From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 0/0/0/5] New SCSI target framework (SCST) with dev handlers
 and 2 target drivers
Date: Tue, 13 Apr 2010 17:03:55 +0400
Message-ID: <4BC46BBB.7060508@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Linus Torvalds <torvalds@linux-foundation.org>, Vu Pham <vu@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, linux-driver@qlogic.com, Jens Axboe <jens.axboe@oracle.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Please review this second iteration of the patch set of the new 
(although, perhaps, the oldest) SCSI target framework for Linux SCST 
with a set of dev handlers and 2 target drivers: for iSCSI (iscsi-scst) 
and for Infiniband SRP (srpt).

The first iteration you can found here: http://lkml.org/lkml/2008/12/10/245.

Please review this patchset as a proposed replacement of the current 
mainline SCSI target subsystem STGT.

I've already described advantages of SCST over STGT in 
http://lkml.org/lkml/2008/12/10/245. In short, they are:

1. Performance, including various performance improvements not available 
from user space, for instance, because of the user space allocated memory.

2. Overall simplicity with the resulting simpler and more clear code, 
because STGT has a microkernel-like architecture, but SCST has the same 
monolithic architecture as the Linux kernel has chosen from the very 
beginning.

3. Complete pass-through support, which isn't practically possible if 
the SCSI target core stays in user space.

I can add to what I already wrote only:

1. There are recent performance comparison data between SCST SRP and 
STGT iSER measured by Bart Van Assche with the following target setup:

* 2.6.30.7 kernel with SCST patches and with kernel debugging disabled.
* OFED 1.5 IB drivers.
* SCST revision 1504 with FILEIO vdisk, built in release mode (make
   debug2release) and with SCST_MAX_TGT_DEV_COMMANDS changed from 48 into
   256.
* ib_srpt kernel module parameters thread=0.
* STGT revision 1.0.1 with rdwr backend.
* 1 GB file residing on a tmpfs filesystem was exported towards the
   initiator system.
* Frequency scaling was disabled.
* Runlevel: 3.
* IRQ affinity for mlx4-comp-0: not bound to a core (smp_affinity=3).
* IB HCA: QDR (40Gbps) Mellanox ConnectX MT26428
* CPU: Intel Core2 Duo E8400 @ 3.00 GHz.
* NOOP I/O scheduler

and initiator setup:

* Vanilla 2.6.33-rc7 kernel
* SRP initiator was loaded with parameter srp_sg_tablesize=128
* Frequency scaling was disabled.
* Runlevel: 3.
* IRQ affinity for mlx4_core: bound to a single core (smp_affinity=1).
* IB HCA: QDR (40Gbps) Mellanox ConnectX MT26428
* CPU: Intel Core2 Duo E6750 @ 2.66 GHz.

The test application was dd utility in O_DIRECT mode run 3 times, then 
average was calculated. Caches were dropped between each run.

For dd bs 4KB:

SCST: write 84 MB/s, read 104 MB/s
STGT: write 62 MB/s, read 64 MB/s

For dd bs 6MB:

SCST: write 1030 MB/s, read 2944 MB/s
STGT: write 796 MB/s, read 1702 MB/s

I've chosen those values for dd bs, because they allow to measure 2 
fundamental properties of any link: latency (with bs 4KB) and bandwidth 
(with bs 6MB). You can see that SCST up to 63% better in latency and up 
to 73% better in bandwidth! Here is clearly seen the user space 
implementation overhead! Are there any other evidences needed?

2. Since the first SCST patches review iteration in December 2008 
popularity of STGT, despite of the being "mainline", has not grown 
noticeably, while popularity of SCST has significantly grown. 
Particularly, Emulex and Marvell added SCST target drivers for their 
hardware (thanks a lot!), Joe Eykholt added FCoE target (thanks a lot 
too!) as well as many storage companies are now either selling 
SCST-based storage devices (see http://scst.sourceforge.net/users.html), 
or preparing to sell them (so not yet listed on the users page).

STGT was originally introduced in 2005 as a "simpler" SCST, where the 
SCSI target state machine moved from the kernel to user space with goal 
to create smaller in-kernel code in a hope that it would be similarly 
effective as the fully in-kernel approach SCST using, but would create 
less the in-kernel part's maintaining effort.

Now, after nearly 5 years passed, it is clear that the overhead of the 
split kernel/user processing of STGT is much higher than with the fully 
in-kernel processing of SCST. Thus, we can see now that the hopes for 
the similarly effective processing of STGT were not correct. We can also 
see now that the size of in-kernel part only doesn't matter without 
considering the overall size of the system including the user space part 
(see http://lkml.org/lkml/2007/4/24/364). Thus, there are no points now 
  left to keep STGT in the kernel.

Usually, if for the kernel there are more than one patch/product/etc. 
doing the same functionality, users are allowed choose the best one by 
voting for it by using it. So, from this point it is also clear that 
users have been voting for SCST, not STGT (see above). Just, for 
instance, count the number of target drivers for SCST: for QLogic (Fibre 
Channel), Emulex (FC and FCoE), Marvell (SAS) and LSI (parallel SCSI, FC 
and SAS) hardware as well as for iSCSI, SRP (InfiniBand) and FCoE! While 
STGT has target drivers only for iSCSI/iSER and IBM pSeries Virtual SCSI 
(ibmvstgt).

Moreover, (Open)Solaris is now developing similar to SCST fully 
in-kernel SCSI target subsystem COMSTAR. Solaris developers are 
similarly started from the user space approach, but quickly realized its 
limitations and moved to the fully in-kernel approach.

Thus, we believe, that 5 years is sufficient time to decide that the 
original hopes for STGT were not correct, STGT is worse than SCST, and 
users are voting for SCST, therefore it is a time for Linux kernel to 
acknowledge those and choose the best option. While Linux is loosing 
time with the worse approach, COMSTAR is going much ahead.

Currently, the kernel has only one target driver for STGT: ibmvstgt from 
drivers/scsi/ibmvscsi, so this is the only driver that would be affected 
by the removal of the in-kernel part of STGT. STGT iSCSI/iSER target 
will not be affected, because it's implemented fully in user space and 
doesn't use any services of the in-kernel part of STGT. Regarding 
ibmvstgt, we don't know how many users this driver has, but I guess, 
only few at best, because it is for very special IBM's mainframe 
virtualization hardware (is it still produced?) and I wasn't able to 
find maintainer for it in the MAINTAINERS file for 2.6.33. Anyway, we 
are willing to do the best to migrate this driver to SCST. But who is 
the maintainer who we should contact? Without hardware we can make at 
the best a compile tested only version.

In future, as I wrote in http://lkml.org/lkml/2008/12/10/245, the user 
space part of STGT could be a good supplement for SCST as a framework to 
produce SCST user space targets via scst_local module (see 
http://lkml.org/lkml/2008/12/10/289), although so far I have not seen 
any interest to development of user space target drivers.

Since the first iteration of the SCST patches, together with a lot of 
other new features and improvements (version 2.0 is going to be released 
soon), we have fixed all review comments and added to SCST a sysfs-based 
interface instead of the old not allowed procfs-based interface. Also we 
reduced amount of the kernel patches touching the kernel's code outside 
of SCST and its drivers.

The the new sysfs interface is nice looking and easy to use. It is a big 
step ahead. Detail description of it with a sample layout you can find 
in the SCST docs. The exceptional feature of the new sysfs interface is 
that it is self-documented, i.e. with it for any management utilities, 
like scstadmin [1], there's no need to know anymore how to configure 
each specific target driver and dev handler. In other words, the 
management code will be made once and will work for all current and 
future targets and dev handlers, including implemented both in kernel 
and user spaces, without any internal changes. To achieve that all is 
necessary is that all target drivers and dev handlers should follow few 
several simple rules how to represent their internal configuration on 
the sysfs. You can find the sysfs rules also in the SCST doc patch. Any 
comments are welcome.

This iteration for simplicity contains only 2 target drivers: for iSCSI 
and SRP. If SCST accepted, we will submit other mainline ready drivers 
later: for QLogic, Emulex and Marvell hardware + scst_local +, probably, 
FCoE target fcst, if Joe Eykholt thinks it's ready.

This patchset is for kernel 2.6.33.

In the next iteration, if we don't be told during this review anything 
really bad, in few weeks time we are going to prepare a request for 
inclusion patch set.

Home page of SCST is http://scst.sourceforge.net
Home page of iSCSI-SCST is http://iscsi-scst.sourceforge.net
Home page of SCST SRP target driver is 
http://scst.sourceforge.net/target_srp.html

Thank you for your time,
Vlad

[1] Scstadmin is an utility, which allows doing SCST configuration using 
a text config file. Among other, it has the following great facilities:

1. A possibility to apply changes in the config file to currently 
running system. Only changes applied, so there are no any unneeded 
restarts and resets.

2. Generate a config file for currently running system.
