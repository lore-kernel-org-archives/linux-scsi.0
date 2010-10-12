From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Tue, 12 Oct 2010 12:03:45 -0700
Message-ID: <20101012190345.GA25737@kroah.com>
References: <4CA653F0.1010008@vlnb.net> <4CA656AD.8020408@vlnb.net> <20101009212047.GB27180@kroah.com> <4CB36592.6060909@vlnb.net> <20101011213235.GA11489@kroah.com> <4CB4AEB9.30501@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CB4AEB9.30501@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 12, 2010 at 10:53:45PM +0400, Vladislav Bolkhovitin wrote:
> > Seriously, you CAN NOT DO THIS!  If you embed a kobject in a different
> > structure, then you have to rely on the kobject to handle the reference
> > counting for that larger structure.  To do ANYTHING else is a bug and
> > wrong.
> > 
> > Please read the kobject documentation and fix this code up before
> > submitting it again.
> 
> Sure, I have read it and we rely on the kobject to handle the reference
> counting for the larger structure. It's only done not in a
> straightforward way, because the way it is implemented is simpler for us
> + for some other reasons.

Sorry, but I don't buy it.

> For instance, for structure scst_tgt it is done using
> tgt_kobj_release_cmpl completion. When a target driver calls
> scst_unregister_target(), scst_unregister_target() in the end calls
> scst_tgt_sysfs_del(), which calls kobject_put(&tgt->tgt_kobj) and wait
> for tgt_kobj_release_cmpl to complete.

Wait, why shouldn't the release then free the memory?

> At this point tgt_kobj can be taken only by the SYSFS.
> Scst_tgt_sysfs_del() can wait as much as needed until the SYSFS code
> released it. As far as I can see, it can't be forever, so it's OK.

I don't understand, why can't you just free the memory, what are you
having to wait for?

You are only having one kobject for your structure, right?  If so, then
free the memory in the release, to wait for something else to free the
memory is wrong.

> Then, after scst_tgt_sysfs_del() returned, scst_unregister_target()
> will free scst_tgt together with embedded tgt_kobj.

As no other kernel code is like this, I don't think it's valid to be
doing so, sorry.

Please fix this.

good luck,

greg k-h
