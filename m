Received: from alln-iport-7.cisco.com (alln-iport-7.cisco.com [173.37.142.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E8E13B797
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 05:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736312936; cv=fail; b=qRPrYhahvJf07Gp+/n+Gv3YbGmhWOzAYDygHBQnPmS3N0ZfqdVKfjRIsNQIHZ1aMZwqpI/q731pa0LIA3is8ZXEuUOtUeYg+L2bRilHrxFRBuwK9zTTBeQpmHLdpIhwzQHZhfBeDjqQu83DH+VLtsufdQ4Wz8gW8PKHGZ1vl9Yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736312936; c=relaxed/simple;
	bh=95ScebRzq6ClgpM67AWfS5dqQvFRZPHzlHY4Yy5eqas=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pveObH0hmAXHGYdj6O58U8/OY6Zf7OnpoKhwvvLQTdtxl/MWF8AMR8IL7LOGscsisiViiMYb9Tt1ZgUHaYNMtEZriI0HP9YKcVEzyijp7baLQxqKFgJ8+xeVhW4ZKMwoEVknIthD9erkFpZ2kufNCvvoDPIUQXGNW07xYwvWwfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=Xqb9hrwg; arc=fail smtp.client-ip=173.37.142.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Xqb9hrwg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2233; q=dns/txt; s=iport;
  t=1736312934; x=1737522534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H0+HkKzsTNeCEt41XY8Epq8WP0ou1oiUIMy9PH6SBnI=;
  b=Xqb9hrwgzJCtaCyEN/pjcFw1bUB0DqrCypB5HLcBGlYrN7HxwMAYOvWr
   76LIwMF+gyK0M6Cmb9a2YGNOnLwlM3h2R3M0xRzZRtIOe5Ft8ruhNiqvG
   ZjrMG/3rloaDUS9cUA3D5gKm835DbtV0G8l2jO7YTLOGfz3DNwDTDndPh
   w=;
X-CSE-ConnectionGUID: Kjb/6vvxTSai2wnIq2+oww==
X-CSE-MsgGUID: hhYb7Jh7QMGh0RjBZyFVog==
X-IPAS-Result: =?us-ascii?q?A0ANAAArB35nj5T/Ja1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEaBwEBCwGBcVKCGUiIIQOETl+IdZ4YgX4PAQEBDQJEBAEBhQcCinQCJjQJD?=
 =?us-ascii?q?gECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFFAEBAQEBATkFDjuGC?=
 =?us-ascii?q?IZaAQEBAQMSFRM/EAIBCBgeEDElAgQOBQgagl+CZQMBpVsBgUACiit4gQEzg?=
 =?us-ascii?q?QHgIIFIAYgzGgFyiXAnG4INgVeCNzE+aRwBgz+EE4IvBIIzS4ErgllnhmaHH?=
 =?us-ascii?q?5AOUnscA1ksAVUTFwsHBYEpHysDgRQmD4EcBTVBOoIMaUs3Ag0CNYIefHiBM?=
 =?us-ascii?q?4IhgjuER4Q4IIVoQoE3HoFrAwMWE4J9HUADC209FCMUGwUEgTUFmm48hCBKg?=
 =?us-ascii?q?nyTFwkBP4JqkDGdDIJDCoQboXwXhASmT5h8gligfxMmhHMCBAIEBQIPAQEGg?=
 =?us-ascii?q?Wc6gVtwFYMiUhkPjjofuSx4PAIHCwEBAwmGS4pRAQE?=
IronPort-PHdr: A9a23:DeR1vBByQbmHhQUMzsJmUyQVXRdPi9zP1kY9454jjfdJaqu8us6kN
 03E7vIrh1jMDs3X6PNB3vLfqLuoGXcB7pCIrG0YfdRSWgUEh8Qbk01oAMOMBUDhav+/Ryc7B
 89FElRi+hmG
IronPort-Data: A9a23:oz3niq7PQugkbhcOuAuJ0gxRtDfHchMFZxGqfqrLsTDasY5as4F+v
 mAfUW/UM67ZMzfxc4gibtuw8E9TscPUzYcxQVZr+S9jZn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH1dOC89RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wr+aUzBHf/g2QpajtMu/rawP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eHo8SvbhpH3Fyz
 vUZci8LTwnZxOWp3+fuIgVsrpxLwMjDJogTvDRkiDreF/tjGMmFSKTR7tge1zA17ixMNa+BP
 IxCNnw1MUmGOkEfUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGIaNK4fRHJgIxC50o
 ErG/1XzXTMaa+W65jrdyHCGtP7hoyT0Ddd6+LqQraMy3wbJmQT/EiY+UVq9vOn8kUWlWvpBJ
 EEOvCkjt64/8AqsVNaVYvGjiGSPshhZX59bFPc3rVjUjKHV+A2eQGMDS1atdeDKqucVRzZti
 EGXj+/SDD01r7u0UCje8aiL+Gba1TcuEUcOYioNTA0g6tbloZ0ugh+ncjqFOPDv5jESMW+sq
 w1mvBQDa6MvYdnnPphXHGwrYRrx/fAlrSZsum07u15JCCsiO+ZJgKTztjDmAQ5odtrxc7V4l
 CFsdzKixO4PF4qRsyeGXf8AGrqkj97cb2aC2wEzQMV/pmvyk5JGQWy2yGwuTKuOGptVEQIFn
 GeJ4mu9GbcKZiLzM/MnC25PI5t6lfS9fTgaahwkRoETOscqLlDvENBGbk+L1Geli1k3jaw6I
 t+ad83qZUv2+ow5pAdas9w1iOdxrghnnDu7bcmik3yPj+HEDFbLEuhtDbd7RrxihE9yiFmOq
 44HXyZLoj0DONDDjt7/qNJOdwxTdilrXfgbaaV/L4a+H+avI0l4Y9f5yrI6cIsjlKNQ/tokN
 FnkMqOE4DITXUH6FDg=
IronPort-HdrOrdr: A9a23:N6V/M6Ok/ahHOsBcT47255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
 nxppUmPEfP+UgssREb9expOMG7MBXhHO1OkPgs1NCZLUbbUQqTXc1fBOTZskfd8kHFh4pgPO
 JbAtdD4b7LfBZHZKTBkXSF+r8bqbHtntHL9ILjJjVWPH1Xgspbnn5E43OgYzZLrX59dOIE/f
 Snl616jgvlU046Ku68AX4IVfXCodrkqLLKCCRtOzcXrCO1oXeN8rDVLzi0ty1yb9pI+9gf2F
 mAtza8yrSosvm9xBOZ/XTU9Y5qlNzozcYGLNCQi+AOQw+cyjqAVcBEYfmvrTo1qOag5BIBi9
 /XuSotOMx19jf4Yny1mx3wwAPtuQxeqEMKiGXow0cLk/aJAA7SOPAxwr6xtSGprXbIiesMlZ
 6jGVjp7qa/QymwxBgVrOK4Jy2C3nDE0kbK19RjzkC2leAlGeVsRUt1xjIPLL4QWC3984wpC+
 9oEYXV4+tXa0qTazTDsnBo28HEZAV5Iv6qeDlKhiWu6UkfoFlpi08DgMAPlHYJ85wwD5FC+u
 TfK6xt0LVDVNUfY65xDPoIBZLfMB2BfTvcdGaJZVj3HqAOPHzA75bx/bUu/emvPJgF1oE7lp
 jNWE5R8WQyZ0XtA8uT24AjyGGGfEytGTD2js1O7ZlwvbPxALLtLC2YUVgr19Ctpv0Oa/erLc
 pb+KgmdMMLAVGebbqhhTeOKaW6AUNuJfEohg==
X-Talos-CUID: 9a23:E5JTQGFT8cIcAth6qmJE9kRTRN47YkHmxXaKPEmZEDwqT6KKHAo=
X-Talos-MUID: 9a23:w1qM3AWMOBsJCBbq/D/stTs9Fsc32oGBCBg3k780que6MiMlbg==
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-11.cisco.com ([173.37.255.148])
  by alln-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 05:08:46 +0000
Received: from alln-opgw-2.cisco.com (alln-opgw-2.cisco.com [173.37.147.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-11.cisco.com (Postfix) with ESMTPS id A301218000254
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 05:08:46 +0000 (GMT)
X-CSE-ConnectionGUID: DUMxHNjeQfCYh/dgoSin7w==
X-CSE-MsgGUID: 8QU/WE3zQJORsZbRzImrEg==
Authentication-Results: alln-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.12,297,1728950400"; 
   d="scan'208";a="16883606"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by alln-opgw-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 05:08:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rwgpMgPi1W1Jvbga5fUk9TA6G3R3l6qm7jKYfzglGQdRyDp9vrbZGGD7c5DJnc9YdeHQjMfF7NeGDqaYt3cLNwDZpa+sPLxcJq3uMhx1WldmXgRaRqmhokRqTt05UP/Py3MMwI27AJxnSXvVGuNQXlLpkXZ7jSBzrl0jDlOvyBhqX28Jaxn3ETarLT8qKonVs8I1uz8n+RNRjEQxbcObCG3OdryZhoR4UA+TOwOLAI6TxASGsYg9LcSPcd7PJTsA7NKcViyRONwmm9/hjVEtap1OjdWc/5a3F0STeOqWsc6RbBtYvrmDQ46mtbtSAH72ni9Y5HanHqZozPsFcnX2GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0+HkKzsTNeCEt41XY8Epq8WP0ou1oiUIMy9PH6SBnI=;
 b=S7ofJdiGEP8sZo+l6FRzXL/AikPDsUVUILah3BePbYqM9LWkZhDQRAczR5BJVRhspz5TCjiSMYJ7f1cbacZmp6eYHswlrOdySeLnrT3nxlsuvboWqqXoS28REkpaiKk+DFqoKZlE1EvM3pwnMff4+naCehqSImhynXUTNtjSIYLzOkwIxE9dHsRUArJB96399mK6IbRxZoLxcCv6Z/8d2hQysBmgX13LfKl3HIPXeoaFj3hFoHDQnDiSwsRDNVaiXocQS24aPqhqYY3C1SkmMnXo7s+jy+UTlHTjcypbJ7sfNNIpWTAeY3VmxbQ1ip1Z2KRDXp9z8xwMy/yUlbCAug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by CY8PR11MB6939.namprd11.prod.outlook.com (2603:10b6:930:59::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Wed, 8 Jan
 2025 05:08:40 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 05:08:40 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar
 Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy (arulponn)"
	<arulponn@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Masa
 Kai (mkai2)" <mkai2@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>
Subject: RE: [bug report] scsi: fnic: Add support for fabric based solicited
 requests and responses
Thread-Topic: [bug report] scsi: fnic: Add support for fabric based solicited
 requests and responses
Thread-Index: AQHbYQ4e9RWA/x0vaEOZaWpQlLhXNLMMUxHA
Date: Wed, 8 Jan 2025 05:08:40 +0000
Message-ID:
 <SJ0PR11MB5896CE4851006AFE779790D7C3122@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <06645656-9445-4710-9646-7a2c147d1f51@stanley.mountain>
In-Reply-To: <06645656-9445-4710-9646-7a2c147d1f51@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|CY8PR11MB6939:EE_
x-ms-office365-filtering-correlation-id: 0f049304-82a3-4ad1-601b-08dd2fa28423
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Tf1gHD+WfSinUiVVXu8LWaoda/JRaLSRn0LX1xQ84ap7c5uJfdj4NxAuiOVZ?=
 =?us-ascii?Q?ffYZ/XF/HUnD7kYO+krk9irIVtk9gzZYuujarAyQGKc5Sn/QMrZmH35dmkUX?=
 =?us-ascii?Q?4V7GkkfQ7YqqWj1IdCQW4re4NkwUN53Q8V4in2NnIL+CvnDnYtSkEa+2/0O3?=
 =?us-ascii?Q?Wi5J2buwmLiQn2IaMSBoWuMgL/Lbwr3SaWQF0BHs5MryqVOnOh6wI7Mz5JvL?=
 =?us-ascii?Q?mMb2CdpvW6oacq9KSAWFsxuznvh1hDXpTyczbXs+blCuea+dNyX7dpxsQzzJ?=
 =?us-ascii?Q?IZ2WSsWuAkVo/xHgs4O0b4+I2jhMlJ424eZoo9PUbTbMbJiX4qYjIlwFasXm?=
 =?us-ascii?Q?F1XkD86lOCvcwOOZAARJSiWuACbznASYUt34W813Nb6LfVxwZwiz37vwQVLk?=
 =?us-ascii?Q?nuP9LqB6nFpCU0qGJ153FhfJNHl18BD4pOx4KQpkgbic0nh6ZjIQ3zWImwjD?=
 =?us-ascii?Q?Ls6iTzFXZnShxg0EpNUqmCCFqm+w1SGN8zmojuOc6KRPnJ+smAs+HIah8Ss/?=
 =?us-ascii?Q?iycLdieEJSxCRuBur+fAlqdCoBGYN/UBN0QqskPrLY8Y4NY2m+LD3sTWAsDz?=
 =?us-ascii?Q?RlOfpk6d3xZMWlIAvK2bzbCOtZYMMwPLOv13tOemGEFsyzdmvsAXMYDbmqwr?=
 =?us-ascii?Q?fzDqOhTYjwuT5lHUolzm7NaZh17c4XIByI4BndpFxOAFCzC9DnYJvfjSbv3d?=
 =?us-ascii?Q?mifqWTt1ZBX8xni0krf0XkoztozKap7QE6lcGxOUC8CqdPngwjHZeN/scgbl?=
 =?us-ascii?Q?kWBZwetcmmNOaEULWjld/L9xvpnEQpCTDnVS/VcK3n2+pcJuD5PYUmcbXtAT?=
 =?us-ascii?Q?vc4cSZNvCKm25PWAC1DqV5tJTEbbRenbyZB/66pJX8wBiItICqdwtbHsoOOW?=
 =?us-ascii?Q?UOl5YAwWzU0yv7NsM7I3gx756jizPa5LnObAvGytn33kzhKU4LfSXrIVCCj/?=
 =?us-ascii?Q?YKZGuShNDkgaarAzAKOAKelwcV3d3duVhj1/INlBkG6jvB6xvbNJnDNZRcX4?=
 =?us-ascii?Q?r5nbXyZYiowK7RkF4gTevmAIJVHIsWycYvzw1S7n/dsU+kL6ZljsuAuS5Slp?=
 =?us-ascii?Q?ab6AEJMaH8i4jVUMZbkCO1a/+ayK98zS4LBZAxnqLiIwIOgbeN+Dv8z68Lnh?=
 =?us-ascii?Q?nQGyJ6NOpO9zxuEO6aY0DJvfRc3PSsmkjciAsPUR/OnPOXOmoRG4wrtgtqVY?=
 =?us-ascii?Q?Bka6UyzgQmGbY/finsh4qMvLYR1j+xkDuOZ9XFX9K5wl/TFrJNaqAQGE56kN?=
 =?us-ascii?Q?klGUWkFZJHhrCp3sE6Pw8Cqs/hUlSsG9zIoUmexlMBCwWptG03IHe82sirer?=
 =?us-ascii?Q?DTevBjmxkhtpv+NBo22CcVtE5Wn6fouUeQ1keo+ZDagmPzSZFgL7b00FEUIR?=
 =?us-ascii?Q?mvMzWvOjZ6ukTLAftCEoiuTQ0iwsdcInacJc+t/D6O2Ru1fmRjJGQ0csm34l?=
 =?us-ascii?Q?1J0RUjWmfuEcnorRDQ4pgFpLz0bEjw9I?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?UHhj/+NL3tqKe7/HTpz/ds2QobvS6h4AMDkAWPBzzG0lmPw4tITr1+op/CNK?=
 =?us-ascii?Q?soMhu4ENeXArjNn3lyfcboRVvIAZn+pwnH34H5vzgFob5uAXv6gRbYRfTpCh?=
 =?us-ascii?Q?95R95s0OEd9SCMD3LkYFuvO8bADoCTlUjuAmLLKi3qNvmEQb6G1whpxllK8h?=
 =?us-ascii?Q?1THZIOa786nhVjiIa65ujtGaWxW8PYyq8Im0s+rCcQZ46lxoaEdN6ueGer5q?=
 =?us-ascii?Q?K9i+hC3xJ/dAuDyyZAj9gj36Fw64O/1Uh+jpquCn6Vye0iYOz8ArEXJsVmTf?=
 =?us-ascii?Q?GlpkcYch4pPH8vtAhMYMveD/q4a74ySXhppbJvCo401I/AKLVxUhf5mQymSf?=
 =?us-ascii?Q?QLDK4eQdqinAZxQchFqdGmJYI9Rl4V6TxLXseSbyjhvO0x3qGsNc66JlnNol?=
 =?us-ascii?Q?dzoa+tXhOTIZ3thcpJRdUkbUWpA9HV+o0z4RvXBmGrAiPOr5Hz3VAphs55/x?=
 =?us-ascii?Q?V85YU7b1IwM13z3iHO4Lw4vPGkQFLU1MPheLthkYGs4uENWG8mq/Y2QXYdHl?=
 =?us-ascii?Q?m8s20dJMl6UryjAbLgP+NKGNWHEhOcr5BEJ72ueGLxZiRS6RrP0JRcjHVAM3?=
 =?us-ascii?Q?dr5keOXIxZIPrfGyvbZTF32P5wZV1wioci585giCIgEWLgF9yEE0ha7aL8gs?=
 =?us-ascii?Q?6nSbGYYvHCoADpgiGBtHQ4A+rl3ZnSqUSsI0CRS2lmgM+keu7NHe84Mb951I?=
 =?us-ascii?Q?+1Zim9qI5fTlBEKA5YXLIIm3WGNI+j41j33c73YUkS78D/lKtQzxwn+YZz7q?=
 =?us-ascii?Q?WhBOPcX87p7qWafhzIatTrAEcff4u/sdnEpctcK4q2f629YGmjtp5uDU4Chw?=
 =?us-ascii?Q?UI/IOhfDbJLEYC85urVV/btFLTC9RdAvcsST3scrY7mJUDzCN7N/VWfNQ66J?=
 =?us-ascii?Q?3dnvEozCWlRYVBUd7dFnV+P5Dxl+6ZdtxSR7u0XMRM3kHG+kSFRmbJEMi+41?=
 =?us-ascii?Q?A6mCGrX+xfzbzqneDI2r7nnsfzLPf+xfjPPoBuuflYYqLqgI1Ur3WflDPaUU?=
 =?us-ascii?Q?8P6l4StlUuJrEHE/JTVFEZQ75+h7MN/AvM372shX71NgzqBD1msS35/ktwLg?=
 =?us-ascii?Q?okLd4ES1NqEidn58Tj9jGYwSyTQoeMngvP2wbzt1csqHbmxaXDaJ0j/IBI/W?=
 =?us-ascii?Q?IDvBiJmsqmVxkX0KYFp5oa22lHM6farMyTufnu42VrkNEdxZdxvXJMatwoE8?=
 =?us-ascii?Q?j8PSQFIWRpNdesm/9KSmEk+uiPcnOM/0YNLMihQRfgfmFmt7jRcl49T3p+tQ?=
 =?us-ascii?Q?DmVHYSX41coeFLfoJHukKYHjTmz1y1hN78aQaIGsSlahJ+1xIKtEaSpcrYv+?=
 =?us-ascii?Q?QWnVuCgQsoadH7+abRDJOBeShz6pXEjxdS4tDc22IH9AK4Iu2+u7+eIjSZA7?=
 =?us-ascii?Q?yoREedsvZxYdpE7XhDELNJeCB1bAxxWI4eui5MWItwoZJeupCn7x0n6sF2aU?=
 =?us-ascii?Q?TNNs5OM28xGs305jdie1J9Y83jGUwLLn8GDC4bqc/78KXOQSMFEOrn5Scimi?=
 =?us-ascii?Q?qDzgFAhQnyHlzOzzB95xkzP7G+nueyY6KBJHFYhvx3hm2Awf64+8xCcqpXGK?=
 =?us-ascii?Q?JoyaFqGjVEAHIml4Aw5meS/1wdMkptamkvAy6c3HDLMqUlzqAwbeh7dWr4Pg?=
 =?us-ascii?Q?2nVfrWf2sJ76YaiHow1Sr88=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f049304-82a3-4ad1-601b-08dd2fa28423
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2025 05:08:40.4023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ifNH7nebtavSfGSYjGpZFTu+mI/3+l2d4pLSWVO8PN7xRrar2MCLDxIkG3oVadus2HS4PoV6Z/+zvXRjE1GdNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6939
X-Outbound-SMTP-Client: 173.37.147.250, alln-opgw-2.cisco.com
X-Outbound-Node: rcdn-l-core-11.cisco.com

On Tuesday, January 7, 2025 6:08 AM, Dan Carpenter <dan.carpenter@linaro.or=
g> wrote:
>
> Hello Karan Tilak Kumar,
>
> Commit a63e78eb2b0f ("scsi: fnic: Add support for fabric based
> solicited requests and responses") from Dec 11, 2024 (linux-next),
> leads to the following Smatch static checker warning:
>
> drivers/scsi/fnic/fnic_main.c:907 fnic_probe()
> warn: missing error code 'err'
>
> drivers/scsi/fnic/fnic_main.c
> 866
> 867         err =3D fnic_alloc_vnic_resources(fnic);
> 868         if (err) {
> 869                 dev_err(&fnic->pdev->dev, "Failed to alloc vNIC resou=
rces, "
> 870                              "aborting.\n");
> 871                 goto err_out_fnic_alloc_vnic_res;
> 872         }
> 873         dev_info(&fnic->pdev->dev, "fnic copy wqs: %d, Q0 ioreq table=
 size: %d\n",
> 874                         fnic->wq_copy_count, fnic->sw_copy_wq[0].iore=
q_table_size);
> 875
> 876         /* initialize all fnic locks */
> 877         spin_lock_init(&fnic->fnic_lock);
> 878
> 879         for (i =3D 0; i < FNIC_WQ_MAX; i++)
> 880                 spin_lock_init(&fnic->wq_lock[i]);
> 881
> 882         for (i =3D 0; i < FNIC_WQ_COPY_MAX; i++) {
> 883                 spin_lock_init(&fnic->wq_copy_lock[i]);
> 884                 fnic->wq_copy_desc_low[i] =3D DESC_CLEAN_LOW_WATERMAR=
K;
> 885                 fnic->fw_ack_recd[i] =3D 0;
> 886                 fnic->fw_ack_index[i] =3D -1;
> 887         }
> 888
> 889         pool =3D mempool_create_slab_pool(2, fnic_sgl_cache[FNIC_SGL_=
CACHE_DFLT]);
> 890         if (!pool)
> 891                 goto err_out_free_resources;
>
> err =3D -ENOMEM;
>
> 892         fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT] =3D pool;
> 893
> 894         pool =3D mempool_create_slab_pool(2, fnic_sgl_cache[FNIC_SGL_=
CACHE_MAX]);
> 895         if (!pool)
> 896                 goto err_out_free_dflt_pool;
>
> err =3D -ENOMEM;
>
> 897         fnic->io_sgl_pool[FNIC_SGL_CACHE_MAX] =3D pool;
> 898
> 899         pool =3D mempool_create_slab_pool(FDLS_MIN_FRAMES, fdls_frame=
_cache);
> 900         if (!pool)
> 901                 goto err_out_fdls_frame_pool;
>
> err =3D -ENOMEM;
>
> 902         fnic->frame_pool =3D pool;
> 903
> 904         pool =3D mempool_create_slab_pool(FDLS_MIN_FRAME_ELEM,
> 905                                                 fdls_frame_elem_cache=
);
> 906         if (!pool)
> --> 907                 goto err_out_fdls_frame_elem_pool;
>
> err =3D -ENOMEM;
>
> regards,
> dan carpenter
>

+Cisco team

Thanks for this bug report, Dan.=20
We will fix this in a future update.

Regards,
Karan
