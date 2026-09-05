Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E128F223DE7;
	Sat,  5 Sep 2026 03:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578559; cv=none; b=owk/3DGnvU7RkNOSZ0n14KueCmw1PWzTM474x7VlfTP9UtWZ/UzeKYAnJM2Z2/SyaFKoHqu33Jmpt7wdTlGnpmCbnD3KCI837/d0Uq1WbuGnXBkIxYddBT/l4idfFSri9WurbHgapqK6pyVoepZSGylIoUNqyoEopL00fZhgWts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578559; c=relaxed/simple;
	bh=Fp1Rbs0IWd1pm5zdxDIKxd4y3jv/rXa7gE2ZMwDeR+U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=kRndKr0yuX5rtq+i6EV4XBBqR5K22ygKodH4+v2/e5o1WH2z2OLHGxwv18XQhPlQNFUhPlvt6XKsxba8XvwX+S+7yW+iy6rCodJ4nxn0z/HmWVsjGFo48zAQQsM3UDGuD105HvCAqjBDciPeY7d+zRK380MzHCjgxn+HpY7/lMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hU3v/1sG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hU3v/1sG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501D81F00A3D;
	Sat,  5 Sep 2026 03:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788578557;
	bh=TXsK4PP6mNB5lbaSUc8CRHI9/lu2qBLPJIJPJAymdHA=;
	h=From:To:Subject:Date;
	b=hU3v/1sG0fROQMlOcIvGMgOipAbdrKOtL+h0EXAovrs7pMTtdB0FqKfYShWYFIdAy
	 DMWRHKJFIn0PidsnFXDgxzpGpLSuEOTP9b489okZ8msz4GgId1zPptbYRyb/6fOaGC
	 Rfjm3yAwEUL7f4HbaUKbX4fJ16li2JU+FjXQW/eaThte0rch+V+Y1W165SWty92fUK
	 09WmWUDCWKlC1nZFJsN87aGanw6d+vxKeKnh1M+dQO+QNW68NoFPDtwdXC2Plc/lT5
	 TqbxzNeebEPRgtDD7CI+ZvkldSktbh8Rgb0ug6Pmkbvz/t3klCtI2xjZSHWjeaG0JM
	 1V9ehii4aY2rQ==
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
Subject: [PATCH v4 00/40] Use defined 16-bits ASC/ASCQ combinations 
Date: Sat,  5 Sep 2026 12:21:44 +0900
Message-ID: <20260905032224.509860-1-dlemoal@kernel.org>
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

Note: this series currently applies cleanly to Linus tree and to the
scsi-staging tree. However, commit 6d81700ad7c4 ("ata: libata-scsi: do not
raise UA for storage element depopulation and restoration") that is now
applied to 7.3-rc2 creates a conflict with patch 37 (the conflict is
trivial to resolve). So this will create a conflict for linux-next. Could
you maybe rebase scsi-staging on rc2 ?

Also please note that sashiko did comment about several pre-existing
issues for different drivers, but I am not addressing these issues in
this series.

changes from v3:
 - Fixed patch 8 to test only the INVALID FIELD IN CDB ASC in
   sd_zbc_complete().  Testing the full sense code for INVALID FIELD IN
   CDB with a zero ASCQ is actually correct and as defined per ZBC
   specifications for zone management operations issued to conventional
   zones. But as Sashiko suggests, some devices may not strictly follow
   that, so we keep to loosen test.
 - Rebased on scsi-staging branch
 - Added review and ack tags

Changes from v2:
 - Removed unintended duplication of KUNIT_EXPECT_EQ() call in patch 7
   (Sashiko comment).
 - Improved patch 38 to directly use 16-bits sense code instead of passing
   only an ascq around (Sashiko comment).
 - Added missing local variable initialization in
   spc_emulate_request_sense() in patch 34 (Sashiko comment).
 - Added review tags

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
 drivers/s390/scsi/zfcp_ext.h                 |    2 +-
 drivers/s390/scsi/zfcp_fsf.c                 |    9 +-
 drivers/s390/scsi/zfcp_scsi.c                |    6 +-
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
 drivers/scsi/scsi_lib.c                      |  133 +-
 drivers/scsi/scsi_lib_test.c                 |   95 +-
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
 69 files changed, 3829 insertions(+), 2015 deletions(-)
 create mode 100644 include/scsi/scsi_sense.h


base-commit: e83b47309f73313e75c3888d7839666aba5b2b2a
-- 
2.55.0

