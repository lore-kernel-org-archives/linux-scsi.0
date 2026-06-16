Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4F63845C4
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 05:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781586915; cv=fail; b=KQCJWPzTb0TdfQX9P3uEJ4oNWgUIaUP3uUFZi1S/ScpObOslgIXYYJf9IS7Mo8Dl5FZeoNwt+YBGOXuejBLiI3vQbUlXCVIVUHovZJkJqbVEeXbfJKYcgc9QoJ/mPYaR8/EZRfP/sy9kYSd3z7lEtOtxc2C2zT5I/Tu/EUMXsfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781586915; c=relaxed/simple;
	bh=p72r261LXbnRkSHICEVfZ9YqTVDXiREgyWlQVu9ZYVM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Oyf7ixTdDJHns8NuSm5bhLM2PKUB1G50CyMP+aAlCVSl7m35N7sLtyVvdbxqJm4xMUm1NL819LxEiJsoYu38wnyJF9LzZVdBUdhtPXukV7N/Af6PIb6m0kdn0C33bIJmdqUw2m6/KLlNJENTffUBX4Dxp5YAJuHHJfAG8EV3lKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=cZG72e4P; arc=fail smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="cZG72e4P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=6998; q=dns/txt;
  s=iport01; t=1781586913; x=1782796513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p72r261LXbnRkSHICEVfZ9YqTVDXiREgyWlQVu9ZYVM=;
  b=cZG72e4P7thxH6WfO96vRSaTY9+m/6qVkD+tej38RGbNfiKXDuID8rZH
   Fv28CWyJPpkrqhokGJv1eo8ukVU4XBPgm7YluF39WdGuusct6+mJcVxGx
   JwVcP7ZbxKr5MIr7GWsKoeH+nv/0HVYo8ZwTZRYdlDTbPWJ5GzO48/r22
   YTtMHaCF67j9mDonneDgM9fHzmKqlpkD4LlM1KWvR4oSHTkYSoePgTsQX
   ZaXZb6bfjAUltuV4rKo5GTVLCAuRrj8WXXqHdXssYgRL+smCC1oirQIPO
   f4dl4JFAdvW9pOg0jSI153f/InRzWT2r9x9Puqm41OE1p26GxbFoOEmis
   Q==;
X-CSE-ConnectionGUID: mM7Ia6nJT7eQp4vC/7Xl5w==
X-CSE-MsgGUID: wBgn67KUQF+n16WmB5Rbjw==
X-IPAS-Result: =?us-ascii?q?A0ApAABs2zBq/4wQJK1aHAEBAQEBAQcBARIBAQQEAQFlg?=
 =?us-ascii?q?QYQBgcBAQsBgWkqKYIrSYgjA4RNX4h5A4ETnQiBfg8BAQENAlEEAQGFBgKNP?=
 =?us-ascii?q?wImNAkOAQIEAwIDAQEBAQEBAQEBAQEBCgEBBQEBAQIBBwWBDhOGUAyGWgEBA?=
 =?us-ascii?q?QEDEhUTNgkQAgEIGB4QMSUCBA4FCBqCCINMAwECpgcBgT0Ciip4gQEzgQG6F?=
 =?us-ascii?q?xWBOAGIWgGFdjiERCcbgg2BFUKCMTg+hEWEE4IwBIINFYEMhEKGIoYvUngcA?=
 =?us-ascii?q?1ksAVUTFwsHBYEjQwMqLy0jSwUtHYEjIR0XFh5YGwcFEiAqQkUjAwIWM1lCO?=
 =?us-ascii?q?AtDBYFdAoIaTiMfAzl/gW+BJWdmFTA1gQEBER8KOgMLbT03FBsDBIE1BYxbF?=
 =?us-ascii?q?w+CLWohCR44NAJCFh9GKBYmlhibC5UXCoQdohEXhASUF5JRmQgjoxs/hRoCB?=
 =?us-ascii?q?AIEBQIQAQEGgWg8gVlwFTuCZ1MZD44qGcoAeT0CBwIHDgMLkWotgU4BAQ?=
IronPort-PHdr: A9a23:QsoTphOoFNyf2WCmP7Ql6nc2WUAX0o4cdiYc7p4hzrVWfbvmpNLpP
 VfU4rNmi1qaFYnY6vcRk+PNqOigQm0P55+drWoPOIJBTR4LiMga3kQgDceJBFe9LavCZC0hF
 8MEX1hgl0w=
IronPort-Data: A9a23:cn+yn6P+oP4RrE3vrR3wlsFynXyQoLVcMsEvi/4bfWQNrUon1TJWm
 GVMCz+OaauJazbxKI1ya47j80sFvZOHytJmHXM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeap1yFjmB+0rF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WV/lV
 e/a+ZWFZgf7gmMsaAr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj6/BLU2A/Y4s6xrl6OHkS6
 9dfdwAJMw/W0opawJrjIgVtrs0nKM+uOMYUvWttiGmCS/0nWpvEBa7N4Le03h9p2ZsIRqiYP
 pRfMGY3BPjDS0Un1lM/C5skgOasj3rXeDxDo1XTrq0yi4TW5FMugeezaYGLI7RmQ+1KtEme+
 D3lwl3XQRdDauOa42e/+HCz07qncSTTHdh6+KeD3vprhkCDg3cYExw+S1S2u7+6h1S4VtYZL
 FYbkhfCtoA78EitC924VBqirTvc5VgXWsFbFKsx7wTlJrfo3jt1z1MsF1ZpQNcnr8QxAzct0
 ze0cxnBXG0HXGG9IZ5FyoqpkA==
IronPort-HdrOrdr: A9a23:gbwg9qjOQFEcFV81rxwR2rjC3nBQX9V23DAbv31ZSRFFG/FwyP
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
X-Talos-CUID: 9a23:fuG85Gxja7xLcxPPq7tEBgURP58EeyPb7kuPLnagVXhCD+KlTQKPrfY=
X-Talos-MUID: 9a23:QVSnVQpHp9McTK67cgEezy5IO8E2vIeTMW5Ol8xYhMyuaBZ6OSjI2Q==
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-03.cisco.com ([173.36.16.140])
  by alln-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2026 05:14:57 +0000
Received: from alln-opgw-3.cisco.com (alln-opgw-3.cisco.com [173.37.147.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-03.cisco.com (Postfix) with ESMTPS id AECAD1800127E
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 05:13:49 +0000 (GMT)
X-CSE-ConnectionGUID: /7nkSjO6SA2uf2+HJtvmrA==
X-CSE-MsgGUID: XHIic1gtT6mE/8KIO49A3w==
Authentication-Results: alln-opgw-3.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.24,207,1774310400"; 
   d="scan'208";a="56659560"
Received: from mail-northcentralusazon11012052.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.52])
  by alln-opgw-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2026 05:13:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oY/1LGKIZrVlgiGQwm4cZn9Z0jmOmt5HoIoRS7kkDkh8MRO9jLtG2iFs4bWB8L7NTMhXbbTe5EC8RVjdD5Oh4y98PNXSzMyan0s05WmMSWh/EhKgWbUg7DM3zWFFOK6DI5fUYDO0TBenJbMS23HYynETvKLV4bbvpfdPxro2MajpNq3wQjJkbO6h9G4MQFbsVLD97DRHIi1a1tkS1eKwAR4y0BpStpORyGiUH6EbD3jaVnQSGjQzPu9euL4kye5ObDRXoXX5Kkj1ugo5HtC3j/+ttgWCsj7QD36GnhhGaP3+2w7raxoHj5T0lHXQmpVF299qeDqyKE5zJC8lEQVdxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p72r261LXbnRkSHICEVfZ9YqTVDXiREgyWlQVu9ZYVM=;
 b=ua2iKIr/3X7jZzBpON1LeF1KHs1NAwrid+w2UNFcqFY41yzXJ1cPx9nK/QYoN51hD961TI0pqDLw3h7hoQLKC7EgszJ5uuI4PqGxYmw/5bURtoiDbSpCyCYXurAFDA2cAjDLt687rI5nJoXoCbwQ0kVbhdvt0IMHrgJT9CVLMBt8nMQGOsec90MVZYZdx0P0gU9kZxBQV4sVCDoP/scG1u9Os839P6SdHz2G+AJqeWAGoIov1wHAkgbZ7KwEEjO94q5gQH+3ItRAKcwnT6D8B8J5pfxQVwkKXsc19PLdX27drGa5JpGzlQkLG++8aS0437y2uuEpmNFhDKLydQ2OjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SJ0PR11MB5088.namprd11.prod.outlook.com (2603:10b6:a03:2df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 05:13:47 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%3]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 05:13:47 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar
 Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy (arulponn)"
	<arulponn@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Arun
 Easi (aeasi)" <aeasi@cisco.com>
Subject: RE: [PATCH v4 01/13] scsi: fnic: Make debug logging protocol
 independent
Thread-Topic: [PATCH v4 01/13] scsi: fnic: Make debug logging protocol
 independent
Thread-Index: AQHc+pa5ZO+HemQVgk6EjyVqD39z37Y7QUcAgAUK8KA=
Date: Tue, 16 Jun 2026 05:13:47 +0000
Message-ID:
 <SJ0PR11MB58965CACD5121D86A11CBEA4C3E52@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260612180918.8554-2-kartilak@cisco.com>
 <20260612184233.1FDAB1F000E9@smtp.kernel.org>
In-Reply-To: <20260612184233.1FDAB1F000E9@smtp.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SJ0PR11MB5088:EE_
x-ms-office365-filtering-correlation-id: f21f77e6-3034-4eea-48b3-08decb660b65
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|22082099003|18002099003|4143699003|11063799006|56012099006|6133799003;
x-microsoft-antispam-message-info:
 ZIMZGf4oKrPyCEjkB8QrVJJ1EyM2BWvsafZQjX1yEXIDprwzIMfAECoNBvnkhVlkxya6iRFUuwGB13OUBlTobSSz0sn/LpoREHOwAM7vJZ6BMN6TuM01vX8brZZNL5xv0pgYJGL6z+19iJUlMDilJB7IVs25TsjR59eA3ETcg+0LGsDQk38FDU0GHq3mL8Cfw9DABZsebGeSUoWWboE9Reu93QtNX6wi1CPplm5MP7G8bjTvqZfs1W/3iahxRQQIh7g/paFf6x8i6ALI1M+cUnLC7NIRp8mYNbdm06eTRMY3I9UuNkB1qyjE9pIjL/QOh/3hAFFnyJKBS3mBtH0Ali1h/RwmdY0LylbzqgBzyvGwQ0FlYOc5gdDANPsgkzAo6OxyAJGjvBzY8QG6HD/hRvYZlD8dLz2VaU81Rmhylg154099EVYSbVuJJE9O9mtictce4aHt33ktVx0ADJykvbJGevshkfz4kNu+YpGd1ypWgeW69d2AdxoKzxh92ce+z4pcLW4wNwogomXoGlimLSdEAHgn11FR9CgPkO6VzcoNbTXETECFTTYwhT89xk1L+jnMtS0uHd7dy+43IO4AVYNuEocV0UeM7mcE0Xnc153X8yfLAA/ga8wDW0RulIOtiGmLTOEmYuq6F5VJez0u3uYtMD1sxZ+wTIgk91qo5KV9ocZAZhtB2iH+ijSk0tGY5ADYmTOyIQcRIzRrpisf5V8eFWHuGsBX3071qj0ZHxEI68MqLEtcmLyUfKBwlMIz
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ZQJRSOJ/edNFPJqlot+1al7UAqGprfl6YpftudXcDQGF1lLQjbKKbefov2F4?=
 =?us-ascii?Q?KNF+FhshgScTvyZr9BkbBi7UOLjtYuEKHx7Iu9XRXeach0ln+oz1x3MLJBpv?=
 =?us-ascii?Q?MBJw9DEuulVYTMS1i9yWldvTv/SFa6h/7BL3thKHPlSsdV2VAkEiUCDwDbsd?=
 =?us-ascii?Q?SMQoV77gVc5t5Sq8vR+YQ10zC32mYv3bwa3EsSOTZKwIRNp1MPaXejhSH326?=
 =?us-ascii?Q?iChskjWsqrRyTz1BfrV+zmUklbwdiH7YvmeKLudnjEL7HmN6s3b/JLD/oVL6?=
 =?us-ascii?Q?RQENJ4/RFL8jsDYBWtSQCrMF1UYkT0N9vjy9P2aqBD6x19eeMi8Ip/j2QGxa?=
 =?us-ascii?Q?dh+74Ci19UICMRdppk2JS+K9mYQH4Apcg6TBtOz1uF8jzDoMf5ddWx21pHqt?=
 =?us-ascii?Q?68jY6LSi16oHq+tKAQ2De8gVRB/3LKFepgnyMtWuoKUoC4K+v9vhM6PHsitw?=
 =?us-ascii?Q?+vDK08GZQDbWclRqU5h6csi80eweAMbChPNjdXlA8PEoIBxDBorPSSeKkUp2?=
 =?us-ascii?Q?Gt0rbiIFCKSInX4iavJf+Hsdg45gBrlk1kJ0QPgBahYqGFNKiqzCSyva8l34?=
 =?us-ascii?Q?N/CAnSHUZciLM2FTTcvE5qz1MPB0NiEHdtSJsbaYP2xkPzB/iH0iqF6ShaFz?=
 =?us-ascii?Q?CKcXaG92vFRdDdPF8j6AhqgJfu62QnfxpBS22DxifDF7tmuIVjLVaqUw7iSQ?=
 =?us-ascii?Q?UYY1BQngfakr2t1OJ3M28W5mv6McI8M6rCfuypaUfs14Go/eQuw/oQUh+T54?=
 =?us-ascii?Q?yPxTXNbNWQvM4d36QMzXzG70lmQl6fxq4KsIAI2nqfY8mCeGIv05R6EJzNQD?=
 =?us-ascii?Q?yE5ojtVaeytCp7SQBKzzK3DtfIfZiNIqm8n4GTt8m0Wk/sUkoai1H28x1X4l?=
 =?us-ascii?Q?3JIO8dfr9EEvC6Td+BxIqPLQRMfbUw5BQ4IgRfjEYHhdsd3MLPs7behvo4Db?=
 =?us-ascii?Q?Cw0fEujcnDkjtJErvlgo/Xm/yz2tTaDuokI5zVYuJnW8YmCP+nLfLbo4My9D?=
 =?us-ascii?Q?Z9rPbRPLxjerr3UnM3AYItZzE9rH+/0ck9EfQBm8WSY6Uopj9EGLZWTYS6a6?=
 =?us-ascii?Q?RQJK8a8lGuOGiyRFnIEWdjU5SuTs0U2QGLb8+OoqPH8YOl/0ZLq1agLLrVWg?=
 =?us-ascii?Q?43yKp9eZUZt4E0xJBlO4NcqLchle6tQw2mBTHQxqkZKWmvgeB6U+gcPzx7ar?=
 =?us-ascii?Q?oc2QTN2oiosHLoW9op9OThZ8p6M8Uj3LFWV3ZBrc8BeAmJxdUfZrEYj6SugV?=
 =?us-ascii?Q?DmVIJW95fkaSP8cVEHgAwCiNmyhpmAD4sE0ZBQtFwtd1EvbPmJloGM2mjKTw?=
 =?us-ascii?Q?ZHDtDYYGE038qzpU8vp3ET3Sq0WVxHxzBQ0P6+Z2QYwKxH0hwnTKkJLgC2e7?=
 =?us-ascii?Q?lzn2YoupQR9XWWACxV+ZfqYqB19kBzUp++hrq5FNH6VNzhPv4qIpbMTpVvoj?=
 =?us-ascii?Q?Y4M5eT2lkhud6fGZLjDe7VuY+K3ny7JNqzJLOT1caC2E+OkPhmmqCAi5yKl2?=
 =?us-ascii?Q?Tdh8asfjjEyr2xhE0M3bFV8pAqvyPsI/xVIdWTPR3/wghxBkJn5dx3Z/C/X5?=
 =?us-ascii?Q?dEa/QHnodPbx7tm+pEATd8rdWZslCaqORZ6XFtEWjzPR7whxw6oOvd55jSPS?=
 =?us-ascii?Q?GBJInyYcKXslJ5ByYumxnHVPol8gK+xeoViWo7c7b0a4p62ahEU7o5dk3jc8?=
 =?us-ascii?Q?Q41DYV5vRQYyrMW0h/Jq1tR3VIoBU6og+QCOUrq9jVV5FrxD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	SJ7rKzG8vjSHoMePTNWkXC07e/JArW5yHzWuE7kxnGPFGSNi+vPQaMeaK9IC4fnIFyDONXTh1pY0MHxveAOLJYRzWZBHGDE0ZiajF/7VG71O/Gzy2VqpzlRHfrVTX9BTl6J6gfkExpsB2I6ut+QAkRyo/vNMBERUINIyHTqj7xB6QXFQ/OQ50/w4cIePJd9hlpZdJJJbsVCtXPnlT6eZixydJ+r5pxV5Jy7al0wIDeASmevsyww5DdbCx7TN4O+mGfChV9VIDHHoQoK/fAWDoV4724rY0ppE5BaugwC6E8CadsAsNzfBi0hpSiClPyje9Q1zYWGYSrI9nv9DsyRFww==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f21f77e6-3034-4eea-48b3-08decb660b65
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2026 05:13:47.1391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P+vl4gM4CXLEvPYJGeJCvtLvLs/uUYpwVn8k48cC6aAC1hmOmCYLcOk0xFxQ1tyj8rqs4T+m+XpvUXEhCRrVOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5088
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-3.cisco.com [173.37.147.251];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.251, alln-opgw-3.cisco.com
X-Outbound-Node: alln-l-core-03.cisco.com

On Friday, June 12, 2026 11:43 AM, sashiko-bot@kernel.org <sashiko-bot@kern=
el.org> wrote:
>
> [Severity: High]
> This is a pre-existing issue, but does this logic permanently halt alloca=
tion
> if it reaches the end of the pool? If find_next_zero_bit() starts at
> oxid_pool->next_idx and reaches FNIC_OXID_POOL_SZ, it appears to return a=
n
> error rather than wrapping around to index 0 to search the rest of the
> bitmap. Because next_idx is not advanced on failure, all subsequent
> allocations might search the same empty tail and fail indefinitely.

Thanks for the review.

This appears to be a pre-existing issue and is not introduced by this patch=
.
Since this patch only updates the debug logging interface, addressing this
issue is outside the scope of this series.

A fix can be considered separately in a dedicated patch series.

>
> [Severity: Medium]
> This isn't a bug introduced by this patch, but does returning false here
> leak the tport structure? If kzalloc_obj() fails, the target port remains
> in the iport->tport_list despite being marked OFFLINING and TERMINATING.

Thanks for the review.

This appears to be a pre-existing issue and is not introduced by this patch=
.
Since this patch only updates the debug logging interface, addressing this
issue is outside the scope of this series.

A fix can be considered separately in a dedicated patch series.

>
> [Severity: High]
> This is a pre-existing issue, but are we leaking control frames if the
> transmission fails? In fdls_send_tgt_plogi(), fnic_send_fcoe_frame() is
> called right after this debug statement, but its return value is ignored.
> If the underlying DMA mapping or workqueue is full, does the allocated
> mempool frame stay permanently leaked?

Thanks for the review.

This appears to be a pre-existing issue and is not introduced by this patch=
.
Since this patch only updates the debug logging interface, addressing this
issue is outside the scope of this series.

A fix can be considered separately in a dedicated patch series.

>
> [Severity: High]
> This isn't a bug introduced by this patch, but does the payload parsing r=
ead
> out of bounds here? Earlier in fdls_process_gpn_ft_tgt_list(), len is
> adjusted by subtracting the FC and CT headers, but rem_len is initialized=
 to
> the original unadjusted len. Does the while (rem_len > 0) loop process ex=
tra
> bytes past the end of the packet if the FC_NS_FID_LAST bit is missing?

Thanks for the review.

This appears to be a pre-existing issue and is not introduced by this patch=
.
Since this patch only updates the debug logging interface, addressing this
issue is outside the scope of this series.

A fix can be considered separately in a dedicated patch series.

>
> [Severity: High]
> This is a pre-existing issue, but could this loop trigger a use-after-fre=
e?
> The list_for_each_entry_safe() loop caches the next pointer. However,
> fdls_delete_tport() intentionally drops the fnic->fnic_lock internally.
> While the lock is dropped, can a concurrent event delete the cached next
> element from the list?

Thanks for the review.

This appears to be a pre-existing issue and is not introduced by this patch=
.
Since this patch only updates the debug logging interface, addressing this
issue is outside the scope of this series.

A fix can be considered separately in a dedicated patch series.

>
> [Severity: High]
> This is a pre-existing issue, but does this code trust the RSCN payload
> length blindly? The rscn_payload_len variable is read directly from the
> network packet without validating it against the actual received buffer
> length. If a spoofed frame specifies a large length, does this loop read
> out-of-bounds?

Thanks for the review.

This appears to be a pre-existing issue and is not introduced by this patch=
.
Since this patch only updates the debug logging interface, addressing this
issue is outside the scope of this series.

A fix can be considered separately in a dedicated patch series.

>
> [Severity: High]
> This is a pre-existing issue, but can this loop run infinitely if
> vlan_desc->fd_desc.fip_dlen is 0? The while (desc_len > 0) loop would
> fail to advance cur_desc or decrement desc_len. Because this function run=
s
> with interrupts disabled (spin_lock_irqsave), could a maliciously crafted
> zero-length descriptor cause a hard lockup?

Thanks for the review.

This appears to be a pre-existing issue and is not introduced by this patch=
.
Since this patch only updates the debug logging interface, addressing this
issue is outside the scope of this series.

A fix can be considered separately in a dedicated patch series.

>
> [Severity: High]
> This isn't a bug introduced by this patch, but does the FIP parsing read
> out of bounds here? At the start of fdls_fip_recv_frame(), the packet len=
gth
> appears to be hardcoded to 2048 instead of using the actual received fram=
e
> size. If a packet declares large descriptors but the actual payload is sm=
all,
> would parsing read past the end of the buffer?

Thanks for the review.

This appears to be a pre-existing issue and is not introduced by this patch=
.
Since this patch only updates the debug logging interface, addressing this
issue is outside the scope of this series.

A fix can be considered separately in a dedicated patch series.

>
> [Severity: High]
> This is a pre-existing issue, but is the shared fip_timer_work susceptibl=
e
> to workqueue corruption? It appears that fnic_handle_fip_timer() and
> fnic_handle_fcs_ka_timer() unconditionally call INIT_WORK on
> fnic->fip_timer_work before queuing it. If these fire concurrently or if =
one
> queues the work while it is already pending/executing, does INIT_WORK
> corrupt the active work_struct linked list pointers?

Thanks for the review.

This appears to be a pre-existing issue and is not introduced by this patch=
.
Since this patch only updates the debug logging interface, addressing this
issue is outside the scope of this series.

A fix can be considered separately in a dedicated patch series.

>
> [Severity: High]
> This is a pre-existing issue, but does fnic_remove() tear down resources
> safely? During driver teardown, fnic_remove() frees the fnic structure bu=
t
> fails to cancel oxid_pool.oxid_reclaim_work,
> oxid_pool.schedule_oxid_free_retry, and iport.fabric.retry_timer. If any =
of
> these delayed works or timers fire after teardown, could they execute the=
ir
> callbacks and access the freed fnic structure, causing a use-after-free
> crash?

Thanks for the review.

This appears to be a pre-existing issue and is not introduced by this patch=
.
Since this patch only updates the debug logging interface, addressing this
issue is outside the scope of this series.

A fix can be considered separately in a dedicated patch series.

Regards,
Karan
