Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFFAC32789
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 266132220F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgGNHFp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:05:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:41638 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgGNHFn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 03:05:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A7422AD1E;
        Tue, 14 Jul 2020 07:05:43 +0000 (UTC)
Subject: Re: [PATCH v2 12/29] scsi: libfc: fc_fcp: Provide missing and repair
 existing function documentation
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-13-lee.jones@linaro.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4fa77049-9134-d0b5-5408-66330fdcbd03@suse.de>
Date:   Tue, 14 Jul 2020 09:05:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713074645.126138-13-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 9:46 AM, Lee Jones wrote:
> Mostly due to descriptions not keeping up with API changes.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/scsi/libfc/fc_fcp.c:299: warning: Function parameter or member 'status_code' not described in 'fc_fcp_retry_cmd'
>   drivers/scsi/libfc/fc_fcp.c:595: warning: Function parameter or member 'seq' not described in 'fc_fcp_send_data'
>   drivers/scsi/libfc/fc_fcp.c:595: warning: Excess function parameter 'sp' description in 'fc_fcp_send_data'
>   drivers/scsi/libfc/fc_fcp.c:1289: warning: Function parameter or member 't' not described in 'fc_lun_reset_send'
>   drivers/scsi/libfc/fc_fcp.c:1289: warning: Excess function parameter 'data' description in 'fc_lun_reset_send'
>   drivers/scsi/libfc/fc_fcp.c:1422: warning: Function parameter or member 't' not described in 'fc_fcp_timeout'
>   drivers/scsi/libfc/fc_fcp.c:1422: warning: Excess function parameter 'data' description in 'fc_fcp_timeout'
>   drivers/scsi/libfc/fc_fcp.c:1696: warning: Function parameter or member 'code' not described in 'fc_fcp_recovery'
>   drivers/scsi/libfc/fc_fcp.c:1716: warning: Function parameter or member 'offset' not described in 'fc_fcp_srr'
>   drivers/scsi/libfc/fc_fcp.c:1859: warning: Function parameter or member 'sc_cmd' not described in 'fc_queuecommand'
>   drivers/scsi/libfc/fc_fcp.c:1859: warning: Excess function parameter 'cmd' description in 'fc_queuecommand'
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/scsi/libfc/fc_fcp.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> index bf2cc9656e191..e11d4f002bd49 100644
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c
> @@ -289,6 +289,7 @@ static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
>   /**
>    * fc_fcp_retry_cmd() - Retry a fcp_pkt
>    * @fsp: The FCP packet to be retried
> + * @status_code: The FCP status code to set
>    *
>    * Sets the status code to be FC_ERROR and then calls
>    * fc_fcp_complete_locked() which in turn calls fc_io_compl().
> @@ -580,7 +581,7 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
>   /**
>    * fc_fcp_send_data() - Send SCSI data to a target
>    * @fsp:      The FCP packet the data is on
> - * @sp:	      The sequence the data is to be sent on
> + * @seq:      The sequence the data is to be sent on
>    * @offset:   The starting offset for this data request
>    * @seq_blen: The burst length for this data request
>    *
> @@ -1283,7 +1284,7 @@ static int fc_fcp_pkt_abort(struct fc_fcp_pkt *fsp)
>   
>   /**
>    * fc_lun_reset_send() - Send LUN reset command
> - * @data: The FCP packet that identifies the LUN to be reset
> + * @t: Timer context used to fetch the FSP packet
>    */
>   static void fc_lun_reset_send(struct timer_list *t)
>   {
> @@ -1409,7 +1410,7 @@ static void fc_fcp_cleanup(struct fc_lport *lport)
>   
>   /**
>    * fc_fcp_timeout() - Handler for fcp_pkt timeouts
> - * @data: The FCP packet that has timed out
> + * @t: Timer context used to fetch the FSP packet
>    *
>    * If REC is supported then just issue it and return. The REC exchange will
>    * complete or time out and recovery can continue at that point. Otherwise,
> @@ -1691,6 +1692,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
>   /**
>    * fc_fcp_recovery() - Handler for fcp_pkt recovery
>    * @fsp: The FCP pkt that needs to be aborted
> + * @code: The FCP status code to set
>    */
>   static void fc_fcp_recovery(struct fc_fcp_pkt *fsp, u8 code)
>   {
> @@ -1709,6 +1711,7 @@ static void fc_fcp_recovery(struct fc_fcp_pkt *fsp, u8 code)
>    * fc_fcp_srr() - Send a SRR request (Sequence Retransmission Request)
>    * @fsp:   The FCP packet the SRR is to be sent on
>    * @r_ctl: The R_CTL field for the SRR request
> + * @offset: The SRR relative offset
>    * This is called after receiving status but insufficient data, or
>    * when expecting status but the request has timed out.
>    */
> @@ -1851,7 +1854,7 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
>   /**
>    * fc_queuecommand() - The queuecommand function of the SCSI template
>    * @shost: The Scsi_Host that the command was issued to
> - * @cmd:   The scsi_cmnd to be executed
> + * @sc_cmd:   The scsi_cmnd to be executed
>    *
>    * This is the i/o strategy routine, called by the SCSI layer.
>    */
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
