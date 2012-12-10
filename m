From: Anand Jain <anand.jain@oracle.com>
Subject: [Bug] Remove and add a mounted device gets a new dev path
Date: Mon, 10 Dec 2012 12:00:39 +0800
Message-ID: <50C55E67.1000507@oracle.com>
References: <50C223B4.8050301@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30216 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab2LJEAn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Dec 2012 23:00:43 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBA40gPY005203
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Dec 2012 04:00:42 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBA40fSm017292
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Dec 2012 04:00:41 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBA40fnc018444
	for <linux-scsi@vger.kernel.org>; Sun, 9 Dec 2012 22:00:41 -0600
In-Reply-To: <50C223B4.8050301@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



# mount /dev/sdb /btrfs

# echo "scsi remove-single-device 1 0 0 0" > /proc/scsi/scsi

# lsscsi
  [0:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sda
  [2:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdc

# btrfs su create /btrfs/sv1
Create subvolume '/btrfs/sv1'
ERROR: cannot create subvolume - Input/output error

# echo "scsi add-single-device 1 0 0 0" > /proc/scsi/scsi

# lsscsi
[0:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sda
[1:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdd <---
[2:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdc

The same disk comes back as /dev/sdd

(the issue is same if disk is mounted as an ext4 fs)

Thanks
