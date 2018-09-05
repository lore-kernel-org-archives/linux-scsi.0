From: Randy Dunlap <rd.dunlab@gmail.com>
Subject: [PATCH v4 1/5] FireWire: clean up firewire-cdev.h kernel-doc
Date: Tue,  4 Sep 2018 17:02:21 -0700
Message-ID: <20180905000225.10733-2-rd.dunlab@gmail.com>
References: <20180905000225.10733-1-rd.dunlab@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180905000225.10733-1-rd.dunlab@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: Jonathan Corbet <corbet@lwn.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Clean up kernel-doc warnings in <linux/firewire-cdev.h> so that
it can be added to a Firewire/IEEE 1394 driver-api chapter
without adding lots of noisy warnings to the documentation build.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: linux-doc@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 include/uapi/linux/firewire-cdev.h |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- linux-next-20180904.orig/include/uapi/linux/firewire-cdev.h
+++ linux-next-20180904/include/uapi/linux/firewire-cdev.h
@@ -47,11 +47,11 @@
 #define FW_CDEV_EVENT_ISO_INTERRUPT_MULTICHANNEL	0x09
 
 /**
- * struct fw_cdev_event_common - Common part of all fw_cdev_event_ types
+ * struct fw_cdev_event_common - Common part of all fw_cdev_event_* types
  * @closure:	For arbitrary use by userspace
- * @type:	Discriminates the fw_cdev_event_ types
+ * @type:	Discriminates the fw_cdev_event_* types
  *
- * This struct may be used to access generic members of all fw_cdev_event_
+ * This struct may be used to access generic members of all fw_cdev_event_*
  * types regardless of the specific type.
  *
  * Data passed in the @closure field for a request will be returned in the
@@ -123,7 +123,13 @@ struct fw_cdev_event_response {
 
 /**
  * struct fw_cdev_event_request - Old version of &fw_cdev_event_request2
+ * @closure:	See &fw_cdev_event_common; set by %FW_CDEV_IOC_ALLOCATE ioctl
  * @type:	See &fw_cdev_event_common; always %FW_CDEV_EVENT_REQUEST
+ * @tcode:	Transaction code of the incoming request
+ * @offset:	The offset into the 48-bit per-node address space
+ * @handle:	Reference to the kernel-side pending request
+ * @length:	Data length, i.e. the request's payload size in bytes
+ * @data:	Incoming data, if any
  *
  * This event is sent instead of &fw_cdev_event_request2 if the kernel or
  * the client implements ABI version <= 3.  &fw_cdev_event_request lacks
@@ -353,7 +359,7 @@ struct fw_cdev_event_phy_packet {
 };
 
 /**
- * union fw_cdev_event - Convenience union of fw_cdev_event_ types
+ * union fw_cdev_event - Convenience union of fw_cdev_event_* types
  * @common:		Valid for all types
  * @bus_reset:		Valid if @common.type == %FW_CDEV_EVENT_BUS_RESET
  * @response:		Valid if @common.type == %FW_CDEV_EVENT_RESPONSE
@@ -735,7 +741,7 @@ struct fw_cdev_set_iso_channels {
  * @header:	Header and payload in case of a transmit context.
  *
  * &struct fw_cdev_iso_packet is used to describe isochronous packet queues.
- * Use the FW_CDEV_ISO_ macros to fill in @control.
+ * Use the FW_CDEV_ISO_* macros to fill in @control.
  * The @header array is empty in case of receive contexts.
  *
  * Context type %FW_CDEV_ISO_CONTEXT_TRANSMIT:
@@ -842,7 +848,7 @@ struct fw_cdev_queue_iso {
  *		the %FW_CDEV_ISO_SYNC bit set
  * @tags:	Tag filter bit mask.  Only valid for isochronous reception.
  *		Determines the tag values for which packets will be accepted.
- *		Use FW_CDEV_ISO_CONTEXT_MATCH_ macros to set @tags.
+ *		Use FW_CDEV_ISO_CONTEXT_MATCH_* macros to set @tags.
  * @handle:	Isochronous context handle within which to transmit or receive
  */
 struct fw_cdev_start_iso {
@@ -1009,8 +1015,8 @@ struct fw_cdev_send_stream_packet {
  * on the same card as this device.  After transmission, an
  * %FW_CDEV_EVENT_PHY_PACKET_SENT event is generated.
  *
- * The payload @data[] shall be specified in host byte order.  Usually,
- * @data[1] needs to be the bitwise inverse of @data[0].  VersaPHY packets
+ * The payload @data\[\] shall be specified in host byte order.  Usually,
+ * @data\[1\] needs to be the bitwise inverse of @data\[0\].  VersaPHY packets
  * are an exception to this rule.
  *
  * The ioctl is only permitted on device files which represent a local node.

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
