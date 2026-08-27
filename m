Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D25488229
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846909; cv=none; b=Mfh4SzfdC0q1a0HzomYcncI4RZ8jnB8fAByQda2cQCM8KmsRGb6XAlqv6JZ+NlQZNKGp/w3KDLhCGHjI+c5jxfunzAphVcMsK2+ZvfnA4TkPsFQuRnz+zw/0hxXvR17Yhfku6XivqziRhRu8d790ZE6xme8pUBza//OXyyyDmtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846909; c=relaxed/simple;
	bh=IIdZmC/LM00PwR5KHA2xpiIqG5UVbMYS/zEiNRNREio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqqbiTbSPLhZTSnH0txMcYfzhE4Q+7Z2I44z1xvicCsQnbJVqolHAv+DBeeYW4v3ZqCsStb6/19+/8cWShQKdBqvUc81wRV4bnreMgDzMYHI4KuH8yPy3kM50xDwe1fHO5MOB8VZW2mN5hkLCdp9asMXDd2uE34/iEhZQdCLMAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=No9Edywy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZanpH+qN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="No9Edywy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZanpH+qN"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RFbwsj059053
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=zlZEuku42ul
	qNc3ih1pFp1rs3evdduqZIg1SlzbXZv8=; b=No9EdywyxhYBjMK0CreG/ee8B20
	+Ze1t6Vts55zTISy/vNkJQ725lDNjnj9PKSG6bJcPgYkTxoBckGgIx+Gf4gvvr40
	6x4Pi4/yEqMcLJNU8hX6Vz+8r0xjF+BwtOZBTc8LzJOKviFZB4yTPuhkrEXBLhm1
	nWBNCuKRPcMe/lOS/MCc4wpI7NM84tSVJFLhCPBSJ1iFH9NdwmW9vs0v5DHBhPe3
	Dy6w7iCtPDDICBN/vmdntg0SeEwYaDN16ZczVWeAgd0GNeQlrLbPUguUjXrHBVVl
	0Jwt57ll/MZ9luK4hS99lDEtLsE8mrIDjreETwfpLI7UZE09ObUre1dwFug==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gak561at9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:24 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc18ced1a5aso77989a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 09:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787846903; x=1788451703; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zlZEuku42ulqNc3ih1pFp1rs3evdduqZIg1SlzbXZv8=;
        b=ZanpH+qNJdzhizVrj43TZ7VfxtvOEFCkdffihoNI2OT+NeTs8YiDaVlrjfZxiRMXTn
         w4P5VGIxYd7mEjLWfO1x6NFxk2l7uBAIAaQdc7AqmIUfXWsD82MPfW+AC/Gh0qrzjWap
         OAsk6QX3k4W82Yg4qiFdB6QrIo8WuZEAex7gt8ZAZ1+G71DPut7VrJ8JKbgtkUW61hjX
         gHfa2TE/koNT5zmoz095c54+8C/FX8FC7FDlMKbhzVc7sF1kab1Jl3NccOR6FqF5Fwj4
         ug03N+2X8azeYqrtGBX6QiTRhKMIGTMUgi2OW0o7FXxzqhsXU4IXEgLWQrsPL2XcO+uf
         kE5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787846903; x=1788451703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zlZEuku42ulqNc3ih1pFp1rs3evdduqZIg1SlzbXZv8=;
        b=ik0RJSu161YHSztKynG9oWPM8/CEpwelU8TQtI+s6L8C102CUhAmYH/rmcyBciNn2I
         4rAQDSSiFqJPIEDH1ZTMNXkct+wGSzM88R0Im/F3rslRCdNg7wJQ9KoRuYR1FTnMuVez
         alz9UVdhi+4f/TLj58v133hdmaZ3NFjbIB5JJVWZr2G4+JXhmdcnyIwtVNSvq66csNsx
         coZqCat9tg6idPXXA+4ZoKVSVujX6aS7nmRrEbLal97RxlPDYtdxXjkVm3MYG14/T526
         onE7+ziK4J19R5h6tNUdYlv7jDPJoTJSQ9EnGB8SHOOdTmLRvasBOdLkUIqIEVESuSsD
         uiWg==
X-Forwarded-Encrypted: i=1; AHgh+Rr0CLvjijkcrpaj2F5BLd+eRvzYPG/T1uyPyvoV4w0WepNLAbb8V8zQqvEEWRIj8GSmc1AxFAJVNS8R@vger.kernel.org
X-Gm-Message-State: AFuF++k0Jovxqv0Jx3S6Rwxh7/Puj0P8Crf0XkmvSY8TRZ42nBLj9ABX
	bj9XBSxZjQYUJ9ZSkLGeijMv5bfB7j1XztZZsnFZF+6fVuyPwk20SlCqia0wU9OOdmMmOIdgRnK
	8qbWKTGYPH4AEqLFOG/3OW+0YuC747bD0V/DmBn7WO+h169wqqxbGTzg774GQ9HPn
X-Gm-Gg: AR+sD13O+YwJwnVMDRy7IUx4zcrlPVNkngiR86QtTUWskJCZ/falVfWQoMDXG+Vyqlv
	7itjMxXBGbfd9mfdt60shw5wfx34DKDbsTUn30EUU2i08DkviQUMhXqGQZGWYczS35rDjfpQUvR
	WsoRJQuhyXGAtVz8mQrb+Jv1bqyBR7G2ZTXcw8OYkczXzR2XrlVOQ6jR/7im8JjITseuLgiDDi3
	nHPGPVhyxdIWC9TNH1firgY4g9MM/wcqNJ0QklRqg3/ZD2RJRT7fmpmMg1hgO1yllLKSKOmDCGK
	znaW8rgdqhiCuKjflNWzJr1PbHk5DVQ5+jdNyjXGAMl8DGiOky3j6hiBn9CZfXM9OVYrI6q/hAb
	U5k14AszHchtADO6G8Olv8fq7ShAhMA2VbykgVsWBXSOR9nwKJtENUhyOu7E=
X-Received: by 2002:a17:90b:54c6:b0:36d:b424:4f17 with SMTP id 98e67ed59e1d1-396d0e24bdamr617104a91.1.1787846902905;
        Thu, 27 Aug 2026 09:08:22 -0700 (PDT)
X-Received: by 2002:a17:90b:54c6:b0:36d:b424:4f17 with SMTP id 98e67ed59e1d1-396d0e24bdamr616889a91.1.1787846902153;
        Thu, 27 Aug 2026 09:08:22 -0700 (PDT)
Received: from u24-san1p10108.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd9085sm3245892a91.12.2026.08.27.09.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 09:08:21 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: ebiggers@kernel.org, axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
Subject: [PATCH v1 01/11] virtio_blk: add inline encryption support
Date: Thu, 27 Aug 2026 09:07:10 -0700
Message-ID: <20260827160806.1295313-2-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX4qG1e4tfo1tR
 w5M4VYw8njhSHaNcDUSOVAVTqJP5EGvAsUhyL5IsbQNHOQSH47D/Gwi8NWRoTb7tg/eVphiJ5t7
 igTjeNulgMmzlYOkYnhy/SHYKI1yYYs=
X-Proofpoint-ORIG-GUID: sAFxPwZfcI4cS6Cf4m1XbKiuwjIHdsFI
X-Proofpoint-GUID: sAFxPwZfcI4cS6Cf4m1XbKiuwjIHdsFI
X-Authority-Analysis: v=2.4 cv=G+Ms1dk5 c=1 sm=1 tr=0 ts=6a9060f8 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=Bv6Tw1xzN9wVcIKmVv0A:9 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX4+mlJlX7Qtgu
 MN7HubVv4QUJXk/ImRK8Un5zOzaMQ8zhJjQD9JVWoefMf1WFAW1HRAdYgPfq048TE847xyK8vlF
 QIDaV4W6QZlxFIWIlLF9hO+f9u7nbOsPqfO6aF73/QaseOTtmHJbf0SJiB77eLPI1ZxX/x1cQy1
 FYiX1X/1lJzyhi7jF7TGVtOFD+NoHbW76iI9IeGIFgS4544rfrtFMvQsUGd9Ijm5W2TeRDOrW0s
 M47c9WhjGwgaxVw8VtNrfN+tTUU3RNCuQLpe889ybAeKMf3P1nzpA5gzJOcJCgEtuwF3bIsY7pT
 vOcrAIudWu8eASbqPw12HlcEmWnOwnAMU5sRAnlCvzK30mfyw3kV0jHkKTuSpeOIodnEK+Jjzyt
 zpyKGhJ2emuopD9oeBrOapqMWbn+g1m6VsSLxe38Hv5nJLxfBpCjhJ42KfeIvhotifxR8S5dVoW
 D1tF0ho4jgBB5QB7G5Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_07,2026-08-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015 bulkscore=0
 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270136

From: linlzhan <linlzhan@qti.qualcomm.com>

Negotiate VIRTIO_BLK_F_INLINE_ENCRYPTION with the host and wire it into
the block layer's inline-crypto framework to enable inline encryption
on virtio block device.

When the feature is present, the driver reads crypto characteristics from
virtio config space (key-slot count, DUN size, supported key types) and
issues VIRTIO_BLK_T_GET_CRYPTO_MODES to discover supported cipher and
data-unit-size combinations.  Encrypted requests use new request types
VIRTIO_BLK_T_CRYPTO_IN/OUT, which append a virtio_blk_crypto_msg
(keyslot index, DUN, data-unit-size-bits) to the standard outhdr.

A new virtio block crypto extension driver (virtio_blk_crypto_ext),
owns the blk_crypto_profile singleton and the blk_crypto_ll_ops dispatch
table. Actual key operations are forwarded to a platform-specific
backend registered via virtblk_set_crypto_ops(); without one,
VIRTIO_BLK_F_INLINE_ENCRYPTION is still negotiated and the
profile is registered, but every keyslot operation returns -EOPNOTSUPP.

The shared profile is a singleton as per blk_crypto_profile is
corresponding to one ICE hardware: the first device to negotiate the
feature initializes it; subsequent devices reuse it only when their
negotiated capabilities (slot count, DUN size, key types) match exactly.

Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
---
 drivers/block/Kconfig                 |  13 ++
 drivers/block/Makefile                |   2 +
 drivers/block/virtio_blk.c            | 199 ++++++++++++++++--
 drivers/block/virtio_blk_crypto_ext.c | 283 ++++++++++++++++++++++++++
 include/linux/virtio_blk_crypto_ext.h |  78 +++++++
 include/uapi/linux/virtio_blk.h       |  62 ++++++
 6 files changed, 623 insertions(+), 14 deletions(-)
 create mode 100644 drivers/block/virtio_blk_crypto_ext.c
 create mode 100644 include/linux/virtio_blk_crypto_ext.h

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 858320b6ebb7..7790ee2c700c 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -312,6 +312,19 @@ config VIRTIO_BLK
 	  This is the virtual block driver for virtio.  It can be used with
           QEMU based VMMs (like KVM or Xen).  Say Y or M.
 
+config VIRTBLK_CRYPTO_VIRTUALIZATION
+	tristate "Virtio block inline encryption virtualization support"
+	depends on VIRTIO_BLK && BLK_INLINE_ENCRYPTION
+	help
+	  Say 'Y or M' to enable routing of crypto requests to a different
+	  operating system in a virtualized environment. This option by
+	  itself does not provide a working backend: enable a
+	  platform-specific driver that implements struct
+	  virtblk_crypto_variant_ops as well (e.g. QCOM_CRYPTO_VIRT on
+	  Qualcomm platforms). Without one, VIRTIO_BLK_F_INLINE_ENCRYPTION is
+	  still negotiated and advertised to the block layer, but every
+	  inline-crypto operation fails with -EOPNOTSUPP at runtime.
+
 config BLK_DEV_RBD
 	tristate "Rados block device (RBD)"
 	depends on INET && BLOCK
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 2d8096eb8cdf..079c910d5fc9 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -25,6 +25,8 @@ obj-$(CONFIG_SUNVDC)		+= sunvdc.o
 obj-$(CONFIG_BLK_DEV_NBD)	+= nbd.o
 obj-$(CONFIG_VIRTIO_BLK)	+= virtio_blk.o
 
+obj-$(CONFIG_VIRTBLK_CRYPTO_VIRTUALIZATION) += virtio_blk_crypto_ext.o
+
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
 obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 32bf3ba07a9d..61a3967bb4df 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -16,6 +16,8 @@
 #include <linux/numa.h>
 #include <linux/vmalloc.h>
 #include <uapi/linux/virtio_ring.h>
+#include <linux/blk-crypto-profile.h>
+#include <linux/virtio_blk_crypto_ext.h>
 
 #define PART_BITS 4
 #define VQ_NAME_LEN 16
@@ -87,7 +89,14 @@ struct virtio_blk {
 
 struct virtblk_req {
 	/* Out header */
-	struct virtio_blk_outhdr out_hdr;
+	union {
+		struct virtio_blk_outhdr base;
+		struct {
+			struct virtio_blk_outhdr base;
+			/* Crypto message (if VIRTIO_BLK_F_INLINE_ENCRYPTION) */
+			struct virtio_blk_crypto_msg msg;
+		} crypto_append;
+	} out_hdr;
 
 	/* In header */
 	union {
@@ -140,12 +149,17 @@ static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *vbr)
 {
 	struct scatterlist out_hdr, in_hdr, *sgs[3];
 	unsigned int num_out = 0, num_in = 0;
+	size_t out_hdr_len = sizeof(vbr->out_hdr.base);
+
+	if (vbr->out_hdr.base.type == cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_CRYPTO_IN) ||
+	    vbr->out_hdr.base.type == cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_CRYPTO_OUT))
+		out_hdr_len = sizeof(vbr->out_hdr.crypto_append);
 
-	sg_init_one(&out_hdr, &vbr->out_hdr, sizeof(vbr->out_hdr));
+	sg_init_one(&out_hdr, &vbr->out_hdr, out_hdr_len);
 	sgs[num_out++] = &out_hdr;
 
 	if (vbr->sg_table.nents) {
-		if (vbr->out_hdr.type & cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_OUT))
+		if (vbr->out_hdr.base.type & cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_OUT))
 			sgs[num_out++] = vbr->sg_table.sgl;
 		else
 			sgs[num_out + num_in++] = vbr->sg_table.sgl;
@@ -235,6 +249,15 @@ static void virtblk_cleanup_cmd(struct request *req)
 		kfree(bvec_virt(&req->special_vec));
 }
 
+static bool is_crypto_request(struct virtio_device *vdev, struct request *req)
+{
+	if (!IS_ENABLED(CONFIG_VIRTBLK_CRYPTO_VIRTUALIZATION) ||
+	    !virtio_has_feature(vdev, VIRTIO_BLK_F_INLINE_ENCRYPTION))
+		return false;
+
+	return req->crypt_ctx && req->crypt_keyslot;
+}
+
 static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
 				      struct request *req,
 				      struct virtblk_req *vbr)
@@ -248,15 +271,21 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
 		return BLK_STS_NOTSUPP;
 
 	/* Set fields for all request types */
-	vbr->out_hdr.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
+	vbr->out_hdr.base.ioprio = cpu_to_virtio32(vdev, req_get_ioprio(req));
 
 	switch (req_op(req)) {
 	case REQ_OP_READ:
-		type = VIRTIO_BLK_T_IN;
+		if (is_crypto_request(vdev, req))
+			type = VIRTIO_BLK_T_CRYPTO_IN;
+		else
+			type = VIRTIO_BLK_T_IN;
 		sector = blk_rq_pos(req);
 		break;
 	case REQ_OP_WRITE:
-		type = VIRTIO_BLK_T_OUT;
+		if (is_crypto_request(vdev, req))
+			type = VIRTIO_BLK_T_CRYPTO_OUT;
+		else
+			type = VIRTIO_BLK_T_OUT;
 		sector = blk_rq_pos(req);
 		break;
 	case REQ_OP_FLUSH:
@@ -298,8 +327,9 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
 		break;
 	case REQ_OP_DRV_IN:
 		/*
-		 * Out header has already been prepared by the caller (virtblk_get_id()
-		 * or virtblk_submit_zone_report()), nothing to do here.
+		 * Out header has already been prepared by the caller (virtblk_get_id(),
+		 * virtblk_submit_zone_report() or virtblk_get_crypto_modes()), nothing
+		 * to do here.
 		 */
 		return 0;
 	default:
@@ -309,8 +339,8 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
 
 	/* Set fields for non-REQ_OP_DRV_IN request types */
 	vbr->in_hdr_len = in_hdr_len;
-	vbr->out_hdr.type = cpu_to_virtio32(vdev, type);
-	vbr->out_hdr.sector = cpu_to_virtio64(vdev, sector);
+	vbr->out_hdr.base.type = cpu_to_virtio32(vdev, type);
+	vbr->out_hdr.base.sector = cpu_to_virtio64(vdev, sector);
 
 	if (type == VIRTIO_BLK_T_DISCARD || type == VIRTIO_BLK_T_WRITE_ZEROES ||
 	    type == VIRTIO_BLK_T_SECURE_ERASE) {
@@ -318,6 +348,17 @@ static blk_status_t virtblk_setup_cmd(struct virtio_device *vdev,
 			return BLK_STS_RESOURCE;
 	}
 
+	if (type == VIRTIO_BLK_T_CRYPTO_IN || type == VIRTIO_BLK_T_CRYPTO_OUT) {
+		unsigned int slot = blk_crypto_keyslot_index(req->crypt_keyslot);
+		unsigned int data_unit_size_bits = req->crypt_ctx->bc_key->data_unit_size_bits;
+		u64 dun = req->crypt_ctx->bc_dun[0];
+
+		vbr->out_hdr.crypto_append.msg.slot = cpu_to_virtio32(vdev, slot);
+		vbr->out_hdr.crypto_append.msg.data_unit_size_bits =
+				cpu_to_virtio32(vdev, data_unit_size_bits);
+		vbr->out_hdr.crypto_append.msg.dun = cpu_to_virtio64(vdev, dun);
+	}
+
 	return 0;
 }
 
@@ -568,8 +609,8 @@ static int virtblk_submit_zone_report(struct virtio_blk *vblk,
 
 	vbr = blk_mq_rq_to_pdu(req);
 	vbr->in_hdr_len = sizeof(vbr->in_hdr.status);
-	vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_ZONE_REPORT);
-	vbr->out_hdr.sector = cpu_to_virtio64(vblk->vdev, sector);
+	vbr->out_hdr.base.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_ZONE_REPORT);
+	vbr->out_hdr.base.sector = cpu_to_virtio64(vblk->vdev, sector);
 
 	err = blk_rq_map_kern(req, report_buf, report_len, GFP_KERNEL);
 	if (err)
@@ -817,8 +858,8 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 
 	vbr = blk_mq_rq_to_pdu(req);
 	vbr->in_hdr_len = sizeof(vbr->in_hdr.status);
-	vbr->out_hdr.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_GET_ID);
-	vbr->out_hdr.sector = 0;
+	vbr->out_hdr.base.type = cpu_to_virtio32(vblk->vdev, VIRTIO_BLK_T_GET_ID);
+	vbr->out_hdr.base.sector = 0;
 
 	err = blk_rq_map_kern(req, id_str, VIRTIO_BLK_ID_BYTES, GFP_KERNEL);
 	if (err)
@@ -863,6 +904,70 @@ static int virtblk_getgeo(struct gendisk *disk, struct hd_geometry *geo)
 	return ret;
 }
 
+/* Maps VIRTIO_BLK_CRYPTO_MODE_* values to the kernel's internal enum. */
+static const enum blk_crypto_mode_num
+	virtio_blk_crypto_mode_map[VIRTIO_BLK_CRYPTO_MODE_MAX + 1] = {
+	[VIRTIO_BLK_CRYPTO_MODE_INVALID]	= BLK_ENCRYPTION_MODE_INVALID,
+	[VIRTIO_BLK_CRYPTO_MODE_AES_256_XTS]	= BLK_ENCRYPTION_MODE_AES_256_XTS,
+};
+
+static int virtblk_get_crypto_modes(struct virtio_blk *vblk,
+				    unsigned int *crypto_modes_supported)
+{
+	struct request_queue *q = vblk->disk->queue;
+	unsigned int nr_modes = VIRTIO_BLK_CRYPTO_MODE_MAX + 1;
+	size_t buf_size = sizeof(struct virtio_blk_crypto_modes);
+	struct virtio_blk_crypto_modes *virtblk_cmodes;
+	struct request *req;
+	struct virtblk_req *vbr;
+	unsigned int i;
+	int err;
+
+	virtblk_cmodes = kzalloc(buf_size, GFP_KERNEL);
+	if (!virtblk_cmodes)
+		return -ENOMEM;
+
+	req = blk_mq_alloc_request(q, REQ_OP_DRV_IN, 0);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		goto out_free;
+	}
+
+	vbr = blk_mq_rq_to_pdu(req);
+	vbr->in_hdr_len = sizeof(vbr->in_hdr.status);
+	vbr->out_hdr.base.type = cpu_to_virtio32(vblk->vdev,
+						 VIRTIO_BLK_T_GET_CRYPTO_MODES);
+	vbr->out_hdr.base.sector = 0;
+
+	err = blk_rq_map_kern(req, virtblk_cmodes, buf_size, GFP_KERNEL);
+	if (err)
+		goto out_req;
+
+	blk_execute_rq(req, false);
+	err = blk_status_to_errno(virtblk_result(vbr->in_hdr.status));
+	if (err)
+		goto out_req;
+
+	for (i = 1; i < nr_modes; i++) {
+		u32 mode_mask = virtio32_to_cpu(vblk->vdev, virtblk_cmodes->modes[i]);
+		enum blk_crypto_mode_num mode = virtio_blk_crypto_mode_map[i];
+
+		if (!mode_mask)
+			continue;
+		if (!mode) {
+			dev_warn(&vblk->vdev->dev,
+				 "ignoring unknown crypto mode %u\n", i);
+			continue;
+		}
+		crypto_modes_supported[mode] = mode_mask;
+	}
+out_req:
+	blk_mq_free_request(req);
+out_free:
+	kfree(virtblk_cmodes);
+	return err;
+}
+
 static void virtblk_free_disk(struct gendisk *disk)
 {
 	struct virtio_blk *vblk = disk->private_data;
@@ -1435,6 +1540,51 @@ static int virtblk_read_limits(struct virtio_blk *vblk,
 	return 0;
 }
 
+static int virtblk_init_crypto(struct virtio_blk *vblk)
+{
+	struct virtio_device *vdev = vblk->vdev;
+	unsigned int crypto_modes_supported[BLK_ENCRYPTION_MODE_MAX] = { 0 };
+	/* virtio_cread() requires the variable size to match the config field exactly */
+	u16 max_slots;
+	u8 max_dun_bytes, key_types;
+	int err;
+
+	virtio_cread(vdev, struct virtio_blk_config,
+		     enc_characteristics.max_slots, &max_slots);
+	virtio_cread(vdev, struct virtio_blk_config,
+		     enc_characteristics.max_dun_bytes, &max_dun_bytes);
+	virtio_cread(vdev, struct virtio_blk_config,
+		     enc_characteristics.key_types, &key_types);
+
+	dev_dbg(&vdev->dev,
+		 "max_slots = %u, max_dun_bytes = %u, key_types = 0x%x\n",
+		 max_slots, max_dun_bytes, key_types);
+
+	if (!max_slots)
+		return -EINVAL;
+	if (!(key_types & (VIRTIO_BLK_CRYPTO_KEY_TYPE_RAW |
+			   VIRTIO_BLK_CRYPTO_KEY_TYPE_HW_WRAPPED)))
+		return -EINVAL;
+	/*
+	 * struct virtio_blk_crypto_msg.dun is a fixed __virtio64, i.e. this
+	 * driver can only ever transmit 8 bytes of DUN per request. Refuse
+	 * to advertise more than that as supported, or blk-crypto could
+	 * negotiate a larger dun_bytes with the filesystem and have the
+	 * high-order bytes of req->crypt_ctx->bc_dun silently dropped in
+	 * virtblk_setup_cmd(), reusing the same IV across data units that
+	 * only differ in those high-order bytes.
+	 */
+	if (max_dun_bytes > sizeof(u64))
+		return -EINVAL;
+
+	err = virtblk_get_crypto_modes(vblk, crypto_modes_supported);
+	if (err)
+		return err;
+
+	return virtblk_init_inline_crypto(max_slots, max_dun_bytes, key_types,
+					   crypto_modes_supported, &vdev->dev);
+}
+
 static int virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
@@ -1540,6 +1690,26 @@ static int virtblk_probe(struct virtio_device *vdev)
 			goto out_cleanup_disk;
 	}
 
+	if (IS_ENABLED(CONFIG_VIRTBLK_CRYPTO_VIRTUALIZATION) &&
+	    virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_INLINE_ENCRYPTION)) {
+		if (virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_ZONED)) {
+			dev_warn(&vdev->dev,
+				 "zoned device does not support inline encryption, disabling it\n");
+		} else {
+			/* Initialize supported crypto capabilities */
+			err = virtblk_init_crypto(vblk);
+			if (!err) {
+				if (!virtblk_crypto_register(vblk->disk->queue))
+					dev_warn(&vdev->dev,
+						"failed to register inline crypto profile with the block layer, continuing without inline crypto support\n");
+			} else {
+				dev_warn(&vdev->dev,
+					"inline crypto init failed: %d, continuing without inline crypto support\n",
+					err);
+			}
+		}
+	}
+
 	err = device_add_disk(&vdev->dev, vblk->disk, virtblk_attr_groups);
 	if (err)
 		goto out_cleanup_disk;
@@ -1672,6 +1842,7 @@ static unsigned int features[] = {
 	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY, VIRTIO_BLK_F_CONFIG_WCE,
 	VIRTIO_BLK_F_MQ, VIRTIO_BLK_F_DISCARD, VIRTIO_BLK_F_WRITE_ZEROES,
 	VIRTIO_BLK_F_SECURE_ERASE, VIRTIO_BLK_F_ZONED,
+	VIRTIO_BLK_F_INLINE_ENCRYPTION,
 };
 
 static struct virtio_driver virtio_blk = {
diff --git a/drivers/block/virtio_blk_crypto_ext.c b/drivers/block/virtio_blk_crypto_ext.c
new file mode 100644
index 000000000000..00b6d410d303
--- /dev/null
+++ b/drivers/block/virtio_blk_crypto_ext.c
@@ -0,0 +1,283 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/container_of.h>
+#include <linux/blk-crypto.h>
+#include <linux/blk-crypto-profile.h>
+#include <linux/virtio_blk.h>
+#include <linux/virtio_blk_crypto_ext.h>
+
+struct virtblk_crypto_profile {
+	struct blk_crypto_profile profile;
+	struct virtblk_crypto_variant_ops *ops;
+};
+
+static struct virtblk_crypto_profile g_vdcp;
+static bool g_crypto_profile_initialized;
+static struct device *virtblk_profile_owner;
+static unsigned int g_max_slots;
+static unsigned int g_max_dun_bytes;
+static unsigned int g_key_types;
+static DEFINE_MUTEX(virtblk_crypto_init_lock);
+static DEFINE_MUTEX(virtblk_crypto_ops_lock);
+
+bool virtblk_crypto_register(struct request_queue *q)
+{
+	return blk_crypto_register(&g_vdcp.profile, q);
+}
+EXPORT_SYMBOL_GPL(virtblk_crypto_register);
+
+/*
+ * Returns the variant ops registered for @profile's virtblk_crypto_profile
+ * with a module reference held on ops->owner, or NULL if none are
+ * registered. Pairs with virtblk_crypto_ops_put().
+ *
+ * Holding a module reference for the duration of each dispatch call (rather
+ * than just dereferencing the raw pointer) is what makes it safe for the
+ * module that implements these ops (e.g. drivers/soc/qcom/crypto_virt.c) to
+ * be rmmod'd: module removal will fail/block until every in-flight dispatch
+ * call has released its reference, instead of racing with a concurrent
+ * virtblk_set_crypto_ops(NULL) and the ops table disappearing mid-call.
+ */
+static struct virtblk_crypto_variant_ops *
+virtblk_crypto_ops_get(struct blk_crypto_profile *profile)
+{
+	struct virtblk_crypto_profile *vdcp =
+		container_of(profile, struct virtblk_crypto_profile, profile);
+	struct virtblk_crypto_variant_ops *ops;
+
+	mutex_lock(&virtblk_crypto_ops_lock);
+	ops = vdcp->ops;
+	if (ops && !try_module_get(ops->owner))
+		ops = NULL;
+	mutex_unlock(&virtblk_crypto_ops_lock);
+
+	return ops;
+}
+
+static void virtblk_crypto_ops_put(struct virtblk_crypto_variant_ops *ops)
+{
+	module_put(ops->owner);
+}
+
+static int virtblk_crypto_keyslot_program(struct blk_crypto_profile *profile,
+					   const struct blk_crypto_key *key,
+					   unsigned int slot)
+{
+	struct virtblk_crypto_variant_ops *ops = virtblk_crypto_ops_get(profile);
+	int ret;
+
+	if (!ops || !ops->program_key) {
+		if (ops)
+			virtblk_crypto_ops_put(ops);
+		return -EOPNOTSUPP;
+	}
+
+	ret = ops->program_key(key, slot);
+	virtblk_crypto_ops_put(ops);
+	if (ret)
+		pr_err("program hardware wrapped key failed: slot=%u ret=%d\n", slot, ret);
+
+	return ret;
+}
+
+static int virtblk_crypto_keyslot_evict(struct blk_crypto_profile *profile,
+					 const struct blk_crypto_key *key,
+					 unsigned int slot)
+{
+	struct virtblk_crypto_variant_ops *ops = virtblk_crypto_ops_get(profile);
+	int ret;
+
+	if (!ops || !ops->evict_key) {
+		if (ops)
+			virtblk_crypto_ops_put(ops);
+		return -EOPNOTSUPP;
+	}
+
+	ret = ops->evict_key(slot);
+	virtblk_crypto_ops_put(ops);
+	if (ret)
+		pr_err("evict keyslot %u failed: %d\n", slot, ret);
+
+	return ret;
+}
+
+static int virtblk_crypto_derive_sw_secret(struct blk_crypto_profile *profile,
+					    const u8 *eph_key,
+					    size_t eph_key_size,
+					    u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	struct virtblk_crypto_variant_ops *ops = virtblk_crypto_ops_get(profile);
+	int ret;
+
+	if (!ops || !ops->derive_sw_secret_key) {
+		if (ops)
+			virtblk_crypto_ops_put(ops);
+		return -EOPNOTSUPP;
+	}
+
+	ret = ops->derive_sw_secret_key(eph_key, eph_key_size, sw_secret);
+	virtblk_crypto_ops_put(ops);
+	if (ret)
+		pr_err("derive software secret failed: %d\n", ret);
+
+	return ret;
+}
+
+static int virtblk_crypto_generate_key(struct blk_crypto_profile *profile,
+					u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct virtblk_crypto_variant_ops *ops = virtblk_crypto_ops_get(profile);
+	int ret;
+
+	if (!ops || !ops->generate_key) {
+		if (ops)
+			virtblk_crypto_ops_put(ops);
+		return -EOPNOTSUPP;
+	}
+
+	ret = ops->generate_key(lt_key);
+	virtblk_crypto_ops_put(ops);
+	if (ret < 0)
+		pr_err("generate hardware wrapped key failed: %d\n", ret);
+
+	return ret;
+}
+
+static int virtblk_crypto_prepare_key(struct blk_crypto_profile *profile,
+				       const u8 *lt_key, size_t lt_key_size,
+				       u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct virtblk_crypto_variant_ops *ops = virtblk_crypto_ops_get(profile);
+	int ret;
+
+	if (!ops || !ops->prepare_key) {
+		if (ops)
+			virtblk_crypto_ops_put(ops);
+		return -EOPNOTSUPP;
+	}
+
+	ret = ops->prepare_key(lt_key, lt_key_size, eph_key);
+	virtblk_crypto_ops_put(ops);
+	if (ret < 0)
+		pr_err("prepare hardware wrapped key failed: %d\n", ret);
+
+	return ret;
+}
+
+static int virtblk_crypto_import_key(struct blk_crypto_profile *profile,
+				      const u8 *raw_key, size_t raw_key_size,
+				      u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct virtblk_crypto_variant_ops *ops = virtblk_crypto_ops_get(profile);
+	int ret;
+
+	if (!ops || !ops->import_key) {
+		if (ops)
+			virtblk_crypto_ops_put(ops);
+		return -EOPNOTSUPP;
+	}
+
+	ret = ops->import_key(raw_key, raw_key_size, lt_key);
+	virtblk_crypto_ops_put(ops);
+	if (ret < 0)
+		pr_err("import hardware wrapped key failed: %d\n", ret);
+
+	return ret;
+}
+
+static const struct blk_crypto_ll_ops virtblk_crypto_ops = {
+	.keyslot_program	= virtblk_crypto_keyslot_program,
+	.keyslot_evict		= virtblk_crypto_keyslot_evict,
+	.derive_sw_secret	= virtblk_crypto_derive_sw_secret,
+	.generate_key		= virtblk_crypto_generate_key,
+	.prepare_key		= virtblk_crypto_prepare_key,
+	.import_key		= virtblk_crypto_import_key,
+};
+
+int virtblk_init_inline_crypto(unsigned int max_slots, unsigned int max_dun_bytes,
+			       unsigned int key_types,
+			       const unsigned int crypto_modes_supported[BLK_ENCRYPTION_MODE_MAX],
+			       struct device *dev)
+{
+	struct blk_crypto_profile *profile = &g_vdcp.profile;
+	unsigned int key_type_supported = 0;
+	int err = 0;
+
+	dev_info(dev, "probing inline crypto capabilities\n");
+
+	mutex_lock(&virtblk_crypto_init_lock);
+
+	/*
+	 * profile is a single, process-wide blk_crypto_profile shared by every
+	 * VIRTIO_BLK_F_INLINE_ENCRYPTION device. Only the first device to get
+	 * here actually initializes it; any other device just reuses it as-is
+	 * if its negotiated capabilities match. A mismatch means this device's
+	 * capabilities don't actually correspond to what the shared profile
+	 * was set up for (wrong keyslot count, DUN size, or key types), which
+	 * is a correctness/security concern, not just a cosmetic one -- fail
+	 * instead of silently registering a profile that doesn't match what
+	 * this device supports.
+	 */
+	if (g_crypto_profile_initialized) {
+		if (max_slots != g_max_slots || max_dun_bytes != g_max_dun_bytes ||
+		    key_types != g_key_types) {
+			dev_warn(dev,
+				 "inline crypto profile already initialized by %s (max_slots=%u max_dun_bytes=%u key_types=0x%x); "
+				 "this device reports max_slots=%u max_dun_bytes=%u key_types=0x%x -- sharing one "
+				 "blk_crypto_profile across multiple VIRTIO_BLK_F_INLINE_ENCRYPTION devices with differing "
+				 "capabilities is not supported, refusing to enable inline crypto for this device\n",
+				 dev_name(virtblk_profile_owner), g_max_slots, g_max_dun_bytes, g_key_types,
+				 max_slots, max_dun_bytes, key_types);
+			err = -EINVAL;
+		}
+		goto out_unlock;
+	}
+
+	if (key_types & VIRTIO_BLK_CRYPTO_KEY_TYPE_RAW)
+		key_type_supported |= BLK_CRYPTO_KEY_TYPE_RAW;
+	if (key_types & VIRTIO_BLK_CRYPTO_KEY_TYPE_HW_WRAPPED)
+		key_type_supported |= BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
+
+	err = blk_crypto_profile_init(profile, max_slots);
+	if (err) {
+		dev_err(dev, "crypto profile initialization failed: %d\n", err);
+		goto out_unlock;
+	}
+
+	profile->ll_ops = virtblk_crypto_ops;
+	profile->max_dun_bytes_supported = max_dun_bytes;
+	profile->key_types_supported = key_type_supported;
+	profile->dev = dev;
+	memcpy(profile->modes_supported, crypto_modes_supported,
+	       BLK_ENCRYPTION_MODE_MAX * sizeof(unsigned int));
+
+	virtblk_profile_owner = dev;
+	g_max_slots = max_slots;
+	g_max_dun_bytes = max_dun_bytes;
+	g_key_types = key_types;
+	g_crypto_profile_initialized = true;
+
+	dev_info(dev, "inline crypto profile initialized\n");
+
+out_unlock:
+	mutex_unlock(&virtblk_crypto_init_lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(virtblk_init_inline_crypto);
+
+void virtblk_set_crypto_ops(struct virtblk_crypto_variant_ops *ops)
+{
+	if (!g_crypto_profile_initialized)
+		pr_warn("virtio blk crypto profile hasn't been initialized\n");
+
+	mutex_lock(&virtblk_crypto_ops_lock);
+	g_vdcp.ops = ops;
+	mutex_unlock(&virtblk_crypto_ops_lock);
+}
+EXPORT_SYMBOL_GPL(virtblk_set_crypto_ops);
+
+MODULE_DESCRIPTION("Virtio block inline crypto extension");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio_blk_crypto_ext.h b/include/linux/virtio_blk_crypto_ext.h
new file mode 100644
index 000000000000..3fe66029ac0d
--- /dev/null
+++ b/include/linux/virtio_blk_crypto_ext.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __LINUX_VIRTIO_BLK_CRYPTO_EXT_H
+#define __LINUX_VIRTIO_BLK_CRYPTO_EXT_H
+
+#include <linux/blk-crypto.h>
+
+struct blk_crypto_profile;
+struct blk_crypto_key;
+struct device;
+struct request_queue;
+
+#if IS_ENABLED(CONFIG_VIRTBLK_CRYPTO_VIRTUALIZATION)
+struct virtblk_crypto_variant_ops {
+	/*
+	 * Module providing the function pointers below. virtio_blk_crypto_ext.c
+	 * pins it with try_module_get()/module_put() around every call, so that
+	 * the module implementing these ops can be safely rmmod'd: the unload
+	 * will simply block/fail until no dispatch call is in flight, instead
+	 * of racing with one.
+	 */
+	struct module *owner;
+	int (*program_key)(const struct blk_crypto_key *key,
+			   unsigned int slot);
+	int (*evict_key)(unsigned int slot);
+	int (*derive_sw_secret_key)(const u8 *eph_key, size_t eph_key_size,
+				    u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+	int (*generate_key)(u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+	int (*prepare_key)(const u8 *lt_key, size_t lt_key_size,
+			   u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+	int (*import_key)(const u8 *raw_key, size_t raw_key_size,
+			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+};
+
+/*
+ * Probes the platform's inline-encryption capabilities and initializes the
+ * shared blk_crypto_profile singleton (once) with the keyslot/DUN limits,
+ * supported key types, wrapped key size, and supported crypto modes reported
+ * by the device over virtio config space / VIRTIO_BLK_T_GET_CRYPTO_MODES.
+ *
+ * Safe to call from multiple devices, including concurrently: only the
+ * first caller actually initializes the shared profile, every other caller
+ * just validates its own capabilities against what was already negotiated.
+ */
+int virtblk_init_inline_crypto(unsigned int max_slots, unsigned int max_dun_bytes,
+				unsigned int key_types,
+				const unsigned int crypto_modes_supported[BLK_ENCRYPTION_MODE_MAX],
+				struct device *dev);
+
+/*
+ * Registers the (already-initialized) shared blk_crypto_profile with the
+ * given request queue. Returns false (and leaves the queue without inline
+ * crypto) if the queue's block-integrity support conflicts with inline
+ * encryption; see blk_crypto_register().
+ */
+bool virtblk_crypto_register(struct request_queue *q);
+
+void virtblk_set_crypto_ops(struct virtblk_crypto_variant_ops *ops);
+
+#else
+
+static inline int virtblk_init_inline_crypto(unsigned int max_slots,
+		unsigned int max_dun_bytes, unsigned int key_types,
+		const unsigned int crypto_modes_supported[BLK_ENCRYPTION_MODE_MAX],
+		struct device *dev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline bool virtblk_crypto_register(struct request_queue *q)
+{
+	return false;
+}
+
+
+#endif
+
+#endif /* __LINUX_VIRTIO_BLK_CRYPTO_EXT_H */
diff --git a/include/uapi/linux/virtio_blk.h b/include/uapi/linux/virtio_blk.h
index 3744e4da1b2a..c1941f7fe019 100644
--- a/include/uapi/linux/virtio_blk.h
+++ b/include/uapi/linux/virtio_blk.h
@@ -42,6 +42,7 @@
 #define VIRTIO_BLK_F_WRITE_ZEROES	14	/* WRITE ZEROES is supported */
 #define VIRTIO_BLK_F_SECURE_ERASE	16 /* Secure Erase is supported */
 #define VIRTIO_BLK_F_ZONED		17	/* Zoned block device */
+#define VIRTIO_BLK_F_INLINE_ENCRYPTION		22	/* Inline Encryption is supported */
 
 /* Legacy feature bits */
 #ifndef VIRTIO_BLK_NO_LEGACY
@@ -148,6 +149,18 @@ struct virtio_blk_config {
 		__u8 model;
 		__u8 unused2[3];
 	} zoned;
+
+	/* Inline Encryption device characteristics (if VIRTIO_BLK_F_INLINE_ENCRYPTION) */
+	struct virtio_blk_enc_characteristics {
+		__virtio16 max_slots;
+		__u8 max_dun_bytes;
+/* Bitmask values for virtio_blk_enc_characteristics.key_types */
+#define VIRTIO_BLK_CRYPTO_KEY_TYPE_RAW	(1 << 0)
+#define VIRTIO_BLK_CRYPTO_KEY_TYPE_HW_WRAPPED	(1 << 1)
+		/* Bitmask of supported key types: VIRTIO_BLK_CRYPTO_KEY_TYPE_* */
+		__u8 key_types;
+		__virtio32 unused3;
+	} enc_characteristics;
 } __attribute__((packed));
 
 /*
@@ -206,6 +219,15 @@ struct virtio_blk_config {
 /* Reset All zones command */
 #define VIRTIO_BLK_T_ZONE_RESET_ALL 26
 
+/* Inline-encrypted write: crypto_msg set in outhdr */
+#define VIRTIO_BLK_T_CRYPTO_OUT		27
+
+/* Inline-encrypted read: crypto_msg set in outhdr */
+#define VIRTIO_BLK_T_CRYPTO_IN		28
+
+/* Get inline crypto modes */
+#define VIRTIO_BLK_T_GET_CRYPTO_MODES	30
+
 #ifndef VIRTIO_BLK_NO_LEGACY
 /* Barrier before this op. */
 #define VIRTIO_BLK_T_BARRIER	0x80000000
@@ -225,6 +247,46 @@ struct virtio_blk_outhdr {
 	__virtio64 sector;
 };
 
+/*
+ * Crypto message descriptor, appended to the outhdr of a
+ * VIRTIO_BLK_T_CRYPTO_OUT or VIRTIO_BLK_T_CRYPTO_IN request.
+ */
+struct virtio_blk_crypto_msg {
+	/* virtual key slot index */
+	__virtio32 slot;
+	/* log2 of the data unit size in bytes */
+	__virtio32 data_unit_size_bits;
+	/* data unit number (DUN / IV) for this request */
+	__virtio64 dun;
+};
+
+/*
+ * Crypto mode numbers used in VIRTIO_BLK_T_GET_CRYPTO_MODES replies and in
+ * indexing struct virtio_blk_crypto_modes.modes[] below. These numbers are
+ * assigned by the virtio spec and are stable: a number is never reused for
+ * a different crypto mode, and additional crypto modes are assigned new,
+ * higher numbers.
+ */
+enum {
+	VIRTIO_BLK_CRYPTO_MODE_INVALID,
+	VIRTIO_BLK_CRYPTO_MODE_AES_256_XTS,
+	__VIRTIO_BLK_CRYPTO_MODE_MAX,	/* sentinel: always one past the last real mode */
+};
+
+/* Highest crypto mode number defined by this version of the header. */
+#define VIRTIO_BLK_CRYPTO_MODE_MAX (__VIRTIO_BLK_CRYPTO_MODE_MAX - 1)
+
+/* Reply to a VIRTIO_BLK_T_GET_CRYPTO_MODES request. */
+struct virtio_blk_crypto_modes {
+	/*
+	 * modes[N], for crypto mode number N <= VIRTIO_BLK_CRYPTO_MODE_MAX, is
+	 * a bitmask of the data unit sizes with which crypto mode N can be
+	 * used: bit i is set if a data unit size of (1 << i) bytes is
+	 * supported. modes[0] is reserved and always 0.
+	 */
+	__virtio32 modes[__VIRTIO_BLK_CRYPTO_MODE_MAX];
+};
+
 /*
  * Supported zoned device models.
  */
-- 
2.34.1

