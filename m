Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1C93CF58
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 01:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740447881; cv=fail; b=IjT55hKlEuP7VrOlbZThhKXmOxN/y5ZVKtgaGGdUKKFXwcg+X9FoK63FF0naNdsIyzFy1WqgfMwgOHjnKPblzYdu3fLK4GqzXtwVa8j1vq/D+xWaZ8WlHYRb02yc1a8+3TYpVnPl1HlXWajD6Zeycpl2jfS0RMNILLvnCHj2tDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740447881; c=relaxed/simple;
	bh=v7d2WUCw4VJUNcvphLgOqFnSHsyrqPMXaedRuA8fj+o=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=AgWMAXJaniWSMHTNEy+CEnlgjebteERkWng42JfFvbCCaKPcjqCw4K8w6OAi0BUIv5fPCrX3GxFHCi1KCCpPGzw3vwHE2spAki1SSV79n1MKzY6gr8l773Jkc+tnLG2PmbnyLykThAvviLShYmZNu/aWR0RtrfCYLwWhBh6tvaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L81ReUvH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CQWnd6z1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L81ReUvH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CQWnd6z1"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51P1BeKQ001574;
	Tue, 25 Feb 2025 01:44:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=e8CNA7UdHC/Yqhvz5M
	kuUCa6CYTVp7eoOesrLPZ+DkI=; b=L81ReUvHoGUkGuHTzqenpk90sEbKDY5H+r
	21KK9YqlCVWK9Oxt0X0YRwm2WA/Zmd8msavnAgJmSciSTwQFeQZV4yG+9ZdMNiS8
	bGKkeIUZGS6uzMaKbX4vLByPPeKr+6rCnj/kfw3Qdx7wHQz8kjwVUKL3UCf4j0nA
	zKslvj0nqLHgDq+o4/T+afiXMqiD2Cf4Xv4lNoBRE5a8ZLf2G26u9UgZvnXU/PWv
	XeiMz/wW17m9Cc0Vck9it3ljao2ybCX7G+ujiMGb4oy4OIN8FJ7MMj7MpnrV8kVx
	hbqu34ojsnOHhZOlAhdXbLQN+YM3nW9dNGOv5tl6Pc5wZERFZ27w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y56040e0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 01:44:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51ON6LSE002880;
	Tue, 25 Feb 2025 01:44:25 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2046.outbound.protection.outlook.com [104.47.57.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44y518s7ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 01:44:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C6WwwI2nSuD1NqwCQgjuVKXqERHMa7RkIkmbeo3wim3avos+vkslrp4XN5g8dv4tZZ0kKanEQu1cM73nTeZcdwv/HvZ1qvESuWM2FuwlUDk0Oph48yRt+Fzrl58aX7kui/nJB/cD98NZxq7IAxR0JaIBEdxn6eOovT+1WXCw+KGKOTrteTCnbtP+VqZjwpH38ij40jXdaosrbaF4yVBWewYjZlIKmrKqQaq6seQZa3jTCQnzsfQDbJMAmw3EgFvlir1r90dg/PJ753Uwrkx7uLxLneFcBe04LnSEJFeKpWYItcnHOYvRP5SO9B/OBKN6Ogz3VgWdpk7egCrzagvqpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e8CNA7UdHC/Yqhvz5MkuUCa6CYTVp7eoOesrLPZ+DkI=;
 b=pknJxp+Pcv/9mdm9ZwVpvgM1PSN2P6ftB39qxBEOXEB+j47TTKFaeLFXEhDCOlLSx2dZeDYdiATZXmXr2+KKkqAm4z8ZBg7lUgnGVGy/fnyCEuz+sy7rMczZIcOFYjbT8pUU26aD2fH5/RZdsrAxc6hfyOZgikbXLzsn3AGVFXhFkBHjosL0UR3OZjQR8rvJUgcJglaqZC6mTqHmwpAc/PdvjnqrgOFrmHQsHgM8bM5CPYufaET41t+RtBSPKpCr7zNyDh4qTnDraiz7B84sHurwf1PwBqWySa2jbB9m1WR/FmvzZPy3UN5q08eaTRjcQd+o+BVUgx4w4zemjsGtdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e8CNA7UdHC/Yqhvz5MkuUCa6CYTVp7eoOesrLPZ+DkI=;
 b=CQWnd6z1F3lYvpVQuyGFU2JZr9YQQV/RMcHfVb700zoz1Eufm2qAnSE+K+jv0fW4F3xb8wJtAbIX6Ji+G0Utm5cpMOqW/Rqu+H2h+8VSwp8krwdcSa00NyxauFSV1RFVJgNzrpxRpN9vNFbVp7F+KD+2SKpPbXyCoLxT0bBCn8M=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH8PR10MB6502.namprd10.prod.outlook.com (2603:10b6:510:22a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 01:44:19 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 01:44:18 +0000
To: =?utf-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, dgilbert@interlog.com,
        "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        jmeneghi@redhat.com
Subject: Re: [PATCH v2 0/7] scsi: scsi_debug: Add more tape support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <46401BB6-2688-4E8D-A730-77B7334AFE40@kolumbus.fi> ("Kai
 =?utf-8?Q?M=C3=A4kisara?=
	(Kolumbus)"'s message of "Mon, 24 Feb 2025 17:13:55 +0200")
Organization: Oracle Corporation
Message-ID: <yq1seo2bz0q.fsf@ca-mkp.ca.oracle.com>
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
	<yq134g4f2xp.fsf@ca-mkp.ca.oracle.com>
	<46401BB6-2688-4E8D-A730-77B7334AFE40@kolumbus.fi>
Date: Mon, 24 Feb 2025 20:44:17 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0037.namprd16.prod.outlook.com
 (2603:10b6:208:234::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH8PR10MB6502:EE_
X-MS-Office365-Filtering-Correlation-Id: 93d04510-92ab-4349-4ed4-08dd553deb51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fzXmQ+Toig23Di4KZg6dFPQ4G8mExa77FgdYwUinZkZwDtBpHbbfYbA1td6T?=
 =?us-ascii?Q?0VEoeUV8Quj1KxzTODZaDmMdkhzJ5q7b6jq2Qe/AAWbWK1O+rlSwNJZVT8yH?=
 =?us-ascii?Q?BRNze9+jAg4AR9i7RsA1FWyqzFCDk3Y07VLHG3KezPnMqr+RsC6Yz+4wFPUo?=
 =?us-ascii?Q?C8HxB7y9DSXlkwlbzU7lTiSMsFoCvry6frgFjBUXGMgW0b23x2H9QVKY7E+3?=
 =?us-ascii?Q?2GMUaPxDsqX0i3xm7OokCXIfqhTU8HCMmRGcPwncI9ByofIMNMVc2wlT70fg?=
 =?us-ascii?Q?9NWl+QcEZWZ6FvwpBszr5LFEd9SOPyu9OiFT4WILj33PKJiUK3WQUebRpK1L?=
 =?us-ascii?Q?2btbgGvEg2481PJeT/4f20r9XgdsDhlINTa/LPrGhaLySzKv8fNzxes4P4Og?=
 =?us-ascii?Q?Awep8kCQN1IFhqDLFEs/LJJWxGocnRyFi6/smoPqpn0Fct71Fz52kPfW5SBk?=
 =?us-ascii?Q?znzRr4w/3BA2tLEdxLzp6tTOVTC2FO+0V02xnMpg8JgKDDsjEYTaFfKOl4dg?=
 =?us-ascii?Q?6TM8/cJSyBHzEZ9FKkUjq4iZ6M8zPJvl4iwMy+UxLo5WTfaVR2dGr8YEtxnk?=
 =?us-ascii?Q?OHj7hZI2boxkdCFhga3uXezXOM5wrj1pI+OTkn9DNiP37qQsf+beptNCz7GI?=
 =?us-ascii?Q?f8E8XdTzaeEH3FR7/xSMLsNkNftYwn1VbLeJO3uTsqOnoISAlWfyE7FlLTFt?=
 =?us-ascii?Q?E8NZeXp7HVrr+ZVUu6RHxs/Oy5UBs8+6sWY2Y0TEminOpXsvq3vXvzPtD6tS?=
 =?us-ascii?Q?vDeB1GtytPNnjTxoLrOgpagEVq3S/Yb95ELTlW7ixSPJCjalwpt9PM+bWMuW?=
 =?us-ascii?Q?OgF+2RyMKDtmrpJLLrolmu21r7g5gVCwwNiVGEO9IgFW88hSb7UjX1EfLLG/?=
 =?us-ascii?Q?3A3dW21S2PUJzlSWqeeL1dGdaVUd0kppzS6J2XYbIcSeMnAopkilmkCSceZD?=
 =?us-ascii?Q?AjqHkS4qgf6e9qKNlDrtcJVDoak5kFftg6qoECcYJzQ1ij2th9liJtalqrkQ?=
 =?us-ascii?Q?wf4OPvm47Wk17KPwUzWnoiPuneFqpEmIKJbWMKAva0ZxpUL4oIZpGYxnImTv?=
 =?us-ascii?Q?NLRMH/6+rnTlJD20fyKyni9iY1iuxTs9QJsh974cwvj4QmPPtbsp1Of8zUTR?=
 =?us-ascii?Q?AuxVArCg6Pp+F/M4UE0v6jWZevEOca5KqMwhuZOe1YDgTQ3Ag5TrJ8AeK8GT?=
 =?us-ascii?Q?Oru3uqo19wUCmd/3ehTTtvwjF0B5k+v/1X+cPsf1hMVjvSCOfKdSe76zQu6g?=
 =?us-ascii?Q?o20ITc5J93PkedG0YOB6znbF6tjygNHtGoCKkaxiCRPZ08gZ2WCVbNCsH57Y?=
 =?us-ascii?Q?eR2WnyKJipu2Gn76BPqWftpnxXsvWbO4NjOl/8xwaagxCy5GJgJbsXEd5xZW?=
 =?us-ascii?Q?BsBCTTfe8TtFA7w4n9nXsaK1Y+6h?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tX1LfKAVK//cBdTTdyYHsWUpf5D5ARy4YZjZia4wcsvGMiQp7NfBwprTI5aS?=
 =?us-ascii?Q?XUZiZIV6vL1MfqvHxewGv26YrJukAgQnVh5kkDsLUkw7vt9sneXO+C4EF68F?=
 =?us-ascii?Q?OBWAPSg4iLLEi0tEfptZSOM80iuqbrG63fEq7Z2H7ybbG5lohgB0wYrMJTnj?=
 =?us-ascii?Q?VZJ3ZF33O71CUfft8Kin983317JKvXFGx/OO+2/d6EBnTx3d8I9D+1DvSt8n?=
 =?us-ascii?Q?x0Tn6bpzX5LCP4QXadGRa7q2jzqkzIezWmhHBmNwbsofMGpEIPZHkTy4hvoz?=
 =?us-ascii?Q?ziIXfVPY+HtQQNbKMIseWq7DSk13z8+pZMni1c2skthRV4q/D7yG5SVrTgr1?=
 =?us-ascii?Q?dwn0vlX+V+NGw51xuPGG+QdL3k6ViaSQ/L5xxWkUO00qUo9Pew9PmIMgodCK?=
 =?us-ascii?Q?KdcrwaGZGz0xXns3p/DcP95bUXI5r9W+O3J9aXrcPPZt4uJskTJy9eL9aumQ?=
 =?us-ascii?Q?LCQok5VUzCUgsGEgxpAt6694qQnDJF2X+gMrsUSznMjxi7wVaQtaMg/FntdD?=
 =?us-ascii?Q?y8vWyNsAh7fRKEhaI3qFIrYPj5x3AOUOZWu3j2iVTzgzWlwymauSp1KZefya?=
 =?us-ascii?Q?zSjSQF101Xubde6/vhhiqrCnPU7LATQccL7JemSLBgH0rxRyxDq3SN5vjecd?=
 =?us-ascii?Q?1V1IUB4iL7DhnnmDcmEu3P5P0o/nddvSML6eYxUMPDKJr4yGf1W2cvQo25GS?=
 =?us-ascii?Q?oWleWctfuc91UNQUDsmBfZgwdk+jHMa8RQmtA6+ez2sJa6cxy42lGijhdFUV?=
 =?us-ascii?Q?jJNdUQ8wUqCIdtuOgMTlRwEhzhj8Ns7DCsu/iNsJvzdV0hV5nSXLbLXAqh+l?=
 =?us-ascii?Q?c24o/EAdicSUT6BpO8gqRivl0xtVHcfA38+7/oGp/MmnN/V6RxSXUblm8+Aj?=
 =?us-ascii?Q?vM43DIX6JsKAvgEdU3/ep4kJm968YM2Ps93pXReTn8SlEdwdnQxk/hBjgGk7?=
 =?us-ascii?Q?cU2CaDJphGfZZEeXfwxDWfelmsXjTQG0flobtKCajgmw7ZgHjQo3sPJ0tkGo?=
 =?us-ascii?Q?a0kN+RFvH4mmwMduP3H28y27bkspe3+kMi3YuwxHKAwRY4/ngs8yNUiCdGjf?=
 =?us-ascii?Q?aq8Nw+DMlW/aBqiAQ62ID3laEIats1kb2d6dAFravtydsx87/E5c6Cy1r3/m?=
 =?us-ascii?Q?Z4xvbh5IqzWKCFM6y2lYyeUd+UBuFXzLoDxalFaUOuIEgFtio6L681jf5lGh?=
 =?us-ascii?Q?vSiRzQUBffqCheEymVa3ZLzOFvpl+PrxxjPhc9BnGNlr0Q2t6uXJGetfqnud?=
 =?us-ascii?Q?fGfnR+dS75hEPwmwDt74MrwBW236Xqtzy2NhkmbFub7qaABqdvLUvmatd0mp?=
 =?us-ascii?Q?sPHAO6UtW6c5W1OQcjwWOPapnjmu34y9AhrpQYjVryRWkvTgXwegLzQL4IL8?=
 =?us-ascii?Q?zlKo30BitSIPI8LrPUS9fHTYzBWVdiL/ivZ3PnfbKhKjMKs17eInTah8Peih?=
 =?us-ascii?Q?Z8oMvTEPQ4JdBiZsyURfrN5myHBoBfKa6qR8BwELJJ86Wd3gpoIdAex16B9e?=
 =?us-ascii?Q?o7M2fXOecu7jlVDTSUTPtvPmW45IGR0qZB3zzOe9LwfGaGf2J329yUHeQggN?=
 =?us-ascii?Q?SvAeKQxoUv0e54oUkCK1fbrqNSn2posU4x2TAbAMvm7wX4//iClFf5bkXXBf?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b+DfYeFReH9wa/PZGdKHmSfmK7NwzdoffO7cVKpnYZFx4iSvU0pNnk0GI78TnP4iGWousdpMAGdM3SoAV1DT8a6DgrUKNCIWQPJXO1XcTpK3eqNo2uZtLz9gA1T5bMPk6ZH8vv2PA/yorJ7lMYvqmRJ4AT/P/d8wRMQ+aCYENqc1Lb5NqBWI2t6w6xJWgGqJtCxx87bx5HUckDnaCeieyr24yDE/bPEWKoyCUDxbyA/ENBJL/U3kGcFtRTxupna67W2DJa7Kkx2LWFn1JYqgvcqO5Yr/wqvikIUdTsirKBlFPbTGmJM7G4k20LL129pIncRkvNUKLeq9YIrOnH+Mh6WJyOXyn2OaVAHbxdv8HUviHjeSkUexcmdOhnfKkasjH6J/dsLHjlGEjOYfJOI7Hn4J4YZ+T07Kx/5W5DDymuLzOBcld/1IBuIHgV0+gZw/3oAZCKnd3R8KcIokD8pKV5ETKUwrmx57WvGJWVWqOsrtSCemQ83qX44T2CMWKKgSI+V1MBUsViMshiz1afmLi2Inl6hRC07uGxfbn1w3Ir8qgQmN9kYREDrvwi5ijbVmXMOPZ6zrKy0is20iuW0pulGuoL8DhyWwmn62VmVPh0k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d04510-92ab-4349-4ed4-08dd553deb51
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 01:44:18.7085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 21ZVdn2rsYZiDPRn4ZO5QcuTASRW/mfvLI4GqWaCxnQqYW5dkN1+avmlCWKHQONjHqAZU8LkK1WyMAeVtIgxfkcD0jFh3NgmuP2VOd2ItPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6502
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_12,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxlogscore=890 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502250010
X-Proofpoint-GUID: SaeToV89xRCJIK3mVYVY5eVHXtv8nkuX
X-Proofpoint-ORIG-GUID: SaeToV89xRCJIK3mVYVY5eVHXtv8nkuX


Hi Kai!

> The command definitions in scsi_debug are common to all devices.

RSOC allows the device to report which fields in a given command are
valid (identified as "Usage data" below).

# sg_opcodes -o 0x8 /dev/sda

  Opcode=0x08
  Command_name: Read(6)
  Command is supported [conforming to SCSI standard]
  No command duration limit mode page
  Multiple Logical Units (MLU): not reported
  Usage data: 08 ff ff ff ff c7

SBC Read(6) and an SSC Read(6) don't have the exact same fields. And
consequently RSOC won't return the correct usage data for Read(6) in
tape mode. CDB byte 1 for tape should be 0x3 (SILI|FIXED) not 0xff
(Which I actually think is a bug, it should be 0x1f for SBC Read(6)
since bits 5-7 are reserved)).

Anyway. It's purely cosmetic. Nothing depends on this in practice, I
don't think.

-- 
Martin K. Petersen	Oracle Linux Engineering
