Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA17E26A0C7
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772787618; cv=pass; b=H29Ef99nIATFpQQixKqJnlvds/14okHHaok+OQoxFC2eLtkqnvgbsyUYTZ755OodffqUKHamoOdKGxtgjFXhn199Q07mLew8Fi2nwWIp2P2XPBqly5RdNCRGVRr+iW1MBYeOrV9R6G+cEYNdg5YiQvzZCSJKGUZZZsA8ing9k9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772787618; c=relaxed/simple;
	bh=0L16VWQr8QG1LSKiQzk1dxuu8pTEnzyJmWWHaNU5jqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g4gmsrYIWTpmlEnLiQpL2HgD624i5SllMY/k2+VbZkUOkqPKRNnMp/sj2xJ85KoMYjs9lQmamwqMtoE7d68xUMKDKub37FGAbEQLrBlpDkabVgh9ge7GvDUYGc9/KcPdBiotPR6O1pNpzUNWIHJSHosYXbTsrijq1XWqcLBTrfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AQXAEIyP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=URben4Zv; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AQXAEIyP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="URben4Zv"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6264a4Gk3296661
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2026 09:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Y0Q2OpTNsJNsKwES2aOblrfidPOydSd+/tsgWOvLO+k=; b=AQXAEIyPy0omLWNY
	xC5AkIZtvCyVzSjqALxnkJ5jaZOZbV5AmW9deGfMB7OCurlXwS6rhPDVV3np6dCT
	MMdSn3RHsUAs1YjrjEt/LjZYVwOvFH6y2n5m69T3BGCOiuNWwF497Yls9ayhkG4h
	LtuelBRmMz1QSQEp8CEq2nTuH6mOqTdcb5Ogo+JpJXVmVNe4Bnl8Ds2x976CwNof
	EJyRrTgo7DpmBffbcR9bt/64YS/xpNmoMo2NcTn/UP8X53T4UQR/eX1vtWbQEkcN
	LSOfF8PucvZTRYEwRqU+JYUBAmPArlJSlrd5vxmVg1MVEzCQBqqr8oq3DvKJwJPV
	hzPrlA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqpxds1qs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 09:00:15 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2be1bc0905bso4095373eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 01:00:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772787615; cv=none;
        d=google.com; s=arc-20240605;
        b=DNHV6oGe1N2RThpGxlWyUixJt74ffqy4a2cOE8o1wJRSv6Al4MASAj2jX+lbP4Uwl1
         LpooVlnlgNcfktk3ioBOZJPStLcJJKLhi046YLMc9R1o3kLusxQwBIlttHUbrfe/dLGq
         OcOODdF1riLBLT9YqnDHZiniYC+DnpvDXt4T5GPZ5KscxZ9/i8cJNVOTFYFrowVtFLLc
         7uVpMjOJSNHRnxkOI0aX3qKA1cwwNzeuBI52v3NXKOy0w7kCVlr1kYOIoAN5lNxJdOCC
         KtduwnkElEPGgC34i3gzGRPGCg2zpheqfQDVYkfZ3Zq+iOL3nMv1rntb2+AuOUSA5w7v
         QzKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y0Q2OpTNsJNsKwES2aOblrfidPOydSd+/tsgWOvLO+k=;
        fh=ALRy19YpI01IEnmFmVX1UvWAhA+RtVJG1d+gaRrQOXU=;
        b=d3qyILUmqT8nn6M4h+k00Ln7ya5GAg0jdvv5tvjBe6zT7nshHR129JWAwLsLC3PEQc
         UcZjDv2LT3w7vItt8t/I5RcpdiiROOORv5JDwm7eYEY8lanKiy0RiNNl6fcR+pvQp2xJ
         piyos3YhUACPHymzxJN/PjPVFzm/ki5/S2Fz+NdPZl1gkKufosnA9t/WV8Ajt+K+a5by
         z4vgniKryKIYeGK3TILzAGmYoGBwu7IgTq1oZRtNrUaeT9lZpk+pzapzgIXPWViAuC/v
         M3PN7sJnmsm6J9aIOiVH+oVCm5W6XVs3B2s8/dh2q5AoO046hTofv68NK4xfAGPRhCVk
         xQow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772787615; x=1773392415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0Q2OpTNsJNsKwES2aOblrfidPOydSd+/tsgWOvLO+k=;
        b=URben4ZvgK/XK6SdXj/KFdReI25zCzLMo4LJf7lfGAhBEI/UpMgMcjs+Dh/E536SOm
         m5T+9EPoif2VEMLvnS85Wtg2mq40j3MhmYLC/6PNhqoKV7/j6RwwaNfmrYdrG2FxQEgL
         JTB4C8inHjayDZ5W1eU2d5O4cuah7udvupB1eQXKSr1x8/nDSlUsBmp8Du3Y2plwLisG
         8/+QjAbxRsU/Fm1pniopmKwhGi/Pxq1onmh05yAjUN+ZiHXFZXRCu0oqHRrNl5X+be/S
         mlSwoPz5aUNq79vTcQUHWAyjSOl/FHoKMY8XlpuWVSPf+XteWoOjKMzB87JisiDG52M6
         GdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772787615; x=1773392415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y0Q2OpTNsJNsKwES2aOblrfidPOydSd+/tsgWOvLO+k=;
        b=JT9ToWeDQ0GQSMq42L4yOzYeDcFsUtl7uP8FU62JSUWO4emOSuhEtCc7QG2GHJyOr7
         G/xwvJNT03W4qOseSaTwlWBvWno5x4SVuv3UVUyQI1qSn/Ja8YEo/KkGKJqeR3ieradC
         V4rPPxUFmihmmn0bZNAok2KrGALHA22RHA9pwUCu6IPLxOxt9nhpOnCytYVMY/oXMLzk
         WtcgloEcjG+sxM7DOgPzKMN/qkyfns+F5Ln0MI7FEpl7jK3zz6DtaEYSZcMZvr91z32g
         XhHZzGxPpeaSkIGzU1mjKUt14JfKsgLAtcXqpcxWSSf2v5rspLUtRDv0UK/ZoOPfqtmP
         3MPw==
X-Forwarded-Encrypted: i=1; AJvYcCWHn+8Ca5SpYz5LGMlB9KpXtGxFuuSHmuJL9cUcHykNb0scA3vte+TQPX4FRL3JFcjaw6300Vn3Br7c@vger.kernel.org
X-Gm-Message-State: AOJu0Ywuy53DkW/+j3GZXgrCNzauHLsyiPeVljKmDD1t+yvRvuCi3bqr
	iSBAi+D4mIROtjNHjHniQzaEJwEPZGrzFme5p4EiIWle86KVfOSs3XeXgjCt6dxy6ZFRHOHT9Ss
	WsRTJi1RkPWlS90qxRuveJW3phBDKqkDIwwDJgso3WHPYli3hsAAQ7B5jGQUSlywXcBOzJ3mLHf
	9LzPBaQbfGDV7+XI/ip3kDgpDssHWCkGjHaRh2g24=
X-Gm-Gg: ATEYQzxELKkPdNIWpoq+8qdHdHO2jXbXyectVMuyHJRshaE6tkhgCqYPBPeHtPLTDX8
	oPOOysEeceyeSUlce9TJMnDX0XmtrEDOyxbgxO3Y9VmUMJRkRI/cx2wxRRddewXIITzWGm+wVrt
	wNdOAJM4M96mYL6lMKCnn4oXYLJCPcq4i49pv8sXe93n25Pxw2QoEZMBH/U6SfqDoK1Jo2hdgMs
	Gi8F2bY
X-Received: by 2002:a05:7301:1296:b0:2ba:7b63:3f4f with SMTP id 5a478bee46e88-2be4dfc5efemr474945eec.15.1772787614559;
        Fri, 06 Mar 2026 01:00:14 -0800 (PST)
X-Received: by 2002:a05:7301:1296:b0:2ba:7b63:3f4f with SMTP id
 5a478bee46e88-2be4dfc5efemr474918eec.15.1772787613896; Fri, 06 Mar 2026
 01:00:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260302-qcom-ice-fix-v4-0-0e65740a5dcc@oss.qualcomm.com>
 <20260302-qcom-ice-fix-v4-3-0e65740a5dcc@oss.qualcomm.com> <CAGptzHN=uiYoDC-LwmWcGc=bO6gYWmnr6DNiS+o0M_BS80QftQ@mail.gmail.com>
In-Reply-To: <CAGptzHN=uiYoDC-LwmWcGc=bO6gYWmnr6DNiS+o0M_BS80QftQ@mail.gmail.com>
From: Sumit Garg <sumit.garg@oss.qualcomm.com>
Date: Fri, 6 Mar 2026 14:30:02 +0530
X-Gm-Features: AaiRm506ir4AC8l0C0Le9ozBvSlNRLBgtgndnExCGvFEbKvlm59knOgNeJByd-c
Message-ID: <CAGptzHO+cXBib_cpD+GvM8riKVSKMF_1Y3DUJO6KL7HcM__mJg@mail.gmail.com>
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
X-Proofpoint-ORIG-GUID: -RF8T6aj47tVbtB14GcOj2WchZu5D3mo
X-Authority-Analysis: v=2.4 cv=E83AZKdl c=1 sm=1 tr=0 ts=69aa979f cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8
 a=FoKZgoKw912WVnOwPkcA:9 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDA4NSBTYWx0ZWRfX3ed5UPBfEORi
 00MhpxvHPhe5cxQxVhudkqaKHcpsvcS+UW6IXZ7Ean/iXnBE4mdR40sUByhsr04twoGMfXsB/Oq
 sBlGUaIbJEJzaKpwMJp173NP/L6T9J0P3eUDDRfub+s36Mak3dfc4kaUgs17wmJ+jekkMDm8n97
 /9gOFHpXZyeoHSam4NlBB9S6uVi1+z/2DSDEi1bFPB1hlsSL861EDBBawIfy8a6mc/gAUhRiYXP
 kJ4F7qntZAJxIWL2plPv011yjoxCJqmROy2ZWG4ybJoFJAXoE0qZSXh/4aEt59X2RR1XbI2UlnC
 ZkCJS5TSIPQkfBWXeAHuIcJFLTQZ1ry5vnb7KymeiJRzLQ16alHiGbcFBSkMPqMDIUUo+LVecmY
 IoNO9UM+y+yTswTd1E0xdmWmw2FUb08DZ7o1koAWfHQ6Eq1cg5GuTmn4vbcCVsya6l9ewOe8lrH
 1IN9PntTL+Chs+7KUZg==
X-Proofpoint-GUID: -RF8T6aj47tVbtB14GcOj2WchZu5D3mo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_03,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060085

On Fri, Mar 6, 2026 at 2:17=E2=80=AFPM Sumit Garg <sumit.garg@oss.qualcomm.=
com> wrote:
>
> Hey Mani,
>
> On Mon, Mar 2, 2026 at 6:30=E2=80=AFPM Manivannan Sadhasivam via B4 Relay
> <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org> wrote:
> >
> > From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> >
> > devm_of_qcom_ice_get() currently returns NULL if ICE SCM is not availab=
le
> > or "qcom,ice" property is not found in DT. But this confuses the client=
s
> > since NULL doesn't convey the reason for failure. So return proper erro=
r
> > codes instead of NULL.
> >
> > Reported-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> > Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcom=
m.com>
> > ---
> >  drivers/soc/qcom/ice.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> > index 833d23dc7b06..d1efc676b63c 100644
> > --- a/drivers/soc/qcom/ice.c
> > +++ b/drivers/soc/qcom/ice.c
> > @@ -561,7 +561,7 @@ static struct qcom_ice *qcom_ice_create(struct devi=
ce *dev,
> >
> >         if (!qcom_scm_ice_available()) {
> >                 dev_warn(dev, "ICE SCM interface not found\n");
> > -               return NULL;
> > +               return ERR_PTR(-EOPNOTSUPP);
> >         }
>
> With this patch-set on top of v7.0-rc2, I still see UFS probe failing
> when ICE isn't supported with OP-TEE as follows:
>
> [    5.401558] qcom-ice 1d88000.crypto: ICE SCM interface not found
> [    5.419482] qcom-ice 1d88000.crypto: probe with driver qcom-ice
> failed with error -95
> <snip>
> [   18.662977] ufshcd-qcom 1d84000.ufshc: freq-table-hz property not spec=
ified
> [   18.670193] ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable
> to find vdd-hba-supply regulator, assuming enabled
> [   18.737665] platform 1d84000.ufshc: deferred probe pending:
> ufshcd-qcom: ufshcd_pltfrm_init() failed
> [   18.747141] platform 3370000.codec: deferred probe pending:
> platform: wait for supplier /soc@0/pinctrl@33c0000/dmic23-data-state
>
> Maybe it's the "qcom-ice" driver failure leading to this deferred
> probe problem again.
>

Following diff on top of your patchset allows the UFS driver to probe
successfully without ICE support. I suppose just setting the drvdata
should be sufficient.

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index d1efc676b63c..a86980647097 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -734,12 +734,6 @@ static int qcom_ice_probe(struct platform_device *pdev=
)
        }

        engine =3D qcom_ice_create(&pdev->dev, base);
-       if (IS_ERR(engine)) {
-               /* Store the error pointer for devm_of_qcom_ice_get() */
-               platform_set_drvdata(pdev, engine);
-               return PTR_ERR(engine);
-       }
-
        platform_set_drvdata(pdev, engine);

-Sumit

>
> >
> >         engine =3D devm_kzalloc(dev, sizeof(*engine), GFP_KERNEL);
> > @@ -643,7 +643,7 @@ static struct qcom_ice *of_qcom_ice_get(struct devi=
ce *dev)
> >         struct device_node *node __free(device_node) =3D of_parse_phand=
le(dev->of_node,
> >                                                                        =
 "qcom,ice", 0);
> >         if (!node)
> > -               return NULL;
> > +               return ERR_PTR(-ENODEV);
> >
> >         pdev =3D of_find_device_by_node(node);
> >         if (!pdev) {
> > @@ -696,8 +696,7 @@ static void devm_of_qcom_ice_put(struct device *dev=
, void *res)
> >   * phandle via 'qcom,ice' property to an ICE DT, the ICE instance will=
 already
> >   * be created and so this function will return that instead.
> >   *
> > - * Return: ICE pointer on success, NULL if there is no ICE data provid=
ed by the
> > - * consumer or ERR_PTR() on error.
> > + * Return: ICE pointer on success, ERR_PTR() on error.
> >   */
> >  struct qcom_ice *devm_of_qcom_ice_get(struct device *dev)
> >  {
> > @@ -708,7 +707,7 @@ struct qcom_ice *devm_of_qcom_ice_get(struct device=
 *dev)
> >                 return ERR_PTR(-ENOMEM);
> >
> >         ice =3D of_qcom_ice_get(dev);
> > -       if (!IS_ERR_OR_NULL(ice)) {
> > +       if (!IS_ERR(ice)) {
> >                 *dr =3D ice;
> >                 devres_add(dev, dr);
> >         } else {
> >
> > --
> > 2.51.0
> >
> >
