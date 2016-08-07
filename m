From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v5 4/8] char: rpmb: provide a user space interface
Date: Sun, 7 Aug 2016 09:44:03 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542B8AC9@hasmsx108.ger.corp.intel.com>
References: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
 <1468873673-21776-5-git-send-email-tomas.winkler@intel.com>
 <20160805200823.GB7999@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20160805200823.GB7999@amd>
Content-Language: en-US
Sender: linux-mmc-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> 
> On Mon 2016-07-18 23:27:49, Tomas Winkler wrote:
> > The user space API is achieved via two synchronous IOCTL.
> 
> IOCTLs?

Will fix
 
> > Simplified one, RPMB_IOC_REQ_CMD, were read result cycles is
> performed
> > by the framework on behalf the user and second, RPMB_IOC_SEQ_CMD
> where
> > the whole RPMB sequence including RESULT_READ is supplied by the caller.
> > The latter is intended for  easier adjusting  of the  applications
> > that use MMC_IOC_MULTI_CMD ioctl.
> 
> Why "  "?
Not sure I there is enough clue in your question. 
> 
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> 
> > +
> > +static long rpmb_ioctl(struct file *fp, unsigned int cmd, unsigned
> > +long arg) {
> > +	return __rpmb_ioctl(fp, cmd, (void __user *)arg); }
> > +
> > +#ifdef CONFIG_COMPAT
> > +static long rpmb_compat_ioctl(struct file *fp, unsigned int cmd,
> > +			      unsigned long arg)
> > +{
> > +	return	__rpmb_ioctl(fp, cmd, compat_ptr(arg));
> > +}
> > +#endif /* CONFIG_COMPAT */
> 
> Description of the ioctl is missing, 
Will add. 

and it should certainly be designed in a way
> that it does not need compat support.

The compat_ioctl handler just casts the compat_ptr, I believe this should be done unless the ioctl is globaly registered in fs/compat_ioctl.c, but I might be wrong.
Tomas


