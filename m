Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA5B31A57B
	for <linux-scsi@vger.kernel.org>; Fri,  5 Dec 2025 08:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764923538; cv=fail; b=JemWPyaBPrB8LH+48B3BlbsYysyBVkIfwosYL9SA2hQW1yKoAhHvRNyDX/cwQfsWvNn8FsRFltZHTZPHQ1nN6+dgXMMKrB83HBWCAqD8fcul8PL3CMM4gFRIFWT3aeZpZ9tv/Yy3OnIYNaCtX1YteDM7Oqk2gqGBDpWPoaIFO9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764923538; c=relaxed/simple;
	bh=ykZU7pCBbPtn3Xew3+43wxyuML5h3yLv/n1h1oeyIc4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fdn1RUsLKJfBA8V1kUgZfCNJ6mnztrCPsobH/HOZGt7ETnZkKjGdeb0XiL0KHGy8MR3CY7wd+RQ3Pb+49QY8u7pufJEEqJU+Zl6NlyybFZleRBa0tZQRtcHoxtsdJqfmX1bkwT8BzCUlm+F/Vo/CEcm/LsjYY+9JGYBGLjjkm6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=mEoeJ7dG; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=dvnmhsWf; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mEoeJ7dG";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="dvnmhsWf"
X-UUID: e10b785ed1b411f0b2bf0b349165d6e0-20251205
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ykZU7pCBbPtn3Xew3+43wxyuML5h3yLv/n1h1oeyIc4=;
	b=mEoeJ7dG74xYP4OZ+uBer1oGKxatJ9FjWdOu+Pt4DDAYYE2sMRL0+JUNXbCgpK9QqE/e5cndqquvC2wNMyrjmQo58VG5Gq8nkIvSxXptNr9zCC6ZP3UBgdSbGxZ9MFEP2FuZ2Aw0vPXs041guCGYpGTEvZyjVnG6vztK+uak+MY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:683e248b-64f4-4c75-ba13-9341b8d35e96,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:7a5aabb2-13de-4936-a6df-52eb9b61d285,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:1,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e10b785ed1b411f0b2bf0b349165d6e0-20251205
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 76285680; Fri, 05 Dec 2025 16:32:04 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 5 Dec 2025 16:32:03 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Fri, 5 Dec 2025 16:32:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lmhqpoKlumEIC/+vkjdI1+IPKAZsAmBpcuAEtFWb1dZ+aD8jtx92m9uITcjYD0jCz2HvvavWEyd+h7RuuKOeg47RasgOIT8ZsQwbndjOWab8Sp3UVMORkwJicxJ1+XmCFIftlt5ThegEP1qNkTxCtzxfJq2MnJ5Bpfqk3BJs0NYCNPQHJ0oB2Xwj2uyOpUwO72uac++bkO7RWHNYtPRLlYViI0lKSi3W7qzY4Bs4d8i7YAt+w3uuaGWSxCdfI9m7ltwZW9Tmlm2MnV1fJyrgpPtUPuCOhLmo4XgqJ1Qdejvys/xyj6lPuc5BS5MB4R5Meqq52Hr++jYZTrU3mtGuYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykZU7pCBbPtn3Xew3+43wxyuML5h3yLv/n1h1oeyIc4=;
 b=J8ROnO/CzZe6SojqnF4j/ee/DiLwG5trLGzZ07HjWfcD+8MSbldnR0zSDNdE9lj8ZqJZixxHzqFr6Afyzxk6f38yseDnt+WP2/KRUTEmVxBd1PM9BgFljolfvlcCLHsL4g0avYxQnUG3UxNtHwyK0e31r9XXDXTZFheAryf0wbCBUd29dCB5qj7d30bL/wp987N9HiWUKqLY1IfBoRFucZoKqukIBCKIi23Nn7FzGTOjP1ywNLIxTwqMTmn7ucmaqxbxHlvGfFdMO8g1vKAmLAWbeGWz28cV+Wxb4KMCvJajqXyrVe52vPKxbAD7rSzLVl2IJ5P4AEThSdXW1Cljwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykZU7pCBbPtn3Xew3+43wxyuML5h3yLv/n1h1oeyIc4=;
 b=dvnmhsWf06g5AqBbca09H0uR8MjxX06Cc3xk1K1jLqKfN4FACl8tbNBVfBFa2+6axnenDq27/n0nvHqSKXZvQqJ85Hz8ieVa7XsrLRUCpBdn3D+gOpjVPPLrMGSz7Uhy9dzv3DA/X8w9vGkZk6vqZoiPStoyDFQB0Ipx+a8Cu3c=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by TY2PPF94EB25A41.apcprd03.prod.outlook.com (2603:1096:408::9dc) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Fri, 5 Dec
 2025 08:32:01 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432%2]) with mapi id 15.20.9388.011; Fri, 5 Dec 2025
 08:32:01 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "rosh@debian.org"
	<rosh@debian.org>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"nitin.rawat@oss.qualcomm.com" <nitin.rawat@oss.qualcomm.com>,
	"mani@kernel.org" <mani@kernel.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ufs: core: Fix a deadlock in the frequency scaling code
Thread-Topic: [PATCH] ufs: core: Fix a deadlock in the frequency scaling code
Thread-Index: AQHcZUojFNv9hnnehEGA0coLdidZbbUSuKsA
Date: Fri, 5 Dec 2025 08:32:01 +0000
Message-ID: <a44b3c71da98d09ce7c4f55e5a5d217329d8be26.camel@mediatek.com>
References: <20251204181548.1006696-1-bvanassche@acm.org>
In-Reply-To: <20251204181548.1006696-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|TY2PPF94EB25A41:EE_
x-ms-office365-filtering-correlation-id: d8dd37e9-8032-4efd-4e2c-08de33d8c302
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZnR0U0Nzem1wY2drSkdNelUyaVN6K1BVdFVRZXYySS9oUUxuTTdSQmNiK2Vo?=
 =?utf-8?B?VEd3T3c4RlhxdlR5TCtGa1RvcFc4L1BkL1lqa0pUU1U0cXZHZ2czdEJPSUNS?=
 =?utf-8?B?cXh1UEQ2Nm5PVDhVeXJpcklYSWs3ME0zYVJXNzk0dXRMUVZISVRIS3RyTmsx?=
 =?utf-8?B?dUNMSEd1dFZaM2xNRXpxcldyaWsxS29sejcvVXhFRVZ6a3FQOUh6MHhveDJ4?=
 =?utf-8?B?ditTc2xiUlNJUmVaMERnS2V0TlBrYUxtaWt6Znl3SE9VZ3B1d3RyZThSUlhD?=
 =?utf-8?B?RUpkbWhHeWFESm5zRG54UXVTeUlybHVvR0ZsVE9leHNFT3VkUGVUTUNVRHFB?=
 =?utf-8?B?Z01YTE8rRUNCNWVGdTFDTVFjeXZWR2xvN3RPTUpXVmI1REFEeVgxOFVoZU42?=
 =?utf-8?B?M2dZVisyYWUwcmh6SkFLNVlxZjlnUDNaOGJhNjZvSUo1SGw5YzNncXc2c1pz?=
 =?utf-8?B?ZW1NMjJBcmp6ZGNtZW9zOCthMFdzM1hzMWpyMlREeVNpVmI3b3Z2UlZvUm16?=
 =?utf-8?B?d2hibE9kSXd5V1Y3SzdKeVdDUUJVL3k0bFpFTzIzL3crektpQWVTTThyeXRr?=
 =?utf-8?B?dm1BVitWckRoMjNOeW5qdk9PWldiV1NvN29sWlV6cXhTMHFIYnBqSDBiQXNh?=
 =?utf-8?B?a2Q4eWhKN0g2SmxBTUVvdGsrbi9uMVcwdUVpM1NZV29WWXNYOFJhVDc4R3d2?=
 =?utf-8?B?UG5IVFZTNVFMRVZpbUZraDhOL2ZmaVBzOVpyN3JDekZUcGU0S2JNMDZEM1lL?=
 =?utf-8?B?a2k2U1VUNitRLzkxZldOekpEVnlXZWpIdkhrSDQ5WHEyMHZ5QUpVL3Y4ZnNp?=
 =?utf-8?B?dEc3cXdmdjBXODZtNmJJcWNuNUxjTUZzSVNJWHlFR3ZYUnlQU0ZwU1JqMy80?=
 =?utf-8?B?MGkxSWpVNm5tSWxwRVZyek8ybHVQRnUrNVZSZC92dEw4alQ2K3Q2dEJrbHMx?=
 =?utf-8?B?RkVtbmdpVjR4SVprRVBnbjFTVlJhQmM0eU5mb2JLcytWQXhzS2hnejdYMG9v?=
 =?utf-8?B?VGtQbGVXWjN0ZFhGY2lPZ2pRZnFiSGZCL3lSa3hmanc3TEk3R2xSZVV4bmR3?=
 =?utf-8?B?L0JtVmRqRHRJUjVKaTZNa0pCZEJQKzI3RnlaR0dXNjI2R2crZk9OaXJVMWQ0?=
 =?utf-8?B?SU9kT3RjcldQQUZxbXE3Qm5ZclBINitlS3FnMWs2Y1hBUURJQTFaQkx3ZklF?=
 =?utf-8?B?V3lveVRDZTNUcWduSXNlV0djclVFa2M3VnRKTlpVNlpTdnRDYmhiSmpybG1D?=
 =?utf-8?B?NjJFVThoajA4YzFQejBKMGx5eGVoT1pKbzd4OHJxYWt0N21HMFo3WTB3Q3FU?=
 =?utf-8?B?S0xoTlN3TmtvM3RxM01tcTl5eFpzYithelVCNWFmMFlKbzZ4MlR1bnVIS0JH?=
 =?utf-8?B?aTUwU1F2SDhxMEF1ZXg3VE9hUi9xMXFKY2hJak5ybWFyOW9TMDF2c01qWVEr?=
 =?utf-8?B?WlBhZ0YyTUhlK2hHNUpJNTJpNFl1QzJoZjNXWUVkN0hEcEEvVE1WNEV5Rmh1?=
 =?utf-8?B?TkcyTHYzWUdieXhIMEFzaDZpSXA5TWlYck8wVm9BLzNjQmRJbi9VV0d5cHBm?=
 =?utf-8?B?cEtQdlAvdFA2YTh2Wlg1V3hmL2tPMmhLZEQ4TVRHNm9nSitsbDJDR0lIYk9i?=
 =?utf-8?B?ZjJuSUFqSVlNOHdYUENWUTBaSVVGakwxSm9icWprQ1BZWEY2SjJNOHg4Z0Uv?=
 =?utf-8?B?dnJPMk55dENnTW15R0dZbTZIUzl0WjZMMW1QUHoyZzZVUW1pcDJWZE1vZGpn?=
 =?utf-8?B?aUZjT25ITU5UZ0VnTURYL2NtTG9OQWJ6c3dtam1rZG9FRVlVS0xmVWgranlD?=
 =?utf-8?B?UERVVS9zMVJneUp1SStraElZRWdRWkNxREd5bksya2lmcWVlVHYrNzBWcG53?=
 =?utf-8?B?b1NFYldERDJNTG1nODNJQ3ZUTCtaY2toZjR1MFVJbWxieVZXM3M4SGV2Nnl3?=
 =?utf-8?B?MXNEUHFmMzBKdUw5SEdJY0s4cXN2T1BZTnM0Mmc4TnNsYWdzWThBdDdBbmtj?=
 =?utf-8?B?M0V5WUU1OHhlenNqMGxCcHhhdHZNMGptSmJxWVQ5dmI1dTJrR3ZUek5PaUVT?=
 =?utf-8?Q?plMbtF?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjloQkNkV0NxK00reGZOdUVDOEp4ekgxZmp4VlhzTUY3aEZMeDJ1TW5oeEsz?=
 =?utf-8?B?UXh1YlFnZVJZdUdZd28rUWI2NEZzb3piUzRCeUZUYXBLVm5FUHZMVHkrTU5n?=
 =?utf-8?B?MjZZaERhK0xOTGJPSVRkY3NoQ3o4YVlERGtBT2MwdFQ2L1RlZjdTQXRsbmU2?=
 =?utf-8?B?TnNabU9ablM3RUxYUGVhK0V3d2RHbldrNEMzM29acjdVMUZoMkV6T09WYzZL?=
 =?utf-8?B?bDhDVmV2ZmVrMzJyR3BQdFhXaGhtM0dCSDRPcTRnai9vSG9CYjdiSDd5Ym1k?=
 =?utf-8?B?NVB6Vy9mallUNlBxZCtzN2o4NFE3M0l0ZjhEQU9hWnh4SXc4SUFucDJPK0p3?=
 =?utf-8?B?T3FxUU9SdnlGTFB5dktjeEdlTWFSTExFQ3BPV29wVmVwTGNFTTluRlZZL0hF?=
 =?utf-8?B?R01YWDBsR1hGeDRSc3IvVzRlMnRCYVF0dGFBZmZCSVFPQ2VWajdBQjNXTjBX?=
 =?utf-8?B?a1NIZkFHbkhHQ0ozM09KYU1lY0VTMSs2TWUyR2o4TFlsclVidStTRnBGcWpE?=
 =?utf-8?B?Tmd0YmV6OHRNOXlzUGxpMTAwMkpZS0VlckF0K0lQNmdzYjR0dnNvd2pHWnpN?=
 =?utf-8?B?TUpUbC90dzNKTmw5QVovMDNQNWJtUWl0TGx4ay9OSVh5MWdxL0QwMXZ1ZVI2?=
 =?utf-8?B?ZEUzQ1VySHovMnU2UUFKejk2NGRraHVuaW5wRmlYWExyS2pEcHpmQ0xIb0hv?=
 =?utf-8?B?RnVyWENsTmY5cWtBSFgzRTUvMnRsYW9hRGJER081d3FLQnBudjdvQ2FjQTBz?=
 =?utf-8?B?WVBjMWxWKzZiRHA2ME5PYitBcW5HWDY2VXMyT1NLNWZOVE1uc25KdkZUNU41?=
 =?utf-8?B?WUZIMjJuRSs5U2RyZmdKMnBFdVNGd2VuL0tlNjIwNUdXMFZUWHQrd2NtelRy?=
 =?utf-8?B?SDR1eHQxcGpVanhjekl5ZWpkK3hqZHJEQ08vcC9VaTNwZmNmbGpNN1hnemIv?=
 =?utf-8?B?ZDgybFozb2ZYcWlXL0cyZ1pWQkhUeGlNNDlHYWFQRVFpdUR3a3dZTy9TQzJN?=
 =?utf-8?B?WVhNWVd0dVdCV3JscXNPOWJGdTdLT3VseXJ4T0c1SWlxQzlMUW1reGlmRnhh?=
 =?utf-8?B?bWxVTE1OclJqK3M0TVJhVnJPakc2QXl3WHNiN3pxckJvZ3Y0WDdhTVdqSFo4?=
 =?utf-8?B?MjJhZUdjRUthOVBVK3l2M2NhVjF5a290ZVRWVVk4WTh2WlhIK09Pei9TSzhj?=
 =?utf-8?B?cit1aEw2aHFCWWdzZmtsNml2WjdGeWpmb211T3BCM2FnV2toZVdsMW9kYzhZ?=
 =?utf-8?B?NzMvaVBUbXE3UE1Xb1FJcHBiTkU5NXdzMkxkVnpqbXJxNTh3bUJJK0NsLzV3?=
 =?utf-8?B?aFJkQ0o3VmxoL2Z5Qm13YlJGRTRmeWZwcVBLUFdPTS9Oc1EvL3ZTNUhUSzlh?=
 =?utf-8?B?RURxZS90ckdZSVNEU1pHK2M1ZFZVU0QyMHcxTEFndEd2R0xrRVpiVEt5SlU3?=
 =?utf-8?B?a2s3V2xzbG11NTlZb25iaVpleXJodWFDQUNpS3hUVGg3eFgvSEVHQ3NuVjNX?=
 =?utf-8?B?dzQwTUN1UVVpelZ4OGhKSXNOTGsrWjFnU2UxVDN6Rm0vRHowMnVNeWozN1Jq?=
 =?utf-8?B?S3lKb0d2ckxuNUxCRks3aVZzbzEydFl2NFRRMmp1R1JCQ3c2Q3dMc0h0MnB4?=
 =?utf-8?B?VUEwWHFadHhHUU9BclYzV08yVmEwOXBjbFFJMVAxcFBtTTg0WlN0MWZlNGla?=
 =?utf-8?B?OTVhZ3JreDFqdk83cHlMNGZWQWNxSUorcmtSaFBhZ0NaQ0ZDSlcxT2lIVktD?=
 =?utf-8?B?bkx4WUpRZU5rQjJpand0SnB2VzBWR2lsMjlTNFlic0NKS28xTnptOEVIQ3A3?=
 =?utf-8?B?T2NQVTVEenJNVndoelBzSGdPTkhzWDhTQ2VHUldoall1bFpQK21PZGthMGty?=
 =?utf-8?B?RXdNZzk3azNFWm41ZlRYeTJKOHdZYVh5ZDZVQ0hjd3NaTTdTcy81Q1VlQ0ls?=
 =?utf-8?B?cFFkR3k1R0x1aWxQSUNwRitkeFZENHdzR25SVmJzRUluMEMyeXkybFVCT2pS?=
 =?utf-8?B?VWlrTmxicExMaGxDeTYwcnAvbEJRWjVPNk12TDh2Y2ltakRPVy9mdHI3b3FS?=
 =?utf-8?B?MWhnc0hDVHVBdTZPN1RlUEQxU0RVUlZLbXcrZnE1dXdkWDQzWGxBdTVuYzNw?=
 =?utf-8?B?T2wyRmlkVnNYdzF5THhpRkhTY1lFN0k0MThjT1REeFNxWURQcjd3emp0VWRl?=
 =?utf-8?B?RkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9029B509B3D83847A7C5F921C7F98125@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8dd37e9-8032-4efd-4e2c-08de33d8c302
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2025 08:32:01.0444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ajHfLgPZLq3bqbpVek62ntx25XIf034/47UHKUQhRpf8sGahwR7jgMQOZWLTcOZrPU/Do34BfpEww28CkVyDwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PPF94EB25A41

T24gVGh1LCAyMDI1LTEyLTA0IGF0IDA4OjE1IC0xMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IENvbW1pdCAwOGIxMmNkYTZjNDQgKCJzY3NpOiB1ZnM6IGNvcmU6IFN3aXRjaCB0bw0KPiBz
Y3NpX2dldF9pbnRlcm5hbF9jbWQoKSIpDQo+IGFjY2lkZW50YWxseSBpbnRyb2R1Y2VkIGEgZGVh
ZGxvY2sgaW4gdGhlIGZyZXF1ZW5jeSBzY2FsaW5nIGNvZGUuDQo+IHVmc2hjZF9jbG9ja19zY2Fs
aW5nX3VucHJlcGFyZSgpIG1heSBzdWJtaXQgYSBkZXZpY2UgbWFuYWdlbWVudA0KPiBjb21tYW5k
DQo+IHdoaWxlIFNDU0kgY29tbWFuZCBwcm9jZXNzaW5nIGlzIGJsb2NrZWQuIFRoZSBkZWFkbG9j
ayB3YXMgaW50cm9kdWNlZA0KPiBieQ0KPiB1c2luZyB0aGUgU0NTSSBjb3JlIGZvciBzdWJtaXR0
aW5nIGRldmljZSBtYW5hZ2VtZW50IGNvbW1hbmRzDQo+IChzY3NpX2dldF9pbnRlcm5hbF9jbWQo
KSArIGJsa19leGVjdXRlX3JxKCkpLiBGaXggdGhpcyBkZWFkbG9jayBieQ0KPiBjYWxsaW5nDQo+
IGJsa19tcV91bnF1aWVzY2VfdGFnc2V0KCkgYmVmb3JlIGFueSBkZXZpY2UgbWFuYWdlbWVudCBj
b21tYW5kcyBhcmUNCj4gc3VibWl0dGVkIGJ5IHVmc2hjZF9jbG9ja19zY2FsaW5nX3VucHJlcGFy
ZSgpLg0KPiANCj4gRml4ZXM6IDA4YjEyY2RhNmM0NCAoInNjc2k6IHVmczogY29yZTogU3dpdGNo
IHRvDQo+IHNjc2lfZ2V0X2ludGVybmFsX2NtZCgpIikNCj4gUmVwb3J0ZWQtYnk6IE1hbml2YW5u
YW4gU2FkaGFzaXZhbSA8bWFuaUBrZXJuZWwub3JnPg0KPiBSZXBvcnRlZC1ieTogUm9nZXIgU2hp
bWl6dSA8cm9zaEBkZWJpYW4ub3JnPg0KPiBDbG9zZXM6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2xpbnV4LXNjc2kvZWhvcmphZmxhdGh6YWI1b2VreDJuYWUyenNzNXZpMnIzNnlxa3FzZmpi
MmZnc2lmejJAeWszdXM1ZzNpZ293Lw0KPiBUZXN0ZWQtYnk6IFJvZ2VyIFNoaW1penUgPHJvc2hA
ZGViaWFuLm9yZz4NCj4gQ2M6IE5pdGluIFJhd2F0IDxuaXRpbi5yYXdhdEBvc3MucXVhbGNvbW0u
Y29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9y
Zz4NCj4gLS0tDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVr
LmNvbT4NCg0K
