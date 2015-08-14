From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] scsi: storvsc: Use ARRAY_SIZE() to compute the elements in the protocol array
Date: Fri, 14 Aug 2015 13:50:13 -0700
Message-ID: <1439585413-3279-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, jthumshirn@suse.de
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Rather than hard coding the number of elements in the array, use the ARRAY_SIZE()
macro to compute the number of elements in the array. This would minimize the
changes needed when we have to extend the protocols supported.

This was suggested by Johannes Thumshirn <jthumshirn@suse.de>.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 64fa305..4dffc3b 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -226,9 +226,8 @@ struct vmstor_protocol {
 	int vmscsi_size_delta;
 };
 
-#define VMSTOR_NUM_PROTOCOLS    5
 
-const struct vmstor_protocol vmstor_protocols[VMSTOR_NUM_PROTOCOLS] = {
+const struct vmstor_protocol vmstor_protocols[] = {
 	{
 		VMSTOR_PROTO_VERSION_WIN10,
 		POST_WIN7_STORVSC_SENSE_BUFFER_SIZE,
@@ -959,7 +958,7 @@ static int storvsc_channel_init(struct hv_device *device)
 	}
 
 
-	for (i = 0; i < VMSTOR_NUM_PROTOCOLS; i++) {
+	for (i = 0; i < ARRAY_SIZE(vmstor_protocols); i++) {
 		/* reuse the packet for version range supported */
 		memset(vstor_packet, 0, sizeof(struct vstor_packet));
 		vstor_packet->operation =
-- 
1.7.4.1
