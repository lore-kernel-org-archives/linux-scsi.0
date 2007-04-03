From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic94xx driver woes
Date: Mon, 02 Apr 2007 19:37:32 -0500
Message-ID: <1175560652.3680.92.camel@mulgrave.il.steeleye.com>
References: <460E90F3.9070601@torque.net> <460EA211.2060501@us.ibm.com>
	 <460EB110.8060706@torque.net>
	 <1175383041.3760.70.camel@mulgrave.il.steeleye.com>
	 <4610161D.7060709@torque.net>
	 <1175536352.3680.52.camel@mulgrave.il.steeleye.com>
	 <46119396.3070008@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35302 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966125AbXDCAhh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 20:37:37 -0400
In-Reply-To: <46119396.3070008@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2007-04-02 at 19:36 -0400, Douglas Gilbert wrote:
> > echo 1 > /sys/class/sas_phy/phy-X:3/link_reset
> > 
> > and see if it just produces 
> > 
> > aic94xx: scb:0x80 timed out
> 
> Yes it does.
> 
> > Again?
> 
> It is repeatable.
> 
> Also when I connect to phy 0 it works (both direct
> connect and expander). However phys 1 and 2 react
> like phy 3 shown above.

OK, well, I know what it is, I just don't know how to fix it.

On certain error conditions, whatever controls the phy SCB processing
seems to freeze to a particular phy.  With me, it's externally induced
(an expander->expander->satapi configuration).  I can recover my system
by powering off and on the expander setup.

Whatever this condition is, it blows away all error recovery, since
they're also done via means of ascbs, so any error recovery ascbs also
get stuck until they timeout.  Someone with the specs needs to look and
see if there's a way we can kick the phy queue (or whatever queue it's
stuck in)---I'm assuming it's a phy queue because I can get packets out
via other phys, just nothing via the stuck one.

James


