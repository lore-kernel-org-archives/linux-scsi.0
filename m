Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114F82F8E8D
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 02:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782959158; cv=none; b=ojNNxmsj9psBo+w78CzUtq4EVO+tsMfVrjxTrq8aRfNhH7wUi5i+an2zuZe/2nhYmv+QDcCuh6LB1sMIqrcUN9nUwLXvonjyXnXba1mnF3lu/7in+KzNQ7zeA7q+gLgmnUnjyYTwRKSE2tdmtq8i0o4tDpftGzi5bs5BRPTRRhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782959158; c=relaxed/simple;
	bh=ajjMYJOUeAJ7+w4Sk7jpoUthErUIpt4feCvrNVnvs5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZxUlVGCYWYalXsvaLiYXzfnEGkrg0YN3qxlvT5UKP7D5BopVzFfLm8WevU8nKneWBH2hE2iYxRk8lV4Ekpaq/Qg8mxv93dvXwnvIzrnKp/UPgcUn2lyG9heNT59EqsvauYp8lhTjMeUQVomjVjL+wKiOwgMYPvfaw8Ws0R1eW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=R4ZuOJUC; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="R4ZuOJUC"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8424b00710aso1018842b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 01 Jul 2026 19:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1782959155; x=1783563955; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=glmkWbYYQh47/UCjaDLzkC1u1NqYyyMJvEXuJTw8adI=;
        b=R4ZuOJUCzbdYvLCZIFgqCT9RW+N4ite7axFPHggWl3/VpKjUc0yGxLC31/ubcPSWJ9
         cHR5rpRCIz9AvF2tGucQPZfl+Iws69ZSsA/iolVxQja/62BV2Ea/4JM4hf3/EId+q1N7
         EGIoRLDsmjnfZFj2F1jQXH6UNwmow5L6NodkM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782959155; x=1783563955;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=glmkWbYYQh47/UCjaDLzkC1u1NqYyyMJvEXuJTw8adI=;
        b=RFtaNjemqP1At+ld8cQqzjPVdd96YfnuBB57P4KwxMGGiNJzJxIkJ4Dg5Hmbi4CZpu
         CpLFGpTLwRwnIXgpEcZzlemcW9SwdhZkjJeFSThy2nTy1I7W7nXpHjnM5BdCDcnbQfbM
         IW68NSZtriKUQjuI3qRDlY0eyeclea2eHymV2+hL9kuTDhFCzGG0x2k5fVBYGoWF9POk
         p5L8OxZf+4ZDixt+xLxumnT9hc6BlFfMu4Pzoi0Vj+BkF1mRawXdq9gSZmZItCe/+ZQ9
         NBEXQhiJzjNiwEyzrRYAxSbHcHKTw8ulEN3j23FP4srEX3XtVHW/ohLsPSi2ywJlrS/x
         /SLg==
X-Forwarded-Encrypted: i=1; AHgh+RqcspWAYNONuEp10zzIvLKiDnD+ZBmHGNck25QkdQxLYAhYnwUmdB6XDadSIFzpnubwAE2CGpBBH4UT@vger.kernel.org
X-Gm-Message-State: AOJu0YxTcXgviAj8mY5bqDvVZ47T9zeaNylxYcx6MA3Y7AnEFpHrTpTQ
	S/PC4na8/giPZ9cVw1DesBCtLbBHXW0K6iwTxecIMkDP69UsTdR2RHv1rwAabGviQ8om/iKB+7W
	zTPE5+w==
X-Gm-Gg: AfdE7cmd9eqPWjIev4a9JZfa2dVQ4TlffrJGvgfDq73Fb8NrvKpf+WEAxaeGQnNR9lW
	9LrsQq8bVMalctRfIdMZ+Rq3VuuLmbSB4FeLVABxtePVK67IixJ+zFMqQ4o0fk4eVX1r3M+flL7
	ZQ8geXSDHk1JU5E+PWx01eZ5EtgSEFdvl7oBmUuHQi9PPmzp9Su3i+CmR1a1IiLnUH14Mpuom4X
	h2C7F86gQgBY/XXW3nXNSFW1g8MpGxSx5C9TL717bEH5IDCBzdqkDNM4pISCThgCPZua8kAqa17
	ybrikgVqPRfFJBpbRyLRxZ/c0r4IK0uqFT1Qa18BoZIKuqVxeF3Pqw56uEgbV5XA3xZl/FYZiyx
	iLG37P5LYkFGSrX8pVISW+4xEgZYFWOZ934PRQ8EF4YAqppK5kpyeqaYg0A6PwMmKaQmmLFBadI
	SgZjOipzrF+thvmRmYjBEASyu24DR5U1XRYJuI8BAqPjC88KX+0gqX
X-Received: by 2002:a05:6a00:4488:b0:847:9c99:ea4f with SMTP id d2e1a72fcca58-847c510599emr3346978b3a.30.1782959154852;
        Wed, 01 Jul 2026 19:25:54 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:faee:2436:3347:c0a2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb9ad161sm582385b3a.51.2026.07.01.19.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 19:25:54 -0700 (PDT)
Date: Thu, 2 Jul 2026 11:25:50 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Oliver Neukum <oneukum@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, 
	usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>
Subject: Re: [usb-storage] [RFC PATCH] usb: storage: uas: limit consecutive
 device resets in error handling
Message-ID: <akXJuqvHLUpcjXIv@google.com>
References: <20260701040335.810297-1-senozhatsky@chromium.org>
 <e2599d9b-5dd9-47db-8339-f1aa825a11d6@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2599d9b-5dd9-47db-8339-f1aa825a11d6@suse.com>

On (26/07/01 10:28), Oliver Neukum wrote:
> On 01.07.26 06:03, Sergey Senozhatsky wrote:
> > When a UAS storage device experiences persistent wire or hardware IO
> > failures, commands time out and the SCSI error handler thread invokes
> > uas_eh_device_reset_handler().  If usb_reset_device() succeeds at the
> > USB hub level but the underlying drive remains unresponsive, the reset
> 
> What exactly do you mean by unresponsive? Usbcore must at least
> reassign the configuration (and the device address).

I might be using a wrong term, sorry about that, what we see is that
USB reports successful resets, but the device still cannot handle
data writes, requests stall.

[..]
> > Introduce a runtime-configurable module parameter 'reset_limit' (default
> > 3) and track consecutive resets in devinfo->reset_cnt.  When a productive
> > block layer command completes successfully (SUBMITTED_BY_BLOCK_LAYER),
> > reset the counter to zero.  If consecutive resets exceed reset_limit,
> > abort the loop by completing pending commands with DID_NO_CONNECT and
> > returning FAILED.  This allows SCSI EH to offline the unresponsive
> > device.
> 
> Let us take a step back. What is the issue here? The device goes
> into error handling. That is not a problem as such. A method
> designed to remedy an error condition has not been effective but seems
> to succeed.
> That must not happen. So what do we do? It seems to me like we
> ought to add a test for the effectiveness of the reset.
> At first glance it looks like UAS should do a TEST UNIT READY
> on its own after a reset.
> Or are we looking at a command that reliably crashes the device and
> is reissued by an upper layer? In that case either we need
> a quirk or the SCSI layer ought to deduce that it is using commands
> it shouldn't use.
> 
> Can we have more information about the scenario that triggered
> the desire for this patch?

Unfortunately, I cannot add a lot of info, as I don't posses (nor
have access to) the device in question.  The user is on 6.6 LTS
kernel (UAS code wise there doesn't seem to be that much of a
difference compared to mainline).  I suppose the misbehaving UAS
device is:

<6>[ 11.902842] usb 2-1.3: New USB device found, idVendor=2109, idProduct=0715, bcdDevice= 2.63
<6>[ 11.902968] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=(Serial: 6)
<6>[ 11.902994] usb 2-1.3: Product: SSK USB3.2 SSD Flash Drive
<6>[ 11.903041] usb 2-1.3: Manufacturer: SSK Corporation
<6>[ 11.903066] usb 2-1.3: SerialNumber: (Serial: 11)
<6>[ 11.909223] scsi host0: uas
<5>[ 11.919288] scsi 0:0:0:0: Direct-Access SSK Port able SSD 256 X082 PQ: 0 ANSI: 6
<5>[ 11.928062] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
<5>[ 11.928336] sd 0:0:0:0: [sda] Write Protect is off
<7>[ 11.928377] sd 0:0:0:0: [sda] Mode Sense: 2f 00 00 00
<5>[ 11.929521] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<6>[ 11.956480] sd 0:0:0:0: [sda] Preferred minimum I/O size 4096 bytes
<4>[ 11.956515] sd 0:0:0:0: [sda] Optimal transfer size 33553920 bytes not a multiple of preferred minimum block size (4096 bytes)

And then all I have is dmesg (ramoops).

(don't get confused by "rq: tag=.. op=..." lines, they are from  our downstream
blk-mq stall watchdog)

Cut and paste from the first time UAS reports an error:

<6>[ 704.586138] sd 0:0:0:0: [sda] tag#5 uas_eh_abort_handler 0 uas-tag 6 inflight: CMD OUT
<6>[ 704.586217] sd 0:0:0:0: [sda] tag#5 CDB: Write(10) 2a 00 00 d3 94 08 00 04 00 00
<6>[ 704.687269] sd 0:0:0:0: [sda] tag#4 uas_eh_abort_handler 0 uas-tag 4 inflight: CMD OUT
<6>[ 704.687356] sd 0:0:0:0: [sda] tag#4 CDB: Write(10) 2a 00 00 d3 8c 08 00 04 00 00
<6>[ 704.693877] sd 0:0:0:0: [sda] tag#3 uas_eh_abort_handler 0 uas-tag 3 inflight: CMD OUT
<6>[ 704.693947] sd 0:0:0:0: [sda] tag#3 CDB: Write(10) 2a 00 00 d3 88 08 00 04 00 00
<6>[ 704.700914] sd 0:0:0:0: [sda] tag#2 uas_eh_abort_handler 0 uas-tag 2 inflight: CMD OUT
<6>[ 704.700963] sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 84 08 00 04 00 00
<6>[ 704.707981] sd 0:0:0:0: [sda] tag#1 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD OUT
<6>[ 704.708053] sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 80 08 00 04 00 00
<6>[ 704.714947] sd 0:0:0:0: [sda] tag#0 uas_eh_abort_handler 0 uas-tag 5 inflight: CMD OUT
<6>[ 704.715019] sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 00 d3 90 08 00 04 00 00
<6>[ 704.730668] scsi host0: uas_eh_device_reset_handler start
<6>[ 704.797633] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 704.817713] scsi host0: uas_eh_device_reset_handler success
<6>[ 735.309699] scsi host0: uas_eh_device_reset_handler start
<6>[ 735.310945] sd 0:0:0:0: [sda] tag#2 uas_zap_pending 0 uas-tag 1 inflight: CMD
<6>[ 735.311018] sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 94 08 00 04 00 00
<6>[ 735.311057] sd 0:0:0:0: [sda] tag#3 uas_zap_pending 0 uas-tag 2 inflight: CMD
<6>[ 735.311122] sd 0:0:0:0: [sda] tag#3 CDB: Write(10) 2a 00 00 d3 8c 08 00 04 00 00
<6>[ 735.311188] sd 0:0:0:0: [sda] tag#4 uas_zap_pending 0 uas-tag 3 inflight: CMD
<6>[ 735.311224] sd 0:0:0:0: [sda] tag#4 CDB: Write(10) 2a 00 00 d3 88 08 00 04 00 00
<6>[ 735.311289] sd 0:0:0:0: [sda] tag#0 uas_zap_pending 0 uas-tag 4 inflight: CMD
<6>[ 735.311354] sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 00 d3 84 08 00 04 00 00
<6>[ 735.311390] sd 0:0:0:0: [sda] tag#1 uas_zap_pending 0 uas-tag 5 inflight: CMD
<6>[ 735.311455] sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 80 08 00 04 00 00
<6>[ 735.311521] sd 0:0:0:0: [sda] tag#5 uas_zap_pending 0 uas-tag 6 inflight: CMD
<6>[ 735.311558] sd 0:0:0:0: [sda] tag#5 CDB: Write(10) 2a 00 00 d3 90 08 00 04 00 00
<6>[ 735.377751] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 735.398693] scsi host0: uas_eh_device_reset_handler success
<4>[ 750.651133] rq: tag=0 hctx=0 op=WRITE sector=13860872 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
<4>[ 750.651205] rq: tag=1 hctx=0 op=WRITE sector=13865992 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
<4>[ 750.651263] rq: tag=2 hctx=0 op=WRITE sector=13863944 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
<4>[ 750.651320] rq: tag=3 hctx=0 op=WRITE sector=13862920 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
<4>[ 750.651379] rq: tag=4 hctx=0 op=WRITE sector=13861896 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
<4>[ 750.651437] rq: tag=5 hctx=0 op=WRITE sector=13864968 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
<4>[ 750.651494] blk: queue stall on sda: 6 inflight, 6 stalled (threshold 60000 ms)
<6>[ 765.511365] scsi host0: uas_eh_device_reset_handler start
<6>[ 765.512640] sd 0:0:0:0: [sda] tag#4 uas_zap_pending 0 uas-tag 1 inflight: CMD
<6>[ 765.512689] sd 0:0:0:0: [sda] tag#4 CDB: Write(10) 2a 00 00 d3 84 08 00 04 00 00
<6>[ 765.512737] sd 0:0:0:0: [sda] tag#0 uas_zap_pending 0 uas-tag 2 inflight: CMD
<6>[ 765.512762] sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 00 d3 80 08 00 04 00 00
<6>[ 765.512808] sd 0:0:0:0: [sda] tag#1 uas_zap_pending 0 uas-tag 3 inflight: CMD
<6>[ 765.512855] sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 94 08 00 04 00 00
<6>[ 765.512880] sd 0:0:0:0: [sda] tag#2 uas_zap_pending 0 uas-tag 4 inflight: CMD
<6>[ 765.512927] sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 8c 08 00 04 00 00
<6>[ 765.512974] sd 0:0:0:0: [sda] tag#3 uas_zap_pending 0 uas-tag 5 inflight: CMD
<6>[ 765.513000] sd 0:0:0:0: [sda] tag#3 CDB: Write(10) 2a 00 00 d3 88 08 00 04 00 00
<6>[ 765.513047] sd 0:0:0:0: [sda] tag#5 uas_zap_pending 0 uas-tag 6 inflight: CMD
<6>[ 765.513094] sd 0:0:0:0: [sda] tag#5 CDB: Write(10) 2a 00 00 d3 90 08 00 04 00 00
<6>[ 765.577456] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 765.597265] scsi host0: uas_eh_device_reset_handler success
<6>[ 795.719449] scsi host0: uas_eh_device_reset_handler start
<6>[ 795.720700] sd 0:0:0:0: [sda] tag#4 uas_zap_pending 0 uas-tag 1 inflight: CMD
<6>[ 795.720752] sd 0:0:0:0: [sda] tag#4 CDB: Write(10) 2a 00 00 d3 80 08 00 04 00 00
<6>[ 795.720778] sd 0:0:0:0: [sda] tag#0 uas_zap_pending 0 uas-tag 2 inflight: CMD
<6>[ 795.720826] sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 00 d3 94 08 00 04 00 00
<6>[ 795.720872] sd 0:0:0:0: [sda] tag#1 uas_zap_pending 0 uas-tag 3 inflight: CMD
<6>[ 795.720897] sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 8c 08 00 04 00 00
<6>[ 795.720944] sd 0:0:0:0: [sda] tag#2 uas_zap_pending 0 uas-tag 4 inflight: CMD
<6>[ 795.720990] sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 88 08 00 04 00 00
<6>[ 795.721016] sd 0:0:0:0: [sda] tag#3 uas_zap_pending 0 uas-tag 5 inflight: CMD
<6>[ 795.721062] sd 0:0:0:0: [sda] tag#3 CDB: Write(10) 2a 00 00 d3 84 08 00 04 00 00
<6>[ 795.721109] sd 0:0:0:0: [sda] tag#5 uas_zap_pending 0 uas-tag 6 inflight: CMD
<6>[ 795.721135] sd 0:0:0:0: [sda] tag#5 CDB: Write(10) 2a 00 00 d3 90 08 00 04 00 00
<6>[ 796.007591] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 796.027767] scsi host0: uas_eh_device_reset_handler success
<4>[ 812.091136] rq: tag=0 hctx=0 op=WRITE sector=13863944 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
<4>[ 812.091194] rq: tag=1 hctx=0 op=WRITE sector=13862920 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
<4>[ 812.091242] rq: tag=2 hctx=0 op=WRITE sector=13861896 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
<4>[ 812.091289] rq: tag=3 hctx=0 op=WRITE sector=13860872 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
<4>[ 812.091335] rq: tag=4 hctx=0 op=WRITE sector=13865992 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
<4>[ 812.091381] rq: tag=5 hctx=0 op=WRITE sector=13864968 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
<4>[ 812.091428] blk: queue stall on sda: 6 inflight, 6 stalled (threshold 60000 ms)
<6>[ 826.435375] scsi host0: uas_eh_device_reset_handler start
<6>[ 826.436559] sd 0:0:0:0: [sda] tag#4 uas_zap_pending 0 uas-tag 1 inflight: CMD
<6>[ 826.436619] sd 0:0:0:0: [sda] tag#4 CDB: Write(10) 2a 00 00 d3 94 08 00 04 00 00
<6>[ 826.436679] sd 0:0:0:0: [sda] tag#0 uas_zap_pending 0 uas-tag 2 inflight: CMD
<6>[ 826.436710] sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 00 d3 8c 08 00 04 00 00
<6>[ 826.436758] sd 0:0:0:0: [sda] tag#1 uas_zap_pending 0 uas-tag 3 inflight: CMD
<6>[ 826.436807] sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 88 08 00 04 00 00
<6>[ 826.436834] sd 0:0:0:0: [sda] tag#2 uas_zap_pending 0 uas-tag 4 inflight: CMD
<6>[ 826.436884] sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 84 08 00 04 00 00
<6>[ 826.436933] sd 0:0:0:0: [sda] tag#3 uas_zap_pending 0 uas-tag 5 inflight: CMD
<6>[ 826.436960] sd 0:0:0:0: [sda] tag#3 CDB: Write(10) 2a 00 00 d3 80 08 00 04 00 00
<6>[ 826.437008] sd 0:0:0:0: [sda] tag#5 uas_zap_pending 0 uas-tag 6 inflight: CMD
<6>[ 826.437056] sd 0:0:0:0: [sda] tag#5 CDB: Write(10) 2a 00 00 d3 90 08 00 04 00 00
<6>[ 826.502749] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 826.521493] scsi host0: uas_eh_device_reset_handler success
<6>[ 856.652469] scsi host0: uas_eh_device_reset_handler start
<6>[ 856.653458] sd 0:0:0:0: [sda] tag#2 uas_zap_pending 0 uas-tag 1 inflight: CMD
<6>[ 856.653535] sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 8c 08 00 04 00 00
<6>[ 856.653574] sd 0:0:0:0: [sda] tag#3 uas_zap_pending 0 uas-tag 2 inflight: CMD
<6>[ 856.653640] sd 0:0:0:0: [sda] tag#3 CDB: Write(10) 2a 00 00 d3 88 08 00 04 00 00
<6>[ 856.653706] sd 0:0:0:0: [sda] tag#4 uas_zap_pending 0 uas-tag 3 inflight: CMD
<6>[ 856.653741] sd 0:0:0:0: [sda] tag#4 CDB: Write(10) 2a 00 00 d3 84 08 00 04 00 00
<6>[ 856.653804] sd 0:0:0:0: [sda] tag#0 uas_zap_pending 0 uas-tag 4 inflight: CMD
<6>[ 856.653867] sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 00 d3 80 08 00 04 00 00
<6>[ 856.653902] sd 0:0:0:0: [sda] tag#1 uas_zap_pending 0 uas-tag 5 inflight: CMD
<6>[ 856.653965] sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 94 08 00 04 00 00
<6>[ 856.654029] sd 0:0:0:0: [sda] tag#5 uas_zap_pending 0 uas-tag 6 inflight: CMD
<6>[ 856.654064] sd 0:0:0:0: [sda] tag#5 CDB: Write(10) 2a 00 00 d3 90 08 00 04 00 00
<6>[ 856.718609] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 856.738743] scsi host0: uas_eh_device_reset_handler success
<3>[ 856.738939] sd 0:0:0:0: [sda] tag#0 timing out command, waited 180s
<6>[ 856.738999] sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK cmd_age=182s
<6>[ 856.739056] sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 00 d3 80 08 00 04 00 00
<3>[ 856.739119] I/O error, dev sda, sector 13860872 op 0x1:(WRITE) flags 0x4800 phys_seg 128 prio class 2
<3>[ 856.739155] Buffer I/O error on dev sda, logical block 1732609, lost async page write
<3>[ 856.739219] Buffer I/O error on dev sda, logical block 1732610, lost async page write
<3>[ 856.739272] Buffer I/O error on dev sda, logical block 1732611, lost async page write
<3>[ 856.739323] Buffer I/O error on dev sda, logical block 1732612, lost async page write
<3>[ 856.739354] Buffer I/O error on dev sda, logical block 1732613, lost async page write
<3>[ 856.739410] Buffer I/O error on dev sda, logical block 1732614, lost async page write
<3>[ 856.739466] Buffer I/O error on dev sda, logical block 1732615, lost async page write
<3>[ 856.739522] Buffer I/O error on dev sda, logical block 1732616, lost async page write
<3>[ 856.739553] Buffer I/O error on dev sda, logical block 1732617, lost async page write
<3>[ 856.739607] Buffer I/O error on dev sda, logical block 1732618, lost async page write
<3>[ 856.739764] sd 0:0:0:0: [sda] tag#1 timing out command, waited 180s
<6>[ 856.739796] sd 0:0:0:0: [sda] tag#1 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK cmd_age=182s
<6>[ 856.739852] sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 94 08 00 04 00 00
<3>[ 856.739907] I/O error, dev sda, sector 13865992 op 0x1:(WRITE) flags 0x4800 phys_seg 128 prio class 2
<3>[ 856.740068] sd 0:0:0:0: [sda] tag#2 timing out command, waited 180s
<6>[ 856.740099] sd 0:0:0:0: [sda] tag#2 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK cmd_age=182s
<6>[ 856.740154] sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 8c 08 00 04 00 00
<3>[ 856.740200] I/O error, dev sda, sector 13863944 op 0x1:(WRITE) flags 0x4800 phys_seg 128 prio class 2
<3>[ 856.740310] sd 0:0:0:0: [sda] tag#3 timing out command, waited 180s
<6>[ 856.740338] sd 0:0:0:0: [sda] tag#3 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK cmd_age=182s
<6>[ 856.740385] sd 0:0:0:0: [sda] tag#3 CDB: Write(10) 2a 00 00 d3 88 08 00 04 00 00
<3>[ 856.740431] I/O error, dev sda, sector 13862920 op 0x1:(WRITE) flags 0x4800 phys_seg 128 prio class 2
<3>[ 856.740532] sd 0:0:0:0: [sda] tag#4 timing out command, waited 180s
<6>[ 856.740558] sd 0:0:0:0: [sda] tag#4 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK cmd_age=182s
<6>[ 856.740603] sd 0:0:0:0: [sda] tag#4 CDB: Write(10) 2a 00 00 d3 84 08 00 04 00 00
<3>[ 856.740649] I/O error, dev sda, sector 13861896 op 0x1:(WRITE) flags 0x4800 phys_seg 128 prio class 2
<3>[ 856.740750] sd 0:0:0:0: [sda] tag#5 timing out command, waited 180s
<6>[ 856.740775] sd 0:0:0:0: [sda] tag#5 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK cmd_age=182s
<6>[ 856.740821] sd 0:0:0:0: [sda] tag#5 CDB: Write(10) 2a 00 00 d3 90 08 00 04 00 00
<3>[ 856.740867] I/O error, dev sda, sector 13864968 op 0x1:(WRITE) flags 0x4800 phys_seg 128 prio class 2
<6>[ 886.862169] sd 0:0:0:0: [sda] tag#4 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD
<6>[ 886.862204] sd 0:0:0:0: [sda] tag#4 CDB: Write(10) 2a 00 00 d3 98 08 00 04 00 00
<6>[ 886.862256] sd 0:0:0:0: [sda] tag#0 uas_eh_abort_handler 0 uas-tag 2 inflight: CMD OUT
<6>[ 886.862303] sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 00 d3 9c 08 00 04 00 00
<6>[ 886.872436] scsi host0: uas_eh_device_reset_handler start
<6>[ 886.936568] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 886.954990] scsi host0: uas_eh_device_reset_handler success
<6>[ 917.070222] sd 0:0:0:0: [sda] tag#3 uas_eh_abort_handler 0 uas-tag 3 inflight: CMD IN
<6>[ 917.070318] sd 0:0:0:0: [sda] tag#3 CDB: Read(10) 28 00 00 00 00 00 00 00 20 00
<6>[ 917.079434] scsi host0: uas_eh_device_reset_handler start
<6>[ 917.079994] sd 0:0:0:0: [sda] tag#1 uas_zap_pending 0 uas-tag 1 inflight: CMD
<6>[ 917.080046] sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 98 08 00 04 00 00
<6>[ 917.080072] sd 0:0:0:0: [sda] tag#2 uas_zap_pending 0 uas-tag 2 inflight: CMD
<6>[ 917.080118] sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 9c 08 00 04 00 00
<6>[ 917.145714] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 917.164988] scsi host0: uas_eh_device_reset_handler success
<6>[ 917.165155] sd 0:0:0:0: [sda] tag#3 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=30s
<6>[ 917.165210] sd 0:0:0:0: [sda] tag#3 CDB: Read(10) 28 00 00 00 00 00 00 00 20 00
<3>[ 917.165239] I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x80700 phys_seg 4 prio class 3
<4>[ 934.971114] rq: tag=0 hctx=0 op=WRITE sector=13867016 len=524288 age=78231 ms pid=11900 comm=image_burner state=D
<4>[ 934.971169] rq: tag=1 hctx=0 op=WRITE sector=13868040 len=524288 age=78230 ms pid=11900 comm=image_burner state=D
<4>[ 934.971217] blk: queue stall on sda: 3 inflight, 2 stalled (threshold 60000 ms)
<6>[ 947.276222] sd 0:0:0:0: [sda] tag#3 uas_eh_abort_handler 0 uas-tag 3 inflight: CMD IN
<6>[ 947.276282] sd 0:0:0:0: [sda] tag#3 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
<6>[ 947.280489] scsi host0: uas_eh_device_reset_handler start
<6>[ 947.281255] sd 0:0:0:0: [sda] tag#0 uas_zap_pending 0 uas-tag 1 inflight: CMD
<6>[ 947.281309] sd 0:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 00 d3 98 08 00 04 00 00
<6>[ 947.281391] sd 0:0:0:0: [sda] tag#1 uas_zap_pending 0 uas-tag 2 inflight: CMD
<6>[ 947.281468] sd 0:0:0:0: [sda] tag#1 CDB: Write(10) 2a 00 00 d3 9c 08 00 04 00 00
<6>[ 947.346666] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 947.365031] scsi host0: uas_eh_device_reset_handler success
<6>[ 977.479406] scsi host0: uas_eh_device_reset_handler start
<6>[ 977.479963] sd 0:0:0:0: [sda] tag#2 uas_zap_pending 0 uas-tag 1 inflight: CMD
<6>[ 977.480015] sd 0:0:0:0: [sda] tag#2 CDB: Write(10) 2a 00 00 d3 98 08 00 04 00 00
<6>[ 977.480042] sd 0:0:0:0: [sda] tag#3 uas_zap_pending 0 uas-tag 2 inflight: CMD
<6>[ 977.480089] sd 0:0:0:0: [sda] tag#3 CDB: Write(10) 2a 00 00 d3 9c 08 00 04 00 00
<6>[ 977.480137] sd 0:0:0:0: [sda] tag#4 uas_zap_pending 0 uas-tag 3 inflight: CMD
<6>[ 977.480166] sd 0:0:0:0: [sda] tag#4 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
<6>[ 977.545653] usb 2-1.3: reset SuperSpeed Plus Gen 2x1 USB device number 4 using xhci_hcd
<6>[ 977.565338] scsi host0: uas_eh_device_reset_handler success
<3>[ 984.123394] INFO: task image_burner:11900 blocked for more than 122 seconds.
<3>[ 984.123449] Tainted: G S U 6.6.135-09364-g548ca84e71c6 #1
<3>[ 984.123501] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
<6>[ 984.123517] task:image_burner state:D stack:0 pid:11900 ppid:11893 flags:0x00004002
<6>[ 984.123577] Call Trace:
<6>[ 984.123603] <TASK>
<6>[ 984.123659] __schedule+0x5e8/0x14c0
<6>[ 984.123688] ? free_unref_page_list+0x25d/0x290
<6>[ 984.123715] ? lru_gen_update_size+0x1e3/0x220
<6>[ 984.123763] schedule+0x5e/0xa0
<6>[ 984.123788] io_schedule+0x47/0x70
<6>[ 984.123814] folio_wait_bit_common+0x18a/0x270
<6>[ 984.123863] ? __pfx_wake_page_function+0x10/0x10
<6>[ 984.123889] folio_wait_writeback+0x35/0x90
<6>[ 984.123937] __filemap_fdatawait_range+0x162/0x190
<6>[ 984.123965] file_write_and_wait_range+0xa3/0x120
<6>[ 984.124013] blkdev_fsync+0x39/0x60
<6>[ 984.124040] __x64_sys_fdatasync+0x4c/0x90
<6>[ 984.124067] do_syscall_64+0x6b/0xa0
