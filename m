From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: question about sd_sync_cache and shutdown
Date: Wed, 12 Jul 2006 11:41:29 -0500
Message-ID: <44B52639.4040609@cs.wisc.edu>
References: <44B44909.1000703@cs.wisc.edu> <44B5227C.5080707@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:5767 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751456AbWGLQl3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 12:41:29 -0400
In-Reply-To: <44B5227C.5080707@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: open-iscsi@googlegroups.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Stefan Richter wrote:
> Mike Christie wrote:
> [...]
>> for a orderly removal of some object, like someone shutting down
>> a iscsi session, we are going to hit that path, but the command will not
>> get sent. However, for unorderly removal, like ripping out a usb device
>> or FC rport or iSCSI session being removed due to dev_loss_tmp expiring
>> then we do not want the command sent. So it seems like it may be
>> intended behavior.
> 
> Certainly depends on how the SCSI mid-low API is used. I only know how
> sbp2 does it. It calls scsi_remove_device on soft shutdown as well as on
> hot unplug. (Earlier it only called scsi_remove_host which calls
> scsi_remove_device.) The last time I checked (2.6.16), this *always*
> called SCSI high-level's shutdown methods, particularly sd_sync_cache.

The ULD's shutdown methods always gets called but for some time the
shutdown function will prematurely fail out when called from
scsi_remove_host or from scsi_remove_device. This includes 2.6.16 from
what I can tell.

If the ULD's shutdown function is called during system shutdown when all
the other shutdown routines are called the sdev state is online and so
the sync cache will be sent. If you call scsi_remove_device manually or
through scsi_remove_host the sdev state will be in the cancel state and
so the command will not get sent.

> sbp2 sends that command in the soft shutdown case but completes it with
> DID_NO_CONNECT in the hot unplug case, like any other commands.
> 
> I don't know which states an "sdev" and "shost" is exactly put through,
> and luckily I never needed to know so far. Sbp2 does not use
> scsi_device_set_state.

Neither does iscsi or FC or any other transport or driver.

 It also does not deal with "starget" or any
> transport sidekick.

It is not a result of dealing with the target or any transport device.
The problem is in scsi_remove_device and its uses of
scsi_device_set_state and sd.c's shutdown function use of
scsi_device_get which checks the state.
