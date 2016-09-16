From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: TRIM/UNMAP/DISCARD via ATA Passthrough
Date: Fri, 16 Sep 2016 09:21:44 -0700
Message-ID: <1474042904.2353.52.camel@HansenPartnership.com>
References: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
         <yq1d1k6l43x.fsf@sermon.lab.mkp.net>
         <CAHmME9pX1sSdFLfsgBqunh=5ttmPg5-vAzvTEfD1Xt4NBk6JzA@mail.gmail.com>
         <yq1twdhb0zr.fsf@sermon.lab.mkp.net>
         <CAHmME9qq5vSC+hZckCystU6cdRPihO492U2B2-pozbwg=3_5nw@mail.gmail.com>
         <5af202ea-a632-28c2-515f-c361e27de5da@suse.de>
         <c2c154db-67fe-dcaa-a46a-48a53e15d1cf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34734 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935745AbcIPQVq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Sep 2016 12:21:46 -0400
In-Reply-To: <c2c154db-67fe-dcaa-a46a-48a53e15d1cf@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Hannes Reinecke <hare@suse.de>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Fri, 2016-09-16 at 11:53 -0400, Austin S. Hemmelgarn wrote:
> On 2016-09-16 07:16, Hannes Reinecke wrote:
> > On 09/15/2016 10:52 PM, Jason A. Donenfeld wrote:
> > > Hi Martin,
> > > 
> > > On Thu, Sep 15, 2016 at 6:07 PM, Martin K. Petersen
> > > > But how do they signal that ATA passthrough is possible? Is 
> > > > there an ATA Information VPD page? Is REPORT SUPPORTED 
> > > > OPERATION CODES supported?
> > > > 
> > > > We need really solid discovery data before we can entertain 
> > > > enabling something like this.
> > > 
> > > `sg_opcodes` said invalid request, so I think there isn't REPORT
> > > SUPPORTED OPERATION CODES, and `sg_vpd -p ai` came up illegal
> > > too.
> > > 
> > > However, sg_sat_identify worked reliably, which means a solid way 
> > > of probing this would be to send IDENTIFY DEVICE ATA via 
> > > SG_ATA_16 or SG_ATA_12.
> > > 
> > > Let me know and I can give you access to the hardware if you're
> > > curious.
> > > 
> > Sadly, that's not sufficient.
> > linux is not the only provider of an SATL (mpt3sas being the most
> > prominent other one).
> > And while they might support ATA_12/ATA_16, there is no indication 
> > that you can pass DSM TRIM that way.
> So it's better to not support it at all than to support it on 
> hardware we can reliably identify?
> 
> I get that having feature parity is a good thing, but the discussion 
> isn't about providing support for all SATL devices, it's specifically
> about UAS connected SATL devices.  Last I checked, mpt3sas doesn't do
> anything with UAS, which means it's kind of irrelevant WRT supporting
> this for UAS devices.

We're getting a bit off topic on mptsas and it's eccentric SATL.

The point is, you're asking for UAS devices which each have an internal
SATL which you say potentially doesn't support discard.  The three
problems we have are

   1. How do we identify if the UAS SATL doesn't support discard.  If it
      does, we really don't want to cause further SATL related issues by
      bypassing it, so we need a way of telling this.
   2. If the SATL doesn't support discard, will it reliably support the
      ATA_12 or ATA_16 pass through (and which one) .. we need a way of
      checking this because there are known SATLs that don't do pass
      through.
   3. How do we actually configure it?  Presumably if the SATL doesn't
      support discard, it also doesn't give us the useful mode page
      indications we use to configure TRIM, so we're going to have to do
      some pass through discovery as well.

James

