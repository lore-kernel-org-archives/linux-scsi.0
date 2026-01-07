Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE9332918
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 13:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767792179; cv=none; b=CmKwubZsdwmxtKfBhRG0c8xx2QdrkSRzPXyPugnheX7kDw7HgtW098YZvIjJ5YLsZJe2dQ4d+TJQ+yoRQl9d8eYlH70r5yG34IdmExO5LS+HpgUN2f5z8kuUigjZep8mcxfrcGYLA7MUGk/wj/KgybXkOZ8h7fTNpH9K4hdZkpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767792179; c=relaxed/simple;
	bh=lhOHDEWr0lZrLkS8CuJKO4fQjRWNIOOdDs4KVEFrNRI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xcsbyi0LMlPw27FCk3tIKEkwXz8lHFHU1tuQ4ke+T6H9brKy/tgUAUUc7HOeCeTAnPwIZGS8eJMdMKwe55ySPF2omNLfa/1fch5y1zi6wZIeRn0TsNlK0SXT7heNTcOaYDeLEGZn27TuQZnR8eI3+nFJWg9YqBgHNERiBVRddik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jewxP7Nm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EnfZ1kzj; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jewxP7Nm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EnfZ1kzj"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 607A1bj84136999
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jan 2026 13:22:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=8aSQf8yithmmMPGLpE92xbDOF4T5JbspQB0
	vu6FqB1I=; b=jewxP7NmKmIBfQkp8b+QQsxMEUFR4dVOfHoTargw5d7M3A8IGEO
	J+3xBpdsCaOO8odysgT9BPFnKG1q96WfwjTBO+FRQ7DLi90MCBoOG+V4iQF9yhIM
	tkc9GNnOxRXgNPPP4lzAZ0adpKZRtaLJVqqagUAsxtVSzz1ddXH3NxyLCDy8if+4
	nFubzMvqV739MLvxEZCbDUy1JjZsCrcf+nd2rWzu4gmpXdYObthi3oMp4WCNC6Nc
	xOqX33HO0ezkxPbNrMgADVysqCORxFXEnqAj7LZ5dR4ZqK1cuieFaEziksEuoR2N
	B6dvnS6vhjIOsKYN56uguthX92a3/fJGrEg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bh66e3dae-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 13:22:57 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4f4a5dba954so55834821cf.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 05:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767792177; x=1768396977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8aSQf8yithmmMPGLpE92xbDOF4T5JbspQB0vu6FqB1I=;
        b=EnfZ1kzjbOnurlG4iojWQ+CVgzpwTLueSfGSS1xa9I3iQpBSOxcUOoAfgcaoCIZxrY
         TW/WmhVGqZPgQ854dE4d0DggDzuiDCHKXxUT9juHZTVvSS4GpzhUzsNaOHykDRNjqbGn
         Tu0gFwWALQRFxPjVo58EvXAdsiCjcaI7t33Tjn0T6ZNWHSSO2E7/pwIYzk7AyF2LSlrb
         5NktbWgwsG9Vr5Iw7ZPz3EjkOFAtoxjtQpZ8SoTFu+RxwvUhQWHjdo3pdQblZmmy4mR2
         hk8L8RuxwauuHFqRNjLek5C8sZ0HocLIJOsXZKbTlMToVrmm11kJsNIYa2Opfz9v9PT+
         7lsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767792177; x=1768396977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8aSQf8yithmmMPGLpE92xbDOF4T5JbspQB0vu6FqB1I=;
        b=XsOuXZKY5LNvk05QskQQHRWwjrkWvVfczdR5XrdDKN1gbrbqxiDtZgb+OFeXc+4kYm
         Aq9iHQBwH/+IvHf0GCSMoPFAIQJ03QD1zIS6Lr8bGnjiFsftyzWoCrtX/UmotaDkPgeO
         HZe6zNX4AV8P48lQI94oBUiW/q5YwOjohdrDZ50zJfGzk2GzpZtyuJOHlQgM3SgfqB0N
         /JnRsxqj2LcaBa1F8Ci6NTjiVMxunK7V+OL05iZ2x3j/paOR23r3/hCWDn7QVHCvRmuZ
         lyUFs4b/JUi1Ghqq+Jgi8t8c+UfeCpzqtl+DDpPKPlzzCcRK8CyNVJ/iOseKLr71I8Lz
         Yu8A==
X-Forwarded-Encrypted: i=1; AJvYcCWr8DQ3oJZWcYyLptS+MfvgmHOUhn2AidH/EP2NleZPy5XJxkJnnlgSQwSIqyz+KnW6KaaOTESDszNR@vger.kernel.org
X-Gm-Message-State: AOJu0YzGRP0xAVqrH9mPEvu3YSnVVvxqq9I56Rvii2Ek1qBsnlVEwE5Y
	0hZPzvdoT8xVe5+2hXI8HJ2U5vo/oxArIG2wKa4UBMKoFYwOxyHxllWIXC4SK+WfCcAgRoq0VAY
	na7egzBlfWBObMTnlb2GlZ3b2dIAaXPAP9ELLVxsJD6RUfhZ9jGs7+XXQ+WOYJuSS
X-Gm-Gg: AY/fxX6w0qwmonh3ncLwMOM0akMz/rpEYiuJOwA6dIQWSe/iMXWUMOSxsZkRsLPaJSD
	ZooKMyPcXouSv92CDFRsaXBHNiynPwQmvTBFI64SHp5wwcgm794ODyA172Hbzkl+i3vsOMPDKD9
	5WojMkyRKkJLgAmngEM3NRHDvhTBX7yeKT3gLArphCn+SywmMi8FpBTsd2vXX7Fav/9YPyTZjEb
	n2+wEvNd4ZFvuHtqTTyq6c7AXDNrG8dibaO0GcGUT/bX8yMkWbTs6JC9aDc/qChTpdK8oRsWBiy
	xV7Cx7jbUHEq3oZ85QyzhC3bsNx+3Kk67axXgW3WbqpTXiD5jtr+MKdepjeWrTw+6bMZGAhzTsG
	Ad0Z7y4mHaSb8jpKNfwH9xntgsA==
X-Received: by 2002:a05:622a:283:b0:4ee:1fbe:80de with SMTP id d75a77b69052e-4ffb49e621cmr28206971cf.63.1767792176728;
        Wed, 07 Jan 2026 05:22:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG8UKAJDIiXreWApaYxxazzcQWyseBXz1P/FQy4nAnTZWI+XJhEs+c8pTlBLLMESDZhGAKr+g==
X-Received: by 2002:a05:622a:283:b0:4ee:1fbe:80de with SMTP id d75a77b69052e-4ffb49e621cmr28206641cf.63.1767792176355;
        Wed, 07 Jan 2026 05:22:56 -0800 (PST)
Received: from quoll ([178.197.218.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f653c78sm101844395e9.11.2026.01.07.05.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 05:22:55 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] docs: dt: submitting-patches: Document prefixes for SCSI and UFS
Date: Wed,  7 Jan 2026 14:22:49 +0100
Message-ID: <20260107132248.47877-2-krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1083; i=krzysztof.kozlowski@oss.qualcomm.com;
 h=from:subject; bh=lhOHDEWr0lZrLkS8CuJKO4fQjRWNIOOdDs4KVEFrNRI=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBpXl4o2Aqf42/CcWEhCu4gAEeEqGw5hTU8w8u7r
 SfFeB/DiRaJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaV5eKAAKCRDBN2bmhouD
 1zL7D/0YDGK3yLNDrfYzgLcBgAwxOxIPue+wrGRCIZ/n2myBNp8/gPPn6XSNepLOYKu2AQCRwFj
 bIxCuMFFFEPHM77n7I1kgMzq8Y5caYqUqUSobmhSFs6w9+ErZLvELqkqhT3Khm8AzIcATW/AJcx
 xKK7rzel9j969qiVR50pD361sb8hHAtz5xdSAhaMyIiPaonieG+1vRiYVOvs8LUCmAe1p4rIB29
 yVlov3p3rB/jYvXiknPzZzHbaCRTCf2nVPB26xkoEl1dM9flcyyD8sYxvkKBf+TTvUc3WBpY2b1
 GDMKiHdj+bF9AgnZ5cEZl0XimvSJl7201JzPqfWSnGyCxT3wVJOUZY/vnwCyBIMUpD94F9fSbe3
 vdbRBnRKl6sYtpUEslY5y4T2qiXkQbDtoafUUCtjumvziY2s9lCRfRi+IsKKti0hCI6b3UzXY3C
 MA+p7rHAmt25KK+BKydORgjuxqtxDpMkE90l1DIVcBZnQfjdddURmeWo+sJURAtWVZt9+SS7/8L
 6d8HcNr6mnLezWAdwUY4LDP+B46/ps1KjEEn/yEihib6zOAOK7lwlH4IJqHH6JS6H621+DWr+fk
 XsblBViPtDgPp9u57JsI78Mj6z15obS0ajcXg2b5v4im0/tzuZcx6qhW0hiKxjouRtwxypcFrWp 290S09sP7jFH9ww==
X-Developer-Key: i=krzysztof.kozlowski@oss.qualcomm.com; a=openpgp; fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDEwMiBTYWx0ZWRfX4CI1UedoVhuN
 8bcwDeVTq4NlWVWFjQuN/mXtSlBBMBMlL1gsGXGu1eP99F6zMS7x2EneZUReDpL1ojRJV2OCreY
 1hARdK4730sU2BKZTNsdj+fPbEt4N61u668BKNMSyVP+dUrRSklU0f8nrum9HYLDwwm0cCZRA0g
 YJ6ILvxZwgWfJZhMOyg0FFrXVtkaJ+yrnBqneDEk7sWZzwHjflflvlcDwSCkMqTp3qsFsJxh6ud
 lhgo22YTPwrZl9Qnp9Vlmca3rAowQyw8+CKNVXvIW0Mbt6abVEoAQ117Pc6qJxHktnWfTOYMP/2
 3Ed6i75ht04Mj5nX1UDeSUO7/t2l97VQOLImef+m4Ui4fSFl2afNRST+gj6NEX48wwJDdNKMriX
 cfTUjtQa/fnsZQhOCM9IgproBld2FGtUelTOJn8I8z7irZoECCe++dd6yQwsJoyXhnYeFBgWAMf
 dgYFBBen75pBh8562yA==
X-Proofpoint-GUID: xD6xN1sl7wba7_jL6R1lIPs7nGtSOXXK
X-Proofpoint-ORIG-GUID: xD6xN1sl7wba7_jL6R1lIPs7nGtSOXXK
X-Authority-Analysis: v=2.4 cv=evHSD4pX c=1 sm=1 tr=0 ts=695e5e31 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=Eb9f15NH/cHKzfGOmZSO4Q==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Psxmm-6NwcIMtDS5Qv8A:9
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601070102

Devicetree bindings patches going through SCSI/UFS trees also use
reversed subject prefix.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/submitting-patches.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/submitting-patches.rst b/Documentation/devicetree/bindings/submitting-patches.rst
index ce767b1eccf2..81e27e50f905 100644
--- a/Documentation/devicetree/bindings/submitting-patches.rst
+++ b/Documentation/devicetree/bindings/submitting-patches.rst
@@ -15,8 +15,8 @@ I. For patch submitters
 
        "dt-bindings: <binding dir>: ..."
 
-     Few subsystems, like ASoC, media, regulators and SPI, expect reverse order
-     of the prefixes::
+     Few subsystems, like ASoC, media, regulators, SCSI, SPI and UFS, expect
+     reverse order of the prefixes, based on subsystem name::
 
        "<binding dir>: dt-bindings: ..."
 
-- 
2.51.0

