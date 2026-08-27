Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFFB494800
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846926; cv=none; b=ZTAlchFrMr2gNOn4njOqfRzHAin+x9GI4ipopq48YW5fniKi05lCKJA7cPvrdgm5hN/lf+AklJg8nOjvLpGvgHTl9xnvEgdVwi0xMGBPEdt37wh6yQ7lfYXCCvbKw5FKNbxEe2kiYP7ubKUWvny5rJ+BgTqVTzcBDJE8iLMp6dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846926; c=relaxed/simple;
	bh=Dfrg6lE9de3zpyDCOAah5y60csvIaySoJn8fAvjltME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eVZ3E098kIZih7QQZox8ukNCGMBl31rxrNgHRUPDxsl9nA1VOpOyJo8kA4o4fUYG4vzm9aycHe+1cva9cICGeVVveblljDo25quyXfYb/PyxydYJkhGAHU6d4OQ5VuN9e6eAKkBWC08ULw7Mf5wf5rD4PWtrH6orh19VXx6GK1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pA5RVx75; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BUfFdTGD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pA5RVx75";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BUfFdTGD"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RFbltQ1310866
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fg04UKiEaH0S7rfjN0Lg/gctUU1gmD3apjDNgN4QmkY=; b=pA5RVx75UuOZY5r6
	RMJfr6RJYwvQUBLetHCZEdZLlCa0kif9EJN0c/i5eGgkFAmGMln2IkpqaRYvEoWM
	3xTr+7d0OX7RsRV6pa6AH9M/kz2FFc5e+cLr46Mds9FRJPqwZZmwqa445tZ4PR5A
	iTeYcwdUBE0lG1Y7BUMQmD7SIQagJPoyr+19KRYtEUMhmzS1jFCqZnerWAo13bXW
	5QkVJFDIUoz8k1/o7AtUS+XNobHDxwrUIAzcd5wTNN2PUbuFYM0m5lfwmZaAspRi
	FzZnoB7uA1DXcYHq8jz4HPRf49wN2pLTlOhlWomEFJmRz/Gte1FTTHVoS3RdzpnW
	FiAypg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ga8m5kp19-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 16:08:41 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d6f80c76e6so37692475ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 09:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787846921; x=1788451721; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fg04UKiEaH0S7rfjN0Lg/gctUU1gmD3apjDNgN4QmkY=;
        b=BUfFdTGD9qWfer0a/Xh2g+vy2Y6X4jdqM3pnzBPQNvFRNFtMxMKon14deNe+IW0xS/
         1PCfvKz0qxCfeVJ6wApcQTrbUC9gJ0Q7DM9Cbc1+cpBnx3t5fS8Z3ocQrHNLeG6cTL2y
         6N2N6cSYsCKNaLwRlgcXRXSRiMI0cemKkvtoaezkZzJ7DMlgeLHGLOXXPb0Crqp1wLp0
         ct1iXAdAz8m8FDY2HvwhGWAQmg6xc706ybqb9YCL7ZsG9k362KI7cR+AKJMy3yy4QSEE
         j2Ve1BgmsJeUxXhioGnjFaBdTMUKkSbxFmm2fL+biZMSp6Jv81RHubGKcxSq66aDaNN7
         /MZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787846921; x=1788451721;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fg04UKiEaH0S7rfjN0Lg/gctUU1gmD3apjDNgN4QmkY=;
        b=gXeg2IELUO6pyfGC9v3OW3jeiV3fFk4WUlB7Wz3OIJVaVn7Q73Vyrfx1+vqkZ97y18
         pf/lMc5GjHph3E5Jlg7M8IM1sxeE/7pp4iNEFJcAceJl0j28Fab+eUUoJ/2OXm4f/2Rp
         ie5VG+RnPdZ1IG4t1r/JRcV7kmSsIFfP7DqriRTn+MuAXrMjSmj0v6cPzJjmhIz8Zgne
         a/lGI6lPqRa5brh/kVSbBr+M4I5FueJbphiLNHCORCfclcvz6oHH+JDQ85wCBs0/VL2d
         j7YpaQASLwjhjmXWYBD936tPBh5kPVBVQiQdMFtOO5v38TIMxB9qQ/f1r6FWJMotuYqP
         IyxQ==
X-Forwarded-Encrypted: i=1; AHgh+RoUnoaNFLIQQwvHFeMZGeKJanxrqocMl5pNqCGaCqEbaNC2PjgTfORKDrp2M2gMvJRorWLgpRcmIV1x@vger.kernel.org
X-Gm-Message-State: AFuF++nRDJZLYivxzf/eb7T28RwQmJUjy0DyUsigk3d2/Cknp0lvas32
	MCxkK2to9s2y3E6pwkkQ8ztFNbUg16EQS4gpU5qqeUe0AS9TJ6wqhld0RZKqQwh3/VvsjUlOWk4
	Btbxw+yO/XHOJzs7OoKPPptdTBNNQU0y841GeXaHbkcXWUvmnYneE7OK5I6DZ2WWz
X-Gm-Gg: AR+sD13vqwUnOWunx8PRJoIWrusNeyZMAh7Ual5ti3+8X8F2NPLD0ojVJErrciSr+Au
	gNUH8W7QXY+CN1nz6y9qlVAIqWppEVoBnulES/4hbx620Gn80VD1rbdCijU6TI516bZskwCBXfL
	vgusYn6J06NHebIcLgK/dr34Bjiam98l6j2PKvqpSmH1NhMSPol8LjvFiTeUUilur1d1Q3GzdMf
	vAGg39ec6vfoT3x4twe40US8QxHiIBoJddEiK7Fj7f4pf1WGHNmN24lndWG7VG3Xk/rBg0+79wN
	qWa0ScMOOJxU7LmljFCoivf8ZgqbtHwMsL1MijzoxYgjdsY7dX8DxwMe7EcD0dGxZI5osr+IbeN
	Ccm88WosEvqNxliTxBIqymqjLP4AGa1yfwHh5EdTKw4+g0yEhUtALXArneXA=
X-Received: by 2002:a17:90b:520f:b0:37c:6130:7a5b with SMTP id 98e67ed59e1d1-396d0ec0d70mr617876a91.8.1787846920229;
        Thu, 27 Aug 2026 09:08:40 -0700 (PDT)
X-Received: by 2002:a17:90b:520f:b0:37c:6130:7a5b with SMTP id 98e67ed59e1d1-396d0ec0d70mr617665a91.8.1787846919411;
        Thu, 27 Aug 2026 09:08:39 -0700 (PDT)
Received: from u24-san1p10108.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd9085sm3245892a91.12.2026.08.27.09.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 09:08:39 -0700 (PDT)
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
Subject: [PATCH v1 08/11] block: add /dev/blk-crypto-proxy for host-side virtio-blk inline encryption
Date: Thu, 27 Aug 2026 09:07:17 -0700
Message-ID: <20260827160806.1295313-9-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: SktCfu79yEvkilc6lJqysbZCymq2dLh-
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfXx9u8i/YtUu6O
 /8UMFdTCIGpyMDuotBeZrFljHu0NJIIXhd6m91IFHqyx8BaJInva3PUZ2xDrkvkKhQmm4scW6b0
 QrX3um3o7p2j/EM3xTx6wdFPqIJ/iu0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX0YmsyFIK1VTV
 8jWqadcNqRpZi8l7MoSL7Hc95Qz7BCIdJooh3xnV0lMSSprn1GIeDoeWxVrI4UWxrhETczCyTt/
 Zpd6Jr6Ppql94Pk7iNxbnd99OkIaHR5xGMRQuxiQYlW5IPIWY9kt1jfiX+hYvHmOQsin8b0gsY8
 6+PpCWbRF3MrGWs1ca5OpkBuIecn9Hh8DYHv9UuegqlrsSW4I0NYzy9Aon3blxZ+K0c2NFnvscT
 wevFYm58bMW6lZWOEZozm59uDxQr2mUa3YPIe0IizB6YdyGcJx0ij5qbnqDxmnIb9WVJfhtFp8P
 Dt7jdPPNJCm3vNCoXquVQ1yKmGcD9TkGfhTG9XWT8chdz4R0p48VliCCnJa64nrSX+Y0a0arcKr
 1TUVBT+nrje5frOrJ+iI3ayqGVHaU927VVgaPbz1QOmJrbqJ1LqIz/zTIxAhBMzHsvJxt2nnyW8
 mfydmGvTSfc8aTF8U+w==
X-Proofpoint-GUID: SktCfu79yEvkilc6lJqysbZCymq2dLh-
X-Authority-Analysis: v=2.4 cv=SomgLvO0 c=1 sm=1 tr=0 ts=6a906109 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=WH_6LjaRQCbUvFa_ckcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_07,2026-08-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270136

From: linlzhan <linlin.zhang@oss.qualcomm.com>

A userspace virtio-blk backend receives VIRTIO_BLK_T_CRYPTO_IN/OUT
requests from guests that carry a virtual ICE keyslot index and a data
unit number.  The backend must submit the bio to the host storage
controller with the correct inline encryption context, but it has
no in-kernel interface to do so.

Add /dev/blk-crypto-proxy, a misc character device that bridges a
userspace virtio-blk backend to the kernel blk-crypto layer.  The
interface is three ioctls:

  BCP_BIND_CONTEXT      — bind a host block device fd and a hypervisor
                          VM fd to this file descriptor; the kernel
                          resolves the VM fd to a guest id and holds
                          the bdev reference for the fd lifetime.
  BCP_GET_CRYPTO_CAPS   — query the bound device's blk_crypto_profile
                          capabilities (supported modes, key types, max
                          DUN bytes) and the number of ICE keyslots
                          allocated to the bound VM, so the backend can
                          populate the virtio config space crypto fields.
  BCP_SUBMIT_IO_BY_VSLOT — submit an inline-encrypted bio using the
                          virtual slot index supplied by the guest.  The
                          kernel resolves virt_slot to a physical ICE
                          keyslot via bcp_slot_virt_ops, calls
                          bio_crypt_set_ctx_by_slot(), and submits the
                          bio synchronously.  Large requests are split
                          at data-unit boundaries (BIO_MAX_VECS per bio)
                          to preserve DUN/IV correctness. The
                          implementation follows the block layer's
                          direct-I/O path, with two differences: each
                          bio carries an inline encryption context, and
                          multiple bios are submitted sequentially
                          rather than concurrently now.

The driver is hypervisor-agnostic and storage-vendor-agnostic.  Two
pluggable op-sets registered by platform drivers fill the gaps:

  bcp_hypervisor_ops  — translate a hypervisor VM fd to an opaque
                        guest_id; implemented by the hypervisor driver.
  bcp_slot_virt_ops   — map (profile, guest_id, virt_slot) to a
                        physical ICE keyslot; implemented by the
                        platform storage virtualization layer.

Both op-sets are RCU-protected singletons; the hot path reads them
lock-free.

Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
---
 drivers/block/Kconfig                 |  15 +
 drivers/block/Makefile                |   1 +
 drivers/block/blk-crypto-proxy.c      | 667 ++++++++++++++++++++++++++
 include/linux/blk-crypto-proxy.h      | 100 ++++
 include/uapi/linux/blk-crypto-proxy.h | 122 +++++
 5 files changed, 905 insertions(+)
 create mode 100644 drivers/block/blk-crypto-proxy.c
 create mode 100644 include/linux/blk-crypto-proxy.h
 create mode 100644 include/uapi/linux/blk-crypto-proxy.h

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 7790ee2c700c..48ad79734c09 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -176,6 +176,21 @@ config BLK_DEV_LOOP
 
 	  Most users will answer N here.
 
+config BLK_CRYPTO_PROXY
+	tristate "Inline encryption proxy for virtio-blk guests"
+	depends on BLK_INLINE_ENCRYPTION
+	help
+	  Provides /dev/blk-crypto-proxy, a misc character device that allows a
+	  userspace virtio-blk backend to submit inline-encrypted block I/O
+	  on behalf of guest virtual machines.
+
+	  Guests supply a virtual keyslot index and data unit number with
+	  each encrypted request.  The host kernel translates the virtual
+	  slot to a physical hardware keyslot and issues the bio to the
+	  storage controller with the correct inline encryption context.
+
+	  If unsure, say N.
+
 config BLK_DEV_LOOP_MIN_COUNT
 	int "Number of loop devices to pre-create at init time"
 	depends on BLK_DEV_LOOP
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 079c910d5fc9..636137248d0d 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_BLK_DEV_LOOP)	+= loop.o
 obj-$(CONFIG_SUNVDC)		+= sunvdc.o
 
 obj-$(CONFIG_BLK_DEV_NBD)	+= nbd.o
+obj-$(CONFIG_BLK_CRYPTO_PROXY)	+= blk-crypto-proxy.o
 obj-$(CONFIG_VIRTIO_BLK)	+= virtio_blk.o
 
 obj-$(CONFIG_VIRTBLK_CRYPTO_VIRTUALIZATION) += virtio_blk_crypto_ext.o
diff --git a/drivers/block/blk-crypto-proxy.c b/drivers/block/blk-crypto-proxy.c
new file mode 100644
index 000000000000..60722884dbcd
--- /dev/null
+++ b/drivers/block/blk-crypto-proxy.c
@@ -0,0 +1,667 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt) "blk-crypto-proxy: " fmt
+
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+#include <linux/mutex.h>
+#include <linux/overflow.h>
+#include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/rcupdate.h>
+#include <linux/uio.h>
+#include <linux/blk-crypto.h>
+#include <linux/blk-crypto-profile.h>
+#include <linux/blk-crypto-proxy.h>
+#include <linux/virtio_blk.h>
+
+static const struct bcp_hypervisor_ops __rcu *g_hypervisor_ops;
+static DEFINE_MUTEX(g_hypervisor_ops_lock);
+
+static const struct bcp_slot_virt_ops __rcu *g_slot_virt_ops;
+static DEFINE_MUTEX(g_slot_virt_ops_lock);
+
+int bcp_register_hypervisor_ops(const struct bcp_hypervisor_ops *ops)
+{
+	int ret = 0;
+
+	mutex_lock(&g_hypervisor_ops_lock);
+	if (rcu_access_pointer(g_hypervisor_ops))
+		ret = -EBUSY;
+	else
+		rcu_assign_pointer(g_hypervisor_ops, ops);
+	mutex_unlock(&g_hypervisor_ops_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bcp_register_hypervisor_ops);
+
+void bcp_unregister_hypervisor_ops(const struct bcp_hypervisor_ops *ops)
+{
+	mutex_lock(&g_hypervisor_ops_lock);
+	if (rcu_access_pointer(g_hypervisor_ops) == ops)
+		rcu_assign_pointer(g_hypervisor_ops, NULL);
+	mutex_unlock(&g_hypervisor_ops_lock);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(bcp_unregister_hypervisor_ops);
+
+int bcp_register_slot_virt_ops(const struct bcp_slot_virt_ops *ops)
+{
+	int ret = 0;
+
+	mutex_lock(&g_slot_virt_ops_lock);
+	if (rcu_access_pointer(g_slot_virt_ops))
+		ret = -EBUSY;
+	else
+		rcu_assign_pointer(g_slot_virt_ops, ops);
+	mutex_unlock(&g_slot_virt_ops_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bcp_register_slot_virt_ops);
+
+void bcp_unregister_slot_virt_ops(const struct bcp_slot_virt_ops *ops)
+{
+	mutex_lock(&g_slot_virt_ops_lock);
+	if (rcu_access_pointer(g_slot_virt_ops) == ops)
+		rcu_assign_pointer(g_slot_virt_ops, NULL);
+	mutex_unlock(&g_slot_virt_ops_lock);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(bcp_unregister_slot_virt_ops);
+
+/**
+ * struct bcp_ctx - per-fd state for /dev/blk-crypto-proxy
+ * @bdev_file: file handle for the bound block device; NULL until BCP_BIND_CONTEXT.
+ *             Published with smp_store_release() so hot-path ioctls can read it
+ *             lock-free via smp_load_acquire() in bcp_ctx_bound().
+ * @guest_id: guest identifier resolved from vm_fd at bind time.
+ * @bdev_writable: block_dev_fd was opened with write access.
+ * @bind_lock: serializes concurrent BCP_BIND_CONTEXT calls on this fd.
+ */
+struct bcp_ctx {
+	struct file *bdev_file;
+	u32 guest_id;
+	bool bdev_writable;
+	struct mutex bind_lock;
+};
+
+/*
+ * True once BCP_BIND_CONTEXT has published ctx->bdev_file.  The acquire pairs
+ * with smp_store_release() in bcp_ioctl_bind_context(), ensuring ctx->guest_id
+ * and ctx->bdev_writable are visible to any caller that observes true.
+ */
+static bool bcp_ctx_bound(struct bcp_ctx *ctx)
+{
+	return smp_load_acquire(&ctx->bdev_file) != NULL;
+}
+
+static int bcp_open(struct inode *inode, struct file *file)
+{
+	struct bcp_ctx *ctx;
+
+	ctx = kzalloc_obj(*ctx, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	mutex_init(&ctx->bind_lock);
+	file->private_data = ctx;
+	return 0;
+}
+
+static int bcp_release(struct inode *inode, struct file *file)
+{
+	struct bcp_ctx *ctx = file->private_data;
+
+	if (ctx) {
+		if (ctx->bdev_file)
+			bdev_fput(ctx->bdev_file);
+		mutex_destroy(&ctx->bind_lock);
+		kfree(ctx);
+		file->private_data = NULL;
+	}
+	return 0;
+}
+
+/*
+ * Resolve a userspace block device fd to a struct file holding a reference
+ * to the block device, opened with the same access mode as @fd so that a
+ * read-only fd cannot gain write access via BCP_SUBMIT_IO_BY_VSLOT.
+ */
+static struct file *bcp_bdev_from_fd(int fd, bool *writable)
+{
+	struct file *f;
+	struct inode *inode;
+	dev_t dev;
+	blk_mode_t mode = 0;
+
+	f = fget(fd);
+	if (!f)
+		return ERR_PTR(-EBADF);
+	inode = file_inode(f);
+	if (!S_ISBLK(inode->i_mode)) {
+		fput(f);
+		return ERR_PTR(-ENOTBLK);
+	}
+	if (f->f_mode & FMODE_READ)
+		mode |= BLK_OPEN_READ;
+	if (f->f_mode & FMODE_WRITE)
+		mode |= BLK_OPEN_WRITE;
+	if (!mode) {
+		fput(f);
+		return ERR_PTR(-EACCES);
+	}
+	*writable = !!(mode & BLK_OPEN_WRITE);
+	dev = inode->i_rdev;
+	fput(f);
+	return bdev_file_open_by_dev(dev, mode, NULL, NULL);
+}
+
+static long bcp_ioctl_bind_context(struct file *file,
+				   struct bcp_bind_context_arg __user *argp)
+{
+	struct bcp_ctx *ctx = file->private_data;
+	struct bcp_bind_context_arg arg;
+	const struct bcp_hypervisor_ops *hv_ops;
+	struct file *bdev_file;
+	u32 guest_id;
+	bool writable = false;
+	int ret;
+
+	if (!ctx)
+		return -EINVAL;
+	if (copy_from_user(&arg, argp, sizeof(arg)))
+		return -EFAULT;
+	if (arg.reserved)
+		return -EINVAL;
+
+	/*
+	 * get_guest_id() may sleep; call it before taking bind_lock.
+	 */
+	rcu_read_lock();
+	hv_ops = rcu_dereference(g_hypervisor_ops);
+	if (!hv_ops) {
+		rcu_read_unlock();
+		return -EOPNOTSUPP;
+	}
+	ret = hv_ops->get_guest_id(arg.vm_fd, &guest_id);
+	rcu_read_unlock();
+	if (ret)
+		return ret;
+
+	/*
+	 * Serialize against concurrent BCP_BIND_CONTEXT calls: two callers
+	 * could both pass the ctx->bdev_file == NULL check before either stores.
+	 */
+	guard(mutex)(&ctx->bind_lock);
+
+	if (ctx->bdev_file)
+		return -EBUSY;
+
+	bdev_file = bcp_bdev_from_fd(arg.block_dev_fd, &writable);
+	if (IS_ERR(bdev_file))
+		return PTR_ERR(bdev_file);
+
+	ctx->guest_id = guest_id;
+	ctx->bdev_writable = writable;
+	/*
+	 * Publish ctx->bdev_file last with a release barrier; bcp_ctx_bound()
+	 * reads it with smp_load_acquire() without taking @bind_lock.
+	 */
+	smp_store_release(&ctx->bdev_file, bdev_file);
+	return 0;
+}
+
+/*
+ * Maps VIRTIO_BLK_CRYPTO_MODE_* to enum blk_crypto_mode_num.  The two index
+ * spaces do not coincide, so modes_supported[] must not be copied positionally.
+ * Keep in sync with virtio_blk_crypto_mode_map[] in drivers/block/virtio_blk.c.
+ */
+static const enum blk_crypto_mode_num
+	bcp_virtio_crypto_mode_map[VIRTIO_BLK_CRYPTO_MODE_MAX + 1] = {
+	[VIRTIO_BLK_CRYPTO_MODE_INVALID]	= BLK_ENCRYPTION_MODE_INVALID,
+	[VIRTIO_BLK_CRYPTO_MODE_AES_256_XTS]	= BLK_ENCRYPTION_MODE_AES_256_XTS,
+};
+
+static long bcp_ioctl_get_crypto_caps(struct file *file,
+				      struct bcp_get_crypto_caps_arg __user *argp)
+{
+	struct bcp_ctx *ctx = file->private_data;
+	struct bcp_get_crypto_caps_arg arg;
+	struct block_device *bdev;
+	u32 modes[VIRTIO_BLK_CRYPTO_MODE_MAX + 1] = {0};
+	struct blk_crypto_profile *profile;
+	unsigned int i, n;
+	u32 cap, written;
+
+	if (!ctx || !bcp_ctx_bound(ctx))
+		return -ENXIO;
+
+	if (copy_from_user(&arg, argp, sizeof(arg)))
+		return -EFAULT;
+	if (arg.num_modes && !arg.modes_ptr)
+		return -EINVAL;
+
+	bdev = file_bdev(ctx->bdev_file);
+	profile = bdev_get_queue(bdev)->crypto_profile;
+	if (!profile)
+		return -EOPNOTSUPP;
+
+	arg.key_types_supported = profile->key_types_supported;
+	/*
+	 * Clamp to 8: the @dun wire field is a single __aligned_u64 so nothing
+	 * upstream can deliver a wider DUN regardless of what the profile claims.
+	 */
+	arg.max_dun_bytes = min_t(u32, profile->max_dun_bytes_supported, 8);
+
+	/*
+	 * arg.modes_supported[] is indexed by VIRTIO_BLK_CRYPTO_MODE_* (index 0
+	 * is always 0 per the virtio spec).  Translate via the map above; do not
+	 * copy profile->modes_supported[] positionally.
+	 */
+	n = VIRTIO_BLK_CRYPTO_MODE_MAX + 1;
+	cap = arg.num_modes;
+	written = min_t(u32, cap, n);
+
+	for (i = 1; i < n; i++) {
+		enum blk_crypto_mode_num kmode = bcp_virtio_crypto_mode_map[i];
+
+		if (!kmode)
+			continue;
+		modes[i] = profile->modes_supported[kmode];
+	}
+
+	if (written &&
+	    copy_to_user(u64_to_user_ptr(arg.modes_ptr), modes,
+			 written * sizeof(modes[0])))
+		return -EFAULT;
+	arg.num_modes = written;
+
+	arg.max_slots = 0;
+	rcu_read_lock();
+	{
+		const struct bcp_slot_virt_ops *sv_ops =
+				rcu_dereference(g_slot_virt_ops);
+		if (sv_ops) {
+			int nslots = sv_ops->get_guest_slots(profile, ctx->guest_id);
+
+			if (nslots > 0)
+				arg.max_slots = nslots;
+		}
+	}
+	rcu_read_unlock();
+
+	if (copy_to_user(argp, &arg, sizeof(arg)))
+		return -EFAULT;
+	return 0;
+}
+
+/*
+ * Compute the number of pages needed for up to @want_bytes of iovec data
+ * starting at cursor (@start_idx, @start_off).  The page count is capped at
+ * @cap to bound the arithmetic; *bytes_out receives the actual byte count.
+ */
+static unsigned int bcp_iov_pages_for_bytes(const struct iovec *iov, u32 iov_cnt,
+					    u32 start_idx, u64 start_off,
+					      u64 want_bytes, unsigned int cap,
+					      u64 *bytes_out)
+{
+	u64 pages = 0, taken = 0;
+	u32 i;
+
+	for (i = start_idx; i < iov_cnt && taken < want_bytes; i++) {
+		u64 base, len;
+
+		if (i == start_idx) {
+			base = (u64)(uintptr_t)iov[i].iov_base + start_off;
+			len  = iov[i].iov_len - start_off;
+		} else {
+			base = (u64)(uintptr_t)iov[i].iov_base;
+			len  = iov[i].iov_len;
+		}
+		if (len == 0)
+			continue;
+		if (len > want_bytes - taken)
+			len = want_bytes - taken;
+		pages += DIV_ROUND_UP(len + offset_in_page(base), PAGE_SIZE);
+		taken += len;
+		if (pages >= cap) {
+			*bytes_out = taken;
+			return cap;
+		}
+	}
+	*bytes_out = taken;
+	return (unsigned int)pages;
+}
+
+/*
+ * Advance cursor (*idx, *off) forward by @bytes within @iov[0..iov_cnt).
+ */
+static void bcp_iov_advance_cursor(const struct iovec *iov, u32 iov_cnt,
+				   u32 *idx, u64 *off, u64 bytes)
+{
+	while (bytes > 0 && *idx < iov_cnt) {
+		u64 seg_remaining = iov[*idx].iov_len - *off;
+		u64 take = min_t(u64, seg_remaining, bytes);
+
+		*off += take;
+		bytes -= take;
+		if (*off == iov[*idx].iov_len) {
+			(*idx)++;
+			*off = 0;
+		}
+	}
+}
+
+static long bcp_ioctl_submit_io_by_vslot(struct file *file,
+					 struct bcp_submit_io_by_vslot_arg __user *argp)
+{
+	struct bcp_ctx *ctx = file->private_data;
+	struct bcp_submit_io_by_vslot_arg arg;
+	struct block_device *bdev;
+	struct blk_crypto_profile *profile;
+	struct iovec *iov = NULL;
+	struct iov_iter iter;
+	struct blk_crypto_slot slot;
+	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
+	u64 bytes_done = 0;
+	u64 align, stride;
+	u64 total_bytes;
+	u32 seg_idx = 0;
+	u64 seg_off = 0;
+	unsigned int phy_slot;
+	int ret = -EFAULT;
+
+	if (!ctx || !bcp_ctx_bound(ctx))
+		return -ENXIO;
+
+	if (copy_from_user(&arg, argp, sizeof(arg)))
+		return -EFAULT;
+	if (arg.reserved2)
+		return -EINVAL;
+
+	bdev = file_bdev(ctx->bdev_file);
+
+	if (arg.direction != BCP_DIR_READ && arg.direction != BCP_DIR_WRITE)
+		return -EINVAL;
+	/*
+	 * blk_mode_t does not stop submit_bio() from writing; enforce the
+	 * caller's original fd permission explicitly.
+	 */
+	if (arg.direction == BCP_DIR_WRITE && !ctx->bdev_writable)
+		return -EACCES;
+	/*
+	 * bdev_read_only() can change after bind time; submit_bio_noacct()'s
+	 * bio_check_ro() only warns rather than errors in this kernel.
+	 */
+	if (arg.direction == BCP_DIR_WRITE && bdev_read_only(bdev))
+		return -EROFS;
+	if (arg.flags != BCP_SUBMIT_IO_F_IOV)
+		return -EINVAL;
+	if (arg.iov_cnt == 0 || arg.iov_cnt > BCP_MAX_IOV)
+		return -EINVAL;
+	/* A shift amount >= 64 would be undefined behavior. */
+	if (arg.data_unit_size_bits >= 64)
+		return -EINVAL;
+
+	profile = bdev_get_queue(bdev)->crypto_profile;
+	if (!profile)
+		return -EOPNOTSUPP;
+
+	/* Resolve virt_slot → phy_slot. */
+	rcu_read_lock();
+	{
+		const struct bcp_slot_virt_ops *sv_ops =
+				rcu_dereference(g_slot_virt_ops);
+		if (!sv_ops) {
+			rcu_read_unlock();
+			return -EOPNOTSUPP;
+		}
+		ret = sv_ops->vslot_to_pslot(profile, ctx->guest_id,
+					     arg.virt_slot, &phy_slot);
+	}
+	rcu_read_unlock();
+	if (ret)
+		return ret;
+
+	memset(dun, 0, sizeof(dun));
+	dun[0] = arg.dun;
+
+	slot.phy_slot            = phy_slot;
+	slot.data_unit_size_bits = arg.data_unit_size_bits;
+
+	align = 1ULL << arg.data_unit_size_bits;
+	/*
+	 * Split bios at stride (smallest multiple of the data unit size >=
+	 * PAGE_SIZE) boundaries so each bio ends on a whole data unit.
+	 * bio_crypt_check_alignment() is skipped for slot-based bios (bc_key
+	 * == NULL), so a mid-unit split would silently mis-encrypt/mis-decrypt.
+	 */
+	stride = DIV_ROUND_UP(PAGE_SIZE, align) * align;
+
+	/*
+	 * Import the caller's iovec once.  import_iovec() validates every
+	 * segment with access_ok(), returns the total byte count, and takes a
+	 * private kernel copy that eliminates TOCTOU from a guest mutating its
+	 * own iovec array mid-ioctl.
+	 */
+	ret = import_iovec(arg.direction == BCP_DIR_READ ? ITER_DEST : ITER_SOURCE,
+			   (const struct iovec __user *)u64_to_user_ptr(arg.iov_ptr),
+			   arg.iov_cnt, 0, &iov, &iter);
+	if (ret < 0)
+		return ret;
+	total_bytes = ret;
+
+	/*
+	 * Reject a misaligned total length up front: bio_crypt_check_alignment()
+	 * is skipped for slot-based bios so nothing downstream will catch it.
+	 */
+	if (total_bytes == 0 || (total_bytes & (align - 1)) ||
+	    (total_bytes & (SECTOR_SIZE - 1))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Fail fast if the request exceeds the device.  bio_check_eod() would
+	 * also catch this, but only on the last bio after earlier bios have
+	 * already done real I/O.
+	 */
+	{
+		sector_t nr_sectors = total_bytes >> SECTOR_SHIFT;
+		sector_t maxsector = bdev_nr_sectors(bdev);
+
+		if (nr_sectors > maxsector || arg.sector > maxsector - nr_sectors) {
+			ret = -EIO;
+			goto out;
+		}
+	}
+
+	/*
+	 * Reject an out-of-range DUN: slot-based bios skip
+	 * bio_crypt_check_alignment(), so an overflow would silently truncate
+	 * in the hardware DUN field rather than error out.
+	 */
+	{
+		u64 total_units = total_bytes >> arg.data_unit_size_bits;
+		u64 max_dun_used, dun_limit;
+
+		if (check_add_overflow(arg.dun, total_units - 1, &max_dun_used)) {
+			ret = -EINVAL;
+			goto out;
+		}
+		dun_limit = profile->max_dun_bytes_supported >= 8 ? U64_MAX :
+			(1ULL << (8 * profile->max_dun_bytes_supported)) - 1;
+		if (max_dun_used > dun_limit) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	/*
+	 * Submit the request as a sequence of bios (submit_bio_wait() per
+	 * bio), each holding at most BIO_MAX_VECS pages.  Sequential
+	 * submission avoids DUN/IV correctness concerns across concurrent
+	 * in-flight bios.
+	 */
+	while (seg_idx < arg.iov_cnt) {
+		unsigned int pages_used = 0;
+		u64 bio_bytes = 0;
+		u32 la_idx = seg_idx;
+		u64 la_off = seg_off;
+		u64 remaining_before;
+		struct bio *bio;
+
+		/*
+		 * Lookahead: count how many whole stride units fit within a
+		 * fresh bio's BIO_MAX_VECS page budget.
+		 */
+		for (;;) {
+			u64 unit_bytes;
+			unsigned int unit_pages;
+
+			unit_pages = bcp_iov_pages_for_bytes(iov, arg.iov_cnt,
+							     la_idx, la_off, stride,
+							BIO_MAX_VECS + 1,
+							&unit_bytes);
+			if (unit_bytes == 0)
+				break; /* only empty segments remain */
+
+			if (pages_used + unit_pages > BIO_MAX_VECS) {
+				if (pages_used == 0) {
+					/* data_unit_size_bits too large to fit one unit. */
+					ret = -EINVAL;
+					goto out;
+				}
+				break; /* finalize this bio; unit deferred to next */
+			}
+
+			pages_used += unit_pages;
+			bio_bytes  += unit_bytes;
+			bcp_iov_advance_cursor(iov, arg.iov_cnt, &la_idx, &la_off,
+					       unit_bytes);
+		}
+
+		if (bio_bytes == 0)
+			break;
+
+		bio = bio_alloc(bdev, pages_used,
+				arg.direction == BCP_DIR_WRITE ?
+					REQ_OP_WRITE : REQ_OP_READ,
+				GFP_KERNEL);
+		if (!bio) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		bio->bi_iter.bi_sector = arg.sector + (bytes_done >> SECTOR_SHIFT);
+
+		/*
+		 * Use bio_iov_iter_get_pages() to pin pages into the bio,
+		 * the same as the O_DIRECT path.  Truncate the iter to this
+		 * bio's byte budget, then reexpand for the next iteration.
+		 */
+		remaining_before = iov_iter_count(&iter);
+		iov_iter_truncate(&iter, bio_bytes);
+		ret = bio_iov_iter_get_pages(bio, &iter, 0, 0);
+		if (ret < 0) {
+			bio_put(bio);
+			goto out;
+		}
+		if (iov_iter_count(&iter) != 0) {
+			/*
+			 * The lookahead verified bio_bytes fits in BIO_MAX_VECS;
+			 * if bio_iov_iter_get_pages() stopped early, its page
+			 * accounting disagreed with bcp_iov_pages_for_bytes().
+			 */
+			bio_put(bio);
+			ret = -EIO;
+			goto out;
+		}
+		iov_iter_reexpand(&iter, remaining_before - bio_bytes);
+
+		/*
+		 * Match __blkdev_direct_IO(): mark pages dirty on reads into
+		 * user-backed memory.
+		 */
+		if (arg.direction == BCP_DIR_READ && user_backed_iter(&iter))
+			bio_set_pages_dirty(bio);
+
+		bcp_iov_advance_cursor(iov, arg.iov_cnt, &seg_idx, &seg_off,
+				       bio_bytes);
+
+		bio_crypt_set_ctx_by_slot(bio, &slot, dun, GFP_KERNEL);
+
+		ret = submit_bio_wait(bio);
+		bio_put(bio);
+		if (ret)
+			goto out;
+
+		/*
+		 * Advance dun by this bio's contribution only, not by
+		 * recomputing from arg.dun + bytes_done, to avoid silent
+		 * truncation when bytes_done grows past UINT_MAX data units.
+		 */
+		bio_crypt_dun_increment(dun, (unsigned int)(bio_bytes >> arg.data_unit_size_bits));
+		bytes_done += bio_bytes;
+	}
+	ret = 0;
+
+out:
+	kfree(iov);
+	return ret;
+}
+
+static long bcp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+
+	switch (cmd) {
+	case BCP_BIND_CONTEXT:
+		return bcp_ioctl_bind_context(file, argp);
+	case BCP_GET_CRYPTO_CAPS:
+		return bcp_ioctl_get_crypto_caps(file, argp);
+	case BCP_SUBMIT_IO_BY_VSLOT:
+		return bcp_ioctl_submit_io_by_vslot(file, argp);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static const struct file_operations bcp_fops = {
+	.owner		= THIS_MODULE,
+	.open		= bcp_open,
+	.release	= bcp_release,
+	.unlocked_ioctl	= bcp_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
+};
+
+static struct miscdevice bcp_misc = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "blk-crypto-proxy",
+	.fops	= &bcp_fops,
+};
+
+static int __init blk_crypto_proxy_init(void)
+{
+	int ret;
+
+	ret = misc_register(&bcp_misc);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+static void __exit blk_crypto_proxy_exit(void)
+{
+	misc_deregister(&bcp_misc);
+}
+
+module_init(blk_crypto_proxy_init);
+module_exit(blk_crypto_proxy_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Host-side inline crypto proxy for virtio-blk guests");
diff --git a/include/linux/blk-crypto-proxy.h b/include/linux/blk-crypto-proxy.h
new file mode 100644
index 000000000000..6cf1ff0703e9
--- /dev/null
+++ b/include/linux/blk-crypto-proxy.h
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __LINUX_BLK_CRYPTO_PROXY_H
+#define __LINUX_BLK_CRYPTO_PROXY_H
+
+#include <uapi/linux/blk-crypto-proxy.h>
+#include <linux/types.h>
+
+struct blk_crypto_profile;
+
+/**
+ * struct bcp_hypervisor_ops - hypervisor VM identity operations
+ *
+ * Translates a hypervisor-specific VM fd to the opaque u32 vm_id used
+ * throughout blk-crypto-proxy.  Register once at module init time.
+ */
+struct bcp_hypervisor_ops {
+	/**
+	 * @get_guest_id: Resolve @vm_fd to an opaque guest identifier.
+	 *
+	 * Verify the caller is permitted to act on behalf of the VM and write
+	 * its u32 id to @guest_id_out.  The value is passed verbatim to
+	 * bcp_slot_virt_ops callbacks.
+	 *
+	 * Returns 0 on success, -errno on failure.
+	 */
+	int (*get_guest_id)(int vm_fd, u32 *guest_id_out);
+};
+
+/**
+ * bcp_register_hypervisor_ops() - register the hypervisor op-set
+ * @ops: op-set to register; must remain valid until unregistered.
+ *
+ * Returns 0 on success, -EBUSY if an op-set is already registered.
+ */
+int bcp_register_hypervisor_ops(const struct bcp_hypervisor_ops *ops);
+
+/**
+ * bcp_unregister_hypervisor_ops() - unregister the hypervisor op-set
+ * @ops: must be the pointer that was passed to bcp_register_hypervisor_ops().
+ *
+ * Blocks until all in-flight callers have finished, then clears the
+ * registration.  Safe to call from module exit.
+ */
+void bcp_unregister_hypervisor_ops(const struct bcp_hypervisor_ops *ops);
+
+/**
+ * struct bcp_slot_virt_ops - ICE keyslot virtualization operations
+ *
+ * Per-VM ICE keyslot accounting and virtual-to-physical slot translation.
+ * The implementation owns the slot allocation table and is registered once
+ * at platform driver probe time.
+ *
+ * @profile is passed to every callback so an implementation supporting
+ * multiple storage controllers can distinguish between them.
+ *
+ * All callbacks may be called concurrently and must not sleep (called
+ * under RCU read lock).
+ */
+struct bcp_slot_virt_ops {
+	/**
+	 * @get_guest_slots: Return the number of ICE keyslots allocated to @guest_id.
+	 *
+	 * Returns the slot count (≥ 1) on success, -ENOKEY if @guest_id is
+	 * not in the allocation table.
+	 */
+	int (*get_guest_slots)(struct blk_crypto_profile *profile, u32 guest_id);
+
+	/**
+	 * @vslot_to_pslot: Translate a VM-local virtual slot to a physical slot.
+	 * @guest_id:       hypervisor-assigned VM identifier.
+	 * @virt_slot:   0-based slot index within @guest_id's allocation.
+	 * @phy_slot_out: receives the physical ICE keyslot index on success.
+	 *
+	 * Returns 0 on success, -ENOKEY if @guest_id is unknown, -EINVAL if
+	 * @virt_slot >= the VM's allocation.
+	 */
+	int (*vslot_to_pslot)(struct blk_crypto_profile *profile,
+			      u32 guest_id, u32 virt_slot,
+			      unsigned int *phy_slot_out);
+};
+
+/**
+ * bcp_register_slot_virt_ops() - register the slot-virt op-set
+ * @ops: op-set to register; must remain valid until unregistered.
+ *
+ * Returns 0 on success, -EBUSY if an op-set is already registered.
+ */
+int bcp_register_slot_virt_ops(const struct bcp_slot_virt_ops *ops);
+
+/**
+ * bcp_unregister_slot_virt_ops() - unregister the slot-virt op-set
+ * @ops: must be the pointer passed to bcp_register_slot_virt_ops().
+ *
+ * Blocks until all in-flight callers have finished, then clears the
+ * registration.  Safe to call from module exit.
+ */
+void bcp_unregister_slot_virt_ops(const struct bcp_slot_virt_ops *ops);
+
+#endif /* __LINUX_BLK_CRYPTO_PROXY_H */
diff --git a/include/uapi/linux/blk-crypto-proxy.h b/include/uapi/linux/blk-crypto-proxy.h
new file mode 100644
index 000000000000..dc8adc8ef5ed
--- /dev/null
+++ b/include/uapi/linux/blk-crypto-proxy.h
@@ -0,0 +1,122 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef __UAPI_LINUX_BLK_CRYPTO_PROXY_H
+#define __UAPI_LINUX_BLK_CRYPTO_PROXY_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define BCP_DIR_READ     0
+#define BCP_DIR_WRITE    1
+
+/*
+ * BCP_BIND_CONTEXT - bind a host block device and hypervisor VM fd.
+ *
+ * Must be called once after open(), before any other ioctl.
+ * Returns -EBUSY if already bound, -EOPNOTSUPP if no hypervisor op-set
+ * is registered.
+ *
+ * @block_dev_fd: fd of the host block device to bind.
+ * @vm_fd:        hypervisor VM fd identifying the guest.
+ * @reserved:     must be zero.
+ */
+struct bcp_bind_context_arg {
+	__s32 block_dev_fd;
+	__s32 vm_fd;
+	__u32 reserved;
+};
+
+/*
+ * BCP_GET_CRYPTO_CAPS - query crypto capabilities of the bound block device.
+ *
+ * Requires BCP_BIND_CONTEXT; returns -ENXIO otherwise.
+ *
+ * @key_types_supported:  [out] BLK_CRYPTO_KEY_TYPE_* bitmask.
+ * @max_dun_bytes:        [out] maximum DUN bytes supported.
+ * @max_slots:            [out] maximum ICE keyslots available for the bound VM;
+ *                              0 if the VM is not found in the table.
+ * @num_modes:            [in] capacity of the buffer pointed to by @modes_ptr,
+ *                              in entries. [out] number of entries actually
+ *                              written to @modes_ptr (may be less than the
+ *                              given capacity; the caller must use this
+ *                              value, not its own capacity, to know how many
+ *                              entries are valid).
+ * @modes_ptr:             [in] pointer to a caller-allocated __u32 array of
+ *                              at least @num_modes (as given) entries. Must
+ *                              be non-NULL if @num_modes (as given) is > 0.
+ *                              On return, holds a per-mode data_unit_size
+ *                              bitmask array indexed by VIRTIO_BLK_CRYPTO_MODE_*
+ *                              (virtio wire numbering, uapi/linux/virtio_blk.h)
+ *                              -- NOT by enum blk_crypto_mode_num. Index 0 is
+ *                              reserved and always 0, matching struct
+ *                              virtio_blk_crypto_modes.modes[].
+ *
+ * @modes_ptr is a pointer + count rather than a fixed-size array embedded in
+ * this struct so that sizeof(struct bcp_get_crypto_caps_arg) -- and hence the
+ * _IOWR-encoded ioctl number -- does not depend on VIRTIO_BLK_CRYPTO_MODE_MAX.
+ * The caller and this kernel may be built against different virtio_blk.h
+ * versions (and thus different values of that constant); embedding a
+ * VIRTIO_BLK_CRYPTO_MODE_MAX-sized array directly in this struct would make
+ * the ioctl fail to even dispatch (-ENOTTY) whenever the two disagree.
+ */
+
+struct bcp_get_crypto_caps_arg {
+	__u32 key_types_supported;
+	__u32 max_dun_bytes;
+	__u32 max_slots;
+	__u32 num_modes;
+	__aligned_u64 modes_ptr;
+};
+
+/*
+ * BCP_SUBMIT_IO_BY_VSLOT - submit an encrypted bio using a virtual slot.
+ *
+ * The kernel resolves virt_slot to a physical ICE keyslot and submits the
+ * I/O synchronously.  Large requests are split at data-unit boundaries
+ * (BIO_MAX_VECS pages per bio).  Requires BCP_BIND_CONTEXT; returns -ENXIO
+ * otherwise.
+ *
+ * @virt_slot:           guest-visible slot index (0-based within the VM's range).
+ * @direction:           BCP_DIR_READ or BCP_DIR_WRITE.
+ * @flags:               must be BCP_SUBMIT_IO_F_IOV.
+ * @data_unit_size_bits: log2 of the encryption data unit size in bytes.
+ * @sector:              start sector (512-byte units).
+ * @dun:                 data unit number (single 64-bit limb, little-endian).
+ * @iov_ptr:             pointer to scatter-gather array of struct bcp_iovec.
+ * @iov_cnt:             number of entries in @iov_ptr[].
+ * @reserved2:           must be zero.
+ *
+ * @sector, @dun and @iov_ptr use __aligned_u64 to guarantee identical struct
+ * layout between 32-bit and 64-bit callers, as required by
+ * .compat_ioctl = compat_ptr_ioctl.
+ */
+
+/* Maximum iovec segments per BCP_SUBMIT_IO_BY_VSLOT call (matches UIO_MAXIOV). */
+#define BCP_MAX_IOV            1024
+
+#define BCP_SUBMIT_IO_F_IOV    (1U << 0)	/* scatter-gather mode; must always be set */
+
+struct bcp_iovec {
+	__u64 iov_base;
+	__u64 iov_len;
+};
+
+struct bcp_submit_io_by_vslot_arg {
+	__u32 virt_slot;
+	__u32 direction;
+	__u32 flags;
+	__u32 data_unit_size_bits;
+	__aligned_u64 sector;
+	__aligned_u64 dun;
+	__aligned_u64 iov_ptr;
+	__u32 iov_cnt;
+	__u32 reserved2;
+};
+
+#define BCP_IOC_MAGIC    0xC7
+
+#define BCP_BIND_CONTEXT       _IOW(BCP_IOC_MAGIC, 1, struct bcp_bind_context_arg)
+#define BCP_GET_CRYPTO_CAPS    _IOWR(BCP_IOC_MAGIC, 2, struct bcp_get_crypto_caps_arg)
+#define BCP_SUBMIT_IO_BY_VSLOT  _IOW(BCP_IOC_MAGIC, 3, struct bcp_submit_io_by_vslot_arg)
+
+#endif /* __UAPI_LINUX_BLK_CRYPTO_PROXY_H */
-- 
2.34.1

