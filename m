From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [libsas PATCH v13] scsi, sd: limit the scope of the async probe domain
Date: Thu, 17 May 2012 06:38:00 -0700
Message-ID: <CABE8wwtNJ1C8petYHfHn0kCwNx9Qt4FC27E61atWLaJWxTGYtg@mail.gmail.com>
References: <20120323000201.17750.18754.stgit@dwillia2-linux.jf.intel.com>
	<1337242396.2926.16.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1337242396.2926.16.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 17, 2012 at 1:13 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2012-03-22 at 17:05 -0700, Dan Williams wrote:
>> --- a/drivers/scsi/scsi_priv.h
>> +++ b/drivers/scsi/scsi_priv.h
>> @@ -163,6 +163,10 @@ static inline int scsi_autopm_get_host(struct S=
csi_Host *h) { return 0; }
>> =A0static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
>> =A0#endif /* CONFIG_PM_RUNTIME */
>>
>> +#if IS_ENABLED(CONFIG_PM) || IS_ENABLED(CONFIG_BLK_DEV_SD)
>> +extern struct list_head scsi_sd_probe_domain;
>> +#endif
>
> This #if is unnecessary. =A0There's no need to conditionally compile
> external variable or function declarations. =A0The only reason we do =
it
> for functions is if we need an else branch with an empty body.

Yeah, that got removed in a later version:

http://www.spinics.net/lists/linux-ide/msg43429.html

Seeing as you are pulling individual patches from the Wayback machine
let me know which ones need resending.  My current backlog (minus this
one) is:

9f8a41c libsas: cleanup spurious calls to scsi_schedule_eh
06895b3 libata, libsas: introduce sched_eh and end_eh port ops
f41b618 scsi: fix eh wakeup (scsi_schedule_eh vs scsi_restart_operation=
s)
3bd4c2a scsi_transport_sas: fix delete vs scan race
af80d48 libsas: enforce eh strategy handlers only in eh context
6e1d0a0 libsas: add sas_eh_abort_handler
0422f1f libsas: use ->lldd_I_T_nexus_reset for ->eh_bus_reset_handler
b579e49 isci: use sas eh strategy handlers
3cbe97b libsas: trim sas_task of slow path infrastructure
b377ed2 libsas: sas_rediscover_dev did not look at the SMP exec status.
1821ae0 mvsas: remove unused variable in mvs_task_exec()
3a9bfca libata: reset once
ef475b4 libsas: continue revalidation
dd4a159 libata: export ata_port suspend/resume infrastructure for sas
df05813 libsas: drop sata port multiplier infrastructure
178afd2 libsas: suspend / resume support
56dcb7c scsi: cleanup setting task state in scsi_error_handler()
a4df371 isci: improve 'invalid state' warnings
2b28b3a isci: kill ->is_direct_attached
9890839 isci: fix 'link-up' events occur after 'start-complete'
d34647d isci: kill sci_phy_protocol and sci_request_protocol
efb3820 isci: fix interrupt disable
523303d isci: Don't filter BROADCAST CHANGE primitives
47439eb isci: kill isci_host.shost
f6abc58 isci: kill ->status, and ->state_lock in isci_host
71f4553 isci: implement suspend/resume support
13906c3 isci: kill isci_port.domain_dev_list
a80e24c isci: Changes in COMSAS timings enabling ISCI to detect buggy
disc drives.
ed12d25 isci: refactor initialization for S3/S4
68b9d79 isci: enable BCN in sci_port_add_phy()
bc1ddb0 isci: fix controller stop
c2f6304 isci: fix oem parameter validation on single controller skus
32400e3 isci: Manage the link layer hang detect timer for RNC suspensio=
ns.
d95c58c isci: Fixed bug in resumption from RNC Tx/Rx suspend state.
657830a isci: Handle all suspending TC completions
c31f05e isci: Terminate outstanding TCs on TX/RX RNC suspensions.
1a69708 isci: Manage device suspensions during TC terminations.
dc473c8 isci: Remote device must be suspended for NCQ cleanup.
4f30fa2 isci: Remote device stop also suspends the RNC and terminates I=
/O.
2656b8f isci: Escalate to I_T_Nexus_Reset when the device is gone.
741bab2 isci: Redesign device suspension, abort, cleanup.
db7328c isci: Add suspension cases for RNC INVALIDATING, POSTING states=
=2E
671db01 isci: Device access in the error path does not depend on IDEV_G=
ONE.
0790396 isci: All pending TCs are terminated when the RNC is invalidate=
d.
0da9c73 isci: Only set IDEV_GONE in the device stop path.
3384bac isci: Remove isci_device reqs_in_process and dev_node from isci=
_device.
2eec736 isci: Distinguish between remote device suspension cases
51c541d isci: Fix the terminated I/O to not call sas_task_abort().
751a0f6 isci: Save the suspension hint for upcoming suspensions.
398224e isci: Manage the LLHANG timer enable/disable per-device.
eedd2a2 isci: Make sure all TCs are terminated and cleaned in LUN reset=
=2E
00854bb isci: Implement waiting for suspend in the abort path.
7eda4e0 isci: When in the abort path, defeat other resume calls until d=
one.
1efce89 isci: Callbacks to libsas occur under scic_lock and are synchro=
nized.
6314cc6 isci: Manage tag releases differently when aborting tasks.
3a194f8 isci: Fix RNC suspend call for SCI_RESUMING state.
723f5f5 isci: Wait for RNC resumption before leaving the abort path.
64c1001 isci: Directly control IREQ_ABORT_PATH_ACTIVE when completing T=
MFs.
4539df1 isci: Add protocol indicator for TMF requests.
9db7785 isci: Added timeouts to RNC suspensions in the abort path.
f68e45a isci: Change the phy control and link reset interface for HW re=
asons.
bbdebf0 isci: Don't wait for an RNC suspend if it's being destroyed.
1479980 isci: Restore the ATAPI device RNC management code.
244d5955 isci: Check IDEV_GONE before performing abort path operations.
9728c87 isci: Remove obviated host callback list.
de98479 isci: Manage the IREQ_NO_AUTO_FREE_TAG under scic_lock.
74dbb19 isci: Fix RNC AWAIT_SUSPENSION->INVALIDATING transition.
1d43a58 isci: Fixed RNC bug that lost the suspension or resumption
during destroy
4fe7411 isci: End the RNC resumption wait when the RNC is destroyed.

These are contained in the following git branches.

git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas/next
git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git isci/next
git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git isci/rnc-re=
work

--
Dan
