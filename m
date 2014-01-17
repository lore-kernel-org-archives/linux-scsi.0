From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 11:31:51 -0800
Message-ID: <CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>
References: <20140116220409.GA1183@linux.intel.com>
	<Pine.LNX.4.44L0.1401170951270.1162-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39732 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaAQTbw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 14:31:52 -0500
Received: by mail-qa0-f42.google.com with SMTP id k4so3765117qaq.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2014 11:31:51 -0800 (PST)
In-Reply-To: <Pine.LNX.4.44L0.1401170951270.1162-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Todd E Brandt <todd.e.brandt@linux.intel.com>, Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Jan 17, 2014 at 6:57 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 16 Jan 2014, Todd E Brandt wrote:
>> My patch makes ata port and scsi disk resume 'non-blocking' (asynchronous
>> with respect to system resume). Which means once they're called the power
>> manager pays no more attention to them and will complete system resume
>> whenever. Both the power manager and the ata subsystems call these
>> features 'asynchronous' so it can be confusing.
>
> I see.  That's not explained very well in the patch description -- it
> talks about going on to resume the next device on the list, but not
> about waiting for the overall system resume to finish.
>

Once dpm_resume of the disk is asynchronous, is there much incremental
gain by further deferring spin up?  The drawback of doing on-demand
resume of the disk is that you incur the full resume latency right
when you need the data.  System resume is a strong hint to warm the
disks back up, and they will go back to sleep if unused.

Of course it reduces the power savings if dpm_suspend/resume is a
frequent occurrence.  However, are systems that make aggressive use of
system suspend shipping with rotating media, or do they ship with
disks that are cheap to resume?  If suspend is not frequent I wonder
if it is worth the trouble/latency cost to keep the disk(s) asleep.

--
Dan
