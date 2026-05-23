Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DCF27703
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 03:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506133; cv=none; b=FCj8+A3Vd9D/eXOP3FUWfYoFP01mRHw0XY7YUC2H/U6GKV7RyNtnnjYW+6XO4EGljzaUcs3JBUHmZTVA7O6luq7nsKS4sAbLJqWX7Zwak6QWTo5a4H88ih56CAwGio9zjR67Zxc/53rS+VTduR9/3w5TH4JIuvwdOEMRqPW6lKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506133; c=relaxed/simple;
	bh=l5mnYq/H4MZGDqxG8rdZEZObR3h23eMGVLvv1gVugLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WYb7VKn6LQUu53NCt0qS0u99W9ff95vDwYbZgtVRCn8wwlyAYbCkM21pXjBffDF3ZSN4IJr8k9E8sK3ReP93hKdqtA0oqSKE4Sz9kxQz46xHGhkUe/WsiotpHOUzKjpPbH51op7cRRpTOtkrmFO7KY0BvaSBDowFV9m6L+RBBTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mp8Cof/P; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mp8Cof/P"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N3FUNR2612422;
	Sat, 23 May 2026 03:15:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fJjrTzpgy3sao2DPxSCIgs/Lp8XC0sfxtYpQTGrtx/U=; b=
	mp8Cof/PrRHbBMxt9hK/sv/lrfel12IL36dPA4IfH9uiFwMd9gejVa7K4/iuLpXa
	7yr+ZWeXWSgvgWrwGTnpgoB3V489i7lkhCMYwr12dM38rOGdOSJ8j6o7tnyFApNd
	a+jVrqGeCd55Yse/BnM9+2RGApSTTnILEcL9HYUyRio5a0EnmACM28wuKqpWzw5N
	sfa9A9EHB+Z8w470pxYGmkK1lQ5VJMUuFmtSvfAs55gqW3Px9VbTNPtzKYev3UDX
	GkWJhWQmCHb7YAAw9w0vvazG7bIHT6svchsepbDiwRbDtIy2bQ6ST67HPq/L/jzQ
	qF+mizH1a5rnhXtfj23YZg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb2nb88ke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F6Zv032352;
	Sat, 23 May 2026 03:15:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:29 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9eS032824;
	Sat, 23 May 2026 03:15:28 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-18;
	Sat, 23 May 2026 03:15:28 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: mvsas: Don't emit __LINE__ in debug messages
Date: Fri, 22 May 2026 23:14:32 -0400
Message-ID: <177913641781.1181900.13257682614122090938.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260427174545.2014499-2-u.kleine-koenig@baylibre.com>
References: <20260427174545.2014499-2-u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=567 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=bPcm5v+Z c=1 sm=1 tr=0 ts=6a111bd2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=w6_s345OmvwzK5sOhyQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zgiPjhLxNE0A:10
X-Proofpoint-GUID: KtQGrdZxKaeDNIVdRNFukm3NVzl6I9LB
X-Proofpoint-ORIG-GUID: KtQGrdZxKaeDNIVdRNFukm3NVzl6I9LB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfXx1C+1iKJ3Hw9
 fwjt7Hly7kZctf5daEv8e3x8DpW5M37SGh5ocarfoWiTN0uWLNgSMefCLzzU/K5V5kOTyHmMdlJ
 GvsYZlYVEqxAgJsw0jFcNsQWBpjMy3UWWyFRej/5aWKsspkTkXAeDF8n7hoHoVVxS/KvqObKDgg
 Rp/LIyg470lck1fanYOL7AcEomzYxRCLWOOd3Qrabi70/oS7QBM/sjc8/I6zoptR4tYnqwrYUGV
 JzadqhJouzEUGIZNBdvQ++qEiXZlZjriKtiJ9qo23JS2wn56ogJ1F5TQJb80d6YNYeKoHqiOEnI
 VcIckgEoPS53UTjn12sSn2Tpdv+341ow4uB9NlLaI7MKCzcwzS+Fgd3G2J6tedMCB3HT/Z+2KQG
 lVFcXmlQdnLR6c48Cz7kbB8RwYXQwRnPoZWlHAK/RGfnPU6H6yVZsWrf+v545Ie+8A+9vLyQ9ZQ
 3sMpx2YSkT0fc5nU/Lw==

On Mon, 27 Apr 2026 19:45:46 +0200, Uwe Kleine-König (The Capable Hub) wrote:

> __LINE__ changes quite easily for cleanup commits. So when checking if a
> cleanup patch introduces changes to the resulting binary each usage of
> __LINE__ is source of annoyance.
> 
> So instead of __FILE__ and __LINE__ emit __func__ to give at least some
> more indication about where the messages originates from than __FILE__
> alone; with that and the actual message the situation should be clear
> enough.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: mvsas: Don't emit __LINE__ in debug messages
      https://git.kernel.org/mkp/scsi/c/2cc8a6cf8a80

-- 
Martin K. Petersen
