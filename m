Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB4B4E9C00
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 13:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416161; cv=none; b=nGHqbEMVvmiOREH0n/qiK+n7L8WqzYdXSnmLoT5WtpeHpSyEeMM3aUy7PMAOmpPg6sQ1Gp0pnhojOCT/9Nffh16qxHkguwn0EfIed0dr/kbj7vFQZOHOZt6mntZr46J8aM0rVJ4Zw5njANyD5q6RJmIRxBujnM+nVydSCq1l5rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416161; c=relaxed/simple;
	bh=QJ3WP5BAC2HmDvQ8yJ8MjuKTExqSQa21M8EhWxsEgQw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p1AwXy8jCDSrBW0H1DmDWsknxKH9TzUnuFzKp84gr7RYDHmClWkQt7SJ1op3MkzJs687uVsmXv5FkyrpYFC0Oc3Jhp1vaFOofr3m7IgCY4YdyrNFKHpoEAwkQuu2vGhOFmu0nu4oK0PtVnm+X+8SBAFpq18886UaZDHD+E47i3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qw7pPEZ+; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qw7pPEZ+"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a0673d9bd2so653685b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 06:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792416158; x=1793020958; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r/O9szk0Y4L3NCg5BU0LaGq0rSpen4QgLpBAJsNG+aE=;
        b=qw7pPEZ+s3vNCf+QlDkkypLBpj857lxfQZdxzoUABcTZz+Yr1KP2WZRfLxJEdi30Av
         ZO9x3soSjHtGqYuSkqSbSgdS9c5ZZUz1QOBDpbgoYGtDw6U3blRVWTUEIRQ9sNFpxl3+
         BW7SU3h7fsnTqby4uBmb2ZVEEgorSDU03aCLZbSMsUhbqGModLOrQwozY8jzQBmy9vkX
         ql5KVA1/+CTG1BNYlrzuQwyvu7xzxJfSGJqZqw/s7yl5a0l6sZk7eYB/ZWvj5srZignt
         +VrPj0SLRGDXmko2yW8bgdgXsgzYx0PROGOKYpTeoBnwwrHqYjDoC09S7gLUzoBHGqo3
         qIOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792416158; x=1793020958;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r/O9szk0Y4L3NCg5BU0LaGq0rSpen4QgLpBAJsNG+aE=;
        b=A/Bh4H8tKESKylChBApF0Dg7Nsw9xX4DHd7VTrCjQBLZHGsEYNbL6iW9zSO6kHRupW
         P0YjIp4qPlH8tlFEkuBKwaaMSuEntW7gCLqA5APBo/S1JWTNrmIeD7liNVJ3guKzXyvE
         tnYrLxEv8qVSFUNWNT0GgbaHmqCUrlgxSxEn2TRxlnYCJsZEARXluyes7xG4c8k8rOaK
         RAShY2Yk+b/LxALJsif32guL8ROH1WCZ7/u6RrcxSTFv7/jF4/X9Umtd3zSvKv+4af85
         uYreAf8BmWSfyygCSgBBUUmAmqmM7HPsBJJlXDEbleJvtCWhthYM/ZrrTwbubX7KPjoy
         hepA==
X-Gm-Message-State: AFq9FYJDSI34ma+OKMBmhb47Rsazrz/UB9+RabkBtLDOsH4U44umKjw3
	4Qcugsd5VSD8TF8wTGsExZr1h8ZKdfwGmJ8kbcrjbzWuPHc1YBpPAC4A
X-Gm-Gg: AYBFou2iLgMn6GNR/1+FEknKbFriSPANquex3I8A9TCvNeKJGEw6HLxb6gs0ecqM7xj
	KdYweomU0QMhso0ypXrSgoLKTXCUH6MYULzs8mRDRhRfKRjli4FVYgpEPoCgYbRsGVgbtPnB0xs
	QLp932Z2ozAXpdEjkCZ2OODTwjza6thpNjuR9PXsIYeoJLOXVTWjDD2gD6gmOsc112JQPsRN/+i
	32m25yk1PP+l5mqUSYTEderWzJE7lyErhE82xUGfCPnpmvGSLeiq0kyZqbWy2m960QfkUPD1EuV
	KnOWktVw/XxUIUfsruGGDn1lXEkgQaMF0kTSkkqKxA2HMtGlPLZpS8VBllmK7goChVjNPIiJ8wQ
	S7EWEdxaaEc8k3fDqKRbR5CCoSgizGhMTRliUgTIjtQhr8lKopvHwKbovOFFiCr4d1XnI+/UoR6
	FuoQbzNiJdpgI2AZPKHmfRv/hXFahMvOzbOQCsqJt0VtqgJX/thYtPM3cofCMxAAAZcBbwDGjuJ
	5t8ljcF5l+TKb8F
X-Received: by 2002:a05:6a00:805:b0:89e:9c7e:fd5e with SMTP id d2e1a72fcca58-8a04ba185aamr5552921b3a.9.1792416158425;
        Mon, 19 Oct 2026 06:22:38 -0700 (PDT)
Received: from [58.206.202.11] ([104.28.215.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f58408085sm3939959b3a.55.2026.10.19.06.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 06:22:38 -0700 (PDT)
From: Haoran Wang <haoranwangsec@gmail.com>
To: Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak Kumar <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, haoranwangsec@gmail.com
Subject: [PATCH] scsi: fnic: use scnprintf in fnic_get_debug_info()
Date: Mon, 19 Oct 2026 21:22:35 +0800
Message-ID: <179241615575.5916.9521598583158892732@whr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fnic_get_debug_info() formats the fnic debugfs statistics buffer with
eight `len += snprintf(info->debug_buffer + len, buf_size - len, ...)`
calls into an 8192-byte vmalloc buffer (buf_size = 2*PAGE_SIZE).
snprintf returns the number of bytes that would have been written and
does not clamp on truncation, so once the buffer fills, `len` keeps
growing past buf_size.

The last call site is a loop over iport->tport_list with no
`len >= buf_size` guard.

    list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
        len += snprintf(info->debug_buffer + len, buf_size - len, ...);
    }

tport entries are created one per GPN_FT target port with no upper
bound (fdls_create_tport).  With a typical stats header (~4-6 KB) and
roughly 46 or more target ports, `len` crosses 8192.  The next
iteration then computes `buf_size - len` as a negative int, which is
promoted to a huge size_t, and vsnprintf writes the full line past the
8192-byte vmalloc allocation into the guard page, causing a kernel
oops on the debugfs open() path.  The inflated `return len` is also
stored as buffer_len and later drives an out-of-bounds read in
simple_read_from_buffer().

The sibling fnic_get_stats_data() in the same file already uses
scnprintf everywhere; fnic_get_debug_info() using snprintf is a porting
oversight.

Replace all eight snprintf calls with scnprintf.  scnprintf returns
min(would-be, size-1), so `len` is bounded to buf_size-1 and
`buf_size - len` stays >= 1 (never negative).

Signed-off-by: Haoran Wang <haoranwangsec@gmail.com>
---
 drivers/scsi/fnic/fnic_trace.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 4ed57ea1f..51e7c973c 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -468,35 +468,35 @@ int fnic_get_debug_info(struct stats_debug_info *info, struct fnic *fnic)
 	struct fnic_tport_s *tport, *next;
 	unsigned long flags;
 
-	len += snprintf(info->debug_buffer + len, buf_size - len,
+	len += scnprintf(info->debug_buffer + len, buf_size - len,
 					"------------------------------------------\n"
 					"\t\t Debug Info\n"
 					"------------------------------------------\n");
-	len += snprintf(info->debug_buffer + len, buf_size - len,
+	len += scnprintf(info->debug_buffer + len, buf_size - len,
 					"fnic Name:%s number:%d Role:%s State:%s\n",
 					fnic->name, fnic->fnic_num,
 					fnic_role_to_str(fnic->role),
 					fnic_state_to_str(fnic->state));
 	len +=
-		snprintf(info->debug_buffer + len, buf_size - len,
+		scnprintf(info->debug_buffer + len, buf_size - len,
 			 "iport State:%d Flags:0x%x vlan_id:%d fcid:0x%x\n",
 			 iport->state, iport->flags, iport->vlan_id, iport->fcid);
 	len +=
-		snprintf(info->debug_buffer + len, buf_size - len,
+		scnprintf(info->debug_buffer + len, buf_size - len,
 			 "usefip:%d fip_state:%d fip_flogi_retry:%d\n",
 			 iport->usefip, iport->fip.state, iport->fip.flogi_retry);
 	len +=
-		snprintf(info->debug_buffer + len, buf_size - len,
+		scnprintf(info->debug_buffer + len, buf_size - len,
 				 "fpma %02x:%02x:%02x:%02x:%02x:%02x",
 				 iport->fpma[5], iport->fpma[4], iport->fpma[3],
 				 iport->fpma[2], iport->fpma[1], iport->fpma[0]);
 	len +=
-		snprintf(info->debug_buffer + len, buf_size - len,
+		scnprintf(info->debug_buffer + len, buf_size - len,
 				"fcfmac %02x:%02x:%02x:%02x:%02x:%02x\n",
 				iport->fcfmac[5], iport->fcfmac[4], iport->fcfmac[3],
 				iport->fcfmac[2], iport->fcfmac[1], iport->fcfmac[0]);
 	len +=
-		snprintf(info->debug_buffer + len, buf_size - len,
+		scnprintf(info->debug_buffer + len, buf_size - len,
 		 "fabric state:%d flags:0x%x retry_counter:%d e_d_tov:%d r_a_tov:%d\n",
 		 iport->fabric.state, iport->fabric.flags,
 		 iport->fabric.retry_counter, iport->e_d_tov,
@@ -504,7 +504,7 @@ int fnic_get_debug_info(struct stats_debug_info *info, struct fnic *fnic)
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
-		len += snprintf(info->debug_buffer + len, buf_size - len,
+		len += scnprintf(info->debug_buffer + len, buf_size - len,
 		"tport fcid:0x%x state:%d flags:0x%x inflight:%d retry_counter:%d\n",
 		tport->fcid, tport->state, tport->flags,
 		atomic_read(&tport->in_flight),
