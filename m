Received: from outbound.baidu.com (mx21.baidu.com [220.181.3.85])
	by smtp.subspace.kernel.org (Postfix) with SMTP id B79F8213254;
	Mon,  6 Jul 2026 06:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.3.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783318148; cv=none; b=aIsHtvjM5VhA2EF5B8pz8hzNmQP7mJ6Qtre2J7UI+IKrxgV+fjar5LPhevkMWb640p+N21OXqY8vI3aj53VDVMoEPGkoLoMKb+gKHZ984ZxdmkMYTehIETGhLFL9mWAp454NawrMgWjz5w2UZFY8JJKzZZQnXjcGsMxVa4ku1Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783318148; c=relaxed/simple;
	bh=89UxSNmJbwus+1T6LL2Jdtv0hEZWDLSbpVditxGK+Uo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lKMhhArOm/OCEjn9wMFamTVmROLIuVWgQmndYf/yGFctXKzYhE02Hw8VgzMWYTSgwvebfUDuk59vCAE1SN0K7sij4BiAnxZrmZIkqZ0F9x34DRP3+gSIdAIJvDazksPsZXUqQC4OjIXvJsnr8j8dmsfOhKpSvWygcXVpWyRXr3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=NZlmfhLf; arc=none smtp.client-ip=220.181.3.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="NZlmfhLf"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>, Sreekanth Reddy
	<sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani
	<suganath-prabu.subramani@broadcom.com>, Ranjan Kumar
	<ranjan.kumar@broadcom.com>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, <MPT-FusionLinux.pdl@broadcom.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] scsi: mpt3sas: fix invalid kfree of embedded event_data in event callback
Date: Mon, 6 Jul 2026 14:08:40 +0800
Message-ID: <20260706060840.2287-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc13.internal.baidu.com (172.31.51.13) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1783318132;
	bh=fY4JfJBuHxJGe2G1UwjbtBb33neK5Eh3TVkeu9PNsJA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=NZlmfhLfzmxBSATvsK/69BeYyH2xh6AsJPuHVQCF/KQjMCuBG5Vph+KkKMGMox6Uv
	 nsc/Q/LRaU+SvPb+gWmVtR1j22Cj1BbsKjegGV+lvFAoVNP9qLFYn3zuuE7EiohMc/
	 gvPAr6nh/4FoJgnljVnZ+xScaztWp9wNXDvlllVe1zW8ndTve32wZ+Imeo7KSZL0iB
	 XIxcu0rKXc0Wq1Yz5zsmn/2r0MrL2H4pZHnMVj5KgZsJjiw0SuOgqQkB7ItMRhDiSk
	 pe9bo4r9YYXj2mS53bE8ZrgrHdxRHmAxprYQKZVTfC7IU6zboJVLtqqUegsu1VV426
	 fuEf2kaobK60A==

From: Li RongQing <lirongqing@baidu.com>

fw_event->event_data is a flexible array member embedded within the
fw_event_work structure (allocated as a single kzalloc). Calling
kfree(fw_event->event_data) on it is invalid and can corrupt the heap,
since it is not a separately allocated pointer.

The subsequent fw_event_work_put() will decrement the refcount to zero
and call fw_event_work_free(), which frees the entire fw_event_work
structure (including the embedded event_data). The extra kfree() is
therefore both wrong and redundant.

Remove the erroneous kfree(fw_event->event_data) call in the
MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST error path. The PCIE topology
change list handler already handles this correctly without the extra
kfree.

Fixes: ad59571931072e6f ("scsi: mpt3sas: Add firmware event requeue support for busy devices")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 12caffe..ca01a49 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12267,7 +12267,6 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		if (!fw_event->retries) {
 
 			ioc_err(ioc, "failure at %s:%d/%s()!\n",  __FILE__, __LINE__, __func__);
-			kfree(fw_event->event_data);
 			fw_event_work_put(fw_event);
 			return 1;
 		}
-- 
2.9.4

