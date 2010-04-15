From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: TCM_Loop virtual SAS Ports + megasas HBA emulation into Linux
	Guests
Date: Thu, 15 Apr 2010 04:58:47 -0700
Message-ID: <1271332727.3082.70.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Gerd Hoffmann <kraxel@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Avi Kivity <avi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Greetings Hannes, Christoph and Co,

So after some additional discussions on and off the linux-scsi list wrt
to KVM + megasas emulation, I got motivated and decided to try it out
for myself using the QEMU code from Gerd's tree at:

http://repo.or.cz/w/qemu/kraxel.git branch: scsi.v9.

As expected using megasas with hw/scsi-disk.c for QEMU userspace CDB
emulation is working, Thank you Dr. Hannes! :-)

Sooo, after poking around a bit further I managed to (partially) get the
TCM_Loop fabric module running with Persistent Reservation and ALUA
using virtual target SAS ports with megasas via hw/scsi-generic.c.  I am
using a single TCM/IBLOCK backstore (single SATA JBOD disk) with two
virtual SAS target ports appearing as local drives on the Linux host.

>From there I am using the following CLI ops to start two qemu instances:

./x86_64-softmmu/qemu-system-x86_64 -m 2048 -smp 4 /root/lenny64guest0-orig.img  \
  -drive if=none,id=mydisk,file=/dev/sg3 -device megasas,id=raid  \
  -device scsi-generic,bus=raid.0,scsi-id=1,drive=mydisk

Here are some observations of what I have seen with various tests so
far..

*) By representing one TCM/IBLOCK backstore as two virtual SAS target
ports, I can pass each scsi-generic device (representing the same
underlying struct block_device) from TCM_Loop's LLD into different Linux
guests.

*) Most TCM control path CDB emulation is working as expected.  This
includes Persitent Reservation IN CDBs and implict ALUA access state
transitions using sg_rtpg to virtual SAS ports in Linux guests..!

*) DATA_SG_IO READs (and I assume WRITEs as well) via hw/scsi-generic.c
are failing in Linux guests with the following message:

scsi_command_complete: ret -90 (Message too long)
[raid.0 id=1 lun=0] READ_12 - from-dev len=4096
scsi_command_complete: ret -90 (Message too long)
[raid.0 id=1 lun=0] READ_12 - from-dev len=512

I assume this is because megasas is currently using hw/scsi-disk.c, yes?

*) Persistent Reservation OUT CDBs seem to be getting dropped with GOOD
status, but the same PR OUT op is still working as expected when using
the virtual SCSI device on the Linux Host.  This does appear to be
specific to PROUT with megasas AFAICT..

Here is the very first screen shot of TCM_Loop + megasas in action on
host running a fresh cut of v2.6.34-rc4:

https://www.linux-iscsi.org/images/TCM_Loop-megasas-04152010.png

I will keep poking around and add the WIP items + info to the KVM and
TCM_loop pages on the LIO wiki.  Until then, any comments to steer me in
the right direction to address the above items would be apperciated.

Best,

--nab
