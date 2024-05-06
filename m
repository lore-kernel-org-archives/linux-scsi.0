Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A95013DBBE
	for <linux-scsi@vger.kernel.org>; Mon,  6 May 2024 21:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715032138; cv=fail; b=t0Iz4zeoKdRNu/NJhSFemS1VxH7hSev6IcX5bw/nNjubPxWOqtG+HXGM2hSwSs0hIV9f2R5s1CaGYJnVTlkaTtLEIngeQMDX8bWRPu+C40E3lAxMa8zRITfITaOM75C9NQaIzOILeWovxHzacRclesD6GwknkLosMP5lnZZiDn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715032138; c=relaxed/simple;
	bh=ysQjep/BEiWKTvCjzuq+vxPbXDnjhWh89xakJLPNZaU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FQBMEkokO7rKXOQXaGLnBCekezsKzaDIu7hbNtHyzW8eABtvAQK7xYyZKTLKBPhBtaQjSz3x94mpmYbLZeBTlsH3YAp6TS6TCUd7sl+KWsB+8VSuzjEAPxPZS1BTv/4lGAqoNaknsHzAlUxnzw43UCaYSATNikJmZoMuxPYBqAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AUCxiNFb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y/6AKe+s; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AUCxiNFb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y/6AKe+s"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446IJDl2018882;
	Mon, 6 May 2024 21:48:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Eyk1Oz9UwvJIpcJttbQyCaYa/6wjHEZWWo+L66ixDZg=;
 b=AUCxiNFb/B9bbdSw6EK8mNeX/eEL4hW5zybeElJ7lSbL/4Sxg+q4kWaLJIqgO/RTzrEr
 4VyMbJ0I6oRhAPYGaVHjgwBQvhx3Fnrex2LYDsXvoqy9GU1gFrJmU41zJZf7EpLKr99q
 6Rn7g9fBIiC82qUmFoEYcqSw4fqBFr8bj3C/XGz+MWk3efUEYM1idpOxs2VI5lfveWvH
 sZ7lZSrB7ujwySmnC6vTk+Z9rX6DA5BClrFeQeDirSudE0mjAq303RFvL5/lAB5ZpzKW
 wNawekM5hedMfZFDrAgBB6k0Th82K6rSuij95WDIuyR2/M8biqqjRcYuC07+0qUND5dn Iw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwcmvbmgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 21:48:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 446LLbgH027581;
	Mon, 6 May 2024 21:48:43 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbfdefsw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 May 2024 21:48:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKZYrTf+ci87jDEKu0As9e9F2UF6yU+UHGTFTC8FuuXO5ToDPfInqt+rYnIvCDNjvrxVesxpGn4BKmxzbefm0WxXOdG/8yxx3vH3X2pd01Rn0AQRJ6A71jWcQuSoaWk+uAGJN1R82RmFxPxfLtC1ZT36PxpfuJqGVyYZP0VEzzj4j0bMbs1eU5ZuE1YkL1JciEVJ91ggjle0+vzpGNI490xgWshrKmvP2+euhYxoSJ6lZtvUWlx0yhOPLRrgBc8SiHay+mT2pZk2wzXwTM4/xtmitFpXRLZ0t7It8iXKpxdskUclFMAkQPRCS1DYWKXoIyDa4PzP+Q5jEfcaBP+WYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eyk1Oz9UwvJIpcJttbQyCaYa/6wjHEZWWo+L66ixDZg=;
 b=Uo5b0MouWr5xlSLtgad92Q1pbCqvXgm3LfrHpRuxreLSaFMvtBv9ZnQqEHmPiBegPzNKYubllFbuRdEzu0NcGX0tnHNowazGZHBqz2GfmCKgEwDLC91BlUZ7fOMGabfiMmV7l3fw5IMkek9IIB+GWHClo7AvR+tzsZ1HwhXXtJrV1b7aQH7CeLI94N0QNEKOOk/j2zxYWUy7QK0aTT3LxpIt0euS+zwPWiPEcBEGykkoae718ut6tOXcv/WQ8T0h5+LrlVNuf/yUnKb3Rg8Hi11qpwoqWKFzcedkJ0u/JC1/Z/mWFZhxxtCxP8z52HlR6MbyFOIWysOCq63l4dRORQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eyk1Oz9UwvJIpcJttbQyCaYa/6wjHEZWWo+L66ixDZg=;
 b=y/6AKe+sqglfDpx89WFBsk2ftbNXMFOqf4YDSGMsz7VU0GeX/+/5YvlgFNHQGCxG4FwhlXX0rutG41Cx32BnHIoCeXt17dBONjsnL4+wrK1VKSwbq+2Grx/UI5s3R1hrWotLGVBB1HrzfuO3/cOIhIcQ2LMEYFe2nzhMnWQG4xE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7212.namprd10.prod.outlook.com (2603:10b6:610:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 21:48:40 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%7]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 21:48:34 +0000
Message-ID: <de89ed94-1446-4e92-998e-ca00e9ed7562@oracle.com>
Date: Mon, 6 May 2024 16:48:31 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] I/O errors for ALUA state transitions
To: Martin Wilck <martin.wilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Ewan Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        Martin Wilck <mwilck@suse.com>, Rajashekhar M A <rajs@netapp.com>
References: <20240503195606.13120-1-mwilck@suse.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20240503195606.13120-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:610:1f1::27) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7212:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df92fda-df11-4661-8adf-08dc6e164728
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?MGE1NXVuNTNSSzIyMDNoUmlCSDljVy95eGRsOTE2bnFDOFNMU1hxUitVb2lj?=
 =?utf-8?B?WlA1MXFKTWxhU3JNcDMxTjBMU3huTzBjUnVCMXg3cXJ6dlN5aDdSVE16bzJT?=
 =?utf-8?B?aEtsLytwQ2p0Y01GQkVLUGVTQWFLY0w2eU9Bd1plMFAxRFlkUHVFd2FUR3U1?=
 =?utf-8?B?TFNvSnRSL1I5ODM3YjZJd2lpWmNhcFdaZ1ljRXBVQ1o1UDFBMHNYeWxtWGhy?=
 =?utf-8?B?eXF4SXVyRmc3WDVCTG9DK2lCYVRzV0RlQy9MSFpBekRvS2NvUEc1WG1DTTdp?=
 =?utf-8?B?RFNpL0FSZ2VHVWJpSURTRFRwci9yVU03dGZZSW5KZ0xZRzR2b3NJQmtObElR?=
 =?utf-8?B?YUZEbmUveCtDeStGZjYwenprK2JSdVZXYXRYS3ZTZGVPay90cUMyNnhodnB4?=
 =?utf-8?B?dURhOWR4WDR1VUtZNUp1UnNBT2RTaExjN24xeEdvbGUzVTVLUm4yb1k5bDJO?=
 =?utf-8?B?bDFraDFDSldOZGd6aDZGY2NpcmZ4S1VhM3lvNW5xa0JyOVRtVDQ2T3ZMbDdX?=
 =?utf-8?B?SDVyenlSbWp4SkVTejR2VW5uUHZXSWpJNklpeWlBY0ZDKy9Rd0lMY2ZvVUYz?=
 =?utf-8?B?MWNlcERTT3B2U05USUhQUmJLLzRYSmlhNzZZRDlrZmZEaVhmdm1FSmwzQVlu?=
 =?utf-8?B?TExKMk5ldDFQN2V2a1dGTGpaY2VWVkhLck50Y2hYOTIxbWo0ZXJHRVNQVWFS?=
 =?utf-8?B?aHpHUURsZ3JtL0dLVGhiRXNqeUhBM3VjZGlNL2h2aW8vRFA3K2xPSlJHTTR4?=
 =?utf-8?B?TEZJSytUVHlyL1FYNTFPWVI1VkVpTW9aNXcxSkpkcVdTaTQxT3Y3L2Ztd0NU?=
 =?utf-8?B?RUYvaUVEdDFCRnZxdjEzeEVOMXRPNjV0dnk3ZVRZNCthK2xCSzBRK001QWVQ?=
 =?utf-8?B?eFBrWFJ2anpiTFVnOVFCdWlrVzYxMCtSc3YzUlpDTitmbkU2YkpUenhuZHlY?=
 =?utf-8?B?eGRGNGJMVkxYTUFHeGdKNW1abHhHVkZpQXJxa2tjUzlXVUpGU0xORzVUeDJv?=
 =?utf-8?B?UXIzdDVNMENkSXR4bXl6R0swNHhHd3BENlBDMFJ4b01GZUZQcFdEaTBlck00?=
 =?utf-8?B?ZWYrTjBmQmxYc2tXbnd1czBWd28vUnpPK0xRNjA4dnRQQmhxWkZ6SUpYMjRp?=
 =?utf-8?B?eGFMb0kzYW0rRk4xRHMxZ3ByUjViRVJFTm9RT1A4Vy9pa3NBSzdnbFBwRW1B?=
 =?utf-8?B?R1d4L0dZYzlub1pUNmh3UkRVamtlRStTU0RTYVg0N1JxUGpzaWJqWUZVUmVw?=
 =?utf-8?B?NlJ2MHZsL3cwNjZDR0lKajhhZGJDdHNwNzRJWWRzb1lLR08veTg5YWFQVkhv?=
 =?utf-8?B?YUx5SFE1aXhrdDQrYTcvdmNIMjljYjZqb1huV3E3N3hTR1RHbUd6WjBsVWlv?=
 =?utf-8?B?OHpvbjZkd2YzZnQ5MlZGTmk1UmdnY3ZPUVdNQjU3bEdaV2lqNG5Nc2Z4WTlU?=
 =?utf-8?B?aS9oM3l2ZWY3YVVlbzdFZ3kwV21SeVF1eFFuZjgvRnFteWxYNU1SKzRwY2cw?=
 =?utf-8?B?QjJXVFNhOUV1ZkxFb1Jyd3VRbld2MUFtdE9PamVBaURLTE5lUW4wN2Q2Z2x3?=
 =?utf-8?B?UDVDTmRaNWtGNmdqWDhuNEc1c2poV1BrVUdKQmxnTGFXZk1WMGMyVkFIaHhH?=
 =?utf-8?B?YVRPUWlyT3JYcTNWUmhDVE5OYllvdWs0S1drTHVPWnRsWUhZSmE2VEJwQ0lU?=
 =?utf-8?B?c29qODVjRDZBVlVhQ1hyVGk1NFIzSDBUOTE3cEk0ZEd4WGI3RlVYT0x3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SnpVaFZQYk50VUd1K0FBbDlmSWlDRjRyMHI4M1pzU3FwWDF4VHhsT0RaaEVi?=
 =?utf-8?B?OWdlZEoxL1VZU1hoTzBOTE4yNUVMLzUwSDExM1B1aTgwdmI3Tzk3cVpEdEZu?=
 =?utf-8?B?Z3hMNjFmR2VMTHNKN2dQVnU0K3Q1UEg1b1R3cUpxNWtscXFTUDh0bnJlMStO?=
 =?utf-8?B?ZkY3M1FRSzd1Tm9DVHgzZmFmNXk3blg4WUV3NXVxRVExajVKNVpsdUlmRUE0?=
 =?utf-8?B?Smp2eDFpZDE4eDI5NFFtYTFBb1dYZGh0VkNWTkJJdW5KQ3MzdkdMR1hGVDJs?=
 =?utf-8?B?V0F5QUI5YVV5TDhZOGZrVjlGV3pXaFlzRWdXTTlQSnFzOTM1SkVYTVA2MkpO?=
 =?utf-8?B?em4xUXNqaW5oRFRtSUZkVCtGaE1PR1hPSDlDaWd6eFVlbHlmR3NQNkphazQ3?=
 =?utf-8?B?U0xHd3RkWHlTMHkwUEtQUWxKOTNRNkd6SmFDeFp3a1N6dWxsSXN5OWV1ckx0?=
 =?utf-8?B?U2R2SEVwY1VzTzN0Yk4xaWc4LzZsUmt0OUN3aU9WaytZN05GcXd2VWtBbFV1?=
 =?utf-8?B?dWw3MHpDd3hDalEwREZFUGttRkZQT2VLZlNqSXpkMjNHS0hjSTdnZXQydi9D?=
 =?utf-8?B?cTlEMmMwd1ZKQkJYNXQ3OFJKQmhjNWhLalZ5bk5sVmxUMytMZ1AzOTU4UEVD?=
 =?utf-8?B?YTNkZ3BkYWFSMjlUc3Bldm10UGQvNU42TEdEMFpSL1JncHl4Wi91RlkxdXJz?=
 =?utf-8?B?N25DLytEQ3Q5ZDhEN0lVdlBzc1N6QjBiZlVPZm0zcjRBd0RPa3R5L1JFdE9r?=
 =?utf-8?B?T3AzbVFsZ2NZRGMzbnVxTVpob0FrZGxDUkZPSDFOVnJBeTdvR3BpeUg3OXpv?=
 =?utf-8?B?ZEtQWEpXV2UrdUJDNkZHeTNoa1RlTGNBYlF5Q1M1SkMyTEwwaUlCdURPN2x4?=
 =?utf-8?B?alJEU2pZTzN2QTBQUndEZTYxTzVHc2RwSEZwZG5hVlpHejhmM2pLb3BwNDBJ?=
 =?utf-8?B?SzB4eGszaUxGWndwVStxdElBbkJZSy9EdzRZcDlOdWtVUVFuclU2OW1Zekgv?=
 =?utf-8?B?ZDhiMVFYdVpJVDV3MUhkVExrRVVVZUdjSlhaY05HKzA2VG0xTVJ2OTA1WDhP?=
 =?utf-8?B?M253bGxvYjNsdERSYTNYRGNrdC82Zm10WS9sOUE4Y3BkbVFvSkcrWlhybERB?=
 =?utf-8?B?Um1UOStBY0JRQW1xMVVjcXI0NUlsbnJMdGg4WDl6ek5iZk9MYy9yV2J1U3BC?=
 =?utf-8?B?SnpTT3BkMjNKczhHMlEzcWNpK29wUUs0MEsxWE5xUFJLcTAvUms5YWs4VTk3?=
 =?utf-8?B?V1NmbkhodmpBS3VZdXRLRTJMa1NseEl6b2VlbFVFS2Z6cElWcU1oUzBETG5G?=
 =?utf-8?B?N3NtZ05NYXhNa3FTRC9yRHQ3OTQ0N2tJWHlSQ1dyZUNaOUlPSTNmSTlMYUtY?=
 =?utf-8?B?WXFWQ0EvV3h1Tlh6TFF2VkdSUGNrdTZyWFBLRGZpUHdVSHk1dEYwYXo0WDA2?=
 =?utf-8?B?eGFRN3pLSWsyVHIyQjJZQnpzTE5YaFpYa1FYTHova1dvT1VWSDBtYmQ4ZDRF?=
 =?utf-8?B?L0VDUmRrNUo3QnllVkR0YUNSWjZjdmt4T0FSM1llK3FncEE4L0x2d3pGbFdX?=
 =?utf-8?B?MVJ6NFpKOEdUaUQ2bXBOL054clQzcTNuc3AwWmV3VkdXTnFrb0M0d0txOVFu?=
 =?utf-8?B?b21oazlobTJPd25yeUVtR3NEMklHUVJqbGU2RjJmbGc3ZG9wOVZMV3lqNkI1?=
 =?utf-8?B?QVZUekNhR3F2cDJzWVA0WUptYyt5OFNhQ2xPTk5oZzl3S25ZRTI2Z1R5dlVz?=
 =?utf-8?B?WFAyR2NHaEkxTTRFZnJ2WVhrSmthUW10K2piK2pzT29FVE5GNXBUeUdsOW1w?=
 =?utf-8?B?MHRMV2liN0FkL3JjTE5KaGpteVZ2WkdSZU4yVkhXdkhxbzVvdFE1K2xPNFV1?=
 =?utf-8?B?ZWtmUm9NOGZpclYybXozS0FaYkp6S0tuMDhUcGJScFpmaFc4bXp2Q0IyVEd2?=
 =?utf-8?B?UnlCcXQ5amRia0Z4bDVEUENGTkEzM3ZoK0lMUlFObVEyK1Z5SHFBMWFmV29X?=
 =?utf-8?B?SHhUYnM3NUliS3NZemY5dnJJTHVjblo5ZmdFVkFhUy9Yd0xBWWxoYTU3MzVK?=
 =?utf-8?B?ZzFSUXY4Tm9vNjY4THNCWko1Rm5MSEUrRm9XVW5paVpFcmFidVhFclJCMXQ0?=
 =?utf-8?B?Qm1VSHJuM3RrWmZvUkJ6eU15aDdmZm1ITFB3bktMSmhWSmN1UUd0M1Erb0E3?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cXcCfD75OcKaagt4bkMhHGaVpSSz9FdXKmP/qjC63DeIeLbfc6svgUj9LEkc17WdOGy0NoP6yK1+hGjSiUx5PLIYQaitxqAspo7yiQX+WIXWZyiTT55kDKJC7SeMRV/qcCUJMXvMJhuL59mMebmgI4EHuYcsskWq4XZDRrC43wm3a3dvC3wcaYCGrBntvNsEJrsOkrES69FqLy4H3m4GcamHR3FjgZdK5zjF4gpUvVz+1SgJrQGBE3e2lOtkPI9r0WBYHsWCFsmK23jdha2BbAGf1Ghe3gagApywJ00clyfiMW5PxKZQnLzXg40o2prKTtXXeokXhxMfKHzogyvDQwpe0vHX1LQJ1Q7FO/JKlU6gzJgzXn5IaYUZYsGb+FDdpXnwZMTnslYhe59jvTYD9e6ZdaXJLUzKrbVSrZdrszvVOKdOqho/caYybHX5sRkEDpx8bs1+6An0VgSWEERM8EkdBEbrRuCBE2QarFnQSeFD7ZpobDvGrmgruA1w40BDZpKWrZkGD81MKYqxg5jJfhLfKk161sDZDV0KeCdp3NtrHxDRTk18Y8f+TSIzi7enpYVYpaHtC71r2/n0cKoPJhrXh+pG8T7cqzNWp7BZ3OU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df92fda-df11-4661-8adf-08dc6e164728
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 21:48:34.4322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sQCEUhURTFlRl2T5rvEhTE2P47BxU4CsO/caXptzU/JavK2nhhUzK00eWk221c8fIM2hlyhprhlq1o144D2x7ksxkm5E1ifieBbItxZZ8Ks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7212
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_15,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=983 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405060158
X-Proofpoint-GUID: lKktDzusa5fE9uOvSdIrMT8nttaGRF9c
X-Proofpoint-ORIG-GUID: lKktDzusa5fE9uOvSdIrMT8nttaGRF9c

On 5/3/24 2:56 PM, Martin Wilck wrote:
>  	case UNIT_ATTENTION:
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a)

Do you need to add this check in alua_tur as well? We are checking for
the NOT_READY case.
