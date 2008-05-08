From: Elias Oltmanns <eo@nebensachen.de>
Subject: Linux specific scsi CDBs vs REQ_TYPE_LINUX_BLOCK requests
Date: Thu, 08 May 2008 19:43:18 +0200
Message-ID: <87r6ccadzd.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:43599 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbYEHRmx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2008 13:42:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Jens,

way back you introduced REQ_TYPE_LINUX_BLOCK requests as some sort of
generic block layer messages. As it turns out, it is not quite obvious
how to add support for this type of requests in the scsi subsystem
properly. On the other hand, Boaz Harrosh has recently added support for
variable length and in particular vendor specific CDBs to the scsi mid
layer. My question to you and James is this: Would it make sense, in
your opinion, to (ab)use BLOCK_PC requests carrying linux specific CDBs
for those purposes you had in mind when introducing LINUX_BLOCK
requests? This would make things much easier as far as scsi is concerned
and it would still be possible to add suport for this kind of requests
to non scsi drivers. On the other hand, this might constitute too
serious a violation of the layers and subsystems involved as I'm
not quite sure, for instance, where to keep the list of those linux
specific opcodes -- include/linux/blkdev.h and include/scsi/scsi.h both
don't seem quite right.

The reason why I'm bothering you with all this is that I'm trying to get
disk shock protection merged into mainline eventually; see the subthread
starting at [1] for a preliminary patch series. Since I want to make
this feature available to both, libata as well as ide, it is appealing
to put the common bits (the timer and the user interface) into the block
layer, thus avoiding code duplication. However, given the difficulties
to realise this approach sanely, it might be better to leave the block
layer out of it as far as possible. After all, it's the ATA specific
feature (immediate disk head unloading) I really care for and by means
of ioctls we could still provide an interface to userspace which doesn't
depend on whether the device is managed by libata or ide.

In fact, unless you are definitely in favour of the block layer approach
(as realised in [2]) and can give me a hint as to how I could solve the
problems described above, I will probably prepare a patch series using
ioctls and post it on linux-ide. The reason is that this approach might
even solve another problem I see further down the road.

Thank you for your advice,

Elias

[1] <http://permalink.gmane.org/gmane.linux.ide/29519>
[2] <http://permalink.gmane.org/gmane.linux.ide/29523>
