From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [Bug 12195] "dd" make kernel panic
Date: Fri, 12 Dec 2008 02:22:05 -0800
Message-ID: <20081212102205.GA16034@linux.vnet.ibm.com>
References: <bug-12195-11613@http.bugzilla.kernel.org/> <20081212022704.5488C108042@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36182 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbYLLKWI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 05:22:08 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id mBCALRmi022461
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2008 05:21:27 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mBCAM6lw148684
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2008 05:22:06 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mBCAM50U005378
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2008 05:22:05 -0500
Content-Disposition: inline
In-Reply-To: <20081212022704.5488C108042@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

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
