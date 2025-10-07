Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814D15464D
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2025 20:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870648; cv=none; b=ZjrjhI6CdahYUS2zbq+uif08viFYuAszMiT8nApZ4HjkKLSUhLr5EPfkR3wwP3F84oDKc0k0U2AMq+crCxv0DVREAegOCWxc1kT+yZsn/OoIAfQW3wl43u/g5WXTwfLd2+3yn1PbWX7qeVNZYk0Bnbhse6xvSALgUkuS+c7Ffro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870648; c=relaxed/simple;
	bh=lo+bODTqhbR+va341uGZBQme+L9mjBJdDdog2Ba/nBk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWaEHHXAJc46QyLCM92qfrxHsFGQSgQd+CFjDy9mH7e63yWQHVkNYi/+00OwiCmLL0tBYrHrqwuIA5iZWyrE56UXdf4WDLs93WIB7bOg7Xz36sfb0I1cAvNGawqiAKVWbEEIiL4ntyku5Lv1l/xYnFQiKBlro2Gyl5iOzZbDZoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IHIrygQd; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IHIrygQd"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-57a59124323so1873012e87.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Oct 2025 13:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759870644; x=1760475444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g03JkHUsqdzLl3r9exUSIw17r9a2Np//6olnzHZA6Y4=;
        b=IHIrygQdeDczRh0ogILlLdPkfzITe9CfMZQerLdPOAwKX7FApneP06kpxGmnM3bjlf
         Br2JBFzy0z5G1uiSYkkCBEmtKEJ7oHeLdlNrtIFeXGHWFmNNbBl1hE5+pJfdoo4X3UqF
         piOIRpP0TL5pVBhc/w7A8enWukHIL9/XFZLxfmsu10fTCYWUSJ9J0Ihg0yPpLz8Gvi8z
         mZ9XKDmE5RliFOVieeAhJ0AlU4FLlPmcpFq6qdKzhk1yNOi4rn8zXRd8P71UKOR5NFR1
         ch9oNSAt7HBFP5FS7SInlJ+00nYytGqlNhO887fPSn0wfnnhVuiSaaeAKjergSbvc8r7
         qoGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759870644; x=1760475444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g03JkHUsqdzLl3r9exUSIw17r9a2Np//6olnzHZA6Y4=;
        b=YPFkCwOM8E3EJY3EtHr0YsJOcIRnpZiQ8GB3eV50vLXlddwDuZQa9FfP4xURC2Od0b
         tkKRL2i4CR3RXYj/QbPyIbIuVgdSItusZKTdY0IKQSTDooIJhs07jC02EjG+zZJvwEjA
         ILLZGIviVEKCrOWOcun4OgK9ENoe1Y6ZxyWzXnyBjznJnjL2Jb0zdJUmp6N6BVzzL777
         a/w/e7vCPGYJDstDZEfaccv4wSGyKW1c2QQwqLvRNh4Kq/jMxzl6tSGZmHfnXOxEexGL
         dibwmkCAyTwhwxo1ESwiYYhXMpzc7m5w/WjaVEeCLCBA7odbjFIc0/w3SVZEVQ7Sbka0
         pQiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGVXiZL7bxaRstpKGR6bYw8XFke0Auarlgh3AfgL5su1xmkcsytms/xdN3jW5gqfJY2rwyOv/a7Vxq@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzy+g6Ext3+7AsXhPOZosbpd1PBmIi8OqsHPS6v/mUYOYsnPBP
	RChDHidCs5hzsg9EgZeZvYaU98c6oC/YhZDQLGnjeh/hpwgBg8Orb1FQ
X-Gm-Gg: ASbGncuCKsl71t/RguDPMsZu1VORJwiovbOY/qWfazv3vg/ooBGQCxGmV8s6joVGbEL
	Gj67SU87dPgX8X6RemzqWKDsIx/PrwkAqwKGcidlhIEvAdFMYXGQhaUn82dadkavC5XI8Neo3yo
	yG8hQD96QRP9OCwVpk/BYcQvcd5yfDe6mRXC54X0t7Nn2CsRipn02A5xia0epuAABOSBfsAwv6k
	8dW2b9kTVR9VPE7jVDj6mBPg3DBFqYpQ86Op8l40KBYDtc6/JFpWlAxcKN25QNDODew6cr8lh1W
	pW7jTYZd4xsvyav+sQ079++AdwP0SbIzqitej0nJpP7T72MLx/mKW7zttrn3PuLgrM4u3qNfRyP
	w1B/NrP4HNib7gtYp8lW1hcYGe7g1jFeWvbihIxF6olzsv0Re8GcAcrXQcQo=
X-Google-Smtp-Source: AGHT+IE3t6erqilqr2vkNvErtfsN1Weu9WLJEnPCNGwz7Ro11VdzfSyM+y127Q8YciWZY6HpkBzUsQ==
X-Received: by 2002:a05:6512:398c:b0:57e:4998:95ce with SMTP id 2adb3069b0e04-5906d8ed6famr305072e87.35.1759870643322;
        Tue, 07 Oct 2025 13:57:23 -0700 (PDT)
Received: from foxbook (bff184.neoplus.adsl.tpnet.pl. [83.28.43.184])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112462esm6473271e87.3.2025.10.07.13.57.22
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 07 Oct 2025 13:57:22 -0700 (PDT)
Date: Tue, 7 Oct 2025 22:57:18 +0200
From: Michal Pecio <michal.pecio@gmail.com>
To: guhuinan <guhuinan@xiaomi.com>
Cc: Oliver Neukum <oneukum@suse.com>, Alan Stern
 <stern@rowland.harvard.edu>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>,
 <linux-kernel@vger.kernel.org>, "Yu Chen" <chenyu45@xiaomi.com>
Subject: Re: [PATCH] fix urb unmapping issue when the uas device is remove
 during ongoing data transfer
Message-ID: <20251007225718.3c8b2cd8.michal.pecio@gmail.com>
In-Reply-To: <20250930045309.21588-1-guhuinan@xiaomi.com>
References: <20250930045309.21588-1-guhuinan@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 Sep 2025 12:53:08 +0800, guhuinan wrote:
> From: Owen Gu <guhuinan@xiaomi.com>
> 
> When a UAS device is unplugged during data transfer, there is
> a probability of a system panic occurring. The root cause is
> an access to an invalid memory address during URB callback handling.
> Specifically, this happens when the dma_direct_unmap_sg() function
> is called within the usb_hcd_unmap_urb_for_dma() interface, but the
> sg->dma_address field is 0 and the sg data structure has already been
> freed.
> 
> The SCSI driver sends transfer commands by invoking uas_queuecommand_lck()
> in uas.c, using the uas_submit_urbs() function to submit requests to USB.
> Within the uas_submit_urbs() implementation, three URBs (sense_urb,
> data_urb, and cmd_urb) are sequentially submitted. Device removal may
> occur at any point during uas_submit_urbs execution, which may result
> in URB submission failure. However, some URBs might have been successfully
> submitted before the failure, and uas_submit_urbs will return the -ENODEV
> error code in this case. The current error handling directly calls
> scsi_done(). In the SCSI driver, this eventually triggers scsi_complete()
> to invoke scsi_end_request() for releasing the sgtable. The successfully
> submitted URBs, when being completed (giveback), call
> usb_hcd_unmap_urb_for_dma() in hcd.c, leading to exceptions during sg
> unmapping operations since the sg data structure has already been freed.
> 
> This patch modifies the error condition check in the uas_submit_urbs()
> function. When a UAS device is removed but one or more URBs have already
> been successfully submitted to USB, it avoids immediately invoking
> scsi_done(). Instead, it waits for the successfully submitted URBs to
> complete , and then triggers the scsi_done() function call within
> uas_try_complete() after all pending URB operations are finalized.
> 
> Signed-off-by: Yu Chen <chenyu45@xiaomi.com>
> Signed-off-by: Owen Gu <guhuinan@xiaomi.com>

Hi,

Was this situation seen in the wild and/or reproduced, or only
predicted theoretically? Was the patch tested?

I wonder what happens to the submitted URBs when scsi_done() is
not called. Since the command URB was not submitted (or else we
wouldn't be here I guess?) the device shouldn't have selected this
stream before disconnection and it seems that the xHC won't try
to move data on those URBs, so they won't complete with -EPROTO.

Will they sit there stuck until SCSI core times out and aborts
the command? That's poor UX, speaking from experience here.

Maybe it would make sense to unlink them? Unlinking Streams URBs
is a sensitive topic because it's forbidden if they can become
the Current Stream, but in this case it looks like they can't.

Or am I missing something?

Regards,
Michal
