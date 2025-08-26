Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A61C2FFDEA;
	Tue, 26 Aug 2025 23:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756250042; cv=none; b=eMXnBhxYZ4K5tJ2bQDjifYB60clAPTp28ej7ets+0sV6z5iTpZnimRT37rlxdqwdQuDIK72b5XDpPdEPoQiNLsX+Rb7eVQecEeF+/BFsTP4zy6OsvecaJL0zvIwGw52nB7gYiRKK0AY3QHY3c404uX434opGDevyFud3dxre2UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756250042; c=relaxed/simple;
	bh=uEBCYYiDbq0M6wu6/+ZsrGgRMhqz9f6/uMequ3aaZKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sHaFnSFj9Yacl/8O4g1vAkOPGgjOl4KEEFQuSEwEx7bbb/l1LLGlpsGBA5HPhoPK3RhDLoB289vQseZHhGo0SQHbiP7UaSdRZsUDychLRykU+CRZUh92JbJDJBoiOBmVCEVzXNtZLEURuga9UI3iStnwH1gYGTBIgyA24jb3JwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OFoWbZ/d; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OFoWbZ/d"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-71fd55c0320so2711977b3.0;
        Tue, 26 Aug 2025 16:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756250040; x=1756854840; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4Fpo+bnVLEPLNMI5Cu33Asj6pQ7wj72t3+k/d2zvlk=;
        b=OFoWbZ/dCl2mlPyRkhkCL3sh1Y7Mwwo5zZWArxLq50GcEYyhhQt6Wp9gwpcE6uqeuJ
         F+lDonUh6ZPHHNiOmGcrw9Yr3fL8r6kpaFFXXzbjG10Yr7ew0/4hWD9pr7xCQiZ7crS4
         iv2FL3N/9slaYNjFruMZFo4d1XBm/9Y5W2mDiSChws3pSm67NNQKiz949MCNQ8p90ISe
         9KklSwTFbWgZZj3rbRquoWAwASCZqeAqVyx+UnG1COeANormrUHl/BPnSZdggWAHV/uI
         9BTQMicT8xhmasMVLLWcX5OBA92BHNBIqUIGQgJkGkWh1jBtvCDawkF/aWzLL1OuNd2v
         ydwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756250040; x=1756854840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W4Fpo+bnVLEPLNMI5Cu33Asj6pQ7wj72t3+k/d2zvlk=;
        b=cQ/0YSWiAIIDeOFLupiUW7IEAbLhBFiq63JYQFkUaIh4k++cERcb1obarYHJWYXs2g
         l6a4oF46zOpuazZfGIjRjANMIKmVPmtwB5V7bOSQ8WiG9Q+AXURAvShpOEf49r0xxwUu
         WeoSbU8lCWEPqrZ4rX40pODvW0FjEEc1d4imz0Z8Y3fpSHyBtOtYSQ2q3A0kZ7i+SUWG
         vLEP80kp9jJXbK6CTRBN/lcB8rXCZhiKINPaC30fKb32Cx8n2orPkw6S8YlR1D4Pww4r
         3IpPNtuVcCGasdQFa/5RnirncMwWMhLVqXTvE6hzUJS+UvVQgic5rLHZExt5yoTac1zm
         x3Iw==
X-Forwarded-Encrypted: i=1; AJvYcCV0VSa3GchXwIKUH5AQp6AO4ocaFSxbPUmtiNh34gEy4S/uo2QPGMXESKnEkIrvsNbzisaJmtUeCmkAqg==@vger.kernel.org, AJvYcCVUE59R8ROkLfBF3syRgTG1IHvCvPrX0cWm8F4sxF92vY+uOnEuZp7iABBfHV585Sy+9/CZWqQ0/p4ZbV+0udw=@vger.kernel.org, AJvYcCXx6dB13uFH8bhE4Lz/u6yqAlwKr8SPGumk54N3UnST+Xle5q/u5SX8YI0h4mxEVltGyAH69jKbZx4b2pDy@vger.kernel.org
X-Gm-Message-State: AOJu0YwDzTWqfxx1XRwssQt8gfgICKk8VfG6BrL+XmLtIooMoZHCTt1w
	ZpGEO8fqo5V8oQGI04Q+SFDoQ7MXN18Vq+HZ7gN2CmoxQkA/eQTr2o+5H1qFkxnTehsp+Q61LLt
	0GxLPrf8Dq0dFbDw1dVhMIBVuGs/IYCE=
X-Gm-Gg: ASbGnctJoGo2K9cstXUCvigMngUgPV1HFcRPTiVgFs2/P3lgY6Lj+CDPb9eBep/piLc
	88eKCHk9uvFaA6gHyItbouLkDhoDH12EHQfdu3uYxcqGvt3f9cYBM3d+6+ap6E4UkS1hqAWdjdA
	ShK3F/XgX2WSEJj08IWw9qlKdvFxtrU5u9uMJulYF7MznCijohmG5/gQ1fP2gAC4KumTyJpD7Ve
	RUPc69mEN9L2wvN4PE=
X-Google-Smtp-Source: AGHT+IGPpTai+Exw2wSm6MraadrRYEspyiWkBZE8ZhNfLkN2VhYHtvZ1erXSLq9GjDyxjrkR49sWBbvK2c28IxztJvc=
X-Received: by 2002:a05:690c:640b:b0:71a:31cd:1848 with SMTP id
 00721157ae682-72132cd773cmr34133487b3.14.1756250039691; Tue, 26 Aug 2025
 16:13:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aJtMETERd-geyP1q@kspp> <yq1seheonya.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1seheonya.fsf@ca-mkp.ca.oracle.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 26 Aug 2025 16:13:38 -0700
X-Gm-Features: Ac12FXyZ0Scojy-Aw_qoW4SP2GXPH0SSCLu1s0QhQxjKMJ-gtu4kh9t0yVDeDaQ
Message-ID: <CABPRKS9BVsGhBDmNVbts9QhMsJ-mZhMKDB4u-NnfVcVLsfWrAg@mail.gmail.com>
Subject: Re: [PATCH][next] scsi: fc: Avoid -Wflex-array-member-not-at-end warnings
To: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: James Smart <james.smart@broadcom.com>, Justin Tee <justin.tee@broadcom.com>, 
	Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Martin and Gustavo,

Regarding the maintainers file, yes Broadcom will push a patch to update so=
on.

Regarding Gustavo=E2=80=99s patch, I think we should also update the
assignment of rdf.desc_len in lpfc_els.c like below.

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index fca81e0c7c2e..432761fb49de 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3762,7 +3762,7 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport,
uint8_t retry)
        memset(prdf, 0, cmdsize);
        prdf->rdf.fpin_cmd =3D ELS_RDF;
        prdf->rdf.desc_len =3D cpu_to_be32(sizeof(struct lpfc_els_rdf_req) =
-
-                                        sizeof(struct fc_els_rdf));
+                                        sizeof(struct fc_els_rdf_hdr));
        prdf->reg_d1.reg_desc.desc_tag =3D cpu_to_be32(ELS_DTAG_FPIN_REGIST=
ER);
        prdf->reg_d1.reg_desc.desc_len =3D cpu_to_be32(
                                FC_TLV_DESC_LENGTH_FROM_SZ(prdf->reg_d1));

Thanks,
Justin Tee
