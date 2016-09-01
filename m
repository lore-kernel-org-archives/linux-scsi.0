From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v5 4/8] char: rpmb: provide a user space interface
Date: Thu, 1 Sep 2016 22:46:33 +0200
Message-ID: <20160901204633.GB5960@kroah.com>
References: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
 <1468873673-21776-5-git-send-email-tomas.winkler@intel.com>
 <20160805200823.GB7999@amd>
 <5B8DA87D05A7694D9FA63FD143655C1B542B8AC9@hasmsx108.ger.corp.intel.com>
 <20160831104955.GA10180@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542C5B6F@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542C5B6F@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 01, 2016 at 08:05:26PM +0000, Winkler, Tomas wrote:
> 
> > 
> > On Sun, Aug 07, 2016 at 09:44:03AM +0000, Winkler, Tomas wrote:
> > > >
> > > > On Mon 2016-07-18 23:27:49, Tomas Winkler wrote:
> > > > > The user space API is achieved via two synchronous IOCTL.
> > > >
> > > > IOCTLs?
> > >
> > > Will fix
> > >
> > > > > Simplified one, RPMB_IOC_REQ_CMD, were read result cycles is
> > > > performed
> > > > > by the framework on behalf the user and second, RPMB_IOC_SEQ_CMD
> > > > where
> > > > > the whole RPMB sequence including RESULT_READ is supplied by the
> > caller.
> > > > > The latter is intended for  easier adjusting  of the  applications
> > > > > that use MMC_IOC_MULTI_CMD ioctl.
> > > >
> > > > Why "  "?
> > > Not sure I there is enough clue in your question.
> > > >
> > > > >
> > > > > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > > >
> > > > > +
> > > > > +static long rpmb_ioctl(struct file *fp, unsigned int cmd,
> > > > > +unsigned long arg) {
> > > > > +	return __rpmb_ioctl(fp, cmd, (void __user *)arg); }
> > > > > +
> > > > > +#ifdef CONFIG_COMPAT
> > > > > +static long rpmb_compat_ioctl(struct file *fp, unsigned int cmd,
> > > > > +			      unsigned long arg)
> > > > > +{
> > > > > +	return	__rpmb_ioctl(fp, cmd, compat_ptr(arg));
> > > > > +}
> > > > > +#endif /* CONFIG_COMPAT */
> > > >
> > > > Description of the ioctl is missing,
> > > Will add.
> > >
> > > and it should certainly be designed in a way
> > > > that it does not need compat support.
> > >
> > > The compat_ioctl handler just casts the compat_ptr, I believe this
> > > should be done unless the ioctl is globaly registered in
> > > fs/compat_ioctl.c, but I might be wrong.
> > 
> > You shouldn't need a compat ioctl for anything new that is added, unless
> > your api is really messed up.  Please test to be sure, and not use a compat
> > ioctl at all, it isn't that hard to do.
> 
> compat_ioctl is called anyhow when CONFIG_COMPAT is set, there is no
> way around it, or I'm missing something?  Actually there is no more
> than that for the COMPAT support in this code.

If you don't provide a compat_ioctl() all should be fine, right?

thanks,

greg k-h
