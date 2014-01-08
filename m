From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Wed, 08 Jan 2014 15:00:05 +0800
Message-ID: <52CCF775.3010303@intel.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <1387236657-4852-1-git-send-email-psusi@ubuntu.com> <52CA1191.8060804@ubuntu.com> <52CA5CF4.2080708@codeaurora.org> <52CA744F.2080609@intel.com> <52CAC067.20601@ubuntu.com> <52CBB188.2080707@intel.com> <52CC1422.1020101@ubuntu.com> <52CCA3CF.5050308@intel.com> <52CCA6E3.2090400@ubuntu.com> <52CCAAA7.4070104@intel.com> <52CCAF8C.7040407@ubuntu.com> <52CCB3E8.5010101@intel.com> <52CCB5C4.7020206@ubuntu.com> <52CCB99A.4090201@intel.com> <52CCE11A.3040609@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6343 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaAHG7v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jan 2014 01:59:51 -0500
In-Reply-To: <52CCE11A.3040609@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>

On 01/08/2014 01:24 PM, Phillip Susi wrote:
> On 01/07/2014 09:36 PM, Aaron Lu wrote:
>> Oh, of course, my stupid :-) Then I suddenly think my patches can
>> kind of work - let's say we have done the hdparm setting thing
>> before suspend and the disk will be spun up in standby mode next
>> time it is powered. Then during system resume phase, remove the
>> pm_request_resume call in both SCSI and ATA's system resume
>> callback, - if the disk is powered, it will be in standby mode and
>> its runtime status is RPM_SUSPENDED, match its real status(sort
>> of); - if the disk is not powered due to some host feature or
>> whatever, it will be in unpowered mode and its runtime status is
>> RPM_SUSPENDED, still match its real status.
> 
> Right, but if the disk is a run of the mill ATA disk not configured
> for power up in standby, then you end up with runtime pm saying that
> it is suspended, when in fact, it spun up on its own and is sitting
> there waiting for commands.
> 
> The PuiS setting isn't something we can or want to twiggle on our own
> during suspend, that's an admin decision that they set more or less
> permanently either with hdparm or the hardware jumper.  We just need

OK, I see.

> to detect what the drive has done and update the runtime pm status to
> match.

Then I would say we just keep the pm_request_resume call in their system
resume callback. For drives that have that cool feature turned on, it
will be in runtime active state while it's actually in standby mode, not
a big deal since it should go to runtime suspended state once the
autosuspend timer is due(the runtime PM core will schedule an idle call
for newly resumed device); For drives that don't have that feature turned
on, it will be in runtime active state while it's actually spun up, no
problem here.

For the PuiS set drive, there is a time window the drive's power mode
doesn't agree with its runtime status, the window is the length of the
autosuspend time interval. Not a big deal I suppose, considering that
time interval isn't eternal? And I wouldn't say the runtime status for
the drive is wrong even in this case, since the runtime status is a
reflection of whether the device is in use or not from kernel's view,
instead of whether it is in a low power mode. But I agree we better
align them.
