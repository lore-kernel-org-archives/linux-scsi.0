From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0 of 7] Block/SCSI Data Integrity Support
Date: Sat, 07 Jun 2008 00:55:33 -0400
Message-ID: <patchbomb.1212814533@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:38415 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbYFGE5n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 Jun 2008 00:57:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


Another post of my block I/O data integrity patches.  This kit goes on
top of the scsi_data_buffer and sd.h cleanups I posted earlier today.

There has been no changes to the block layer code since my last
submission.

Within SCSI, the changes are cleanups based on comments from Christoph
as well as working support for Type 3 and 4KB sectors.


What's This All About?
----------------------

These patches allow data integrity information (checksum and more) to
be attached to I/Os at the block/filesystem layers and transferred
through the entire I/O stack all the way to the physical storage
device.

The integrity metadata can be generated in close proximity to the
original data.  Capable host adapters, RAID arrays and physical disks
can verify the data integrity and abort I/Os in case of a mismatch.

Right now this is SCSI disk only but similar efforts are in progress
for SATA and SCSI tape.  With a few minor nits due to protocol
limitations the proposed SATA format is identical to the SCSI ditto
for easy interoperability.


T10 DIF
-------

SCSI drives can usually be reformatted to 520-byte sectors, yielding 8
extra bytes per sector.  These 8 bytes have traditionally been used by
RAID controllers to store internal protection information.

DIF (Data Integrity Field) is an extension to the SCSI Block Commands
that standardizes the format of the 8 extra bytes and defines ways to
interact with the contents at the protocol level.

Each 8-byte DIF tuple is split into three chunks:

	- a 16-bit guard tag containing a CRC of the data portion of
      	  the sector.

	- a 16-bit application tag which is up for grabs.

	- a 32-bit reference tag which contains an incrementing
          counter for each sector.  For DIF Type 1 it also needs to
          match the physical LBA on the drive.

There are three types of DIF defined: Type 1, Type 2, and Type 3.
These patches support Type 1 and Type 3.  Type 2 depends on 32-byte
CDBs and is work in progress.

Since the DIF tuple format is standardized, both initiators and
targets (as well as potentially transport switches in-between) are
able to verify the integrity of the data going over the bus.

When writing, the HBA will DMA 512-byte sectors from host memory,
generate the matching integrity metadata and send out 520-byte sectors
on the wire.  The disk will verify the integrity of the data before
committing it to stable storage.

When reading, the drive will send 520-byte sectors to the HBA.  The
HBA will verify the data integrity and DMA 512-byte sectors to host
memory.

IOW, DIF provides means for added integrity protection between HBA and
disk.


Data Integrity Extensions
-------------------------

In order to provide true end-to-end data integrity we need to be able
to get access to the integrity metadata from the OS.  Dealing with
520-byte sectors is quite inconvenient so we have worked with HBA
manufacturers to separate the data buffer scatter-gather from the
integrity metadata scatter-gather.

Also, the CRC16 is somewhat expensive to calculate in software.  So we
have also allowed alternate checksums to be used.  Currently we
support the IP checksum which is fast and cheap to calculate.

When writing, the HBA will DMA two scatterlists from host memory: One
containing the data as usual, and one containing the integrity
metadata.  The HBA will verify that the two are in agreement and
interleave them before sending them out on the wire as 520-byte
sectors.

When reading, the disk will return 520-byte sectors, the HBA will
verify the integrity, split the integrity metadata from the data, and
DMA to the two separate scatterlists in host memory.


SCSI Layer Changes
------------------

At the SCSI level, there are a few changes required to support this:

 - an extra scatterlist for the integrity metadata

 - tweaks to sd.c to detect and handle disks formatted with DIF

 - sd.c must issue the right READ/WRITE commands when a disk is
   formatted with DIF

 - extra fields in scsi_host to signal the HBA driver's DIF
   capabilities


Block Layer Changes
-------------------

The main idea of DIF/DIX is to allow integrity metadata to be
generated as close to the original data as possible.  So in the long
run we'd like this to happen in userland.  Given mmap(), direct I/O,
etc. this obviously poses some challenges.  *cough*

For now the integrity metadata is generated at the block layer when an
I/O is submitted by the filesystem.  There are also functions that
allow filesystems to generate the integrity metadata earlier, and to
use the application tag to mark sectors for recovery purposes.

struct bio has been extended with a pointer to a struct bip which in
turn contains the integrity metadata.  The bip is essentially a
trimmed down bio with a bio_vec and some housekeeping.

There are a few hooks inserted in fs/bio.c and block/blk-* to allow
integrity metadata to be handled correctly when splitting, cloning and
merging.  Aside from that, the integrity stuff is completely opaque.

Because we don't want the block layer, filesystems, etc. to know about
DIF and tuple formats, all the functions that interact with the
integrity metadata reside in the SCSI layer and are registered via a
callback handler template.  The block layer changes have been made so
that the upcoming standards for data integrity on SATA (T13 External
Path Protection) and SCSI tape will fit right in and can register
their own handlers.

I have included a more in-depth description of the block layer changes
in Documentation/block/data-integrity.txt.


Comments and suggestions welcome.

-- 
Martin K. Petersen	Oracle Linux Engineering



