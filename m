From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Print SCSI Inquiry data more compactly
Date: Wed, 21 Jun 2006 11:33:29 -0600
Message-ID: <20060621173329.GZ1630@parisc-linux.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290B5BB@otce2k03.adaptec.com> <20060621164150.GM31472@vienna.egenera.com> <20060621165057.GW1630@parisc-linux.org> <1150909340.20655.37.camel@gator.sc.steeleye.com> <44997F73.7040903@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42882 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750962AbWFURdb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 13:33:31 -0400
Content-Disposition: inline
In-Reply-To: <44997F73.7040903@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Eddie Williams <Eddie.Williams@steeleye.com>, linux-scsi@vger.kernel.org

On Wed, Jun 21, 2006 at 01:18:43PM -0400, James Smart wrote:
> I agree with Eddie's points, with another small recommendation:
> 
> scsi <2:0:1:0> x00:HP 18.2G:ATLAS10K3_18_SCA:HP05:02:

If you want to get brackets around the 2:0:1:0, you need to talk to
jejb about getting sdev_printk changed.

> where x00 is byte 1 of the inquiry data - device type and qualifier.
> Clarifies the H:C:T:L as well.
> 
> Eddie Williams wrote:
> >Do you need the labels?  How about
> >scsi 2:0:1:0:DASD:HP 18.2G:ATLAS10K3_18_SCA:HP05:02:
> >
> >This keeps it short.  For those that are probably looking at this data
> >the labels are not needed anyway.  It is easy to parse if someone wants.
> >I used "DASD" just because that is what was referenced before.  I think
> >I would prefer the number or "direct access" but either way I would not
> >lose any sleep.

I used scsi_device_type to get the string, so "Direct Access" it is.

Worst case, we get:

scsi 2:0:1:0: Direct-Access     HP 18.2G ATLAS10K3_18_SCA HP05 ANSI ver: 01 CCS

so we're out of room unless we do one or both of:
 - ditch the "ANSI ver:"
 - print the scsi_level instead of "01 CCS"

Using colons instead of spaces to improve parsing is misleading at best;
there's nothing to stop vendors putting colons in their descriptions.
And as I said earlier, there's no need to parse this data anyway.

So we could do:

scsi 2:0:1:0: Direct-Access     xAB HP 18.2G ATLAS10K3_18_SCA HP05 Level: 03

if we really want to see the PQ.  We could even just print the PQ:

scsi 2:0:1:0: Direct-Access     7 HP 18.2G ATLAS10K3_18_SCA HP05 Level: 03

clocking in at a svelte 74 columns.
