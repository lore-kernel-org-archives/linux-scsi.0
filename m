Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB7EC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 08:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiKOIZP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 03:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKOIZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 03:25:14 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CC81C2
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 00:25:13 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5BB3667373; Tue, 15 Nov 2022 09:25:10 +0100 (CET)
Date:   Tue, 15 Nov 2022 09:25:10 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v6 03/35] scsi: Add struct for args to execution
 functions
Message-ID: <20221115082510.GC17445@lst.de>
References: <20221104231927.9613-1-michael.christie@oracle.com> <20221104231927.9613-4-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104231927.9613-4-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 04, 2022 at 06:18:55PM -0500, Mike Christie wrote:
> This begins to move the SCSI execution functions to use a struct for
> passing in args. This patch adds the new struct, converts the low level
> helpers and then adds a new helper the next patches will convert the rest
> of the code to.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c    | 69 +++++++++++++++-----------------------
>  include/scsi/scsi_device.h | 69 ++++++++++++++++++++++++++++++--------
>  2 files changed, 82 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index fc1560981a03..f832befb50b0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -185,55 +185,39 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
>  	__scsi_queue_insert(cmd, reason, true);
>  }
>  
> -
>  /**
> - * __scsi_execute - insert request and wait for the result
> - * @sdev:	scsi device
> - * @cmd:	scsi command
> - * @data_direction: data direction
> - * @buffer:	data buffer
> - * @bufflen:	len of buffer
> - * @sense:	optional sense buffer
> - * @sshdr:	optional decoded sense header
> - * @timeout:	request timeout in HZ
> - * @retries:	number of times to retry request
> - * @flags:	flags for ->cmd_flags
> - * @rq_flags:	flags for ->rq_flags
> - * @resid:	optional residual length
> + * __scsi_exec_req - insert request and wait for the result
> + * @scsi_exec_args: See struct definition for description of each field
>   *
>   * Returns the scsi_cmnd result field if a command was executed, or a negative
>   * Linux error code if we didn't get that far.
>   */
> -int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
> -		 int data_direction, void *buffer, unsigned bufflen,
> -		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
> -		 int timeout, int retries, blk_opf_t flags,
> -		 req_flags_t rq_flags, int *resid)
> +int __scsi_exec_req(const struct scsi_exec_args *args)

I find the struct for everyhing a somewhat confusing calling convention.
So I'd pass the required arguments directly, and stuff all the optional
bits into the struct.  Based on the previous discussion maybe
something like:

int __scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
		blk_opf_t opf, void *buffer, unsigned int bufflen,
		int timeout, int retries,
		const struct scsi_exec_args *args)

which would be a nice replacement for all the existing scsi_execute*
interfaces.

