From: michaelc@cs.wisc.edu
Subject: Move dm hw handlers to lower level subsystems
Date: Sat, 09 Jun 2007 14:07:57 -0500
Message-ID: <11814160842916-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu,
	device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

The following patches remove the dm hw handlers and move them
to scsi (there is only one hw handler dm-emc, but I also added
one for old hp boxes which cannot be upgraded).

Why move this piece of code to the scsi layer or dasd layer
or wherever they are needed?
- dm is only a BIO mapper/router. It does not know anything about
scsi and it would be nice that it did not have to.
- In the future we can use the scsi hw handlers for more advanced
things. For example, during scanning they can check a devices
state (check it if is a passive path using whatever vendor specific
checks it needs to), then we can set some bits or do
some magic so that when we get commands to passive devices later
(like from partition scanning or userspace app scanning) we
can avoid retries and filling the logs with noisey error messages.

The drawbacks?
- I think sending REQ_TYPE_BLOCK_PC from dm hw handlers is very
simple. There is no needed for the REQ_TYPE_LINUX_BLOCK/REQ_LB_OP_TRANSITION
abstraction.

The patches I am sending converts what is in mainline. In the past
I was converting every patch that has been sent to dm-devel, so I could
make sure it all work or was going to work or was just as horrible as
dm :), but I think it would be an easier transition to just get what
is in mainline coverted so we can began doing more advanced things like
Ed and Chandra's patches (I am working on patches for that once this
is done).

The patches should work with the existing multipath tools. The dm multipath
argument code, will load the scsi hw handler when it see the dm one.
The only thing we do not handle in a nice backward compat way in the
kernel is the dm hw handler specific arguments. Because the hw handlers
move to a different subsytem, there was not nice way to do some sort
of compat code in the kernel. And there was actually only one hw handler,
and I guess Hannes or Ed, in a previous thread said the defaults for it
should be fine most of the time initially so I did not worry.

I did testing on the code, but I do not actaully have any of this hardware,
so I hacked up scsi_debug. This was nice because I can test all the code
paths, but I am not really sure how realistic the testing is. So if you
have a old hp/compaq hsv/msa box where the firmware cannot be upgraded
or a emc clariion box try it out.
