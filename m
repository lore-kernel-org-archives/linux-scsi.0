From: Naveen Burmi <naveenb@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 20 Nov 2003 20:23:52 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03112020235202.16789@naveenb-lnx.cisco.com>
References: <200310231734.10263.krmurthy@cisco.com> <03112019020601.16789@naveenb-lnx.cisco.com> <20031120133433.A31298@infradead.org>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:18572 "EHLO
	sj-iport-3.cisco.com") by vger.kernel.org with ESMTP
	id S261882AbTKTOuq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 09:50:46 -0500
In-Reply-To: <20031120133433.A31298@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Thursday 20 November 2003 07:04 pm, Christoph Hellwig wrote:
> On Thu, Nov 20, 2003 at 07:02:06PM +0530, Naveen Burmi wrote:
> > Lun masking feature is provided by the linux-iscsi driver. In the
> > linux-iscsi driver configuration file user can specify the luns of a
> > target that needs to be activated upon the detection of that target.
> >
> > > If you already have the LUN specified, why do you need to issue a
> > > REPORT LUN command?
> >
> > User has specified the LUNs that needs to be activated upon the detection
> > of a target. Once that target gets detected then to find out weather the
> > LUNs specified by the user are actually present, we need to issue REPORT
> > LUN command.
> >
> > > I don't know iSCSI specification details, but I would want to specify a
> > > target, not a LUN, in a configuration file and have all LUNs on the
> > > target be automatically configured.
> >
> > User might not want to configure all the LUNs of a target.
>
> I'm not sure I agree with that.  Users might also want whatever but it's
> not sensible to do that.  Ignore the user request now, if we see real-world
> use for that we'll implement it in the midlayer.  And if you think it's
> really important implement it in the midlayer now and keep the patch around
> for users that want it.

we are actually trying to do  optimization by sending REPORT LUN command 
before actually configuring the target in the mid layer and configure only 
the devices that are actually present.
Agreed its not sensible to do it right now. Let's the need of it should be 
felt in the real-world, after that it can be implemented in the mid-layer.

We will remove iscsi_do_cmnd as pointed out by you from iscsi LLD.

Thanks,
Naveen. 

>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
