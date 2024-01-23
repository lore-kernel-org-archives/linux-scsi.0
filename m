Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27816ADE
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 22:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706049613; cv=fail; b=UkM614QLrl38pWq7ExN/mf3o+wWAQyLfIhGAv3bVQGQUV9aUvce22PYgRLcuMGuPAaTPf4kZYakYEVkPUOtKaLGb3bH919ysoGjLqBGkqt4pVSbaUHm76XM1ueVCyYGNWz0yXRdeBEr2ssRxuNsskkoqxVCtRQ9XxxO9KjRxWT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706049613; c=relaxed/simple;
	bh=XatcJ/ycvtnEs8x7CSKaevI/AgsL05bgDJD2vos5DC4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MTSSqO0dp4Tvb7terxLWzJRU5Szmon4cF1r/QqaxetgwGO+gkdRYCDdM/fWejdRuMyTMFPbfETcCAOXAbnDUlXVMWKKWdCDssmzv1lg0UNzOxRjX9oX1iaTPD9SwqOP3SJgL8cUqEA7qf+x+Wx8z76Rmr4RwDSwin6Sknl14SF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a3GBurzA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cWZwJGgC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a3GBurzA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cWZwJGgC"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40NGRV9F026838;
	Tue, 23 Jan 2024 22:40:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=CCl6MrsXS6LZl+h44RCLy/lQJC3+hA/mhlZ5IpCZwkI=;
 b=a3GBurzAIsHrcdIemv4u7bpViz8DkqDSksb8TtJAUliutcaRCvq7mJDN9+fZ7eMVnf6J
 5nvDwBNpXOWzI3403ulQ10ZHxfZc9455zovkk8kjg59r4zWjplEszkW4ZtxSMNY9NKYl
 SnyGpB+RX/BZXluf4jFiwpXZnkUHEMaNrLbp9Ddt1PPtma+00VT9VFESa9zRjSkmyBo0
 SB0ZXDWCidY4AeHO+WqbbkQBbhdz7AScKrEyOoe1TUC+Ouks4M8W3hB3XI4DodLHuZPK
 w0dcu4U31yv9dFj7EqrRe9PYbeTqfDTddc6OGZ+oBOC7P2YCpGy04I44LnyFdD59KrNq Jw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7anqkv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 22:40:06 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40NKrnbp001450;
	Tue, 23 Jan 2024 22:40:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs32320yn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 22:40:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XY2GhrKEcBZccKI1pe7yUldZcepxG3k6EXG57g8aghd4G2E9Rr7P1MMx9G+bA2FDeay+wX9tBGhSjQek7JRhDtQPb3hXeTB4zvt4qysWkNzNQlqyY0RWA9M0ubM0g75WyWuf+Kldqdeg58mkXUTtKSR7ZZfYo6FRFDArYlJs5KYxlh2CLykEBoEQoYbXulyoyYgkMLRUWTgTb8C1qPlONOXg7BvQPO7p5pU5pawDsQW+/J0yUz0dq/k3MFvhukrrpA1xgw770AMph4K2PKdvn96imXszkWux4DOHGOw8L21Om+tRsAt82V4rGn6HPmGwrlateQh7UyMW1105X6w8tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCl6MrsXS6LZl+h44RCLy/lQJC3+hA/mhlZ5IpCZwkI=;
 b=SJt8nc9syJeK3DKLiqRYwk8IlfSLGlGkWfUgvjczkKVrquLJlXa38fPt5xWDHKPc55XZtJwhTaQlac+kjI6CR8ff+8HxN9SdqTbkXIVEmh3rGNSTVn2SN8rPqd/8zv2mlML8vggbwBvAFHA1HcBDbBoSLUFauZUDhpsH3pBZUoOfAN7TRQevbF9+VYNkVsZabnnQ9euStfrZEGYYLWBDhhVvrXO4Jlv2z+iefyOSDSeyY1UiLhgLymaAKpHPx/K7RYTB4ckXfg8NMzRk54nEptuEY8BqIWOfn6Xnh7omhZCepaoIKyoguyJDU865DlzU3Igg6xCo7xQ2TaPUoQYunQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCl6MrsXS6LZl+h44RCLy/lQJC3+hA/mhlZ5IpCZwkI=;
 b=cWZwJGgCdo/R1dd8KrXL0DnQKKa6wdNqNUviGo+bNgNROn4dVSbAoDsnASZewsFoEAtAIimK2Lhf+buZumyfdwPisbTva0u03e6/mGA3dVdH04Khc6+48iopiWS8WKfr4NlszAEc0L1ouSvOOdhpVvt3V1e9jb/uiE163djIeII=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA1PR10MB7165.namprd10.prod.outlook.com (2603:10b6:208:3fd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.37; Tue, 23 Jan
 2024 22:40:02 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 22:40:02 +0000
Message-ID: <bc98813f-113e-4074-be85-06455f684856@oracle.com>
Date: Tue, 23 Jan 2024 16:40:00 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Update max_hw_sectors on rescan
Content-Language: en-US
To: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: brking@pobox.com, jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20240117213620.132880-1-brking@linux.vnet.ibm.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20240117213620.132880-1-brking@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:5:334::27) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA1PR10MB7165:EE_
X-MS-Office365-Filtering-Correlation-Id: 941b3997-1df7-4290-00d5-08dc1c643cc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qnEQcltgJUTL/kCdBm8Gx9sCCg45xUCzCV/UOpjc+RUgRCllznNwCmmR4HijVs7NXNuINygqZZEeKmCns/4/S8W1kKGzN4VJ5mPuI2sganvDmCEScoPS3yc4Y+PoebPqIxmAuchj30i0Nx9NR/xQMD6+PWAyMD1nlbg3C3A7adxuOp9aSKobjEv+Oxu2+uokk8NaH+FsgoQu/Pp4fzLBDuk8bz3QrR6/9up9N/yMF0wHWYqHsHkcqn6FZjoIAFSAqfUE50a/J8LfskNe8s6vmZo6dsAjnUoTReMhlN/gJWrWhvMIm04KFCIR3wt1H4yllIESUUyYmaoZtyUbhLW+gIGEONuwztV/muyAPbcQAVhOyh4HNaKvY7OApFgygYdSfYbG+3VT7AKvrCKI+NW4ILfRttMJIHq21xWbBU4vEeJo23jCh4hUiqqsHFkcq0m+4tTE5RwtuU5YlDDqlspmhNs4+IIKuTdXwVC/uJDT6/Wz/1wFeNtZphUAD9tSdfRLLZu+p/PpKcpoRrIQH6NChnw3FpxMbbU2B5N1DMALtSWqewZ8IiFYdJqsBRr+kKY9WioGxQ5M4e39xdTLne+nnxrTolSf6YcOStoC9NHhOUZnB4w3zs+bKeDcwKsHUjioUkMnSAi0aYfF5DI5LNOk8Q==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(396003)(39860400002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(83380400001)(6512007)(2616005)(107886003)(38100700002)(6486002)(26005)(8676002)(15650500001)(8936002)(5660300002)(2906002)(478600001)(6506007)(4326008)(53546011)(66946007)(66556008)(316002)(66476007)(41300700001)(36756003)(86362001)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WC9nbUJQTUlvOGdYcUJEdzE0ZlVTelZMc2xCRkdCUVhlSnZPdGZ4SU9XMDJQ?=
 =?utf-8?B?d3FWbWFCL0RIWENWYmdUYUVDMG9vbGJ1dlZqMVJFbGxDazJuRDRyS0dTdlpk?=
 =?utf-8?B?cHNjWTVkWDdjbU5QSDBMOUZtYzZ6YWE4UDEzQ2E5L3hXVnVwbjg5SUwzbytF?=
 =?utf-8?B?M0cyd0t6NzBMaHFkbDU0UXZkd3h5R3E3MFZVVkkzUURDSXBvSmZZSC8yczh3?=
 =?utf-8?B?YTQwY0ljTERVaDNjTUlZSlZ4dFpoWEhPVDdpeG1QMmZ6em5zNFdNWUhhYW9W?=
 =?utf-8?B?NkxvZkpEZFhKZWhJZTRhOVRjSXE4aDFRZXlucm1FVXhmNGw3Y1llODRITzh2?=
 =?utf-8?B?NVhFMDcrcmI3VDZIUVBtWFh1MW1zMERSb3hKVVd5MkJtREtnQUo2NCtxbEJs?=
 =?utf-8?B?K1JHNDEyOGh2N1hjN044T3Y2U2hpcWhEWmFMUzFta1V0MnFEM3VGcGRHYXdy?=
 =?utf-8?B?SEtleW1LcGZOTmI5Vi9qaHlKNDY2Yi9ocFZrT3VWNzhvVVpRR1ZaRXJBNy91?=
 =?utf-8?B?RXRUa3p6MU02SXN6NTN5K29ZYTVtdG4yUlJmMkZjbmF2aEUxY0h5ZkFkNjEz?=
 =?utf-8?B?RFEzTTVaUis3ZWpLMFZlcHhiWFlTV05CbVdsb3NaMlMwWE43OHp4dis3Q2ND?=
 =?utf-8?B?UmJEV3BicUhnR2daSlIzNlUxVmJ1Q0xIeXFBZWpzcEVwWDZUZDJ0cjFjeHd2?=
 =?utf-8?B?SnhJNDdoWEFDVzJjZy9EOS9YQUtDSW1xOXpjbndmWXFEZTl1aEtqbklsYXlM?=
 =?utf-8?B?REVaL3JOWUNGS3RkNXIybTRodkxRREp3SWI0RHF0K3VFV0x4eTFYL2VIVUtt?=
 =?utf-8?B?eGlXeDhmMEVmK1FaUWNmUStlQ1RsaGh6Z3prLzJrK21nMXdsZHllMmNkcUVY?=
 =?utf-8?B?MWoydTg4UkJBOUFCU3BHdFEvd3pqYzcrbkpzK3BteVpyLzJDOW94TGk5VUMw?=
 =?utf-8?B?QnNJdnBiRDhMK1ByUlVwZGVVV3EwNFZCOXdmQllqMnBUMTUxdFFsR01mQU9V?=
 =?utf-8?B?M2NDZDZ4ZlFpK0dEUWVPME4xN2lVVW43VDVTR2Z5YVhibms5aHZIV1BjRUNP?=
 =?utf-8?B?TFVIbEYvcEdVbGNGbi91SWVRRTIrQjlyU1ZXN0E1K0MrMldQT2pVTzdCZ1Zt?=
 =?utf-8?B?UXVFdDdQaXBsZE5WQTNESFd4cDNPQlNBK2dQSCtqd25qVExRNi9tNDAxelNB?=
 =?utf-8?B?TGUzeTZkZVJjNDlURmxZbFhUdGx0N0Y4Vk9FNEJCYklKSGgyTkloa1NPSlBL?=
 =?utf-8?B?ZnFMcXBiVkE5OTlpdVNVT0kwclBIckZkbGdqRnpOOWNHb2M4bE9MR0RQVy9G?=
 =?utf-8?B?MXVNYVhndmJLQkh3M0VVM2Nlakh5WEpmVkllT1p0SlBtUlV2R25kQmhwY1B4?=
 =?utf-8?B?UVpWN0N5ZDY3eFhqTnVvdzB6SlpReHN5NFpGZHE4QytMek40RkpRUE9KY0c5?=
 =?utf-8?B?YWNqSnV6UE14RTlzcElROHNlVlNoc2dPNG5rTCs4UU1jS0Z1RTg0Q0dXdlU5?=
 =?utf-8?B?RHhmRVRERm5jYnhieHY2SnJzRFlRUElzYms1RW82YmRSTUU3dFdoY3RFTVVV?=
 =?utf-8?B?T1NabE1LRW9yWUl2ZUVzK2doUiszSkF6V3FnTXFDeUhINzdWbk5Qdm5ySVBO?=
 =?utf-8?B?cVVSZ3pDS21LU3NnTTd6OHhTUGdjV0Mvb1JmUlZJZ3N6Y3RIMlhWaTFQRnNR?=
 =?utf-8?B?RVRXKzd6NVJjL055dEVUSlcwYU1BNVRNUldMaVg0ZjRMMjFZLzdVWmlGMS9B?=
 =?utf-8?B?K0cvcWNHKzZUdWkwUWJRWEUybmlOa1pOc0NIcXlpeUxPY1c0M09sZWNjT1RV?=
 =?utf-8?B?eW40OUowSWN4Uzhqd3NZdlNHQ3E2d05HUjZoMkxKWmVKTWdldWhYSVNUUHpl?=
 =?utf-8?B?QXVlVjBSREpUOVExV0tHNmhnRExlRklrV2FMRUN2MWd4ZEw3eXd4MkFhSzZn?=
 =?utf-8?B?RnVxYUY5VjMrbzd6SnBWZVpmUXluZy84V1FHVkpoVXljV1hIY2U1R25CZHJv?=
 =?utf-8?B?bVFKMHZ1b1VSVmRLcm1RZDNZZDR6SzkxQVY3SHRDVFpnalR4VmV2MWZIRGpk?=
 =?utf-8?B?K205OHBFYTRJdzdIRjRsVjlnbjE4N3BPM2lhVlhpMFBFaW5Nek1WVmZDakly?=
 =?utf-8?B?TzNtZlhRMExvUldkb3Z4L1ovR3Btb0IrYzRZZDJMelBya3RUcnh5ZURrYlRh?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	pPUN2fBHBK8pNYoF9BUFu8uIVX4QE9VPMXXJFTQp5Zb22qd/MQ26XMLo7lc4e1FBgbaEEwbr1aXdBC9V0DClHhR1P9EccEO+DhANEN+7ZaMI7xdrT2qPKOC2gSyXrxiS8hngDEo9k/B5lymAnKyVQUF6ION0+Ah/whWQZIpd5z76B6H8VGc8/6L3BL0zqKnClNz+cc5BlI25W4jkz9tycIapap44DA1Mn38rKuQumqgjR3jg259V19fv/eZMp35lqh0wCuOnddoQq/vEUceIa5tOJfPj4XG2HupJCFnymbOzf1SMRy+dWWEC+0rdGBBrB4YIkk1+YdXY2MHwJV5vl7AxhoaPNcOHM4Nnm8t7owujvSTXr6dYxg4WpkYjN5Keneo/Q6k4bntsGbmyBPkJvrlFmDunioUG44RPsV631oUZtLbFCJXpvPlm02QY07topBppOvJ8bDSTF0vuoEwLHrQicnPPpK7nmfUk+vlxuPvwNnpdOGPUoTMabnzHiw3SwH9AYuyxu3RVWl8LAupK7+YaKHbZxMdZVIjQXmzMwlzOF7s5nTnRuUxQWLtdDmmlkNOlvnyVG/Eddtqj2Z9TCFm7xeFXZCrwdlqz3gIWwmI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 941b3997-1df7-4290-00d5-08dc1c643cc5
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 22:40:02.2907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cmvna8tycrOKxH5ACRZmOvXKV4S5i976xn+LH9MZrxMSE3KrdLQBa970VRPcPtxkw6rtCyqNzyYuNhQdPDwKswlhHAL7FMnit/Jwp3+J8M0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7165
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-23_13,2024-01-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230168
X-Proofpoint-GUID: 0-G3I4GRrhtSpcK0qkQ-sFQQm-sp-rTQ
X-Proofpoint-ORIG-GUID: 0-G3I4GRrhtSpcK0qkQ-sFQQm-sp-rTQ

On 1/17/24 3:36 PM, Brian King wrote:
> This addresses an issue discovered on ibmvfc LUNs. For this driver,
> max_sectors is negotiated with the VIOS. This gets done at initialization
> time, then LUNs get scanned and things generally work fine. However,
> this attribute can be changed on the VIOS, either due to a sysadmin
> change or potentially a VIOS code level change. If this decreases
> to a smaller value, due to one of these reasons, the next time the
> ibmvfc driver performs an NPIV login, it will only be able to use
> the smaller value. In the case of a VIOS reboot, when the VIOS goes
> down, all paths through that VIOS will go to devloss state. When
> the VIOS comes back up, ibmvfc negotiates max_sectors and will only
> be able to get the smaller value and it will update shost->max_sectors.
> However, when LUNs are scanned, the devloss paths will be found
> and brought back online, still using the old max_hw_sectors. This
> change ensures that max_hw_sectors gets updated.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>  drivers/scsi/scsi_scan.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 44680f65ea14..01f2b38daab3 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1162,6 +1162,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>  	blist_flags_t bflags;
>  	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
>  	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	struct request_queue *q;
>  
>  	/*
>  	 * The rescan flag is used as an optimization, the first scan of a
> @@ -1182,6 +1183,10 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>  				*bflagsp = scsi_get_device_flags(sdev,
>  								 sdev->vendor,
>  								 sdev->model);
> +			q = sdev->request_queue;
> +			if (queue_max_hw_sectors(q) > shost->max_sectors)
> +				blk_queue_max_hw_sectors(q, shost->max_sectors);
> +

What happens if commands that are larger than the new shost->max_sectors get
sent to the driver/device?

For example, if we called fc_remote_port_add and scsi_target_unblock puts the
existing devices into SDEV_RUNNING, then we do the scsi_scan_target call and
hit the code above, could we have commands in the request_queue already (we
relogin before fast_io_fail even fires so the commands never get failed)?
It looks like commands have already passed checks like bio_may_exceed_limit
and will be sent to the driver. Will the driver/device spit out an error?

Is this ok, or do you need some sort of flush and limit re-check/re-split?
