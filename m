From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Sat, 16 Nov 2013 10:20:31 -0800
Message-ID: <1384626031.3614.7.camel@dabdike.int.hansenpartnership.com>
References: <527AF287.7020700@ubuntu.com>
	 <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>
	 <527BDA11.6060603@interlog.com> <527C0349.5010301@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <527C0349.5010301@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: dgilbert@interlog.com, todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-11-07 at 16:16 -0500, Phillip Susi wrote:
> On 11/7/2013 1:21 PM, Douglas Gilbert wrote:
> > On 13-11-06 08:57 PM, Phillip Susi wrote:
> >> Don't bother forcing disks to spin up on resume, as they will do
> >> so automatically when accessed, and forcing them to spin up slows
> >> down the resume.  Add a second bit to the manage_start_stop flag
> >> to restore the previous behavior.
> > 
> > SCSI disks when in STOP state do not spin up "automatically when
> > accessed".
> 
> The drive does not, but the scsi error handling notices when a command
> fails because the drive needs started, starts it, and retries the command.

No disk does, neither SCSI nor ATA.  The error handler is not
automatically activated for a not ready/initializing command required
because of multi-path.  We override the default behaviour via
allow_restart only for IBM vfc/vscsi and ATA disks.  With this patch
SCSI devices would no longer ever restart after suspend.

> > And your choice of bits looks like it will favour fixing broken
> > SATA behaviour but as a by-product break working SCSI disk
> > behaviour.
> 
> No, it has nothing to do with sata behavior; it has to do with whether
> or not all disk drives should be restarted immediately after a resume,
> or only when they are accessed.  I happen to have a few older drives
> that I very rarely access and would rather they not start up every
> time I resume.

As Doug said, if you don't restart a SCSI device after resume, it will
never get started.

James


