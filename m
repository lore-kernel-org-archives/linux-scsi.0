Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE0D411FAB
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 17:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785776515; cv=fail; b=sQEEtoqfeRpssx/ipfs01zsOPJdBShudJXyDkSD2wuhyPlXTa/WSay6ADD8UnPa6vDCmUtYb3VlMv91+tkWKpCPxbYuYdEY1Ioz4SaU1u+JxPLE8mn4rGqZjfPLuWXHct04dMolPO6HqAiPU65kD+9DnrjasjVEeJiMHY+8mm7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785776515; c=relaxed/simple;
	bh=Krk841aZyHvf3Vfxykeq9FqtRDuX6qMeIbx5sqz/9fg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aA/N8gwm/O3bIkaKPCIqGjCVMm6iP/+C6EX00UzA/YetCPynP3si2UrOH6D9JJ/Qc6v/X7ZU7XCfChCZM9UV1uB65rEhklKfwadgUOOCKXhcQGrS+jH7Da1IhUmxNFIAfUxYMwoJ/EL1jbuLudD0L+gru62W4eNGasH9b5WoVa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RqzQY1Lp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tQwI9pWX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RqzQY1Lp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tQwI9pWX"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673C5Z112697832;
	Mon, 3 Aug 2026 17:01:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ur1NCw1XEP/T7iqu6BHG0NkE6IgZ1crjsQ0YbXtLWBA=; b=
	RqzQY1LpqvXQHq4Mb8C/lXbUBzmlxYPaxdsSTniVTXM+NZ1rsUS/Wf2oYBbZME/X
	Jwwnlcekvkz7/QhhZQwUeGRMfJaYecUEk2IwMSVuIaBTdJgoUkOiN4dI1O+tKgUW
	+z7bA9DSRDela5VZSBiu+9OXy4RplgAQZU5KGW67Sl3pahtSpUhfYwNEs1q3ZsCL
	zEMUcNdwiMGBd40agOgwCZvAoLuVoe39nee8KJNINxVgZvBJ5c06wDTdeANoyxab
	/SBblu+/x7sSwOXIla5JZZxWngvQfQNNafn4x38JkoXb3kT4DPWVKTEsWsUidk9y
	onvfalFfcUtZRoRL9q6V2Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs77embev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Aug 2026 17:01:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 673H0mWZ001039;
	Mon, 3 Aug 2026 17:01:15 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012071.outbound.protection.outlook.com [40.93.195.71])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ftq40b09w-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 03 Aug 2026 17:01:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rUrRC2+owgmfTxu9R9scTSPPKURaP5hnvAPD5EeYY4qb5jBvLhgm9Rj65Q98a3S1qM44WqFYLnwnrFRlka/rqb9ENXXFcTafsaGZNMvIdtxpkoeIYEy/xunOMoFgFICKP//vZRuoiQcZbuQUWqqXkv2NPjA2sPfCPlCS3Wp3e6DOGMn+CLRr/meF2tLXOhLKLqxfB+020w4A38tx7DGOmGwGgn+71w+5a1CgRqOJi1f+UMFc+AnUKHUaMy6cu/OBxYo2fv04fUkk501wG2NR2bjVF1oa4/3rXlzkHTrVkAm2n4jU9g9wJjsgaYffhg4JBEWQEhnARR9+CSosumSg2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ur1NCw1XEP/T7iqu6BHG0NkE6IgZ1crjsQ0YbXtLWBA=;
 b=NXcz3NPZJFHYIILWEcBly3nM1zDdt6/v+3Py+AwD/o/OrEeISOCiZaVoVvVl4ml45ZB8azncg2av0kcQfyj3XiV+IsAp22XtnZA55a6s2OaXqH+sGWTTEAfP5t4Y4KhLaov7XCjmtX6zxwCGTtw3U0GWOPyl4Ssg2OchVmmCt9PDkNCi7hj7PyHsCsSQF1rXbGzCcMPEAmcI59AZ9jE32uV15Mxy6Nwo60C2XJYpQCx2Je0aNCGtFeNIkM/6muRKlYU8LFv3zTnBlvwhP5fk8ntEnXmOAk9WmWUCGRGIDOQ/7kDxEMnqh4mxmxxzvXATGszxUTC9fk66Py5xB+sEFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ur1NCw1XEP/T7iqu6BHG0NkE6IgZ1crjsQ0YbXtLWBA=;
 b=tQwI9pWXwQBaMMYmrJnmu7n2XS21sFZnCy1MG82kR527lMXlAoYEDMPMesG4MTH83CxKOls611Hh4ZNtaA3nfk3czAmHylTM9Bwqx0XQeZXUeuS+xphRpbFbLPkJ9QZE9+Ducf65hI/JPEFFZ8+sJazE6FKurVGt/q4XWBR2vuE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BY5PR10MB4372.namprd10.prod.outlook.com (2603:10b6:a03:207::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.17; Mon, 3 Aug 2026 17:01:07 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 17:01:06 +0000
Message-ID: <7ea61c74-ed48-44cf-bfab-3f3a49b3d455@oracle.com>
Date: Mon, 3 Aug 2026 18:01:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] scsi: core: Protect host state changes with the
 host lock
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
        Jianzhou Zhao <luckd0g@163.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Nilesh Javali
 <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
 <970cc36fb627fae64b4957954483c74cf8e59c87.1785534721.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <970cc36fb627fae64b4957954483c74cf8e59c87.1785534721.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0192.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BY5PR10MB4372:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f6fff33-cedf-426a-f1ef-08def180cf07
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 moN21EWfXs12wJaNsJTF8NOkHnPTmlFfjBLs2H1tbzUMiSYL2W6oC/XGYTaNd9rFvjbdU1hhFShPDzIJFeJ2+TOFjdIX9be9yaj62YTKJshR8Y06NhaOrdgUx0PU8bmIfaJGSeqnSIIKBC5Q1EDqlAaEBlZhNIHGzGZz69Ttd8N+gI/uxSSDHmUmpLddisP4jdVEyVubPfem+iB44iKnF7UCA8USd2tpy2a4Bc4HOfPQs+hgd2bIGH5PDZ2HaqHzSA4mmBop8RiS/eCTnVsWyRgZ8EUoI3ztOEnzkTqyAkI86330Tcwm7Gys/mMBTA26qQVK0UI/+OAl7l96cGkxOCwalk3nY7AUhieJrsahaf7EBkNAzAM7JvX2LZ2rDWrDnmVfchhK+hU6cQZs381aFpLzcgRiI8XaC9/mBHNV8wKXtDw9R5fk0b1varjV+2Sk9hKUSgXO+1uHutaaRHavx/qEcI6Vqt0ziYIIV6AUjQQAZOjLlU28IagP1D52xdutqFp29DsWuvVI0NQV4tJm9/rmenP6Y2eivmM8JtibhW2aRzlo+IBAHD4hrYj+WTGrWvJYxgjMgAHMzuzFVoVV26fRMJLYc5pGqQfai17YpsLwk1BcTnviPUllgAiyUpzMcrOfA28wPkPgRe0YTNGEgcJo9JmltJ+6f/iEzo999BA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?M2hySHQ3YmdaU0hFcVkxSW1VNXlLbllieWlmY2RsT2lIVUlLK3MwRm1SN3hr?=
 =?utf-8?B?cDBxSzlRaUJEVlZFSW1OQ0Vrd3NydVQvUlJhRWd1eFN6cUxVRTRwRVdZRldx?=
 =?utf-8?B?cCt5NVM1a3dTbzdQTks1d3RCZ1dVZDVEalRwaDZSSTZDd09FTTZ3NHpnSzlS?=
 =?utf-8?B?ZzlqOW93VkV0bFJoUXVqR2g2N1dydExSRGdSUFZ1NXpGanQrckYzVXR0OFZ5?=
 =?utf-8?B?a3p0ZVlJQlQ2UENzVU1yNHVSaDhLdlBpMmNWREgyRlRlbGlSM0NKUm9rQ1k5?=
 =?utf-8?B?MTBXRHAwaGNyTkdkTURNWm9Wc2piRERvc0RKUmlIdmFMUmFERkNXZkNkZldK?=
 =?utf-8?B?QjI5QnBMZWt0NG4xUTA5eEZsTUVHUFBoQjg0UGt3aVk3U3R5c3lkT0pGVy9x?=
 =?utf-8?B?MVg4QWl1ZFVwTW5XaDg3ak83TG9CcFZpYmxCdFpqdUlHY2VybVhVYXBGWkw0?=
 =?utf-8?B?b1pRVFY0cFdEN1RSSE9DMnpNbzJsY090VWZ0QWp2V0lXcEF5ZkdCS2NsSi9P?=
 =?utf-8?B?M21JZUMyNnJpVnBTRWgrMGRYdzRWK2EvVHNFU3dtUldXTS9teTVlbHZ5Y2Jk?=
 =?utf-8?B?a2piTkVNeFh6YzRJZFd6NVduTWxMTVJWVjlVblJQREMrZWFCNlpFcUIvM1l5?=
 =?utf-8?B?L2ZzamFWYWRDUXpZeU5PejM2bUYva0lPWXErTjdCWG1yLzd2WlVkd0F1emJp?=
 =?utf-8?B?ZSs3YW1WSGFUVFlOWEJoZHNOTUtNSDIxNUI2VkZBOVN0L3B5dEQySEx3NVlV?=
 =?utf-8?B?MUNkSjlWa0tUSDhYTDVJLyt1L3M2RGJlNXZoWHZwdkVLenI3NjdiY2gxR2E5?=
 =?utf-8?B?dGo2WVkyK1FVeS85a3NFVDJadC91T3ozRVp4WW1pSEZuRWRGOFJPejBtY240?=
 =?utf-8?B?WGl1Zk12MGRSZkxiT0ZIbGZ4MDFRdTNxTU5qTW4xcTFxeDRhNHNkOTFsczdB?=
 =?utf-8?B?VlA4Uk15OUN3UWdTZUM0Vit2QjdJTHdnV2xtZUFyd2J6U2xRQXZId05tVmti?=
 =?utf-8?B?UGRHTWRveTN0bFJFZzY0OTdlMkhvYUh2V0N6bi9FTXYyaEhWNTh5d0I2aUdK?=
 =?utf-8?B?L2xEd21pK0tjTFVWdFdMd1M1MEhkQnkzUkRoMDNRYTRFTWdHQlRmSXVZSFl1?=
 =?utf-8?B?djlrMVk2L21wY1poNzdHcCtuYlFDb1VLbTArbzBGeS84ZVRXZmFrTUFQZHg4?=
 =?utf-8?B?Y3JXdk9paVlxckFvWG10QktnRldVZlY2R2Z0NVZYYnkvcmxScUw1ZThXUTl6?=
 =?utf-8?B?QTk2MWl1V1o5MXpyVWIzTGtIaWN1aXFiSng1bllwUnpha0RLRzFQZUNiWHFr?=
 =?utf-8?B?UnNNOW53c0lEUUxEVThIcFRwd2VXOHlPemRKcVlFeFZrNjlMRnRVYlZQU3pN?=
 =?utf-8?B?ejM3RmVPTW9lSTd6RFpaRFJFK0Q4TGxWVkFudFNJbGVxWWZDRzg3OU8rcUJH?=
 =?utf-8?B?YWNtSmpMRTdJTCtRMGo5T1lENmFPZGdTemtRTnhXOTZ1K1kvdFpPTlVVL3da?=
 =?utf-8?B?RTRncGJXVGtLZ1EwaUtDTkQzcGxuUXJsOUJSNDAxTHpKc1hWYUJDWE5ROWNL?=
 =?utf-8?B?c0tKMTZicXN3M3JHenJVS051L1FvbmR4Mko3Njd1SEsydkxkakZ5TEtxbkxV?=
 =?utf-8?B?RjN5NVcraTVIYnExR3ZlQ2J0UzJoNUV2czE4QkFxT2E3WTNUckFTZzJna0Fa?=
 =?utf-8?B?dkVUQkJPQlVQZ2lmR2I0S1lYS3Nzb0dHeG10QjlSRFBscmdERnlMTzkySG9u?=
 =?utf-8?B?Z3Y0Q3lpVm9PTWdVY3BOZzJUTXEzcUVpNkNQdVhZWlNKbXRsR3BHSDZ5YW94?=
 =?utf-8?B?SWpWWFQ1eFdmZkRqbDRmMG8zS3gxaURKUUdLeE1qUXNCZXBCOFdYSDh0bTlq?=
 =?utf-8?B?SVV1SFgzVTZidjU1dHk4cmQrZFAxaWRPK3BBK0hpTDhqdW01K1hkUjd1aHIw?=
 =?utf-8?B?cy9LMEorSW0rZ3V0aWZaa21ObGx0U1NVV25FZ3gwbXFwa25UVW9xME5vUytP?=
 =?utf-8?B?SDF5d3NXZS9jUzdSTTVkUlQzR0RMelZkSlI0andJamxpcTczZ3k0TnhRTzkv?=
 =?utf-8?B?cUtDNG9ROFJwbHVMVXBBRjFQWnA3eVNVcDVPSnJpTkxQcExIaVBsWnc1Rm1C?=
 =?utf-8?B?MlkrOUE0dExvRWZsVkZBajIvSVQ0bVVvWnozS05LT3dadm5WaUtmNXNYOGpX?=
 =?utf-8?B?MlFVeUd4Wk9ETUN0VmczRlVRRFQwcFpWOElFWFV4UFpsZVoyQ256OUl4R3Zu?=
 =?utf-8?B?aUg4MERSRFcvQWU1NUxKeFEreHl6M0NkaUFOdUZ2RnI0REF3a3lpRm55bFF0?=
 =?utf-8?B?QnorVFdZUEdjc2lGYkJYSnM1aERuVG9MZU5XYis1bWZMcFFkSmpaYk9jWUJx?=
 =?utf-8?Q?2iykgQKMnu4rfXFc=3D?=
X-Exchange-RoutingPolicyChecked:
	PR5y5WkCj1Qub2yWXdTDSZyBZUdFCQ31yDfP8V+ZIoHTAPif/50+SSgWvCGFtPcYTmlS00gOG9Jnxe+cbXesfFaE2Efst9HmNvt9ZWQ6SDIPTI+xY8CSjHb7eQkzzsdQoWwLm4GK+WwObpKFy8Zg+E69aolFZE8z8pK8yB4l3c3jqA8Ln6G0BeHk5YiHdquKgXidSQzLzcUTYo+V0rPrEO3bRVJJ2RW1r4Lk5C8dtkuCFqyrCnpFrsYYwv846PSQrR1PYatlShvOgSmP7CI3q20wQoCSstOLc32XG5sZmqKxfbdVbptiDNtSzZP0XQCTqViyOVumLa9sQ1NjaStwHg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eENzBh0wSSzG+YobLWaZZmmerFYHh5vpI8nDQhaA2CUIZQUgtk31ZJ++P7Idvvo66chvUatzMCm/+wpeutc9w04eFOYqplW//dC14igUqBWKm7rpCyviPfDWXE9Y1n2CvF1C4g6F4eoljMlWBVnwOfnqfSz2e/ZoBSH4wT+aR+phq19G8zGMt0Du1fU/Qw5Y90ITosBBZyI+PvCEaphP+DM5iYaFa3CfY7xmwaS7VflSPEXgHlLbvL2/VZ+LZ0Bqx44xQDhbiDTwQDEcuCOfvtQqwtvYbWwLHjXRCzLwmrBJOeES/2rfdfsyBEsLvJHc64Dalqs8n8Br0xpecN78f1RZgPsUK4pOH6hdhfWjJo2vRCXr5+P4T/Iye+ksrp7OnCrch16KIIPcOIsx3rpbbdXotueRlOaJZUUBHcxQmNrbiKrv0auLfkY820Tb+j87JLAEOrtZK4no6QPSWsHAsjlTS3QEliP9AXGl+FUFPGqLzUw5CbWon78RTIfoh11gkl7PemtdGT8BO42gxC0h48uCVHWR/Ndt0fK5Y7ktdsiZ9/FkUrWUNfLLMQoLGbFbbtCrUNVQSRYmAVkb6O8wGwww1o0yTnB5+8ty0VYvozI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6fff33-cedf-426a-f1ef-08def180cf07
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 17:01:06.7642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hH/CYQpSrg1tkCrtu2jt40T1G+Zz/jlvvz1lw1PMpJNu74LM1C2Kdjw7E/6qrzRdbIgTx0BchGMvRkRNiA+vZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_04,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608030152
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDE1MSBTYWx0ZWRfX6ki82R9YPAAl
 v5GUC9faT/ndkIN/AJrCJvgoGvq1NuOXiORMD5EPlTx/ONgdilgyIpm+MXPNP8zEM3RHhKNsjBt
 1XGCNn3y0/wU6vjUA+9Z8oCxXiqiB1MA1QOZbfyhQCkGD0uObi2QBZ7bRptfRf1JG586GeuTcUZ
 6h1mC+XKunFjT6tQlmHrIVoshmzvs4iaO78pG5nxAxDv5FHL0PXA3aphDJZJUiPKmV9o9mqfc4D
 1fKNj3sGq8oYIe4qvl/oRUnUcZRjSvmrsQ2GU6B8tZfqL87JFHnsOMqh9rCYXcG6xTx9/dmSlYr
 zHHFHwN5UsXSny4WZr6lAkRhFYT6yOR4ih1K3sPZzIcp7VReLL2BBI5+n19XL6FH4tZ6Mc6bH3T
 rvD7JLqYlH1t8+9YRv3tr5QNQ7IUQQ2Qqc7SkTs9M+a3GseB3BYwx6tSUI7YJLUzM4SA1zd9OrL
 sdZALRqHj5Z37YTjgPw==
X-Proofpoint-GUID: SBoiJcZStlNVNKeKZw_LD2QFA2FDypdW
X-Authority-Analysis: v=2.4 cv=OqZ/DS/t c=1 sm=1 tr=0 ts=6a70c95d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=C82dAtNcj1IyK_HYeZoA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: SBoiJcZStlNVNKeKZw_LD2QFA2FDypdW
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDE1MSBTYWx0ZWRfX/4oavVL1ayZF
 tDiP6Kw7OKo0xQ0EUlniGBuXZaswaKWgsrpvoksT7vTRZIEarEtpI0Kh/UVe3f2OKEcMYdgD8m3
 qXb/jzuUXrjUTmGFgGruXmMmzkgg8TW9gjEZfs6JDrq8h0YOczXa

On 31/07/2026 22:52, Bart Van Assche wrote:
> @@ -411,8 +413,8 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
>   		return NULL;
>   
>   	shost->host_lock = &shost->default_lock;
> -	spin_lock_init(shost->host_lock);
> -	shost->shost_state = SHOST_CREATED;
> +	scoped_guard(spinlock_init, shost->host_lock)

Please forgive my ignorance, but what does spinlock_init do here in 
relation to setting shost->shost_state?

Elsewhere we have scoped_guard(spinlock_irq, shost->host_lock) for 
protecting setting shost->shost_state and this makes sense to me. 
However I am curious what scoped_guard(spinlock_init, ...) does.

> +		shost->shost_state = SHOST_CREATED;

