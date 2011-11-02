From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/4] scsi_dh_rdac: Adding the match function for	rdac
 device handler
Date: Wed, 2 Nov 2011 11:46:12 -0400
Message-ID: <20111102154612.GA30632@redhat.com>
References: <47D23AD8469A2B448F33C24BD7A39BD9105DB4D8@RTPMVEXC1-PRD.hq.netapp.com>
 <4EB0EF3F.1010300@suse.de>
 <47D23AD8469A2B448F33C24BD7A39BD9105DB8EE@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929Ab1KBPqS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Nov 2011 11:46:18 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pA2FkIkP009120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Nov 2011 11:46:18 -0400
Content-Disposition: inline
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD9105DB8EE@RTPMVEXC1-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>

On Wed, Nov 02 2011 at 11:23am -0400,
Moger, Babu <Babu.Moger@netapp.com> wrote:

> > -----Original Message-----
> > From: Hannes Reinecke [mailto:hare@suse.de]
> > Sent: Wednesday, November 02, 2011 2:21 AM
> > To: dm-devel@redhat.com
> > Subject: Re: [dm-devel] [PATCH 3/4] scsi_dh_rdac: Adding the match
> > function for rdac device handler
> > 
> > On 11/01/2011 06:19 PM, Moger, Babu wrote:
> > > This patch introduces the match function for rdac device handler.
> > Without this,
> > > sometimes handler attach fails during the device_add.  The match
> > function was
> > > introduced by this patch
> > > http://www.spinics.net/lists/linux-scsi/msg54284.html
> > >
> > > Signed-off-by: Babu Moger<babu.moger@netapp.com>
> > > ---
> > >
> > > --- linux/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-10-31
> > 11:25:44.000000000 -0500
> > > +++ linux/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-10-31
> > 11:31:34.000000000 -0500
> > > @@ -819,6 +819,21 @@ static const struct scsi_dh_devlist rdac
> > >   	{NULL, NULL},
> > >   };
> > >
> > > +static bool rdac_match(struct scsi_device *sdev)
> > > +{
> > > +	int i;
> > > +
> > > +	for (i = 0; rdac_dev_list[i].vendor; i++) {
> > > +		if (!strncmp(sdev->vendor, rdac_dev_list[i].vendor,
> > > +			strlen(rdac_dev_list[i].vendor))&&
> > > +		    !strncmp(sdev->model, rdac_dev_list[i].model,
> > > +			strlen(rdac_dev_list[i].model))) {
> > > +			return true;
> > > +		}
> > > +	}
> > > +	return false;
> > > +}
> > > +
> > >   static int rdac_bus_attach(struct scsi_device *sdev);
> > >   static void rdac_bus_detach(struct scsi_device *sdev);
> > >
> > > @@ -831,6 +846,7 @@ static struct scsi_device_handler rdac_d
> > >   	.attach = rdac_bus_attach,
> > >   	.detach = rdac_bus_detach,
> > >   	.activate = rdac_activate,
> > > +	.match = rdac_match,
> > >   };
> > >
> > >   static int rdac_bus_attach(struct scsi_device *sdev)
> > >
> > As stated in the other mail, I guess we would need to have a check
> > if the LUN is in ALUA mode.
> > And, btw, the _original_ intention was to allow vendor-specific
> > device_handler to do some better probing, eg querying some
> > vendor-specific VPD pages.
> > Especially for RDAC it would make far more sense to query the
> > existence and format of one of the RDAC-specific VPD pages (eg 0xC2,
> > 0xC4, or 0xC8) and use that for matching.
> > Then you could do away with the vendor/model array altogether here
> > and we wouldn't need to update the rdac handler every time a new
> > array comes out or has been rebranded by some OEM.
>   
> OK. I will add the check for TPGS. I will send the patches tomorrow.
> For sending the VPD pages(0xC2, 0xC4 and 0xC8), I think we need be little careful here.
> This includes sending these commands to every possible device in the system. That is what we want to avoid.
> I will investigate more on that. That will be my next set of patches independent of this.

Much appreciated.  I agree with Hannes, ideally we wouldn't need the
rdac dev_list.

What about the issue where the appropriate scsi_dh isn't attached during
scan (resulting in boot failures, trespasses, etc)?

Hannes, I know you had plans for how to address the early scsi_dh
attachment (and this match() work is a great step forward).  I just
wanted to touch base with you on what your current vision is on how to
achieve proper early scsi_dh attachment (and what the remaining TODO
is).

Thanks,
Mike
