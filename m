From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: always scan VPD pages if thin provisioning is
 enabled
Date: Wed, 25 Jan 2017 07:38:05 -0800
Message-ID: <1485358685.2473.6.camel@HansenPartnership.com>
References: <1485329165-64825-1-git-send-email-hare@suse.de>
         <20170125102329.GA17657@lst.de>
         <022cd098-4156-6e17-a308-adff544bf99f@suse.de>
         <1485354425.5280.76.camel@localhost.localdomain>
         <02181dcf-0177-d2f3-545e-264d87bc489b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42590 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750980AbdAYPiJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 10:38:09 -0500
In-Reply-To: <02181dcf-0177-d2f3-545e-264d87bc489b@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, emilne@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, 2017-01-25 at 15:38 +0100, Hannes Reinecke wrote:
> On 01/25/2017 03:27 PM, Ewan D. Milne wrote:
> > On Wed, 2017-01-25 at 11:38 +0100, Hannes Reinecke wrote:
> > > On 01/25/2017 11:23 AM, Christoph Hellwig wrote:
> > > > On Wed, Jan 25, 2017 at 08:26:05AM +0100, Hannes Reinecke
> > > > wrote:
> > > > > For any device with an older SCSI revision we might not
> > > > > be scanning VPD pages, which results in a wrongly configured
> > > > > discard mode if thin provisioned is enabled.
> > > > > According to sbc3 any thin provisioned device (ie devices 
> > > > > which have the LBPME bit set in the output of READ 
> > > > > CAPACITY(16)) need to support VPD pages. So this patch always 
> > > > > enables VPD pages even for older SCSI revisions if thin 
> > > > > provisioning is enabled.
> > > > 
> > > > Can you explain what you need this for?  A device with a per
> > > > -SBC3 revision that wants us to use UNMAP?
> > > > 
> > > Some storage arrays essentially lie about the SCSI revision (most
> > > notably Hitachi :-), and some claim to support SPC-2 (or even 
> > > SPC) but support newer features, too. Most notably VPD pages 
> > > support. In this case it was an HP EVA claiming to support SPC-2 
> > > only, but providing thin provisioning.
> > 
> > Um, isn't this why we added:
> > 
> > commit c1d40a527e885a40bb9ea6c46a1b1145d42b66a0
> > Author: Martin K. Petersen <martin.petersen@oracle.com>
> > Date:   Tue Jul 15 12:49:17 2014 -0400
> > 
> >     scsi: add a blacklist flag which enables VPD page inquiries
> > 
> > (well, it was for storvsc, but we could add an entry for the HP
> > EVA)
> > 
> I knew someone would raise this objection :-)
> 
> Thing is, setting 'WS16' here is arguably wrong, as LPBME just means
> 'logical block provisioning management enabled', not 'WRITE SAME 16 
> with UNMAP' supported.
> 
> And we've set the restriction for scanning VPD pages rather high by
> moving it to at least SPC-3; meaning we lose out on all SPC-2 devices
> with logical block provisioning.
> 
> So rather than blacklisting each and every device (and incurring 
> loads of customer calls) I'd rather fix it once and for all.

Anything with a capacity over 2TB gets into RC16 .,. that includes a
lot of USB storage nowadays.  What would this proposed addition do to
them?

James


