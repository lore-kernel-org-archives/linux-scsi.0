Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFF43DC87A
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 19:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781637739; cv=fail; b=WBFMr7gSuLq9dSO7RU+aPwEzZ8ciD+H/D5bAmwby2F35a1qFtkHg1x2eCIh1S/9O/PnAcQG7gl5L6jMZ9xittMQm/CP5wTxThjDGYYGpdA83WahqwykaRVIoTnvcqoTIf1D0m8d/0tiIISthv4meRSDyI2FCx9K+P+RGc4OK7hs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781637739; c=relaxed/simple;
	bh=5BUmB5dBruhViEywXYzDV14MsL5XtX1o0IRwExZ+rXE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pWX9JEPpH1AhcssPuyRXvMkuBQdFmVchBK2u/YDcJFuu/EDsSDbCqr174rLb0lAOEiOxRp2P4ExNgE3s9tSWgFh2Tq6JQJuizDKE9OBzn2WI8QrD6T0K3OYN+QZQ3A4aTnOxP6YvNCDi4Nlnf+1PSRoehOp3qRrd38jf+NxWFAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=I/TBB76z; arc=fail smtp.client-ip=173.37.142.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="I/TBB76z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7870; q=dns/txt;
  s=iport01; t=1781637737; x=1782847337;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5BUmB5dBruhViEywXYzDV14MsL5XtX1o0IRwExZ+rXE=;
  b=I/TBB76z8SE3o5j+myPQ+pFmtXGvdd22FigoqpEfsqiCQivYVEnZ2Cit
   BgmRatfeJisXtBfG2unQdnJyFy8Vu1aLBjtdxUFHEVOzEA69uu5I5udgh
   BQ/vQnn3ovqhkiaMHQvZF/ewp5SxcPFvb/Zt+KBydAuks/yCW73idgXcg
   Lj2oSTLVbDuqQqrdspIDE7OVSlwTlY1lehU0ePsxZkOHaGpUTfHJVStH6
   aSZj5PSRuC8+slSPyKmHwLJRG9PTjfuiC6ZnF/+fXzUHOjaNxDaDuFkp6
   dbYhXyJ8/RIZXYrBqiBAlTFhtJgW4Cns/6dZReXBBYw648RG9EFLf3YsN
   w==;
X-CSE-ConnectionGUID: Lfqz0iZKQ6KSiqJ09BjAZA==
X-CSE-MsgGUID: s/lEO1u1T82xlgYvgzDnSw==
X-IPAS-Result: =?us-ascii?q?A0CTAwD8oDFq/40QJK1agS6BK4FuKimBCoEhSYRXg0wDh?=
 =?us-ascii?q?SyIeQOBE50IFIFqDwEBAQ0CUQQBAYUGAhaNKgImNAkOAQIEAwIDAQEBAQEBA?=
 =?us-ascii?q?QEBAQELAQEFAQEBAgEHBYEOE4ZQDIZaAQEBAQMSEQQNRRACAQgYAgImAgICL?=
 =?us-ascii?q?xUQAgQOBQgagghZgnMDAQKmWgGBPQKKKnp/M4EB4C8GFAGBCi6IWwGBcIQGO?=
 =?us-ascii?q?IREJxuCDYEVQoIxOD6EKhsVg0Q6gjAEgiKBDJEbCUl4HANZLAFVExcLBwVhQ?=
 =?us-ascii?q?kMDKi8tI0sFLR2BIyEdFxYeWBsHBRIgKkJFIwMCQjQEIT84C0MFgV0CghFOI?=
 =?us-ascii?q?x8DOX+Bb4ElZ2YVMDWBAQERHwp7AwttPTcUGwMEOnsFjGkXD4I2CBUbgQkgA?=
 =?us-ascii?q?oEMZZQQgmxJr1kKhB2iEReEBI16hh2SUZkII6h0AgQCBAUCEAEBBoFoPIFZc?=
 =?us-ascii?q?BWDIlMZD44tFswmeT0CBwIHDgMLk2UBAQ?=
IronPort-PHdr: A9a23:Yr44yBWj4RoTcmcXH05/glgsHJnV8K3PAWYlg6HPw5pHdqClupP6M
 1OaubNmjUTCWsPQ7PcXw+bVsqW1QWUb+t7Bq3ENdpVQSgUIwdsbhQ0uAcOJSAX7IffmYjZ8H
 ZFqX15+9Hb9Ok9QcPs=
IronPort-Data: A9a23:cpfPpaCBoqFjGhVW/2Piw5YqxClBgxIJ4kV8jS/XYbTApGxw1TMGm
 msbWTyPP/bfMTH1fo8nOdu/oUNXu5PTmtNkOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZvCCeA+n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357jX2thh
 fuo+5eBYAH8hWYvWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TE5/t3Hhk3D64hpMVMAHhsr
 a0yKhk/R0XW7w626OrTpuhEj8AnKozveYgYoHwllW2fBvc9SpeFSKLPjTNa9G5v3YYVQ7CHO
 YxANWMHgBfoO3WjPn8UAYgineOhhVH0ciZTrxSeoq9fD237k1Iti+a2aYuKEjCMbd4Smmu//
 3+fwzSjEhUVBcKQ2xaDyW3504cjmgu+Aur+DoaQ8v9snU3W3WcICTUIWlah5/q0kEizX5RYM
 UN8x8Y1haE28EruSpz2WAe15SbY+BUdQNFXVeY97Wlh15bp3upQPUBdJhZpY909v8hwTjsvv
 mJlVfuwbdCzmNV5kU6gy4o=
IronPort-HdrOrdr: A9a23:edJleqg9pyGZzCOHyFfLhTBDrnBQX9V23DAbv31ZSRFFG/FwyP
 re/8jzhCWVtN9OYhAdcIi7Sde9qBPnmaKc4eEqTNGftXrdyRqVxeZZnMTfKlzbamHDH4FmpN
 1dmsRFebnN5B1B/LnHCWqDYpgdKbu8gd2VbI7lph8HI3AJGsRdBkVCe3qm+yZNNXB77O8CZe
 GhD7181kKdkBosH6OGL0hAddLu4/fMk5XrawMHARkI1Cmi5AnD1JfKVzKj8lM7ST1g/ZcOmF
 KpryXJoomzufCyzRHRk1TU84lXn9XZzN5CDtyni8QeKDng4zzYJbiJXYfsgBkF5MWUrHo6mt
 jFpBkte+5p7WnKQ22zqRzxnyH9zTcH8RbZuBylqEqmhfa8aCMxCsJHi44cWADe8VAcsNZ117
 8O936FtqBQEQjLkE3Glpr1vlBR5w+JSEgZ4KkuZk9kIM0jgXhq3NUiFXZuYdM99eTBmdga+a
 dVfZrhDb1tACOnhjjizxpSKZqXLzQONybDZFQescqI1DUTtnV4w0wEgPE7pB47hcgAo10u3Z
 WZDkyu/4s+E/M+fOZzAvwMTtCwDXGISRXQMHiKKVCiD60fPWnRwqSHq4ndydvaMaDg9qFC0K
 jpQRddryo/akjuAcqB0NlC9Q3MWny0WXDoxttF75Z0t7XgTP6zWBfzBWwGgo+lubESE8fbU/
 G8NNZfBOLiN3LnHcJM0xflU5dfJHECWIkeu8o9WViJvsXXQ7ea/NDzYbLWPv7gADwkUmTwDj
 8KWyXyPtxJ6gSxVnrxkHHqKgXQk4zEjOVN+YThjpwuIdI2R/9xWyAu+CGE2v0=
X-Talos-CUID: =?us-ascii?q?9a23=3A6FSMJmjjWwNSDeZtRa/J49h6VTJuVnPE3i/REWy?=
 =?us-ascii?q?BV0VSSaS3EQ66+opWup87?=
X-Talos-MUID: =?us-ascii?q?9a23=3AtkP9zQ/b9Hz/DPKj2UBCm3iQf9wv54mJUV1UrcV?=
 =?us-ascii?q?cq82LBDJ/KRubtyviFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-04.cisco.com ([173.36.16.141])
  by alln-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2026 19:21:08 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-04.cisco.com (Postfix) with ESMTPS id 82540180001A7
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 19:21:08 +0000 (GMT)
X-CSE-ConnectionGUID: jmu6Cs93QOas4YO2rSBb+w==
X-CSE-MsgGUID: aBMFkDuVQASZIOf34rp87A==
Authentication-Results: alln-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.24,208,1774310400"; 
   d="scan'208";a="78429142"
Received: from mail-northcentralusazon11012028.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.28])
  by alln-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2026 19:21:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NtEFbsFrbFAlruYKhboiJglVrzp/ITD/RoDwdFRRCESAtUARoH/L44rswzIH/VH2192nYlkd8aLnqWRBWhMJurxl6wwC4dWtnbwCdSXYdolTnnpRLYJsfMTw9cbUrXPHe7lQZmk0RLD8i+g9VJBZ3LrkJFIchHdVNPkFIZIj1k/LRapL1Bg0jBPwQxB4G/ppNw5Vpjbs4eUI/gxMMtfmr9fwPZAqnetjvHY2XumIS60XxnIpH4r1Tvf1p5v/y22/Cl7OJDPXxJVeQvEbiwqvwnffvRcc+A4BxjTEdbKyLPEfLL19AxV4I1Jf37orSr3HVYYWB2SRA4VofdXTq4BiNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5BUmB5dBruhViEywXYzDV14MsL5XtX1o0IRwExZ+rXE=;
 b=HEmBqj/4OALxFu4sWC94IGOX8JSLQy+2u75ObgWvp2m8pytA641SnV5AOuCPyNGX+LrHosNpUxehYD4JUIF73OpufT4Iy9CjQpS9/lKCz/Tl5yCwI8/FmlguijFb0b0GvyPC7QTDF3pdazPX7Kj/NgY0rDID+wUDZrfFXvgu1UxhTR7GcD4N7ZDIx645PWPrcuyhuHCJqH58Lzdnm6f4vLPfd5FlrAm2qMZBVMMfVTNuppzI/Sf690jr1fLoUIYxf2IuHfJhLIrh61pUn756Vfh/ATrQqMMn3Mq6nt2YjicvG7qxXqZlhkGdULbtktELw6Vof7a/LtmqAP6mQ554Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SJ0PR11MB5939.namprd11.prod.outlook.com (2603:10b6:a03:42e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 19:21:04 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%3]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 19:21:04 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar
 Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy (arulponn)"
	<arulponn@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Arun
 Easi (aeasi)" <aeasi@cisco.com>
Subject: RE: [PATCH v4 07/13] scsi: fnic: Route completions and resets by
 initiator role
Thread-Topic: [PATCH v4 07/13] scsi: fnic: Route completions and resets by
 initiator role
Thread-Index: AQHc+pc1OOOOpraNmUGMsw+MlokPILY7fN4AgAYXIzA=
Date: Tue, 16 Jun 2026 19:21:04 +0000
Message-ID:
 <SJ0PR11MB5896BC592264395BAF588612C3E52@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260612180918.8554-8-kartilak@cisco.com>
 <20260612221550.B8A961F000E9@smtp.kernel.org>
In-Reply-To: <20260612221550.B8A961F000E9@smtp.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SJ0PR11MB5939:EE_
x-ms-office365-filtering-correlation-id: 517f0497-be88-48ca-c22c-08decbdc68cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|56012099006|4143699003|5023799004|11063799006|22082099003|18002099003|6133799003|38070700021;
x-microsoft-antispam-message-info:
 83hpsnmxeA4NPZJOGbFCL/LSzdHW1teDtr3g2MrpAmeKr0ABAc+59eJzFLTektAk6JojhOTl1PK9Ji4g7E4YotKDkRugTVub+v/pIL6B37aL5W0MvgYMoBi9E4X3kB0/x5YCfG4FHUxEkwIog+o3e6kFDxF1ldmOzDYaqsiFCun3avAsmP0Iul6WYL9QjBa47+RpN7c/8gkf+ZnzWc5pwidFB7pfIbRhoPKDZ7INIyQ+bunF7Fdgl08jzYC5iGnNc3PM95/GNDF+aS503zn4HPVyN/0FkbpmWHlaFRH0eXNtcSMPPUTTLgwkmilYlPdKpT3N1IxWoCpRx8hUuLPpSPLxjL0bqlzhzG9qekmrv0sx651rf6ef6hciElJ6sM2bh1IbXqglDkvrWrgtCzisJSlRxZgk4RQ6dvVT5D2IFbgA4YXPfVQS14zm7OARk4P9Je0+A9qL4lt5NdPkWZdltP30LQ3dQLuC3tfr667ne9zZCc2U8PjXnjG2JUnAyAl8lhOjnmMNj8uHk5VpkKb2/tFaTJiYbHWLuTOQItWGSUlEjLbKFKETajX8sT3SI7cLRVnN5u3nw56COlpAeSbVXRWUVScQHF3jDIRNI/HzJifFM7XjeJNMhXp+lGGoW94RrIc39ZsJZZwFELqG6MdNBhi5yVb5lwnOSlxVURw93P0BEk8n2kO6bxVAAt9MBgfsEuYR93w7ywF03rKSAXCEFA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(56012099006)(4143699003)(5023799004)(11063799006)(22082099003)(18002099003)(6133799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eHQ4T1d6RVhnbWd6NGJUVk8rMURpdlZ3ZkRWL2FzUUlTdjYrTHJhZzZFTmVr?=
 =?utf-8?B?UXZlRHpYMktFVjVXRm0yMk5yOHREODV2bTAxWEYwV0ErZEUrUE94OU9Mc0hM?=
 =?utf-8?B?WDlBaUYzZlU0TWMyWmRncmdvNW1vSyswTkJNaTlIU2xOdk9TanRWTk1Pb1Jj?=
 =?utf-8?B?Q1JiNllOMTNZRDZaZVM3eFN5SGF3QmJITHF0dlpSSGNhb3NDNkQxb0xFV0pY?=
 =?utf-8?B?aFI4cXlHNTZocStwK051K0VCZU1kS0s3Z1FrSjhQSDdxMkVFY2xIOHhUZ2V3?=
 =?utf-8?B?OGx0S1dyY213SEgwWDVUVEVkaFVFLytJK000T0hIT0F4VUZ0emJVM21QZHJz?=
 =?utf-8?B?ZWw4dHIxYndFZGlDSXQyWXBOL2pHSTkyZTdtZTR2OGpEUVg5cHVlK01ZdmY1?=
 =?utf-8?B?NDRJVnRwVWd4OWZxQzBxY05TNVdPWVJHT1ZYM2F3bUl2bEpLQktwK2oyZzBI?=
 =?utf-8?B?TXlVS1MyUWI4dlhnSE5wU0ZsY3dMZXJhZThBRlJaT2EyL25BS0R2NWhhdU9a?=
 =?utf-8?B?bFUrQ0gzdE9OaU80ZXZjWSsrTFJxSHNva3FHSlN2MzNpc2NOaWVyYy81MVhm?=
 =?utf-8?B?VE1TMzNFZ3o4TmlnRzZySndGbXk1Tjc0Z0g4cEpvNVdSTmx4SGd2RHNOcDhw?=
 =?utf-8?B?SmxoTmlNb3M2SC9RM2JGdGwxbnF2bG01Z0JONFB4ei9zMWxRS2txaVFwWEdu?=
 =?utf-8?B?REFMT1JCY2FwaTY5UGVSSkhhelRQbUMzR1k4T0szRkdSMVMwVXVJcTNVNFI5?=
 =?utf-8?B?UkNJSVBLVmNGV1NueU4xSjJMdTcvemk0OFJpTFJDUTJZZEppKzE0UmMrVGsy?=
 =?utf-8?B?emtXREVDRDgraE5tcG1sVmcydGdlY1crbzRlenBuYkp2NWVhUGlqNzg3TVNT?=
 =?utf-8?B?RnpIa0J2QnJoR1ZVeHdRVnRHYnpCbXZ1VkZENjE5eVRuMkNpRUlKVXN4S2tU?=
 =?utf-8?B?ZjJvME55dVpOS0xqQmFhRStyQVpRSnE2bjlqYlNvV3FrQlJqdUI0Vml0TXR4?=
 =?utf-8?B?NE9NNnI3VUU1eXk2cmgrNGpic2s4Y1ZmeTgrWFN0T1RLSUUyR3MyU2ZoZUI2?=
 =?utf-8?B?ZS9FWkc5bWpJc1RYeDN3MlEyMVFUNEdyZy9lTXRqMGFoamRTc2xRVWNUTHVo?=
 =?utf-8?B?MTZJM3hDWUd6akV3NVp2Q1JuMFExdlY0QTRIYzFkV1FkcTMrZW1Cb1hJdDZE?=
 =?utf-8?B?MkNpblIzTk4rQlBiQVV3QThseVJ1bWFRZUZOS0xIUXllN044RU5SWi95YXdR?=
 =?utf-8?B?NjAwb2tBR1I1bUhJSzBPVTQzZkltdWtDd1BvTUQ3dG83RERGQTNWWXlxQ0JL?=
 =?utf-8?B?KzV6dXVTYm9ZSjh0UWNURElvSUtzNXhITStTdVJEbnk1RjFJWldZUGovcmgx?=
 =?utf-8?B?cGhYNGh3N1J5RlNNb0dkQ0pidEpKWHRPN0d6dFV3alY0cVQ1b3NoZDNvKzJi?=
 =?utf-8?B?QVUvVmd5NWo2SUx1N00yUS84VkJ3ZDF2dXlRR3dSRmNIVG9XSkdpdWQyTW85?=
 =?utf-8?B?eDJkRm96am5EUnRWdVNsU2h6anQwekxDbDk3SmJidkZLb0JqaWZ4TTd6Rk5u?=
 =?utf-8?B?a08rL3FVQk03Wi9mRmV3VkRNd2paTnMvVWNjdXdDL0EvT0c5aU5KZ0lralpt?=
 =?utf-8?B?LzI0eDQwenIrSTB6b0djRUloenlocSszVXVoOFgySzdxQU9TR2wzVWJ5Um9p?=
 =?utf-8?B?alR4bXpBdUpEdVByN0wvM2c1aldtYll4VEZ3UkJKTDR1aUNtNDd0YkV1K0lj?=
 =?utf-8?B?RlFPVHBUNlZLQ3pyaGxsNW5pd1VEc01RWGUyNlZlajMzNmFWVmdQQkExNzFq?=
 =?utf-8?B?bjkxbDREbWUvRmJSUVRrMzFqL3diUHhVSG5BemtzU0dpYms5dmZWclBMN1pG?=
 =?utf-8?B?OCtMcUgyNCt2MkJ0YThzRHhnYmRUNURhaDlINkJkYUxQb2NZM0lGNEZhZ2NG?=
 =?utf-8?B?VlIwaTBTbzFSUjVidzNxZEpVcnNiMmwveUI4MDFLUUZkNnVXZURpOG9pa1dt?=
 =?utf-8?B?dGVtM2tqU2svWStvYUxWR1lXYkZoejlFb01jckpPYUZPSEVvc2c4OERZWXBu?=
 =?utf-8?B?bU55U2IvWUV1VVI4ODFDS3pYSFdyc3E3cDBIZXcxclU5RGJIOUlOZnJzME1H?=
 =?utf-8?B?VUYzeDJYNy9IYjVFRHE3V0FaYi9oK1dZWlZQeG9HTlNvaU5iczdwOHE2a2tr?=
 =?utf-8?B?cTIzMitLVjBhV1dXYkpDZnpUV2UrQnJLK0Z6UnZDVTR3RGdpeHJvM24raVVK?=
 =?utf-8?B?bUxLcFQrOSs5ZmJkcUd3c25BUjhVUDM2MFFWOWNyUTlXMnoxVUFPN0RHRDJC?=
 =?utf-8?Q?GD/+d+elHAQH0+1rjx?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	dAZVlWtxPvQelFGXA1RVdBs0lDBtA7CZDCiTCOqOR+f6TWsGsZquLsk9P7IZ4IMFf6UZScUc0PoWMgQdwN1W+A6VLm433eajsz9RsB0pYOEw9zWOpWxLcjZtQHR0a39aWBgD6TeEpQE/M5gMD05EteApaY2mTucxdJBdoBiulTmmSBSE/OD1ugL5HYLlaXvYT6zWTWIWMNhP9BYzmVpxE0hkYaQNk6ZiLL0CjNhqzN6Xw8p2xD+WnQCYCVoAjEjk/PxoC+wsiKTPnNoSb5MxKsB0zmvqP0mGHNUURuNUayCfgGGEoG06dBEc5idQbRU2CS9ETHBeNUJnmiijm4qMAQ==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 517f0497-be88-48ca-c22c-08decbdc68cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2026 19:21:04.4303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VvyYLr0WXhXrwDNJmu7nSVdcqcZj9U1AUfhOWNvdsWnHVdW6CkbhmZZ4tcPWcWnf9cKSNfgjyHyZurSvbDUyWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5939
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-4.cisco.com [173.37.147.252];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: alln-l-core-04.cisco.com

T24gRnJpZGF5LCBKdW5lIDEyLCAyMDI2IDM6MTYgUE0sIHNhc2hpa28tYm90QGtlcm5lbC5vcmcg
PHNhc2hpa28tYm90QGtlcm5lbC5vcmc+IHdyb3RlOg0KPg0KPiBUaGFuayB5b3UgZm9yIHlvdXIg
Y29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJldmlldyBmb3VuZCAzIHBvdGVudGlhbCBpc3N1ZShz
KSB0byBjb25zaWRlcjoNCj4NCj4gTmV3IGlzc3VlczoNCj4gLSBbSGlnaF0gU2tpcHBpbmcgV1Eg
Y29weSBjbGVhbnVwIGZvciBpbml0aWF0b3Igcm9sZXMgY2F1c2VzIG1lbW9yeSBsZWFrcyBhbmQg
bW9kdWxlIHVubG9hZCBoYW5ncyB3aGVuIHRoZSBmaXJtd2FyZSByZXNldCB0aW1lcyBvdXQgb3Ig
ZmFpbHMuDQo+IC0gW0hpZ2hdIFVuY29uZGl0aW9uYWwgcHJvY2Vzc2luZyBvZiBgRkNQSU9fTlZN
RV9FUlNQX0hXX0NNUExgIGNhdXNlcyBhIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSB3aGVuIHRo
ZSBkcml2ZXIgaXMgY29uZmlndXJlZCBhcyBhbiBGQyBpbml0aWF0b3IuDQo+DQo+IFByZS1leGlz
dGluZyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIENhbGxpbmcgYHNjaGVkdWxlX3RpbWVvdXQoKWAgaW5z
aWRlIGEgaGFyZCBJUlEgaGFuZGxlciBjYXVzZXMgYSAnQlVHOiBzY2hlZHVsaW5nIHdoaWxlIGF0
b21pYycga2VybmVsIHBhbmljLg0KPiAtLQ0KPg0KPiBjb21taXQgMjNjN2NmNWEyOTllOTgzNWEz
MmExNDYwMjUzN2Y1NzkxYzk0YjE0Yg0KPiBBdXRob3I6IEthcmFuIFRpbGFrIEt1bWFyIDxrYXJ0
aWxha0BjaXNjby5jb20+DQo+DQo+IHNjc2k6IGZuaWM6IFJvdXRlIGNvbXBsZXRpb25zIGFuZCBy
ZXNldHMgYnkgaW5pdGlhdG9yIHJvbGUNCj4NCj4gRGlzcGF0Y2ggRkNQSU8gY29tbWFuZCwgcmVz
cG9uc2UsIGFuZCBJVE1GIGNvbXBsZXRpb25zIHRvIHRoZSBGQ1Agb3IgTlZNZQ0KPiBoYW5kbGVy
cyBiYXNlZCBvbiB0aGUgY29uZmlndXJlZCByb2xlLiBSZWFkIHRoZSBOVk1lIHF1ZXVlLWRlcHRo
IGFuZCB0aW1lb3V0DQo+IHJldHJ5IGZpZWxkcyBmcm9tIGZpcm13YXJlIGNvbmZpZywgY2xlYW4g
dXAgTlZNZSBJL08gb24gZmlybXdhcmUgcmVzZXQsIGFuZA0KPiBza2lwIFNDU0ktb25seSBjbGVh
bnVwIGZvciBpbml0aWF0b3Igcm9sZXMgdGhhdCBhbHJlYWR5IHJlc2V0IGZpcm13YXJlLW93bmVk
DQo+IHJlcXVlc3RzLg0KPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmlj
X3Njc2kuYyBiL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNfc2NzaS5jDQo+ID4gaW5kZXggMDRhYjM4
NDAzM2IxOS4uNWFkNGJiNzE0NDI4MyAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvZm5p
Yy9mbmljX3Njc2kuYw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNfc2NzaS5jDQo+
ID4gQEAgLTczNCw2ICs3MzUsOCBAQCBzdGF0aWMgaW50IGZuaWNfZmNwaW9fZndfcmVzZXRfY21w
bF9oYW5kbGVyKHN0cnVjdCBmbmljICpmbmljLA0KPiA+ICAgICAvKiBDbGVhbiB1cCBhbGwgb3V0
c3RhbmRpbmcgaW8gcmVxdWVzdHMgKi8NCj4gPiAgICAgaWYgKElTX0ZOSUNfRkNQX0lOSVRJQVRP
UihmbmljKSkNCj4gPiAgICAgICAgICAgICBmbmljX2NsZWFudXBfaW8oZm5pYywgU0NTSV9OT19U
QUcpOw0KPiA+ICsgICBlbHNlIGlmIChJU19GTklDX05WTUVfSU5JVElBVE9SKGZuaWMpKQ0KPiA+
ICsgICAgICAgICAgIG52Zm5pY19jbGVhbnVwX2FsbF9udm1lX2lvcyhmbmljKTsNCj4NCj4gW1Nl
dmVyaXR5OiBIaWdoXQ0KPiBUaGlzIGlzIGEgcHJlLWV4aXN0aW5nIGlzc3VlLCBidXQgZG9lcyBj
YWxsaW5nIGZuaWNfY2xlYW51cF9pbygpIGhlcmUgY2F1c2UgYQ0KPiAnQlVHOiBzY2hlZHVsaW5n
IHdoaWxlIGF0b21pYycga2VybmVsIHBhbmljPw0KPg0KPiBUaGUgY29tcGxldGlvbiBoYW5kbGVy
IGlzIGNhbGxlZCBpbiBhbiBhdG9taWMgY29udGV4dDoNCj4gZm5pY19pc3JfbXNpeF93cV9jb3B5
KCkgLT4gdm5pY19jcV9jb3B5X3NlcnZpY2UoKSAtPg0KPiBmbmljX2ZjcGlvX2NtcGxfaGFuZGxl
cigpIC0+IGZuaWNfZmNwaW9fZndfcmVzZXRfY21wbF9oYW5kbGVyKCkgLT4NCj4gZm5pY19jbGVh
bnVwX2lvKCkNCj4NCj4gSW5zaWRlIGZuaWNfY2xlYW51cF9pbygpLCB0aGUgdGhyZWFkIHlpZWxk
czoNCj4NCj4gZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19zY3NpLmM6Zm5pY19jbGVhbnVwX2lvKCkg
ew0KPiAgICAgLi4uDQo+ICAgICAgIHdoaWxlICgoaW9fY291bnQgPSBmbmljX2NvdW50X2FsbF9p
b3JlcXMoZm5pYykpKSB7DQo+ICAgICAgICAgICAgICAgRk5JQ19TQ1NJX0RCRyhLRVJOX0RFQlVH
LCBmbmljLCAuLi4pOw0KPg0KPiAgICAgICAgICAgICAgIHNjaGVkdWxlX3RpbWVvdXQobXNlY3Nf
dG9famlmZmllcygxMDApKTsNCj4gICAgICAgfQ0KPiAgICAgLi4uDQo+IH0NCj4NCj4gWyAuLi4g
XQ0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQpUaGlzIGlzIGEgcHJlLWV4aXN0aW5nIGlzc3Vl
IGFuZCBpcyBvdXRzaWRlIHRoZSBzY29wZSBvZiB0aGlzIHBhdGNoIHNlcmllcy4NCkl0IHdpbGwg
bmVlZCB0byBiZSBhZGRyZXNzZWQgaW4gYSBzZXBhcmF0ZSBkZWRpY2F0ZWQgcGF0Y2ggc2VyaWVz
Lg0KDQo+ID4gQEAgLTE0NTcsMTEgKzE0NjAsMjEgQEAgc3RhdGljIGludCBmbmljX2ZjcGlvX2Nt
cGxfaGFuZGxlcihzdHJ1Y3Qgdm5pY19kZXYgKnZkZXYsDQo+ID4gICAgICAgICAgICAgYnJlYWs7
DQo+ID4NCj4gPiAgICAgY2FzZSBGQ1BJT19JQ01ORF9DTVBMOiAvKiBmdyBjb21wbGV0ZWQgYSBj
b21tYW5kICovDQo+ID4gLSAgICAgICAgICAgZm5pY19mY3Bpb19pY21uZF9jbXBsX2hhbmRsZXIo
Zm5pYywgY3FfaW5kZXgsIGRlc2MpOw0KPiA+ICsgICAgICAgICAgIGlmIChJU19GTklDX0ZDUF9J
TklUSUFUT1IoZm5pYykpDQo+ID4gKyAgICAgICAgICAgICAgICAgICBmbmljX2ZjcGlvX2ljbW5k
X2NtcGxfaGFuZGxlcihmbmljLCBjcV9pbmRleCwgZGVzYyk7DQo+ID4gKyAgICAgICAgICAgZWxz
ZSBpZiAoSVNfRk5JQ19OVk1FX0lOSVRJQVRPUihmbmljKSkNCj4gPiArICAgICAgICAgICAgICAg
ICAgIG52Zm5pY19mY3Bpb19udm1lX2Zhc3RfY21wbF9oYW5kbGVyKGZuaWMsIGRlc2MpOw0KPiA+
ICsgICAgICAgICAgIGJyZWFrOw0KPiA+ICsNCj4gPiArICAgY2FzZSBGQ1BJT19OVk1FX0VSU1Bf
SFdfQ01QTDogLyogZncgY29tcGxldGVkIE5WTWUgRVJTUCAqLw0KPiA+ICsgICAgICAgICAgIG52
Zm5pY19mY3Bpb19lcnNwX2NtcGxfaGFuZGxlcihmbmljLCBkZXNjLCAxKTsNCj4gPiAgICAgICAg
ICAgICBicmVhazsNCj4NCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBEb2VzIHVuY29uZGl0aW9uYWwg
cHJvY2Vzc2luZyBvZiBGQ1BJT19OVk1FX0VSU1BfSFdfQ01QTCBjYXVzZSBhIE5VTEwgcG9pbnRl
cg0KPiBkZXJlZmVyZW5jZSB3aGVuIHRoZSBkcml2ZXIgaXMgY29uZmlndXJlZCBhcyBhbiBGQyBp
bml0aWF0b3I/DQo+DQo+IFVubGlrZSB0aGUgRkNQSU9fSUNNTkRfQ01QTCBhbmQgRkNQSU9fSVRN
Rl9DTVBMIGNhc2VzIHdoaWNoIGNoZWNrIHRoZQ0KPiBpbml0aWF0b3Igcm9sZSwgbnZmbmljX2Zj
cGlvX2Vyc3BfY21wbF9oYW5kbGVyKCkgaXMgY2FsbGVkIHVuY29uZGl0aW9uYWxseS4NCj4NCj4g
VGhpcyBmdW5jdGlvbiByZWxpZXMgb24gbnZmbmljX2ZpbmRfaW9fcmVxX2J5X3RhZygpLCB3aGlj
aCB0ZXN0cyBhIGJpdCBpbiB0aGUNCj4gbnZmbmljX3RhZ19tYXAgYml0bWFwOg0KPg0KPiBkcml2
ZXJzL3Njc2kvZm5pYy9mbmljX252bWUuYzpudmZuaWNfZmluZF9pb19yZXFfYnlfdGFnKCkgew0K
PiAgICAgaWYgKHRhZyA9PSBGTklDX05WTUVfTk9fRlJFRV9UQUcgfHwNCj4gICAgICAgICAhc2Jp
dG1hcF90ZXN0X2JpdCgmZm5pYy0+bnZmbmljX3RhZ19tYXAsIHRhZykpDQo+ICAgICAgICAgcmV0
dXJuIE5VTEw7DQo+IH0NCj4NCj4gSG93ZXZlciwgZm5pYy0+bnZmbmljX3RhZ19tYXAgaXMgaW5p
dGlhbGl6ZWQgZXhjbHVzaXZlbHkgaW4NCj4gZm5pY19udm1lX2Rydl9pbml0KCksIHdoaWNoIGlz
IG9ubHkgZXhlY3V0ZWQgaWYgdGhlIGRyaXZlciByb2xlIGlzDQo+IEZOSUNfUk9MRV9OVk1FX0lO
SVRJQVRPUi4gSWYgZmlybXdhcmUgc2VuZHMgdGhpcyBldmVudCB0byBhIGhvc3Qgb3BlcmF0aW5n
IGFzDQo+IGFuIEZDIGluaXRpYXRvciwgc2JpdG1hcF90ZXN0X2JpdCgpIHdpbGwgZGVyZWZlcmVu
Y2UgdGhlIHVuaW5pdGlhbGl6ZWQgc2JpdG1hcA0KPiBzdHJ1Y3QuDQo+DQo+IFsgLi4uIF0NCg0K
VGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KVGhlIHRlYW0gd2lsbCByZXZpZXcgdGhpcyBmZWVkYmFj
ayBhbmQgZGV0ZXJtaW5lIHRoZSBuZWNlc3NhcnkgY2hhbmdlcyBpbiB0aGUgbmV4dCByZXZpc2lv
biBvZiB0aGUgcGF0Y2ggc2VyaWVzLg0KDQo+ID4gQEAgLTE2NTAsNiArMTY2MywxNSBAQCB2b2lk
IGZuaWNfd3FfY29weV9jbGVhbnVwX2hhbmRsZXIoc3RydWN0IHZuaWNfd3FfY29weSAqd3EsDQo+
ID4gICAgIHVuc2lnbmVkIGxvbmcgc3RhcnRfdGltZSA9IDA7DQo+ID4gICAgIHVpbnQxNl90IGh3
cTsNCj4gPg0KPiA+ICsgICAvKg0KPiA+ICsgICAgKiBDbGVhbiB1cCBhbGwgb3V0c3RhbmRpbmcg
aW8gcmVxdWVzdHMuIEZvciBGQyBpbml0aWF0b3Igb3IgTlZNRQ0KPiA+ICsgICAgKiBpbml0aWF0
b3Igd2UgaXNzdWUgZmlybXdhcmUgcmVzZXQgYmVmb3JlIHRoaXMgYW5kIGFsbCBJL09zIGFyZQ0K
PiA+ICsgICAgKiBhbHJlYWR5IGZyZWVkDQo+ID4gKyAgICAqLw0KPiA+ICsgICBpZiAoSVNfRk5J
Q19GQ1BfSU5JVElBVE9SKGZuaWMpIHx8DQo+ID4gKyAgICAgICBJU19GTklDX05WTUVfSU5JVElB
VE9SKGZuaWMpKQ0KPiA+ICsgICAgICAgICAgIHJldHVybjsNCj4gPiArDQo+DQo+IFtTZXZlcml0
eTogSGlnaF0NCj4gRG9lcyB0aGlzIGVhcmx5IHJldHVybiBjYXVzZSBtZW1vcnkgbGVha3MgYW5k
IG1vZHVsZSB1bmxvYWQgaGFuZ3MgaWYgdGhlDQo+IGZpcm13YXJlIHJlc2V0IHRpbWVzIG91dCBv
ciBmYWlscz8NCj4NCj4gSWYgZm5pY19mY3Bpb19yZXNldCgpIHRpbWVzIG91dCB3aGlsZSB3YWl0
aW5nIGZvciBjb21wbGV0aW9uLCB0aGUNCj4gZm5pY19mY3Bpb19md19yZXNldF9jbXBsX2hhbmRs
ZXIoKSBpcyBuZXZlciBpbnZva2VkLCBhbmQgdGhlIElPIGNsZWFudXANCj4gZnVuY3Rpb25zIGFy
ZSBza2lwcGVkLg0KPg0KPiBCZWNhdXNlIGZuaWNfd3FfY29weV9jbGVhbnVwX2hhbmRsZXIoKSBu
b3cgdW5jb25kaXRpb25hbGx5IHJldHVybnMgZWFybHkNCj4gaW5zdGVhZCBvZiBhY3RpbmcgYXMg
YSBmYWxsYmFjayB0byBjb21wbGV0ZSBwZW5kaW5nIGRlc2NyaXB0b3JzIHdpdGgNCj4gRElEX05P
X0NPTk5FQ1QsIGl0IHNlZW1zIGFsbCBvdXRzdGFuZGluZyBJT3Mgd291bGQgYmUgbGVha2VkLiBU
aGVpcg0KPiBjb21wbGV0aW9uIGNhbGxiYWNrcyBhcmUgbmV2ZXIgdHJpZ2dlcmVkLCB3aGljaCBw
ZXJtYW5lbnRseSBibG9ja3MNCj4gc2NzaV9yZW1vdmVfaG9zdCgpIGR1cmluZyB0ZWFyZG93bi4N
Cj4NCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KVGhlIHRlYW0gd2lsbCByZXZpZXcgdGhpcyBm
ZWVkYmFjayBhbmQgZGV0ZXJtaW5lIHRoZSBuZWNlc3NhcnkgY2hhbmdlcyBpbiB0aGUgbmV4dCBy
ZXZpc2lvbiBvZiB0aGUgcGF0Y2ggc2VyaWVzLg0KDQo+IC0tDQo+IFNhc2hpa28gQUkgcmV2aWV3
IMK3IGh0dHBzOi8vc2FzaGlrby5kZXYvIy9wYXRjaHNldC8yMDI2MDYxMjE4MDkxOC44NTU0LTEt
a2FydGlsYWtAY2lzY28uY29tP3BhcnQ9Nw0KPg0KDQpSZWdhcmRzLA0KS2FyYW4NCg==
