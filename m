From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] sd: always scan VPD pages if thin provisioning is
 enabled
Date: Wed, 25 Jan 2017 09:27:05 -0500
Message-ID: <1485354425.5280.76.camel@localhost.localdomain>
References: <1485329165-64825-1-git-send-email-hare@suse.de>
         <20170125102329.GA17657@lst.de>
         <022cd098-4156-6e17-a308-adff544bf99f@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750870AbdAYO1G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 09:27:06 -0500
In-Reply-To: <022cd098-4156-6e17-a308-adff544bf99f@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, 2017-01-25 at 11:38 +0100, Hannes Reinecke wrote:
> On 01/25/2017 11:23 AM, Christoph Hellwig wrote:
> > On Wed, Jan 25, 2017 at 08:26:05AM +0100, Hannes Reinecke wrote:
> >> For any device with an older SCSI revision we might not
> >> be scanning VPD pages, which results in a wrongly configured
> >> discard mode if thin provisioned is enabled.
> >> According to sbc3 any thin provisioned device (ie devices which
> >> have the LBPME bit set in the output of READ CAPACITY(16)) need
> >> to support VPD pages. So this patch always enables VPD pages
> >> even for older SCSI revisions if thin provisioning is enabled.
> > 
> > Can you explain what you need this for?  A device with a per-SBC3
> > revision that wants us to use UNMAP?
> > 
> Some storage arrays essentially lie about the SCSI revision (most
> notably Hitachi :-), and some claim to support SPC-2 (or even SPC) but
> support newer features, too. Most notably VPD pages support.
> In this case it was an HP EVA claiming to support SPC-2 only, but
> providing thin provisioning.

Um, isn't this why we added:

commit c1d40a527e885a40bb9ea6c46a1b1145d42b66a0
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Tue Jul 15 12:49:17 2014 -0400

    scsi: add a blacklist flag which enables VPD page inquiries

(well, it was for storvsc, but we could add an entry for the HP EVA)

> >> +		/*
> >> +		 * sbc3r36 states:
> >> +		 * The device server in a logical unit the supports
> >> +		 * logical block provisioning management shall support
> >> +		 * the Logical Block Provisioning VPD page.
> >> +		 * So VPD pages should be supported if lbpme is set.
> >> +		 */
> > 
> > It's a bit odd to quote SBC3 when the device clearly is pre-SBC3
> > to need this workaround..
> > 
> _Actually_ it's pre-SPC-3.
> 
> But that was the earliest draft I had :-(
> I'd be happy to modify this if I had access to sbc-2 drafts.
> 
> >> +		if (!scsi_device_supports_vpd(sdp))
> >> +			sdp->try_vpd_pages = 1;
> > 
> > Do the assignment unconditionally?
> > 
> Yeah, can do.
> 
> Cheers,
> 
> Hannes


