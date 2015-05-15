From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [Open-FCoE] [PATCH] scsi: fix Wunused-but-set-variable
	buildwarning
Date: Fri, 15 May 2015 09:14:15 +0200
Message-ID: <20150515071415.GC24293@opentech.at>
References: <1431627166-12729-1-git-send-email-hofrat@osadl.org> <1488e7d0337944d98996c115cd0baefc@EX13-MBX-026.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488e7d0337944d98996c115cd0baefc@EX13-MBX-026.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Prasad Gondi <pgondi@vmware.com>
Cc: Nicholas Mc Guire <hofrat@osadl.org>, Vasu Dev <vasu.dev@intel.com>, "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 14 May 2015, Prasad Gondi wrote:

> It seems like     rpriv is used to set the fsp->tgt_flags originally
> 
> >   fsp->tgt_flags = rpriv->flags 
> 
> And fsp->tgt_flags are used in "fc_fcp_cmd_send" like this
> 
>         setup_timer(&fsp->timer, fc_fcp_timeout, (unsigned long)fsp);
>         if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
>                 fc_fcp_timer_set(fsp, get_fsp_rec_tov(fsp));
> 
> Main purpose of this flags used is to set the correct TimeOut Value for fc_fcp_timer. 
> 
> So is the removal of the "fsp->tgt_flags = rpriv->flags" in fc_queuecommand() is intentional? Or by mistake?
> 
thats something I can't say - but the commit message indicated that the
removal of tgt_flags was intentional.

> Once we clear that out we can see whether this change make sense?
>
yup - many thanks !

hofrat
 
