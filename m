From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Fri, 01 Aug 2008 16:28:03 +0400
Message-ID: <48930153.5090609@vlnb.net>
References: <488E02DE.5080100@vlnb.net> <1217267776.3503.112.camel@localhost.localdomain> <488E0C78.80205@vlnb.net> <1217484743.25491.7.camel@galr-linux> <489181C4.70003@vlnb.net> <20080731160251.GB76172@plap4-2.local> <4891F95A.9070409@vlnb.net> <20080731175544.GB80258@elab5.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:42624 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751371AbYHAM2Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2008 08:28:16 -0400
In-Reply-To: <20080731175544.GB80258@elab5.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com, Gal Rosen <galr@storwize.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

Andrew Vasquez wrote:
> On Thu, 31 Jul 2008, Vladislav Bolkhovitin wrote:
> 
>>> The changes above are large (170k diffs so far), and at this point are
>>> being run-through our testing.  The hope is to get the changes
>>> upstream during one of the next two merge windows.
>>>
>>> Given the infrustructure mods and our focus on that front, if there's
>>> something small and contained you can offer above what I've proposed
>>> we'll be interested in reviewing any patches you'd push forward.
>> Then, I believe, my patch should go in as a temporal measure. I don't think 
>> we should crash users for 2 more major releases.
> 
> So the 'online' check concerns you?  So, add an 'unloading' flag, set
> it on remove_one(), save a copy of dpc_thread at qla2xxx_wake_dpc(),
> then wake_up() saved value if not 'unloading'.  Of course the direct
> wake_up() in request_acqusition should be modded to call
> qla2xxx_wake_dpc().  We're not talking about some huge window here.

My main concern is not about the 'online' flag, but about that your 
patch doesn't fix the race, which it's intended to fix, because:

1. It doesn't handle possibility of CPU to reorder commands. Hence, it 
could be possible that other CPUs can see 'online' flag set to 0 *after* 
dpc_thread set to NULL, despite in the code "ha->flags.online = 0" 
precede "ha->dpc_thread = NULL". To address that the corresponding 
memory barriers around ha->flags.online assignment and reading are needed.

2. More importantly, it doesn't handle possibility for task_struct, to 
which dpc_thread field refers, to be destroyed exactly between lines

if (ha->flags.online && t)
	wake_up_process(t);

or inside wake_up_process(). Hence, already freed and possibly reused 
data will be accessed by wake_up_process() with all corresponding bad 
consequences.

>> The same is true for my 
>> other patch "Proposed protection of fcports field of struct scsi_qla_host" 
>> as well, because without it there should be no big problems to crash the 
>> driver via sysfs.
> 
> We're still looking through your patches...  So how exactly would it
> be 'be no big problems to crash the driver via sysfs.'???

Example scenario: one or many applications read in a loop any sysfs 
entry, which go over fcports list, and at the same time DPC thread adds 
to it new entries. If CPU can reorder commands (most modern CPUs can) it 
is possible that list_for_each_entry() will access partially inserted 
entry => NULL pointer dereference.

To see better what I mean look at the difference between list_add() and 
list_add_rcu() as well as between list_for_each_entry() and 
list_for_each_entry_rcu().

Vlad
