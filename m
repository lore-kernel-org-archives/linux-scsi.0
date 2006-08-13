From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: scsi_host_template.emulated and bridging devices
Date: Sun, 13 Aug 2006 15:36:06 +0200
Message-ID: <44DF2AC6.1060201@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39057 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751244AbWHMNhH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Aug 2006 09:37:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dougg@torque.net>

Hi,

the sbp2 driver currently sets the host template's "emulated" flag to 1. 
This is not true for the driver or protocol though.

Of course almost all available SBP-2 devices contain bridges to PATA or 
SATA; therefore they "emulate SCSI" i.e. translate SCSI commands. (But 
the sbp2 "host" itself doesn't.)

There are also SBP-2 bridges to SPI but these are rarely used nowadays. 
I suppose SBP-2 to SPI bridges are mere bus bridges without command set 
translation. I don't know if there are any native SBP-2 devices. 
FireWire scanners might be native.

The only driver which evaluates the "emulated" flag is the sg driver but 
I don't know for what purposes.

My question: Should sbp2 set "emulated" to 0?
-- 
Stefan Richter
-=====-=-==- =--- -==-=
http://arcgraph.de/sr/
