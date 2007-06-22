From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Fri, 22 Jun 2007 13:34:40 +0200
Message-ID: <20070622113439.GA6015@schmichrtp.de.ibm.com>
References: <200706191025.30986.swen@vnet.ibm.com> <20070619171217.GA30099@infradead.org> <1182307586.10507.7.camel@mulgrave.il.steeleye.com> <20070621150308.GA29643@schmichrtp.de.ibm.com> <1182459492.3923.35.camel@mulgrave.il.steeleye.com> <20070622044035.GB5560@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:5963 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbXFVLfz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2007 07:35:55 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id l5MBZnYP182888
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jun 2007 11:35:49 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5MBZiqo979058
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jun 2007 13:35:49 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5MBZhRM004975
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jun 2007 13:35:44 +0200
Content-Disposition: inline
In-Reply-To: <20070622044035.GB5560@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Thu, Jun 21, 2007 at 09:40:35PM -0700, Mike Anderson wrote:
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > A proposal to display the correct form of the LUN would be useful if you
> > wish to make it? ...  The problem is really that SAM specifies a
> > possible 4 level structure with 4 possible address methods per level.
> > 
> > The well known LUNs should be simple; there are only three: Report Lun,
> > Access Controls and Target Log Pages.  The rest we really need input on.
> > For instance, I could see the vendors wishing us to combine a
> > multi-level flat addressing space into a single logical unit number,
> > whereas I could see them wanting us to supply some sort of hierarchy for
> > the peripheral and logical unit methods of addressing.
> > 
> > Since you're already using 2 level flat addressing, how do you want to
> > see that represented?
> 
> James, why would we would not want to display the lun per SAM4 4.6.2 as
> suggested by Stefan in a previous comment.

I would also agree to display the LUN in sysfs as 64 bit hex number as
advised in SAM4.

While the SAM describes different formats and addressing schemes, i
don't see how this affects the SCSI layer in the kernel. The kernel
gets the 64 bit LUNs and uses them as unique ids. 4.6.1 in SAM4 says
in the last sentence, that different values for the 64 bits represent
different LUNs, so the assumption of the LUNs being unique is
guaranteed.

My point of view is mainly from the device driver's (zfcp) and user's
point of view. It is only that the disk systems i deal with use the 2
level addressing in the LUNs. The user interface of the disk system
displays something like: Volume F000 is exported as FCP LUN 40F04000.
When the SCSI midlayer uses and exports this value in sysfs, it should
be displayed in the same format (hex).

I don't know if the multi level scheme is actually used as hierarchy
somewhere. If somebody would be interested in using this information,
i think a userspace tool could grab the value from sysfs and display
the detailed information according to SAM.

--
Christof Schmitt
