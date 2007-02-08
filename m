From: "Fajun Chen" <fajunchen@gmail.com>
Subject: Time Measurement in SG
Date: Thu, 8 Feb 2007 16:32:43 -0700
Message-ID: <8202f4270702081532y583443d1m7bd36161a19631d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.226]:27220 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161064AbXBHXco (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 18:32:44 -0500
Received: by nz-out-0506.google.com with SMTP id s1so629978nze
        for <linux-scsi@vger.kernel.org>; Thu, 08 Feb 2007 15:32:44 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

The command duration is measured in sg.c using
jiffies_to_msecs(jiffies).  The HZ set up in my ARM system is 100, so
this time measurement can only provide resolution of 10ms (or +/-
5ms).  Since the AT commands in sequential read mode can be as fast as
about 1ms, this inaccuracy could easily add up.  Do we need to
increase the time resolution to at least 100us (i.e, 1/10th of 1ms)?

SG duration is measured at the sg level which is still several layers
above LLD, so SG duration may not be quite close to device time spent
on each command. Is there any other way to get more accurate
measurement of command duration on the device?

Thanks,
Fajun
