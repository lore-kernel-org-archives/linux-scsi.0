From: Tejun Heo <tj@kernel.org>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 15:24:33 -0500
Message-ID: <20140117202433.GB23024@htj.dyndns.org>
References: <CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1401171513500.6173-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:53946 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaAQUYh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 15:24:37 -0500
Received: by mail-qc0-f169.google.com with SMTP id w7so4124358qcr.14
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2014 12:24:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401171513500.6173-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dan Williams <dan.j.williams@intel.com>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Jan 17, 2014 at 03:15:54PM -0500, Alan Stern wrote:
> You will have to argue this point with Phillip.
> 
> If necessary, we could add a sysfs attribute to force a spin-up during
> system resume.  Or you could disable runtime PM for the disk, but that
> has its own disadvantages.

Isn't immediate spin-up trivial to implement from anywhere?  I'm not
sure whether we'll end up defaulting to the lazy behavior or not but
if we do requiring userland to echo something to sysfs to configure
immediate spin-up feels a bit silly when userland might as well just
issue a dummy command to force spinup.

And, yes, I agree with Dan that avoiding spinup of harddrives on
system resume seems a bit niche in its usefulness.  suspend/resume
cycle at the very least generates logs which most likely will be
committed to the drive sooner or later.

What kind of use cases are we expecting for the lazy behavior?

Thanks.

-- 
tejun
