From: "Drew Winstel" <DWinstel@Miltope.com>
Subject: Perform uncached reads on SCSI drives?
Date: Wed, 13 Apr 2005 08:02:19 -0500
Message-ID: <66F9227F7417874C8DB3CEB057727417045099@MILEX0.Miltope.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from firewall.miltope.com ([208.12.184.221]:60295 "EHLO
	smtp.miltope.com") by vger.kernel.org with ESMTP id S261334AbVDMNBz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 09:01:55 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-scsi (E-mail)" <linux-scsi@vger.kernel.org>
Cc: "Matthew Alan Gray (E-mail)" <mgray@radicalsystems.com>, Brett Smith <Bsmith@Miltope.com>, John Treubig <JTREUBIG@Miltope.com>


Is there a way to perform large quantities of uncached reads on a drive 
connected to a SCSI controller under Linux 2.6.x?

Here's a little about the rationale behind such a move:
Previously, we had been testing hard drives using full-capacity, 1/3-capacity, 
and random stroke using the SCSI Seek 10 command with SCSI drives and the 
WIN_SEEK command for 'true' IDE drives (i.e. drives accessed via /dev/hd[a-t]) 
as part of our process for ensuring drives meet customer performance and 
reliability requirements.  Thanks to the emergence of SATA and the resulting 
inquiries from technical minds, we have begun to test those drives using the 
same benchmarks.

This is where we run into problems.  

Since libata-scsi.c simulates (basically a no-op; see libata-scsi.c) the SEEK 
6 and SEEK 10 commands, we have attempted to switch to calling reads to the 
beginning/middle/end/wherever as necessary.  

The reads we're calling are getting cached.  If we call 100 reads--50 to the 
beginning of the drive alternating with 50 to the end--the first read will 
sometimes appear to have a realistic result, then the rest will all complete 
in the neighborhood of 10 microseconds.  

Here is a sample SG_IO header we're passing via ioctl():
interface_id = 83
dxfer_direction = -3
cmd_len = 10 
mx_sb_len = 32 
iovec_count = 0
dxfer_len = 512
dxferp = 0xbfffedc0
cmdp = 0xbfffed60 
sbp = 0x80786a8 
timeout = 20000
flags = 3
pack_id = 0
usr_ptr = 0x0
status = 0 
masked_status = 0 
msg_status = 0 
sb_len_wr = 0 
host_status = 0
driver_status = 0
resid = 0
duration = 0
info = 0

Hardware tested:
Silicon Image SiI 3512 (sata_sil driver)
Promise SATA150 TX4 (sata_promise)
Promise Ultra133 TX2 (PDC20269 chip; pata_pdc2027x driver)

Drives:
Fujitsu MHT2080BH (80 GB 2.5" SATA)
Seagate ST3200822AS (200 GB 3.5" SATA)
Seagate ST3400832AS (400 GB SATA)
Fujitsu MHT2080AH (80 GB 2.5" PATA)
Toshiba MK4019GAX (40 GB 2.5" PATA)

Kernel versions tested:
2.6.7
2.6.11 with libata-dev as of March 11

Only the large Seagate drive was tested with the Promise SATA controller (and 
vice versa).  Only the sata_sil driver was tested with 2.6.7. All other 
combinations (keeping SATA with SATA and PATA with PATA, of course) were tested 
with the same results, leading me to believe libata was to blame, unless by some
chance we're missing a magic flag in our command block.

Just to make sure this was not a libata-specific issue, I tested this same read 
sequence with a Seagate ST336706LC Cheetah and a Seagate ST973401LC Savvio 
connected to an Adaptec 29160 (aic7xxx driver) Ultra160 controller.  Lo and 
behold, this produced the same results, hence me posting here instead of 
linux-ide.  

Any help would be greatly appreciated.

Thanks,
Drew
