From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: how to recover from "medium format corrupted"?
Date: Mon, 14 Dec 2009 15:32:35 +0100
Message-ID: <4B264C83.4080009@interlog.com>
References: <alpine.DEB.2.01.0912140158580.2915@bogon.housecafe.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48081 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbZLNOci (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2009 09:32:38 -0500
In-Reply-To: <alpine.DEB.2.01.0912140158580.2915@bogon.housecafe.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-scsi@vger.kernel.org

Christian Kujau wrote:
> Hi there,
> 
> I noticed that I cannot access one of the two 73GB SCSI disks any more 
> (connected to a 53C1030 LSI/Fusion MPT controller); during bootup the 
> message "READ CAPACITY failed" appears. Searching the net I've seen two 
> very interesting posts [0] about this and I think this is exactly what 
> happened to my disk:
> 
> I was booting the same system into Solaris 10 earlier 
> and wanted to erase the partition table via "dd if=/dev/zero ..." but as 
> this wasn't working (the table was still in place) I "played around" with 
> format[1] and may have issued the "FORMAT" command - but as it estimated
> to run ~100 minutes I interrupted the command and booted into Linux 
> (2.6.32) only to see that sdb now has a different geometry:
> 
> # hdparm -g /dev/sd[ab]
> /dev/sda: geometry      = 8924/255/63, sectors = 143374744, start = 0
> /dev/sdb: geometry      = 0/64/32, sectors = 0, start = 0
> 
> Unfortunately, sg_format (as suggested by Douglas in the posts) were not 
> able to recover the disk.

Christian,
Could you try the '--wait' option on the sg_format? The disk
does not seem to respond to the TEST UNIT READY poll. If
it is a modern disk it might respond to a REQUEST SENSE poll
but sg_format doesn't support that yet.

The '--wait' option will leave sg_format hanging until the
FORMAT UNIT finishes or 4 hours expires.

MEDIUM FORMAT CORRUPTED [asc/ascq=0x31,0x0] is caused by an
interrupted FORMAT UNIT.

Doug Gilbert

> I wonder if the disk is still OK (it was working earlier, SCSI FORMAT 
> commands won't destroy the disk, right?) and if anyone knows some magic 
> SCSI commands to issue so that the disk returns to a normal state again.
> 
> I've the lsiutil[2] tool on my hands, just in case some more details are 
> needed.
> 
> Any ideas?
> 
> Thanks,
> Christian.
> 
> [0] http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg09553.html
>     http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg07629.html
> [1] http://www.sun.com/bigadmin/content/submitted/format_utility.jsp
> [2] http://www.lsi.com/DistributionSystem/AssetDocument/LSIUtil_1.62.zip
> 
> 
> v40z1# dmesg | grep sdb
>  sd 2:0:1:0: [sdb] READ CAPACITY failed
>  sd 2:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
>  sd 2:0:1:0: [sdb] Sense Key : 0x3 [current] 
>  sd 2:0:1:0: [sdb] ASC=0x31 ASCQ=0x0
>  sd 2:0:1:0: [sdb] Write Protect is off
>  sd 2:0:1:0: [sdb] Mode Sense: ab 00 10 08
>  sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
>  sd 2:0:1:0: [sdb] READ CAPACITY failed
>  sd 2:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
>  sd 2:0:1:0: [sdb] Sense Key : 0x3 [current] 
>  sd 2:0:1:0: [sdb] ASC=0x31 ASCQ=0x0
>  sd 2:0:1:0: [sdb] Attached SCSI disk
> 
> v40z1# sg_format --format -vvv /dev/sdb 
> open /dev/sdb with flags=0x802
>     inquiry cdb: 12 00 00 00 24 00 
>       duration=0 ms
>     SEAGATE   ST373307LC        0007   peripheral_type: disk [0x0]
>       PROTECT=0
>     mode sense (10) cdb: 5a 00 01 00 00 00 00 00 fc 00 
>       duration=0 ms
>     mode sense (10): requested 252 bytes but got 28 bytes
>     mode sense (10): response
>         00 1a 00 10 00 00 00 08  08 8b b9 98 00 00 02 00    
>         81 0a c0 0b ff 00 00 00  05 00 ff ff                
> Mode Sense (block descriptor) data, prior to changes:
>   Number of blocks=143374744 [0x88bb998]
>   Block size=512 [0x200]
> 
> A FORMAT will commence in 10 seconds
>     ALL data on /dev/sdb will be DESTROYED
>         Press control-C to abort
> A FORMAT will commence in 5 seconds
>     ALL data on /dev/sdb will be DESTROYED
>         Press control-C to abort
>     format cdb: 04 18 00 00 00 00 
>     format parameter list:
>         00 02 00 00                                         
>       duration=280 ms
> 
> Format has started
>     test unit ready cdb: 00 00 00 00 00 00 
> sense buffer empty
> FORMAT Complete
> v40z1# echo $?
> 0
> 

