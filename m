From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: how to use scsi_remove_device
Date: Fri, 17 Mar 2006 21:30:55 +0100
Message-ID: <441B1C7F.2090605@s5r6.in-berlin.de>
References: <1142598225.25906.256865850@webmail.messagingengine.com> <441B1388.20704@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:14214 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932069AbWCQUfZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Mar 2006 15:35:25 -0500
In-Reply-To: <441B1388.20704@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mark Haverkamp <markh@osdl.org>, Eric Moore <Eric.Moore@lsil.com>, Leon Woestenberg <leonw@mailcan.com>

Hi all,

the following drivers use [__]scsi_add_device/ scsi_remove_device:

drivers/ieee1394/sbp2.c
drivers/message/i2o/i2o_scsi.c
drivers/message/fusion/mptsas.c
drivers/scsi/aacraid/commsup.c
drivers/scsi/ipr.c

Sbp2 calls scsi_add_device + scsi_remove_device.
I2o_scsi calls __scsi_add_device + scsi_remove_device + scsi_device_put.
Ipr calls scsi_add_device + scsi_device_get + scsi_remove_device + 
scsi_device_put.

But aacraid and mptsas call scsi_add_device + scsi_remove_device + 
scsi_device_put. AFAICS this is either one scsi_device_put too many or 
one scsi_device_get too few.

(I am looking at Linus' tree.)
-- 
Stefan Richter
-=====-=-==- --== =---=
http://arcgraph.de/sr/
