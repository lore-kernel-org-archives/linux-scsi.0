From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Fusion MPT driver fails PHP
Date: Wed, 09 Jun 2004 09:58:02 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200406090058.AA03295@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:10457 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S265490AbUFIA6X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 20:58:23 -0400
Received: from m4.gw.fujitsu.co.jp ([10.0.50.74]) by fgwmail5.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id i590wLTB001160 for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2004 09:58:21 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s4.gw.fujitsu.co.jp by m4.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id i590wH4x000776 for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2004 09:58:17 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail503.fjmail.jp.fujitsu.com (fjmail503-0.fjmail.jp.fujitsu.com [10.59.80.100]) by s4.gw.fujitsu.co.jp (8.12.11)
	id i590wHsr005937 for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2004 09:58:17 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan503-0.fjmail.jp.fujitsu.com [10.59.80.124])
 by fjmail503.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HZ000M1RO14AV@fjmail503.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Wed,  9 Jun 2004 09:58:17 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I tested PHP using LSI22320-R, but it ended up with failure.
I locally talked with Eric Moore, but I wanted to hear your opinion, I mailed
this problem to ML.

Our Environment:
 Host: Intel Tiger4(lk 2.6.6)
 SCSI Card: LSI22320-R(Fusion MPT driver 3.01.05)

When I remove LSI22320-R by latch operation, Fusion MPT driver tries to issue
some message to adapter for synchronize cache operation, but the reply message
doesn't return and it causes timeout.
I think the cause of this problem is remove operation is called in interrupt
by latch.
I think we shouldn't issue any message to adapter during this remove operation.
And I think the synchronzize cache operation should be activated from upper 
layer.

Following is the sequence to timeout.
    :
  device_detach_shutdown()
    if (dev->driver && dev->driver->shutdown)
      dev->driver->shutdown(dev);
        V
  mptbase_shutdown()
    MptDeviceDriverHandlers[ii]->shutdown) {
      MptDeviceDriverHandlers[ii]->shutdown(dev);
        V
  mptscsih_shutdown()
    if(hd != NULL)
      mptscsih_synchronize_cache(hd, 0);
        V
   mptscsih_synchronize_cache()
     mpt_config(hd->ioc, &cfg); <- This function doesn't response.

Masao Fukuchi
