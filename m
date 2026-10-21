Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792602286;
	b=JMqO4jjXHns2ab8bF5UQNsoUPcoIUA8OuQoXKY/yZwQKlM0JhArcph0sMPOa4TuhiE2z
	 88UQwGY2xJdfyWQWDqyhVxFw6MQqn+rkQCquZinhzQ08TMVQFSXb3Iy7QQYTRn2qjlm37
	 JYP50L4wTlaUM6DrN+69Ix7STAuO/ScH0lS7xBNC7PQ8b+CP5TnHJZ2TfPcQaOIUYaGHJ
	 UX4YoW6ECj7xE+lDwHPh/kGBN30Rfd6oBrLj8yOGzfikcua+V7kYqXV+r51/pXLbGoWSc
	 n9uWTnl+gmLBbWzuBgYpoVqumF0QILdCld/rU8uzKubSHNqgS8QDKetZfBxet5mqoCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602286;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D7a/aq8TmS1nl59vDrMFkTYHsVBfKzn9g+F3Ti4XDsc=;
	b=zJyL3IwMrrvJumv5n2t9Zn5QYjDquMiS0hIlC5uTZikgX2XxEgh/ryYQTVkkLsrs57bZ
	 0RhEzQe+zjK0hof55Nagra9qtsLVOKUvWXm52+YM8ANW1Iqj4flID1j3I23OjcEbsGMNM
	 KF3HzLNxtD/MmCdwMiykyDaUkP9dYwUL81TXGCJLbkBiE1uXvNUBl2+UT+hU03do6UXZk
	 Fhu1NKyeuQNvWT9iQlott8S4016c90cZSBgtBeKM0kX3PHW3H3jotxY7DF8VvmLTaFehw
	 0O3ObPL1emqPrOUwUPYn5bbr+0AJiKr/2V/7JCs3ASCRX3fHQ4jSzBadxD0kq/kCgDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=IAY3OVrI;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91777606A31B
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 17:04:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91777606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=IAY3OVrI
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso1826130eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792602285; x=1793207085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D7a/aq8TmS1nl59vDrMFkTYHsVBfKzn9g+F3Ti4XDsc=;
        b=IAY3OVrIPRimhhQh5kFJRjlZAzrLM5l8IA+NXBqDPxuB3Gdwbv9Bn+Rg5owsvDINAb
         XtfXb1oiooOVJVcMTL0j4CYmgsvbfsi6hG1jqF95f5TLU9kCPWecgPWDV7VAZOGxKN/y
         bH3/td3Du/lsifVETSTvLAcapvka53n563ZNLIZSf/0Kn2mk+92yDv8l37JgRS4E3+0p
         lyWqvlLrC6YOaO/Pt1JiDlMHDl7bor0711iMUhM7KBoGeh1SRPg+Sh8ESpBcpm0uFkNJ
         ZYjRQu5TrvUbYko+0SBs5O662AktD+nia9nhM2IGKjHEGdVdkfi3uxET7D9oeZM2c6IY
         MijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792602285; x=1793207085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D7a/aq8TmS1nl59vDrMFkTYHsVBfKzn9g+F3Ti4XDsc=;
        b=OMMVd/BaodbeSsNahvMiH/puArnHhDsRVFcdYzmpGBLRfQAH5KQEk9+z86bsph9fyA
         dE5XjtI+mOixwXZMrecmDAv1cGiyKa5zOtJA1xyViKqtIV1JYLbi1VTXQmGFqHXPwRFh
         LJXkCY+DQGDxeFHRjARgic3Yej+ZccLhEV9BBqzyoWMBersfImSWl0O5uXJLoOrymwlt
         TPF0QN2f6F7doDphh9JBIdcUwDzZ0zBllff0PfguGf4vkI1eczL1f0MuIQmkzHdr3gBm
         tXmwElmgq6bROGdLmjIqMeWS0aB4Hw0+Kviue9tjBOGOObNzGIvevILH2Y7+5glxBiIy
         THfQ==
X-Forwarded-Encrypted: i=1; AKwUvBzKA0T7nUIBvueROE0gviJXQtV/LL1Tnq1k80ZwO6pmbTnnEUOJhgBKjS1po5W8yPwbr1HIxSBRa6os@vger.kernel.org
X-Gm-Message-State: AFq9FYKZuHtKrvYbVJAuQqW8heHMwdj307MfyC7BvPZiYQVeSozXpA/V
	jpG1DtX22Dlt0XzHrxpMPJqUhPNV9zKMeQCdxyZebtfDOiAhtTGzIQvYUF1d+HQUDZY=
X-Gm-Gg: AYBFou0F0C2midr6qOvM+/XBh8SU03X4EkemzyN2nmWfjaplcQ741wENhoSaRYZHZS2
	QjpuOM5XDi00p36EPAA13lU2+J3pUFxaMxM31yB7MIwKuZ6PMW46jD1azMmOYmEdH/Nf1GB681q
	WrZUGald1NTx76aeeL5z5THLLxifWC2SdQIoNG6PxpP1BNGLvwhNBkPZvl9amFIiocIr8Id6BTW
	Z2uUGJiJKIApj9QrJXfMda1dj7VEl07kYsWio3pJdQv0Xo58/cmV/V2TXuoIlgmcuoOxLOTClip
	ex8m63tkIGvguRK0oaX4v9JTYSEd/Xl9w0X9ITikLpw6hRnZ64CGlWtGWIpq8zUxyga9wApYmEi
	hEPSUqn8g8O0PXVik6uOQBv3qMa2p24tnZttgRTxLnjr7h8LzgnHX5jJljiEekAQJMlMPSpZ6xS
	NP9Ivc9x3Z6t+MJ+hTsRPh6H8uUsbhQp+Y3ZSef2DB6KUQz6OV9obQ9YSTLn2v2JIUP3EuxlUVB
	NGg78BGfa4FlzD2m0+tjxcRqhYGaeXO2yHaxpR/GibEHlInNV3dxBBO+oQVHKEF2hBo3PI5EfOK
	OnH6d7pKqMXesM+j3F9IDCOLJHaRkYtr+zDSPuGNPpY5u88nGSGHlL1lko+B7FelCp8pFQM/Vka
	y72e0FH+VhX+DEtrzc2kvl7zxLgPmuQpbj4eusTLqpm2DlADxxmnp
X-Received: by 2002:a05:7300:e9cf:10b0:365:b147:b458 with SMTP id 5a478bee46e88-3674b52acb8mr4309024eec.3.1792602283571;
        Wed, 21 Oct 2026 10:04:43 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cc8439sm9396277eec.11.2026.10.21.10.04.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 10:04:42 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	krishna.kant@purestorage.com
Subject: Re: [PATCH v8 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
Date: Wed, 21 Oct 2026 10:04:34 -0700
Message-ID: <20261021170434.8478-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <227b9f93-0dda-448f-a268-05cf4f9b6046@acm.org>
References: <227b9f93-0dda-448f-a268-05cf4f9b6046@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 10/20/26 3:09 PM, Bart Van Assche wrote:
> This is a big behavior change. I prefer not to unbind disks if PQ
> changes.

OK, no unbinding. v9 will never detach a driver from a bound disk.

> Having taken another look at the cover letter makes me wonder whether
> it is really necessary to refetch standard INQUIRY data and reprobe the
> device when the peripheral qualifier or device type has changed?
> [...] When I was working on active/active SCSI arrays myself we
> didn't care about the INQUIRY data in the kernel and let multipathd
> figure out which path(s) to use.

I'd like multipathd to make that decision too. The problem is a path it
never gets to see. If a host scans while the array reports PQ = 1 on a
path, scsi_bus_match() doesn't bind sd, so the path has no block device
and multipathd doesn't know it exists. When the array returns to
PQ = 0, nothing binds sd, and the path stays unusable until someone
deletes the device and rescans. User space can't fix that; only the
kernel can bind sd.

The array has no choice about PQ = 1 here. SPC-4 5.15.2.4.5 requires it
in the unavailable state:

  a) INQUIRY (the peripheral qualifier (see 6.6.2) shall be set to
     001b);

We discussed this in "The PQ=1 saga" thread Martin started in January
2023. The simplest fix, letting scsi_bus_match() bind at PQ = 1, came
up there, and Martin pointed out that some arrays rely on PQ = 1 to
keep a ULD from binding and that keying off TPGS is probably not
enough. The IBM 2145 case behind 948e922fc446 (since reverted) shows
why: it returns PQ = 1 with PDT 0 for LUNs that aren't mapped. So I'm
not proposing that.

What came out of that thread instead was to reprobe the device when it
leaves the unavailable state. Martin suggested triggering a re-probe on
the transition, and you suggested a rescan when the ALUA state goes
from unavailable or standby to an active state. With unbinding off the
table, that is all v9 needs to do:

  - Only logical units with no driver bound are refreshed. A bound
    disk is left exactly as it is today: no INQUIRY refetch, no
    reprobe.

  - If the refreshed INQUIRY data shows PQ = 0, the driver is bound.
    Nothing is ever unbound.

The trigger has to come from the target, because a LU with no driver
bound gets no commands, so no UNIT ATTENTION or ALUA state change
reaches it. Our arrays make the host rescan when they leave
unavailable, the same way they do when the first volume is mapped to a
host. On iSCSI they send an asynchronous event with REPORTED LUNS DATA
HAS CHANGED, and iscsid writes to the sysfs rescan attribute of every
device on the session, which ends up in scsi_rescan_device(). On FC
they log out the host's initiators, and after the re-login the
transport scans the target. That scan finds the existing scsi_device
and today does nothing with it, so the scan path calls
scsi_rescan_device() for registered devices that have no driver bound.
Bound devices skip it, so the scan cost and the time scan_mutex is held
don't change for them.

That leaves one difference you should know about. While a path is
unavailable, a host that was running when it became unavailable keeps
a bound sd on that path, which ALUA and multipathd treat as a failed
path. A host that scanned while it was unavailable has no sd on it.
Both end up the same once the array returns to PQ = 0.

This makes v9 much smaller than v8: no unbind, no offline handling,
and no INQUIRY update on a device that has a driver bound. The fixes
you and Sashiko found still apply where the code remains
(device_is_registered() before binding, the inquiry_len handling, the
PQ 3 / PDT 1Fh filters, and the structural points).

Martin, does this direction work for you before I write it?

Thanks,

Brian
