Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792608643;
	b=siqCcHwl8aOkyKqtI1Zt+wc8Na5SMhwfRExkr5EP0ieQn8nirXNe8ON9OEF8Fdv+6+GD
	 B5yqvM+TCLnJLQ2i8ho4pou97FogjPAen4u/QWZJAxLuuTimV1miP/FeOfEbm7ZVeeX06
	 J1GF9ILbZCsYAU3ZzSluhhthtu/03kL7FAdWT2NOTbo9h+wDXXhiOtbS3aU8sioerLqqa
	 1i2q3QbDZX6WHhEO+TyoXrIBXeZ1eTjrFQs7ObzJu/bWGgLzRGjkcolglgvHQQaXMg097
	 x46rpJLhsY9z0I8l+Ehy6i+ElBxmzecF/mBqB75hhYPpINF8//zcOANpmRGIFAhbA/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792608643;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v4DG4eX7qGLgBkujHZ0cOe7Lt3LotmgjHE2iKjwEN5A=;
	b=Kq+wltvUlq3xmxMWbyMji2A7la8Y9KL1Qxzof8txYBlo4JhuY/IrqxV0fqT7fkPywsHr
	 PhNcWJlQ5L3AD/QNs7GC4q4jmVonvXdSe1vcTc2KTfCzPxmLxPllC9vz+Pe6fL4Fg11HV
	 mOQN8PjP7jfDVbZ3OjX2BhtLo06Pq3kBcUg8FBacRLqLDuHI9V5UGMaTeMDiBpGrLSapr
	 1fnJVQIZLycOO4YBRIhVtkNoZgyFrUb8KyNbQsmSUZEWQ4qnxIfU0E6gtNky82+ckyaL7
	 V9g7MbLRupLlonSSrt9DFO7CPubqSoB45i1JmoaVZ7pjzKv+WWfP/7AKD7qmGMuREHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=UgmKodks;
	arc=none smtp.remote-ip=74.125.82.45
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C2F606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 18:50:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50C2F606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=UgmKodks
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-19305bcb72cso37904c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 11:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792608641; x=1793213441; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v4DG4eX7qGLgBkujHZ0cOe7Lt3LotmgjHE2iKjwEN5A=;
        b=UgmKodksqnlQRUg6OKar9G93QMBqjt2BS3tQZBDrj/+c9x3JAxbzEMewmT/LwjRnlX
         KDGEQM+unbTZAQhbLhqttWOwb+EOp8KE3VmEAMtFsPbs+v5/5iq8Hb/ImSs5u0COaIeq
         uulDaOfnvmbMZUF+9T9aN6hMImD78Uil+CRW9eCX9Gc4h/3MRXYUHr/QXPM++7JrugVp
         LAqe8gI/Xq9Yh2fMAGQX3BdntkSuzHV2yV2sOybw2jdaeF0Ng6i/0JVjXlcyBnNcopGv
         OTGXi48fkM/ycXFZ6tiRHVS8VqzVWHx78JhoTDOC/OeA15rWqK+i//ylspF1H05b1zPw
         OLjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792608641; x=1793213441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v4DG4eX7qGLgBkujHZ0cOe7Lt3LotmgjHE2iKjwEN5A=;
        b=GSOC5n6dVo8x0m3I1pmyhXYa5YIwSZzi9zrUDh81fCcObBmrc2vS/m+HbTdb299WtD
         TcyPddyQ6Kq6ioqZ7RdBzyT66g0yQHhBhIzPHS3l4wiRg7JFI0MPk/UCD/yCAMbrtR2L
         1JEvQcY+OE2vlwtW7yQHEUbrR+Wh5vWpm+fxWjSQSpgVli9c6KD/QNrRq3eI+fPkDbYx
         Y60ygPWusRwH33MdKFPkKx0+zdKFhD9aS7ddxqNMwXkR2Ot9P6q9Gw3ggHdcbb/V+m0c
         fIrdqXEGtIgyv4rG83sA9fzT+EsvMB3SCafClPKU+Q6D/H7Pgu91LSFj8wiURkChKW0f
         3PYg==
X-Forwarded-Encrypted: i=1; AKwUvBwI/i6KHP7r3ufpymBIPsDl2vWoBPd8sZjzgsXsJRustFpc83Is7xMuKGPtNG4a46/PZvqwSHYhj0OT@vger.kernel.org
X-Gm-Message-State: AFq9FYKR30hDHY/2IUp2Ak49wwCzZEobb006FPAY2LDkM/5kBRpQV4zW
	KKVyTM1IrG3aqEg+L4PCt8xdSJD2ZsWWz8SCkGLxBnkxZpySN+RRllDAKE+s0q5qvBc=
X-Gm-Gg: AYBFou1sDxozCdQaCPAGamXFSKWq4efXbCZAG4D0w0xBHu2ulNKDNv8BZsBNnDJpSQl
	5Sar8Ei4QIcpSc9ku5OgdhbjPs5MD9nEo9cjEy55Wtun6Iy30VL8TGhQ4RBai+kDTQ+7vfGY2Bm
	Ve3eBYD0pJ/YGnj/eaDdROpdF5p6jjV+o3ulcncpEc/CEQL3ScDpcGKyQqqJWLyqN2ex0NPcRT6
	VsEaawe3dB2L2sHpeD7CI+PUJbyArth9JAgCQlhDZ/O/z0QSyqORg83KZu8EnFq/Zt2J8uccti/
	PyFLxoAqHardOYdp08EWGI5dQVp/C+a9xRFrkaozyunkIslAvv2dNPjB/xYQfetLnPsLmx0lLDx
	j7tgQyZNrDSpTs5LRJqa0nl69pbYAgUKLGFg0anmzSuTD3P4tgKyS4PX9BtKf2qTiH0p5Jw2qCc
	A6sgYqRWLqs0NSWL3FD/sEMEJIHjXuhl6FJ6E8ijwknzr7PKV925txi0tHHN+umAW4S2g0YlyJH
	ONTJCOdL3EB60u/gjIsb1CpZLaulkzySgYZ16uBTddwCLhqB3R1aKFevNrIVjMn97Potq1Mehb4
	1uOMBWXWnmR7l2HuVoOsp866yh0FXK8SrXiYU4P1MCTSzJlXOpVQIED1eXydlB6V1Bw3IBLJ6hf
	MZkfGKiAefZkiFup2NoMly/A2mdEp7BopvTNmZDU43sLEMFreWxvy
X-Received: by 2002:a05:701b:4244:20b0:18c:640f:7f48 with SMTP id a92af1059eb24-190a8a847d4mr3558873c88.44.1792608641035;
        Wed, 21 Oct 2026 11:50:41 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903bb7f098sm12559577c88.12.2026.10.21.11.50.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 11:50:40 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	krishna.kant@purestorage.com
Subject: Re: [PATCH v8 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
Date: Wed, 21 Oct 2026 11:50:31 -0700
Message-ID: <20261021185031.35091-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <b4ea3aa9-7db5-4af9-a893-ae2af3c05eed@suse.de>
References: <b4ea3aa9-7db5-4af9-a893-ae2af3c05eed@suse.de>
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

On 10/21/26 12:45 PM, Hannes Reinecke wrote:
> Aw. The mysteries of SPC. Can't you simply use 'Standby' state?
> That would not require all this weird rescanning.

We do use standby today, and have since 2017. That is where the
trouble is. SPC-4 5.15.2.4.4 says that in standby the device server
"shall support those of the following commands that it supports while
in the active/optimized primary target port asymmetric access state",
and the list includes:

  l) PERSISTENT RESERVE IN;
  m) PERSISTENT RESERVE OUT;

We support persistent reservations in active/optimized, so standby has
to accept them too. When the link between the two arrays is down, the
array that has stopped serving the volume can't mirror a reservation
change to its peer, so it can't accept one without the two arrays
ending up with different reservation state. Making standby work in
that situation takes a lot of extra handling on the array. The
unavailable list in 5.15.2.4.5 has no PR commands, which is exactly
what this case needs.

Standby also isn't handled the same way by every host. ESX and AIX,
for example, don't treat a path as down when RTPG reports it as
standby; their path checkers keep trying to use it. So we carry
OS-specific exceptions for how standby is presented to each host type.

ESX and AIX both handle unavailable. Linux is the one we can't use it
with today, because of the problem this series addresses. If Linux
handled it too, unavailable could be the rule for us, and most of the
OS-specific code and the extra PR handling could go away. That is the
motivation for doing this in Linux.

Bart, on Windows: I don't know how current Windows handles
unavailable. If it still doesn't handle it well, we can keep using
standby for Windows hosts, but that would be the one exception rather
than the rule.

> Weelll ... an 'unavailable' device _never_ comes back.
> The only chance it had to 'come back' would be to set a UNIT ATTENTION.
> But that we will only ever see if we send commands to that device,
> which we don't as it's unavailable ...
[...]
> What it the proposed strategy to get it back?

It depends on whether sd is bound, and after Bart's reply sd will stay
bound on a running host (I've agreed to drop unbinding; see my reply to
Bart from earlier today).

  - A host that was running when the path became unavailable keeps sd
    bound. This is the case you describe for standby: the multipath
    map stays intact, multipathd's path checker keeps polling the
    path, and when the array leaves unavailable the UNIT ATTENTIONs it
    posts (ALUA state changed, INQUIRY DATA HAS CHANGED) are seen on
    those polls and the path is reinstated.

  - A host that scanned while the path was unavailable has no sd on
    it, so nothing polls it, and you're right that a UNIT ATTENTION
    alone would never be seen. For that case the array makes the host
    look again when it leaves unavailable: on iSCSI it sends an
    asynchronous event with REPORTED LUNS DATA HAS CHANGED, and iscsid
    rescans each device on the session; on FC it logs out the
    initiators, and the transport scans the target after the re-login.
    That rescan is where v9 binds sd.

> Also we have to worry about the implications for multipathing:
> If the device is set to 'unavailable' we'll be disconnecting it
> from multipathing as the 'sd' driver will be detached.

With unbinding dropped, that no longer happens. A bound path stays in
the map as a failed path, as it would in standby.

> When do you do the LOGO? When entering the unavaiblable state?
> Or when resetting it back to normal?

When leaving unavailable. Entering it, the array only posts INQUIRY
DATA HAS CHANGED and the ALUA state change; sd is bound and sees them
on its next command. Leaving it, the array posts both UNIT ATTENTIONs
and then, on FC, logs out the initiators so that a host with no sd on
the path rescans.

> Yes, but that was the point.
> If reprobe fails, what are you going to do?
> You cannot 'magically' get it back, as _normally_ you would do a reprobe
> to get it back. But that failed. So you _really_ need to delete that
> device and restart from scratch.

In v9 the reprobe only ever binds a driver to a LU that has none. If
the bind fails, the device is left in the state it was already in: a
scsi_device with no ULD, exactly what the scan creates for a PQ = 1 LU.
Nothing that worked before is lost, and the next rescan the array
triggers tries again. Deleting the device and scanning from scratch
would end at the same sd probe, so I'd rather log the failure and leave
the device for the next rescan than add a removal path.

Thanks,

Brian
