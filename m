From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Need insight into aic94xx driver code
Date: Sat, 08 Jul 2006 11:19:51 -0500
Message-ID: <1152375591.12020.18.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:26789 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964889AbWGHQTy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 12:19:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

One of the things I discovered while debugging the code is that there's
a race condition setting the per connection DDB phy mask for a wide
port.  If the wide port forms after discover, then the DDB phy mask is
set to a single port and always remains so.  If the wide port forms
before discovery, then the DDB phy mask is correctly set to all phys in
the port.

When the wide port forms after discovery, what happens is that the DDB
sequencer code adds the phy in asd_update_port_links.  However, the
initial per connection DDBs never get updated ... is this correct? (I
can't really tell, because the DDB code is deep magic within the
driver).

The driver doesn't even have a port_deform callback, so it never acts on
phys being removed from the port, so I think someone needs to add phy
removal from a port functionality to the driver (unless it's lurking
somewhere I didn't find).

Thanks,

James


