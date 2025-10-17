Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FE727FB1E
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 08:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689678; cv=fail; b=JROqBNimQK910JeL2w/3Z11YkdwVc/1EJfKJMRsr1UG0CO3i5odRYAIUUPhiq9KNJAYNqM//PsPkffK6CwYFsAW18cdEQ5kTAyKLaGqZisD/Hwoeh3MVX9IryYAU3ZfOx9lGqLYb1I6p+iVbeBC4Kj7lHVrrkgt+1r4W3c0+8o0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689678; c=relaxed/simple;
	bh=F9uf5cs1Codck+Cp8SD4ZwiPvp3j2g8UOYELsvxEoNI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o3BzGIQgp6Gso64IMKmj775Bqhix7VQ53Lw8ZK3XsqHRJnM/hEf/oDNDU3QqnF56aneGPXqnEOLN5uwsZJvxz2AMMXlGGbgWdcPPC18ALKkIP+xpD8yE5uwiK2hFp2t6eEi1T0G2U/+i/1z/534rFM4u5RHK6Isa2lS+iXA0+OU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qtnSjIz8; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=i+nHbjFH; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qtnSjIz8";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="i+nHbjFH"
X-UUID: 2af7c45cab3311f0ae1e63ff8927bad3-20251017
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=F9uf5cs1Codck+Cp8SD4ZwiPvp3j2g8UOYELsvxEoNI=;
	b=qtnSjIz8+7P3QMYjtu+UoKJSQYZXYa+wLXyRrDNfGb+cSfjRPE6xgWByiZ6PCxiRqjkOa4s3joNyO6zRXS+taCv3tPu8aL63ZH1kU2bDJ2EuTfwJuo3YXtt66wZEgqI5Vb92Q9+lIs+yIkd1CYukhjeCSZCBCZswkuLna9d6y18=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:f39fa3de-3553-41c4-a94f-c551e509aed1,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:6a5d2a51-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2af7c45cab3311f0ae1e63ff8927bad3-20251017
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1059268491; Fri, 17 Oct 2025 16:27:50 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 17 Oct 2025 16:27:47 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 17 Oct 2025 16:27:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bD0ai3a3Zn31i85PLqHk4zpdNjia5PkE6B1eJohT7bAAU+iFq8vyj1Zg+4kVQFJN/ftl1/6BYM2/U5tfUlyZvsarZG3bXKiBpFSV+mrvNDbemwD/VDVSry2O4FvCDyvLeek2TKpzNHwpO6r7fbWjLyGtkQ4RbG67kpEBxVvA6qeTY6WaOklKMtO9tzIRuXqEqAuya9aEgzYML3Qzy0EtwfVkxaqXA+cOYbpLKtPZLW/8ZHuYf77F9Gg0oUgp4kp2d1eGFqIsGhTK+AnJvi68buyngvYQDh3C0OZ56tkm4qsTtrWVru+4YSthws/5GbDzAS9WPhC2AOyEnB04wKBlWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9uf5cs1Codck+Cp8SD4ZwiPvp3j2g8UOYELsvxEoNI=;
 b=CbXtUL8sKefDU5IJvAfIuWJz+0oaCyajTPKxizfB9Pi6u0sMh5ae1eYHf5AQqDbDpaiJANhn4R3ft2zROObFTYXvHTyAsGNAf5frfJpp6QHtaadDy1DghdatbVSWyLsOiVGNJAMivcqNQGPGJc1uk5XUO9GotcCdzf0S0ktR9x0xpn8mJPQRlkFLcfFBrPl8UMrJr4ZBgMVNxsp0BK+fUXIdrth3f4cijqc+VAxBBtydpjwcfK+OCzrNmBcYXAuAlKfc/y6abeXX8tGRKCXcorb1+4iywssW9PIQ/4qiql2CjYfv5qGIk2rqVj2b9a19XrdWH8NRvb/VJQtbGXjuAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9uf5cs1Codck+Cp8SD4ZwiPvp3j2g8UOYELsvxEoNI=;
 b=i+nHbjFHb7ztkdXe9Q+K1TIm0W0nFQuXKMQyIJiFYSj+/VUjxUWZg3MDfYQHCkq7/KUoJz0cJBAvO+t50+FQ7rH2G0EB2x+qrDZbsaL/WQk8Q4Mtm0zCcu0idtMJ8wxiEEdSrd48RJJwun6JjS/TbaZqAQe40aUbt1TgjcHh9Kc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6847.apcprd03.prod.outlook.com (2603:1096:400:25b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 08:27:46 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 08:27:46 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"chullee@google.com" <chullee@google.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "beanhuo@micron.com" <beanhuo@micron.com>
Subject: Re: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid"
 attribute group
Thread-Topic: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid"
 attribute group
Thread-Index: AQHcPUVzmnY3uUn2AU60C/91apcezLTGBUiA
Date: Fri, 17 Oct 2025 08:27:46 +0000
Message-ID: <22dd7d580444be92d0029694468cdddf1ac98f13.camel@mediatek.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
	 <20251014200118.3390839-2-bvanassche@acm.org>
In-Reply-To: <20251014200118.3390839-2-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6847:EE_
x-ms-office365-filtering-correlation-id: d7e8b909-b8ad-4a19-73f1-08de0d570cc5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?V0NnZEViRTFkVFlCU0srZmNIclR3VUJQd3U2T3llU2p4RGFQVzZrZk4rMC93?=
 =?utf-8?B?ZVY3WldJYUlENHN1UHQ1MzhLaTRTWUR0U1IxcXc4TEcrK1o3bXpJbktsR056?=
 =?utf-8?B?aGhYZ2l5a21tczQxYXJ1dXh6RFBDZjU3Sk03L3ZsNWw5c3MzcDdaT0Z4TU16?=
 =?utf-8?B?M0JDQ05nTElNdjJTQTIzZlFhNGNMVjFwbVkwcWhXdWpJUVBiYVhmOWZXbTFQ?=
 =?utf-8?B?dHJCb1hueFBsb1pmVU1MNDRiSmZDS0ZyQVZ5SEljSUJ3UXNXaHRpZFNyZFd0?=
 =?utf-8?B?eW5VV0lxTjZDOWJ0YmVER3ZQZlZaWmQxejhQNndNU1hoOEJ3ZGVOWkd0UmRI?=
 =?utf-8?B?TkJWTWR1bXcrVWZtUHBXNU1XZm1mZnhwdGVHZU0yWTJ1cTlKdkVRd2EybGdu?=
 =?utf-8?B?VmJtTmlNMmgyeG1NMVVxT003S21GTlNhRXFRMzdndVU2NG45c0R5aDc2Uk9p?=
 =?utf-8?B?bWJodlZJbXpOcDk5QUpkMlUwTUZkQWVwNGpNK3JEaFJqamVoL2VPZ3VTUlU2?=
 =?utf-8?B?djNURHFPanZTL0VWbzRGSGpEdGd6QlRCWEJKa1pJSXVBQUtpbC9vZjNVNkNh?=
 =?utf-8?B?OTlFN1k0N1BSZEFzQUdjcEEwQmhRUzVuRTM2ZVErTGJFSFRiQkRRcUZrTjZ4?=
 =?utf-8?B?emdSOFlEOWR1VHpNcTRHOVg2dTVIaW5XQVkrVzFqa0ZnY08rVW9VdnlyUVFJ?=
 =?utf-8?B?SVVibHZEdWlEQU83MEZHTTg4RzJvditsRG4vOGVmZFlwR25wN0F4REVMT256?=
 =?utf-8?B?ZTN2NVRzWkxVOGlJSWQ3ekZIbTUvSEdwSE15elhoaDJuNDUzNFBCZXlFY0tu?=
 =?utf-8?B?UFRaaHhUU0xQYlJyRWZUSEF2SmJMdENLYzM1MUFtWFhHemxNN2RBTDNNbXlQ?=
 =?utf-8?B?ZVRMaXFWQ0ZzbkxLWk9lZzF5eXdwOGVZV0srdmIxc0lROWdleFBwejNud1J4?=
 =?utf-8?B?ZUZIVTdCMU9KeFRkS0wvZHdSMXBwMUxBRlVhSFZpSjVCTyt4UkpLWVg0Qk1a?=
 =?utf-8?B?eTZONXFaZkZVSmxSbE5VYVpHVDY3anBRQVl4MEplUlR5NnFDNU5YQko4MGIy?=
 =?utf-8?B?cnlaVjh6YlZ1R3g3YkJ0RGFXUXlNcDlCVmtScWc1SzhmMEFtQVZBZGJjTkZB?=
 =?utf-8?B?c250VUM3bzJWeFVrTmdBb0JiR1BzRXN6M1RaYXJZT2ZwcitsSGNlb0R3T0xR?=
 =?utf-8?B?alV3M3VOdUN3UDBYZ09ZRTJCeTluNEhyNU5yYVg5ZVVFZ3VMM0NkaDQ1ZHJP?=
 =?utf-8?B?L2VEeGwrNzdTTXJhWi8yemd0dlJSK0YvSnVsOFlZUlNvK09lV2lTUWpnbjVI?=
 =?utf-8?B?a3Yrd3kwT2pneC9FanRUUjBES1A1Q0VIaWRrU0RKVS9IbmpPWDFOSXdoUlI3?=
 =?utf-8?B?TFVHTVBEb2dnMEdxZVNSUWxRUDZqVkljZUw0T2hUSjdwelVWVFZBbVk1VGx0?=
 =?utf-8?B?RU1rYmY5RjIxUEl5M0EzVjRaV3JxdTNJdldxZHJzSlRtZm4wdWxmcHlyNnlV?=
 =?utf-8?B?ZkI3WW9UTnBIWTduZmRSMFpxU1lFUitCZnFPN05nWjhUQ1dsTi8xWVEyUm80?=
 =?utf-8?B?QVY2RlBtNGJRd3E1SFp1cURjaS8wMFVJNncyeW1xeFJ6WTJKampXMnRWa3Z2?=
 =?utf-8?B?SDIrck9ZSzUxWktTWUkxWWcwR1BGWVh2bUlLRXFnWE9LenpJQlN4SDNleGNH?=
 =?utf-8?B?RmljS3pzNjVxU1FiWEdyT3FPa1hjZzZTVDYwODRQcmRFS2NWTTRJV0ttLy9B?=
 =?utf-8?B?MXYxUkk4VUxVdzFHU20zTWRISUR5djFQYjBqNkZIdERXNGJoTDJZMDVtbjZW?=
 =?utf-8?B?T1o4bWlKZ3U5QVlBWXFYbnhEVjloaVZQeXdiaWN6Zlgra0JQZVU2QTNwTjBr?=
 =?utf-8?B?RE9lTFgyblhaUXJyUGZjbnJsd2ZkaVQ0Y2pST2VWS2hEZTBRSFhWY1k2c0Jw?=
 =?utf-8?B?L214dmZMVUxjVmVKU0tmNzJ3WHRBSU9nZU9KN2JaUk1ZNTFTMTVBQXZXRi85?=
 =?utf-8?B?dFVjT0UzbVI5SForL0RGcHdEeEtlN21ISUEzMDlFam9aSm90VFpseVhpUmhY?=
 =?utf-8?Q?877vEZ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2dSNEpuNnJqVjBPeVBYdmNIMFNrV0thRmFBa2lLU2RxZXN2WXlabDFUMVd2?=
 =?utf-8?B?bFRNNDZ5RGRUS3AwYlBPK01abW5uMEFnVUNYSXoxZVd5c2p2R05MZk5xbkM3?=
 =?utf-8?B?bXhqbzhMcHlMSEhMN05kTm0wR3E3cFFqNk8wb3B0RlEzZm15STRpcUxYdXVY?=
 =?utf-8?B?dmxjUHVndjVQdlRubUJzRHZVbXlCWE1kOEUwbzcvNUwyeUw0R1hLQzRVYjM4?=
 =?utf-8?B?Nzd5dXErZ0RZVTlMcU9TSFJCUW9FcHlFZ0MrbHBrTXhmd0U0VG5nN3Juek9V?=
 =?utf-8?B?RmxzOXVlTFdTTmlrTzNsUE55YkxURnJYdkVCUlRvaXdIalJUWnl4eXBvVExE?=
 =?utf-8?B?cEkrQ1M3TnlnQVlGQnlGbG1SZHNGeHZXNnZ0UUs3TFIwamhpenRGcG5LcDl5?=
 =?utf-8?B?TnJoMXUrZVpVc1BKb0plUXdDWHoyeHp3ZjZKTGJUQ1NSelFLVHJEU0hXVXRZ?=
 =?utf-8?B?N2JLU0VVY2RuNGdqRVpoQ0ltZkFpMG9EV2lCZW53am9zdUtQOEdlYml4Zm4x?=
 =?utf-8?B?b1d5TkFJaXQ2WE1RZVRTR295NFBoUXFPZlhhRW1YYm9PVFoyQzc1TzJCa2dy?=
 =?utf-8?B?ZGlLVGpLWWs2eFBjMDlDelBoanYxaUdLOCtmVlhCOUVrSFQ3cU94ckczcTJJ?=
 =?utf-8?B?clN6cm94UFlKUEpKQjVkVHViTjl3RXh1bEtRSU83eWRRWXlld285dnRZVE5s?=
 =?utf-8?B?dGk5Q1NDVm1MenJRdkxRbm5pN2huV2ZCSXduY0xKSnBPNjJlZFV1bGgwTVFq?=
 =?utf-8?B?Y3NmL0pUMjc0ZThMalYxNG5wdmVwNWxUamowREZHNzFJcjJHdGhBNDI4Ymxw?=
 =?utf-8?B?UHdSWE80NkRUalRHampNYXI5ZTBTUkhHd0RYbjFZR21sUlNiTjBMQlR5VEVI?=
 =?utf-8?B?dlh2SUJyMDNKRUMrN0dFMU0zMjQ3Q0NJaFJRWVRLbzViSXV4bFo4UEIzUHBL?=
 =?utf-8?B?aWJiSXp4N0ZqRVI3MHZkUklabHl3dE0wdHRQQTQvVW5DNGdkcmR3dU0vR0RQ?=
 =?utf-8?B?TmFvSUFuaGZMUTd4emxzY1MvbzB0UWZnZW5ZbWNZUzBlUE1qeEl1KzEzT2dx?=
 =?utf-8?B?N1U1NW9HeGRZNHA2d2FTeG8xaWJOeEkrUXluT2UwUkFwTHdJMjlvRi8rMnBX?=
 =?utf-8?B?Sk5ZRFo0RldBWWJxVWVTWXViNmxQdklNL1llb0V6Y0VRUE90blpaVW1hVUt3?=
 =?utf-8?B?eEZkc1g2aFpsRHFYbTNqRmlTRk92WEVYalVPN2x5NmtrMFZueEp3UU1ZNjZL?=
 =?utf-8?B?YmFVcEMzTHRCaU9IZE5Ib2J3K2pibWtsWk9XeDFhT2RYc3FLVnlyanNXN1I5?=
 =?utf-8?B?eFRaQzVxNnIwWHozbGpwa2cydktwZ0JZTnJFOW94YUpaUDNjOGJRL3NiZ1dV?=
 =?utf-8?B?NWpLS1YxVWZhVXNwem4wNmlIYTdIQ2NpVUJDQkpna2szTjByMi9nMjNOL1pp?=
 =?utf-8?B?V0JobFZPbHpjN3dyTGt0RG1yV0RCL0ZRRVhEWi9JVzFidUwyZUU0MWIzOVlI?=
 =?utf-8?B?RkZRUEVWaWQ0SjFIRTE3bE1peXZTdHM5NkZLUWJYL0tnc2IwYlVLWWxLVno5?=
 =?utf-8?B?c2t5dVlUNDc4ZXhMd3dheW1hRTlVOCtwSEJKR09hNFlPYTVOMWM1RkVwRFo1?=
 =?utf-8?B?bG42NUNxMlpScVpnWWFMQy9oR1VtYTNPU3MyQ0hlcnJ4R1pkUDAxaWsxaFBz?=
 =?utf-8?B?UGUzc2tBNXRSVVNoajVFa2FGMXA5MzE0WHJUTlFqSGF3NzZ5eE5VV0daT3VB?=
 =?utf-8?B?T25zL2xRL3Y3NFh0UjhrRVlzV1plSTlGRzA0aEZLZmk1bm92NE9QNjRXa1FR?=
 =?utf-8?B?OTlCQmk3MlRucTgvVXRHR00zdHJ1UEdwZnJHUEhUanQ2ZGU2cnlnLzNRUWM0?=
 =?utf-8?B?OVBrRnhwWUorVUYxTnVidlNXUkJHdDltNTJZekJ1Y20zeHhVRzk5ci9KNHBr?=
 =?utf-8?B?TWo2ZmhqWkRoWFZwNU1aSEJzdHZWaktTREg5V3N5Qk9UcHF1a0drUUkwSlJV?=
 =?utf-8?B?RjVWQWJsSXh5ZDB1TitoOTI0TzZjYmI5QTUvaXF2RjdXVU15YWZnd0JEL0Yw?=
 =?utf-8?B?Q0FDaXNWWkdndFowUnJnZFNsYmNXZFdzaUpsUWwzbzdDTHN0eDVFZjgvQ002?=
 =?utf-8?B?dlVuMnBCY1dIdkl3NHJJZXlrSnllTGE0ODlzVUViZm9FUHFJcGFNU3hkM2Yz?=
 =?utf-8?B?dlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72B3EBD36716EF408F4750B1FB6D80E3@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e8b909-b8ad-4a19-73f1-08de0d570cc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 08:27:46.0487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bjrKVWS2cbyFTRxyG0/tIAaSxA+ZydisXR+K9SyoqMVo7OO2ABh0wUvj5kFTFeRSjYzdsQMW8M1KqvQNIZshHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6847

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDEzOjAwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IHVmc19zeXNmc19hZGRfbm9kZXMoKSBpcyBjYWxsZWQgY29uY3VycmVudGx5IHdpdGgNCj4g
dWZzX2dldF9kZXZpY2VfZGVzYygpLg0KPiBUaGlzIG1heSBjYXVzZSB0aGUgZm9sbG93aW5nIGNv
ZGUgdG8gYmUgY2FsbGVkIGJlZm9yZQ0KPiB1ZnNfc3lzZnNfYWRkX25vZGVzKCk6DQo+IA0KPiDC
oMKgwqDCoMKgwqDCoCBzeXNmc191cGRhdGVfZ3JvdXAoJmhiYS0+ZGV2LT5rb2JqLCAmdWZzX3N5
c2ZzX2hpZF9ncm91cCk7DQo+IA0KPiBJZiB0aGlzIGhhcHBlbnMsIHVmc19zeXNmc19hZGRfbm9k
ZXMoKSB0cmlnZ2VycyBhIGtlcm5lbCB3YXJuaW5nIGFuZA0KPiBmYWlscy4gRml4IHRoaXMgYnkg
Y2FsbGluZyB1ZnNfc3lzZnNfYWRkX25vZGVzKCkgYmVmb3JlIFNDU0kgTFVOcyBhcmUNCj4gc2Nh
bm5lZCBzaW5jZSB0aGUgc3lzZnNfdXBkYXRlX2dyb3VwKCkgY2FsbCBoYXBwZW5zIGZyb20gdGhl
IGNvbnRleHQNCj4gb2YNCj4gdGhyZWFkIHRoYXQgZXhlY3V0ZXMgdWZzaGNkX2FzeW5jX3NjYW4o
KS4gVGhpcyBwYXRjaCBmaXhlcyB0aGUNCj4gZm9sbG93aW5nDQoNCkhpIEJhcnQsDQoNCkhvdyBk
b2VzIHRoZSBzeXNmc191cGRhdGVfZ3JvdXAoKSBjYWxsIGhhcHBlbiBmcm9tIHRoZSBjb250ZXh0
DQpvZiB0aGUgdGhyZWFkIHRoYXQgZXhlY3V0ZXMgdWZzaGNkX2FzeW5jX3NjYW4oKT8gDQpEbyB5
b3UgaGF2ZSBhIGJhY2t0cmFjZT8NCg0KVGhhbmtzDQpQZXRlcg0KDQo=
