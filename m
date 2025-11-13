Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09AE26980F;
	Thu, 13 Nov 2025 02:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763002059; cv=none; b=WkryujiM0/tNcxO6kGdj8Jxe1lmgUJtbn0y+LulO3rG/0cPQDm/JpybCiMkV3uTsOvd/mzX6HOBA3KAatpY8KcmrG80vFIvm3uxOwk7NEo9llOOPfGQ5k5dldcWqhbHLIrg+088MORiYEDkuKXTdtavtA0Zi7EBkFVqprxWuyHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763002059; c=relaxed/simple;
	bh=FWzhZoXDYdhehysd0N/Y0Ocbz/rgArBbWTS465/380s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZGRAqv6m72vaQLtX+HsRpir20DSUL3gm+bv8qs8YRyE+xk43p9xx9E+43ti1Bjigugn0WdiIzdkCTv4+ZcdN6ztGsOlxUUPt2eFXDd7Hq0By7Gzd4F4ecVqPkgs/qNTQWEcOTHN8tLYtNuUtaax4LOQ+Ca7vMcbzZMCuItbp24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hzh33el4; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hzh33el4"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1hkxu024043;
	Thu, 13 Nov 2025 02:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1sHGTjdI5nQJA3D1GLCj0xQo44LivYH21QX3rDb+TUM=; b=
	Hzh33el4Y+nT36Z0VrbtaAD5HFlzKjd/SEGtfUnf2Rk15Z7upJSq79FIk+8OQJQr
	g+aaSqeDRGGGyb/1ComZPolN8bbq19AcYehgnomNyH9AeXTnHaZnJX9ZuLUKaYvp
	EGEutrLZoe8a/M9JeJUUpgTCf4XWu2F26gQWzQdoBhxAFARatzy4IhyeiLhVEOmM
	JIGB+227d/ejhnmn3iYwwjwwFnKcE+d8bOXiMCDnfHPduXT4mvgW/T7aUQDgWd3V
	X2GZPanY2J9CaMG/bZCfmsJ2811tiWgWSqz/9bBWCElCPCw4hK5xrs0Xea+acP1U
	o95fdf0QI5vnESzgUSN+8w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acxpngvwq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD0qNLZ032481;
	Thu, 13 Nov 2025 02:47:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9van9qcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:14 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AD2lB8N038323;
	Thu, 13 Nov 2025 02:47:13 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a9van9qab-6;
	Thu, 13 Nov 2025 02:47:13 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        robh@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, jejb@linux.ibm.com, lgirdwood@gmail.com,
        broonie@kernel.org, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, wenst@chromium.org,
        conor.dooley@microchip.com, chu.stanley@gmail.com,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        naomi.chu@mediatek.com, ed.tsai@mediatek.com,
        chunfeng.yun@mediatek.com
Subject: Re: [PATCH v1] dt-bindings: phy: mediatek,ufs-phy: Update maintainer information in mediatek,ufs-phy.yaml
Date: Wed, 12 Nov 2025 21:46:55 -0500
Message-ID: <176298170716.2933492.7751949109863545912.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251103115808.3771214-1-peter.wang@mediatek.com>
References: <20251103115808.3771214-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=924 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130017
X-Authority-Analysis: v=2.4 cv=Criys34D c=1 sm=1 tr=0 ts=691546b3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=mpaa-ttXAAAA:8 a=8d0GUG1h20LVvl_VnrYA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12100
X-Proofpoint-GUID: IeOeuSWTlTrpHkCLnld7n0QRG4Xbhs5D
X-Proofpoint-ORIG-GUID: IeOeuSWTlTrpHkCLnld7n0QRG4Xbhs5D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0MSBTYWx0ZWRfX9hbFk6XYutWW
 Yw7di95yWfu4YBraVPukJnMQ3rL3LgBLjU45S3j4/On0OocZqamzibfRHrN25ewELf036lHNgZb
 ocRqjtcAmEFBstn5lkCHBt92p8nYFTiKKCu+UjganwOUDFl2rNPVr+uqMhmHgAi0rKTdS5uuucZ
 Nakmo6jG4CS72zn6vgTFbhWHuXu9rehqhT3IbiX3V09g3QZ5Mhbug5odUW/PCZTuQDk4zCIVybs
 RtL5XI13vbVCNvz+zqxVjU9lnrm7y5yq4R+DmHdrYM19V0iFjHpJ5DsS7Zgvlu282zdwdM7dIow
 vYuwk+pAfUwdZsqF62XLSQm6uKlJW5H7U7k/LDpAvpht/EaATwJQf3acFLFUHb3E0cNhRuxZzwP
 VrS0lDd+Zwu3TNzsGErQDLAcV67CglrMjT1PRHOz5TiCmo0YLFE=

On Mon, 03 Nov 2025 19:57:36 +0800, peter.wang@mediatek.com wrote:

> Replace Stanley Chu with me and Chaotian in the maintainers field,
> since his email address is no longer active.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] dt-bindings: phy: mediatek,ufs-phy: Update maintainer information in mediatek,ufs-phy.yaml
      https://git.kernel.org/mkp/scsi/c/ad4716ad48d4

-- 
Martin K. Petersen
