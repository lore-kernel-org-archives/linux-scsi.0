Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F77E130A54;
	Tue,  9 Apr 2024 14:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673498; cv=none; b=b+0rermpoFLCJ7JOD7BGIbIEd43Njfqw8fsn38nIsYmj/FHfqGXzjTkD/cyWd57smnhdIY086r5WG9fr58c8biAI6rEJ/Wpo+9m62O09tIqqoRrUahcZCANXzlRIEK5psRIcPjqMMbAfC1Pq5n1kZjIIbAh6K35lJ61C9w3oohc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673498; c=relaxed/simple;
	bh=1WoibkJ1J4WjuQ78vUrSaeJ/E6nJvUKUhT4nCRazdLs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=khY01GOyJr52w74PIdSskmtqSaRE7tGP2CLdC6TsGAphobTu6xY0h15xDWyNBB1GvQZK7OAH6gbsjeimIT9vhmT5IjbsbWAb6cUKBZPxVGyxXdqvimBVNsuyPCRbohW2fVVjF3GQOuUOp5cpyWU39AnXijW2FkHmGtOjtkG3QhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pfAAg1TX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pfAAg1TX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=97bJb+aM4uYv62j+Gihd8s7QCNiNww4A5KroSNoTlYU=; b=pfAAg1TXWfxFdVeaFZ+GOSrffY
	9opvV/p0NF1YZEO34uIv5lolkaLAf+sUaLSVanzWMOOW7+PPbaG9w4bomeT4jhkmOzspC49mxOz1b
	H6Dyi9Iv17uV0qaciScXTpekCblRhFBlIAGXnv+MaFf9uxbDNcEmmcEyQP0VAfDO5+7V7oDOKLCUT
	5pQaAGDb8t5b74FCjq7XirjBhCNNGorPAJiR4qYhzjy5mwDAqd9wyV3j5aEWMOZxWMSXBUJladnlL
	kQl9y+JCp6G8UhLLX/kYktgpOfYS0hpwNyiOwqvMS3Hd1+ViZ3cCstBFtqpruWlkcsx14c9qguV2I
	d44JbDjw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruCbf-00000002RtJ-1bH1;
	Tue, 09 Apr 2024 14:37:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@us.ibm.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: convert SCSI to atomic queue limits, part 1 (v3)
Date: Tue,  9 Apr 2024 16:37:25 +0200
Message-Id: <20240409143748.980206-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series converts the SCSI midlayer and LLDDs to use atomic queue limits
API.  It is pretty straight forward, except for the mpt3mr driver which
does really weird and probably already broken things by setting limits
from unlocked device iteration callbacks.

I will probably defer the (more complicated) ULD changes to the next
merge window as they would heavily conflict with Damien's zone write
plugging series.  With that the series could go in through the SCSI
tree if Jens' ACKs the core block layer bits.

Changes since v2:
 - rebased on top of the scsi-queue tree with libsas cleanups
 - fix another commit log typo

Changes since v1:
 - print a different warning message for queue_limits_commit failure vs
   ->device_configure failure
 - cancel the queue limits update when ->device_configure fails
 - spelling fixes
 - improve comments

Diffstat:
 block/blk-settings.c                        |  245 ----------------------------
 block/bsg-lib.c                             |    6 
 drivers/ata/ahci.h                          |    2 
 drivers/ata/libata-sata.c                   |   11 -
 drivers/ata/libata-scsi.c                   |   19 +-
 drivers/ata/libata.h                        |    3 
 drivers/ata/pata_macio.c                    |   11 -
 drivers/ata/sata_mv.c                       |    2 
 drivers/ata/sata_nv.c                       |   24 +-
 drivers/ata/sata_sil24.c                    |    2 
 drivers/firewire/sbp2.c                     |   13 -
 drivers/message/fusion/mptfc.c              |    1 
 drivers/message/fusion/mptsas.c             |    1 
 drivers/message/fusion/mptscsih.c           |    2 
 drivers/message/fusion/mptspi.c             |    1 
 drivers/s390/block/dasd_eckd.c              |    6 
 drivers/scsi/aha152x.c                      |    8 
 drivers/scsi/aic94xx/aic94xx_init.c         |    2 
 drivers/scsi/hisi_sas/hisi_sas.h            |    3 
 drivers/scsi/hisi_sas/hisi_sas_main.c       |    7 
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c      |    2 
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c      |    2 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |    7 
 drivers/scsi/hosts.c                        |    6 
 drivers/scsi/hptiop.c                       |    8 
 drivers/scsi/ibmvscsi/ibmvfc.c              |    5 
 drivers/scsi/imm.c                          |   12 -
 drivers/scsi/ipr.c                          |   10 -
 drivers/scsi/isci/init.c                    |    2 
 drivers/scsi/iscsi_tcp.c                    |    2 
 drivers/scsi/libsas/sas_scsi_host.c         |    7 
 drivers/scsi/megaraid/megaraid_sas.h        |    2 
 drivers/scsi/megaraid/megaraid_sas_base.c   |   29 +--
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    3 
 drivers/scsi/mpi3mr/mpi3mr.h                |    1 
 drivers/scsi/mpi3mr/mpi3mr_app.c            |   12 -
 drivers/scsi/mpi3mr/mpi3mr_os.c             |   76 +++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |   18 --
 drivers/scsi/mvsas/mv_init.c                |    2 
 drivers/scsi/pm8001/pm8001_init.c           |    2 
 drivers/scsi/pmcraid.c                      |   11 -
 drivers/scsi/ppa.c                          |    8 
 drivers/scsi/qla2xxx/qla_os.c               |    6 
 drivers/scsi/scsi_lib.c                     |   40 +---
 drivers/scsi/scsi_scan.c                    |   74 ++++----
 drivers/scsi/scsi_transport_fc.c            |   15 +
 drivers/scsi/scsi_transport_iscsi.c         |    6 
 drivers/scsi/scsi_transport_sas.c           |    4 
 drivers/staging/rts5208/rtsx.c              |   24 +-
 drivers/ufs/core/ufs_bsg.c                  |    3 
 drivers/ufs/core/ufshcd.c                   |    3 
 drivers/ufs/host/ufs-exynos.c               |    8 
 drivers/usb/image/microtek.c                |    8 
 drivers/usb/storage/scsiglue.c              |   57 ++----
 drivers/usb/storage/uas.c                   |   29 +--
 drivers/usb/storage/usb.c                   |   10 +
 include/linux/blkdev.h                      |   26 +-
 include/linux/bsg-lib.h                     |    3 
 include/linux/libata.h                      |   10 -
 include/linux/mmc/host.h                    |    4 
 include/scsi/libsas.h                       |    3 
 include/scsi/scsi_host.h                    |    9 +
 include/scsi/scsi_transport.h               |    2 
 include/scsi/scsi_transport_fc.h            |    1 
 include/ufs/ufshcd.h                        |    1 
 65 files changed, 347 insertions(+), 595 deletions(-)
