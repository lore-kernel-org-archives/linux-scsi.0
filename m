From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFCv2 5/7] vhost/scsi: Enable T10 PI IOV -> SGL memory mapping
Date: Mon, 17 Mar 2014 12:02:54 +0100
Message-ID: <5326D65E.6060205@redhat.com>
References: <1395034381-656-1-git-send-email-nab@daterainc.com> <1395034381-656-6-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143AbaCQLDP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2014 07:03:15 -0400
In-Reply-To: <1395034381-656-6-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>

Il 17/03/2014 06:32, Nicholas A. Bellinger ha scritto:
> +		if (vq->iov[0].iov_len == sizeof(v_req_pi)) {
> +			req = (unsigned char *)&v_req_pi;
> +			target = &v_req_pi.lun[1];
> +			req_size = sizeof(v_req_pi);
> +			hdr_pi = true;
> +		} else if (vq->iov[0].iov_len == sizeof(v_req)) {
> +			req = (unsigned char *)&v_req;
> +			target = &v_req.lun[1];
> +			req_size = sizeof(v_req);
> +			hdr_pi = false;

The right check here is on the negotiated features.

You need a matching QEMU patch to enable the protection information
feature, like this (untested):

diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index 3983a5b..4c8d5cd 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -154,6 +154,9 @@ static uint32_t vhost_scsi_get_features(VirtIODevice *vdev,
     if (!(s->dev.features & (1 << VIRTIO_SCSI_F_HOTPLUG))) {
         features &= ~(1 << VIRTIO_SCSI_F_HOTPLUG);
     }
+    if (!(s->dev.features & (1 << VIRTIO_SCSI_F_T10_PI))) {
+        features &= ~(1 << VIRTIO_SCSI_F_T10_PI);
+    }
 
     return features;
 }
diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
index 6610b3a..4a551e9 100644
--- a/hw/scsi/virtio-scsi.c
+++ b/hw/scsi/virtio-scsi.c
@@ -629,6 +629,9 @@ static void virtio_scsi_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
+    /* Protection information is not supported yet.  */
+    dev->guest_features &= ~VIRTIO_SCSI_F_T10_PI;
+
     scsi_bus_new(&s->bus, sizeof(s->bus), dev,
                  &virtio_scsi_scsi_info, vdev->bus_name);
 
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 9010246..8621fbf 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -267,6 +267,16 @@ int e820_add_entry(uint64_t, uint64_t, uint32_t);
             .value    = "no",\
         },\
         {\
+            .driver   = "virtio-scsi-pci",\
+            .property = "prot_info",\
+            .value    = "off",\
+        },\
+        {\
+            .driver   = "vhost-scsi-pci",\
+            .property = "prot_info",\
+            .value    = "off",\
+        },\
+        {\
             .driver   = "PIIX4_PM",\
             .property = "acpi-pci-hotplug-with-bridge-support",\
             .value    = "off",\
diff --git a/include/hw/virtio/virtio-scsi.h b/include/hw/virtio/virtio-scsi.h
index 42b1024..a555f49 100644
--- a/include/hw/virtio/virtio-scsi.h
+++ b/include/hw/virtio/virtio-scsi.h
@@ -34,6 +34,7 @@
 #define VIRTIO_SCSI_F_INOUT                    0
 #define VIRTIO_SCSI_F_HOTPLUG                  1
 #define VIRTIO_SCSI_F_CHANGE                   2
+#define VIRTIO_SCSI_F_T10_PI                   3
 
 #define VIRTIO_SCSI_VQ_SIZE     128
 #define VIRTIO_SCSI_CDB_SIZE    32
@@ -184,7 +185,9 @@ typedef struct {
     DEFINE_PROP_BIT("hotplug", _state, _feature_field, VIRTIO_SCSI_F_HOTPLUG,  \
                                                        true),                  \
     DEFINE_PROP_BIT("param_change", _state, _feature_field,                    \
-                                            VIRTIO_SCSI_F_CHANGE, true)
+                                            VIRTIO_SCSI_F_CHANGE, true)        \
+    DEFINE_PROP_BIT("prot_info", _state, _feature_field,                       \
+                                            VIRTIO_SCSI_F_T10_PI, true)
 
 void virtio_scsi_common_realize(DeviceState *dev, Error **errp);
 void virtio_scsi_common_unrealize(DeviceState *dev, Error **errp);

