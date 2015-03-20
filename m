From: Ewan Milne <emilne@redhat.com>
Subject: Re: iSCSI regression with linux 3.9 and 4.0
Date: Fri, 20 Mar 2015 09:51:26 -0400
Message-ID: <1426859486.19806.30.camel@localhost.localdomain>
References: <20150320135742.63df219b@leda.localdomain>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbbCTNv1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Mar 2015 09:51:27 -0400
In-Reply-To: <20150320135742.63df219b@leda.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Hesse <list@eworm.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 2015-03-20 at 13:57 +0100, Christian Hesse wrote:
> Hello everybody!
> 
> I reported this issue at LKML [0] but received no answer. Hopefully
> linux-scsi is a better place...
> 
> Beginning with linux 3.19 I see an iSCSI regressen. This works perfectly with
> linux 3.18.x (tested with 3.18.6) and before. Effected kernels I tested are
> 3.19.0, 3.19.2 and 4.0rc4.r199.gb314aca.
> 
> The logs tell the story:
> 
> Feb 19 11:26:49 thebe kernel: scsi host6: iSCSI Initiator over TCP/IP
> Feb 19 11:26:49 thebe kernel: scsi 6:0:0:0: Direct-Access     QNAP     iSCSI Storage    4.0  PQ: 0 ANSI: 5
> Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] 1073741824 512-byte logical blocks: (549 GB/512 GiB)
> Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Write Protect is off
> Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Mode Sense: 2f 00 00 00
> Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> Feb 19 11:26:49 thebe kernel:  sdb: unknown partition table
> Feb 19 11:26:49 thebe kernel: sd 6:0:0:0: [sdb] Attached SCSI disk
> Feb 19 11:26:49 thebe iscsid[10804]: Connection1:0 to [target: iqn.2004-04.com.qnap:ts-859:iscsi.xxxxxxx.c40a18, portal: xx.xx.xx.xx,3260] through [iface: default] is operational now
> Feb 19 11:26:57 thebe kernel:  sdb: unknown partition table
> Feb 19 11:28:20 thebe kernel: EXT4-fs (dm-8): mounting with "discard" option, but the device does not support discard
> Feb 19 11:28:20 thebe kernel: EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
> Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] UNKNOWN Result: hostbyte=0x00 driverbyte=0x08
> Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] Sense Key : 0x5 [current]
> Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] ASC=0x24 ASCQ=0x0
> Feb 19 11:28:24 thebe kernel: sd 6:0:0:0: [sdb] CDB: 
> Feb 19 11:28:24 thebe kernel: cdb[0]=0x2a: 2a 00 34 5b 07 ff 00 2f 88 00
> Feb 19 11:28:24 thebe kernel: blk_update_request: critical target error, dev sdb, sector 878381055
> Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:317: I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592 starting block 108749056)
> Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical block 108749056
> Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical block 108749057
> Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical block 108749058
> Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical block 108749059
> Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical block 108749060
> Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical block 108749061
> Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical block 108749062
> Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical block 108749063
> Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical block 108749064
> Feb 19 11:28:24 thebe kernel: Buffer I/O error on device dm-8, logical block 108749065
> Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:317: I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592 starting block 108749312)
> Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:317: I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592 starting block 108749568)
> Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:317: I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592 starting block 108749824)
> Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:317: I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592 starting block 108750080)
> Feb 19 11:28:24 thebe kernel: EXT4-fs warning (device dm-8): ext4_end_bio:317: I/O error -121 writing to inode 33196503 (offset 8388608 size 7278592 starting block 108750336)
> Feb 19 11:29:10 thebe kernel: sd 6:0:0:0: [sdb] UNKNOWN Result: hostbyte=0x00 driverbyte=0x08
> Feb 19 11:29:10 thebe kernel: sd 6:0:0:0: [sdb] Sense Key : 0x5 [current]
> Feb 19 11:29:10 thebe kernel: sd 6:0:0:0: [sdb] ASC=0x24 ASCQ=0x0
> Feb 19 11:29:10 thebe kernel: sd 6:0:0:0: [sdb] CDB: 
> Feb 19 11:29:10 thebe kernel: cdb[0]=0x2a: 2a 00 20 44 89 17 00 20 50 00
> Feb 19 11:29:10 thebe kernel: blk_update_request: critical target error, dev sdb, sector 541362455
> Feb 19 11:29:10 thebe kernel: Buffer I/O error on dev dm-8, logical block 66621731, lost sync page write
> Feb 19 11:29:10 thebe kernel: Aborting journal on device dm-8-8.
> Feb 19 11:29:10 thebe kernel: EXT4-fs error (device dm-8): ext4_journal_check_start:56: Detected aborted journal
> Feb 19 11:29:10 thebe kernel: EXT4-fs (dm-8): Remounting filesystem read-only
> Feb 19 11:29:20 thebe kernel: EXT4-fs error (device dm-8): ext4_put_super:780: Couldn't clean up the journal
> 
> [0] https://lkml.org/lkml/2015/2/19/91

Sense key 0x5 ASC/ASCQ 0x24 0x00 is ILLEGAL REQUEST, INVALID FIELD IN
CDB.  The CDB was 2A 00 34 5B 07 FF 00 2F 88 00, which is a WRITE_10
to LBA 878381055 with a length of 12168 blocks (a little less than 6MB).
It looks like this is within the reported capacity of the device, and
there are no other bits set in the CDB.

Looks like you could get this error if RWWP (reject without write
protection) is set in the control mode page.  I don't see any messages
about the protection type, though.  What does sysfs report?

-Ewan


