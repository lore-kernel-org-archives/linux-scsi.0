From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 21:33:09 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401172131590.12758-100000@netrider.rowland.org>
References: <CAPcyv4hy_SXusbN04W-crhGNYcfBGhiP2iZTRuyRqTF8Rb4HFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:37177 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752158AbaARCdK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 21:33:10 -0500
In-Reply-To: <CAPcyv4hy_SXusbN04W-crhGNYcfBGhiP2iZTRuyRqTF8Rb4HFQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Todd E Brandt <todd.e.brandt@linux.intel.com>, Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 17 Jan 2014, Dan Williams wrote:

> > The intention is that this will help on systems with more than one
> > disk drive.  The one containing the core OS files and the journal will
> > certainly spin up right away, but the others may not.
> >
> > To tell the truth, I'm not sure how useful this feature would be to
> > most people.  But there probably are a few, like Phillip, who will be
> > glad to have it.  That seems like sufficient justification for adding
> > it.
> >
> 
> Hmm, given that an ATA "start" command is just a "read verify" I
> wonder if this can be done more simply than tying runtime and system
> resume together.  Could the lazy resume knob simply cause sd_resume to
> be skipped?  The first real command that comes down will achieve the
> same effect.

That might work for ATA disks, but it wouldn't work for other sorts.  
SCSI disks need to be spun up explicitly before they get a READ 
command.

Alan Stern

