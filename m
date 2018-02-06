From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH/RFC 3/6] usb: gadget: Add NO_DMA dummies for DMA mapping API
Date: Tue,  6 Feb 2018 11:14:49 +0100
Message-ID: <1517912092-15470-4-git-send-email-geert@linux-m68k.org>
References: <1517912092-15470-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1517912092-15470-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Add dummies for usb_gadget_{,un}map_request{,_by_dev}(), to allow
compile-testing if NO_DMA=y.

This prevents the following from showing up later:

    ERROR: "usb_gadget_unmap_request_by_dev" [drivers/usb/renesas_usbhs/renesas_usbhs.ko] undefined!
    ERROR: "usb_gadget_map_request_by_dev" [drivers/usb/renesas_usbhs/renesas_usbhs.ko] undefined!
    ERROR: "usb_gadget_map_request" [drivers/usb/mtu3/mtu3.ko] undefined!
    ERROR: "usb_gadget_unmap_request" [drivers/usb/mtu3/mtu3.ko] undefined!
    ERROR: "usb_gadget_map_request" [drivers/usb/gadget/udc/renesas_usb3.ko] undefined!
    ERROR: "usb_gadget_unmap_request" [drivers/usb/gadget/udc/renesas_usb3.ko] undefined!

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
---
 include/linux/usb/gadget.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 66a5cff7ee142d6a..b68e7f9b210be122 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -805,6 +805,7 @@ int usb_otg_descriptor_init(struct usb_gadget *gadget,
 
 /* utility to simplify map/unmap of usb_requests to/from DMA */
 
+#ifdef	CONFIG_HAS_DMA
 extern int usb_gadget_map_request_by_dev(struct device *dev,
 		struct usb_request *req, int is_in);
 extern int usb_gadget_map_request(struct usb_gadget *gadget,
@@ -814,6 +815,17 @@ extern void usb_gadget_unmap_request_by_dev(struct device *dev,
 		struct usb_request *req, int is_in);
 extern void usb_gadget_unmap_request(struct usb_gadget *gadget,
 		struct usb_request *req, int is_in);
+#else /* !CONFIG_HAS_DMA */
+static inline int usb_gadget_map_request_by_dev(struct device *dev,
+		struct usb_request *req, int is_in) { return -ENOSYS; }
+static inline int usb_gadget_map_request(struct usb_gadget *gadget,
+		struct usb_request *req, int is_in) { return -ENOSYS; }
+
+static inline void usb_gadget_unmap_request_by_dev(struct device *dev,
+		struct usb_request *req, int is_in) { }
+static inline void usb_gadget_unmap_request(struct usb_gadget *gadget,
+		struct usb_request *req, int is_in) { }
+#endif /* !CONFIG_HAS_DMA */
 
 /*-------------------------------------------------------------------------*/
 
-- 
2.7.4
