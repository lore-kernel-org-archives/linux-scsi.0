From: "Russell Johnson" <rjohnson@rtlogic.com>
Subject: megaraid battery status questions
Date: Thu, 9 Sep 2004 08:44:05 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000701c4967b$747b7bd0$1e01a8c0@rtlogic.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eagle.rtlogic.com ([216.87.68.236]:20441 "EHLO
	eagle.rtlogic.com") by vger.kernel.org with ESMTP id S265196AbUIIOoN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Sep 2004 10:44:13 -0400
Received: from culebra (firewall.rtlogic.com [216.87.68.234])
	by eagle.rtlogic.com (Postfix) with ESMTP id F273E1CB05C
	for <linux-scsi@vger.kernel.org>; Thu,  9 Sep 2004 08:39:24 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have been using the megaraid driver on a Dell system using the PERC4 for
several months now and have noticed that /proc/megaraid/hba0/battery-status
will report errors after reading it over time.  If I reboot the system then
the battery status errors go away until I poll again.  The BIOS for the
Megaraid doesn't report battery status errors in any of the tests I have
run.  The errors I see include "low voltage" and "charge fail".  In
addition, I have seen the same "errors" across several different systems so
it isn't just a single adapter or system that is failing.

My goal is to poll for both battery status and raid status on a periodic
basis (every 5 minutes or so).  I have tried this on different kernels and
driver versions with the same result and I'm wondering if anyone else has
seen the same issue or found a solution.  I started with a 2.4.21 kernel and
tried a 2.10.x driver.  I'm currently running a 2.6.7 kernel with the 2.00.3
driver and the latest firmware I could find, dmesg reports "megaraid:
[350O:1.09]".  I have written some code similar to recent posts with the
title "megaraid megaraid2-2.10.7 causing kernel panic" and it is reporting
the same failure on all of the above setups that I have tried.  It seems
that the latest proper megaraid driver for kernel 2.6 versions might be the
2.20.3.1 version but it doesn't support the /proc files as the 2.0 and 2.10
drivers did.  I'm not sure if the new driver supports the same ioctl I'm
using or not.

With my goal to poll raid status and battery status on a periodic basis,
does anyone have ideas on what mechanism I can use?  Ioctl?  Other programs?

I have also noticed that it seems that the megaraid mailbox will not accept
new commands while the inquiry3 command is being executed.  Can anyone
verify that this is the case?  I can't find any information on the command
and its limitations.

Thanks for any help!

Russ Johnson



