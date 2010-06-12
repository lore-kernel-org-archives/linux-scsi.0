From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 13/15] qla4xxx: Added bsg support
Date: Sat, 12 Jun 2010 17:37:39 -0500
Message-ID: <1276382259.10508.25.camel@mulgrave.site>
References: <20100611074900.GA27827@sles11sp1b1.qlogic.org>
	 <4C12D398.8020200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab0FLWhq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jun 2010 18:37:46 -0400
In-Reply-To: <4C12D398.8020200@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com

On Fri, 2010-06-11 at 19:23 -0500, Mike Christie wrote:
> On 06/11/2010 02:49 AM, Vikas Chaudhary wrote:
> > Added BSG support to enable application support to configure
> > ISP40XX/ISP82XX adapter.
> >
> > This patch is on top of: http://marc.info/?l=linux-scsi&m=126999297630764&w=2
> >
> 
> Did James say that using vendor specific commands was ok? I did not see 
> anything on the list.

In principle, the point about vendor specific host commands has already
been conceded ... lpfc and qla2xxx already use them.

I think the real rule is that for host specific BSG commands, it's only
for stuff that's specific to the host ... so not stuff which should be
done generically.

There are no hard and fast rules for applying the test above.  In
theory, the management interfaces exposed by FC_BSG_HST_VENDOR could be
used to send commands ... but it tends to get tolerated as long as the
drivers support the standardised rport commands.

If I look at what the qla4xxx interface would do

     1. it only supports vendor specific commands ... this is a bit of a
        red flag since it's proposing to do nothing in a vendor neutral
        way.  This one, I punt back to you: what should an iscsi device
        implementing BSG support of the standard commands (which have
        only very recently been proposed for definition)
     2. QL4_SET_FLASH looks a bit suspicious ... the only thing I think
        you could really set from that is the mac addresses ... is this
        so?
     3. the DDB commands seem to be for manipulating the end point
        table ... which is basically the iscsi connection table ... does
        manipulating that from BSG make sense?
     4. What is ACB and IFCB?  It's undocumented
     5. GET/SET_ISCSI_STAT seems to be statistics related by the name;
        is it? if so, why not use the more standard statistics interface
        in the iscsi transport class?


>  If he did, then instead of the patch above from 
> Jay, you want to use iscsi bsg patches that I sent that handle Tomos's 
> comments about not duplicating fc code. I sent the bsg lib to the list 
> and then in my tree on kernel.org I ported the fc drivers (those might 
> need a update for some patches James Smart recently sent). For those bsg 
> patches you will want to then also add the vendor specific command back.

Agreed, having a standard way of doing bsg helps.

James


