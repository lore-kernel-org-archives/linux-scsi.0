From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 27 Oct 2003 15:39:32 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031027153932.A16679@infradead.org>
References: <200310231734.10263.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:57609 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262913AbTJ0Pje (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2003 10:39:34 -0500
Content-Disposition: inline
In-Reply-To: <200310231734.10263.krmurthy@cisco.com>; from krmurthy@cisco.com on Thu, Oct 23, 2003 at 05:34:10PM +0530
List-Id: linux-scsi@vger.kernel.org
To: Krishna Murthy <krmurthy@cisco.com>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com

On Thu, Oct 23, 2003 at 05:34:10PM +0530, Krishna Murthy wrote:
> Hi,
> 	Linux iSCSI driver 4.0.0.1 (linux-iscsi-4.0.0.1.tgz) is available at
> 
> http://sf.net/projects/linux-iscsi/

Here's a list of a few comments I've come up with.  I haven't yet looked
at the data structurws much, but it seems there's a complete lack of
refcounting.  Also there's lots of comments were ysou complain about scsi
midlayer misbehaviour or bugs - please submit patches or submit workarounds
when you encounter them, that's what open source is all about!

Also the same question that went to the unh folks goes to you:  why do
you think your implementation is better than theirs and why do you think
cooperation on one iscsi stack is impossible.

here's the list:


highlevel:
	- kill md5.c and iscsi-crc.c and use common cryptoapi
	md5 / common crc code instead.
	- please kill you thousands of atoi/aton reimplementations
	and look for proper linux functions like simple_strtoul.

README:
	- very outdated with 2.4/vendor issues

Makefile:
	- lots of unused kernel detection stuff

iscis-kernel.h:
	- only backward-compat cruft, should go away.

iscsi.c:
	- doesn't need at least smp_lock.h - please audit header
	usage.
	- kill stupid MODULE/MODULE_LICENSE ifdefs.
	- kill = 0 / = NULL initializers for static variables, not needed.
	- kill LINK_DIR/session->target_link_dir - kernel must
	  not know about device pathes.
	- kill max_*_devices - not needed in kernelspace (and wrong
	  in 2.6)
	- fix up strange indentation artefacts from indent, like:

static
struct iscsi_trace_entry
    trace_table[ISCSI_TRACE_COUNT];

should be:

static struct iscsi_trace_entry trace_table[ISCSI_TRACE_COUNT];

	- first argument to memset is void * - don't cast pointers
	to char *
	- dito for memcpy
	- lose stupid braces, e.g.

list_del_init(&(task->task_group_link));

should be just

list_del_init(&task->task_group_link);

	- don't use <hosts.h> but <scsi/scsi_host.h>, similarly
	use <scsi/scsi*.h> instead of scsi.h if possible.  There's
	still some stuff not moved away from scsi.h yet, but you
	should at least avoid anything explicitly marked deprecated
	in that file and not in <scsi/scsi_*.h>
	- no need to implement ->slave_alloc and ->slave_destroy if
	they are noops anyway.
	- kill that slab name randomization - if kmem_cache_destroy
	fails you module is buggy and needs to be fixed.
	- instead of the single linked list of commands use a 
	lists.h list in the scsi_pointer
	- host and hba can't be NULL in ->queuecommand per defintion,
	similarly id, lun cdbsize and use_sg can't be bigger than you
	set in the template.
	- iscsi_info is far too noisy.  I'd suggest killing it and
	just setting the name field in the template propely
	- the procfs code is a mess.  Please move it over to
	proper per-device / per-host sysfs attributes as procfs
	support in HBA drivers is deprecated.
	- kill ctl_open/ctl_release and move add an owner to the
	fops structure for refcounting.
	- the ifdef MODULE around iscsi_init/iscsi_cleanup is bogus
	- lots of ifdef mess - iscsi_kernel.h still has lots of
  	  old kernel compat stuff - kill it.
	- target_reset_occured() is a dup of scsi_report_device_reset()
	- initialization is a total mess.  You try to emulated the
	  pre-2.6 init ordering.  Use something like:

	shost = scsi_host_alloc();
	<content of ->detect>
	scsi_add_host()

	instead, and read the comment abote .legacy_hosts in the
	scsi_host_template defintion!  Similar inline the code
	in iscsi_release into the exitfunc.
	- iscsi.c is _far_ too big.  Needs to be split into a few
	files.  I'd suggest avoiding the name iscsi.c so you can
	build into iscsi.ko
	- the ioctl API looks very broken, I need more time to
	audit it.  As a start slit ctl_ioctl into a function per ioctl
	subcommand.
	- why can't you store a pointer to the session in host-private
	data of the scsi_device so you don't have to search in each
	->queuecommand?
	- kill the is_root_disk special casing.  drivers can't know
	what the root disks is, there might not even be a single one.
	- compilation fails for me in line 480, looks like this is because
	the left-over ifdefs are wrong - just use set_user_nice unconditionally.
	Or even better stop messing with priorities, kill iscsi_daemonize and
	use daemonize() directly.
	- having multiple kmap() in the same process at the same time can kmap(),
	you redesign iscsi_xmit_task/iscsi_xmit_data/iscsi_recv_data not to do that.
	for the tx path use ->sendpage to avoid a data copy and kmapping altogether.
	- the explanation of PREVENT_DATA_CORRUPTION doesn't make sense.
	- why do you have SLAB_NO_REAP optional?  Either it works or it doesn't..
	- please stop that preallocation, you destroy the effect of per-cpu
	caches with that.  
	- you're only allocating one hba struct but still do complex list walking
	to find.  Either move to multiple hbas (and proper standard lists) or
	kill all that overhead.
	- INVALID_ORDERING_ASSUMPTIONS should probably a rutime option (?)
	- what the heck is iscsi_set_if_addr?  You have absolutely no business
	messing with network device configuration.
	- device_flags() is strange.  Better put a separately allocated struct
	into the scsi_device (allocated in slave_alloc, freed in slave_destroy)
	that only contains the bitmask for now.  (and maybe the session, see
	above)
	- similar for command flags - put your own overlay over the scsi_pointer,
	including a bitmask.
	- kfree(NULL) is fine, don't check for variables beeing non-NULL before
	freeing them.

memset(session, 0, sizeof (*session));
kfree(session);

	is rather bad for the cache.

	- this comment indicates you don't want normal EH:

 * check condition with no sense.  We need to avoid this, 
 * since the Linux SCSI code could put the command in 
 * SCSI_STATE_FAILED, which it's error recovery doesn't appear 
 * to handle correctly, and even if it does, we're trying to 
 * bypass all of the Linux error recovery code
 * to avoid blocking all I/O to the HBA.  Fake some sense 
 * data that gets a retry from Linux.

	so don't use scsi_error.c and define your own eh_strategy_handler method.

	- please explain on this:

 * Philsophically we ought to complete the command and let the
 * midlayer or high-level driver deal with retries.  Since the
 * way the midlayer does retries is undesirable, we instead
 * keep the command in the driver, but requeue it for the same
 * cases the midlayer checks for retries.  This lets us ignore
 * the command's retry count, and do retries until the command
 * timer expires.

	why can't you simply mess with the retry count instead
	of duplicating all the retry logic.  really, the midlayer
	queues are there for a reason.

	- this doesn't seem to be an issue for a 2.6-only driver:

 * not to log?  In 2.5 we can put a pointer in
 * Scsi_Device->hostdata, but 2.4 doesn't
  ...


	- your probably want to rewrite your TCQ code to use the
	block layer tcq code, see include/linux/scsi_tcq.h

	- there's lots of if (sc->device) checks where sc is a
	scsi_cmnd - but the device field never can be NULL for
	those, that's guaranteed by scsi_get_command.  Indeed you
	have far too many checks for impossible conditions.  Just
	use BUG_ON for those if you don't trust the midlayer, but
	trying to handle those conditions is just insane.

	- replace iscsi_inet_aton with in_aton?

 *  FIXME: it'd probably be cleaner to move the timeout logic to the rx thread.
 *         The only danger is if the rx thread somehow blocks indefinately.
 *         Doing timeouts here makes sure the timeouts get checked, at the
 *         cost of having this code constantly loop.

	- yes, you really need to reduce the amount of threads in the driver..
	- shost->can_queue is not supposed to be changed once the host is online,
	  as it's not locked down.
	- please produce a simple testcase for the bug mentioned above
	  iscsi_eh_device_reset.
	- the bug mentioned above iscsi_eh_bus_reset should be long fixed.  if
	not please report to linux-scsi.
	- is the iscsi fake geometry documented somewhere?  If not why don't
	you simply use the default, CAM one?


iscsi-probe.c:
	- lots of unchecked kmalloc()s
	- you can't allocate scsi_cmnds yourself but _must_ use scsi_get_command
	- dito for scsi_device.
	- the whole iscsi_do_cmnd use looks very very strange.  you're probably
	much better of to use the scsi_request based interfaces and use midlayer
	queueing and sometimes even higher level interfaces, e.g. your iscsi_send_tur
	coudld be replaced by an scsi_ioctl(sdp, SCSI_IOCTL_TEST_UNIT_READY, NULL)
	I still don't understand, though why the heck you need to do a TUR in
	a lowlevel driver and even more need a thread do a single TUR, started from
	another kernel tread.  there more I dig into it your probing and thread
	abuse looks horribly screwed.
	- reinitilialize disk is another such candidate.  again why do you
	need to send START_STOP commands from the LLDD, why do you need another
	thread instead of a state machine and again life would be a lot simpler
	by using the midlayer queueing infrastructure.
	- dito for the reports luns and inquiry code in iscsi_detect_luns.
	I'm very very unhappy to see a lowlevel driver mess with all this.
	Even if you need to do it from a LLDD use the midlayer functionality for
	it.  But I still want to see a very good explanation why you need this at all.

iscsi-kernel-event.c:
	- sleep_on is racy.
	- the concept of this is screwed.  (See below)

iscsi-event-handler.c:
	- the kernel-event mechanism is totally bogus.  you're not going
	to wait in kernelspace for an userspace upcall doing procfs
	stuff.  As I already said procfs might not even be mounted.
	use scsi_add_device/scsi_remove_device and kill that stupid
	symlinking crap.  Really, if you driver has to deal with
	pathnames something is horribly wrong. If you really want
	devices to show up in /dev/iscsi/ submit patches to udev.

iscsi.h:
	- Linux now has (lowecase) versions of DRIVER_BYTE & co.
	- Linux now has unshifted status codes
