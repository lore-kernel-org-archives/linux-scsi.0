From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ide-scsi opps
Date: Thu, 11 Jul 2002 16:39:17 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E17Sg2H-00011H-00@the-village.bc.nu>
References: <000901c228e9$ddbe9160$0501a8c0@Stev.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <000901c228e9$ddbe9160$0501a8c0@Stev.org> from "James Stevenson" at Jul 11, 2002 03:47:22 PM
List-Id: linux-scsi@vger.kernel.org
To: James Stevenson <mistral@stev.org>
Cc: Linux Scsi <linux-scsi@vger.kernel.org>

> i think its the request queue is null taken from line 337 ide-scsi.c
> 
> if (status & ERR_STAT)
>     rq->errors++;            OPPS!!
>     idescsi_end_request (1, HWGROUP(drive));
>     return ide_stopped;
> }
> 
> i think the opps happens because rq is NULL would this opps show this ?
> it gets triggered on the loading of rq->error into a register.
> though i am unsure of the best way to fix it could anyone spare some
> time and help me a bit. the bug is 100% reproduceable by me by trying to
> read from some suspec media in a cd drive.


Before the rq->errors++ add

	if(rq == NULL)
		printk(KERN_ERR "Arghh rq==NULL\n");
	else


that will log errors instead of crashing. The next task then is to figure out
how rq got to be NULL if that proves it to be the problem.


