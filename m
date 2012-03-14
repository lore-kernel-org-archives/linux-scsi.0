From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [isci PATCH v3 3/4] libsas: suspend / resume support
Date: Wed, 14 Mar 2012 13:44:11 -0700
Message-ID: <1331757853.17334.12.camel@ultramagnus.opencreations.com>
References: <Pine.LNX.4.44L0.1203141010470.1644-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1203141010470.1644-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-03-14 at 10:21 -0400, Alan Stern wrote:
> On Wed, 14 Mar 2012, Dan Williams wrote:
> 
> > libsas power management routines to suspend and recover the sas domain
> > based on a model where the lldd is allowed and expected to be
> > "forgetful".
> 
> What exactly does that mean?  What is there for the lldd to remember?  
> Does it maintain some sort of state information about the devices 
> attached to the links?

The lldd is responsible for reporting link-up events at power on.
Rather than require lldds to remember the state of the links across
suspend (and filter link-up messages for "suspended" links), this
implementation puts all the responsibility on libsas.  The goal being to
try to minimize the need for special case code in the lldd.  The lldd
simply redoes init and posts link-up events as normal.  Then at resume
time libsas reminds the lldd about the topology of devices that was
previously reachable via a given link.

> > sas_suspend_ha - disable event processing allowing the lldd to take down
> >                  links without concern for causing hotplug events.
> >                  Regardless of whether the lldd actually posts link down
> >                  messages libsas notifies the lldd that all
> >                  domain_devices are gone.
> > 
> > sas_prep_resume_ha - on the way back up before the lldd starts link
> >                      training clean out any spurious events that were
> >                      generated on the way down, and re-enable event
> >                      processing
> > 
> > sas_resume_ha - after the lldd has started and decided that all phys
> > 		have posted link-up events this routine is called to let
> > 		libsas start it's own timeout of any phys that did not
> > 		resume.  After the timeout an lldd can cancel the
> >                 phy teardown by posting a link-up event.
> > 
> > Storage for ex_change_count (u16) and phy_change_count (u8) are changed
> > to int so they can be set to -1 to indicate 'invalidated'.
> > 
> > There's a hack added to sas_destruct_devices to workaround a deadlock
> > when a device is removed across the suspend cycle.  sd_remove is called
> > under device_lock() and wants to async_synchronize_full(), while the
> > resume path is running in an async callback and is trying to grab
> > device_lock()... fun ensues.  So we guarantee that async resume actions
> > have been flushed before allowing new invocations of sd_remove.
> 
> Ooh, that doesn't sound like a good way to handle it.  For one thing, 
> it's possible for the resume routine to be called while the caller 
> holds the device-lock for the device being resumed.  It would be best 
> if the resume path defers removal of devices that have disappeared to a 
> different thread.

In fact, that's what the hack does (in Scsi_Host workqueue context), but
that's only part of the solution.  We also need to flush resume
operations otherwise we can trigger the following deadlock (that lockdep
can't catch thanks to lockdep_set_novalidate_class(&dev->mutex); and the
lack of lockdep annotation for async_sychronize_full()):

[  494.237079] INFO: task kworker/u:3:554 blocked for more than 120 seconds.
[  494.294396] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  494.360809] kworker/u:3     D 0000000000000000     0   554      2 0x00000000
[  494.420739]  ffff88012e4d3af0 0000000000000046 ffff88013200c160 ffff88012e4d3fd8
[  494.484392]  ffff88012e4d3fd8 0000000000012500 ffff8801394ea0b0 ffff88013200c160
[  494.548038]  ffff88012e4d3ae0 00000000000001e3 ffffffff81a249e0 ffff8801321c5398
[  494.611685] Call Trace:
[  494.632649]  [<ffffffff8149dd25>] schedule+0x5a/0x5c
[  494.674687]  [<ffffffff8104b968>] async_synchronize_cookie_domain+0xb6/0x112
[  494.734177]  [<ffffffff810461ff>] ? __init_waitqueue_head+0x50/0x50
[  494.787134]  [<ffffffff8131a224>] ? scsi_remove_target+0x48/0x48
[  494.837900]  [<ffffffff8104b9d9>] async_synchronize_cookie+0x15/0x17
[  494.891567]  [<ffffffff8104ba49>] async_synchronize_full+0x54/0x70  <-- here we wait for async contexts to complete
[  494.943783]  [<ffffffff8104b9f5>] ? async_synchronize_full_domain+0x1a/0x1a
[  495.002547]  [<ffffffffa00114b1>] sd_remove+0x2c/0xa2 [sd_mod]
[  495.051861]  [<ffffffff812fe94f>] __device_release_driver+0x86/0xcf
[  495.104807]  [<ffffffff812fe9bd>] device_release_driver+0x25/0x32  <-- here we take device_lock()

[  853.511341] INFO: task kworker/u:4:549 blocked for more than 120 seconds.
[  853.568693] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  853.635119] kworker/u:4     D ffff88013097b5d0     0   549      2 0x00000000
[  853.695129]  ffff880132773c40 0000000000000046 ffff880130790000 ffff880132773fd8
[  853.758990]  ffff880132773fd8 0000000000012500 ffff88013288a0b0 ffff880130790000
[  853.822796]  0000000000000246 0000000000000040 ffff88013097b5c8 ffff880130790000
[  853.886633] Call Trace:
[  853.907631]  [<ffffffff8149dd25>] schedule+0x5a/0x5c
[  853.949670]  [<ffffffff8149cc44>] __mutex_lock_common+0x220/0x351
[  854.001225]  [<ffffffff81304bd7>] ? device_resume+0x58/0x1c4
[  854.049082]  [<ffffffff81304bd7>] ? device_resume+0x58/0x1c4
[  854.097011]  [<ffffffff8149ce48>] mutex_lock_nested+0x2f/0x36   <-- here we wait for device_lock()
[  854.145591]  [<ffffffff81304bd7>] device_resume+0x58/0x1c4
[  854.192066]  [<ffffffff81304d61>] async_resume+0x1e/0x45
[  854.237019]  [<ffffffff8104bc93>] async_run_entry_fn+0xc6/0x173  <-- ...while running in async context

--
Dan

