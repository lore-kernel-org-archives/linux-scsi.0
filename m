From: Patrick Mansfield <patmans@us.ibm.com>
Subject: examples using sysfs attributes to scan and delete scsi_devices
Date: Tue, 8 Jul 2003 13:41:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708134147.A32189@beaverton.ibm.com>
References: <20030708134016.A32161@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:20459 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S265341AbTGHU1V
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jul 2003 16:27:21 -0400
Content-Disposition: inline
In-Reply-To: <20030708134016.A32161@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Jul 08, 2003 at 01:40:16PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Some sample usage of the delete and scan attributes. 

The system has one fastt200 (disk array) with 32 LUNs (4:0:0:*),
10 disk drives (4:0:1-10:0).

[root@elm3b79 root]# ls -l /sysfs/bus/scsi
total 0
--w-------    1 root     root            0 Jul  8 13:28 delete
drwxr-xr-x    2 root     root            0 Jul  8 04:04 devices
drwxr-xr-x    5 root     root            0 Jul  8 04:04 drivers
--w-------    1 root     root            0 Jul  8 13:08 scan

[root@elm3b79 root]# ls /sysfs/bus/scsi/devices
0:0:0:0  4:0:0:0   4:0:0:14  4:0:0:2   4:0:0:25  4:0:0:30  4:0:0:8   4:0:4:0
0:0:1:0  4:0:0:1   4:0:0:15  4:0:0:20  4:0:0:26  4:0:0:31  4:0:0:9   4:0:5:0
0:0:2:0  4:0:0:10  4:0:0:16  4:0:0:21  4:0:0:27  4:0:0:4   4:0:1:0   4:0:6:0
0:0:3:0  4:0:0:11  4:0:0:17  4:0:0:22  4:0:0:28  4:0:0:5   4:0:10:0  4:0:7:0
0:0:4:0  4:0:0:12  4:0:0:18  4:0:0:23  4:0:0:29  4:0:0:6   4:0:2:0   4:0:8:0
0:0:5:0  4:0:0:13  4:0:0:19  4:0:0:24  4:0:0:3   4:0:0:7   4:0:3:0   4:0:9:0

# delete a few scsi_devices from the disk array

[root@elm3b79 root]# echo "4 0 0 25" > /root/xx; dd if=/root/xx of=/sysfs/bus/scsi/delete 
0+1 records in
0+1 records out
[root@elm3b79 root]# echo "4 0 0 1" > /root/xx; dd if=/root/xx of=/sysfs/bus/scsi/delete 
0+1 records in
0+1 records out
[root@elm3b79 root]# echo "4 0 0 3" > /root/xx; dd if=/root/xx of=/sysfs/bus/scsi/delete 
0+1 records in
0+1 records out
[root@elm3b79 root]# ls /sysfs/bus/scsi/devices
0:0:0:0  4:0:0:0   4:0:0:15  4:0:0:20  4:0:0:27  4:0:0:5  4:0:10:0  4:0:7:0
0:0:1:0  4:0:0:10  4:0:0:16  4:0:0:21  4:0:0:28  4:0:0:6  4:0:2:0   4:0:8:0
0:0:2:0  4:0:0:11  4:0:0:17  4:0:0:22  4:0:0:29  4:0:0:7  4:0:3:0   4:0:9:0
0:0:3:0  4:0:0:12  4:0:0:18  4:0:0:23  4:0:0:30  4:0:0:8  4:0:4:0
0:0:4:0  4:0:0:13  4:0:0:19  4:0:0:24  4:0:0:31  4:0:0:9  4:0:5:0
0:0:5:0  4:0:0:14  4:0:0:2   4:0:0:26  4:0:0:4   4:0:1:0  4:0:6:0

# Rescan a target, in this particular case a REPORT LUN scan occurs

[root@elm3b79 root]# echo "4 0 0 -" > /root/xx; dd if=/root/xx of=/sysfs/bus/scsi/scan 
0+1 records in
0+1 records out
[root@elm3b79 root]# ls /sysfs/bus/scsi
delete  devices  drivers  scan
[root@elm3b79 root]# ls /sysfs/bus/scsi/devices
0:0:0:0  4:0:0:0   4:0:0:14  4:0:0:2   4:0:0:25  4:0:0:30  4:0:0:8   4:0:4:0
0:0:1:0  4:0:0:1   4:0:0:15  4:0:0:20  4:0:0:26  4:0:0:31  4:0:0:9   4:0:5:0
0:0:2:0  4:0:0:10  4:0:0:16  4:0:0:21  4:0:0:27  4:0:0:4   4:0:1:0   4:0:6:0
0:0:3:0  4:0:0:11  4:0:0:17  4:0:0:22  4:0:0:28  4:0:0:5   4:0:10:0  4:0:7:0
0:0:4:0  4:0:0:12  4:0:0:18  4:0:0:23  4:0:0:29  4:0:0:6   4:0:2:0   4:0:8:0
0:0:5:0  4:0:0:13  4:0:0:19  4:0:0:24  4:0:0:3   4:0:0:7   4:0:3:0   4:0:9:0

# Rescan an entire adapter

[root@elm3b79 root]# echo "4 - - -" > /root/xx; dd if=/root/xx of=/sysfs/bus/scsi/scan 
0+1 records in
0+1 records out

# some failure cases

[root@elm3b79 root]# echo "4 0 0 88" > /root/xx; dd if=/root/xx of=/sysfs/bus/scsi/delete 
dd: writing `/sysfs/bus/scsi/delete': No such device
0+1 records in
0+0 records out
[root@elm3b79 root]# echo "4 0 88" > /root/xx; dd if=/root/xx of=/sysfs/bus/scsi/delete 
dd: writing `/sysfs/bus/scsi/delete': Invalid argument
0+1 records in
0+0 records out

-- Patrick Mansfield
