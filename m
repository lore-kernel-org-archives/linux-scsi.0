From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH v2 0/8] [SCSI] Enhanced sense and Unit Attention
 handling
Date: Mon, 15 Apr 2013 12:51:01 -0400
Message-ID: <1366044661.30762.26.camel@localhost.localdomain>
References: <1359741195-2641-1-git-send-email-emilne@redhat.com>
	 <516730A1.4090302@tributary.com>
	 <1366035182.30762.14.camel@localhost.localdomain>
	 <516C28DB.2090809@tributary.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab3DOQvF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Apr 2013 12:51:05 -0400
In-Reply-To: <516C28DB.2090809@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Linux Scsi <linux-scsi@vger.kernel.org>

On Mon, 2013-04-15 at 11:20 -0500, Jeremy Linton wrote:
> On 4/15/2013 9:13 AM, Ewan Milne wrote:
> 
> >> patch could attempt to clear the check conditions from LUNs that share
> >> the I_T.
> > 
> > I think the mid-layer will handle that automatically.  If check conditions
> > are reported the commands will have to be reissued.
> 
> 	But, not automatically (unless i'm missing something again). The UA is going to
> arrive when each lun gets sent a command, which could be a long time from the
> initial UA if the lun is idle. Enough time, that the attempts to coalesce the
> events are going to fail.

Yes, although we can't put off rescanning for too long, or the system
won't react in a timely manner to a storage configuration change.  I
used 2 seconds which was a compromise to avoid overloading udev.  If
the UAs are received too far apart in time, then more than one event
will be generated.

Note, if multipath is in use, multipathd will periodically (every 15
seconds, I think) send commands to all the paths, so the UAs will be
detected at that point.

> 
> 	I guess it depends on what you have udev doing when it gets the event. If it
> triggers a rescan involving something besides inquiry/report luns then that will
> trigger the remaining UA's from the luns on the target that changed. But if it
> does something other than that, I don't see it by reading the
> patch/scsi_scan.c code.

What I did in my testing was have a udev rule that performed a rescan.
I believe sd_revalidate_disk() ends up being called, which will perform
several commands (MODE SENSE, READ CAPACITY, etc.), for disk devices.

-Ewan



