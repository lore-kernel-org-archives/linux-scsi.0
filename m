Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D3433B6EF
	for <linux-scsi@vger.kernel.org>; Mon,  9 Feb 2026 18:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770662949; cv=pass; b=QVS+bkbEBAZGn+SRh7RXnLNlwucqd8mqab2cdNrtK4cziksXfTOtNb8NtC7tjrPwu2atssE955SMceEdjLhYFSAaThpXJ8tlpbpoysxXq0JQzOEkACB2CStXTeGiEv2KyguNKICGX0Q73xrMnGFvUldKt4+0mVizWUgtH6jjwUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770662949; c=relaxed/simple;
	bh=PVpZLYTg3MjRnHaJv8OCWhsOHyrKr7DSwatUXt5Cwq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OkUhhxhXFKr28SEBda4NHVoru7O0cq4iYBtB19ee++Ndk7CX3XN/VrypLK1Nyj+1hNi6pbcjg/mPsshMQ0CLUd/rsbqQrj9DDYtQrZtzZqpilQzeyCCutGoJ24kgcQTV2GutWOfzcWwEboVBT/90vBcn/yNvdEbhWovoldnTSQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h39sTF8a; arc=pass smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h39sTF8a"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8c52f15c5b3so479365785a.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Feb 2026 10:49:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770662948; cv=none;
        d=google.com; s=arc-20240605;
        b=YL4vG6TEyTt+ZBnTq6E1Hvzc3GnnmzGmaS6sWm3d3qoKzG7VxVCj0jPcHLFdI5BmhH
         vaVI7KjsGt00eocI1t0USUES348DdtRXAozY4sSmcLmH15KEO68rVXey4VThmyrpZoas
         kP7jHy/HLHr9535Q58JRqKaXIQmLo9shihvJo5IQhcKEdMs5MQsy3otOp12qehsAs8Yg
         lJQ6iUbl8FutyTyuvPTMaMwu3iqFfUeb1tazzx9GDWPH30lsMGR7HY5MhDgcuLhb0Tn6
         LgkoMuBuZ7ZLkBuFoW6ItekYh4YD6gYzd4aI/kV/QHQmotWfQpGIc8b5tNLCYymdYZgH
         aPlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2hJF7VNVh2CuReVtz/fX4jYrWMmesBnbUQwI4UXJlWs=;
        fh=PE1hVsk7X/yrq5GegjIr/77Aaljm2QGtr1AmkwY9TSY=;
        b=L3JzAucvc4mZGeQ+3fuvrsR8dq7VcXhVQ4HMp4NJzvx/su2gn0zSV53ayFcmM/RQLa
         4f6M2G82GgWATyJhO+uqr5A2jH4dPKQ+e0bgIg501jXwLBqV6pzJJNJn5uGrJi0v98vz
         bg5BSJWn/SmHeCAIpJUaqqH0fUu2gz/STvcuIE7+/TaMKBMMi4jtP4Uhzm4kwOdGnWO9
         tZod0BXruUVTiaEpdSYx8eMFF8EnLSkFTvTRf6V7zUFmfxBtfq+SMlcTAl2AAKYf5K80
         tCAXT0/FKBa9sDSKhvb9J+KD4DfNithAlHR2ui7HhyZOrXfpVkqm29I40nCc9hgb+2nX
         Epcg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770662948; x=1771267748; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2hJF7VNVh2CuReVtz/fX4jYrWMmesBnbUQwI4UXJlWs=;
        b=h39sTF8aA2hMeMg8kK/Jb73dLL26DEZ6OXfXD2X07I6vjJ8/9q7M6odRWdHIJnA5gi
         ZbkE47DW39cvTngyuORJ6NFw0ZmmEgcbD4oBIfIFYRUUrYXg62smKXYb4puoHvUdekhu
         3ml/G4+5YYE3UTppke0HtH4Av/ZrjI9o9DZKJuRbX/H8Dcb1as1EgYPTZr/85NbrthOQ
         YbqH89UUPZVK07VHUYcubLm1OfE8IavSd39c5mu47y8zHBQKn9tuhQPUdyxms3G41hnN
         dX6+sCpIcfBifB0rj2ayCj1KOJbod7GMkdEgpm0OwX+COkVqbSOS7OTck+lrxRnMt0O0
         ZJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770662948; x=1771267748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2hJF7VNVh2CuReVtz/fX4jYrWMmesBnbUQwI4UXJlWs=;
        b=ZlGqIXOpqb60AxBML+1ILoSwuepz2o4U2sZ//oDcDsJnLorUHwl0UnYTDT+wObSdMU
         T9D+4AlZhs9+/0XnZvEMuFmDL/BSbrjRUwZ0gvs58oWeVrp6+bEemG3/EhEhWcHb/FYV
         uW2oykp9w4AS2QWfZnueR5Hbj9M60HtmWUL/eJGqH9FGJVYtpX1Jr1fePXJHxLlnrAxI
         RJg19JJ8fnRLpeHpDmfMFJ8GEfowCBKU3x7Vm7hCDoAIXMv8/YbMYauPuwFb0fO3xno+
         uLVYExWzCi5AgSYT4Q033awFZcoOMwz7U3rhgz76669cPm5LjDNye6yxDCstxrCJu+Nw
         Iktg==
X-Forwarded-Encrypted: i=1; AJvYcCUq/a6pgjUV+wtzGqnUsUI4h1vlfktEHSVkyCpJpYkVQWz+zuM5bcWcmg9neST7OVkMA2pH85zjJ8dg@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9iux9mmqkynOQXtvAPj8CyprrYmtTp9fSZbV37/52BPOZgHpI
	TfLmZCQvNb0ZgAUmWT3dp/3Sj2jZRN4pwXUZS+MUhEgllewwDe9v4VQsSzYlOzgmeOSAKUcw+LN
	9Mj1NrXTGOKhiHr+tXX2KBrwBkA81UEs=
X-Gm-Gg: AZuq6aKmac/jZtV6TSdgoTUym8V8TV/RjjBL0J0C+mN1M753AAOidWNQMEf3dCWwIpw
	fYrCEzVfttlCSsqg0AaGq224jKoRZyGV/bn84GPIaMQYi47oUoiZVbvXDPH764MS5SO4E7sFpHS
	qJPiZF241w+J6WAGnvGWOTRQZ67cDbDOIl0qaY1C2RlQ1YuN0SUcTRAfMH7kReRT0IoEKpiOTIq
	PTMaSOnBZZjErLJihegIPR1bmRctsnI7f6VlArRAImuAQKBAmMgcd+qrQvu/cIFQ+kNSQsZ
X-Received: by 2002:a05:620a:192a:b0:8ca:3e78:ef79 with SMTP id
 af79cd13be357-8caf086bbd7mr1640911385a.77.1770662947716; Mon, 09 Feb 2026
 10:49:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113222716.2454544-1-minipli@grsecurity.net>
 <CABPRKS89zwXdUT1Bhj37cQDyOHNupOJ-Ez6kS7Dp_pu06X9Myw@mail.gmail.com>
 <CABPRKS-ongXPqWVpNYiKvy_afVKn999bxtSEfsBVQ7z5JVCgeQ@mail.gmail.com>
 <59933d92-eefe-49f6-ad70-79fe7aef0f3c@grsecurity.net> <CABPRKS8C4WmEYX+jtAOTS_jeFYt_GeTp9uBoWzCMF8cUZxxzUA@mail.gmail.com>
In-Reply-To: <CABPRKS8C4WmEYX+jtAOTS_jeFYt_GeTp9uBoWzCMF8cUZxxzUA@mail.gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 9 Feb 2026 10:47:10 -0800
X-Gm-Features: AZwV_Qh-_Ib9vKIETPKMg2bngOjh8R7iN5m-oqlfeVwk72_gaS5Ma2oT2XCfonk
Message-ID: <CABPRKS_cT5f21A-Jkx_uhA+SF4THpPSaqKtk8mWk9nN4Gh9LFQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Properly set WC for DPP mapping
To: Mathias Krause <minipli@grsecurity.net>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>, 
	linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mathias,

> Thanks, I think I=E2=80=99m able to reproduce the call trace of concern. =
 I=E2=80=99ll
> have a closer look at this patch and will report back.

I have some slight changes to the original patch, which I've tested on
real hardware.  Please see below.
Is it possible to check if this works for the customer as well?

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a116a16c4a6f..b5e53c7d33e7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12039,6 +12039,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
         iounmap(phba->sli4_hba.conf_regs_memmap_p);
         if (phba->sli4_hba.dpp_regs_memmap_p)
             iounmap(phba->sli4_hba.dpp_regs_memmap_p);
+        if (phba->sli4_hba.dpp_regs_memmap_wc_p)
+            iounmap(phba->sli4_hba.dpp_regs_memmap_wc_p);
         break;
     case LPFC_SLI_INTF_IF_TYPE_1:
         break;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 734af3d039f8..a0b55bd8566e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15981,6 +15981,47 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba
*phba, uint16_t pci_barset)
     return NULL;
 }

+static phys_addr_t
+lpfc_dual_chute_pci_bar_addr(struct lpfc_hba *phba, uint16_t pci_barset)
+{
+    if (!phba->pcidev)
+        return PHYS_ADDR_MAX;
+
+    switch (pci_barset) {
+    case WQ_PCI_BAR_0_AND_1:
+        return phba->pci_bar0_map;
+    case WQ_PCI_BAR_2_AND_3:
+        return phba->pci_bar1_map;
+    case WQ_PCI_BAR_4_AND_5:
+        return phba->pci_bar2_map;
+    default:
+        break;
+    }
+    return PHYS_ADDR_MAX;
+}
+
+static __maybe_unused void __iomem *
+lpfc_dpp_wc_map(struct lpfc_hba *phba, uint16_t dpp_barset)
+{
+    if (!phba->sli4_hba.dpp_regs_memmap_wc_p) {
+        void __iomem *dpp_map;
+        phys_addr_t dpp_addr;
+
+        dpp_addr =3D lpfc_dual_chute_pci_bar_addr(phba, dpp_barset);
+        if (dpp_addr =3D=3D PHYS_ADDR_MAX)
+            return NULL;
+
+        dpp_map =3D ioremap_wc(dpp_addr,
+                     pci_resource_len(phba->pcidev,
+                              PCI_64BIT_BAR4));
+
+        if (dpp_map)
+            phba->sli4_hba.dpp_regs_memmap_wc_p =3D dpp_map;
+    }
+
+    return phba->sli4_hba.dpp_regs_memmap_wc_p;
+}
+
 /**
  * lpfc_modify_hba_eq_delay - Modify Delay Multiplier on EQs
  * @phba: HBA structure that EQs are on.
@@ -16944,9 +16985,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct
lpfc_queue *wq,
     uint8_t dpp_barset;
     uint32_t dpp_offset;
     uint8_t wq_create_version;
-#ifdef CONFIG_X86
-    unsigned long pg_addr;
-#endif

     /* sanity check on queue memory */
     if (!wq || !cq)
@@ -17132,14 +17170,15 @@ lpfc_wq_create(struct lpfc_hba *phba, struct
lpfc_queue *wq,

 #ifdef CONFIG_X86
             /* Enable combined writes for DPP aperture */
-            pg_addr =3D (unsigned long)(wq->dpp_regaddr) & PAGE_MASK;
-            rc =3D set_memory_wc(pg_addr, 1);
-            if (rc) {
+            bar_memmap_p =3D lpfc_dpp_wc_map(phba, dpp_barset);
+            if (!bar_memmap_p) {
                 lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
                     "3272 Cannot setup Combined "
                     "Write on WQ[%d] - disable DPP\n",
                     wq->queue_id);
                 phba->cfg_enable_dpp =3D 0;
+            } else {
+                wq->dpp_regaddr =3D bar_memmap_p + dpp_offset;
             }
 #else
             phba->cfg_enable_dpp =3D 0;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index ee58383492b2..b6d90604bb61 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -785,6 +785,9 @@ struct lpfc_sli4_hba {
     void __iomem *dpp_regs_memmap_p;  /* Kernel memory mapped address for
                        * dpp registers
                        */
+    void __iomem *dpp_regs_memmap_wc_p;/* Kernel memory mapped address for
+                        * dpp registers with write combining
+                        */
     union {
         struct {
             /* IF Type 0, BAR 0 PCI cfg space reg mem map */


Regards,
Justin
