Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792692301;
	b=kvelrGEXamr5zlZKR/oynWjhQMUVMMzyZ84vWeIp4/a+DVrzAm/aTZkNZf06nKMtwi2f
	 sOZM7kuuTM+ze39VNIDV1yxz6daWjopef3VUNe/WWm2BG8AaDKZwv9jkWbmiVh+Fwh1R6
	 h8BauAXHyvJYY33KwAAcLks+C2ejmFv+LHk3Fs5p5w7agdRy0yBQ6L9CPOkZzEIAJ4DY8
	 uNaTgsUZ9qHJmD2stt9gFNgIgR5oD/Cm2ZKoyuQLNLyAkgBPfhj9wPdCENaGkmXIzwzfb
	 ZMQlERFQzwtYxS+ldajEsDA/OPBKskEGcaOn/uO21RpXE9+ehzR1kAW3GZi64r3u2Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792692301;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BQv5WCVuR/wPR2VTHkLrQQEoGRsGLhEHNxeDxB8rPyE=;
	b=zqLe54BRXpPLynxNR2CqFqj9eEfpFulrHzGndXXdJVXUmvB5W1dQ9jFw0D+V7fo+xVOh
	 sde9ldspsPsxgMlc1SirrpD9ILq2VlPooJE3/YChjgw4rxSvxGGeMy4Su+WMSmhGf2kCT
	 eJwUzfJvcFAwtOz8r+mj7r0y1HQ4HM2sdQz2Jyvcq4WczbLdH/H5Qon9cvUl+0H1udSyV
	 u2knZKSI1AJD5o/2Gv2ph459MnFvc2R5aObaZ2XCuBmorPDnuBK2txk/KG6aRWPTzQDFU
	 U+SyGgCz1aU1xEFxnhYVI4WFhvo78hbqh7jb6Sfh3++L757mz0bKNpskQl7x4unSciA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=BwY8v3cy;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FD2606A319
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 18:05:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61FD2606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=BwY8v3cy
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso143851eec.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 11:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792692299; x=1793297099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BQv5WCVuR/wPR2VTHkLrQQEoGRsGLhEHNxeDxB8rPyE=;
        b=BwY8v3cyhLYHcVq8pqykuQcofva2vrCXBXzZusCnAKTQ3r/K7UVVCaCNNbYt3w53Yt
         QIOWH1CR1EkPVa+0qZLB3AK6f+ALq1SclR1b8BGF3mAadXwVdckA3ybv6dpWhxk9HAwD
         p5BAd9a5JdlOT0taw0UoYgyoRhSJqMoAsE0GKLi4Q3qDcbrQjdLbhdVoAfU5K0qQsEub
         SobTYvKuEI9XQY/49TVmrqo8Oks2ov46cDr6dg96yZBE0BQ28RPpHarVudCYZxfWBj7X
         aZqVUQp2IDUa7WbGobirb6hvpGb6N499kjT3DJ5Rg3GF0M8VouAJHH/4ZrneP8qUQAaU
         mmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792692299; x=1793297099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BQv5WCVuR/wPR2VTHkLrQQEoGRsGLhEHNxeDxB8rPyE=;
        b=GnlB4RCuBznf4V6Mb/ACgrxbtFha9+4eAgzpc3X27rreQIbEbYkhu2ZO03u+u/Y0TQ
         0pRpCAYISezjtawo1sshME6atPUIN/Ii6uyg8Sctu71D1/SBjNca9ZuPv5h2SgnXaXhb
         Bo9ktFhtcy+7Hxey8tXXK49dk+44hC3R2PAeHFVPTj47r+W9/4oCgS5Bso6Oefue8yru
         NZofzWLNnwrQQXuj7+0psWCvAIDp8Pe5hdfRh8JpMv7b+8N2H2Bj0x3qsymqRQTUeET7
         lIyGVgF3C5A+AC0XE5Jk31INM3SttvlMeK7JxP/+h5iYvamA64OMp8EYiRhyrx7uJMy2
         h2Bw==
X-Forwarded-Encrypted: i=1; AKwUvBzVU9ov5ueth8OYfw1wuKJ2gE/gyJi3RgoJJ0DgrFMeLH3Y+4j0p18EDIa2g6+qd0NcedJQ7sxEzZEa@vger.kernel.org
X-Gm-Message-State: AFq9FYIPJLkXchQoEMwu4EXbOQJjZRrzpUifL3TUSX2kqHzWlZ+ngZrJ
	e6orkeEE3NFInGd/vHS13VIHMlLIERTB6Ktu5kQuLsvtRNtLQ/L0nI8OA7/uKWOjmOQ=
X-Gm-Gg: AYBFou2TLWBPDJG54f2/ZQBo5F8cJvJmnKuUA4eSuJy5Y/uLhsxHONOxOJLkjieb1VL
	h43TGuTEvHVbYJkUM3kioa/pKsDyCuH4tm5PLRIaDPRx7zVK5pHs25jY/n6oOcOn12Ck3gYt9qU
	nMnk11wcFIg8XC3H80g7lgGtRvBnloUDFXcKL/4YfBKxUyO7/eYqayeIIKUfAwQtEEBynge51Wh
	baRVUIfICjMND7VPb5BJDnP1O5tSJVKIvkG4t7bp9uGMovx1+d3toTkiy+1Kyn/DvgK6+VADbaS
	T7yC7kxwZfhPhRr+vuISyfmB4hkpXMlaOzltZ7dKHcRMXhxftPS9OMh1fEWwBJYqPbfWspVQitF
	2uL71w3jRW+UuXuV+jzec5HE5bLACPZvYyIMhIK/GOxIygGrJ8Jbnzh9tS9wUSLJHI4r3dXo9mA
	+FoRqvYvtQdvHS+pggqtnnW28T0GKfVQmI2A2MZvcu94vyB4KgW8P76UOn70l0IN0QGP6Yo+UyH
	YnXUTHmxHT4aqGOr2/86M06gJrbme4gJvliskklHHB0kQzmjxYMkMqwScNcOwPh9ENnZfQ1I6So
	INw53bYuwegZcC3Pku/0sngS3BAEQzs8w/SFzy4Uf9KjvOjsMN7vk0Rzj6SP7achziuhyNSvgf4
	XCA4ZcQJB0sm4rNk/AP2cpIetB8b6/Px78bXILMiYXlqWc39agWjc
X-Received: by 2002:a05:693c:8105:b0:35e:f4ac:5f8e with SMTP id 5a478bee46e88-3674866f3bemr8431673eec.0.1792692299128;
        Thu, 22 Oct 2026 11:04:59 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cc8439sm18561033eec.11.2026.10.22.11.04.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Oct 2026 11:04:58 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	krishna.kant@purestorage.com
Subject: Re: [PATCH v8 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
Date: Thu, 22 Oct 2026 11:04:48 -0700
Message-ID: <20261022180448.35270-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <524b50e3-cdcf-4cf3-861f-a647a07ae6e8@suse.de>
References: <524b50e3-cdcf-4cf3-861f-a647a07ae6e8@suse.de>
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

On 10/22/26 1:56 PM, Hannes Reinecke wrote:
> But if you want to have this behaviour it would make sense to modify
> scsi_bus_match() to extend to pqual 01b, too; then 'sd' would stay
> bound to the scsi device even after rescan, and we wouldn't need
> to worry about driver detaching and multipathd becoming inoperational.
[...]
> But still it might be worthwhile exploring the idea of extending
> scsi_bus_match(), as that will solve any ambiguity with 'sd' attaching
> to the device.

I agree, and I'd much rather do that than the reprobe. It was my first
idea in "The PQ=1 saga" thread in 2023, but matching PQ = 1 on its own
isn't safe, and I think I now understand why Martin pushed back then.

PQ = 001b has two meanings. One is the ALUA unavailable state, which
SPC-4 5.15.2.4.5 a) requires. The other is a LUN that isn't mapped to
the initiator at all. SPC-4 6.6.1 says:

  In response to an INQUIRY command received by an incorrect logical
  unit, the SCSI target device shall return the INQUIRY data with the
  peripheral qualifier set to the value defined in 6.6.2. The device
  server shall terminate an INQUIRY command with CHECK CONDITION
  status only if the device server is unable to return the requested
  INQUIRY data.

So the INQUIRY succeeds, and 6.6.2 decides the qualifier. An array
can map a volume at any of its LUNs, so 011b ("The device server is
not capable of supporting a peripheral device on this logical unit")
would be wrong. 001b is the correct answer for a LUN that could hold a
volume but currently doesn't:

  001b  A peripheral device having the indicated peripheral device type
        is not connected to this logical unit. However, the device
        server is capable of supporting the indicated peripheral device
        type on this logical unit.

An array that returns PQ = 1 for an unmapped LUN is therefore doing
exactly what the standard says. The trap is set elsewhere, by REPORT
LUNS. Some arrays, at least in the past, returned a full LUN list
(0 to 255) in REPORT LUNS and left it to the initiator to work out
which LUNs were really there. Linux then sends INQUIRY to every one of
them and, correctly, gets PQ = 1 back from all the unmapped ones. Binding sd at
PQ = 1 would turn each of those into a disk with nothing behind it: no
READ CAPACITY, no logical block size. I suspect that is the experience
behind Martin's "there are also storage arrays out there that rely on
PQ=1 to inhibit devices being claimed", and the IBM 2145 case in
948e922fc446 (PQ = 1, PDT 0 for a LUN that isn't mapped) looks like
the same thing.

Checking TPGS doesn't help, because the TPGS bits come from the same
INQUIRY response. The array fills in the standard INQUIRY data for an
unmapped LUN the same way it does for a mapped one.

A command other than INQUIRY does tell the two apart. A LUN that isn't
mapped rejects REPORT TARGET PORT GROUPS with LOGICAL UNIT NOT
SUPPORTED, while a LU in the unavailable state must accept it
(5.15.2.4.5 c)) and reports its target port group as unavailable.

The ALUA handler is already in the right place to send it.
scsi_sysfs_add_sdev() calls scsi_dh_add_device() before device_add(),
so scsi_dh_alua has attached before scsi_bus_match() runs. The only
thing missing is the RTPG result: alua_check_vpd() queues the first
RTPG with alua_rtpg_queue(), so it normally completes after the device
has been matched.

So my proposal is:

  - In scsi_dh_alua, for a device that reported PQ = 1, send the first
    RTPG synchronously at attach time and set sdev->access_state from
    that device's own response. An unmapped LUN fails the RTPG and
    stays as it is today. The queued RTPG and the shared port group
    handling stay as they are, so an unmapped LUN can't pick up
    another LU's state from the port group.

  - In scsi_bus_match(), match PQ = 0 as today, and also PQ = 1 when
    access_state says unavailable.

sd then binds to an unavailable path whether the host was running when
the path became unavailable or scanned while it was. The path stays in
the multipath map as a failed path, multipathd keeps polling it, and
the existing UNIT ATTENTION handling brings it back, as you described.
This relies on scsi_dh_alua being attached at scan time (built in, or
loaded before the scan), which I think is how it should work anyway.

It would replace the v8 reprobe completely: no INQUIRY refresh, no
reprobe, and no change to the scan path.

Would you take a synchronous first RTPG in alua_check_vpd() for PQ = 1
devices? If you'd rather keep the handler as it is, the alternative is
for the SCSI core to send a TEST UNIT READY to PQ = 1 LUNs during the
scan and look for LOGICAL UNIT NOT ACCESSIBLE, TARGET PORT IN
UNAVAILABLE STATE, but I think the handler is the better place for it.

Thanks,

Brian
