From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Mon, 25 Jun 2007 12:39:09 +0200
Message-ID: <200706251239.09755.swen@vnet.ibm.com>
References: <200706191025.30986.swen@vnet.ibm.com> <20070622044035.GB5560@us.ibm.com> <1182521500.3923.49.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:63807 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbXFYKjh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2007 06:39:37 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.8/8.13.8) with ESMTP id l5PAdVe4379148
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jun 2007 10:39:31 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5PAdV5g1601542
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jun 2007 12:39:31 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5PAdUma031675
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jun 2007 12:39:30 +0200
In-Reply-To: <1182521500.3923.49.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

On Friday 22 June 2007 16:11, James Bottomley wrote:
> On Thu, 2007-06-21 at 21:40 -0700, Mike Anderson wrote:
> > James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > > A proposal to display the correct form of the LUN would be useful if you
> > > wish to make it? ...  The problem is really that SAM specifies a
> > > possible 4 level structure with 4 possible address methods per level.
> > > 
> > > The well known LUNs should be simple; there are only three: Report Lun,
> > > Access Controls and Target Log Pages.  The rest we really need input on.
> > > For instance, I could see the vendors wishing us to combine a
> > > multi-level flat addressing space into a single logical unit number,
> > > whereas I could see them wanting us to supply some sort of hierarchy for
> > > the peripheral and logical unit methods of addressing.
> > > 
> > > Since you're already using 2 level flat addressing, how do you want to
> > > see that represented?
> > 
> > James, why would we would not want to display the lun per SAM4 4.6.2 as
> > suggested by Stefan in a previous comment.
> 
> Because in a two LUN system, what was LUN 1 would then become LUN
> 0x1000000000000 which looks a bit unpalatable.
> 
> James
> 
> 
> -

Despite the issue whether we should display and/or use (sysfs !?)
full blown 64bit values, so with leading zeros, you still have the option to display, 
for the single level addressing, the LUN as a 2 byte value as described in  SAM4 4.6.2. 
So for your example this would be 0x0001 or 0x1, which is exactly what you'd like to see, right ?
Only for 2+ level environment the 64bit representation comes into the play.

And, because you were asking how we'd like that to be represented, I personally prefer
a full blown 64bit hex value with leading zeros.
It makes the comparison to internal structures/models easier and gets us a bit closer
to the documented (SAM4) standard.
...and I think we all can deal with a few extra digits being displayed.

Cheers Swen
