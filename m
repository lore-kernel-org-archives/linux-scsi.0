From: walt <w41ter-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Date: Sat, 18 Jan 2014 12:23:27 -0800
Message-ID: <52DAE2BF.7020208@gmail.com>
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com> <20140114172056.GB12126@xanatos> <52D5ABBD.7090202@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D45EDA3-VkEWCZq2GCInGFn1LkZF6NBPR1lH4CV8@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 01/17/2014 06:34 AM, David Laight wrote:

> Can you try the patch I posted that stops the ownership on LINK TRBs
> being changed before that on the linked-to TRB?

Please disregard my earlier post about the patch not applying cleanly.
That was the usual html corruption, so I found the original on the usb
list and it was okay.

Sadly, the patch didn't fix the ASMedia lockup behavior, however :(

I did notice that the lockup occurred only when copying *to* the usb3
drive, and not when copying from it.  I think that may be new behavior
but I can't swear to it.

Just to confirm, here are the first few lines of the patch I used.
Please let me know if it's the wrong patch:


diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 53c2e29..589d336 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2928,6 +2928,11 @@ static void queue_trb(struct xhci_hcd *xhci, struct xhci_ring *ring,
        struct xhci_generic_trb *trb;
 
        trb = &amp;ring-&gt;enqueue-&gt;generic;
+
+       field4 = (field4 &amp; ~TRB_CYCLE) | ring-&gt;cycle_state;
+       if (trb == &amp;ring-&gt;enqueue_first-&gt;generic)
+               field4 ^= TRB_CYCLE;
+
        trb-&gt;field[0] = cpu_to_le32(field1);

        <big snip>
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
