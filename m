From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
	of staging
Date: Sun, 16 Oct 2011 03:01:23 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA0FED0@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1318660132-21529-1-git-send-email-kys@microsoft.com>
	<1318714047.7271.49.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <1318714047.7271.49.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: devel-bounces@linuxdriverproject.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>, "ohering@suse.com" <ohering@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Saturday, October 15, 2011 5:27 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> linux-scsi@vger.kernel.org; hch@infradead.org; Haiyang Zhang
> Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
> staging
> 
> On Fri, 2011-10-14 at 23:28 -0700, K. Y. Srinivasan wrote:
> > In preparation for moving the storage driver out of staging, seek community
> > review of the storage  driver code.
> 
> That's not exactly a very descriptive commit message for me to put into
> SCSI.  It doesn't have to be huge, just something like "driver to enable
> hyperv windows guest on Linux" or something.

Sorry about the commit message. I will have a more descriptive message in the next
submission.

> 
> 
> >  drivers/scsi/Kconfig             |    7 +
> >  drivers/scsi/Makefile            |    3 +
> >  drivers/scsi/storvsc_drv.c       | 1480
> ++++++++++++++++++++++++++++++++++++++
> >  drivers/staging/hv/Kconfig       |    6 -
> >  drivers/staging/hv/Makefile      |    2 -
> >  drivers/staging/hv/storvsc_drv.c | 1480 --------------------------------------
> >  6 files changed, 1490 insertions(+), 1488 deletions(-)
> 
> What tree is this against?  The hv/storvsc_drv.c in upstream only has
> 
> jejb@dabdike> wc -l drivers/staging/hv/storvsc_drv.c
> 792 drivers/staging/hv/storvsc_drv.c
> 
> i.e. whatever you're sending is double the length (and obviously I have
> trouble applying the patch.

This patch  moves the file from drivers/staging/hv/ directory to the 
drivers/scsi directory; hence double the length. I saw an email from Greg earlier where
he recommended that the patch we post should not delete/modify the files in the hv
directory. When I submit this next, I will take that approach.
 
> 
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -0,0 +1,1480 @@
> 
> So not a detailed review, but a couple of structural observations:
> 
> The whole driver is a writeout deadlock trap since I assume you intend
> for it to be used as root/swap of a linux guest?  The writeout deadlock
> occurs when we can't make forward progress on a direct writeout I/O
> because one of the GFP_ATOMIC memory allocations in your driver fails.
> The only way to fix this is to back the allocations with mempools (one
> per actual device) so you can guarantee that whatever memory pressure
> the system is under, one command can always make the round trip to
> storage and back.

I will implement a mempool based allocation scheme as you have suggested.

> 
> You use the locked version of queuecommand, but it looks like you don't
> need the host lock in the submit path, so why not just use the unlocked
> version?

Will do.
> 
> The bounce buffer handling for discontiguous sg lists is a complete
> nightmare.  And can't you just fix the hypervisor instead of pulling
> this level of nastiness in the driver, I mean really, the last piece of
> real SCSI hardware that failed this badly was produced in the dark ages.

The restrictions (as they are) are really from the windows host side and for what it is 
worth, I have never seen this code triggered at least for I/O initiated by the file system. 

 
> Assuming the answer is "no", I really think you need to set the minimum
> block size to 4k, which will completely avoid the situation.

I would love to get rid of the bounce buffer handling code by ensuring that the 
upper level code would never present scatter gather lists that would trigger bounce buffer
handling code. How would I accomplish that. 
 
> 
> Minor, but use accessors like shost_priv()

Will do.

> 
> The SET WINDOW command is an obsolete scanner command ... the comment
> about smart issuing it looks completely bogus, but even if there's
> something issuing scanner commands and your hypervisor crashes on them,
> you need to reject it with ILLEGAL_REQUEST not DID_ERROR.

Will do.

> 
> All the business around max segment size and supplying your own merge
> biovec function looks a bit bogus, don't you just want to disable
> clustering?  This looks like another knock on from the weird hypervisor
> sg list handling, where you apparently need one sg entry per page.  This
> was originally a bug in the circa 1990 era NCR 53c800 host controllers
> we then had, so that's actually why the clustering parameter exists ...
> it's sort of nostalgic to see you resurrecting such an ancient bug.

I will try to clean this up. Would you want all the cleanup you have suggested here
done before the code can be moved out of staging or could you take the code and I could 
give you the patches to address the issues listed by you. Once again, thanks for taking the time 
to look at this code.

Regards,

K. Y
