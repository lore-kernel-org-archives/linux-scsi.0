From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: warning cleanup for drivers/scsi/fdomain.c
Date: Tue, 30 Jul 2002 15:44:39 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020730061710.512AC412E@lists.samba.org>
References: <E17ZOxI-0001tS-00@wagner.rustcorp.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "Tue, 30 Jul 2002 14:49:56 +1000."
             <E17ZOxI-0001tS-00@wagner.rustcorp.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Eric Sandeen <sandeen@sgi.com>
Cc: linux-scsi@vger.kernel.org

In message <E17ZOxI-0001tS-00@wagner.rustcorp.com.au> you write:
> --- linux/drivers/scsi/fdomain.c	Mon Feb 25 13:38:04 2002
> +++ linux-fixed-warnings/drivers/scsi/fdomain.c	Sun Jul 21 21:43:37 2002
> @@ -2041,7 +2041,7 @@ int fdomain_16x0_release(struct Scsi_Hos
>  		free_irq(shpnt->irq, shpnt);
>  	if (shpnt->io_port && shpnt->n_io_port)
>  		release_region(shpnt->io_port, shpnt->n_io_port);
> -
> +	return 0;
>  }
>  
>  MODULE_LICENSE("GPL");

[Side note to SCSI people]

This is correct, as stands, but the real fix is to declare
Scsi_Host_Template's release method to return void, since the only
caller I can find ignores the return anyway.

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
