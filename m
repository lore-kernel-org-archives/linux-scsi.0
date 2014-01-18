From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCH v4 1/2] asynchronous ata port resume
Date: Fri, 17 Jan 2014 18:11:21 -0800
Message-ID: <CAA9_cmcf24-WT-DhGUy3SweXF=ZvtFD_pR5dNJkAMafceJkaPg@mail.gmail.com>
References: <20140116043853.GB27413@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f42.google.com ([209.85.128.42]:58414 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaARCLX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 21:11:23 -0500
In-Reply-To: <20140116043853.GB27413@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>

On Wed, Jan 15, 2014 at 8:38 PM, Todd E Brandt
<todd.e.brandt@linux.intel.com> wrote:
> On resume, the ATA port driver currently waits until the AHCI controller
> finishes executing the port wakeup command. This patch changes the
> ata_port_resume callback to issue the wakeup and then return immediately,
> thus allowing the next device in the pm queue to resume. Any commands
> issued to the AHCI hardware during the wakeup will be queued up and
> executed once the port is physically online. Thus no information is lost.
>
> This patch applies to all ata resume callbacks: resume, restore, and thaw for
> code simplicity. The primary benefit is to S3 resume.
>
> The return value from ata_resume_async is now an indicator of whether
> the resume was initiated, rather than if it was completed. I'm letting the ata
> driver assume control over its own error reporting in this case (which it does
> already). If you look at the ata_port resume code you'll see that the
> ata_port_resume callback returns the status of the ahci_port_resume callback,
> which is always 0. So I don't see any harm in ignoring it.
>
> If somebody requests suspend while ATA port resume is still running, the
> request is queued until the resume has completed. I've tested
> that case very heavily. Basically if you do two suspends in a row (within
> seconds of each other) you lose any performance benefit, but that's a use
> case that should happen only very rarerly (and wouldn't be expected to
> be of any power benefit since too many sequential suspends actually
> takes more power than just letting the machine stay in run mode).
>
> v4: Jan 15, 2014
>  [in response to Tejun Huo]
>  - completely removed the pm_result member of the ata_port struct
>  - result from ata_port_suspend/resume is now returned from the function
>    instead of into a pointer location
>  - ata_port_request_pm now only returns 0/-EAGAIN for pass/fail
>
> Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

You may want to split out the pure "do resume async" changes from the
return code and api cleanup.  Doubtful that anything depends on the
return code but at least gives a bisection point for each conceptual
change.
