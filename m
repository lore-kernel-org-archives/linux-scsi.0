From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [isci PATCH v3 3/4] libsas: suspend / resume support
Date: Wed, 14 Mar 2012 17:11:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1203141654460.1644-100000@iolanthe.rowland.org>
References: <1331757853.17334.12.camel@ultramagnus.opencreations.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56625 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761261Ab2CNVLK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 17:11:10 -0400
In-Reply-To: <1331757853.17334.12.camel@ultramagnus.opencreations.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>

On Wed, 14 Mar 2012, Dan Williams wrote:

> > Ooh, that doesn't sound like a good way to handle it.  For one thing, 
> > it's possible for the resume routine to be called while the caller 
> > holds the device-lock for the device being resumed.  It would be best 
> > if the resume path defers removal of devices that have disappeared to a 
> > different thread.
> 
> In fact, that's what the hack does (in Scsi_Host workqueue context), but
> that's only part of the solution.  We also need to flush resume
> operations otherwise we can trigger the following deadlock (that lockdep
> can't catch thanks to lockdep_set_novalidate_class(&dev->mutex); and the
> lack of lockdep annotation for async_sychronize_full()):

Unfortunately, lockdep isn't able to track dev->mutex accesses 
usefully.  It would be nice if it could.

> [  494.611685] Call Trace:
> [  494.632649]  [<ffffffff8149dd25>] schedule+0x5a/0x5c
> [  494.674687]  [<ffffffff8104b968>] async_synchronize_cookie_domain+0xb6/0x112
> [  494.734177]  [<ffffffff810461ff>] ? __init_waitqueue_head+0x50/0x50
> [  494.787134]  [<ffffffff8131a224>] ? scsi_remove_target+0x48/0x48
> [  494.837900]  [<ffffffff8104b9d9>] async_synchronize_cookie+0x15/0x17
> [  494.891567]  [<ffffffff8104ba49>] async_synchronize_full+0x54/0x70  <-- here we wait for async contexts to complete
> [  494.943783]  [<ffffffff8104b9f5>] ? async_synchronize_full_domain+0x1a/0x1a
> [  495.002547]  [<ffffffffa00114b1>] sd_remove+0x2c/0xa2 [sd_mod]
> [  495.051861]  [<ffffffff812fe94f>] __device_release_driver+0x86/0xcf
> [  495.104807]  [<ffffffff812fe9bd>] device_release_driver+0x25/0x32  <-- here we take device_lock()

> [  853.886633] Call Trace:
> [  853.907631]  [<ffffffff8149dd25>] schedule+0x5a/0x5c
> [  853.949670]  [<ffffffff8149cc44>] __mutex_lock_common+0x220/0x351
> [  854.001225]  [<ffffffff81304bd7>] ? device_resume+0x58/0x1c4
> [  854.049082]  [<ffffffff81304bd7>] ? device_resume+0x58/0x1c4
> [  854.097011]  [<ffffffff8149ce48>] mutex_lock_nested+0x2f/0x36   <-- here we wait for device_lock()
> [  854.145591]  [<ffffffff81304bd7>] device_resume+0x58/0x1c4
> [  854.192066]  [<ffffffff81304d61>] async_resume+0x1e/0x45
> [  854.237019]  [<ffffffff8104bc93>] async_run_entry_fn+0xc6/0x173  <-- ...while running in async context

I see.  It's a nasty situation; I guess the best way to describe it is 
a conflict between the requirements of the PM and SCSI subsystems:

	The PM core runs suspend and resume operations in async 
	threads, and these threads need to acquire the device lock;

	The sd driver needs to insure that async probing is finished
	when starting its remove routine, and it is called with the
	device lock held.

The best solution might be to use a workqueue for sd's async probing 
instead of the "async" threads.  Then the work routine could be 
cancelled without doing async_synchronize_full().

Alan Stern

