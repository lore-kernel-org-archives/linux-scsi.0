From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Suspending SCSI devices and buses
Date: Thu, 19 Aug 2004 17:05:55 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408191647170.2106-100000@ida.rowland.org>
References: <4123C0E4.6010906@optonline.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:54276 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S267398AbUHSVFz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 17:05:55 -0400
In-Reply-To: <4123C0E4.6010906@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 18 Aug 2004, Nathan Bryant wrote:

> Alan Stern wrote:
> > How does a host driver tell the SCSI core that an adapter is being 
> > suspended (and hence the core needs to suspend all the devices attached to 
> > that adapter)?  Ditto for resume.
> 
> For devices, this should be handled by the applicable scsi_driver - 
> sd.c, etc. I posted a patch for this to the mailing list a week or two 
> ago, check the list archives.
> 
> > 
> > There doesn't appear to be any way to do it.  The scsi_bus_type and 
> > various driver structures don't contain a "suspend" entry.
> 
> Correct, the midlayer doesn't quite support this yet, but my patch 
> should do the most important bits if somebody would be kind enough to 
> merge it... As a quick summary, first we need to quiesce the child 
> devices and synchronize their caches, then the LLD just needs to handle 
> flushing any remaining in-flight DMA transactions.

Thanks.  Looking at your patch, I have a question.  It doesn't look like
the resume path is careful to check for Unit Attention with Power On or
Medium May Have Changed sense.  What happens if somebody changes the
medium while the drive is suspended?  Or am I missing something?

Alan Stern

