From: "vasu.dev@linux.intel.com" <vasu.dev@linux.intel.com>
Subject: Re: [Open-FCoE] [PATCH] scsi: fix Wunused-but-set-variable
 buildwarning
Date: Fri, 15 May 2015 10:09:33 -0700
Message-ID: <1431709773.4358.14.camel@lin-nd1-054.jf.intel.com>
References: <1431627166-12729-1-git-send-email-hofrat@osadl.org>
	 <1488e7d0337944d98996c115cd0baefc@EX13-MBX-026.vmware.com>
	 <20150515071415.GC24293@opentech.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150515071415.GC24293@opentech.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Prasad Gondi <pgondi@vmware.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Nicholas Mc Guire <hofrat@osadl.org>, "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-05-15 at 09:14 +0200, Nicholas Mc Guire wrote:
> On Thu, 14 May 2015, Prasad Gondi wrote:
> 
> > It seems like     rpriv is used to set the fsp->tgt_flags originally
> > 
> > >   fsp->tgt_flags = rpriv->flags 
> > 
> > And fsp->tgt_flags are used in "fc_fcp_cmd_send" like this
> > 
> >         setup_timer(&fsp->timer, fc_fcp_timeout, (unsigned long)fsp);
> >         if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
> >                 fc_fcp_timer_set(fsp, get_fsp_rec_tov(fsp));
> > 
> > Main purpose of this flags used is to set the correct TimeOut Value for fc_fcp_timer. 
> > 
> > So is the removal of the "fsp->tgt_flags = rpriv->flags" in fc_queuecommand() is intentional? Or by mistake?
> > 
> thats something I can't say - but the commit message indicated that the
> removal of tgt_flags was intentional.
> 

It was intentional and good cleanup since now rpriv->flags is used
directly with that change instead of storing in fsp->tgt_flags as it was
before.

> > Once we clear that out we can see whether this change make sense?
> >

Anycase the patch under discussion is straight forward clean up patch
since it just removes a local stack variable which is not used.

Thanks,
Vasu
