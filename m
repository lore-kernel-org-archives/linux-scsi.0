Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3723E5577
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 10:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395100; cv=fail; b=abudyq9KDxJtrhiZltp63CfpVKXLW9iqJ4iZIw/wrdvH1KtZxbbyUzL0HnUDb2eTpQGpHNLLyqVze22jOsdMnyG81/mSyKkD0xcpo0wno8hlzEYZhpTgU68SRq1XhFV2qT3xmjEd8CBYJv000ieRXjwzgolUV+kZmR1zT6jospw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395100; c=relaxed/simple;
	bh=QxoZMAXEj9ydbhb2BAPZcWYsfLFtFnpBZjv6MYpOkPQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LEm+jmmq2HHpF7ge5CmFiFii3u/lbEb4Rwj2bGF+or6R4Q8hAGzfv1/xZGslcu064lqfK5zR1ftRlsVMaCmHX3MwMIRYID44PIQHyJ++QOMvBhBlVs95DfA1uFrWoo1eqUXqSd3NCZKmKkcO/TLXjeWZnAqxh/GhRcaDR6+rXd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=E9vA6P66; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="E9vA6P66"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6526iSNk878414;
	Tue, 2 Jun 2026 03:11:30 -0700
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023141.outbound.protection.outlook.com [40.93.201.141])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ega3b81jr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 03:11:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OAVL49AmAuZqJAKWIORlOtcQ2DKBJ3ZQa81xYZOJGLKgbe/Fa6hF/6+SgOcmoYdYnw7e7Ub6GQv35ybeMcwTUAlCEuzoDhypCwOAbVMiV98czO57krcPCe/CYf+LlOY3WAezxpuI7qw9HKNuk95xBE63Exrj9AI6Z7wo0j08HndFFruSL5gkTyKbLAoqzlxYY/F3n9pb2dJ/o1HrySpqpTYWnP7jqNIGLGqxFsXTiuL8VTg3rYv9xVX6kTnxlYyqAyackv5zsGDifoLz0ObqToxFKrf9AhVQMLUxq47PDpnMI1D/I/zGaVR7ggr9uRqz+4ril95W1Bc5UUWPyC3ZbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QxoZMAXEj9ydbhb2BAPZcWYsfLFtFnpBZjv6MYpOkPQ=;
 b=Kl57mSS46iAOR890v/oS+WS3JKl3WET1/Q0PChimvFVI833C9M5BdCcsVtSxK6PI9brI3O5J+39tonMCwHxNjZmvHNoxf3/kyoJkXqDKBrvBviP36UHS8z4hXc3GXtdeLNYL8bUqFD0BUA+FV7FRKgoRWrkregukhFlYz1+HBt/jiSfO9JbnHmUay1N9JWomsT+WiZE53JKdiymf2/zDxNwHpzKMlvjZ8mGl9QOeWDGvTQDUbIH0mGDuMzkP3EJfl4mOF3fiBRKHq+49o7XBjEnB8f8GwXM5BtJiRV65+G5viq7ufGZZPMAfCn78b2jmCUAlw6vd+7ZKzQx76qb00A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QxoZMAXEj9ydbhb2BAPZcWYsfLFtFnpBZjv6MYpOkPQ=;
 b=E9vA6P66gqJvBdtRHy8VtfEoEj3sldwmTtBflcVinXCsbx0AKp78I2AiDTd2SQxCyPXHeKjXsF0G428CNtNgbUeCuWbK29xL83U2sjBl8eZ/nNFLUJR1rLD2RPvKEUs05CqI1w/AIP0a2aiX0CMt6Ai9xOGdEebr3wYmhBguyoU=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by PH3PPFBC9D4BC2A.namprd18.prod.outlook.com (2603:10b6:518:1::cc5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 10:11:27 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522%5]) with mapi id 15.21.0071.015; Tue, 2 Jun 2026
 10:11:27 +0000
From: Nilesh Javali <njavali@marvell.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
	<martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
CC: SCSI-ML <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream
	<GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy
	<agurumurthy@marvell.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        "hare@suse.com" <hare@suse.com>,
        Sameer Kshatriya <skshatriya@marvell.com>
Subject: RE: [EXTERNAL] Re: [PATCH 06/44] scsi: qla2xxx: Add FC operational
 firmware load for 29xx
Thread-Topic: [EXTERNAL] Re: [PATCH 06/44] scsi: qla2xxx: Add FC operational
 firmware load for 29xx
Thread-Index: AQHc8bGRP0uSP55VhUWr7CYn23XT0LYqHscAgADi/4A=
Date: Tue, 2 Jun 2026 10:11:27 +0000
Message-ID:
 <CO6PR18MB45003BEE884DBDCA16C90D26AF122@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20260601102853.328426-1-njavali@marvell.com>
 <20260601102853.328426-7-njavali@marvell.com>
 <191cd7dc-f6e7-46c1-8a0c-9e63482f34a0@gmail.com>
In-Reply-To: <191cd7dc-f6e7-46c1-8a0c-9e63482f34a0@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|PH3PPFBC9D4BC2A:EE_
x-ms-office365-filtering-correlation-id: c8ca1416-fa01-459f-eb4b-08dec08f4f15
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|38070700021|4133799003|3023799007|6133799003|11063799006|56012099006|4143699003;
x-microsoft-antispam-message-info:
 UMWh1Rdp4VL/MO25HSTdGI7mVBBNkSuvXwoQPKNh7HguZtVuOJX+e0WuXS0sGEcGQSxbwTPDKW128pWYMtzjSnzkKDYQlSTPreEXvdAT7wUBem954dkk1gaHyv9oVFDjgwC4mIEkxKJGFUOpFz/G1pmz+t7QcOhcVKV9mNJxqRMzkQqan4Z/WUFxeaO1WovDlAmaqOaQVCn3W/0bZ6CphPu/uRkA3DmJX/7iwiUq9/0GGz0jMhar6dJ3s82XbBfVjKMZgURn3jZyhh0E1VNfWGmBj7rED3YN8/T10FtNLikObuqDb7yVj9xEoL9WMAX/B6Cchin0ltKl1teiRoqbnsjgPdmxFqwOq/rugVu2oGlTSDpLI95oMzCgO2QVTZLUJQtD6OrN04Uy2+nQ2Fd/W4UyeG+u5ajqRSQGmwwzPZNYSI7KJf3gnQNivjW+Hms4O8ELNhWZqQF26658pOKZvoR6YMBD290JZDnJYqzXyr2bTP0ixAG9oG2mg+fAqOx6ZA1vnWh+o3tJ7H6bEyz6QZvwiiHaz9FYyOuuAEQk7MJx/YZ5j16gztB47p/KooT50OimOccVN8dEmfgoxAA5ZIEcSBGTdXr0uXADDV3ZIADbI0izzybQ9ynLckTKHpLpAEBRIHP8YYMQoXfi4lK942rX8xNaNOfrb6Qd22M4dXBDTpeZBynYLyQiyoTczv+5Oi33NY2twVlChtu+sJPf86RYjpQPq6Wk87uKpXdD2VTUx3FILTOfhbVA39z9nwg7
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(38070700021)(4133799003)(3023799007)(6133799003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WkhGcHpJYVZwbTFRN2Qvd204RDRDR3BMNzF6N2lBL1I2dStlVFcycXpBSUtX?=
 =?utf-8?B?d2NQb3B5d2wvWjZIM0JWWU1BRTVVUmozRVo4L01kTmZzWjBzOXpVa1IzdFl2?=
 =?utf-8?B?Q1czSTRtQTNGWVlNZjJKNFBHdjl6WVgyK2ZwVkJiQlc5WlZtUEM2QXVZb2Jk?=
 =?utf-8?B?NFZPSHQrbU54Z0dUTWQ4TnJSVXNia09DRzgxMXROY0w4OTBXb2NKNVNHNnZ0?=
 =?utf-8?B?ZlVqZjRzdzJVeFkveXhRZjNtbkUxQ1JXUGEvb1AyaC9YWE1Qa1VUeW8wbVlK?=
 =?utf-8?B?WkxCMXI4ZW9UaFhaei9qZHYwTkJmZU5UUGRMbHJ3RW9SbTU5NjhucXUvWFZ3?=
 =?utf-8?B?THp6YjY0K2h6cGgwM2hSbDFSY2FBai9WcVJydlQxZVlxTHh4d3V3bk1hSTV1?=
 =?utf-8?B?TytPWjI1OHV3Qk85Sk10WGd5V1NOQm1JOCs1N3pNSmFVZmNBT0ZDZU54QWly?=
 =?utf-8?B?OVUybkpuNFNxNzNLdzVrQUNrMXZDYk91V2Q4VUUxNkxOSXhQR2lKeVVIc2dl?=
 =?utf-8?B?akJ5M0p5MmR6RnVCbitKT2JxRGRnMmdyVUUxLzQrOVYzcVVWQVJiS2JRQVov?=
 =?utf-8?B?MVVlT2VNWGtybUEva3JaNElOMVljL1dBZURyMzJXdVIwem9YdDA0N3NQRFdM?=
 =?utf-8?B?WU8reHZxSmxlWkZWR1dFcEwwYWlKZFBDbTlrVFI2YVMvemw2M2lTSVVlc29x?=
 =?utf-8?B?bWhxYStOOGwvOXd1MHdZN3BVc0ZSdEIyb1RvOWd3R21SaTZUOXdrVFdIcEJY?=
 =?utf-8?B?ZmR0ZVZsMFFuTlFVMWd5NjFidHZQUmh6VzZoMFhZWHRkTzZKZUtnVWxHN0Zu?=
 =?utf-8?B?UmptbVhTYzBFRVpJU0pWZHFpRHNURGJ6M1ROanhqTEdpNVQyQmRzOVV5KzRQ?=
 =?utf-8?B?VFhPSjRoMllmUUs4OHh6eHJJazRWaThqR2crUm5kUUhIOENUYitDVnhBTGor?=
 =?utf-8?B?bGk2cVFhdzFrc054QS8yZFo5b3VXSVBoZnV0OWtUMTdsdkczM3BWbkdPV1di?=
 =?utf-8?B?OHJteGtxQjZoNEYxQUtuN3ZpNjJrU1JKK0s2bDR3Mm1rKy9jaWMzNEdCRjdJ?=
 =?utf-8?B?NlRGWC9rKzJXeHQzcnJHOGZxcTdaRnVZT2RRMDVoVDNXbENmRXpkN1h5N1BG?=
 =?utf-8?B?VTBydEd2YnEvZW00VHZZNmE2RG9IOFFFK1pzaGkyWVgrVFhldWFQemQvMyt3?=
 =?utf-8?B?NVdGWE5xaDFPOTNtSTAyNjlJb0NEdXUzNXUrekQ4enBLV2tOaXB0WnY0aE5I?=
 =?utf-8?B?bzgzSkJLeENNQzlaWVRtN2E2c1hjMzF2S2FFaVVwZmhDeGh6YjdjbnFUV1o1?=
 =?utf-8?B?Z3doeUt1Wk9XWlFhSi8rTms1QzNaSTJRTnMvcXlDUmJXWU1laDRXWHI4cEZq?=
 =?utf-8?B?NkFtSkRaUk9jL2ltOVlyUE82czNYVzl4WW9QWEl6a2FSWHkwVWpuYVpVNDdi?=
 =?utf-8?B?SExCaG9WclhEY09KTkt4WmJxMm1BZ0dlUGYvUDM2YnlsQUpKVlcwSGs0TVk0?=
 =?utf-8?B?REhQNVF2OFB1VUg2WWJsVmdENmlOMmcrYkhUeE5OY1dDOFVJazE2b2p0Q2NJ?=
 =?utf-8?B?cXhCTmhyZmZudURLZ1BRK1YrampNZHU5Y0I3NXJZb3NMRVpXTGpWbDI0Y0k2?=
 =?utf-8?B?VUF1Z0hnYUY1YUxjT3lmSnRhZW9PNllOZVUvNFN0UkhGanRkTTR4ZmNBWThS?=
 =?utf-8?B?SzlOTjlTL3l6S2d4NlVweTBxcWZRdVlhVU1BNG9QWC9CN2dUcWJPYmEza0pJ?=
 =?utf-8?B?bm9rZ0ZGRzNwWVVJTy9xelRTS1htSGI2RjdlSVFnVUxhZjFxbEo3TUcrTjcr?=
 =?utf-8?B?b29MQ2pIQ2lURFVVcWdTdlVSd0UzVkhyQ1hsdllnNzBkNUh0WXZCOElaZUNL?=
 =?utf-8?B?b0cxUTIyOUJMaGw3UGVzUmVnSms1NTRDZ01DOUxpbnh6Mk1tSlM5R004QTk4?=
 =?utf-8?B?MHhUNTVBVytLTldSdTZmVE1nZy9RNXd3Z0kxbWhRNmpMSTRPRCsyVmhWL0VV?=
 =?utf-8?B?SVU3d1NmQVk3NVdMMzZCbnFIcFdKVUhTdDdTTWRiSTNRL3lHb2pXZDgyZjVy?=
 =?utf-8?B?SS84Uk1RTndnMW9DZmVKcHpRelNtSXUvRGFMYlp4Q1JPckMwQ01tdTFkelRs?=
 =?utf-8?B?Yk5zR0VhOVZRc1YxVFUrVTR4N213Z2xTZkdGRkNQbUxQMHlmMzJiU2MvZ1dT?=
 =?utf-8?B?L1QwWmlBUyswc1YrMWUwd0UzN3JFZHB3cS8yaWpSbVp2bXIybnhVRG5GSGxs?=
 =?utf-8?B?VlBMYU9aNUxabnhFU3dpR2lTbEZYeHhaRU4ybWJQVlhucW5ML2lucmJxdnJ0?=
 =?utf-8?Q?nUJ7B5bfhkJz1sNRxe?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	AHoQZG5uxFBWDhNRCtIIqOBlWZvPp0ou+98hTZ35PNhw9V5/o7EAnChh0cUNITRSe2Lzi/pNbiMlfj7ac6sC1KjQIhQyDrRxwtkj1OeBN2U/9XRgWYy7E32gdMlwUu1rQgNvQ843QmeUgtK03J76V50nXwnc7ipIGEWyQZjnimLiYMDcyMdv24GHSVeEYu3Gr8yXyDp75E66gOPZxgNjXAAxTgZyhm2xvSlhI2WhsH7zuh46Sc2sDhA0Dm/1fQ8cUtCf+x3d4+TOlQDF4zeSzUBm01OIbMJYNkQVB+KQDrku0oy2fYfu0kIVydHPZtRh+njhPzv+/5wDSn8RKjd3eg==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ca1416-fa01-459f-eb4b-08dec08f4f15
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2026 10:11:27.2426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2CR/k8WcCqVCTlmYyuPSGPfJChRluOC2eAu40YRQj7yl8VSSeO88gfsDqeDbF3lHqD7ekgkhMEidAC0eiVngnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFBC9D4BC2A
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDA5NiBTYWx0ZWRfX1Scho3/tfce/
 X8W03aGPTtjc8W/oSLee5hJ/nkJ/j1NG/e5IN+9eIS/DcGJqT8mVpUISikj774aH3eEV29N9r84
 L3vt7ekvMuLzcPIKFJ9R4Rno2ysJYy1Wl2yx5iSfP8fZPqTOvtkPtr9tRCh7ELIOcZFDK5/aWPG
 XsyF+itWc39AFj6hpjaJOlpnTHmEU1+aB73V5NzBOJH3FmYQAK0EcfNZOE+dqyUsSnENadrNVZW
 ZGcxDPoPsWMBeYjEoM7gvkCEpzCG5ll2rCz9d0uVDSV6FMlfZHvc4RY5Qt5z6tZSW0EM+ViBdFB
 64hgJVHmjn1BdVvVNMoh8U52t6kUiXuCwnmYLqF0Uhxp3vykv7d/PKqPpKdPy6nTMyATgZjOujQ
 9VfRH2VL03hmwcE1xIELeYHUkttuYNKzxJupHbGnRe8CACdxuKeb9jrYlsW9FthIELDP4QBcnjk
 uBszTw3giRrBLr8OXXQ==
X-Authority-Analysis: v=2.4 cv=cLjQdFeN c=1 sm=1 tr=0 ts=6a1eac52 cx=c_pps
 a=CCbTjXOBCEiPRml7Y9u42A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=QXcCYyLzdtTjyudCfB6f:22 a=RpNjiQI2AAAA:8
 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=bLk-5xynAAAA:8
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=iox4zFpeAAAA:8 a=xmsGQxIg3Z6tn0yPl1EA:9
 a=lqcHg5cX4UMA:10 a=PRpDppDLrCsA:10 a=QEXdDO2ut3YA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22 a=zSyb8xVVt2t83sZkrLMb:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-ORIG-GUID: PljVc4wTGWl_vqdXl3Wy5gHEI6wY3ylH
X-Proofpoint-GUID: HLgA0w2QJJlbo4U9K4sg-xfJhd7d-ll_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-02_01,2026-05-28_03,2025-10-01_01

SGkgWG9zZSwNCg0KVGhhbmtzIGZvciB5b3VyIHJldmlldyBjb21tZW50cy4NClBsZWFzZSBzZWUg
dGhlIHJlc3BvbnNlIGlubGluZSBwcmVmaXhlZCBbTko6XS4NCg0KVGhhbmtzLA0KTmlsZXNoDQoN
CkZyb206IFhvc2UgVmF6cXVleiBQZXJleiA8eG9zZS52YXpxdWV6QGdtYWlsLmNvbT4gDQpTZW50
OiBUdWVzZGF5LCBKdW5lIDIsIDIwMjYgMToyOSBBTQ0KVG86IE5pbGVzaCBKYXZhbGkgPG5qYXZh
bGlAbWFydmVsbC5jb20+OyBKYW1lcyBFLkouIEJvdHRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhh
bnNlblBhcnRuZXJzaGlwLmNvbT47IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2Vu
QG9yYWNsZS5jb20+OyBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4NCkNjOiBTQ1NJLU1M
IDxsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZz47IEdSLVFMb2dpYy1TdG9yYWdlLVVwc3RyZWFt
IDxHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbUBtYXJ2ZWxsLmNvbT47IEFuaWwgR3VydW11cnRo
eSA8YWd1cnVtdXJ0aHlAbWFydmVsbC5jb20+OyBlbWlsbmVAcmVkaGF0LmNvbTsgam1lbmVnaGlA
cmVkaGF0LmNvbTsgaGFyZUBzdXNlLmNvbQ0KU3ViamVjdDogW0VYVEVSTkFMXSBSZTogW1BBVENI
IDA2LzQ0XSBzY3NpOiBxbGEyeHh4OiBBZGQgRkMgb3BlcmF0aW9uYWwgZmlybXdhcmUgbG9hZCBm
b3IgMjl4eA0KDQpPbiA2LzEvMjYgMTI64oCKMjggUE0sIE5pbGVzaCBKYXZhbGkgd3JvdGU6ID4g
RnJvbTogTWFuaXNoIFJhbmdhbmthciA8bXJhbmdhbmthckDigIptYXJ2ZWxsLuKAimNvbT4gPiA+
IEFkZCBzdXBwb3J0IHRvIGxvYWQgdGhlIDI5eHggRkMgb3BlcmF0aW9uYWwgZmlybXdhcmUgZnJv
bSB0aGUgPiBmaWxlc3lzdGVtIGFuZCB0byBzZXQgdXAgdGhlIGNvcnJlc3BvbmRpbmcgZmlybXdh
cmUgZHVtcCA+IHRlbXBsYXRlLuKAig0KWmpRY21RUllGcGZwdEJhbm5lclN0YXJ0DQpQcmlvcml0
aXplIHNlY3VyaXR5IGZvciBleHRlcm5hbCBlbWFpbHM6IA0KQ29uZmlybSBzZW5kZXIgYW5kIGNv
bnRlbnQgc2FmZXR5IGJlZm9yZSBjbGlja2luZyBsaW5rcyBvciBvcGVuaW5nIGF0dGFjaG1lbnRz
IA0KwqDCoGh0dHBzOi8vdXMtcGhpc2hhbGFybS1ld3QucHJvb2Zwb2ludC5jb20vRVdUL3YxL0NS
Vm1Ya3FXIXRpM1p0TjkteVBVd2Ztd1dlUmY2amY5eGFHWGxQemJOZWlQbUJmVGtpQXpaUzRFOUlR
M3ZfWjZONWtQYUJvUnlITlRiQVNaUzJIQlUzdUQ0YWlvSjlES0RmeTAtUEJwTSTCoMKg4oCMIA0K
DQoNClpqUWNtUVJZRnBmcHRCYW5uZXJFbmQNCk9uIDYvMS8yNiAxMjoyOCBQTSwgTmlsZXNoIEph
dmFsaSB3cm90ZToNCg0KPiBGcm9tOiBNYW5pc2ggUmFuZ2Fua2FyIDxtYWlsdG86bXJhbmdhbmth
ckBtYXJ2ZWxsLmNvbT4NCj4gDQo+IEFkZCBzdXBwb3J0IHRvIGxvYWQgdGhlIDI5eHggRkMgb3Bl
cmF0aW9uYWwgZmlybXdhcmUgZnJvbSB0aGUNCj4gZmlsZXN5c3RlbSBhbmQgdG8gc2V0IHVwIHRo
ZSBjb3JyZXNwb25kaW5nIGZpcm13YXJlIGR1bXANCj4gdGVtcGxhdGUuICBUaGlzIGZvbGxvd3Mg
dGhlIHNhbWUgcmVxdWVzdF9maXJtd2FyZSAvIHNlZ21lbnQtbG9hZA0KPiBwYXR0ZXJuIHVzZWQg
YnkgZWFybGllciBhZGFwdGVycy4NCg0KPiBDYzogbWFpbHRvOnN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmcNCg0KTmV3IGZlYXR1cmVzIGFuZCBoYXJkd2FyZSBzdXBwb3J0IHNob3VsZCBub3QgYmUgdGFy
Z2V0ZWQgZm9yIHN0YWJsZQ0KdHJlZXMuIE9ubHkgYnVnIGZpeGVzIG9yIGVzc2VudGlhbCByZWdy
ZXNzaW9ucyBiZWxvbmcgaGVyZS4NCg0KW05KOl0gTm90ZWQuDQoNCj4gQEAgLTc2ODAsNiArNzcy
MCw3IEBAIHFsYTJ4MDBfdGltZXIoc3RydWN0IHRpbWVyX2xpc3QgKnQpDQo+ICAgI2RlZmluZSBG
V19GSUxFX0lTUDgwMzEJInFsODMwMF9mdy5iaW4iDQo+ICAgI2RlZmluZSBGV19GSUxFX0lTUDI3
WFgJInFsMjcwMF9mdy5iaW4iDQo+ICAgI2RlZmluZSBGV19GSUxFX0lTUDI4WFgJInFsMjgwMF9m
dy5iaW4iDQo+ICsjZGVmaW5lIEZXX0ZJTEVfSVNQMjlYWAkicWwyOTAwX2Z3LmJpbiINCj4gICAN
Cj4gICANCj4gICBzdGF0aWMgREVGSU5FX01VVEVYKHFsYV9md19sb2NrKTsNCj4gQEAgLTc2OTcs
NiArNzczOCw3IEBAIHN0YXRpYyBzdHJ1Y3QgZndfYmxvYiBxbGFfZndfYmxvYnNbXSA9IHsNCj4g
ICAJeyAubmFtZSA9IEZXX0ZJTEVfSVNQODAzMSwgfSwNCj4gICAJeyAubmFtZSA9IEZXX0ZJTEVf
SVNQMjdYWCwgfSwNCj4gICAJeyAubmFtZSA9IEZXX0ZJTEVfSVNQMjhYWCwgfSwNCj4gKwl7IC5u
YW1lID0gRldfRklMRV9JU1AyOVhYLCB9LA0KPiAgIAl7IC5uYW1lID0gTlVMTCwgfSwNCj4gICB9
Ow0KPiAgIA0KPiBAQCAtNzczMCw2ICs3NzcyLDggQEAgcWxhMngwMF9yZXF1ZXN0X2Zpcm13YXJl
KHNjc2lfcWxhX2hvc3RfdCAqdmhhKQ0KPiAgIAkJYmxvYiA9ICZxbGFfZndfYmxvYnNbRldfSVNQ
MjdYWF07DQo+ICAgCX0gZWxzZSBpZiAoSVNfUUxBMjhYWChoYSkpIHsNCj4gICAJCWJsb2IgPSAm
cWxhX2Z3X2Jsb2JzW0ZXX0lTUDI4WFhdOw0KPiArCX0gZWxzZSBpZiAoSVNfUUxBMjlYWChoYSkp
IHsNCj4gKwkJYmxvYiA9ICZxbGFfZndfYmxvYnNbRldfSVNQMjlYWF07DQo+ICAgCX0gZWxzZSB7
DQo+ICAgCQlyZXR1cm4gTlVMTDsNCj4gICAJfQ0KVGhlIGxhc3QgYXZhaWxhYmxlIGZpcm13YXJl
IGZpbGUgaW50ZW5kZWQgZm9yIHVzZXItc3BhY2UgdXBkYXRlcyB2aWENCnJlcXVlc3RfZmlybXdh
cmUoKSB3YXMgInFsMjUwMF9mdy5iaW4iIGJhY2sgaW4gMjAxOSAoZm9yIHRoZSBJU1AyNXh4IFFM
b2dpYw0KMjUwMCBTZXJpZXMgOEdiIEZDIEhCQXMpLiBTaW5jZSB0aGVuLCBubyBvZmZpY2lhbCBm
aXJtd2FyZSBiaW5hcmllcyBoYXZlDQpiZWVuIHJlbGVhc2VkIG9yIHB1Ymxpc2hlZCBmb3IgbmV3
ZXIgMTZHYiBvciAzMkdiIEhCQXMgKHN1Y2ggYXMgSVNQODN4eCwNCklTUDI3eHgsIG9yIElTUDI4
eHgpLCBsZXQgYWxvbmUgYmVpbmcgbWVyZ2VkIGludG8gdGhlIHVwc3RyZWFtDQpsaW51eC1maXJt
d2FyZS5naXQgcmVwb3NpdG9yeS4NCg0KV2hpbGUgdGhpcyBjb2RlIG1pZ2h0IGJlIHVzZWZ1bCBm
b3IgeW91ciBpbnRlcm5hbCBkZXZlbG9wbWVudCBhbmQgdGVzdGluZw0KcHVycG9zZXMsIGFkZGlu
ZyBkZWFkIGNvZGUgdG8gdGhlIHVwc3RyZWFtIGtlcm5lbCBmb3IgZmlybXdhcmUgZmlsZXMgdGhh
dA0KZG8gbm90IHB1YmxpY2x5IGV4aXN0IHByb3ZpZGVzIHplcm8gdmFsdWUuDQoNCltOSjpdIEp1
c3QgaW4gY2FzZSB0aGUgZmlybXdhcmUgZnJvbSBmbGFzaCBjYW5ub3QgYmUgbG9hZGVkIGR1ZSB0
byBzb21lIHJlYXNvbnMsDQp0aGVuIGEgcmVjb3ZlcnkgbWVjaGFuaXNtIGlzIGVzc2VudGlhbCB0
byBsb2FkIGZpcm13YXJlIGZyb20gZmlsZS4NCg0KDQo=
