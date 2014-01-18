From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 18:15:10 -0800
Message-ID: <CAPcyv4hy_SXusbN04W-crhGNYcfBGhiP2iZTRuyRqTF8Rb4HFQ@mail.gmail.com>
References: <20140117202433.GB23024@htj.dyndns.org>
	<Pine.LNX.4.44L0.1401172034180.945-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:60065 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaARCPL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 21:15:11 -0500
Received: by mail-vc0-f176.google.com with SMTP id la4so1870570vcb.21
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2014 18:15:10 -0800 (PST)
In-Reply-To: <Pine.LNX.4.44L0.1401172034180.945-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Jan 17, 2014 at 5:41 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 17 Jan 2014, Tejun Heo wrote:
>
>> On Fri, Jan 17, 2014 at 03:15:54PM -0500, Alan Stern wrote:
>> > You will have to argue this point with Phillip.
>> >
>> > If necessary, we could add a sysfs attribute to force a spin-up during
>> > system resume.  Or you could disable runtime PM for the disk, but that
>> > has its own disadvantages.
>>
>> Isn't immediate spin-up trivial to implement from anywhere?  I'm not
>> sure whether we'll end up defaulting to the lazy behavior or not but
>> if we do requiring userland to echo something to sysfs to configure
>> immediate spin-up feels a bit silly when userland might as well just
>> issue a dummy command to force spinup.
>
> Then turn it around.  Make the new sysfs attribute enable a lazy
> resume.
>
>> And, yes, I agree with Dan that avoiding spinup of harddrives on
>> system resume seems a bit niche in its usefulness.  suspend/resume
>> cycle at the very least generates logs which most likely will be
>> committed to the drive sooner or later.
>>
>> What kind of use cases are we expecting for the lazy behavior?
>
> The intention is that this will help on systems with more than one
> disk drive.  The one containing the core OS files and the journal will
> certainly spin up right away, but the others may not.
>
> To tell the truth, I'm not sure how useful this feature would be to
> most people.  But there probably are a few, like Phillip, who will be
> glad to have it.  That seems like sufficient justification for adding
> it.
>

Hmm, given that an ATA "start" command is just a "read verify" I
wonder if this can be done more simply than tying runtime and system
resume together.  Could the lazy resume knob simply cause sd_resume to
be skipped?  The first real command that comes down will achieve the
same effect.
