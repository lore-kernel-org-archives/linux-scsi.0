Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F11D2C694
	for <linux-scsi@vger.kernel.org>; Mon, 15 Apr 2024 07:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713165774; cv=fail; b=FuBcnhO6D3rZu6E3DIltvcKHqswaU3/Bu8z3iS8sypGHRp+5l2rkzvJsRjL3T06trRVnrTFRcM3K1FQaFewvPLhhCGWUm2SJCPgIawstX7t7hwKbTgYGxeFNsmTaVm7QXz/3QcXhJEjc+13f1O0od5DOIDwefWQ+bwi7uF8w/E8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713165774; c=relaxed/simple;
	bh=YITvvykO9RGygriJx7PBqYhp8lYfLJRvbCF0oKRJmwo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r7uGg8k3EoF6fysflqXN7goiw1TkjQD1wzsxmggzepCekM09E05Kf8uOinbOrF7oFSoJ85FJBOh2G96dgU9GHvCG1LTC+qKAWm/nyyEcMC4yuj/fOhtyeeDH9OVOAiw+a393qIJwnSHlmEZHc8GF+/Va5kjXrLEkXDEGK5t4S0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Tz5uzEcz; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=hQhpkm/O; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Tz5uzEcz";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="hQhpkm/O"
X-UUID: f539853afaf811eeb8927bc1f75efef4-20240415
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=YITvvykO9RGygriJx7PBqYhp8lYfLJRvbCF0oKRJmwo=;
	b=Tz5uzEczRMyssWx9MbY+pfhQ0g3jvWdtZeh5o9CdQ+4lqHnfVArJQBCnZF5cMaoQoEnKkSRD8RgHT+1oUEHgMyO6rcPPoH1rbPz5SzOxAtt2weVw6O0v/TY129uQPmqJDE4u8HVRkplkZg2R1P+UDHe9rTCitW8/rlLpxIv3wcM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:5e314a42-ec1e-431e-9196-76841639e22b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:54532f86-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: f539853afaf811eeb8927bc1f75efef4-20240415
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2064152879; Mon, 15 Apr 2024 15:22:46 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 15 Apr 2024 15:22:45 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 15 Apr 2024 15:22:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8RegNk2BadKUJDUEU0zPVtZx61Jav7/fzpmtqf0kxPlnblZ3wzdApimtcpzCQTPXnFzlitqfOx/cGsVqqpugcxVUrQswqjtvl3ilj4wGkeUS24s5kCFqgLWXqpjfWEL3ItaNvbHrDkQByEO7DKvAJgniPv8//p9lvB4c1t2SH3nX29KMIUAkTvS4SCCPfFb/fGTM8V2PpGOjVYNO0Gy7z4tZy6J07w1gECcqOstrmCjWQR7sglftQOwKIx9FiIGnklTapx844K5XmmRxTtB4xCgS0i28DP5L6qtKhnUNmxzvaLbQgUiiSEaxzAqCoKrNhvRpNWnjfvH8gQk+EiGeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YITvvykO9RGygriJx7PBqYhp8lYfLJRvbCF0oKRJmwo=;
 b=DHoQNLU59fUsuT39Qz2Z+tli+WkFV8Axh9b5UT8TDvu4GBn5hDkZ1RDg7sl3oVZgfBecaCS7a/uwdD7TdxFKdFHakBi1MjCi8qpz3IcFwcXGM04VIkdsmUbLETy3toQd5G0FtmoQsILBl2cqwTZIgU+7etLCY5cGK2RMFpUsMEvu7QZSEEbU54ypEfDE7k6LBR0rHqaLaoXd5umoC+ToNY5lWZErayd6DTxDJlHtCNrr7hXJpA2XYbth6xRq5qm2m2xoEf1gOXZkDC9e4H+4if34LDCMf8AqXvVi3DDzn+7MgHGcNUkRAld0yBIunu+IOQL/t2nNC/e0+kAGGbU1Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YITvvykO9RGygriJx7PBqYhp8lYfLJRvbCF0oKRJmwo=;
 b=hQhpkm/O82AGLfop07Lka90MJG9L2XchBgN9aDHVxLP9oqUq17N7FhFYJtgSOVhiC/KZQO9HLf4XSO2PW/F+mtiunYcHRoorMchXJcO5B9BaveaGMIhQrq9S/LIK/dATPgob7ma9SQ0EyK6FuZio1g7vKiNs6SIMiS3auTUxSUA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6528.apcprd03.prod.outlook.com (2603:1096:400:1f9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Mon, 15 Apr
 2024 07:22:43 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7452.046; Mon, 15 Apr 2024
 07:22:41 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "zhanghui31@xiaomi.com" <zhanghui31@xiaomi.com>,
	"quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
	"keosung.park@samsung.com" <keosung.park@samsung.com>,
	"konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "andersson@kernel.org"
	<andersson@kernel.org>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"angelogioacchino.delregno@collabora.com"
	<angelogioacchino.delregno@collabora.com>, "yang.lee@linux.alibaba.com"
	<yang.lee@linux.alibaba.com>
Subject: Re: [PATCH] scsi: ufs: Remove .get_hba_mac()
Thread-Topic: [PATCH] scsi: ufs: Remove .get_hba_mac()
Thread-Index: AQHajQDkq47WBz98gkqBOwkbEBHITbFo8WQA
Date: Mon, 15 Apr 2024 07:22:41 +0000
Message-ID: <f3f07f6866c7c344f6c76316116f12c45de53e13.camel@mediatek.com>
References: <20240412174158.3050361-1-bvanassche@acm.org>
In-Reply-To: <20240412174158.3050361-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6528:EE_
x-ms-office365-filtering-correlation-id: a105d608-c201-49d6-19cb-08dc5d1cd611
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?utf-8?B?d2xOcEErOWg5R1VDeVJBQXdYdHVpL0wrMzFmMHoxUkxvMjdNVUw0emJNM2lY?=
 =?utf-8?B?M2FpM0ROR1BQOVFtVkdxbWNRZUNQeU03RktGV290S0xKaVJ4d0VsR2NyZkIy?=
 =?utf-8?B?YmRGeUVGU0ZqUHpXYVhGMDZsTWlKZDZUcnBhbmY4ZWxNayt2dm1JT1JzdWZu?=
 =?utf-8?B?d1k0RkVwcDQ1dDBDSW8wQ2dPQUg4ejcvbU02dG1tSHBpZGpWNVMzVXBnenR3?=
 =?utf-8?B?OUZIUTlRSU5JeEFIcTFlUEcrRktNTlV2UkpyMW5wajBudmNVZDFhTWtUb1R2?=
 =?utf-8?B?dmxQcDc0S0VmYmgxVlU4dkRCVmRsWGpBUzkya3Q5VXVDditOU0lLOFpQdFF1?=
 =?utf-8?B?SHdqSk1XbmZLWDNlQTI3cW9vVUI3cUhxYzFCR25USHIwcS9tbDdXbkZIU2wy?=
 =?utf-8?B?L0FkaFRhNXlRbzYzV2VYankwMEo5WWt4WkY0enUvWFBFcksxcVFweDdScjJ5?=
 =?utf-8?B?N05UbUU3VDZFdjUzYlJrZkVlNVVmNFJ1VkNWSGFtdnRaWVpFbEVvWGdLUS93?=
 =?utf-8?B?NkgyNnl0NzJVS3FyOUJhMHl3SkVpWnJudGRpR3dlR1VWRkkvNE1RVG96a1F6?=
 =?utf-8?B?NzlPc0hjOU1FbHVDa2dmQVJwRUlPTTRqTUljLzJNTVgrcjJWTEVvZUlCTjBH?=
 =?utf-8?B?bzBhbkpHbEdFVGJtZGNkS3ZOUTVqdnBTUmZ4azRpd2VRVmxHUEdyQnlkQ1FJ?=
 =?utf-8?B?aE5EbDQ5SjBUSE52Z3QvUkJIVGFrRHp3OHFoRkJqS3hpYVllYkVDNytzclhu?=
 =?utf-8?B?N0RCNi9aQko3WVdtUkJlcEE2SzhLMy9jaFQ5L1ZrbXVpc0xlbUxYdVEweVRl?=
 =?utf-8?B?VTlvMEk1WmxnSmxzTTVROFQ1YWN4VXF0NzdIalZ0RkVodnRHbTYrSytPV0M2?=
 =?utf-8?B?dmwwWmt1RTlackVNMnpzNndaNkJ1S2FlRUZuVjBjbFJ5Y3lnb3BKSWNGU2oz?=
 =?utf-8?B?T1dtWVlsb0o0c09Xb2FjOVI2U0JEWklwc3JIVDl2cU1mVUVRQTZ1YXAwTG1R?=
 =?utf-8?B?NWdXb1RGeUhhT3I4T25XSlJFOXNVT2JPKzVhWnBoNkFRVWd4UXZPTG55S29J?=
 =?utf-8?B?ZllHTmhIeldNSGsybHpwdUFVMGVFOVgyUGtEWW5CM3lpc0VSaUdVMmFLSm1W?=
 =?utf-8?B?QU8xMjlKTzY2VUtJc0FnWUJYUGcvb1JMdXkvbXkwUzJ4NUpseU5KR1R0SUZq?=
 =?utf-8?B?ZFllOERHZEJuc1Y3MEFxTThjd3gwUzRoSll1NWZQVnpQUmFyZG1oNERiRWJr?=
 =?utf-8?B?ZjJKL2FtdFRhYjZwSGpHNWlrNkkvYkxzWENqeHJvYk5iVkU3c0RQT0JDTElz?=
 =?utf-8?B?a3N5ak1lY3RSWmhZWDllNWhYM2N0WUdvVHFQV2lmTzd1Vi9pM0pGSlN4SVlw?=
 =?utf-8?B?a2VyVlFGSTNtWGhTR3NmK0k0R0R1TmdzSm5zQ2xSRWgySnZLcHlKcGhGY1dS?=
 =?utf-8?B?ZzR3RDZnUjM5bC9tRUZDVWhnRTZxQjlZUWV2endaa0o4OVdQWEs1N2NNUCs5?=
 =?utf-8?B?UVdud0w1OTBRL3diSFF6cG03WC9rbDdYNEdveFYydE5SazlJR3BSMzY2TXg1?=
 =?utf-8?B?SlJ2Uzg4S3k4UFV3eXJTaGpjY1dQVHlPM253bFVrcWRzY1VJaGx6eXg4UEMy?=
 =?utf-8?B?UCtvYlErZ0xmWjllaVZlVkJueGlzVkZFTm5CcVNxaXJzQUxVdG02d2hRN0lK?=
 =?utf-8?B?OVJQWGxWZlo1Sll2bFRIT21YSXBHbW5kZUk2TEcvZlBXTDUwNVZIdUo4WWx1?=
 =?utf-8?B?bVJjeHJ4dEFPQnZGTkRwODUyWWsrYnhQTlVDaHBlQ0Fmck5nbjlmRm85TkM4?=
 =?utf-8?B?VUxTL0NxOXZxMWhwQXZUQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGpaVzNxdjBWcDJvcHBHVTAxVGk4Zk51Z3Y1YlNPTjg0di9GM2RxRWFDQkpa?=
 =?utf-8?B?N3NmZ3lyRFNiMjc0amJpaDRoMVQ1Yk1FS2ZUaUN0Q1ZmeUNFKzJvclhKeENs?=
 =?utf-8?B?NE5LSHVPK0JDZFc4NGRMRS9YajVnUTRpTVhkdlF0d1lWN1BiaThkYlBvSnZV?=
 =?utf-8?B?UThrbVdieG80RXl5YVg3QWxMTWJWYnh5R0kza0cxK2k3Ly93S0szL2liMmZI?=
 =?utf-8?B?Vk5PN2JSaUdmUUJIOWlVcTRoTDJJRWZXUDc0azVWcENvRE5vTzdSRVFjd2s1?=
 =?utf-8?B?QjFraWJmUDhmWngvRzYyQWE1QkpLL0NGMjJUc1JFYlgzMzVwczVjZTUxU1ZP?=
 =?utf-8?B?U0YrSk5aTWp1endscHZSblJWOVJJTWxidmlkellZbzViZHg0cXA5d3dqZVlX?=
 =?utf-8?B?TEl6alUzOGZkcHd2eWNnb2tibVhXWjIzekVBbFVpQmwzcFBTNGxrdnFHQ1Nm?=
 =?utf-8?B?dlQyZXFpZXlRNlZHdS9KR1JVNjg5OXpSS0FBQU9aTXFHS2h5UkdzNVZJaWFs?=
 =?utf-8?B?N0RpVVpNamNjM0Fub2lZOVk1RGZDbGZCR1g3UU1CeGtFNnZ6dDN2NnZJUnIy?=
 =?utf-8?B?ZDcvdUNmQWZEdVFmSVFqSGVueEVSUnN0VWJXRytwaDU5SHhvTGxEaEdFS251?=
 =?utf-8?B?TFprTlF3RlFGOGNCVWNoNG84bExvOXRlYkZBUGxXV0cybWpIL2ZvUTBPTURp?=
 =?utf-8?B?VXRSOWZLdmRMNlJkSldJVlVOUWR0aEcyNnZEbFZLRStjaDRMZEtxMHh6RXBP?=
 =?utf-8?B?bHZqM1NybXRnaXFWWm9kajVVZmdaSmliZlhPZnVCMlhtd0laV0R2UjlndEla?=
 =?utf-8?B?OFZhbWxKUmdOMk1KWmpxNUkzbU1GS282QXQ4UE05b1ozM0xqSmdRZDhnOE5X?=
 =?utf-8?B?MDVKd3VrNEVFdmxUL0R3UFE3dllnaWZ0MHR0M3BzUC9HL1pDZFA1NzU5Z3Nl?=
 =?utf-8?B?bVpoVjlVOGNDSmtlZ3VRaXRkb2d5c3Y3NHQ5QWNzMnVabDhRbkc5TUJjQ2Qw?=
 =?utf-8?B?aFZFZTJJOVM5UnEzRmFBcU9hZ0t5WHZQY0piTzV0Q0Vha290SGlCcmxaLzcw?=
 =?utf-8?B?Nk9HQ1AyYmpvSS9LZkIxRWNrZnhUWWJJdXdHQStoTjNRSjByczNicU1YUDky?=
 =?utf-8?B?NzlUbzlPUGRyOGsrcW02ODBqWERGM2s1eGUybW1wejdsRjFON001Yk83UW5O?=
 =?utf-8?B?MHZFcXFoZjZOL1FvaEQ2T2lhSTNLdTYyZUZLNzBNY0p0aEZGZDlEUkVDbTZU?=
 =?utf-8?B?eGVXeFRjazRGelg3RnJUQlNFRjhnWG9TV05rZ3BHRXM4Z3BmMm11a29IOFNu?=
 =?utf-8?B?RTltaUxBb0FIUVlXMlBJZEU5T2dkTVAvYVkyUHY4YnVFUFdGS1pidnFZcUkw?=
 =?utf-8?B?bzJpVGFPdGdSZlJLRTNtY1A4WDFrRzFEUDV6d25yaGZrK3ZFNE9LYVE4Sjda?=
 =?utf-8?B?SHhEbWJ4RkJiUFlPYXVsS3ZQSy9pMTFoZXFwMDQ1eXgzdnZSaU1hbU9haUFW?=
 =?utf-8?B?bEZ0SWg5S3BybW5qY3QvUHB3MzRBbW5QalArZzRNZVRYdkxRbU04dlBTeW9N?=
 =?utf-8?B?ZXVXb1gvRkpFK00yZzBsQkU1OTI3em9FRkp5bVFDWkt6alNtUFFnbmdsZk1J?=
 =?utf-8?B?bnNlcytQQ01HWVNpWnJ4dnpLM1lSdDRkRysyVVk1KzMyckp5d1VuVzVjNmIz?=
 =?utf-8?B?Y1VSV2dmWjJZUGlpTGdvMWNCOGpqeGQ2NFV0M05tUlRuUGtGUko5MXMzMkkr?=
 =?utf-8?B?MnhDZEx2QmI4Mm5CcHR6UzUwcDBrd0ZUT2hCVllDUVAyOWhGRHZNM09lend2?=
 =?utf-8?B?ZU1ORFFkTDFjUzVHQmFUSWpEdUR4OW9TU2lqNG1rVStVWEZZQmRZU2ZwQVNP?=
 =?utf-8?B?VkFjY3JpanY1WEFEQ0pmNHQrVm1GK2RaVDR3VjFxMGN6WU14Ris4RlpPYk51?=
 =?utf-8?B?c3JkMG1LNWhOenZ5alR5cjhxTUdrQWt2MHQ0SHVhSUJPTWMwR09BWGNLeTZz?=
 =?utf-8?B?bVVtMWpYZHNuU3o3LytxdXZBc1ZIUVNhZ0hZNEpsZ0tlbms1L0VETCs5S21R?=
 =?utf-8?B?dVlTZnNzeUsxRmdlRHpqWGc3OUp3VXpXUnFCWnNtSlgzUFIxMTdFaVFJTE1C?=
 =?utf-8?B?K3BSTnpmTkVrSGdzdFc3VHVCM2tvbmQ1WFhVZFFRQ2dlM21lYTVxOHdZTmFD?=
 =?utf-8?B?SWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD7FB8941BDCD648860A722739879E59@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a105d608-c201-49d6-19cb-08dc5d1cd611
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2024 07:22:41.1533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pPtM9Cg4BmegO6gTTDwnQhMh/8mIotFbACBsV3XNhrU7ataiiKgk6EtMSDto3CyEjiOHurbibeVw3mwsl/2rsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6528
X-MTK: N

T24gRnJpLCAyMDI0LTA0LTEyIGF0IDEwOjQxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgU2ltcGxpZnkgdGhlIFVGU0hDSSBjb3JlIGFuZCBhbHNvIHRoZSBV
RlNIQ0kgaG9zdCBkcml2ZXJzIGJ5DQo+IHJlbW92aW5nDQo+IHRoZSAuZ2V0X2hiYV9tYWMoKSBj
YWxsYmFjayBhbmQgYnkgcmVhZGluZyB0aGUgTlVUUlMgcmVnaXN0ZXIgZmllbGQNCj4gaW5zdGVh
ZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20u
b3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5jICAgICAgfCAxNCArKysr
Ky0tLS0tLS0tLQ0KPiAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QtcHJpdi5oICB8ICA4IC0tLS0t
LS0tDQo+ICBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jIHwgMTMgLS0tLS0tLS0tLS0t
LQ0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMtcWNvbS5jICAgICB8ICA3IC0tLS0tLS0NCj4gIGRy
aXZlcnMvdWZzL2hvc3QvdWZzLXFjb20uaCAgICAgfCAgMSAtDQo+ICBpbmNsdWRlL3Vmcy91ZnNo
Y2QuaCAgICAgICAgICAgIHwgIDIgLS0NCj4gIGluY2x1ZGUvdWZzL3Vmc2hjaS5oICAgICAgICAg
ICAgfCAgMiArLQ0KPiAgNyBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDQxIGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5jIGIv
ZHJpdmVycy91ZnMvY29yZS91ZnMtbWNxLmMNCj4gaW5kZXggNzY4YmY4N2NkODBkLi4yMjg5NzVj
YWY2OGUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5jDQo+ICsrKyBi
L2RyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5jDQo+IEBAIC0xMjUsMjAgKzEyNSwxNiBAQCBzdHJ1
Y3QgdWZzX2h3X3F1ZXVlDQo+ICp1ZnNoY2RfbWNxX3JlcV90b19od3Eoc3RydWN0IHVmc19oYmEg
KmhiYSwNCj4gICAqDQo+ICAgKiBNQUMgLSBNYXguIEFjdGl2ZSBDb21tYW5kIG9mIHRoZSBIb3N0
IENvbnRyb2xsZXIgKEhDKQ0KPiAgICogSEMgd291bGRuJ3Qgc2VuZCBtb3JlIHRoYW4gdGhpcyBj
b21tYW5kcyB0byB0aGUgZGV2aWNlLg0KPiAtICogSXQgaXMgbWFuZGF0b3J5IHRvIGltcGxlbWVu
dCBnZXRfaGJhX21hYygpIHRvIGVuYWJsZSBNQ1EgbW9kZS4NCj4gICAqIENhbGN1bGF0ZXMgYW5k
IGFkanVzdHMgdGhlIHF1ZXVlIGRlcHRoIGJhc2VkIG9uIHRoZSBkZXB0aA0KPiAgICogc3VwcG9y
dGVkIGJ5IHRoZSBIQyBhbmQgdWZzIGRldmljZS4NCj4gICAqLw0KPiAgaW50IHVmc2hjZF9tY3Ff
ZGVjaWRlX3F1ZXVlX2RlcHRoKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICB7DQo+IC0JaW50IG1h
YzsNCj4gKwlpbnQgbnV0cnM7DQo+ICANCj4gLQkvKiBNYW5kYXRvcnkgdG8gaW1wbGVtZW50IGdl
dF9oYmFfbWFjKCkgKi8NCj4gLQltYWMgPSB1ZnNoY2RfbWNxX3ZvcHNfZ2V0X2hiYV9tYWMoaGJh
KTsNCj4gLQlpZiAobWFjIDwgMCkgew0KPiAtCQlkZXZfZXJyKGhiYS0+ZGV2LCAiRmFpbGVkIHRv
IGdldCBtYWMsIGVycj0lZFxuIiwgbWFjKTsNCj4gLQkJcmV0dXJuIG1hYzsNCj4gLQl9DQo+ICsJ
V0FSTl9PTl9PTkNFKCFoYmEtPm1jcV9lbmFibGVkKTsNCj4gKwludXRycyA9IChoYmEtPmNhcGFi
aWxpdGllcyAmIE1BU0tfVFJBTlNGRVJfUkVRVUVTVFNfU0xPVFMpICsgMTsNCj4gDQoNCkhpIEJh
cnQsDQoNCk1lZGlhdGVrIHNvbWUgcGxhdGZvcm0gcmVhZCBudXRycyBpbiBNQ1EgbW9kZSBpcyAw
eDFGLCBub3QgMHgzRi4NCldoaWNoIG1lYW5zIHdlIHN0aWxsIG5lZWQgdGhpcyBvcHMgdG8gZ2V0
IGNvcnJlY3QgTUFDLg0KDQoNCj4gKwlXQVJOX09OQ0UobnV0cnMgPCAzMiwgIm51dHJzOiAlZCA8
IDMyXG4iLCBudXRycyk7DQo+ICANCj4gIAlXQVJOX09OX09OQ0UoIWhiYS0+ZGV2X2luZm8uYnF1
ZXVlZGVwdGgpOw0KPiAgCS8qDQo+IEBAIC0xNDYsNyArMTQyLDcgQEAgaW50IHVmc2hjZF9tY3Ff
ZGVjaWRlX3F1ZXVlX2RlcHRoKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEpDQo+ICAJICogSXQgaXMg
bWFuZGF0b3J5IGZvciBVRlMgZGV2aWNlIHRvIGRlZmluZSBiUXVldWVEZXB0aCBpZg0KPiAgCSAq
IHNoYXJlZCBxdWV1aW5nIGFyY2hpdGVjdHVyZSBpcyBlbmFibGVkLg0KPiAgCSAqLw0KPiAtCXJl
dHVybiBtaW5fdChpbnQsIG1hYywgaGJhLT5kZXZfaW5mby5icXVldWVkZXB0aCk7DQo+ICsJcmV0
dXJuIG1pbl90KGludCwgbnV0cnMsIGhiYS0+ZGV2X2luZm8uYnF1ZXVlZGVwdGgpOw0KPiAgfQ0K
PiAgDQo+ICBzdGF0aWMgaW50IHVmc2hjZF9tY3FfY29uZmlnX25yX3F1ZXVlcyhzdHJ1Y3QgdWZz
X2hiYSAqaGJhKQ0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QtcHJpdi5o
DQo+IGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QtcHJpdi5oDQo+IGluZGV4IGY0MmQ5OWNlNWJm
MS4uYTFhZGQyMjIwNWRiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC1w
cml2LmgNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QtcHJpdi5oDQo+IEBAIC0yNTUs
MTQgKzI1NSw2IEBAIHN0YXRpYyBpbmxpbmUgaW50DQo+IHVmc2hjZF92b3BzX21jcV9jb25maWdf
cmVzb3VyY2Uoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIAlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+
ICB9DQo+ICANCj4gLXN0YXRpYyBpbmxpbmUgaW50IHVmc2hjZF9tY3Ffdm9wc19nZXRfaGJhX21h
YyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAtew0KPiAtCWlmIChoYmEtPnZvcHMgJiYgaGJhLT52
b3BzLT5nZXRfaGJhX21hYykNCj4gLQkJcmV0dXJuIGhiYS0+dm9wcy0+Z2V0X2hiYV9tYWMoaGJh
KTsNCj4gLQ0KPiAtCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gLX0NCj4gLQ0KPiAgc3RhdGljIGlu
bGluZSBpbnQgdWZzaGNkX21jcV92b3BzX29wX3J1bnRpbWVfY29uZmlnKHN0cnVjdCB1ZnNfaGJh
DQo+ICpoYmEpDQo+ICB7DQo+ICAJaWYgKGhiYS0+dm9wcyAmJiBoYmEtPnZvcHMtPm9wX3J1bnRp
bWVfY29uZmlnKQ0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsu
YyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLQ0KPiBtZWRpYXRlay5jDQo+IGluZGV4IGM0Zjk5NzE5
NmM1Ny4uMGE1MjkxN2U3ZmU2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1t
ZWRpYXRlay5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gQEAg
LTM0LDcgKzM0LDYgQEAgc3RhdGljIGludCAgdWZzX210a19jb25maWdfbWNxKHN0cnVjdCB1ZnNf
aGJhICpoYmEsDQo+IGJvb2wgaXJxKTsNCj4gICNpbmNsdWRlICJ1ZnMtbWVkaWF0ZWstdHJhY2Uu
aCINCj4gICN1bmRlZiBDUkVBVEVfVFJBQ0VfUE9JTlRTDQo+ICANCj4gLSNkZWZpbmUgTUFYX1NV
UFBfTUFDIDY0DQo+ICAjZGVmaW5lIE1DUV9RVUVVRV9PRkZTRVQoYykgKCgoKGMpID4+IDE2KSAm
IDB4RkYpICogMHgyMDApDQo+ICANCj4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdWZzX2Rldl9xdWly
ayB1ZnNfbXRrX2Rldl9maXh1cHNbXSA9IHsNCj4gQEAgLTE2NTYsMTcgKzE2NTUsNiBAQCBzdGF0
aWMgaW50IHVmc19tdGtfY2xrX3NjYWxlX25vdGlmeShzdHJ1Y3QNCj4gdWZzX2hiYSAqaGJhLCBi
b29sIHNjYWxlX3VwLA0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+IC1zdGF0aWMgaW50IHVm
c19tdGtfZ2V0X2hiYV9tYWMoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gLXsNCj4gLQlzdHJ1Y3Qg
dWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQo+IC0NCj4gLQkv
KiBNQ1Egb3BlcmF0aW9uIG5vdCBwZXJtaXR0ZWQgKi8NCj4gLQlpZiAoaG9zdC0+Y2FwcyAmIFVG
U19NVEtfQ0FQX0RJU0FCTEVfTUNRKQ0KPiAtCQlyZXR1cm4gLUVQRVJNOw0KPiAtDQo+IA0KDQpC
ZXNpZGUsIG1lZGlhdGVrIGFsc28gaGF2ZSBhIGhvc3QgY2FwcyB0byBkaXNhYmxlIE1DUSBldmVu
IGh3IHN1cHBvcnQuDQoNClRoYW5rcy4NClBldGVyDQoNCg0KDQo+IC0JcmV0dXJuIE1BWF9TVVBQ
X01BQzsNCj4gLX0NCj4gLQ0KPiAgc3RhdGljIGludCB1ZnNfbXRrX29wX3J1bnRpbWVfY29uZmln
KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICB7DQo+ICAJc3RydWN0IHVmc2hjZF9tY3Ffb3ByX2lu
Zm9fdCAqb3ByOw0KPiBAQCAtMTgwMSw3ICsxNzg5LDYgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1
ZnNfaGJhX3ZhcmlhbnRfb3BzDQo+IHVmc19oYmFfbXRrX3ZvcHMgPSB7DQo+ICAJLmNvbmZpZ19z
Y2FsaW5nX3BhcmFtID0gdWZzX210a19jb25maWdfc2NhbGluZ19wYXJhbSwNCj4gIAkuY2xrX3Nj
YWxlX25vdGlmeSAgICA9IHVmc19tdGtfY2xrX3NjYWxlX25vdGlmeSwNCj4gIAkvKiBtY3Egdm9w
cyAqLw0KPiAtCS5nZXRfaGJhX21hYyAgICAgICAgID0gdWZzX210a19nZXRfaGJhX21hYywNCj4g
IAkub3BfcnVudGltZV9jb25maWcgICA9IHVmc19tdGtfb3BfcnVudGltZV9jb25maWcsDQo+ICAJ
Lm1jcV9jb25maWdfcmVzb3VyY2UgPSB1ZnNfbXRrX21jcV9jb25maWdfcmVzb3VyY2UsDQo+ICAJ
LmNvbmZpZ19lc2kgICAgICAgICAgPSB1ZnNfbXRrX2NvbmZpZ19lc2ksDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1xY29tLmMgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy0NCj4g
cWNvbS5jDQo+IGluZGV4IDBiMDJlNjk3ZWE1Yi4uMTAwZjVmMGI5ZGE2IDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1xY29tLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91
ZnMtcWNvbS5jDQo+IEBAIC0xNjczLDEyICsxNjczLDYgQEAgc3RhdGljIGludCB1ZnNfcWNvbV9v
cF9ydW50aW1lX2NvbmZpZyhzdHJ1Y3QNCj4gdWZzX2hiYSAqaGJhKQ0KPiAgCXJldHVybiAwOw0K
PiAgfQ0KPiAgDQo+IC1zdGF0aWMgaW50IHVmc19xY29tX2dldF9oYmFfbWFjKHN0cnVjdCB1ZnNf
aGJhICpoYmEpDQo+IC17DQo+IC0JLyogUXVhbGNvbW0gSEMgc3VwcG9ydHMgdXAgdG8gNjQgKi8N
Cj4gLQlyZXR1cm4gTUFYX1NVUFBfTUFDOw0KPiAtfQ0KPiAtDQo+ICBzdGF0aWMgaW50IHVmc19x
Y29tX2dldF9vdXRzdGFuZGluZ19jcXMoc3RydWN0IHVmc19oYmEgKmhiYSwNCj4gIAkJCQkJdW5z
aWduZWQgbG9uZyAqb2NxcykNCj4gIHsNCj4gQEAgLTE3OTgsNyArMTc5Miw2IEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X29wcw0KPiB1ZnNfaGJhX3Fjb21fdm9wcyA9IHsN
Cj4gIAkucHJvZ3JhbV9rZXkJCT0gdWZzX3Fjb21faWNlX3Byb2dyYW1fa2V5LA0KPiAgCS5yZWlu
aXRfbm90aWZ5CQk9IHVmc19xY29tX3JlaW5pdF9ub3RpZnksDQo+ICAJLm1jcV9jb25maWdfcmVz
b3VyY2UJPSB1ZnNfcWNvbV9tY3FfY29uZmlnX3Jlc291cmNlLA0KPiAtCS5nZXRfaGJhX21hYwkJ
PSB1ZnNfcWNvbV9nZXRfaGJhX21hYywNCj4gIAkub3BfcnVudGltZV9jb25maWcJPSB1ZnNfcWNv
bV9vcF9ydW50aW1lX2NvbmZpZywNCj4gIAkuZ2V0X291dHN0YW5kaW5nX2Nxcwk9IHVmc19xY29t
X2dldF9vdXRzdGFuZGluZ19jcXMsDQo+ICAJLmNvbmZpZ19lc2kJCT0gdWZzX3Fjb21fY29uZmln
X2VzaSwNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLXFjb20uaCBiL2RyaXZl
cnMvdWZzL2hvc3QvdWZzLQ0KPiBxY29tLmgNCj4gaW5kZXggYjlkZTE3MDk4M2M5Li43OTUxNDIx
Yjk5MjEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLXFjb20uaA0KPiArKysg
Yi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1xY29tLmgNCj4gQEAgLTE0LDcgKzE0LDYgQEANCj4gICNk
ZWZpbmUgVFhfRlNNX0hJQkVSTjggICAgICAgICAgMHgxDQo+ICAjZGVmaW5lIEhCUk44X1BPTExf
VE9VVF9NUyAgICAgIDEwMA0KPiAgI2RlZmluZSBERUZBVUxUX0NMS19SQVRFX0haICAgICAxMDAw
MDAwDQo+IC0jZGVmaW5lIE1BWF9TVVBQX01BQwkJNjQNCj4gICNkZWZpbmUgTUFYX0VTSV9WRUMJ
CTMyDQo+ICANCj4gICNkZWZpbmUgVUZTX0hXX1ZFUl9NQUpPUl9NQVNLCUdFTk1BU0soMzEsIDI4
KQ0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91ZnMvdWZzaGNkLmggYi9pbmNsdWRlL3Vmcy91ZnNo
Y2QuaA0KPiBpbmRleCBiYWQ4OGJkOTE5OTUuLjNmNTA2MjFiODU2NCAxMDA2NDQNCj4gLS0tIGEv
aW5jbHVkZS91ZnMvdWZzaGNkLmgNCj4gKysrIGIvaW5jbHVkZS91ZnMvdWZzaGNkLmgNCj4gQEAg
LTMyNCw3ICszMjQsNiBAQCBzdHJ1Y3QgdWZzX3B3cl9tb2RlX2luZm8gew0KPiAgICogQGV2ZW50
X25vdGlmeTogY2FsbGVkIHRvIG5vdGlmeSBpbXBvcnRhbnQgZXZlbnRzDQo+ICAgKiBAcmVpbml0
X25vdGlmeTogY2FsbGVkIHRvIG5vdGlmeSByZWluaXQgb2YgVUZTSENEIGR1cmluZyBtYXggZ2Vh
cg0KPiBzd2l0Y2gNCj4gICAqIEBtY3FfY29uZmlnX3Jlc291cmNlOiBjYWxsZWQgdG8gY29uZmln
dXJlIE1DUSBwbGF0Zm9ybSByZXNvdXJjZXMNCj4gLSAqIEBnZXRfaGJhX21hYzogY2FsbGVkIHRv
IGdldCB2ZW5kb3Igc3BlY2lmaWMgbWFjIHZhbHVlLCBtYW5kYXRvcnkNCj4gZm9yIG1jcSBtb2Rl
DQo+ICAgKiBAb3BfcnVudGltZV9jb25maWc6IGNhbGxlZCB0byBjb25maWcgT3BlcmF0aW9uIGFu
ZCBydW50aW1lIHJlZ3MNCj4gUG9pbnRlcnMNCj4gICAqIEBnZXRfb3V0c3RhbmRpbmdfY3FzOiBj
YWxsZWQgdG8gZ2V0IG91dHN0YW5kaW5nIGNvbXBsZXRpb24gcXVldWVzDQo+ICAgKiBAY29uZmln
X2VzaTogY2FsbGVkIHRvIGNvbmZpZyBFdmVudCBTcGVjaWZpYyBJbnRlcnJ1cHQNCj4gQEAgLTM2
OSw3ICszNjgsNiBAQCBzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X29wcyB7DQo+ICAJCQkJZW51bSB1
ZnNfZXZlbnRfdHlwZSBldnQsIHZvaWQgKmRhdGEpOw0KPiAgCXZvaWQJKCpyZWluaXRfbm90aWZ5
KShzdHJ1Y3QgdWZzX2hiYSAqKTsNCj4gIAlpbnQJKCptY3FfY29uZmlnX3Jlc291cmNlKShzdHJ1
Y3QgdWZzX2hiYSAqaGJhKTsNCj4gLQlpbnQJKCpnZXRfaGJhX21hYykoc3RydWN0IHVmc19oYmEg
KmhiYSk7DQo+ICAJaW50CSgqb3BfcnVudGltZV9jb25maWcpKHN0cnVjdCB1ZnNfaGJhICpoYmEp
Ow0KPiAgCWludAkoKmdldF9vdXRzdGFuZGluZ19jcXMpKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+
ICAJCQkJICAgICAgIHVuc2lnbmVkIGxvbmcgKm9jcXMpOw0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS91ZnMvdWZzaGNpLmggYi9pbmNsdWRlL3Vmcy91ZnNoY2kuaA0KPiBpbmRleCAzODVlMWM2Yjhk
NjAuLjZjMjgxNzcxMTNlMSAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS91ZnMvdWZzaGNpLmgNCj4g
KysrIGIvaW5jbHVkZS91ZnMvdWZzaGNpLmgNCj4gQEAgLTY3LDcgKzY3LDcgQEAgZW51bSB7DQo+
ICANCj4gIC8qIENvbnRyb2xsZXIgY2FwYWJpbGl0eSBtYXNrcyAqLw0KPiAgZW51bSB7DQo+IC0J
TUFTS19UUkFOU0ZFUl9SRVFVRVNUU19TTE9UUwkJPSAweDAwMDAwMDFGLA0KPiArCU1BU0tfVFJB
TlNGRVJfUkVRVUVTVFNfU0xPVFMJCT0gMHgwMDAwMDBGRiwNCj4gIAlNQVNLX1RBU0tfTUFOQUdF
TUVOVF9SRVFVRVNUX1NMT1RTCT0gMHgwMDA3MDAwMCwNCj4gIAlNQVNLX0VIU0xVVFJEX1NVUFBP
UlRFRAkJCT0gMHgwMDQwMDAwMCwNCj4gIAlNQVNLX0FVVE9fSElCRVJOOF9TVVBQT1JUCQk9IDB4
MDA4MDAwMDAsDQo=
