From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: LIO-Target/ConfigFS v3.0 on ppc64 for Playstation3
Date: Thu, 16 Apr 2009 18:28:17 -0700
Message-ID: <1239931697.4176.593.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n5a.bullet.mud.yahoo.com ([209.191.126.232]:20904 "HELO
	n5a.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758975AbZDQB2W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 21:28:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: CBE-OSS-DEV <cbe-oss-dev@ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Geoff Levand <geoffrey.levand@am.sony.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Greetings all,

I have recently been updating my Playstation3s to use the
lio-core-2.6.git v3.0 codebase, and I am happy to report all of v3.0
functionality is now up and running with Target_Core_Mod/ConfigFS and
LIO-Target v3.0 on v2.6.29 ppc64 including SCSI-3 compliant emulation.
Persistent Reservations, full ConfigFS operation, and hardware device
export is up and running.  

http://linux-iscsi.org/index.php/Playstation3/iSCSI

Currently, this requires folks to build a v2.6.29 ppc kernel and modules
from the lio-core-2.6.git tree.  You will need to be comfortable
checking cloning a git repository and building/install from source on
your PS3-Linux installation..

>From there, the export of storage objects using the v3.0 ConfigFS is
quite straightforward, here is an excerpt from the URL above to
configure iscsi_target_mod in 'demo mode' for /dev/sr0 to allow any
iSCSI Initiators to login and perform I/O to the target_core_mod/pSCSI
configured storage object.

       modprobe target_core_mod
       export CONFIGFS=/sys/kernel/config/
       export TARGET=/sys/kernel/config/target/core/
       export FABRIC=/sys/kernel/config/target/iscsi/

       # Create PSCSI ConfigFS storage object from HTCL 0:0:0:0
       mkdir -p $TARGET/pscsi_0/sr0
       echo scsi_channel_id=0,scsi_target_id=0,scsi_lun_id=0 > $TARGET/pscsi_0/sr0/control
       echo 1 > $TARGET/pscsi_0/sr0/enable

       export DEF_IQN="iqn.2003-01.org.linux-iscsi.playstation3.cell:sn.73b073c4e157"
       export PORTAL="192.168.0.160:3260"

       # The first mkdir(2) to $FABRIC will load iscsi_target_mod
       mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/np/$PORTAL"
       echo 8 > "$FABRIC/$DEF_IQN/tpgt_1/param/MaxConnections"
       # Create the SCSI Target Port from PSCSI storage object
       mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0"
       ln -s $TARGET/pscsi_0/sr0 "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0/lio_bdrom_port"
       # Allow demo mode R/W access for the iSCSI target portal group
       echo 0 > $FABRIC/$DEF_IQN/tpgt_1/attrib/authentication
       echo 1 > $FABRIC/$DEF_IQN/tpgt_1/attrib/generate_node_acls
       echo 0 > $FABRIC/$DEF_IQN/tpgt_1/attrib/demo_mode_write_protect
       # Enable the TPG Endpoint so initiators can login
       echo 1 > $FABRIC/$DEF_IQN/tpgt_1/enable

Also, you can find more information about Target_Core_Mod/ConfigFS and LIO-Target/ConfigFS at:

http://linux-iscsi.org/index.php/Target_Core_Mod/ConfigFS
http://linux-iscsi.org/index.php/LIO-Target/ConfigFS

--nab



