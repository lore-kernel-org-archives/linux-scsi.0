From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc4 for 2.6.36-rc4
Date: Sat, 18 Sep 2010 13:32:12 -0700
Message-ID: <1284841932.13344.339.camel@haakon2.linux-iscsi.org>
References: <1284754930.13344.216.camel@haakon2.linux-iscsi.org>
	 <20100918125729D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100918125729D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@suse.de, michaelc@cs.wisc.edu, bharrosh@panasas.com, konrad@darnok.org, jeykholt@cisco.com, hare@suse.de, hch@lst.de, James.Smart@Emulex.Com, andrew.vasquez@qlogic.com, philipp.reisner@linbit.com, martin.petersen@oracle.com, vasu.dev@linux.intel.com, Joel Becker <joel.becker@oracle.com>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2010-09-18 at 13:00 +0900, FUJITA Tomonori wrote:
> On Fri, 17 Sep 2010 13:22:10 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > It is my great pleasure to announce that TCM/LIO v4.0.0-rc4 for v2.6.36-rc4 has
> > been tagged and pushed into lio-core-2.6.git/lio-4.0.  The last weeks have been
> > really very busy and many gracious thanks go out to all of the individuals who
> > made comments and helped bring together this v4.0.0-rc4 release.  A list of the
> > major changes includes:
> 
> Have you addressed all the non-SCSI obstacles to mainline inclusion?
> Sorry, I can't track TCM thread but I thought that you got some sysfs
> issues at least?

So the only remaining item outside of drivers/target/ code that needs to
be addressed for .37 is the symlink referencing counting bit.  This is
the case where a struct config_group with symlinks that use a
destination that is in a struct config_group *above* where the source
link struct config_group lives, and currently makes it impossible to
signal (from theconfigfs consumer perspective) the destination symlink
that the parent struct config_group is being dropped with rmdir().

Joel and I have been discussing potential resoultions here:

http://marc.info/?l=linux-fsdevel&m=128414860505481&w=2

but we have yet to come to a resolution, and the ->check_link() patch is
still in use in lio-core-2.6.git/lio-4.0 code.

The possibilities that have been discussed so far include:

*) Include the original struct config_item_operations->check_link()
patch and require the configfs customer to be aware of this case when
fs/configfs/symlink.c:configfs_unlink().  At this point this still works
OK for me, but I do acknowledge that making the configfs consumer aware
of this issue is really not the proper right long term solution.

*) Use refcounting for the symlinks inside of the configfs consumer.  I
asked Joel about how to do this in his last response, but I have not yet
heard back from him.   Joel, would you be so kind as to elaborate on
what you meant by this..?

*) Make fs/configfs/symlink.c code handle this specific "destination
link outside of parent struct config_group" symlink reference count case
internally instead of requiring configfs consumers be aware of the
issue.

At this point I am still leaning towards #3 (with Joel's blessing) as
the cleanest  long term solution, but I am still happy to persue #2 for
fabric independent configfs handlers target_core_fabric_configfs.c code
for the .37 merge.  I am still open suggestions (again, with Joel's
blessing) about how to get this item properly resolved.

> 
> If so, can you tell me where I can find reviewable patchset?

So the RFC cuts have been going into a seperate tree here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-4.0.git;a=summary

Mike has requested an RFC v2 for him to review TCM Core and TCM_Loop
v4.0.0-rc4 changes.  So I will be respinning this tree with the latest
changes from lio-core-2.6.git/lio-4.0 and re-posting in the next days.

> I really hope that you drop stuff from the patchset that isn't a must for
> target support (e.g. queuecommand lock stuff). If you keep adding
> something new to tha patchset, it's really difficult to review it.
> --

Indeed, I plan to keep the drop-host_lock stuff a logically seperate item,
and the TCM_Loop ->queuecommand() caller in the upcoming RFC v2 patches
will still contain the original host_lock unlock() -> do_work() -> lock()
optimization in use by many mainline LLDs today.  I will plan to send a
seperate patch to James depending how/when the drop-host_lock stuff is merged.

Many thanks for your comments Tomo-san!

--nab
