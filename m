Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608B94949E7
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 16:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779123246; cv=none; b=UIRnK7kNbVcXWNKyLfqCa/OzVQVzOpbZjv5g6hC7mb6gKIQfKeRmHzjemc/ipgmIFHjk/hmTn5ncssjiuB6YQD92gZZjTfwLWaMItuCbmfp4OQ5ZLGP87Y1pIFeAtjgOq8vB9Guhpwd2pS66pXGEskT6yC60V2/uVe7HdEoOY9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779123246; c=relaxed/simple;
	bh=ClDDjyUl4SKlH9uEahuXtDhQEAFlq8qG/UeEokcx5uo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a/RUeb4Zyrd3gFEEfcbDF0u3AAHQzipCTbSv2SPiRbuVCSaR3R8uaBRmuABjEd78tvfgKl409rVXJity+XNViPmi8I65mlgYWPJkgEwB3LnJsM/EArRVrzI1LtABoW/Fgvax0T3ShHUPx08XqU7vGSeolzoEYfnNkv6dbodxGj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jlf6SxZv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SFrIi5qx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jlf6SxZv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SFrIi5qx"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IE6Ulh353070
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 16:54:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=QsRIgQLI2Vx
	jSQE2G7J2CVT4oRZL8O7+2aFEOMgl1AI=; b=jlf6SxZvDkUjLbUlYWpqN9ECRy2
	1TGxM75oOz9LiqLeJoWb9CbgFhmRzX1pWc8om4HJe3Z/S/XVrEi0LFqdI97mCI07
	Yi8DL77Ba33eIJ4PEBXAz5JwlkWOfmcV6Zuxd2s1TdZBi1nlqaxWPfLUE7/ye18G
	cumjE5bpEiu0iAOZZPrRdKFd8Ww+9kINVFucLybXsVM81qvgDC2SWksWXcqYq96w
	BSCmskxaYfvF7OC/QELhjYbBszkkUGwMi4bhD1sJ7839UqSw4agv9thI/imC4ySJ
	dwhaquucbhB6TEixTO6obuW3sjY8j+63iYIwrMC+5a4VzOz1VOUE7bL5qvw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e7xjaj796-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 16:54:04 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2bd6cc53fd6so26096825ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 09:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779123243; x=1779728043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QsRIgQLI2VxjSQE2G7J2CVT4oRZL8O7+2aFEOMgl1AI=;
        b=SFrIi5qxkeibayzfg9Asu3hYe6ni2NgiKTxHUlI4nBxPUpgACuuI5jixLs5oztw6GM
         xdhtuMsK9gocefNoJqs53MKsUeZUVk2UIPfrCHHj44YaTo/E60fj7QRn8A0LGzF0ha9v
         +W8GI5eeG0H9iy2kR7FPvVs3hziiGV1hfoTjvIZi+ap7p8B1mHb50x69Zdsowd3/I8Ng
         IpSLFJpKXo/FclqP+nCn+oQDBCq0njcjnieOrnxpW6oPhFeLJ3pPogI675pUcOdmTxta
         zxrzvMWcesDWHG7ixbiml9QNIl6VDDXXZTOnqr6ofF7+EXOyU2kcEAfnvNuMFy04Zpth
         x5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779123243; x=1779728043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QsRIgQLI2VxjSQE2G7J2CVT4oRZL8O7+2aFEOMgl1AI=;
        b=djLynBsYA2Ss4NhgNhN4+UehMnFtvyMOMDEUtFW5/4zLQWbfEOprHK31fyuFt/oIq+
         JdFjZtMFSWQUEVzSgC7hJeVXr/lL1jobBEJljDja1hkFCKiI1DJxGM2MCxE3N5ap4bPa
         6BhN9zQOuobIQhBoI4XkjmCrnl24ZsVuxVLyb+cEq6S98J0AfSAqapPX7MW8WKH6p4Y7
         DvEeZudRWF9p7h9WirKjJXQ2MJkA8yO3ObUv5kzB5dTQbjyCWFNi+EslkHkG215bi2I2
         89rilNFSC6TzjyLBJYHY+MiT7FSCpqojI3PhlqqNO7q9o6m/rgehe/GwNPxbszYp0HdJ
         qxOQ==
X-Forwarded-Encrypted: i=1; AFNElJ9nxLES/zvIBxa7PfRjahL4md0YJGBeSrXhUXqXuRBxirPwdKXwMWoYrkYPGeW+sVQPSsaLuTN08To0@vger.kernel.org
X-Gm-Message-State: AOJu0YzDe0Nn16++XXpQNBwY6wrUGvDM+FCVTxyuBgneOrBczLtq09tt
	LEpEVYgpjifLMDCMLV77y+GLPaRReYVkjSEOXlNhs5Fp3ZvysDYQev9hC/AD5jmJ5G77QdubhOi
	BaZFffJ5J0anSqB7Vr3K9XCN1nCT5IxBDzA65QRyz6SyIORIygd6klDnE/HnJ2zMl
X-Gm-Gg: Acq92OExHh6LcswCwQQb/Z/yb7wl8u5MfVDJXx/Sytv9OiXsF9n381GLbKPlE1x30/b
	c+T6+Mgbv2VX24VpzZ/Uko2hyrhk340kG2N4f4oYvY+FCDunVO8GqLhZ9R7oLl3SafEkr+ikA5C
	EYU0ykH70da+/SYEtpqv3M975amcHo2Cyz7rzuRu2bqVClaLto4wd2th9KeHxr4LLL0aV7AW4jV
	Rm4VWfDlw6ZZdp18i7VeouNoY16dIp/MEnqhCmNhOCIGNwuZkQlrgk/TQ2IlgIZGg8u0g4Opyue
	VPujZWs5Exh9eJS9J8y7pKhjilUxh/maOXxi4KhfP9D+IpX3Oj5fQM4L227CeoCUqzOpADvYEef
	VjK8f6rtbzgrprqoiACoU6u2kqWDu059CYlYeswVWCAsvngpiiHnO9g==
X-Received: by 2002:a17:903:3b8e:b0:2b2:4b4e:e4d2 with SMTP id d9443c01a7336-2bd7e8056e8mr164901055ad.15.1779123243452;
        Mon, 18 May 2026 09:54:03 -0700 (PDT)
X-Received: by 2002:a17:903:3b8e:b0:2b2:4b4e:e4d2 with SMTP id d9443c01a7336-2bd7e8056e8mr164900635ad.15.1779123243000;
        Mon, 18 May 2026 09:54:03 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5fc47sm149971045ad.10.2026.05.18.09.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 09:54:02 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        andersson@kernel.org, dmitry.baryshkov@oss.qualcomm.com,
        abel.vesa@oss.qualcomm.com, luca.weiss@fairphone.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V1 1/3] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add Hawi UFS PHY compatible
Date: Mon, 18 May 2026 22:23:44 +0530
Message-Id: <20260518165346.1732548-2-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518165346.1732548-1-palash.kambar@oss.qualcomm.com>
References: <20260518165346.1732548-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDE2NiBTYWx0ZWRfX4/6LNs+NJf2c
 v8UWEdC4pLOS6dTsqsqTMePX2E2LQeEvAOmcoLxAF2N2JjCSoyc9Upb/WS3BH7QGuJEXa+fG+DB
 Qu3D65xxlppIQmHg8WigXp5xfIPvSPo6NvQYoVdu/twySQXvZLLcbNpeCqxtoy0ATok7hgiVA1F
 6r3ammqBL0UqO/muXJxE1ObcchR+cckDelDMTcgalh7iDhZLpcE+ufgKeL9rSUSW3GIx+XLp9iD
 2eiNRhdwfDJpCFpflk/1U/1vvdGAsBrvNAhdnTyNT2X6dsD5WwnAqf+yzqKy+yOj6RrzF1djO0V
 qcK0otOg9zrjb/uMSZivc/Q808VpAQSuU3xZ3SQy2ulXmPEc1yV5r66yBQGpXuF2jAkTag/aA97
 TYvFuqhUQZChwfsK9jcavDHGbk5u/SSPZM27aivC+8E7N10GmkQdA0AA8RVVx31U+UG8HlPS+LV
 +Asd+0UEscu3b2XXLjg==
X-Authority-Analysis: v=2.4 cv=BYHoFLt2 c=1 sm=1 tr=0 ts=6a0b442c cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=YyC-2lJWTkF9Doz0jaYA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: FFHcVvs47nyptu5ucgK-quBGY7U_-9ed
X-Proofpoint-GUID: FFHcVvs47nyptu5ucgK-quBGY7U_-9ed
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605180166

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

Document QMP UFS PHY compatible for Hawi SoC.

Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 .../devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml       | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index 9616c736b6d4..2326dcf38a46 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -37,6 +37,7 @@ properties:
               - qcom,kaanapali-qmp-ufs-phy
           - const: qcom,sm8750-qmp-ufs-phy
       - enum:
+          - qcom,hawi-qmp-ufs-phy
           - qcom,milos-qmp-ufs-phy
           - qcom,msm8996-qmp-ufs-phy
           - qcom,msm8998-qmp-ufs-phy
-- 
2.34.1

