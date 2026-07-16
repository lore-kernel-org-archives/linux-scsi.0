Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA603E2756
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 08:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191062; cv=none; b=Np9c0/BvUW2MSdhrW4lZfLAJ5QK6XRMg9qIzf2xoUALAPJ2EXteNlKkHaDc9qhnvbllEZZffDaIzzObwl8klK6C8UcqHuaZOgoJ02/cd5dXtRNdisJKWgYMM7QIhuTDPu7rl7dmMzZJXMAknh4OZ5ImjgYHeRRFqO71lVxjzc38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191062; c=relaxed/simple;
	bh=YCH1yylulf8EbgQrB2WZCIRrwVIgjivx9cOy+yUc6pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJe60F0mfL54lDlk1ltYoNomgMPNGYJT08AVUdVVAk6cdG/Il9D5x7iGWxCD1zf+LJ6cmajEutIL+sXsJ87oTeeeTajpIrUrSlE0f+YDNANM4ZHoyc1Fvhr9NpwhXJZEhJqMcWQlxW0iPrE9V8F5OUp8LvaskU8y9liKeB7IB3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mFs3axel; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Kq93ubgo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mFs3axel";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Kq93ubgo"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66G7DXBa1892281
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 08:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=WqcCf+Dhdx6
	Y50GJtvfwTO5MqJahdd7ZlfJbqzun1ro=; b=mFs3axelzO9r0n365nnN37XvtQq
	N78hfiyC8tHfroaPs6sX9bJqLCJwPThrLHpLrKBKParEuiaFs/DS22cj9eF+WaQx
	xWxynwBdAkt5+Dv/Legd2vWpO1EcGYyGbmwIrmAMrAubpGqGvCtFmO1ESzpntW99
	BY6sKDiKlVLO6lD7XGZK+0RcAL2mpV+cBecAyLT7zgkt+909Kvk4l7b/bhuipKxF
	l/TGwlViEEZIbet7MSJr5JA3AfQHAt/fajqFb+dn+gNR/md2nO3gIcyznuhQjllS
	uldc9/6Yzp/6ZewQmP23MjqcEK3y+QTCzbqULjcRF1tUCnUTRkpR/oiazGA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fecnybexs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 08:37:38 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c0ab07320so55673111cf.2
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 01:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784191058; x=1784795858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WqcCf+Dhdx6Y50GJtvfwTO5MqJahdd7ZlfJbqzun1ro=;
        b=Kq93ubgoMCh4JurFN0/av80+Dusndxo7C5Tikw5lNDZJcW5QqVVhTc7FKB2Nox4US+
         kjTprqlTqlxv+DwV9EwnosLByG7ga8NNK1ukrBmnIhZAvZPMeyaT7HStHEAob+10GIrA
         Eis5setqx5w0I404ucGPX/xhNA/DMyHJr/FCOq7jxGGfHKCglUsJmJzDW498nBUrsY0C
         hV6VG3Fe486AWeRwUJdhE01zQMhHOB7DlRdhViwslK3e4Min43qnyeQ9H4mw+qyi2yky
         f5X0xv7rof+30syhD33SSCgjSVsavOGEgRfdxfiLYt6S3p2tioxNRSHX30mQdRcBY6Fv
         pi7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784191058; x=1784795858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WqcCf+Dhdx6Y50GJtvfwTO5MqJahdd7ZlfJbqzun1ro=;
        b=aJaG1uBZoKO/Ml2Z6Cfg7RUSey9jOF0Z8+gtQ+r/KrQPFVzHGOEF3FUzURey01+KFS
         PKCPSKpA+zyXDeKZK8tmOoKRM3oTyC+BG7QZlDGLA/thSM2T6cKoRDy5DR+CVr1lySVN
         li2w9xZb6+xZKH/gQR7yBDwmGPrxQP34+UDdjdY6N/FJzsRSquQ6FzgFQSf0hDI7vosm
         AczfpYKakx1mZDsE4f71eFjE7OV5gpmVZ+SzoXFvL0otTdkWPLse1JftiviBTb/L9AGA
         7+8CqDS9eLdFrXEzc1Tf5IowJg7UsEozdTQOOck/2lwctoVBRZ0OwEhsH8gB2cEY2vJ1
         slDQ==
X-Gm-Message-State: AOJu0YxUMc68+xYaYjjYMqVn+gdTpd1112udtTZ2nQTfPS8e1ymOSv0q
	5HUYWEItWWckiPj8h1QL4LBzAas0NsmGUG8J8fgYM5uGYobE908LyJBJA8EumfGiIN5rMdkw8zp
	f1s7TNI9u60fcKdUi1YELZmlN+hwGAOO7IRHCrxuKmCxrFGcR1lL+JKtKIFbmnswQ
X-Gm-Gg: AfdE7ckQs0x6Sk1MrAcF/a8bd9weslqsMxnwuJg11Z84iVo7ZoTvckj3kjvK4VGubyy
	hY4Fdwt6p8u5Vfe9IX2nxSlDlIbsyxiTKL/ASAleDMqRW7KR98HiOeFYm/MgXik7jC54IXO+aIb
	WjlTTyk0VUzSgtanR9DIjD08xS0oXIwIKPlBb9Mj3ouFIiqj4kS2nHSxkDiKPVGUj+nMNeVEPw7
	IgmRya+gfi1v8NYP+OpNCkupne75pymxLhbz7K0TY79X2ccMeqrVO0PZz4ZtIv+XieSkRP7WFRp
	vJIJr+Nr59S7DjkqNwTdKZ38I+4/WCDx6/qwI3+ILNu571MyGkdgc86KdxGp3ffU7PRBz4XdrWS
	6ckmuuJiDKkVoaQTa5F4gwSVWEKniUREZueRec+lGBMJqGLv98zc=
X-Received: by 2002:a05:622a:994:b0:51a:89db:95a4 with SMTP id d75a77b69052e-51cbf177b90mr203948611cf.6.1784191057900;
        Thu, 16 Jul 2026 01:37:37 -0700 (PDT)
X-Received: by 2002:a05:622a:994:b0:51a:89db:95a4 with SMTP id d75a77b69052e-51cbf177b90mr203948441cf.6.1784191057426;
        Thu, 16 Jul 2026 01:37:37 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541e94e7asm43614295e9.12.2026.07.16.01.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 01:37:36 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        beanhuo@micron.com, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: [PATCH v1 1/2] ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN
Date: Thu, 16 Jul 2026 10:37:19 +0200
Message-ID: <20260716083728.2226422-2-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716083728.2226422-1-jorge.ramirez@oss.qualcomm.com>
References: <20260716083728.2226422-1-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDA4NyBTYWx0ZWRfX6chIANisMOS+
 OEfHhHOZdCpcxfpKoeCHEZjCoQpm0HJC4OFQ9jxmSqrP+FoH7VUlQakPoAjojTWpdoM4xyyLyu0
 0Iic/OifR20wSWMSHLxGf2lEB4rnAuM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDA4NyBTYWx0ZWRfXwEyDptjSOnkL
 8tcgAnbiGI3yOReV0LjtSUcHsOjDp9/Bzhyiw7UR9/mxBv2qEK5IAjOfhLAE/35kZCOltWV10lr
 4VeuPul4U2R8CSfSQtgWbrT3nk3w6FFUcbjNYbIisEiJsB+iyqPf3BhPoyGhxtn/lWR1s3iVhte
 MknDMlz18m+QwqRiDY/r0ySa4kxCjbeAiwIHtsw5P43SV1yXuBsO2KEYjrK8EB9H0oKgG/h0iPy
 EVmUyIaYaCegQzS0IQOMBlWB8mU9IVUANSj/RLgBkHx4UA2VMxYUzya0VthMbiMB7M7zL5EZqAh
 QZMSu4y1+s3W883jDus8A/Q/0a7BCHWesUSeGKM1WaKPFnw9jH+c37W8QSaYB8UaibH/jALo4B8
 Aa1Cje4ZXflijmhBZhmvQ3FmGOlJy5D9xvmdmAOM+P+sq38VlIhTHfysqGQMqOfD711VKVI41fK
 CKqa8WXM67bd6hAvLQg==
X-Proofpoint-ORIG-GUID: sNc9lZ9liMEeT5jjmeE2_5RY2tjuJSpP
X-Authority-Analysis: v=2.4 cv=Lt2iDHdc c=1 sm=1 tr=0 ts=6a589852 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=w0io_FmA1e-6CLxyNa8A:9 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: sNc9lZ9liMEeT5jjmeE2_5RY2tjuJSpP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_03,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607160087

After a power cycle, the first command sent to a UFS logical unit
completes with CHECK CONDITION and a power-on UNIT ATTENTION (ASC
0x29). The SCSI core reports this to the caller instead of retrying
it. For the RPMB well-known LU, that first command is the first RPMB
frame sent after boot, so the frame fails. RPMB has no earlier,
guaranteed access that could clear the condition beforehand, so this
breaks RPMB on every cold boot.

Ask the SCSI core to retry the power-on UNIT ATTENTION on the RPMB WLUN
so that RPMB works from the very first access after a power cycle.

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-rpmb.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index ffad049872b9..d0c7ea7a36f4 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -40,6 +40,23 @@ struct ufs_rpmb_dev {
 static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t len, bool send)
 {
 	struct scsi_device *sdev = hba->ufs_rpmb_wlun;
+	/* Retry the power-on UNIT ATTENTION (ASC 0x29); the SCSI core does not. */
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
+	const struct scsi_exec_args exec_args = {
+		.failures = &failures,
+	};
 	u8 cdb[12] = { };
 
 	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
@@ -48,7 +65,8 @@ static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t le
 	put_unaligned_be32(len, &cdb[6]);
 
 	return scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
-				buffer, len, /*timeout=*/30 * HZ, 0, NULL);
+				buffer, len, /*timeout=*/30 * HZ, /*retries=*/0,
+				&exec_args);
 }
 
 /* UFS RPMB route frames implementation */
-- 
2.54.0

