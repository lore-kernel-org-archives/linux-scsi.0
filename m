From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 8/8] target: remove struct se_transform_info
Date: Tue, 23 Nov 2010 19:11:40 -0800
Message-ID: <1290568300.30138.187.camel@haakon2.linux-iscsi.org>
References: <20101123223053.574330460@bombadil.infradead.org>
	 <20101123223111.263485253@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41853 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0KXDRI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 22:17:08 -0500
In-Reply-To: <20101123223111.263485253@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2010-11-23 at 17:31 -0500, Christoph Hellwig wrote:
> plain text document attachment (kill-se_transform_info)
> No quite sure what the original use was, but these days it's almost
> completely superflous.  Besides the two different ways to pass the
> se_device that can also be retreived from the se_cmd it only contained
> a set_counts flag for transport_generic_get_cdb_count, which can more
> easily be passed directly.
> 

This is a long overdue cleanup committed as 2e7d255302, great stuff.  ;)

Also just to clarify, the se_transform_info was a historical reminent
used by SCF_SCSI_DATA_SG_IO_CDB cmds in order to support the v2.x legacy
iSCSI RAID1 w/ so that individual se_tasks could be directed to
different se_devices from a single received se_lun -> se_cmd.

Which brings the total for the series tested this evening against
TCM_loop and LIO-Target ports on .37-rc2 x86 KVM with IBLOCK, PSCSI,
FILEIO and IBLOCK backends.  Pushing into lio-core-2.6.git now..

 drivers/target/lio-target/iscsi_target_core.h |    1 -
 drivers/target/lio-target/iscsi_target_mib.h  |    1 -
 drivers/target/target_core_alua.h             |    2 -
 drivers/target/target_core_configfs.c         |   65 +++------
 drivers/target/target_core_device.c           |   18 +--
 drivers/target/target_core_file.c             |   27 +---
 drivers/target/target_core_file.h             |    2 -
 drivers/target/target_core_hba.c              |  180 ++++++++++------------
 drivers/target/target_core_hba.h              |   11 +-
 drivers/target/target_core_iblock.c           |   23 +---
 drivers/target/target_core_iblock.h           |    2 -
 drivers/target/target_core_mib.c              |    3 -
 drivers/target/target_core_mib.h              |    2 -
 drivers/target/target_core_pscsi.c            |   11 +-
 drivers/target/target_core_pscsi.h            |    2 -
 drivers/target/target_core_rd.c               |   30 +----
 drivers/target/target_core_rd.h               |    2 -
 drivers/target/target_core_stgt.c             |    9 +-
 drivers/target/target_core_stgt.h             |    2 -
 drivers/target/target_core_transport.c        |  207 +++++--------------------
 include/target/target_core_base.h             |   38 -----
 include/target/target_core_configfs.h         |    2 -
 include/target/target_core_device.h           |    2 -
 include/target/target_core_tpg.h              |    2 -
 include/target/target_core_transport.h        |   15 +--
 25 files changed, 163 insertions(+), 496 deletions(-)

Thanks Christoph!

--nab


