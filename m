Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792997469;
	b=Rr1d5EoD9ZA+em/I6trIKMqh4RHLoWEIxgBduRUl04tIJhamGxuWEqleHHlbyQ/bdW6m
	 Zy1lzUCLNFJ6n6Mi40cmgqY55n1q7vzfYeMwZdQH5Ez9s8Nhofyx7P6y1/C5lOos05q+w
	 wR6b07NdN8Ai2LzfQ7Xd9KeeZfErimOIukG1PKtK5ry60s56RUgjvaOX87+GmGraJhHWX
	 M2R5UK9DeiZ5WCAoZk7rKRsweG+dNhjsg7acILZfT+0irY4nyTGNeq5g+wbb+d6RjJN91
	 92BenYQxFhjiOk0Z1+jgUJc6YsFjWW9mqYsM2E78JvfHyMsMUCXD27ltzwUHFauJnyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792997469;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=0j1HbGy7SxsAlSqhArcwYTwwZPIic+C0p0uOLAj5YQ0=;
	b=pdSdk2BitCED7tXtRidHhk0QRGKlMtAZfMp1+Vl1GlU6Kx/Wzg0Qk1EFjcLEEhcgsCCi
	 6kZaK9dMWdVUFfOHkRGDD65jC9DiL9HMZVYuQi4tb3Ovb1BlpSrGzcUS5qgiZmIf6+xmI
	 agIhcWzVfoYb8OaQo1h45cbYaS+xXhHIOuLQM7fSgCUZgbVMWbvlx8WTTszYWeePwvRal
	 01mQd82Vldn/ax+vzT4v5IRfg3tgnj9HsYnBqrzkqg/gER202vXZI494UqomxNaYfAkli
	 WSWE7ELcgyFqC4bENh+gZ+DDVKJm+2hiOHL+8N8TcoYWiMJfAekU4bknGQQlUOnCw9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="APuzZa/l";
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FD4606A331
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 06:51:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98FD4606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=APuzZa/l
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e3b22e971so1070514f8f.0
        for <linux-scsi@vger.kernel.org>; Sun, 25 Oct 2026 23:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792997467; x=1793602267; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0j1HbGy7SxsAlSqhArcwYTwwZPIic+C0p0uOLAj5YQ0=;
        b=APuzZa/l+iomygd2XnB1OLwxTWnBFALEW+WLtwiqq4qGZV2D7ZUvt830TlaSSiUq01
         elOJDygunaN8Ek6VZ1ub2l4QUzb+L9/e4XityPv8VOMW9eZTRaKXU0VSmqo+BEdrCraB
         hWff7GwMEj2QX0uYmCo/UyUSjfgdo+Ke+Ehniwsn4eNe7Uh4FARktmiwemjusGCN5DAA
         cSdBoktwOP7Er37FSibtG21hWNBslEnxqitV/REjFbToHI7nlDmmBbuCqPgurxA/41ge
         RS7Ne8RRlFtouPY0bK9LNCXVIYkRnJoJ1mNe+62N+0ABF4Roz0MfFQu922YnSwD0xEYm
         rVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792997467; x=1793602267;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0j1HbGy7SxsAlSqhArcwYTwwZPIic+C0p0uOLAj5YQ0=;
        b=mFGtJ/EWCpV81BXLtaOsKxMqcVAnvE70AFc9ml4eRSqzabs6RGpvjjy3muE7ynp1en
         92F7Fp87w9lGlSU1UlTQx9T+dFBUm+PzMBVaJ8sCQFQXDv3+VF6vGLW5HIsR3Y74zkaL
         Zuxw5oTHZ+rJ8JWiOXBn3sy3QxZSgSdFEPjpCzn+6IegPWcRUtOUQ3x851H99wS4/WbE
         TY7GkpuRDbo9Af1FFOCQIlgx7mYC2Jl7/+iY5EkJnLLjM0LtxumLPxDPABG1nS52QBf3
         lZzxbeYVeU4rkpMjLEDkIcFsscU3Nc9bKg54mESxZ8YXDOWVcfGYV7OFMFQ4RFF0nFUX
         ItXw==
X-Forwarded-Encrypted: i=1; AKwUvBxtnr4lyFphQ/1yPXfm/iIKgWKQg/gJggvTdLbrgPGsIr+ORUuX2BO9h5FcCG34+N9Tqi59wi0hK06m@vger.kernel.org
X-Gm-Message-State: AFq9FYK1EkrXZDPRGzpv4ayLBlYuOCTXOZDqJypbVwfA9O1J8smPw37C
	7kXvgHKzCxjV48PQny3Sl6T3BT2q6VQhz98eKx+W5SVMd79Ig2l4zGuqm5vJeP4qAFI=
X-Gm-Gg: AYBFou2Y8Myg71MojcAf0oqAnVXYDdRJDjP+/nx3aycAE2HY9gLZI/gQt3J9sY9V01X
	ULNpzZBvV3UD6cBbHtLyYiuHaMgu4yO/rW8pbrriQorQSfzyDSGTtc0IMSNISn0GWPUPetHB8sY
	FrgWh8LnspUAy9ZmPUzan9PMA7qOrkXqKXZP3/I2sdG/7A9YGrUXlihLaLCw2sUglHZrnEUbWA7
	CLNFCIFEhcfpNECFBH4cBASm4FH3EOhTwkwU0goOy8N30Ib5bJnL8fRFZoJbjmptOuTbhk3ES6y
	lKSs3iG5BdhBEo0+4yPwUtLPvaj/y/GxOf4OWdncaquYADx0dCBLatnt8cmv8ZBJ7TIjPPMaHqw
	IQ2BBthUXjdx9ZbfBwuw2qRncp2ySwX6ZYoVTeQuhN2/5ncUsqB3ZQ7sRG2gq34c/5ySLKvlGjV
	0qdPD0+RxdDfJIUeVxyKWmxX+6s4yW9/IpQp0FMNEWiLSSGMm9pBNz9OhrDNuLXy7FNKJbkOALM
	dclIxnsSwN1ZFmHsK66pqmFGXBhFL2/3kyxL+nctuVeJaga+vWGeDW/+LCfkstZO4IcZXZzhp2d
	OU8p+pb/RfSriA6V
X-Received: by 2002:a5d:6f0c:0:b0:48e:1d81:5b86 with SMTP id ffacd0b85a97d-48e3eb9b259mr9504623f8f.52.1792997466877;
        Sun, 25 Oct 2026 23:51:06 -0700 (PDT)
Received: from ?IPV6:2001:a61:2a62:aa01:5ada:99ae:a1fe:1f54? ([2001:a61:2a62:aa01:5ada:99ae:a1fe:1f54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd8dcfsm14523532f8f.50.2026.10.25.23.51.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 23:51:06 -0700 (PDT)
Message-ID: <8b0665bc-7962-4803-9904-26815a6594b8@suse.com>
Date: Mon, 26 Oct 2026 07:51:05 +0100
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
Subject: Re: [PATCH v2] scsi: aic79xx: Fix NULL pointer dereference in device
 reset
To: Andrew Luebke <andrew.luebke@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261023170330.269844-1-andrew.luebke@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20261023170330.269844-1-andrew.luebke@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/23/26 7:03 PM, Andrew Luebke wrote:
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
> Making that call safe is not enough on its own. When the target accepts
> the reset, ahd_handle_nonpkt_busfree() (or, in packetized mode, the task
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
> Let every accessor that dereferences the command accept an SCB without
> one. The ahd_cmd_*() helpers for the transaction status and the SCSI
> status check for a NULL command: the transaction status then reads as
> CAM_REQ_INPROG and the SCSI status as SAM_STAT_GOOD, and setting either
> does nothing. ahd_get_transfer_dir(), ahd_get_residual(),
> ahd_set_residual() and ahd_freeze_scb() have no such helper underneath,
> so they check scb->io_ctx themselves: the transfer direction reads as
> DMA_NONE and the residual as 0, while setting the residual and freezing
> the SCB do nothing. The ahd_set_residual(reset_scb, 0) call in
> ahd_linux_dev_reset() is then harmless, and the reset SCB completes
> through ahd_done() as that commit intended. The SCSI status, residual
> and transfer direction accessors get the check so that none of them can
> be handed the reset SCB and crash; the only path from the reset SCB to
> them that is apparent is ahd_handle_scsi_status(), should a packetized
> LUN RESET end in a status error.
> 
> ahd_perform_autosense() also declines autosense for an SCB without a
> command. Otherwise a target that answered the reset with CHECK
> CONDITION would have the reset SCB requeued for REQUEST SENSE, and with
> negotiation pending ahd_handle_scsi_status() clears SCB_DEVICE_RESET on
> the way, so ahd_done() would later dereference the missing command.
> Declining leaves such a reset SCB to the reset timeout and the error
> handler's escalation, which completes it through ahd_abort_scbs().
> 
> Tested on the SE7501WV2S with this patch applied to v7.2.11 (i686), on
> the disks of its second AIC-7902 channel (160 MB/s DT, not packetized).
> Device resets sent with SG_SCSI_RESET_DEVICE to a Seagate ST373453LW log
> "Bus Device Reset Message Sent" and "Device reset returning 0x2002"
> (SUCCESS), three of them while the disk was being read; the reads
> complete, scsi_eh_1 survives and the disk keeps working. scsi_eh_1 also
> survives a device reset of the channel's other disk - the one behind the
> crash above, which accepts the reset but no longer spins up - and a bus
> reset sent with SG_SCSI_RESET_BUS, after which the first disk still
> works. The device resets go through ahd_handle_devreset() and
> ahd_abort_scbs(), so they exercise the transaction status and freeze
> accessors on the reset SCB. Not tested: the packetized (IU) LUN RESET
> path, a device reset that times out and escalates to a bus reset, and
> the autosense change, since a target here answers TARGET RESET with a
> bus free as SCSI requires. The oops was not reproduced on purpose on an
> unpatched kernel; the crash above came from the failing disk.
> 
> Fixes: c67e63800446 ("scsi: aic79xx: Do not reference SCSI command when resetting device")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrew Luebke <andrew.luebke@gmail.com>
> Assisted-by: LLM
> ---
> 
> Notes:
>      v2:
>       - Keep ahd_set_residual(reset_scb, 0) in ahd_linux_dev_reset(): with
>         the check in ahd_set_residual() the call is safe, and the patch now
>         touches only aic79xx_osm.h (Hannes).
>       - Move the NULL checks for the transaction status and the SCSI status
>         into ahd_cmd_set_transaction_status(), ahd_cmd_set_scsi_status() and
>         the two ahd_cmd_get_*() helpers (Hannes). ahd_set_residual() keeps
>         its check in the SCB wrapper: it calls the midlayer's
>         scsi_set_resid() directly, with no ahd_cmd_*() helper underneath.
>         The same goes for ahd_get_residual(), ahd_get_transfer_dir() and
>         ahd_freeze_scb().
>       - ahd_perform_autosense() returns 0 for an SCB without a command, so a
>         device reset that ends in CHECK CONDITION is not requeued for REQUEST
>         SENSE with SCB_DEVICE_RESET cleared (found by the Sashiko AI review of
>         v1).
>      v1: https://patchwork.kernel.org/project/linux-scsi/patch/20261020221530.2606178-1-andrew.luebke@gmail.com/
>      
>      This analysis, the patch and this changelog were prepared with an LLM coding
>      assistant (Claude Opus 5.5, Anthropic) at my direction; I reviewed them and
>      ran the hardware tests described above. Build-tested with W=1 for
>      x86_64 and i386 on mkp/scsi.git for-next (db8b4d2bf2d3): no new warnings;
>      checkpatch clean. sparse and smatch were not run.
> 
>   drivers/scsi/aic7xxx/aic79xx_osm.h | 26 +++++++++++++++++++++-----
>   1 file changed, 21 insertions(+), 5 deletions(-)
> 
Sigh. It is a really bad sign if the patch description is far longer 
than the patch itself. Might be okay for really intricate things, but
adding NULL checks to functions certainly is not.
But this doesn't change the validity of the patch, so:

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
