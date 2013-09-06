From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: [PATCH/RESEND 2/2] Hard disk S3 resume time optimization
Date: Fri, 6 Sep 2013 15:11:53 -0700
Message-ID: <20130906221152.GA7205@linux.intel.com>
References: <20130906004425.GA31998@linux.intel.com>
 <1378480234.2063.16.camel@dabdike.int.hansenpartnership.com>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:41447 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3IFWLu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Sep 2013 18:11:50 -0400
Content-Disposition: inline
In-Reply-To: <1378480234.2063.16.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

Sorry for the missing description, I've submitted it several times so I
just assumed that the previous entries in the thread were enough. I'll
resubmit with a full description.

As for replacing sd_resume altogether, the reason I didn't is because
there are three callbacks which use sd_resume. I've only tested this
functionality for the system resume call, not restore or runtime_resume,
and I didn't know if the other two made sense as asynchronous since
it doesn't really buy anything in runtime_resume, but I understand your
point that it adds unnecessary complexity. I'll fix it.

I'm sure there are no issues but I'll be sure and test all the new scenerios 
before I resubmit.

So, with fixes to those two issues, do you think this technique is something 
you'd accept? I've tried it two different ways, one where I changed the pm
code to allow nonblocking resume callbacks, which just finalized system 
resume without waiting for the ata and scsi drivers to finish. But that 
didn't fly well with Rafael as it violates some implicit assumptions 
about how the callbacks function. I worked with Rafael to come up with a 
"skip_resume" version which just skipped the system resume of the disks, 
changed them to runtime suspended, and let them runtime resume whenever 
they were accessed, but it proved to be impractical in a real OS environment 
because the OS tends to access everything at once when it comes back online.

This approach is really the only remaining way (that I can think of) to 
remove the ata-port wakeup delay in software, so given the massive 
performance benefit I hope you'll consider it. Thanks for the reply!

On Fri, Sep 06, 2013 at 08:10:34AM -0700, James Bottomley wrote:
> On Thu, 2013-09-05 at 17:44 -0700, Todd E Brandt wrote:
> > Part 2 of the hard disk resume optimization patch, this one applies
> > to the scsi subsystem.
> 
> This is a horrible patch description, it won't tell the next reader
> anything about what is going on and why.  Give the patches two separate
> summaries and refer back by summary explaining what this one does.
> 
> Also, having two code paths do the same thing is always a bad idea:
> someone will update one and not the other.  sd_resume() should be come
> sd_resume_async(); wait for async event
> 
> James
> 
> 
