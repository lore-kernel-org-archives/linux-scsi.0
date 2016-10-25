From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Tue, 25 Oct 2016 15:00:55 +0200
Message-ID: <20161025130055.GA12090@bblock-ThinkPad-W530>
References: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56607 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758563AbcJYNCm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Oct 2016 09:02:42 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9PCxMC4114968
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 09:02:42 -0400
Received: from e06smtp06.uk.ibm.com (e06smtp06.uk.ibm.com [195.75.94.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26a5p7yy9x-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 09:02:42 -0400
Received: from localhost
        by e06smtp06.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Tue, 25 Oct 2016 14:01:09 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id E9F68219005F
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 14:00:22 +0100 (BST)
Received: from d06av10.portsmouth.uk.ibm.com (d06av10.portsmouth.uk.ibm.com [9.149.37.251])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u9PD16No29556874
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 13:01:06 GMT
Received: from d06av10.portsmouth.uk.ibm.com (localhost [127.0.0.1])
        by d06av10.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u9PC17o7023934
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 06:01:07 -0600
Received: from bblock-ThinkPad-W530 (dyn-9-152-212-116.boeblingen.de.ibm.com [9.152.212.116])
        by d06av10.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id u9PC17dl023905
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 06:01:07 -0600
Content-Disposition: inline
In-Reply-To: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, gabriel@krisman.be, brking@linux.vnet.ibm.com

On 01:20 Mon 24 Oct     , Gabriel Krisman Bertazi wrote:
> James,
> 
> I fixed the things you pointed out on the previous review.  As
> discussed, I didn't change the code to reuse the request yet.  We can
> follow up on that later.
> 
> Thanks,
> 
> >8
> 
> Usually, re-sending the SCSI command is enough to recover from a Unit
> Attention (UA).  This adds a generic retry code to the SCSI command path
> in case of an UA, before giving up and returning the error condition to
> the caller.
> 
> I added the UA verification into scsi_execute instead of
> scsi_execute_req because there are at least a few callers that invoke
> scsi_execute directly and would benefit from the internal UA retry.
> Also, I didn't use scsi_normalize_sense to not duplicate functionality
> with scsi_execute_req_flags.  Instead, scsi_execute uses a small helper
> function that verifies only the UA condition directly from the raw sense
> buffer.  If this design is not OK, I can refactor to use
> scsi_normalize_sense.
> 
> This prevents us from duplicating the retry code in at least a few
> places.  In particular, it fixes an issue found in some IBM enclosures,
> in which the device may return an Unit Attention during probe, breaking
> the bind with the ses module:
> 
> scsi 1:0:7:0: Failed to get diagnostic page 0x8000002
> scsi 1:0:7:0: Failed to bind enclosure -19
> 
> Link: https://patchwork.kernel.org/patch/9336763/
> Suggested-by: Brian King <brking@linux.vnet.ibm.com>
> Suggested-by: James Bottomley <jejb@linux.vnet.ibm.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
> ---
>  drivers/scsi/scsi_lib.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index c71344aebdbb..4f6a91d6ee34 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -163,6 +163,16 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
>  {
>  	__scsi_queue_insert(cmd, reason, 1);
>  }
> +
> +static inline bool scsi_sense_unit_attention(const char *sense)
> +{
> +	int resp = sense[0] & 0x7f;
> +
> +	return ((resp & 0x70) &&
> +		((resp >= 0x72 && (sense[1] & 0xf) == UNIT_ATTENTION) ||
> +		 (resp < 0x72 && (sense[2] & 0xf) == UNIT_ATTENTION)));
> +}
> +

Just some minor nit-pick. In other places where we check for valid sense
(SCSI_SENSE_VALID(), scsi_sense_valid())
we always check for whether the upper nibble really only contains 0x70
((resp & 0x70) == 0x70). 

I also find it strange that we now have 3 different and independent
functions/places that check for valid sense.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block

>  /**
>   * scsi_execute - insert request and wait for the result
>   * @sdev:	scsi device
> @@ -187,7 +197,14 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>  	struct request *req;
>  	int write = (data_direction == DMA_TO_DEVICE);
>  	int ret = DRIVER_ERROR << 24;
> +	unsigned char sense_buf[SCSI_SENSE_BUFFERSIZE];
> 
> +	if (!sense) {
> +		sense = sense_buf;
> +		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
> +	}
> +
> + retry:
>  	req = blk_get_request(sdev->request_queue, write, __GFP_RECLAIM);
>  	if (IS_ERR(req))
>  		return ret;
> @@ -210,6 +227,13 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>  	 */
>  	blk_execute_rq(req->q, NULL, req, 1);
> 
> +	if (scsi_sense_unit_attention(sense) && req->retries > 0) {
> +		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
> +		retries = req->retries - 1;
> +		blk_put_request(req);
> +		goto retry;
> +	}
> +
>  	/*
>  	 * Some devices (USB mass-storage in particular) may transfer
>  	 * garbage data together with a residue indicating that the data
> -- 
> 2.7.4

-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294

