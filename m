From: "Moore, Eric Dean" <emoore@lsil.com>
Subject: RE: [PATCH] MPT Fusion driver update
Date: Mon, 10 Nov 2003 17:43:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57035A9F19@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43474 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264141AbTKJWn1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2003 17:43:27 -0500
Received: from mhbs.lsil.com (mhbs.lsil.com [147.145.31.100])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id hAAMYEV2013141
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2003 14:41:00 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

I will see what I can do to clean up the source
coding style. I don't know what the purpose of
the DROP_TEST is??

I have another patch in the works that should 
fix up error recovery.  There is lengthy 
over 30s polling being done from within eh entry points; 
and these mdelays sometimes creating NMI's on a SMP 
AMD-64 system.  Also during the polling, the system is 
non-responsive as the host_lock is acquired.

I plan to get started soon implementing some of
the new PCI API in the driver, ACPI, etc. 

Eric


On Monday, November 10, 2003 11:01 AM, Matthew Wilcox wrote:
> 
> On Mon, Nov 10, 2003 at 10:17:36AM -0500, Moore, Eric Dean wrote:
> > In addition, its going to be very difficult to 
> > inline source into email clients. The problem that I see
> > are the tabs and over 80 characters per line. I've tried 
> > a handful of email clients, non work. So I decided to 
> > email James Bottomley the patch as an attachment.  When Pam
> > Delaney was supporting this driver, she was directly
> > emailing patches to Alan Cox, etc.  I can email you 
> > the patch or put in on our ftp so you can download. 
> 
> Inlining patches into your message is definitely the best approach.
> They get read by the maximum number of people that way, improving the
> chances of bugs being found.
> 
> If you can't do that, an attachment is next best.  If you can, attach
> it with mime-type text/plain as that lets people reply to it 
> more easily.
> 
> If it's far too big (eg you're moving big chunks of code 
> around to make
> the driver more readable), third best is to put the patch on a web/ftp
> site and send a URL.
> 
> There's some fairly easy techniques you can use to reduce the 
> line length
> in your driver.  Here's an example...
> 
> drivers/message/fusion/mptscsih.c :: mptscsih_qcmd().  This 
> function is
> nearly 300 lines long (see Documentation/CodingStyle).  Let's start by
> reordering some bits to get rid of indentation:
> 
> -	if (rc == SUCCESS) {
> -		[...]
> -	} else {
> +	if (rc != SUCCESS) {
>                 mptscsih_freeChainBuffers(hd, my_idx);
>                 mpt_free_msg_frame(ScsiDoneCtx, hd->ioc->id, mf);
>                 did_errcode = 3;
>                 goto did_error;
> 	}
> 
> +	[...]
> 
> ifdefs in the middle of functions are frowned upon, so we can 
> take out the
> DROP_TEST and move it into its own function, like this (for example):
> 
> +#ifdef DROP_TEST
> +static int drop_test(MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, 
> Scsi_Cmnd *SCpnt, in
> t target, int my_idx)
> +{
> +       numTotCmds++;
> +       if ((hd->ioc->id != DROP_IOC) || (target != DROP_TARGET))
> +               return 0;
> +
> +       dropCounter++;
> +
> +       /* If counter matches DROP_THIS, do not issue command to FW to
> +        * force a reset.  Save the MF pointer so we can free 
> resources
> +        * when task management completes.
> +        */
> +       if (dropCounter != DROP_THIS_CMD)
> +               return 0;
> +
> +       dropCounter = 0;
> +
> +       /* If global is set, then we are already doing something -
> +        * so keep issuing commands.
> +        */
> +       if (dropMfPtr != NULL)
> +               return 0;
> +
> +       dropTestNum++;
> +       dropMfPtr = mf;
> +       atomic_inc(&queue_depth);
> +       printk(MYIOC_s_INFO_FMT "Dropped SCSI cmd (%p)\n", 
> hd->ioc->name, SCpnt)
> ;
> +       printk("mf (%p) req (%4x) tot cmds (%d)\n", mf, 
> my_idx, numTotCmds);
> +
> +       return 1;
> +}
> +#else
> +static int drop_test(MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, 
> Scsi_Cmnd *SCpnt, in
> t target, int my_idx) { return 0; }
> +#endif
> 
> [...]
> 
> -#ifdef DROP_TEST
> -               numTotCmds++;
> -               /* If the IOC number and target match, increment
> -                * counter. If counter matches DROP_THIS, do not
> -                * issue command to FW to force a reset.
> -                * Save the MF pointer so we can free resources
> -                * when task mgmt completes.
> -                */
> -               if ((hd->ioc->id == DROP_IOC) && (target == 
> DROP_TARGET)) {
> -                       dropCounter++;
> - 
> -                       if (dropCounter == DROP_THIS_CMD) {
> -                               dropCounter = 0;
> - 
> -                               /* If global is set, then we 
> are already
> -                                * doing something - so keep 
> issuing commands.
> -                                */
> -                               if (dropMfPtr == NULL) {
> -                                       dropTestNum++;
> -                                       dropMfPtr = mf;
> -                                       atomic_inc(&queue_depth);
> -                                       printk(MYIOC_s_INFO_FMT
> -                                               "Dropped SCSI 
> cmd (%p)\n",
> -                                               hd->ioc->name, SCpnt);
> -                                       printk("mf (%p) req 
> (%4x) tot cmds (%d)\
> n",
> -                                               mf, my_idx, 
> numTotCmds);
> -                                       return 0;
> -                               }
> -			}
> -               }
> -#endif
> +       if (drop_test(hd, mf, SCpnt, target, my_idx))
> +               return 0;
> 
> I note the DROP_TEST code is broken -- for example dropMfPtr 
> is referenced
> in mptscsih_flush_drop_test() before its definition on line 2199.
> Perhaps this code is junk and can simply be deleted?
> 
> -- 
> "It's not Hollywood.  War is real, war is primarily not about 
> defeat or
> victory, it is about death.  I've seen thousands and 
> thousands of dead bodies.
> Do you think I want to have an academic debate on this 
> subject?" -- Robert Fisk
> 
