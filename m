Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E15C2D739A
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 20:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761596630; cv=none; b=YGokCUkd1UpjMfuwZFh3SmBuzDRIFxnh6lX4hw3nj0u5Uzecv2ZA6kchQsiE0LkAEW+RBWtER8fFKuwOrebO47O4txKQCFHr6XHGQ28DbSAsyQnkbH/vmlUJf4LiuGPQ3fdKawL1l6/FKlFlAISeebhuJr8HmSShCUmZrQqApXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761596630; c=relaxed/simple;
	bh=eNQEDqw7OjskM94an5ecGHYPY0xA4Ir2dTEeEri0xOw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PsmoB1wNo+BUrHKXQUmLgjdHN388dii1qKw/1Lj0RopLL05QrO6n7zmwZ59v/mnmOWcsGl+emhTryVSe3zjNhG+T/oSkxuQXLDC2SAU8G/YQGf74il24pyAEzXDuzVCLN8s/DV0VDS2RSATG4gl00VQgmyNcXFtybZClvowCntw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=EtKYBrZm; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="EtKYBrZm"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id A68EF24002A
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 21:23:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de; s=2017;
	t=1761596626; bh=RZnGNMkbjELii2SDbcECmppAdYrlJFmo47Ja93s+ljw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Autocrypt:OpenPGP:From;
	b=EtKYBrZm9yLSk7HfUOFlPZdirfGqy+yVYZh1t4JrAsXH95Y7fn5BwF9US4z8dFUzX
	 2NqZRTaBz/bvlLBAgLCoJ0cZO24sYfxhb6e+9SyhdO7GRDkJMi55B8Vpte5Lqw87yW
	 e4pWIRsP/FPHFFGJM6773xIsFh/EMt5VwvHlLSnGIfwxzlOcfsHUyMySKuy/dt7bSR
	 dXAr2FuBCY4xSTI7sB61lRd1qomARPwrFMIIlWnwwdmAk4pbi8SJOLJRGn7KdpURuW
	 z96IahZ6pmlE5tHvC4rt6Qpfie1UdNovBhLpGtV1ey0Nh7YPOnGmdBTE28bmBkzcUk
	 k/+l5PaNMVbag==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cwQ293Hmdz9rxF;
	Mon, 27 Oct 2025 21:23:45 +0100 (CET)
From: Markus Probst <markus.probst@posteo.de>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Markus Probst <markus.probst@posteo.de>
Subject: [PATCH v5 0/3] Support power resources defined in acpi on ata
Date: Mon, 27 Oct 2025 20:23:46 +0000
Message-ID: <20251027202339.1043723-1-markus.probst@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1880; i=markus.probst@posteo.de; h=from:subject; bh=eNQEDqw7OjskM94an5ecGHYPY0xA4Ir2dTEeEri0xOw=; b=owEBbQKS/ZANAwAIATR2H/jnrUPSAcsmYgBo/9RUJMpoiwNSMZetUOHvqdaW55KtRIimwc+EY LKIHJ4K8WaJAjMEAAEIAB0WIQSCdBjE9KxY53IwxHM0dh/4561D0gUCaP/UVAAKCRA0dh/4561D 0uqBEACsmVJ+ByfXzmqnli7w9clQJ/562RPZDYTERk95FXI0SAN8K1F9KSv6LFe+Pmvqrz+/I1g qydZuXdOEUd5tHPW/NlgqPc4wSAzOcQISZUeiQMSaizFyLYA0Qw8WIm236TQl6T+/EA+bOZheQD Dmn1pLd4i5vNlk5fScv7lZs+se9mRsviUERerBc9AmiuCuLbIPMEo3zZeN1ZV77+h1sg0gXUYDM v7SvB/cXT0HxEAM24hAHHY0uAw+0bT4ENMoPfTK231a4w3GxIys0ernCY9+WrQHKQt+qHFvgPiy KQrOCU7Y47VDlBhdGOJ5Zfa8H2+YQULZzrqQRZpgYgP+nHpVpnVjOvQqwZbmQ5Zm+6C2hvP0I6X 5/MgWFbMkAKLmx3vXXtNNmikubFluHjjP84Rf8EJ/9W2ybn2mIlwPSL2l5d3PKUHpMQCInUpZ0l 5cfrEcdoSNHhASLbNOb+XdaNgWWPr/WUUpobZ3CtNfdjBlGBQ8eZiE5s3JDT7LCLCMtUNWBTLmx vBusBOFt/dagtznXhNJ6KzPvBhYQ3HkyxWPpDnN3JoP4a1h9tlNOrmYlWv/TqvGHNcP627qrRmd 2jWPPeyYEVhFA9LzZ3p0E63NfQTbfhpW91UO13o5/PI36hClJAcSUH/IGHChj+cmndks8vR4Wo6 KDCN9rAahSHC1mQ=
 =
X-Developer-Key: i=markus.probst@posteo.de; a=openpgp; fpr=827418C4F4AC58E77230C47334761FF8E7AD43D2
Content-Transfer-Encoding: 8bit
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
  keydata=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
  aBeNN4ijKZchBXHPgVx+YtWRHfcm4l8=
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt

This series adds support for power resources defined in acpi on ata
ports/devices. A device can define a power resource in an ata port/device,
which then gets powered on right before the port is probed. This can be
useful for devices, which have sata power connectors that are:
  a: powered down by default
  b: can be individually powered on
like in some synology nas devices. If thats the case it will be assumed,
that the power resource won't survive reboots and therefore the disk will
be stopped.

Changes since v4:
- improved documentation
- use false/true instead of 0/1
- removed repeating code in ata_acpi_dev_manage_restart
- split long lines
- removed debug message
- improved error message

Changes since v3:
- rename function from "ata_port_set_power_state"
  to "ata_acpi_port_power_on" and remove enable argument
- split "ata_acpi_port_power_on" and "ata_acpi_dev_manage_restart" into
  two commits
- improved commit messages
- improved comments (style and new comments)

Changes since v2:
- improved commit messages
- addressed warning from kernel test robot

Changes since v1:
- improved commit messages
- addressed style issues (too long lines and docs)
- removed ata_dev_manage_restart() and ata_port_set_power_state()
  methods
- improved log messages in ata_acpi_port_set_power_state


Markus Probst (3):
  scsi: sd: Add manage_restart device attribute to scsi_disk
  ata: stop disk on restart if ACPI power resources are found
  ata: Use ACPI methods to power on disks

 drivers/ata/libata-acpi.c  | 66 ++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-core.c  |  2 ++
 drivers/ata/libata-scsi.c  |  1 +
 drivers/ata/libata.h       |  4 +++
 drivers/scsi/sd.c          | 35 +++++++++++++++++++-
 include/scsi/scsi_device.h |  6 ++++
 6 files changed, 113 insertions(+), 1 deletion(-)

-- 
2.51.0

