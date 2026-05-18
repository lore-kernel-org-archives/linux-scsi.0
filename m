Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE0C381AEB
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779129686; cv=none; b=dQGxc7UtibxsbZlgAcX0vUrg1/02YhSw3checRmcp/E1VyVWEHbHqldn3Gs480QIVO4sQIHFVhylvFPetzx2wKz+OE9jL72bsjTc+3UgBNmctpoeMC1vL/FFzzCafA6tMQLCmONcwEfngvnffqRSynfzYQ24knbRan9/SNIlqso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779129686; c=relaxed/simple;
	bh=OzEYtXnV85GnF+LqOcz5UNsNvTkWQ53yW9dRfFpIzTo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ALowmN2c3RPLU0t66KSHP8BaqmYUgJnNAoqNVzZnl5x0XnlYwrAAfTRuGH0F4Vl1khG44w5KWHR1HtZWZAN5ffpi3PxcUgfiMlwRfngA6+kK9M6KBt0TNOj65WwiGfDW2bUSxlNbbHcU/c0YoJRcSXBnIy8/TJzp4bkxpyDJVKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jo+j94yS; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jo+j94yS"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-449de065cb3so2533138f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 11:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779129683; x=1779734483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U7pmfatTAGCFopvwOxekiavKhWvJwuVBKlcaz6/af+I=;
        b=Jo+j94ySkMhMW7OIVytFRNRxxPNESIum42HrGU3sfwOrtDF6tfKSasKcheKgfyruhL
         EkYIriQgzR8e0NrFAe5n3yuUwSqUHN9cRN9foad99O1j4cHnjoWkdhKAVOf5eOoQVdfE
         qQQpZEMKgYfen1tFlHD97dtCeZVF85YZFIALrGGzBC68PGKkZte9DqDcYGmacElXKtex
         8JFT+qINcM/zr2yqJCIyISp8Jm8JE2fsDNQ0OMfjWuRqHPLmFylgHYOyjGW/VL7nwYQS
         uXkoehVWtEn+ZvLKzcSAd+vgJPY4K8QLIzzoeMT/QfovEGFiL58gbGXNWvnmRPlxAchG
         NKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779129683; x=1779734483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U7pmfatTAGCFopvwOxekiavKhWvJwuVBKlcaz6/af+I=;
        b=DFhtHpM/cOgRw2lWy4+AS0RYfpx6SDOYWbEekyRUTrWbJ5PAWDEsN9vrGmQ6N9aMsU
         wXcZL3wfx5GNxou4Cw+pVU9zUvyiZwbFR0Gnao7LHilbfGyb6+V978OWbeaYxIftwZri
         3n7Llx3lGRQdwiTkHEwPpQ8q+hA4zYhqsFx96e0KZRAQGR6LMuFteDT9PCSft6iLlyI3
         RiqN/U/1Gf9jhHAk1cC5Hi+AT0u1FyalFS+9c1zluqKFolBJ0nUOimvZdCPBxRuWU+Rt
         vf6ZwHq0HBlOGddMKnQ4RytN72zBP72TD0gX9SSPJmAKxcmttrXRiXumbM2sTljH7MG5
         eu+Q==
X-Forwarded-Encrypted: i=1; AFNElJ+pP0g5Y2rIDDOz8B/RDIfBXxGimTKN3Tbt5jOZbrX5fOyLKq2fJ27xDZr8sBzgFKDgzSy6VK+XxObc@vger.kernel.org
X-Gm-Message-State: AOJu0YzLJdqkSIAzsC4SI8fpUXZ8PZNl6qOp6DWnyGpEahyq958awSqa
	SQv8H4kZMjVXViify9a+/C2dUHYeXqC30Q4TYSewDSX/i7U5Ok61/Jqe
X-Gm-Gg: Acq92OEMBsfm9imfR1HQ1t1AQysXTQzeWgP6oMGwSuEpN0BPGeVn0yb1rJdwhDtKcaU
	vr43KOPGnzHOQMUPE1Tt+EvH3I71ixh0hz/JVsRupgDlrWEq1aUUEkl7SLxJ7Bx8crg+2ZPLKrU
	Jv/T9cDMvb/6W2MiYh+XUBQVo+lQ2LU7fUddP9mEt+nOwqa1w7QmElNWJD4FzQMsUH14dt6wuCy
	dAKo28mFc7tzMglb0hSWMJ9PwJa6sAeLME9a/vh/9I+0Fdaxt6yiBIf1NO5B9EXJ/Wt6O1khY7T
	0sJXww4F5+9fgl1HHiwr7eIl/rCZpfxmJBNFq0xcMSE7m7/3kDzuOf6oWKFGzmPLEFrCYWmJKLM
	YZgxhLpbSIm2D3BmRgzqWrGW6tghuFY2nReHbv93sV53uBSLHJKHfelH8UpMf6veUjJe0hqAtCx
	Tg1t1cunY=
X-Received: by 2002:a05:6000:2902:b0:45a:e3dd:586b with SMTP id ffacd0b85a97d-45e5c59a269mr26461049f8f.18.1779129683293;
        Mon, 18 May 2026 11:41:23 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e768c4fsm39305594f8f.8.2026.05.18.11.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 11:41:22 -0700 (PDT)
From: Louis Sautier <sautier.louis@gmail.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] scsi: mpt3sas: add hwmon support
Date: Mon, 18 May 2026 20:41:07 +0200
Message-ID: <20260518184109.770185-1-sautier.louis@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Expose the IOC and board temperature sensors of LSI / Broadcom / Avago
SAS HBAs that bind to mpt3sas through the hwmon interface. The data
lives in MPI IO Unit Page 7.

The same fields are exposed by Broadcom's userspace tooling through
the /dev/mpt[23]ctl ioctl path (typically root-only): IOCTemperature
and BoardTemperature in lsiutil; ROC and Controller in storcli.
With this driver, sensors(1) shows them unprivileged:

  $ sensors mpt3sas-pci-0200
  mpt3sas-pci-0200
  Adapter: PCI adapter
  IOC:          +42.0°C

v1 -> v2:
  v1: https://lore.kernel.org/r/20260512214703.655633-1-sautier.louis@gmail.com
  * Dropped misleading Documentation/hwmon/mpt3sas.rst.
  * Dropped inaccurate concurrency-wait figure from Testing;
    corrected empirical data is in the on-list discussion.

Testing
-------

Validated across three Broadcom SAS chip generations. None of the
cards had a board sensor present, so the testing only covers the
IOC channel:

  * LSI 9500-8i / SAS3816, SAS-3:
    - hwmon device registers as "mpt3sas" with only temp1 (IOC) exposed
    - IOC reading matches `storcli /c0 show temperature` and
      `lsiutil -p1 -a 25,2,0,0`
    - rmmod / modprobe cycle goes through the explicit
      unregister/register paths cleanly

  * LSI 9305-24i / SAS3224, SAS-3: same behaviour.

  * LSI 9211-4i / SAS2004, SAS-2: firmware reports both
    *TemperatureUnits = NOT_PRESENT, no hwmon device registered
    (graceful-skip path).

Not verified (no available hardware):
  * Path with both IOC and board sensors present.
  * Fahrenheit-units conversion.
  * Sub-zero readings (signed-cast path).

Louis Sautier (2):
  scsi: mpt3sas: add IO Unit Page 7 config accessor
  scsi: mpt3sas: add hwmon support

 drivers/scsi/mpt3sas/Kconfig          |   9 ++
 drivers/scsi/mpt3sas/Makefile         |   2 +
 drivers/scsi/mpt3sas/mpt3sas_base.h   |  19 +++
 drivers/scsi/mpt3sas/mpt3sas_config.c |  36 +++++
 drivers/scsi/mpt3sas/mpt3sas_hwmon.c  | 200 ++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  |   6 +
 6 files changed, 272 insertions(+)
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_hwmon.c


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
2.54.0

