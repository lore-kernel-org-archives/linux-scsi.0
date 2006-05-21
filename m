From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] scsi: Return -EINVAL when "id == max_id" in scsi_scan_host_selected()
Date: Sat, 20 May 2006 20:34:28 -0700 (PDT)
Message-ID: <20060521033428.61699.qmail@web31813.mail.mud.yahoo.com>
References: <1148108792.13190.36.camel@amitarora.in.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:36494 "HELO
	web31813.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751347AbWEUDe3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 May 2006 23:34:29 -0400
In-Reply-To: <1148108792.13190.36.camel@amitarora.in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Amit Arora <aarora@in.ibm.com>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, patmans@us.ibm.com

--- Amit Arora <aarora@in.ibm.com> wrote:
> On Fri, 2006-05-19 at 21:21, Matthew Wilcox wrote:
> > On Fri, May 19, 2006 at 04:14:50PM -0700, Amit Arora wrote:
> > > The scsi_scan_host_selected() should return -EINVAL when the id is equal
> > > to the max_id. Currently it uses ">" when comparing with max_id, and
> > > hence leaves the border case when "id==max_id".
> > > The channel and lun have values valid from 0 up to,
> > > and including, max_channel or max_lun. But, the valid values for id
> > > range from 0 to max_id-1. This patch fixes the problem.
> > 
> > You're right, but the patch is wrong.  It's not acceptable to have
> > different meanings for variables with such similar names.  Either it
> > needs to be renamed to id_count or we need to fix all the other users of
> > max_id.
> 
> I agree that similar sounding variable names should not have different
> meanings, but having this slight inconsistency for the time being (till
> we have a new naming convention for these variables) is better than
> having a bug in the code which brings down the whole system ! Obviously
> the current code is wrong and is thus resulting in a system crash
> (actually a BUG_ON) when following command is issued on a system with an
> Adaptec SCSI controller (aic7xxx/aic79xx driver) :
> "echo 0 16 0 > /sys/class/scsi_host/host0/scan"
> It might behave similarly on other drivers as well.
> 
> Thus, I still think applying the patch might be a good idea in the
> immediate future. Moreover, this patch doesn't change the current
> definition of any of these variables and results in a behavior which is
> currently expected. So, till the time we figure out what should be done
> in the long run to remove any confusion over the definition of these
> variables - why not apply the patch ?
> 
> Sorry, being a novice in this area, I did not understand what you meant
> by "other users of max_id". I think all the drivers currently have it as
> "maximum value of id possible" + 1. Please correct me if I am wrong.
> 
> > 
> > BTW, I think we have another problem with max_lun:
> > 
> > 	max_dev_lun = min(max_scsi_luns, shost->max_lun);
> > 	...
> > 	for (lun = 1; lun < max_dev_lun; ++lun)
> > 
> > surely that should be <= ?
> 
> Yes, looks wrong to me.

Hi Amit,

Welcome to the club!

You'll find a lot more other "bugs" in the Linux SCSI Core.  Not much
has changed in the past 6 years, nothing in the core at least.

As to your particular gripe: you're right.  But I doubt anything would
get fixed or changed any time soon.  There is very little competence
which also has power to change things in the SCSI part of the Linux.
Take a look at the SCSI mailing list archives for good ol' laughs.

People here think that the concept of a "host" should be escalated to
the block subsystem, people here think that "REQUEST SENSE" clears ACA,
and that calling done() and then turning around to do eh on the
command in question is ok.  People here think that using link
commands has something to do with barriers and atomic transactions.
"SCSI device with Target ports" is called "techno-gibberish" here.

Anyway, I'd suggest fixing such things in your own version/git tree
of the kernel.

As to naming: I always call such things "num_of_xyz" to be absolutely
clear that the enumeration is "0 <= index_xyz < num_of_xyz".

Good luck,
    Luben

