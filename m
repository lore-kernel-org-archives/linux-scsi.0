Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18136FC0C;
	Wed, 16 Oct 2024 07:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729062986; cv=fail; b=tHtUavGcUl0XStl0VTmc0iG3j+7JDBv7qELP8/u5dIu8LP76jJL1872MD8LLY+T+LS0hnYXyM7O1IyL3nUufWFRMkH7/0RvH0RAnnw233lx1rVuYImzbZaQ4QvH9Wszi3ZbtBM9gGckhVdZq723nvvMyHSIajqfNgy9Q1A6JizI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729062986; c=relaxed/simple;
	bh=IpcgU1A4ySNzGip4sBV2P3m1LwrvlnDa4FrpRSZuS+o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JkKASmGTra7er12GS602nql/i8CwVUXyMWD7T8Zr8oYsPzpaQ5VSRozN9IYRRDWnI0xj9+Vc/UhVpJIfnHgLCjgCXr8uarpmXkNiCPImqZBpx7hizYSgxZTkYUnXBUPc/z6Uw2fqdcmYTZXkExnt7UpkyewdD2nxjttSFw33M04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QTMhwqzO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xkEbQuYC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QTMhwqzO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xkEbQuYC"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2Mg1F011182;
	Wed, 16 Oct 2024 07:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=DAuFiyKWpgAGI6aCJrSM/8cg9XkebN39k4wSBBMXxq8=; b=
	QTMhwqzO+zSjnkatrOZYTUsBKZg3HV1TXxNJJgoAHMVVo1NHuEWKZvdWlf0ExFph
	Xp83R7jlJ+6QaQesscwwTxAk6adAzpQnPuZwff3KzYcgbZB8wDhPbLyh+mAmaA7R
	hDfoYNmlO8aYsizKhxMc6nTyDerNSkmPLl2ltLIedKhK/yWlJI3ZpsBjme+JEGvY
	ZcE6zIQDiOsZpBptgXJ1KS1yRVsHXvvUyzL347PBIzq+5EUljeupbaIIcOpFYzP1
	js66oQr2J6s8cooDNBZqFvBwEyFWSzXtchx+lO0Om4OThZs7N+Hyc/bmhK43roHn
	yauRVa+wAa7XMJH2He6gEw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427hntb2y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 07:16:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G6K9bs019862;
	Wed, 16 Oct 2024 07:16:20 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj8fedt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 07:16:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BBQdhy/AqFqwPPNEUBhOqqlY92qnxR4a8uJh4EFc2u/WlJEGWGoW8EAB1IzQvKaSuRXY1MLW8A/yBi2IZKfWccVWiszgOikjvXEsW1+Aqr533YoPXWOXfLyv3mDOf59N1P0Q7XBKVcRPrEVlTELMHyYyA6snDeOEKJwpsuYk5ixy6Nnvcfv2aWQMz4zv86mtS9totKE/amgu0yQfK63FEhV5QJymnpCnD+BigDH/KTP8j7qXNN0E1jEtiIkENgeRWCHiYR/Ulj5k2QIpQtgrAVGFzDCTYDMK/Rq6qnoxVsmvHVQEOyACejdprtxAi/gNphRMEvKUjSulsrgQe2AmSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAuFiyKWpgAGI6aCJrSM/8cg9XkebN39k4wSBBMXxq8=;
 b=kuUfYnFXubXrGJ26RWTJ03IphHSJTZP+b5DL9W7IWiCQ7M0vcAIU1WPjas3IML2BhX9h6h/3LA+yWQXJa5UAMAm+dUwZCQSwxS0I9n5MOjwtNSnAnNg98LlXY9MGJexJqDif7yftjtOX1o+EsyeMb2OcXNiC3fuk4TWaH3sANJ4bgVvSr7sY9uTnVzt2bL18jK70b0/3OB63ucuErM23s4L6afmuN/PiihkPXRalMudB9pezwlhNCwrNPX7FaeyWQ+yYwDH2rTNzPD9bLfqNzqRMnC+T1W5E6gd24lX9y5tu1wMSoVcMagys4QauAs67Rrd9Qb4V4bSqFtVpk2O8zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAuFiyKWpgAGI6aCJrSM/8cg9XkebN39k4wSBBMXxq8=;
 b=xkEbQuYC/2ligAiF61mYL2j+moJWqtMPxfuK6dAWE5+VF1VKzyj6p03rQ0q/S5RuWgSgVQ+d5BdM48ee91mTfwtLt0Gf1zptB94Gi3K8GoYTdxvxwRW+z6a/nS0pnjNOspsOsHt6KS0+P2OKONnAV3c871jc7jpLj2WcoJTJLmo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM6PR10MB4298.namprd10.prod.outlook.com (2603:10b6:5:21f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 07:16:18 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 07:16:17 +0000
Message-ID: <9151ca6d-7153-4a97-aaa2-7277fc5ffa84@oracle.com>
Date: Wed, 16 Oct 2024 08:16:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: scsi_debug: remove a redundant assignment to
 variable ret
To: Dan Carpenter <dan.carpenter@linaro.org>,
        Colin Ian King <colin.i.king@gmail.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20241002135043.942327-1-colin.i.king@gmail.com>
 <2be706cc-0944-4413-b1b0-52d34fbdadf8@stanley.mountain>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <2be706cc-0944-4413-b1b0-52d34fbdadf8@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0435.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM6PR10MB4298:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a7f983e-2833-4d8e-ab6f-08dcedb26d82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RXV1TFc2bnZlRFVjaXpuSkswalE1UHBUTlArODAyWFpOQjZOZVJ0Q1JjNVVF?=
 =?utf-8?B?RWRQQWI1Rkl6UmpncFcxNk10am5MUmtzdzRrNWlsVnRVeTNhcUtjRVVjNUNQ?=
 =?utf-8?B?bWdrdElJZnFQQkIxcVJFQ1RyNTNFcENTMDhtb2hrNWppV2lIMVhEdHVESmM5?=
 =?utf-8?B?ZHA4VFcrcCt0ejNvZWU3M3E0RW04WWlabUkxZndkNnhQOVJBR3U4cmVpQzBM?=
 =?utf-8?B?bHQ1OVRDWVhqSTV2R3E1SXovVXVxR1V2a0lwZ05ZZEVzdHRjNUlsK292QnZC?=
 =?utf-8?B?azJ3SFplMjRKaCs0K3RiaWN2U2szSFk5MHhVZDNKTTNuaVZ3S2ZhYXVncElL?=
 =?utf-8?B?eDRhR3lsZGU2MTZFaE1oQXY4N1lMYWhESEx2L1dlR0dxUVJIeHJaZVRqR3Ba?=
 =?utf-8?B?ZjJxVXo5WlgyVDZqRTFNN3piVDdEZHh4V0xNV25Ka0dEYWd6NUwvNUwvZE54?=
 =?utf-8?B?bVNPSkVWVEg5aUNyTk5YeEw4TytzRmR4R2xSanRjbktwV05HLzAwL2ZVSU5a?=
 =?utf-8?B?TjR2Rld2NVNEUFcrMUJSSHRNMGRMaEJFYWhUQW00R054dkZnc1Zhci84Z1pZ?=
 =?utf-8?B?VVo2MksySEl4R2hTMTFuMnNlMjYwR0Foc1FldkFlRitQbnZDdDdVYVRQdC9R?=
 =?utf-8?B?a2l6SUxNS2cwTnAxVGU1RWZ6K0Z5bktSc09RYVB3SUNEYmxrQUgwaTRQNGdo?=
 =?utf-8?B?eWVScmxKK0J1OVJwSVIzaXRMeG5BOHJkWFV3ZUpoamU4ci9vcjFDNnZPSDAz?=
 =?utf-8?B?RlNRVGMrR0ExWjJkeENqZThDbFl6N2VXTjVUL2NIRUJweG0yN1BOSXJXbFVw?=
 =?utf-8?B?SXpzUDZmellSWEJoNHMrSWdIODVLWnpIcU9RUUR1UFRjVFRiSlo3Yk1oRWJJ?=
 =?utf-8?B?Tzh0WThGcU9QQlp5ODhOUkNoSkJnWjZFYVFJeVNOTGt5YXM0YVBNemhuYklK?=
 =?utf-8?B?blcwaXFaRG80V25nZWxoVXIzWVNOMmtaZVlIcHVjOENDbGVSZUZhWXgwRUM2?=
 =?utf-8?B?UjlhMGl1MFRnREpXWUg5WnlaOVJpa0dkQkxERm1OUko4bHp0VXNkYzhROFZN?=
 =?utf-8?B?VEtORkRiVWgxdWZmbStUWXNWS2NtOWltYXRhNXpZTnROdDN0NFg3WEJkTmZK?=
 =?utf-8?B?YjIyU2R5Q0ZiRXpNeGJuc21NTmp1alBCTURSdG4yMm0wYUtDMjhyeDZSUFVW?=
 =?utf-8?B?S2hOYlI3L2M0U3Z3dVltV3RtSHo3U2ZtOWtPbUdvTVFQOWg2bGp3MHpGcmNH?=
 =?utf-8?B?aEVvYnpaMTFQTGVzd1Exbk9MS2tFUVpJY25Td3NQbGlRUDlXMHZKREJhUmVa?=
 =?utf-8?B?V3UzbFQrdEplTTkyTDlqT3puWWhLcVlucjNCU3FwRDJEcFlLa3dYNVlSc1ZK?=
 =?utf-8?B?elpRNFVBaEFGM3NwVWRsa3I5Wmw4bnNuSXV0N21OR0EwSkdaTFM2R1BWdW9p?=
 =?utf-8?B?YS8xSnBiaE5jRzd3Tnl5TlhoaFlkVk1LYStWZWN1bWVFdUg0K3p6V1UvaFRF?=
 =?utf-8?B?VHhmUXV3K3dTT09Vc05DZUF4U0FCVGF3dkkzbFNOMndWUG1xcjZ5cmttVTli?=
 =?utf-8?B?b0RDZkFROXpubnlNTnF0UENLdGIyZEhja3lueEoxZmViaVFHWnVJMXFUbFhR?=
 =?utf-8?B?ellQNmpCYk1NM3hINWtHUjAyODQ5dWx1SWRjcmRuT1V2SlFhSTg3N2pVYlBw?=
 =?utf-8?B?dlBsVEUydXFXK3diM0tnL3RKWjgxQmcrQjlSM1RDWXF1ajZnQkFsckVRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0labzhieTBpUU1oNzN2SGM4dUxVdmNrT21vZEhQRUROeGM5QVlsWm9GT0RS?=
 =?utf-8?B?cUt2VmFQa0JlYVZoVGVldzdwdFZMWTZHeTY1MWxXUVFsb0kweE15TEtaYkox?=
 =?utf-8?B?Y1FxdmtxMkh0QkNSZmNlWTVwbW15TE9MWnNLdi9xcVovcmJ2QVVrZ3R0UHkx?=
 =?utf-8?B?VTg2T3lVQ0pXNHhOa3o1djY4TnhKRFdmbDJ6VUNnY0hlZ0krcEtFSXJZSzBE?=
 =?utf-8?B?eFVEZVhlaTRtUW5wNTRrTTgya1lIam1IQzF2QW1MRFRZbFJUSHg4OEdVYUxV?=
 =?utf-8?B?QytjNDZieC9EM0szamdQQzdWL0ZjZmR2VEhQR2wwY3QwcXZGaVA4dklIWUpZ?=
 =?utf-8?B?SkthYmszaG03dHlBSnFBSTlGNTEyTDJsbkhTSHk2aG5lWDVtT3k3azRwUTRR?=
 =?utf-8?B?dlpFN0FDWVRxTDNpZ2tGTXgvNm1vZWFOVUV3aXBrT0E5VUpzY1BNbzE0OGoz?=
 =?utf-8?B?Yml2QlZtbTdVNm9GQ2RITFpxLytZWDM3bysreXkwejVRZFpON3QyelRkMHds?=
 =?utf-8?B?azBWYlhHZ3MxUUc0ZGRoT3lXUFNvUVQ0amxkNjIxcUVyNFJOSVg0Q1VKN0dF?=
 =?utf-8?B?T3JDVmpPdHRmRkhGVDU2dzhiYkJLZ3htaHcvdzVpVVRrQi9sbDhjOWRCa0tz?=
 =?utf-8?B?ZjdET2tST3VXc0xFSmt2cUJ4UE5HRUpWZ2FWR3c5c0pyOHVPTEVFSEdXbWs2?=
 =?utf-8?B?K2N3c2cxQ1hVd1Iva2g1NWJGN2R2L3k2WDUzTTEzSCtKV1N3YjVZQ2dmOCtx?=
 =?utf-8?B?QUxMaDlGNjJtR2g0ZDRKV05KU1pRTEdGR3FyeTUxMmNCL0ZNcTlqSUV2aER1?=
 =?utf-8?B?S0pwdytOQ0R1V3FmbFZ3dStxQW1ZUnhISGJ1ZDR4UW14YklKR1A4eDZTQjFH?=
 =?utf-8?B?NWU0MVNPTGRDLzMzd01BZkh5aitmY3kwb29XK2E5K3RwRGFIeHo0L3pNVE5n?=
 =?utf-8?B?Rzc5OWY2ZmZrQ1hWL1MrKzB6aHR2NTNNWU1UMHpXMnRyenhSdXI0SHRMKys3?=
 =?utf-8?B?SDBQTHZxSGRMT21YWnRlTU5hQWFhRUlIMjNyMG5Hb2F4eXJyN05hR2lBVC9s?=
 =?utf-8?B?dCtadk5LY2dMNXJFT2FJSWkxYmhnNXd6M3Z5Vm1maGlHejNDRm95a0U1RElp?=
 =?utf-8?B?THJ5eEFtSHE0dnJydkZ1UW9vSkZPV1RDR2QxWDBJZFJ3YUoxUWNzdXpBaFJO?=
 =?utf-8?B?czRKREhGbVRHSjE4RVFSVTNpMzE2VW5vRThIWEpJZE9iVDNuVXRyeDlicVVE?=
 =?utf-8?B?S1RBQXRsZzBUZHlOOEsvVHZ3MVA0YTdjUVd2NmlRNHBKNW14clFZcE1CSTVB?=
 =?utf-8?B?dnpFb2VKNXM5VG1xRDBEeGRBbHpZdmNCanpid1JQdEg3S1hxSjVFVjdRaDlv?=
 =?utf-8?B?U1RBMjhWN2tlcEJjS2VQSE5wTElyZGhrWjQ5RmhTTElFTXRneGt2Z1RmNWx3?=
 =?utf-8?B?VkdZdmw4R3Y0NnRNZWVHYnFlamVyZlArQ3MybnRRSDBLd2krdTVIMUFlcWxP?=
 =?utf-8?B?TzRxUis4USt1VXphWjg0NERNSnU1cTQzTk5yc1ZEdVFjT1NMN2tLNEpoa2NQ?=
 =?utf-8?B?NUpxQVZiWHFpZzZqTnQ0NVNCSS9tbHZSc2NqM1lSenRZTjEwN25MSG5zc2p5?=
 =?utf-8?B?VGtzSngrVTE2YVc1WEZsNXNUazFrTkNsT3BxcUxqS2JSMERxS01TVHltZmNZ?=
 =?utf-8?B?cFBuc0FMbWRrZGIzOWNLM3YxT09TdDdoL0FnZHk0QU4rUzdEUWpsbytVM1Bt?=
 =?utf-8?B?aDR0VlM3NTd3eFRVZ1FUdlpNdUowbFRFb0JMd1NRQXlrSUM2MFpUOW1HbGZo?=
 =?utf-8?B?Ym9sWkV1NDBMVVRaNm5wUUxHZU1YMDI0SzFRWEZBSWJUR28wNU93Q0cvZ3la?=
 =?utf-8?B?OE1lTzdJL1cxa3dyWENsOWt0T2ptRXE3MmZUSnAxTklUTW5UdUZOYUhWTUow?=
 =?utf-8?B?U2dQWWVMVXpFZEpRWitvWnVpREc2Tk9McHF6UEpUSDVvU3dIOWFadWh2U3Iz?=
 =?utf-8?B?S1Z0YW9hSmt1Wld3ZDNsa1RkNldRSHFleDBCUlFCaWVCNjhwUkJCYTNvNUxn?=
 =?utf-8?B?VGl2NzRzMy9jc01zNzlCaHVUL1dQVG92WDJkL2pnaXR5RU5mYkdscVFvUFR1?=
 =?utf-8?B?bkJoY2NGdnMzMjNJTXQ2RUhRMk13K1gycVdOa3R6NHg5M292eVQwck13SCtG?=
 =?utf-8?B?bWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	USePv2unew4v6IyIfKRtT9vU8WSbT/1BAuMTN7ZwcmtlgO85qJFN6CIyLuy4aS+kA2JwvhI33hg57fMlmn22cu+13Qc4kguEkyEdRe0l+v/DZV8767OP7HTu1/T2yjCaTtL2xaFAORQ9GN8ANXpCHikktaYWbK9UG2Kqto/AYn4Tv3qhog+AEOIPhcKmiVLEG//b162I/F8YkYHIv3ZDhHYlHoM7CiuNbEKY2ABy1YlbH+2ey6x//+K8t+Q9WGhcnEKizRTMuXKQv6TfKmKrJCwNe0x3qP9sFCe9UbHlwOUmdXF2qQd9dah3ZtEwwGl0p0OFVin5FeVCML9U/v6dqbeV5r74rGyif2LhOvxgER9OSrXpWwoCyfI81UObfAhboEuVWLKxZDVKEXuUVQcFimh8SvV2jlf4FUCRO3VxB5N9aZoNePoMq39JSDrKFMFrhY2/BXHDQhuB12tgBk2QKCmk0bvsA1CJ5/UJCJd5p0RXlpJgrq+OjU+PFGHucnrq+sbHh4oMC7PoH0l61bOnOZtRXFz2VY6t7fK5o7CMoOIH8OPhwlJZVJvrq5dQ+O7YvbzjDJguHmyR2cU2BdNZuiCL4quK/Z1yyG6g/YnWARA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7f983e-2833-4d8e-ab6f-08dcedb26d82
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 07:16:17.9313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvLIiXlJnj5CwiNT/JS9jBFgg6LhY61WyZ0sO2M1G4cQrJyHFVZVX+0ru4/qBeIhe071whOZWgqCu1j1HHjDQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-16_05,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160047
X-Proofpoint-ORIG-GUID: 716db_JPhCNYS1sqOj3eqxiRiGAswadw
X-Proofpoint-GUID: 716db_JPhCNYS1sqOj3eqxiRiGAswadw

On 02/10/2024 16:10, Dan Carpenter wrote:
> On Wed, Oct 02, 2024 at 02:50:43PM +0100, Colin Ian King wrote:
>> The variable ret is being assigned a value that is never read, the
>> following break statement exits the loop where ret is being re-assigned
>> a new value. Remove the redundant assignment.
>>
>> Signed-off-by: Colin Ian King<colin.i.king@gmail.com>
>> ---
>>   drivers/scsi/scsi_debug.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index d95f417e24c0..7c60f5acc4a3 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -3686,14 +3686,12 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
>>   		sdeb_data_sector_lock(sip, do_write);
>>   		ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
> You would think there would be a:
> 
> 	total += ret;
> 
> here.
> 
>>   		   fsp + (block * sdebug_sector_size),
>>   		   sdebug_sector_size, sg_skip, do_write);T
>>   		sdeb_data_sector_unlock(sip, do_write);
>> -		if (ret != sdebug_sector_size) {
>> -			ret += (i * sdebug_sector_size);
>> +		if (ret != sdebug_sector_size)
>>   			break;
>> -		}
>>   		sg_skip += sdebug_sector_size;
>>   		if (++block >= sdebug_store_sectors)
>>   			block = 0;
>>   	}
>>   	ret = num * sdebug_sector_size;
>          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> And that this would be a "return total;"

Right, the function is currently a little messy as there is no variable 
for "total", and we re-assign ret per loop.

So I think that we can either:
a. introduce a variable to hold "total"
b. this change:

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index af5e3a7f47a9..39218ffc6a31 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3690,13 +3690,14 @@ static int do_device_access(struct
sdeb_store_info *sip, struct scsi_cmnd *scp,
                sdeb_data_sector_unlock(sip, do_write);
                if (ret != sdebug_sector_size) {
                        ret += (i * sdebug_sector_size);
-                       break;
+                       goto out_unlock;
                }
                sg_skip += sdebug_sector_size;
                if (++block >= sdebug_store_sectors)
                        block = 0;
        }
        ret = num * sdebug_sector_size;
+out_unlock:
        sdeb_data_unlock(sip, atomic);


Maybe a. is better, as b. is maintaining some messiness.

Thanks,
John

> 
> The comment at the start of the function says that it's supposed to return the
> actual number of bytes that were copied.  And you can see how that was the
> intention.
> 
> But what it actually does is it always reports that it copied the complete
> number of bytes.  #Success #Woohoo
> 
> I wouldn't feel comfortable changing it to report partial copies without testing
> it.  Someone needs to look at it more carefully to figure out what the correct
> fix is.


