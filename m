From: Andy Grover <agrover@redhat.com>
Subject: Re: tcmu-runner (target userspace passthrough daemon) development
Date: Wed, 21 Jan 2015 16:17:08 -0800
Message-ID: <54C04184.9070502@redhat.com>
References: <54BEE479.4050503@redhat.com> <1421800535.9970.27.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbbAVARL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2015 19:17:11 -0500
In-Reply-To: <1421800535.9970.27.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 01/20/2015 04:35 PM, Nicholas A. Bellinger wrote:
>> As a proof-of-concept, I've implemented a Gluster backend handler. I'm
>> looking for code review and collaborators, as well as suggestions on
>> what other userspace handlers we might want to work on. Tape or optical
>> jukebox emulation? VMDK files?? Video RAM???
>
> How about a user-space handler for qcow2, so we could have a mechanism
> for exposing qcow2 images into KVM guest using vhost-scsi export..?
>
> Ideally there would be a library that QEMU provides so that from TCMU's
> user-space handler perspective, it's simply issuing fd reads/writes into
> qcow2 library code that is doing the fancy feature stuff outside of
> user-space handler logic..

Reusing qemu's BlockDriver support would enable LIO luns to be backed 
not just by qcow2 files, but by pretty much EVERY image format, plus 
Gluster, Ceph, sheepdog, all in one go.

The obstacle is that there is not a library. The programs in qemu like 
qemu-img and qemu-nbd that share blockdriver code are in the qemu tree 
and just link in the block .o files. The most straightforward solution 
is to add a qemu-lio-tcmu.so that similarly statically links in all the 
BlockDrivers, and is also a tcmu-runner handler module.

The issues with this are:

1) Getting the qemu build system to do what we want. It has an elaborate 
build system and I lack build-fu. I got this working about 5 months ago 
but then my changes experienced bitrot.

2) Code-wise, decide on whether to be a user of the qemu block 
subsystem, or to pretend to *be* the qemu block subsystem. If we're a 
user then we get nice APIs like bdrv_pwrite() that hide things like 
async or coroutines from us, but require us to call qemu_init_main_loop, 
which does a lot of stuff that assumes it's its own process, mucks with 
signals, etc. If we pretend to be the block subsystem then we need to do 
ourselves much of what the block subsystem does, to use all of the 
registered BlockDrivers in the way they expect.

3) Get it accepted into qemu. Qemu developers' interest in LIO is that a 
baremetal instance booted off an iscsi lun, and the lun is backed by a 
qcow2 file, enables snapshots & migration between the baremetal and virt 
really easily. This involves us supporting QMP, the qemu remote 
configuration protocol. Which sounds weird to me. Check out this msg and 
others on the thread:

http://lists.nongnu.org/archive/html/qemu-devel/2014-09/msg00920.html


I'm still confused, honestly. I think we just want the blockdrivers, and 
to not have to maintain them ourselves, but need a solution the qemu 
developers will accept, too.

-- Andy
