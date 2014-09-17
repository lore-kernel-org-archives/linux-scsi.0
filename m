From: =?iso-8859-1?Q?Gon=E7alo_Rosa?= <goncalo.rosa@gmail.com>
Subject: RE: CentOS 6.5 tgtadm LUN ID set doesn't work
Date: Wed, 17 Sep 2014 13:51:37 -0500
Message-ID: <000601cfd2a8$69e83cc0$3db8b640$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:62756 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbaIQSvk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Sep 2014 14:51:40 -0400
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-scsi-owner@vger.kernel.org

Hello,

I am having issues to have tgtd to assume specified LUN ID numbers.

I did the following procedure:
tgtadm --lld iscsi --mode target --op new --tid 1 --targetname
iqn.2014-09.local.vclass:tg0
tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 1
--backing-store /dev/sdg
tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 2
--backing-store /dev/sdh
tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 3
--backing-store /dev/sdi
tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 4
--backing-store /dev/sdj
tgtadm --lld iscsi --mode target --op new --tid 2 --targetname
iqn.2014-09.local.vclass:tg1
tgtadm --lld iscsi --mode target --op new --tid 3 --targetname
iqn.2014-09.local.vclass:tg2
tgtadm --lld iscsi --op new --mode logicalunit --tid 2 --lun 5
--backing-store /dev/sde
tgtadm --lld iscsi --op new --mode logicalunit --tid 3 --lun 5
--backing-store /dev/sdf
tgtadm --lld iscsi --op bind --mode target --tid 2 --initiator-address
172.20.10.61
tgtadm --lld iscsi --op bind --mode target --tid 3 --initiator-address
172.20.10.62
tgtadm --mode target --op show
tgt-admin --dump > /etc/tgt/targets.conf

and the tgtadm --mode target --op show output was as shown below:
[root@iscsi ~]# tgtadm --mode target --op show
Target 1: iqn.2014-09.local.vclass:tg0
System information:
Driver: iscsi
State: ready
I_T nexus information:
LUN information:
LUN: 0
Type: controller
SCSI ID: IET 00010000
SCSI SN: beaf10
Size: 0 MB, Block size: 1
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: null
Backing store path: None
Backing store flags:
LUN: 1
Type: disk
SCSI ID: IET 00010001
SCSI SN: beaf11
Size: 10737 MB, Block size: 512
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: rdwr
Backing store path: /dev/sdg
Backing store flags:
LUN: 2
Type: disk
SCSI ID: IET 00010002
SCSI SN: beaf12
Size: 10737 MB, Block size: 512
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: rdwr
Backing store path: /dev/sdh
Backing store flags:
LUN: 3
Type: disk
SCSI ID: IET 00010003
SCSI SN: beaf13
Size: 10737 MB, Block size: 512
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: rdwr
Backing store path: /dev/sdi
Backing store flags:
LUN: 4
Type: disk
SCSI ID: IET 00010004
SCSI SN: beaf14
Size: 10737 MB, Block size: 512
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: rdwr
Backing store path: /dev/sdj
Backing store flags:
Account information:
ACL information:
Target 2: iqn.2014-09.local.vclass:tg1
System information:
Driver: iscsi
State: ready
I_T nexus information:
LUN information:
LUN: 0
Type: controller
SCSI ID: IET 00020000
SCSI SN: beaf20
Size: 0 MB, Block size: 1
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: null
Backing store path: None
Backing store flags:
LUN: 5
Type: disk
SCSI ID: IET 00020005
SCSI SN: beaf25
Size: 10737 MB, Block size: 512
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: rdwr
Backing store path: /dev/sde
Backing store flags:
Account information:
ACL information:
172.20.10.61
Target 3: iqn.2014-09.local.vclass:tg2
System information:
Driver: iscsi
State: ready
I_T nexus information:
LUN information:
LUN: 0
Type: controller
SCSI ID: IET 00030000
SCSI SN: beaf30
Size: 0 MB, Block size: 1
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: null
Backing store path: None
Backing store flags:
LUN: 5
Type: disk
SCSI ID: IET 00030005
SCSI SN: beaf35
Size: 10737 MB, Block size: 512
Online: Yes
Removable media: No
Prevent removal: No
Readonly: No
Backing store type: rdwr
Backing store path: /dev/sdf
Backing store flags:
Account information:
ACL information:
172.20.10.62

My intention is that all LUN IDs should be different per host, so tg0 will
serves shared LUNs 1,2,3 and 4 and tg1 serves LUN 5 to host 172.20.10.61 and
tg2 serves LUN 5 to host 172.20.10.62. I am using CentOS 6.5
After reboot tg1 and tg2 presents the LUNs both with LUN ID 1.
Also added LUN 5 to both targets in /etc/tgt/targets.conf and after reboot
ignores the instruction and still presents with LUN ID 1.

/etc/tgt/targets.conf below:

Default-driver iscsi

backing-store /dev/sdf
LUN 5
initiator-address 172.20.10.62

backing-store /dev/sde
LUN 5
initiator-address 172.20.10.61

backing-store /dev/sdg
backing-store /dev/sdh
backing-store /dev/sdi
backing-store /dev/sdj

Please, can anyone be so kind and help me to fix the LUN IDs?

Thank you in advance.

