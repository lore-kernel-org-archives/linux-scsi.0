From: Patrick Mansfield <patmans@us.ibm.com>
Subject: and some example usage of the attributes
Date: Wed, 9 Jul 2003 13:29:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030709132912.A7393@beaverton.ibm.com>
References: <20030708134016.A32161@beaverton.ibm.com> <20030709132757.A7360@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:51330 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266134AbTGIUPA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2003 16:15:00 -0400
Content-Disposition: inline
In-Reply-To: <20030709132757.A7360@beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Jul 09, 2003 at 01:27:57PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Some example uses of the delete and scan attribute.

[root@elm3b79 root]# ls -l /sysfs/class/scsi_host/host2
total 0
-r--r--r--    1 root     root         4096 Jul  9 12:30 cmd_per_lun
--w-------    1 root     root            0 Jul  9 12:34 delete
lrwxrwxrwx    1 root     root           46 Jul  9 12:30 device -> ../../../devices/pci0000:01/0000:01:0c.0/host2
-r--r--r--    1 root     root         4096 Jul  9 12:30 host_busy
--w-------    1 root     root            0 Jul  9 12:36 scan
-r--r--r--    1 root     root         4096 Jul  9 12:30 sg_tablesize
-r--r--r--    1 root     root         4096 Jul  9 12:30 unchecked_isa_dma
-r--r--r--    1 root     root         4096 Jul  9 12:30 unique_id

[root@elm3b79 root]# ls /sysfs/class/scsi_host/host2/device
2:0:0:0   2:0:0:14  2:0:0:2   2:0:0:25  2:0:0:30  2:0:0:8   2:0:4:0  name
2:0:0:1   2:0:0:15  2:0:0:20  2:0:0:26  2:0:0:31  2:0:0:9   2:0:5:0  power
2:0:0:10  2:0:0:16  2:0:0:21  2:0:0:27  2:0:0:4   2:0:1:0   2:0:6:0
2:0:0:11  2:0:0:17  2:0:0:22  2:0:0:28  2:0:0:5   2:0:10:0  2:0:7:0
2:0:0:12  2:0:0:18  2:0:0:23  2:0:0:29  2:0:0:6   2:0:2:0   2:0:8:0
2:0:0:13  2:0:0:19  2:0:0:24  2:0:0:3   2:0:0:7   2:0:3:0   2:0:9:0

# Delete some devices

[root@elm3b79 root]# echo "0 9 0" > /root/xx; dd if=/root/xx of=/sysfs/class/scsi_host/host2/delete 
0+1 records in
0+1 records out
[root@elm3b79 root]# echo "0 0 0" > /root/xx; dd if=/root/xx of=/sysfs/class/scsi_host/host2/delete 
0+1 records in
0+1 records out
[root@elm3b79 root]# echo "0 0 22" > /root/xx; dd if=/root/xx of=/sysfs/class/scsi_host/host2/delete 
0+1 records in
0+1 records out

# Scan a target - for this target REPORT LUN is used

[root@elm3b79 root]# echo "0 0 -" > /root/xx; dd if=/root/xx of=/sysfs/class/scsi_host/host2/scan
0+1 records in
0+1 records out

# Scan the entire host

[root@elm3b79 root]# echo "- - -" > /root/xx; dd if=/root/xx of=/sysfs/class/scsi_host/host2/scan
0+1 records in
0+1 records out

-- Patrick Mansfield
