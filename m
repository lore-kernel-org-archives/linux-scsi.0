From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 09/11] drivers/scsi: Convert #ifdef DEBUG
 printk(KERN_DEBUG to pr_debug(
Date: Fri, 15 May 2009 12:04:52 -0700
Message-ID: <1242414292.3373.6.camel@Joe-Laptop.home>
References: <cover.1242407227.git.joe@perches.com>
	 <d6d5dc09d259cc1da0fef2b1e9c6b7588cccf0b4.1242407227.git.joe@perches.com>
	 <1242413806.22585.2.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2167 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZEOTEx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 15:04:53 -0400
In-Reply-To: <1242413806.22585.2.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2009-05-15 at 18:56 +0000, James Bottomley wrote:
> On Fri, 2009-05-15 at 10:59 -0700, Joe Perches wrote:
> > diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> > index 8059494..29d5118 100644
> > --- a/drivers/scsi/aha1542.c
> > +++ b/drivers/scsi/aha1542.c
> > @@ -509,9 +509,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
> >  		if (mbistatus == 3)
> >  			continue;	/* Aborted command not found */
> >  
> > -#ifdef DEBUG
> > -		printk(KERN_DEBUG "...done %d %d\n", mbo, mbi);
> > -#endif
> > +		pr_debug("...done %d %d\n", mbo, mbi);
> 
> This one looks dangerous ... that's a per trigger printk from interrupt
> context.  That's a lot of stuff to bung in the log buffer for a normal
> operating case (which is pretty interrupt heavy).  What does this do to
> system responsiveness?

The normal operating case is not to define DEBUG.

Hmm, if CONFIG_DYNAMIC_DEBUG is enabled, it is a functional change.
Maybe the changes should be to pr_devel?

