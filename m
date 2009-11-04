From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Wed, 04 Nov 2009 10:07:13 -0600
Message-ID: <1257350834.2697.52.camel@mulgrave.site>
References: <4AF17AD3.6060909@Calva.COM>
	 <1257348128.2697.29.camel@mulgrave.site>  <4AF1A38E.3000009@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50261 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbZKDQHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2009 11:07:15 -0500
In-Reply-To: <4AF1A38E.3000009@Calva.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Hughes <john@Calva.COM>
Cc: linux-scsi@vger.kernel.org

On Wed, 2009-11-04 at 16:53 +0100, John Hughes wrote:
> James Bottomley wrote:
> > On Wed, 2009-11-04 at 14:00 +0100, John Hughes wrote:
> >   
> >> No sign of an enclosure.
> >>
> >> I've tried with a Debian  2.6.26-2-xen-amd64 kernel, and a 2.6.31 I 
> >> build myself.
> >>
> >> Any clues about what I should to to diagnose this problem?
> >>     
> >
> > Tell me what disks you have first.  Currently the matching algorithm
> > only works with SAS disks because we have no VPD translation for SATA.
> > Hopefully I'll be getting a SATA device to put in an enclosure at some
> > point, so I can play with this (at the moment I only have one SATA
> > device and I'm using it for data storage ...).
> >
> > James
> >
> >
> >   
> All but one are SAS.
> 
> # lsscsi
> [0:0:32:0]   enclosu DP       BACKPLANE        1.07  -       
> [0:2:0:0]    disk    DELL     PERC 6/i         1.21  /dev/sda

OK, so this one is a RAID emulation device and likely won't work, but
the rest (apart from the ATA one) should.

Could you tell me what the enclosure page 0 (supported diagnostic pages)
and page 10 (additional information page that allows us to do the
matching) say?  I suspect the enclosure either doesn't support the page
needed for the matching or there's some problem with the way the
information is encoded.

To get this information, you'll need to run sg_ses on the sg device for
the enclosure (the two promise ones).

Thanks,

James


