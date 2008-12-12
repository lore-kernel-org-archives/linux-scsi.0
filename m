From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12195] "dd" make kernel panic
Date: Fri, 12 Dec 2008 02:22:17 -0800 (PST)
Message-ID: <20081212102217.BB88F108048@picon.linux-foundation.org>
References: <bug-12195-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892AbYLLKWx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 05:22:53 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBCAMIjl029483
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2008 02:22:20 -0800
In-Reply-To: <bug-12195-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12195





------- Comment #7 from anonymous@kernel-bugs.osdl.org  2008-12-12 02:22 -------
Reply-To: andmike@linux.vnet.ibm.com

bugme-daemon@bugzilla.kernel.org <bugme-daemon@bugzilla.kernel.org> wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12195
> 
> 
> 
> 
> 
> ------- Comment #6 from ming.m.lin@intel.com  2008-12-11 18:27 -------
> 2.6.28-rc8 also panic

The blk_mark_rq_complete check should prevent completions from occurring on
already timed out requests unless the interaction previous mentioned between
mpt_fault_reset_work and the scsi eh thread requeue alows the REQ_ATOM_COMPLETE
bit to get cleared prior to the scsi_done being called from
mptscsih_flush_running_cmds. This did not look obvious to hit.

mpt_fault_reset_work
        mpt_HardResetHandler
                mpt_signal_reset
                        mptsas_ioc_reset 
                                mptscsih_flush_running_cmds
                mpt_do_ioc_recovery

When scsi_times_out is called there should not be a transportt->eh_timed_out,
or hostt->eh_timed_out set for mptsas which should lead to waking up the eh
thread. We will then call mptscsih_abort from the eh thread and it will return
success if the scsi command is not found leading to a possible requeue.

If you have time for another re-create it would be good to set some scsi
logging.
sysctl -w dev.scsi.logging_level=4100 # mlcomplete 1 and error 4
echo "1" > /proc/sys/kernel/sysrq # If needed
echo 9 > /proc/sysrq-trigger # Raise console log level

Also if you have more dmesg output prior to the error from the previous
failure runs that would be good to post also.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
