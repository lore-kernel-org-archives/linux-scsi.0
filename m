From: Jon Derrick <jonathan.derrick@intel.com>
Subject: [PATCH] nvme-scsi: Use correct byte ordering for eui64 in Dev ID VPD
Date: Tue, 25 Apr 2017 14:18:09 -0600
Message-ID: <20170425201809.1683-1-jonathan.derrick@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30677 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033572AbdDYUVm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 16:21:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, keith.busch@intel.com, hch@infradead.org, sagi@grimberg.me, Jon Derrick <jonathan.derrick@intel.com>

NVME specifies an EUI64/NGUID in little-endian format, while SCSI
specifies that the Device Identification VPD use big-endian for EUI
formats. The current code copies this bytestream directly from the
Identification Namespace page, meaning we just need to reverse the
bytestream when passing it on to the VPD.

This results in the correct values being parsed by sg-tools, eg:
$ sg_inq -e -p 0x83 /dev/nvme1n1 -vvv
open /dev/nvme1n1 with flags=0x800
VPD INQUIRY: Device Identification page
    inquiry cdb: 12 01 83 00 fc 00
      duration=0 ms
  Designation descriptor number 1, descriptor length: 20
    designator_type: EUI-64 based,  code_set: Binary
    associated with the addressed logical unit
      EUI-64 based 16 byte identifier
      Identifier extension: 0x100000001
      IEEE Company_id: 0x5cd2e4
      Vendor Specific Extension Identifier: 0x0
      [0x00000001000000015cd2e40000000000]

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
---
 drivers/nvme/host/scsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/scsi.c b/drivers/nvme/host/scsi.c
index f49ae27..8f94e77 100644
--- a/drivers/nvme/host/scsi.c
+++ b/drivers/nvme/host/scsi.c
@@ -598,6 +598,7 @@ static int nvme_fill_device_id_eui64(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	int nvme_sc, res;
 	size_t len;
 	void *eui;
+	int i;
 
 	nvme_sc = nvme_identify_ns(ns->ctrl, ns->ns_id, &id_ns);
 	res = nvme_trans_status_code(hdr, nvme_sc);
@@ -628,7 +629,8 @@ static int nvme_fill_device_id_eui64(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	inq_response[5] = 0x02;	/* PIV=0b | Asso=00b | Designator Type=2h */
 	inq_response[6] = 0x00;	/* Rsvd */
 	inq_response[7] = len;	/* Designator Length */
-	memcpy(&inq_response[8], eui, len);
+	for (i = 0; i < len; i++)
+		inq_response[8 + i] = ((char *)eui)[len - (i + 1)];
 
 	res = nvme_trans_copy_to_user(hdr, inq_response, alloc_len);
 out_free_id:
-- 
2.9.3
