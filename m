From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH v2 21/39] megaraid_sas: big endian support changes
Date: Thu, 9 Feb 2017 23:34:11 +0530
Message-ID: <bf1452a18cc228e85919071223af48fd@mail.gmail.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486546173-20713-22-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:36803 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752929AbdBISEy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2017 13:04:54 -0500
Received: by mail-qk0-f169.google.com with SMTP id 11so12898632qkl.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2017 10:04:13 -0800 (PST)
In-Reply-To: <1486546173-20713-22-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com

> +static inline void set_num_sge(struct RAID_CONTEXT_G35 rctx_g35,
> +			       u16 sge_count)
> +{
> +	rctx_g35.u.bytes[0] = (u8)(sge_count & NUM_SGE_MASK_LOWER);
> +	rctx_g35.u.bytes[1] |= (u8)((sge_count >> NUM_SGE_SHIFT_UPPER)
> +							&
> NUM_SGE_MASK_UPPER);
> +}

This function and below get_num_sge() need fix.  We have supposed to pass
pointer of struct RAID_CONTEXT_G35 to get correct setting reflected in IO
frame, otherwise it just set in stack local memory and that is not a
intent here. We will fix this patch and resend. Only fixing this patch and
resend works fine with complete series (there is no hunk failure observe),
so just going to push one particular patch with below title.

[PATCH v2 21/39 RESEND] megaraid_sas: big endian support changes

> +
> +static inline u16 get_num_sge(struct RAID_CONTEXT_G35 rctx_g35) {
> +	u16 sge_count;
> +
> +	sge_count = (u16)(((rctx_g35.u.bytes[1] & NUM_SGE_MASK_UPPER)
> +			<< NUM_SGE_SHIFT_UPPER) | (rctx_g35.u.bytes[0]));
> +	return sge_count;
> +}
> +
> +#define SET_STREAM_DETECTED(rctx_g35) \
> +	(rctx_g35.u.bytes[1] |= STREAM_DETECT_MASK)
> +
> +#define CLEAR_STREAM_DETECTED(rctx_g35) \
> +	(rctx_g35.u.bytes[1] &= ~(STREAM_DETECT_MASK))
> +
> +static inline bool is_stream_detected(struct RAID_CONTEXT_G35
> +*rctx_g35) {
> +	return ((rctx_g35->u.bytes[1] & STREAM_DETECT_MASK)); }
> +
>  union RAID_CONTEXT_UNION {
>  	struct RAID_CONTEXT raid_context;
>  	struct RAID_CONTEXT_G35 raid_context_g35;
> --
> 2.8.3
