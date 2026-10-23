Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792739421;
	b=FeXfWtIMXlGEGcWGXzP4T4r3yVSBmbuajl1IZ3EXGCF2hMIfzn8woeVtqcAx8SfNxTZx
	 drYMW6s5VUL7a+WmWgQ8552yDNtbKOfsY0obX6RGHuii0h17kFyYcuuflO4lbsqJIx5EB
	 JJBBMA8zaqU7Mud/1cHoWCIN97fGGRGsR+mRHp0C+E+m0q2IKVMKgavHBHsj6XYTGi5yI
	 z/ei/6HDLMY4S0De5iXqBxfoYgP2aOU5xQQC6Bd41qe/UMGsES6doX9+k4L0NKu5KXjLN
	 LPTRonWGZI9Krb5qG5aZ5gQkzHFdCRsDZadXrUpD8VzIL9M49RH3C7qU07xrzOXaFng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792739421;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=LA5ZZjgpbx0RTDW9ai9W/GLRxgypkMy9ntsqOBi5pkI=;
	b=SF7MouI0beOnr/BVEP/Nu/PKUCGWxc7lfWXHgGxsb8xUFKPp3rpDBi4qxV9vZ9qZN8PO
	 +yKcl3gvOUYQzd+y2j8ElJ6dw0HOaB/1XAOUH8yI9Jv9NRk9XgiOpryU2QV7wrWh7eRcz
	 qjN1JJLk+uoKL5mzwdDjtHdaXRHxEjuAUEHaqOlXlZgpX9nItKRxjPQ+mkDBqA/zXC22m
	 +QRaqp4JaM4XX8AQQzTYx/prAxQt68If+rjQ9Ipy2SoAw0ZHxwAXsmdZVgnI9PlfnGyMo
	 HQX7WUaeC7/F2PJijpkLfNEUipF9Sv2/0Pc216gQq9LYFR/TDhVhVQpiDjKp/93uFQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Yg04iduI;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4534D606A31B
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 07:10:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4534D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Yg04iduI
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48df54150dfso243577f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 00:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792739420; x=1793344220; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LA5ZZjgpbx0RTDW9ai9W/GLRxgypkMy9ntsqOBi5pkI=;
        b=Yg04iduIgzlBsA43rtsO/42g3L47mJRdphzU2RjnxnebA4Psvpd6FGOA5TerY/DUQ1
         BcY6aKL7JXWs7gcbe9aw8NjSAbO0gkeZu1+WwnvDAB10zd6+XwXywfYU2Ey9ntwX1zRm
         Zb9hpI3BK7s68fM51V7Z2M2PqTHoPN5owSkRgQOpiSWPpq10QmdxOWTNeRTK89tr4dUL
         TduAZV2SMQXm+2aCA6SfiVe4TVTo4lIaOr0hxDmjAtUUp2RszTOjeviKli5Ybjpk7Bgs
         B1wO7N1jm4VMoXAnckoFYH9a4ITd/jQX/xdC6w+slKEe6InrHt0LhVWOIOSarBmfPFwn
         tx0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792739420; x=1793344220;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LA5ZZjgpbx0RTDW9ai9W/GLRxgypkMy9ntsqOBi5pkI=;
        b=Rx4mQGGT/pWHHs7kXCSqsyrlLzU5ZuOVzKST58EWkNj5qutWpq4MsJSq3eP3TS7pb3
         apQeTd+baglM8nUv0cELsMPfZr9UayH/QWH0pb8xYue3aQYqvIdRUpeSLfVyhG6inga3
         shI9kPDbGA97ZaOrJHMZIXZww4o3ooPw/5Y9+G8qTQH1cdOdh78PJsE4dg1RA8v22E1g
         hUxkUXTJ6hbSkFD/1tMTS30SmaDeBrqjPOTEMMhG0AraaPGbYYPv6p8PgE2Vlw2Kam5/
         Ff7jDm/wx4xD117YDxAmQKEDvx+gGW9E6Q4zPwBF+ZJzcCYYikXfCYkUz5JNvIoRYRF1
         rT/A==
X-Forwarded-Encrypted: i=1; AKwUvBwybNnqQYzZbLe+geuI6IGdzNYy4LzVJ4abNhU1VORhRPL6OhRGSGUkg/Aoh3RH5Voe7hrA3aM6RE3G@vger.kernel.org
X-Gm-Message-State: AFq9FYJnTHP2whkEsvSIl+vAuiTSXLGbRgrW+5+SdsMEg5+5A7kvIodu
	pIcOX0xrNmCPOdx+yEGd7ibDi945vTTC3zX38UYIPp5cvrImx/d/9ht+FCsCHuCDgWq/FmT7NBN
	BTcUB
X-Gm-Gg: AYBFou0Kur8braBXE2TRS5QCsXZvUT7Lnds5OHwVPQijIOQj7Fehhir9Gcjj7qxcbeU
	Xeihkd/M+pxXb17F45vm5lAykeLrlDFBNKBCIdf0LwElJKsDzIwR0bgLhJ4xPVfUV6wJ1FBWO68
	T/3LlKWeiFwcOKtqf92lYqsDcqUCAcv74VSnq/WYLT/kEjb4D93Bo9RRlgDcHEON4SZfZcABkH8
	MubokTXUv55NFbvoE/tnxkVLT/ezj8LWZPrifU6XnGfCyNo8TtZFIb+2C4nnGl3bxru1ehWWKp9
	0rrEns/sXEx36ovgpb7euWfGoWueKjCRF6mgH06+ITG7gRzQgMnr6HM4czlhjv2YR8PCoz3EqQU
	kKqPrJEs4qfR3K3T46svkDo+cEbKvHNKPbmW+2Rii/QmYavrg6SJp1dnFmMbCpwG4z9TZMqiM/N
	3Nma3IH1YoizAgDc6A9Yz6EZVJ5FQ3t/EsowiEIPcxdspNkPWIuOq2jfP8C4M8Gvk47jQNn7mFA
	KPzvAnXfMmlSpmc6mu9wfwbSvbnkONSSGGF1q7VXROGtbZSu/MBATjWfAsknzTsGvGwPLlG4IiM
	22RNbosUuKFwDLy3
X-Received: by 2002:a5d:5f8f:0:b0:487:40d:af29 with SMTP id ffacd0b85a97d-48e385b144emr2092520f8f.36.1792739419441;
        Fri, 23 Oct 2026 00:10:19 -0700 (PDT)
Received: from ?IPV6:2001:a61:2bd5:7101:bc42:dc32:395c:d37f? ([2001:a61:2bd5:7101:bc42:dc32:395c:d37f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e38025d82sm3308711f8f.16.2026.10.23.00.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 00:10:18 -0700 (PDT)
Message-ID: <d6651632-120c-4858-9c92-bc5a1ac7d33c@suse.com>
Date: Fri, 23 Oct 2026 09:10:17 +0200
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: aic79xx: Fix NULL pointer dereference in device
 reset
To: Andrew Luebke <andrew.luebke@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261020221530.2606178-1-andrew.luebke@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20261020221530.2606178-1-andrew.luebke@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/21/26 12:15 AM, Andrew Luebke wrote:
> Commit c67e63800446 ("scsi: aic79xx: Do not reference SCSI command when
> resetting device") makes ahd_linux_dev_reset() build its TARGET RESET
> SCB with io_ctx set to NULL, but the function still calls
> ahd_set_residual(reset_scb, 0) a few lines later, which is
> scsi_set_resid() on the NULL command. Every call of the device reset
> handler therefore oopses and kills the SCSI error handler thread; all
> further I/O on that host hangs until the machine is power cycled.
> 
> Hit on an Intel SE7501WV2S board (on-board AIC-7902, i686, v7.2.9) when
> a failing Ultra320 disk made the error handler escalate to a device
> reset. Both disks on that channel then stayed in D state:
> 
>    sd 1:0:0:0: [sda] tag#287 Attempting to queue a TARGET RESET message:
>    BUG: kernel NULL pointer dereference, address: 0000009c
>    #PF: supervisor write access in kernel mode
>    EIP: ahd_linux_dev_reset.cold+0xee/0x26e
>    Call Trace:
>     scsi_eh_ready_devs+0x538/0x8d0
>     scsi_error_handler+0x3a2/0x3b0
>     kthread+0xd2/0x120
>    note: scsi_eh_1[78] exited with irqs disabled
> 
> (0x9c is resid_len in struct scsi_cmnd on i386.)
> 
> Removing that call alone is not enough. When the target accepts the
> reset, ahd_handle_nonpkt_busfree() (or, in packetized mode, the task
> management completion) calls ahd_handle_devreset(), and its
> ahd_abort_scbs() walks the target's pending SCBs - the reset SCB
> included - reading and setting their transaction status and freezing
> them through the wrappers in aic79xx_osm.h, which dereference io_ctx.
> The same walk runs if the reset times out and the error handler
> escalates to a bus reset.
> 
> Commit c7f4c5dec651 ("scsi: aic79xx: Fix up NULL command in ahd_done()")
> taught ahd_done() about the NULL command, but not these wrappers.
> 
> Drop the residual write, and let every wrapper that dereferences io_ctx
> accept an SCB without a command: the transaction status reads as
> CAM_REQ_INPROG, the SCSI status as SAM_STAT_GOOD, the transfer
> direction as DMA_NONE and the residual as 0, while setting a status or
> the residual and freezing the SCB do nothing. The reset SCB then
> completes through ahd_done() as that commit intended. The SCSI status,
> residual and transfer direction wrappers get the same check so that no
> wrapper can be handed the reset SCB and crash; the only path from the
> reset SCB to them that is apparent is ahd_handle_scsi_status(), should
> a packetized LUN RESET end in a status error.
> 
> Tested on the SE7501WV2S with the same change applied to v7.2.11
> (i686): a device reset sent with SG_SCSI_RESET_DEVICE to a healthy
> Seagate ST373453LW logs "Bus Device Reset Message Sent" and "Device
> reset returning 0x2002" (SUCCESS), scsi_eh_1 survives and the disk
> keeps working. That run goes through ahd_handle_devreset() and
> ahd_abort_scbs(), so it exercises the transaction status and freeze
> wrappers on the reset SCB. Not tested: the packetized (IU) LUN RESET
> path and the bus reset escalation. The oops was not reproduced on
> purpose on an unpatched kernel; the crash above came from the failing
> disk.
> 
> Fixes: c67e63800446 ("scsi: aic79xx: Do not reference SCSI command when resetting device")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Andrew Luebke <andrew.luebke@gmail.com>
> ---
> 
> Notes:
>      This analysis, the patch and this changelog were prepared with an LLM coding
>      assistant (Claude Opus 5.5, Anthropic) at my direction; I reviewed them and
>      ran the hardware test described above. Build-tested with W=1 for x86_64 and
>      i386 on mkp/scsi.git for-next (db8b4d2bf2d3): no new warnings. sparse and
>      smatch were not run.
> 
>   drivers/scsi/aic7xxx/aic79xx_osm.c |  1 -
>   drivers/scsi/aic7xxx/aic79xx_osm.h | 19 ++++++++++++++++---
>   2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index feb1707fe..4c603ad63 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -819,7 +819,6 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
>   	reset_scb->io_ctx = NULL;
>   	reset_scb->platform_data->dev = dev;
>   	reset_scb->sg_count = 0;
> -	ahd_set_residual(reset_scb, 0);

You actually make this call safe for a NULL argument right at the end of 
this patch, so please omit this line to get the residual count reset for
the non-NULL case.

>   	ahd_set_sense_residual(reset_scb, 0);
>   	reset_scb->platform_data->xfer_len = 0;
>   	reset_scb->hscb->control = 0;
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
> index c6eb2b97e..b47aa6c98 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.h
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
> @@ -508,7 +508,8 @@ void ahd_cmd_set_transaction_status(struct scsi_cmnd *cmd, uint32_t status)
>   static inline
>   void ahd_set_transaction_status(struct scb *scb, uint32_t status)
>   {
> -	ahd_cmd_set_transaction_status(scb->io_ctx,status);
> +	if (scb->io_ctx)
> +		ahd_cmd_set_transaction_status(scb->io_ctx, status);

Can't you move this check into ahd_cmd_set_transaction_status()?

>   }
>   
>   static inline
> @@ -521,7 +522,8 @@ void ahd_cmd_set_scsi_status(struct scsi_cmnd *cmd, uint32_t status)
>   static inline
>   void ahd_set_scsi_status(struct scb *scb, uint32_t status)
>   {
> -	ahd_cmd_set_scsi_status(scb->io_ctx, status);
> +	if (scb->io_ctx)
> +		ahd_cmd_set_scsi_status(scb->io_ctx, status);

Same here.

>   }
>   
>   static inline
> @@ -533,6 +535,8 @@ uint32_t ahd_cmd_get_transaction_status(struct scsi_cmnd *cmd)
>   static inline
>   uint32_t ahd_get_transaction_status(struct scb *scb)
>   {
> +	if (!scb->io_ctx)
> +		return CAM_REQ_INPROG;
>   	return (ahd_cmd_get_transaction_status(scb->io_ctx));
>   }
>   
> @@ -545,6 +549,8 @@ uint32_t ahd_cmd_get_scsi_status(struct scsi_cmnd *cmd)
>   static inline
>   uint32_t ahd_get_scsi_status(struct scb *scb)
>   {
> +	if (!scb->io_ctx)
> +		return SAM_STAT_GOOD;
>   	return (ahd_cmd_get_scsi_status(scb->io_ctx));
>   }
>   
> @@ -566,13 +572,16 @@ u_long ahd_get_transfer_length(struct scb *scb)
>   static inline
>   int ahd_get_transfer_dir(struct scb *scb)
>   {
> +	if (!scb->io_ctx)
> +		return DMA_NONE;
>   	return (scb->io_ctx->sc_data_direction);
>   }
>   
>   static inline
>   void ahd_set_residual(struct scb *scb, u_long resid)
>   {
> -	scsi_set_resid(scb->io_ctx, resid);
> +	if (scb->io_ctx)
> +		scsi_set_resid(scb->io_ctx, resid);

And here.

>   }
>   
>   static inline
> @@ -584,6 +593,8 @@ void ahd_set_sense_residual(struct scb *scb, u_long resid)
>   static inline
>   u_long ahd_get_residual(struct scb *scb)
>   {
> +	if (!scb->io_ctx)
> +		return 0;
>   	return scsi_get_resid(scb->io_ctx);
>   }
>   
> @@ -631,6 +642,8 @@ void	ahd_platform_freeze_devq(struct ahd_softc *ahd, struct scb *scb);
>   static inline void
>   ahd_freeze_scb(struct scb *scb)
>   {
> +	if (!scb->io_ctx)
> +		return;
>   	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
>   		scb->io_ctx->result |= CAM_DEV_QFRZN << 16;
>   		scb->platform_data->dev->qfrozen++;
> 
> base-commit: db8b4d2bf2d3e02b4ff78bbf69d00e11795840de

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
