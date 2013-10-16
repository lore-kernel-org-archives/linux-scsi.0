From: Robert Story <rstory@tislabs.com>
Subject: kernel cant access SATA adapter device
Date: Wed, 16 Oct 2013 15:46:51 -0400
Message-ID: <20131016154651.7280ce92@kvm171.vb.futz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from walnut.tislabs.com ([192.94.214.200]:43417 "EHLO
	walnut.tislabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761621Ab3JPURd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 16:17:33 -0400
Received: from nova.tislabs.com (unknown [10.66.1.77])
	by walnut.tislabs.com (Postfix) with ESMTP id 38FB928B003A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2013 15:46:52 -0400 (EDT)
Received: from kvm171.vb.futz.org (localhost.localdomain [127.0.0.1])
	by nova.tislabs.com (Postfix) with ESMTP id 15E441F8033
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2013 15:46:52 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,

I've got a SATA adapter for a SD card in a Dell Poweredge R610. The BIOS
can see and boot the sdcard, (to Windows, or using syslinux/extlinux), but
when it hands over control to the Linux kernel, the kernel cannot access it.

Here's an excerpt from dmesg:

scsi 0:0:2:0: Direct-Access     ATA      FC-1307 SD to CF 1.1  PQ: 0 ANSI: 5
sd 0:0:2:0: Attached scsi generic sg3 type 0
mptsas: ioc0: mptsas_free_fw_event: kfree (fw_event=0xffff8801ab1ad8c0)
sd 0:0:2:0: [sdc] Spinning up disk .....................not responding...
sd 0:0:2:0: [sdc] READ CAPACITY(16) failed
sd 0:0:2:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:2:0: [sdc] Sense Key : Not Ready [current]
sd 0:0:2:0: [sdc] Add. Sense: Logical unit not ready, initializing command required
sd 0:0:2:0: [sdc] READ CAPACITY failed
sd 0:0:2:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:2:0: [sdc] Sense Key : Not Ready [current]
sd 0:0:2:0: [sdc] Add. Sense: Logical unit not ready, initializing command required
sd 0:0:2:0: [sdc] Test WP failed, assume Write Enabled
sd 0:0:2:0: [sdc] Asking for cache data failed
sd 0:0:2:0: [sdc] Assuming drive cache: write through

After booting and running 'sdparm --command=start /dev/sdc' I can get a
read capacity to work, but cannot access the drive (e.g. fdisk -l /dev/sdc).

If I put the SD card in a USB adapter, it works, and I was able to access
the SD card via the SD adapter in another machine. But our production
machines are dell's, so I really want to get it working there.

I've attached more complete debug info from booting and existing CentOS 6.4
install with the card installed, and a rdsosreport from an attempt to boot
Fedora 20 Alpha.

Any help or suggestions greatly appreciated.


Robert

--
Senior Software Engineer
Parsons Government Services , National Security & Defense Division
