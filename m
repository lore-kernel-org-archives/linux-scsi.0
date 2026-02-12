Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFB12581
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 00:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770854611; cv=pass; b=OMYeqDPayMbiJ2VwrkKydhpnDrQauN+KXVvkPIe8k/QFiUi3xmipAULhGJNAm3gAlfR0FLinzf2H1rJmlCTdiMc2ggNscKRWsAwk6rj0TlbAKzRVSp6xlIBTxuAbJaYyG9b0mazu9tjI4zf2bgfrrsGUaFX16YPz7wyNcjZa+yU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770854611; c=relaxed/simple;
	bh=UX2AvFCfHX9Xdac/OOYLstKl+KXsKqVDBl5xkks2A/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I4pwe8ktGv50/ZGYRHH4lMuAvDPW6AAK3K0NTprFW6cflIKH7h7BgophivWo/4N1JIhSGmCuahegTCy1M4P+a/FlCgifYM262oLYZx6AOhf8VOSyNZtMZzDZ5N5z/RoxWFvhd9yNNpDB743zJR3APGC70mKBFhj8GS/vtg6a+4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=enG2JkH3; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="enG2JkH3"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-896f9397ecdso30162026d6.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 16:03:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770854609; cv=none;
        d=google.com; s=arc-20240605;
        b=lL8EddJhgvFW0l/XHIsB8/Ia7EINo9j/7i5Ji6er9p2D6XOLPDzmTyMphZvfYfVZCq
         XjzYmiLi+lu7RS9GqinRh8Z70xWn47/EwpfAUu+r0XQCpuvH1hziyOsHwLu2UCeqhiq4
         eunlfd6C6Sn8ls33wu8kPO+AXTHai9tTx1mCDrAFdYMvMvbLxI/CFSxSQpbXXH63ltx7
         T/O6eXfqVS8va78Yn7fownzJx8KYMRyIQ0WU37ZLY8IUBzOwMTMQKTbzhttfv4FTqVt/
         Aq9FlSnNDzw45RhCa1hXAaK70y7jujgoCNSMbv5eAiudwSZTFuROriQAqqDiGge/ayEm
         tgcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NA+da2ISexxU0MvbLeMMxlLd16lWOsS0VskAeoluY8w=;
        fh=t5Vj/X07xT37NoXqNtk+1kLpEQBhwUB94pbAVo4usQ0=;
        b=fSCJtn2HsLUa59KQoT1NVm/ZfstuY4ArholYJNGD8mcAHZt4i/1CUKnhTLvQZZ4Rc9
         dxGahvTJ3drD+/AAFV5AXt1YR1MyD5pNR97mJMPnZO+rS8F7khSS2Vfpl72ATwXytMCw
         KX1IZ1ZzvNmhC19E4sy17fIbiOBRCAKlinrmXEDvM4QsVq300wvo9m9q/BVM1uC4crk9
         MEOo0pZbPmkz16XJJyF62bxikdJl/fXNjSQR0B4LXgNj0lPUSWBe/jUfiSrfMXAREGLO
         gE01tbQASoqj0aNhQ8wgbUoy9I1nzuThgARH3zOfaEjeVJAroNMDF1BrUKNZ1FSNlWgS
         PReQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770854609; x=1771459409; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NA+da2ISexxU0MvbLeMMxlLd16lWOsS0VskAeoluY8w=;
        b=enG2JkH3YrDjqs+j5/LiUp0zj+8Kd1+p+6/nNesoMERp67Ijt+DJTGyk7ej1NZiw73
         9cWlpmbtCuIuYWhSMfKqrDkh27v6PLBK3m6OwI5NAqaGc+zY02gMhOUS7xtjpqK0Gu2O
         nllNplbtCTsyfqEv+gfMRYzw2C9VTvjWhG5Ipv1Z8UPXbkQhYKepk8I2TadI5KyJGe2U
         pr2nKr3WrzdvJFc+iCsae79GW+ThJbD8KjSgWrWb2b0oE2aOmGXMOYOGIylMMYPcQiM0
         3sXC4wrALFoMtmJxNnRHMiRVSaXl9XU57+m2eG4yzzXKEnRD14RO/eKKbL6ncvHLQNeo
         svwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770854609; x=1771459409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NA+da2ISexxU0MvbLeMMxlLd16lWOsS0VskAeoluY8w=;
        b=g5o7WiKuSfuxh+Oiddi773xBMKz211mhrhqxxaCk1cc6nGerosPB5xUhzENIURxHIA
         2HvjMd+cIF48KBD3bYASoa0CJ9qC54uXTFd06H4L5bi9QCT4NoqOOtEwce2LVvQ54MbO
         GU3FOW1QKyY0JB3qiQ0UphD+TeTjGAHKIc+vaeOpMmAa2xFlfvd1pOTDZAdyjB+7ZZYr
         jcN4ZhF1WsWY40odsgl32rf6m/x9kVi3tVxF6cfkYtpGYLgbiYHHngI4vpEwWtevuYVu
         qS4ligD72Tx7D7VdFLbMKhl8sTACx/0Dl1+TslxOt0XUFBkUJntCwaEynhOHqZE5to8n
         C0/A==
X-Forwarded-Encrypted: i=1; AJvYcCWimHNAdxAu2UCHl7eSyyJZ7W9ph/U2wJJoK7VSTHhgci5Rwvi+pOo0aLrsy/pPNq0v3c/AX0gDggTU@vger.kernel.org
X-Gm-Message-State: AOJu0YzbuYt2R9LHtKojhL8+9JM//1Z8ETQDY7tSxClRdO0KPH/AREFV
	7fa1J6ZoYSABMCdDEiaScc/HjOGcwDAFvDZgt1LfndUQPYhffOBZCrXLu3XajY/Ain196e5Ylr1
	JBa2fIIezLTM5gNle/HaQtVOuNnATcds=
X-Gm-Gg: AZuq6aK23VXhYiw8iuNNMHVak1jts+XvsSVwjdyjoTPYoQDLHrls+qazom958FhxfWY
	cEG+zkymEyz+bLF1UJsBadbZca4k19cFE2vifgRBKP3D6U3Wqimw8FwaoW/wz9ELkR1xGPJ0fFl
	B+v2FRk2so4/5aUKPTraroV1+SGR5dyE8fCSOL33yR1++SocmkKCAmK3kZn/5yH50CLRysWVJTd
	FJjAK3C/2u/5KoFdWJtbiUEFtx6bqxfcBNcy7X6RvQ2PNdBbMNQb5EmRrU0iOqbh9rP+5juX7IC
	+niEax62vrGywRHrHJU=
X-Received: by 2002:a05:6214:1c8c:b0:896:f588:b2de with SMTP id
 6a1803df08f44-89729c60314mr7669156d6.32.1770854608603; Wed, 11 Feb 2026
 16:03:28 -0800 (PST)
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
 <CABPRKS_cT5f21A-Jkx_uhA+SF4THpPSaqKtk8mWk9nN4Gh9LFQ@mail.gmail.com> <82f38f49-2f50-4c8b-9482-e446e61d5006@grsecurity.net>
In-Reply-To: <82f38f49-2f50-4c8b-9482-e446e61d5006@grsecurity.net>
From: Justin Tee <justintee8345@gmail.com>
Date: Wed, 11 Feb 2026 16:01:28 -0800
X-Gm-Features: AZwV_QjyhkE0Us2-qH2m0GNkCNWaiDfoVHiiJ29k5j_byhufcFvswZ3ygtafHoc
Message-ID: <CABPRKS8yunk2P9vH0qr0Z-FS3Og17btQDa6dxYDs_2G-1QXkjg@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Properly set WC for DPP mapping
To: Mathias Krause <minipli@grsecurity.net>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>, 
	linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> You're hard-coding PCI_64BIT_BAR4 here which *feels* inappropriate if we
> went all the way with wrappers like lpfc_dual_chute_pci_bar_addr() and
> making sure to be using the BAR the device told us. In fact, that was
> the reason, I did it like this, assuming it might be something else than
> WQ_PCI_BAR_4_AND_5, e.g. a BAR shared with the doorbell registers. If
> that cannot happen, what's the reason to have 'dpp_offset'?

Totally right, we actually only use WQ_PCI_BAR_4_AND_5 for dpp.
Hence, the hardcode to PCI_64BIT_BAR4.  Please see revised patch
below.

The reason for dpp_offset is to be able to store the dpp register
address for each individual WQ created.  We can just add the
dpp_offset from the response of our mailbox command on top of the base
dpp register address.

> Also, what's the reason to do the offset calculation in the caller?
> ioremap_wc() can handle non-page-aligned / offset addresses just fine.
> That's why my version passed dpp_offset to lpfc_dpp_wc_map() and made it
> adjust the to-be-mapped address before calling ioremap_wc(); to only
> remap what's needed.
> Same for the size: I just capped it to what's needed by its only user in
> lpfc_sli4_wq_put(). Again, ioremap_wc() will do "The Right Thing(TM)"
> and map all required pages.

Sure, but the DPP apertures are contiguous anyways so what=E2=80=99s the ha=
rm
in a single ioremap_wc call and then have each wq->dpp_regaddr point
to its corresponding dpp register address, it seemed simpler?

> Out of curiosity, the I/O stalls are no longer happening with this versio=
n?
Yes, I/O stalls are no longer happening with that version and the
revised patch below.

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a116a16c4a6f..b5e53c7d33e7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12039,6 +12039,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
                iounmap(phba->sli4_hba.conf_regs_memmap_p);
                if (phba->sli4_hba.dpp_regs_memmap_p)
                        iounmap(phba->sli4_hba.dpp_regs_memmap_p);
+               if (phba->sli4_hba.dpp_regs_memmap_wc_p)
+                       iounmap(phba->sli4_hba.dpp_regs_memmap_wc_p);
                break;
        case LPFC_SLI_INTF_IF_TYPE_1:
                break;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 734af3d039f8..f4bff6ee3a0b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -15981,6 +15981,23 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba
*phba, uint16_t pci_barset)
        return NULL;
 }

+static __maybe_unused void __iomem *
+lpfc_dpp_wc_map(struct lpfc_hba *phba)
+{
+       if (!phba->sli4_hba.dpp_regs_memmap_wc_p) {
+               void __iomem *dpp_map;
+
+               dpp_map =3D ioremap_wc(phba->pci_bar2_map,
+                                    pci_resource_len(phba->pcidev,
+                                                     PCI_64BIT_BAR4));
+
+               if (dpp_map)
+                       phba->sli4_hba.dpp_regs_memmap_wc_p =3D dpp_map;
+       }
+
+       return phba->sli4_hba.dpp_regs_memmap_wc_p;
+}
+
 /**
  * lpfc_modify_hba_eq_delay - Modify Delay Multiplier on EQs
  * @phba: HBA structure that EQs are on.
@@ -16944,9 +16961,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct
lpfc_queue *wq,
        uint8_t dpp_barset;
        uint32_t dpp_offset;
        uint8_t wq_create_version;
-#ifdef CONFIG_X86
-       unsigned long pg_addr;
-#endif

        /* sanity check on queue memory */
        if (!wq || !cq)
@@ -17132,14 +17146,15 @@ lpfc_wq_create(struct lpfc_hba *phba, struct
lpfc_queue *wq,

 #ifdef CONFIG_X86
                        /* Enable combined writes for DPP aperture */
-                       pg_addr =3D (unsigned long)(wq->dpp_regaddr) & PAGE=
_MASK;
-                       rc =3D set_memory_wc(pg_addr, 1);
-                       if (rc) {
+                       bar_memmap_p =3D lpfc_dpp_wc_map(phba);
+                       if (!bar_memmap_p) {
                                lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
                                        "3272 Cannot setup Combined "
                                        "Write on WQ[%d] - disable DPP\n",
                                        wq->queue_id);
                                phba->cfg_enable_dpp =3D 0;
+                       } else {
+                               wq->dpp_regaddr =3D bar_memmap_p + dpp_offs=
et;
                        }
 #else
                        phba->cfg_enable_dpp =3D 0;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index ee58383492b2..b6d90604bb61 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -785,6 +785,9 @@ struct lpfc_sli4_hba {
        void __iomem *dpp_regs_memmap_p;  /* Kernel memory mapped address f=
or
                                           * dpp registers
                                           */
+       void __iomem *dpp_regs_memmap_wc_p;/* Kernel memory mapped address =
for
+                                           * dpp registers with write comb=
ining
+                                           */
        union {
                struct {
                        /* IF Type 0, BAR 0 PCI cfg space reg mem map */
