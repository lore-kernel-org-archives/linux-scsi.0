From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [Bugme-new] [Bug 7717] New: Tapes unreadable after unload
Date: Wed, 20 Dec 2006 22:41:17 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0612202228060.4873@kai.makisara.local>
References: <200612201031.kBKAVIJS005240@fire-2.osdl.org>
 <20061220025058.70d3d4ea.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kolumbus.fi ([193.229.0.46]:53691 "EHLO mail.kolumbus.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030358AbWLTVBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Dec 2006 16:01:40 -0500
In-Reply-To: <20061220025058.70d3d4ea.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, bgs@bgs.hu

On Wed, 20 Dec 2006, Andrew Morton wrote:

> 
> (please respond via emailed reply-to-all)
> 
> On Wed, 20 Dec 2006 02:31:18 -0800
> bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=7717
> > 
> >            Summary: Tapes unreadable after unload
> >     Kernel Version: tested 2.6.17 through 2.6.29 with various results
> 
> I assume that means 2.6.17 and 2.6.19 failed.
> 
> >             Status: NEW
> >           Severity: blocking
> >              Owner: io_scsi@kernel-bugs.osdl.org
> >          Submitter: bgs@bgs.hu
> > 
> > 
> > Most recent kernel where this bug did *NOT* occur: 2.6.19
> 
> And that means that 2.6.19 did not fail.
> 
> Please clarify.
> 
> > Distribution: Slackware/Fedora
> > Hardware Environment: HP 530, HP Dl380
> > Software Environment: tar, mtx
> > Problem Description: Doing a tar backup works well. Data is written and is
> > readable. Binary restore comparison is ok. After unload/load the tape produces
> > Input/output errors. The tape is unreadable with working kernels too. Any
> > attempt to restore data from faulty tapes were in vain until now. 
> > 
> > Steps to reproduce:
> > tar cvf /dev/st0 /path/to/something
> > mtx -f /dev/sg1 unload
> > mtx -f /dev/sg1 load X
> > tar tvf /dev/st0
> > 

I tried this with 2.6.19 and the tape was readable. Unfortunately I don't 
have any older kernels around to test. I have not heard about any problem 
like this.

Note that the data becomes unreadable after the tape is touched by mtx 
through sg device, i.e, bypassing st.

> > tar output:
> > tar: /dev/st0: Cannot read: Input/output error
> > tar: At beginning of tape, quitting now
> > tar: Error is not recoverable: exiting now
> > 
Do you find any messages with dmesg or in system log?

> > All read() attempts fail after 42 bytes. (I can attach those 42 bytes if they
> > are of any help).
> 
Interesting byte count :-)

-- 
Kai
