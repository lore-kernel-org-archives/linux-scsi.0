From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: Return -EINVAL when "id == max_id" in scsi_scan_host_selected()
Date: Mon, 22 May 2006 19:16:19 -0600
Message-ID: <20060523011619.GG4093@parisc-linux.org>
References: <1148080489.23417.18.camel@amitarora.in.ibm.com> <20060520042132.GC2826@parisc-linux.org> <1148108792.13190.36.camel@amitarora.in.ibm.com> <1148345675.3320.77.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:13735 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750726AbWEWBQV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 21:16:21 -0400
Content-Disposition: inline
In-Reply-To: <1148345675.3320.77.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Amit Arora <aarora@in.ibm.com>, linux-scsi@vger.kernel.org, patmans@us.ibm.com

On Mon, May 22, 2006 at 07:54:35PM -0500, James Bottomley wrote:
> Actually, we've got another cockup here with drivers: some have set this
> to 8 or 16 and others to 7 or 15.  If we apply this without auditing
> them, for those who set it to 7 or 15, the last target will end up
> inaccessible.

So as scsi maintainer, what's your preference for the 'right way' to fix
this?  Clearly a whole-scale driver audit is needed, so my preference is
to rename the variable (how about id_limit?) and then do a sweep
checking that everybody's using it correctly.

Then we need to do a similar check for max_lun and max_channel.  As far
as conventions go, I think we should use 8 and 16; it's just so much
more natural to write 'for (id = 0; id < id_limit; id++)'.
