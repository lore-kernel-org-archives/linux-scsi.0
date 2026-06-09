Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A2749691D
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 16:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781023519; cv=none; b=s9AyaG6Gga3JGIEuJGo44j7SB7hF/fsZWvHZqEPamGF8yARPFVbV4VxfVQ3IKOsaCHFPRE52HiP7wnG5RwNzbu1truvBufOR9DCAQH6JKfm4yZyn1W8rLRTETiUXhn8wRTlxZf3ubYnmSd/Al4pRZEc+Juf6WDDl+fLBM+QGj14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781023519; c=relaxed/simple;
	bh=8wausxUPOgNLfbiJPcncQ/auFbeylOlT/hS6b0Jagkg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EYdfAii/jiN63X+AMGbG4XM3Xul7sSL+gv0r9iQDUNdCesM4w+STZM6yBIkyM0P8dsIobsV2Vpktgq9c78h+0QC1qbMLh3QWcdV6HvbNeRYh5m1wSOopdwlP42EN1D3REuv+cQw4RiHqVGxbudFPd5nJRdOULc6J+DcAlV6vACY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jw9ziCqr; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jw9ziCqr"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490ae94a89eso49473335e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2026 09:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781023517; x=1781628317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M0k7ym6VlytNaWxTXaJuUlFnXBgEzjB0STL4A4y7nWg=;
        b=jw9ziCqrcapOwsjAWmjsJscmOG/q+W2llTA4TY5+/25skz9FKZopocwKC4kZiOTyCE
         5QKpDlXBppK8zazlR5aEj1FuD6mnLIrNRWb05w5UrL/AJiQgj5Pk55LQelS3az4xGyOj
         W0TOx8/xUol6ViX973NJJNXQG1ARDvJKFz0TS4tVbgS2vS/EADwrn0v+XW7u2+o+pC3G
         BwixQfndX2YDkIusCMOJLjVtg2n5mVBDnot7PfN1V5PEID7Ol926HLrbYh5jkggVIoIj
         wALfXhRJ6FFuxhrirddUEN7+dfNCzxRYxdNXvst/pdyKq+9wsoGEpL+HhGSFEivM1SJ9
         Al1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781023517; x=1781628317;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0k7ym6VlytNaWxTXaJuUlFnXBgEzjB0STL4A4y7nWg=;
        b=VJO7ZKTKFEERzL/VZis2FH49b1Z75NSHZJxN5lcNaFEJGoho+YHtDFuRdL1HEi0PKR
         NG0ghzKAu1eUytJ44tNJY94lUHXvu3knV1vat4MMd9hVYqsciUqkXc+bbmVCSuXHoCLH
         dDCFZU9+UtMb8XvqYEvvF8QUtveAHLA0Z5r9FdmR7gc+94k/mnC4CePGfjysmaVKZDxA
         w35PODjimXoqAt+OwJ8IrGY5i20idCZRHm63xKExHpQl5q+om17aaWwfGFW2Ns9COtAU
         uJNugw/1LeewoDCasMxybUXe/ugU/HW86lBz7k6bJMBid0sn/4BRg+8hOu6EODok4zkV
         Gv1g==
X-Forwarded-Encrypted: i=1; AFNElJ/irTlJEXYS2c2arRs2ZCGirnumKobdHtr9ARJcumRKUKG6svBNJEMOfG5pOrxIJu7+TYS/LMMdn8Xo@vger.kernel.org
X-Gm-Message-State: AOJu0YzsGbsOp1iFVx6xh2MT4YDgjnj33jmBZKTCoHqPaXKOaKs7TGpo
	S26QXQFbLCfO/katCvhk2dKYpF5UvXT0mZz+sB2r/nMa49sik9X94viy
X-Gm-Gg: Acq92OERqsVgJl9i6YryhVUTIcjkvUCHpXD7xKz7oD5EjVecZbcgRfPd/++6p92I1Yv
	fmXuzYSvaAH5BRB0WHVbSSagkNjV/ylE/1+QzOKLtwYAWcS0OPQEymDE8A+Va7OFyGvHnFo4RK6
	/YknoRnrTVwsa+JDKJ5Bh/SWfKaeA7bxNq47EnwjbwL5s1KYKoeOpRGFMKMApf3Ny17DrbyAvKs
	f1AOz4iJRrDPtAct+YvVHGxSTOH4z/MxA6ggg4WgVkhbftkg/Zrcv/y+5eTMyhNQ1+IGojPXkvH
	DiVnRB2MHDu86aeS90jZ78qhPaGuhT6qGSGi7yiA8qd9xVoPhh4SA2to24hPJ4xuFVPOTqBSdLL
	oMahyPZiR+3UAV5nrWuRTBYl2LKheO+C3drZqihk6NKaYpewUJIj1zwnXUr/B3UDc0jzSbQIm1E
	2ElPG66bc6KCfGJqNI
X-Received: by 2002:a05:600c:5488:b0:490:9d1b:f07f with SMTP id 5b1f17b1804b1-490c25b1277mr404826055e9.12.1781023516628;
        Tue, 09 Jun 2026 09:45:16 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcbe3sm59351635f8f.8.2026.06.09.09.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 09:45:16 -0700 (PDT)
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
Subject: [PATCH v3 RESEND 0/2] scsi: mpt3sas: add hwmon support
Date: Tue,  9 Jun 2026 18:44:21 +0200
Message-ID: <20260609164423.2829699-1-sautier.louis@gmail.com>
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

v2 -> v3:
  v2: https://lore.kernel.org/r/20260518184109.770185-1-sautier.louis@gmail.com
  * Removed stale Documentation/hwmon/mpt3sas.rst reference from
    Kconfig help text.

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

