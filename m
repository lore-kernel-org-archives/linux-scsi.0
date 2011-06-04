From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/7] iscsi-target: Bugfixes for t_mem_list -> t_mem_sg[] conversion
Date: Fri,  3 Jun 2011 18:18:11 -0700
Message-ID: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm22.access.bullet.mail.mud.yahoo.com ([66.94.237.223]:29926
	"HELO nm22.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751703Ab1FDBSo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 21:18:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Andy and Christoph,

This series addresses some issues that have appeared during recent testing on
lio-core-2.6.git/master (v3.0.0-rc1) with the iscsi-target patches from
to convert direct usage of struct iscsi_cmd->se_cmd.t_mem_list into struct
iscsi_cmd->t_mem_sg[] using iscsit_alloc_buffs() + iscsit_map_iovec(), and
sendpage() in the outgoing TX path.

Patch #1 involves changes to iscsit_alloc_buffs() required to properly handle
offset_in_page() from kmalloc() with SCF_SCSI_CONTROL_NONSG_IO_CDB payloads
required for initial INQUIRY + REPORT_LUNs, SCAN et al to function..

Patch #2 fixes a payload length padding bug in iscsit_send_data_in() that was
causing problems, and Patch #3 is a bugfux for iscsit_target_tx_thread() to disable
sendpage() with map_sg=0 for non ISTATE_SEND_DATAIN outgoing payload ops that was
causing a seperate OOPs.

Patch #5 addresses the transport_generic_new_cmd() failure in iscsit_handle_scsi_cmd(),
and Patch #6->#7 contain two bugfixes required for I/O payloads to function using
non PAGE_SIZE iSCSI MaxRecvDataSegmentLength with new scatterlist mapping logic in
iscsit_map_iovec() and iscsit_fe_sendpage_sg() respectively.

Finally, Patch #8 addresses a seperate iscsit_do_crypto_hash_sg() SGL pointer walk
bug also introduced with the recent merge.

This series is now passing initial MRDSL walking tests w/ 512 byte increments using
randrw verify fio tests for SCF_SCSI_DATA_SG_IO_CDB and SCF_SCSI_CONTROL_SG_IO_CDB
payloads, but still needs more needs more max_sectors backend testing with new
immediate data WRITEs -> transport_generic_map_mem_to_cmd() usage, and also verified
with MRDSL < 8192 cases with contiguous buffers for SCF_SCSI_CONTROL_NONSG_IO_CDB.

Please have a look and comment.

Thanks,

--nab

Nicholas Bellinger (7):
  iscsi-target: Fix iscsit_alloc_buffs() breakage with offset_in_page
  iscsi-target: Fix padding breakage in iscsit_send_data_in
  iscsi-target: Clear map_sg usage for non ISTATE_SEND_DATAIN ops
  iscsi-target: Handle transport_generic_new_cmd failure
  iscsi-target: Fix iscsit_map_iovec cur_len + data_offset breakage
  iscsi-target: Fix iscsit_fe_sendpage_sg breakage
  iscsi-target: Fix iscsit_do_crypto_hash_sg() bug

 drivers/target/iscsi/iscsi_target.c      |  106 ++++++++++++++++++------------
 drivers/target/iscsi/iscsi_target_util.c |   15 ++--
 2 files changed, 72 insertions(+), 49 deletions(-)

-- 
1.7.2.5

