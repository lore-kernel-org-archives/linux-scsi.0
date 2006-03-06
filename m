From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Mon, 06 Mar 2006 13:30:32 -0500
Message-ID: <440C7FC8.8050000@torque.net>
References: <20060303101420.78398.qmail@web31806.mail.mud.yahoo.com> <1141399404.3928.5.camel@mulgrave.il.steeleye.com> <440867B7.70703@s5r6.in-berlin.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:457 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1752390AbWCFSbu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Mar 2006 13:31:50 -0500
In-Reply-To: <440867B7.70703@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, ltuikov@yahoo.com, "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Stefan Richter wrote:
> James Bottomley wrote:
> 
>>Assuming the cages are all powered up, which is beyond
>>the driver control, then serialising the scan will allow one to
>>specify /dev/sda1 deterministically for root.
> 
> 
> Does SAS provide a persistent globally unique property of a device, or
> has SAS to rely on bus topology to uniqely identify devices?

That swings on what you mean by "device" but broadly:
Yes to the first part, but ... SAS is a transport and
SAS transport endpoints (i.e. "ports") have naa-5
world wide unique identifiers. That might sound great
but most SAS disks are dual ported, so that gives two
SAS (i.e. naa-5) addresses (typically consecutive).
A dual ported SAS disk could/should have up to
4 naa-5 addresses:
  - one for SAS port 1 (primary)
  - one for SAS port 2 (secondary)
  - one for the target device
  - and, one for the logical unit

A SAS (target) device might also be a bridge, for
example, as found in SAS expanders that support SATA
devices. SATA disks do not yet have mandated world
wide unique addresses (but provision has been made for
a naa-5 address). The SAS "port" address of a SATA
disk is actually the bridge it is plugged into (but
one could switch SATA disks).

I suspect what you would really like to identify uniquely
is the logical unit. Fuzziness remains due to the
possibility of bridges.

Doug Gilbert
