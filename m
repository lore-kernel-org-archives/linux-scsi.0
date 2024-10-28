Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925383A1DB
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2024 20:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730145872; cv=fail; b=UA2i/+gYRy+EDB+qPxw5VDN1cuhrJe4K1mppHlBO+EKMtmsS4SMPP/+euGjaaB+tMTfAMRe3wrYU+V53nEhLTdyW2/xVilnbFQSuKvX8MPANAVFEQ2qvjVm/QVb6ePA6mSUqc5W4ZwIwnWCTvb2+TPVhWGNX7d2rD+H997mUv68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730145872; c=relaxed/simple;
	bh=Hi/AbekajV/4t161fiRVywocV6l6m+sWv8iYfLBQpqA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q5uv34tHZ1dZaAP5vGx0+9BPMChWXq8RLqLwuKeG4Z9LSDoVlHbjxo2bKIVvwa8B9DCrOOkqrQQqUOTXzUQaeobuUiwf2z7Ho35CGmmXj5CG7wJeqCgT6H+jwJG+SZsyJ7DUwPKPPCrW0UvDg8K3QMr1bghk40fpwVRBVwoQUK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com; spf=pass smtp.mailfrom=micron.com; dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b=VXdpCHLh; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=micron.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b="VXdpCHLh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=snoFLPu87gJCX5x0fvcbM6U0inr/MK3coUrv0A4wNepXBowRHeqBZfCO0IdHt23HprzxMYHDtp0o4sv0ED1I27pbu5NugLcj7lYmD0jfqXqpo7s6CkwMH3V0+0xuCZI8IxIMEnEqFY984U6Bi6R7uING7F73wXzUpPTpPHBdR14uvRYzorXKQbSsKNk3hcXaInuWCeIbXAVPOxrndeCm0SZH9/uhEu5xWa5tUXQ55CqaNsT7pZU++cGlyGs6lNnO/dzKvWf66/zd8XFyOSomCpMpq/Jmi26fzLP/GJYnvsewGxKdO5HdTEfCBxRrLjqcVQKOal/O+726LlBEMv0eRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hi/AbekajV/4t161fiRVywocV6l6m+sWv8iYfLBQpqA=;
 b=llNgFeNUzEgSxXeB6fFF3o6oI3fX31XRlgRlpVcfEuo93+Wl9B9kuv1T5mWZmN2t7Eo8DJTqNKtfxqy6HDo4iRuEiFvrqSWJd6Um8hqtRaleLz0yRmyQngJaQUkc6LlNlxiDabfHbCARir4Ehhh3LiBEgMgtzQ7D2eevZ9fMvXp8MueToUIWr1Vn5sY4vldx44yCWMs5uKzJ0j9bJgex84JIU1UluH+IDwfxAhnEHCQNtE8lw+V83qyF21Vs00ZAn5faOE/QU4gT7a5JqyCwCIEL9X1A0QtwBceuC913qv1zjQ7CNmP+VccBCtVjTHpS7ltNzmUEYW6ikEs1RpI+hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hi/AbekajV/4t161fiRVywocV6l6m+sWv8iYfLBQpqA=;
 b=VXdpCHLhyrfIt0jloQoNI3Fhtrb9ipaQIvIE+Tn6Xf9W//Y+Z2shZEhMivL3TFh7iu57XXNeAc9jLNzv0z95z7nXEpbxWjO3/Ra9VZlHIVndpXkWJEy8SU0XJdedpoQfE4A2zYtbeTMGJBQuQt7c7xPH9QkVt+vsB1zStR9Sg3KL8NkzZwV+HEzGXqdfKYRQEBi9urm6fzsXAXnJj6GG/ME9azai94EcmyLZYdH+FSvlx+pmoZfeLa6lT2uWWX9kRIVcWirsN3b1BkySH/bNHTbO5E7V0hDyrVJkfyO+xPZ9fPyko5A8bMvhvLHUrOXpPWEaWa3NpdhNEu4rhvMV/A==
Received: from SA6PR08MB10163.namprd08.prod.outlook.com
 (2603:10b6:806:40a::22) by CH0PR08MB6955.namprd08.prod.outlook.com
 (2603:10b6:610:da::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Mon, 28 Oct
 2024 20:04:22 +0000
Received: from SA6PR08MB10163.namprd08.prod.outlook.com
 ([fe80::74f0:61ed:1b4f:6a36]) by SA6PR08MB10163.namprd08.prod.outlook.com
 ([fe80::74f0:61ed:1b4f:6a36%5]) with mapi id 15.20.8093.023; Mon, 28 Oct 2024
 20:04:21 +0000
From: Bean Huo <beanhuo@micron.com>
To: Bart Van Assche <bvanassche@acm.org>, Bean Huo <huobean@gmail.com>, Huan
 Tang <tanghuan@vivo.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: "opensource.kernel@vivo.com" <opensource.kernel@vivo.com>
Subject: RE: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
Thread-Topic: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
Thread-Index: AQHbJ97yrEYEmW+CFkOY1GKmd8K2QLKcgTKAgAAWhhA=
Date: Mon, 28 Oct 2024 20:04:21 +0000
Message-ID:
 <SA6PR08MB101635BB17A5B1B2B13363344DB4A2@SA6PR08MB10163.namprd08.prod.outlook.com>
References: <20241026004423.135-1-tanghuan@vivo.com>
 <e992d83526fe722af8cef1b9ca737c8d0646417a.camel@gmail.com>
 <04e443d0-2968-4d63-b05e-ddb7b2aa5680@acm.org>
In-Reply-To: <04e443d0-2968-4d63-b05e-ddb7b2aa5680@acm.org>
Accept-Language: en-US, en-150
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ActionId=199d1b84-d2a1-477b-9bbb-5dbfa40ec1cd;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ContentBits=0;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Enabled=true;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Method=Privileged;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Name=Public;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SetDate=2024-10-28T19:58:40Z;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SiteId=f38a5ecd-2813-4862-b11b-ac1d563c806f;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=micron.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR08MB10163:EE_|CH0PR08MB6955:EE_
x-ms-office365-filtering-correlation-id: f2735d0c-67da-4c7f-2192-08dcf78bb667
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UTh6TXFuYTV3bjJMRDhsUGl4OVdTOTdjbXh4QjhvVVhaTmtnZjVLNG95ZzVr?=
 =?utf-8?B?L0xNM0RaNktZd1l3bU9MV3JDdnNtOVVoWjRROUJVS1RnVFRtZXJIaVRDaDkx?=
 =?utf-8?B?QU54YWtKRWlmQXg1akY1WFlnUHBKdVBGU2FMZHF0ejJwV1hBa0JOUGNFUTB2?=
 =?utf-8?B?aFovb01HN0pOdVJ5WDRiTGNudUNNUmZhWmhic05CdndXRWhSNnFldDI4M1RI?=
 =?utf-8?B?RUd0RmRJcXJYQTUzRjN0cFlWV3krQzFEUlpTN3FXRmxmamdZaTRkeDRjNkNu?=
 =?utf-8?B?VzVoTHJWWW9CNy9jT2pXbTRGSEZyNFhqSlYwak8vSnBvcWhvbloxV0g1Y2lS?=
 =?utf-8?B?ZElMZThGUEtIQmUybWZzNzBuZ2J6YjdnZVFnSHZGdXYxeENIL1NvWTVYVjFD?=
 =?utf-8?B?ZFFhYlIwblU5WXcvcW42QzJqY0Q4VCsvY1l4L254aWFodUFGcmpRRGJoeVkr?=
 =?utf-8?B?UFYrZ2xKY0FRdTdDZ1MyUUV2WmEyeEtWaWRIVjNGV2ovNnYzdC9yek9uK2NF?=
 =?utf-8?B?MnJnSExpTHhaQmpIVW8wQlBzYkhOZ2Npb0xIZ0crcnN3N25uZFZldTNsZnFO?=
 =?utf-8?B?WnFpS1lWY25jUGFZYlBZVlp1ME9DNmh1ZW1qdUlnQmIzZDFXUWxGcnpkNnlS?=
 =?utf-8?B?QTlOVzN2Z1g5dlNaWmdYbE1yc1d1eWRyU2wyekx1UHlIbmhVTFhQcWdTRU83?=
 =?utf-8?B?QTZvZFVWdVFLcHQzdWxLOW5nZ08rc3M4MjIyOHNWZ2lZMWFUK0UzVGhwbnVL?=
 =?utf-8?B?MDZrZTMzUE9MQlNqdUF6SSs3Z2FER3dOWCtsaHhkSzQzbjFtTW52Qk5scmRT?=
 =?utf-8?B?b1YraUVELzJPS3dSejlmM011ZFlhSzdIWVoxU2x3cXRDRlY5QW5USURwWHRr?=
 =?utf-8?B?Nk4vb3pIcFk1UHd4RDh3QldyNXFFTGl2QzRQUVJsWWlIUTcrU3JLNUkzZWVR?=
 =?utf-8?B?cWdWWUZxKzhzTDhUd0FxM0RvUy9pSkxPTitsU3FjNmJ0bUU2OW52Uzg4NVZm?=
 =?utf-8?B?VjRwZHU2VCsrL09CL2lVRjkvREVkQlJLY0JsOHJnUFRSMHQ4bmtCWXNvUElw?=
 =?utf-8?B?Qm1YaDgrdXdKNm1YVi96VzJlNVBhUHpCTkZ3eW1ORGRRKytHdEtUc2hsNnpt?=
 =?utf-8?B?aVN1aS9vVG5IQUcxblVMN280VlRnZUI4ajIvckdWVlZYNXpOZzhzc1duZmY4?=
 =?utf-8?B?bUNtN0RyOXNXMkNJQkQ1UUYxaER3bWZDYUgzVFZXVC9tV2pOODJ6L01nKzhz?=
 =?utf-8?B?SGNaS3VxbWdRM1pXaEhuek9reXNnT1dFNDVnVWdyMmxWZ2RWc3k4OEhscStM?=
 =?utf-8?B?NW94cG80dEhkeGgrN0IyUFEwT1cvWmVOYkd4UzNFdXFhOGdzYVpCL2dNN3RS?=
 =?utf-8?B?YXpuZjF1enNRMlJBbWJRN3kvbHBJMVE2b2kwdFN3ZTNEd1pUTGNuVWVkN0I2?=
 =?utf-8?B?T1lCYk05eDV0YUtRVGFZU1czVGlYSkFWQ3hDVFBvajZCWFNtRk40d21INExH?=
 =?utf-8?B?MTk1bkNBVThOVEpqR0htTmdJa1R4V2diUGpoaEgxL2J2WXU3NkIxR1U4ZllX?=
 =?utf-8?B?STFqYVVld1QxMWFxRDJtU0JmYit1WGR2QjlHbkM4Y3ZOQlZJVnBoM3ZSeHN4?=
 =?utf-8?B?K0dZSHgvci82dnNyRC9NTUI1M05VSWVqYkhMSWlrMmpDYzg0NWdUdzhtdm5r?=
 =?utf-8?B?U3BrY1pEVFZqNzR3dXZSNjFKTE5HUHZmaG41NmFUQ2lQdWZ5ek5ZYW0wUmxs?=
 =?utf-8?B?YmZ6WEp6aEpmdjRla0FhTloycTNhOWhDRUx1SUIxc0l0L29zVllzc2FJbWp2?=
 =?utf-8?Q?o5rdfoJGdX7f3PZHNs1++btm9KIuJPe+sHyAw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR08MB10163.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WXBzMC9pQ0tYYTBGWkk0UUN4cHUwS3NPWjNOS1VuRHZ6eEs3VXhYdjNRTmtB?=
 =?utf-8?B?anJ6NDQzWE83eTNMQmdwTnBsZUQ2aWxxMURlaDMzNlE2VnVjcC9DdVV3alNK?=
 =?utf-8?B?aGNZbmZkY2lwYmJBMWJTTjRVcEtWNzAveXo4MHVrdXB2c2IvUzAzL1Axekl5?=
 =?utf-8?B?WnRyT21RaGV5c2NiY2FQbUdWUHRON2ZSaVI2M1ZkdkRTNkM5L1hlUFArdEV2?=
 =?utf-8?B?REEzcHRacDl1VnN4ZXRWenJGam5qNjdWSi9UVFlvQTlaYW1BNTQ3aE01RGVa?=
 =?utf-8?B?dVZ3WHdoYVBaeDg3aVNSeG1DUG1DWjVuMmhJZENXYWNVOU9xSTA3bkdCbmU2?=
 =?utf-8?B?UGZqQUp4MDhSb25qcWtLdXdYVEtzbW5MVlhFbUErV1FDclVwbmV4QWpZMmNa?=
 =?utf-8?B?UUVjdXJWb3NPVFdEREdQeTZDS3FxNGJuSlo4WlFST1BGZk9DVmN2dkIway85?=
 =?utf-8?B?Qk5wSnJ2bjZXTUNXaDk0dWFrQ0F4OTBRK0dNWG9RVHYwdkhxN2U2V3lrNHFx?=
 =?utf-8?B?M2V3bjZ0SFkrV1VCdmIvcEhib3lBeThOUC81UjlsZGlqYjVzZ29iR2NYbWNC?=
 =?utf-8?B?ekpLSWlZelNvODRpK2ZXekhRUGxEcjhnMlJUUXN0Mmk4d3dWb3M5MXM3VGlS?=
 =?utf-8?B?a2QyOUgyT1hYZTJiei9pNkQ0TDhtZ3pZZk14clNSYzIzb0U0OGVURGxOdkZD?=
 =?utf-8?B?dm5PazFJSTRZR2V2SGFLYkdZNFFCcTA3cXdDalVNZkovV0hheFZtb3oyZGkz?=
 =?utf-8?B?M0puNTRPYUZ2ZEQybVhNRm1lazN0em51d0VQMXlwV2pQREZpb21RVVZsMmIv?=
 =?utf-8?B?bk0ramduZUdNbDVWRUhmSjV6SkJXaW5NcnhsMCtjNmlaZlJaOExDbFF3b1c0?=
 =?utf-8?B?OHROZjU1NWMyZzJnOFR3Zzd2dkRUYXpiM2RRNG1vTTB1NUpNenRxYmJuS3k3?=
 =?utf-8?B?MnM1ZGlobk43djJ3QldpeUZnQUttWW9GMTJmYm44V2orUDhvZkJJbUw3bnVY?=
 =?utf-8?B?ajlGdFZ5Ukt0TWhuc2hlcEwra2xQV1JQWnphMnZ6M01LY21OSC9iTVg5aWMr?=
 =?utf-8?B?V0k3SnJNYkl2WHRFREc0czh1RkplMWx1a1pNWjNVMnZiWk1TOHRVRnNsaXI1?=
 =?utf-8?B?TDlLYWw0eUZ2VWxaOUc0b3dsYVhPT2hKc0xIN01TQ2l3RWZCdVluK3VjVmVx?=
 =?utf-8?B?dVhWeEZwTDllbXdhQUczQmV6cWVMalE2RktXK0JBWnozcEV1L0N3NjA0TEJW?=
 =?utf-8?B?dzEvd0xnemlieFcvbjZpMWNCcm5xMnJRZDE4Sk0vbWdpNTJrK3Raa252MC9R?=
 =?utf-8?B?bWF4NWNpSHR3Uml2NHN1cHlPcGdMTi8rbGlma2xtbXI5ZVlQMWZ2SlFXd3Uw?=
 =?utf-8?B?Z3VsUGhrdUllV2k4ZDhJZFNjenJISHpLWThOcXlQUzdIVitHdURvdFNwcWVS?=
 =?utf-8?B?VlY4aDZVdFFEcnNXelc4aUsyRGJVTDBTTDE1TkJ4MS9KV212dHFUbmxSeUt0?=
 =?utf-8?B?V2dDTXdRMHZQN0VqMFpidkYyWnhsQ0Y4VmNqUkFpMHlRbDV1dC96R3FEWmt2?=
 =?utf-8?B?QVZGTDhDMEN4MzA1VWg0RzY3Wmluc1A4UURRbS9GVjdxRlE2N3hwUUNlemhh?=
 =?utf-8?B?dnJCNUFFRE1wMmt0SzdjZm5ndklLVXNIUkdSOHVKSUtNQ1ZIbzVNRlkwQ052?=
 =?utf-8?B?NUZ0NVAyYzgrNjBpR1Z5aGFTaE5DMVpoeU1jMWdMV3ZJMTN6UGFoQUtBYTU3?=
 =?utf-8?B?Y21zNlpHODZoZk0xUTV0OC9aSWNMakZZOTFyR0hpTkw2SUcxVTR6dGNjTXFF?=
 =?utf-8?B?bDllME5tM2xETlI3b2g1bkdqL0VrbTkwVHY5SmZuRExqbnhSeUdyaGVpRmJp?=
 =?utf-8?B?Q1ZXNnhoR0F1TlFJUzFrVCtvM3Rna3RtaStSSUxjSXo3eGYrdmJkWU1udUhK?=
 =?utf-8?B?d3RITlE5cVI4VjR6Vm1nMFhVWmZhWU1SL0ExVnhJQllqT0Z1YVo3YzlMOWhq?=
 =?utf-8?B?L0Jmc1ArQktoalQzcDQvMUUxejdEZnVpT2s4WkorYkVHeXo4U1pLUjEwWUNa?=
 =?utf-8?B?blZSSjZ3L2hXZmt1MEN1d3ByUUljbXlsMXBRZm5LVnhLbDRYc2xybHB2eTdz?=
 =?utf-8?Q?T7PfYxmwF8Qnt+XNC4iFYAPgG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA6PR08MB10163.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2735d0c-67da-4c7f-2192-08dcf78bb667
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2024 20:04:21.2251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mh305GuRXBwGgcvA/Q/5djTcpq9Q0t2ZTOuoErB3sLT8jzJ/ZYuc31/XRxz0G6ve5ngsHDbBVvWPVrylbnGFtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR08MB6955

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgPGJ2
YW5hc3NjaGVAYWNtLm9yZz4NCj4gU2VudDogTW9udGFnLCAyOC4gT2t0b2JlciAyMDI0IDE5OjM4
DQo+IFRvOiBCZWFuIEh1byA8aHVvYmVhbkBnbWFpbC5jb20+OyBIdWFuIFRhbmcgPHRhbmdodWFu
QHZpdm8uY29tPjsNCj4gbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IG9wZW5zb3Vy
Y2Uua2VybmVsQHZpdm8uY29tDQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0ggdjJdIHVmczog
Y29yZTogQWRkIFdCIGJ1ZmZlciByZXNpemUgc3VwcG9ydA0KPiANCj4gQ0FVVElPTjogRVhURVJO
QUwgRU1BSUwuIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcw0K
PiB5b3UgcmVjb2duaXplIHRoZSBzZW5kZXIgYW5kIHdlcmUgZXhwZWN0aW5nIHRoaXMgbWVzc2Fn
ZS4NCj4gDQo+IA0KPiBPbiAxMC8yNi8yNCAxMjo0MCBQTSwgQmVhbiBIdW8gd3JvdGU6DQo+ID4g
SSBzYXcgdGhhdCAiQm90aCBVRlMgNC4xIGFuZCBVRlMgNS4wIGFyZSBjdXJyZW50bHkgaW4gZGV2
ZWxvcG1lbnQiDQo+ID4gaGF2ZSBub3QgYmVlbiBvZmZpY2lhbGx5IHB1Ymxpc2hlZCB5ZXQuIEFy
ZSB5b3Uga2VlbiB0byBpbmNvcnBvcmF0ZQ0KPiA+IGZlYXR1cmVzIGJhc2VkIG9uIGFuIHVucHVi
bGlzaGVkIHN0YW5kYXJkPw0KPiANCj4gSGkgQmVhbiwNCj4gDQo+IFVGUyBXRyBtZW1iZXJzIGFw
cHJvdmVkIHRoZSBXQiBidWZmZXIgcmVzaXplIGZ1bmN0aW9uYWxpdHkgdGhyb3VnaCB0aGUNCj4g
SkVERUMgdm90aW5nIHByb2Nlc3MgYWJvdXQgb25lIHllYXIgYWdvLiBJc24ndCB0aGF0IHN1ZmZp
Y2llbnQgdG8gaW1wbGVtZW50DQo+IHRoaXMgZnVuY3Rpb25hbGl0eSBpbiB0aGUga2VybmVsPyBT
ZWUgYWxzbyB0aGUgSkMtNjQuMSBEZWNlbWJlciA3LCAyMDIzDQo+IG1lZXRpbmcgbWludXRlcy4N
Cj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo+IA0KDQpCYXJ0LA0KDQpUaGF0J3Mgbm90IGEg
cmVhc29uIHdlIG11c3QgaW1wbGVtZW50IGl0LiBOb3QgZXZlcnl0aGluZyB0aGF0IGV4aXN0cyBp
cyByZWFzb25hYmxlLCBlc3BlY2lhbGx5IHRob3NlIHRoaW5ncyBkZXNpZ25lZCBieSBodW1hbnMu
IA0KDQpNeSBxdWVzdGlvbiBpcywgVUZTIDQuMSBoYXMgbm90IGJlZW4gb2ZmaWNpYWxseSBwdWJs
aXNoZWQuIEhvd2V2ZXIsIEkgbm90aWNlZCB0aGF0IHlvdSBoYXZlIHN0cm9uZ2x5IHN1cHBvcnRl
ZCB0aGlzIHdvcmsuIEV2ZW4gdGhvdWdoIEkgZG9uJ3QgdGhpbmsgaXQncyBuZWNlc3NhcnkgdG8g
ZW5hYmxlIGEgU3lzZnMgbm9kZSBlbnRyeSBmb3IgdGhpcyBjb25maWd1cmF0aW9uLg0KDQoNCktp
bmQgcmVnYXJkcywNCkJlYW4NCg==
