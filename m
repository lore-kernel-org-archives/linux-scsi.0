Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59E928B7DB
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 17:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779470869; cv=none; b=PucmDthvgcbg9C6i0aurc4fJBnotTyXWtG1L0WrYA7VrldWR5JRDLD5UV+m39vfny/quV/oS8Q2C24FHyy2OWpVBasWa02TwkzsT3WSprurry++Cj+gF36ASoXZsyXLwwSSxGkdlu84ONUVYxOcpxS/12Zc8GT05UU056Duo158=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779470869; c=relaxed/simple;
	bh=VNEhOKBhobQqQsoEuqNm9mT3JANz2GEoOzRTHnEsEfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SfJnSNIhe5dan5bfwMvqufkd0+VjWqWEt9aWa6yAworenE/JTlNCjjbX49FBlE6OOykTcaPTvSYc8uXHKFnNUMzLX7DucF6hzu1qAxmlrWDOwyc2k4Z4ml0bg5ofKRWcVmGvGJo+Tc4jl57mjLfSP53TtpYkuzQeTX6AuCghduY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eTRw7Ils; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aKuvOF8E; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eTRw7Ils";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aKuvOF8E"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MBODhi1298044
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 17:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=lqhBDm7fYqu
	6MvZpBtGOglNbnbUjw4oExZ0wnZT6Ids=; b=eTRw7IlsnPnTflsXgUIXt9mJ1aS
	VMQ+9LlouPD7KBhhgzaT9XHekdEG2oNxzRq9OfdrNhgYaIO2dwOwfTb4iN2t+lZx
	cIVCq8iTBkWOxzczU7X3o4yo/2AK0XiFYDAS/zcG1+OsvEaMfII7aWIc/4bCKEmO
	nJd8aEGmJiCFGINhP5wb/4IHePvPDlwb3mXIrwf7Xad8PwwtQMA60LcnBlRBe58T
	ZzBAJNKxYrvv9W2YV6PGgofF8qRSxUnaDWDOwBJVEWhg6JRFV96+4OLf7iOuOYFE
	4oSDp0J0CbWWNuln1VNR9p8QMzJFUZlcAqgOgELrbMT0yJYrSSLut+Wx7+Q==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eaah0c6ng-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 17:27:46 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-837c4eb3bdfso4593651b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 10:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779470866; x=1780075666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lqhBDm7fYqu6MvZpBtGOglNbnbUjw4oExZ0wnZT6Ids=;
        b=aKuvOF8Et889WJBJ89gW/6eB0ydhWlUB6S+h3fMb7mipqdr45xGhmTgsyhajesYhHV
         VVxJcp01vwAr5ZOeqKVpg3UYzfQM/uAY3UXwrS1XU2ks8EN+6IpjEA54JdeK7KzttVZb
         Ws6CxnirdqQzNfyPdjvQnD+UdPyb3xjXwwyU2wzMAA8tXHjL63Uv07ybZ0RFV7B9x6wp
         iSJnyCwkAMTAqZd8lY+Xu2c5TAZBb2Bzw/Qg89wOhcKwee9hgYfNfYVWJHUnGJvK+WbB
         7cPHsbXXTJ0+MBjRB9VAn9QksK82EWzmDKwrLvQLZ2WDPF0LapZNEAP3IhdPjFjxjDAW
         sF+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779470866; x=1780075666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lqhBDm7fYqu6MvZpBtGOglNbnbUjw4oExZ0wnZT6Ids=;
        b=ItCpkiXs95l1b9YbIkiGAA4DCqASTA0DL618+jq2WXDvCHw0MsNZieQvkj9KgRy+KA
         f8bLvF7LzsRzrZadeKRIX8u4eZyZqxtYC1DU+efETYtdexihXQ2miXmuNKdPdC+wgV9n
         aj0W7Bb9zv6eSc5JgEoDjCeHC2w10PoxK7irS9jyQFFMNVngUyNx0TIGRa4QjSoNsgLc
         Cs5HsPBItPXvKNDj1u1WxV1nKpz/CX1QPw+s1eCrgYssSeykthpfiy+NIPyQkqkQaSAm
         FKsuagj+hFhsaxAluYusT+w1gImdBeP6DUL/UzSXWPda5coQaMBYvt+tXNUlaXdrG5uP
         qIxg==
X-Forwarded-Encrypted: i=1; AFNElJ+bofB1PdZBJlZnukz3DnUxFhowoahCcmsyb8iISeSgCn9KhsT+2qn7sDsluDO0KZtSJvKWNRLBGSGX@vger.kernel.org
X-Gm-Message-State: AOJu0YyAtjQQuWFTAKjLDoaSudAQEhPeGlS/VbkIkn/w81nHqbqoA1FI
	/b03qdkJBS8jIcNlj6aLNS8lSgLNW60GImTAOauMpIizLPkeTKtbs7AumUA0bKKs6l2tPixFdca
	5Yk9JIO8PWK3MWaX7hmsocO72FzUoGwt0aTqpxgSpdG83IElJUvydyETzm3M/QH+D
X-Gm-Gg: Acq92OHkTWfVDtK2IoQpawgBUymEFO+ucf2u8eqXLUHkTc3IQWJEh3JdV59iNRq8GMD
	GA7uuQtVR5d5VsmOisgHnn3QZm0bGnj1vT4KWgPCpI/zP3Cl/445akkFAP7xSB9c5U78hHu+NrW
	vffSFHzV5Lt7Fz0vrTFUt52Cr1Ll+86J7eSIwek5EYOd0ABmA6mTlDcQ/+YTjeG1j0TV6ynBaGI
	dY09MWICfycGvaZiqoO5R+1VMp0IlFCqgJDwTG75hwBkSjX0bxh0nm13XxJIXWnCaxQTBwCo+YV
	fb3R8mtUd4Y5oGX5m37o9C36OZpHiMIH+sPk79WaJtz8hJvW+1mkP9r76HeIUfIHQjbyGw7FUHh
	nnnwJ1RjZdxXkwGo4ieablu6ji+5K3s6av3NJIsDtOS+ZPrsyMYL+0Q==
X-Received: by 2002:a05:6a00:421a:b0:82c:249e:a85b with SMTP id d2e1a72fcca58-8415f155bc1mr4845093b3a.13.1779470866323;
        Fri, 22 May 2026 10:27:46 -0700 (PDT)
X-Received: by 2002:a05:6a00:421a:b0:82c:249e:a85b with SMTP id d2e1a72fcca58-8415f155bc1mr4845068b3a.13.1779470865852;
        Fri, 22 May 2026 10:27:45 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164ea09a9sm3045693b3a.31.2026.05.22.10.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 10:27:44 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V2 2/3] scsi: ufs: qcom :dt-bindings: Document the Hawi UFS controller
Date: Fri, 22 May 2026 22:57:15 +0530
Message-Id: <20260522172716.820490-3-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260522172716.820490-1-palash.kambar@oss.qualcomm.com>
References: <20260522172716.820490-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDE3NCBTYWx0ZWRfXxPNG2gW9B+Ih
 /4UPL/feptPUeSIMMVDVhbWJl6yLfeLbMgaHTzYM1br/Ic7CPJglnqkAhVF0pAJQNmjATfWpLMU
 vByFFpD5nwnE1RpfGp8BoWkd0YXmsrN2NSiDpfs6qgSKv/xd+Vsdbesy3nNEmKHYmKgVzoUndqX
 v+vW+L3YXrmplL/5w/js2XYISoWeO7iOj1AGW7yOFkRPuEdO7JEmDsjYQUdOH0X97IpF4XwJFf3
 dOR3/M223H8FqywDgEalqcREwFZ5L9OCUM4XzJCNU/p9N/W0XQzr30ocLKkDSEZQZvlObbpk1ZP
 JtsZMrTaq/khWzFYxwewzPsgNvkPG+fie78pUk5YF+/wfJ8wGQts0n5kY/680QfF3edbO1LQKhH
 0m5d8vboJFoAgnb5+qe5UZnqOrfx1AUUlVMNoOJaAmsTsJUHF7tchIpAF+OXHMPxub+yNUPtB75
 JYCTH8cpSa+j1Yz5TOQ==
X-Proofpoint-GUID: R_Tb9N6BK09WuD0knzuZhkRz_P79SHtL
X-Authority-Analysis: v=2.4 cv=LNdWhpW9 c=1 sm=1 tr=0 ts=6a109212 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=dkR0I6OD3irOzcp_LXMA:9 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: R_Tb9N6BK09WuD0knzuZhkRz_P79SHtL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_04,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220174

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

Document the UFS Controller on the Hawi Platform.

Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
index f28641c6e68f..3de00affa4c6 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
@@ -16,6 +16,7 @@ select:
       contains:
         enum:
           - qcom,eliza-ufshc
+          - qcom,hawi-ufshc
           - qcom,kaanapali-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
@@ -27,6 +28,7 @@ properties:
     items:
       - enum:
           - qcom,eliza-ufshc
+          - qcom,hawi-ufshc
           - qcom,kaanapali-ufshc
           - qcom,sm8650-ufshc
           - qcom,sm8750-ufshc
-- 
2.34.1

