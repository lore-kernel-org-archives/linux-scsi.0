From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
Date: Mon, 30 Aug 2010 17:01:19 -0400
Message-ID: <x49y6bn7r34.fsf@segfault.boston.devel.redhat.com>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
	<1282751267-3530-27-git-send-email-tj@kernel.org>
	<20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de>
	<4C753D75.2010305@kernel.org> <20100825200223.GE2738@quack.suse.cz>
	<4C76250B.6060800@kernel.org> <20100827173147.GA12374@quack.suse.cz>
	<x4939tv98n8.fsf@segfault.boston.devel.redhat.com>
	<20100830202034.GB12226@quack.quadriga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0H3VEH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2010 17:04:07 -0400
In-Reply-To: <20100830202034.GB12226@quack.quadriga.com> (Jan Kara's message
	of "Mon, 30 Aug 2010 22:20:34 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com, Christoph Hellwig <hch@infradead.org>

Jan Kara <jack@suse.cz> writes:

> On Mon 30-08-10 15:56:43, Jeff Moyer wrote:
>> Jan Kara <jack@suse.cz> writes:
>> 
>> >   An update: I've set up an ext4 barrier testing in KVM - run fsstress,
>> > kill KVM at some random moment and check that the filesystem is consistent
>> > (kvm is run in cache=writeback mode to simulate disk cache). About 70 runs
>> 
>> But doesn't your "disk cache" survive the "power cycle" of your guest?
>   Yes, you're right. Thinking about it now the test setup was wrong because
> it didn't refuse writes to the VM's data partition after the moment I
> killed KVM. Thanks for catching this. I will probably have to use the fault
> injection on the host to disallow writing the device at a certain moment.
> Or does somebody have a better option?
>   My setup is that I have a dedicated partition / drive for a filesystem
> which is written to from a guest kernel running under KVM. I have set it up
> using virtio driver with cache=writeback so that the host caches the writes
> in a similar way disk caches them. At some point I just kill the qemu-kvm
> process and at that point I'd like to also throw away data cached by the
> host...

I've used ilo to power off the system under test from remote.  I have a
tool to automate the testing.  It works as follows:

There's a client and a server.  The server listens on an ip/port for
connections.  A client will connect, tell the server it's configuration
(including what disk it's writing to, what block size it's using, and
the total amount of I/O to be done), and then start doing I/O.  The I/O
is done using the AIO api, and the data written includes a block number,
a generation number, fill, and a crc.  As each completion comes in, the
completed sectors are communicated to the server program.  Upon
completion of an entire series of writes (writing the entire data set
once), the server waits some amount of time and then power cycles the
client.  The client comes back up and is run in check mode to verify
that all of the data it reported as completed to the server is actually
in tact.

I recently updated the code to run against a file on a file system
(previously it would only work on a block device).  It makes use of
stonith modules to do the power cycling.  It works, but it isn't the
most elegant bit of engineering I've ever done.  ;-)

Anyway, that code is available here:
  http://people.redhat.com/jmoyer/dainto-0.99.4.tar.bz2

Cheers,
Jeff
