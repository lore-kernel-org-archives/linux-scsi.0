From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: Increase can_queue and cmds_per_lun
Date: Wed, 30 Aug 2006 15:25:20 -0400
Message-ID: <1156965920.7701.13.camel@mulgrave.il.steeleye.com>
References: <20060830190454.28371.qmail@web31807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:3525 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751365AbWH3TZd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Aug 2006 15:25:33 -0400
In-Reply-To: <20060830190454.28371.qmail@web31807.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, Konrad Rzeszutek <konrad@darnok.org>

On Wed, 2006-08-30 at 12:04 -0700, Luben Tuikov wrote:
> > --- a/drivers/scsi/aic94xx/aic94xx_init.c
> > +++ b/drivers/scsi/aic94xx/aic94xx_init.c
> > @@ -71,7 +72,7 @@ static struct scsi_host_template aic94xx
> >       .change_queue_type      = sas_change_queue_type,
> >       .bios_param             = sas_bios_param,
> >       .can_queue              = 1,
> > -     .cmd_per_lun            = 1,
> > +     .cmd_per_lun            = 2,
> 
> Why 2?  Why not 3?  If you can set this to 3, then why not 4?
> But if you can set it to 4, why not 5?
> 
> This value should also be dynamically set, it should depend on
> the type of LU and it shouldn't be present in the host template.
> (But that's an architectural argument which leads nowhere on lsml.)

actually, cmd_per_lun is pretty much a vestigial variable.  It's used
for the initial queue depth before the driver decides to turn on TCQ.
Thus, since the non-tagged depth should always only be 1, the only
useful value to set it to is 1.

James


