From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Read-Only devices, multipath and more
Date: Fri, 16 May 2008 21:35:44 +0200
Message-ID: <1210966544.12901.51.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
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
To: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
Cc: Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: linux-scsi@vger.kernel.org

Hi,

I'll try to summarize the facts about how linux kernel (scsi and
device-mapper) and userspace (multipath-tools) handles devices
RO->RW->RO changes.

The sample setup is 2 x EMC Symmetrix systems, with a pair of logical
unit configured for synchronous inter-system replication (SRDF). In a
normal situation, the LU receiving the data updates (the R2) is RO,
while the LU emitting the data updates (the R1) is RW. Let's take this
state as a starting point.

Server S1 sees R1. Server S2 sees R2

---

t0)
storage state: R1 (RW) <- sync -> R2 (RO)=20
action: Linux system on S2 freshly rebooted.
fact: scsi paths to R2 are reported read-only by "hdparm -r"
fact: device-mapper refuse to load a RW multipath table on these paths
(ie without libdevmapper:set_task_set_ro())

question: should change this behaviour to allow to load a RW multipath
table on these paths and let the IO be failed by the storage hardware ?

t1)
=EF=BB=BFstorage state: R1 (RW) <- split -> R2 (RW)=20
action: none
fact: scsi paths to R2 are still reported read-only by "hdparm -r"
fact: device-mapper still refuse to load a RW multipath table on these
paths
=EF=BB=BFfact: if a RO multipath table was loaded at t0, it is still RO a=
t t1

question: shouldn't the write protection change be detected by the scsi
kernel subsystem, or should we implement a userspace device polling ?
question: how do we detect from userspace the device write protection
change ? (trying to load a multipath devmap is not a good test).
sg-utils maybe ? in multipathd or in a separe daemon, as the issue
extends beyond multipathing ?

action: echo 1>/sys/block/sd{a,b}/device/rescan
fact: the write protection flags are updated to the correct RW state and
multipath then works as expected

question: is there a softer way to update the write proctection flags ?

t2)
=EF=BB=BFstorage state: R1 (RW) <- resync -> R2 (RO)=20
action: none
fact: the RW multipath devmap is still loaded

question: so why not permit to load it in the first place ?

---

This scenario shows there is an annoying lack of consistency and
symmetry in the Linux behaviour. I'm willing to implement whatever is
expected from the multipath-tools. But can we define what is expected ?

Alasdair proposed to add more explicit table loading ioctl return code
when the failure is due to this ready-only paths issue (E_ROFS for
example). Which comes short of solving the RO->RW devmap promotion=20

Please advise.
Christophe Varoqui (keep me on cc:)
