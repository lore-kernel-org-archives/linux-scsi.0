From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Pb with external RAID controller in lk 2.4
Date: Fri, 24 May 2002 10:44:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020524104450.B22142@eng2.beaverton.ibm.com>
References: <3CEA83AE.1DCAB7BC@cri74.org> <3CEB4D6D.92C207EE@cri74.org> <20020522100339.A268@eng2.beaverton.ibm.com> <20020524191733.N28936@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020524191733.N28936@gum01m.etpnet.phys.tue.nl>; from garloff@suse.de on Fri, May 24, 2002 at 07:17:33PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Patrick Mansfield <patmans@us.ibm.com>, Fabien Salvi <fabien@cri74.org>, linux-scsi@vger.kernel.org, Lorraine Suschetet <lorraine@ext.cri74.org>

On Fri, May 24, 2002 at 07:17:33PM +0200, Kurt Garloff wrote:
> Hi Patrick,
> 
> On Wed, May 22, 2002 at 10:03:39AM -0700, Patrick Mansfield wrote:
> > The 2.4 kernel won't scan past LUN 7 for SCSI-2 devices - you can try
> > modifying the code and set the max to 31 in scsi_scan.c.
> 
> If you have a FC device (or whatever device that supports LUNs > 7) that
> reports as SCSI-2, you can flag it with BLIST_LARGELUN in scsi_scan.c
> to get it treated as SCSI-3.
> (New in 2.4.18)

I don't see that in 2.4.18, is it in a 2.4.19-pre? (I can't get to
any kernel.org or a mirror right now.)

> >         /* Use the peripheral qualifier field to determine online/offline */
> >         if (((scsi_result[0] >> 5) & 7) == 1)   SDpnt->online = FALSE;
> >         else SDpnt->online = TRUE;

> Those fields should not be set by the device, IMHO.
> Or has their meaning changed for SCSI-3 devs? Then the appropriate check
> should be added to the code.
 
I don't think anything has changed, SCSI-3 for a peripheral qualifier
of 001b says:

  The device server is capable of supporting the specified peripheral device
  type on this logical unit. However, the physical device is not currently
  connected to this logical unit.

So it seems reasonable to set it to 1. For many disk arrays, this value
can be modified - the pq or byte one of the INQUIRY result for LUNs with
with no storage.

-- Patrick Mansfield

> 
> > The device is probably setting the peripheral-qualifier (PQ) such that the
> > scan continues but the device is marked offline, this is just annoying
> > if do not have a lot of them. In scsi_scan.c:
> > 
> 
> But actually the problem is different: Too many LUNs where detected :-(
> 
> Regards,
> -- 
> Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
> GPG key: See mail header, key servers         Linux kernel development
> SuSE Linux AG, Nuernberg, DE                            SCSI, Security


