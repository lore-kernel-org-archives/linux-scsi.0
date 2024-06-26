Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0C5190079;
	Wed, 26 Jun 2024 18:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424854; cv=none; b=tc6gWi3iUt2EfF6HkoikJfcqBgrQsrycOOhfM+bFxtam08cTk0h3W7zNiW/Hq8Cf6at7hAJ4p7QoFDL24SBvbkjdsbuSC+8D6fKuVCJVZxD1kdBhl99Y4QhQRmv2ehhWvZomkBznBCTgyworTNwdD+9YT76E19VgngQHAR0SXTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424854; c=relaxed/simple;
	bh=q1CZG9hxYfrvOGAzm7i9i2PwdocdoYIv+geXRGkL1Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dGy9q7gloxgo0BKR4hqq8SI3Grfn/N7X+aI2uWSq4ZCXyX4r2ESgpTn1yNunCmCN2moJYcbrNqqahJ58FH4gJWTj/oc9Bjr7SV88L7rw8+9aDHQoUyRRRM1LxP+Oks8/AgnO+SrJRHyy/UHVVch+bWPuY3+VxbGoChrnHPkk+Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXSoQX9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXSoQX9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514F6C116B1;
	Wed, 26 Jun 2024 18:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719424853;
	bh=q1CZG9hxYfrvOGAzm7i9i2PwdocdoYIv+geXRGkL1Qg=;
	h=From:To:Cc:Subject:Date:From;
	b=ZXSoQX9xGtJ74o4hdOMSaGUskMmGHJ+iwKn5/QXiZ1fNAHcXr5zc3Dt3mAcwA14gr
	 4BV7hbNAbSs0AdDnQD32u1sNorjht9qPVlgz7qLi029H25rPdEo3qvcVexa8+aK5HS
	 nQCESKhvPhm1Xhcvmrh6EP2MpNfE0NGsAvPsX1EudC+dPVZsr6My9RXm7uQV88lpw5
	 G/dHbKrHOo1hvkXtCq/pQJ8I2qI8NziIwbSDEeCEMUhEusJYnHR5KQQTEdhP5EsKd5
	 P2nP1OMUAXUJhghc7F9dPVBCDAlfd6umTiePMI897oN0UdZrWdSGr2uioQy2WoRTxL
	 EabMQoYZM6/RA==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Tejun Heo <htejun@gmail.com>,
	Jeff Garzik <jeff@garzik.org>,
	Colin Ian King <colin.i.king@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org
Subject: [PATCH v2 00/13] ata,libsas: Assign the unique id used for printing earlier
Date: Wed, 26 Jun 2024 20:00:30 +0200
Message-ID: <20240626180031.4050226-15-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3445; i=cassel@kernel.org; h=from:subject; bh=q1CZG9hxYfrvOGAzm7i9i2PwdocdoYIv+geXRGkL1Qg=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJqwu1XHIp51LGP73DKTIuF1rtF4rqCau8uLJrgsORy+ naVmgDnjlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEwkcz7DX0GdF3V5TUmXGcM6 xNVK2k56dFzd2qakfHbmFbvqmxMunmNkuP38pQjzgdbHsbUd9fdOPov9URsaw1woa3vDcfPj9/1 xjAA=
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Hello all,

This patch series was orginally meant to simply assign a unique id used
for printing earlier (ap->print_id), but has since grown to also include
cleanups related to ata_port_alloc() (since ap->print_id is now assigned
in ata_port_alloc()).

Patch 1-3 fixes incorrect cleanups in the error paths.
Patch 4,12 removes a useless libata wrappers only used for libsas.
Patch 5 introduces a ata_port_free(), in order to avoid duplicated code.
Patch 6 removes a unused function declaration in include/linux/libata.h.
Patch 7 remove support for decreasing the number of ports, as it is never
        used by any libata driver (including libsas and ipr).
Patch 8 removes a superfluous assignment in ata_sas_port_alloc().
Patch 9 removes the unnecessary local_port_no struct member in ata_port.
Patch 10 performs the ata_port print_id assignment earlier, so that the
         ata_port_* print functions can be used even before the ata_host
	 has been registered.
Patch 11 changes the print_id assignment to use an ida_alloc(), such that
         we will reuse IDs that are no longer in use, rather than keep
	 increasing the print_id forever.
Patch 13 adds a debug print in case the port is marked as external, this
         code runs before the ata_host has been registered, so it depends
	 on patch 10.


Martin, how do you want us to coordinate libsas changes?

You don't seem to have any libsas changes staged for 6.11 so far,
and the libsas changes in this series are quite isolated (and small),
so perhaps we can simply queue them via the libata tree?

Kind regards,
Niklas


Changes since v1:
-Added patches that fixes incorrect cleanups in the error paths.
-Added patches to remove useless libata wrappers only used for libsas.
-Added patch that introduces ata_port_free().
-Added patch that removes a unused function declaration in libata.h.
-Added patch that removes local_port_no (Damien).
-Added patch that assigns the print_id using ida_alloc() (Damien).
-Picked up tags.

Link to v1:
https://lore.kernel.org/linux-ide/20240618153537.2687621-7-cassel@kernel.org/

Niklas Cassel (13):
  ata: libata-core: Fix null pointer dereference on error
  ata: libata-core: Fix double free on error
  ata: ahci: Clean up sysfs file on error
  ata,scsi: Remove useless wrappers ata_sas_tport_{add,delete}()
  ata,scsi: libata-core: Add ata_port_free()
  ata: libata: Remove unused function declaration for ata_scsi_detect()
  ata: libata-core: Remove support for decreasing the number of ports
  ata: libata-sata: Remove superfluous assignment in
    ata_sas_port_alloc()
  ata: libata-core: Remove local_port_no struct member
  ata: libata: Assign print_id at port allocation time
  ata: libata-core: Reuse available ata_port print_ids
  ata,scsi: Remove useless ata_sas_port_alloc() wrapper
  ata: ahci: Add debug print for external port

 drivers/ata/ahci.c                 | 21 +++++++---
 drivers/ata/libata-core.c          | 66 ++++++++++++++++--------------
 drivers/ata/libata-sata.c          | 49 ----------------------
 drivers/ata/libata-transport.c     |  5 ++-
 drivers/ata/libata-transport.h     |  3 --
 drivers/ata/libata.h               |  1 -
 drivers/scsi/libsas/sas_ata.c      | 14 +++++--
 drivers/scsi/libsas/sas_discover.c |  4 +-
 include/linux/libata.h             | 12 +++---
 9 files changed, 71 insertions(+), 104 deletions(-)

-- 
2.45.2

