Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B8E27F166
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 23:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762298377; cv=fail; b=uAETGJrFFBUAduyhBPAxxrIBjhcCNiuVGQsezkjL5I1nS6p3mNr2j05/5JWXWHA8crnqrlI/+sxo7nXyqqwHKEqQVZdkdHq7Rkk2edDU61EVLrq9VkACYkNLKVj5ED3fdtARkPJoBgZ/dLdLA23ayKX4uiVkClfwbvhtVlUsziE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762298377; c=relaxed/simple;
	bh=bF1+Tfp6FgRD7h7lDJUSpOGG3ybRZHVy64HwE04cVSI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tvi6TA3oGh57xuIsdN3E4WLXb8VvQ/zOfPiGE6jGcjFTZfImARsCQStrupKstTxrIqUMMxFS9oKaB2TbtK3pgSTu3VZTEki9wuPmdQaEFflW34oWJkxBgrZeEwOYJZ7+WQrh9YrWt87t8uuVuwiOdOsk88MNW2pF7RBFB8z7O7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=Hpq8MJSg; arc=fail smtp.client-ip=173.37.142.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="Hpq8MJSg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2143; q=dns/txt;
  s=iport01; t=1762298375; x=1763507975;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PHIbLKq0UXd9fOzLC5ibG5pJI2+YdtCLORnFHZY78MI=;
  b=Hpq8MJSg3zlHS/P5ecI9Ip01iqcUMjgLbVpT1f/FL60PtsxaiTsQKZK5
   +TLpbpDyKSLvsFkMIaiIRoGmetmAJH9Zz21eZ0SZC1797/UinEm1ykrvr
   ZtzNL3Gfe+N3B+RxrrW/m8GB39ttw7XSF+eoYTOD36AP1oNNrYJ4lyu7+
   mdvrkNfw4cnWXmBOTzZgopdxUYyGxyIxLYMX9JPkCbo1597quEDIbVJDs
   gVYiDLivA1h+z3i15MqWveNR+rVEUsW67le3xV5MZbiruGOqVHgUKxqlY
   uAQO9xAUW0Bl4lHClz0d3j50J8tx0LE5Etq3tMgPKwbo5q5W7KXkufWJ3
   A==;
X-CSE-ConnectionGUID: BPGooZIeRnaBFtjye4tODg==
X-CSE-MsgGUID: nMa4iMDITFG+mOTTc65YMA==
X-IPAS-Result: =?us-ascii?q?A0AuAAAWiQpp/5QQJK1aHAEBAQEBAQcBARIBAQQEAQFlg?=
 =?us-ascii?q?RcHAQELAYFtUgeCG4hpA4RNX4h4nh2Bfw8BAQENAlEEAQGFBwKMVwImNAkOA?=
 =?us-ascii?q?QIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGXIZbAgEDEmcQA?=
 =?us-ascii?q?gEIDjgxJQIEAQ0NGoVUAwECpz8BgUACiiuCLIEB4CaBSgGIUgGFboR4JxuCD?=
 =?us-ascii?q?YEVQoJoPoRFhBOCLwSCIoEOhieLAwaHZlJ4HANZLAFVExcLBwWBIEMDgQsjS?=
 =?us-ascii?q?wUtHYEkIh8YEWBUQINJEAsGaA8GgRIZSQICAgUCQDqBaAYcBh8SAgMBAgI6V?=
 =?us-ascii?q?w2BdwICBIIZfoIPD4l0AwttPTcUGwUEgTUFllgBMV1MgXMqkwldswsKhByiD?=
 =?us-ascii?q?Reqay6HZZBzIqNZhRsCBAIEBQIQAQEGgWg8gVlwFYMjURkP3VaBNAIHCwEBA?=
 =?us-ascii?q?wmTZwEB?=
IronPort-PHdr: A9a23:vO8d2RWhY85+tRVCvGiC7vgEaxXV8K3PAWYlg6HPw5pHdqClupP6M
 1OaubNmjUTCWsPQ7PcXw+bVsqW1QWUb+t7Bq3ENdpVQSgUIwdsbhQ0uAcOJSAX7IffmYjZ8H
 ZFqX15+9Hb9Ok9QcPs=
IronPort-Data: A9a23:L5X0Ma1UBWBRsxWz2fbD5Zlwkn2cJEfYwER7XKvMYLTBsI5bp2BRm
 msdXjyBPPaMMTf3L4x/YY/j80MCvcfRmtc1S1Q63Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmH4E/xbtANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXU6
 Lsen+WFYAX4gmcsbjpPg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGJnkZOooq2+tNB2hk2
 +AaOT1RcjeviLfjqF67YrEEasULJc3vOsYb/3pn1zycVK9gSpHYSKKM7thdtNsyrpkRRrCFO
 YxAN3w2MESojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZjuCyb4uPJYzRLSlTtkC9r
 z7H2kjYPj81d9m49QaOrC+do8aayEsXX6pXTtVU7MVChFyV23xWExYNVHOlrvSjzE2zQdRSL
 woT4CVGkEQp3EWvSt+4W1izp2SJ+0dFHdFRCOY9rgqKz8I4/jqkO4TNdRYYAPQOv84tTjts3
 ViM9+4FzxQ12FFJYRpxLoupkA4=
IronPort-HdrOrdr: A9a23:1LojLKOYiHuNisBcT4f255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
 nxppUmPEfP+UgssREb9expOMG7MBXhHO1OkPgs1NCZLUfbUQqTXc5fBOTZskfd8kHFh4pgPO
 JbAtdD4b7LfBlHZKTBkXSF+r8bqbHtntHL9ILjJjVWPH1Xgspbnn5E43OgYzZLrX59dOIE/f
 Snl616jgvlU046Ku68AX4IVfXCodrkqLLKCCRtOzcXrCO1oXeN8rDVLzi0ty1yb9pI+9gf2F
 mAtza8yrSosvm9xBOZ/XTU9Y5qlNzozcYGLNCQi+AOQw+cyTqAVcBEYfmvrTo1qOag5BIBi9
 /XuSotOMx19jf4Yny1mx3wwAPtuQxeqUMKiGXoxEcLk/aJAw7SOPAxw76xtSGpsnbIiesMlJ
 6jGVjp76a/QymwxxgVrOK4Jy2C3nDE0kbK19Rjz0C2leAlGeJsRUt1xjIOLH8NcRiKmrwPAa
 1gCtrR6+1Rdk7fZ3fFvnN3yNjpRXgrGAyaK3Jy8PB9/gIm1EyR9XFoj/A3jzMF7tYwWpNE7+
 PLPuBhk6xPVNYfaeZ4CP0aScW6B2TRSVaUWVjibWjPBeUCITbAupT36LI66KWjf4EJ1oI7nN
 DEXElDvWA/dkryAYmF3YFN8BrKXGKhNA6dh/129tx8oPnxVbDrOSqMRBQnlNahuewWBonBV/
 O6KPttcrbexKvVaPB0NiHFKu5vwCMlIbgoU/4AKiaznv4=
X-Talos-CUID: =?us-ascii?q?9a23=3A5WiqmWpA3zrtFBhMxAwiZM/mUeodXXra/lbdGUm?=
 =?us-ascii?q?xI0h1SqyYFUO31Kwxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3A/Ue8pwzJOOA12VkxgPI6fAT996aaqKKLARwMtLk?=
 =?us-ascii?q?nh+erdilXBwuW0mmGZ6Zyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-11.cisco.com ([173.36.16.148])
  by alln-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 Nov 2025 23:19:29 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-11.cisco.com (Postfix) with ESMTPS id 473A2180001EE
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 23:19:29 +0000 (GMT)
X-CSE-ConnectionGUID: ye2sQSL1RqCvRuFkTuaOpQ==
X-CSE-MsgGUID: FvuCPs+sQGGgXoeak8m7LQ==
Authentication-Results: alln-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.19,280,1754956800"; 
   d="scan'208";a="57260118"
Received: from mail-bl2pr08cu00104.outbound.protection.outlook.com (HELO BL2PR08CU001.outbound.protection.outlook.com) ([40.93.4.12])
  by alln-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 Nov 2025 23:19:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ylushBlANb0xv6CutxnHTMGu2dx/NpdHtl4lKLMXczLGXP7/t9TeYcAbvmFDGRWwz1LQWoMSgXzshZ+1VSnhlQ2kAhM3OOA2dk8cOFMfKNHAfctuNeNWSKV65Cj1+BXwZy3omnLc1V/0WXExiivjMwjRczLAO3ufoS765TJTbSUDgDoSGNRhSOVyyaI/Z/fXKLSwBReno4Gxs4vh1N23GgIrXHTVlmhwp/8hCzBEgg1puiKce6AwNfK7XXSZ1K6g/XMr1LBegfKxL1z3wxqM+ER3vFvumZV9ubHEAeGI+JYLu9RPueYJg2eUZ0GkdDVgizt69l/MrZ2gcijNF77HVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHIbLKq0UXd9fOzLC5ibG5pJI2+YdtCLORnFHZY78MI=;
 b=YMVve5B7hg6ZyW4luqsszenT3uCrRaJKOs16EHIYeaI+WPZxTY8Sfe8R9wgYYdMRbWsCBmHV3DUlzOeES4irb/XIshPRVZxv6QX8hoGGfbZ7BtbZWgvMndnoBdG+x8nosqqTm9UM4wHKgl3KGPJplXn45oX/GZTHaWqOzwlzp61Bx7IKwMD1a2e2Z10lUyqa4Yii91S3Gri1r38bB8EOO++i5Qb7KEvFIRObXq4AjyUXxBuL3HPX4JDwAOf4f3/07OQfw60llO+O+VbkHTTD9v2B2J4aRFeB8U5bB3kmLmwzSSh9+Zye+DuJ8GpxUAckDEXA/mvf6LME3Q9byAeovA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DS0PR11MB7681.namprd11.prod.outlook.com (2603:10b6:8:f0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Tue, 4 Nov
 2025 23:19:26 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%4]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 23:19:26 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Hannes Reinecke <hare@kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: James Bottomley <james.bottomley@hansenpartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>
Subject: RE: [PATCH 3/4] fnic: missing initialisation for wq_copy_base
Thread-Topic: [PATCH 3/4] fnic: missing initialisation for wq_copy_base
Thread-Index: AQHcTXJyB4hzo+4fOE+PiZ5vsIOgZbTjJ8sA
Date: Tue, 4 Nov 2025 23:19:26 +0000
Message-ID:
 <SJ0PR11MB589663DB0217D8A04B933F88C3C4A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20251104100424.8215-1-hare@kernel.org>
 <20251104100424.8215-4-hare@kernel.org>
In-Reply-To: <20251104100424.8215-4-hare@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Enabled=True;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SiteId=5ae1af62-9505-4097-a69a-c1553ef7840e;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_SetDate=2025-11-04T23:18:36.0000000Z;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Name=Cisco
 Confidential;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_ContentBits=3;MSIP_Label_c8f49a32-fde3-48a5-9266-b5b0972a22dc_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DS0PR11MB7681:EE_
x-ms-office365-filtering-correlation-id: 6eba861c-a12c-4a9a-452d-08de1bf8992a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-7?B?dlZ3TjNXR2xGTVJ3Y0U0UmlMMy9tZ3ZPdlIyVnA4a3l3cEE5Ulp4VFV3Q3dW?=
 =?utf-7?B?Y1daODZYdThUSmE2Y2FZU25Ub09TcHdiVDZFWnVyQjVDaThodEQ4OXJVN1FO?=
 =?utf-7?B?N21NcmhMeGRCOTlVN0dvUlJkVER1aE1HQ0hFcnRGeC9xLystcWhQRzFFbDlv?=
 =?utf-7?B?S1Bnbi83bTk0L3JOM1pSTjlDODFieG5uWFR0YnJqYndUTEVPOWMzSkM5amgz?=
 =?utf-7?B?UkhFU3hKbVNGYzk5RVRGeTJHWTV1THVWN1pJSUtzZUlxeXZEZHJySXZqNFBq?=
 =?utf-7?B?bzlsVmpCTUlWd3VDZzZ2YWFqbk5DRE9ucTQydlBDMnRRZnJDNjIycXozRHFL?=
 =?utf-7?B?aGk5UWJXSEVWUW5NN1liZjFWd3E5QmFxT0NxVlJQNVo0eUhLWExHRHprQUR2?=
 =?utf-7?B?MnQvRzJKdzhzaXRibVNOMk1HaUJrNDdhYnFyaExMQ0V3OHVySnRhbDNpT1g1?=
 =?utf-7?B?Vml1c1JtWTVwQnJRYzUxSW1kN3ltQU9kZjF0bHYxS1h6cTBUTlMyWWRRa1hr?=
 =?utf-7?B?Ky1GaWdkWXpTQzdyRm1aSGx0a2FrMDdjTTFhMCstMVozS0VnenRERjdwSlhR?=
 =?utf-7?B?d3JGcGRQbkM4SmFlTGpHcFVVcVI1Vmg5WThYN0F0TFVpVlFQTld0VDJodkZK?=
 =?utf-7?B?NEE1dW5FOG5nZzIrLTB4Rmcxck1aanZWclU1MURMc0MzSllKS1FzZGQxdU5Q?=
 =?utf-7?B?b1F3aTJwN09QOHJYMW5qczU1VmNaY2hEaHJDekYrLWV3NGp2cEdsR2tGbmdI?=
 =?utf-7?B?TFlIMC9QM2hYcDJLYWR0YllwWmppR1YrLUZMSERQWmRMbDJwQmFiVUJsVURQ?=
 =?utf-7?B?QVJqQW0rLS84dXRXSW5oaThKMHYyN2ZsTjBCU0ZVRXBNWk1IeVdYcmptdzBt?=
 =?utf-7?B?dnNlOUk0QTloOWZjQ0l3ek5zTGVnWDlmeXczTCstWjVvOFVSaXJTbEdxcDAx?=
 =?utf-7?B?dlRISGhjcWlJZHBVbkN1cWYxN2Y3cjlENExXQkdCMS90WVgvbnRJS2RFdGtS?=
 =?utf-7?B?WjBpRm9IeFFURjJpZW96MWxub0pnaTluYTl0ZzhXU29vWTBnNjZFblduTVlt?=
 =?utf-7?B?Nmt5cmo5RWN6M25nS09aRHQ2dUliWlZTVWw3RnpxMTlycVFVbk4rLUNvVzJC?=
 =?utf-7?B?ZzI3R1RXaVhBR29tKy0zUE5PR1VwTEp0YWw3ZW9tZystKy16dHA2aGZiSVp6?=
 =?utf-7?B?YnA3T1JqeUtDU0dCM2NEaDdBNS9qM21xRkxaMndlTFZwR3Yyem1RejA1c05Y?=
 =?utf-7?B?eUVXMHkydTlmazNKSUpabHIyVXN6b0MrLTJIVzZNWUhYOXhCWUJYcEdLbDgy?=
 =?utf-7?B?M0hZSURCR2ZYcVBLMzI0cCstMXBFRzlBL01DRGovRXU0YThITXFUSkI4Y2Jk?=
 =?utf-7?B?c2prOSstU1hCWFBxREQ2ME0zTmlLUmVBbVcyN0E1ZUEwa3QzdTVBM1djajJU?=
 =?utf-7?B?RzJkM3BjL1daZTRJOUFHSXJMSElYWWo2N2w5V1dRZFQrLTkzWDQvbmZ5L014?=
 =?utf-7?B?Z2UxN2k3Q2RvN1BZQnc5VlR4ckZPYXBYQVRxcVNOdVFLN1p2ZHllbFRqRGVR?=
 =?utf-7?B?U2gwd1B3YmNKa0JRUGZhU01OaEtidFNTNEZNWm1tN3RHM2c0UVh5aXhwSW9O?=
 =?utf-7?B?RWZ2cm9LZ3lMQzQvckxLL2M3NGcrLU1RQ1J6ci9LSDNWQkVpTWU4aWk5ODJH?=
 =?utf-7?B?dXQrLVlRVDROUm5sbHcrLTkrLWp6ZkJEdistTUluOFMzTGRWSWUrLTNHOEZz?=
 =?utf-7?B?VmZ0VnFEWFh1cWd1NmFVZ0N4V0JrUjlIQXJaanBNTkRaUWZMVW1UWWYxYS95?=
 =?utf-7?B?QVRVVXhRenQxVU50VGUrLVJ5dklxT1BVYzlUTWYvenkzRmhGZ2VQTlBvUmJ5?=
 =?utf-7?B?VCstMFhDdldrOGFtYzhsRDVjMnJjVm1xKy1WYjk3WUt4NnFZRjNoV1JLb0Ju?=
 =?utf-7?B?d01kSjdFdkFRdVU3RHdNZjZ3S3VnNEVkNUwzcGhRbGo2VFZad1RsU2kwbmov?=
 =?utf-7?B?aGVyc3N2YS9Kd0pGWXJtVDIySkx2VjhraG9lNFdCT2Mxei9TS2U2d3kzQ002?=
 =?utf-7?B?bzJucHlYU1VvcGc3cnVkcjJXc3B5aXpMVXVmeWd6OQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?bFhKOEV4c2QrLUNPZjI2SFZDd3YrLWFBQmNMRlo2T21kR2ZISWJrTGNDNzkw?=
 =?utf-7?B?RTIyVTFRcmY3MC96dUh5UC9UU0hmcnJVUmJTNXk1LzhGVkN3bzRlYS9ha2Jl?=
 =?utf-7?B?aDd4TXY3YWVkZjJzdjgvZHN1ZzIweUhlcElUZ2hOM3hTUC92cjdmVmlJUGRq?=
 =?utf-7?B?S0NTRGcvQXFQclVGNVdKa3U4SUZGcUsrLWpTNmx6OVZaaW5QdmYxSkl5dlYz?=
 =?utf-7?B?bi94QmRxVDRxN09XdUVFNFFFWDJZRjczT1MrLVlrWmJ5R3ZidHFYTU9FcDRZ?=
 =?utf-7?B?RWNDUUlzR1c5eVcvUWttTDBBRzlVRFlyYlBuSThlejRzTmVUcFhqWFN3WnpV?=
 =?utf-7?B?ektOSGYzdTRiUi9URG1aQ3NKa0pmM0MvNTEyeFVPanlsdG10enJGZUpXRHV5?=
 =?utf-7?B?ZTAyWTk1NnlqbVVLRUdNbU1ndWdGdTdOSld1bisteDZJTzNvVmxFMnNOak9V?=
 =?utf-7?B?Nystc3dZLzV5UzZPNkp6bkdjWWNJV2x4aTdndFJOTmo0aTgzTVBycistRnFY?=
 =?utf-7?B?Qmg2bmE4dWl3Mi9uazJIZWZYd05QOEtoVElrVkxlRUV6SHoxbjJlVjQzVklP?=
 =?utf-7?B?bFpxdG9tWWFWKy1tcWI2elUwR1REZm9iUVVmYlNuM1dKMjI3bEpFemVJSUU0?=
 =?utf-7?B?aTZoTThjWWhUMUdGei8zb2ExQk1PdDFFdWNFM08rLXFzampldEtHZGNsMTdK?=
 =?utf-7?B?cHNydzh5akJBOVk0V0dnM25qRW5RZDZ0RGhsc0toRDFYcGlMd25sNkU1aVNH?=
 =?utf-7?B?NVFJSEdRM1BmdG1CNkl5Tm1aWFJFclFkWldZTy9KMGdhVE10NjBmWCstTXk0?=
 =?utf-7?B?cjdaQnI2SnRJT1l5cFdscVBzZDhNR2FjWnowbWhLUmE1TW04Q1ZwUms0NWFm?=
 =?utf-7?B?YXRKQzVRRnl0SDRKVVh0Z3BEQXF4TlY1UEhVb2tQcXU0Nk9oZ2dsNGgwWWp5?=
 =?utf-7?B?eDJaaHJtVUp2SnVhWG5ENnFpNUt2ZGdISCstYy9jTTQrLTVwUFVIYk5Wb0dG?=
 =?utf-7?B?bFdNckFZL1BoQ2dEUGw0OE5MUENJYnZOem9aRUw0TmRRdjFhaGt5TnI1U2V3?=
 =?utf-7?B?eG1Ga3VoM0xmOFlQL2o0Zjd6ajlzKy0ydXZnRTNQKy1yd3o5T0Nic012NjIz?=
 =?utf-7?B?ZkNNZlYwN05Ec0UvREpRL2MrLTB2d1RqV015NjdXdFNEUVRFL21QdFJNYWxs?=
 =?utf-7?B?bFV0TnJTT1JrREJBY2xVdFVjVzVMMDhaaUdxTW02Y2xPS0ZOdWtraUs4SDU3?=
 =?utf-7?B?UEs5Mzk0TElxMld3cEg5bGRHakRWc3NYZUJrWVR2RHNTVkRUKy15MFo2cTU5?=
 =?utf-7?B?anBEcENPT1ArLXovR2NuRzdjazNFQ1JaVCstMzI5WVB5UWtySkFLZ21vKy1z?=
 =?utf-7?B?d1dWV3o3Uy9SMG1lL0tqOWFqdlllZWNPVFhhT0Q0Qm5lNUhyNjZlcTRNRlZQ?=
 =?utf-7?B?dFl1VzBXUUNaelh4TklLS1RKUURqbmNkN1ljZm45bkc5YjlmbUNjdWZjUDJM?=
 =?utf-7?B?REJYS25ia2t2bUljd1pESm5tRzRodUMzNGo4cVhyTjhyL2l3S1BmcW9lYUt5?=
 =?utf-7?B?TWtvZXVyZjZFbE5aRmR2bGQyeFlwTS9Kc2MrLWtCbGtlTzhhZlF6NTBRcmFY?=
 =?utf-7?B?eERkUUpVaVpNZ3ZIT2xMZ1RZSEMwaystdTYyMGp5T0ZwSzh2aHhReG5KaTlQ?=
 =?utf-7?B?eEE0NkV6QU51RmZ5YzRmZ0d6bnNEQlV4UGp4dUd0S2w3MkV5WFR0YVh3a2VI?=
 =?utf-7?B?NGJJTVRtcWxxanA5SmtzcGxtb2N2N2JMbEVxRDdoeTduRjM5RFgvQVVNSlFk?=
 =?utf-7?B?WkZiRnhNUVVaSDJ0YmNtQnBObHVvUmw1MXB6QlQ0cGVha2JKMTFnNDlSNSst?=
 =?utf-7?B?T2ZUYistSFRsN3ZiTXJxT091Q3cxY1NxeVRrQ0hYbzFsVlUrLVBwbnQ0S0pG?=
 =?utf-7?B?WGFSaFlpM08yelN3UE1FL1Ziak5vVzEzRnBnRHR3QnJyWnIzQlhLWlBwbTY5?=
 =?utf-7?B?eTlvRHo3ZlNQYUU5WVVsWmZCUGN2dW0wdFBDczNsS0x2YkNLQjFlYSstaVVx?=
 =?utf-7?B?R2lrRmFDbzYyNDJVUm1hdHFnSGpKRGFGTHdsaTMzVkJmUEpWblkrLUZ1ZEsz?=
 =?utf-7?B?b1QxMll0S3pvQlRnUlJtei80ZnhWcUdqMVRVSW9VcE1CUVFsY3F2WjRtNHZN?=
 =?utf-7?B?UVhFczdvKy1haEFtd2tiVGV4dEV2U3FIaWZOY292cFJKS3RIODNXYWg2QVU5?=
 =?utf-7?B?VlpDZUVTNzB6bDNZNVBQeDZYOGpJQTUrLVda?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eba861c-a12c-4a9a-452d-08de1bf8992a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 23:19:26.8680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CJXzGEKRZBHbsWmEpeHIq7JBZsWXKu1YeLs6JjUT/M/1z9WzlKg5UtxOro5TDEy3gzY13iV4lZhEA+wtIPcD5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7681
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: alln-l-core-11.cisco.com


Cisco Confidential
On Tuesday, November 4, 2025 2:04 AM, Hannes Reinecke +ADw-hare+AEA-kernel.=
org+AD4- wrote:
+AD4-
+AD4- With the conversion to multiqueue the 'wq+AF8-copy+AF8-base' value we=
re left
+AD4- uninitialized for MSI and INTx interrupts, causing the driver to issu=
e
+AD4- a message 'FCPIO+AF8-SUCCESS icmnd completion on the wrong queue' and=
 finally
+AD4- running out of command tags as the completions would be accounted on
+AD4- the wrong queue.
+AD4-
+AD4- Fixes: 8a8449ca5e33 (+ACI-scsi: fnic: Modify ISRs to support multique=
ue (MQ)+ACI-)
+AD4-
+AD4- Signed-off-by: Hannes Reinecke +ADw-hare+AEA-kernel.org+AD4-
+AD4- ---
+AD4- drivers/scsi/fnic/fnic+AF8-isr.c +AHw- 2 +-+-
+AD4- 1 file changed, 2 insertions(+-)
+AD4-
+AD4- diff --git a/drivers/scsi/fnic/fnic+AF8-isr.c b/drivers/scsi/fnic/fni=
c+AF8-isr.c
+AD4- index 7ed50b11afa6..e16b76d537e8 100644
+AD4- --- a/drivers/scsi/fnic/fnic+AF8-isr.c
+AD4- +-+-+- b/drivers/scsi/fnic/fnic+AF8-isr.c
+AD4- +AEAAQA- -350,6 +-350,7 +AEAAQA- int fnic+AF8-set+AF8-intr+AF8-mode(s=
truct fnic +ACo-fnic)
+AD4- fnic-+AD4-cq+AF8-count +AD0- 3+ADs-
+AD4- fnic-+AD4-intr+AF8-count +AD0- 1+ADs-
+AD4- fnic-+AD4-err+AF8-intr+AF8-offset +AD0- 0+ADs-
+AD4- +-             fnic-+AD4-copy+AF8-wq+AF8-base +AD0- fnic-+AD4-rq+AF8-=
count +- fnic-+AD4-raw+AF8-wq+AF8-count+ADs-
+AD4-
+AD4- FNIC+AF8-ISR+AF8-DBG(KERN+AF8-DEBUG, fnic-+AD4-host, fnic-+AD4-fnic+A=
F8-num,
+AD4- +ACI-Using MSI Interrupts+AFw-n+ACI-)+ADs-
+AD4- +AEAAQA- -376,6 +-377,7 +AEAAQA- int fnic+AF8-set+AF8-intr+AF8-mode(s=
truct fnic +ACo-fnic)
+AD4- fnic-+AD4-wq+AF8-copy+AF8-count +AD0- 1+ADs-
+AD4- fnic-+AD4-cq+AF8-count +AD0- 3+ADs-
+AD4- fnic-+AD4-intr+AF8-count +AD0- 3+ADs-
+AD4- +-             fnic-+AD4-copy+AF8-wq+AF8-base +AD0- fnic-+AD4-rq+AF8-=
count +- fnic-+AD4-raw+AF8-wq+AF8-count+ADs-
+AD4-
+AD4- FNIC+AF8-ISR+AF8-DBG(KERN+AF8-DEBUG, fnic-+AD4-host, fnic-+AD4-fnic+A=
F8-num,
+AD4- +ACI-Using Legacy Interrupts+AFw-n+ACI-)+ADs-
+AD4- --
+AD4- 2.43.0
+AD4-
+AD4-

Thanks for this change, Hannes.
The fnic team will review this and get back to you.

Regards,
Karan
