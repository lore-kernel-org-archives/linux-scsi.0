From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] zfcp: Invalid locking order
Date: Thu, 8 Feb 2007 15:40:03 +0100
Message-ID: <20070208144003.GC8345@osiris.boeblingen.de.ibm.com>
References: <200702071317.58026.swen.schillig@freenet.de> <20070207160643.GE30311@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:56726 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423081AbXBHOlq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 09:41:46 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate7.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l18Ef1sF065258
	for <linux-scsi@vger.kernel.org>; Thu, 8 Feb 2007 14:41:01 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l18Ef0io1880288
	for <linux-scsi@vger.kernel.org>; Thu, 8 Feb 2007 14:41:00 GMT
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l18Ef0QW026132
	for <linux-scsi@vger.kernel.org>; Thu, 8 Feb 2007 14:41:00 GMT
Content-Disposition: inline
In-Reply-To: <20070207160643.GE30311@alberich.amd.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Swen Schillig <swen.schillig@freenet.de>, linux-scsi@vger.kernel.org

On Wed, Feb 07, 2007 at 05:06:43PM +0100, Andreas Herrmann wrote:
> On Wed, Feb 07, 2007 at 01:17:57PM +0100, Swen Schillig wrote:
> > From: Swen Schillig <swen@vnet.ibm.com>
> > 
> > Invalid locking order. Kernel hangs after trying to take two locks
> > which are dependend on each other. Introducing temporary variable
> > to free requests. Free lock after requests are copied.
> >     
> 
> I am just curious. You didn't mention which locks are causing the dead
> lock.
> 
> I've glanced through the code and it seems that locking order
> of abort_lock and req_list_lock for adapters is inconsistent.
> Is that the bug you try to fix?

It's a possible A-B-B-A deadlock on the erp_lock and req_list_lock
(see output below).  The bug was introduced with
fea9d6c7bcd8ff1d60ff74f27ba483b3820b18a3 and this patch reverts
parts of it.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.20-rc6-mm3 #2
-------------------------------------------------------
zfcperp0.0.5207/165 is trying to acquire lock:
 (&adapter->erp_lock){++..}, at: [<802110ea>] zfcp_erp_port_forced_reopen+0x3a/0x68

but task is already holding lock:
 (&adapter->req_list_lock){++..}, at: [<8021bec2>] zfcp_fsf_req_dismiss_all+0x2e/0x124

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&adapter->req_list_lock){++..}:
       [<000522e0>] lock_acquire+0x6c/0x94
       [<002d7dc2>] _spin_lock+0x46/0x58
       [<0020c0ec>] zfcp_erp_strategy_check_action+0x130/0x328
       [<00210008>] zfcp_erp_thread+0x1cc/0x1274
       [<00018dfa>] kernel_thread_starter+0x6/0xc
       [<00018df4>] kernel_thread_starter+0x0/0xc

-> #0 (&adapter->erp_lock){++..}:
       [<000522e0>] lock_acquire+0x6c/0x94
       [<002d819e>] _write_lock+0x46/0x58
       [<002110ea>] zfcp_erp_port_forced_reopen+0x3a/0x68
       [<0021159e>] zfcp_erp_adisc_handler+0x1a6/0x258
       [<002138ac>] zfcp_fsf_send_els_handler+0x140/0x548
       [<00216afe>] zfcp_fsf_req_dispatch+0x1a6/0x1c44
       [<0021b266>] zfcp_fsf_req_complete+0xfa/0xd28
       [<0021bf6c>] zfcp_fsf_req_dismiss_all+0xd8/0x124
       [<0020c91e>] zfcp_erp_adapter_strategy_generic+0x49e/0xb5c
       [<0020e37e>] zfcp_erp_strategy_do_action+0x44a/0x17c4
       [<0020ffe4>] zfcp_erp_thread+0x1a8/0x1274
       [<00018dfa>] kernel_thread_starter+0x6/0xc
       [<00018df4>] kernel_thread_starter+0x0/0xc

other info that might help us debug this:

2 locks held by zfcperp0.0.5207/165:
 #0:  (&adapter->req_list_lock){++..}, at: [<8021bec2>] zfcp_fsf_req_dismiss_all+0x2e/0x124
 #1:  (&zfcp_data.config_lock){..++}, at: [<802110dc>] zfcp_erp_port_forced_reopen+0x2c/0x68

stack backtrace:
048d1af0 00000000 0f8d1bb8 0f8d1b6c 00000000 00000000 00000000 00000000 
       00000002 00367cd6 00367cd6 8001504e 
Call Trace:
([<0000000000014f9c>] show_trace+0x70/0xb4)
 [<000000000001506c>] show_stack+0x8c/0xb0
 [<00000000000150b6>] dump_stack+0x26/0x30
 [<000000000004f0e0>] print_circular_bug_tail+0x8c/0x90
 [<00000000000516a4>] __lock_acquire+0x838/0x1018
 [<00000000000522e0>] lock_acquire+0x6c/0x94
 [<00000000002d819e>] _write_lock+0x46/0x58
 [<00000000002110ea>] zfcp_erp_port_forced_reopen+0x3a/0x68
 [<000000000021159e>] zfcp_erp_adisc_handler+0x1a6/0x258
 [<00000000002138ac>] zfcp_fsf_send_els_handler+0x140/0x548
 [<0000000000216afe>] zfcp_fsf_req_dispatch+0x1a6/0x1c44
 [<000000000021b266>] zfcp_fsf_req_complete+0xfa/0xd28
 [<000000000021bf6c>] zfcp_fsf_req_dismiss_all+0xd8/0x124
 [<000000000020c91e>] zfcp_erp_adapter_strategy_generic+0x49e/0xb5c
 [<000000000020e37e>] zfcp_erp_strategy_do_action+0x44a/0x17c4
 [<000000000020ffe4>] zfcp_erp_thread+0x1a8/0x1274
 [<0000000000018dfa>] kernel_thread_starter+0x6/0xc
 [<0000000000018df4>] kernel_thread_starter+0x0/0xc
