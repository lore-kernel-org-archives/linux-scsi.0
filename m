Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DC1335BA
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 20:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313138; cv=none; b=R61eIQD+aBWjGmxX7dCmBekQSGFqjwhTbceCAhKZ+5N+UoDmqhseCMj+gavMUAV4QI/7AwzUshgUK4Z+bSHKHZTHUcnwMQ1mH31EsFtozIK1/m0mMc/MTcGfucDP3X9oZBrzKvFYwCKXG/Jh4x80pSKRbeq0f4SrVKE94SoV83c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313138; c=relaxed/simple;
	bh=5TzrfhnlpZfuxC//QYNeBHxmJqS3+OrsHOQnPFRebqI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jUV8PhX7Th4GTVVEz9T1/3ARJeMHaHsllnX+vU6PM+vkoFfbcPS0/baDBFK5U0bSsbbWrwbAQfqNnM2gNwiTeAynS5InmfeUIDCpstXrpfVgOM/2SlZmdRFnh3aD+uqPugi6tNjQcOPKRHK2WYGTlXwrOSSJlXnQiE7ac+Tghho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=RMZ+aFFl; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="RMZ+aFFl"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64312565c10so9763806a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 12:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765313133; x=1765917933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0AVUgcslW//k3OenyqHygRYimxckKKjixyDJLIFwKxI=;
        b=RMZ+aFFlOgu4r/gN7vwoRFnOnyDPb6ZA3i6vekB9142Tm9drKAphecRVmthAN1riV3
         zzgyRXIcJfaLq10wfLmClCdi3Oh2tUdg+SrRWJvx6iLODgRd8f8YCEasEqM3e7poMyHy
         Ovp1KNOrnUq/o8M//77w8NsHWaRuSxCu8m8UvuYcgFttMXrYYu2YxmmMCbJLpEXBV3r9
         ga5irOZmJV0kkkK9d5dYtWLJ11eFvh6ObdBnVGsFwFYNL+3bvS3iK+K5PsiYFl3G1lVQ
         vBq2UzEcbTNCYGiNrqz0GDUnshyxESFNmpMR+r/r4Au7ucggKn6Oryw7h+spe8nY2jHc
         1x0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313133; x=1765917933;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0AVUgcslW//k3OenyqHygRYimxckKKjixyDJLIFwKxI=;
        b=cFjNIuPVst4JL7tcQd0Yz/h1B0tqdkFgy9AnG9bwKaI+/7hAulQgYqOKUIDhugJlFr
         UM9/XD82Xz6W3Yy65sjDiLzjXY1CWZJj+BcV76mh22ONJvuvYpEiI6BpaGOoe6wQlbv2
         DzzmS+qFq6NLliEEK5rT5gJ9oaPx6thjhDYGQ5dD0c23ZnhBpUoTecFcC5ZQnMk/Iv/g
         85fBkIwLo4PvHR5LQWN+PLDG35YWXXeQMc/dsP/WZ4rRocFZ8CYBMOjmQo4CFUs1SbsO
         HJ+nKiOdvqSEuBe7dkU0Enz1J8cR8j1fEp8kMIrZCzQMaL3aGEYAs/QU0+tukQ5OFL+a
         2VLg==
X-Forwarded-Encrypted: i=1; AJvYcCWPG/tyXKnZ/BIAdUVzjivtCkbe8K54b1hpX45OZdukEUNWd5nMyaAfdoZdWzQJRHV6MYEgx5wIy/XF@vger.kernel.org
X-Gm-Message-State: AOJu0YzIritGcaL26zxgyGdFyLvX8eSzfzU1h+RkxuGhoXrb5rmFjSyW
	7EeUcfWGZ6M8SnCuODSyt0XG6H+S8XAirDfMDLg8MGZXsBz3Dwa9qpG8uTENx1oMWZY=
X-Gm-Gg: AY/fxX6whumJglL+88aIRnWL2pVetv9B6cORcWKV3QhPWVU+VCSj0Vnz2QSUXUG8+k6
	V2aWM+OZQ8IXvzhEq6/IFSmmN8tYwaPdUO42yMp/GOUt54bMlcUyEASHnGMZns8LCtOESHffLgv
	O6POm482QEDxYgtn+w+s6VvTgT7KMQj0+3+aKVeGelVGFzyXeWLM/Q0zjpfHUMKsGOwmCMAcTha
	Ud0EdR6/uCq4hI7jy+3lK/qcSdjK9TJeQ++byqRc2b3hGIGf7nVqfEj6HB6H4fxEluS/u821qd7
	Utnwpzu62AMfZXVWgQzb/h+/FhI5CxG1abNhOwEGwYiIE1onARz/mNHOVBSTcmfEdkS/tBmSMWM
	3/CYg0pXimU49F6HjHGem91xdff2XSvRTU/vDzrskyRF/cR5OYO143cGA09+w2QZqcPJDKaIW+i
	AynWlcqK9A+o9/i+zy
X-Google-Smtp-Source: AGHT+IGqggYnfr0+QxMM8zfY3hyXNGWMhj0jkdtknLO5g8cdRrHCDqwIIbpimUOgPk54yaBdXGzZiA==
X-Received: by 2002:a05:6402:2803:b0:640:b3c4:c22 with SMTP id 4fb4d7f45d1cf-6496cbc45c5mr198938a12.18.1765313132699;
        Tue, 09 Dec 2025 12:45:32 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-647b2c5575fsm15228708a12.0.2025.12.09.12.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 12:45:32 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	=?utf-8?q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 0/8] scsi: Make use of bus callbacks
Date: Tue,  9 Dec 2025 21:45:01 +0100
Message-ID: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1409; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=5TzrfhnlpZfuxC//QYNeBHxmJqS3+OrsHOQnPFRebqI=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpOIpOr8yhy+68Ss54hUecScxE5EzHaerXX9YRF yW0ZU08geqJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaTiKTgAKCRCPgPtYfRL+ TqcOB/9KoBNS1XVsBMIgO+/QTdkHpuGclHb4LKpOE7yhirPT/7sHhWYCke9B8jE1+xXkp6IbWcd 8ti/VIEydmCpf8EdBac618hsdbn9tKGqJ7jXVMLUpJOSIdRDx9rZ0I9AMGPNue7THWAoWOv2/QQ /dk++NJf4KeaZ1Lb8tdQ1b3KWnI3QaLsU/gnYro6bCglnwO0x+vCkXtABJRlMFkX6IQ6V0RkYIT uAhezL+9goD8mVwIKre7RYIoUpikfhv1fUEt5SznTxaubXlH86zh3+a7ZyheXY2nZjbENiqQv9T 537SC6vCzFQhhMpl4N5XX9y2pV/H3Tm+jUu6E++rpL+nOqtM
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Hello,

there are currently two mechanisms to bind a device to a driver: struct
device_driver::probe() and struct bus_type::probe(). The latter is the
newer and preferred variant. This series converts the scsi subsystem to
use the bus_type variant with the eventual goal to drop the
device_driver variant (after all other subsystems are converted as
well).

This passed an allmodconfig buildtest on amd64 and arm64. The intention
is that nothing changes for users of the scsi subsystems. 

Best regards
Uwe

Uwe Kleine-König (8):
  scsi: Pass a struct scsi_driver to scsi_{,un}register_driver()
  scsi: Make use of bus callbacks
  scsi: ch: Convert to scsi bus methods
  scsi: sd: Convert to scsi bus methods
  scsi: ses: Convert to scsi bus methods
  scsi: sr: Convert to scsi bus methods
  scsi: st: Convert to scsi bus methods
  scsi: ufs: Convert to scsi bus methods

 drivers/scsi/ch.c          | 18 ++++-----
 drivers/scsi/scsi_sysfs.c  | 77 ++++++++++++++++++++++++++++++++++++--
 drivers/scsi/sd.c          | 25 +++++++------
 drivers/scsi/ses.c         | 15 ++------
 drivers/scsi/sr.c          | 21 +++++------
 drivers/scsi/st.c          | 22 +++++------
 drivers/ufs/core/ufshcd.c  | 22 +++++------
 include/scsi/scsi_driver.h |  7 +++-
 8 files changed, 137 insertions(+), 70 deletions(-)


base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
-- 
2.47.3

