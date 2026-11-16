Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.129.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794835504;
	b=pqyZ53rYHnCWISq1qqVatFERB3xii1CIyv5vPuDjGAJ5XvbxmkAaH0uw3/QXhtFp/mVH
	 CdFN990dCu3bRLDnnC7dJUd+fyNE+eObPXemL+7JZUe5ZpeuJcnloTvf1iWFyO/CaK+G4
	 IYPY7eJu9Trbmgioy6Fqoc9+EjUM4VZijUJ8r+LD6YnMMy6Ewe4jYvnklz36RqcS3Homu
	 P3kqQRfH7kTtSEDXBOYAilA1sS3LyLqvx0DVB9gmv3Fy24sqFywoV7BM2XJMpmj4UUcHW
	 YlXGbiP+T39gyt8BKgjuhI6EQOvrEqr/i+K7nmhYA67C8jneZjdldCL5npXxK3ecpIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794835504;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=P0or60iH8KD6aVVIkNBvUiUCGLvpK7LSLC/zGWPxXoI=;
	b=GwSDn8Y+oxbYilcrLToMAqn2nYYRUVMluvaJgVVVZ/kpf+2GmWI+/2wxnbVBu+YOB6X0
	 0yMqoCTaO+/h0uDwMZu5iu48NhazIakJFhvYKryoyjDZnAsB3QsKLmY2+yaT5MZ9zvGtL
	 CRYhO+IZDCim+DMKvM6zLqZh4AscFDZ0+mWa3rwBKDr30ourNmIrY44isjLeXmF8uNObO
	 cN461VOtufrLBbdLGETUzGl6zpOx+YTpIBAPu2L0YyuRe8A20f0j7xnsimyLJd9pSYyXO
	 cdod4JUlRj7IdAWfVCRGp/UYcZPqUNNRg5pVX7UCQhOJE7TuhEEuwVd/1dqIrVhFO6w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OplHaKuG;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=sWJnNv6U;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD67606A33B
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:25:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AD67606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OplHaKuG;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=sWJnNv6U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794835502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P0or60iH8KD6aVVIkNBvUiUCGLvpK7LSLC/zGWPxXoI=;
	b=OplHaKuGoD8QOQXnZKl7UBvEKqqd+0nAZaHjM0rX/6fclEUbNSlsHB1i9t1AhmTCcM1TZr
	kmjyp0MTUewEqJAg/jrh4M5xLZLhOX2gTBRvy/UyjLu3wQQ+KJ7wtLMAfC6o3Wv6eHSah+
	Iv2WEAaQ8LGM4VU+7xUCjFtpwhl6bAU=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-30VOUNKnNTeWGSAQL8_myA-1; Mon, 16 Nov 2026 08:25:00 -0500
X-MC-Unique: 30VOUNKnNTeWGSAQL8_myA-1
X-Mimecast-MFC-AGG-ID: 30VOUNKnNTeWGSAQL8_myA_1794835499
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3ae10702993so3127441fa.3
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 05:25:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794835499; cv=none;
        d=google.com; s=arc-20260327;
        b=rtymBe2Agth4mX4hh1aV5TaTtOYGuA8pCh9A4hQ/cmw3tI0X1wN1f/vz4+2W73sdGt
         uY1gUYPkazgkRDIeNCO3j9dzatBTcFjpTEl14cc7igW3U9pIALzS++u7X2Pet2zv2ecW
         OHm+xipN59Xp8HtIhFZvLX+abQ0T7bQgjsXtndWrPBO+rN2zlLEXxo6EEdwh5btdBRQK
         e3IjEcaVyRCrZODcwqkCHLh2z/KQvHveFfR4yNBKtf8NpQaeP6/VubqiJO5Rtmb8sXE8
         t48l7u6iVwU3AnnqtbDPiVzFi051G1+aQkXahqQ6Df2+8QcgBnThopcgFOyOMIksjAb/
         Y45Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P0or60iH8KD6aVVIkNBvUiUCGLvpK7LSLC/zGWPxXoI=;
        fh=bDm7yJy2zwc29fwuRu2H8KpD+fRkZZF/vpQIVpyGAKw=;
        b=hQ+0E/OoXnBCCUMCitH5XFWZoQeNvLi1xRkMZG9Ck9A1EgNNjAyhKGrR+4CrDG/Jre
         b5vsaJxON+4UjOFtsl5rcuu8goj9Neol+I8A+7Q9umrX2fwbluDY3o/U4DYwYgfRhxF4
         G04iCJP4vJ/syRuOf3xn6JgX5X8vWtGoZWXJdzLPfna2sgtvKMYUPLptpJYE6CtTa29s
         WZye+WWR8Bn94eyExXm0qfmajC/z6LVyAVThry1gofCsFjuaZG8OW9iiXYeWv+5BPvY5
         pUwYlvoKYupJE7mgH6gDGH9TmZi9VWeGJJvexE92DTrb3vcN9bYAasqbIlXPhPBHb+3J
         C+Tw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794835499; x=1795440299; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P0or60iH8KD6aVVIkNBvUiUCGLvpK7LSLC/zGWPxXoI=;
        b=sWJnNv6UfjQFEyBlH6VYih/dysn6z3uGY8/Iv0ob6XOYc1gc5jdYgWVtcj47Am6FL+
         vwOHJgvOgqJ9B0m7DWY/bJGY6fZjlFEdfKOPqO06PMikk3INSLiAwck8T4WVjSlhCCjZ
         JMrKRJGPWMxoZ1aVRDJ0o5aB9HJ84ChGkN/iCq0R7JVqJx2DtuYqzB3CHLGagbnLOm/v
         Nj58/A99ZlnFDnSKzVTCwB4Ut4qnvmjbGeFsM1k0qOi798QMr/bayWUPR38zvfUW5X7D
         Lu4/7bvmxt6My3jRqWupBKvM9XiMcnyJljplIiM3j33dTI+mvP8okZ+CQHP8jC2DL7Bq
         NoOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794835499; x=1795440299;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P0or60iH8KD6aVVIkNBvUiUCGLvpK7LSLC/zGWPxXoI=;
        b=ybDu4OPw3aijGWqwYwqAe5tcMJkPhq+5NZUQgBBE1gT5QoEJPjnHjeGB6lCn/h16vi
         hhR4PM1IwRs7T+evmbYcmfwu9cV68FrwaK0Njj2TitJi9SZQDS0vATfhkDrQK5BPEGlj
         vV1gRYMj+6k91SqKaXZzNgXRmk/4Qq6spJOx+r9xFU37W57Munp2QPuiGdSO6F56gCzd
         qqUPEmE+2OKM0tdZGsgv3Bp74mISehzEVB0ph/e5Q5Rx2zlo3tmvFvoxhsuGbDAl97IQ
         mg1akAN2ORNtmbjrFVhuEicB8yFJtl39iqOgPqNCFtWzM58UeSmoNwhW3B0dJgTsJAmk
         d2qg==
X-Forwarded-Encrypted: i=1; AL+hErFgYjuO2NaZMPnRufF/fYo3UbML7a2f0QZ13grnud6uKJsbN3LQcRjP6BzvS1MNdjgiWz8TeC04HTiN@vger.kernel.org
X-Gm-Message-State: APuU4Z8CwFbx6HLxQ3m84diF2KfNcp94AQx2SsC3RLr9huZNzsUxHypP
	PqwpS0Aec4n0D6WCGvhIq4IJgRlgN/raxeC3PqToquYm33rHTTUo9KK/nXpRsnkTigF/F6PNlUt
	ARzQj3R6PblSDIbBav+0Ji/U+Uj4tQDy5kuCmlJ5S9Evyf1XztypQzqhjU09DIH5IQnIFjBcXhW
	G98S6ktcCcu8cJzpXXidlb7GYuy4MB7ndyiTIEzA==
X-Gm-Gg: AYBFou3WK1xnlJ6AXYhdZC2DiAeNqr+yMVOMPhDiYoXi0Ucbq1BmUydYHx/lhmQWsWV
	cMA3jd+ELMkG5KWeVKRHQL7Oig4Li3QCVnKHDYYLvGjabdn/j3rhLlASnW5ZG0iEfuzM2BBLFLt
	IL8SKM9sTeUWlty+T3t9ogjhv3SIDhN04XIhBP1u89F7K3m4yq4zVCVjU+
X-Received: by 2002:a05:651c:e112:20b0:3ab:1d67:caf with SMTP id 38308e7fff4ca-3ae2b394355mr26665961fa.0.1794835498814;
        Mon, 16 Nov 2026 05:24:58 -0800 (PST)
X-Received: by 2002:a05:651c:e112:20b0:3ab:1d67:caf with SMTP id
 38308e7fff4ca-3ae2b394355mr26665691fa.0.1794835498182; Mon, 16 Nov 2026
 05:24:58 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114-b4-ufs-s32n7-v11-0-dc36e11919d5@oss.nxp.com>
In-Reply-To: <20261114-b4-ufs-s32n7-v11-0-dc36e11919d5@oss.nxp.com>
From: Enric Balletbo i Serra <eballetb@redhat.com>
Date: Mon, 16 Nov 2026 14:24:45 +0100
X-Gm-Features: AclHuK8HnePhPDPUHuce7pVJV7FFzGqggvZufNxDNXFt_WHCsNiK_-bsjhSBvsE
Message-ID: <CALE0LRseQXtrDG3=QgXBgB33O+BBfyeSeKcHdDzL++VT6ocFXg@mail.gmail.com>
Subject: Re: [PATCH v11 00/14] Add S32N79RDB UFS support
To: larisa.grigore@oss.nxp.com
Cc: "Martin K. Petersen" <mkp@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bart Van Assche <bvanassche@acm.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Rob Herring <robh@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, devicetree@vger.kernel.org, 
	Ajay Neeli <ajay.neeli@amd.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	linux-arm-msm@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>, 
	linux-kernel@vger.kernel.org, NXP S32 Linux Team <s32@nxp.com>, 
	Asutosh Das <quic_asutoshd@quicinc.com>, linux-arm-kernel@lists.infradead.org, 
	Stanley Jhu <stanleyjhu@google.com>, Frank Li <Frank.Li@nxp.com>, imx@lists.linux.dev, 
	linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>, 
	linux-mediatek@lists.infradead.org, linux-samsung-soc@vger.kernel.org, 
	Pedro Sousa <pedrom.sousa@synopsys.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Peter Griffin <peter.griffin@linaro.org>, echanude@redhat.com, 
	Chaotian Jing <chaotian.jing@mediatek.com>, 
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>, 
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>, Manivannan Sadhasivam <mani@kernel.org>, 
	linux-rockchip@lists.infradead.org, Krzysztof Kozlowski <krzk@kernel.org>, clizzi@redhat.com, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Heiko Stuebner <heiko@sntech.de>, 
	Matthias Brugger <matthias.bgg@gmail.com>, Chunyan Zhang <zhang.lyra@gmail.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, Orson Zhai <orsonzhai@gmail.com>, aruizrui@redhat.com, 
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Larisa,

Thank you for taking care of this



On Sat, Nov 14, 2026 at 12:57=E2=80=AFPM Larisa Grigore via B4 Relay
<devnull+larisa.grigore.oss.nxp.com@kernel.org> wrote:
>
> This series adds support for the UFS host controller found on the NXP S32=
N79
> platform. The controller is based on the Synopsys DesignWare (DWC) UFS ho=
st
> architecture and requires S32N79-specific M-PHY initialization/calibratio=
n
> sequence. It is compliant with JESD-223D "Universal Flash Storage Host
> Controller Interface" v3.0, and supports up to HS-Gear 4 speed grade. It =
is
> compatible with UFS 2.1, 3.0 and 3.1 devices. The MIPI UniPro is complian=
t with
> "MIPI Alliance Specification for Unified Protocol", v1.8. The MIPI M-PHY =
is
> compliant to version 4.1.
>
> In order to keep the S32N79 platform driver small and avoid duplicating c=
ommon
> DWC code across platform glue drivers, the series also refactors and expo=
rts a
> few reusable DWC helpers. In particular, M-PHY CREG (CBCREG*) register ac=
cess
> helpers and the shared M-PHY CR bitfield definitions are moved from the
> existing AMD Versal2 glue driver into the common ufshcd-dwc layer, and ar=
e then
> used by the platform drivers. The series also introduces a generic Hibern=
8
> TX-FSM polling helper so that multiple platforms can reuse the same pre-l=
ink
> checks.
>
> Device tree binding documentation for the S32N79 UFS controller is includ=
ed.
> The SoC and board DTS updates that instantiate and enable the controller =
are
> no longer part of this series and will be posted separately.
>
> Changes in v11:
>
> ufs: dwc: Move shared M-PHY CR bitfield macros to ufshcd-dwc.h:
> - New patch. Move the FAST_FLAGS, FW_CALIB_CCFG, RX_OVRD_IN_1 and RX_PCS_=
OUT
>   bitfield macros from the AMD Versal2 driver to ufshcd-dwc.h, so the S32=
N7
>   driver can use them instead of raw values.
>
> ufs: pltfrm: Add a flags argument to ufshcd_pltfrm_init():
> - New patch. Let glue drivers request optional behavior from the common
>   platform code. All existing callers pass 0, no functional change.
>
> ufs: pltfrm: Add a flag to manage fixed rate clocks:
> - New patch. Add UFSHCD_PLTFRM_FIXED_RATE_CLKS. When it is set and neithe=
r
>   freq-table-hz nor operating-points-v2 is present, register the clocks
>   listed in clock-names with a 0 Hz min/max rate, so the UFS core enables
>   and gates them without scaling. This replaces the dummy single 0 Hz
>   operating-points-v2 table used in v10.
>
> dt-bindings: ufs: Add NXP S32N79 UFS host controller:
> - Dropped operating-points-v2 from the required properties and the OPP
>   table from the example, the fixed rate core clock is now handled by
>   UFSHCD_PLTFRM_FIXED_RATE_CLKS.
> - Reworded the commit message accordingly.
>
> ufs: s32n7: Add NXP S32N79 UFS host controller driver:
> - Pass UFSHCD_PLTFRM_FIXED_RATE_CLKS to ufshcd_pltfrm_init() so the UFS
>   core manages the fixed rate "core" clock without an OPP table.
> - Also clear the DWC BUSTHRTL clock gating enable (CGE) after each HCE
>   enable, as clock gating is not supported on this platform. Added the
>   DWC_UFS_BUSTHRTL_CGE definition to ufshci-dwc.h.
> - Moved the local N_DeviceID programming from the link startup POST_CHANG=
E
>   to the PRE_CHANGE hook, before DME_LINKSTARTUP, as in the recommended
>   sequence. Kept the local-only CPort 0 setup instead of
>   ufshcd_dwc_connection_setup(), which programs different settings (it
>   clears the host N_DeviceID_valid and sets the device T_PeerDeviceID
>   to 1). This additional context is provided here rather than in the comm=
it
>   message, as it explains why the suggested alternative was not used rath=
er
>   than the change itself.
> - Defined the CBREFCLKCTRL2 ref_clk_en_unipro and ref_clk_en_app override
>   enable bits in ufshcd-dwc.h, next to the existing ref_clk_gating_suppor=
t
>   one.
> - Embedded the variant ops in struct s32n7_soc_data and recovered the SoC=
 data
>   in init() with container_of_const(), so device_get_match_data() is only
>   called once, in probe().
> - Documented why SCM_STATUS is first written back to its reset value: eac=
h
>   M-PHY start-up sequence must start with the PHY in reset, and the PHY m=
ay
>   still be running on the host reset / error recovery paths.
> - Replaced the raw M-PHY values with the shared bitfield macros, includin=
g
>   the CBREFCLKCTRL2 override enable bits.
> - Updated the commit message for the CGE and fixed rate clock changes.
> - Dropped the Reviewed-by tag of Frank Li.
>
> - Link to v10: https://lore.kernel.org/all/20261103133215.1385823-1-laris=
a.grigore@oss.nxp.com/
>
> Changes in v10:
>
> All patches:
> - Dropped the "scsi:" subject prefix.
>
> ufs: core: Return a negative errno from WLUN suspend/resume:
> - New patch. __ufshcd_wl_suspend() and __ufshcd_wl_resume() may return a
>   positive result code, e.g. from ufshcd_link_startup(). The runtime PM c=
ore
>   treats it as a failure, but rpm_get_suppliers() only checks for a negat=
ive
>   value, so the LUs consuming the WLUN are reported as resumed while the =
host
>   is in the error state. Convert positive values to -EIO at the WLUN PM
>   callback boundary, as ufshcd_init() already does. This replaces the
>   Fixes: rationale previously carried by the dwc link_is_up() patch and
>   covers every source of positive values, not only the DWC glue.
>
> ufs: dwc: Return a negative error if the link is down:
> - Dropped the Fixes: tag. The PM-boundary issue is now fixed in the core;
>   this patch is a cleanup so the helper returns an errno before it is
>   exported.
>
> ufs: unipro: Add TX/RX FSM state attributes:
> - Fixed the commit message: AMD Versal2 has no header with these
>   definitions, only users in the .c file.
>
> ufs: core: Add common Hibern8 TX FSM polling helper:
> - Changed the subject prefix from "ufs: host:" to "ufs: core:".
> - Fixed the helper name in the commit message.
> - Renamed the internal per-lane poller from ufshcd_poll_tx_hibern8_lanes(=
)
>   to ufshcd_tx_lanes_in_hibern8().
> - Log the TX_FSM_STATE of each lane that did not reach Hibern8 on timeout=
.
> - Moved the prototype to the non-extern declarations and dropped "extern"=
.
> - Report a positive UIC result from DME_GET as -EIO, so the helper really
>   returns a negative errno as documented.
> - Fixed checkpatch --strict alignment checks.
> - Dropped the Reviewed-by tags of Frank Li and Stanley Jhu, as the patch
>   changed significantly.
>
> ufs: dwc: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
> - Reworded the commit message and explained the static array race.
> - Use the "name() - description" kernel-doc style like the rest of the
>   file.
>
> dt-bindings: ufs: Add NXP S32N79 UFS host controller:
> - Restricted lanes-per-direction to 2, matching the driver.
> - Explained in the commit message why clock-names and the single 0 Hz
>   operating-points-v2 entry are required.
>
> ufs: s32n7: Add NXP S32N79 UFS host controller driver:
> - Changed the subject prefix to "ufs: s32n7:".
> - Added <linux/bitfield.h> and <linux/bits.h>.
> - Reject lanes-per-direction other than 2.
> - Dropped redundant error messages and the remove() wrapper.
> - Used u32 for the ufshcd_dme_get() result, aligned register offset style=
,
>   clarified the SCM_STATUS comments.
> - Documented the PERFORM_LINK_STARTUP_ONCE quirk and spm_lvl in the commi=
t
>   message, and updated the HS rate-select bullet.
> - Documented in the commit message that the DWC BUSTHRTL power gating is
>   disabled because it is not supported on this platform.
>
> Changes in v9:
>
> ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h:
> - Prefixed the RX_STATE_* and TX_STATE_* enum constants with UFS_ to avoi=
d
>   polluting the global namespace, and updated the existing users
>   (AMD Versal2, HiSilicon, Qualcomm).
>
> ufs: host: Add common Hibern8 TX FSM polling helper:
> - Use the renamed UFS_TX_STATE_HIBERN8 constant.
>
> dt-bindings: ufs: Add NXP S32N79 UFS host controller:
> - Added Reviewed-by: Frank Li.
>
> MAINTAINERS: Add NXP S32N7 UFS host controller entry:
> - Added the imx@lists.linux.dev mailing list.
>
> arm64: dts: freescale: s32n79: Add UFS host controller:
> arm64: dts: freescale: s32n79-rdb: Enable UFS:
> - Dropped from this series, as requested; they will be sent separately.
>
> Changes in v8:
>
> ufs: host: Add common Hibern8 TX FSM polling helper:
> - Added Reviewed-by: Stanley Jhu.
>
> scsi: ufs: Add NXP S32N79 UFS host controller driver:
> - Let the UFS core manage the core reference clock: declare it in DT via
>   clock-names/operating-points-v2 so the core adds it to hba->clk_list_he=
ad
>   and gates it across system suspend and runtime idle. Dropped the manual
>   devm_clk_get_enabled() and the struct s32n7_ufs core_clk member, and no=
w
>   read the clock rate from the core clock list.
> - Dropped the ufs_s32n7_calculate_us_tick() wrapper and inlined the divis=
ion.
> - Dropped the unused struct s32n7_ufs hba member.
>
> dt-bindings: ufs: Add NXP S32N79 UFS host controller:
> - Added the required clock-names and operating-points-v2 properties.
> - Dropped the Reviewed-by and Acked-by tags.
>
> arm64: dts: freescale: s32n79: Add UFS host controller:
> - Added clock-names =3D "core" and an operating-points-v2 table with
>   opp-hz =3D <0> (fixed-rate clock) so the UFS core manages (and gates) t=
he
>   core reference clock.
>
> Changes in v7:
>
> scsi: ufs: Add NXP S32N79 UFS host controller driver:
> - Wrapped .prepare/.complete in pm_sleep_ptr() instead of pm_ptr().
> - Fixed code alignment issues.
>
> Changes in v6:
>
> scsi: ufs: dwc: Return a negative error if the link is down:
> - Translate a positive UIC command result from ufshcd_dme_get() into -EIO=
.
> - Declare dme_result as u32 to match the ufshcd_dme_get() parameter type.
>
> scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset:
> - Added Reviewed-by: Frank Li.
>
> scsi: ufs: Add NXP S32N79 UFS host controller driver:
> - Added Reviewed-by: Frank Li.
>
> Changes in v5:
>
> scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset:
> - New patch. Split the macro reorder into its own cleanup.
>
> ufs: host: Add common Hibern8 TX FSM polling helper:
> - Return the real poller error on timeout, not a forced -ETIMEDOUT.
>
> dt-bindings: ufs: Add NXP S32N79 UFS host controller:
> - Dropped the jedec,ufs-2.0 fallback.
> - Removed the select: block and the clocks description.
>
> scsi: ufs: Add NXP S32N79 UFS host controller driver:
> - Documented the timeout values as driver-defined bounds.
> - Wrapped .prepare/.complete in pm_ptr().
>
> arm64: dts: freescale: s32n79: Add UFS host controller:
> - Dropped the jedec,ufs-2.0 fallback.
>
> Changes in v4:
>
> scsi: ufs: dwc: Return a negative error if the link is down:
> - New patch. ufshcd_dwc_link_is_up() now returns a negative errno on fail=
ure
>   instead of a positive value.
>
> ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
> - Added Reviewed-by: Frank Li.
>
> ufs: host: Add common Hibern8 TX FSM polling helper:
> - Refactored ufshcd_dme_check_tx_hibern8() to use read_poll_timeout().
>
> scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
> - Added Reviewed-by: Frank Li.
>
> dt-bindings: ufs: Add NXP S32N79 UFS host controller:
> - Added Reviewed-by: Frank Li.
>
> Changes in v3:
>
> ufs: host: Add common Hibern8 TX FSM polling helper:
> - Use -EAGAIN while polling and only normalize to -ETIMEDOUT on timeout, =
so
>   real attribute-read errors are returned instead of masked.
> - Drop the stray delay.h include in ufshcd-pltfrm.c; the helper lives in
>   ufshcd.c.
> - Drop the now-redundant dev_err() after the check in the HiSilicon drive=
r.
>
> scsi: ufs: Add NXP S32N79 UFS host controller driver:
> - Use devm_clk_get_enabled() to enable the core reference clock.
> - Rename the family-level identifiers from the s32n_ prefix to s32n7_
>   (structs and functions), keeping the s32n79_ prefix only for the
>   chip-specific data.
>
> Changes in v2:
>
> ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h:
> - Improved the enum comments. They now cite the MIPI M-PHY v6.0 tables.
>
> ufs: unipro: Add TX/RX FSM state attributes:
> - Added Reviewed-by: Frank Li.
>
> ufs: host: Add common Hibern8 TX FSM polling helper:
> - Moved the helper into the UFS core (ufshcd.c).
> - Split out an inner per-lane poller, ufshcd_poll_tx_hibern8_lanes().
> - Expanded the commit message to document the -ETIMEDOUT normalization do=
ne
>   when converting the qcom/hisi checks to the helper. No code behaviour c=
hange.
>
> scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
> - Made the DME attribute arrays const. They are now initialized inline in=
stead
>   of by later field assignments.
>
> scsi: ufs: dwc: Export common clock divider and link status helpers:
> - Added Reviewed-by: Frank Li.
>
> dt-bindings: ufs: Add NXP S32N79 UFS host controller:
> - Renamed the patch subject and simplified the commit message.
> - Renamed the binding file to nxp,s32n79-ufshc.yaml so it matches the
>   nxp,s32n79-ufshc compatible string.
> - Removed the nxp,mphy-boot-mode property.
> - Made reg-names and clocks required.
> - Removed the conditional if/then/else schema.
> - Removed clock-names.
> - Changed the compatible from jedec,ufs-3.0 to jedec,ufs-2.0.
> - Updated the example clocks to <&clks 0x92>.
>
> scsi: ufs: Add NXP S32N79 UFS host controller driver:
> - Removed the nxp,mphy-boot-mode handling and the mphy_boot_mode enum. Th=
e
>   M-PHY firmware always runs from ROM now.
> - Added a struct s32n_soc_data for SoC match data.
> - Moved the calibration writes out to static const tables.
> - Renamed struct phy_reg_cfg to s32n_phy_reg.
> - Moved the rate-select sequence out of link_startup_post_change() into a=
 new
>   pwr_change_notify() pre-change path.
> - Used devm_clk_get(dev, NULL) and dropped the redundant core_clk NULL ch=
eck.
> - Switched to *_PM_OPS() macros and pm_ptr() for the PM ops.
> - Clarified the Hibern8 poll timeout comment.
> - Enabled Auto-Hibern8 instead of setting UFSHCD_QUIRK_BROKEN_AUTO_HIBERN=
8.
> - Reworked and improved the M-PHY initialization sequence.
>
> arm64: dts: freescale: s32n79: Add UFS host controller:
> - Changed the compatible from jedec,ufs-3.0 to jedec,ufs-2.0.
> - Removed clock-names.
>
> arm64: dts: freescale: s32n79-rdb: Enable UFS:
> - Removed the nxp,mphy-boot-mode property.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>

During testing, I found the following error, which **seems totally
unrelated** to this series.

 [   10.730295] ufs-s32n7 4ac80000.ufs: ufshcd_query_attr: opcode 0x04
for idn 15 failed, index 0, err =3D 15
 [   10.730304] ufs-s32n7 4ac80000.ufs: ufshcd_update_rtc: Failed to
update rtc 15

Using the query_retry variant, which every single caller in the
codebase seems to use, get rid of the error. I'll send a follow up
patch for this.

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ca8329052cbc..4dfa50e67542 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8739,8 +8739,8 @@ static void ufshcd_update_rtc(struct ufs_hba *hba)
        if (ufshcd_rpm_get_if_active(hba) <=3D 0)
                return;

-       err =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
QUERY_ATTR_IDN_SECONDS_PASSED,
-                               0, 0, &val);
+       err =3D ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+                                    QUERY_ATTR_IDN_SECONDS_PASSED, 0, 0, &=
val);
        ufshcd_rpm_put(hba);

        if (err)


In any case, tested on an NXP S32N79-RDB board. UFS I/O works normally.

Tested-by: Enric Balletbo i Serra <eballetb@redhat.com>


> ---
> Larisa Grigore (14):
>       ufs: core: Return a negative errno from WLUN suspend/resume
>       ufs: dwc: Return a negative error if the link is down
>       ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
>       ufs: unipro: Add TX/RX FSM state attributes
>       ufs: core: Add common Hibern8 TX FSM polling helper
>       ufs: dwc: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
>       ufs: dwc: Export common clock divider and link status helpers
>       ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset
>       ufs: dwc: Move shared M-PHY CR bitfield macros to ufshcd-dwc.h
>       ufs: pltfrm: Add a flags argument to ufshcd_pltfrm_init()
>       ufs: pltfrm: Add a flag to manage fixed rate clocks
>       dt-bindings: ufs: Add NXP S32N79 UFS host controller
>       ufs: s32n7: Add NXP S32N79 UFS host controller driver
>       MAINTAINERS: Add NXP S32N7 UFS host controller entry
>
>  .../devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml  |  58 +++
>  MAINTAINERS                                        |   9 +
>  drivers/ufs/core/ufshcd.c                          | 101 +++-
>  drivers/ufs/host/Kconfig                           |  12 +
>  drivers/ufs/host/Makefile                          |   1 +
>  drivers/ufs/host/cdns-pltfrm.c                     |   2 +-
>  drivers/ufs/host/tc-dwc-g210-pltfrm.c              |   2 +-
>  drivers/ufs/host/ufs-amd-versal2.c                 | 106 +---
>  drivers/ufs/host/ufs-exynos.c                      |   2 +-
>  drivers/ufs/host/ufs-hisi.c                        |  50 +-
>  drivers/ufs/host/ufs-hisi.h                        |   6 -
>  drivers/ufs/host/ufs-mediatek.c                    |   2 +-
>  drivers/ufs/host/ufs-nxp-s32n7.c                   | 546 +++++++++++++++=
++++++
>  drivers/ufs/host/ufs-qcom.c                        |  44 +-
>  drivers/ufs/host/ufs-qcom.h                        |   2 -
>  drivers/ufs/host/ufs-renesas.c                     |   2 +-
>  drivers/ufs/host/ufs-rockchip.c                    |   2 +-
>  drivers/ufs/host/ufs-sprd.c                        |   2 +-
>  drivers/ufs/host/ufshcd-dwc.c                      |  86 +++-
>  drivers/ufs/host/ufshcd-dwc.h                      |  50 +-
>  drivers/ufs/host/ufshcd-pltfrm.c                   |  61 ++-
>  drivers/ufs/host/ufshcd-pltfrm.h                   |  12 +-
>  drivers/ufs/host/ufshci-dwc.h                      |   8 +
>  include/ufs/ufshcd.h                               |   2 +
>  include/ufs/unipro.h                               |  22 +
>  25 files changed, 949 insertions(+), 241 deletions(-)
> ---
> base-commit: 7e1392a42ea288d70a266f6553fe06f57f8647ea
> change-id: 20261114-b4-ufs-s32n7-b8763256eaa7
>
> Best regards,
> --
> Larisa Grigore <larisa.grigore@oss.nxp.com>
>
>
>

