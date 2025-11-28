Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE64C2144CF
	for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2025 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764349958; cv=none; b=TTXErHbhwl+AaWi8l2B5+UQqQ5pU0Bihc0JGJAn8Ku4RxM1J923f/w3FWLJUdUxxBsyYifI7NCNgSGDwIGqVTssi5YnjwCXsWwZJmverdiEXGhzu1lntzev3C6IGdNMRlPP19/noLqVHCC+fD/CR/YcR7IAez3M11B8chbSVByk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764349958; c=relaxed/simple;
	bh=g3BSPCjjOnGxxBCVOCe92o3NM5RUdh3Z4VIlFuTsNFM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=EKHIQ0VXx7NPHY2TnJD9ShVNJd3hxfb8CZNW6DxXFomSyY+9GCCwkTB63uFpFx5dFypJi7z993L+pm95B3vVtTpuzSip49ZsFVuv4TxOUbeLPkcXc6k+4/hzTtjUp2n87H+IHGATTzJqFHcBg+UfISkD27MWUcioSLeApZvJ5KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ISTsPr/H; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ISTsPr/H"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-37902f130e1so19798461fa.1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2025 09:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764349955; x=1764954755; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:content-language:subject:from
         :user-agent:mime-version:date:message-id:sender:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4y624NKZwLRWYLn9yEjnslUqFCuVYiuH4bJp+HzF7B0=;
        b=ISTsPr/H9G2C91q6R+RUOmp7rwuanjk3/CkMQurnnAchLGrF0tZnHbHoJSKLorX82a
         hkzOVDWd/9XQnsbCXw9c1BhQpAjeyttxVkMTcvRxyYWXU8XUnNf2y4Dk6vXOAQU2/96h
         5dIA+7dQDvAeHR+ckFcJw6OqmrMcfVvnCGoYDA9AdYGHCiwY0+baXGmZDi5yegSQxhz5
         T8qszdKx5zDOPNHYz330WIvbcH81NJ9fwwAg3DJjJ1w5zVdhROIBFZ6Fx79obH4kMRm+
         cTVrQcz59AdSEJRXBa/yp4ud3juaq99136MpA70UpZfEZRJ4mYWUPrhQRaNXT81NDNlH
         ixgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764349955; x=1764954755;
        h=content-transfer-encoding:cc:to:content-language:subject:from
         :user-agent:mime-version:date:message-id:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4y624NKZwLRWYLn9yEjnslUqFCuVYiuH4bJp+HzF7B0=;
        b=kmjvarq9GSCOMegTb5wCiJjfCNwiwq9NLE4hvV6sWewF4Tji7+eeAeQwEPxrfVeeE3
         tbAh0mHeJKeABS9xj68igd3FBuoF/3Bxyg9ZX11L2P/nE5BQv2U9aumgcWTy7I29uotq
         mzMOZFjaqxHNp+eHd7QkpXCRD6SXjP0VEQq1hlSTt0k8yAQyGJe27W9B8EIDClixe8QR
         LDWgC3OZPGQBaeVyrbCSPJN7YRtLhKCExYSUGdbC119m3z4hjBjZYEOGZCSHfTp9p+SY
         MP8DhJPCX2hQ50LjLR68W1v7OtqXHSXaslbV3iXH5BprKxrJbQdQ2LLAbjSQXniRJqMh
         irZg==
X-Forwarded-Encrypted: i=1; AJvYcCXO8RiKkbFHt2uFSSfW3n6pPxLieTMXK9DqbQR+ponJJ8CmsVtJCVB5jYSDtnOh69BSyBwQgqLzRw/2@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2rcenEgEjBl+TtUbKmg6/aLUhDyn4u7ZF1JtnpHefwdyfqBts
	k2FGDcJWQDydEtfMaz95rh9viebPaHnB9OsDsKWV1Sz+zCPS8sOIhT65i1kZpLkM
X-Gm-Gg: ASbGnctkucD+fl+wztBFpbaF0eVR0ctccfQCmLIW/eA+3Mr6YKGuecG9pPLb8QQw0v8
	T8NX3C8wURlZ6QNvBAt3L6Ed6NTKq+DtMbMHtzaiFRrlkk7KhHI1JqMUaQqsnZxnKTUlTPJh8WA
	cOSqZEkR0M90TL4eQgA2sgJ3/JU+QluBDm7VlQDnyQzWKSXDCE19tNoPwlkscb0Grdgikt23wZm
	E3/FktOcFC+pcg5VtGnAvQMnvRCY/O7M3VN2hIZnscvqvNPHNqTo0HtpQGg+Q3OUqEIn7mmTMW+
	1kblkXxxIdNflqU9PM4KZ41bIjvoRs19IsZK6bzn6pSBjBdgzS7D/t6GUWMUqeKgZwrMPr+JrdQ
	gTYs0/F9SAEHsmJmLrDRdcqgofYiIOr1gDnXAgKjxly47MbZBibNUxs+kUeevnTrYorvOQK1xdT
	HysC+8XaRTv5REnChKQ2UnU9BPY6a9KRuwYg==
X-Google-Smtp-Source: AGHT+IHte/5ZtKIMvNAng3bD9glTPppPjaecJN6jmdihJB2Rj4FRXzGEZXaE0bZYZJN6SF6wnuY8FA==
X-Received: by 2002:a05:651c:40dc:b0:37b:bafc:25e2 with SMTP id 38308e7fff4ca-37cd9202816mr62858961fa.20.1764349954399;
        Fri, 28 Nov 2025 09:12:34 -0800 (PST)
Received: from [192.168.1.149] (nat-0-0.nsk.sibset.net. [5.44.169.188])
        by smtp.googlemail.com with ESMTPSA id 38308e7fff4ca-37d2368e40csm10368961fa.5.2025.11.28.09.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Nov 2025 09:12:33 -0800 (PST)
Sender: Maxim Nikulin <m.a.nikulin@gmail.com>
Message-ID: <a221275c-53af-459d-97ed-05a0766adb04@gmail.com>
Date: Sat, 29 Nov 2025 00:12:32 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Max Nikulin <manikulin@gmail.com>
Subject: [PATCH] docs: admin: devices: /dev/sr<N> for SCSI CD-ROM
Content-Language: en-US, ru-RU
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Don't claim that /dev/sr<N> device names for SCSI CD-ROM drives are
deprecated and don't recommend /dev/scd<N> alternate names for them.

/dev/scd<N> device names for SCSI CD-ROM drives are not in use for more
than a decade, see commit [1] that was a part of udev release 174.
Earlier related rules were volatile, sometimes /dev/scd<N> were syminks
to /dev/sr<N>, sometimes vice versa.

Recognizing of root=/dev/scd<N> kernel command line argument was removed
in kernel 2.5.45 [2].

In the docs /dev/scd<N> are recommended names since 2.6.9 [3].
Mention of these names appeared much earlier in 1.3.22 [4].

[1] https://git.kernel.org/pub/scm/linux/hotplug/udev.git/commit/?id=d132be4d58
    2011-08-12 14:05:19 +0200 Kay Sievers.
    rules: remove legacy rules for cdrom and usb printer

[2] https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/commit/init?h=v2.5.45&id=51924607bd
    2002-10-29 00:47:58 -0800 Alexander Viro.
    [PATCH] removal of root_dev_names[]

[3] https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/diff/Documentation/devices.txt?h=v2.6.9-rc4&id=a74e11ffeda
    2004-03-16 15:09:38 -0800 Andrew Morton:
    [PATCH] devices.txt: typos and removal of dead devices

[4] https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/tree/Documentation/devices.txt?h=v2.6.9-rc4&id=8f0ec1f9369
    Linus Torvalds: Import 1.3.22

Signed-off-by: Max Nikulin <manikulin@gmail.com>

---

I hope, the suggested changes make kernel docs more close to reality.

During discussion of a bug in wodim (a fork of cdrecord) I was confused
that docs recommend /dev/scd<N> as SCSI CD-ROM name. The following
thread did not clarify the issue:

https://lore.kernel.org/lkml/20061105100926.GA2883@pelagius.h-e-r-e-s-y.com/
Scsi cdrom naming confusion; sr or scd? Sun, 5 Nov 2006 10:09:26 +0000

If I'm not mistaken, "sr" was always used internally in the driver
"scd" were limited to log strings. I have added SCSI subsystem to CC
to confirm that there is no objection from their side.

It seems, de-facto /dev/sr<N> names are used and I think, /dev/scd<N>
should be avoided. I may be completely wrong though.

I wouldn't mind if you discard this patch and to commit another one
with better wording instead.
---
 Documentation/admin-guide/devices.rst | 4 +++-
 Documentation/admin-guide/devices.txt | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/devices.rst b/Documentation/admin-guide/devices.rst
index e3776d77374b..515338d0e406 100644
--- a/Documentation/admin-guide/devices.rst
+++ b/Documentation/admin-guide/devices.rst
@@ -97,9 +97,11 @@ It is recommended that these links exist on all systems:
 /dev/bttv0	video0		symbolic	Backward compatibility
 /dev/radio	radio0		symbolic	Backward compatibility
 /dev/i2o*	/dev/i2o/*	symbolic	Backward compatibility
-/dev/scd?	sr?		hard		Alternate SCSI CD-ROM name
 =============== =============== =============== ===============================
 
+Usage of ``/dev/scd?`` as alternate SCSI CD-ROM names for ``sr?`` devices
+ended around year 2011.
+
 Locally defined links
 +++++++++++++++++++++
 
diff --git a/Documentation/admin-guide/devices.txt b/Documentation/admin-guide/devices.txt
index 94c98be1329a..c480f230aa4a 100644
--- a/Documentation/admin-guide/devices.txt
+++ b/Documentation/admin-guide/devices.txt
@@ -389,11 +389,11 @@
 		    ...
 
   11 block	SCSI CD-ROM devices
-		  0 = /dev/scd0		First SCSI CD-ROM
-		  1 = /dev/scd1		Second SCSI CD-ROM
+		  0 = /dev/sr0		First SCSI CD-ROM
+		  1 = /dev/sr1		Second SCSI CD-ROM
 		    ...
 
-		The prefix /dev/sr (instead of /dev/scd) has been deprecated.
+		In the past the prefix /dev/scd (instead of /dev/sr) was used and even recommended.
 
   12 char	QIC-02 tape
 		  2 = /dev/ntpqic11	QIC-11, no rewind-on-close
-- 
2.39.5

