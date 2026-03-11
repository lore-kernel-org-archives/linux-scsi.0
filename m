Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AB23CEBA3
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 10:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224831; cv=none; b=vAoH2Jxt9gGoPEQvOEb88u75kZdev2cc7LlYr7RAyHiI0CYsegTSCM0Sk5KFsxIwNqk9QiRNC2Umi9a2ip78dIqrCgSTImL31LO/3pp0X7Fhvds9v05k2JsvH7dQzz9REIJL6NvHDibQQ7Io0LYu9wN7JxCth/34K1gv0uhsuzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224831; c=relaxed/simple;
	bh=MEWJHGeeC6PpNHKqe4NMQXI8Kni0IbPXM+j6vE6Kjuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBCSoArdfV6LJEYdcIhc8AvAeEx2DU88W9/qpT7Szo05ej0FG0tbTnFD1KfnXiB70FYT2Jz/m2DS8p41e0ghw56c+RofyJRoux5XIOSGaXAShI8CKo8AEe4j0Xuoo5eXfDWSXDxbJFCEVihcznRedf3R9oAPjYEAl5FmVacMq+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=g/SmGQ56; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dKVRLYgv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="g/SmGQ56";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dKVRLYgv"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B7Q8wB2030909
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 10:27:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=99wJ4r5T/iMLg2Wt3IqUifMJ
	Jodj7jWILseLGYBjBVM=; b=g/SmGQ56c+eO5r6PcNWOsybrEGwXl2KMFtkZml48
	tyz3HK1eSyqmUl60my2jYN6WUZSyb+XdKr3hE53qgy2O+qE4PAjPMMflJidLderD
	zTBvAXs2w5hteSyazwAe31RLzSHPmfJBFIaAi9heLfjEVum/dZqtrg+qtFSFLLNV
	udCeBqYwouCx1gDKYP3YUwsjcXsxELB5gGsPCPqEg0RFGl8ih96569DSoicZJwrm
	Tg8wwrZfSDHq83Gg1HwWogWh/fVEB5BTj2zFrlflQ5EnllairdBES9R0A+E6xHvl
	gTQyc3Rg8F1aBZI5ZjFC9GQ2F0CaZ4qMWFXLWaCQUWXp5A==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cu40h0qsy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 10:27:09 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cd858e8709so3158225585a.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 03:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773224827; x=1773829627; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=99wJ4r5T/iMLg2Wt3IqUifMJJodj7jWILseLGYBjBVM=;
        b=dKVRLYgverLLzWDIMTogbOQgSdJjlSbKJ8thx5PJNqfNRXlujSLf91U5tmGfdzOIgM
         TQEYPxdgZZ2TRZlkVs0qNWd5BFPe0BcLvToRP9Bkka8NASooWWokzW0PR1wwy57Ma4pB
         9xDrrOJJF4jPVQ8TJQr+vbjEyqQMPxV5hNBVL5pRIfSdTxnD522/SyXK2llIyoPfjwDC
         c0d+cDbklENXJm0wNy6K444wp82gCa1Ho0K0iVE3HXbqEO1E2196l2XGw6+afYfnH2Vv
         xOd6RHEMMi8/wuvk1+JxIU85n+aIaeZo8IIJ9doPLJpTXb9MHVX8z2ZeSVf8UgzEAeZY
         kKZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224827; x=1773829627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99wJ4r5T/iMLg2Wt3IqUifMJJodj7jWILseLGYBjBVM=;
        b=HiLXYnK1Nb+0mqXsZnoZA/hpg3nUx8MXBfQMwu9tBvW2MsMViJVbcddhz/CBXZGfBD
         ebVk6zhfO5uLQUap0NWSdVNjVmdo6dnqFR+bDtJrfTxQPnRhZksz49Da295TP4gRTjc5
         zkNs9RrCWiFSPf8kgwQejHfGFxDXVyXY80HFEy2MOK1DaSgQ1Ja212Pmk3UAVdHANAL/
         vca/wp1kFwgvFW+z6ZXtoGof9yJ7bkkCMAv/Fem5Y1SoKBlS/ezzWJO51v6Hr2Is7Mj9
         L/1IgN0tRxQ64etTuIaroUriQETHN3Yhj2P1wcoFPDJBjTxzWfa9DKhyhTs2ioy3bebq
         r+qQ==
X-Forwarded-Encrypted: i=1; AJvYcCViBGIAkvPgaCLAs0WV2W+x9uvlTZxBZPTK/9p9cdWAIbqaYWOzJjclQ/zcWnak4SrLzlwhY5cr/iWE@vger.kernel.org
X-Gm-Message-State: AOJu0YwLQ9JyYAG/hf9LLB1m8/xXBQn3JBWdKA2H0WzyPH0jPNDfIhRX
	39X4mXax2R0F/qku26Emgi0AJ25s427r9pBOvWH3jwnIPPaMcx7gBHnY9SgBEgE4gtJFg9P1k35
	bFQHV4+BjsNZQb23zhzn/JKtjXNgZnRKDf4renKfD+DLMCe3iKA3UM2qZjWKWM1wT
X-Gm-Gg: ATEYQzxVqmZpBCD4tRLSbyCXo3AXUq8IpnvlNRu8YCljjqOBdtzt132wd2UpmvoGZjt
	vW9l4QHgMXixHxXs75C+XXl4Uz/dhoCsC6T3bYNaqPcxbfCKU0wrwWwyYg67hyd5ojYszjBdxKA
	fMlHhioMpwdk5rCna/b5i3Hr9Y2A9KRk4emM4rCsPeCwU0WXOjx2hG2GmWCjVTjyuL+bosk6rdo
	HjNt0kSJJizI58rCE4+dT7BwCs+MFDU1qyfEX/AbrVSjRcsEwaGFGpQq7DOLQXsO10OUa24ETBe
	nzRCKY4JTI0u8Iuv+p9w2/Fz6DPi1Vugputf7E8PdGAITs/dgrsb9UiRnvWyxSZQbk1RM638GtF
	96N8yKLQTXZBzw6Bs7lpw9gaoRKx8Y3NF9XKV
X-Received: by 2002:a05:620a:1720:b0:8cd:8e8c:2087 with SMTP id af79cd13be357-8cda19b9991mr241104485a.7.1773224827301;
        Wed, 11 Mar 2026 03:27:07 -0700 (PDT)
X-Received: by 2002:a05:620a:1720:b0:8cd:8e8c:2087 with SMTP id af79cd13be357-8cda19b9991mr241101285a.7.1773224826727;
        Wed, 11 Mar 2026 03:27:06 -0700 (PDT)
Received: from oss.qualcomm.com ([86.121.162.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439f818d5eesm6660916f8f.1.2026.03.11.03.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 03:27:05 -0700 (PDT)
Date: Wed, 11 Mar 2026 12:27:03 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: qcom: dt-bindings: Document the Eliza UFS
 controller
Message-ID: <3udticxb5sodqsjnolzpwwaajsmp5ugvhpxn6pl6jjyjyc5ygo@izze4ccdhyc4>
References: <20260310-eliza-bindings-ufs-v2-1-1fe14fc9009c@oss.qualcomm.com>
 <20260311-radical-bold-catfish-d7ccca@quoll>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-radical-bold-catfish-d7ccca@quoll>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA4NyBTYWx0ZWRfXwY8MjzELDxjW
 Hwn2BNuUabd2U24vHJr7tQ/vupllWOyZniabgN9fAj5NclYN3p4lFmrA1kmGV/loQ2Hmz5vlcrz
 SbO7NAyY/ZG+semy59gHQYWqMvggWBuEg/nNoKpkrZ1mCBYBhmYKyxytW8eppYILt9Uh2/0PQK6
 20hKeJn3LSQSWJv7ffhCG2bDw1YDYGJW1FoiJnjm9cShf4PLhm8j/3VC9AFlGzr2u95w5Kh2Mja
 AP7xSKyDCJj/teI34DWRMduUuoK5f5jkUY8qkFmulA9EK+ZW/r3DbHYhTZqEBAJpMrpsA2cGjcW
 vUHcAnlU9l/nI1YT1nj3vvMrFE9yA9jMSE9QVo6f57z0iU/uIOjxXHXKz+Oq5atBUGFlUNmYTt/
 ZUl367bANcsExOJfoIk0+ZnyCdUZMFiytICPkQWbbdnFNQp8Gxyljb+1hVsimp2iD3FWqDTddGQ
 7EkeW5vEGnKbVGmGAQQ==
X-Proofpoint-ORIG-GUID: nnU598lb5KjLmuHAXtzW2NGV9oCIPHAA
X-Authority-Analysis: v=2.4 cv=YJ+SCBGx c=1 sm=1 tr=0 ts=69b1437d cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=oauzzCmhM186DRC0Y2yWPg==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=Zn_5qlUWoac-AIgVFFMA:9 a=CjuIK1q_8ugA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: nnU598lb5KjLmuHAXtzW2NGV9oCIPHAA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603110087

On 26-03-11 09:33:03, Krzysztof Kozlowski wrote:
> On Tue, Mar 10, 2026 at 12:44:42PM +0200, Abel Vesa wrote:
> > Document the UFS Controller on the Eliza Platform.
> > 
> > The IP block version here is 6.0.0, exactly the same as on SM8650.
> > 
> > Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> > ---
> > Changes in v2:
> > - Rebased on next-20260309.
> > - Mentioned the IP revision, as Manivannan requested.
> > - Link to v1: https://patch.msgid.link/20260223-eliza-bindings-ufs-v1-1-c4059596337f@oss.qualcomm.com
> > ---
> >  Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> > index cea84ab2204f..80550144f932 100644
> > --- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> > +++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> > @@ -15,6 +15,7 @@ select:
> >      compatible:
> >        contains:
> >          enum:
> > +          - qcom,eliza-ufshc
> >            - qcom,kaanapali-ufshc
> >            - qcom,sm8650-ufshc
> >            - qcom,sm8750-ufshc
> > @@ -25,6 +26,7 @@ properties:
> >    compatible:
> >      items:
> >        - enum:
> > +          - qcom,eliza-ufshc
> >            - qcom,kaanapali-ufshc
> >            - qcom,sm8650-ufshc
> >            - qcom,sm8750-ufshc
> 
> You need constraints for minItems: 2 for reg and reg-names. MCQ is
> required. The mistake was doone for Kaanapali, but that patch was
> applied without review, so it is not a correct example to base on.

OK, so something like the following then ?

@@ -68,6 +68,18 @@ required:

 allOf:
   - $ref: qcom,ufs-common.yaml
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,eliza-ufshc
+    then:
+      properties:
+        reg:
+          minItems: 2
+        reg-names:
+          minItems: 2

