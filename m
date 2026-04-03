Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4002826ACC;
	Fri,  3 Apr 2026 02:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775181994; cv=none; b=up6mnOVQi6AH83j4OoOJpdnXMRnDTpZHVzSGzt3HjEQWIArpbA+lr0gcZ0rd2LwK7mptfMHpN/UxIOwbni6JvBKKshpJ0tP8r/C/MpN7jh5RUWFtEY4kHIeFG9bw8llwBiNnNYaUhjTKuSWWmN9OM13Pvf18Rbbe8NHWjB1ofBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775181994; c=relaxed/simple;
	bh=1W4tjBqf5BvAuPYHUBY1miuc02LtiNRpTu/6mPCNpFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NWuLA0T3MQ2K8Y+LU2DI5e5DvMOCEHqxZBuETReWRTJdqf/EUn2nae0XVnY/rujQPEupWbiqEBGajzOxM6bVw2UrS/1Iivwd3+LKVwf14n9wqIG7jyqf9lIK/x8BMpiRxnvH3gG09jPV41uoGEDOf/qMa7uotHbMK/ifs3wA78o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JwAu2icc; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JwAu2icc"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632Nfkuu3751116;
	Fri, 3 Apr 2026 02:05:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rQA2c0EYdpJ+hfmV5uQX+x/eS6J7CMXiAI3R4R8GMgo=; b=
	JwAu2icc0n6otSL+QqMZH5ABHWLK9A7283OEQ5PVe7yypXNAqsE+PFIQaSfmrhSj
	ID2PdIsPjlE2Zmw3PfXvJaaikdFvc7YJJKldLN1Rjm16cTScllGtbv//5/exSb2+
	KFhF0kwn7doxpCWVF9RJc167atndvButy3HpgX4oki5NRFGsfA1UqGaS85RDgS+/
	VbD5NQQhNdoWYHRD/jzZYaUc/a85Dmt0uROlSa+WXvRqZFin/Vko+nQrS06SUh5J
	dmnR7vieBaFFq3/7lhh1NQ9gAC62iusyRqHi4UlBkSJ3yHKoy1ePlURlHmu6d8Z8
	5DrLmQfJvIden05Jr8Bl3w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65s11gad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6330mRh9029210;
	Fri, 3 Apr 2026 02:05:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eddp4e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:40 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 63325cqZ017364;
	Fri, 3 Apr 2026 02:05:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4d65eddp33-2;
	Fri, 03 Apr 2026 02:05:39 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nathan Chancellor <nathan@kernel.org>, Arnd Bergmann <arnd@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] scsi: esas2r: fix __printf annotation on esas2r_log_master()
Date: Thu,  2 Apr 2026 22:05:25 -0400
Message-ID: <177517593428.3522679.17660227397593974614.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323100027.1975646-1-arnd@kernel.org>
References: <20260323100027.1975646-1-arnd@kernel.org>
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
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=922 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNyBTYWx0ZWRfXwv8RfEZpLQAQ
 quzNcEj4OrMFeAn/SsGJUGoocuftV47wFqTntziCWMlEPLWJkUgu5n85i7W77hOpgGNDYgvC2f7
 5mBuKQ0ta6Dj3YVZAXyRC1xE2mL8drv+vgInImuzzVXgXs7yEt0UZodqkBkXq68oJ3/63TPSmZZ
 /O2YDttwtqyYOlT1ak+Lazm3SzLlJi2b58Daimm8l7iaUSyduZNPUVlBA6jJ5XcUaFT3fqgeUbZ
 KjFSrV9pwMzvrhWHB6NOGgLODHgKPOaE20luE3+GNO24cW0WI0QryUIrSt/aONhac2x9KLYocou
 mXRFvApPFr6IhhvlUxqM4eiZnks4fLYCrbOoVgYIx1UHgLfe4KuLridQt0aHflVCnsOLrr8AJHs
 WuZjNqzk8trpQHJzq0HnZJ2W0EOrlg2OrSe9Mb6HWAyP5hJyyS7AucmbD+/9ymYlPvw1DSovpol
 im7+XQ01Fwa5yp9hn/g==
X-Proofpoint-ORIG-GUID: CWRzmXaqJyZyhxzv4bgjpd97QZMjIkz4
X-Authority-Analysis: v=2.4 cv=BvOQAIX5 c=1 sm=1 tr=0 ts=69cf2075 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=Er6j1MMAQklbVYpzFGkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: CWRzmXaqJyZyhxzv4bgjpd97QZMjIkz4

On Mon, 23 Mar 2026 10:57:39 +0100, Arnd Bergmann wrote:

> clang-22 started warning about functions that take printf format strings:
> 
> drivers/scsi/esas2r/esas2r_log.c:160:50: error: diagnostic behavior may be improved by adding the 'format(printf, 3, 0)' attribute to the declaration of 'esas2r_log_master' [-Werror,-Wmissing-format-attribute]
>   121 |                 retval = vsnprintf(buffer, buflen, format, args);
>       |                                                                ^
> drivers/scsi/esas2r/esas2r_log.c:121:12: note: 'esas2r_log_master' declared here
>   121 | static int esas2r_log_master(const long level,
>       |            ^
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: esas2r: fix __printf annotation on esas2r_log_master()
      https://git.kernel.org/mkp/scsi/c/67557418905b

-- 
Martin K. Petersen
