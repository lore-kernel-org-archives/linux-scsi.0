From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH] lpfc: fix model description
Date: Mon, 27 Apr 2015 00:32:11 +0200
Message-ID: <20150427003211.0000410a@localhost>
References: <20150422231618.00005ec8@localhost>
 <5538A10E.10904@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49199 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbbDZWcH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Apr 2015 18:32:07 -0400
In-Reply-To: <5538A10E.10904@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-scsi@vger.kernel.org, James Smart <James.Smart@Emulex.Com>, Sebastian Herbszt <herbszt@gmx.de>

Bart Van Assche wrote:
> On 04/22/15 23:16, Sebastian Herbszt wrote:
> > Remove trailing space from model description.
> >
> > Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
> >
> > diff -up 4.0/drivers/scsi/lpfc.orig/lpfc_init.c 4.0/drivers/scsi/lpfc/lpfc_init.c
> > --- 4.0/drivers/scsi/lpfc.orig/lpfc_init.c	2015-04-15 06:18:24.673045138 +0200
> > +++ 4.0/drivers/scsi/lpfc/lpfc_init.c	2015-04-22 21:03:39.203230409 +0200
> > @@ -2253,7 +2253,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba
> >   				phba->Port);
> >   		else if (max_speed == 0)
> >   			snprintf(descp, 255,
> > -				"Emulex %s %s %s ",
> > +				"Emulex %s %s %s",
> >   				m.name, m.bus, m.function);
> >   		else
> >   			snprintf(descp, 255,
> 
> Hello Sebastian,

Hello Bart,

> Since you are touching that code, please include the following 
> additional changes in your patch or in a separate patch:

I could follow up with a patch containing

> * Change the type of the third argument of lpfc_get_hba_model_desc()
>    from uint8_t * into char * since that pointer is used to store a
>    '\0'-terminated ASCII string.

-static void lpfc_get_hba_model_desc(struct lpfc_hba *, uint8_t *, uint8_t *);
+static void lpfc_get_hba_model_desc(struct lpfc_hba *, char *, char *);

and

-lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
+lpfc_get_hba_model_desc(struct lpfc_hba *phba, char *mdp, char *descp)

since both mdp and descp are strings.

> * Add a size argument to lpfc_get_hba_model_desc() such that the callers
>    of this function can specify what the size is of the array descp
>    points at (sizeof(phba->ModelDesc) ?).

I am not sure whether this change is necessary because callers of
lpfc_get_hba_model_desc() are limited to lpfc_init.c and always use
the same arguments (phba->ModelName, phba->ModelDesc):

        char ModelDesc[256];            /* Model Description */
        char ModelName[80];             /* Model Name */

> * Switch from snprintf() to scnprintf() because the latter function
>    guarantees '\0'-termination if the output has to be truncated.

Doesn't snprintf() guarantee this too? The only difference between
snprintf() and scnprintf() seems to be the return value.
snprintf() calls vsnprintf() and scnprintf() calls vscnprintf() which
calls vsnprintf() itself.

> Thanks,
> 
> Bart.
> 

Sebastian
