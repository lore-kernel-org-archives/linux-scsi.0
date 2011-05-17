From: Vasilis Liaskovitis <vliaskov@gmail.com>
Subject: TCM/LIO ib_srpt testing
Date: Tue, 17 May 2011 12:37:59 +0200
Message-ID: <BANLkTim5inFCXMwnFz=4CHrAmhXMYyMscw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63027 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab1EQKiA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2011 06:38:00 -0400
Received: by vws1 with SMTP id 1so213146vws.19
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2011 03:37:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am trying to test the TCM/LIO ib_srpt target driver from master
branch of lio-core-2.6

In the past, using branch tcm_ib_srpt-38, I have successfully
initialized the srp target and initiator with the "manual steps" in:
http://linux-iscsi.org/wiki/SCSI_RDMA_Protocol#Manual_steps

However with master, the manual steps fail at:
root@server1:~# mkdir -p /sys/kernel/config/target/srpt/mlx4_0/mlx4_0/lun/lun_0
mkdir: cannot create directory
`/sys/kernel/config/target/srpt/mlx4_0': Invalid argument
Has the recommended ib_srpt initialization procedure changed recently?

The target and initiator are the same machine in this test.  This is
on Mellanox QDR (mlx4 backend driver)

When I tested the tcm_ib_srpt-38 branch of lio-core-2.6, the same
manual steps worked fine:

[ 3725.279283] <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
[ 3725.279336] Initialized struct target_fabric_configfs:
ffff88061a3f5800 for srpt
[ 3725.279416] <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
[ 3725.279539] TARGET_CORE[srpt]: Allocated Normal struct
se_portal_group for endpoint: 0x2c903000f5e7a, Portal Tag: 1
[ 3725.282984] Target_Core_ConfigFS: REGISTER -> group:
ffffffffa0273380 name: srpt
[ 3725.283071] Target_Core_ConfigFS: REGISTER -> Located fabric: srpt
[ 3725.284622] Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> ffff88061a3f5b08
[ 3725.284677] Target_Core_ConfigFS: REGISTER -> Allocated Fabric: srpt
[ 3725.284727] Target_Core_ConfigFS: REGISTER -> Set tf->tf_fabric for srpt
[ 3725.286314] iblock/srpt: Adding to default ALUA Target Port Group:
alua/default_tg_pt_gp
[ 3725.286403] srpt_TPG[1]_LUN[0] - Activated srpt Logical Unit from CORE HBA: 1
[ 3725.377681] srpt_TPG[1] - Added ACL with TCQ Depth: 1 for srpt
Initiator Node: 0x0002c903000f5e7b
[ 3725.379182] srpt_TPG[1]_LUN[0->0] - Added RW ACL for
InitiatorNode: 0x0002c903000f5e7b

And the scsi device seemed to appear correctly on the initiator side:

[ 3758.027108] scsi host1: ib_srp: new target: id_ext 0002c903000f5e7a
ioc_guid 0002c903000f5e7a pkey ffff service_id 0002c903000f5e7a dgid
fe80:0000:0000:0000:0002:c903:000f:5e7b
[ 3758.027959] Received SRP_LOGIN_REQ with i_port_id
0x0:0x2c903000f5e7b, t_port_id 0x2c903000f5e7a:0x2c903000f5e7a and
it_iu_len 260 on port 1 (guid=0xfe80000000000000:0x2c903000f5e7b)
[ 3758.031561] Session : kernel thread ib_srpt_compl (PID 2396) started
[ 3758.031631] TARGET_CORE[srpt]: Registered fabric_sess_ptr: ffff88021aaad000
[ 3758.031898] scsi1 : SRP.T10:0002C903000F5E7A
[ 3758.032317] scsi 1:0:0:0: Direct-Access     LIO-ORG  IBLOCK
  4.0  PQ: 0 ANSI: 5
[ 3758.032751] sd 1:0:0:0: [sdc] 9762242560 512-byte logical blocks:
(4.99 TB/4.54 TiB)
[ 3758.033193] sd 1:0:0:0: [sdc] Write Protect is off
[ 3758.033245] sd 1:0:0:0: [sdc] Mode Sense: 2f 00 00 00
[ 3758.033389] sd 1:0:0:0: [sdc] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[ 3768.046220]  sdc: unknown partition table
[ 3768.046823] sd 1:0:0:0: [sdc] Attached SCSI disk

However, the tcm_ib_srpt-38 branch results in a  kernel panic during
I/O traffic (e.g. doing simple dd tests on exported disk)
I was hoping that the latest patches in master would fix this.

Does anyone have tips on initializing ib_srpt manually, with
lio-utils, or with rtsadmin?
.
Also, If there's another branch more suitable for the latest LIO
patches please lat me know.

thanks,

- Vasilis
