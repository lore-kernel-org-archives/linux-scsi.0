From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: [ANNOUNCE] iSCSI Initiator Core Tools v2.1
Date: Fri, 11 Mar 2005 13:16:09 -0800
Message-ID: <1110575769.7247.34.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from smtp817.mail.sc5.yahoo.com ([66.163.170.3]:34415 "HELO
	smtp817.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261253AbVCKVaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 16:30:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, iscsi-initiator-core-announce <iscsi-initiator-core-announce@iscsi-initiator-core.org>

The following is v2.1 of iSCSI Initiator Core Tools.  This release
includes many enhancements and manual page updates.  Attached is an
explanation about the two main configuration files of the iiC Stack.

The v2.1 will be appearing shortly at:

http://www.kernel.org/pub/linux/utils/storage/iscsi/

The following is a short howto to get developers and users up to speed.
Please join the lists at http://iscsi-initiator-core.org and give me
your feedback.

/etc/sysconfig/initiator:

#
# Use '#CHANNEL="N 8 eth16 11.23.34.45 3260"' to disable a defined iSCSI
CHANNEL
#
# Arguments:
#        iSCSI Channel (1 iSCSI Session for N Logical Units per
CHANNEL=)
#        | iSCSI IPv4 Connection Count for iSCSI Session
#        | | Network Interconnect Device Name
#        | |  |   IPv4 iSCSI Target Node Address
#        | |  |         |       iSCSI Target Service Port
#        | |  |         |         |
CHANNEL="0 2 eth0 192.168.0.1 3260"    # Example Target 1
CHANNEL="0 2 eth1 192.168.1.1 3260"    # ""    ""      ""

The following multiplexes 4 (four) connections over two different
ethernet ports to the same iSCSI Target Node.

CHANNEL="1 2 eth0 192.168.0.2 3260"    # Example Target 2
CHANNEL="1 2 eth1 192.168.1.2 3260"    # ""    ""      ""

The following does the same as above, but over a different iSCSI     
Channel.  Each iSCSI Target Node's Target Portal Group MUST have its 
own CHANNEL entry defined:

/etc/sysconfig/iscsi_device_maps

#
#       iSCSI Channel ID 
#       | iSCSI Logical Unit Number
#       | | Parition Number
#       | | |     
#       | | |   iSCSI device mount point
#       | | |    |
DEVICE="0 0 1 disk0a"
DEVICE="0 0 2 disk0b"
DEVICE="0 1 1 disk1a"
DEVICE="0 2 1 disk2a"

On iSCSI Channel 0:

LUN 0/Partition 1 gets mounted at: /iqn.target.example1/disk0a
LUN 0/Partition 2 gets mounted at: /iqn.target.example1/disk0b
LUN 1/Partition 1 gets mounted at: /iqn.target.example1/disk1a
LUN 2/Partition 1 gets mounted at: /iqn.target.example1/disk2a

DEVICE="1 0 0 dvd0"
DEVICE="1 1 1 disk0a"
DEVICE="1 1 2 disk0b"
DEVICE="1 2 1 disk1a"

On iSCSI Channel 1:

LUN 0/Partition 0 (DVD-ROM) gets mounted at: /iqn.target.example2/dvd0
LUN 1/Partition 1 gets mounted at: /iqn.target.example2/disk0a
LUN 1/Partition 2 gets mounted at: /iqn.target.example2/disk1b
LUN 2/Partition 1 gets mounted at: /iqn.target.example2/disk1a


-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>

