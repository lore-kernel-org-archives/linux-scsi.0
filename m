Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E2F2DF707
	for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2025 01:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758073420; cv=fail; b=Nt6EPUM604jrNe3p2Vj89Te4uz+j1eX/34/pl/dHnGvQpBda8j/XB5Krv9frozLuQMxV+jmQJ+cZriSW6V1zEEG1R+c1P8eXJUpiytubbPFTpOttZ+JcTqN7ltJqmkzn6otv8oQlyehU3pdlFLGfnCiLXUwyhFwd3J5GHSCcW1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758073420; c=relaxed/simple;
	bh=8XkULz/JNgLdWg4mwiUVviim0+TclR1RZSgeotVcULM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BeYpwnSjmdUXt18IumrImx1ur40aGDlKO7zO0CE00nYvlUqQYxwvDnsHt1V7VE4FCNu8y8GonsemtSJnUOCZLEYIw+AZE7vGF3yMjihJ3fiGocJkTOSJZAMS40QfMGTc0LT53LL5LJEJ0fECG3Y/pA3kc5clr7ZJMGlfYCIHZPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j0rABucV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qUrhhqoF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j0rABucV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qUrhhqoF"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GLYw9q032006;
	Wed, 17 Sep 2025 01:43:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Kib48iCfQlRkDOI9Bv
	w2IGj8q86ERBs0+qFr0S04YRA=; b=j0rABucVchAQt9XuVEf/ioywhk06HdLfqW
	DUQC5E1tMcV2uJH9zZmyk7J65zvnWAFsKi8pYbuAkSovuj6YXFemJF0mky9IvvvI
	KAcd70Zo5GxRwO3rWs7EcJce1rxeo1fCM9X8A4uMURykxQys+KHyPAO9Ev7eFXQw
	ZyHPxPt9xM3h7yk2b7AB3iABcdcYRAmYKYqNyMKdzRbzTo/jcMMUD5V/zJTam8RT
	Q6+jsFyI2e2vF89Dfy7Rw2g58l6+nOpnzFROWx/R+mdoeGTABdQ6rxZIslLYAV1H
	kR8b0YHz5/KK3/c0AjV6SWfJ0d+xhdUReSlbcMsIiLzPz87LXywQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxb082w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 01:43:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58H0UFfc001525;
	Wed, 17 Sep 2025 01:43:20 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011003.outbound.protection.outlook.com [52.101.62.3])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dcd1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 01:43:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OAwO24pqbDLEzqcA3vnfu5cSRl5xIlcCbn6/VaWnl4wgqpz/lU4JcX9HADalwNYf5arRk1pMaaXoq96sN/wm+LSbpkdXljOpDEy8JVRHJdl+i7FP/XCJU6JPnwD/Bn53c8TEZTL8GIRZ+c524C9S4ptEzmtbEoRBWC6cvYyh5xCcidncaOctmb82hSUPWAw1e2fIKui3KLR8uOc1k+1/kBYVjV4Yc9vV52C5uxUgYXhPZplKFoCHK510gWx55/bQx97b9VXES9b7SSCxgbTuBE/QpJ0IfAYOoCzOLLGNWc2ldO3/mNInKuP80NdNo8Z1ae9qqTIYkoCzdjygbNb9fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kib48iCfQlRkDOI9Bvw2IGj8q86ERBs0+qFr0S04YRA=;
 b=Xbw2tbpIQo/p05NaSNn2wPwkeYQgNmj5Yi1cyd8E0OIf4ZLZszT0SNa8AODUfXxKkxzjfwm/5gaqg3Fs94KMfyAXznn2iZ5wKqNIMwtm84YKWusptt2enwnrOWkVi2jtZN1+zNKTXkAlQK18FE9zWdo0i9oRGf5V/18K0XHLaxnZnDitBO5WIVo0pCkEXP6+tLhAIHVPjKBLOkEqIrSk5/g/fLW/gdQKxUuhdZ7ouviI+m9pcZX9Kk2v2DYp9pBugL1VSl/Ny0pxvM0zj94vwKeRDOHgxfXSh993bRsM8nCl4upTX0+5F+jeAQjiXviLg0OGZMz0oNTlNqBDTRhxjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kib48iCfQlRkDOI9Bvw2IGj8q86ERBs0+qFr0S04YRA=;
 b=qUrhhqoFRN9UU7rEErA8J5JZkdBFXXDqrtJn8gSy19U7aOqjL32wNBeMxt/epkuzzkp7Ii2R+CqTmN+c+5PXjQiHlqeOFh/IOaJpMriPNornBbH6c0y4+2sqqXl4GG3/+bAjPoyWaqTrWYNIE+d/y/hBUt+UVylA3AK+9/POUgc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB7538.namprd10.prod.outlook.com (2603:10b6:208:44b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 17 Sep
 2025 01:43:03 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 01:43:02 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@sandisk.com>, Bean
 Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Manish Pandey
 <quic_mapa@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: Re: [PATCH] ufs: core: Disable timestamp functionality if not
 supported
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250909190614.3531435-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 9 Sep 2025 12:06:07 -0700")
Organization: Oracle Corporation
Message-ID: <yq18qidzwf9.fsf@ca-mkp.ca.oracle.com>
References: <20250909190614.3531435-1-bvanassche@acm.org>
Date: Tue, 16 Sep 2025 21:43:00 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0073.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB7538:EE_
X-MS-Office365-Filtering-Correlation-Id: cc7619d6-fec6-414e-7baa-08ddf58b8a53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?po+e0toNP8dMa9uCgoFxK5Gx2fM4lhuyrmySU1XtFUSm85fGON0F01piyRhx?=
 =?us-ascii?Q?xJVjF0MGd92jQ3sU+CsvN2mRRnskHPZhuuK3FLzSnMTB+cD1pcqz1Gv7uJCl?=
 =?us-ascii?Q?Jrno8aD4ofc0WMu15eulpnpyrCq4+qBCvGrWy5x74CwuYb93c/7gUulCPKwu?=
 =?us-ascii?Q?ARUXHt+IkMwON3tsexSbwMHgL8WPGjS1uwju6xVorm8ibpJi9z4PcD77HMaq?=
 =?us-ascii?Q?fG83kQbDnzrvEYvttzfh22FJsA8wWrMesrSW4u6y36x8AY1yK9JFw7sWEHw9?=
 =?us-ascii?Q?iun+HN1eKDvl8q+A5PnSIdC8nhcMSSf/bqfmwogW8a/ehjbjFE2rZSuQxozK?=
 =?us-ascii?Q?Dd76yHHHTyvm45SmaEplPprg+HNqEzF6ELnrjA6fiveeJ5N5bkjhOsvg/TjS?=
 =?us-ascii?Q?gPwRXN7/nDAYiYvRQuYkVd2+d2xtPNTy3kFsvE+Il/GMyItqjVYqCTzjb5nV?=
 =?us-ascii?Q?/gJb1XOmlyGl9qcpXdHsdMhbECq4G5+SviYtuzmt9zqmdBB0UisVyiC8jY8b?=
 =?us-ascii?Q?OKIWDzM+nre8acSRngivgySMmAMe1bjFHqIV8DrOjYuxB1ZaDnuIf7TCbSIZ?=
 =?us-ascii?Q?yK4vSy362hMVPriPlRv5+DmL3EQuZo8DHLwhlBY01JWODnFWS6k9QlpiDv0x?=
 =?us-ascii?Q?USxT5CwD/Z/YLG7SgLWL5Tcvo6cZT64+HSi/0GAJ1DzFHy9K1IlGMNCflr1e?=
 =?us-ascii?Q?x0KWyALHmfQGb7aVRTjCSjYgLT3FF5cIIRQFYMsXiGtZx3OvUiMgoae44Yb2?=
 =?us-ascii?Q?zEWOjv/hhjzdL6JFkn5OysNsXORhiRZ/5ZsTPWJfUKSAscbQtcuABiyc/aCB?=
 =?us-ascii?Q?sJIqGsW0tuTbvNyRW3cMArRZ2gr3dMTLKy9RIxri3F01pTD/rAthfoKrthCB?=
 =?us-ascii?Q?ny5ITHLTyDWWycCa5N5kUcAXiIebbOM+TW+ZgnCEus6aeRzxyUsoBeKjlpnu?=
 =?us-ascii?Q?ov6XrgDXvETMbJGby5FqV/nVMosa020i5BjUI4AYhineO/G6+25XByWEhEBG?=
 =?us-ascii?Q?7EuoCrkqr9XHdf6V5OKPsPS2/CLM63R+uRdgosRTbpGFVFP8bQB8+EibFg02?=
 =?us-ascii?Q?MWIVLqK5aCg8Vopp4Xdu9cseEibRp8LFJLu1y+2vouMesrUwl+sNTu5rH9cw?=
 =?us-ascii?Q?jM6jH5O85AX9amd3w9ZwTEsA2Bb8FyXwM5IYKqWLw+vpblKXj9P2bVt1U1Ky?=
 =?us-ascii?Q?Rf3dxMr2sb9+2D0GJmWzFyo8hFfs7qjDUxeZ2C50EWL+8jug/HVejN3widGf?=
 =?us-ascii?Q?XH9okman+o7RnFtDUO8HGBUtG+EsnqcJ0L9ZqEjKs6zznnTHUumexyBv9iEz?=
 =?us-ascii?Q?y9Nrr68Jc+sPaVDKF0QoiK1TJ/5rm44Ipucw3RPgtFjcoL6Xshzl6CLdfLnU?=
 =?us-ascii?Q?6P6rdLJXUWsjl7j9fE4pZU0eO/s+nqDF3/9KQqHGx820iqf4CWv2SsaWsz9T?=
 =?us-ascii?Q?eTv8AXmBpgY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gyFLjzYEVKT1YD9QAsAP6LRMNUYpYQhjZHoDo2B5f7OUIq279kRBos3JYGpT?=
 =?us-ascii?Q?+/3AczpB3Nlljx7+qtWxl/kg1CJeYtoQz2LARifPSXhUhbSvnpYZ1p0V10j4?=
 =?us-ascii?Q?OdBeVEsAgOvyEvv9kVHNrourFuLSGCC44y3PcLe3zdTDdHsvhNLLJROGgS1m?=
 =?us-ascii?Q?yK4zG0m3DRLizOMrgJ6ro2tbbuHLlCDzN08AURwAzAErL1Z4mgwfmSwfiZx7?=
 =?us-ascii?Q?OHgvV52M9XfCBcsXvgvAHleykMhgMPAsblR2gtmC+bJC3fC85X0hGg3RUzdm?=
 =?us-ascii?Q?JPK31XxRhNsJ7f3zVsRQKg944Cw3C9aE2Mzl9J64dyMh9b6a5ipEIDSLEG0i?=
 =?us-ascii?Q?cQSO0+QQX2aBqSjvb78FknimYPote0xkfkhlTkHCTRpVxILX/NhwRWt02dhW?=
 =?us-ascii?Q?Kx+zlBC7DOhysQUbT6/ucCO8wMC6u9Z9Ydoq5ve8wFoq4isF1ZMQtRg5Cqvm?=
 =?us-ascii?Q?eTp4BENckINPaImIeFjUb32S9f2jwT8FkLqS5pru/BzhKs6viYWucDyiSDDD?=
 =?us-ascii?Q?0CI5SEaXK1+NThpuRtQ9l3GW0pKR/PiSfgOgCw7uS3+qFq30um9wuymSm6SN?=
 =?us-ascii?Q?HSr0nXbAfLKAjtBhbo1M/BizK07tLYSfWVhyQv+y4N/5V1sz+OVDNVnH8fUy?=
 =?us-ascii?Q?AP7vxQblzPBc4ts/lbd04kY5PRbF2IZoK8GW+/7JhEnauyaYTWSazEsYBHW9?=
 =?us-ascii?Q?NMaXbsUIok4TtY+XgZU1v/Mx86tUW5HaVuAErJ9/CPrM6RZlmjASnf+8Rsaw?=
 =?us-ascii?Q?VA6TuaUqc6swTQiEwx/2cj7y3f4GjqCQC895nBXVXeOjD3qFsC2baDAbw+Sw?=
 =?us-ascii?Q?ytrA8+V352Hn8qjU8CuNzrb1MZlPmf3Ltvcn3c/yGnDnL4MhsKkToJ86K8eL?=
 =?us-ascii?Q?WlMAcRx4+y7yWdEPwbJ3TNHNX9aSHVMxjk9VRUZ9N57lSuR+XJtDBv3/517f?=
 =?us-ascii?Q?Z3+LIAp8tjAzumXW8hQy6GrFDn/esHj2rV4JsWgF7jpD3pyndlVAIOFKXMyb?=
 =?us-ascii?Q?pigM7xGCTsxDoZ30lM1ChHKXRxpJhYuxDnse/rXVuzzVdnKdpzCLZrvoaYhL?=
 =?us-ascii?Q?/hKJDNkqF41ucPElFWRTdpXESQ5lBOG7wIjbE/P/fD3KtrV4+POx66ZJ6o59?=
 =?us-ascii?Q?NktztdhVzzg/iSvRAgTk8xa5RhJtiB7s29ii1NgQr75LOiaNFKw9CR4bpsBe?=
 =?us-ascii?Q?sjeG76YBJMjIn3ipGBtY7LBcvj4l4jBpS9TEZyqzYTivTJmbUEJGea1HiGEn?=
 =?us-ascii?Q?00ovpYMEb8nLvuLi8xiDe+PlPWXND1QpuLmC7LX81Gd6mXVjF7UYS52qZJ+P?=
 =?us-ascii?Q?slY7PIzVCTiqd43VXbr3V/mSDUAG5+YoNVRrgZQ2eX6hVN0/o6KOxdu/Q0bF?=
 =?us-ascii?Q?dslpQ7r1q1o+ip1/bnN95rQE9wNWDB+5NjPEKNoAFUm50ch65AZNNb/LajVF?=
 =?us-ascii?Q?7COYm0CLH+h8C7RH9Y51qDI5NOZfY91pYNd9GWD9gQuq3q46qFs+A50nsngD?=
 =?us-ascii?Q?4muQy38ROgB29NhLRmk1YWgp4Eb0mNNq1KH7EYBoPil5SpjXT6Tb+0kDa+vJ?=
 =?us-ascii?Q?6lriYXpgEtA2ynD5Krl2nt75c4zY+nBBf9t4kKQXJOReWURDWXbgltI65utI?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HGqakVXusS/s5picjXGZSEyahDhVd0Yr7+PlXke+/VlxylxT9adbh+o061iO8Dj32pGSBGeOsAsuP1zkoBhIkx6Bn53A9v6rEOrvSMr2/2BKILfO/8r/I/eW6T+U3gQmTdKPJ920K3+Xlpy6ltmsBfSq43Vbn21UIIeKlqJt5b2NoRHVLCchxR5hwwabJ36Ng+aEgTTCcRg0CYSMFilzRBztioQRYXrXh69YRSEvoHamNAsYhzm3Wcfhke/UU6dG+FO81Mnbz27yJiPZXZnph3Nkg0QqjpxOLza5KnLD9mUJwuoTPShuIUN8GfHksopXI8Jd1efjBdEG3G950WgZX76HA9/HZ7MTrZbqhr9Ty+N2gzDQkFZo2MADJh+JIR0Oh/wnHOeQoBkAj7zvCmiMg+Lk7qFEcYws2Y6ZZYoQNBHBt1dwS9LwGZCQj8U0B7xxaELuxtxawZ7bXE7GvAJ2toRQf5Ii60k1+2421SEqF3ozxVTHWQgQcr/x3SSqD0R2iRu5InXHSlFBbwU38FZ99tBfLhKvR+ocDJOmNZ5JMAoUTY6FYz1YDc37KrA4sB5zdVzi3i0lJjpZlfZUlEELpv6oWNVmMv2PhwNaxGHKjRo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7619d6-fec6-414e-7baa-08ddf58b8a53
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 01:43:02.7810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +N+uz9tk5jDSGMXYKquCjjoVhCdq5k3rVklHTMNiqIPV0VG/s6l/UFSJ3kBvu8C1jD+aNJI1PI20GoAFESVhMkYe32xToyNzZ5nbRMHUOfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7538
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-16_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=848 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509170015
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX/hiWdIalCqG9
 H2aYFtKx9ikXtnnaZEmMxeMDVIaxqbyENhDpZL+ZhuOPoVni4zqC9GKJAtyZipzMaP37jeLG/Hk
 dpV4QHvRxNszdpvS2xEIPOAaeFUxUfhLPoV0S4LH3DU5PpbZ/QvHV5jvJ1GxIwlrF9aee2Po1LM
 nLAkCXNQwKZ/2D3rfU66mDaNZloOjKtAPwkyMBbKQASqP3rc+u6uBVuf+kuiMPlOSAdzN1BNHQK
 hywTYijXy6sV/5iJuN+i8tie3+CgkP70AFCfNtEmfXt9D+B4Fsqe1Xm94v42/g7yA4rpGM2M4Tp
 giQSHcBBwjMohxvDENEBboz2pnirwh+Cd5lKXigXptJGyUsdKufGolIqfOqp8cEsVot+6ybz5o8
 OazhxYNm
X-Authority-Analysis: v=2.4 cv=KOJaDEFo c=1 sm=1 tr=0 ts=68ca1239 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-GUID: uzEL5eI63862h4m_23FXDQJyBYIOvMzg
X-Proofpoint-ORIG-GUID: uzEL5eI63862h4m_23FXDQJyBYIOvMzg


Bart,

> Some Kioxia UFS 4 devices do not support the qTimestamp attribute. Set
> the UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT for these devices such that
> no error messages appear in the kernel log about failures to set the
> qTimestamp attribute.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
