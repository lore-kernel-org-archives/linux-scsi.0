Received: from alln-iport-7.cisco.com (alln-iport-7.cisco.com [173.37.142.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D7426FA50
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 18:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769193535; cv=fail; b=oaa/xDyERiZIu2dqGGSnWjqslMJmIr6ym3hbFbLztBi2UZvTl2T247Uw1akYpZD5kDqmNEbhU9252693Ap1ZGcFrEz79/QSLh4G7P4x1AoQU8tUTusKwIHgbhu/muD8JfHuOBPkANQXKyEmaMkKm1tjpEvWHh3cG5fY9XndXhKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769193535; c=relaxed/simple;
	bh=5DzK79gj095kx/rj5f4UgLVJqwlE6GZIU/udADIDrlY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AJHa0DKz6NZ3q1mPpOAAipSYAqwnicslSHl1/kZBr4nJWb35GYaQoYvFIFnSgfixWyoEfp1CjrYplenkmMEJiefp2+We8mVudG5BGXgM4H1KjB0BI+P+vp8/Tvmml7NTUqJ3vVva3Z5SgynDYWezQJ+N4/9BTHNY3ZNgO7Jr3cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=khRSHdNY; arc=fail smtp.client-ip=173.37.142.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="khRSHdNY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=10604; q=dns/txt;
  s=iport01; t=1769193533; x=1770403133;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5DzK79gj095kx/rj5f4UgLVJqwlE6GZIU/udADIDrlY=;
  b=khRSHdNYYTilgkmKFqzMb4WgpRkDgyWZLlksU60KZlHjQvi5OQ5gwzeU
   g77b8Y9ZOrGiLcVVp8eDnFfMlhWox/dYXh5v+NhEjIgFCwUm1FsENCZC0
   72EtwTEBpO91XidJCY5WPtKpigsvWoJraaeLLqCOkEXDXaD7zVCFaan47
   WSF3JcCQcEW9o0vlbepv6w7pQ6Mqao5/GqWrnPdNuc8AB2NjFs5pMbIRI
   TxOyEFIqOrE4RffMy2yU+JGNdDxBFaWCm8MB2skLASVPn7uitr7vy75Vh
   cpHQVpbVMucxwlNBr1vHwYPtUJ6RhdWy3C0oizYKMbiYfAzaGlWb9Iurk
   w==;
X-CSE-ConnectionGUID: PB7Mq6+NRV6XEtoO8pz0zw==
X-CSE-MsgGUID: ODrEWBHxQziZMqng4bI9WA==
X-IPAS-Result: =?us-ascii?q?A0BPAADJvnNp/43/Ja1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAUAlgRoDAQEBCwGBbVMHgiFJhFeDTAOFLIZYgiEDoBkPAQEBDQJRBAEBg?=
 =?us-ascii?q?hOCdAIWjHUCJjcGDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFg?=
 =?us-ascii?q?Q4ThlyGWgEBAQECARIRBA1FBQsCAQgOCgICJgICAi8VEAIEDgUIEweFLScDA?=
 =?us-ascii?q?QKkeQGBQAKKK3p/M4EB4C4UAYEKLgGIUgGBb4QAG4RdJxuCDYEUAUKBZoECP?=
 =?us-ascii?q?oQtGBWDRDqCLwSCIoEOi10Ggg6GFQlJeBwDWSwBVRMXCwcFYUJDA4EGI0sFL?=
 =?us-ascii?q?R2BIyEdFxMfWBsHBRMjMQYZBhwSAgMBAgI6UwyBdQICBIITe4IBD4cEgQAFL?=
 =?us-ascii?q?m8aDiICLBU3BCMsAwttPTcUGwMEOnsFjmdEgi4BKgdeGyd5bRYgRJJPFAcCA?=
 =?us-ascii?q?T+CbEmMJ4NWn1kKhByiDheBH4JljROZVJkGpUMxgyICBAIEBQIQAQEGgX4mg?=
 =?us-ascii?q?VlwFYMiUhkPji0Wx0J4PAIHAQoBAQMJkWuBfAEB?=
IronPort-PHdr: A9a23:3k0IhBTwZ9lxYnQqVONqK/PdDNpso47LVj580XJvo7tKdqLm+IztI
 wmDo/5sl1TOG47c7qEMh+nXtvX4UHcbqdaasX8EeYBRTRJNl8gMngIhDcLEQU32JfLndWo7S
 exJVURu+DewNk09JQ==
IronPort-Data: A9a23:L+PtWK2+8TvSuvzbf/bD5YZwkn2cJEfYwER7XKvMYLTBsI5bp2ECz
 TMeWT/TP67cMWqmeI13boy+8E9TuMfTzddlHVE/3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmH4E/xbtANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXX4
 Lsen+WFYAX7g2cuaTpNg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGNGtpGJRGucBNPz9+2
 OAfD2AVfEiRmLfjqF67YrEEasULNsLnOsYb/3pn1zycVapgSpHYSKKM7thdtNsyrpkRRrCFO
 IxDNGcpNUiZC/FMEg9/5JYWn+6ymnj7ej5wo1OOrq1x6G/WpOB0+OaxYIOEKo3aGq25mG6/i
 njrwE7ZEigINe660DyKrniN19DmyHaTtIU6UefQGuRRqFmSwHEDTQYdTlqTv/a0kAi9VshZJ
 khS/TAhxZXe72SxRdX7Ghn9q3mes1tEB5xbEvYx70eGza+8DxulO1XohwVpMbQOnMQ3Xjctk
 FSOmrvU6fZH6tV5lVr1Gm+okA6P
IronPort-HdrOrdr: A9a23:bOTN3a6ZdHHBVPCY+APXwYeCI+orL9Y04lQ7vn2ZFiYlEfBwxv
 rPoB1E737JYW4qKQ8dcLC7VJVpQRvnhPhICPoqTMaftW7dySSVxeBZnMffKlLbalfDH4JmpM
 Ndmu1FeaLN5DtB/IjHCWuDYqsdKbC8mcjC65a9vhJQpENRGt1dBmxCe3+m+zhNNXJ77O0CZe
 KhD6R81l2dUEVSRP6WQlMCWO/OrcDKkpXJXT4qbiRM1CC+yRmTxPrfCRa34jcyOgkj/V4lyw
 f4uj28wp/mn+Cwyxfa2WOWxY9RgsHdxtxKA9HJotQJKx334zzYJLhJavmnhnQYseuv4FElnJ
 3nuBE7Jfl+7HvXYyWcvQbt4Q/9yzwjgkWSimNwwEGT4/ARdghKT/aptrgpNScxLHBQ+u2U5Z
 g7ml5xcaAnVC8o0h6Nv+QgHCsa5nZc6UBS4tL7yUYvELf3rNRq3NYiFIQ/KuZaIAvqrI8gC+
 VgF8fa+bJfdk6bdWnQui11zMWrRWlbJGbMfqEugL3d79FtpgEw82IIgMgE2nsQ/pM0TJdJo+
 zCL6RzjblLCssbd7h0CusNSda+TjWle2OADEuCZVD8UK0XMXPErJD6pL0z+eGxYZQNiJ8/go
 7IXl9UvXM7P0juFcqN1ptW9Q2lehT2YR39jsVFo5RpsLz1Q7TmdSWFVVA1isOl5+4SB8XKMs
 zDTq6+w8WTWlcGNbw5qzEWAaMiW0X2ePdlz+oGZw==
X-Talos-CUID: =?us-ascii?q?9a23=3ANI/zg2r6Xz13UsxG9TWvqmnmUfgPLVjEkjT2GXH?=
 =?us-ascii?q?mOUt1T5rFUU3I6rwxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AcHpDgg+RgKWmP/aaEs24aJCQf+BE+YmRImAdqIc?=
 =?us-ascii?q?HieydMyMsMRbMsx3iFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-04.cisco.com ([173.37.255.141])
  by alln-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 23 Jan 2026 18:37:44 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-04.cisco.com (Postfix) with ESMTPS id D675E180005D9
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 18:37:43 +0000 (GMT)
X-CSE-ConnectionGUID: 6gm8zvVtRNabgtJZx5LZxA==
X-CSE-MsgGUID: FB1bsB3+R9CCUVfSOc8pHw==
Authentication-Results: alln-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.21,248,1763424000"; 
   d="scan'208";a="63644800"
Received: from mail-dm2pr0701cu00103.outbound.protection.outlook.com (HELO DM2PR0701CU001.outbound.protection.outlook.com) ([40.93.13.67])
  by alln-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 23 Jan 2026 18:37:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qDPCwu38PEwwWYeYpjI6vr4lQhqCuMiXwxvlr9AWM+7sBHijq0Gn2+G4mtQeksC7bRl7iKuuw4xN8oPTgxjiCB46/6XxnCU4jefxFhAcMunHW0dqI+acgdtS38Zy1a9pebeXa88dOVjMY9Vt5EIDddCL01KVqoN/gCszwxtgwV8bIoXbavMFo4h2QU48rpcRhjKmb8zBkB05B5uW3bQco42YwWBcjRhrz7ncRk4+G2q0f/B9EJuJ+WtH2x1Gzw8UfAiqnkYl0KOqJ0Intoiy42xNuQLyZH3aNyuAxvae2vwywZsTr8Bz+vjy8kfkmm2jRcTwkYU+YJRMlAv9poeAJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DzK79gj095kx/rj5f4UgLVJqwlE6GZIU/udADIDrlY=;
 b=K3VYzqCb7x95Eg+K0rzNrzfsWHJJsQAHck+k7HjA1hcmo9SfVx8vcvXGInisL61msH3c2+5dJskjDE8/BUt+LzoPemPpslJUNTPKWhssEsWwBqO5Ucb4AMx5OxhTyyuF/w5rsyJB6KiDz6WVD+Sj3nrlHFu8acj2oQbSsHOCkQPtL61g364vzI4aVMajaGOmTNbLsZ69S8TeQXUxJQra4A4Rdz9UnOluhNICdmXlbaphBnp2s6swwQEEhesobJNl85TkqLplkrOrxB6Mobss90d9Ww06K+zlAJnN6CoJKJoz4G/8ZI5BLAbaG7h1EkYe815qaS8DxMm36m/S9NQPqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SJ5PPF5DFCDEDFC.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::82e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 18:37:41 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%2]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 18:37:41 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Lee Duncan <lduncan@suse.com>
CC: Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@kernel.org>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, James Bottomley
	<james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>, "Satish Kharat (satishkh)" <satishkh@cisco.com>,
	"Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>, "Gian Carlo Boffa
 (gcboffa)" <gcboffa@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>
Subject: RE: [PATCH 4/4] fnic: make interrupt mode configurable
Thread-Topic: [PATCH 4/4] fnic: make interrupt mode configurable
Thread-Index:
 AQHcTXJy2FynwvhbtEuofvwLS32KDLTmNqmAgACvswCAAOdagIBqhQOAgA48oQCAAAHskA==
Date: Fri, 23 Jan 2026 18:37:41 +0000
Message-ID:
 <SJ0PR11MB589602A7DE4E65E88CD9069BC394A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20251104100424.8215-1-hare@kernel.org>
 <20251104100424.8215-5-hare@kernel.org>
 <SJ0PR11MB5896BDD3102F17EA15356C95C3C2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <b8631995-a3df-4232-9f89-514d7a502bc0@suse.de>
 <SJ0PR11MB58964721E3ABEF2CF62D7D10C3C3A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB5896BEB89C838BF3E4929135C38FA@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <CAPj3X_WDYDuqvCmoccNC2dHkB03K1gq1okkY0L3z2dZxd_q6=g@mail.gmail.com>
In-Reply-To:
 <CAPj3X_WDYDuqvCmoccNC2dHkB03K1gq1okkY0L3z2dZxd_q6=g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SJ5PPF5DFCDEDFC:EE_
x-ms-office365-filtering-correlation-id: a5c4e4ab-6646-41b7-9c21-08de5aae7d9e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|18082099003;
x-microsoft-antispam-message-info:
 =?utf-8?B?UkMyZ1N1YWRoYmpGTzVlTzJYbkRPSUtIZmpiT0l6RFpFN1pqSnZsSHRwVXJr?=
 =?utf-8?B?eTQ5cXhjTmRxVHpoZXl0MG9BLy9OdHJzMTFSdkM4NGpJdHZjSEFYSUNpM1lJ?=
 =?utf-8?B?dVFpcG5YN1dYTlJPY0FsQmNmdEhURVBHaTZJS2t0dzljTDRsYUp4azNIVWJ5?=
 =?utf-8?B?bUhaYUFZbE1Ea2hIVlliY2orc3gvbXZJSnErVnVLZ1dsZG9kMU0zSWZjUHJv?=
 =?utf-8?B?UmFyVTBnRitPY3g1Z1RodTJPY1pad3krTEVJcXo5M1djMmdPZkJGczVTMUl0?=
 =?utf-8?B?djJlUXFIalp0Z0FueWpIRDJPVmpndngrTWMwa1hvUG1xdzd3aTdHQVAySHJa?=
 =?utf-8?B?N0NNRDN0UUhLSi9xZlpBUFpjdVdhL1YwSHB5TG5YUnowaUFJNTFyYTZMOGpy?=
 =?utf-8?B?bWxXY0x1Qi83Mm5ZemJaaE9Pc25oUENHZHZ1bFNDY3dGcHdVaDhHZ1FWcWRi?=
 =?utf-8?B?MUwvbWJYMmRzMnR5dXpNMjRXWE9uZVQ4S3I4VXkvNktGMDl1RzlxQ3VWTjZ1?=
 =?utf-8?B?ZW5RdjlsdnJFZ3BKY2JKdXhKQjB0WjFEdjM1MFZsbWhrampwOWMzVVJlQkxR?=
 =?utf-8?B?UlRvSjZJbktDTlE2aStoT3JVeW5JT0I2TmtGVzR2TExjcnVmQUhGTjdzTkhN?=
 =?utf-8?B?UGxaRXdPOFg1ZHBLbDRrbDdhdnphVnp0cGNVYk11bkIwRXF4TkJZRks1UmRz?=
 =?utf-8?B?Vkc1WGJSU01MWlFYWEh3Nk5vNjNYdUtxTzNtcmg4ek1FN0RtTGViWU9TaDdl?=
 =?utf-8?B?QjdOVkxVYTN6STEvbDhsYTlkbVRDa0RhRE0wVW53V2lIcjdPM1h2VEFNZFIr?=
 =?utf-8?B?MmZJRjZlME5ZOXladFVqK0hra1RuZTBrams3emM3WHdFa041U2VpSENHL1kv?=
 =?utf-8?B?MnlxbFdLM0VGYTM5YnU2K0RtVjVqNGpIWlZxWGMzWHN6cGxTZVNnaEpNTHJ3?=
 =?utf-8?B?ZElpZVJuY3dnb2J5Y2xTS25uNUxFalMyWWNiYkpvanBPSzV0VUIvTVluUVc3?=
 =?utf-8?B?ZEhuSlB1TkNyZEJlai9ZUE5MYnhNU2htQ3pjN0ZVbFVYREhwbURnMlkvT3hj?=
 =?utf-8?B?RE5sM1pYSVg3Q0NEV0FpSy9tYVFKSEhUc0FrZmJoTm9PUUN5MlVsTGRjb3Jv?=
 =?utf-8?B?RTM0bUF4Tk5DOGxEU2tHcnJESis2NXpVc0FjQlpOM29LL3lqejFEWm5ZOU1N?=
 =?utf-8?B?UUNZZ0JLTmpGVERCL3pWcGlTQnpSMjVDZEkwTHh5OGZ1a0VMbWJGZ0xLdThK?=
 =?utf-8?B?Q2w4TjJMVnlWa3FHTnZDbm9yeVdpRi9EZHFRK3VtcEozYTZMNFpDTjRjYjlk?=
 =?utf-8?B?ZFRBZFJGRHR6eDUrQnJqN0N1dW5XczdKR3hFYmd0VkMva1JuUC9Ua3hyQUhE?=
 =?utf-8?B?T0RNcXRPblg4ZndRcFAwUDlwbEI2MExMMTJVU0R6M1ppUEJPQSt4RWIzME4y?=
 =?utf-8?B?R3R5QlZWbkhhTTFuOU8xL1pjbEpUQlRjYVoyOTg2R3l5OWJuRUtHOURuQjg3?=
 =?utf-8?B?WU9SVTFIcTFnLzRJOXNOWFlOZUtZMDl3QjN6TkdkYllOZi9KRzY0WFRLbi9t?=
 =?utf-8?B?cEZKRHg3a1R2Z0E5NVBYS25pWU1rb0tybWxpS0J6SkNFV1JPQng1dUU5RzBx?=
 =?utf-8?B?NVhsQUMzdThCRXBKWUk2Q0hhWEsyM3FBSHFNcG56TW5UbTZLNnBSRnhCMXVv?=
 =?utf-8?B?bTZ1VUpDU1dueHMxQUtRQ2Y4TFg2VGxDVDFEYTN6NVNnUDJqRmR2WVFvdkxy?=
 =?utf-8?B?OEt0YkxNbHJPeGtUbXcyR1RwUVVOVFdTd0JTalN1TktYQ0g5MGpORy8zb24r?=
 =?utf-8?B?YWRVVHRvekI3Tm5kcHZTcFdGNTlReGlzRGFxMTR3dlJPaktqeXRvSit6YW9V?=
 =?utf-8?B?dUduT2xBZE9abVgxOWZiMGNFKyt6Q0lWam8yOGFUaXl4UUJWMDVrbEd2OC8z?=
 =?utf-8?B?MXJVSEZrUWhBQ2F6ZnU5SXdsZ25nZ0djWFcyV2V2OUFMdGk1VkwvUkJhVDla?=
 =?utf-8?B?cEpWYk1nSnBhOUx6OXdjYks5aU9SY2hYaUl5Q2FtaXZzU0tUUEJ4ZmJRc3Uw?=
 =?utf-8?B?ejI4RGVyN2hvWHdFd01Fa2U3MEhtVDFxODBTTkxQVlY1TVNQcFYzMVdJV1dz?=
 =?utf-8?B?bm5KaWpzbDFsVmZ3Y0hXMVJBWGRxZFF2WDZlM2l1VytNWHppdG1JenRSVWh2?=
 =?utf-8?Q?ta3XOLtroG5Iwwp0czbl6K0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(18082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bE9TYmk1UEVWd01udnJpUUpOVElqV2hySG1tMElJeWIwcE94Tk45UEhjTUxL?=
 =?utf-8?B?NkV2aG1GK0l5Tm5Memxjd2NKcFFrZ012S0puU0UvaWJ6V2FHWWY5eGZaYTR2?=
 =?utf-8?B?SjlLODQraUVQZFVJSk1WaVhrVVV2UzZlNFgyM3pxTGZEVkdrY0d6QklDQmRz?=
 =?utf-8?B?MXZiUnBoV1pQWUk2K25Yd3g0YlZHMUdxSWhMNXR2Nkw5aWF4UEI3bW5VQjlO?=
 =?utf-8?B?ZkI0WG44djkxUkpVdkszYndiTmk4aTVOUW9nbmkwQnhCMSs0WG1DRFFNbTFY?=
 =?utf-8?B?aWpMZmEwWEV0RHlTeU0vMFZ4aFdqWFB2R2I3cDA0WlUzdnRWRnRtZ1pxTkI1?=
 =?utf-8?B?ZHdTOWpSYzR5emYyMm5SeTcxd01meVhLQVAyMUU0a25DcFhENENhOWdUaVEr?=
 =?utf-8?B?TWJURmw0U3BuUndjeTNORWwrcUQrQUQxNTdYbUE0TzZsWjh1U3NwQUVjckZw?=
 =?utf-8?B?RGlvZ0lyYThqWExXVXdlYXJSSWJudGZ1Mi9FY0pXajZLcE00M3JpUEJiRG55?=
 =?utf-8?B?S2x2MldMdk9oaXlxL1E3OVRWdWZGTktaWUdsL3paekIyWVZLSUUzaGFLUTVN?=
 =?utf-8?B?SnJuc3g1eVJrL3ZiUXpLcEdmc0pMSDRjWmZVUjFZMWdncGp3VmY0WDgyWVZl?=
 =?utf-8?B?MittYkNBcWpIRnpiODBQUjJmN0xrWUFxWlcvYUh3YkU1RXpJMDJDMmlCWURv?=
 =?utf-8?B?V2RxaVJjeU1BQjdjTU9pYi9JOWlMT1hYT09aOG45WldiWTN1YThmc1JwTjVQ?=
 =?utf-8?B?Qzl0WWI4YTlVQ0kyc3JoV2lQSVg2NXNQb1ROdUM0S0UyTW9lSk9mTUo2WXZr?=
 =?utf-8?B?cUk2WVJBQ1hLMWl0dG1walFtMkRZbFl3aVFpZkRTazlwZXp3T3dhL1VVMWtq?=
 =?utf-8?B?SzFsZG4xT0lMVzdmMnRnOUVYWk04cC9nOXZsYklXOG5IYkRaeThZUWUvWm9I?=
 =?utf-8?B?NEl1WnBoSFpyK3NZL09YcG9MK0VtVEF0czhMck92dmxqVjltbVh5L0U5V3A3?=
 =?utf-8?B?TC9sS0dBV0ZjVTJWQ29LRmN2eGJQWVdaWWs4d0RMM0JpZE5yVTlOMWk4Y2Z2?=
 =?utf-8?B?clIxOVNIOEE5SEx5aHN4YUFpTUNqQWVYSEFxbU9icHB2bjF1MEFSMlhQVHlW?=
 =?utf-8?B?SWJxMEg3K0RiUHdYekFjZXRDK3RWc2QwVVFHK0V2Ymk5ZE9sR1R0ODduOGhm?=
 =?utf-8?B?aStTeEEybGgwN29zUW5ROEFMbDgwTEJLT01RdXRaSi9pY082YW1ZWTdoTHpQ?=
 =?utf-8?B?Z0l4TWhPQTBzYldYSDdIVG1kS3RsZ3Z4YktZTmsxcVF0bWJXVUk4SFJQV3o1?=
 =?utf-8?B?M0dHMHlpQlo2S2NldklRcGVSMEQ2Q0drV2Z5UG1mN0JEcTcxcmVQTHZnUmlL?=
 =?utf-8?B?SEl6dEhHTzd1Q0xMZ0Y0aC9ROEJiT1JtYlMvcjB1T3VDZzBScmU0cSt1dnBu?=
 =?utf-8?B?cU84TEY3STlCMWJHd3Nobzg3OFlSZm5KVldheUhORG85cEVXcFBGL3BZNW9v?=
 =?utf-8?B?c3BqMUhRL0gwYjh1clNsTEZiK0tuK05IZVV2N2Q1Uk9YcTdLM1FqNnFNc1FG?=
 =?utf-8?B?VHp3MmtZTy9tc0Q3U3EvdkFkNUFSdGxweCt4ZGJ1Y1V3a1Rzci9BSHhZTXl4?=
 =?utf-8?B?eEJiNUc0Njk1VmxiR2VzejA3aVVYcHlRMS9SMTlmaW0vdUc5UWdkcThCa2pG?=
 =?utf-8?B?SEY2MlI2MkRuVG90S1hwcDNpS0cvYXg2eU44WTVocmIzUStDNGxYdmhWam9z?=
 =?utf-8?B?Y2d4dkpaMkYwVzdwSDR0eDVvakV0YnhhdzdHbnk5L2t6YzYzM0FwdFNIWlFS?=
 =?utf-8?B?ZTlQaUFmSFdDbUZvcVBuQitNMmdFL3ZZRUxDZUFxbnVOZC9UVHZjWFBSQ0dE?=
 =?utf-8?B?bSt5SExNb0dSTWhLc1dzcWxNMkQyQ1dQSDlEMnBZM0ZwanZ1TXFHbFdrS3Av?=
 =?utf-8?B?aktVdWFxR0c5MWlPTENnbWlpa3BpWWJPTnZnWXJsSHVadFhsSkFZVllpbk1X?=
 =?utf-8?B?SVNvU2w1RTFrdS9VeEhUV0tzcWttRTlZQlZXSDMvMzR6cnlhM3FTaXU4TFI2?=
 =?utf-8?B?SGZJZXZyRHVHTDQ5aFRxR0ZnSFdPR3hJbUZaRkljRWd4dGZWVXpUL1lENm5V?=
 =?utf-8?B?WUtnS0E1eVBwTUpJYWpZRlIwR1BodWNHTTUyR2xHT2RBeFNBNHpTeVZuOGFC?=
 =?utf-8?B?R1ZPL091a0JBd3RTVVVZaGloN1p4WGNpSVY5aW9NRkVBZ1l3WmxBSFFlRTUr?=
 =?utf-8?B?b2UzMFhyR1JTdlU3OUpqN3JpaEpEN2xhSThKTlpmK2YwMWxoY0JJSFJLTkp0?=
 =?utf-8?Q?7/kTMCC3suF9m4AfyC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c4e4ab-6646-41b7-9c21-08de5aae7d9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2026 18:37:41.1292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IqwmnhYalYCcLXtjBqnqHUrDWii6Z3/IqmWZq9HJolwjje6Zd0Kh/z/rePFeQFwypoWndjl3nFW0hDrN9/cmGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF5DFCDEDFC
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: rcdn-l-core-04.cisco.com

T24gRnJpZGF5LCBKYW51YXJ5IDIzLCAyMDI2IDEwOjIyIEFNLCBMZWUgRHVuY2FuIDxsZHVuY2Fu
QHN1c2UuY29tPiB3cm90ZToNCj4NCj4gT24gV2VkLCBKYW4gMTQsIDIwMjYgYXQgOTowNOKAr0FN
IEthcmFuIFRpbGFrIEt1bWFyIChrYXJ0aWxhaykNCj4gPGthcnRpbGFrQGNpc2NvLmNvbT4gd3Jv
dGU6DQo+ID4NCj4gPg0KPiA+IENpc2NvIENvbmZpZGVudGlhbA0KPiA+IE9uIEZyaWRheSwgTm92
ZW1iZXIgNywgMjAyNSAyOjIzIFBNLCBLYXJhbiBUaWxhayBLdW1hciAoa2FydGlsYWspIHdyb3Rl
Og0KPiA+ID4NCj4gPiA+IE9uIEZyaWRheSwgTm92ZW1iZXIgNywgMjAyNSAxMjoyOSBBTSwgSGFu
bmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBPbiAx
MS82LzI1IDIzOjA5LCBLYXJhbiBUaWxhayBLdW1hciAoa2FydGlsYWspIHdyb3RlOg0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gQ2lzY28gQ29uZmlkZW50aWFsDQo+ID4gPiA+ID4gT24gVHVlc2RheSwg
Tm92ZW1iZXIgNCwgMjAyNSAyOjA0IEFNLCBIYW5uZXMgUmVpbmVja2UgPGhhcmVAa2VybmVsLm9y
Zz4gd3JvdGU6DQo+ID4gPiA+ID4+DQo+ID4gPiA+ID4+IEluIHNvbWUgZW52aXJvbm1lbnRzIChl
ZyBrZHVtcCkgbm90IGFsbCBDUFVzIGFyZSBvbmxpbmUsIHNvIHRoZSBNUQ0KPiA+ID4gPiA+PiBt
YXBwaW5nIG1pZ2h0IGJlIHJlc3VsdGluZyBpbiBhbiBpbnZhbGlkIGxheW91dC4gU28gbWFrZSB0
aGUgaW50ZXJydXB0DQo+ID4gPiA+ID4+IG1vZGUgc2V0dGFibGUgdmlhIGFuICdmbmljX2ludHJf
bW9kZScgbW9kdWxlIHBhcmFtZXRlciBhbmQgc3dpdGNoDQo+ID4gPiA+ID4+IHRvIElOVHggaWYg
dGhlICdyZXNldF9kZXZpY2VzJyBrZXJuZWwgcGFyYW1ldGVyIGlzIHNwZWNpZmllZC4NCj4gPiA+
ID4gPj4NCj4gPiA+ID4gPj4gU2lnbmVkLW9mZi1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQGtl
cm5lbC5vcmc+DQo+ID4gPiA+ID4+IC0tLQ0KPiA+ID4gPiA+PiBkcml2ZXJzL3Njc2kvZm5pYy9m
bmljLmggICAgICB8ICAyICstDQo+ID4gPiA+ID4+IGRyaXZlcnMvc2NzaS9mbmljL2ZuaWNfaXNy
LmMgIHwgMTMgKysrKysrKysrLS0tLQ0KPiA+ID4gPiA+PiBkcml2ZXJzL3Njc2kvZm5pYy9mbmlj
X21haW4uYyB8IDEwICsrKysrKysrKy0NCj4gPiA+ID4gPj4gMyBmaWxlcyBjaGFuZ2VkLCAxOSBp
bnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiA+ID4gPiA+Pg0KPiA+ID4gPiA+PiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL2ZuaWMvZm5pYy5oIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5p
Yy5oDQo+ID4gPiA+ID4+IGluZGV4IDExOTlkNzAxYzNmNS4uYzY3OTI4Mzk1NWU5IDEwMDY0NA0K
PiA+ID4gPiA+PiAtLS0gYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljLmgNCj4gPiA+ID4gPj4gKysr
IGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5pYy5oDQo+ID4gPiA+ID4+IEBAIC00ODQsNyArNDg0LDcg
QEAgZXh0ZXJuIHN0cnVjdCB3b3JrcXVldWVfc3RydWN0ICpmbmljX2ZpcF9xdWV1ZTsNCj4gPiA+
ID4gPj4gZXh0ZXJuIGNvbnN0IHN0cnVjdCBhdHRyaWJ1dGVfZ3JvdXAgKmZuaWNfaG9zdF9ncm91
cHNbXTsNCj4gPiA+ID4gPj4NCj4gPiA+ID4gPj4gdm9pZCBmbmljX2NsZWFyX2ludHJfbW9kZShz
dHJ1Y3QgZm5pYyAqZm5pYyk7DQo+ID4gPiA+ID4+IC1pbnQgZm5pY19zZXRfaW50cl9tb2RlKHN0
cnVjdCBmbmljICpmbmljKTsNCj4gPiA+ID4gPj4gK2ludCBmbmljX3NldF9pbnRyX21vZGUoc3Ry
dWN0IGZuaWMgKmZuaWMsIHVuc2lnbmVkIGludCBtb2RlKTsNCj4gPiA+ID4gPj4gaW50IGZuaWNf
c2V0X2ludHJfbW9kZV9tc2l4KHN0cnVjdCBmbmljICpmbmljKTsNCj4gPiA+ID4gPj4gdm9pZCBm
bmljX2ZyZWVfaW50cihzdHJ1Y3QgZm5pYyAqZm5pYyk7DQo+ID4gPiA+ID4+IGludCBmbmljX3Jl
cXVlc3RfaW50cihzdHJ1Y3QgZm5pYyAqZm5pYyk7DQo+ID4gPiA+ID4+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL3Njc2kvZm5pYy9mbmljX2lzci5jIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19pc3Iu
Yw0KPiA+ID4gPiA+PiBpbmRleCBlMTZiNzZkNTM3ZTguLmI2NTk0YWQwNjRjYSAxMDA2NDQNCj4g
PiA+ID4gPj4gLS0tIGEvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19pc3IuYw0KPiA+ID4gPiA+PiAr
KysgYi9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX2lzci5jDQo+ID4gPiA+ID4+IEBAIC0zMTksMjAg
KzMxOSwyNSBAQCBpbnQgZm5pY19zZXRfaW50cl9tb2RlX21zaXgoc3RydWN0IGZuaWMgKmZuaWMp
DQo+ID4gPiA+ID4+IHJldHVybiAxOw0KPiA+ID4gPiA+PiB9DQo+ID4gPiA+ID4+DQo+ID4gPiA+
ID4+IC1pbnQgZm5pY19zZXRfaW50cl9tb2RlKHN0cnVjdCBmbmljICpmbmljKQ0KPiA+ID4gPiA+
PiAraW50IGZuaWNfc2V0X2ludHJfbW9kZShzdHJ1Y3QgZm5pYyAqZm5pYywgdW5zaWduZWQgaW50
IGludHJfbW9kZSkNCj4gPiA+ID4gPj4gew0KPiA+ID4gPiA+PiBpbnQgcmV0X3N0YXR1cyA9IDA7
DQo+ID4gPiA+ID4+DQo+ID4gPiA+ID4+IC8qDQo+ID4gPiA+ID4+ICogU2V0IGludGVycnVwdCBt
b2RlIChJTlR4LCBNU0ksIE1TSS1YKSBkZXBlbmRpbmcNCj4gPiA+ID4gPj4gKiBzeXN0ZW0gY2Fw
YWJpbGl0aWVzLg0KPiA+ID4gPiA+PiAtICAgICAgKg0KPiA+ID4gPiA+PiArICAgICAgKi8NCj4g
PiA+ID4gPj4gKyAgICAgaWYgKGludHJfbW9kZSAhPSBWTklDX0RFVl9JTlRSX01PREVfTVNJWCkN
Cj4gPiA+ID4gPj4gKyAgICAgICAgICAgICBnb3RvIHRyeV9tc2k7DQo+ID4gPiA+ID4+ICsgICAg
IC8qDQo+ID4gPiA+ID4+ICogVHJ5IE1TSS1YIGZpcnN0DQo+ID4gPiA+ID4+ICovDQo+ID4gPiA+
ID4+IHJldF9zdGF0dXMgPSBmbmljX3NldF9pbnRyX21vZGVfbXNpeChmbmljKTsNCj4gPiA+ID4g
Pj4gaWYgKHJldF9zdGF0dXMgPT0gMCkNCj4gPiA+ID4gPj4gcmV0dXJuIHJldF9zdGF0dXM7DQo+
ID4gPiA+ID4+IC0NCj4gPiA+ID4gPj4gK3RyeV9tc2k6DQo+ID4gPiA+ID4+ICsgICAgIGlmIChp
bnRyX21vZGUgIT0gVk5JQ19ERVZfSU5UUl9NT0RFX01TSSkNCj4gPiA+ID4gPj4gKyAgICAgICAg
ICAgICBnb3RvIHRyeV9pbnR4Ow0KPiA+ID4gPiA+PiAvKg0KPiA+ID4gPiA+PiAqIE5leHQgdHJ5
IE1TSQ0KPiA+ID4gPiA+PiAqIFdlIG5lZWQgMSBSUSwgMSBXUSwgMSBXUV9DT1BZLCAzIENRcywg
YW5kIDEgSU5UUg0KPiA+ID4gPiA+PiBAQCAtMzU4LDcgKzM2Myw3IEBAIGludCBmbmljX3NldF9p
bnRyX21vZGUoc3RydWN0IGZuaWMgKmZuaWMpDQo+ID4gPiA+ID4+DQo+ID4gPiA+ID4+IHJldHVy
biAwOw0KPiA+ID4gPiA+PiB9DQo+ID4gPiA+ID4+IC0NCj4gPiA+ID4gPj4gK3RyeV9pbnR4Og0K
PiA+ID4gPiA+PiAvKg0KPiA+ID4gPiA+PiAqIE5leHQgdHJ5IElOVHgNCj4gPiA+ID4gPj4gKiBX
ZSBuZWVkIDEgUlEsIDEgV1EsIDEgV1FfQ09QWSwgMyBDUXMsIGFuZCAzIElOVFJzDQo+ID4gPiA+
ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX21haW4uYyBiL2RyaXZlcnMv
c2NzaS9mbmljL2ZuaWNfbWFpbi5jDQo+ID4gPiA+ID4+IGluZGV4IDg3MGIyNjViZTQxYS4uNGJk
ZDU1OTU4ZjU5IDEwMDY0NA0KPiA+ID4gPiA+PiAtLS0gYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmlj
X21haW4uYw0KPiA+ID4gPiA+PiArKysgYi9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX21haW4uYw0K
PiA+ID4gPiA+PiBAQCAtOTcsNiArOTcsMTAgQEAgbW9kdWxlX3BhcmFtKHBjX3JzY25faGFuZGxp
bmdfZmVhdHVyZV9mbGFnLCB1aW50LCAwNjQ0KTsNCj4gPiA+ID4gPj4gTU9EVUxFX1BBUk1fREVT
QyhwY19yc2NuX2hhbmRsaW5nX2ZlYXR1cmVfZmxhZywNCj4gPiA+ID4gPj4gIlBDUlNDTiBoYW5k
bGluZyAoMCBmb3Igbm9uZS4gMSB0byBoYW5kbGUgUENSU0NOIChkZWZhdWx0KSkiKTsNCj4gPiA+
ID4gPj4NCj4gPiA+ID4gPj4gK3N0YXRpYyB1bnNpZ25lZCBpbnQgZm5pY19pbnRyX21vZGUgPSBW
TklDX0RFVl9JTlRSX01PREVfTVNJWDsNCj4gPiA+ID4gPj4gK21vZHVsZV9wYXJhbShmbmljX2lu
dHJfbW9kZSwgdWludCwgU19JUlVHTyB8IFNfSVdVU1IpOw0KPiA+ID4gPiA+PiArTU9EVUxFX1BB
Uk1fREVTQyhmbmljX2ludHJfbW9kZSwgIkludGVycnVwdCBtb2RlLCAxID0gSU5UeCwgMiA9IE1T
SSwgMyA9IE1TSXggKGRlZmF1bHQ6IDMpIik7DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBCYXNlZCBv
biBmbmljIHRlYW0ncyByZXZpZXc6IHRoZXJlIGlzIGEgd2F5IHRvIGNob29zZSB0aGUgaW50ZXJy
dXB0IG1vZGUgdXNpbmcgdGhlIFVDUyBtYW5hZ2VtZW50IHBsYXRmb3JtLg0KPiA+ID4gPiA+IFdl
IGRvIG5vdCB3YW50IHRvIGV4cG9zZSB0aGlzIGFzIGEgbW9kdWxlIHBhcmFtZXRlci4NCj4gPiA+
ID4gPg0KPiA+ID4gPiBZZWFoLCBJIGtub3cuIEl0IHdhcyBwcmltYXJpbHkgdXNlZCBkdXJpbmcg
dGVzdGluZyB0byBlYXNpbHkgY2hhbmdlDQo+ID4gPiA+IGJldHdlZW4gdGhlIHZhcmlvdXMgbW9k
ZXMuDQo+ID4gPiA+IEkgY2FuIGRyb3AgaXQgZm9yIHRoZSBuZXh0IHJvdW5kLg0KPiA+ID4NCj4g
PiA+IFRoYW5rcyBIYW5uZXMuIFNvdW5kcyBnb29kLg0KPiA+ID4NCj4gPiA+ID4gPj4gc3RydWN0
IHdvcmtxdWV1ZV9zdHJ1Y3QgKnJlc2V0X2ZuaWNfd29ya19xdWV1ZTsNCj4gPiA+ID4gPj4gc3Ry
dWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKmZuaWNfZmlwX3F1ZXVlOw0KPiA+ID4gPiA+Pg0KPiA+ID4g
PiA+PiBAQCAtODY5LDcgKzg3MywxMSBAQCBzdGF0aWMgaW50IGZuaWNfcHJvYmUoc3RydWN0IHBj
aV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICplbnQpDQo+ID4gPiA+ID4+
DQo+ID4gPiA+ID4+IGZuaWNfZ2V0X3Jlc19jb3VudHMoZm5pYyk7DQo+ID4gPiA+ID4+DQo+ID4g
PiA+ID4+IC0gICAgIGVyciA9IGZuaWNfc2V0X2ludHJfbW9kZShmbmljKTsNCj4gPiA+ID4gPj4g
KyAgICAgLyogT3ZlcnJpZGUgaW50ZXJydXB0IHNlbGVjdGlvbiBkdXJpbmcga2R1bXAgKi8NCj4g
PiA+ID4gPj4gKyAgICAgaWYgKHJlc2V0X2RldmljZXMpDQo+ID4gPiA+ID4+ICsgICAgICAgICAg
ICAgZm5pY19pbnRyX21vZGUgPSBWTklDX0RFVl9JTlRSX01PREVfSU5UWDsNCj4gPiA+ID4gPj4g
Kw0KPiA+ID4gPiA+PiArICAgICBlcnIgPSBmbmljX3NldF9pbnRyX21vZGUoZm5pYywgZm5pY19p
bnRyX21vZGUpOw0KPiA+ID4gPiA+PiBpZiAoZXJyKSB7DQo+ID4gPiA+ID4+IGRldl9lcnIoJmZu
aWMtPnBkZXYtPmRldiwgIkZhaWxlZCB0byBzZXQgaW50ciBtb2RlLCAiDQo+ID4gPiA+ID4+ICJh
Ym9ydGluZy5cbiIpOw0KPiA+ID4gPiA+PiAtLQ0KPiA+ID4gPiA+PiAyLjQzLjANCj4gPiA+ID4g
Pj4NCj4gPiA+ID4gPj4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFRoYW5rcyBmb3IgdGhlc2UgY2hh
bmdlcywgSGFubmVzLg0KPiA+ID4gPiA+IEZvciB0aGUgb3RoZXIgY2hhbmdlcyBpbiB0aGlzIHBh
dGNoLCBJIHdpbGwgbmVlZCB0byB0ZXN0IGFuZCBnZXQgYmFjayB0byB5b3UuDQo+ID4gPiA+ID4N
Cj4gPiA+ID4NCj4gPiA+ID4gVGhhbmtzLg0KPiA+ID4gPiBUaGUgJ3Jlc2V0X2RldmljZXMnIHRo
aW5nIGlzIHByaW1hcmlseSB0aGVyZSBmb3Iga2R1bXA7IG1pZ2h0IGJlIGFuIGlkZWENCj4gPiA+
ID4gdG8gbWFrZSBpcyBleHBsaWNpdCBieSB1c2luZyAnaXNfa2R1bXBfa2VybmVsKCknIGRpcmVj
dGx5Lg0KPiA+ID4NCj4gPiA+IFllcyBIYW5uZXMuIFRoYXQgd291bGQgYmUgYmV0dGVyLiBUaGFu
a3MuDQo+ID4gPg0KPiA+ID4gPiBDaGVlcnMsDQo+ID4gPiA+DQo+ID4gPiA+IEhhbm5lcw0KPiA+
ID4gPg0KPiA+ID4gPiAtLQ0KPiA+ID4gPiBEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAg
ICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0DQo+ID4gPiA+IGhhcmVAc3VzZS5kZSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgNCj4gPiA+ID4gU1VT
RSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgRnJhbmtlbnN0ci4gMTQ2LCA5MDQ2MSBOw7xybmJl
cmcNCj4gPiA+ID4gSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHRjogSS4gVG90ZXYsIEEuIE1j
RG9uYWxkLCBXLiBLbm9ibGljaA0KPiA+ID4gPg0KPiA+ID4NCj4gPiA+IEknbSBicmluZ2luZyB1
cCBhIHNldHVwIHRvIHRlc3QuIEknbGwgd2FpdCBmb3IgeW91ciBuZXh0IHJldmlzaW9uLg0KPiA+
ID4NCj4gPiA+IE15IHBsYW4gaXMgdG8gaW5kdWNlIGEga2R1bXAgdG8gdGVzdCBvdXQgdGhlc2Ug
Y2hhbmdlcy4NCj4gPiA+IElmIHlvdSBoYXZlIGFueSBvdGhlciB0ZXN0cyBpbiBtaW5kLCBwbGVh
c2UgbGV0IG1lIGtub3cuDQo+ID4gPg0KPiA+ID4gVGhhbmtzLA0KPiA+ID4gS2FyYW4NCj4gPiA+
DQo+ID4NCj4gPiBIaSBIYW5uZXMsDQo+ID4NCj4gPiBQbGVhc2UgY29uc2lkZXIgc2VuZGluZyBv
dXQgYSBuZXcgcmV2aXNpb24gb2YgdGhlc2UgY2hhbmdlcy4NCj4gPiBJJ2QgbGlrZSB0byB0ZXN0
IGFsbCB0aGUgY2hhbmdlcyBhbmQgYWRkIGEgdGVzdGVkLWJ5IHRhZyB0byB0aGVtLg0KPiA+DQo+
ID4gVGhhbmtzLA0KPiA+IEthcmFuDQo+ID4NCj4NCj4gSGkgS2FyYW46DQo+DQo+IE15IG5hbWUg
aXMgTGVlIER1bmNhbiwgYW5kIEkgd29yayB3aXRoIEhhbm5lcy4gSGUgaXMgb3RoZXJ3aXNlIG9j
Y3VwaWVkDQo+IHJpZ2h0IG5vdywgc28gSSdsbCBkbyBteSBiZXN0IHRvIHRha2UgaXQgZnJvbSBo
ZXJlLg0KPg0KPiBJdCBzZWVtcyBsaWtlIHlvdSB3YW50ZWQgdHdvIGNoYW5nZXMgdG8gcGF0Y2gj
NDoNCj4gMS4gUmVtb3ZlIHRoZSBuZXdseS1hZGRlZCBtb2R1bGUgcGFyYW1ldGVyLCBhbmQNCj4g
Mi4gVXNlICJpc19rZHVtcF9rZXJuZWwoKSIgdG8gdGVzdCBmb3Igc2V0dGluZyB0aGUgaW50ZXJy
dXB0IG1vZGUgdG8gSU5UWA0KPg0KPiBJIGhhdmUgbWFkZSB0aG9zZSBjaGFuZ2VzIHRvIHBhdGNo
IzQsIGFuZCBpbnRlcm5hbCB0ZXN0aW5nIHNob3dzIHRoYXQNCj4ga2R1bXAgd29ya3MuDQo+DQoN
CkhpIExlZSwNCg0KQXBwcmVjaWF0ZSB5b3VyIHJlc3BvbnNlIGFuZCB5b3VyIHdpbGxpbmduZXNz
IHRvIHRha2UgdGhpcyBmb3J3YXJkLg0KU291bmRzIGdvb2QuIFRoYW5rIHlvdSBmb3IgdGhlIGNo
YW5nZXMgYW5kIGludGVybmFsIHRlc3RzLg0KDQo+IEkgd2lsbCByZXN1Ym1pdCB0aGUgcGF0Y2gg
c2VxdWVuY2UgYWZ0ZXIgb25lIG1vcmUgaW50ZXJuYWwgdGVzdC4gSSBhcHByZWNpYXRlDQo+IHlv
dXIgcGF0aWVuY2UuDQo+DQo+IFAuUywgSSBiZWxpZXZlIHRoZSBwYXRjaGVzIHdpbGwgZW5kIHVw
IGdldHRpbmcgdG8geW91IHRocm91Z2ggb3RoZXIgY2hhbm5lbHMsDQo+IHNpbmNlIGEgYnVnIHdh
cyBmaWxlZCwgYnV0IGlmIHlvdSdkIGxpa2UgdG8gdGVzdCB0aGVtIGFuZCB3YW50IGEgY29weSBi
ZWZvcmUNCj4gSSByZXBvc3QgdGhlIHNlcXVlbmNlLCBwbGVhc2UgY29udGFjdCBtZS4NCj4NCg0K
SSB1bmRlcnN0YW5kLiBJIHdvdWxkIGxpa2UgdG8gZGV2IHRlc3QgdGhlc2UgY2hhbmdlcyBvbiB0
b3AgdGhlIGxhdGVzdCBrZXJuZWwganVzdCB0byBtYWtlIHN1cmUgdGhpbmdzIGFyZSB3b3JraW5n
IGNvcnJlY3RseS4NCkkgZG9uJ3QgbWluZCB3YWl0aW5nIHVudGlsIHRoZSBpbnRlcm5hbCB0ZXN0
cyBhcmUgY29tcGxldGVkLiBJJ2xsIHRha2UgeW91ciBuZXh0IHJldmlzaW9uIGluIGZvciB0ZXN0
aW5nLg0KVGhhbmtzIGFnYWluIGZvciB5b3VyIGhlbHAuDQoNClJlZ2FyZHMsDQpLYXJhbg0K
