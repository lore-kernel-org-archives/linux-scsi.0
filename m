Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4163F3043CE
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 08:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761120858; cv=fail; b=fjxKS2YsGASc9s9R0KKSJMBMUSFWXqjPErKAf7+OIcUPwg+40b09tyh2pW4jRtgv7/kAmdDJQx0RwsE7qxeT0xYkNoz5baNU/LxH/9BDR4jtKEdW82IhtpBmuilePANaBJRZDzarvnVDV0Hrj4XzLsilWhttH70oXyJNWJ5pHe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761120858; c=relaxed/simple;
	bh=aS0PxmmQbuftkJ0ReHusLCQYd9n4NV05c7VEGUcez8k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d1mC/24M7YqYLutlDa7fyt/75X2bvw138tK11K1LSvI70Ycy13uC0GA+Fkb2b0f/u6wtmzO27Jy/QT52UAi6JN+DsEdRt800uzdGX+3iHVuxkEgoAiteOP8Wc9xalXZSTik8FL3SHzvrDgsb1lOebRO34oNeo+zt+xeeMacY9Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cGcE1cDa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lhRFiV42; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cGcE1cDa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lhRFiV42"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M8CHJC001318;
	Wed, 22 Oct 2025 08:14:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nXLXYnUhfrSiqfY//OAGjaHfG90cR6k5kpNyQ+YPw9s=; b=
	cGcE1cDaJEnIBvl05fBGgNnNnUWPbouKSBT5ZXc87blDKJfGAx3HzBQgbj3fY5P/
	SA2cjTdmEUC4Vh8f9niPUxPI76CDUNvw6SOhiqHWhiQ8YRprIha4L+cuTItDFmiU
	s+f5y2WcAb+/edTdv8kukQLFbtAuAt8ZCuhi+vi+xW6nczqyWUndIRDka6VgwhxG
	uS5Jbu4KTBwVTkPXIOEu9QRpEKCvcOvhBp4TPKiT0zHkOk5N06N1Euxot6+K7t/p
	0BdumULYn5HeFxonciiCykYEuZDAj+dpVYYChb+iEjkjOesL+xGT0Ll9zqJy1XsF
	M7SwK5dm0ebWNi6RTGGsAA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xstyg5fd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 08:14:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M864sD032257;
	Wed, 22 Oct 2025 08:14:02 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011025.outbound.protection.outlook.com [40.107.208.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bdw5rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 08:14:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Csmp7/22aUQ9JvtxaVxbUGqM9/2vxz5NrlBMo9giFbzsvKoKzMqsRfrfkYSXwCdCSl8Zl70He9yL2rcCjdjXNupH7tctcgqzsww/yqAUEhMXKFBBQga/bMFCbUuF9fdsBV/LESUhPYFvW2nHzF9eD/5rddva+LDIJq5z4D75eYL75hoKSb1tmbVCP+/KzfErxQlgM+GzRxT2YqzpVI3uBhS2t8kXkxEatlb5aUtEO5doQUh7a/OZUjMNwLGpaN05eFPpHSxKz8s6bPqjBOVFGeXQa2ETsRHXqyHZuLeNTvm65wiWl/DO9LFGDT4MHi6f4Ml3IiWkotLq8IVRRsVRtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXLXYnUhfrSiqfY//OAGjaHfG90cR6k5kpNyQ+YPw9s=;
 b=xRL+Gk9IzSBYwxfSXgkcz/5Bw6zmzqllGAKH+MX1S0HzneiGcE5eAcapYnJxROTA8rHkd/qkOm43tQJe/UW4GWfCykWGF6Xq5qh6h+zdaJYutQMXcmrQ63kZM7QxoEfN2bVW2dj6YdyWUxTLkypEC0da+Wd2Af3RwmJiE3D0zhc5AjeW3KCVCp9Q/bRPJYMExoxOchVAOQjTauJ+v5Qv8LXE7sI00o3+hVLt24wibIW5KOGed0sNeSmFDw2WS7O1mXXPdP3w2o8hkRF5yc6BSrJUvh1+ElpbLYznCqgY3fDZAcrYb5C78aJzP/sylVpyt9A2LxJABees1NtNPnmYNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXLXYnUhfrSiqfY//OAGjaHfG90cR6k5kpNyQ+YPw9s=;
 b=lhRFiV42e/buK5/EhGmkh2YyxAhKPrZFvB4sRuOaOP0y7q1p6J9vF1gOVxMJLxyhoodr8NL0fE5CT8S5ZKhZb9u9ulXERYk1Vg7roXIXlZ6qeSlmdfDlew5D1sc5G8dW0RwE0YM3o1k8fLsG7IugOm9gEiDNHP312F+/4djM6KA=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA1PR10MB7311.namprd10.prod.outlook.com (2603:10b6:208:3fa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Wed, 22 Oct
 2025 08:13:58 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 08:13:58 +0000
Message-ID: <fe16b110-300c-4b13-bf2b-56e7f2c6f297@oracle.com>
Date: Wed, 22 Oct 2025 09:13:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <yq1h5vr4qov.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <yq1h5vr4qov.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0312.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA1PR10MB7311:EE_
X-MS-Office365-Filtering-Correlation-Id: be06ce77-0123-4c6b-4f70-08de1142f37a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S25jMFFPMlFxV213NzlyRmdHcU45aXRWdytiM1FNVzRQMXNFVzFwT29lSGRT?=
 =?utf-8?B?V3NIdmpDSDdMWW1CUW1md01sRnVTMit5cjVDMHVNN280SmNEQkhsNWdWUlNk?=
 =?utf-8?B?MlRSK29xOUZ4d1IreGowSUZvZUt1TXJTL0srOVR1RzI5cG9lSkhCWUR6dDFs?=
 =?utf-8?B?TEk4TzI3Um5PSnA4K1d3TTMxR1VKRjhOcDFqWUsrNHV0RCs0cjlkNFFKRk9Z?=
 =?utf-8?B?eEhGVmZ0eis5NjlSVmdSdEFmZW5nNXZKTXFlL2NHbTNpUk1MRTB3ZjNFNysy?=
 =?utf-8?B?TzVjYmNmUk9FVHpxcFBud0VnNm55V2o4U0NOKy81bi9SVyt1bVBSeXBHNjg1?=
 =?utf-8?B?QUN4RWlPbFZkb243MU1aZ3hKOU0vT1dzdGJmS3dKaUZaUjhJcTVPelJJU09E?=
 =?utf-8?B?ZStxMWgrUnlSYjVIa2p3eDZuSkk2MU1kRkMxb1ZFZ3gzcUVhZTF5Vlk5aFpM?=
 =?utf-8?B?azAvMEJPTndmRHV5Q2N3OGxNcThZK1NiUjdNRGY2cERYbDhFNjgyZTcyRUYw?=
 =?utf-8?B?UzM4K2IwWTlFYzlpdEExTGFnalloMGNEMmNnUjA4SzJjMURlSTJCYXp6UlRL?=
 =?utf-8?B?dkg3MWxSMXZZdmFOZ252aENNck1XVktlUm5TWFZkVWt6cXBDbkRuaUVXRnpS?=
 =?utf-8?B?aXNkOU5xWVdpc2ZBVkc1bVB4UFRYODhnczFURkY2bXVxWkNqUDZyYXRtejlV?=
 =?utf-8?B?Y0gyaVdUYW1hbUIvUDM4S1hNREdUOWdJMkxpOUp2c3I2c3A4Q1R2RDdjeHda?=
 =?utf-8?B?M3hHZ0hDY0xLOWpyVkpFSGpGNlcwbzlObDZka0hUQXNHSytsbTJzWkFmdGxP?=
 =?utf-8?B?TXcrZWQvQ0hURnpDZVE0YnZyY05wdHpRN0FsazllSmluMVoyd2tOZmJTejAz?=
 =?utf-8?B?Y1VtMDdhTTRtSDdjRU5Rc28zL0gwTnlYOXR5UHc4eHU1S2R0eTFaOGJubW5I?=
 =?utf-8?B?cVA4d3NPS3o0a05uY3ROSDlDVXpjY3JhSWh6bk1KNi9MOG1ia1dkMkk5UzZT?=
 =?utf-8?B?Qng4MDJJQktPalp6TCtjUk1Db0U2ekQzTStqTU8xUHRqQm1seUJTUm5hVGVU?=
 =?utf-8?B?RVRYUkxJVjhacGphSzdWcDRTUGFBZ2dwU3RzVEt1YisxMWtLeVdlUXlOVlNP?=
 =?utf-8?B?UWxPWUxlSE1IZ21uL2RhYlB4T2V2YXR2MXBXZEZwU1lDM3RmcGJtU1dpMlR5?=
 =?utf-8?B?ZklOTDFCK0s5ZzVVMzNWcXZnSUtITEdaSG51NldqSVZzUWozY3g0NmJ0UEhT?=
 =?utf-8?B?NWpMR2VqMklRWVlSRWNtQk1zV252QUtjNmZUeU1EYVEwOHRWTFZpTUEzNCtS?=
 =?utf-8?B?TzJYdU8valp6bTV5cXVMTlNhZ1BkN2Rxa1QySXhFVmhjSUhWTmM3bnZQMHdw?=
 =?utf-8?B?RElUVENFckZjNnNYNWsvaXBXMGp0KytqZlY5VjEvbm1WOGcyWlRYRFM2NUhh?=
 =?utf-8?B?ejNlcFZ6MHE4dnM2cTVLWWhQaVlpUnp3Z0ZQeXA0YjlMVUpkYmpPUzhMNkwx?=
 =?utf-8?B?M0lCeW1rOGtpbS8rMjQvaXdYUnZ5d3loMndMUFR2WnI2YVIxN1EvZ2hxNEow?=
 =?utf-8?B?N3JDL0RxWHZ5RUZ4enl6OHJieEE3ZnZXeVNjckFNUGtSL000UU1VWVo5bk5K?=
 =?utf-8?B?OVFaYXJhM21ia2hvMnlTdWhhSURTZkdCN1ZWd1RVdHplZlR5TUt1alphRmh1?=
 =?utf-8?B?R2oyV1F3V3ZlOHdaaDBrMlVrUmozc0JGNEYrb1hJcEJkOU9zNFpEc1I2SUlM?=
 =?utf-8?B?Z25MWElWdEU3UHo3cis5Y2F2YmF1OVZrL2dObTVsN3luK3RXY0hCRkswY3dk?=
 =?utf-8?B?RUttUWlnYm9nL3ZIQ25oVDRvbGhtaS9tb3lHMnFzMnFTVFVEYTEwL0RyVGZm?=
 =?utf-8?B?MDdQd2FPS1lkdnh0WCswS2oyK1dRTmJiRktHaDVRRVhpVEg3c01tcFNDOXV4?=
 =?utf-8?Q?k2uDShC4Xky+iC+QpOLIp0YphHBW8NaU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWpjbVIvZlhyb2plcXdGWVlFb3pUNDhqbUZIMm52Y0ZwRU00VXhldXZpRFV6?=
 =?utf-8?B?cnkxTHUwd2hjOW15YzkyUEZ1U3hrQTFsRDJocFFkVFhLRmF3NXVEaks4a0Va?=
 =?utf-8?B?UHNqcmpuRzBPOE01TFV0TlVXNVFuU0JiNUNBNk5ZRkJHaG4weWxpVjJxMEpw?=
 =?utf-8?B?VW9zby9iUnJ0bDZvN0FDTU5iTlJlVFBhU2FBOEVKYkl4b1VMVVc2ajJXNU90?=
 =?utf-8?B?Yld3SE00MXBMRExWVGRKd1VWYWprYjd4Q09tVDJ6ZlVaeTh0LzEyQ3BaOEI2?=
 =?utf-8?B?MHN4VGdNWWJPekRpaXloKy9qQ09SN1FGU3orSDZrcjR2bEk5amhoQnZSL0xh?=
 =?utf-8?B?cnJra2czODdsay8yRjhUN1V1NFJOYm8rdk1CVDlmWGhpaHRaZ1ZSU1hFVHpO?=
 =?utf-8?B?eVB4dzdoWnA2MlMyRXVxZUVoSDR6UmlnZWx1WjY3Zjk4cmRYSjkrSnNQS0N5?=
 =?utf-8?B?RDl4L3FheGpvNnlnMFZYdkpVdnpja1NscXozeTg5Q296dEpyYU84Zm8rbTNk?=
 =?utf-8?B?SmxmZG40dEZrdzZVNVdoTW4xN0hsNlliM0NVUGVGRW5aWDJaSUF1eElORllo?=
 =?utf-8?B?YXI5Q0RkWVJackZVaDgxTWNBZVl3djE2WFFNV3I2OEd3OVZ2Zk9SM3h5aFpi?=
 =?utf-8?B?Y2V3VVFyZDZHWVlXaEFYVkFXeW54MjJLWmVBRmVnWjdHa01yZ1pKblNreXFX?=
 =?utf-8?B?cGNvbndDL0d0TWI3aDFzODdTRGxhdHdCajZ3Z20yeldkRU9zV2JQNHFNRnJ5?=
 =?utf-8?B?QnhUV0hnSTZYbmQ4MG5ub1pQVnR5UEdXSUxXMkx1LzErOHZWT3lqTlRuaXk0?=
 =?utf-8?B?QXpudkFxd0N0Z2FYemVuUndpWDFFZXg5ZmVVUVJCeFZPTnlTK0VBaWgydDRP?=
 =?utf-8?B?WkZFNitkc1VtUTlWZTdNZTBDWnB1NTVFaGlJWENzaXQ5ZkRWWk9YajVoWDcv?=
 =?utf-8?B?c29OZCtpS2N1VkRNYm95VDMzbjUrTjdpSkNPTlVDUldWVS9VS1ZZR1F0VS9l?=
 =?utf-8?B?SVlGMDNvb1lSS0ZXMGZrbEVtMEJlU0pjeTVzNUZSVTZBTmhGc3RtQ3NCdE1H?=
 =?utf-8?B?TXFmb2V0cjM3UWtnaUtsa1BSZ3RReVVmaTRmbGxuUk5EaHBEWExjT1RWWE9x?=
 =?utf-8?B?RTNHMWtuTlVOTElERUIvWjlVYW4yNFlzaTZFSkJzOHZSZWNjRUt6cU9PWTlp?=
 =?utf-8?B?dWRoc2s3UW0zbTVzMDUwcXJkSk42R1Z5QzhiTmp3U2ZIb0dHdjZsbUNOQXpM?=
 =?utf-8?B?V0lYcmVwVWt3MTEyaFNGOGhYVGVVOUhzZ0RXcEI5Y2NXUTNCYlhtSG9hZkl6?=
 =?utf-8?B?WDJxdEMvRFFGMGpYeHQzd3ZpTVRnM291Snk4MHM4UzRtaU1QSzgxY1lkU1ZN?=
 =?utf-8?B?WWlzK3lmZk8yRm1QQnc0dnhoazdFSWxMYk4rS0JYZnBBWTFvSTl3c3dsVjU1?=
 =?utf-8?B?MXFaSk8yK1F1SVhlV0pVd1lueVRBdkh3cWp5VlYrSldxa01xVzFGVzcveVE4?=
 =?utf-8?B?N2ovaUJOV0orZVVNaGxpV3d0VDdEcGs0QkF1VzRKVU55QzRVVzQxdDNDcWRn?=
 =?utf-8?B?UUxoZTRVejBSdDhmTXUrQll3RlJPcHJmbVJCV01WU204Nm9GejllSHdpcXZi?=
 =?utf-8?B?YVUvR1ZQbHJHL1VOQ1dlUk5RQTRBc3U3REJvSmxjRXNoVTlibjNxS0ZpRHhm?=
 =?utf-8?B?UDRZRytmNEhwMURWdWVQVFp1bEhxcnFSWms2SWFURW91Vi9KbnVOc2MzWVFC?=
 =?utf-8?B?Mnp5MHZXMXllOEdtWjNFcTg5V2dFNEQxT2tQeHJrSE11a0luaVhVQ2o1bmhu?=
 =?utf-8?B?QlVud3lObTBmZ1VpVHBOUmNyUDVWelJkNG95RTdDZC96R1NqZ2t5dndjZ2pR?=
 =?utf-8?B?bHoxaU5qTGhHNnpqZVRHa1hCeVlKY2RDSVZsVjdhSlllWlliZFp1YkY0UDFa?=
 =?utf-8?B?NEI4Tm84bHltWHFpWHlBaWpkeTZVWjBSMGVxK25TQXM4eUlMclUyUjRUN1pD?=
 =?utf-8?B?Z3NKREF6aDZCY1FBZFBneEhsb1I4eVFNWHVQakJLaE11VDFLZlhQMmZWYTQw?=
 =?utf-8?B?QVRrU2Y1b296djJQNkUrUW8wR2lWM0JaN1hFQVJGQ1NHOXNKZnJmVHhlYmhw?=
 =?utf-8?B?VEorY29NdmtORTVXaC9zOFhQWFdJRW9qaysxSXVBd3NIZ2JEdlAxUEVGa3V6?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p7PRdiLxLEGN7tBcufG3YzNykDq1y2rSeh2iRXhh/U3GLXz3qZLuPQNFS3Rn0qg1mZ0b10hOx9MsLXe+/1elkxV9PWMLUrpYdHzdWLEO/FCu7AXar9e/IVHxI65oDPve983ivKU0ZePsRliZXUmdOJ/wTq/1A7Wm2CVvkMW/MhzZkeluwD/y+3+TSTuTXyIbbWcj/OsJd41sVK4GZF4BePCkLlzJPWw7iFTPxnhibdV0IQtYsHakSd0lfp4v5uJ2aD3jefW9uwgrieMkp21LFmxXah5K2kVt1F7TUA4T2SRrVzVMd+rIAV3pJmsj61ggwqBL+KAI4cMdfeyiF4g35fvpfG6p/hxhSFPLHUkPszV7VgUtJ7+ZNv24ALBmcEZupar8SynwtE9aIrMGGCnZcojehqDiVZXeqFhIkLklCv0dkIEzHEgWJ9ZG16EGVvAS+LHRUcUm/Y4kG4GOR5xnpC+SuojsJoWicbvP2MPkSKuLT0/xHHecw51Kd4ExdTH/L69i5dKUHtPh5ldteWXviLPDLbU5wFMNeueAYI44PezUH9utY1MO0YGp0w1t85f6bsJF/qf9pvaDfJeZTHTDLy6uBBQmhZFPTT2NEwR+8P8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be06ce77-0123-4c6b-4f70-08de1142f37a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 08:13:58.5078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WSsO0Rb1hYVDRXVJbvGXcV6g8FHg7lA+s8YwEQUhCSEOgnV0O8oLezkgZJdlYIwj17ga97eFjK53l1WxnG7H2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7311
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220065
X-Proofpoint-GUID: JXNwS-nTmYNwFFzP_QsjsiBDHJpdlcuE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA1MCBTYWx0ZWRfX4/gO/AjZdECj
 rbkCEE6DBiAhaopQ3/kHGdAah0ZtPNlGYM6v5pyEwzft6YuhAWhOdMjaB1Z7mrIVGUXXWs7krX3
 i3RMSgY+SNRXQ8tHCrM6RiC88P7DYFChJ5olWab0SoJiiaHnbpUD0TksaZZa6YMOtM35Dg6DTFl
 Su2jyyNRXJqYRMs+j6sKp3GwOvTRFdkaTi4riXw7jyci/w+5bzNYVORz6Sa6Us0LdW6NCHRabco
 ZhjIjOO+uEaeunxWuEVCnRtLjCC3epGmBzjRVdVXL3N1e9uyiCZk3e7PtszN7DizJt/ZXwb3fLT
 Oy+cZeql168hAYKX13SjviwajnQaSGjI2wxQ+kc63s7mqKMHZqPESYwPSvNS9HF0JxCr+lki3dO
 CxhxQTVDiYV8WRQL3QYIQIkihEovGIQOT4Mv5DhCliMjrbHKEXM=
X-Authority-Analysis: v=2.4 cv=OdeVzxTY c=1 sm=1 tr=0 ts=68f8924e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=MKWTulNytnU2kOss9gAA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: JXNwS-nTmYNwFFzP_QsjsiBDHJpdlcuE

On 22/10/2025 03:26, Martin K. Petersen wrote:
> 
> Bart,
> 
>> Commit 995412e23bb2 ("blk-mq: Replace tags->lock with SRCU for tag
>> iterators") introduced the following regression:
> 
> Applied to 6.18/scsi-fixes, thanks!
> 

I don't think that we should call scsi_host_busy() on a shost which has 
not been added, so it would be nice to have a plan to fix the LLDs also.
