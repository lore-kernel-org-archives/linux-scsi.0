Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EB342C50C;
	Wed, 29 Jul 2026 17:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785344744; cv=fail; b=VQCeGohfxsKJlH7buyqEdaw4cifoPmzyuI9NPfzAL+ehR2j6ha1aURVJpMkbvDLEcF3IhFLvM2Updooc5EtyZomJwvEB7eCX+TIjpBm3tjFETPE41XKPtDv5bMMe+QikjOhZeP+IMlzDCmn+Ld0Bf1nIfgv6I1uE+HNUiMvEFtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785344744; c=relaxed/simple;
	bh=HEqRaktdG+kBn+23i48kpqjbbNUkBlKmff+9m3LOFYo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pZMfQzWUmqpKgDEw9XWtABqvCQ87vPGXq6DzrbCmiDBvZTVTxgG3W+TWMni96tGl9wmSBXVdWrHfcNgqpFu3k3AlASGqYQmTKY2VnW5YHIaBt8tfw4ThRo5Zmm4w1oUARpwBbNfcd1n8bVQahrvkhGhhtcuy/+M70hsNqoywBjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ds5+X/EL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qc33lrBc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ds5+X/EL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qc33lrBc"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDYbun3039847;
	Wed, 29 Jul 2026 17:05:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vJ9aOqG5DEVIllVeUveibL6FUZPAHJ5AQZvZMGg/0hE=; b=
	ds5+X/ELZJZZpIQQo+dNpRd9mnPh811PYLtC5ScXZ84vRo80c6n1+TFwA3rhMHdL
	puioS3lWr+a7d+ZT1j2q2r+BaZ+7SssRfQ3Y8d7dD2ufQtqviJ8vToXQ1JO1lUW8
	NF4G1pQHCU5O8nUoWjcruy2AZZtZcmIOV9IpGabHXJ53lQDKOe3xo603DWfpKAwQ
	SaUQARIAZ32P8NJyH0bwR49or4i6srzidRps+i9RXTyyOI/XWSoIEZd9P/ez5Rz3
	/GI+PNgTfdW4k92XVsxSo5V4adH1Y0U3f+JvhjroHPsXPRWBbYnjUHq5vVPHvEqO
	QMZIXvTWoO48EJTFJTVQEw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xxb8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 17:05:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TH0esH009010;
	Wed, 29 Jul 2026 17:05:41 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010025.outbound.protection.outlook.com [52.101.46.25])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8k1br3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 17:05:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c0H0XD1HVCcN7DrrZOSKlPzG2DRyVgQw2GiIJpcbtM8emeYgJzndNh2wRbrMRlv/a5PFWQ6E5Qq+xj1u6H6eeL4epx+kLHSkd93q3fwgptZ6rdluaAJk04uf5ICy9diOoJSXtJotIVfBBz8BWx/ft5t6Q5We4RZwe7OioFfQthyxl4OtIxL/rvH07hDoQwMknOcfbKwj0qX/eDTY7e/bxGVH4no/ZaoSh1Fft3SccTI+6FKSsNWhfB0HuaY6AfVrkTiRSQ19VbhcVOhAn2cWXZsnkAIrdFGM9s3xMBX4GRkVqld1TCroPup0BM+ewbNsVLQCS5ay0kZW/sjEULd9ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJ9aOqG5DEVIllVeUveibL6FUZPAHJ5AQZvZMGg/0hE=;
 b=TDBRWlk9Oh/poXVDgGsAk7DyjgNFf3D6G0zlsjK1RDMqIG0083S+IRecWUild9LrKkcO+YFC6BqZr8EvQU1Muf7po0C3Fc7Khf8KpVJVNhHXn6TwUmEs1DDtxyMCAEFLyTkkPEm5WzRap54ocr60BQXL+0BqwhSZS5IfGxyC5d0uNPLCqTd5aEszhtLuz3XE1kuskIWRtZtLRPhFjRi6vjhZzGlQiDZIeFNcqFSPJ8jh8fiwXh/zFuXZ+T/V7qR8VzRHwvdZyA9do3h7bBg/QWJfZu7mxZStmpAjSon4q+Ifij6gYh+07TaR5XXi4dwyZMNvnS52DAmvyOVqnXRBvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJ9aOqG5DEVIllVeUveibL6FUZPAHJ5AQZvZMGg/0hE=;
 b=qc33lrBc8FszRpVnvDd6Ew80B7EYxm7B8AlCsWPr23zqWzAKyxTd12xcFwxX02TxuJ6T83VrS7D/qMw8EmjqMg5buqbxh9DiGJZlTlaaB8CHAtDuCZ2I1UTQM6iJ7EIOSJZu08uF2qysfyqK80l0n9zxmnCsaJ/53LpMLF9ngHw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4667.namprd10.prod.outlook.com (2603:10b6:806:111::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.13; Wed, 29 Jul
 2026 17:05:14 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 17:05:14 +0000
Message-ID: <87916280-5bb2-435a-abfc-9ecab8e4e28f@oracle.com>
Date: Wed, 29 Jul 2026 18:05:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 23/27] scsi: sd: add multipath disk attr groups
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-24-john.g.garry@oracle.com>
 <20260729164842.25B4B1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729164842.25B4B1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0022.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5b::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4667:EE_
X-MS-Office365-Filtering-Correlation-Id: fac03fe0-17a9-416d-2bcd-08deed938e6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|6133799003|56012099006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KSZinIESMx0oYQjLnTYMJhzJ70i514D+7wl/BB6FouX9Kd/Rt8EPm7aNr4zTKj8xKxHVGwYuzpTLTAc8uELWzU1DD+4O2djRPghqz4rY40zeSGrJQ+6j7gvQL1ufOqplihMqthPPGhxhV+l+Y/vk+S6IZdQ5aEMOuSa2umVTVZTVE0UWj6XJvHM6OG557oy+uHBVL/4Ycegym+r8B/C7XpN2SZZRSwDvtXGACny1QIRsTspnagPrLJtCY1Ssak6Lz3TKZJPPRLlJuGrYULAMr8xgpqo4X4EHiJcqsAGBCJ+8MPTsC7Wp7r+XXMhrUZRv6QABCB/sYf+MXnhXHDN65/uL3JpCNjULfxdKQmj2z0teE3sOIIq610l5FIOjaw2Epu1vjj6vX2zvcpwZ7AuC8pe5WcIQshzPzQ1fmj8+ACrWU0f7NrsiS9zG0m839A7243cV3hhIfwdpM/R9/sVI7u44zVGX3jGfPoKKY6O/5AhnCnzOlJrLBpoHzefuVqDej/j9bjHLZX7Tbgp+DgyCrz26RGJT8ErcJE5S8Ez0va3JsZ9tz4YnMQvr3aXhuGim4nPkeruf/jHOEoXltcqRXljfg5UrA8O/Kv7oLEClWQt3CXjQ3e7+FwB8ywpy+VM36j0IBXoPTNCfch9HjsI5Gzl8oatyMnhgQXtQL5apbXI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(6133799003)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YU1ZU0FHQlpWNVVVYnM1SW5rRDd6bjlsOEdsR0JmMjVQZ0lHaFlmVDVRUWI0?=
 =?utf-8?B?NWJMVzczdXNWVHNGWmgrWWFpWXNWaHVxTjk3dzhPbU52RXRWTE1NSXFsRDRl?=
 =?utf-8?B?OWp5c2JQTEpqdHVXQ05tRFhkaGNGR0plRE1ZQWNkZDFwdGFBYWlQS040cmdY?=
 =?utf-8?B?Q2NWWUEzbGZFV1JjMkhOSlk1WnRIdlQ4aERJeFZIRHZEZklBT0dXcDZqNllI?=
 =?utf-8?B?RHF2a0t6OU5kL0ZCRW43QnNmbWlPa0pvdlZ1WTA1V1pLTkoxb3d4MXBQSjVY?=
 =?utf-8?B?YVNIS3VKWFpPSE52YWxYbThqa05BeW9YaSt3ZHE3bmdLdTRUVzExR3VvbDhC?=
 =?utf-8?B?b2hBeWxIYkVEMGdLQWI1VTFNNmJSNDdscGdsaTZzbTdORy94ZzJvb0lwbUw1?=
 =?utf-8?B?LzVhU2JqdVF1UWRvbWdGVEk5MUEwdHh1dmRiVDAyOGQ5eEJSRU1RS1NXRkVP?=
 =?utf-8?B?NWUweFpUSGVsT3lwaTV0NS9wSDBNTFdicG1HTDBGS3hETlRDY216WTZKQ0Nz?=
 =?utf-8?B?UjVxcUcrZEVXcnBkYUtSa0lSVy8yK2x4cGNXUHQyRHNaKys1WHlGcTBLUFNw?=
 =?utf-8?B?ZU95Ti9oZENQajhCSUJibWkwaStUcHo4L3kyUnYrNWpYMWU5TGdGZW05Tis0?=
 =?utf-8?B?aVYyRG8wVk5ZdVAydU1xblJBdWVOR3VZcEtTcGlkWXFSMzBoOTNjcFdwWFZS?=
 =?utf-8?B?cVNhU0FVb0ViVHVxbmlRbmpieVJCMWh5RmZtbVpQejFxUnp3N1J6T292QVF5?=
 =?utf-8?B?UlFsZmllTEVGT1BQR0l4cXFCYUN2K3I5UVFYWnZGaDNlOE05UkZXVWtrRjEx?=
 =?utf-8?B?VTNtaXBMYldpWm9zbTdsUDJaZkhBZFJiNm9VWnl1eU9qdTQ4M3dpZmhTTmF1?=
 =?utf-8?B?YXhiTEdGcVdCOEwrSHZkWHlST0NMWk42MkZDYnA1blE0QmY2Tm51MVVnOVow?=
 =?utf-8?B?SkZWaGh3ZEVkakxrWnRQODR5blBraHc2QmlpaGVqTHVZRHBqVUdnazd2TWJX?=
 =?utf-8?B?eGg4NzNDKzRtUkNhZ1k0OE45ckZheEd4MitkMVlzWWh0dDAvT0xoSFVQVURs?=
 =?utf-8?B?Q2V0QlBLTFY5ZHpKalJsZDAxZVVCV2svNXVOYUpFV3gwUVpRdmx2YUFySGE0?=
 =?utf-8?B?dzhhbnpyNjFmS1I5N3ZQOXB4UTF4YlZTdkFhZXM4dUJ2RzNIeldkMjBoSmxS?=
 =?utf-8?B?a2RkR1lka0NvUGRTUU5hVkIyTnhTQ0ExSkpQeHFyRWV0TXVWU0VuR2xTUzlh?=
 =?utf-8?B?aWMzaWRBSjNaWDBFVTUrUWUvOGIxUDNONHh3MlFwcG5FS3lvN1dMbEx2QkNp?=
 =?utf-8?B?MHdKOG1od2pXWExtT3R2dXB3WTREV0c5UTRPK3hxMlBOcFBiaENsRU00c2JZ?=
 =?utf-8?B?RnNaa2pHa0Z6Q25NNXpRdU4yZ2M2SURkdXEwOVAwNlRqVUcrMkRXRldtTDlQ?=
 =?utf-8?B?a3R6K3VlQU8zSDlpSFk2OXFyaThmbm5oWnpBN1M5Zm9meloxakRwL1JEeHJN?=
 =?utf-8?B?UGVlRlNVWEFGK0c4VUh4T1Fjdk16aUg4YzlBeHdXR3JQS3o3Nk9YMDVHMkpU?=
 =?utf-8?B?WEJHbmd3d1U0eHMrN1V1ZlhKc1M3b2YybUdqMEV0N2ZnL3p1cHd3c09RYkE3?=
 =?utf-8?B?WjczNXNYMS9wUWZocWtranorTmNjNC8yMDY5d01taVh1V3J2RjRWYkhYdk5h?=
 =?utf-8?B?VGgweU9aNDNtUGxNU2RiZm8wQm5ueFAzV01XY1pkcHlFV2tCa2R1eU1SRlZa?=
 =?utf-8?B?OVYxWnBiMGZZYnhnVkZOejJncGhiZjRlNHdydTNUTk00Q3hKMHI1TFg3M1Fz?=
 =?utf-8?B?RDVrU2RhQjIrY2wvcjBPNEROM3hWUHJpTlhYaUNkc2NPRzJqalpXbnEweEZv?=
 =?utf-8?B?SVdSRUpZRDAxek9HSkVzVjF1OG14Wmh5ZzFIaUI3bTIwNHlOcDFDNmMvTmpy?=
 =?utf-8?B?MWFTVHFpUmpiS0pzb1MzNmNJVTVlbjFDUTZBS2VMYjlQNEl1MXNxeWd1UkhH?=
 =?utf-8?B?ckRoL3UyZFlmbWNFK1FtODNwMENPbTg2T0JHR3FjNmxYVzZ2NlUya3ppcWZr?=
 =?utf-8?B?R3kyM1BneG1GR0FlL285Z1JMcjJabXAxa2JYR0h0bTBKbWVBMmpvditLdVBU?=
 =?utf-8?B?SlVSaUh0TDhXeEU1MDVDMnFjYzJOd3ZUbHVDdCtLd1NsOUNvSnpzMldFRVJl?=
 =?utf-8?B?Z2t4N1FMOTYvQUtnekRWbzZtQVZPcmJXSE13UXdEenFVcFg4eWpCQ1dVdVE4?=
 =?utf-8?B?NVRHYVdVaUJ4VFhvVEx2TDdTdWg4TTU2TkhRNi9NUERxa3F2Q2J1eFVrMWRZ?=
 =?utf-8?B?ckRVUzdZVWJaRXBNOGRKSEl3NHcrWE9PY2pwY0hMVU1FeXVoeGVmbEVQdjcx?=
 =?utf-8?Q?Y6zgfpskAe2VTNPY=3D?=
X-Exchange-RoutingPolicyChecked:
	CpGJCfC8R9f/oEUkyxI4HIJP2YS/e6kZzswgdDjR9kpLJgRQ9SBtmkClEfVjVGZUa9KNu0BUIaZtAkHDytNnkpHarQbWKOeAbcgz8i3OfzDuE224P6hvz6tb2DujMI6A0phV6g0X8iJmTNuEMxNJT22ZF49Pkae4gOdakkLAEBkCPFR35c/j190nuBSRlep6PboE0NqK//KjeofwXRrY8baSAnHefGVG5EzHgzlooryN7cKCWnOJoaEXf/Ho5zo9Kwl67fFBWj44u2G+RFYCXfyp1fdUm/xwpnH5I8Uf7Jdhk7xm0RNjn5rdPPFhnh473NHzDsYZt2T+WxCKXClZug==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6juC65X+A7jqMrwkOTJwC3tkmXdQ3oITdsR8oyad0TSG++5bTDNT7Cf0gYNfqX47mNFRX5+xoifAAdwGYJgdeAdXqI8GOjJVfIpUKvtpxHlv0V1UGwBrSrylVY4TmjbojTXUUdu0GliPVR3i8Q4/U8T4B+3GsnVunfSUZzJFpLE9lyDtPJkCsgHQLvHb8VG//P6WIf1t9FiFPcVBJfcS5mrKzGA4fQ3Q82V/MzVmsbQqTQSLRK9m2CNVmWQm+WVt3xSdzy4jc3z2cBjxaJuRv3ECCUpN0ydY6/rrkXmmUDYXMm6D7bf3SdFWcHex8Vv+u71H5F8BTfuHu6UxSyumh0vF8tmt30Yl9WB4Q0ke/SfOTuvAMryrR9Eb+irtS0hThqcFeX5JRd/6E5RmQ69t+VZx0ovb+TLeaWA3aHsakm4pugSTt2o8zlI9oTt//vfaDaGpB1y0zSMAV66MAJdfOqRhY0nIj49H1iGQiBXCMLS24D5RkJAv4ZL6lZ4RXxo5JfYxhm0pbnT35InZD4qhFwSv/EBfKeuvXyqlQYdBJiYhGfJit+jJHN5Ga7JKUxdvPZ+xY/QeUL3sgtI6ncDXS0TwdF/KUTwqpEit0TWIhzY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fac03fe0-17a9-416d-2bcd-08deed938e6c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 17:05:14.0512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jz4eKcTqvfoe/lvPhABFYjWtBmU9Kx37Xdea15tXqzowgKpdj2WUjw2G/KUE/+7eJN5KAuNUl9oCeDNf4gRu+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4667
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290133
X-Proofpoint-ORIG-GUID: tXguOco47C40JaPwPmmEvgV6xRfoXz_t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEzMyBTYWx0ZWRfXw7DUBavjnnf5
 tiMNzvMQ47eXz+9W5nXSbJUGsKMtS/vpkX43T5E0MDgtiAqWEwPWNLX12zWGti6GxCoDEh7piFf
 EO5Le4E0FX4o+etStIc9NPvQUB0SiWrvpFCPC31lRnsJ+ksKYUPP9qZW3geRnutiSVGoNLJR4lC
 yBdRxFJPUxByKZ0IQftXWpWdT6bk5cTEcLqLnuOTsLDZ6C/RemWJRjDjnWydANLC3q6B3HRqrch
 27MKsbMLebSMzmUkwln2nUBRhEUDHiCWpizilwIC7ky/QLe60yXI8M+kOYNoTmoxnptIJxFsWoH
 vOdkdQtg3uDFEeULLyBVNuBlA0wunsqWblpPxCyudlwnBFMGnQvzqNfKWaSV1Owv/v3nKwKCB7E
 Ql1LAkyBjsk8T+LQ7kF9FBpxkVIRgUsp+64mA3U2bBGjrTVggdBEMhBLOHpCnv39l462r0T/536
 kZct9FfoTwWAMaeluSW20H615tiDwVfI7bGT5HPI=
X-Proofpoint-GUID: tXguOco47C40JaPwPmmEvgV6xRfoXz_t
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a6a32e6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=vaHYCAQu7TT825BQN1cA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEzMyBTYWx0ZWRfX60/uns4Wg451
 FesQZ12+iEDATDgCRvVCXbVwrLKe1NRzEr9W+BXK/bX91tzl3ijOM/K88oT9nB4vO9eLqr3dlKP
 DWlUdda2gLB7OmmmsRC33dEb1oXKrBeM9nDqb+iHnWKJSu0diVBI

On 29/07/2026 17:48, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Medium] Result: Dead Code. The newly defined sysfs attribute groups for multipath disks are never assigned or registered, rendering the patch's functionality completely dead.
> - [Medium] Result: Latent Type Confusion. The `sd_mpath_disk_attr_group` lacks an `is_visible` callback, exposing it to a fatal type-confusion or NULL dereference crash if mistakenly wired up to standard SCSI disks.
> - [Medium] Result: Speculative Use-After-Free. Uncanceled delayed work caused by the `delayed_removal_secs` sysfs configuration risks a UAF on `mpath_head` teardown.
> --
> 
> --- Patch [23]: [PATCH v6 23/27] scsi: sd: add multipath disk attr groups ---
> commit 681fea1e5bfb430f8ec567b5c630bf2528c332b3
> Author: John Garry <john.garry@linux.dev>
> 
> scsi: sd: add multipath disk attr groups
> 
> Set multipath disk attr groups, which includes delayed disk removal and
> everything from mpath_attr_group.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 242a15bc2c5bb..36c745cbb2619 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -4006,6 +4006,42 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
>>   	return 0;
>>   }
>>   
>> +static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
>> +		struct device_attribute *attr, const char *buf, size_t count)
>> +{
>> +	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
> 
> [Severity: Medium]
> Does the teardown path in mpath_head_uninit() contain an explicit
> cancel_delayed_work_sync(&mpath_head->remove_work)? If a delayed work is
> scheduled via this sysfs store function, could it race with mpath_head
> teardown and trigger a use-after-free if the work isn't canceled?

delayed work is not scheduled via this sysfs store function

> 
>> +
>> +	return mpath_delayed_removal_secs_store(mpath_head, buf, count);
>> +}
>> +
>> +static ssize_t sd_mpath_device_delayed_removal_show(struct device *dev,
>> +		struct device_attribute *attr, char *buf)
>> +{
>> +	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
>> +
>> +	return mpath_delayed_removal_secs_show(mpath_head, buf);
>> +}
>> +
>> +static DEVICE_ATTR(delayed_removal_secs, S_IRUGO | S_IWUSR,
>> +		sd_mpath_device_delayed_removal_show,
>> +		sd_mpath_device_delayed_removal_store);
>> +
>> +static struct attribute *sd_mpath_disk_attrs[] = {
>> +	&dev_attr_delayed_removal_secs.attr,
>> +	NULL
>> +};
>> +
>> +static const struct attribute_group sd_mpath_disk_attr_group = {
> 
> [Severity: Medium]
> Should this group include an is_visible() callback? Without one, if this
> attribute group is ever mistakenly attached to generic,

it's not used elsewhere, so I won't add a pointless is_visible callback

> non-multipath SCSI
> disks, accessing the attribute would trigger mpath_bd_device_to_head() on
> an invalid device pointer, potentially causing a type confusion or NULL
> dereference crash.
> 
>> +	.attrs		= sd_mpath_disk_attrs,
>> +};
>> +
>> +__maybe_unused
>> +static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
> 
> [Severity: Medium]
> Are these attribute groups actually registered anywhere? 

They are used later

> The array is defined
> as __maybe_unused, but it doesn't appear to be hooked up to any device
> class (e.g., sd_mpath_disk_class.dev_groups) or passed to device_add_disk()
> in this patch. Will these attributes ever be visible to userspace?
> 
>> +	&sd_mpath_disk_attr_group,
>> +	&mpath_attr_group,
>> +	NULL
>> +};
> 

