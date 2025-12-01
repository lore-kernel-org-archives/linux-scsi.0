Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013048.outbound.protection.outlook.com [40.107.201.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66B92877D8;
	Mon,  1 Dec 2025 07:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764573097; cv=fail; b=LiWxag71lQNk2PqRc0hUHqjqrhsXNvu512oGn07YUxXBgUUWPeJWUgbokBEXnL/EnNR3htl++lgRbjOIhv6IYDAzL0S713MjgUHMCTHtBxInS7ShZEMKQ2qUOdj8GEXnqpYNVR//IeBePMNtmzz8jhWKlekgneT5QWu2bhgiEHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764573097; c=relaxed/simple;
	bh=VR8+OErRLHQ2W2IdNk0EsX8Skc4KK3WTUNo5Bjcftk4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N8Yd74OnqZ0Qo232jMKYtgCUOkWWy3kZxDuR7wYdMbOS1FOIWq5Yuq2QBneG4+1FJSyY1Ok9o0MBSMfwCtGIJ4iv+t5VS5XCOq8ag/1F7uP7IGQlQTb0+OW25oaqguQrZoiyKAJPnTC4tH3W7x9twBD6ebpOjXUOpU4ZEo6Ar3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eYKG9gsn; arc=fail smtp.client-ip=40.107.201.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eYKG9gsn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GmAl7IHx2x6K5yCMjuL342/ENMnevM7EC+7gC40ZhUWBN+x1Ju7Bp0q29/top0XjMGlQlP0oAGU+pMXBm9mcrwMGdgnwB3kWZICPQGm3WR44ismvqHI3Ah83iAYIjNB+GjuJ4FYM8cNDyL9x1A6vn3MvqMe1Pwj4tqX9e2pwRL2pc3lTriaxVf/stVUAjTCzz56qsFMb7aDeVrnVTkV49q+s43VxR6P3KwffUmbQvvZ/ra4a5mHXGQCtOscfFxIeikxViHEfp4mf2WoOoTdEjDbo1nKlapfxvyRhxzy6BYespfquzkCfJ0DDNXmaUyq+PBu1LKcuBphucEVEdW4H4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VR8+OErRLHQ2W2IdNk0EsX8Skc4KK3WTUNo5Bjcftk4=;
 b=EAWG/yNLmD1Dvnh9Rc7SNysO67T1gZNEW1YtMZKSM2AfPctZL63VixEKhyvcOgoZNzecKACVrYQGCKx/GqExValh+CvrCw221egmeWWPGZAl4D/JG/8KSnfyabKyrQyrvnAvwRRfTfvD2ucKZPlalwThNtrbfGZOw7+pk5sTloaB0s8bElcsH4XJ8YvUCngPm//7m286ee8CEiPzIxOPI7WVG2omJZ6Srv+vGQBx46rFzZ2wVWeE0ghqv6gKJ+d06KGFHM5M5Gp7vE856bDtJIJKL7X2oZZmhCmbyA8Tf2VjKTK+HDemLdr3X11YOsqTlDsofhYQhIUYVo/iM/dl5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VR8+OErRLHQ2W2IdNk0EsX8Skc4KK3WTUNo5Bjcftk4=;
 b=eYKG9gsnFjY5ul05Ga288HrRc9Qm8QaBsHbBHOYrGN5RIY9A7lctUvsOTltwQ9vj3oJBU94pZN1M/GwM7n/FNVPj0gD2+9+TdM072rzGXl9Agd4nALH8HHCF4vvMu6wmgJB6lPi6t8xGzp9hp/8OBUaKROD7tZbvoo2GIdAVrnB9uF2FMqMq+gxJbUBtqpMwH8ebV9uvVcgy1Zbu4bq8QCajKlRzKHiUnIiNHOcCTr38un18RvmWINFai/qj29tUoIK1YUSUmbBJVeaH9skYStTMxsSisM2wCkHaTkbXS60uhVLE1YD+f7sEpN3oqm6Rj3CNYmWS/YBtlisbMMZNbw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CY8PR12MB7756.namprd12.prod.outlook.com (2603:10b6:930:85::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 07:11:32 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 07:11:32 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
CC: Keith Busch <kbusch@kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike
 Christie <michael.christie@oracle.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sagi Grimberg
	<sagi@grimberg.me>
Subject: Re: [PATCH v2 2/4] nvme: reject invalid pr_read_keys() num_keys
 values
Thread-Topic: [PATCH v2 2/4] nvme: reject invalid pr_read_keys() num_keys
 values
Thread-Index: AQHcX7YzcUq/7de0wEueQCDOArhALLUMZAOA
Date: Mon, 1 Dec 2025 07:11:31 +0000
Message-ID: <69b3b390-77fe-440c-8747-096c0b26a112@nvidia.com>
References: <20251127155424.617569-1-stefanha@redhat.com>
 <20251127155424.617569-3-stefanha@redhat.com>
In-Reply-To: <20251127155424.617569-3-stefanha@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CY8PR12MB7756:EE_
x-ms-office365-filtering-correlation-id: 84905ac5-675f-4db9-1bb9-08de30a8daff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QUh1cWdnbmQ1T0xibkl2QTR2a1hLSndOM01GbnlDUnpRM3I4YnZmZERZT1Vx?=
 =?utf-8?B?dDlEVnVTOEJySytwTlcrMGduMFlraEhNZHJIaldzT2NVR0dYMkx4S2J5R1p2?=
 =?utf-8?B?aVpteEFETzJmOS80TkIyWWZseXZZZkJZci9QNWJYQktlNE1VUGFVR2NpVVZH?=
 =?utf-8?B?M0RrZ0E4dE9scHkzMDJBTkptTjZUdWI5ckNTL0ZOK0lSa25sMVlKSWtaNnha?=
 =?utf-8?B?RHVob21sazgxZDk0QnE2dGs0N3lFMFl1UktpaWt2QWFGYi9iTDVRbzdHQmF4?=
 =?utf-8?B?ZnI1Q2psMC9nNmlkcktLQk9UMm05RktiUkt0VXlndnZzSzlHN0NDN2dNbkJB?=
 =?utf-8?B?SXZ5dTd3VjdZMWNFVjVIekI2K3BiS1gwZG54aHVSeVJCcTdveVVUN1V0VjhI?=
 =?utf-8?B?b1g3cVQ4d053cXJqZkVtU29GVDFsM1h2NHRaQ1NvRUpKNDhtSytiUlBsQjdx?=
 =?utf-8?B?MDZQR1ArSHMvWnE0T0ZxZ3RydVRZV2tRNFpSYmtMSEFOMHIybkoxUEk2Z2Qw?=
 =?utf-8?B?NTlEZTliRVVlcWdkb0UvY2NCclR2bWtGZHVlLysvMGhCanYwR25QM0lWUCtF?=
 =?utf-8?B?K1YrOVJpOCtmMlpLaXdnQ1loVEtvQlA3aVBxZHNCaDNYZlhtMm1oQmJnOGcw?=
 =?utf-8?B?cHM0TWNqK2Y1OGJyMGdRcnBjNWJlQXRvRDhQelVpeGduYW85MDZKYlg4alk1?=
 =?utf-8?B?ejlRVHlyeVpSSWpQSWZiaUZVQzh6TWEwR0UraUNmcVViN3hkUll6N3UvQStJ?=
 =?utf-8?B?VXh0a1g4OGNOTjJmR1JNSnNWMWRKTXJOL0pDSGo3Q3dSNGg2Uit3R0srYnlx?=
 =?utf-8?B?NENNT0d6VUg5T0NBY2tvSXlGanAvKzdvU0pSbkIwQytIdEFEaG9MYXlaZEMx?=
 =?utf-8?B?QnJrelgwdlVRbXdOazZqWDJtTWRvY25UM3lTbEV6S3VMbWdCS2ZQREVUTmtt?=
 =?utf-8?B?WVFjaVh2czVwaGZaZ1h0MXJtZ1F0ak5TckVzMWxQVUU0d3BPcDIwM1dXb1pT?=
 =?utf-8?B?YUtrK1NwTUdhZzBqQ1MyZUl6NDNwdGd4MVozSFFoWGc2dFlSYWRma1NjNVNH?=
 =?utf-8?B?ck40T1RSZGlvSlhjVGtMTnpBc3hGU1AxclZmZEpKMVZ6dDlMcGZ3bExwSUtq?=
 =?utf-8?B?bGp4aWpSWnF6Q0xsMEttM2U4bVJrSkE5ZVg2QmdvNS83cjNnU0VWLzlZb3pP?=
 =?utf-8?B?LzFIOStKRTFTSjZYQ2EwdlR6ZDAvaEdGK0RTZ0o3VHBnTUI4SE1PQkJINERV?=
 =?utf-8?B?VTgrSEdPUWRuMGVXU0REUUpiWEhhUG1UeW95VDlnSld5S05nT2xNYzJSTEFq?=
 =?utf-8?B?R1VEQ1p3ZE5OQ0grU2lwR0l4ME1TSTZRZFBvdEttckp4U3NITENDTlpHWWJ2?=
 =?utf-8?B?ejVjT1h2MHFCcngyS2JOczJ5ZjZGZTUzK0xDNjNEZEY1eTBlNFA1blR5M0Nq?=
 =?utf-8?B?Mkkwb3EvTjlUckdiNUM0cFh3b1ArMCtZNlhNMlJwRXFTSjhJL3p0TldxbmZp?=
 =?utf-8?B?M3czd01ONkxqdDMyM2t1NStqR2hFVGZqMjZWNjZJV0YrL3NtZ0cyU1kwQUFp?=
 =?utf-8?B?SmE5QWRGMWhieitJWWVPWmtuRW0yR1d4ekJXcjRzd09XbGhFcnNlQkJkNEJn?=
 =?utf-8?B?azN0YVRNL0l5dk9iZS84a0pVcVFxUllLQk13ODk1QnEyZ2tCS0trRitRSGRp?=
 =?utf-8?B?czgxTTBmTG9sYVZ4TjlwOXJ0d2w0MjJ2ekNpZWpPMTBKbVhBc1hHakFwRHB5?=
 =?utf-8?B?QnRucmVuZXZlYklUS2t6TTJzLzNaSEJtQm9sQ1dpSnlranVZRU1CbldEVDN1?=
 =?utf-8?B?dnN2WFZyNjJQRlEwNXlRakp6Z3MyaHFPMUF0aUd6WHhmTzNkM2VhM2hDVG9j?=
 =?utf-8?B?ZzN3WVpQRVVtM2RhVW5Ec0tibnRLTHZpd1B0bmp5Z1dEK21mVjN2RnNFZkNE?=
 =?utf-8?B?a00xN1BiQjUyTC9LbXN5ZkhoN2xqQldiaHJOSFU3d3Fjc0t1SkhMdUx6YWJ4?=
 =?utf-8?B?UndsYXlOeVBiUVF3QUhOVWNweTVQbmhxc1dDL2kyUk50dWhqcGdmQnlIa0Q2?=
 =?utf-8?Q?5UZsKI?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TUwrSXF3MitrcklJVldjWC94d2ZRaVl4SnVFWnJ5MTRFTUZ5aGp0bEc0K2lX?=
 =?utf-8?B?SFhaTHhWVERsT3JhRE1mQUlhdXVYanhlb0pyYnF4eVVwQzFtSjVucE04OW03?=
 =?utf-8?B?ejBRd2pLbENCK3VlQjV0SDBMdHZDSUtuQ0dRaWVURE9jRXdIL0R0aVZnQ1Rx?=
 =?utf-8?B?ZUtKNERvS2s1K3BMMU5SNmQ4QzRGY0FmSlhMSUhBTTlXclc4RGFTbW12SXY0?=
 =?utf-8?B?N1Brdk5ia2pUd3VIN3JDMUJsR1JwV1p0TUdNYlRYNHU5OFN4cTJIL0locW02?=
 =?utf-8?B?ZW1zQVkrNy80M1lWMTYxWWk2WmNvbHFXZEpsSHg1bUtEeElYOTQrUlg1WjBo?=
 =?utf-8?B?RnVJV0hBbG55Tkdack1paWxDS2lDR2JNem9Mb2dVYXh2OXBKWkxmcXNlT1BJ?=
 =?utf-8?B?QVppUm9SeHlRdEVzc1dUWExxeHk3OXhRNUdpbk05dW1RZ1NmS3RaNFZQUE84?=
 =?utf-8?B?aDJ0SWpYd3hDSFpObjRwaERoSnY2cktFYXJSdlZRdStkT3ZVYUE5Y2VNdDJJ?=
 =?utf-8?B?NFhWS2dXVUJzRXFZd0dEM2JibENyL0pTUlJQRU5wNHdnSTBNS2REOFk4S1RV?=
 =?utf-8?B?dFo0NDk1Sm9jQ2FseW5reXpPQlpYVGhtOHZSRmhBVEFnQnZybFVKS3RrU2tv?=
 =?utf-8?B?VDdLMHhTZXMvcXExUWdmM3RqcVZuOVUxOVl0VUozOXFVUUFadDcvcVZ0NGVF?=
 =?utf-8?B?Rk9rUDRQbmFCTGt3UTVVZ3kvdWJqZ3RFWUdBUjJDSllYTzVadnE2YzZvQWNN?=
 =?utf-8?B?RTFjNFlrc08wMEl6bm5aWGI2Q3VkUEJ4UXlEdk9WbkMvZGdkaGVSVHM4cHZa?=
 =?utf-8?B?dWh5clNSWjZLNGlhL3JGdEtPWFhTZncwSWJuOXhpY1hDbUQyZFViRjJqcklG?=
 =?utf-8?B?dFFNbXowaVZMcGNhVE9OY3ZGTURndGIzMjBmQTBxSk9heWc5Y2RWWTJBU1dG?=
 =?utf-8?B?V0IrcDZ3STRISnJWMW8zSXg1YVQ5aEttUExSVi9XK0ZPQXhITkZSSEs5czVh?=
 =?utf-8?B?TVllbDk0Z0k3TGxacEFSSGJZeHFITit0a3VCcWNHSjNqd1hSbzNjeVIyelRV?=
 =?utf-8?B?SDJhZHN6M3NoLy83c0FZeUF1Y1JqQU5RbTFwVVF4cWJPQ3lOS21jQncvZFBt?=
 =?utf-8?B?OXpuc2RnZ3llUG5YR1FKQzdacTMwdGFUdm9GK1BZQVNBTEpXUUN0bmlqQXRD?=
 =?utf-8?B?Sm1TdlU5cEg4ZFIxZFhWaFp2ZTZja2pYUE44RVdTdlJIRlpqcGJXZk9oSTFQ?=
 =?utf-8?B?V0xNYWV1NEdPZUxsbVd1eHFsak5KRGt3OGJneWZLc05HQmdzM0RJQVVPbWN2?=
 =?utf-8?B?YnVkNk9wRk1oUW9icytmWjBZUTl3UHhVbDJDTzN0V3RFNEJER3k1VGZacE0x?=
 =?utf-8?B?ZHhrSVJQUEM4SEtWazZ5b2E1NDBiRzRTVFhuNHBZZkl1RTdCYzc4UllEVnRQ?=
 =?utf-8?B?bzkwZmVxVlA3R0dCYlpIelFRb2dKZTUxa0dlN2JsM2dSUW5mZnNyWGs1NnR2?=
 =?utf-8?B?aXRTKzM1SlJMRm5hQmpoRms0OFFuUEJVTWc4NS81anVtQUVFSzlUS0R1TGlo?=
 =?utf-8?B?TE0xUnYzZE1TdldHeUhyVEtGdVd4Mi9wNTVySlIyOEwyVUxmVjRGUjBrdlNs?=
 =?utf-8?B?emJrUUs2UlpJVnFwTlhsUUFUTXgwYXZtbTdKWlpBTjdGUkJkdVZWK0R4SjYv?=
 =?utf-8?B?R2xKT2NOR2x6QlBXMFlrd0kyWGRLWWR3aWpHVFJhTUVtQ0t2WGgzYkwwMkxY?=
 =?utf-8?B?WUN6K1MxSDVqb3IrS3JIZXBuVzZYK0dsV0JpbFF1T0V2RXFRSG51RXRvTTYr?=
 =?utf-8?B?akZ4Qy9aV2h3M0xaYnpnT2ZmYzk3OUFEeFErVHI2dzM2emRhR0x5ZDBaMk1J?=
 =?utf-8?B?Z3RpMzR6RDBCTE84K1VaRU44NENPV3JubEpBVXo0QndSRCtObmpndWZVeHZx?=
 =?utf-8?B?UjRaZzUzMEY3YzExVUoxdHFlNlFDa1BSZ3Zvclh0RG0rcjc2enFWMzNvd2M4?=
 =?utf-8?B?d1UzQy9sN0I0VUZqRWw1bzZZRlJidElqR2hLQXNrdTVERFN2S1JuUFhYVXNp?=
 =?utf-8?B?T3NLT1M4OGVaR3BXaUVXN3Yyc1h3WllvWHJBZ3NnVHExYjJwZFM1bittSHZz?=
 =?utf-8?B?a2lSRlZidW8yaFFsa2JVaTNzYjB4bWw2b2Z4alV5dzlHYy9PcUp1b3Q3S1Fv?=
 =?utf-8?Q?mf8iCpqK8G9K8+XMRellu0uuhtyfUUI2nVy89s8ZVwqd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18DB45DE77AE164B872F76EA760BEBF0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84905ac5-675f-4db9-1bb9-08de30a8daff
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2025 07:11:31.9660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GFV8PdG63fFAGp1veCAznrJh8RbGSWtPjHsDf+3Np6Yctfp0FTzW+ACY4JFSNJKVKd/OaKaZMFXREz6al5aZVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7756

T24gMTEvMjcvMjUgMDc6NTQsIFN0ZWZhbiBIYWpub2N6aSB3cm90ZToNCj4gVGhlIHByX3JlYWRf
a2V5cygpIGludGVyZmFjZSBoYXMgYSB1MzIgbnVtX2tleXMgcGFyYW1ldGVyLiBUaGUgTlZNZQ0K
PiBSZXNlcnZhdGlvbiBSZXBvcnQgY29tbWFuZCBoYXMgYSB1MzIgbWF4aW11bSBsZW5ndGguIFJl
amVjdCBudW1fa2V5cw0KPiB2YWx1ZXMgdGhhdCBhcmUgdG9vIGxhcmdlIHRvIGZpdC4NCj4NCj4g
VGhpcyB3aWxsIGJlY29tZSBpbXBvcnRhbnQgd2hlbiBwcl9yZWFkX2tleXMoKSBpcyBleHBvc2Vk
IHRvIHVudHJ1c3RlZA0KPiB1c2Vyc3BhY2UgdmlhIGFuIDxsaW51eC9wci5oPiBpb2N0bC4NCj4N
Cj4gU2lnbmVkLW9mZi1ieTogU3RlZmFuIEhham5vY3ppPHN0ZWZhbmhhQHJlZGhhdC5jb20+DQo+
IC0tLQ0KPiAgIGRyaXZlcnMvbnZtZS9ob3N0L3ByLmMgfCA0ICsrKysNCj4gICAxIGZpbGUgY2hh
bmdlZCwgNCBpbnNlcnRpb25zKCspDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL252bWUvaG9z
dC9wci5jIGIvZHJpdmVycy9udm1lL2hvc3QvcHIuYw0KPiBpbmRleCBjYTZhNzQ2MDdiMTM5Li4x
NTZhMmFlMWZhYzJlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL252bWUvaG9zdC9wci5jDQo+ICsr
KyBiL2RyaXZlcnMvbnZtZS9ob3N0L3ByLmMNCj4gQEAgLTIzMyw2ICsyMzMsMTAgQEAgc3RhdGlj
IGludCBudm1lX3ByX3JlYWRfa2V5cyhzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LA0KPiAgIAlp
bnQgcmV0LCBpOw0KPiAgIAlib29sIGVkczsNCj4gICANCj4gKwkvKiBDaGVjayB0aGF0IGtleXMg
Zml0IGludG8gdTMyIHJzZV9sZW4gKi8NCj4gKwlpZiAobnVtX2tleXMgPiAoVTMyX01BWCAtIHNp
emVvZigqcnNlKSkgLyBzaXplb2YocnNlLT5yZWdjdGxfZWRzWzBdKSkNCj4gKwkJcmV0dXJuIC1F
SU5WQUw7DQoNCmRlLXJlZmVyZW5jaW5nIHJlcyBpbiByZXMtPnJlZ2N0bF9lZHNbMF0gaXMgc2Fm
ZSBpbiB0aGlzIHBhdGNoID8NCg0KaWYgc28gcGxlYXNlIGlnbm9yZSB0aGlzIGNvbW1lbnQgLi4u
DQoNCi1jaw0KDQoNCg==
