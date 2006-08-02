From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x: Report
Date: Thu, 3 Aug 2006 00:07:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0608022348570.12263@poirot.grange>
References: <44CF40F2.3080401@annessi.at> <Pine.LNX.4.60.0608020046510.8659@poirot.grange>
 <44D075A2.2080501@annessi.at> <Pine.LNX.4.60.0608021209310.5115@poirot.grange>
 <44D0BC2F.3030700@annessi.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.21]:39364 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932262AbWHBWGp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2006 18:06:45 -0400
In-Reply-To: <44D0BC2F.3030700@annessi.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Annessi <robert@annessi.at>
Cc: linux-scsi@vger.kernel.org

On Wed, 2 Aug 2006, Robert Annessi wrote:

> BUG: warning at drivers/scsi/dc395x.c:2329/data_in_phase0()
>  [<f884c768>] data_in_phase0+0x190/0x244 [dc395x]
>  [<f884c15e>] dc395x_handle_interrupt+0xf7/0x128 [dc395x]
>  [<f884c1c0>] dc395x_interrupt+0x31/0x5f [dc395x]
>  [<c0137975>] handle_IRQ_event+0x21/0x49
>  [<c0137a2e>] __do_IRQ+0x91/0xef
>  [<c0104a2f>] do_IRQ+0x43/0x50
>  [<c01032aa>] common_interrupt+0x1a/0x20

Would be interesting to find out what exactly causes these warnings. Could 
you, please, try the patch at the bottom of this email with 2.6.18-rc3 and 
see if the message it prints appears in dmesg - together with the NO_TAGQ 
warkaround and without safe=1.

> I tested with 2.6.18-rc3.
> "dd if=/dev/sda of=/dev/null bs=1M count=1024" (for read)
> "dd if=/dev/zero of=/dev/sda bs=1M count=1024" (for write)
> each 5 times (results were almost the same.. maximum difference was 0,1mb/s)
> 
> default arguments: ~37,5mb/s (read) ~37,6mb/s(write)
> safe=1: ~2,8mb/s (read) ~2,3mb/s (write)

Well, this looks much better to me. So, I think, we may say for you the 
problem is solved. Globally, I think, the reason why other drivers have no 
problems with this drive is because they are using results of the generic 
inquiry evaluation code, and it chooses better communication parameters 
than the dc395x. Would be nice to switch dc395x to do that too.

Thanks
Guennadi
---
Guennadi Liakhovetski

--- a/drivers/scsi/dc395x.c	2006-06-09 00:18:41.000000000 +0200
+++ b/drivers/scsi/dc395x.c	2006-08-02 23:42:37.000000000 +0200
@@ -2326,7 +2326,14 @@
 					}
 				}
 
-				WARN_ON((fc != 0x40) == !d_left_counter);
+				if (((fc != 0x40) && !d_left_counter) ||
+				    ((fc == 0x40) && d_left_counter &&
+				     (!(srb->dcb->sync_period & WIDE_SYNC)
+				      || d_left_counter != 1)))
+					printk(KERN_WARNING "dc395x: inconsistent counters: "
+					       "FIFOCNT %u, left %u, %s\n", fc, d_left_counter,
+					       srb->dcb->sync_period & WIDE_SYNC ?
+					       "wide" : "narrow");
 
 				if (fc == 0x40 && (srb->dcb->sync_period & WIDE_SYNC)) {
 					/* Read the last byte ... */
