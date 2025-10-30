Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0D42750FB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 03:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761795199; cv=none; b=WZYRUwUcvvfqq0qHC82LkgF9TRzWAkx8lkIWcDcY+ZVZg3K0J4o/Tl8AeMDROwGPGQDporAUOuQDWN34BrDMmeVw3Gmg2TL5dEeSxeW+fUWTJDFMKg/N8BIEldeD/jNhMhdxXPDfVlvOYQ5UR/Jx8P0R9fjBBu2jg/gRkdnY81s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761795199; c=relaxed/simple;
	bh=OG20UJrRzmQmN/Kq0bMN4CqSEz0Ri5LEHy2e3ZHArGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g2TGGFmEIknCdSt5mUTqFc0Ldx6nmZjwZ1LaMY3Uf4e/DjReJG7uwSMWWoxFe5bvpZwVKFOvi7IEIk3FBzWUOu9eB8/IOeqUMrVUCcH07GWYqqSMcgBWGCGOnnCXJQjSf8gpgQx8bfKY65giWpaduA9j+Uv86fzaO0Z0Q8D3j90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rQftAsYX; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rQftAsYX"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U29pNH019205;
	Thu, 30 Oct 2025 03:33:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7MQeG9jT4kOvSXqiNKcxxDRd3q/jMMa8Ca7QXt5h1os=; b=
	rQftAsYXPFkfp6ecl1e0v2gwq6xiWHOF1LmEy926LBAF+fN9dgHGVWpU0nXnZPYP
	hHMb0YQ10eU1tnE9ai0Vilo2mCWrFfzCD8drScL3851xOGgJ+7ZBkj+bmnlj4WJX
	VScd/Ccpbt/Z6vbbzZs9M/rIKF8dmfQ+qXnU9FARyX4WyerLgmRNTZG+Jzuy4xfy
	LDuHfkIGRyicz+g0qNutjZScyDgeFdMDoDcwRjgbScxwHvWDgp1OXQL4Uwuw1Q4g
	A1vebNMc/1BRdYSey/f8E4e21HkxcQgGttd/jaByVdrF+wUpWdpe2X+9UI7FOMBb
	kDVVl/qo6sm4901oVD6C5Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3y02g2tu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:33:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U0P53X007666;
	Thu, 30 Oct 2025 03:33:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33wm1kvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 03:33:03 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 59U3X1nP023116;
	Thu, 30 Oct 2025 03:33:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a33wm1ku9-2;
	Thu, 30 Oct 2025 03:33:02 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Daniel Lee <chullee@google.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Huan Tang <tanghuan@vivo.com>, Avri Altman <avri.altman@wdc.com>,
        Liu Song <liu.song13@zte.com.cn>,
        Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <huobean@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Gwendal Grignou <gwendal@chromium.org>
Subject: Re: [PATCH] ufs: core: Revert "Make HID attributes visible"
Date: Wed, 29 Oct 2025 23:32:57 -0400
Message-ID: <176179516243.2050237.11349123845566493377.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251028222433.1108299-1-bvanassche@acm.org>
References: <20251028222433.1108299-1-bvanassche@acm.org>
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
 definitions=2025-10-30_01,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=762 adultscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300025
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDAxNSBTYWx0ZWRfX+CwCqQjfLlhi
 Y8Xcr33OlHU/e/0yspr1lX08vUtfOIGZu44PWtN7fgnPmwDVDDFXap25M91ELzP+FjfCi0AaY/W
 UvLupnDrQZjp3xtNSWxmuOivdU1qhSZng/XZ9BYXhIiQEtV4uJxIGK66G2y38k45eIvlMYVZUz2
 45yXyenSoLZNqh8Fe9MUoeXDaZj7G1K5XbJK8l+5TPZR/+jix3lgje2mx1QXypCMrPNXL/P+/J9
 N3WwJ1SIy10DUgvDlGxwPiqnGSw7NkfovF1dD8MYKoVvkazOAaYXd0ezTwhykf/MdgZx8C4KBko
 qMYNQQq0/wx3nYfWoilPlA7rcZowx9H0E1Gj5slW2ARtuH7NeCuaX++TPMZo4olr39+vTQzX3aD
 691h8Tg1ooZAVLPtk8WVBizxqqLHfw==
X-Proofpoint-ORIG-GUID: KfBYRSjPZUyvRfNpevKTQ6lgMx2TPnPq
X-Authority-Analysis: v=2.4 cv=Vs4uwu2n c=1 sm=1 tr=0 ts=6902dc70 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=7iX1HaTYTDlj_WLJQgIA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: KfBYRSjPZUyvRfNpevKTQ6lgMx2TPnPq

On Tue, 28 Oct 2025 15:24:24 -0700, Bart Van Assche wrote:

> Patch "Make HID attributes visible" is needed for older kernel versions
> (e.g. 6.12) where ufs_get_device_desc() is called from ufshcd_probe_hba().
> In these older kernel versions ufshcd_get_device_desc() may be called
> after the sysfs attributes have been added. In the upstream kernel however
> ufshcd_get_device_desc() is called before ufs_sysfs_add_nodes(). See also
> the ufshcd_device_params_init() call from ufshcd_init(). Hence, calling
> sysfs_update_group() is not necessary.
> 
> [...]

Applied to 6.18/scsi-fixes, thanks!

[1/1] ufs: core: Revert "Make HID attributes visible"
      https://git.kernel.org/mkp/scsi/c/f838d624fd11

-- 
Martin K. Petersen
