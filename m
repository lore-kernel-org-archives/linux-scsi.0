Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7183D287245
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 09:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758535025; cv=none; b=VUVeVmk8zVK0bR+H/g04OoTlOLaCXZbUIGsum1B9MgRW6KuCaZo/7xrVpUfu0OHMZGrZmH9Nm6gB0cEurCC/AGdIXeC6RF8WCD0h9O0gp5ayarhY/bNS6fbTHAve2HB3Xb1MWVoQrF7FGKE7Ot+Lmaw7kvmd2aNJ8JC4sJosFfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758535025; c=relaxed/simple;
	bh=ObkmtCJHVKyFchPvae5/kOYWZR1HWIKgbSl65AeWQUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syOuZLP/zNxpgcqTIbI1Xb2WzsjqF4Ql8g/opJnvQLyRFXCw2dZHbNmC9QJ91qND8yo7o89mNHdvmEeepBMKMsHIyO9kDxRpk8VKMSFMKyDaqARsTFfJ4NORrNMRaTd6TO7yobX9Dx6zgFnxu5Qg+wqgR4f24Q0UcWHoWCwtIRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=VC/gQREd; arc=none smtp.client-ip=209.85.219.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VC/gQREd"
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-78e4056623fso39491116d6.2
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 02:57:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758535022; x=1759139822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3QnyBpSVzjMACQ8a/+eKylQDFjEVLKitMUrRzynNxGI=;
        b=ldpQ0LqbwG99LEU7tvXzWek+xl7ObeOGPKMaaEWR9YCXAdOgoFYI7AOJWVLfevxY8o
         zprm8J9cPc9xThNV4L1IEDUbqM2eqVTtNu8nlHXlhtpeHrQBZ6BmIR35g8p/KKSLHTn2
         +883oaFPQ6PB+oA3Yw7Caj4PAeN+wdRwSiPl48JZ0i7rhoOb8uM+UBMglzlcneNBHJyy
         yQ0+5wEXQEkwa3CdYppl1tEC/2p8rndriw6UNf6J/YHZoVNHhxgD5bvyPwK3iZMHY/MH
         NbdbOOlfAR+5NVNV4n20GlXxn5zm0jBZxF4b/AtiN4nEkSrKWIrU2j6qq8mTnV2G74us
         QVFQ==
X-Gm-Message-State: AOJu0Yx30kWFKntfb0YtYj30Nwjr7merBhRhRYrn3bwVi+qp6yBQWomY
	VDLjrK31WqxllVQHwrGw4mv+rXXvjZohX+lB7fwg8g2UNE+XPDFarMTiCLSyge6ImCvbGaYOPvp
	UiYP0i76TujgZbTr7p2pwxteeldHnfG2e7q03Y/WvbWc+8nTl7VhK/1XaYpVR5ASKPX9ELZt8PY
	+THN3Ve9L+fZyUEahM8FvxsroW9bf5FCvc43gnNbbKrlVkADNZ7iJzlWetgJOhhF8L6LUYpgFXT
	ikONJ7ogfPY3jNw
X-Gm-Gg: ASbGncs/Je1pcDNxJzXPSwiWJq2KFtQ8CoEIG+7I+GcFeoV2SzL0cN2wcpmI26XuOEt
	7B/q6dEuWolGJ4lL9+BVd4ZI0v00EEN7vj1Pdwth8fRKCEic8U5QjkWDls2bPJY+TDG7f7+cSI4
	cATmS10/jcoLS4eIog81UMAMWzDpofxcNEXfswxHPxq4OWPonrDoRKGwFcaUPKoqJDwkI7+vS0K
	HvdLXtWALBnL6fEz2t0CcWWHjsWyMK3YOULF6IQMgBBQulHQ4keHPOq2yLKsCb1oH9U5ctyhG8L
	j+rd/WLsPfNoeNQMag1NDF9JrcUEvLKxtp8X4kNI17mAMn+kbvgmTrvi41lHMzfFWWB6dietmpG
	j1ycfKuDOiaLXfB2QIBCCTODIoRLP3j/DeNZtS+uua+qs+VBAyIvEXUh5wv5jjFEvVXrl5LvM8g
	Dsrw==
X-Google-Smtp-Source: AGHT+IE2UPpAVDKBYfUGedDpstRDyWF5IU1QgFjqVJHRhR28JeJpBYX7jpoVzL8gn4p3yDZLpi8riIBwx+DJ
X-Received: by 2002:ad4:5744:0:b0:77e:613f:9b66 with SMTP id 6a1803df08f44-799124b90damr126445736d6.15.1758535022177;
        Mon, 22 Sep 2025 02:57:02 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-121.dlp.protect.broadcom.com. [144.49.247.121])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-7934ee8ba36sm7767526d6.25.2025.09.22.02.57.01
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Sep 2025 02:57:02 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-27356178876so12842835ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 02:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1758535020; x=1759139820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3QnyBpSVzjMACQ8a/+eKylQDFjEVLKitMUrRzynNxGI=;
        b=VC/gQREd9/qjyASbRFoIsXjpySn0FXnrq6ivt/INpRJMh+gmJAR18itnDITjBfeoh3
         QtB0iGR6i5xTfG99takl0Sn5XL99I/XRaIhMr7hqrvUH+Xg3d7F0RJ90wIPCcww2rEb3
         cGDWLmF8JQMIqPpl0ll071VOkTRIRfz/g4duA=
X-Received: by 2002:a17:903:46ce:b0:278:daab:7940 with SMTP id d9443c01a7336-278daab7a5bmr34988115ad.17.1758535020017;
        Mon, 22 Sep 2025 02:57:00 -0700 (PDT)
X-Received: by 2002:a17:903:46ce:b0:278:daab:7940 with SMTP id d9443c01a7336-278daab7a5bmr34987715ad.17.1758535019520;
        Mon, 22 Sep 2025 02:56:59 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f4594a76bsm1034584b3a.62.2025.09.22.02.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 02:56:59 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 1/4] mpt3sas: Fix crash in transport port remove by using ioc_info()
Date: Mon, 22 Sep 2025 15:21:10 +0530
Message-ID: <20250922095113.281484-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922095113.281484-1-ranjan.kumar@broadcom.com>
References: <20250922095113.281484-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

During mpt3sas_transport_port_remove(), messages were logged with
dev_printk() against &mpt3sas_port->port->dev. At this point the SAS
transport device may already be partially unregistered or freed, leading
to a crash when accessing its struct device.

Using ioc_info(), which logs via the PCI device (ioc->pdev->dev),
guaranteed to remain valid until driver removal.

[83428.295776] Oops: general protection fault, probably for non-canonical address 0x6f702f323a33312d: 0000 [#1] SMP NOPTI
[83428.295785] CPU: 145 UID: 0 PID: 113296 Comm: rmmod Kdump: loaded Tainted: G           OE       6.16.0-rc1+ #1 PREEMPT(voluntary)
[83428.295792] Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
[83428.295795] Hardware name: Dell Inc. Precision 7875 Tower/, BIOS 89.1.67 02/23/2024
[83428.295799] RIP: 0010:__dev_printk+0x1f/0x70
[83428.295805] Code: 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 49 89 d1 48 85 f6 74 52 4c 8b 46 50 4d 85 c0 74 1f 48 8b 46 68 48 85 c0 74 22 <48> 8b 08 0f b6 7f 01 48 c7 c2 db e8 42 ad 83 ef 30 e9 7b f8 ff ff
[83428.295813] RSP: 0018:ff85aeafc3137bb0 EFLAGS: 00010206
[83428.295817] RAX: 6f702f323a33312d RBX: ff4290ee81292860 RCX: 5000cca25103be32
[83428.295820] RDX: ff85aeafc3137bb8 RSI: ff4290eeb1966c00 RDI: ffffffffc1560845
[83428.295823] RBP: ff85aeafc3137c18 R08: 74726f702f303a33 R09: ff85aeafc3137bb8
[83428.295826] R10: ff85aeafc3137b18 R11: ff4290f5bd60fe68 R12: ff4290ee81290000
[83428.295830] R13: ff4290ee6e345de0 R14: ff4290ee81290000 R15: ff4290ee6e345e30
[83428.295833] FS:  00007fd9472a6740(0000) GS:ff4290f5ce96b000(0000) knlGS:0000000000000000
[83428.295837] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[83428.295840] CR2: 00007f242b4db238 CR3: 00000002372b8006 CR4: 0000000000771ef0
[83428.295844] PKRU: 55555554
[83428.295846] Call Trace:
[83428.295848]  <TASK>
[83428.295850]  _dev_printk+0x5c/0x80
[83428.295857]  ? srso_alias_return_thunk+0x5/0xfbef5
[83428.295863]  mpt3sas_transport_port_remove+0x1c7/0x420 [mpt3sas]
[83428.295882]  _scsih_remove_device+0x21b/0x280 [mpt3sas]
[83428.295894]  ? _scsih_expander_node_remove+0x108/0x140 [mpt3sas]
[83428.295906]  ? srso_alias_return_thunk+0x5/0xfbef5
[83428.295910]  mpt3sas_device_remove_by_sas_address.part.0+0x8f/0x110 [mpt3sas]
[83428.295921]  _scsih_expander_node_remove+0x129/0x140 [mpt3sas]
[83428.295933]  _scsih_expander_node_remove+0x6a/0x140 [mpt3sas]
[83428.295944]  scsih_remove+0x3f0/0x4a0 [mpt3sas]
[83428.295957]  pci_device_remove+0x3b/0xb0
[83428.295962]  device_release_driver_internal+0x193/0x200
[83428.295968]  driver_detach+0x44/0x90
[83428.295971]  bus_remove_driver+0x69/0xf0
[83428.295975]  pci_unregister_driver+0x2a/0xb0
[83428.295979]  _mpt3sas_exit+0x1f/0x300 [mpt3sas]
[83428.295991]  __do_sys_delete_module.constprop.0+0x174/0x310
[83428.295997]  ? srso_alias_return_thunk+0x5/0xfbef5
[83428.296000]  ? __x64_sys_getdents64+0x9a/0x110
[83428.296005]  ? srso_alias_return_thunk+0x5/0xfbef5
[83428.296009]  ? syscall_trace_enter+0xf6/0x1b0
[83428.296014]  do_syscall_64+0x7b/0x2c0
[83428.296019]  ? srso_alias_return_thunk+0x5/0xfbef5
[83428.296023]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: f92363d12359 ("mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index dc74ebc6405a..66fd301f03b0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -987,11 +987,9 @@ mpt3sas_transport_port_remove(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	list_for_each_entry_safe(mpt3sas_phy, next_phy,
 	    &mpt3sas_port->phy_list, port_siblings) {
 		if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
-			dev_printk(KERN_INFO, &mpt3sas_port->port->dev,
-			    "remove: sas_addr(0x%016llx), phy(%d)\n",
-			    (unsigned long long)
-			    mpt3sas_port->remote_identify.sas_address,
-			    mpt3sas_phy->phy_id);
+			ioc_info(ioc, "remove: sas_addr(0x%016llx), phy(%d)\n",
+				(unsigned long long) mpt3sas_port->remote_identify.sas_address,
+					mpt3sas_phy->phy_id);
 		mpt3sas_phy->phy_belongs_to_port = 0;
 		if (!ioc->remove_host)
 			sas_port_delete_phy(mpt3sas_port->port,
-- 
2.47.3

