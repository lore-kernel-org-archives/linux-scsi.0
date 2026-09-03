Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73D32D8DDB;
	Thu,  3 Sep 2026 03:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406937; cv=none; b=jZgX8fxFxX4ZM0wokkGSQttWjHpx92hZ4sLLxbxVFQTnRYh10wMV/xy3OtpS1gsKwLqQgvX65b/DQiWjo+t4/n1VefAPGXfzdY6q5OrvfLpNsQvQ4nKfxpOPrrMxm35agiMbXgpH+V7TpmVI/elQr3m1ScWCo4d/qprgSzhSZnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406937; c=relaxed/simple;
	bh=geB7IcHMQKdiUr/yNJgzr7yB7zabcVHfPGUZFdYJl6Q=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=N38Zc9OsrkoVg7orwA3FYsUEuoPCa40n3bFbQyBQfEiU6w6d84K6fstzOsRVlIUpqeW+dqk2YWU+p4tAoW/TP9RtYR2DOq/GZ1wGhkTaNuP/yTZj7WEanY32jbN+eqZ5UqKnrtojQc8E0smT5uUrNza1rsUASqxcziFABa9Bb3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODKUy3wR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODKUy3wR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB5D1F00A3A;
	Thu,  3 Sep 2026 03:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406935;
	bh=A0T2pyw+Z4N7gniZaS+KCR3Gcmpdwg+vSMiOX8M6/VI=;
	h=From:To:Subject:Date;
	b=ODKUy3wRRJVfh9CyypB34RmlENNmHEt+c2Z0X/sA3H5qvf/FPFDxmp44Yj/igeuUp
	 sRSniIXwey9sel+AWgjf+5kQP72pssGtpKr2lZO8n9xN6g8Ou+Nwl7dxJkqOO4La0l
	 fjcYKZVjCJTehBJ+kHupJVQxg65GdmbO9pqX4v4eQTXwiXmX2nmmcuJNGTAlPEXoo+
	 42ltcAcuCnLPZeKrtnrlF/JZ0J64jS5ZM7I7FzVHay53ZC6T7i7PWBqbr4eBYU5UE/
	 S0QVlCJHVF/0CteC6fbIvHLWS9JtbXAXub04Tu7KNAdVnfXz4PVuvqykWTMfpuMGY1
	 DEnjeSsTaBrNg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v2 00/40] Use defined 16-bits ASC/ASCQ combinations 
Date: Thu,  3 Sep 2026 12:41:21 +0900
Message-ID: <20260903034201.112211-1-dlemoal@kernel.org>
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

Changes from v1:
 - Addressed Sashiko comments signaling missing "ASC_" prefix when using
   the named macros for ASC codes.
 - Fixed up patch 7 to correct trace event print of asc/ascq. Also
   extended the use of scsi_set_sense() in place of scsi_build_sense().
 - Modified patch 37 to extend the use of scsi_set_sense_buffer() in place
   of scsi_build_sense_buffer().
 - Added patch 34 and 38 to extend the use of scsi_set_sense() in place of
   scsi_build_sense().
 - Added patch 40 to remove scsi_build_sense() and
   scsi_build_sense_buffer().

Damien Le Moal (40):
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
  target: use 16-bits defined sense codes
  usb: storage: use 16-bits defined sense codes
  cdrom: use 16-bits defined sense codes
  ata: libata: use 16-bits defined sense codes
  s390: scsi: use 16-bits defined sense codes
  scsi: cleanup scsi_proto.h
  scsi: remove scsi_build_sense() and scsi_build_sense_buffer()

 drivers/ata/libata-eh.c                      |   13 +-
 drivers/ata/libata-sata.c                    |   20 +-
 drivers/ata/libata-scsi.c                    |  346 ++-
 drivers/ata/libata.h                         |    5 +-
 drivers/cdrom/cdrom.c                        |   10 +-
 drivers/s390/scsi/zfcp_scsi.c                |    3 +-
 drivers/scsi/3w-xxxx.c                       |    3 +-
 drivers/scsi/ch.c                            |   55 +-
 drivers/scsi/constants.c                     |   61 +-
 drivers/scsi/device_handler/scsi_dh_alua.c   |   55 +-
 drivers/scsi/device_handler/scsi_dh_emc.c    |   28 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c  |   29 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c   |   55 +-
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
 drivers/scsi/scsi_common.c                   |   24 +-
 drivers/scsi/scsi_debug.c                    |  332 +--
 drivers/scsi/scsi_error.c                    |   94 +-
 drivers/scsi/scsi_ioctl.c                    |    3 +-
 drivers/scsi/scsi_lib.c                      |  130 +-
 drivers/scsi/scsi_lib_test.c                 |   96 +-
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
 drivers/target/target_core_spc.c             |   11 +-
 drivers/target/target_core_transport.c       |   11 +-
 drivers/target/target_core_ua.c              |   28 +-
 drivers/target/target_core_ua.h              |    7 +-
 drivers/usb/gadget/function/f_mass_storage.c |   34 +-
 drivers/usb/gadget/function/storage_common.h |   71 +-
 drivers/usb/storage/debug.c                  |   12 +-
 drivers/usb/storage/debug.h                  |    4 +-
 drivers/usb/storage/transport.c              |    7 +-
 include/scsi/scsi_cmnd.h                     |    3 +-
 include/scsi/scsi_common.h                   |   16 +-
 include/scsi/scsi_dbg.h                      |    6 +-
 include/scsi/scsi_device.h                   |   26 +-
 include/scsi/scsi_proto.h                    |   71 +-
 include/scsi/scsi_sense.h                    |  943 +++++++
 include/trace/events/scsi.h                  |    4 +-
 67 files changed, 3821 insertions(+), 2007 deletions(-)
 create mode 100644 include/scsi/scsi_sense.h

-- 
2.55.0

