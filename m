From: Lester Hightower <hightowe@10east.com>
Subject: Fix for memory leak problem in megaraid2.c /proc entries (fwd)
Date: Thu, 8 Apr 2004 11:29:20 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404081126480.9356@les5.10east.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from docs1.10east.com ([63.238.77.220]:51101 "EHLO 10east.com")
	by vger.kernel.org with ESMTP id S262026AbUDHP3X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2004 11:29:23 -0400
Received: from les5.progressive-comp.com (les5.progressive-comp.com [63.238.77.104])
	by 10east.com (8.12.10/8.12.8) with ESMTP id i38FTKud000496
	for <linux-scsi@vger.kernel.org>; Thu, 8 Apr 2004 11:29:20 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Based on this auto-response:

| Date: Thu, 08 Apr 2004 10:23:01 -0500
| From: linux-megaraid-devel-admin@lists.us.dell.com
| To: DEVNULL@10east.com
| Subject: Auto-response for your message to linux-megaraid-devel@dell.com
|
| The linux-megaraid-devel@dell.com mailing list has been discontinued.
| Please redirect your message to either:
|
| linux-scsi@vger.kernel.org  for all megaraid-specific issues
| (subscribe at http://vger.kernel.org/vger-lists.html#linux-scsi)
|
| or
|
| linux-poweredge@dell.com  for all Dell PowerEdge-specific issues
| (subscribe at http://lists.us.dell.com)


I am forwarding this email to linux-scsi@vger.kernel.org:

---------- Forwarded message ----------
Date: Thu, 8 Apr 2004 11:22:36 -0400 (EDT)
From: Lester Hightower <hightowe@10east.com>
To: linux-megaraid-devel@dell.com
Subject: Fix for memory leak problem in megaraid2.c /proc entries

This diff fixes a memory leak in megaraid2.c, v2.10.1 (Dec 03, 2003):

[root@10east scsi]# diff megaraid2.c.MEMORY_LEAK.20040408.lhh megaraid2.c
3395c3395,3399
<       if( channel >= max_channels ) return 0;
---
>       if( channel >= max_channels ) {
>               pci_free_consistent(pdev, 256, scsi_inq, scsi_inq_dma_handle);
>               mega_free_inquiry(inquiry, dma_handle, pdev);
>               return 0;
>         }

I have shared it with the proper folks (Atul Mukker) at LSI, so it will
likely (hopefully) make it into newer driver versions/newer kernels.

The problem occurs only in the circumstance where one reads one of the
/proc/megaraid/hba<X>/diskdrives-ch<N> files where the card <X> does not
have channel <N> on it.  Most people would likely not notice this leak in
normal operation, but due to the way that we monitor our MegaRaid cards in
our company (we read these /proc entries every 180s) so we found the leak
rather quickly, and unpleasantly (when your kernel eats all your RAM).

--
Lester H. Hightower <__h+i_g+h_t+o_w+e__@__10east.com>
Chief Technology Officer, 10 East Corp.

p.s. my_email_addrs =~ s/[_+]/g to email me...
