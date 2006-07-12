From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: question about sd_sync_cache and shutdown
Date: Wed, 12 Jul 2006 18:25:32 +0200
Message-ID: <44B5227C.5080707@s5r6.in-berlin.de>
References: <44B44909.1000703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:14028 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1750997AbWGLQ2e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 12:28:34 -0400
In-Reply-To: <44B44909.1000703@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
[...]
> for a orderly removal of some object, like someone shutting down
> a iscsi session, we are going to hit that path, but the command will not
> get sent. However, for unorderly removal, like ripping out a usb device
> or FC rport or iSCSI session being removed due to dev_loss_tmp expiring
> then we do not want the command sent. So it seems like it may be
> intended behavior.

Certainly depends on how the SCSI mid-low API is used. I only know how
sbp2 does it. It calls scsi_remove_device on soft shutdown as well as on
hot unplug. (Earlier it only called scsi_remove_host which calls
scsi_remove_device.) The last time I checked (2.6.16), this *always*
called SCSI high-level's shutdown methods, particularly sd_sync_cache.
sbp2 sends that command in the soft shutdown case but completes it with
DID_NO_CONNECT in the hot unplug case, like any other commands.

I don't know which states an "sdev" and "shost" is exactly put through,
and luckily I never needed to know so far. Sbp2 does not use
scsi_device_set_state. It also does not deal with "starget" or any
transport sidekick.
-- 
Stefan Richter
-=====-=-==- -=== -==--
http://arcgraph.de/sr/
