Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6C0245020
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2025 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765894641; cv=none; b=KX0UwFSRlK2ERVufu7XFPxxZCvj8ZAXtQoXCR1EB/oVQI0oiDIEgzGOAKaQxoF8X1eGSgCJTAmEoxfmT507mxOrSHNb6J0y4Cx31gAp9I5bJtR2sCDkk7jc3c1XeBAcd4DwdnE40xG5gI2OjGFceU9yJVo9cnkKAi7I6xkRLnc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765894641; c=relaxed/simple;
	bh=jxyxVWryLXdewUTdvf3TJcYXWU+G97kw3pB/KMLo9fw=;
	h=Message-ID:Date:MIME-Version:From:Subject:References:To:Cc:
	 In-Reply-To:Content-Type; b=gMpfSK5b/dvxCyDc/PdMpgvLH//LmDfJsw6hnoRViQnQX5zZ+NLm5kYIrL/p236hFJaBlUTyju2cwFMpM1nzDSYsIu/OcUSWwoVUruwt7Bu4wdf57xG0XrPeZvlNYh7TS5tKm6JDIONLpIYY6wHewBqGLaU1MoFPjNzsLc0t11c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fDDra2gy; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fDDra2gy"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5942bac322dso4894813e87.0
        for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2025 06:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765894638; x=1766499438; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:to:content-language
         :references:subject:from:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=pBec499KaHMN6ajq+mD6FMl/SnLupUZN19aWhrOOyrI=;
        b=fDDra2gy0xa6Maj8wY99/M90M8hRvPd+k9RjoTEggiBvtyCYzO8Rw7L/ODraYTEbbu
         W32PyKZN5epqJgfQlf1nFVFw7CKW7N2VFGjkf/WwycZWeDp2HD8q9srKXhCPceY23Tdu
         D/nNojaHW6LASYD5L15soANZ6vea5Zr2QfMray6yt2uT4v5CXe3JlRzNdehvJpd2jZYE
         r7rCq2b70rT/uBXd0oebiip/XDHxToJyM1Wb8yx7BOJ1xOYzGsPxkJ+N24J4eE7sls74
         nDcATS89HArDLeQXKAH2Z/93y3+YLPkcscNf8OphJnXfUes9o/DZ8QKCI0P9RLoczH5F
         YM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765894638; x=1766499438;
        h=content-transfer-encoding:in-reply-to:cc:to:content-language
         :references:subject:from:user-agent:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBec499KaHMN6ajq+mD6FMl/SnLupUZN19aWhrOOyrI=;
        b=xE/pzhJ7QGtXpSVguVmGOr1kVX1/oDJA2hYeCf1U8PGt6UdRKVfSe8Bi3jZhG+25Lz
         uecXrsqXOB9mVFQhDoc7em4BC0T7jOOnTe7FjSqyzXbjMDIpZwQBN9hSGWWe0z1Is0OX
         a6OCQj8US8B/r+/EWKRyEXHYY1XmIU3xeY0lbydGdn3ZqvG/XDDAYnuDSENlhXvFLr5O
         PtsVTAEGksZxQXDvel6aJiJTm4MWh2E3epDpmxQnQljd3N70XyLDIjQGUddTVTr6Ecgr
         RIDSGmQHTS8Nh2O2zVmVeklwnOJltvOI4RL/fFkPYzQhfkxynRZu+xiWCvVKgpVdYgOe
         Figw==
X-Forwarded-Encrypted: i=1; AJvYcCXL3VYQDGpkESp54txA2R2aPFJdrFMb0JWnSwzHJeKmZpSFm5XQtVneSWJ2DPx18dOHKvZ7ZjNfnxpa@vger.kernel.org
X-Gm-Message-State: AOJu0YxS/1b276vRdwv/U3v7UmSF0oCTrQyQ/LMKR2+n1vtWcUmSjoFW
	bRurKTckPHh3kwfzFJWdjlDGSmTc6RgzzosHYQxp5fAQ7n0fd64QD/A2
X-Gm-Gg: AY/fxX5ZAM8q7r9bHbgCAs2ni9nhbRjY8PXMKchykf95Df28E412nspmYmgW9CvWwhW
	03SXa21IBZ/3pRVZLW6W6Qt81u/LhDhQZAUbsphtfzwgu3BWFVRLpjyK63OL/qA1ugChEXQLRjY
	/3HReolrKFUZeXXSezNAfp0uOcDBeEFu3eZy8B94oQQWDiXAESOVlSIuOndPnx8NLWIYNPBdHcZ
	iaIPY5+kTIhDEzQPMLRwVMYPSqJcZ380gxobqlr5Z89YhOy9cf3kGC58t62zdf7gHgrXcLIX+ZE
	1LS0exjumuuyAXPOhExpjNWYBQkxvZlDy2hmyeUjjVDHZoSb23tkwcxoXQdGn0Fuhu+/udLpnSN
	stH5/2evpRTNXXbabYTGRKFgpTJQ1P7GFx13a7VPqlj2bqT6po595BF9yL7J5U3FZQ3FDYkDjdh
	lMUQt03FuXCucuHUzwXPfVp643BIVsc6jDjX4pybH/QJr5
X-Google-Smtp-Source: AGHT+IECzB8wZ6HqfjopDqmXGNgF3m2bTGkCmXboQK1CslrkKLddE94RR4VBthxbzSBTTxtqVMzU/Q==
X-Received: by 2002:a05:6512:3b8e:b0:598:eef2:e209 with SMTP id 2adb3069b0e04-598faa01680mr4980176e87.5.1765894637269;
        Tue, 16 Dec 2025 06:17:17 -0800 (PST)
Received: from [192.168.1.149] (nat-0-0.nsk.sibset.net. [5.44.169.188])
        by smtp.googlemail.com with ESMTPSA id 2adb3069b0e04-5990da5dd0dsm927794e87.78.2025.12.16.06.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 06:17:15 -0800 (PST)
Sender: Maxim Nikulin <m.a.nikulin@gmail.com>
Message-ID: <f0a3e0aa-e4f9-41d3-8931-57837831d136@gmail.com>
Date: Tue, 16 Dec 2025 21:17:13 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Max Nikulin <manikulin@gmail.com>
Subject: [PATCH v2 1/2] docs: admin: devices: /dev/sr<N> for SCSI CD-ROM
References: <aSuj66nCF4r_5ksh@archie.me>
Content-Language: en-US, ru-RU
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <aSuj66nCF4r_5ksh@archie.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Don't claim that /dev/sr<N> device names for SCSI CD-ROM drives are
deprecated and don't recommend /dev/scd<N> alternate names for them.

/dev/scd<N> device names for SCSI CD-ROM drives are not in use for more
than a decade, see commit [1] that was a part of udev release 174.
Earlier, related rules were volatile, sometimes /dev/scd<N> were syminks
to /dev/sr<N>, sometimes vice versa.

Recognizing of root=/dev/scd<N> kernel command line argument was removed
in kernel 2.5.45 [2].

In the docs /dev/scd<N> became recommended names in 2.6.9 [3].
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
    1995-09-01 Linus Torvalds: Import 1.3.22

Signed-off-by: Max Nikulin <manikulin@gmail.com>

---

I hope, the suggested changes make kernel docs more close to reality.

During discussion of a bug in wodim (a fork of cdrecord) I was confused
that docs recommend /dev/scd<N> as SCSI CD-ROM name. The following
thread did not clarify the issue:

https://lore.kernel.org/lkml/20061105100926.GA2883@pelagius.h-e-r-e-s-y.com/
Scsi cdrom naming confusion; sr or scd? Sun, 5 Nov 2006 10:09:26 +0000

If I'm not mistaken, "sr" was always used internally in the driver
while "scd" were limited to log strings. I have added SCSI subsystem
to CC to confirm that there is no objection from their side.

It seems, de-facto /dev/sr<N> names are used and I think, /dev/scd<N>
should be avoided. I may be completely wrong though.

I wouldn't mind if you discard this patch and to commit another one
with better wording instead.

Patch v2:
- More verbose note on removal of /dev/scd? names.
---
 Documentation/admin-guide/devices.rst | 5 ++++-
 Documentation/admin-guide/devices.txt | 6 +++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/devices.rst b/Documentation/admin-guide/devices.rst
index e3776d77374b..0dc8c5b98e30 100644
--- a/Documentation/admin-guide/devices.rst
+++ b/Documentation/admin-guide/devices.rst
@@ -97,9 +97,12 @@ It is recommended that these links exist on all systems:
 /dev/bttv0	video0		symbolic	Backward compatibility
 /dev/radio	radio0		symbolic	Backward compatibility
 /dev/i2o*	/dev/i2o/*	symbolic	Backward compatibility
-/dev/scd?	sr?		hard		Alternate SCSI CD-ROM name
 =============== =============== =============== ===============================
 
+Suggested earlier ``/dev/scd?`` alternative names for ``/dev/sr?``
+CD-ROM and other optical drives (using SCSI commands) were removed
+in ``udev`` version 174 that was released in 2011.
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

base-commit: 464257baf99200d1be1c053f15aa617056361e81
-- 
2.39.5

