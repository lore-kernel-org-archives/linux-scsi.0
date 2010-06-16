From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH 13/15] qla4xxx: Added bsg support
Date: Wed, 16 Jun 2010 10:42:56 -0500
Message-ID: <1276702976.2847.168.camel@mulgrave.site>
References: <20100611074900.GA27827@sles11sp1b1.qlogic.org>
	 <4C12D398.8020200@cs.wisc.edu> <1276382259.10508.25.camel@mulgrave.site>
	 <5E4F49720D0BAD499EE1F01232234BA871286CE740@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109Ab0FPPnC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 11:43:02 -0400
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA871286CE740@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>

On Tue, 2010-06-15 at 19:40 -0700, Vikas Chaudhary wrote:
> >-----Original Message-----
> >From: James Bottomley [mailto:James.Bottomley@suse.de]
> >Sent: Saturday, June 12, 2010 3:38 PM
> >To: Mike Christie
> >Cc: Vikas Chaudhary; linux-scsi@vger.kernel.org; Ravi Anand
> >Subject: Re: [PATCH 13/15] qla4xxx: Added bsg support
> >
> >On Fri, 2010-06-11 at 19:23 -0500, Mike Christie wrote:
> >> On 06/11/2010 02:49 AM, Vikas Chaudhary wrote:
> >> > Added BSG support to enable application support to configure
> >> > ISP40XX/ISP82XX adapter.
> >> >
> >> > This patch is on top of: http://marc.info/?l=linux-
> >scsi&m=126999297630764&w=2
> >> >
> >>
> >> Did James say that using vendor specific commands was ok? I did not see
> >> anything on the list.
> >
> >In principle, the point about vendor specific host commands has already
> >been conceded ... lpfc and qla2xxx already use them.
> >
> >I think the real rule is that for host specific BSG commands, it's only
> >for stuff that's specific to the host ... so not stuff which should be
> >done generically.
> >
> >There are no hard and fast rules for applying the test above.  In
> >theory, the management interfaces exposed by FC_BSG_HST_VENDOR could be
> >used to send commands ... but it tends to get tolerated as long as the
> >drivers support the standardised rport commands.
> >
> >If I look at what the qla4xxx interface would do
> >
> >     1. it only supports vendor specific commands ... this is a bit of a
> >        red flag since it's proposing to do nothing in a vendor neutral
> >        way.  This one, I punt back to you: what should an iscsi device
> >        implementing BSG support of the standard commands (which have
> >        only very recently been proposed for definition)
> 
> That's not true. For ex : Look at the ping support we have added which other
> iSCSI HBA vendors can use as well. Here's the thread : 
> http://article.gmane.org/gmane.linux.scsi/59535

The fact remains that none of the non-vendor-specific bsg commands is
implemented in this patch set.

> Also we are adding support in iSCSI transport for other stuff which we think
> is the right interface to use. Here's the thread :
> http://article.gmane.org/gmane.linux.scsi/59532

That's good ... and part of the problem is defining the standard set of
BSG packets for iSCSI

> But the reason we are trying to implement most of the commands using vendor
> specific way is because *setting up the card/configuration* related stuff
> are communicated using mailbox command interface with our firmware which
> do blob data transfer back and forth. Driver is basically funneling info 
> back and forth between F/W and API in a blob format. So we need this to allow
> end user's to configure the card using QLogic Application or *iscsiadm* in
> future as we are migrating from ioctl interface to bsg/netlink/sysfs route
> which will require API changes.

That's not really a relevant concern though ... at some level,
programming any HBA to do work becomes the exchange of HBA specific
"binary blob" information.  It's the job of a driver to provide a
standardised interface to the operating system which hides as much of
the binary blob transformations as possible.

As I said, I think the general rule of thumb is that anything that would
be something you'd expect all iSCSI initiators to do (like setting mac
addresses or listing endpoints) should be done via standardised,
non-vendor specific commands.

> Additionally we are working on to add support in  libiscsi user space to
> support qla4xxx which will manipulate this blob and hookup with Linux Native
> *iscsiadm*  tool. Mike was OK with this approach as long as user space
> iscsiadm support will be enabled. This is something we are working on
> parallely as well. Here's the email thread where Mike responded and we pretty
> much agreed to it :
> http://article.gmane.org/gmane.linux.scsi/58849/match=qla4xxx+bsg

Right, so I'm pretty much endorsing this approach.  With the proviso
that for anything that we already provide interfaces for (or which we
will provide interfaces for in the immediate future) you should be
using, so it's not a licence to take the existing solaris tool and hack
BSG up to use the blob data format unmodified. 

> 
> >     2. QL4_SET_FLASH looks a bit suspicious ... the only thing I think
> >        you could really set from that is the mac addresses ... is this
> >        so?
> 
> It's used for multiple purpose, for ex :-
> 	1. write firmware image to flash
> 	2. write target configuration to flash and make target persistent
> 	3. write firmware control block to flash
> 	4. write chap information to flash, etc..

So isn't the existing request_firmware() interface more appropriate for
this?

> >     3. the DDB commands seem to be for manipulating the end point
> >        table ... which is basically the iscsi connection table ... does
> >        manipulating that from BSG make sense?
> 
> For qla4xxx firmware establishes  Connection/Session and qla4xxx driver
> works in session mode. We are using ddb commands here to establish
> session with target.
> Let us know if you have any suggestions over here.

Tell us what you want to know ... getting session information out looks
to be a fairly universally useful thing rather than qlogic specific.

> >     4. What is ACB and IFCB?  It's undocumented
> 
> It is control block containing qla4xxx firmware related settings.

discuss ...

> >     5. GET/SET_ISCSI_STAT seems to be statistics related by the name;
> >        is it? if so, why not use the more standard statistics interface
> >        in the iscsi transport class?
> >
> 
> we added it via BSG using vendor command as it blob data transfer.
> API interprets the data and displays the statistics. Driver is just a passthru.

OK, so what statistics?  We already use the sysfs statistics group for
fibre channel, should we also be using that for iscsi?

> >>  If he did, then instead of the patch above from
> >> Jay, you want to use iscsi bsg patches that I sent that handle Tomos's
> >> comments about not duplicating fc code. I sent the bsg lib to the list
> >> and then in my tree on kernel.org I ported the fc drivers (those might
> >> need a update for some patches James Smart recently sent). For those bsg
> >> patches you will want to then also add the vendor specific command back.
> >
> >Agreed, having a standard way of doing bsg helps.
> 
> We will do patches again on top of bsg lib patches.

Thanks,

James


