From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: ConfigFS enabled Generic Target Mode and	iSCSI	Target
 Stack on v2.6.27-rc7
Date: Fri, 10 Oct 2008 21:49:20 +0400
Message-ID: <48EF95A0.5030405@vlnb.net>
References: <1222716101.4296.41.camel@haakon2.linux-iscsi.org>	 <48E3B529.4060406@vlnb.net>	 <1222907050.15764.56.camel@haakon2.linux-iscsi.org>	 <48E4FE3F.2080707@vlnb.net>	 <1222982972.15764.118.camel@haakon2.linux-iscsi.org>	 <48EB325E.6050907@vlnb.net>	 <1223412658.15764.306.camel@haakon2.linux-iscsi.org> <1223450521.15764.349.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:60549 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760957AbYJJRtL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2008 13:49:11 -0400
In-Reply-To: <1223450521.15764.349.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-iscsi-target-dev@googlegroups.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, Greg KH <greg@kroah.com>, Jerome Martin <tramjoe.merin@gmail.com>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Joel Becker <joel.becker@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>

Nicholas A. Bellinger wrote:
  > Ok, here is the commit:
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commit;h=d1dc1c1da8375c1b9099166d7d93f7f45477f892
> 
> In the example I am using two iSCSI Initiators (one Debian and one
> OpenSuse) that both have TPG LUN 0 and 1 mapped to their Initiator LUN 0
> and 1 under $FABRIC/$IQN/tpgt_1.
> 
> Here is what it looks like from the CLI:
> 
> export TARGET=/sys/kernel/config/target/core/
> export FABRIC=/sys/kernel/config/target/iscsi/
> 
> <Setup target_core_mod storage objects..>
> 
> DEF_IQN="iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0"
> 
> # The first mkdir(2) to $FABRIC will load iscsi_target_mod
> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/np/172.16.201.137:3260"
> # Create TPG LUN 0 and symlink $STORAGE_OBJECT from target_core_mod
> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0"
> ln -s $TARGET/iblock_0/lvm_test0 "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0/lio_west_port"
> # Create TPG LUN 1 and symlink $STORAGE_OBJECT from target_core_mod
> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1"
> ln -s $TARGET/pscsi_0/sdd "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1/lio_east_port"
> 
> INITIATOR_DEBIAN="iqn.1993-08.org.debian:01:2dadf92d0ef"
> 
> # Create Node and two LUN ACL Symlinks for Debian Initiator
> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_0"
> ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_0/."
> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_1"
> ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_1/."
> 
> INITIATOR_SUSE="iqn.1996-04.de.suse:01:1661f9ee7b5"
> 
> # Create Node and two LUN ACL Symlinks for Suse Initiator
> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_0"
> ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_0/."
> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_1"
> ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_1/."
> 
> # Enable the $FABRIC endpoint so it can accept new iSCSI sessions.
> echo 1 > $FABRIC/$DEF_IQN/tpgt_1/enable
> 
> 
> And running....
> 
> 
> target:/sys/kernel/config# tree $FABRIC
> /sys/kernel/config/target/iscsi/
> |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
> |   `-- tpgt_1
> |       |-- acls
> |       |   |-- iqn.1993-08.org.debian:01:2dadf92d0ef
> |       |   |   |-- control
> |       |   |   |-- info
> |       |   |   |-- lun_0
> |       |   |   |   `-- lun_0 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_0
> |       |   |   `-- lun_1
> |       |   |       `-- lun_1 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_1
> |       |   `-- iqn.1996-04.de.suse:01:1661f9ee7b5
> |       |       |-- control
> |       |       |-- info
> |       |       |-- lun_0
> |       |       |   `-- lun_0 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_0
> |       |       `-- lun_1
> |       |           `-- lun_1 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_1
> |       |-- control
> |       |-- enable
> |       |-- lun
> |       |   |-- lun_0
> |       |   |   |-- control
> |       |   |   |-- info
> |       |   |   `-- lio_west_port -> ../../../../../../target/core/iblock_0/lvm_test0
> |       |   `-- lun_1
> |       |       |-- control
> |       |       |-- info
> |       |       `-- lio_east_port -> ../../../../../../target/core/pscsi_0/sdd
> |       `-- np
> |           `-- 172.16.201.137:3260
> |               `-- portal_info
> `-- lio_version
> 
> 20 directories, 12 files
> 
> Note that iSCSI Initiator LUN ACL Symlinks are done on a per TPGT
> context and are only allowed for TPG LUNs under the same
> $FABRIC/$IQN/$TPGT path.

I don't like that limitation. It looks completely artificial for me. And 
this approach doesn't address what to do if there is a connection from 
initiator, for which there is no corresponding ACL entry.

I again strongly suggest you to get familiar with SCST access control 
approach before making the next move. It's proved to be good and we 
should take all the best from it.

> --------------------------------------------------------------------------------
> 
> Dump information for all running iSCSI Sessons on all iSCSI Target
> endpoints..:
> 
> target:/sys/kernel/config# cat $FABRIC/iqn*/tpgt*/acls/*/info
> 
> InitiatorName: iqn.1993-08.org.debian:01:2dadf92d0ef
> InitiatorAlias: ubuntu
> LIO Session ID: 2   ISID: 0x00 02 3d 05 00 00  TSIH: 2  SessionType: Normal
> Cmds in Session Pool: 1  Session State: TARG_SESS_STATE_LOGGED_IN
> ---------------------[iSCSI Session Values]-----------------------
>   CmdSN/WR  :  CmdSN/WC  :  ExpCmdSN  :  MaxCmdSN  :     ITT    :     TTT
>  0x00000010   0x00000010   0x00000042   0x00000051   0x090a0040   0x000000e7
> ----------------------[iSCSI Connections]-------------------------
> CID: 0  Connection State: TARG_CONN_STATE_LOGGED_IN
>    Address 172.16.201.129 TCP  StatSN: 0x0000006c
> InitiatorName: iqn.1996-04.de.suse:01:1661f9ee7b5
> InitiatorAlias: opensuse
> LIO Session ID: 13   ISID: 0x00 02 3d 01 00 00  TSIH: 13  SessionType: Normal
> Cmds in Session Pool: 1  Session State: TARG_SESS_STATE_LOGGED_IN
> ---------------------[iSCSI Session Values]-----------------------
>   CmdSN/WR  :  CmdSN/WC  :  ExpCmdSN  :  MaxCmdSN  :     ITT    :     TTT
>  0x00000010   0x00000010   0x00000022   0x00000031   0x040a0000   0x00000003
> ----------------------[iSCSI Connections]-------------------------
> CID: 0  Connection State: TARG_CONN_STATE_LOGGED_IN
>    Address 172.16.201.136 TCP  StatSN: 0x00000003
> 
> 
> Anyways, you get the idea.  The primary functionality is up for getting
> ACLs iSCSI Initiator Nodes and LUNs symlinked to TPG LUNs symlinked to
> $STORAGE_OBJECTs from target_core_mod.   I will be continuing to convert
> stuff from the IOCTL, mostly things that need to be made into configfs
> attributes.  I am going to focus on the getting the remaining stuff
> under configfs up for iscsi_target_mod, and start looking at the much
> larger todo item of seeing how we can merge target_core_mod and scst
> core..  Please have a look and let me know what you think (espically the
> target_core_mod parts), and I will pull the latest SCST code and start
> looking at the FABRIC <-> TARGET you mentioned..
> 
> --nab
> 
> 

