Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C27C29346F;
	Mon, 31 Aug 2026 02:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141905; cv=none; b=F5Zvt4DLno2fkNAqjsSOmIrT0vSuNOMbG0O2h/HZHsDS8aL0rZ3CCycZbwPxzvhem5HMdvBASFGxt7rkYmrUIQJ4md0PikF7gkkzVCw/fdyF8iSPBLG7BGwQ3YA/Vqxi7hzhkZxBQGl6qkRHqmT8e5lTyIaldnXDTj/krAvNM9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141905; c=relaxed/simple;
	bh=/ssjtIj6QG4czOwrOPhD4XlpBJShlGlQGZWAq9Jhd3o=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Erz9J/bERvqBN+/G2EI9arIxj0c692NSh6nR4L31lh1olF0spMW2ppLVN42GPBiXHg+iggH5SAePW2eI4plr6SbB8O85hriH68LpTxjnUnwRgDbMede5A1e4oIRNSU8SCQ8h5YOWf6+ScHVJvsrnOXOC8AnLh1MkJrHXJtQhDzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vw2mST+k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vw2mST+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111141F000E9;
	Mon, 31 Aug 2026 02:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141904;
	bh=DP5CUggDYLJP1zwRDoCvBoCMOmV/x4yH7Zk2+n9eEYw=;
	h=From:To:Subject:Date;
	b=Vw2mST+kuW6C2RGFvP2UbUzT8qKg/ZaZTcmlASA6VkfpKZ4ecLI34EfwakE8giTxa
	 vNZbihrxVVmndDpDpXbjuoBgCU8/n9ieiZywHW5CvfhecC7ZP/9U4CJqAUek1UnxB+
	 OynMEQngjwKHEdUWYGOSGafMPSFDI4WwuQJr1/HhB7sgkGrGaUxuymbKHmEVrG5CqM
	 OoBCe528+n1qm+WipkEtvGdbBEHon/07OtYwRuAYurIn2oOzlHz5R7ODFb4sqb/u6y
	 9v302g9OZGchnOotBBZlJjN6CwWDp8rMI5zyIOCJoBeS0iTz6pLE/BfYuWcUtrlBOX
	 FudCPar3fdWvA==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 00/37] Use defined 16-bits ASC/ASCQ combinations 
Date: Mon, 31 Aug 2026 11:04:14 +0900
Message-ID: <20260831020451.585944-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin, James,

This patch series defines as macros all ASC/ASCQ combinations present in
https://www.t10.org/lists/asc-num.txt and converts the SCSI core code and
SCSI low level drivers to use these macros instead of hard-coded
ASC/ASCQs. To do this, struct scsi_sense_hdr and struct scsi_failure are
modified to replace the asc and ascq 8-bits fields with a 16-bits
sense_code field.

This cleans up the code in many places and makes it easier, and self
documented, to test sense codes in the case of errors.

Overall, there should be no functional chnages here.

Damien Le Moal (37):
  scsi: define all additional sense codes and their qualifiers
  scsi: constants: use defined sense codes
  scsi: constants: rename internal struct field names
  scsi: rename sense field of struct scsi_failure
  scsi: prepare for using 16-bits defined sense codes
  scsi: use struct scsi_sense_hdr to log sense keys and codes
  scsi: core: use 16-bits defined sense codes
  scsi: sd: use 16-bits defined sense codes
  scsi: sr: use 16-bits defined sense codes
  scsi: ses: use 16-bits defined sense codes
  scsi: ch: use 16-bits defined sense codes
  scsi: st: use 16-bits defined sense codes
  scsi: device_handlers: hp_sw: use 16-bits defined sense codes
  scsi: device_handlers: rdac: use 16-bits defined sense codes
  scsi: device_handlers: emc: use 16-bits defined sense codes
  scsi: device_handlers: alua: use 16-bits defined sense codes
  scsi: mpt3sas: use 16-bits defined sense codes
  scsi: mpi3mr: use 16-bits defined sense codes
  scsi: 3w-xxxx: use 16-bits defined sense codes
  scsi: leapraid: use 16-bits defined sense codes
  scsi: megaraid: use 16-bits defined sense codes
  scsi: myrX: use 16-bits defined sense codes
  scsi: smartpqi: use 16-bits defined sense codes
  scsi: qla2xxx: use 16-bits defined sense codes
  scsi: ps3rom: use 16-bits defined sense codes
  scsi: lpfc: use 16-bits defined sense codes
  scsi: stex: use 16-bits defined sense codes
  scsi: mvumi: use 16-bits defined sense codes
  scsi: libiscsi: use 16-bits defined sense codes
  scsi: ibmvscsi_tgt: use 16-bits defined sense codes
  scsi: scsi_debug: use 16-bits defined sense codes
  scsi: hpsa: use 16-bits defined sense codes
  scsi: storvsc: use 16-bits defined sense codes
  usb: storage: use 16-bits defined sense codes
  cdrom: use 16-bits defined sense codes
  ata: libata: use 16-bits defined sense codes
  scsi: cleanup scsi_proto.h

 drivers/ata/libata-eh.c                      |   13 +-
 drivers/ata/libata-sata.c                    |   14 +-
 drivers/ata/libata-scsi.c                    |  346 ++-
 drivers/ata/libata.h                         |    5 +-
 drivers/cdrom/cdrom.c                        |   10 +-
 drivers/scsi/3w-xxxx.c                       |    3 +-
 drivers/scsi/ch.c                            |   55 +-
 drivers/scsi/constants.c                     |   61 +-
 drivers/scsi/device_handler/scsi_dh_alua.c   |   55 +-
 drivers/scsi/device_handler/scsi_dh_emc.c    |   30 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c  |   31 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c   |   51 +-
 drivers/scsi/hpsa.c                          |   69 +-
 drivers/scsi/hpsa_cmd.h                      |   23 -
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |    5 +-
 drivers/scsi/leapraid/leapraid_func.h        |    7 -
 drivers/scsi/leapraid/leapraid_os.c          |   15 +-
 drivers/scsi/libiscsi.c                      |    3 +-
 drivers/scsi/lpfc/lpfc_scsi.c                |   18 +-
 drivers/scsi/megaraid.c                      |    8 +-
 drivers/scsi/megaraid/mega_common.h          |    2 -
 drivers/scsi/megaraid/megaraid_mbox.c        |   12 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c              |    3 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c              |   50 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c         |   69 +-
 drivers/scsi/mvumi.c                         |    2 +-
 drivers/scsi/myrb.c                          |   67 +-
 drivers/scsi/myrs.c                          |   23 +-
 drivers/scsi/ps3rom.c                        |    5 +-
 drivers/scsi/qla2xxx/qla_isr.c               |    9 +-
 drivers/scsi/scsi.c                          |    3 +-
 drivers/scsi/scsi_common.c                   |   12 +-
 drivers/scsi/scsi_debug.c                    |  332 +--
 drivers/scsi/scsi_error.c                    |   94 +-
 drivers/scsi/scsi_ioctl.c                    |    3 +-
 drivers/scsi/scsi_lib.c                      |  122 +-
 drivers/scsi/scsi_lib_test.c                 |   58 +-
 drivers/scsi/scsi_logging.c                  |   22 +-
 drivers/scsi/scsi_scan.c                     |   22 +-
 drivers/scsi/scsi_transport_spi.c            |   12 +-
 drivers/scsi/sd.c                            |  126 +-
 drivers/scsi/sd_zbc.c                        |    2 +-
 drivers/scsi/sense_codes.h                   | 2496 ++++++++++++------
 drivers/scsi/ses.c                           |   23 +-
 drivers/scsi/smartpqi/smartpqi_init.c        |   31 +-
 drivers/scsi/sr.c                            |    3 +-
 drivers/scsi/sr_ioctl.c                      |   29 +-
 drivers/scsi/st.c                            |   35 +-
 drivers/scsi/stex.c                          |    3 +-
 drivers/scsi/storvsc_drv.c                   |   15 +-
 drivers/usb/gadget/function/f_mass_storage.c |   34 +-
 drivers/usb/gadget/function/storage_common.h |   71 +-
 drivers/usb/storage/debug.c                  |   12 +-
 drivers/usb/storage/debug.h                  |    4 +-
 drivers/usb/storage/transport.c              |    7 +-
 include/scsi/scsi_cmnd.h                     |    7 +
 include/scsi/scsi_common.h                   |   20 +-
 include/scsi/scsi_dbg.h                      |    6 +-
 include/scsi/scsi_device.h                   |   26 +-
 include/scsi/scsi_proto.h                    |   71 +-
 include/scsi/scsi_sense.h                    |  943 +++++++
 include/trace/events/scsi.h                  |    4 +-
 62 files changed, 3765 insertions(+), 1947 deletions(-)
 create mode 100644 include/scsi/scsi_sense.h

-- 
2.55.0

