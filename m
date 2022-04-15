Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7727C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 16:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355846AbiDOQev (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 12:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239143AbiDOQeu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 12:34:50 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AE8C55BA
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 09:32:22 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q12so7630052pgj.13
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 09:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=g6JnB+JOMokWNS8hHqOWN/4y2CEijsmficdG9hkVaxg=;
        b=b3cbfa0WLvbR2zH1GNXELzAYca2YgBlAkWq3CPUWlVCtbMLRGo9Rz1kTjmpzEeNXDg
         hKmBJ0t6a79W0ob2tom3lP9fhEXQQrgYnI0Ygejy1uYzgY0qaJJQSzBbZBPpqEmIpoHl
         zJpzmzseI0+tirCHPU9MSRC/IesXOey3lnbr8GyK5nGwIEiIbzCDrEzEA6YCDBXvEmn8
         MinvTCKjJdj4wbHjH9ZvW+TLMth6Neiga3e5c5SWIshMLyNySYRdMFIUcYPO3PFGDDMl
         UKcJEn3CAJE7IdoYgCHmtPva5Nd9fEsDzyINbK4weDvN9KxU88V6qXgxDJ8DkeqIzFz9
         O7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g6JnB+JOMokWNS8hHqOWN/4y2CEijsmficdG9hkVaxg=;
        b=aW/t0Sy8Z3cwDybTG45iMgaD67/lLAcyqchK02cQdCQEAA+yqijuwe6Xt0SP84bGpL
         8EXIVrup4+YF1qUfsFKlQGZokpzwRf/EetIz7WZhAL5EhshyCmHO0DbQrpzHYHMk04HM
         08ALX0JsHqG/HiQV3ReivuiCZaIm4cIx+njAz5XUBS+E8G89ePMfmvQcoLi3N3DR8Rrf
         Qyg0m8LgU5sAhkPg5OExRl563wcrga0eoaXas0prKLZRtS3WA0OyvK0Ap5BvRNGzJAad
         yWRnZkgYUEXWc47FyPGJTUWrCHzy3DBzE9OObvsQlWYr6drRuNUI4XX1JBM6Tb8wIfTP
         DGDQ==
X-Gm-Message-State: AOAM532rFyiMH6vOOP7CbWc1iqBC8Lv6NcNByfUvh+6s6M3cFi6gY41o
        LMkIQemcRV1c3fimvDnyYJqxK0TEE1A=
X-Google-Smtp-Source: ABdhPJzXRkN4tajVN24fX7XWoUOqha2NaMX92CsiecDg+kYDFh2WnaKNXorXgP3vRS2dPANxcwHfew==
X-Received: by 2002:a63:d906:0:b0:39c:c4ca:32b1 with SMTP id r6-20020a63d906000000b0039cc4ca32b1mr7057117pgg.408.1650040341573;
        Fri, 15 Apr 2022 09:32:21 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l2-20020a637c42000000b003644cfa0dd1sm4749069pgn.79.2022.04.15.09.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 09:32:21 -0700 (PDT)
Message-ID: <9bd6ce27-d984-efc4-c907-babca6897300@gmail.com>
Date:   Fri, 15 Apr 2022 09:32:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC] scsi_transport_fc: Add an additional flag to
 fc_host_fpin_rcv()
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        James Smart <jsmart2021@gmail.com>
References: <20220414064358.21384-1-njavali@marvell.com>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20220414064358.21384-1-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/13/2022 11:43 PM, Nilesh Javali wrote:
> From: Anil Gurumurthy <agurumurthy@marvell.com>
> 
> The LLDD and the stack currently process FPINs received from the fabric,
> but the stack is not aware of any action taken by the driver to alleviate
> congestion. The current interface between the driver and the SCSI stack is
> limited to passing the notification mainly for statistics and heuristics.
> 
> The reaction to an FPIN could be handled either by the driver or by the
> stack (marginal path and failover). This patch enhances the interface to
> indicate if action on an FPIN has already been taken by the LLDDs or not.
> Add an additional flag to fc_host_fpin_rcv() to indicate if the FPIN has
> been processed by the driver.
> 
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/lpfc/lpfc_els.c     | 2 +-
>   drivers/scsi/qla2xxx/qla_isr.c   | 2 +-
>   drivers/scsi/scsi_transport_fc.c | 6 +++++-
>   include/scsi/scsi_transport_fc.h | 2 +-
>   4 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index ef6e8cd8c26a..fd931b1781e3 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -10102,7 +10102,7 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
>   		/* Send every descriptor individually to the upper layer */
>   		if (deliver)
>   			fc_host_fpin_rcv(lpfc_shost_from_vport(vport),
> -					 fpin_length, (char *)fpin);
> +					 fpin_length, (char *)fpin, false);
>   		desc_cnt++;
>   	}
>   }



This is fine.  Thank you.


> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 21b31d6359c8..e01d9a671749 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -45,7 +45,7 @@ qla27xx_process_purex_fpin(struct scsi_qla_host *vha, struct purex_item *item)
>   	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x508f,
>   		       pkt, pkt_size);
>   
> -	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt);
> +	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt, false);
>   }
>   
>   const char *const port_state_str[] = {
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index a2524106206d..6de476f13512 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -892,12 +892,13 @@ fc_fpin_congn_stats_update(struct Scsi_Host *shost,
>    * @shost:		host the FPIN was received on
>    * @fpin_len:		length of FPIN payload, in bytes
>    * @fpin_buf:		pointer to FPIN payload
> + * @hba_process:	true if LLDD has acted on the FPIN
>    *
>    * Notes:
>    *	This routine assumes no locks are held on entry.
>    */
>   void
> -fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
> +fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf, bool hba_process)
>   {
>   	struct fc_els_fpin *fpin = (struct fc_els_fpin *)fpin_buf;
>   	struct fc_tlv_desc *tlv;
> @@ -925,6 +926,9 @@ fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
>   		case ELS_DTAG_CONGESTION:
>   			fc_fpin_congn_stats_update(shost, tlv);
>   		}
> +		/* If the event has not been processed, mark path as marginal */
> +		if (!hba_process)
> +			fc_host_port_state(shost) = FC_PORTSTATE_MARGINAL;

This doesn't seem right.  I would think the meaning of "processing" 
varies by FPIN type, thus the flag should be passed to the different 
xxx_update routines and any decision would be made there - or at least 
the decision is made within the type case statement above. For example: 
FC_PORT_STATE_MARGINAL should only be set with Link Integrity events.

However, we currently leave the decision of marginality to be determined 
and managed by the external daemon that processes the fpin events. So 
the patch needs to expand the fpin event to include the driver processed 
flag in the event data. Please add this to fc_host_post_fc_event().

Given we leave marginality to the daemon, who will now know whether the 
driver handled the fpin or not, I don't think fpin_rcv should include 
the changing of portstate to marginal.

-- james


