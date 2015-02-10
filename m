From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
Date: Tue, 10 Feb 2015 08:55:37 -0800
Message-ID: <1423587337.8339.3.camel@perches.com>
References: <1423233221-27069-1-git-send-email-linux@rasmusvillemoes.dk>
	 <bb45ec6cfa94612741a2eb355d0de566@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bb45ec6cfa94612741a2eb355d0de566@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-02-10 at 22:16 +0530, Kashyap Desai wrote:
> Acked-by: Kashyap Desai <kashyap.desai@avagotech.com>
> 
> > -----Original Message-----
> > From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> > Sent: Friday, February 06, 2015 8:04 PM
[]
> > There is currently no %po format extension, so currently the letters
> "on" are
> > simply skipped and the pointer is printed as expected (while missing the
> word
> > on). However, it is probably only a matter of time before someone comes
> up
> > with a %po extension, at which point this is likely to fail
> spectacularly.

Nice tool Rasmus

> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
[]
> > @@ -3105,7 +3105,7 @@ megasas_internal_reset_defer_cmds(struct
> > megasas_instance *instance)
> >  	for (i = 0; i < max_cmd; i++) {
> >  		cmd = instance->cmd_list[i];
> >  		if (cmd->sync_cmd == 1 || cmd->scmd) {
> > -			printk(KERN_NOTICE "megasas: moving
> > cmd[%d]:%p:%d:%p"
> > +			printk(KERN_NOTICE "megasas: moving
> > cmd[%d]:%p:%d:%p "
> >  					"on the defer queue as
> internal\n",
> >  				defer_index, cmd, cmd->sync_cmd, cmd-
> > >scmd);
> >

It'd probably be nicer to coalesce the format.

			printk(KERN_NOTICE "megasas: moving cmd[%d]:%p:%d:%p on the defer queue as internal\n",
				defer_ndex, cmd, cmd->sync, cmd->scmd);
