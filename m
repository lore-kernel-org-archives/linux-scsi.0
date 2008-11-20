From: Bernd Schubert <bs@q-leap.de>
Subject: cache flush timeouts by blk_queue_ordered()
Date: Thu, 20 Nov 2008 19:19:19 +0100
Message-ID: <20081120181919.GA3818@lanczos.q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:52463 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbYKTSxo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2008 13:53:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

Hello,

with some FC hardware-raid units we have the problem that the 
SYNCHRONIZE_CACHE command reproducibly fails. 

[658715.827428] sd 6:0:2:2: last recovery: 4311805647, now: 4459793681
[658715.833980] sd 6:0:2:2: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
[658715.842288] sd 6:0:2:2: [sdk] CDB: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
[658715.850954] sd 6:0:2:2: Activating scsi error recovery (1)
[658715.856793] sd 6:0:2:2: trying to abort command
[658715.861820] qla2xxx 0000:07:02.0: scsi(6:2:2): Abort command issued -- 1 36e2df2 2002.
[658746.004124] sd 6:0:2:2: last recovery: 4459793692, now: 4459801236
[658746.010686] sd 6:0:2:2: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
[658746.019004] sd 6:0:2:2: [sdk] CDB: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
[658746.027680] sd 6:0:2:2: Activating scsi error recovery (2)
[658746.033526] sd 6:0:2:2: trying to abort command
[658746.038543] qla2xxx 0000:07:02.0: scsi(6:2:2): Abort command issued -- 1 36e2df4 2002.

My guess is that these units flush their cache when this command is send
even though they have a battery backup unit and flushing 2GB cache may
take some time... Since I can only reproduce it on systems in production
I can't do any experiments, but I guess the default timeout of 30s is not
sufficient.

Problem is now that this timeout cannot be adjusted by the sysfs scsi device 
timeout, since sd_prepare_flush() doesn't have the required device 
structure. The reason for that is blk_queue_ordered(). It neither
gets a timeout argument, nor any pointer to the device.

I already tried to use container_of() in sd_prepare_flush, but somehow
that doesn't seem work if the structure member is a pointer.

The next solution that comes into my my mind is to add the timeout argument
to blk_queue_ordered() and subsequentely to modifiy all callers.
Would such a patch be accepted? Or is there any better solution?

Any help is appreciated.


Thanks,
Bernd

PS: (I'm also discussing the cache flush issue with one of our 
hardware vendors, but fixing their firmware might take ages). 
