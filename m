Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF42211C
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2024 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732035961; cv=fail; b=gp0TiaSHgg1Lw00SGwuAgAidY/s0wX8mZLWHXlfXk1LFYgjSfe5jxW+n/b4YlTZd02P+o5UuXxcyXNILPX7rGib8wwsZC74eCXuiJdoN8/gx6VTcFSRdoqiztjb0Hh/j9aCvwj0uNq+ZtYW5+yHT0cFyFZOadQ8gkbPT8CGYXkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732035961; c=relaxed/simple;
	bh=3LHr8JeabJ8HxSkzhZ1AWYq2b+Lt+a+lMum7f/BgpuA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lGzRbpH4XYFTJ8pnv19qU2CHYN7kRUtORVLGxYXNo7YVr5rqLFmhPv9sVgut7blAAOlzy0TgbdOAzFQOpV7fEladz2hImpYTa6ogMj+YF+WmX+9vAvAs9y02BeL4b5OR+3vKPYy95rd1BQmSvtfj25ETY6x5a8x2nFkfAAB8Q1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GV2FudBA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z4pjs52E; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GV2FudBA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z4pjs52E"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJGtWF4019445;
	Tue, 19 Nov 2024 17:05:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=qhwePsHnmm4KgoiaUr
	FlvF+zFLo8LfN1jlfTSAHxdVY=; b=GV2FudBADlQmnaJ1yeLkhr44xd1Gj24VG6
	6Khgpnmk/olbeY6WNV0CzQL0LILuXCwtLwaivdoQVpyhqwLPtAT3nsJeKABwi0pY
	PxczObwD6d1bwn90CaePKqEi5FMsqgCb8cSVMZhYoH3eSh7sb/GfVRWqQukVc7fo
	/1i1QpQFukx3CmPAeU5NkeOVb/AHlv/rCJnB4+6j9g18/xGo7mMnMEbZAOQZjvZt
	vQnJiBVaS+4ub5v0WzaNKhoxRs4XnbsPxXhxqb5K22q0aukwx9E/TJxcNeqTmrgQ
	+Tg4HryMAwEn94SpXZDJ7jgF8kTp+vhiGse5rjuYE9BpgEv6SP6Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42ynyr3xmd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 17:05:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJH1N4Z023156;
	Tue, 19 Nov 2024 17:05:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu97knw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 17:05:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x0dhQ5Mm9o2NqmTt8NKC+SH9T0JsXKDJSDCq1kImwByYjIkjh81ozLrEu5QxfSohx3Z47BrJQl+xjnxOF/aaJM/R6CkISKQxbsweGmOkY3D75nZxenqilEqMcKi5NK2A5oXim4Q/j80V1MVSEup63xNZgQG8d6goDq24RE7JUtzC5CQbMTCrBkQRzoJ0jlUhWdSQdRKYfteJ8gTFoUQQTk4xDOjlXn9pcyM/y1ufZrRxb6h/ZuYDrjW+d1A1szNEEagPBJZ8MW79DosAtuiIAhefpPrhbQBIGireppMvb72NX+VZlQhRe5RJXE04K+5uT0hx7njgyGOJ9pjqN3fnFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhwePsHnmm4KgoiaUrFlvF+zFLo8LfN1jlfTSAHxdVY=;
 b=yxddR7lE8cQOcxWYP5gfgh45YIBXPgaNe0FAx+cnURZ6Sbw1CfR4D2ex54kcF2PbxD8KGgm7VeUsKra9YZzebfwRTgYq6dl0SK2qUIBjDHsrWWsXRH6LJowIWNoTrFqSzETGFACGG/PLtjhI9Te1k+JujL3QjEDXoT7D987I4VyZIFmRYaCsXHFO5kQ4sjju6mahVfQu7N2JrsoSJWOTwbWPzoRxlU5rSYySCzDIU7woN8SWDvlxq4AcHXol2S4fAwSVUQ0bL4LT8ZI3uP3fh+06q3HW8MpqcrI5nQKzIjDU0Re0yHPMp+qi7acaFyUMRSnVw0zUALw0jOXwo1KkfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhwePsHnmm4KgoiaUrFlvF+zFLo8LfN1jlfTSAHxdVY=;
 b=Z4pjs52EXjWSJk3Q1Yp1sWyk6ikWTHyARE+4vBMkEAu0Hkb4S4Apq0dfhcCai+OZnukdC+X1hOoNU/r6VOwp4e3ezDtiFJ29wHUZUOCKvpsltZSGc4bmOlYIEqUIXp7bOOizxT+VB2oezfZjJMwUxye8WLOPRiTwsNn+SSPEvCA=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by CH0PR10MB5194.namprd10.prod.outlook.com (2603:10b6:610:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Tue, 19 Nov
 2024 17:05:48 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8158.023; Tue, 19 Nov 2024
 17:05:48 +0000
To: Marius Schwarz <fedoradev@cloud-foo.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Subject: Re: scsi bus disconnect on high load in qemu kvm anno 2024
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <3a274d9a-8ff9-4cc8-8f4f-fd4cf98c3a14@cloud-foo.de> (Marius
	Schwarz's message of "Tue, 19 Nov 2024 13:52:52 +0100")
Organization: Oracle Corporation
Message-ID: <yq1r077qiam.fsf@ca-mkp.ca.oracle.com>
References: <3a274d9a-8ff9-4cc8-8f4f-fd4cf98c3a14@cloud-foo.de>
Date: Tue, 19 Nov 2024 12:05:45 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0377.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::22) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|CH0PR10MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: 2520e272-6b8c-4b33-5578-08dd08bc6a09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eJ8y541Gn4FagS5L5Tyvks8nDgap0lQa/s5a8+1g4HNynAwLkUGQ6aJq/lLU?=
 =?us-ascii?Q?h08Vzi9Cj+HzfvIzqYu9ODaU1r+aDIWiLtGlAAcXbF+FpAYIrSQt0b8oYHz8?=
 =?us-ascii?Q?BqBRUHQaFbEUaw4/zMShjcrnytBOe1dvotmUcG/yVsjsv2pAr/fOjg5zskU0?=
 =?us-ascii?Q?XjHapZN+sr7zAKhinBZGpND+dHGrCb0QF+szUWT3659tCJ4sxxiXZzwA5Sge?=
 =?us-ascii?Q?R/4JTx3dz+eGScmGWw/DpdF76wty0mGbedqoJQNqS/QwGgQ7uetGrulWNp24?=
 =?us-ascii?Q?KlwZhUXsrMpRCtZ+ieL0TVWbdxWqOak+mdDd/EmHG9DvKD6p/oGaat96wI3Q?=
 =?us-ascii?Q?q6laGcyC3hO4uSJmtzYw0n0X9CXupRNQExCqNIKzX2a5jQ7IKuVDwRUqu2AI?=
 =?us-ascii?Q?ynr9IWhveBS+t7HuPWREZzbpYe6N3fhXohsp/HPf8tRw/eOoOWq8LYJx49Od?=
 =?us-ascii?Q?SfmWAvvlpv2+kuUIZqZEOqXVddHYsG6BHX/X1/UgpPH06QcPB90UNeBOK9bE?=
 =?us-ascii?Q?GWbfRivnIAbGFIgx6A7/2J2I+DGLS/63alZAqgpFq4SikdI2dZGwmyS5Wntw?=
 =?us-ascii?Q?wVMhTGp/mjk9oIe3ood3OkE7ujcPk3btFcyT1gEdT3aE1qyp+RXwf5Sh20Ha?=
 =?us-ascii?Q?ONR3rK5NjHRk7o4JqvQvi1tVD9YswdtX+27ImGaiucxZZqBKtr1GEEzCDnRP?=
 =?us-ascii?Q?q2LVuo4/2GaRmjuj45F7HayWaRs6XtH6LLqz1V20JxlrUXgIgKLYJI5RDt6Z?=
 =?us-ascii?Q?SLO/AesqUmHoxlJ4kCgNKnP2/1YsXfT5FNVee/TG9VTpEQl45PsVQobD9EaU?=
 =?us-ascii?Q?31kNSp/pvO8r+ZfUO+xCVvk836jFGkRQ7u6/JY2gxfYcpII+kQLSP5t1fnxf?=
 =?us-ascii?Q?LogRGXJ6go6oy7+MzIBjUejKcPThQN2+g1jYxpyAtdoW8IpdLdY7K/wV2JFA?=
 =?us-ascii?Q?z84NY6Hj0ik5L8cXqVrWGvTQLUhV6tOfnlaHOu3v0voTKbvk7a1b9bZZQbbP?=
 =?us-ascii?Q?lobFDCmeMg90i+ItXTFiPBTQ5+OVqsmhRVBPKlL7mqaDi75KUBuoxvuyVm44?=
 =?us-ascii?Q?P2VmlxJYjfeqkwgOMPb346BpvU2D5M67aN47WnJ9F+I2bzTaLHD8qqbpOWpk?=
 =?us-ascii?Q?5hGm6WiJIvAY0qHTqsdpiS6GrgVSj5LPw+eo1V7iuCFfAO3qS7Q1XO/hMqob?=
 =?us-ascii?Q?dMH+GyV0wBpVJFYrcdDJrfKY5B9KG2EJKWb2x2d/E71m5RuNRbByiko4gZLU?=
 =?us-ascii?Q?Sg48r+4Kr7JWAQ2KwzgjCES7nbxGlfHEmzqXvhigrvDvu99GCD5m4l0n+T/d?=
 =?us-ascii?Q?+igenEoI/J8K+UBi680e+r4M?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rktpJaNjsck+vciv8RsPCRVp0sHzKEoVf0qXd3WAf7eDlTG1fEugC6Hi0t5p?=
 =?us-ascii?Q?5ai822YH2nqhcqaRe9nMj+GzoXuShQK7r44+//emeZn43KGh09LNNntfV7du?=
 =?us-ascii?Q?JdMSr3GBZH2jK9z5eBVvNfIPROqMMBi0bYqvc4dKrfUNWG1Cq6q8BpXB+pZO?=
 =?us-ascii?Q?2/WZoWGVSCbXlcxLYpcR2JhoSwv4/oYWcmBj4HzjN5iNxnaGQhAJhqa/dHoM?=
 =?us-ascii?Q?Z1g9ltHsRQ174rCPcAfndPwKqHU64cU6PNEzjEtmmLFv4lj6Y51N2WcNdd30?=
 =?us-ascii?Q?iw+eyAcF3Ec9JqI68q7lBTvP3LAkYG51SiZmAY6jzSq+iNK1XY8ulOzxvYjt?=
 =?us-ascii?Q?xtJcz9519NLKd4706oY9YK10Vp7wWuJOf6Oh+kM2zUWovp8669OEJHnmVA3u?=
 =?us-ascii?Q?livkyQw/fg776Tvqqz/8YK9U1bC4ug/kkqA3tod9KeGiAq3mfKVRf07YisBy?=
 =?us-ascii?Q?U/QrMKPW93PUWHAUIEY6M2bUF/SgZ+dUuoZFXkjjds4yVP26agV2HzmQhZ0A?=
 =?us-ascii?Q?4U24wQKsqDraZBOlw7Z4t0gVavlx4be9JwlBA6C7kvJlgvcmRfxrD1giK6GS?=
 =?us-ascii?Q?OwpNALGaIWuD16OP6quYkphsRkntUsX59p+5k6eCKv9Qq4rgzQy5iFCeHa+K?=
 =?us-ascii?Q?uYER9vpA97If8pqhm7Pot+jPNEQ7ZAprHtxwZPIh0Pouuz/3qSh+48Eb2SeX?=
 =?us-ascii?Q?+SjX1JaoE6852DMMwWSNLoIDmE2nxBKchUtvxMFm9V+FJRDokfazgakt7A1Z?=
 =?us-ascii?Q?+6xKCOthZuHvT6SBX8DkGz5uqbfzJdN2yiAMdcwC1rvIdlDijiA1JA5MBlov?=
 =?us-ascii?Q?JG4rTvpCNb0T084f9HrcasT0kFZFW6BE327gIxl4vnr2OeOi6kA4pULRhg7O?=
 =?us-ascii?Q?2xUxUzZ+XkgSD2FAvARhyAdYuYsfUsUF7a/JRbUk26c0QKZLcMtXP3YwdEoI?=
 =?us-ascii?Q?R8q1FseR8Vza8GafP6LiNzqdt8qEocyRXbTyhaqJD/PHKQFpNP5z8p52TavW?=
 =?us-ascii?Q?OIGRDPC3ZS35cC48+Tp0pbC/uRmHpUHn8PgcQvuyni68CWmJo5GEJJiqawma?=
 =?us-ascii?Q?5LyLIxvd64FQwblnBPmLbPApO5ZhQcF1LmZzTNko0ZYTpl2UInBhdaAwN3Rz?=
 =?us-ascii?Q?0JHs04U5LCn2B6BrZP7ySkSJQpMpFYsqKWk5vFXFIXBXXoABwHbbh9c4ey/+?=
 =?us-ascii?Q?MhvYmU+c3BCqIUN5iyuZpgpC9S1udlPYFQ1F3HvQpDA/KsmM/+pGXLHYQH1b?=
 =?us-ascii?Q?VgyI+HTtXXDnClDuv13n2d6BTLrrPUJ3a8TC6e1C7rrBZ8r0/F/PR0TPFfBP?=
 =?us-ascii?Q?WCLzPHqYrCCxYC64b7RKI/UCjjFIN30/5DspypHSAyUwJ5XOhUhW30mo3FIe?=
 =?us-ascii?Q?qZmGpawbMSMOzhv/ubBxPNCpgcO8kZMrqA36X2tMQJaZIUjLNY54URu10g8f?=
 =?us-ascii?Q?dOUa0RV7G6Reg/EfRVUPhP5EPBCEw2T6Q0BOPNRllYoTf7S63NGfQkGTAkq1?=
 =?us-ascii?Q?ZhCEWM5M2GV4AZwFt7VpyYAEl4lSC/fijrZbZE61HoegrvDY7AFXQeZrgdRp?=
 =?us-ascii?Q?V113ip1JkrPLwQPysYmWd8BOu4soBhbB9fZ8cc072vCZcsWHN8aH6Th+k1tH?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	14LJ52TveNVKVJjHHBg27N8YlexTqZ/g6JJndDwxqMzYzV2IRPzECG1O0Xob0vg3vhbSNJNFyxCCuDUEELWPsykIh52DWDj7ji8OHg/E4xkjuKEOBWQEhlu6RNE4kVYZyRhEONU8Db2hLSh0bMjABkYosIS6T2PmqPp8yno1GGBnPyvJC0A9DLt3xNBcuTKZ7G0C4sWunEsSHd0VtGFc2+hm9CCpr6hIULI/ZCN3UN8ex0tHmgEgh8YGIsVaYZdgerDrCZRPuzd0Mj6rRYgeBnN+yvzY2yPFmXdDvp/Oi3IWT29g+mXj2IdSUgwfPKuuHdVCVKcQGhOY1PW2NJ5+y5ZZ8KVtLmfoMCWsbHY++npDEkoCuJ+7qLdu8uTDmuSVej3WfU+6PtTl9wvo3uAh8xrN5KQIYp6jH0lLjEIgkhmJ36567wo2jfzUSDjVwGmPGKacn5XcluecVebZeitNAZTVPD71U9pKEi6yzCvyLmeTUlKB3hiXck9Lb2QYYrW1/HGT1BaGWySXtfS+ykBXO7xQlna96jq4ZkdCstm3WpkrXSxqeBsbwR0fnwFINBiwHpSOg9CgYCunGjgLN2gyX/ykZiwYlJvTst483lFh3gs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2520e272-6b8c-4b33-5578-08dd08bc6a09
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 17:05:48.5429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pO3hO2oUgjWu9NdNdCSzC3ZqkhSiz4qHxoH+J0Ec24VgoP1RD1UzO7aiZVUbkwfpFCcfAjo2S/IFiMdZiI/z2WfUEDSwjO5HVxdP1ghMvC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-19_08,2024-11-18_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411190127
X-Proofpoint-ORIG-GUID: 01eRwAnrAW7DT5dKT8ShT7-XmAheOOYX
X-Proofpoint-GUID: 01eRwAnrAW7DT5dKT8ShT7-XmAheOOYX


Marius,

> [  +0,000007] sd 2:0:1:0: [sdb] tag#325 ABORT operation started
> [Nov14 23:50] sd 2:0:1:0: ABORT operation timed-out.
> [  +0,009594] scsi target2:0:0: TARGET RESET operation started
> [  +4,905550] scsi target2:0:0: TARGET RESET operation timed-out.
> [  +0,000005] scsi target2:0:1: TARGET RESET operation started
> [ +34,407328] scsi target2:0:1: TARGET RESET operation timed-out.
> [  +9,829432] sd 2:0:0:0: [sda] tag#76 ABORT operation started
> [  +0,002336] sym0: SCSI BUS reset detected.
> [  +0,002062] sd 2:0:0:0: ABORT operation complete.
> [  +0,005062] sym0: SCSI BUS has been reset.
> [  +3,193215] sd 2:0:1:0: Power-on or device reset occurred
> [  +0,000057] sd 2:0:0:0: [sda] tag#76 BUS RESET operation started
> [  +0,002319] sd 2:0:0:0: BUS RESET operation complete.
> [  +0,000008] sym0: SCSI BUS reset detected.
> [  +0,006945] sym0: SCSI BUS has been reset.

Hannes made some tweaks to the sym53c8xx_2 handling about a year ago
which may explain the difference in behavior when I/Os time out due to
load.

But why rely on emulating 20-year old hardware in a
performance-conscious environment? I thought Proxmox defaulted to
virtio?

-- 
Martin K. Petersen	Oracle Linux Engineering
