From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Print SCSI Inquiry data more compactly
Date: Wed, 21 Jun 2006 13:03:27 -0600
Message-ID: <20060621190327.GB1630@parisc-linux.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290B5BB@otce2k03.adaptec.com> <20060621164150.GM31472@vienna.egenera.com> <20060621165057.GW1630@parisc-linux.org> <1150909340.20655.37.camel@gator.sc.steeleye.com> <44997F73.7040903@emulex.com> <20060621173329.GZ1630@parisc-linux.org> <44998A34.20202@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33169 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932666AbWFUTD2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 15:03:28 -0400
Content-Disposition: inline
In-Reply-To: <44998A34.20202@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Smart <James.Smart@Emulex.Com>, Eddie Williams <Eddie.Williams@steeleye.com>, linux-scsi@vger.kernel.org

On Wed, Jun 21, 2006 at 08:04:36PM +0200, Stefan Richter wrote:
> Matthew Wilcox wrote:
> >On Wed, Jun 21, 2006 at 01:18:43PM -0400, James Smart wrote:
> >>scsi <2:0:1:0> x00:HP 18.2G:ATLAS10K3_18_SCA:HP05:02:
> >>Eddie Williams wrote:
> >>>scsi 2:0:1:0:DASD:HP 18.2G:ATLAS10K3_18_SCA:HP05:02:
> >scsi 2:0:1:0: Direct-Access     HP 18.2G ATLAS10K3_18_SCA HP05 ANSI ver: 
> >01 CCS
> >scsi 2:0:1:0: Direct-Access     xAB HP 18.2G ATLAS10K3_18_SCA HP05 Level: 
> >03
> >scsi 2:0:1:0: Direct-Access     7 HP 18.2G ATLAS10K3_18_SCA HP05 Level: 03
> 
> All of these hurt eyes. What is wrong with the current two-line format?

Several things.  The way that it's printed means that simultaneous scans
lead to the output getting garbled.  Also, when doing simultaneous scans,
it's no longer clear (was it ever?) which device a particular scan message
belongs to.  That argues for attaching the scsi bus ID to the printk, and
making it all one line, and as atomic as possible.  James tells me that
having the PQ number included helps determine problems with multipathing.

> One line too many? What about silencing protocol drivers first? sd puts 
> out a lot of lines right after those inquiry data. What's more, sd is 
> forced by some upper layer to go through the initialization twice, 
> therefore sd sees fit to print its stuff out twice. This is where I see 
> potential to reduce log noise.

There's a lot of places SCSI is too verbose.  I intend to address all of
them eventually; having hundreds of SCSI devices is really no fun right
now.  That cause isn't helped by people placing spurious roadblocks in
the way.

> Highly cryptic log messages on the other hand are about as valuable as 
> _no_ log messages at all. The lines I quoted above are not far from 
> white noise.

You're exaggerating.  BTW, here's what a line would look like from sbp2 ...

scsi 9:0:0:0: CD-ROM            MATSHITA  UJDA730 DVD/CDRW  1.00 Level: 0 

btw, I've always found that "CD-ROM" a little confusing; considering
that SPC4 says "CD/DVD device", any objections to changing that string
to say "CD/DVD" instead of "CD-ROM"?
