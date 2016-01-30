From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Sat, 30 Jan 2016 07:46:20 +0000
Message-ID: <bug-111441-11613-gtiiCDNU9S@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52631 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbcA3HqY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jan 2016 02:46:24 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A51DB20382
	for <linux-scsi@vger.kernel.org>; Sat, 30 Jan 2016 07:46:23 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1231D2039E
	for <linux-scsi@vger.kernel.org>; Sat, 30 Jan 2016 07:46:21 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111441

--- Comment #8 from nab <nab@linux-iscsi.org> ---
On Fri, 2016-01-29 at 17:32 -0600, Mike Christie wrote:
> On 01/29/2016 04:21 PM, Serguei Bezverkhi (sbezverk) wrote:
> > HI Mike,
> > 
> > I tried your patch and it is has eliminated first traceback but I still do not see my remote targets.
> > 
> 
> That is sort of expected. Your target is not setup for ALUA properly. It
> says it supports ALUA, but when scsi_dh_alua asks about the ports it is
> reporting there are none. Ccing the people that made the patch that
> added the issue and own the code.
> 
> Hey Christoph and Hannes,
> 
> The dh/alua changes that added this:
> 
>         error = scsi_dh_add_device(sdev);
>         if (error) {
>                 sdev_printk(KERN_INFO, sdev,
>                                 "failed to add device handler: %d\n",
> error);
>                 return error;
>         }
> 
> to scsi_sysfs_add_sdev are adding a regression.
> 
> 1. If that fails, then we forget to do device_del before doing the
> return. My patch in this thread added that back, so we do not see the
> sysfs oopses anymore. But.....
> 
> 2. It looks like in older kernels, we would allow misconfigured targets
> like this one to still setup devices. Do we want that old behavior back?
> Should we just ignore the return value from scsi_dh_add_device above?
> Note that in this case, it is LIO so it can be easily fixed on the
> target side by just setting it up properly. I do not think other targets
> would hit this type of issue.
> 

Btw, what does misconfigured mean here wrt target ALUA..?

-- 
You are receiving this mail because:
You are the assignee for the bug.
