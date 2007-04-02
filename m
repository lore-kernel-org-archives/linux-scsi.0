From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic94xx driver woes
Date: Mon, 02 Apr 2007 12:52:32 -0500
Message-ID: <1175536352.3680.52.camel@mulgrave.il.steeleye.com>
References: <460E90F3.9070601@torque.net> <460EA211.2060501@us.ibm.com>
	 <460EB110.8060706@torque.net>
	 <1175383041.3760.70.camel@mulgrave.il.steeleye.com>
	 <4610161D.7060709@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60364 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965550AbXDBRxB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 13:53:01 -0400
In-Reply-To: <4610161D.7060709@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2007-04-01 at 16:29 -0400, Douglas Gilbert wrote:
> ...
> sas: phy3 added to port0, phy_mask:0x8
> sas: DOING DISCOVERY on port 0, pid:2110
> aic94xx: scb:0x80 timed out

This might be the problem.

I see this periodically when a phy goes out to lunch on my system ...
with me, it always seems to be phy0 of a port containing phy0-4 ... so
phy1-3 still function to get messages.

Can you try sending a link reset to phy3?

It should be something like

echo 1 > /sys/class/sas_phy/phy-X:3/link_reset

and see if it just produces 

aic94xx: scb:0x80 timed out

Again?

Thanks,

James


