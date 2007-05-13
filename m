From: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Sun, 13 May 2007 19:26:31 +0100
Message-ID: <46475857.4010509@simon.arlott.org.uk>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>	 <20070513160608.GA29024@redhat.com>	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>	 <Pine.LNX.4.64.0705131216440.27468@localhost.localdomain>	 <1179073670.3723.48.camel@mulgrave.il.steeleye.com>	 <46474E1A.6080904@simon.arlott.org.uk> <1179078537.3723.53.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxima.lp0.eu ([85.158.45.36]:43265 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbXEMS0j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 May 2007 14:26:39 -0400
In-Reply-To: <1179078537.3723.53.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On 13/05/07 18:48, James Bottomley wrote:
> On Sun, 2007-05-13 at 18:42 +0100, Simon Arlott wrote:
>>> If you set CONFIG_MODULE=y and build SCSI we assume you could have a
>>> SCSI driver module at some point, which would necessitate the wait scan
>>> module.
>> This should be implemented like "Library routines" and only added if such 
>> a SCSI driver module is actually selected. Why can't it at least be a 
>> visible option in the menu? (Although even then it looks like it's 
>> impossible to disable).
> 
> There's out of tree modules to consider.

Ok, I propose we make dozens of modules default 'm' in case an out of 
tree module requires it.

SCSI_SCAN_ASYNC ("Asynchronous SCSI scanning"): "You can load the 
scsi_wait_scan module to ensure that all scans have completed."

It looks like SCSI_WAIT_SCAN is pointless unless SCSI_SCAN_ASYNC 
is selected - so it should depend on it:

---
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e62d23f..0f6c370 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -244,7 +244,7 @@ config SCSI_SCAN_ASYNC
 config SCSI_WAIT_SCAN
 	tristate
 	default m
-	depends on SCSI
+	depends on SCSI_SCAN_ASYNC
 	depends on MODULES
 
 menu "SCSI Transports"


-- 
Simon Arlott
