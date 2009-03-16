From: Vegard Svanberg <vegard@svanberg.no>
Subject: "Sense Key : Hardware Error [current]"
Date: Mon, 16 Mar 2009 09:49:56 +0100
Message-ID: <20090316084956.GZ16295@svanberg.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from junior.svanberg.no ([81.175.2.180]:54861 "EHLO svanberg.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756667AbZCPI66 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Mar 2009 04:58:58 -0400
Received: from localhost (svanberg.no [127.0.0.1])
	by svanberg.no (Postfix) with ESMTP id 94AF4184050
	for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2009 09:49:58 +0100 (CET)
Received: from svanberg.no ([127.0.0.1])
	by localhost (mail.svanberg.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yyEUYBmvvY2j for <linux-scsi@vger.kernel.org>;
	Mon, 16 Mar 2009 09:49:56 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear list,

I sent the e-mail below to aacraid@adaptec.com. However I'm not entirely
sure if it's related to Adaptec, or if it's some other part of the SCSI
subsystem reporting these errors. The reason I'm posting here is that we
need to nail down if this could be a software bug or a hardware problem.

Thanks in advance!

Hello,

We have a few Supermicro servers with AOC-USAS-S4IR (Supermicro product
number), which is using AAC-RAID. About a month ago, these servers lost
the power. They had no battery, so some corruption/data loss occured due
to write-back cache being enabled.

However, after booting up, they worked fine. Two weeks later, one of the
servers suddenly crashed. We lost some data and moved the data we could
to another machine.

Now, a month later, suddenly one of the other machines crashed with
exactly the same error messages. 

This is on Debian Etch, but with a Ubuntu kernel (2.6.27-7-server). 

What happens is that some I/O error is reported, and the root filesystem
is remounted read-only. While copying the data over to a new machine,
sometimes it hits bad inodes/blocks. 

The RAID controller doesn't report any errors. RAID status is reported
as Optimal.

Fsck will (try to) fix the errors, but reports short read while fixing
them. After rebooting, the problems are back again. We also tried moving
the physical drives to another, identical machine, and the errors are
still occuring. 

Some output from dmesg while trying to copy data to another server:

[2834866.071770] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
[2834866.071778] sd 0:0:0:0: [sda] Sense Key : Hardware Error [current] 
[2834866.071782] sd 0:0:0:0: [sda] Add. Sense: Internal target failure
[2834866.071787] end_request: I/O error, dev sda, sector 302515639
[2834866.071823] EXT3-fs error (device dm-0): ext3_get_inode_loc: unable to read inode block - inode=9455580, block=37814399

More output from dmesg:

[   38.907730] end_request: I/O error, dev sda, sector 284688831
[   38.907802] EXT3-fs error (device dm-0): read_block_bitmap: Cannot =
read block bitmap - block_group =3D 1086, block_bitmap =3D 35586048
[   38.907956] Aborting journal on device dm-0.
[   38.919742] ext3_abort called.
[   38.919798] EXT3-fs error (device dm-0): ext3_journal_start_sb: =
Detected aborted journal
[   38.919942] Remounting filesystem read-only
[   38.925855] __journal_remove_journal_head: freeing b_committed_data
[   38.925915] journal commit I/O error
[   38.925935] journal commit I/O error
[   38.925953] journal commit I/O error
[   38.943245] Remounting filesystem read-only
[   38.958907] EXT3-fs error (device dm-0) in ext3_reserve_inode_write: =
Journal has aborted
[   38.958988] EXT3-fs error (device dm-0) in ext3_truncate: Journal has =
aborted
[   38.959051] EXT3-fs error (device dm-0) in ext3_reserve_inode_write: =
Journal has aborted
[   38.959137] EXT3-fs error (device dm-0) in ext3_orphan_del: Journal =
has aborted
[   38.959222] EXT3-fs error (device dm-0) in ext3_reserve_inode_write: =
Journal has aborted
[   39.024087] journal commit I/O error
[   39.024103] journal commit I/O error
[   39.024117] journal commit I/O error
[   39.024124] journal commit I/O error
[   39.024181] journal commit I/O error
[   39.024201] journal commit I/O error
[   39.024208] journal commit I/O error
[   39.024258] journal commit I/O error
[   39.024275] journal commit I/O error
[   39.024284] journal commit I/O error
[   39.024330] journal commit I/O error
[   39.024358] journal commit I/O error
[   39.024384] journal commit I/O error
[   39.024432] journal commit I/O error
[   39.024481] journal commit I/O error
[   45.749997] sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DD=
RIVER_SENSE,SUGGEST_OK
[   45.750008] sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]=20
[   45.750012] sd 0:0:0:0: [sda] Add. Sense: Internal target failure
[   45.750017] end_request: I/O error, dev sda, sector 721945599
[   45.750079] Buffer I/O error on device dm-0, logical block 90243144
[   45.750137] lost page write due to I/O error on dm-0
[   87.970284] sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DD=
RIVER_SENSE,SUGGEST_OK
[   87.970292] sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]=20
[   87.970296] sd 0:0:0:0: [sda] Add. Sense: Internal target failure
[   87.970302] end_request: I/O error, dev sda, sector 83324999

Any ideas? Thanks in advance.

-- 
Vegard Svanberg <vegard@svanberg.no> [*Takapa@IRC (EFnet)]

