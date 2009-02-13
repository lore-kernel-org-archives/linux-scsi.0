From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: next Feb 13 drivers/scsi/aha1542.ko build break
Date: Fri, 13 Feb 2009 19:34:44 +0000
Message-ID: <20090213193444.GL28946@ZenIV.linux.org.uk>
References: <20090213175526.d0590862.sfr@canb.auug.org.au> <49955D00.2020707@in.ibm.com> <4995BA4B.9050209@oracle.com> <4995C66E.1000800@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4995C66E.1000800@cisco.com>
Sender: linux-next-owner@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Sachin P. Sant" <sachinp@in.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 13, 2009 at 11:13:50AM -0800, Joe Eykholt wrote:

> > I'm seeing that also.  I think that it's this line in aha1542.c:
> > 
> > 495:		mbo = (scsi2int(mb[mbi].ccbptr) - (SCSI_BUF_PA(&ccb[0]))) / sizeof(struct ccb);
> > 
> > since I can comment out the "/ sizeof(struct ccb)" and the driver builds successfully.
> > 
> > This may need a patch to use one of the div() macros (?).
> 
> In the above case, this problem might not occur if sizeof(struct ccb) happened to
> be a power of 2, since the compiler generates a shift in that case.
> Then later someone could increase the size of the struct and introduce this problem.

The real problem, of course, is that we should _not_ be doing 64bit-division
here, be it by shifts or by __udiv...; if anything, we ought to store the
bus version of HOSTDATA(...)->ccb at the time we'd checked that allocation
got us a small enough address (i.e. after scsi_register()).  And store it
in u32.
