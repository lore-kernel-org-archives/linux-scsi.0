From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of staging
Date: Mon, 17 Oct 2011 08:59:36 -0500
Message-ID: <1318859976.4794.8.camel@dabdike.int.hansenpartnership.com>
References: <1318660132-21529-1-git-send-email-kys@microsoft.com>
	 <1318714047.7271.49.camel@dabdike.int.hansenpartnership.com>
	 <6E21E5352C11B742B20C142EB499E0481AA0FED0@TK5EX14MBXC128.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA0FED0@TK5EX14MBXC128.redmond.corp.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-10-16 at 03:01 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> > Sent: Saturday, October 15, 2011 5:27 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> > linux-scsi@vger.kernel.org; hch@infradead.org; Haiyang Zhang
> > Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
> > staging
> > 
> > On Fri, 2011-10-14 at 23:28 -0700, K. Y. Srinivasan wrote:
> > > In preparation for moving the storage driver out of staging, seek community
> > > review of the storage  driver code.
> > 
> > That's not exactly a very descriptive commit message for me to put into
> > SCSI.  It doesn't have to be huge, just something like "driver to enable
> > hyperv windows guest on Linux" or something.
> 
> Sorry about the commit message. I will have a more descriptive message in the next
> submission.
> 
> > 
> > 
> > >  drivers/scsi/Kconfig             |    7 +
> > >  drivers/scsi/Makefile            |    3 +
> > >  drivers/scsi/storvsc_drv.c       | 1480
> > ++++++++++++++++++++++++++++++++++++++
> > >  drivers/staging/hv/Kconfig       |    6 -
> > >  drivers/staging/hv/Makefile      |    2 -
> > >  drivers/staging/hv/storvsc_drv.c | 1480 --------------------------------------
> > >  6 files changed, 1490 insertions(+), 1488 deletions(-)
> > 
> > What tree is this against?  The hv/storvsc_drv.c in upstream only has
> > 
> > jejb@dabdike> wc -l drivers/staging/hv/storvsc_drv.c
> > 792 drivers/staging/hv/storvsc_drv.c
> > 
> > i.e. whatever you're sending is double the length (and obviously I have
> > trouble applying the patch.
> 
> This patch  moves the file from drivers/staging/hv/ directory to the 
> drivers/scsi directory; hence double the length.

No, that's not it.  Look again: the storvsc_drv.c in staging is removing
1480 lines, but in git head, this file is only 792 lines long ... is
there an alternative tree with the rest in?

The point I'm making is that the staging file you're modifying isn't the
one I see in Linus' git head, so which git tree is it in (I assume it's
somewhere waiting for the merge window)?

[...]
> > The bounce buffer handling for discontiguous sg lists is a complete
> > nightmare.  And can't you just fix the hypervisor instead of pulling
> > this level of nastiness in the driver, I mean really, the last piece of
> > real SCSI hardware that failed this badly was produced in the dark ages.
> 
> The restrictions (as they are) are really from the windows host side
> and for what it is 
> worth, I have never seen this code triggered at least for I/O
> initiated by the file system. 
> 
>  
> > Assuming the answer is "no", I really think you need to set the minimum
> > block size to 4k, which will completely avoid the situation.
> 
> I would love to get rid of the bounce buffer handling code by ensuring
> that the 
> upper level code would never present scatter gather lists that would
> trigger bounce buffer
> handling code. How would I accomplish that. 

OK, so as I read the code, what it can't handle is fragments except at
the ends.  As long as everything always transfers in multiples of 4k,
the problem will never occur.  This means that all devices you present
need to tell the OS they have 4k sectors.  I *think* you can do this by
setting  blk_limits_io_min() in the driver ... but you'll have to test
this.  The minimum sector size gets set also in sd.c when we probe the
disk.  I think that won't override blk_limits_io_min(), but please test
(we don't have any SCSI drivers which have ever used this setting).

The way to test, is to read back the /sys/block/<dev>/queue/ settings
when presenting a 512 byte sector disk.  (And the way to activate your
bounce code would be to create a filesystem with a < PAGE_SIZE block
size).

James
