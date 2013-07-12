From: Hans Verkuil <hansverk@cisco.com>
Subject: The pm80xx driver hangs in 3.10 with the Adaptec 71605H HBA
Date: Fri, 12 Jul 2013 13:02:06 +0200
Message-ID: <201307121302.06856.hansverk@cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1705 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab3GLLCi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jul 2013 07:02:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: xjtuwjp@gmail.com, lindar_liu@usish.com
Cc: linux-scsi@vger.kernel.org

Hi!

I am trying to get my Adaptec 71605H HBA to work with kernel 3.10.
Unfortunately it hangs while waiting for a completion.

After registering all the interrupts the pm8001_pci_probe() function calls
pm8001_init_sas_add(). That function calls PM8001_CHIP_DISP->get_nvmd_req()
and waits for a completion that never happens.

I tried to use the drivers available from the Adaptec website, and after
hacking them so they compiled again with 3.10 I just copied those sources
over to the kernel, recompiled and tested those. And lo and behold, that
actually worked! So the Adaptec drivers do something that the current kernel
drivers don't.

The patch I applied to the 3.10 kernel to effectively update the current
drivers with those from Adaptec is here:

http://hverkuil.home.xs4all.nl/0002-pm80xx-copy-over-adaptec-drivers.patch

The original drivers from Adaptec are here:

http://www.adaptec.com/en-us/downloads/rh/rhel_6/productid=asa-71605h&dn=adaptec+71605h.html

I tried to find relevant differences that might explain why the adaptec
version works while the current 3.10 doesn't, but nothing jumped out to
me.

It's no problem to test any patches you have, or to do some debugging if
someone can point me in the right direction.

Regards,

	Hans
