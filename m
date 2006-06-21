From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Print SCSI Inquiry data more compactly
Date: Thu, 22 Jun 2006 00:36:02 +0200
Message-ID: <4499C9D2.5090103@s5r6.in-berlin.de>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290B5BB@otce2k03.adaptec.com> <20060621164150.GM31472@vienna.egenera.com> <20060621165057.GW1630@parisc-linux.org> <1150909340.20655.37.camel@gator.sc.steeleye.com> <44997F73.7040903@emulex.com> <20060621173329.GZ1630@parisc-linux.org> <44998A34.20202@s5r6.in-berlin.de> <20060621190327.GB1630@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:1749 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1030334AbWFUWgp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 18:36:45 -0400
In-Reply-To: <20060621190327.GB1630@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Smart <James.Smart@Emulex.Com>, Eddie Williams <Eddie.Williams@steeleye.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Jun 21, 2006 at 08:04:36PM +0200, Stefan Richter wrote:
>> What is wrong with the current two-line format?
> 
> Several things.  The way that it's printed means that simultaneous scans
> lead to the output getting garbled.

That's true, but it could be implemented as an atomic operation with 
multiple printks nonetheless. However you are right, layout should not 
be a reason to add locks. Make it one printk, but please keep it 
readable. The inquiry printout is one of the few that people actually 
care for.

> You're exaggerating.

On purpose. :-)

> BTW, here's what a line would look like from sbp2 ...
> 
> scsi 9:0:0:0: CD-ROM            MATSHITA  UJDA730 DVD/CDRW  1.00 Level: 0 

Here is another SBP-2 device:
    Vendor: ST340083  Model: 2A                Rev: 3.01
    Type:   Direct-Access-RBC                  ANSI SCSI revision: 04

This may be misleading if "Vendor:" and "Model:" prefixes are stripped.

> btw, I've always found that "CD-ROM" a little confusing; considering
> that SPC4 says "CD/DVD device", any objections to changing that string
> to say "CD/DVD" instead of "CD-ROM"?

Seems reasonable.
-- 
Stefan Richter
-=====-=-==- -==- =-==-
http://arcgraph.de/sr/
