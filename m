Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFCA2BEC2B
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 12:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788265436; cv=pass; b=dT8HHSrPbkigoj23QDYbrs9Y3GuI/vMivq9ew+Kzg0NzPrpexWZieEZJ8OFuns1//Fm2kRYiA3uGhU9GVI5WvJXKZbEB1AkYRrdkmym1+LIGxp0H/fiHfTu685WIiMWxQ3g4XEyWeI2xbJMbWRKbl+gZ2KyP/Y70ojzaKW13Gz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788265436; c=relaxed/simple;
	bh=Ht5cATAfleiy5G4DRiReKjHxLRj7wcDPgpE6phoygGA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=GR842HgkYUHX7rgu1ZA1g6sPFxgv5wx5MvFawsfSxnVrGULwm/0cURGoI7bxKsBV6f7dVgtRgBskx6lp1qb4nm4JBySE/wuDHmGeI6wHLxhbqB3V05InDjiGvqdwcyaT/N+JDlGyIoBYyw2HHXnYpxQHABkH9CLYbDaWr4wc9hY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CuRCfc4T; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CuRCfc4T"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-52fac937235so171321cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 05:23:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788265434; cv=none;
        d=google.com; s=arc-20260327;
        b=YjVh7j1PLWp/3mO+rxJgwfgW86E1tbFn0Ry1k4m6bp312UklXsX9aExw/NiUqPomwx
         7++MIl5i3aorJNOGTKAWSiN1Ry7Gkw5DXvKGeDNHz+wkJ6bd3PPNY3sWzn/YlPpgAHc6
         BEVTFcECMt7OKbj8iVt2ADVh3kVuQ+qf+8q5CPg5nCe3gQaCv1YRkaxdfVmpM82DtlXI
         7JU4NtF7oz4Z/hxMzG0/cTkUCMBdXJ6gjd2/t7P/4z+lxtF0PnoB3fec9dT3nihnXt1J
         rWG3+g1L0ALzLvVP8lVy82IxnO3z6c2dFs+N2z1DAbgAIa/gpGlUvaXMffGcEM3P53L6
         agng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=xs/nVb2M1FK/MKYSmvmte6+x7BswjnCwSS6fAm+oyTM=;
        fh=KnVM/KIPecmoH0JZekTMvrNsOPd/Sh/kOUZJpu4ebO0=;
        b=TcbGuhKR8Z3Mazw8Y4KKmQG7FESYiKnyQgQ1bx4Ljf6TbaFS2piyqUtCpnYK4JXb3+
         nFeIH0HL9U7svaTKGUud1c4nPXnEmwJ+8wYz/6TeNKV6VMPZTlTQw3A2O15jhMlkpUWC
         8cIujaqOk/3JaZT5phN4t+nWC1fUuUnCBk19J7zkshmSyL6JJUQecsJrhjbiZqnvzXqo
         j0qzst0jURrphD5T4ol26yboILUZQ8sI6X0468CSw5ijvb0BnZITk6p6hfcMMGBsa4Qq
         jK4eRhmzCLiyYuTxyaO/NUJ+z9jCjGwb02Vt8zvgyqUDJiX6O+Tmkd9YTanxOlC1W4ZM
         W6UA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788265434; x=1788870234; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xs/nVb2M1FK/MKYSmvmte6+x7BswjnCwSS6fAm+oyTM=;
        b=CuRCfc4TLjb1itnOPdeYgIB0vWu/Fzo3XOaYzQosePC9QjJLm77xrSfwt/qAC5a/e3
         gfZfa4aJY7syELE9RYB39QliNIQKDroKNr3/zcg5kxPKjOrbbRnHXKdDqs9CSUa/qFoT
         j2aSB6h+PvQddNkJTCEjGQ16D9n2+hRFRntSYWzuV4VBtfoJdEs/YTdc0zPBRTXftnR6
         biFG2xYDMrYncsUIhqz0LieJtw8DzBnIZ9ke9EpTT5d+H0LtnJCfTrfxPPgnG/Od19wS
         CCGLCTr4UW4lkx3teU/wuRfhQwwHUSGFWCMS1bfYJQDPZq4Ks66/MDMayI9hlNgtfnXN
         kvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788265434; x=1788870234;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xs/nVb2M1FK/MKYSmvmte6+x7BswjnCwSS6fAm+oyTM=;
        b=e178CttZfF5Ot3JD9nQNFJEJgGzg0nNSUHKbNqAJQyKG6xm8HASzOM4l2mnvhkzzqC
         lAx6ggPhlon+Tde/nsV3BSrjfFRpkeOzb46RDSH8csRSDU+RsuJQed8uNJvIFlFl+N7g
         VmSNfw6aAo5MXdITlsTLnUXshTDlfeq5gIY9KMAhEte2CWs97+8FgqYxIP5a5Ju8eHfi
         Dsa19OPD9JEgDarJpaDZd2nJ5CEeVLRPPmdDlUd11/iCJzpxWENfMWFvcn3pkHmjPfmC
         +258gQOKZ92RBb2O7e5wBN2hJlwQfH7jEuGrKWQUhKUECV8FW8IptlGFV6F7x6TBncBm
         /+Eg==
X-Forwarded-Encrypted: i=1; AHgh+RpqzD2RFyLMQs6lAW0FkeOf4kO6hGj/EvlSjIpKQNm9XQf4iiXSuT9Pp9Vw+C2pv0NljIe92nhPO6cZ@vger.kernel.org
X-Gm-Message-State: AFuF++lnGM49DC+SEujwPFJ6Tsb9+HgrA4uBSMRMrAwFYkqYc8Ue0VtU
	Vf82zF1hv+ruV8oZ3y6lViYxu9PHqjtCoCg+pO/OzzHR7S7XiLgPofQS7Rqg8vsR4z2cITKknfV
	8cWDFfMnrNdRgOAQbm/F6oLXKh4vTzw9EgcWLneyH
X-Gm-Gg: AR+sD11aEhWN+Mwff9u/5vJ1ILNBqYGKvuvQSkeKt6MbxKKTFCwos9DLI8NCCPtSHTB
	wgDsOjCdgB23yBLNLLu8tOQyPlxQv/CkBnPJb6mPQh7sRbHxt7bQYNRCT9lXMbuzIIpBrw/H73G
	zwYt5ItRYSV9VFHE0rH057n1ueQBlqpk1mblUoL02e4Ukd80g/W2p+nDI9GJOQbACEB3RIUd9Ya
	qkifUiy4HvFxYZXINV3ZDbsKXa1MNGeh7oWeb4rAYiTFA6xY/ID4awFdi6xzMoz+YPaRmoga5ln
	vjd4C2lDvF83EydlquhTjFs7H3xqmMwiGrjrQBaL6NzJ
X-Received: by 2002:a05:622a:550:b0:52f:9ed4:8d74 with SMTP id
 d75a77b69052e-53024ed6209mr15248401cf.14.1788265433232; Tue, 01 Sep 2026
 05:23:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stanley Jhu <stanleyjhu@google.com>
Date: Tue, 1 Sep 2026 20:23:15 +0800
X-Gm-Features: AcwNN1WpJB9_YlNn1Oe8v1rf02Ia4P8dBEY00QCfQskFb3n-rTKkMqg0dRw3YE8
Message-ID: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
Subject: [PATCH] scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Peter Wang <peter.wang@mediatek.com>, quic_cang@quicinc.com, 
	quic_nguyenb@quicinc.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reading host controller registers (such as CQTP) is unsafe when the
host controller is disabled (HCE = 0), as accessing registers in an
unclocked or reset state can cause bus stalls and system hangs.

In ufshcd_mcq_compl_all_cqes_lock(), all completion queue entries have
already been inspected, processed, and cleared in memory, so the
software queue is logically empty.

Avoid the unsafe MMIO read of CQTP by synchronizing hwq->cq_tail_slot
directly to hwq->cq_head_slot in software. Upon subsequent controller
re-initialization, ufshcd_mcq_make_queues_operational() will
reconfigure and re-zero all queue pointers.

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs-mcq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 8106d55f4041..0e1f99c8d77c 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -349,8 +349,12 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
                entries--;
        }

-       ufshcd_mcq_update_cq_tail_slot(hwq);
-       hwq->cq_head_slot = hwq->cq_tail_slot;
+       /*
+        * All completion entries have been processed and cleared.
+        * Synchronize tail to head in software to mark the queue empty,
+        * avoiding unsafe MMIO reads while the controller is disabled.
+        */
+       hwq->cq_tail_slot = hwq->cq_head_slot;
        spin_unlock_irqrestore(&hwq->cq_lock, flags);
 }

--
2.43.0
