From: Naveen Burmi <naveenb@cisco.com>
Subject: Request for review of Linux iSCSI driver version 4.0.0.2
Date: Fri, 28 Nov 2003 16:06:24 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03112816062402.31165@naveenb-lnx.cisco.com>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:54698 "EHLO
	sj-iport-3.cisco.com") by vger.kernel.org with ESMTP
	id S262110AbTK1Kdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 05:33:41 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: davmyers@cisco.com


Folks,

Thanks to all of you for the review of linux-iscsi driver 4.0.0.1. As on
today, we have taken care of most of the review comments. There are few
others that we are in active discussion in this (scsi) mailing list and
will incorporate them in due course of time.

I would like to call for review of 4.0.0.2 Linux iSCSI driver that has
most of the review comments taken care of. It can be downloaded from

http://sf.net/projects/linux-iscsi/

Could you please review the same for inclusion in 2.6 kernel?

P.S: 4.0.0.2 has been tested successfully with linux-2.6.0-test9.

Here is the list of changes (Based on comments from 1st review):


THE FOLLOWING COMMENTS ARE TAKEN CARE OF:
----------------------------------------

1. Please kill your thousands of atio/aton reimplementations and look for
    proper linux functions like simple_strtoul.

2.  iscis-kernel.h:
        - only backward-compat cruft, should go away.

3.  - doesn't need at least smp_lock.h - please audit header
        usage.
        - kill stupid MODULE/MODULE_LICENSE ifdefs.
        - kill = 0 / = NULL initializers for static variables, not needed.
        - kill LINK_DIR/session->target_link_dir - kernel must
          not know about device pathes.
        - kill max_*_devices - not needed in kernelspace (and wrong
          in 2.6)
        - fix up strange indentation artefacts from indent, like:

4.  static struct iscsi_trace_entry
    trace_table[ISCSI_TRACE_COUNT];

should be:

static struct iscsi_trace_entry trace_table[ISCSI_TRACE_COUNT];

        - first argument to memset is void * - don't cast pointers
        to char *
        - dito for memcpy

5.  - lose stupid braces, e.g.

list_del_init(&(task->task_group_link));

should be just

list_del_init(&task->task_group_link);


6.  - no need to implement ->slave_alloc and ->slave_destroy if
        they are noops anyway.

7.  - kill that slab name randomization - if kmem_cache_destroy
        fails you module is buggy and needs to be fixed.

8.  - host and hba can't be NULL in ->queuecommand per defintion,
        similarly id, lun cdbsize and use_sg can't be bigger than you
        set in the template.

9.  - iscsi_info is far too noisy.  I'd suggest killing it and
        just setting the name field in the template propely

10.  - the procfs code is a mess.  Please move it over to
        proper per-device / per-host sysfs attributes as procfs
        support in HBA drivers is deprecated.

11.  - the ifdef MODULE around iscsi_init/iscsi_cleanup is bogus

12..  - lots of ifdef mess - iscsi_kernel.h still has lots of
          old kernel compat stuff - kill it.

13.  - target_reset_occured() is a dup of scsi_report_device_reset()

14.  - initialization is a total mess.  You try to emulated the
          pre-2.6 init ordering.  Use something like:

        shost = scsi_host_alloc();
        <content of ->detect>
        scsi_add_host()

        instead, and read the comment abote .legacy_hosts in the
        scsi_host_template defintion!  Similar inline the code
        in iscsi_release into the exitfunc.

15.  - iscsi.c is _far_ too big.  Needs to be split into a few
        files.  I'd suggest avoiding the name iscsi.c so you can
        build into iscsi.ko

16.  - the ioctl API looks very broken, I need more time to
        audit it.  As a start slit ctl_ioctl into a function per ioctl
        subcommand.

17.  - why can't you store a pointer to the session in host-private
        data of the scsi_device so you don't have to search in each
        ->queuecommand?

18.  - kill the is_root_disk special casing.  drivers can't know
        what the root disks is, there might not even be a single one.

19.  - compilation fails for me in line 480, looks like this is because
        the left-over ifdefs are wrong - just use set_user_nice 
unconditionally.
        Or even better stop messing with priorities, kill iscsi_daemonize and
        use daemonize() directly.

20.  - why do you have SLAB_NO_REAP optional?  Either it works or it doesn't..

21.  - you're only allocating one hba struct but still do complex list walking
        to find.  Either move to multiple hbas (and proper standard lists) or
        kill all that overhead.

22.  - what the heck is iscsi_set_if_addr?  You have absolutely no business
        messing with network device configuration.

23.  - device_flags() is strange.  Better put a separately allocated struct
        into the scsi_device (allocated in slave_alloc, freed in 
slave_destroy)
        that only contains the bitmask for now.  (and maybe the session, see
        above)

24.  - kfree(NULL) is fine, don't check for variables beeing non-NULL before
        freeing them.

25.  - this doesn't seem to be an issue for a 2.6-only driver:

 * not to log?  In 2.5 we can put aver..

26.  - shost->can_queue is not supposed to be changed once the host is online,
          as it's not locked down.

27.  - please produce a simple testcase for the bug mentioned above
          iscsi_eh_device_reset.

28.  - the bug mentioned above iscsi_eh_bus_reset should be long fixed.  if
        not please report to linux-scsi.

29.  - is the iscsi fake geometry documented somewhere?  If not why don't
        you simply use the default, CAM one?

30.  - lots of unchecked kmalloc()s

31. - Linux now has unshifted status codes.

32.  - kill ctl_open/ctl_release and move add an owner to the
        fops structure for refcounting.

33.  highlevel:
        - kill md5.c and iscsi-crc.c and use common cryptoapi
        md5 / common crc code instead.

34. README: - very outdated with 2.4/vendor issues

35. memset(session, 0, sizeof (*session));
    kfree(session);

        is rather bad for the cache.

36.  - please stop that preallocation, you destroy the effect of per-cpu
        caches with that.


CURRENTLY WORKING ON FOLLOWING COMMENTS:
---------------------------------------

1.  - the explanation of PREVENT_DATA_CORRUPTION doesn't make sense.

2.  highlevel:
        - kill scsi-crc.c and use common cryptoapi
         common crc code instead.

3. Makefile:
        - lots of unused kernel detection stuff

4.  - please produce a simple testcase for the bug mentioned above
          isidlayer queueing infrastructure.
        - dito for the reports luns and inquiry code in iscsi_detect_luns.
        I'm very very unhappy to see a lowlevel driver mess with all this.
        Even if you need to do it from a LLDD use the midlayer functionality
        for it.  But I still want to see a very good explanation why you need
        this a t all.

5.  - don't use <hosts.h> but <scsi/scsi_host.h>, similarly
        use <scsi/scsi*.h> instead of scsi.h if possible.  There's
        still some stuff not moved away from scsi.h yet, but you
        should at least avoid anything explicitly marked deprecated
        in that file and not in <scsi/scsi_*.h>

6.  - having multiple kmap() in the same process at the same time can kmap(),
        you redesign iscsi_xmit_task/iscsi_xmit_data/iscsi_recv_data not to do
        that. for the tx path use ->sendpage to avoid a data copy and kmapping
        altogether.

7.  - this comment indicates you don't want normal EH:

 * check condition with no sense.  We need to avoid this,
 * since the Linux SCSI code could put the command in
 * SCSI_STATE_FAILED, which it's error recovery doesn't appear
 * to handle correctly, and even if it does, we're trying to
 * bypass all of the Linux error recovery code
 * to avoid blocking all I/O to the HBA.  Fake some sense
 * data that gets a retry from Linux.
 
so don't use scsi_error.c and define your own eh_strategy_handler method.
 
8.  - please explain on this:
 
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
 
9.  - you can't allocate scsi_cmnds yourself but _must_ use scsi_get_command
 
10.  - dito for scsi_device.
 
11.  - the whole iscsi_do_cmnd use looks very very strange.  you're probably
        much better of to use the scsi_request based interfaces and use 
midlayer
        queueing and sometimes even higher level interfaces, e.g. your
        iscsi_send_tur could be replaced by an
        scsi_ioctl(sdp, SCSI_IOCTL_TEST_UNIT_READY, NULL)
        I still don't understand, though why the heck you need to do a TUR in
        a lowlevel driver and even more need a thread do a single TUR, started
        from another kerns of DRIVER_BYTE & co.

Thanks,
Naveen.
