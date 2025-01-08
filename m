Received: from alln-iport-2.cisco.com (alln-iport-2.cisco.com [173.37.142.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED31410E4
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 05:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736312574; cv=fail; b=W10G1B2sTZpHfg83cNlHo7Nkkz8UtA0URgp+PiMbFPc6S8m/CsagzOWrZieZ0lqkuP5mOkcRYSM9v9eTHfwxPM+5OcitZ2vw1zMdBurfaNQroZsKwOnvarVm3S71/h0KrG8OB8Di6u6M1a1wNf0Eaqjv4GHpY4rOG8NjERSYauA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736312574; c=relaxed/simple;
	bh=bpqwQw18YeO8Uq9xovKVL4i60XCh2M6H8sKt78XSnR4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b7f6UjdyaPJY5fS5NTEJ2fo3bTVLgO7vHWo7/JgQ8bixXlGkhihqhCqqiJvakrMjkBbS2wipjPUcQd4p7d6+E7x6A4Bfsi0RIPwp69dIr03/OGlvzBRDVmlCcZm06NVohn8u/o0QsK5HCxDLVugeoz7hckM7Hsior431qix2s/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=lLb06xIR; arc=fail smtp.client-ip=173.37.142.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="lLb06xIR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=3438; q=dns/txt; s=iport;
  t=1736312573; x=1737522173;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d9VqIRL38iyaXCjkXUym2dKCLhYD1my6LllGohJTXoM=;
  b=lLb06xIRJauw5G80bbnV/6XE9Kew8D0rgjfkoveyI7lB3YveKbhDJByP
   XtTtH+c3dfngMevFsnvXbjmqZKwCAyIuCaNZBnGWOovpbVzpcuEc+LYeb
   xu1O9irNKu1rI+r3y5SQIN+ZOtd0iwSqISvg86LoYd0jRZYadsy4lx1wj
   o=;
X-CSE-ConnectionGUID: Ve7nQNq7QFeDQC+xhwxJ9Q==
X-CSE-MsgGUID: T1TsyIK/SVWzDArqn3+llw==
X-IPAS-Result: =?us-ascii?q?A0ABAAC5BX5nj5MQJK1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQCWBGgUBAQEBCwGBcVKCGUiIIQOETl+IdZFKjE6Bfg8BAQEPR?=
 =?us-ascii?q?AQBAYUHAop0AiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHB?=
 =?us-ascii?q?RQBAQEBAQE5BUmGCIZaAQEBAQMSFRM/EAIBCBgeEDElAgQOBQgagl+CZQMBp?=
 =?us-ascii?q?VsBgUACiit4gQEzgQHgIIFIAYgzGgFyiXAnG4INgRVCgjcxPmmDXIQTgi8Eg?=
 =?us-ascii?q?jNLgSuCWWeGZocfkA5SexwDWSwBVRMXCwcFgSkfKwOBFCaBKwU1QTqCDGlLN?=
 =?us-ascii?q?wINAjWCHnyCK4IhgjuER4RYhWiCF4FrAwMWE4J9HUADC209NxQbBQSBNQWab?=
 =?us-ascii?q?jyCfYFtlhODM5Axn08KhBuhfBeEBKZPmHyCWKB/Ew0ZgSGDUgIEAgQFAg8BA?=
 =?us-ascii?q?QaBZzqBW3AVO4JnUhkPjjq5Sng8AgcLAQEDCZA8YAEB?=
IronPort-PHdr: A9a23:JrD74ReB3EjCtq9HyLJ4t8h+lGM/gIqcDmcuAtIPkblCdOGk55v9e
 RGZ7vR2h1iPVoLeuLpIiOvT5rjpQndIoY2Av3YLbIFWWlcbhN8XkQ0tDI/NCUDyIPPwKS1vN
 M9DT1RiuXq8NCBo
IronPort-Data: A9a23:TOdLgq0m7K7RMBBuWPbD5d9xkn2cJEfYwER7XKvMYLTBsI5bp2BTy
 WBOCDyGafqKYDfzLth0bd+x8U4AvMSAnNZqSARk3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmE4E/watANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXU4
 7sen+WFYAX4g2csYjpNg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGMkxpO7Q+47lOL2xiz
 NdbODASfjLSvrfjqF67YrEEasULJc3vOsYb/3pn1zycVK5gSpHYSKKM7thdtNsyrpkRRrCFO
 YxAN3w2MEuojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZjOCybISEK4HRLSlTtnrBm
 nnX3ke+OS8lJvC20yODqTGogvCayEsXX6pJSeXnraQ16LGJ/UQXCRsLRR6gquK4olCxVsgZK
 EEO/Ccq668o+ySWosLVVhm8pjuA+xUbQdcVSrV84wCWwa2S6AGcboQZctJfQOIr68kPYyV17
 3GEs+rCRixvr623GEvIo994sgiOESQSKGYDYwoNQg0E/8TvrekPYvTnEIwL/Emd0IGdJN3g/
 w1muhTSkFn6sCLq60lZ1Q2f695PjsGVJuLQ2ukxdjn4hu+eTNX+D7FEEXCBsZ59wH+xFzFtR
 kQslcmE9/wpBpqQjiGLS+hlNOj2vKjfb2GD3QA+QMZJG9GRF5iLINA4DNZWeRYBDyr4UWWyC
 KMukVoLvcYNYCvCgVFfPNLpV5lCIVfc+STNDa2MMYEUPfCdhSeM/TplYgaLznvxnU032aA5M
 tHzTCpfJShyNEiT9xLvH711+eZynkgWnDqDLbillE7P+eTFOxaopUItbADmghYRsPjc+F29H
 hc2H5fi9iizp8WnPnSNrddIfABSRZX5bLivw/Fqmie4ClMOMEkqCuTaxvUqfIkNokifvr6gE
 q2VMqOA9GfCuA==
IronPort-HdrOrdr: A9a23:5mqghap5W1HmYc9pDlB9SSkaV5tkLNV00zEX/kB9WHVpm5Oj5q
 OTdaUgtSMc1gxxZJh5o6H/BEDhex/hHZ4c2/h2AV7QZniWhILOFvAs0WKC+UytJ8SQzJ8m6U
 4NSdkbNDS0NykEsS+Y2nj3Lz9D+qj7zEnAv463pBkdL3AOV0gj1XYENu/xKDwOeOAyP+tDKH
 Pq3Ls+m9PPQwVxUu2LQlM+c6zoodrNmJj6YRgAKSIGxWC15w+A2frRKTTd+g0RfQ9u7N4ZnF
 QtlTaX2oyT99WAjjPM3W7a6Jpb3PH7zMFYOcCKgs8Jbh3xlweBfu1aKv2/lQFwhNvqxEchkd
 HKrRtlFd908Wntcma8pgao8xX80Qwp92TpxTaj8DjeSI3CNXAH4vh69MZkmyjimg0dVRZHoe
 R2Nleixt9q5NX77X3ADpbzJklXfwGP0AofeKYo/g9iuM0lGf5sRUh1xjIOLH/GdxiKs7wPAa
 1gCtrR6+1Rdk7fZ3fFvnN3yNjpRXgrGAyaK3Jy8fB9/gIm1UyR9XFojPA3jzMF7tYwWpNE7+
 PLPuBhk6xPVNYfaeZ4CP0aScW6B2TRSVaUWVjibGjPBeUCITbAupT36LI66KWjf4EJ1oI7nN
 DEXElDvWA/dkryAYmF3YFN8BrKXGKhNA6dgP129tx8oPnxVbDrOSqMRBQnlNahuewWBonBV/
 O6KPttconexKvVaPF0NiHFKu1vwCMlIb8oU/4AKieznv4=
X-Talos-CUID: 9a23:6bNCs2DDyN3tRKz6Exdqq0gtPNl6S1PQ4E77YF+4FnZLGYTAHA==
X-Talos-MUID: 9a23:A9HJEQY+/ofPsOBTi2bQnyBDF4BT3Zu8JGkXiJNd+M2AKnkl
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-10.cisco.com ([173.36.16.147])
  by alln-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 05:02:46 +0000
Received: from rcdn-opgw-5.cisco.com (rcdn-opgw-5.cisco.com [72.163.7.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-10.cisco.com (Postfix) with ESMTPS id 57ED41800027A
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 05:02:46 +0000 (GMT)
X-CSE-ConnectionGUID: Yy7VhVWASlKPN07HMEtdUg==
X-CSE-MsgGUID: VTHP2w/zSoKjaO3ic+HFHw==
Authentication-Results: rcdn-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.12,297,1728950400"; 
   d="scan'208";a="21085972"
Received: from mail-dm6nam10lp2041.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.41])
  by rcdn-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 05:02:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ddACAXkjnXCpvBIYZNT5f3wHr5Q640frjgLRI4StIupbkWFqFpHaULtavm7oq7pL03NTzrxyKJX7AdIvTlzM61ZRFxE0LzPOuEvrOjc7WL5RxJGlqfk+g05jiyMMkHrNvoDP9ZzpJhIFGLKEiZmA/qIlEQoxTbkeUrsZKKf9lkv2uJ6YSjlSbCrvdd8xabKuPIbdjKqa41nunGfIMLSGYhzLtCJFT1ikOvA8m45CRqFozkgMhwTx8swkS0eNfxt8fgTGj1KEeo+OVQkMhvX13K7gju8uERsyKqGYitbMLRrPayj3RaCsUJ2UFqz5FLNNu3EpQvHpMW9RzFfe/wpXZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9VqIRL38iyaXCjkXUym2dKCLhYD1my6LllGohJTXoM=;
 b=QOkgdM38Xb4E2qfrXAILDGXnjdOQH1jMhfMZEO9+jDgbGFs8huecx/pImZ3QDHcKe+XYMEKBqmrRVuyMx0cmY2RrH+NHXEQgHdQGZ2tUWTpRhosvGTbCWZZsV1cfdXK9+4TYuapr/kRZ5ojACessiPp3eM/7iAQOl+rI8nWBkPw3bxoZGs7pBiwq4FFn6FbLRhI0NL2sO2+occQOaOv23sA22oK2FSOgbcuDyU7H9/tKaq1IMo3/tgNeQRr6/2ndb/OnKtYXSzpcjrMBpzJa1tVXLoDQdwvrqNA0h2JhavjCx2WqrMpefqihNRy6obLZ7jo/7IdO950qufJXClByaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DS0PR11MB6519.namprd11.prod.outlook.com (2603:10b6:8:d1::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Wed, 8 Jan 2025 05:02:41 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 05:02:40 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar
 Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy (arulponn)"
	<arulponn@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Masa
 Kai (mkai2)" <mkai2@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>
Subject: RE: [bug report] scsi: fnic: Modify fnic interfaces to use FDLS
Thread-Topic: [bug report] scsi: fnic: Modify fnic interfaces to use FDLS
Thread-Index: AQHbYOtbffLgyzNcx0aZfQ7baoll6LMMUhCQ
Date: Wed, 8 Jan 2025 05:02:40 +0000
Message-ID:
 <SJ0PR11MB58965593237C1C118C5C4121C3122@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <382a9f41-dbb4-4039-abcd-cb0497c37d52@stanley.mountain>
In-Reply-To: <382a9f41-dbb4-4039-abcd-cb0497c37d52@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DS0PR11MB6519:EE_
x-ms-office365-filtering-correlation-id: a1b012e1-d0dd-464b-564f-08dd2fa1adbe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?1NWJqWI4aD2ogMm7+5x6tFWXhexxYf4tM7m8RlCYDqafAoxzGBl03aoiXB7n?=
 =?us-ascii?Q?BkTdWdzzF+ofwd+p78mX95baeudo7yp2sFfhvhdH8cwApB7pcDaaA74e3UWv?=
 =?us-ascii?Q?hRvfB59KCP54b4xJCQoXsreu2AAf40ZHJGUXvz2LvHmsv1Brp6yI+zugSOqj?=
 =?us-ascii?Q?0Y8OHcvbGEuWa8As9T/qVd4AslKCE+W6LjjesWUkxSxr8RgKVgf1j0aEIQyu?=
 =?us-ascii?Q?VzUjGIU+VdMJkyomwD26cXgdgAXCW/ju4K2lylMi0C4jzHH7lT+S9S8n7EHR?=
 =?us-ascii?Q?3SQamaHF3lzzR4vMQQGDxubG+0jCsB9FTRaPU8nzZfwg/LvMq6iqshFKOkba?=
 =?us-ascii?Q?KkgbSWuxxf+341M9cCBC7jadF6tSFu3lKdm7EpgbRmOXDDVkjfJH4d14G+y/?=
 =?us-ascii?Q?v2UMtgg2VVMVg0gyhkiQrNtEG7CwEwuMcGIgc0ElY9ZlqZ9NuSH2VyoIIYet?=
 =?us-ascii?Q?+sQxu0ajeK4lsXssf9oz0H/3LDgX54uAQCr5HNx6+829KA8hRYDuilx4GJER?=
 =?us-ascii?Q?xad6aFXzhct6tC6a+/ZFHgnm6DQla5WryGoERiHVx6qs2t7TVzQjTfJWlQL/?=
 =?us-ascii?Q?KuUHXJhGZhT2h2L/Dyb0Z6vc0ZhvmfSsWSm+XzvyqFCq72bSCFh0vgaU+a5b?=
 =?us-ascii?Q?BAYRzoNYKEYe08qRk3GcVk2EHR5uRDglxemUPIXZojzWqeRb7w/PPZDyuWRf?=
 =?us-ascii?Q?wY7zcDEYuSSJ1UiIV5xQukxqLUr113e1sn4FdMyBWqohDNCq0beBwdrDO96S?=
 =?us-ascii?Q?fi3bKPsrrzS9wimhstJeYUk3dsiHcEcXCKl5sVMaNlM4s91rswa938mhKskx?=
 =?us-ascii?Q?NJVG7Ad6E1T3CquuFQNOgns8qe7uOo4+pf8WjfmV3UBFM+EBT0oMpymsFtHw?=
 =?us-ascii?Q?1XeiZ90jbDK/mEALw9cEVhWN0s0V8gLD1/kXiXa12BbII4HEEciAo+i8vvmS?=
 =?us-ascii?Q?YI/vklZ2ESHCCElgjYoCuG3fQ1DjWAlrF+Eo/avLLZx4qJk6j1hQDduNdoje?=
 =?us-ascii?Q?EVdV0JoT3NEUzqjy0Uc8czRfXR6v5sHpqINmhauz7Np4n4chOnGbxiXxUm7y?=
 =?us-ascii?Q?cCxHc3qJafNy6dF8fhiVNhgkecOVwFq/l8G7YJJicYoYjlRsvdt7kAzg8PWW?=
 =?us-ascii?Q?9T99VgcbFgyAavcDokVJlKwUUHUjhe6NoZo7sGplr0z8KjyfQ93XurihLZvA?=
 =?us-ascii?Q?WHKbdnCj3sZUSCIWKM4Enm9VSQVOko45Gq7WM7hFe4mqdS41VEz7vXBomhPH?=
 =?us-ascii?Q?ps5buNZ4aqEjPpDrRFAW0qWOKhGbeU/fw8eZhAqlAeoSnytFVEoS6Ny5/PRS?=
 =?us-ascii?Q?D/ZIQo/hjy/fY8oG9w0Wo1xEYg+srb8MgM+woZpUTSwAWyhS3QPyDrOyiZTp?=
 =?us-ascii?Q?wv3Aji0LbVaiuzR6/pzmaQ6nKNI2HSAcjPG79i9CxzGZC/UQU03UqIERrvIN?=
 =?us-ascii?Q?oDctRjAjZLkBDHLAm9lCasWKxflraH3j?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?TXJq21M48i5vlgrk85lDjWjZ+6rHr90yLHw3pJ8Kzz6grOEIC4e8JCz1R93I?=
 =?us-ascii?Q?0CcOfk8/bVbjZ1N0F2C25nEicRiENfJWw064PR8DCiFVx96fxGCh6vliG4ET?=
 =?us-ascii?Q?fkO23myhLmlR/o9BI5rjOJ7izluHYYkRZLqCQG1n0s37MUFUJh0YS72S9vW3?=
 =?us-ascii?Q?BToJI0DJSsflJvOYKc1cD3ENlNt3MCvnk/eTltl/WbnRZS4LGqlODos8UqhE?=
 =?us-ascii?Q?StE3g8DdtSmJoKi5BOrI81yfCBy1/pH+gkiao2mO2uaGa+mSAitcClV5K1ge?=
 =?us-ascii?Q?jw89RBjZkXknVd8Kez3k15/nFOOSpheIQSheJYQy9f+VJUGikMSkPY1ldPuc?=
 =?us-ascii?Q?EJpN7tYn41sqgaxEtE/G9tP6CrGd4YrxJnfpCl5K52tlsovkmKZOH813v/cB?=
 =?us-ascii?Q?URkJOC+53ZD5814tAEUDKDyLtgvHHlwmYDHKYDPcoO6Heun7WBFVA/jPigM7?=
 =?us-ascii?Q?alPvQ9pGDPXCz5QeyZOrfWMS/WQXxEVYo1Jc9nnYxvn5grZ5IAjoptFJoBGQ?=
 =?us-ascii?Q?q1u5GpSwFhwMH2k8Ju3t5Wvsc366LMmmm8EKJes4YdPphZxApPK6MUHPmGyN?=
 =?us-ascii?Q?shFgQy6mZbSMAG0nWEuKjpKQ8/gKjQZxJhtiTA2JIPl5fIGxKomN3Fow0EjD?=
 =?us-ascii?Q?eWHch3neKjYvZWz8SI/agL/brf3P2NS7YWpJIXGFu5G88mdDxmzjqbELLLkN?=
 =?us-ascii?Q?cF1/hsx1n0EIaZn0XdX+4FVetmdU1RPGIs5+14MEDzz2Gl329XqLaksaVBkm?=
 =?us-ascii?Q?FlS1bzFOu+Xzm1uKHuBPOtQXsVYF0TgQYcTa9vKunQdHY3WYpgLq64cZYxTZ?=
 =?us-ascii?Q?NPuD6I13JVZ03GmH6mcq8qNzzDZvIUdheLl+SgAyEnQJ1xTJ/7BQ1goaUsyF?=
 =?us-ascii?Q?7+6FOwwA0K8oPII6/NudZHXPsOtg+fCPCQYbfXeq8eo9SbxiYQHNtfhU21+Z?=
 =?us-ascii?Q?tq0O7oNufScPLhQPf0TEmfIOtXzvbzA4Hp8UcskrOzxbyb0jl/EwaaeN2PYF?=
 =?us-ascii?Q?NXXIyl00CNWKDZ8kjYkEDjKjKSAQYXy0v8IfiPa5yiTZ5yvSYeCDZ/8ZQjih?=
 =?us-ascii?Q?N/U4vYtVaIhbZr9zCzcEOD9UpOsNm222iO0KsNfPlTh82IlM20stLek5K7ya?=
 =?us-ascii?Q?FY5piGklSFQ0MM6dQ+E+DSc0WWebi/uw8aTdnKxxPAJAro9KTR+ibNQDJe0o?=
 =?us-ascii?Q?htGwJlSf1YSlJN5WbVQipDcXITvgdyKlLkHLeRo6ajRvVof+oHQSL2PDfYrn?=
 =?us-ascii?Q?OYVebfubNaq/EL9RJHXpV+29/4XpTm4Dn4jux8ahWdj7tT8bTYTRWndCUOkX?=
 =?us-ascii?Q?zgcGKSO/tX6SE/gL/MpEpl/lxfupVn/ptQnXgveBpGfCz451x1750wpvur6a?=
 =?us-ascii?Q?0H89f3iFbYYi4wfl7ngr/QKTLuThOmxW9FYLDn8cRTDimA1D5Y2z53xDQZ6/?=
 =?us-ascii?Q?6CfkZHihBQ56z+J747QPmpvBD4CAwmNJLwuvQvcL+4JcrxjZSSX9EV8ry7ar?=
 =?us-ascii?Q?pHUoLeYLrvDynou/PVsVayj9ZXWvaofLke0oSmjYDtbpGGZV6kd8qXC3bIId?=
 =?us-ascii?Q?plCAoAwJALMvnSM0pj4n0kcPMsDql88a9/AVlpXL9L9FZZWn1ffWG4ndkuCj?=
 =?us-ascii?Q?YjSAA7i7y922JhSwHo2qerQ=3D?=
Content-Type: text/plain; charset="us-ascii"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b012e1-d0dd-464b-564f-08dd2fa1adbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2025 05:02:40.7327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xubYNGwKeyqZPF5169IgjbN8pniSN9nIG+s9jNww4y63XvTHaYayWv+rhZjuRi75SAXOrMpz4ROS4sH4tdmpVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6519
X-Outbound-SMTP-Client: 72.163.7.169, rcdn-opgw-5.cisco.com
X-Outbound-Node: alln-l-core-10.cisco.com

On Tuesday, January 7, 2025 2:03 AM, Dan Carpenter <dan.carpenter@linaro.or=
g> wrote:
>
> Hello Karan Tilak Kumar,
>
> Commit 9243626c211e ("scsi: fnic: Modify fnic interfaces to use
> FDLS") from Dec 11, 2024 (linux-next), leads to the following Smatch
> static checker warning:
>
> drivers/scsi/fnic/fnic_main.c:1034 fnic_probe()
> warn: missing error code here? 'fnic_scsi_drv_init()' failed. 'err' =3D '=
0'
>
> drivers/scsi/fnic/fnic_main.c
> 1020
> 1021         vnic_dev_enable(fnic->vdev);
> 1022
> 1023         err =3D fnic_request_intr(fnic);
> 1024         if (err) {
> 1025                 dev_err(&fnic->pdev->dev, "Unable to request irq.\n"=
);
> 1026                 goto err_out_fnic_request_intr;
> 1027         }
> 1028
> 1029         fnic_notify_timer_start(fnic);
> 1030
> 1031         fnic_fdls_init(fnic, (fnic->config.flags & VFCF_FIP_CAPABLE)=
);
> 1032
> 1033         if (IS_FNIC_FCP_INITIATOR(fnic) && fnic_scsi_drv_init(fnic))
> --> 1034                 goto err_out_scsi_drv_init;
>
> Missing error code.
>
> 1035
> 1036         err =3D fnic_stats_debugfs_init(fnic);
> 1037         if (err) {
> 1038                 dev_err(&fnic->pdev->dev, "Failed to initialize debu=
gfs for stats\n");
> 1039                 goto err_out_free_stats_debugfs;
> 1040         }
> 1041
> 1042         for (i =3D 0; i < fnic->intr_count; i++)
> 1043                 vnic_intr_unmask(&fnic->intr[i]);
> 1044
> 1045         spin_lock_irqsave(&fnic_list_lock, flags);
> 1046         list_add_tail(&fnic->list, &fnic_list);
> 1047         spin_unlock_irqrestore(&fnic_list_lock, flags);
> 1048
> 1049         return 0;
> 1050
> 1051 err_out_free_stats_debugfs:
> 1052         fnic_stats_debugfs_remove(fnic);
> 1053         scsi_remove_host(fnic->host);
> 1054 err_out_scsi_drv_init:
> 1055         fnic_free_intr(fnic);
> 1056 err_out_fnic_request_intr:
> 1057 err_out_alloc_rq_buf:
> 1058         for (i =3D 0; i < fnic->rq_count; i++) {
> 1059                 if (ioread32(&fnic->rq[i].ctrl->enable))
> 1060                         vnic_rq_disable(&fnic->rq[i]);
> 1061                 vnic_rq_clean(&fnic->rq[i], fnic_free_rq_buf);
> 1062         }
> 1063         vnic_dev_notify_unset(fnic->vdev);
> 1064 err_out_fnic_notify_set:
> 1065         mempool_destroy(fnic->frame_elem_pool);
> 1066 err_out_fdls_frame_elem_pool:
> 1067         mempool_destroy(fnic->frame_pool);
> 1068 err_out_fdls_frame_pool:
> 1069         mempool_destroy(fnic->io_sgl_pool[FNIC_SGL_CACHE_MAX]);
> 1070 err_out_free_dflt_pool:
> 1071         mempool_destroy(fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT]);
> 1072 err_out_free_resources:
> 1073         fnic_free_vnic_resources(fnic);
> 1074 err_out_fnic_alloc_vnic_res:
> 1075         fnic_clear_intr_mode(fnic);
> 1076 err_out_fnic_set_intr_mode:
> 1077         if (IS_FNIC_FCP_INITIATOR(fnic))
> 1078                 scsi_host_put(fnic->host);
> 1079 err_out_fnic_role:
> 1080 err_out_scsi_host_alloc:
> 1081 err_out_fnic_get_config:
> 1082 err_out_dev_mac_addr:
> 1083 err_out_dev_init:
> 1084         vnic_dev_close(fnic->vdev);
> 1085 err_out_dev_open:
> 1086 err_out_dev_cmd_init:
> 1087         vnic_dev_unregister(fnic->vdev);
> 1088 err_out_dev_register:
> 1089         fnic_iounmap(fnic);
> 1090 err_out_fnic_map_bar:
> 1091 err_out_map_bar:
> 1092 err_out_set_dma_mask:
> 1093         pci_release_regions(pdev);
> 1094 err_out_pci_request_regions:
> 1095         pci_disable_device(pdev);
> 1096 err_out_pci_enable_device:
> 1097         ida_free(&fnic_ida, fnic->fnic_num);
> 1098 err_out_ida_alloc:
> 1099         kfree(fnic);
> 1100 err_out_fnic_alloc:
> 1101         return err;
> 1102 }
>
> regards,
> dan carpenter
>

Thanks for this bug report, Dan. Appreciate your help.
We will address this in a future update.

Regards,
Karan
