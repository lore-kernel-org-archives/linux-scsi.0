Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD92524AE3
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991485; cv=none; b=fMT9aciyJX6tOeZWSAnsq5i58HmMSZ5BVzkLtYOy1SZlkdGlRgcssDcLKpqNx29ZYQN0jQXU75j/Px52KTkjz97zsF3em4gdGns+xVw4jkiBUvpYttmFpuAFfzXQoCX+0ArROGqjsefBuIEa1XuagcdILxOC9hfPdDjEtncYKIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991485; c=relaxed/simple;
	bh=CJI50wcXJ2BCcOVcasSmzvaz+gwwPUSdoPRdsX17WOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BGSyhS9pSiuMCgLZNGDXVdxy1hPmLw/hN9EBhmfHevZlP2ljXmZctO8PiYkn/mJqMgEcJed+sJc0f9MsknstKiciDkFlgJQ2YyMCW+/SAlojR55yfaKtKfplUnb42VOBbamf63Bst9FmewDKlgSDwTzyijKHfrFIZTnt/0PYKLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=HczcyIm3; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="HczcyIm3"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-890d52c7c7bso3470214b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 08:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791991483; x=1792596283; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5OkvFTt8xurlOqdzsXBI0/VdI7mHWZJ52WKipIc8xDM=;
        b=HczcyIm3MWVmySNs2AZGzSS+u13XAxcWoXoaeoFo4Tt2jdwuDZVe3RIA41dDcHeQS8
         oBG90vvTV47G2g0T2TpkRr8nqyDhcQui5uQiFuZ6Z/9umigpLRDlB3bOZM2DZ//+FTN6
         5am15r1T8b+0dUADURcoe+bWU9J0CMtLeE1+uxIh3D8k6HjX/s1urS+rNluRYbs5kS58
         v0S/kGfTHENI89s2B1ZY2hR/P8QoDVoA/NmhFKJK3f+NPych5RrAq2UwhgADJjGSGf35
         vbHk3DzqrvQ2tt/GDfYyD4XE7feo/chohJSz8Q/IENgBzrXWAPkV1s/x2ZXz2Ho7m9aw
         3jAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791991483; x=1792596283;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5OkvFTt8xurlOqdzsXBI0/VdI7mHWZJ52WKipIc8xDM=;
        b=f/Vq3Em+a+IMBU/wLhVJ9bs81/DeKLt7elATU3dmYf4/JdLb25vy00eJH5aTJkEICD
         NAZm/8QM/+NDp3msxgFxSEFmgD/ZiktY3kipAoO+ixWMAXna54kAdfqKbJtmQuPdDC1P
         FDJYZdjvD0nBjSxsLlvAZQOlGZF525uA59hIdp6rpndK/R0PyGYbDamiU3pZLycPR5ur
         Gzjj7loqY+Xo+xMmFFjwmSB7LesyoEOzDTQhtqfNidOtB60YEfhzTftComGHW67m2NbW
         37N/5m+G1vSO/oQwOLLaqlwE7RQOKtj9vwX5i0JZdije7+A2/fyaN6eSVv4P6MNEciXS
         NgRg==
X-Gm-Message-State: AFq9FYK1qmeD8dxOAnRQt+RQ0pbulZshnFuk8pr9fSJNf4SbdgQMOFDt
	DqwBoWEJLqpVJfZKFAKITnOk1coqvwKMRZJX1Jr4uDDNx25skEATSRO+h1E+E7HgTn/IT113xvm
	CHGzD
X-Gm-Gg: AYBFou3aLaXTQBTiJHWhyjDxv0SuSY1a7Y26gvXm9MQp0fJGQ6WpLG/BH9V2oGKtYc/
	+xUNTJrkrck24XMMdDLYMI6f3ooEZOE3uOda/CNeq3mVAC0xU4RizdvgST7YOKSlcgSI9UnNgLN
	VkOhMRon1OKI0IdpeliJYv9shc8YevvdNPFCnZuwDIR4qw0gJ5SFg26eCtjv8Y2OnIGjm4/fhP9
	HPFBon4KVJwUGSS6vz/jVDdqFNf7TIHkdr8dEk0O4o+cqiaX5s7ADutw6g5TYy4X4P4Snyrn31q
	cZ+PvGabzON2EOGZwj+I6Tt7fii4qGtliRgWl3rLRzUMeuws75vwq4EiThnbkCV8/habVmAh7TF
	uo64ocnE5tmOuSIbhATbUMeYK6NsdDJG2Iap/44Ph+SB7lmJzvMsyCSZcJMMhhYzRXLQ4HqAj7u
	bjXY2unH6MteimVUxxRKJRbczeWcB38c0ZYGQ1B/Jbu8RRZnEopu65KvcvKtxsK8zvEsUXwuJ8W
	2tdZPF/SWRkG8Tf+Ds4
X-Received: by 2002:a05:6a00:c488:b0:899:915:792b with SMTP id d2e1a72fcca58-89909158069mr7435498b3a.54.1791991482981;
        Wed, 14 Oct 2026 08:24:42 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89d802a42f8sm1299291b3a.10.2026.10.14.08.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:24:42 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v4] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Thu, 15 Oct 2026 00:24:35 +0900
Message-ID: <20261014152435.3637416-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-171387@kernel.org>
References: <20261014134104.3528958-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-171387@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Both are real.  Neither is fixed in this version; both are fixed in the
series that replaces it:

  [PATCH v5 0/6] scsi: mvumi: bound the values the firmware supplies
  <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
  https://lore.kernel.org/linux-scsi/20261014151914.3632701-1-yhlee@isslab.korea.ac.kr/

- mvumi_flush_cache(): confirmed.  device_id is an unsigned char and the
  bound, mhba->max_target_id, comes from the u16 max_devices_support, so a
  reported count of 256 or more never terminates the loop, and that loop
  runs from shutdown, suspend and remove.  Fixed by 6/6 of the series,
  "scsi: mvumi: widen the flush cache loop counter"
  <20261014151914.3632701-7-yhlee@isslab.korea.ac.kr>, which gives the
  counter the type of its bound rather than rejecting the value: the rest
  of the driver already handles counts above 255 -- mvumi_probe_devices()
  walks it with an int and host->max_id is wider too -- so rejecting would
  turn away a working configuration.  frame->device_id is a u16 and
  target_map holds round_up(max_target_id, 8) / 8 bytes, so nothing
  truncates or overruns after the widening, given the reset check 4/6 adds.
  6/6 depends on 4/6 for that reason and its commit message says so.
- mvumi_calculate_checksum(): confirmed.  Fixed by 2/6,
  "scsi: mvumi: reject an out-of-range handshake frame length"
  <20261014151914.3632701-3-yhlee@isslab.korea.ac.kr>, which rejects a
  frame_length that does not fit the handshake page before the checksum
  walks it.  HSP_MAX_SIZE is 48 and the header is 4 bytes, so a
  frame_length above 44 is turned away, well below the 256 that makes the
  counter wrap, and the same patch reads the field once with READ_ONCE() so
  the checked value is the one used.  The counter width is left alone
  there, since the input can no longer reach it.

Looking for the rest of this shape turned up three more, all in the series:
a hotplug event bitmap size that is not held inside the 512-byte event
buffer (3/6), a response frame tag that is checked on the outbound-list
frame but used from the copy made afterwards, with a > instead of >= bound
(5/6), and an inbound or outbound entry size too small to hold the frames
the driver puts in it (folded into 4/6).
