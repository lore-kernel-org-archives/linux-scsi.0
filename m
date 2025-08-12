Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C0A1E5B64
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 12:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755000640; cv=fail; b=L/eGBZtxAGfvxQHhHls/E0OU2XySeCCBMqYiVla4mHGfsIeOMqAD1wJQkZSiH9q6iLZpxjhWppiWaqoVnsqd2wpPdYLGmrhc9T6l7Sh2c3n0DpbrLeQlMdbXy41aqIQXykRivXKq+tqAzZ5hZpjzNnLTROShgx/7598kADMitxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755000640; c=relaxed/simple;
	bh=eroRF414M9WB2dBuXZiQ5SW9jLDZaEbWGvoulLgIuGM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cxASj4YxRBQmpE1KbQwytrWerZTmBb8HJDCe7alRqMaRAkVM6/yZrKWAzY61cbgGVV0yY2kQrWdNZK6vIfJMYZ9BGxAhZbKqjm0dczHuIPqZTtlb1DQ2Uruy5DusBSxSbFRW2t/BDrkXsmwfjzQGKytSDi1xK4R/Tz9O6wx3jQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=kI1T/Ask; arc=fail smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="kI1T/Ask"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=789; q=dns/txt;
  s=iport01; t=1755000639; x=1756210239;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ym167BsRTqjFI4twXryjS6Ub4/7G1VmsZ9WjuXNoaWw=;
  b=kI1T/AskiSyNBISp5hE6VGy1ZKTjNy41/ji+R3EWI1b+wFFpB9m1GEDR
   gnNpIhcxS6L2Xk2Xxay18Q/uK7AXuPurEJouTq+nPKw4CZ3is5Uv5jD6+
   XzhEpcLftijkx3KjhzNbVfgPWj+8R7e4Q7vu0d8C88q7CCh18NrjsbS+b
   nQ37BY9RJPcc0cLHwwfjKOYtQu/eYTfgWV1fid/IGjl6F9sT+ZzCmt9pO
   jLPzKbwh/LSOBvrvGTN7qw+QA6ZsNYRwk/phUu3z7xsPbjhATMWu/Ro0M
   CV1tCSiCBHhD3E57mzUcnR+hp1Ly93Afl05HRPfKN+H8CLWaWu1nopiv4
   w==;
X-CSE-ConnectionGUID: kblVqCXESgCwU9nZbzXXFg==
X-CSE-MsgGUID: W6ulzx18Qge0M6WdUOYkWQ==
X-IPAS-Result: =?us-ascii?q?A0AEAQDJLpto/40QJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAUAlgS6BblIHghVJiCADhSyIeaAZDwEBAQ0CUQQBAYFTgzQCjCICJjgTA?=
 =?us-ascii?q?QIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGXIZaAQEBAQMSK?=
 =?us-ascii?q?D8QAgEIDgoeEDElAgQBDQUIGoVPAwGjBgGBQAKKK3iBNIEB4CWBSYhRAYpjJ?=
 =?us-ascii?q?xuCDYFXgmg+hEWEE4IvBIIiRFKDY40BiThSeBwDWSwBVRMXCwcFgSAQMwMqN?=
 =?us-ascii?q?DEjDzwFLR1zDCgSa4QbhCcrT4IidYEBeFo/g1MSDAZrDwaBFRkeLQICAgUCQ?=
 =?us-ascii?q?z6BYBcGHgYgEgICAgICOkADC209NwYOGwUEgTUFkwmDKAE9URyCDRfHGgqEH?=
 =?us-ascii?q?KINF6prmQYiqHQCBAIEBQIQAQEGgX8lgVlwFYMiUhkPxG94PAIHCwEBAwmTZ?=
 =?us-ascii?q?wEB?=
IronPort-PHdr: A9a23:OhNIkxU4A08+It96LV/OWHLy6hvV8K3PAWYlg6HPw5pUeailupP6M
 1OavLNmjUTCWsPQ7PcXw+bVsqW1QWUb+t7Bq3ENdpVQSgUIwdsbhQ0uAcOJSAX7IffmYjZ8H
 ZFqX15+9Hb9Ok9QcPs=
IronPort-Data: A9a23:d2Qg46iKaND41XoK1ha9HLg/X161KhEKZh0ujC45NGQN5FlHY01je
 htvDz2HOf+CYGHzKYx+bdm2pBlSv5TUmtI2TVM5/Hs8FnxjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOKn9CAmvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSAULOZ82QsaD9Mu/va8EoHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUb8OJJGEp+2
 McXAy8wPxaxjfCG8Jy0H7wEasQLdKEHPasWvnVmiDWcBvE8TNWbH+PB5MRT23E7gcUm8fT2P
 pVCL2ExKk2eJUQTYz/7C7pm9Ausrnr2aSFZrFuWjaE2+GPUigd21dABNfKOK4LSG58KwR7wS
 mTuwDrkBgMKbYymxjfd1yyTitLorCDEYddHfFG/3rsw6LGJ/UQXCRsLRR6gquK4olCxVsgZK
 EEO/Ccq668o+ySWosLVVhm8pjuA+xUbQdcVS7F84wCWwa2S6AGcboQZcgN8hBUdnJZebRQh1
 0SCmJXiAjkHjVFfYS/1Gmu8xd9qBRUoEA==
IronPort-HdrOrdr: A9a23:1zf2/6+OZQQbyM1k1FNuk+GXdr1zdoMgy1knxilNoENuA6+lfp
 GV/MjziyWUtN9IYgBfpTnhAsW9qXO1z+8S3WBjB8bSYOCAghrmEGgC1/qv/9SOIVyFygcw79
 YFT0E6MqyOMbEYt7e13ODbKadc/DDvysnB7omurQYJcegpUdAd0+4TMHfjLqQCfng8OXNPLu
 vl2iMonUvGRV0nKu6AKj0uWe/Fq9fXlJTgTyInKnccgjWmvHeD0pK/NwKX8Cs/flp0rIvK91
 KrryXJooGY992rwB7V0GHeq75MnsH699dFDMuQzuAINzTFkG+TFcRccozHmApwjPCk6V4snt
 WJiQwnJd5P53TYeXzwiQfx2jPnzC0l5xbZuBylaDrY0I7ErQABeo58bLFiA1zkAo0bzZdBOZ
 dwriekXlxsfEr9dWrGloD1vlpR5zqJSDIZ4J0uZjpkIMojgHs7l/1EwKuTe61wRx7S+cQpFv
 JjA9rb4+sTeVSGb2rBtm0q29C0WG8vdy32CXTql/blmgS+pkoJh3cw1YgahDMN5Zg9Q55L66
 DNNblpjqhHSosTYbhmDOkMTMOrAiiVKCi8fV66MBDiDuUKKnjNo5n47PE84/yrYoUByN83lI
 7aWF1VuGYucwblCNGI3pdM7hfRKV/NFwjF24Vb/dx0q7f8TL3kPWmKT00vidKpp7EFDsjSS5
 +ISeRr6j/YXBzT8KpyrnnDssNpWAsjueUuy6MGZ24=
X-Talos-CUID: 9a23:Reisv2BKJie9Ttj6Eypt8HANMfAISXL200qBJX2yG1ZZZrLAHA==
X-Talos-MUID: =?us-ascii?q?9a23=3AU3bXBgzPoSYZitNj7IpIqa2t2wSaqJvwFUQfgcx?=
 =?us-ascii?q?WgsaJbQkuBDugqwW0fbZyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-04.cisco.com ([173.36.16.141])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Aug 2025 12:09:17 +0000
Received: from rcdn-opgw-1.cisco.com (rcdn-opgw-1.cisco.com [72.163.7.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-04.cisco.com (Postfix) with ESMTPS id 44D36180001AD
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 12:09:16 +0000 (GMT)
X-CSE-ConnectionGUID: 7ap6U9YJRPSOyBz20KVZmg==
X-CSE-MsgGUID: H4rjI5P+TNuIH1Ipf+9irA==
Authentication-Results: rcdn-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.17,284,1747699200"; 
   d="scan'208";a="32371410"
Received: from mail-bn1nam02lp2047.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.47])
  by rcdn-opgw-1.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 12:09:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QG/JkAtNtwiqOnZ1WYgG6xD+BxSycWaWqgFupl8x86KlIivhOL3/bOBVKDtT2CbOlnIQJAkeiuOjiK7bx1ZqUVIm0fKoKa6J5XANnNHq98b15SSgOhIMnt6vvAON0//QXLFpw3AmlV/vLN1VbmnSyc6s/36cHlBlKIFe9Pd5TnHg2n68IIkDw2vF4FjVYjuDb9ftLFE207dFtQuWf9clHrHlnve3I60/4YEhbOpfchCrA0XsOn2RQaaHYISEFJ/G/V/5TCt65x4YYv2UhztD+zQ74YeEamjDjWQTW5Q3A5q7RSiEGIjXDEaegOuCPHHwkj0GLfNCj0ibx+99ACimUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ym167BsRTqjFI4twXryjS6Ub4/7G1VmsZ9WjuXNoaWw=;
 b=oQeZ8o0UuYvTQt6NIBWYRVTSu1ed6st5UVTmyokc3eh3PSJ1Tl+OOdDRiInwfk+vMZ2WHMmL4bGA6e2ePlR7weDZp3IL6bpyGj/c6/nEKsMcHZJl1gYWPNDkTCrv43sbxvZCBRjJtigCGctDi7Q8J/XJJBT+nn4mpbkaebhyom28ITPx40jq/hcnZDEZuSCz0YVhikI5cSzdlX9qcX833ujpVmDwrZEOHgoWyYanFcNq1gbyiYv+dXfAA8Ti/auzMtX/GuZIhBZ6PgBKne16DOfVW4B3aPGivYh/YgeVfHPg2pByuF58I6xXzTpZO1xjunRbj6NLjd4gCFZ0//hd5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by PH7PR11MB7987.namprd11.prod.outlook.com (2603:10b6:510:242::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Tue, 12 Aug
 2025 12:09:14 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%4]) with mapi id 15.20.9031.012; Tue, 12 Aug 2025
 12:09:13 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Christoph Hellwig <hch@lst.de>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "Satish Kharat (satishkh)" <satishkh@cisco.com>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: RE: [PATCH] fnic: remove a useless struct mempool forward declaration
Thread-Topic: [PATCH] fnic: remove a useless struct mempool forward
 declaration
Thread-Index: AQHcC2QiAaKrZjOQ1keAGvkvNSgVvbRe68qw
Date: Tue, 12 Aug 2025 12:09:13 +0000
Message-ID:
 <SJ0PR11MB5896543FC3FF23AD9F56BE19C32BA@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250812082808.371119-1-hch@lst.de>
In-Reply-To: <20250812082808.371119-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|PH7PR11MB7987:EE_
x-ms-office365-filtering-correlation-id: 0df9a552-4a43-4672-f139-08ddd9990d5e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?T3BsZerf67rpPMas9iA31C5lfB62hlkoFGgT3Gbmt9YqTVn9rTDu2094dHNf?=
 =?us-ascii?Q?Zhieaq3VgmyWgCION6MArOXKBJNNw7z6SDXjLKfnMih64H1CKJTMSSlPnodE?=
 =?us-ascii?Q?5hzghxUb66nIFID0eoF9b+uFyf6Vem44bttgWZDtxj6V8GuqD3xP2l+7dy9G?=
 =?us-ascii?Q?gSN+87co37dfdEPxZEx3aIx2iII6bQw+1vsvvpcyMQ1RC3LfAn05A1Rq77ok?=
 =?us-ascii?Q?lmQ6TMtYtisG7/QDfXWkCk8ZRMAIa8dsDh7wi2EGsqriwlztQ0Bs7nujvWGz?=
 =?us-ascii?Q?aK1e1hUOqaLu92kVA89cDOl4cBjw25AOt1YBIGVCa5nZe0dd9sgfQX/9Jd/c?=
 =?us-ascii?Q?Axgztw/epN74gXiitAAfhZgs+8hYD3drNSQK3j2kQfFl1+x65KezbRQqpcTl?=
 =?us-ascii?Q?LjiBCXin/6m0VQIAEMLHfEccBcNncCbCtFbVdnCDq6x1PO50tM/7AeuSRVj+?=
 =?us-ascii?Q?486PFsEY3J9xs7SYJjWA888tOJAkK9YBfxEfqUsoOoZ9V13yXXBsQGJqR3F6?=
 =?us-ascii?Q?CTnCZNQKmf4pVuZb2hzKozX09xPIJGox0BMDxZQAHv5DoeMRL0Mx9JDFpkLP?=
 =?us-ascii?Q?pUpxSN5buR8EqMNAEKPjo/VbWWBFGSFa0ekKXgoycuz4V6DOHq7sj7BAJkRU?=
 =?us-ascii?Q?ESnRie+NUQXj56dAfB2cTzs3aMkk6HD9q+XxiYv3DJNsMjUZcW1iQA+MA1+W?=
 =?us-ascii?Q?XJ6EMVlNw+sfXe0CkZQcElX9DzCuZzPF6xXOtHOsHXRwhC6epchKvRXT8ZX1?=
 =?us-ascii?Q?RAg/K/UkflSomn1Vw+4Sq94cvfk5BQKEZCI93ZR7oj1Yh43cJakqVlBdyVrX?=
 =?us-ascii?Q?il9UQ7NptqAC0mpI7CZDOhxBoIpeh4tzNt0awWG/FUyZKMG0N42ZpVAkjn/U?=
 =?us-ascii?Q?TvQC6i9/xBfIHIBty1GwK5alv8PNGiTQse2yZBAfJqJKveg2iOy+9u4pOrZf?=
 =?us-ascii?Q?sc0uYpLQfRnGP0u7qRkFB1QiN4nyZiLxgctk5QlCAMT4o1OrFGHrbTIWGUoQ?=
 =?us-ascii?Q?OZ2XmJP/8bYbbDbA5tIgJ0cXs8RkMKzwn6U6PyyLpKPY/YD+1uXde+09u4jF?=
 =?us-ascii?Q?pDWaKBcYpGZQOix0fOXyc86pf3DAQTme9ZNKcvyCob3tbnSnjU6Uk/IOGumU?=
 =?us-ascii?Q?qG/JaHBgYUdTiCzWYUJ3a4JHzPq0W2c6LK1qYzQRJTK5oLFC0rRyv1rdUo2y?=
 =?us-ascii?Q?2kTg8rrEMbR9Zl4c9PpenSxICF3rXjJJOlWIGC3QDtfozg/3Talkva93I3fu?=
 =?us-ascii?Q?LyZ2rX1/8qrVC87iDfkpRVZA3RFlGceWhZxeU0dxsrcI0+A1D4Z0bvGjCXiY?=
 =?us-ascii?Q?0wuE9Od0pi+GVV8wAfwx6eSn5MbAo35+Fv91AfO41SW/qgBfxI21qn5iPTn5?=
 =?us-ascii?Q?Ls7OOkR/iqPKPR3FXjn5kux8bwJhIBaHcXn+Uewcl6O0qqtRRLAkTw+jxeXa?=
 =?us-ascii?Q?SAr6bt/B0WnlHXIwlhF87H1yT016yf58adha/5CqsuPSDpvJoH/hMA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?rsxo9fLMZnaV/Vf57SFROGIXpkhAPGR6xqtN0Q78Z5xxOE2i1V6llNYQlORG?=
 =?us-ascii?Q?ehofC1u4J8LB/R4vyHxYc3d6RZW2csQYFPbqBoaUnON/+fU7Rz+XSATgZr+o?=
 =?us-ascii?Q?RQckUL2xPz9wxhRG60EAAxjyolzj4ul5CPTdAbqpNlSScmFhAxu72odd5U/M?=
 =?us-ascii?Q?LRTyzIe0qWg/+PxF8yp0WNcVILV7AvB1Dqa5sRLx6z1gKUhKFOJIf+FFpPzq?=
 =?us-ascii?Q?MW76nx+HvaSXjmF9sc4D4LVF/Fj2GSxiDfDkkupgyTQigf9UWU3EayeKxebj?=
 =?us-ascii?Q?smeuZRepMFGjAJPBtqkjNJ2ExIjmCgLXXBhxLGfPAL15EJbqGB8Az5YbSBal?=
 =?us-ascii?Q?TmSy0WpQjZDVST09zMTzSy07hMhNKcGtzjGPsKPia9cwjzYkHOM9GGRzj+Uf?=
 =?us-ascii?Q?Ibj1ZaOzkmSf3Qs9MwvGssAXXfOugnWmkaWBfiYaADuixsPh4jkEN/+GJrnK?=
 =?us-ascii?Q?OOD9N2RuQb4WtUaLVDB4SNxuoxL5hk836Md07mFEEDa3+Sa6kwMaFn/vYVQ6?=
 =?us-ascii?Q?OeaFfVCq/SKzhJvpl2cTUsSyZoK+GGZntXMhzajhakfHb5x1fj0OxSyIYpK2?=
 =?us-ascii?Q?KOt9he9CBnjPO4lhlHSM8QYPIv4i9IjoygUOOkOj1OMWcCj2P8g2pPXxpKCB?=
 =?us-ascii?Q?pwUDOEM8uc+Wu7YWVjix3zsw4jBMgNPcbTSOAP0XbTtizit0cy5GYvQ8ELSy?=
 =?us-ascii?Q?7dbcIZJQaTA4kABtF9sRUMhahqRyCzBYkhuzbu+pkyr3UuaTfziB6teDzO6e?=
 =?us-ascii?Q?Fsq+DCtPNH9FF7n7ev/+YjLccgcwWkeHZJW6HETO1p1zAsmdSDqlQ5HOVm4S?=
 =?us-ascii?Q?fKy1a9HpumxOwjVPmbpxGI9HbDiDZMDyoKMo1nOruqPrLMmfi35mbd2KS1kR?=
 =?us-ascii?Q?fWMBfL4KEGgY02x49KxLUmSjYUXNz6fTD6uybUuxs+ICSn38/DIO05rG+ixt?=
 =?us-ascii?Q?BT+EKsGq7J0UWIa+wCYHuPT4lis0T6nbkZxh8VH23F9pR48qOX12lCIuKydr?=
 =?us-ascii?Q?OoxHy9Fzqu2LYo0O8GI/uWbKGHMiwo4dMioimwLGvPKZxBBm/MPk44fluTip?=
 =?us-ascii?Q?tAUeSu0vy/ic+gPPlJMtEoNvvca8C4osCFJUlkbjbIHT/pAxC9VBUAa+Nsbi?=
 =?us-ascii?Q?5dVAYsJ04hyuP+fmGgYcvmbWnAi3NKtLZzeG6SY3fhKvF3B9loHLBfTPBPLh?=
 =?us-ascii?Q?Sg8II/gy5ZG8Pp9e/qz5TXN/Mhjrfd0ZBJhRx7k5Sfz/SLF/yQvtlo4gLsfu?=
 =?us-ascii?Q?4pwoN8znPcoHfUHQkNM5/dVy7aR5/5JsBVhX9aDiiLy3hMvZ06r9Xaj+kvzx?=
 =?us-ascii?Q?veIBwB1QfD6nlVbDJqHrwlREYutDypIE3hFXAS+B5w7tENi/Y1lNquqiraeZ?=
 =?us-ascii?Q?l1LwtvL5lLbyATnobCDXn0BkZ8i0gGMqNaZeCPoNojfF6+OHZUFYc7cJgEzx?=
 =?us-ascii?Q?lV6ZOIxINjoa0G369CjmF2HP0U1pVlrr2/tE6T2TFS4rGLJYwUl+JX8MFdWN?=
 =?us-ascii?Q?hymT6xczY4q4e1U1Akzu7nBsHkTL/YlYFN/P6atUMhOsgsE3A5hrsF6ewDx0?=
 =?us-ascii?Q?0TH281mYyoCKRkpZQoMnpKc4EyoBlVwWtZjV6fVA?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df9a552-4a43-4672-f139-08ddd9990d5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 12:09:13.3437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EQ8efvmeV4Zopg+JFqb2BFkS135YGYw5K/x1JJ/1mXakptcFJGau18FWER3SekChLJhopcaDYg3jGBL9eW7xTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7987
X-Outbound-SMTP-Client: 72.163.7.162, rcdn-opgw-1.cisco.com
X-Outbound-Node: alln-l-core-04.cisco.com

On Tuesday, August 12, 2025 1:28 AM, Christoph Hellwig <hch@lst.de> wrote:
>
> Struct mempool doesn't current exist, and thus also isn't used in fnic.h,
> remove it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> drivers/scsi/fnic/fnic.h | 2 --
> 1 file changed, 2 deletions(-)
>
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index c2fdc6553e62..1199d701c3f5 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -323,8 +323,6 @@ enum fnic_state {
> FNIC_IN_ETH_TRANS_FC_MODE,
> };
>
> -struct mempool;
> -
> enum fnic_role_e {
> FNIC_ROLE_FCP_INITIATOR =3D 0,
> };
> --
> 2.47.2
>
>

Thanks for your change.
Looks good to me.

Reviewed-by:  Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
