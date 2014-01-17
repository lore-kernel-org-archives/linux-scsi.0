From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 15:15:54 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401171513500.6173-100000@netrider.rowland.org>
References: <CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:50123 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753250AbaAQUPz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 15:15:55 -0500
In-Reply-To: <CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Todd E Brandt <todd.e.brandt@linux.intel.com>, Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 17 Jan 2014, Dan Williams wrote:

> Once dpm_resume of the disk is asynchronous, is there much incremental
> gain by further deferring spin up?  The drawback of doing on-demand
> resume of the disk is that you incur the full resume latency right
> when you need the data.  System resume is a strong hint to warm the
> disks back up, and they will go back to sleep if unused.
> 
> Of course it reduces the power savings if dpm_suspend/resume is a
> frequent occurrence.  However, are systems that make aggressive use of
> system suspend shipping with rotating media, or do they ship with
> disks that are cheap to resume?  If suspend is not frequent I wonder
> if it is worth the trouble/latency cost to keep the disk(s) asleep.

You will have to argue this point with Phillip.

If necessary, we could add a sysfs attribute to force a spin-up during
system resume.  Or you could disable runtime PM for the disk, but that
has its own disadvantages.

Alan Stern

