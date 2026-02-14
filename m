Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6F9202F65
	for <linux-scsi@vger.kernel.org>; Sat, 14 Feb 2026 01:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031958; cv=none; b=kPMbzBe64ksW/SsgBlU+xLHvJDw2SlZJhhfISakUetrl3UbBFYGGa3YEy86QKOjrPBEPbWZYHKGMMpaoCH1vTJWw9AwBKTQlgvNhlmqqwrR+syGbUiiZ31v2+tVCqdI2EpJ1FRqbpQFIMHQCOr7XLwM67Gr1X9XAOcompSwEDuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031958; c=relaxed/simple;
	bh=baoYx6QR7n0FRoIEbXK83Lclxt0pfJj/tUAo4hsJmdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WTHbdtT+p7jGP2inRnnE8u/Y27LRh8I0tJ/Pt4mHR05ifjf0Ti/04KybB3rjqt6+x8wQDWz0ZWkE08TuwGNf3uJvNGVwkBqpWJTtXNw5KUWS3nGBAut/j4Fa4wZUYuVpShDfWiD+4D65uutjt13A64IyIRkUgKOXG36yfuFm5Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J9JMk865; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J9JMk865"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-79274e0e56bso14896047b3.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 17:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771031956; x=1771636756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6C9Jxn0OLf2Xmfmsud9RmUJXy/88yPl8N+iMOUt6rC0=;
        b=J9JMk865HnaSmkeRkFR8IVgxnZIDcXzE21TqDCAVIYRnne62e7eEJKwk6fGF+PBqkS
         vh1PXw3mNFxIStcZzWIEDgYYW2cFoPjV2MAxXazpO8aCwrwWUEk112ArQmGXxIDW059f
         I3c3tHn/d/Tu0JtiwEVhI6IbPKUuAvgRKl64fYe3sf7IbhRX/xWePpG9R+oPA6TDrVN3
         A5VX37G1fv9j7Dsre3Lzq0Uk4rDqintCq8bqnpkysnja/xA/VDD3BLbPHZdF/kXfwmTO
         /OolCc+EiTkrLxLMerDIgB6RFs4D1r9MC66RFWgpUsT6XSsqptuSZI3x0ZenN43WOL6v
         ch6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771031956; x=1771636756;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6C9Jxn0OLf2Xmfmsud9RmUJXy/88yPl8N+iMOUt6rC0=;
        b=LyyFstX9Y3U3L3qNbxbwvtJ6dTwRhSptbXpF+zE3u5lYNU2xFzPk9aQvli90GPPPe0
         2z8AmH3AdcSkEzcVirmCx6diEsoDKCnxbakkLopEDyxsy9MJpn17xBpsBak9LvxTWq0l
         8cZj2AmL9TXj0DFh/U3ZWsVbljLatsBF4CQOHJX33ZTpAyj37LYN6gUEJdJqby+xgXDX
         qXJRTrFulL3IOdcPw1I0X0aRlMe61qKiBLt9eqNXyBKzlAf4A4Lv38eNS+/xd+MGvw8D
         JpCVJStevYDexY6jX1JTJTFeRLMSUyMHwI2rM7FsI4/iBmkosI1tnUJ9dvjhxXOcCkaW
         KjRA==
X-Forwarded-Encrypted: i=1; AJvYcCVw+FKyh8AlHvnSbWdGEdbsfqdAZ4sBm1zIRZS0WwC7dY6u6r0/0uzP3zVSfI3M2N2tuXDGsFh2p3GS@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd8I5YyGMQ7604iSeYMM5DXufwm5Q7bQe3fy8PIhxUuFbEUnwX
	9fGmI0JmdkJco4lrOcl+M1S+N+pkAx8fsdyK9uab/tY+KxwiNHjOuSCq
X-Gm-Gg: AZuq6aIIvSeNAGSZJfz8O+bFoWLuXEmlD/BXda7L4PSYWCSSioYyW5d4Dun2O0z8qZO
	BFHQT1rcdcu+RIJ4EfdvAHX5Av5VDAtKk8S3JpFv4PXzPmqvyCfh9PvzP4XDss17VIp5KgIeUvZ
	aEijSp41fr3Fi1BEz9wb2MWsbWlOMwBCP+2pvrlumbXruHQOpHqBAaVPV98tC2T36sdIlrIGzGg
	0pzrfdAUKXYNhvtQUb30Z4gwI+KdLpD+QJ4BQxK8dQDZdlY4YXppGz1pkYCdKiPeWu0y9hphddH
	AjvWEIOe4qqxJktfV37h4SMi3NH3s7D1DNkf+B1u9gYBUC+emQCe6pboXMnJXC2pztDVEAMvaJ9
	azMtHN3Wv0XaLGTYFu4rDZdLnI6QseZT+R6vOWkbARaGgPPkOyCty5H7KxDS/tVqsxcT3p4uzIv
	djS4dgGQu73VMb56n1d+Wwb8KTja0Y6c1ns/a1Hr+3YmEOUp4=
X-Received: by 2002:a05:690c:368a:b0:794:f011:29f6 with SMTP id 00721157ae682-797a0cd516cmr33992927b3.54.1771031956131;
        Fri, 13 Feb 2026 17:19:16 -0800 (PST)
Received: from 5163NRD-SPRABHU.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7966c177773sm77655057b3.2.2026.02.13.17.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 17:19:15 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	pankaj.raghav@linux.dev,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	Swarna Prabhu <sw.prabhu6@gmail.com>
Subject: [PATCH v3 0/2] enable sector size > PAGE_SIZE for scsi
Date: Fri, 13 Feb 2026 17:18:28 -0800
Message-Id: <20260214011829.508272-1-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Swarna Prabhu <sw.prabhu6@gmail.com>

Hi All,

This is v3 series sent based on the review comments received on v2 [1].
This patchset enables sector sizes > PAGE_SIZE for
sd driver and scsi_debug driver since block layer can support block
size > PAGE_SIZE. There was one issue with write_same16 and write_same10
command, which is fixed as a part of the series.

Changes since v2:
 - create a helper function to initialize a large page mempool at
   'sd_probe' when the first device with sector size > 4k is detected
   for sd driver with ensuring atomicity.
 - create a helper function for safe destruction of the large page
   mempool and use that in 'sd_probe' if the device fails at probe
   after the mempool is successfully created.
 - Utilize the helper function for safe destruction of the large
   page mempool in 'sd_remove' when the last device with sector
   size > PAGE_SIZE is detached from the system.
 - Replace while with for loop to 'clear_page' in 'sd_set_special_bvec'
   function in sd driver.
 - Modified the git commit title and message to remove the fix tag for
   for scsi sd driver patch.
 - Rebased the changes on latest origin/master branch.

Thanks to Damien for review on the v2 series.

Testing:
-Test suite: xfs and generic from fstest + QEMU emulated block
    device(scsi and nvme)
  - fstest Config for patched xfs 16k block size [xfs_reflink_16k_scsi]
    TEST_DEV=/dev/sda
    SCRATCH_DEV_POOL="/dev/sdb"
    MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=16384,
    -s size=16384'
  - Generic test results
    Baseline: 6.19-rc8 kernel + nvme 16k logical block size
    Patched: 6.19-rc8 kernel + scsi 16k logical block size
    No regressions introduced by the patch.
  - XFS tests results
    Baseline: 6.19-rc8 kernel + nvme 16k logical block size
    Patched: 6.19-rc8 kernel + scsi 16k logical block size
    No regressions introduced by the patch
  - Blktests results
    scsi and block layer tests with 16k logical block size.
    Baseline: vanilla kernel + scsi 4k
    No regressions seen by the patch.

Link to v2: https://lore.kernel.org/all/20260211015043.2608866-1-sw.prabhu6@gmail.com/ [1]

Swarna Prabhu (2):
  scsi: sd: enable sector size > PAGE_SIZE in scsi sd driver
  scsi: scsi_debug: enable sdebug_sector_size > PAGE_SIZE

 drivers/scsi/scsi_debug.c |  8 +---
 drivers/scsi/sd.c         | 80 +++++++++++++++++++++++++++++++++------
 2 files changed, 69 insertions(+), 19 deletions(-)

-- 
2.39.5

