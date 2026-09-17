Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207984A2046;
	Thu, 17 Sep 2026 10:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789641160; cv=none; b=GhCF5DdDDobHs8w6qgT/Xhirl8zMvrExmdVrjlhRmsTkx6ACYNyWp5QaH6NVTeCrcNKkuC7eFqKjFP2QnGHR/+eFe1jxc3yxCPPk/EpfUhukoVuAQYS4GbT5vod9t6bFueg+dJMu4IzmI3R8qzyuf2UK2DPrZ0DEQTJpQgL74fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789641160; c=relaxed/simple;
	bh=f2kr8PmdCVWr86p1NW2i3K28lMuauysr3sb4zu+meQY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p44tlyrozN8o0TtaHh6PhcjvRB/Dd+dTe4b7Sgg+4YUIZOv46ohVZ8T8FLpzgD8lmZoAyCD809fzUhcli7S0R7BGoCY2tWvpvqotr9sNUXtpFtLychx6rkNO+vxLpBqMiufs8rp6BA0E/Wt7+JKpHE07yrCt4ETMjYV2IpSnSL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowACH8z27watqobB+CA--.787S2;
	Thu, 17 Sep 2026 18:32:27 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@suse.de
Cc: MPT-FusionLinux.pdl@broadcom.com,
	kashyap.desai@lsi.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	ranjan.kumar@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: message: fusion: Fix scsi_device reference leak in mptspi_write_spi_device_pg1()
Date: Thu, 17 Sep 2026 10:32:27 +0000
Message-Id: <20260917103227.2147120-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACH8z27watqobB+CA--.787S2
X-Coremail-Antispam: 1UD129KBjvdXoWruF18KryxKr1UAw4fXFW5Wrg_yoWktFX_uF
	1FvFn7X348WF1Iva4fZr9I9ryfKFsrW392qa4IqFs3trWUZry8Xr1fZFZ8Cw4DuF48ur13
	C3WkAayrGw15GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbgkYjsxI4VWkCwAYFVCjjxCrM7CY07I20VC2zVCF04k26cxKx2IY
	s7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4
	kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7
	v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0E0s8F02x267IIx4CEVc8vx2IErcIFxwAC
	I402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrw
	CF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E
	5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtV
	W8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY
	1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
	v26r4UJVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW0oVCq3bIYCTnIWIevJa73UjIFyTuY
	vjxU7WE_DUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAANA2qrrJpLFwAAsp

scsi_device_lookup_by_target() returns the scsi_device with an extra
reference that the caller has to drop with scsi_device_put().  The
loop that looks for a tape device to enable inline data padding
never releases that reference, neither when it breaks out on a
match nor when it keeps iterating over the other target ids, so a
reference is leaked on every write of the device page.

Drop the reference in both cases.

Fixes: 19fff154e7ee ("[SCSI] mptfusion: Adding inline data padding support for TAPE drive.")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/message/fusion/mptspi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 56892b1f3de2..89d6beba08ca 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -914,8 +914,12 @@ static int mptspi_write_spi_device_pg1(struct scsi_target *starget,
 				nego_parms |= MPI_SCSIDEVPAGE1_RP_IDP;
 				pg1->RequestedParameters =
 				    cpu_to_le32(nego_parms);
+				scsi_device_put(sdev);
 				break;
 			}
+
+			if (sdev)
+				scsi_device_put(sdev);
 		}
 	}
 
-- 
2.34.1

