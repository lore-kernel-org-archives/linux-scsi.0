Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1627148825;
	Tue,  2 Jul 2024 16:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719936519; cv=none; b=ahnS9Bn/Pk60YX9tFUH+SB9iPAv3RnXIZ/L3Qc2xmfq9nAxPGwrOlp7gI7lOwILa3ogq8BxCuEJv6iothR0bxFrHUaOn6HC6ukmAci3S4sMzxcyAW0tzaAbH2AKSi7QpZd7w7UQKAqBEZiLwfDVziBnHcMBjSxiujC8rMnpikE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719936519; c=relaxed/simple;
	bh=lchi3y0ajozoK/j9DWHedifHZG3QRwJ4IlmhCIeecO0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PIDMyMp8vCwx43FzsDid23APInCJP3gMgxmL5pTDky42mJf/kh6ES7FAP1V7E6/QWPCD5xgK2myDZQUXfplU81EFfZuT5EL9LZYvfbiw5Efcatlx2Xtdx061rXLHH/zuwfZeJ56quyspY5Z3dLxoPhYCTTBsHVR3M9HzMzNBMFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PEk6IECF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PEk6IECF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688A7C116B1;
	Tue,  2 Jul 2024 16:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719936519;
	bh=lchi3y0ajozoK/j9DWHedifHZG3QRwJ4IlmhCIeecO0=;
	h=From:To:Cc:Subject:Date:From;
	b=PEk6IECFqwq8E9QQq2+rHmhfz4CGG6fWePIUeuylePDK1XR7m66t9npfChMD5kTPB
	 nCUj32YTe03yntJ3wsQPPT6vdHnm0OktAvoQB+GHJYDqP2+hhIxSKMVn9Fux1OZZC5
	 rw7CdqU9v6UzEBEfqVGip+FWRX2sMKvep3IwWG1exLtt2LGADT5znZNEoEdU3FZmkV
	 99q5rCjhWGcQeNUzSfUHkIAgbrZ/a1AKstOs2ULBZq3ryxIexuLaD4vxHA2i9DZxK7
	 +LaWsnkQIQClxmNtelV+w2K4nINcD8wgiJoSZ6YMdDHziKkIecoxInC6NTIiLN6Kx6
	 K50sCAuWWXiHg==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org
Subject: [PATCH v3 0/9] ata,libsas: Assign the unique id used for printing earlier
Date: Tue,  2 Jul 2024 18:07:56 +0200
Message-ID: <20240702160756.596955-11-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2517; i=cassel@kernel.org; h=from:subject; bh=lchi3y0ajozoK/j9DWHedifHZG3QRwJ4IlmhCIeecO0=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJaVO+2X1y2LIDJzaFZI/O4RuI1VumFDYfWiJ1g4t+nW njte9y/jlIWBjEuBlkxRRbfHy77i7vdpxxXvGMDM4eVCWQIAxenAEyEbRPD/zTTnfmb+UPdU14+ 7HqUFXB6Jt+Vh7rK1Z5vld7xh13cIMrw37U57UB6ttCDe5wp0qc1tA3nR+2sf3j5m5rnrEvH/rD O5wQA
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


Changes since v2:
-Sent out patches that were strict bug fixes as a separate series.
-Rebased patch series.
-Picked up tags.
-Fixed minor typos.
-Fixed problem reported by kernel test robot, by using a local variable to
 check for errors.
-Removed existing super ugly code that iterates past host->n_ports (which
 relied on the ata_host_alloc() allocating n_ports+1 rather than n_ports),
 as suggested by Hannes.
-Now when we don't have the ugly code that iterates past host->n_ports,
 change ata_host_alloc(() to only allocate n_ports, as the ugly workaround
 of allocating an n_ports+1 ports is no longer needed (as it was only
 needed for the feature that this patch series removes).


Link to v2:
https://lore.kernel.org/linux-ide/20240626180031.4050226-15-cassel@kernel.org/

Link to v1:
https://lore.kernel.org/linux-ide/20240618153537.2687621-7-cassel@kernel.org/


Niklas Cassel (9):
  ata,scsi: Remove useless wrappers ata_sas_tport_{add,delete}()
  ata: libata: Remove unused function declaration for ata_scsi_detect()
  ata: libata-core: Remove support for decreasing the number of ports
  ata: libata-sata: Remove superfluous assignment in
    ata_sas_port_alloc()
  ata: libata-core: Remove local_port_no struct member
  ata: libata: Assign print_id at port allocation time
  ata: libata-core: Reuse available ata_port print_ids
  ata,scsi: Remove useless ata_sas_port_alloc() wrapper
  ata: ahci: Add debug print for external port

 drivers/ata/ahci.c                 |  4 ++-
 drivers/ata/libata-core.c          | 41 +++++++++----------------
 drivers/ata/libata-sata.c          | 49 ------------------------------
 drivers/ata/libata-transport.c     |  5 ++-
 drivers/ata/libata-transport.h     |  3 --
 drivers/ata/libata.h               |  2 --
 drivers/scsi/libsas/sas_ata.c      | 12 ++++++--
 drivers/scsi/libsas/sas_discover.c |  2 +-
 include/linux/libata.h             | 11 +++----
 9 files changed, 36 insertions(+), 93 deletions(-)

-- 
2.45.2

