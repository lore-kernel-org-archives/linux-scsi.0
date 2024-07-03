Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0451DA313;
	Wed,  3 Jul 2024 18:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032288; cv=none; b=qguw8Mzft8aOQ7DTp8Ebw4XMBp71XSULuoBprOiV/GYA+7f3nQqH4y1hBOYfUTkwBnHzDtun7122xVgPfUFw0XfpZXxJEkdiCqrsWLDv1Pe014Rw53mzIeayQOG4HrMTSPu21aDT0sVs8cXkrdWr/TVDPAtVhhCxsqHZKQe1Lt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032288; c=relaxed/simple;
	bh=6sZEh2OLFkSBucYfcwUKKMpGpJufj0CWpI/ycKu61hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aWOCe0uQ+tChe8lkGe8ZoTf8ilxv4LxCJuOeWIpK+kV7QbB+dIbc7Qq480rM9+1wrVMUkXziwN+KESxDoi98ppai64O36iOgnIqna7misORE6iWK4CdjtIzGS3bEcc2sPAbKiAmY+PeM0ilHbaejkUpGBCiy0Co7xCfrJ2sVXqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MdVkE6hS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MdVkE6hS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E2BC2BD10;
	Wed,  3 Jul 2024 18:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720032288;
	bh=6sZEh2OLFkSBucYfcwUKKMpGpJufj0CWpI/ycKu61hQ=;
	h=From:To:Cc:Subject:Date:From;
	b=MdVkE6hSaQ8YTHEPbU7hMRCJZztsrnogzw06pfaPvtW+rNPBo+eUHBAcIdBf0GpLX
	 NrtOnmL8j2iRSpDi+a9TxzXSV0JyQSTSbftrE9Y3dnh8zsVC1+bN5g2WupZTjEH8MH
	 pXfjpPk44n+kphQNgjjZ7LowbH+6wi1cGSTNR03JHrg5OXnL6RJL9FuiHkbh9NNOxP
	 94l4y0W1YhFuALBr0+HLUXB6+eI2DAduL6HbdJB5qiJNW9pQlJdkNIfQALyAqiP72u
	 NcrHWdMaWkpBEkG8568mvJjO9XSVhsIbce5ThpNFVjMXfAZanhuHqkFmqjr7A919/w
	 7/IldrjoB/UOQ==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org
Subject: [PATCH v4 0/9] ata,libsas: Assign the unique id used for printing earlier
Date: Wed,  3 Jul 2024 20:44:17 +0200
Message-ID: <20240703184418.723066-11-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2323; i=cassel@kernel.org; h=from:subject; bh=6sZEh2OLFkSBucYfcwUKKMpGpJufj0CWpI/ycKu61hQ=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJa5zCJcBqU1MxKnG9c4uH2LH/Jw4DTdXOz8icdavl+l WnfjBXPOkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjAR+/+MDK/EeGbwlT29sEoh 3YDLYcbf+9ksd7buF/zyM2yP0DS7DAGGPzzNfBd3HzT/9XspL1v7gdl5ovsdROunBGWGfdx963a QLwsA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Hello all,

This series moves the assignment of ap->print_id, which is used as a
unique id for each port, earlier, such that we can use the ata_port_*
print functions even before the ata_host has been registered.

While the patch series was orginally meant to simply assign a unique
id used for printing earlier (ap->print_id), it has since grown to
also include cleanups related to ata_port_alloc() (since ap->print_id
is now assigned in ata_port_alloc()).


Kind regards,
Niklas


Changes since v3:
-Picked up tags.
-Clarified commit message, and avoid word useless, for patch
 "ata,scsi: Remove wrappers ata_sas_tport_{add,delete}()"
-Clarified commit message, and avoid word useless, for patch
 "ata,scsi: Remove wrapper ata_sas_port_alloc()"
-Remove superfluous sata_port_info struct, as it is not strictly needed
 anymore, and instead perform the initializations directly in
 sas_ata_init().


Link to v3:
https://lore.kernel.org/linux-ide/20240702160756.596955-11-cassel@kernel.org/

Link to v2:
https://lore.kernel.org/linux-ide/20240626180031.4050226-15-cassel@kernel.org/

Link to v1:
https://lore.kernel.org/linux-ide/20240618153537.2687621-7-cassel@kernel.org/

Niklas Cassel (9):
  ata,scsi: Remove wrappers ata_sas_tport_{add,delete}()
  ata: libata: Remove unused function declaration for ata_scsi_detect()
  ata: libata-core: Remove support for decreasing the number of ports
  ata: libata-sata: Remove superfluous assignment in
    ata_sas_port_alloc()
  ata: libata-core: Remove local_port_no struct member
  ata: libata: Assign print_id at port allocation time
  ata: libata-core: Reuse available ata_port print_ids
  ata,scsi: Remove wrapper ata_sas_port_alloc()
  ata: ahci: Add debug print for external port

 drivers/ata/ahci.c                 |  4 ++-
 drivers/ata/libata-core.c          | 41 +++++++++----------------
 drivers/ata/libata-sata.c          | 49 ------------------------------
 drivers/ata/libata-transport.c     |  5 ++-
 drivers/ata/libata-transport.h     |  3 --
 drivers/ata/libata.h               |  2 --
 drivers/scsi/libsas/sas_ata.c      | 22 ++++++--------
 drivers/scsi/libsas/sas_discover.c |  2 +-
 include/linux/libata.h             | 11 +++----
 9 files changed, 37 insertions(+), 102 deletions(-)

-- 
2.45.2

