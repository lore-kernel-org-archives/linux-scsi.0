From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 64171] Block SCSI Generic Driver does not keep data
Date: Fri, 15 Nov 2013 08:42:06 -0800
Message-ID: <1384533726.2003.10.camel@dabdike.int.hansenpartnership.com>
References: <bug-64171-11613@https.bugzilla.kernel.org/>
	 <bug-64171-11613-moT5WALEj8@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49451 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab3KOQmK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Nov 2013 11:42:10 -0500
In-Reply-To: <bug-64171-11613-moT5WALEj8@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Sat, 2013-11-02 at 17:09 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=64171
> 
> --- Comment #2 from d gilbert <dgilbert@interlog.com> ---
> On 13-11-01 03:49 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=64171
> >
> >              Bug ID: 64171
> >             Summary: Block SCSI Generic Driver does not keep data
> >             Product: SCSI Drivers
> >             Version: 2.5
> >      Kernel Version: 2.6.32.61
> >            Hardware: All
> >                  OS: Linux
> >                Tree: Mainline
> >              Status: NEW
> >            Severity: high
> >            Priority: P1
> >           Component: Other
> >            Assignee: scsi_drivers-other@kernel-bugs.osdl.org
> >            Reporter: af300wsm@gmail.com
> >          Regression: No
> >
> > Data written to any given file descriptor should be unique to that descriptor
> > and processor space.  Currently, the BSG Driver does not keep this uniqueness.
> > As the attached simple program demonstrates, a SCSI Command queued to the
> > device in one process is dequeued by another process which has opened a handle
> > to the same device.
> >
> > The attached file sends the simple SCSI "Test Unit Ready" command from the SCSI
> > Primary Command Spec. to the device using the BSG driver.  As the program
> > demonstrates, the sg_io_v4.usr_ptr field, which is set in the "push" branch of
> > the program, is dequeued from the "pop" branch of the code.
> >
> > I also tested this behavior on Fedora 19 and the bug exists there as well.  F19
> > uses kernel 3.9.5.
> >
> > Compile the attachment:
> > g++ -o <out> combined.cpp
> >
> >
> > Execute as follows:
> > sudo combined pop /dev/bsg/0:0:0:0 &
> > sudo combined push /dev/bsg/0:0:0:0
> 
> I ran this test on lk 3.11.6 and it also exhibits this
> problem.
> 
> When the bsg driver was originally designed, if my memory is
> correct, it did not have an asynchronous interface, so it
> skipped the complexity of keeping a separate context for
> each file handle within each device.
> 
> With the addition of the asynchronous interface, the lack of
> file handle context is exposed by your simple test. I'm
> pretty sure that parallel test programs could show that
> synchronous SG_IO ioctls can also be tricked. For example:
> send INQUIRYs continuously from one process, TURs from
> another process to the same device. Then, once in a while,
> I guess that they would pick up the other one's response.

OK, so why do you both think this is a bug not a feature?  The
read/write interface isn't completion order safe, it was introduced
for /dev/sg compatibility and somehow got carried forwards when it
should have been deprecated.  The ioctl interface is, so just use the
latter.  If you can find a test case where the ioctl interface has the
same problem, then I'll treat it as a bug.

James


