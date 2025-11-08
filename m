Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939E2239E75
	for <linux-scsi@vger.kernel.org>; Sat,  8 Nov 2025 09:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762594755; cv=fail; b=t0DIuDixtcDQP69Yd9tv73Y/ytzbpP7wC7NJ7WXk0uGsWW6JPwJVfo5kOtwM3Aj7qEIotWB/IKmTunbufhA+9OUAwaV15vD0jeq3321yqxrhW8XLx+S37uB7rAQwFaCGuUk4v31/3BMaZx+q69Z7G/cwuwO+qViNus7kGq/hduc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762594755; c=relaxed/simple;
	bh=h44wtdedaE7I6D1OsVxpslGWBCOGqFR7N026sH1vMTI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Wljl5OrI9OutrsDy5WqZmMXoeHcX1ixZ+6Qgv8z/F7RnP/EuXGgpCqdaoUNPceuPdEseSukVVGZG/JKCVLrt5is1lsF4sIkmdS6lxx6BBPsTIqbVrE57Ix6eNFQOnvkWZGWFn5NP/e5tLvS7xbRTkRJGEKMUkJB+/avn49arBpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FdXEz3+u; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fWGGQ6Qu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FdXEz3+u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fWGGQ6Qu"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A87rGtH024745;
	Sat, 8 Nov 2025 09:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=X0ME65w/eKv9+Po3dZgpIWg2CNP6su7TYzaTLuuZRmY=; b=
	FdXEz3+uLwApk7NlmfvdUaoI82Qf0j9LNFhIcBFNa0rPsp8zKMOzSySlRJslFIAL
	FUTbWWlU9WMFWADEoWmDYRWkYh/h9rzxMOmd+bzIjMbpmItgSMu9qIAvoc1A3JLP
	Mxe2hcBTevVX9k2HwF3Pm2KTeJ2NUxUjJBoPAH5ZOHOEG4jsK0zj51bRmMK/3OnB
	lXVsjLPIql1Zfox0SaEwMLmWJPA9SawEI4REMjWNHQioPdho6AGotkZP1rxeoFGI
	XHiybo9BuUpxCVc7SQ9PLc0Sp19lcu2T/umjkbvciY/PbL3L6kcBa1cek3SlVelZ
	qIyueGOoozCwf5L2bksYBA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa0jy84n0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 09:38:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8669nr010113;
	Sat, 8 Nov 2025 09:38:49 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011007.outbound.protection.outlook.com [40.107.208.7])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vag83ur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 09:38:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dqOqj6kwSokQ6nfxqDOwT4AsOhxfEyOnRar9mlnrhyzGjLQ1UBG2jlxvTyt+e6ZrxV0rDJmZQnpEeaEb3Uh15zPkgJ6X/+f7mE5/a2/wJ9ikUQGcAGGYtFTcmOJ7Jnn9P2vFjBzTUjrZpttIsNgZCNmvJ1LdX+p/cSVoMFncSsIH3TtaWPa0kqhiHECMJsH2ynKLgN8YFp3y27XvLYlgY2g1GTSejRTkTwRuwisC8Dh8g0vDR9BGZ2ltMUFfUGvk2i4JUXQNB1nGeretY974CiBOTGMC8Ym7HskKCR7nkFfubr6jgO/tHkK2rBHesxC/Ua562BioiIt5HZjTGm+vfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0ME65w/eKv9+Po3dZgpIWg2CNP6su7TYzaTLuuZRmY=;
 b=B4QMa/uCTI4xol+ZfZ3cj5qTTqB2TRvy/6RvpfHKRsPM009HBKsIQ3LhhnooIkVGSYzslTzbF6RT+o4uD47FEekFJUUMfBl5IsCYlR5R5GdP5d6mvk6fNwHqIaKbI3/IL0prbS2ZQ6oGyqrgCWXy6OihJTZ8OZq1Z/3GVCaytiDIs5U6q/LcdbH2WjSxhYqq9TLP+ZqsBJig1Op51keGWG0rSvayo8UyzunYa61zqmmAv2lwqMzmshBI+ygmMi9yz/2/RN2ys/WIflQGhjvOPj7Kqmi0RPLm8DyKRFXtuH4a+CkdeA0KoTk9t4CtjvTAWOa7BW3j9+I9EQy5rknGxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0ME65w/eKv9+Po3dZgpIWg2CNP6su7TYzaTLuuZRmY=;
 b=fWGGQ6QuoOcOOgjlTDJCQeGQveXKADm7FKBwkurtEzC7G/lBpRpRpwAI6W9JfKxve4WzGnFYrNnQZS9rz+pPaGdgAHu28JR1fEGIOdX31xzvo51iyeHB88CLlu5+9ZYplGtG92vOp46dCTl0xa9r7Q1nEuGYwUzqIiSvhqX/Qag=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ0PR10MB5670.namprd10.prod.outlook.com (2603:10b6:a03:3ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Sat, 8 Nov
 2025 09:38:46 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Sat, 8 Nov 2025
 09:38:46 +0000
Message-ID: <da25e95c-8895-4a0b-ad7d-9f88f58a91e0@oracle.com>
Date: Sat, 8 Nov 2025 09:38:43 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: scsi: scsi_debug: make timeout faults by set delay to maximum
 value
To: JiangJianJun <jiangjianjun3@huawei.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org, hewenliang4@huawei.com, yangyun50@huawei.com,
        wuyifeng10@huawei.com
References: <8d4247f6-2772-4f2e-aef7-32c1b0dc8091@oracle.com>
 <20251108082959.1831-1-jiangjianjun3@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251108082959.1831-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0321.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::21) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ0PR10MB5670:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d1145e2-089b-4f0b-4982-08de1eaa9cc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?THRNTnpGWG9lV3lKNkRheGpKaDBjenJPcWppVW84clpVM0t5RFpyVEovWmc2?=
 =?utf-8?B?QkZVQ21uVG4yamViUFVBdnBkMWdCV2pmMC9rS1VJSFRYTGZDcXhrdkl2K1F4?=
 =?utf-8?B?REFwWjVnVFU1RFg2UGRXV1lqdExGQ3dyOFFpa2MvUWtJNDVsU0RHd1VHUUV3?=
 =?utf-8?B?MWNxODNkbDFiNEVuQTZKTEhscmsxNTFpK3hiVjZSUHljTkFzUTBSOStKWGVW?=
 =?utf-8?B?ZWtMbWVRMzA4ODhFRkhDakQxTGowUS9vWmNrWGdwbWJMbVJ6R2RmZTc3V1c5?=
 =?utf-8?B?MGNXYjNqd0psRmtiYkFYeDlsdThrTjFRblF3QVNnVkdsQldiVnplWUxqK2t2?=
 =?utf-8?B?UTZicnRFMzBpUEVycjFPZDRaZ2F4T2xFM0tvMnR2VURXK3M1MytGMDkzWXZp?=
 =?utf-8?B?c3BySk5DbVk5YWtZY3ZBQzRVUmhOTnBXZEs0SDd6Q05JMXhBUGdicEtqLzBR?=
 =?utf-8?B?clliSy90UnJETUlYa0R5S2hYa3BWKzdtOHNHOXpDaGtsK09XV21rREd3K3hB?=
 =?utf-8?B?N1ZsRVFaSHJNd0NpNDhHVzBYdHpzYndpWVc5d1VsQzAvWURYREF1amMyYXpv?=
 =?utf-8?B?QVl4ZlZjZnl6bkdBRUxwRkgrM3V0dC9lMmNGOElJMDRwQUtDN3VJa3lBRjNG?=
 =?utf-8?B?aUlkNkp2OFRQSW8wUnlXZXErd041dFA5YWdvODhTSUpXRDZCcjd1RTU1ZFNl?=
 =?utf-8?B?N1ErL1YvYyt4L2NiNXhxY2Q0UndBNEphUXFCcUgyRU96ZFlFeDNXNlc5MDNC?=
 =?utf-8?B?ZS90WXFJeWJuSmsrMW0xVW1KOFpoTTF1dllXQ2Q3OFc3TVlGT0pjTjlJeVJS?=
 =?utf-8?B?aHllT3l3eWYwZlFMcmdCNldZLzk5c1hPVWpGOGVaZkZOTTl2Q1dQUnUzdkVj?=
 =?utf-8?B?TDFYSmNQbW9aOGxGRktrYmtjUFlTTVJwNTVUdmF3VEFlaVUxelY0dzJPUFEy?=
 =?utf-8?B?OTJSalZpZzdpajVGMWdMaExmNGVESUJmRVhRTWxvZk13WHpyVE9mZjJqcldH?=
 =?utf-8?B?cTd5TTkyTGVkWVBUS0ZSemxRVFdQQkxweWFqc0FQL2krajQvbzlMc2c3UUc0?=
 =?utf-8?B?SldKWDYwOG9RdnE0dFhXc2lGcUJTVGxJM0hFb0IwZXhBSnd6VXAyTHNrcDNW?=
 =?utf-8?B?S3c0WlprKy95V25zQkdhd0dYaW5GY1FTRUZWOWRTMXJkZVVsV1EzWTMvTWY3?=
 =?utf-8?B?eXFxb05KQWhtRTJtc0F1T1FmR2VnZ1djV1dHU0gzMlYyVll1NytTT29MTXQ1?=
 =?utf-8?B?blBZM0R1Y2dBZ05xbkE0TFdHb3E3Ri85dXdqZlhJaFFReFA3cDBQNy8wSmF0?=
 =?utf-8?B?elA0VkFXT0swMjVRV25uamdIQWZhWmFnV3huc2RqZFFJUVJveUR6SmpSUEF5?=
 =?utf-8?B?Qkg0dzRzQk92RzFwZGtTdFBITUdTR05FUTA4UExCMTgvUDRSVVlHYW9BbVpH?=
 =?utf-8?B?Y2FoT0RYZHVSQW1IN1hOVlQrRktwNUIwclUwOHovc0tUQTNoNDcrZjRUMFVm?=
 =?utf-8?B?RWJwR0Y3S1ovZ1M3ZHZld0swcHYwR1F0azQzbk1sc28rZGdUZnFpVURQYXNL?=
 =?utf-8?B?QTZyWEJCZSs1RHdBVjk2eThqWnZxZEhGS2RXTWQzbkRjQzM1QkQzOE9hektX?=
 =?utf-8?B?ZHg3MUJIbHZFcERzQlRKMHljS3lzSmQ5VVBBL0xaMmZqWGtzUFpHd0JDbmht?=
 =?utf-8?B?OTFzcmZtbXVGVHZNeS9Ob0hEMUtpcW0yYVNQNjBtNWczbDRvblJFZXVXZzFz?=
 =?utf-8?B?Ykd1cXBlWUtZSzNsWHJzSXFkVXZTR3drRUpIZ3ZxeVVuTExWcVJsTmlBNjJr?=
 =?utf-8?B?T0hQaElOTWxsbk9TOXdEdVBjT3Z3cGh3TXVRbzNhdVNrd1ZnZHF1V2F3TDM2?=
 =?utf-8?B?bHJ2WTlGY3NOWSt4My9ING9acjk3UVdBcTlkcS9RZlZ6ZzhNSzBWVk5acy9X?=
 =?utf-8?Q?paFb8zqzE/R/BjQ/eUfXj9IabjNFJ6Kl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlBpLzV4OEJvWFRaVmpmRjVjYUVCbDM2am03TDZvUHNSWFlOR0p4eG1CZkxl?=
 =?utf-8?B?S2NPRUc0YXNpcURrTENKazF1Q0hpTVpYajVYRTFEUjBodW41Umpuczc0N3J0?=
 =?utf-8?B?dmNoVjBFcmdEakpMVzFEQlFYTk50NmFIcHVydG1nckg4ZHZZSFhKRmNSc0FG?=
 =?utf-8?B?MzJaSEl3RXJpTWtFOXFobkJidjRRRW9HV3MrcVdyMmlDVFdmMnZ1UUVWUThC?=
 =?utf-8?B?c1dpRFNXdytsSnBZNitjZUdXNU5wejhlVk40Y0pRUk84aFlKOExtY3oxQkFG?=
 =?utf-8?B?c0NFWDRYbFRRSEJxekFYMUpkYWxDaG1IRllVQ2x3SjA1UDdDK2xNNVpqbnpm?=
 =?utf-8?B?dVZNSVo5a3FSVXI3dlFnNlc5bnlkd1dBemdUbThFcGFGbEJBYXo4VG5HYzAz?=
 =?utf-8?B?cTE4VC8vL1k4TnR6M2gybUgvRWdmL0xiYk9WZitCMGFwa0pNamxRZks2ai9E?=
 =?utf-8?B?TGFLK0RtdVRjTTFsZlNPR1JtcVFxbk5yUy85QitXc0FmL21IUnE5WkE1dVNm?=
 =?utf-8?B?NEJBZjl5K05COXVQUDJBdUx5RFpUNmRQTS90dmVqbzFScGJzSVhVVlFpdVZB?=
 =?utf-8?B?WXhXczRFbGRabEs1OGZOVXVsU1Jlb1U0ZFFQdGI3V1lEVmhIRUJMNUlHeFFj?=
 =?utf-8?B?MExMeERsKy92T0NOdTRLdmhLQzZCMEZTQ1RWaW1BdGdDaENGOWd5aVdqQnNv?=
 =?utf-8?B?SDNaYld4ZzBJS2ducTF1b0xNZ0kxZXBEcEgybTRjOGVncUo0a0JYb3BqQ0Jz?=
 =?utf-8?B?UUt1MENUaGtWanFLV0xQZ3NXdnpwc3lYdWFkODF5SDJmVkxjRVdYZzc0U2lC?=
 =?utf-8?B?RVZ2bVhxRkJycTREQzhrMUc0OXFyd3ZYNm95WUYwQTZRUHQ0cGYzZ0dGdjZ1?=
 =?utf-8?B?Wk05cW9wV2pZSXd6dkt4dkF0elRWUTZzNG9COEE1UDIwdDBpNVRZejVSbUhJ?=
 =?utf-8?B?bE41QnBxOW9hN3lyb1pma0htRDBnd21CeTVSUlZVV09Zc0tIb3FIbHFocTUy?=
 =?utf-8?B?eE5tNVp3RWJ0cmFtNmllVlFPR09hdzFIOXBqL3BnWXRDazNIU2JPbkVHNFY1?=
 =?utf-8?B?K0szbmZmU29oWXZBQ0tzNjRWYXZacUI1aWVXTlBabUV4Z3hpRVlMR2NuYUwx?=
 =?utf-8?B?MC9zWUZvdnFBMDNtQ2lZNjZCTHIyVWlVVVFCNDBsM2crd3Z6VTErWUlYYy9o?=
 =?utf-8?B?WHh2Y2xPVElkdjAxYWF3UE9SNWd0MnFXZ01XSW9zNWZMdGtJejBycG8xb1or?=
 =?utf-8?B?S1RmUzVwekFaK0FiWWlsR2NEQUpaTU9rTFg4U0NwVmNRSkFqZ1FKNUFYZ3Yz?=
 =?utf-8?B?YndSTm5lUVVJY1VwQzNud0ZMaGJZaVFpSklsL0Y5RjFPSkR1cGVia0d6RUhk?=
 =?utf-8?B?WFJDVGQzb3ZITzFnK21wb0s5TGoxQ01ja2dXMmhoVk5xNkFpOVd5ekI5SXRH?=
 =?utf-8?B?Y3licFp0TDZkVEVsUlR4S0U0WkZiZ1AzQTYwTkxaNXMxODNYa2dhRFZKb1BO?=
 =?utf-8?B?ZkZzbWFyMkRrT3RabWFHOVhQc0FxVi9IS21sZldyWGswSFJCWnBoaFZCUnVp?=
 =?utf-8?B?dHNHcGdqSDYxK3pHSWcrcFZEVldCQ29wdi9sVGI4WUx1VVlXa0RmUU9OL0pB?=
 =?utf-8?B?NnBpRTY2RHM4UVRjeFFoWE1yMTRmY0lIbHJoWkx1a2V2Q0Q1c3VBVjVnWGZ5?=
 =?utf-8?B?WHpnaFRGa29DTU0zTGRZOVZtRFE3eExqTjNIQ1o5TFk5K21uVi9zd3NqVEE5?=
 =?utf-8?B?V1BMQTI2TjFzMzBzczdyWkJ1dEZEdXZQenM5WEdmT09oYmkvamZFNnRrd1Nr?=
 =?utf-8?B?OGlCdnVVU1dIWkpSdEk4WFZpcjVQNnoyMnpaUS9vMEVYVjlnUXZaRW42K1hS?=
 =?utf-8?B?bFdGL0FMbEtJVzZuaWdkQnAyNWY3OEdzWWMvbnIyTHFsSzB5aS9RY0tOSlk5?=
 =?utf-8?B?QVhSMEVkOVVFNys2VlFHUGxtbnBnTGQxRFArczlGMWdMRkRkSlpPZWtESHFB?=
 =?utf-8?B?ZUdCamh6UU9XOHZQZG9PNHBMM2tvakNXTjk3UFE5OTdRLzVvT3R6QWtTVi8r?=
 =?utf-8?B?cjZTbUZ6a0U3YU04N3hqanB0MlNRYU1ZMXE5VVdwYUZYNG1uVWY1ZElxRWpt?=
 =?utf-8?Q?B662wYTDjz9VxPs8g3CPLKTnL?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EcNnhO4sm9gTOgx1mUEpD+ri4a65txQXo+LG4rCA2LNIxPwH6LYOojOq9Bf21RTWv//hhgZ2EmvuTSqwfji9mxXui0UZHpsiOrGedY5ThZdhGgVS4Y1d0bvPNcglLSNRxs+XuuumIcsTYump/27eFUN0Id+F8qfHs/FWD5ePqz8IZeCTZlPLOWkTt1UAgm6KSB2pheBbhbDp/+PI+2K5qmpBTOAu7Eo+xSMa8LhgwqjgvvCw4fpj2JJW3ddr1+ejuk9dKQfali8ojCjxXuQPjM/9Rkmi4vH5DhiAfrPmbvmVNduKqsQkM7QGrtpu6+4oOBrj4I9CfAvW/pckrgpjO6ipl/AMavDzYhKz2XoM57h2cy5ukcp5KVeD2TPq6+As5s3HQvFku9fxdO/KH0fr9FPiLmTzs5soMzUHmgPG5yf1q9EtFUhROsHOUIXuYC3ChVQoGMJeW6Uh9RauwRpv9XBcsASr/kUyC97HoU5k96ZKcM1iOFV0Tuhf2RJpyROF80sYIIT4wgI0W7bcKFm5KBg0Gp1fpg8KTR0IvX8BP8YPvDYDgcCwuRgZLATS4b/j2xkIuj7TeBimUAj2yZNamkLXybkUUHSJ71zgwIuBN90=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d1145e2-089b-4f0b-4982-08de1eaa9cc2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 09:38:46.0216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjAd/WTFx1MdDnCnEF9SolFj/rCIefodA2d3LUrNd7F6f2CzWoeQc0rrGZesro0GMRE0q/uZBzDYbUJWnhNVXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5670
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=765 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA1MCBTYWx0ZWRfX4bk8X2+3o8TN
 yPpj21FxuzrhlxGBHsiTm4aMqPROM6STEirXfI+kWRwF7m5u4tpjO8qrTZvDtnUuprupDq3WRt/
 +pQoFqKgwh7CBNHNkNg3ISdu8g43KLQPYqYgPyZI6etO+7bHNXq1zf0JLVqKqbs2PQCmvN6TLBQ
 StUDAAASLqf3TB3aBeh6co2rGgwbw2YVQmTUmNZSYZSv1nhfrvdzva71cDpzccczaBLCy3Uk74h
 IgHpbmvjve+OHmNL9vSyiOmURPOPWXAMzSMmSxSPhUiRC8XoJ/Lmvalhr5UrNw+sy6lVjw0xSvg
 kxoPrzx0tAVQXEJH0i3YXf96/blHZHOqQ170SHwYQbuEEnOhxun+K1zB1XQnYq1l+Sy1OhB9wco
 wsRy3rpO0BQ7BIC6gib+CgMvc6/LyKe7d3cYRSMkFPKZodfbDHY=
X-Proofpoint-ORIG-GUID: pjSMHzFADfnP4CbNeDlFmXvDUiG2yL8N
X-Authority-Analysis: v=2.4 cv=IpkTsb/g c=1 sm=1 tr=0 ts=690f0faa b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=nw9gV98cSB7LrlnsEq8A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12097
X-Proofpoint-GUID: pjSMHzFADfnP4CbNeDlFmXvDUiG2yL8N

On 08/11/2025 08:29, JiangJianJun wrote:
>> When we get discard the command, we get a timeout, and the scsi error
> 
>> handling kicks in eventually. The first thing that the scsi error
> 
>> handler tries to do is abort the command. All that the scsi_debug abort
> 
>> handler can do is ensure that we no longer have a reference to the
> 
>> scsi_command, which may mean cancelling any pending completion (if
> 
>> possible). Is your problem that sometimes the abort handler may fail,
> 
>> and we have to escalate?
> 
> What I mean is, in fault injection, we need to set a timeout, and then we expect a successful aborting. 

I don't think that you can always expect successful aborting.

As an example of this, if the completion callback for a command is 
running at the same time as the abort handler, then we cannot 
successfully abort.

> On the other hand, we can make a failed aborting by injecting-fault.
> 
> Before your modifications, the above objectives were achievable. The purpose of my current modification is also to restore the previous functionality.

Which modifications are you specifically referring to?

