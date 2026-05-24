Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404E02F1FED
	for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 21:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779656765; cv=none; b=rRXPpb+w1Mg3fYa9qiErnBe6mGuZJnyE+HsEHclTfA6Y1HG9/EvJ0+x5y0R3Yb4Fa63ecQt4EI1eFjC2u050DwAT1uOmDwxmOY48hhX+v+Wf0ntHGcVbattbJSj2r1/DNsxmOLgG8lwVfdItP/J9ppQt8cdVonHGufJCXiZJzd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779656765; c=relaxed/simple;
	bh=8wausxUPOgNLfbiJPcncQ/auFbeylOlT/hS6b0Jagkg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=scGbH/ghXkMPmERhSpsTJrOW8DSYlTfrHWu9Uuau9HQvcijUBn5vth6bKj0D2/RXKGL97m9QdXUqLtUMTlfglMFAKFKQMvNhvDf5XYHVqfD6mKARiPf4xhtufZ/TjImpnK1fNI9cR0qXFNymruuiq6HE4Vosm8Wgby20b/5W5lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TuRHHHEr; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TuRHHHEr"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4903997fcb5so32936435e9.2
        for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 14:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779656763; x=1780261563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M0k7ym6VlytNaWxTXaJuUlFnXBgEzjB0STL4A4y7nWg=;
        b=TuRHHHErJhkfeI4naF+vvpjtJAzeH1dc/0n99drgWSi9KrtS1GdenwTWCx7rxYBXCa
         1gsP9R+BdVGxhyR0/BJYTliTUxOX7/8u53qR4WVvryFVJReVMXJp4LvDDtic8bLSMwnP
         hpzQsrjHr8S1ahZboIQxxgb5ZPsByWSGx2YlYjBbWqJ+HwoQ5VdGX5QufuHM9/f7MuXy
         qKioh1+/6I5g4lS6b25Sptw1Kxemf0JyzJg52odr5mP8vagdmUSAwIMDYbis3TlWuSwx
         Hnsmo9Sk2H1eYWyr25PFpBzOCMMZwcDpdTLBXCLAP9yEvPTe6TmPfF4xXtDe3qbPX0U/
         WbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779656763; x=1780261563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0k7ym6VlytNaWxTXaJuUlFnXBgEzjB0STL4A4y7nWg=;
        b=pUW7XObeeWa0nN1b8m2QCar577FifKfeBtYmVddwk7PsSfQrvK2bFSCXxtpsMERzWp
         f/P3bD7G5hs1r61dijNlvyAPVdlXu+Yk/O1buSypiS/frx3epsYM7+mPwVpXh6AaAB0e
         Iv+3pyT84vr+id52ZJwMvPMIjTZVySCDU5w6Yn6fNvbOVFeDM6RV9Y9ELEcjdEgestu4
         P7E2UzcVdFI6Rbf44grRbrq78+naSg860kNFUizI6QYmBNKwK9TthD54YDIfHoZlU9h3
         QaLaMoJc93SSkWIyRbimAr/OhHSs4wac1VvZPmnCjACHtQ8peUUSfjqe26rYA4VFPX2M
         hUxw==
X-Forwarded-Encrypted: i=1; AFNElJ8EO97wQj1jwvvG+iRkTTIjm5vyk0Qvzrvr311H66oGzGGlTmG+NhRyJFGRcotmUJwjMppNlgn+GJFF@vger.kernel.org
X-Gm-Message-State: AOJu0YyEhoBxxVFT3/afueCNxtWK/jPs17qMQxKou7EVqgAMTdw6SHUL
	hJxzqmYCJa3CXWA0a0YQef/nHcQ0fJAT0rtBssMsqhPgQ4q5xblj64TO
X-Gm-Gg: Acq92OENImu6bY/gljRfF/PTXKEKN4UMuMyLDbKgYJZJ3PeJVC5KsIMqlNu37W5NXfw
	V7QuccZNdgKswI1oYsTFLFpxauW4rZh8Gjc4ae0S8BdZWkWB1sCDnlp6N19+UyLqX5kv7noe/rb
	gU3NPQKGS7yavD7K2pf8zXHlLGa1dhqCRWVwF2AhzmPSSuHvG/yBRQ72+Sbel4sQSwNbdfDUcUk
	HTETyNCMi37GZ4VWPHFuZHZtz8KxGkYnZccT71uVxxmzJISxZocOyTA0Ad3Q/JIQPWzKoqPHx+x
	OWYB7NOXPMaO7W1G7XPU/oASnvMlX06vqF8B/yB3QQcogP7Of+vpz4mVPstVQ1CsVFXdlhaBT6j
	39f5r+kbIFzYuZguI47XbejcT8BCaZuH+1XUN/XWezMk2Fo3JX6FSIHRFROD8yZLSWVFSsZ8sRr
	IpJc3/3vc=
X-Received: by 2002:a05:600c:4f0b:b0:489:1ba8:5bf0 with SMTP id 5b1f17b1804b1-490426c5b05mr191379085e9.21.1779656762434;
        Sun, 24 May 2026 14:06:02 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49059fb42dasm85170925e9.7.2026.05.24.14.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 14:06:01 -0700 (PDT)
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
Subject: [PATCH v3 0/2] scsi: mpt3sas: add hwmon support
Date: Sun, 24 May 2026 23:05:43 +0200
Message-ID: <20260524210545.1333637-1-sautier.louis@gmail.com>
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

