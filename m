Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC873FD4;
	Mon, 14 Jul 2025 17:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752513562; cv=fail; b=JUaXuGQiMhNn9+IoECwNfGDQNV7/hF8y4ETe/KS0RRwG3xAQlpxQh7eYI4ae/kJcvOLBrF1j+46Fc5F75cL0j8+qGdg4SPcXxo2SRWiu9hmQ4mFZnN1+T85UlQGufE4HVxWRa6jrJIwwQdwJiEgqVr58hFYsnl58IOd0hExLFyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752513562; c=relaxed/simple;
	bh=n+omWo0wtgt/hmTNoqN0gSPF2MCJka20iHCofzo44bM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Xa3Ik7tXy7CSr/69DWigIieV1OuOv8f0M9KpUSiWJvMqBHbuWXtiODF+r2f/DrbYeRnqY4Iz52xrsJTo+ln+jZZZytucuyJk6cDRRJPLCS1sgZZBEmEE0k0UhueHXDNnOo8N7PIcSeq8SLlWVG3+RLK/vLTFAyU6VwSbfJzxszw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UFPnAc+c; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iSDuCQS6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UFPnAc+c";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iSDuCQS6"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56EHGpGb031372;
	Mon, 14 Jul 2025 17:19:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=n+omWo0wtgt/hmTNoqN0gSPF2MCJka20iHCofzo44bM=; b=
	UFPnAc+cCILKoNCDQNODGsxBqDk6VYKl2OnLvlx4GlhrHqtSfomB6VEFTrolSLkJ
	ioqebtSRWJXoOd4pwVDqmjCM+zLzVyxPgW4NUDeg455MEO8OqFFFdBnU4pkcdKr1
	3/G/v3tpQWT+nMxYPQhARhbh30mHtxXvke8UVa9+wh1XMSjB6QS7qYw5Zo8Qrh83
	Ivo68CSzQBmZ5DDrL2pArGW0BK9W8h02aPl0nk8ZdK4TiWxPR+HvgBO1G3QEJkkQ
	Ma/XiG2yQd7gj0+ChT+zm3TvJsMfJXzZNnqQFMyVqYXcUhcpVB+xyJyoAw+JmkCH
	S273g6IW5Gpaqb+Ui56tOQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ujy4mpvt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:19:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EHG7A1030372;
	Mon, 14 Jul 2025 17:19:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58tdx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:19:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HCwe3Q3CFDr2oV5rTST9l3D0IOqj+WxaraFcrqhCFKxSHi5uFfyFAlydP9DCeKtYuEbIpA3gBSgMnUpIass1wd9FVZKZA2F/IBJdDuUcvuNDM89uQddNMUYftyKhh/V+F42Qiy+2dxKsNU4ss1NJztyFSarPQUL9rMX47klhhsyN7ElbznYh0pYQTgLb20WqDKvZdWPI+G6WhqOL+6hehK+t54S4SxhbwPpJzww4Uo8JLmy0XdQJvSluhHnlimd1m5D2BOm7qAeLWtGpJSWk/LkqNwryXkezNHsRM8P9fg45nnQqROyL9x4g2Jl5VEHTCEg5EM8Lp71tSzKjS8UVUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+omWo0wtgt/hmTNoqN0gSPF2MCJka20iHCofzo44bM=;
 b=M2axjgExTd7MhyrnkOI9LZhpTFTDXAFaNOLCUAyV4T4nDaLGuv2rsb0VK4tYbmwuOsyQIkbIXqJA+2iHPifrku0INdQdRa82t0c9xohEDbrW3OQ5p3QJom01dFQMcAtrdTUOLZZ04PeLsUEXjf4zV9TkiU1rTL5Db6Si+XlM/VZ8f3D+NLYnLMyvUEOq0ert7E3jjTM0aYJjB32XkwW37td1fJ2XtVBLHParCarOKHBvegpw0LdB+HRjEzdGYooXG4/piRcbvdx8BzLEDHVwXC8LK6jp0dp7Au7ZDJMdh0jLbIFdKcrQ5E859omKWS7FnKlrPlbKtKZFBgS747audA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+omWo0wtgt/hmTNoqN0gSPF2MCJka20iHCofzo44bM=;
 b=iSDuCQS6YVnlD6X323W1/dsBkcrj0J2fkC9Z1KqNoviGSxtplgwQ3XDKMzP5RWFU0vcsjuuTZVOe595yyDxsGJRCYKgZqr8qUR7XeDIRCU5pUNsw6JjxAx44VAkjnMGjCLSMr9U/SJN/SoguZmiSFflXs0reelvvT+11qDHuWDA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BN0PR10MB5157.namprd10.prod.outlook.com (2603:10b6:408:121::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Mon, 14 Jul
 2025 17:18:58 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 17:18:58 +0000
To: =?utf-8?Q?Andr=C3=A9?= Draszik <andre.draszik@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
        Peter Griffin
 <peter.griffin@linaro.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seungwon Jeon <essuuj@gmail.com>, Avri Altman <avri.altman@wdc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Tudor Ambarus
 <tudor.ambarus@linaro.org>,
        Will McVicker <willmcvicker@google.com>, kernel-team@android.com,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: exynos: fix programming of HCI_UTRL_NEXUS_TYPE
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250707-ufs-exynos-shift-v1-1-1418e161ae40@linaro.org>
 (=?utf-8?Q?=22Andr=C3=A9?=
	Draszik"'s message of "Mon, 07 Jul 2025 18:05:27 +0100")
Organization: Oracle Corporation
Message-ID: <yq1v7nu8zd1.fsf@ca-mkp.ca.oracle.com>
References: <20250707-ufs-exynos-shift-v1-1-1418e161ae40@linaro.org>
Date: Mon, 14 Jul 2025 13:18:55 -0400
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PH7PR17CA0037.namprd17.prod.outlook.com
 (2603:10b6:510:323::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BN0PR10MB5157:EE_
X-MS-Office365-Filtering-Correlation-Id: 918774be-54c2-4cd0-5b94-08ddc2fa84c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0NMV0dMNUZweG5PSVk5TG9OUHRUVzU5eURLN0QwVzZwaDNIU05Ganp2bzV0?=
 =?utf-8?B?RHJTMUdhOEo1c2pUajh5VmZCUC8vaXYvQXI5NEtQOEJjVkhzVEhXUnowT1lT?=
 =?utf-8?B?a3BQUnQ3N05TK1M2L2FndEhjNXhJSG11bStOWFpUMExNVW1IQUdSSnpseEdy?=
 =?utf-8?B?U1B6VlF4NVBCUS9xdW5EamVQY1liaFVRWGkzRUxudGRsMWd6ellZUlMvdmVm?=
 =?utf-8?B?eCs1YXR1Q3NHUkc3aVNCaVNtZ0VWQWptLzBYbVlRdWZCQkgxbXF1TjgyeEV5?=
 =?utf-8?B?YVRxa0h6TXlVSXVRZE8vM1Vuc2RjZ2NBK0JvV3gvTGo4dEoyQ1A1VkcvTWtP?=
 =?utf-8?B?bG9kaTZ3U25NZWxiVU11ZldsQndQQTZlZm8rLzVuaUM2UlBLTHdBR2xsa3k3?=
 =?utf-8?B?TWt3bGVBNzFuL1pYa2F1MGZ1SElPRkk1eTZtMGltWmpteG9icDVnSUU5T09L?=
 =?utf-8?B?SVVVZW92VG9rcFBRbjNvWkFKK054emRwaXFCSGJoTUtweUwrYW9TcWovdHRI?=
 =?utf-8?B?cXRHdFQ1SWVnUkZ2VEpBNjJ4RWJ5WVQ3dmkvYzVzUGdZTTdxaUIxRHRucXc1?=
 =?utf-8?B?cGxNNWFwMHBLWVVlOXdSME5hSi9WbWF2T2ExZXJiNGdWY21lb1pYdHhkS0pI?=
 =?utf-8?B?VVpwekRuOGVNcUhKd0crOWZTQjY1SjlKUDhSNTUvWUxUeXZCQXEwZkFLbjBu?=
 =?utf-8?B?dUh3VHlrZjc3NHhzOVpHMnltVnZhNUY5YmtFOGdXbDIyU1dramZXby93bzlV?=
 =?utf-8?B?RDhmbjBTaGU2RnYzb0UvY3VMTjFJb1crRmh4QVZROXdlVnpOdlNvdmQvWS84?=
 =?utf-8?B?bExGb0ZOZU5KUm5PSXR6TjZ1Z3dnbmlQWjc3UnY0YTd2NmpjSWZ0eWVOazBX?=
 =?utf-8?B?eEg3THljZVQvVTE4U0d1NFdRZFM3UEpRYi9sakwwNk5VWCtLZ0E1N096Zllq?=
 =?utf-8?B?WlNzYktiMERZUGFPK2h6ZEgxcmUwREg2cHE0bkpTR3FVUXFlSlgzVk5TK2dD?=
 =?utf-8?B?eXg3cTlKZE1Ka1ExYXQyTW5lY1NlRXRiNnp5M1AyMThOdkVvTmhEUmF5aHlF?=
 =?utf-8?B?VUZYTGcvVExzYjBEdjhvSEJGTE5YSFJtay82c0tsQVQ5c0luSVh3MGpVOWk4?=
 =?utf-8?B?TlNXRlFLbFRxSm52Sk1NZDIvWkxTdVB2QzJOem13QWZleE5UajFiR01jdzFN?=
 =?utf-8?B?c1FmbGNFb2pEUEQrdHF1WlB2aVBPdjdwaW9IUjlmcElCdWl3dmJhUlVOS05v?=
 =?utf-8?B?NWgzSG12bm9aRDNiRmFPMUZwdGdsWHZ2TGJZc3pONUN6cGM0SzN4bUxNY0NU?=
 =?utf-8?B?QzlNanR2UEQrWGw0VzIyRnFHOHd2YWxFZWpPOWFOb3hRUHV1Q1ZSekpxV09D?=
 =?utf-8?B?Q2Z0NmcxeTFPd1BqSUhoVDI4ZjJwbnI3VFlKT0NJd0psd09jYncvd0xFM3dy?=
 =?utf-8?B?V1hNdzFSWktaUTdWQnJMMGZiNllWR0hLdlcxeHB6TkM5MHZzRUlBdmRCbXE1?=
 =?utf-8?B?M0s1aElBL2p3aDlJN3RPbktscTJqdXMrQzFuTWlpVkNJZzhYVVRVamphNG9a?=
 =?utf-8?B?NXNZclQ0V2JBb1RpWkJCOEIvMzRXSHhYeGlBb0VSbmRsTzVoY2RFdXhsdG5I?=
 =?utf-8?B?THpMaTZ0SUJnNWZoem8vZEFYZUMrRVVqYVRpcEdEY0MzQ3ZJTmlTZXF0dlJC?=
 =?utf-8?B?QjJnME96TVFoKzNya05zVHJlYTZ6QTBRb3dJMnpPUjh2T2pwU05JMGt1NjlF?=
 =?utf-8?B?UzNZcnZJdnN4RlhWTDFVQlFIb3R4R0YyZzZJamcxTHRmSWE2V0trYWxiUTFB?=
 =?utf-8?B?OVdMQW8wK0VxSHJJazg1NmlSb0F5TlBpZXlXdzFySVZOSXZTdkQwRVYxRDB4?=
 =?utf-8?B?ellaeE0ybjM4Z29EOHRvMVhkQVlUUzZ1ckRWM2h1c1p5OFFRTjV1cHMxVXpx?=
 =?utf-8?Q?bmiy8ZMUz7I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2xyQ0oraUhLMjR0cHA0UzhjaHg4WlRKVjFHakc2Mkwzbjh4Mk9zVGx2dHZp?=
 =?utf-8?B?ZWlWeVgzVGRsbWhqNWJIeU1MZUp3blZQVEZ6YXQwWU9nbzJoRWF4VGtxai9p?=
 =?utf-8?B?cldNNHFjZ0VjMGFVK092TWw3UmhVbEJLR09WSmszTTY0MXZuUnNDNE1oODZM?=
 =?utf-8?B?N1U0d04ydXp4bGR6cTlQT2hQTFdESnI3SkVsM1VWd3hBZWZ1dWtQeEpzSVJY?=
 =?utf-8?B?MTZOQlFDTExrZ1JPNzdmY3ZiS3U3WmZCOGZ6UWJpVWxIWGcrclEzcGMrbWpP?=
 =?utf-8?B?TkZJaksxbS9QdzNPaGdKNEd3T3BFSDl5YmVJblFaRWRYdjZWeUhlZ01xN09X?=
 =?utf-8?B?MWttaWJIdjVOSDVQbzlnTCtuTnI1eThaaWtUUnNLTVY1QTVoOGorOHFxU1VW?=
 =?utf-8?B?U0Q0UW0xenpaeW1TbGRJdVVVa2FZcEhMajUxZjRmQW5jd2NBNTVpM25JZkVM?=
 =?utf-8?B?SHFCSWFGODAvNlgrTk1JL1ZYb2xLeENlUi8wYy9pMTNXbW9TcnFWUU9GTGJ2?=
 =?utf-8?B?MUU3bWlpUDBUTktWM29zeUxDN3NpYXhDMlRVT2U2Ykt4OGpJdkZzVFIvNkNT?=
 =?utf-8?B?cHRvVVkyS3I2MWplaVUrMDJJaDV6LzRjM2pHNTFSbElRWEgwOGtKTE01RzN1?=
 =?utf-8?B?NzZxeTVuSHpoZmJyQlJscEtuMm8wcEJJNDRnUklsRENLZUwxdk5UbCsvdUJU?=
 =?utf-8?B?dWN2dmlGa0ZiY3pCa3ZQdmovV2Z2eTd5eGkvRUlqMkRlelpLc3A2YXlRSHlB?=
 =?utf-8?B?MlM0N01nN3pQUkhGL29ySUV3a1ZlSmZQVHU1M0NKa2liUWFZejgydGZUUzRy?=
 =?utf-8?B?WjAyb2Zsd2o2WG9JNmVKbFB0anFKSWlURkJxYmMxYm9QaFVvRk4rN3oyWEFs?=
 =?utf-8?B?WWdIMktTcHllWW94TmtYOGxuOXlpMEk4dFhaejlCZlZZcmxWYUVTTnpUbW9N?=
 =?utf-8?B?MThMWnkvT3cwY1pkc2dRMjlzRGNBZ3pNQzgraWpiYzZNUTMyRmIzbTNNd2k3?=
 =?utf-8?B?VDlZWDlYQ21iU1FsWDRXV1FlSWlPUGFIQVFveXppQUg3dVpXLzJobnNPQSsy?=
 =?utf-8?B?TWlQeFg3bU83VlFvQU55N2FOYmdoMlh6NjlXKzg0WVorS1RlWGZlZFVzVGNU?=
 =?utf-8?B?Q2JTRFh4OWFuOGlTUExRQW9DbWlXNmp6MXhuazlUb3pONVg3ZHB3OWs0NlUx?=
 =?utf-8?B?N09XS1l3OE9FV0F2YUkrbktGT1VLakpVamdIZ3JtM3lZVE03eTdsOGxhWXl2?=
 =?utf-8?B?MnNmeVZscGVyUjVnREozeDNsU2ZhQmdJQVlXRmNnbmtPZDVMN3M3RENwc2Vx?=
 =?utf-8?B?TXVrbnVpSmEralBWekVNVmRIWUV3c1ducVpIVHFHc01ZbG5mRXFDcjVZRlBI?=
 =?utf-8?B?RzhzS2ROemJVY0Z2empnS0ZTRUlKc2Y5UG1CM2RyWEdrcE0wNDQ0SnNETHdO?=
 =?utf-8?B?a25IbDhkT09DaTNBUlkwTytDVXQ2ZlJKMzQxT25KWTRkaDZEWEtWd0NxTGh3?=
 =?utf-8?B?ekJmLzhVVDhydDhNRUNqYnV2UVhtNU1VU3hlL2ZzbDZZcHVBeEo0MHZGSHFk?=
 =?utf-8?B?MEZqbll0Qmo2L1JEWWVkWmhybmN3Ym1tYS9wVHhpZ3lyc1h5UlRJVXlmbU5h?=
 =?utf-8?B?NTl1ZDk3b1RIeHpiZFkxZTVITFdBbTlSQVpnbVF1TFAxUjRCL1pxb2VUMURU?=
 =?utf-8?B?dDh0L2JLRCtCUVdiamR6NWJqKzJTWFJpZVJyaG1VaTY5b0Q5SjFlYUM5M0tZ?=
 =?utf-8?B?QXhVMkR6M1AzRFJzRlMxb0NoSWVYQWdtTXRINXZ2bkc4MGVYZ0hRVkpFQ2k3?=
 =?utf-8?B?S3JRU29Hbk44S043dm96Y1FZNW1Kc0VHMVRYZWNaSzNXaE8vc3RXNitiUy9D?=
 =?utf-8?B?Z0ptczMvT3d3YXI4cFFxSDQ5SEhtVFFkZUhnZTRKNk9UOTF6d01sQUdrTk9s?=
 =?utf-8?B?czR0bGxWNHkyMmRRbGs5R1k4UG9PemlZSjM0aTJkNUdmVVppbDZhaHNKZVJ2?=
 =?utf-8?B?QUpaaExKbjFuUXFtSUpQT1pVNWhCUzNidDgyTjJnRHJCSldNS0U0cDcxSGdJ?=
 =?utf-8?B?eHpWQ0JENHhtbjBjVmV1QjFSRXdzZEErbzFUVmdhNjF1Um1xSUVFb1A1b1lu?=
 =?utf-8?B?bG1lRTduNEkvaCtQRHR2cFN4ei9GaFJCR2o2WHBSYlh4eGtBT0JQdFpQQjVZ?=
 =?utf-8?B?SlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	adoRP/zmFfwZukKTxn7h2yk5FQfUi27wKuNERsHcYw+ttoc0boEiRCvd4pWDt0LJXSon+AxVa4MFCD6zslEnHlbg/2N5ksrjHpxsMLHTWDVTlkzKUAnWQ+Kynp2St48E3RgZNaKIWgamlUIdDR7wrqR1UTWRqlVh7pwL6Hh+ha5VfvqlHV2oxbJmCFyBuRDtptK0bgkQYi5alYEghtHe7uzGSUDhu0MVprUnr0y9E4dhRc88Fb9mdS7cXg7VkQ2Vzle/TMYMnMvd04gCKLzI4Nkw00rIu65+bTzeCJp7Vu4QImwk0qX6nGLJvqmMJq77hzQblLVoEicor9cqqbho1KeXY6Wy1Fv18LVUs0A1z45GDhzpiNjdBYJsnT0o5HPvDoYADBJbUOI+FUSlp1+qnrCsp2dunsnd59NpcWe3N1UNLNsALlNDbXUL/Zclff5NA+kLZ48/cXsisVkvyDjD3Az0tqSmRAvh+L+VSwCvFRkE+BhpYXn0ylflOqkiTKkrcHeHCCmhKrjiqL9mRdzkaKaea7Hye/Ea4XDKlsuINFXxZAkDaUPOip6JJjEqlMUXolkj46O5IXk1oLOx81wBUfL5Ex0/Qw7WZSlrvW4oEJs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 918774be-54c2-4cd0-5b94-08ddc2fa84c2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 17:18:58.2709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mcu88CLa4uSiNYWE3fw5PxruS9iscWo8R75H0866RRc5zX/SMAw1fxC2JcGXg6s6NvUUCc+Id5DknvMw6ruTKbuuF5YhCoJ9F8TpfFWDGWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5157
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507140108
X-Proofpoint-ORIG-GUID: jWvQ6hf8h-dOpsqPfGdnGQij0shXycN6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDEwOCBTYWx0ZWRfX7CQiB4H7F3fU GKqwo6RT0SmVNru+UUXcVWzMwCr0o+lvdkb3ymu6941aoPkr01M9xSnCefZ0g/leinWjmuOgAKm wgSoPId84Fz/Hx1SKNGLADyJazMu+RG54EX4oKXBGS3B/ufmnQiMbtuLnu/2GY2Av0yyGx2SkP1
 CJK4zQj7bk21JkLJDqCH/KKz7BN0SKOXmzuVRjmOCsZ6PqHu7uqnO2EtvSZ5/cdWnqPpHM7Ul03 nCkK/rPdHTnS7tYlKsX1crpau+ff2UNGLjN8AZh3cvmDQM7FKe/aBBhVqiYMcefsfw6AXOBQv4Z n+mnIPCG+3bZNcva8VzNI7lAATXO39Cg28qAhHfAduQ2SXZpiNMQFcpXx3ZWdcZI9hYOaIl22jH
 bgIJ78XynPWuAWxko+oOuA+ULTjv0huhaCMkKY2b8ytVUHI4PqL3FuBAS4pkNah5l/FfSj2A
X-Authority-Analysis: v=2.4 cv=Xtr6OUF9 c=1 sm=1 tr=0 ts=68753c06 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-GUID: jWvQ6hf8h-dOpsqPfGdnGQij0shXycN6


Andr=C3=A9,

> On Google gs101, the number of UTP transfer request slots (nutrs) is
> 32, and in this case the driver ends up programming the UTRL_NEXUS_TYPE
> incorrectly as 0.

Applied to 6.17/scsi-staging, thanks!

--=20
Martin K. Petersen
