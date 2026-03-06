Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2D3231842
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 08:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772786874; cv=pass; b=dCuKUsdOt+Xae1aipMmBMdoViT5oLjRd/QMTvRR66DyazQgCYZSUSRFxRtP8L1x7jEgkM63p8kegWVt3aWVLhx0m/byDcMRy9gJ0tAqjhFzqUv5hyPSVc0ZcOTDiSXjUX/VKvW8PFbXAM0JoSGoDQndbQW/E3mkSjhdsOp66lvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772786874; c=relaxed/simple;
	bh=ZaBQ5tkLSmw9g7b8fhNlWVbbux3qphLUl1rPCiwF2zM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=loCRAHiwsA2jtFSGjMxjQU54EUTUy2blSR2K4ZDFRilM+3uw3j34OxJGZTHp+GFejaTSx6GmbTifmdGuDOjjSCIVOasfyd97ObQsFBiUbkPaMuHnSJKkW1fYXqkH8Qkz88pUronI8yUy+29dcAnQDULeguHEUSUhBxihT+thA78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NnXx+cbb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AM17GEDn; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NnXx+cbb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AM17GEDn"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62654Shn4193518
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2026 08:47:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	X2ApZDaJcSIzT6mlxuYP1CqmneNlNHGPXDzmji4RH34=; b=NnXx+cbbq/HsKF8R
	LEVMtBHS5WQZGAhSPbl3kITrHa8CHRR/Zh9CxkCjtAp/7KLlutfy5mJKEOzpA+1t
	XmzVegaMVmw0qQmKsOXdOwjJlkCruDm4t0+c57nP1UzOzfZGDMnH2LrcWZkpyaL3
	5b1zKViUky0JLxsIMi0Jp57YiomiFtlGxXsu/G78dEpKlXItttOl9mTt+r0oE60O
	Ig9WBY2hbaNeOg+2eNiclZ+sEiiQCKG1Sfdua9RnfM+hOP6M7tsM/m8oPv2gcL3M
	t+2+GD0Pm+hl4QDXRMWhLxbMJCASiUpXgBbhD+Cew0eUYT6iPpa4IDckfFF2wYLs
	7FaiRg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqrf5rq06-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 08:47:51 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2be232ef3d3so59488752eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 00:47:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772786871; cv=none;
        d=google.com; s=arc-20240605;
        b=RXyc/D9smnOGprVki8JKwrH52o2PT+XUGMLKf66CnVjt3Va+m9hSI8YsTdh0N2FyKw
         6rU16yEU4dKtIH5RcRXj/L9qj0zOKe/6Kn9Rzg5kpkjxupg49ifW6Yua8pENt+wZsK72
         ZbPFx87aTPsR7/IbVbD9vF9zCFr9QZ+cDuOURr9R39RGmtR3NQ7bnVQxwUfNKSOj3vgR
         +6TLyG43c9Z8B9670qnfQYrHXfTjLPOf2+VVJktA0m72TZc63PJe14ULEORSEsOYzHDg
         BVDNVDVXu3zZ49QVLdsAl/wCaVWOTvsEdadBPWuTcvs2Bw99WQjcX8LjPP45KpFNfy+q
         /lQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X2ApZDaJcSIzT6mlxuYP1CqmneNlNHGPXDzmji4RH34=;
        fh=pla4xw27dw8SMBmxoVH4tPF6Sp5e4Dk+5SV0dpADtUc=;
        b=MH3OskP4AJbkI74LQ+s9BE/XnH4Od1qAXswBgHpL4iEBpPU5SfHAB39R/d+oiIgeYE
         4cEFI3eRGdwmjO8CwasmyKAtC4h3RRhKNWBXA7PQ7WkJy8cSsgx1+wcBlIewrqrkel6y
         PYVP+TOryBQTwPpOFLGIqhAVA3LP6t7rX77ofyXY8tRpfJZT25mxrbzcgxaNyy8TRfA2
         e9YwRPakNXdbQ74W2iSqD4yb3JipC3K2EQVuNAMGHq3+T9vm4sEcmo5izxWs4fUFZ/I8
         /ackzmUlitKAcDpfh8V+52Adgi46K+UIftGiINwa61MhJdRW0Pf+pbX2hJmEXsUOBdpb
         QTeA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772786871; x=1773391671; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2ApZDaJcSIzT6mlxuYP1CqmneNlNHGPXDzmji4RH34=;
        b=AM17GEDnjgW9AQdNrxY79zzhyxZdNDS6MjMAF4YEBt6iWLja55bEJPBdL9Ah0etxks
         F7V1BQX4Vp1zS9dCwVzQqHZBEOmkSn22W4pnDnNIQo901GjA59AmMziZDvmBgZK7jLZ/
         u0cXsGYSM+5QwPaMEjUGrzl0PcUPZZVOHskddyJ1acKdOKj1XIFL9xoz4GiY0NFiCwKX
         U0aS1Fs5fMEptn6eLo92XESn9gKS92Sj39XSwUvAbqqFG1dKp2MY5mO4HYE/cV8zVqSZ
         6E9UzsSXFlvPKu7l3NJJFsdAHudUq+A1Bw+5BB+cvK3KnmAi9vdy/7GCglYB4kMmSD01
         oVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772786871; x=1773391671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X2ApZDaJcSIzT6mlxuYP1CqmneNlNHGPXDzmji4RH34=;
        b=DQV3swavbap3ZaY2HUAadIEChi6r6kh+LQeF/aYACXbEW0SG6xgx9223c49u9jX0br
         O6FrZcDJDa0wUqa9PZauwNgr6en2G8sCIjylBmMQZlGfijrbRBq7ZHCrWMhrY2p5dSrG
         eo9bHAmQb68cfD1UA4p7VKQWM/dv6v4Vz/uUHoywnwRbJ+psZVK13rJ2EfdNAT43YObu
         kTVL7ezH1xZEPNFupgN2KqyNLozzHeofpw2byalHw05n3/IEkrvub7ZsKTbCsmy3LyhP
         1swOPwYNhKT1yNFXi75s8pA9aaE0dTuK4cpz9d247XZARkq+e9ye0fLwc9Xt4BBZW6h4
         iRYw==
X-Forwarded-Encrypted: i=1; AJvYcCXuHnBzrqvzhQfiWDIKDqWtrjvi1vDyOFlQHjnYJJmMx9BwYbATQaGrPBaE5b0d0IzrThgyp/t9Dapg@vger.kernel.org
X-Gm-Message-State: AOJu0Yx073Zvb2OOpIUdvJnhuJ7xbUZ9gL7k81v0AAK821ywfX0uLZC0
	absCmV/W1cCH1N6HvfvicpWD2N+0EobQqriTiuHhYc/BzY6cKX/ZRxd6QKiNFFevCDTBdz+jIKR
	Az2pkAsd8rbd05jYlf7wHDjYkzancKCcPNCxQ26FHZfh+5FMO7/hfzWQ9Fzu6GPKVEczt5cElvv
	7MlgyqTG3CDx/lVp1BzfzVvyter9Nd1B4Exdck5AqdLIgO7+Xp+Q==
X-Gm-Gg: ATEYQzw7WXXvhqNJU2OixVfHQzOU2Vwb7uADqmf3LJ8nlPvL24rwlhejcjFD/TFnIsJ
	8EPKrHiKsvoM1i1cMmLwy7B07AzNtF968B1SMsX9RP09oP2iQOqgly2DgTa7kEm80PpBUKkMeze
	1uufk0J1N13oSKVtB9PjuLoq/kk4nYL3vLql8gXG4bQnS0zOAkqKgNj/nGzAFMy6GdBgT/4/4qF
	IyI/FL6
X-Received: by 2002:a05:7301:2f95:b0:2be:1946:8579 with SMTP id 5a478bee46e88-2be4e05bca0mr561979eec.29.1772786870564;
        Fri, 06 Mar 2026 00:47:50 -0800 (PST)
X-Received: by 2002:a05:7301:2f95:b0:2be:1946:8579 with SMTP id
 5a478bee46e88-2be4e05bca0mr561960eec.29.1772786870005; Fri, 06 Mar 2026
 00:47:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260302-qcom-ice-fix-v4-0-0e65740a5dcc@oss.qualcomm.com> <20260302-qcom-ice-fix-v4-3-0e65740a5dcc@oss.qualcomm.com>
In-Reply-To: <20260302-qcom-ice-fix-v4-3-0e65740a5dcc@oss.qualcomm.com>
From: Sumit Garg <sumit.garg@oss.qualcomm.com>
Date: Fri, 6 Mar 2026 14:17:38 +0530
X-Gm-Features: AaiRm53gfCr5M3RUQ0TNbe5SUyiCFNlNVgIigtSQ2TjqBnHklxctDwimKFYR3Hc
Message-ID: <CAGptzHN=uiYoDC-LwmWcGc=bO6gYWmnr6DNiS+o0M_BS80QftQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] soc: qcom: ice: Return proper error codes from
 devm_of_qcom_ice_get() instead of NULL
To: manivannan.sadhasivam@oss.qualcomm.com
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Abel Vesa <abelvesa@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: jYiZCVfHn2HgydfUrhrqdKwqFs405A3B
X-Proofpoint-GUID: jYiZCVfHn2HgydfUrhrqdKwqFs405A3B
X-Authority-Analysis: v=2.4 cv=L+oQguT8 c=1 sm=1 tr=0 ts=69aa94b7 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=9oxdx14C3Cyt1g6qQDsA:9 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDA4MiBTYWx0ZWRfX+F6qr/6cuYl0
 1fVJFpf67CkfMOVqwUinjViGZac6HDD0aDFq/xO37xhNCKS2uMc1C3K7glUg2wHFL4dMm9VlSHQ
 XbV5MBz0PTAxHth+3fyoyCiXeMSD3GVujikAP5rCl57dH2FKqs5Yqkra2aMZ/y5R1/Nxn9y+Qjo
 t1wm/kAGCoc8KATvFyXDo15JG/7A9SgvfL40itX9e15hRx5sFa2EZxn526kgVi+nZs/0DlP2eXN
 BnRDpU0UkVL0hZgbYjWsCXOUHzTf30QDjAXlCah4t6ikGsGfqjYnwu5lvuDjIFKd/3OpWBwAvov
 eOrbIVJS2ICnYn6ks+upC9L51y3XVYuVr+ri6qtzDFr96mtpSykg0AT+uNlt9hvx1ZJSQ7HSx1p
 UJJP7/wtvLOtpuK6CkOtIf9X0Dl366C0mm6tqy8BVghV2KeRnCOANQl8nYzUC/r8T5D6XMMltZy
 TqqfKWrtsqdD/UkwpSg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_03,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060082

Hey Mani,

On Mon, Mar 2, 2026 at 6:30=E2=80=AFPM Manivannan Sadhasivam via B4 Relay
<devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org> wrote:
>
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>
> devm_of_qcom_ice_get() currently returns NULL if ICE SCM is not available
> or "qcom,ice" property is not found in DT. But this confuses the clients
> since NULL doesn't convey the reason for failure. So return proper error
> codes instead of NULL.
>
> Reported-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.=
com>
> ---
>  drivers/soc/qcom/ice.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 833d23dc7b06..d1efc676b63c 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -561,7 +561,7 @@ static struct qcom_ice *qcom_ice_create(struct device=
 *dev,
>
>         if (!qcom_scm_ice_available()) {
>                 dev_warn(dev, "ICE SCM interface not found\n");
> -               return NULL;
> +               return ERR_PTR(-EOPNOTSUPP);
>         }

With this patch-set on top of v7.0-rc2, I still see UFS probe failing
when ICE isn't supported with OP-TEE as follows:

[    5.401558] qcom-ice 1d88000.crypto: ICE SCM interface not found
[    5.419482] qcom-ice 1d88000.crypto: probe with driver qcom-ice
failed with error -95
<snip>
[   18.662977] ufshcd-qcom 1d84000.ufshc: freq-table-hz property not specif=
ied
[   18.670193] ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable
to find vdd-hba-supply regulator, assuming enabled
[   18.737665] platform 1d84000.ufshc: deferred probe pending:
ufshcd-qcom: ufshcd_pltfrm_init() failed
[   18.747141] platform 3370000.codec: deferred probe pending:
platform: wait for supplier /soc@0/pinctrl@33c0000/dmic23-data-state

Maybe it's the "qcom-ice" driver failure leading to this deferred
probe problem again.

-Sumit

>
>         engine =3D devm_kzalloc(dev, sizeof(*engine), GFP_KERNEL);
> @@ -643,7 +643,7 @@ static struct qcom_ice *of_qcom_ice_get(struct device=
 *dev)
>         struct device_node *node __free(device_node) =3D of_parse_phandle=
(dev->of_node,
>                                                                         "=
qcom,ice", 0);
>         if (!node)
> -               return NULL;
> +               return ERR_PTR(-ENODEV);
>
>         pdev =3D of_find_device_by_node(node);
>         if (!pdev) {
> @@ -696,8 +696,7 @@ static void devm_of_qcom_ice_put(struct device *dev, =
void *res)
>   * phandle via 'qcom,ice' property to an ICE DT, the ICE instance will a=
lready
>   * be created and so this function will return that instead.
>   *
> - * Return: ICE pointer on success, NULL if there is no ICE data provided=
 by the
> - * consumer or ERR_PTR() on error.
> + * Return: ICE pointer on success, ERR_PTR() on error.
>   */
>  struct qcom_ice *devm_of_qcom_ice_get(struct device *dev)
>  {
> @@ -708,7 +707,7 @@ struct qcom_ice *devm_of_qcom_ice_get(struct device *=
dev)
>                 return ERR_PTR(-ENOMEM);
>
>         ice =3D of_qcom_ice_get(dev);
> -       if (!IS_ERR_OR_NULL(ice)) {
> +       if (!IS_ERR(ice)) {
>                 *dr =3D ice;
>                 devres_add(dev, dr);
>         } else {
>
> --
> 2.51.0
>
>
