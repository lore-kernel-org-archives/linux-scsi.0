Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433AEC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 14:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0C9961185
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 14:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbhDZO7U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 10:59:20 -0400
Received: from verein.lst.de ([213.95.11.211]:41651 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233825AbhDZO6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 10:58:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3E1AC68C4E; Mon, 26 Apr 2021 16:57:59 +0200 (CEST)
Date:   Mon, 26 Apr 2021 16:57:58 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 04/39] scsi: Fixup calling convention for
 scsi_mode_sense()
Message-ID: <20210426145758.GE22120@lst.de>
References: <20210423113944.42672-1-hare@suse.de> <20210423113944.42672-5-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423113944.42672-5-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 23, 2021 at 01:39:09PM +0200, Hannes Reinecke wrote:
> The description for scsi_mode_sense() claims to return the number
> of valid bytes on success, which is not what the code does.
> Additionally there is no gain in returning the scsi status, as
> everything the callers do is to check against scsi_result_is_good(),
> which is what scsi_mode_sense() does already.
> So change the calling convention to return a standard error code
> on failure, and 0 on success, and adapt the description and all
> callers.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_lib.c           | 10 ++++++----
>  drivers/scsi/scsi_transport_sas.c |  9 ++++-----
>  drivers/scsi/sd.c                 | 12 ++++++------
>  drivers/scsi/sr.c                 |  2 +-
>  4 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d7c0d5a5f263..c532f9390ae3 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2135,9 +2135,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
>   *	@sshdr: place to put sense data (or NULL if no sense to be collected).
>   *		must be SCSI_SENSE_BUFFERSIZE big.
>   *
> - *	Returns zero if unsuccessful, or the header offset (either 4
> - *	or 8 depending on whether a six or ten byte command was
> - *	issued) if successful.
> + *	Returns zero if successful, or a negative error number on failure
>   */
>  int
>  scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
> @@ -2190,6 +2188,8 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
>  	 * byte as the problem.  MODE_SENSE commands can return
>  	 * ILLEGAL REQUEST if the code page isn't supported */
>  
> +	if (result < 0)
> +		return result;

The return would be much easier to read if it was just below the call to
scsi_execute_req that assigns result than under the comment
describing the code below.

>  	if (use_10_for_ms && !scsi_status_is_good(result) &&
>  	    driver_byte(result) == DRIVER_SENSE) {
>  		if (scsi_sense_valid(sshdr)) {
> @@ -2228,13 +2228,15 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
>  			data->block_descriptor_length = buffer[3];
>  		}
>  		data->header_length = header_length;
> +		result = 0;
>  	} else if ((status_byte(result) == CHECK_CONDITION) &&
>  		   scsi_sense_valid(sshdr) &&
>  		   sshdr->sense_key == UNIT_ATTENTION && retry_count) {
>  		retry_count--;
>  		goto retry;
>  	}
> -
> +	if (result > 0)
> +		result = -EIO;

IMHO it would be nice to restructure the end of the function to do
something like:

	if (!scsi_status_is_good(result)) {
		if (status_byte(result) == CHECK_CONDITION &&
		    scsi_sense_valid(sshdr) &&
		    sshdr->sense_key == UNIT_ATTENTION &&
		    retry_count) {
			retry_count--;
			goto retry;
		}
		return -EIO;
	}

	// various data fixups here

	return 0;
