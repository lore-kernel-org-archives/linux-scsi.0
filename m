Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC9B214A82
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2025 23:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736550486; cv=fail; b=FE4xt/tL4wZ+VnPRZxELdpSRcV1po79vB5HerdmbD2B1XrhR12tL/DZ/uqYZ5bGAihtwgxPyvVe0ET02FiGZ0RIfHNr7LORWHLhWT3jyc7Mw0M1gB5sPCrwvwxxVqKXEACk1D7bW2VckL4bwSLsFsDBBPfU47NENvX78ciWvysw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736550486; c=relaxed/simple;
	bh=iXjhF71m2ALytX155w5uQy18cYix2IL1HUa4lfJvKj8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=WmKtxNB2YQmywl1ejV62mKM1q61c6pQ7QeQ1rkouTMTsM9zcluDsc3DFrFWDo7BrUPDOADpNZie80jCNDKf2UE8h/HYvSGVsTm4NukWkOO30fQZeEqeosdTTbMSM+17NH95YDnG+sYTqLTO/YzetMJiccPkYl7Lfo6dMVMCDbw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DFG2FYJl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kXxFjSDn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DFG2FYJl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kXxFjSDn"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBo0l022226;
	Fri, 10 Jan 2025 23:07:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=hNRdxGjzXHnj6iJoxP
	3gHccwDdpudjxcQx/x/IAhKfo=; b=DFG2FYJlLOsjAnwE9sogHD1wrGLBfgBVgz
	vD/g62uh2eZLNthHOQSoA5HnKHtoyz05pTOpLPZhtuaFJ8dER9hEYa475LZTEtXJ
	z6/q8LYpS2eWhL8whAYE+QV5bgzTMsjPGzIX+QoLu5J5ruUfcxCt5niMhVstLA7J
	FTboy3kpQkuS0HTiCjJiZpPFSFcHx7M1/vhq8HUq0tV6/tgL/hTuLUNfOBTupRGA
	ZTXsMkWtYOUMveKzei3CUBfabPNKm9BkItIMt9IPHYI5LuQfyprKCTGjOtKgdYj+
	BYkT2WuQ/najpVYnvq1qeCTGFm41xgSNk5ve0Sk7sfTydlDVqG0g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudcc5g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 23:07:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALc4JR019833;
	Fri, 10 Jan 2025 23:07:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuekdcet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 23:07:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cN2jTU2/3NVnKs/GVbBSdyJil4kKDcBj89KUSCS81cUqcmrwv+UYirsI5GiBOXpzLlbGKFCfWlsfM2FJe+w9B96k7mLCrTCwX8fZXWSAKFB2zE0eC0YOufg/DtmWy91paZ2bEt5wVKQbu3UAFk6DoC3JpREU4t2MgUAMWGrpJt1V+S3Dpst/SHpBEjEx9xj+TsJ/CQRXlz53B+CymGfn8w875t9q0XtEgLCVOveM8WLp5G9efRqlZIwRoa45ET5nhNww4vHKToojcmcVv6YhXUIEone0UM/BONOYY8vNWci0rzML6qWrcxpskPc8DcGNUqZ6QYd2wyQXGEkvaGyojQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hNRdxGjzXHnj6iJoxP3gHccwDdpudjxcQx/x/IAhKfo=;
 b=xj+DGnkX1f6Wt9kaoMuCFfZnLrcUAlFBUcej25Q2FGhUCun0X41N5ljXYtA55d72hKfJngQLsWk5mnnpmmqcnydlAXxRq8xhU2sryB0jLGoeP8i/m32EQOwMVFjN0MgxDrUm5PzuDjnuwm2dHTio3nxID8TT9PHBRqA+7x0INT0ZeD35iE5oVpGxGW5hDADynrSMNK3fGZTwnXire5hwrV5IP+741SDiOKN8jEBIeyPNrFtGTAfS+kTfjtNKpUj0toVu5qCeom583f4HTPa2VmA89qgc2vLeyPdgJwkd6pYNH4TTKAgL9WQ3Sd1mf5KhSmQhf9BcCQ91LsJ6DMaqBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNRdxGjzXHnj6iJoxP3gHccwDdpudjxcQx/x/IAhKfo=;
 b=kXxFjSDncPfLvPT8PRJfhj68tzofKga2mSzjxN3VsSjl2B5XjF/jhBCFiHUxPTF+IbkSG4TuTLMnTMxXnO4OpQ2ct7mfaerJqcUNPVseDEKC28JOkJvF2/qyw4Kf/ng4br0NohhPb2hB2A5GtNmh1cvn16uWoqnu1Not8ZeNhnQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4986.namprd10.prod.outlook.com (2603:10b6:610:c7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Fri, 10 Jan
 2025 23:07:45 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Fri, 10 Jan 2025
 23:07:45 +0000
To: Guixin Liu <kanie@linux.alibaba.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E . J .
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4] scsi: mpi3mr: fix possible crash when setup bsg fail
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250107022032.24006-1-kanie@linux.alibaba.com> (Guixin Liu's
	message of "Tue, 7 Jan 2025 10:20:32 +0800")
Organization: Oracle Corporation
Message-ID: <yq18qri46a4.fsf@ca-mkp.ca.oracle.com>
References: <20250107022032.24006-1-kanie@linux.alibaba.com>
Date: Fri, 10 Jan 2025 18:07:42 -0500
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0177.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4986:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ee837ca-e6c2-4ddc-ce88-08dd31cb97ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?beupnU1y50FPE8hXaATZPKiSN/7ebGT/srQERj5d8GRBn9/B6auSnWyVYD73?=
 =?us-ascii?Q?PUEkfydGtdY4n9U9U7fS5MGr9L3knWcyqqauAoY9wxJNDdgOtAlW808j3r8N?=
 =?us-ascii?Q?OdzM7BUYK0yI3M3uW3I2o18OnO4sBfengqiRpeEhxHJs/DvDiq70MPyoECD+?=
 =?us-ascii?Q?TfpOGy3uQDFYqFhjIABL3Ed+eeTW6krc7BUHKXlnwvd0Kpt6eiF/kIAePMZA?=
 =?us-ascii?Q?N3q7W2Lmb6AcppFS8RZM/qnEnslzlCPEdsa0Tof70g06U2w4JCz8m5nGCoP9?=
 =?us-ascii?Q?5Ukibr2B44KFZd58vjZ5B0oyGN9Dit1Wtk7fsXBdacpVmC7n4jg3qmiE67CU?=
 =?us-ascii?Q?/ZNdPrsS2GIvP7nPrW6OoeEA7vrYfk6YhmcYOfBGkxkq4wZgWsF3p8Jt36vo?=
 =?us-ascii?Q?LJYpddrKljXO8GEhU3wRsuqIjcUDbm/DI8thG0vgrl/V8lyEyZdoSO2DBxmT?=
 =?us-ascii?Q?9IlIkYJBRXJPhG/JSbTRBC0SMSp4ZRF2WDMvCQZNESZKG8CGQ7iX4SsA/876?=
 =?us-ascii?Q?xrS8ys50SuUMhLdCjeR+reLG+BeKJn0cWuuoAFxgSZCBwG5s7t+/f2Pujgqn?=
 =?us-ascii?Q?tCfs6GJhQ4oRpMwM6Bi8z5SM0w/H5oGBzuA8jk7kwpYeM3V+oSC2NzKwruye?=
 =?us-ascii?Q?T0EDs6R5O2+WXrMkySlg/to7QjZAsHvYLsDHV5TNrcYbeUq1DKBj86y2CDD9?=
 =?us-ascii?Q?6JRGW2ljjGtGLxqBYzKD9NXQAU/p1x+SLs4fV2y6hFlO2dN7qKYsw/wpZjY4?=
 =?us-ascii?Q?IJrXy6SJ+Hd2CIxxhQJdM2qvxnAQKNX+m3AUDH2chC7wcq+dCie2TVxDhrGr?=
 =?us-ascii?Q?Ii6rb8+f0qP2Z8lws4sc7FTVlMR8gUP+rOfAqkVgZoYEHuiUPow8CsA+mHwI?=
 =?us-ascii?Q?xYILIdlLU9GPmlCSGHnTX0dy5v/7bfm29rObhCMOZOm14VlCuOXXOIkrF0Qx?=
 =?us-ascii?Q?HzwpkIINITzeWVtULl8m0b6VESmZ+IcpPlWlWZGDwy1inXrkzhk673A4R8Kz?=
 =?us-ascii?Q?LljPwRsw3WFkDg5AeTfoBzfF9jNM4Ko2xBjoFevR7lrkuD30/dMezFO8U+1j?=
 =?us-ascii?Q?gBpk812wIYG8t3citNRqASmy4V4NE20BfkWghY+z3VLMDlHx8G6QTW7kRfN1?=
 =?us-ascii?Q?28uPM902x63T06CH+eFpUZb4ruCGz+hTt/ZimA5vqnjmd5MRUsP1VXsvteNP?=
 =?us-ascii?Q?CW3gUyjTOdbwNdQFl+yJVwlreqgUFLac+3Vfgc5uLaV+xL1p6ffCNFWd+69l?=
 =?us-ascii?Q?M0dFBHTEG+Y1KyE3cWFyp+GUt/aEaE01JqoKGgU+f5eKY5BJd4hZP4+k8ahQ?=
 =?us-ascii?Q?4d0Ele8yUxSif1/mJ3PLDPrbHp/JHdWaK0zNqavdV24mK3PDjji8vEPBwz/4?=
 =?us-ascii?Q?qvjp3PM2mlcfLHL/NiasbxdG0KKy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FnfJ4Jmg0Y4ddiODW9Qq60LCdwzjaCVm2nJE7bAxvVzrY2nlU6ebNEz75Uus?=
 =?us-ascii?Q?MfYxNfBGeA3NuyxFfjK3frWlpOtrXIoYRgq19dwchOohx3cGptIJzO0nq21j?=
 =?us-ascii?Q?m7IemcJNnHOSpdR0yr8iL6FkloacFdZckKE1yGqKJucN6YVfWzV7xa1b8cOJ?=
 =?us-ascii?Q?YPQ7M/ItTlhKQKiRXjaNWEcPLSm4AoNZeYpBQ91LY0Sgt8yWbSFngEreKeae?=
 =?us-ascii?Q?zHuSUPcyoGB+R6lvalb2eoWcuMlQTf7i6CmS4evHKRT2PS14ese1nuRK1f/D?=
 =?us-ascii?Q?MQyPvbbRTTiy+ittP8AOVIjziAT0YwZmhXGnFrhrbkxSb1rhBjJ8RSolOOAe?=
 =?us-ascii?Q?gI8vl9akvCwlS5xTG1avg6LnbfzwJCuZ7hcPq3zeoz94otEQGQ72JcW5e+yc?=
 =?us-ascii?Q?835yizVd7i6dhT/OmI6rzXLvZT2FCzreQ1orkW6WEWCwZaFuNutLasy7qg6H?=
 =?us-ascii?Q?cC5IwdtC02eEBf70/qF2ubbE+eke111aCEw7MMiQc+CC2kfVtgSJE3vcr6yB?=
 =?us-ascii?Q?tzg4W7EbTN8vSLpLrCsVA+Q0mL1UiXvo0ug5cXMTlkekjehIL6VHMdZPP+T8?=
 =?us-ascii?Q?5pEpedsZHFLbhz6GVZrnKC2MGSuEMYPahr1SUpPhcw5uKL46Ojl77vuEj9eX?=
 =?us-ascii?Q?xtnwXjUuIJ+Rv3Cp7kS2JRIKu28007LYQtHQtcpVZNyDdoeVZMVnc+Im/A9x?=
 =?us-ascii?Q?hb9wLuqLt9suAq/cKVwwQaMmSHcydEljvcP5mavmsoi3qP6kH2y7f4WuTuak?=
 =?us-ascii?Q?S5moMBDq0nFxyMXruMi3uzK88CuU8Trnxb7D2jAxdUQcYRI1IMRbNvM/yQ42?=
 =?us-ascii?Q?ZEomcrE++M6P1HeIpHVuLm4j/WhLRBdila7NS5NaIfIQGLpqYJgYvWjxqdyP?=
 =?us-ascii?Q?PcG75cgTIsrnapvNNQm6QGyLUZj8d5vGPo++g2TalYI+RcyCa4g/K4itJ7h1?=
 =?us-ascii?Q?1nu07MNZEIZDcV/UrsHay7RgAfmXTTU604C9WCO4AXuWA6NEZMpGSntABO9a?=
 =?us-ascii?Q?BaX8h2DRRvlKtJOzV0cvyl17YxJU+MMgjl26gTF3kF4ubbizA6pTuoRRF11I?=
 =?us-ascii?Q?y11jBZQIEGAcZNxH/INV2SpjG+tRs3jg4YZ/s4rO+M6ozXev3841YHJPQCq0?=
 =?us-ascii?Q?7gQNyof5c4MID4klZhmTK2uxt5V6rTrbAovhC36iotoOsITLmfph/7R7GPCf?=
 =?us-ascii?Q?UzP6VlSUX/VvI0DSFSSWSUn2sfdzvbPQL84JlWK3fI7Xl36TlZTTeASlpPik?=
 =?us-ascii?Q?qMZ/bL9/d/77E//Bj2Rikpe28tyjj1dYdJ9WepUs+t6L3J8XV+kmW9kNrDmY?=
 =?us-ascii?Q?tTOqOapyH7pGx1istcf9HGmJP5UXhP8hYgmZL0MptJgSHDhX/tgJV0fowx00?=
 =?us-ascii?Q?U9DetAGEu1rbfiM9AIBD6dx0BWxrSPk3goFVxAp0WE4DH4vLjifRjPGMNWvJ?=
 =?us-ascii?Q?cEAaKnajwQTPFWn9jDMpuNSX00cBbAsqvkWdmFCv5Qk3e+/av7ufRc1mH8cU?=
 =?us-ascii?Q?j/oUcdVjkGEtOUDF2U3NMiYxOLc/qqOHvqalbgCmyCxkLpUjKnLA0T+dHhzU?=
 =?us-ascii?Q?Pr67LOKNFW84qZWSo9C8admwKA+IDrp0+27pS2Jrkp/WIMGTZwpZAFQoUHTB?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3en5tTFNp35g08Ou7AncfKe0Dj4BqHj8xjE/FYKQcsBOWHji96Bvc5usjwJHeS9vozcK5L5SYA/dsJG+jmbr/0v8pH43PStrWgkJaZYY5JD32pJz2g80RYK2TTf8u3ACOAIUGRM9cXjgFbsdJkXMRc2pboQQ8gza5h/bgKXjeFg0mwgIChXNXQWankn+PBvYzDxRu278PAhysHnFjc9TV05fYIZ/a4ekVlNtY3u+XFPFEGlPOOlFSyt1Fttyz7xqxip3vomlw22tsqrslKQ4wXR3tiUBdqeTFUsO/I5EX2f100pEkMRuVg+tFjlD2kL+G2tfDFLkvP5yQmjKWHQ3nDxTBb0w7u1952VoUfh6GYEaOPCtguhgtGIbaIRTPm/BmYGF7DLVjPyrfO8uq+yUD1KvOW09M1dauMTgxVsyKV/BSkhYrb+IlI3XN08+TtcaA29hrNwulBGgJhh5TjmZn5Q3qiiP/Fi0IubYiLyy6Zy5Dmf4BjIHOs68Wd7S0ssvRWH0IHP3nxVCXNdjCPSeo6yfq0hSV7L3Qgt+kcH80bqawCuBm3Jgzh98g+SmPTP6hwS/DKi4tc19OIz5xvlb6GfTQk27t2FZatpvFAOlkJ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee837ca-e6c2-4ddc-ce88-08dd31cb97ac
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 23:07:45.0301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXNZk0XzJAjChVHV8/UeKIfMHw5MjAte+RY5Q22CvqUq/Q8AACQm7xQgL68O5UqYZfU0SJJ9aK83FhjRKq8xzt9ykRPuf+FaEFhg3gIvVCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4986
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_10,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=645 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100177
X-Proofpoint-ORIG-GUID: aUqbjPXswnNDlg_LE_tzfN7ONppvqGPd
X-Proofpoint-GUID: aUqbjPXswnNDlg_LE_tzfN7ONppvqGPd


Guixin,

> If bsg_setup_queue() fails, the bsg_queue is assigned a non-NULL
> value. Consequently, in mpi3mr_bsg_exit(), the condition
> "if(!mrioc->bsg_queue)" will not be satisfied, preventing execution
> from entering bsg_remove_queue(), which could lead to the following
> crash:

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
