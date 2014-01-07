From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst
Date: Mon, 6 Jan 2014 16:31:57 -0800
Message-ID: <20140107003157.GA7963@xanatos>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218211220.412278148@linuxfoundation.org>
 <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos>
 <52C6D9F1.9000709@gmail.com>
 <20140103195455.GA4193@xanatos>
 <52C729CE.9050307@gmail.com>
 <20140103232929.GD4193@xanatos>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140103232929.GD4193@xanatos>
Sender: linux-kernel-owner@vger.kernel.org
To: walt <w41ter@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 03, 2014 at 03:29:29PM -0800, Sarah Sharp wrote:
> On Fri, Jan 03, 2014 at 01:21:18PM -0800, walt wrote:
> > I'm so sorry Sarah, that was another mistake.  The mistake is so stupid I'm not
> > going to publish it here :(
> > 
> > Once I finally ran the kernel with debugging actually compiled in, dmesg contains
> > xhci debugging messages.  Wow :)
> > 
> > It's a big file so I zipped and attached it, which I hope is acceptable in lkml.
> 
> Yep, that's fine.  Sticking it in pastebin (or up on your server) is
> also fine, if it gets really big.
> 
> > BTW, this dmesg is from a kernel with sg_tablesize = 31, which as I said before
> > doesn't fix the problem.  The cp stopped around 7GB just as before.
> > 
> > Sorry for the noise...
> 
> No worries! :)  With the dmesg, I can finally see what happened:
> 
> [  188.703059] xhci_hcd 0000:03:00.0: Cancel URB ffff8800b7d2e0c0, dev 1, ep 0x2, starting at offset 0xbb7b9000
> [  188.703072] xhci_hcd 0000:03:00.0: // Ding dong!
> [  193.711022] xhci_hcd 0000:03:00.0: xHCI host not responding to stop endpoint command.
> [  193.711029] xhci_hcd 0000:03:00.0: Assuming host is dying, halting host.
> [  193.711046] xhci_hcd 0000:03:00.0: // Halt the HC
> [  193.711060] xhci_hcd 0000:03:00.0: Killing URBs for slot ID 1, ep index 0
> [  193.711066] xhci_hcd 0000:03:00.0: Killing URBs for slot ID 1, ep index 2
> [  193.711078] xhci_hcd 0000:03:00.0: Killing URBs for slot ID 1, ep index 3
> [  193.711096] xhci_hcd 0000:03:00.0: Calling usb_hc_died()
> [  193.711103] xhci_hcd 0000:03:00.0: HC died; cleaning up
> [  193.711116] xhci_hcd 0000:03:00.0: xHCI host controller is dead.
> 
> It seems that the xHCI driver tried to stop the endpoint ring in order
> to cancel a SCSI transfer, and the driver never got a response for that.
> 
> The offset is rather suspicious (0xbb7b9000), and it probably means the
> driver attempted to cancel a transfer that had been moved to the
> beginning of the ring segment, with no-op TRBs before the link TRB.
> 
> I suspect David's patch triggers a bug in the command cancellation code.
> There's also the unlikely possibility that the no-op TRBs did indeed
> cause the host to hang.  Either way, I'll have to look into it.
> 
> I'll let you know when I have some diagnostic patches ready.

Hi Walt,

I have a couple of patches for you to test.  You can either apply the
attached three patches, or you can pull down a kernel with:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/sarah/xhci.git -b 3.12-td-fragment-failure

Please only apply the first patch (which is diagnostic only), trigger
your issue, and send me the resulting dmesg.  Then try applying the
other two patches, and see if the issue goes away.  (I suspect it won't
but I can't be sure.)

Sarah Sharp

--x+6KMIRAuhnl3hBn
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-TD-fragment-debugging.patch"

>From 0261dcd2711c010d786dcd940803a44e1bc19512 Mon Sep 17 00:00:00 2001
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date: Mon, 6 Jan 2014 16:06:27 -0800
Subject: [PATCH 1/3] TD fragment debugging

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 55fc0c39b7e1..d05f61dc8359 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -982,6 +982,14 @@ void xhci_stop_endpoint_command_watchdog(unsigned long arg)
 		 * doesn't touch the memory.
 		 */
 	}
+
+	xhci_dbg(xhci, "Command ring:\n");
+	xhci_debug_ring(xhci, xhci->cmd_ring);
+	xhci_dbg_ring_ptrs(xhci, xhci->cmd_ring);
+	xhci_dbg(xhci, "Event ring:\n");
+	xhci_debug_ring(xhci, xhci->event_ring);
+	xhci_dbg_ring_ptrs(xhci, xhci->event_ring);
+
 	for (i = 0; i < MAX_HC_SLOTS; i++) {
 		if (!xhci->devs[i])
 			continue;
@@ -1003,6 +1011,12 @@ void xhci_stop_endpoint_command_watchdog(unsigned long arg)
 				xhci_giveback_urb_in_irq(xhci, cur_td,
 						-ESHUTDOWN, "killed");
 			}
+			if (!list_empty(&temp_ep->cancelled_td_list)) {
+				xhci_dbg(xhci, "Dev %i Ep 0x%x:\n", i,
+						xhci_get_endpoint_address(j));
+				xhci_debug_ring(xhci, ring);
+				xhci_dbg_ring_ptrs(xhci, ring);
+			}
 			while (!list_empty(&temp_ep->cancelled_td_list)) {
 				cur_td = list_first_entry(
 						&temp_ep->cancelled_td_list,
@@ -2966,6 +2980,10 @@ static int prepare_ring(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
 						num_trbs, TRBS_PER_SEGMENT - 1);
 				return -ENOMEM;
 			}
+			xhci_dbg(xhci, "Insert no-op TRBs at 0x%llx\n",
+					(unsigned long long)
+					xhci_trb_virt_to_dma(ep_ring->enq_seg,
+						ep_ring->enqueue));
 
 			nop_cmd = cpu_to_le32(TRB_TYPE(TRB_TR_NOOP) |
 					ep_ring->cycle_state);
-- 
1.8.3.3


--x+6KMIRAuhnl3hBn
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-xhci-Avoid-infinite-loop-when-sg-urb-requires-too-ma.patch"

>From 380071d6fa2430c7141faefc8acfc0909c75a0ed Mon Sep 17 00:00:00 2001
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 6 Jan 2014 03:16:32 +0000
Subject: [PATCH 2/3] xhci: Avoid infinite loop when sg urb requires too many
 trbs

Currently prepare_ring() returns -ENOMEM if the urb won't fit into a
single ring segment.  usb_sg_wait() treats this error as a temporary
condition and will keep retrying until something else goes wrong.

The number of retries should be limited in usb_sg_wait(), but also
prepare_ring() should not return an error code that suggests it might
be worth retrying.  Change it to -EINVAL.

Reported-by: jidanni@jidanni.org
References: http://bugs.debian.org/733907
Fixes: 35773dac5f86 ('usb: xhci: Link TRB must not occur within a USB payload burst')
Cc: stable <stable@vger.kernel.org> # 3.12
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index d05f61dc8359..2afaf15009e8 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2978,7 +2978,7 @@ static int prepare_ring(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
 			if (num_trbs >= TRBS_PER_SEGMENT) {
 				xhci_err(xhci, "Too many fragments %d, max %d\n",
 						num_trbs, TRBS_PER_SEGMENT - 1);
-				return -ENOMEM;
+				return -EINVAL;
 			}
 			xhci_dbg(xhci, "Insert no-op TRBs at 0x%llx\n",
 					(unsigned long long)
-- 
1.8.3.3


--x+6KMIRAuhnl3hBn
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0003-xhci-Set-scatter-gather-limit-to-avoid-failed-block-.patch"

>From c463a2dec054a5b5f3bc48c1e979dfa5d7cfabfa Mon Sep 17 00:00:00 2001
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date: Mon, 6 Jan 2014 13:07:03 -0800
Subject: [PATCH 3/3] xhci: Set scatter-gather limit to avoid failed block
 writes.

Commit 35773dac5f862cb1c82ea151eba3e2f6de51ec3e "usb: xhci: Link TRB
must not occur within a USB payload burst" attempted to fix an issue
found with USB ethernet adapters, and inadvertently broke USB storage
devices.  The patch attempts to ensure that transfers never span a
segment, and rejects transfers that have more than 63 entries (or
possibly less, if some entries cross 64KB boundaries).

usb-storage limits the maximum transfer size to 120K, and we had assumed
the block layer would pass a scatter-gather list of 4K entries,
resulting in no more than 31 sglist entries:

http://marc.info/?l=linux-usb&m=138498190419312&w=2

That assumption was wrong, since we've seen the driver reject a write
that was 218 sectors long (of probably 512 bytes each):

Jan  1 07:04:49 jidanni5 kernel: [  559.624704] xhci_hcd 0000:00:14.0: Too many fragments 79, max 63
...
Jan  1 07:04:58 jidanni5 kernel: [  568.622583] Write(10): 2a 00 00 06 85 0e 00 00 da 00

Limit the number of scatter-gather entries to half a ring segment.  That
should be margin enough in case some entries cross 64KB boundaries.
Increase the number of TRBs per segment from 64 to 256, which should
result in ring segments fitting on a 4K page.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 drivers/usb/host/xhci.c | 4 ++--
 drivers/usb/host/xhci.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index ed6c186a5393..d834278c7540 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4724,8 +4724,8 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 	struct device		*dev = hcd->self.controller;
 	int			retval;
 
-	/* Accept arbitrarily long scatter-gather lists */
-	hcd->self.sg_tablesize = ~0;
+	/* Limit the block layer scatter-gather lists to half a segment. */
+	hcd->self.sg_tablesize = TRBS_PER_SEGMENT / 2;
 
 	/* support to build packet from discontinuous buffers */
 	hcd->self.no_sg_constraint = 1;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index ed3a425de8ce..6b3164c75c98 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1262,7 +1262,7 @@ union xhci_trb {
  * since the command ring is 64-byte aligned.
  * It must also be greater than 16.
  */
-#define TRBS_PER_SEGMENT	64
+#define TRBS_PER_SEGMENT	256
 /* Allow two commands + a link TRB, along with any reserved command TRBs */
 #define MAX_RSVD_CMD_TRBS	(TRBS_PER_SEGMENT - 3)
 #define TRB_SEGMENT_SIZE	(TRBS_PER_SEGMENT*16)
-- 
1.8.3.3


--x+6KMIRAuhnl3hBn--
