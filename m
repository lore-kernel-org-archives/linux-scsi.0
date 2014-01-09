From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Thu, 09 Jan 2014 14:18:35 +0100
Message-ID: <1516302.TLKdDXZteT@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1401081547490.1659-100000@iolanthe.rowland.org> <52CDFB97.9080303@intel.com> <1800854.f96ZTXrYof@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1800854.f96ZTXrYof@vostro.rjw.lan>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Phillip Susi <psusi@ubuntu.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thursday, January 09, 2014 01:17:12 PM Rafael J. Wysocki wrote:
> On Thursday, January 09, 2014 09:29:59 AM Aaron Lu wrote:
> > On 01/09/2014 05:21 AM, Alan Stern wrote:
> > > On Wed, 8 Jan 2014, Phillip Susi wrote:
> > >> You issue a REQUEST SENSE command and that returns status indicating
> > >> whether the drive is stopped, or in standby.  See my patches.  One of
> > > 
> > > I never saw your patches.  Where were they posted?
> > > 
> > > If you issue the REQUEST SENSE command in the usual way (going through
> > > the SCSI and block layers), and the disk is already in runtime suspend,
> > > it won't do what you want.  The block layer won't deliver requests
> > > until the device leaves the RPM_SUSPENDED state.  In addition, when it
> > > receives the command the block layer will submit a deferred
> > > runtime-resume request, which rather defeats the whole purpose.
> > > 
> > > (I guess you actually saw some of this happen, and that's what led to
> > > this email thread in the first place.)
> > > 
> > > It's a knotty situation.  The only way to find out whether the disk is
> > > spinning is to ask it, which requires doing I/O, which requires
> > > spinning up the disk.  Maybe we need to add a mechanism to the block
> > > layer's runtime PM implementation for addressing just this situation.
> > 
> > I think it's knotty because the runtime PM status is a view from the
> > kernel/host side, i.e. it is runtime suspended if it is not being used,
> > no matter which power state it is in. The trigger for the PM state
> > transition are all based on this, if we want to do it the other way
> > around(update device's runtime PM status based on device's actual power
> > state), we are in a knotty situation.
> 
> Agreed.

That said during system resume, when we are trying to avoid resuming the
device to save time/energy, it makes sense to check its physical state and
do a pm_request_resume() if that is "on" to avoid a situation in which the
device is physically "on", but its runtime PM status is "suspended" and it
never gets powered down because of that.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
