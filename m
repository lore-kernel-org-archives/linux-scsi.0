From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 0/7] iSER target initial support for T10-DIF offload
Date: Thu, 16 Jan 2014 15:55:49 +0200
Message-ID: <1389880556-21059-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:36590 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751628AbaAPN4F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 08:56:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@daterainc.com
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, oren@mellanox.com

This patchset adds basic support for T10-DIF protection information offload
in iSER target on top of Nic's recent work and RDMA signature verbs API.

This code was tested with my own implementation of the target core T10-PI support
which was designed mainly to activate the transport DIF offload. In order to
actually get Linux SCSI target to work with iSER T10-DIF offload a couple of
patches needs to be added to Nic's work which is ongoing.

Apart from doing the actual iser implementation for  T10-DIF offload, this
series would help to see the full picture by:

* Showing how the T10-DIF offload verbs are used
* Showing how fabric transport offload plugs into the target core

The T10-DIF signature offload verbs and mlx5 driver implementation patches are
available from the for-next branch of git://beany.openfabrics.org/~ogerlitz/linux-2.6.git
as the below commits:

2b4316b IB/mlx5: Publish support in signature feature
ef3130d IB/mlx5: Collect signature error completion
c1b37b1 IB/mlx5: Support IB_WR_REG_SIG_MR
f5d8496 IB/mlx5: Keep mlx5 MRs in a radix tree under device
72a72ee IB/mlx5: remove MTT access mode from umr flags helper function
ccb0a907 IB/mlx5: Break wqe handling to begin & finish routines
cda0569 IB/mlx5: Initialize mlx5_ib_qp signature related
33b4079 IB/mlx5, mlx5_core: Support for create_mr and destroy_mr
8b343e6 IB/core: Introduce Signature Verbs API
c1b0358 IB/core: Introduce protected memory regions


Here is a running example of target T10-PI support in an offload
manner using Mellanox "Connect-IB" HW. The working mode is "head-less"
where the iSER target is working against a legacy iSER initiator. SCSI
writes are inserted with protection block guards and SCSI reads are
verified and stripped from protection block guards.

*Note: fileio support is not apart of this patchset and will be provided
later as part of Nic's next T10-PI patches.

*Note: configuration commands are presented on top of targetcli

1. Creating file backstore
    /> backstores/fileio create file_or_dev=/root/file name=dev size=1G
    Not using buffered mode.
    Created fileio dev.

2. Set protection parameters
    /> backstores/fileio/dev set attribute prot_type=1 guard_type=crc app_tag=0xfefe pi_handover=seperated
    Parameter guard_type is now 'crc'.
    Parameter app_tag is now '0xfefe'.
    Parameter prot_type is now '1'.
    Parameter pi_handover is now 'seperated'.

3. Format (with T10-PI) file backstore and enable protection information
    /> backstores/fileio/dev set attribute pi_format=1 pi_enable=1
    Parameter pi_enable is now '1'.
    Parameter pi_format is now '1'.

    Now file file.protection is created and formatted:
    $ hexdump -C -n 48 file.protection
    00000000  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
    *
    00000030

3. Set iscsi tpgt T10-PI support (signaling the transport to initialize T10-PI)
    /> iscsi/iqn.2003-01.org.linux-iscsi.dev-r-vrt-077-024.x8664:sn.5263e2a37630/tpgt1/ set attribute t10_pi=1
    Parameter t10_pi is now '1'.

5. Legacy initiator successfully writes 4 512B blocks
    $ dd if=/root/tmp_file of=/dev/sdb bs=512 count=4 oflag=direct
    4+0 records in
    4+0 records out
    2048 bytes (2.0 kB) copied, 0.170229 s, 12.0 kB/s

    Now data blocs are stored in file and protection block guards are stored
    in file.protection

    $ hexdump -C -n 48 file.protection
    00000000  00 e3 fe fe 00 00 00 00  0e c6 fe fe 00 00 00 01  |................|
    00000010  2c d8 fe fe 00 00 00 02  1d 5d fe fe 00 00 00 03  |,........]......|
    00000020  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
    00000030

6. Legacy initiator successfully reads 10 512B blocks
    $ dd if=/dev/sdb of=/dev/null bs=512 count=10 iflag=direct
    10+0 records in
    10+0 records out
    5120 bytes (5.1 kB) copied, 0.00397309 s, 1.3 MB/s

7. Corrupting block 0 guard tag in file.protection (0x00e3 -> 0xff1c)
    $ hexdump -C -n 48 file.protection
    00000000  ff 1c fe fe 00 00 00 00  0e c6 fe fe 00 00 00 01  |................|
    00000010  2c d8 fe fe 00 00 00 02  1d 5d fe fe 00 00 00 03  |,........]......|
    00000020  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
    00000030

8. Legacy initiator fails to read 10 512B blocks
    dd if=/dev/sdb of=/dev/null bs=512 count=10 iflag=direct
    dd: reading `/dev/sdb': Input/output error
    0+0 records in
    0+0 records out
    0 bytes (0 B) copied, 0.0035183 s, 0.0 kB/s

    SNIP from target log:
    kernel: mlx5_0:mlx5_poll_one:512:(pid21565): CQN: 0x19 Got SIGERR on key: 0x40000bde err_type 0 err_offset 207 expected e3 actual ff1c
    kernel: PI error found type 0 at offset 0x207 expected 0xe3 vs actual 0xff1c

    where error type 0 is IB_SIG_BAD_GUARD.


Changes from v0:
- Dropped applied preperation patches
- Restored break statement for RDMA_WRITE completions
- Used core rroutine for sending CHECK_CONDITION for PI errors
- checkpatch errors

Sagi Grimberg (7):
  Target/core: use sense_reason_t for se_cmd->pi_err
  Target/iscsi: Add T10-PI indication for iscsi_portal_group
  IB/isert: Initialize T10-PI resources
  IB/isert: pass mr and frpl to isert_fast_reg_mr routine
  IB/isert: Accept RDMA_WRITE completions
  IB/isert: Support T10-PI protected transactions
  Target/configfs: Expose iSCSI network portal group T10-PI support

 drivers/infiniband/ulp/isert/ib_isert.c      |  519 +++++++++++++++++++++-----
 drivers/infiniband/ulp/isert/ib_isert.h      |   19 +-
 drivers/target/iscsi/iscsi_target_configfs.c |    6 +
 drivers/target/iscsi/iscsi_target_core.h     |    5 +-
 drivers/target/iscsi/iscsi_target_tpg.c      |   21 +
 drivers/target/iscsi/iscsi_target_tpg.h      |    1 +
 include/target/target_core_base.h            |   11 +-
 7 files changed, 481 insertions(+), 101 deletions(-)

