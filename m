From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: dm-multipath+iscsi-initiator-core performance results
Date: Mon, 04 Apr 2005 12:22:43 -0700
Message-ID: <1112642563.21326.77.camel@haakon>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-xpbytXVEIuRRINJInix6"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel <dm-devel@redhat.com>, iscsi-initiator-core-devel <iscsi-initiator-core-devel@iscsi-initiator-core.org>, iscsi-initiator-core-announce <iscsi-initiator-core-announce@iscsi-initiator-core.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andre Hedrick <andre@pyxtechnologies.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <mikenc@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org


--=-xpbytXVEIuRRINJInix6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Greetings all,

The following presents benchmarks for dm-multipath in combination with
iscsi-initiator-core over 10Gb/sec Ethernet.  This test's primary
purpose is to show how outer-nexus multipathing using dm-multipath in
conjunction with inter-nexus multiplexing using iscsi-initiator-core can
perform on Linux v2.6 with commodity 64-bit hardware

For this test iSCSI/TCP over IPv4 was used with a single iSCSI Initiator
Node defining two iSCSI Channels to the same physical iSCSI Target Node
via different iSCSI Target Portal Groups. (see diagram below).  A table
is then loaded into dm-multipath containing references to the same LUN
over multiple iSCSI Channels. Tests where run in both single connection
(SC/S) and multiple connection (MC/S) scenarios.  There is a concrete
performance improvement on READs with MC/S (almost 100 MB/sec on 128k).

For more information on iiC, visit http://www.iscsi-initiator-core.org

--------------------------------------------------------------------------

A) iSCSI SAN Topography:

Initiator Node: iqn.2005-02.org.iscsi-initiator-core.org:linux-x86_64

        iscsi-initiator-core v1.6.2.0-rc1 on Linux/x86_64 2.6.12-rc1
        iscsi-initiator-core-tools v2.3
        device-mapper: 4.4.0-ioctl (2005-01-12)
        device-mapper: dm-multipath version 1.0.4
        device-mapper: dm-round-robin version 1.0.0
	multipath-tools v0.4.3

	2x 1.8ghz 242 AMD Opterons w/ 2 GB Memory
	Neterion Xframe 10Gb Ethernet

Target Node: iqn.2002-07.com.pyxtechnologies.target:lad220.linux.x86_64

	PyX Technologies Storage Engine 2.x on Linux/x86_64 2.6.12-rc1
         
        2x 1.8ghz 242 AMD Opterons w/ 2 GB Memory
        Neterion Xframe 10Gb Ethernet

--------------------------------------------------------------------------

B) Diagram:

2 iSCSI Channels - One (1) Connection per Session (SC/S):

  Initiator                      Target
 ___________               _____________________
|           |             |                     |
| Channel 1 |<----------->| TPG 1 192.168.3.220 |\
|           |             |                     |  LUN 0
| Channel 2 |<----------->| TPG 2 192.168.3.221 |/
|___________|             |_____________________|


2 iSCSI Channels - Two (2) iSCSI Connections per Session (MC/S):

  Initiator                      Target
 ___________               _____________________
|           |/<--------->\|                     |
| Channel 1 |\<--------->/| TPG 1 192.168.3.220 |\
|           |             |                     |  LUN 0
| Channel 2 |/<--------->\| TPG 2 192.168.3.221 |/
|___________|\<--------->/|_____________________|

-------------------------------------------------------------------------

C) Performance Results:

Using LTP disktest (see attached files for full output, see below for
configuration):

disktest -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 -B$BLOCK_SIZE

SC/S via 2 iSCSI Channels:

WRITE:

32k: Total write throughput: 227711385.6B/s (217.16MB/s), IOPS 6949.2/s.
64k: Total write throughput: 342947703.5B/s (327.06MB/s), IOPS 5233.0/s.
128k: Total write throughput: 412186487.5B/s (393.09MB/s), IOPS 3144.7/s

MC/S via 2 iSCSI Channels:

WRITE:

32k: Total write throughput: 232743458.1B/s (221.96MB/s), IOPS 7102.8/s.
64k: Total write throughput: 367285589.3B/s (350.27MB/s), IOPS 5604.3/s.
128k: Total write throughput: 451494980.3B/s (430.58MB/s), IOPS 3444.6/s

SC/S via 2 iSCSI Channels:

READ:

32k: Total read throughput: 330224981.3B/s (314.93MB/s), IOPS 10077.7/s.
64k: Total read throughput: 420939912.5B/s (401.44MB/s), IOPS 6423.0/s.
128k: Total read throughput: 435495458.1B/s (415.32MB/s), IOPS 3322.6/s.

2 iSCSI Channels w/ Multiple Connections per Session (MC/S):

READ:

32k: Total read throughput: 364500309.3B/s (347.61MB/s), IOPS 11123.7/s.
64k: Total read throughput: 471708467.2B/s (449.86MB/s), IOPS 7197.7/s.
128k: Total read throughput: 528338124.8B/s (503.86MB/s), IOPS 4030.9/s.

-------------------------------------------------------------------------
 
D) Detailed iSCSI Initiator Node Setup Information:

Single Connection Setup from /etc/sysconfig/initiator

CHANNEL="1 1 eth2 192.168.3.220 3260 0
AuthMethod=CHAP,None;DataDigest=None;MaxRecvDataSegmentLength=262144;MaxBurstLength=262144;FirstBurstLength=262144 tpgfailover=0"
CHANNEL="2 1 eth2 192.168.3.221 3260 0
AuthMethod=CHAP,None;DataDigest=None;MaxRecvDataSegmentLength=262144;MaxBurstLength=262144;FirstBurstLength=262144 tpgfailover=0"

Multiple Connection Setup from /etc/sysconfig/initiator

CHANNEL="1 2 eth2 192.168.3.220 3260 0
AuthMethod=CHAP,None;DataDigest=None;MaxRecvDataSegmentLength=262144;MaxBurstLength=262144;FirstBurstLength=262144 tpgfailover=0"
CHANNEL="2 2 eth2 192.168.3.221 3260 0
AuthMethod=CHAP,None;DataDigest=None;MaxRecvDataSegmentLength=262144;MaxBurstLength=262144;FirstBurstLength=262144 tpgfailover=0"

iSCSI Channel 1 Login and LUN Scan:

CHANNEL[1] - Setting max_sectors: 512
scsi2 : PyX Technologies iSCSI Initiator Core Stack v1.6.2.0-rc1-OSS on
Linux/x86_64 2.6.12-rc1
iCHANNEL[1] - Allocated Linux SCSI Host with ID: 3
Received OK response from PyX Authentication Daemon, continuing.
Received OK response from PyX Authentication Daemon, continuing.
iSCSI mutual authetication completed successfully.
RFC-3720[1] - Setting OFMarker value to 31892 based on FIM
RFC-3720[1] - Setting IFMarker value to 32136 based on FIM
iCHANNEL[1] - iSCSI login successful on CID: 0 to 192.168.3.220:3260,1
iCHANNEL[1] - Incremented iSCSI connection count to 1 to node:
iqn.2002-07.com.pyxtechnologies.target:lad220.li
nux.x86_64
iCHANNEL[1] - Established iSCSI session to node:
iqn.2002-07.com.pyxtechnologies.target:lad220.linux.x86_64
iSCSI Core Stack[1] - Incremented number of active iSCSI sessions to 1.
  Vendor: PYX-TECH  Model: RAMDISK-DR        Rev: 02  
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sdb: 2400000 512-byte hdwr sectors (1229 MB)
sdb: asking for cache data failed
sdb: assuming drive cache: write through
SCSI device sdb: 2400000 512-byte hdwr sectors (1229 MB)
sdb: asking for cache data failed
sdb: assuming drive cache: write through
 sdb: unknown partition table
Attached scsi disk sdb at scsi2, channel 0, id 0, lun 0
Received OK response from PyX Authentication Daemon, continuing.
Received OK response from PyX Authentication Daemon, continuing.
iSCSI mutual authetication completed successfully.
RFC-3720[1] - Setting OFMarker value to 32296 based on FIM
RFC-3720[1] - Setting IFMarker value to 32348 based on FIM
iCHANNEL[1] - iSCSI Login successful on CID: 1 to 192.168.3.220:3260,1
iCHANNEL[1] - Incremented iSCSI connection count to 2 to node:
iqn.2002-07.com.pyxtechnologies.target:lad220.linux.x86_64

iSCSI Channel 2 Login and LUN Scan:

iCHANNEL[2] - Setting max_sectors: 512
scsi3 : PyX Technologies iSCSI Initiator Core Stack v1.6.2.0-rc1-OSS on
Linux/x86_64 2.6.12-rc1
iCHANNEL[2] - Allocated Linux SCSI Host with ID: 3
Received OK response from PyX Authentication Daemon, continuing.
Received OK response from PyX Authentication Daemon, continuing.
iSCSI mutual authetication completed successfully.
iCHANNEL[2] - iSCSI login successful on CID: 0 to 192.168.3.221:3260,2
iCHANNEL[2] - Incremented iSCSI connection count to 1 to node:
iqn.2002-07.com.pyxtechnologies.target:lad220.li
nux.x86_64
iCHANNEL[2] - Established iSCSI session to node:
iqn.2002-07.com.pyxtechnologies.target:lad220.linux.x86_64
iSCSI Core Stack[1] - Incremented number of active iSCSI sessions to 2.
iSCSI Core Stack[1] - Spawned 1 thread set(s) (2 total threads).
  Vendor: PYX-TECH  Model: RAMDISK-DR        Rev: 02  
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sdc: 2400000 512-byte hdwr sectors (1229 MB)
sdc: asking for cache data failed
sdc: assuming drive cache: write through
SCSI device sdc: 2400000 512-byte hdwr sectors (1229 MB)
sdc: asking for cache data failed
sdc: assuming drive cache: write through
 sdc: unknown partition table
Attached scsi disk sdc at scsi3, channel 0, id 0, lun 0
Received OK response from PyX Authentication Daemon, continuing.
Received OK response from PyX Authentication Daemon, continuing.
iSCSI mutual authetication completed successfully.
iCHANNEL[2] - iSCSI Login successful on CID: 1 to 192.168.3.221:3260,2
iCHANNEL[2] - Incremented iSCSI connection count to 2 to node:
iqn.2002-07.com.pyxtechnologies.target:lad220.linux.x86_64
iSCSI Core Stack[1] - Spawned 1 thread set(s) (2 total threads).


device-mapper table was created with:

echo "0 2400000 multipath 0 0 2 1 round-robin 0 2 1 8:16 1000 8:32 1000
round-robin 0 2 1 8:16 1000 8:32 1000" | dmsetup create dm0

----------------------------------------------------------------

Thanks!

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>

--=-xpbytXVEIuRRINJInix6
Content-Disposition: attachment; filename=disktest-2chan-1conn-read-128k.txt
Content-Type: text/plain; name=disktest-2chan-1conn-read-128k.txt;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

[root@lad210 iscsi-initiator-core]# disktest -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 -B131072
| 2005/04/04-03:08:33 | START | 17260 | v1.1.12 | /dev/mapper/dm0 | Start args: -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 (-N 2000) (-c) (-p r) (-L 7) (-D 100:0)
| 2005/04/04-03:08:33 | INFO  | 17260 | v1.1.12 | /dev/mapper/dm0 | Starting pass
| 2005/04/04-03:08:36 | STAT  | 17260 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 441057280.0B/s (420.62MB/s), IOPS 3367.7/s.
| 2005/04/04-03:08:39 | STAT  | 17260 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 441428650.7B/s (420.98MB/s), IOPS 3369.2/s.
| 2005/04/04-03:08:42 | STAT  | 17260 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 441232042.7B/s (420.79MB/s), IOPS 3367.2/s.
| 2005/04/04-03:08:45 | STAT  | 17260 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 441133738.7B/s (420.70MB/s), IOPS 3366.2/s.
| 2005/04/04-03:08:48 | STAT  | 17260 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 441118446.9B/s (420.68MB/s), IOPS 3366.0/s.
| 2005/04/04-03:08:51 | STAT  | 17260 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 441064561.8B/s (420.63MB/s), IOPS 3365.5/s.
| 2005/04/04-03:08:54 | STAT  | 17260 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 440770169.9B/s (420.35MB/s), IOPS 3363.2/s.
| 2005/04/04-03:08:57 | STAT  | 17260 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 440806058.7B/s (420.39MB/s), IOPS 3363.4/s.
| 2005/04/04-03:09:00 | STAT  | 17260 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 441100970.7B/s (420.67MB/s), IOPS 3365.6/s.
| 2005/04/04-03:09:03 | STAT  | 17260 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 435495458.1B/s (415.32MB/s), IOPS 3322.6/s.
| 2005/04/04-03:09:03 | STAT  | 17260 | v1.1.12 | /dev/mapper/dm0 | Total read throughput: 435495458.1B/s (415.32MB/s), IOPS 3322.6/s.
| 2005/04/04-03:09:03 | END   | 17260 | v1.1.12 | /dev/mapper/dm0 | Test Done (Passed)


--=-xpbytXVEIuRRINJInix6
Content-Disposition: attachment; filename=disktest-2chan-1conn-read-32k.txt
Content-Type: text/plain; name=disktest-2chan-1conn-read-32k.txt;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

[root@lad210 iscsi-initiator-core]# disktest -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 -B32768
| 2005/04/04-03:09:18 | START | 17270 | v1.1.12 | /dev/mapper/dm0 | Start args: -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 (-N 2000) (-c) (-p r) (-L 31) (-D 100:0)
| 2005/04/04-03:09:18 | INFO  | 17270 | v1.1.12 | /dev/mapper/dm0 | Starting pass
| 2005/04/04-03:09:21 | STAT  | 17270 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 336811349.3B/s (321.21MB/s), IOPS 10281.3/s.
| 2005/04/04-03:09:24 | STAT  | 17270 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 341136725.3B/s (325.33MB/s), IOPS 10412.0/s.
| 2005/04/04-03:09:27 | STAT  | 17270 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 340401265.8B/s (324.63MB/s), IOPS 10389.1/s.
| 2005/04/04-03:09:30 | STAT  | 17270 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 340525056.0B/s (324.75MB/s), IOPS 10392.7/s.
| 2005/04/04-03:09:33 | STAT  | 17270 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 340634282.7B/s (324.85MB/s), IOPS 10395.9/s.
| 2005/04/04-03:09:36 | STAT  | 17270 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 340754432.0B/s (324.97MB/s), IOPS 10399.4/s.
| 2005/04/04-03:09:39 | STAT  | 17270 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 340882383.2B/s (325.09MB/s), IOPS 10403.3/s.
| 2005/04/04-03:09:42 | STAT  | 17270 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 340915541.3B/s (325.12MB/s), IOPS 10404.2/s.
| 2005/04/04-03:09:45 | STAT  | 17270 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 340344225.2B/s (324.58MB/s), IOPS 10386.8/s.
| 2005/04/04-03:09:48 | STAT  | 17270 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 330224981.3B/s (314.93MB/s), IOPS 10077.7/s.
| 2005/04/04-03:09:48 | STAT  | 17270 | v1.1.12 | /dev/mapper/dm0 | Total read throughput: 330224981.3B/s (314.93MB/s), IOPS 10077.7/s.
| 2005/04/04-03:09:48 | END   | 17270 | v1.1.12 | /dev/mapper/dm0 | Test Done (Passed

--=-xpbytXVEIuRRINJInix6
Content-Disposition: attachment; filename=disktest-2chan-1conn-read-64k.txt
Content-Type: text/plain; name=disktest-2chan-1conn-read-64k.txt;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

[root@lad210 iscsi-initiator-core]# disktest -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 -B65536
| 2005/04/04-03:06:50 | START | 17240 | v1.1.12 | /dev/mapper/dm0 | Start args: -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 (-N 2000) (-c) (-p r) (-L 15) (-D 100:0)
| 2005/04/04-03:06:50 | INFO  | 17240 | v1.1.12 | /dev/mapper/dm0 | Starting pass
| 2005/04/04-03:06:53 | STAT  | 17240 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 428102997.3B/s (408.27MB/s), IOPS 6535.0/s.
| 2005/04/04-03:06:56 | STAT  | 17240 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 427709781.3B/s (407.90MB/s), IOPS 6527.7/s.
| 2005/04/04-03:06:59 | STAT  | 17240 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 426653923.6B/s (406.89MB/s), IOPS 6511.1/s.
| 2005/04/04-03:07:02 | STAT  | 17240 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 425787392.0B/s (406.06MB/s), IOPS 6497.7/s.
| 2005/04/04-03:07:05 | STAT  | 17240 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 427111219.2B/s (407.32MB/s), IOPS 6517.7/s.
| 2005/04/04-03:07:08 | STAT  | 17240 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 427411228.4B/s (407.61MB/s), IOPS 6522.2/s.
| 2005/04/04-03:07:11 | STAT  | 17240 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 427753472.0B/s (407.94MB/s), IOPS 6527.4/s.
| 2005/04/04-03:07:14 | STAT  | 17240 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 426571093.3B/s (406.81MB/s), IOPS 6509.3/s.
| 2005/04/04-03:07:17 | STAT  | 17240 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 425920891.3B/s (406.19MB/s), IOPS 6499.3/s.
| 2005/04/04-03:07:20 | STAT  | 17240 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 420939912.5B/s (401.44MB/s), IOPS 6423.0/s.
| 2005/04/04-03:07:20 | STAT  | 17240 | v1.1.12 | /dev/mapper/dm0 | Total read throughput: 420939912.5B/s (401.44MB/s), IOPS 6423.0/s.
| 2005/04/04-03:07:20 | END   | 17240 | v1.1.12 | /dev/mapper/dm0 | Test Done (Passed)


--=-xpbytXVEIuRRINJInix6
Content-Disposition: attachment; filename=disktest-2chan-1conn-write-128k.txt
Content-Type: text/plain; name=disktest-2chan-1conn-write-128k.txt;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

[root@lad210 iscsi-initiator-core]# disktest -K8 -ID -PT -h3 -T30 -w /dev/mapper/dm0 -B131072
| 2005/04/04-03:10:07 | START | 17285 | v1.1.12 | /dev/mapper/dm0 | Start args: -K8 -ID -PT -h3 -T30 -w /dev/mapper/dm0 (-N 2000) (-c) (-p r) (-L 7) (-D 0:100)
| 2005/04/04-03:10:07 | INFO  | 17285 | v1.1.12 | /dev/mapper/dm0 | Starting pass
| 2005/04/04-03:10:10 | STAT  | 17285 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 396405418.7B/s (378.04MB/s), IOPS 3027.0/s.
| 2005/04/04-03:10:13 | STAT  | 17285 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 407262549.3B/s (388.40MB/s), IOPS 3108.5/s.
| 2005/04/04-03:10:16 | STAT  | 17285 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 410998101.3B/s (391.96MB/s), IOPS 3136.6/s.
| 2005/04/04-03:10:19 | STAT  | 17285 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 413412010.7B/s (394.26MB/s), IOPS 3154.8/s.
| 2005/04/04-03:10:22 | STAT  | 17285 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 413628279.5B/s (394.47MB/s), IOPS 3156.3/s.
| 2005/04/04-03:10:25 | STAT  | 17285 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 414369564.4B/s (395.17MB/s), IOPS 3161.8/s.
| 2005/04/04-03:10:28 | STAT  | 17285 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 414175037.0B/s (394.99MB/s), IOPS 3160.3/s.
| 2005/04/04-03:10:31 | STAT  | 17285 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 414930261.3B/s (395.71MB/s), IOPS 3166.0/s.
| 2005/04/04-03:10:34 | STAT  | 17285 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 414910843.3B/s (395.69MB/s), IOPS 3165.8/s.
| 2005/04/04-03:10:37 | STAT  | 17285 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 412186487.5B/s (393.09MB/s), IOPS 3144.7/s.
| 2005/04/04-03:10:37 | STAT  | 17285 | v1.1.12 | /dev/mapper/dm0 | Total write throughput: 412186487.5B/s (393.09MB/s), IOPS 3144.7/s.
| 2005/04/04-03:10:37 | END   | 17285 | v1.1.12 | /dev/mapper/dm0 | Test Done (Passed)


--=-xpbytXVEIuRRINJInix6
Content-Disposition: attachment; filename=disktest-2chan-1conn-write-32k.txt
Content-Type: text/plain; name=disktest-2chan-1conn-write-32k.txt;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

[root@lad210 iscsi-initiator-core]# disktest -K8 -ID -PT -h3 -T30 -w /dev/mapper/dm0 -B32768
| 2005/04/04-03:11:57 | START | 17315 | v1.1.12 | /dev/mapper/dm0 | Start args: -K8 -ID -PT -h3 -T30 -w /dev/mapper/dm0 (-N 2000) (-c) (-p r) (-L 31) (-D 0:100)
| 2005/04/04-03:11:57 | INFO  | 17315 | v1.1.12 | /dev/mapper/dm0 | Starting pass
| 2005/04/04-03:12:00 | STAT  | 17315 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 61756757.3B/s (58.90MB/s), IOPS 1887.3/s.
| 2005/04/04-03:12:03 | STAT  | 17315 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 156598272.0B/s (149.34MB/s), IOPS 4780.3/s.
| 2005/04/04-03:12:06 | STAT  | 17315 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 187775203.6B/s (179.08MB/s), IOPS 5731.3/s.
| 2005/04/04-03:12:09 | STAT  | 17315 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 202984106.7B/s (193.58MB/s), IOPS 6195.2/s.
| 2005/04/04-03:12:12 | STAT  | 17315 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 212415283.2B/s (202.57MB/s), IOPS 6482.9/s.
| 2005/04/04-03:12:15 | STAT  | 17315 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 218755527.1B/s (208.62MB/s), IOPS 6676.3/s.
| 2005/04/04-03:12:18 | STAT  | 17315 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 222967515.4B/s (212.64MB/s), IOPS 6804.8/s.
| 2005/04/04-03:12:21 | STAT  | 17315 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 226155178.7B/s (215.68MB/s), IOPS 6902.0/s.
| 2005/04/04-03:12:24 | STAT  | 17315 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 228335919.4B/s (217.76MB/s), IOPS 6968.6/s.
| 2005/04/04-03:12:27 | STAT  | 17315 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 227711385.6B/s (217.16MB/s), IOPS 6949.2/s.
| 2005/04/04-03:12:27 | STAT  | 17315 | v1.1.12 | /dev/mapper/dm0 | Total write throughput: 227711385.6B/s (217.16MB/s), IOPS 6949.2/s.
| 2005/04/04-03:12:27 | END   | 17315 | v1.1.12 | /dev/mapper/dm0 | Test Done (Passed)


--=-xpbytXVEIuRRINJInix6
Content-Disposition: attachment; filename=disktest-2chan-1conn-write-64k.txt
Content-Type: text/plain; name=disktest-2chan-1conn-write-64k.txt;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

[root@lad210 iscsi-initiator-core]# disktest -K8 -ID -PT -h3 -T30 -w /dev/mapper/dm0 -B65536
| 2005/04/04-03:10:56 | START | 17295 | v1.1.12 | /dev/mapper/dm0 | Start args: -K8 -ID -PT -h3 -T30 -w /dev/mapper/dm0 (-N 2000) (-c) (-p r) (-L 15) (-D 0:100)
| 2005/04/04-03:10:56 | INFO  | 17295 | v1.1.12 | /dev/mapper/dm0 | Starting pass
| 2005/04/04-03:10:59 | STAT  | 17295 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 299062613.3B/s (285.21MB/s), IOPS 4566.0/s.
| 2005/04/04-03:11:02 | STAT  | 17295 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 328684885.3B/s (313.46MB/s), IOPS 5016.7/s.
| 2005/04/04-03:11:05 | STAT  | 17295 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 340889144.9B/s (325.10MB/s), IOPS 5202.4/s.
| 2005/04/04-03:11:08 | STAT  | 17295 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 346466986.7B/s (330.42MB/s), IOPS 5287.3/s.
| 2005/04/04-03:11:11 | STAT  | 17295 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 350368563.2B/s (334.14MB/s), IOPS 5346.7/s.
| 2005/04/04-03:11:14 | STAT  | 17295 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 351822734.2B/s (335.52MB/s), IOPS 5368.8/s.
| 2005/04/04-03:11:17 | STAT  | 17295 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 354159664.8B/s (337.75MB/s), IOPS 5404.4/s.
| 2005/04/04-03:11:20 | STAT  | 17295 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 354320384.0B/s (337.91MB/s), IOPS 5406.8/s.
| 2005/04/04-03:11:23 | STAT  | 17295 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 354372570.1B/s (337.96MB/s), IOPS 5407.6/s.
| 2005/04/04-03:11:26 | STAT  | 17295 | v1.1.12 | /dev/mapper/dm0 | Total write throughput: 342947703.5B/s (327.06MB/s), IOPS 5233.0/s.
| 2005/04/04-03:11:26 | END   | 17295 | v1.1.12 | /dev/mapper/dm0 | Test Done (Passed)


--=-xpbytXVEIuRRINJInix6
Content-Disposition: attachment; filename=disktest-2chan-2conn-read-128k.txt
Content-Type: text/plain; name=disktest-2chan-2conn-read-128k.txt;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

[root@lad210 iscsi-initiator-core]# disktest -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 -B131072
| 2005/04/04-03:38:05 | START | 3824 | v1.1.12 | /dev/mapper/dm0 | Start args: -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 (-N 2000) (-c) (-p r) (-L 7) (-D 100:0)
| 2005/04/04-03:38:05 | INFO  | 3824 | v1.1.12 | /dev/mapper/dm0 | Starting pass
| 2005/04/04-03:38:08 | STAT  | 3824 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 531103744.0B/s (506.50MB/s), IOPS 4054.7/s.
| 2005/04/04-03:38:11 | STAT  | 3824 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 529771178.7B/s (505.23MB/s), IOPS 4043.2/s.
| 2005/04/04-03:38:14 | STAT  | 3824 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 530317312.0B/s (505.75MB/s), IOPS 4046.9/s.
| 2005/04/04-03:38:17 | STAT  | 3824 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 531289429.3B/s (506.68MB/s), IOPS 4054.1/s.
| 2005/04/04-03:38:20 | STAT  | 3824 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 530561979.7B/s (505.98MB/s), IOPS 4048.4/s.
| 2005/04/04-03:38:23 | STAT  | 3824 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 531802794.7B/s (507.17MB/s), IOPS 4057.8/s.
| 2005/04/04-03:38:26 | STAT  | 3824 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 531915142.1B/s (507.27MB/s), IOPS 4058.6/s.
| 2005/04/04-03:38:29 | STAT  | 3824 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 531726336.0B/s (507.09MB/s), IOPS 4057.1/s.
| 2005/04/04-03:38:32 | STAT  | 3824 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 530603728.6B/s (506.02MB/s), IOPS 4048.5/s.
| 2005/04/04-03:38:35 | STAT  | 3824 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 528338124.8B/s (503.86MB/s), IOPS 4030.9/s.
| 2005/04/04-03:38:35 | STAT  | 3824 | v1.1.12 | /dev/mapper/dm0 | Total read throughput: 528338124.8B/s (503.86MB/s), IOPS 4030.9/s.
| 2005/04/04-03:38:35 | END   | 3824 | v1.1.12 | /dev/mapper/dm0 | Test Done (Passed)


--=-xpbytXVEIuRRINJInix6
Content-Disposition: attachment; filename=disktest-2chan-2conn-read-32k.txt
Content-Type: text/plain; name=disktest-2chan-2conn-read-32k.txt;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

[root@lad210 iscsi-initiator-core]# disktest -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 -B32768
| 2005/04/04-03:25:34 | START | 17578 | v1.1.12 | /dev/mapper/dm0 | Start args: -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 (-N 2000) (-c) (-p r) (-L 31) (-D 100:0)
| 2005/04/04-03:25:34 | INFO  | 17578 | v1.1.12 | /dev/mapper/dm0 | Starting pass
| 2005/04/04-03:25:37 | STAT  | 17578 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 362872832.0B/s (346.06MB/s), IOPS 11076.7/s.
| 2005/04/04-03:25:40 | STAT  | 17578 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 368525312.0B/s (351.45MB/s), IOPS 11247.8/s.
| 2005/04/04-03:25:43 | STAT  | 17578 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 369899747.6B/s (352.76MB/s), IOPS 11289.3/s.
| 2005/04/04-03:25:46 | STAT  | 17578 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 369650346.7B/s (352.53MB/s), IOPS 11281.5/s.
| 2005/04/04-03:25:49 | STAT  | 17578 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 370265292.8B/s (353.11MB/s), IOPS 11300.1/s.
| 2005/04/04-03:25:52 | STAT  | 17578 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 370078151.1B/s (352.93MB/s), IOPS 11294.3/s.
| 2005/04/04-03:25:55 | STAT  | 17578 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 369423311.2B/s (352.31MB/s), IOPS 11274.3/s.
| 2005/04/04-03:25:58 | STAT  | 17578 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 369883818.7B/s (352.75MB/s), IOPS 11288.3/s.
| 2005/04/04-03:26:01 | STAT  | 17578 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 369944651.9B/s (352.81MB/s), IOPS 11290.1/s.
| 2005/04/04-03:26:04 | STAT  | 17578 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 364500309.3B/s (347.61MB/s), IOPS 11123.7/s.
| 2005/04/04-03:26:04 | STAT  | 17578 | v1.1.12 | /dev/mapper/dm0 | Total read throughput: 364500309.3B/s (347.61MB/s), IOPS 11123.7/s.
| 2005/04/04-03:26:04 | END   | 17578 | v1.1.12 | /dev/mapper/dm0 | Test Done (Passed)

--=-xpbytXVEIuRRINJInix6
Content-Disposition: attachment; filename=disktest-2chan-2conn-read-64k.txt
Content-Type: text/plain; name=disktest-2chan-2conn-read-64k.txt;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

[root@lad210 iscsi-initiator-core]# disktest -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 -B65536
| 2005/04/04-03:36:09 | START | 3794 | v1.1.12 | /dev/mapper/dm0 | Start args: -K8 -ID -PT -h3 -T30 -r /dev/mapper/dm0 (-N 2000) (-c) (-p r) (-L 15) (-D 100:0)
| 2005/04/04-03:36:09 | INFO  | 3794 | v1.1.12 | /dev/mapper/dm0 | Starting pass
| 2005/04/04-03:36:12 | STAT  | 3794 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 478412800.0B/s (456.25MB/s), IOPS 7302.7/s.
| 2005/04/04-03:36:15 | STAT  | 3794 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 476206421.3B/s (454.15MB/s), IOPS 7267.7/s.
| 2005/04/04-03:36:18 | STAT  | 3794 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 479519630.2B/s (457.31MB/s), IOPS 7317.8/s.
| 2005/04/04-03:36:21 | STAT  | 3794 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 482028202.7B/s (459.70MB/s), IOPS 7355.8/s.
| 2005/04/04-03:36:24 | STAT  | 3794 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 481331336.5B/s (459.03MB/s), IOPS 7345.1/s.
| 2005/04/04-03:36:27 | STAT  | 3794 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 479894641.8B/s (457.66MB/s), IOPS 7323.1/s.
| 2005/04/04-03:36:30 | STAT  | 3794 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 479227318.9B/s (457.03MB/s), IOPS 7312.8/s.
| 2005/04/04-03:36:33 | STAT  | 3794 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 478907050.7B/s (456.72MB/s), IOPS 7307.9/s.
| 2005/04/04-03:36:36 | STAT  | 3794 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 477730740.1B/s (455.60MB/s), IOPS 7289.9/s.
| 2005/04/04-03:36:39 | STAT  | 3794 | v1.1.12 | /dev/mapper/dm0 | Read throughput: 471708467.2B/s (449.86MB/s), IOPS 7197.7/s.
| 2005/04/04-03:36:39 | STAT  | 3794 | v1.1.12 | /dev/mapper/dm0 | Total read throughput: 471708467.2B/s (449.86MB/s), IOPS 7197.7/s.
| 2005/04/04-03:36:39 | END   | 3794 | v1.1.12 | /dev/mapper/dm0 | Test Done (Passed)


--=-xpbytXVEIuRRINJInix6
Content-Description: 
Content-Disposition: attachment; filename=disktest-2chan-2conn-write-128k.txt
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

[root@lad210 iscsi-initiator-core]# disktest -K8 -ID -PT -h3 -T30 -w /dev/mapper/dm0 -B131072
| 2005/04/04-03:55:06 | START | 4148 | v1.1.12 | /dev/mapper/dm0 | Start args: -K8 -ID -PT -h3 -T30 -w /dev/mapper/dm0 (-N 2000) (-c) (-p r) (-L 7) (-D 0:100)
| 2005/04/04-03:55:06 | INFO  | 4148 | v1.1.12 | /dev/mapper/dm0 | Starting pass
| 2005/04/04-03:55:09 | STAT  | 4148 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 442411690.7B/s (421.92MB/s), IOPS 3378.0/s.
| 2005/04/04-03:55:12 | STAT  | 4148 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 451499349.3B/s (430.58MB/s), IOPS 3446.0/s.
| 2005/04/04-03:55:15 | STAT  | 4148 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 450887680.0B/s (430.00MB/s), IOPS 3440.9/s.
| 2005/04/04-03:55:18 | STAT  | 4148 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 451848874.7B/s (430.92MB/s), IOPS 3448.0/s.
| 2005/04/04-03:55:21 | STAT  | 4148 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 453351833.6B/s (432.35MB/s), IOPS 3459.3/s.
| 2005/04/04-03:55:24 | STAT  | 4148 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 454703331.6B/s (433.64MB/s), IOPS 3469.6/s.
| 2005/04/04-03:55:27 | STAT  | 4148 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 455475200.0B/s (434.38MB/s), IOPS 3475.4/s.
| 2005/04/04-03:55:30 | STAT  | 4148 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 455163904.0B/s (434.08MB/s), IOPS 3473.0/s.
| 2005/04/04-03:55:33 | STAT  | 4148 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 455620835.6B/s (434.51MB/s), IOPS 3476.4/s.
| 2005/04/04-03:55:36 | STAT  | 4148 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 451494980.3B/s (430.58MB/s), IOPS 3444.6/s.
| 2005/04/04-03:55:36 | STAT  | 4148 | v1.1.12 | /dev/mapper/dm0 | Total write throughput: 451494980.3B/s (430.58MB/s), IOPS 3444.6/s.
| 2005/04/04-03:55:36 | END   | 4148 | v1.1.12 | /dev/mapper/dm0 | Test Done (Passed)


--=-xpbytXVEIuRRINJInix6
Content-Disposition: attachment; filename=disktest-2chan-2conn-write-32k.txt
Content-Type: text/plain; name=disktest-2chan-2conn-write-32k.txt;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

[root@lad210 iscsi-initiator-core]# disktest -K8 -ID -PT -h3 -T30 -w /dev/mapper/dm0 -B32768
| 2005/04/04-04:01:00 | START | 4253 | v1.1.12 | /dev/mapper/dm0 | Start args: -K8 -ID -PT -h3 -T30 -w /dev/mapper/dm0 (-N 2000) (-c) (-p r) (-L 31) (-D 0:100)
| 2005/04/04-04:01:00 | INFO  | 4253 | v1.1.12 | /dev/mapper/dm0 | Starting pass
| 2005/04/04-04:01:03 | STAT  | 4253 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 149454848.0B/s (142.53MB/s), IOPS 4563.7/s.
| 2005/04/04-04:01:06 | STAT  | 4253 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 200392704.0B/s (191.11MB/s), IOPS 6116.8/s.
| 2005/04/04-04:01:09 | STAT  | 4253 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 217051591.1B/s (207.00MB/s), IOPS 6624.8/s.
| 2005/04/04-04:01:12 | STAT  | 4253 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 224529066.7B/s (214.13MB/s), IOPS 6852.8/s.
| 2005/04/04-04:01:15 | STAT  | 4253 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 230031360.0B/s (219.38MB/s), IOPS 7020.5/s.
| 2005/04/04-04:01:18 | STAT  | 4253 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 233007786.7B/s (222.21MB/s), IOPS 7111.3/s.
| 2005/04/04-04:01:21 | STAT  | 4253 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 234948120.4B/s (224.06MB/s), IOPS 7170.4/s.
| 2005/04/04-04:01:24 | STAT  | 4253 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 236113920.0B/s (225.18MB/s), IOPS 7206.0/s.
| 2005/04/04-04:01:27 | STAT  | 4253 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 236654136.9B/s (225.69MB/s), IOPS 7222.4/s.
| 2005/04/04-04:01:30 | STAT  | 4253 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 232743458.1B/s (221.96MB/s), IOPS 7102.8/s.
| 2005/04/04-04:01:30 | STAT  | 4253 | v1.1.12 | /dev/mapper/dm0 | Total write throughput: 232743458.1B/s (221.96MB/s), IOPS 7102.8/s.
| 2005/04/04-04:01:30 | END   | 4253 | v1.1.12 | /dev/mapper/dm0 | Test Done (Passed)


--=-xpbytXVEIuRRINJInix6
Content-Disposition: attachment; filename=disktest-2chan-2conn-write-64k.txt
Content-Type: text/plain; name=disktest-2chan-2conn-write-64k.txt;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

[root@lad210 iscsi-initiator-core]# disktest -K8 -ID -PT -h3 -T30 -w /dev/mapper/dm0 -B65536
| 2005/04/04-03:57:12 | START | 4178 | v1.1.12 | /dev/mapper/dm0 | Start args: -K8 -ID -PT -h3 -T30 -w /dev/mapper/dm0 (-N 2000) (-c) (-p r) (-L 15) (-D 0:100)
| 2005/04/04-03:57:12 | INFO  | 4178 | v1.1.12 | /dev/mapper/dm0 | Starting pass
| 2005/04/04-03:57:15 | STAT  | 4178 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 304698709.3B/s (290.58MB/s), IOPS 4652.0/s.
| 2005/04/04-03:57:18 | STAT  | 4178 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 343605248.0B/s (327.69MB/s), IOPS 5244.3/s.
| 2005/04/04-03:57:21 | STAT  | 4178 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 359654286.2B/s (342.99MB/s), IOPS 5488.8/s.
| 2005/04/04-03:57:24 | STAT  | 4178 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 362845525.3B/s (346.04MB/s), IOPS 5537.2/s.
| 2005/04/04-03:57:27 | STAT  | 4178 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 366804992.0B/s (349.81MB/s), IOPS 5597.5/s.
| 2005/04/04-03:57:30 | STAT  | 4178 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 370161891.6B/s (353.01MB/s), IOPS 5648.7/s.
| 2005/04/04-03:57:33 | STAT  | 4178 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 373168225.5B/s (355.88MB/s), IOPS 5694.5/s.
| 2005/04/04-03:57:36 | STAT  | 4178 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 376392362.7B/s (358.96MB/s), IOPS 5743.6/s.
| 2005/04/04-03:57:39 | STAT  | 4178 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 376909672.3B/s (359.45MB/s), IOPS 5751.5/s.
| 2005/04/04-03:57:42 | STAT  | 4178 | v1.1.12 | /dev/mapper/dm0 | Write throughput: 367285589.3B/s (350.27MB/s), IOPS 5604.3/s.
| 2005/04/04-03:57:42 | STAT  | 4178 | v1.1.12 | /dev/mapper/dm0 | Total write throughput: 367285589.3B/s (350.27MB/s), IOPS 5604.3/s.
| 2005/04/04-03:57:42 | END   | 4178 | v1.1.12 | /dev/mapper/dm0 | Test Done (Passed)


--=-xpbytXVEIuRRINJInix6
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-xpbytXVEIuRRINJInix6--
