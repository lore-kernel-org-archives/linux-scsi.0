Received: from alln-iport-1.cisco.com (alln-iport-1.cisco.com [173.37.142.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160032F12AE
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 20:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781642090; cv=fail; b=aq1y9b6GReauPY4oKeqePIKTQts8H5AO1i7WuHfHi5BftW6Ha9f2P8yH4b9jbvRev3aA1ij9S2JSsHuFdSTMpi0pQHztJjKDB4+53uFfyeHpIliu09+3q7/TogCtniRVLN/aZ2bmZQ9jSAf9iHEbsC0l3uZuouWg9qv/0eghQXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781642090; c=relaxed/simple;
	bh=Hz3a1bWqhLmenwMPsGMzwxxREVTHWFDBqLx7R4YCWJY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y2rhqfdO8cTNbPbwmNubIDQPhH3zwjR/IFpVOz+z50Cv+4Nc0ONnErm8f74wHecG2YHE9fIzAQVw1bExBhYOe54FNfFIMQZpB0G3CIAGa6kEpQl0vGoaioSHK5myr9dl5cFCpt6GECWhzp0FlASk8Kfj/c5fZ9fQryhnrPXR9ww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=NZVOQM51; arc=fail smtp.client-ip=173.37.142.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="NZVOQM51"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7764; q=dns/txt;
  s=iport01; t=1781642089; x=1782851689;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hz3a1bWqhLmenwMPsGMzwxxREVTHWFDBqLx7R4YCWJY=;
  b=NZVOQM51I8pj2zzfIu66RLjcd4zllQP1nXBWzB6FT3WTZtmZDMt7KaQJ
   2pEi3qCAYBhFzSfGLeL4bFF85Mg0Rt/oVqjPmriyRcq07OpBOyP/EB5Ai
   rJTHB4SyD2DrYww8XqlRfBFiBvwjuuXH6txG9ZL851LshfUkM0vjyO8p6
   j0m89Lm2JlaPCywREYxrU5r21/DzxQjAXwv/C9qWmUz4L93WhiLTk9MXM
   bIF0+lJ80MwdX4kyBUExS1CL8EBfeCzkQL6gvAMXxqiWseourJKuryrIG
   ik3m/9q8HPBASjzHOQJPguLkiYd0buECc9cza9OGikgW0ZCeWoxKNk5pF
   g==;
X-CSE-ConnectionGUID: ElcMmV0cRTuqTl9V1LCl2g==
X-CSE-MsgGUID: nWrW5QrZSRmmJfGnrDsniA==
X-IPAS-Result: =?us-ascii?q?A0CRAwAWsjFq/5QQJK1aHgEBCxIMZYEgC4FuU4EKgSFJh?=
 =?us-ascii?q?FeDTAOFLIh5A54bgX4PAQEBDQJRBAEBhQYCFo0rAiY0CQ4BAgQDAgMBAQEBA?=
 =?us-ascii?q?QEBAQEBAQsBAQUBAQECAQcFgQ4ThlAMhloBAQEBAxIRBA1FEAIBCBgCAiYCA?=
 =?us-ascii?q?gIvFRACBAoEBQgagmGCcwMBAqYlAYE9Aooqen8zgQHgLwYUAYEKLohbAYFwh?=
 =?us-ascii?q?AY4hEQnG4INgRVCgmk+gQUBgnVKFYNEOoIwBIINFYEMhDOGJYZDCUl4HANZL?=
 =?us-ascii?q?AFVExcLBwVhQkMDKi8tI0sFLR2BIyEdFxYeWBsHBRIgKkJFIwMCQjQEIT84C?=
 =?us-ascii?q?0MFgV0CghFOIx8DOX+Bb4ElZ2YVMDWBAQERHwp6AwttPRQjFBsDBDp7BYxpF?=
 =?us-ascii?q?w+CU24eGCACMkZ5HwEIk2iCbEmvWQqEHaIRF5F+mG6ZCCOjZ4UNAgQCBAUCE?=
 =?us-ascii?q?AEBBoFoPIFZcBU7gmdTGQ+OLRbMIHk9AgcCBw4DC5F5gWwBAQ?=
IronPort-PHdr: A9a23:9/0tXR3Wl+FsL1qRsmDPmlBlVkEcU/3cNwoR7N8gk71RN/nl9JX5N
 0uZ7vJo3xfFXoTevupNkPGe87vhVmoJ/YubvTgcfYZNWR4IhYRenwEpDMOfT0yuBPXrdCc9W
 s9FUTdY
IronPort-Data: A9a23:C4kuHKvSVMAsYF0OwehrMeSueOfnVBxfMUV32f8akzHdYApBsoF/q
 tZmKWvVMq3cYmv0eoslPYi19UhU75TSzNVhHlNs/C02H3lGgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav666yEgiclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuFZDdJ5xYuajhKs/za9ks01BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIw1+J8JGRwr
 fciFC0UUhTSubuS67bhRbw57igjBJGD0II3s3Vky3TdSP0hW52GGvyM7t5D1zB2jcdLdRrcT
 5NGMnw0MlKZPVsWZgd/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JYLaGp4JxRfEz
 o7A12LGGC5HDcat8gCA91CiqenVsTj9WatHQdVU8dYv2jV/3Fc7DBwQSEv+uvKii2agVN9Fb
 U8Z4Cwjqe417kPDczXmdxS8pHjBulsXXMBdVrRjrgqM0aHTpQ2eAwDoUwJ8VTDvj+dvLRQC3
 V6SlNSvDjtq2IB5g1rEnltIhVte4RQoEFI=
IronPort-HdrOrdr: A9a23:5QIjb65Nksgn6jiJKgPXwceCI+orL9Y04lQ7vn2ZFiYlEfBwxv
 rPoB1E737JYW4qKQ8dcLC7VJVpQRvnhPhICPoqTMaftW7dySSVxeBZnMffKlLbalfDH4JmpM
 Ndmu1FeaLN5DtB/IjHCWuDYqsdKbC8mcjC65a9vhJQpENRGt1dBmxCe3+m+zhNNXJ77O0CZe
 KhD6R81l2dUEVSRP6WQlMCWO/OrcDKkpXJXT4qbiRM1CC+yRmTxPrfCRa34jcyOgkj/Z4StU
 TVmQ3w4auu98q81gLd0GHr6ZFXksvKy9dIBsCA4/JlawkEjDzGWK1RH5m5+BwlquCm71gn1P
 PWpQ07Ash143TNOkmovBrEwWDboXUTwk6n7WXdrWrooMT/Sj5/IdFGn5hlfhzQ7FdllM1g0Z
 hMw3mSu/NsfFH9dWXGlp31viNR5w2JSEkZ4KguZrtkINIjgYpq3MgiFYVuYc899WzBmdsa+a
 JVfbHhDb5tACCnhjbizylS6e3peGgvFRGbRUVHkMmU3z9K2E1d9SIjtZYidrNqzuNgd3GCjN
 60b5hAhfVASNQbYrl6A/pEScyrCnbVSRaJK26KJ0/7fZt3cE4lhqSHqYnd3tvaMKAg3d83gt
 DMQVlYvWk9dwbnDtCPxoRC9lTITH+mVTrgx8lC79wh04eMCYbDIGmGUhQjgsGgq/IQDonSXO
 uyIotfB7vmIXH1EYhE0gXiU91ZKGUYUscSptEnMmj+6P7jO8nvrKjWYfzTLL3iHXItXX7+GG
 IKWHzpKMBJ/imQKwnFadjqKgTQk2DEjOZN+fLhjpouIaA2R/hxjjQ=
X-Talos-CUID: 9a23:9ejFUGE50pbKtklVqmJK8EUxH/59eUfh0W7sJx6GUEJCTOeaHAo=
X-Talos-MUID: =?us-ascii?q?9a23=3ARgp/LA2MfYZ6gJKkzcO97infdTUj5Zu0Nx00i6c?=
 =?us-ascii?q?9gcyBFyJfPS2xlzK2a9py?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-11.cisco.com ([173.36.16.148])
  by alln-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2026 20:34:47 +0000
Received: from alln-opgw-5.cisco.com (alln-opgw-5.cisco.com [173.37.147.253])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-11.cisco.com (Postfix) with ESMTPS id 3B681180001C2
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 20:34:47 +0000 (GMT)
X-CSE-ConnectionGUID: 5S6w8PvHQk+99Mu++42Yag==
X-CSE-MsgGUID: DxfkgJ55SGK/Qw/xJRS4PQ==
Authentication-Results: alln-opgw-5.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.24,208,1774310400"; 
   d="scan'208";a="57706829"
Received: from mail-northcentralusazon11012058.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.58])
  by alln-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2026 20:34:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DL9lcNdGtDNVjpgHbDXcT/5sq7JWhS+nwj2bwHSN3IJc/BPcwPXQtAJ9hmoitWCghi+OFV9VxIvE3svRnxy3TExbDweDRotFm4F3R/ht0G0z910faPDq9BgdHIBesCv/lWOCBQs7wxvBlDUDD5pSDMOgaYa8JuVJSqXvP7quWw4M+K2LJCptyP+QU+0FcuwfzJTI95tg8DUzgQpeSfw74LKF80sBGvQdpGNT6e4AvLUA8IXQKeQEwEzWafwCJ59XM4WJWJPrb5FhBGqjWK048VD2M7/HfXJP7r5hyxbYd/NKW+chb1F+RJA11r3I6B4d8ob1Et4t3R9W44c/nW7wiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hz3a1bWqhLmenwMPsGMzwxxREVTHWFDBqLx7R4YCWJY=;
 b=HUG2zw4RH/KNJT4ATlmPi4vHuwnnHNA0axps4Q8RBEgGjvR/0+ibDDa5ra/R6HOYGZZjQcwkQLhj2+qyaKjwfbl14yC1PD1a/FkTuVbJJKln4LW4kYdwWHjOjPCyUNrx0cOR45K5O/O4QGvW7kDE+wGI4QwIyHZGu60RzTTDcFCBmJ+kwqQZjXO2GM8ERQ0ZnkSv4FHRIzrnj5mrKwxegOmE5wtljePpyzLHxJZr1FdbNPcJ0mgA7tXzmQOsTk6+nbT2/g2zSQGWVQ0h0ILUuVwzpGBsXa5yWQdWK03MYVVg4MX1R8fKqVeu3o9ub8XDy638qOpHCNSSbG3c0XgmNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DM6PR11MB4530.namprd11.prod.outlook.com (2603:10b6:5:2a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 20:34:44 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%3]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 20:34:44 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar
 Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy (arulponn)"
	<arulponn@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Arun
 Easi (aeasi)" <aeasi@cisco.com>
Subject: RE: [PATCH v4 10/13] scsi: fnic: Abort timed-out NVMe LS requests
Thread-Topic: [PATCH v4 10/13] scsi: fnic: Abort timed-out NVMe LS requests
Thread-Index: AQHc+pdv4ATUzQC1QkuKcSmu98c8QLY7iJ2AgAYglnA=
Date: Tue, 16 Jun 2026 20:34:44 +0000
Message-ID:
 <SJ0PR11MB589611A3BE741EE3881FE0BFC3E52@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260612180918.8554-11-kartilak@cisco.com>
 <20260612225754.3524B1F000E9@smtp.kernel.org>
In-Reply-To: <20260612225754.3524B1F000E9@smtp.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DM6PR11MB4530:EE_
x-ms-office365-filtering-correlation-id: 977769bf-d34a-46cb-531a-08decbe6b38a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|56012099006|4143699003|11063799006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 q2//cLRrdy+Yhxf052zxYnheVYfCQzrYt0EjMNUiFKcWU6yqh3xZfQr7JeGIL1ESZ7mdM4gkSvqEitVq4p/HO8Qu+TKYyF73KiPyysEQmBAegb8uP8wU7asJeHAimvSLkAoNmhUFUGg/M9uZP3UemKvoE5HEhFbnto3vA0t5bQ8wmg+yzJEWiaM0bBkusQA4Pp1lWwNfmPXTEHCq4pQUSPQ1xQc/Zd0IIoK5LmD0/q6z5YOY5sB+qIOSuA+W5fz6VS+NVxXHB54wOO2aPAt8MM3fa95rksyYKR6+8wTKAe8xswH5sDJTtMTVRlwQAHXBEYP1pvjCiickZ5NtTU+8CCrp1BCPe8B+1ex0MDgYml1y4LNFrI69wp5jifoNs5ql4JtUvcKGh2fkTaMTodr50g/jT6LHoSV32R8JMiENFsWfiexWhflxRmOS4/p+/RzGBY1pvGbLOCg06yvV6/TmaCsSrn3BIIqqdAYDq9JTDkHA34L+IkeMeO8qsCzQ6489NALwIU9hJMZStLTytFw0ZCSKRC2BFrK5ebx5i9vxo6CIO5xCamklFVYy7cWdaxJgoZZLFAimTb3EKh8R2pZ+b+EpbHPfwg+T5KYQcp4Kxi44h2utGF7WET8O9M6nZAZvE5R5/BvEpsU8vcxN0aneA9fnxf2nxrvUyucny3PNKNmEqm9u3ZMXDVF8cb4INKRn8ctFowr2R+Tb8+iccgndqA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y29uMnJTd3U3cHRQUGpNRjZBbEd2MzJETWlqWjlSd3hhLzdKaTBvQ2RmYTZr?=
 =?utf-8?B?NVZqZFFsUkJwaTlXNElNcnp2VUd2ZE9Ccm9hS3FKOGc0MWlORkNzbVA5c1RP?=
 =?utf-8?B?L2oyYzZpV1U0Zk1zWGJnSW1ncTZ5NGh0dThrVXd3YUR4RDdDQXRaSW52VVU0?=
 =?utf-8?B?TVhQN2VBd0JncitZRmpDcDFZZnN0OGZDY0lYNTFYL1lDRXI2SlJPN3UwTFVN?=
 =?utf-8?B?RGRiekE2MWJ1a0krcFBGWm0zZjJXVUVOd2FUUHlndmp1VURMSGhFMmhnWUFl?=
 =?utf-8?B?OXYreTdpYVBMeUtUZ3hvdjdhcXNXLzNhVFc5TUtIL2R0SEpJcnZTUzNtWGJT?=
 =?utf-8?B?SHRiRVBBTnVuQTZDM2ZkUXdnQldUL0NiM2VlMW5pSU1ydnZ1OGlwTXN0SG1E?=
 =?utf-8?B?N2diNjkxRkthbDhyZ0NFekdNRjVPcFhFbjV5TGFKL0prVWV0clFFYVM3WW9K?=
 =?utf-8?B?bEV3VlNhNnYrekh2SHY2blBqaitYK0NUUGZqRkNjNlpLM3h2dS9xdFZQN2w0?=
 =?utf-8?B?ZDBrdnNIdkp5Zk5UT0xHWDVyNEU3cUVHYmYyY1dwS282OFpLMnZoTG9DV2dO?=
 =?utf-8?B?REpqVmxoSXBjR3hWN2wxL29ycEgxdCs1SXd1MEhYRG1zSFBhMVlPSlArMWxO?=
 =?utf-8?B?djVKQkJGTmpuSHROV09jeFdwdTJLWGZPSmFjK1hna045VlY0S3B2eG44bmpM?=
 =?utf-8?B?VkpLSEpLQkczZ1lNSlFEREJrZ3BMejZLZVpiZ25EeFpPV2M1eVBCa0kzWEdT?=
 =?utf-8?B?OGkrVWZUQXFLUTVJcksyeVRhZ0RCQ2cwUko5MkxOejM4b1NNSHJPSmhBL25w?=
 =?utf-8?B?MW1qVVNRUEhFNUh4d3JSMUtIS3B0QVdqMUF2SzUydmxzOENKMzEvMWt1d0Fj?=
 =?utf-8?B?QjBpRmh3SmJJakY0b0hJUWs2dXdwSmlSZS9DQlNnVDNkNStUZDExOTl1MDJ1?=
 =?utf-8?B?Y1Q4Wk5TejAxWFBSY0xReEpZZk5OMEZnb1ZwMmhwVnZKUDM4d29QaXlSQ3o3?=
 =?utf-8?B?NjVGSzRnWkw5cDZqeDI0b0NmNkZvT0VZY2dUK0VVcjdldk5UZmNpVlR5YjFH?=
 =?utf-8?B?cG43SjJLZGdaTnljWmovdkxSU0g1OG1ZTGFvc2J3RTl4Q2xsV28zanA2UVdm?=
 =?utf-8?B?eEV1NFRHSXFrWFg5WXVOY2RicE9IMTY2aDVtNmFsVGtQVFVuUW9KMmljdzhM?=
 =?utf-8?B?QWNFTmlBV1c0ZXg2aGJyNkJ0ejNjTUNoR281ZkZNM0FkMUVlRGl1S1hoRjYw?=
 =?utf-8?B?MEN1K0N5TE5YTGJ5azY2c3BPSGZLS0tGdzhZZk8rWG1PVCtVWTdpMkZJUFpu?=
 =?utf-8?B?dVYzZ2FWSCtrRFVUSEEyWDF3dUdNYS91eEkzL0VvZUZsTS9CWjRjVjhsL1hG?=
 =?utf-8?B?REJGbnNaUTdua0EzdU1kVnhvc2hEREZiVFpBRVF6N2J6NjF3cEEzRVpKT0JQ?=
 =?utf-8?B?Y2VEMmtvTUQzVDU4b0ZHQUNEc0w3dmRzL3RGdVJ1K3c5SFhqYUR2SXprSVhS?=
 =?utf-8?B?bEVPMWVHcE9zSnBORkhwQUNJM1BiOEhJRyt3bEFTcDdmM0hZSzQyMUJ0K2pk?=
 =?utf-8?B?N01DejM1ZXQxMkdPV3UvSDFSR2V2WmNUUFJzYjR5Q0czc0hicGI0RG8zZS92?=
 =?utf-8?B?VFVWNFdHTlZLT2pxdnh0SHlpRXBTSVByVjdjVmZiT1JneTNLb2ZBWkVkaGVl?=
 =?utf-8?B?TkQ2Y2g0Z1UxcTBPcVRDR0tRZm0zUllDRTdQZldZdGFtUGtzdW9HM3FPZG1K?=
 =?utf-8?B?WGhxeEZuaWZhQmp3VU1WcEQ4Z3oyRUtBaHVib0dOdU5MRG8yN2w4WHcvWXZE?=
 =?utf-8?B?RjFIUUdxTFFhRVB1V1FhUThZN3I4WlovUXdpYkxWY0VQOFhiaEtqb3dmQ0g1?=
 =?utf-8?B?VjVVV3JxQStEZmE5SUlsaTIyM3BqOGgzYVZ4dXZYOGNQM2lrUzhBTEExbFJr?=
 =?utf-8?B?Rm1NVjgySHRuS3RadmYwWFY4OGpjU25Fdy94V0xNaUxJM1ptcUwwVjFBVUlL?=
 =?utf-8?B?NUVOSzBTY3dyaGNVMGFRUXdJazJoeEtiZmVDeGUwMWZzd0pUR1RrMGpDNElQ?=
 =?utf-8?B?TGpGUWZqRHRSWXF2MzQwU3phZDh0SHpVbktDVU9vSm1jVjNYLzR5MFBHanN0?=
 =?utf-8?B?bGZXSGNiM3c3UHBWcjNDMzNFVzR6L2hSUzR4RGkzTmNiUTh2aEt5c3RpMHhC?=
 =?utf-8?B?ZGs0TFBrUlBRQk1ncERUd2dtTDlBVVFieTBEWjJrQWhnY0NWZnhzcHQxQlhk?=
 =?utf-8?B?Sm96eVVYRXo3bjFUTE1WOWtXMDluV2JjZ29BOFdQNWZyTzkvMlV2dVQ1aFhz?=
 =?utf-8?Q?s2CvIgTk8Ra1cdgHyG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	f60yCwhamdrY3RnVBksOoDtuNxt5F4ZNkVwtCIy96LX1WpQ88ZAP2Qnfo4p4lypZpfZRI48/Gg2DGpg77gNGKrY/UVUZrlX9VEYTsO4ld+iw/2m86nB4kS9w+qvpaeWbwIN8nJ5CtBE2HF/DSNo4DoWvV6mfvNG9LplUvJZstKKuro+fPsd2ggU5Z++eH55ZtrCOG06jQq8spM13yO1RSHGfz+iQ9scmG/2as1ftq5NMvnLv3VWcUtwWFqz5TSUVdElYtTQ6Q9WqZKmnm8pKLyozygorqa/tJo18Z0/zqCbbwuviAMwmPv/N5ZzqWNhv7epJFnTspZOHhPHpjqJaQQ==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 977769bf-d34a-46cb-531a-08decbe6b38a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2026 20:34:44.7944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8/pj/OmcFtlCXRMYoAc2zAXVNdqnbWLSWeHvDIr8sWMrROltBke8m3d109qSwqroKXgafExSJ7bJJsku4z/9DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4530
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-5.cisco.com [173.37.147.253];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.253, alln-opgw-5.cisco.com
X-Outbound-Node: alln-l-core-11.cisco.com

T24gRnJpZGF5LCBKdW5lIDEyLCAyMDI2IDM6NTggUE0sIHNhc2hpa28tYm90QGtlcm5lbC5vcmcg
PHNhc2hpa28tYm90QGtlcm5lbC5vcmc+IHdyb3RlOg0KPg0KPiBUaGFuayB5b3UgZm9yIHlvdXIg
Y29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJldmlldyBmb3VuZCA0IHBvdGVudGlhbCBpc3N1ZShz
KSB0byBjb25zaWRlcjoNCj4NCj4gTmV3IGlzc3VlczoNCj4gLSBbQ3JpdGljYWxdIERyb3BwaW5n
IGZuaWNfbG9jayBiZWZvcmUgbmV0d29yayB0cmFuc21pc3Npb24gYW5kIGFjY2Vzc2luZyB0aGUg
TlZNZSBMUyByZXF1ZXN0IG9uIGZhaWx1cmUgbGVhZHMgdG8gVXNlLUFmdGVyLUZyZWUgYW5kIGRv
dWJsZSBjb21wbGV0aW9ucy4NCj4NCj4gUHJlLWV4aXN0aW5nIGlzc3VlczoNCj4gLSBbSGlnaF0g
Q2FsbGluZyB0aW1lcl9kZWxldGVfc3luYygpIHdoaWxlIGhvbGRpbmcgZm5pYy0+Zm5pY19sb2Nr
IGNhdXNlcyBhbiBBQkJBIGRlYWRsb2NrIHdpdGggdGhlIHRpbWVyIGNhbGxiYWNrLg0KPiAtIFtI
aWdoXSBEcm9wcGluZyBhIHNwaW5sb2NrIGluc2lkZSBsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUg
aW52YWxpZGF0ZXMgdGhlICduZXh0JyBwb2ludGVyLg0KPiAtIFtIaWdoXSBTYXZpbmcgc3Bpbl9s
b2NrX2lycXNhdmUgaW50ZXJydXB0IHN0YXRlIGludG8gYSBzaGFyZWQgc3RydWN0IG1lbWJlciBj
b3JydXB0cyBpbnRlcnJ1cHQgc3RhdGUuDQo+IC0tDQo+DQo+IGNvbW1pdCBhZjQ4NTVlODIzMjBj
MzJkZDU4NzQ2MDIyM2FiOTk3NzY1OGRmMDI0DQo+IEF1dGhvcjogS2FyYW4gVGlsYWsgS3VtYXIg
PGthcnRpbGFrQGNpc2NvLmNvbT4NCj4NCj4gc2NzaTogZm5pYzogQWJvcnQgdGltZWQtb3V0IE5W
TWUgTFMgcmVxdWVzdHMNCj4NCj4gQWRkIGFuIEZETFMgaGVscGVyIHRoYXQgc2VuZHMgQUJUUyBm
cmFtZXMgZm9yIG91dHN0YW5kaW5nIE5WTWUgTFMNCj4gcmVxdWVzdHMuIFVzZSB0aGUgYWN0aXZl
IExTIHJlcXVlc3QgT1hJRCB3aGVuIGJ1aWxkaW5nIHRoZSBBQlRTIGZyYW1lLA0KPiBzZW5kIGl0
IHRocm91Z2ggdGhlIEZDb0UgdHJhbnNtaXQgcGF0aCwgYW5kIGNhbGwgaXQgZnJvbSBMUyB0aW1l
b3V0DQo+IGFuZCBhYm9ydCBoYW5kbGluZy4NCj4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
Y3NpL2ZuaWMvZm5pY19udm1lLmMgYi9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX252bWUuYw0KPiA+
IGluZGV4IDAxNDY2MDcyNTM3M2IuLjljYzhmMGJhZjA5Y2IgMTAwNjQ0DQo+ID4gLS0tIGEvZHJp
dmVycy9zY3NpL2ZuaWMvZm5pY19udm1lLmMNCj4gPiArKysgYi9kcml2ZXJzL3Njc2kvZm5pYy9m
bmljX252bWUuYw0KPg0KPiBbIC4uLiBdDQo+DQo+ID4gQEAgLTEyMzIsNiArMTIzNiwyMyBAQCB2
b2lkIG52Zm5pY19sc19yc3BfcmVjdihzdHJ1Y3QgZm5pY19pcG9ydF9zICppcG9ydCwNCj4gPiAg
ICAgc3Bpbl9sb2NrX2lycXNhdmUoJmZuaWMtPmZuaWNfbG9jaywgZm5pYy0+bG9ja19mbGFncyk7
DQo+ID4gIH0NCj4NCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBUaGlzIGlzIGEgcHJlLWV4aXN0aW5n
IGlzc3VlLCBidXQgZG9lcyBjYWxsaW5nIHRpbWVyX2RlbGV0ZV9zeW5jIHdoaWxlDQo+IGhvbGRp
bmcgZm5pYy0+Zm5pY19sb2NrIGluIG52Zm5pY19sc19yc3BfcmVjdiBjYXVzZSBhbiBBQkJBIGRl
YWRsb2NrPw0KPg0KPiBJZiB0aGUgdGltZXIgY2FsbGJhY2sgdW5jb25kaXRpb25hbGx5IHJlcXVl
c3RzIGZuaWNfbG9jaywgd2FpdGluZyBmb3IgdGhlDQo+IHRpbWVyIHRvIGNvbXBsZXRlIHdoaWxl
IGhvbGRpbmcgdGhlIGxvY2sgd2lsbCBkZWFkbG9jazoNCj4NCj4gbnZmbmljX2xzX3JzcF9yZWN2
KCkNCj4gICAgIHNwaW5fbG9ja19pcnFzYXZlKCZmbmljLT5mbmljX2xvY2ssIGZuaWMtPmxvY2tf
ZmxhZ3MpOw0KPiAgICAgLi4uDQo+ICAgICB0aW1lcl9kZWxldGVfc3luYygmbnZmbmljX2xzX3Jl
cS0+bHNfcmVxX3RpbWVyKTsNCj4NCj4gWyAuLi4gXQ0KPg0KDQpUaGFua3MgZm9yIHRoZSByZXZp
ZXcuDQpUaGlzIGlzIGEgcHJlLWV4aXN0aW5nIGlzc3VlIGFuZCBpcyBvdXRzaWRlIHRoZSBzY29w
ZSBvZiB0aGlzIHBhdGNoIHNlcmllcy4NCkl0IHdpbGwgbmVlZCB0byBiZSBhZGRyZXNzZWQgaW4g
YSBzZXBhcmF0ZSBkZWRpY2F0ZWQgcGF0Y2ggc2VyaWVzLg0KDQo+ID4gQEAgLTEyNzQsNiArMTI5
NCwxOSBAQCB2b2lkIG52Zm5pY19sc19yZXFfdGltZW91dChzdHJ1Y3QgdGltZXJfbGlzdCAqdCkN
Cj4gPiAgICAgICAgICAgICBGTklDX05WTUVfREJHKEtFUk5fRVJSLCBmbmljLA0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgInRwb3J0OiAweCV4IGxzcmVxOiAweCV4IHNlbmRpbmcgYWJv
cnRcbiIsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICB0cG9ydC0+ZmNpZCwgbnZmbmlj
X2xzX3JlcS0+b3hpZCk7DQo+ID4gKyAgICAgICAgICAgbnZmbmljX2xzX3JlcS0+c3RhdGUgPSBG
TklDX0xTX1JFUV9DTURfQUJUU19QRU5ESU5HOw0KPiA+ICsgICAgICAgICAgIHNwaW5fdW5sb2Nr
X2lycXJlc3RvcmUoJmZuaWMtPmZuaWNfbG9jaywgZm5pYy0+bG9ja19mbGFncyk7DQo+ID4gKw0K
PiA+ICsgICAgICAgICAgIGlmIChmZGxzX3NlbmRfbHNfcmVxX2FidHMoaXBvcnQsIHRwb3J0LCBu
dmZuaWNfbHNfcmVxLT5veGlkKSA9PSAwKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICB0aW1l
b3V0ID0gRk5JQ19MU19SRVFfVE1PX01TRUNTKGxzX3JlcS0+dGltZW91dCk7DQo+ID4gKyAgICAg
ICAgICAgICAgICAgICBtb2RfdGltZXIoJm52Zm5pY19sc19yZXEtPmxzX3JlcV90aW1lciwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICByb3VuZF9qaWZmaWVzKGppZmZpZXMgKyBt
c2Vjc190b19qaWZmaWVzKHRpbWVvdXQpKSk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICByZXR1
cm47DQo+ID4gKyAgICAgICAgICAgfQ0KPiA+ICsgICAgICAgICAgIEZOSUNfTlZNRV9EQkcoS0VS
Tl9FUlIsIGZuaWMsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAidHBvcnQ6IDB4JXgg
bHNyZXE6IDB4JXggY2Fubm90IHNlbmQgYWJvcnRcbiIsDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICB0cG9ydC0+ZmNpZCwgb3hpZCk7DQo+ID4gKyAgICAgICAgICAgc3Bpbl9sb2NrX2ly
cXNhdmUoJmZuaWMtPmZuaWNfbG9jaywgZm5pYy0+bG9ja19mbGFncyk7DQo+DQo+IFtTZXZlcml0
eTogSGlnaF0NCj4gVGhpcyBpcyBhIHByZS1leGlzdGluZyBpc3N1ZSwgYnV0IGRvZXMgc2F2aW5n
IHRoZSBpbnRlcnJ1cHQgc3RhdGUgaW50byB0aGUNCj4gc2hhcmVkIGZuaWMtPmxvY2tfZmxhZ3Mg
c3RydWN0IG1lbWJlciByaXNrIGNvcnJ1cHRpbmcgQ1BVIElSUSBzdGF0ZXMNCj4gZHVyaW5nIHNw
aW5sb2NrIGNvbnRlbnRpb24/DQo+DQo+IFVzaW5nIGEgZ2xvYmFsIHZhcmlhYmxlIGZvciBJUlEg
c3RhdGUgaW5zdGVhZCBvZiBhIGxvY2FsIHN0YWNrIHZhcmlhYmxlDQo+IGNhbiBsZWFkIHRvIGNv
cnJ1cHRpb24gd2hlbiB0aGUgbG9jayBpcyBjb250ZW5kZWQuDQo+DQo+IFsgLi4uIF0NCg0KVGhh
bmtzIGZvciB0aGUgcmV2aWV3Lg0KVGhpcyBpcyBhIHByZS1leGlzdGluZyBpc3N1ZSBhbmQgaXMg
b3V0c2lkZSB0aGUgc2NvcGUgb2YgdGhpcyBwYXRjaCBzZXJpZXMuDQpJdCB3aWxsIG5lZWQgdG8g
YmUgYWRkcmVzc2VkIGluIGEgc2VwYXJhdGUgZGVkaWNhdGVkIHBhdGNoIHNlcmllcy4NCg0KPg0K
PiA+IEBAIC0xNTc5LDEwICsxNjA3LDI1IEBAIHZvaWQgbnZmbmljX2xzX3JlcV9hYm9ydChzdHJ1
Y3QgbnZtZV9mY19sb2NhbF9wb3J0ICpscG9ydCwNCj4gPg0KPiA+ICAgICAvKiBNYXJrIHRoZSBz
dGF0ZSBhbmQgZmxhZ3MgKi8NCj4gPiAgICAgbnZmbmljX2xzX3JlcS0+c3RhdGUgPSBGTklDX0xT
X1JFUV9DTURfQUJUU19QRU5ESU5HOw0KPiA+ICsgICBveGlkID0gbnZmbmljX2xzX3JlcS0+b3hp
ZDsNCj4gPiAgICAgdGltZW91dCA9IEZOSUNfTFNfUkVRX1RNT19NU0VDUyhsc3JlcS0+dGltZW91
dCk7DQo+ID4gICAgIG1vZF90aW1lcigmbnZmbmljX2xzX3JlcS0+bHNfcmVxX3RpbWVyLA0KPiA+
ICAgICAgICAgICAgICAgcm91bmRfamlmZmllcyhqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyh0
aW1lb3V0KSkpOw0KPiA+ICAgICBzcGluX3VubG9ja19pcnFyZXN0b3JlKCZmbmljLT5mbmljX2xv
Y2ssIGZuaWMtPmxvY2tfZmxhZ3MpOw0KPiA+ICsNCj4gPiArICAgcmV0ID0gZmRsc19zZW5kX2xz
X3JlcV9hYnRzKGlwb3J0LCB0cG9ydCwgb3hpZCk7DQo+ID4gKyAgIGlmICghcmV0KQ0KPiA+ICsg
ICAgICAgICAgIHJldHVybjsNCj4gPiArDQo+ID4gKyAgIHRpbWVyX2RlbGV0ZV9zeW5jKCZudmZu
aWNfbHNfcmVxLT5sc19yZXFfdGltZXIpOw0KPg0KPiBbU2V2ZXJpdHk6IENyaXRpY2FsXQ0KPiBD
YW4gZHJvcHBpbmcgZm5pY19sb2NrIGJlZm9yZSBuZXR3b3JrIHRyYW5zbWlzc2lvbiBhbmQgdGhl
biBhY2Nlc3NpbmcNCj4gbnZmbmljX2xzX3JlcSBhZnRlciB0cmFuc21pc3Npb24gZmFpbHVyZSBs
ZWFkIHRvIGEgdXNlLWFmdGVyLWZyZWUgYW5kDQo+IGRvdWJsZSBjb21wbGV0aW9ucz8NCj4NCj4g
U2luY2UgbWVtb3J5IG93bmVyc2hpcCBpcyB0cmFuc2ZlcnJlZCB0byB0aGUgdGltZXIgd2hlbiBt
b2RfdGltZXIgaXMNCj4gY2FsbGVkLCB0aGUgdGltZXIgY291bGQgZmlyZSB3aGlsZSB0aGUgbG9j
ayBpcyBkcm9wcGVkLiBUaGlzIGNvdWxkIGZyZWUNCj4gbnZmbmljX2xzX3JlcSBiZWZvcmUgd2Ug
cmVhY2ggdGltZXJfZGVsZXRlX3N5bmMuDQo+DQo+IFsgLi4uIF0NCg0KVGhhbmtzIGZvciB0aGUg
cmV2aWV3Lg0KVGhlIHRlYW0gd2lsbCByZXZpZXcgdGhpcyBmZWVkYmFjayBhbmQgZGV0ZXJtaW5l
IHRoZSBuZWNlc3NhcnkgY2hhbmdlcyBpbiB0aGUgbmV4dCByZXZpc2lvbiBvZiB0aGUgcGF0Y2gg
c2VyaWVzLg0KDQo+DQo+IFtTZXZlcml0eTogSGlnaF0NCj4gVGhpcyBpcyBhIHByZS1leGlzdGlu
ZyBpc3N1ZSwgYnV0IGRvZXMgZHJvcHBpbmcgdGhlIHNwaW5sb2NrIGluc2lkZQ0KPiBsaXN0X2Zv
cl9lYWNoX2VudHJ5X3NhZmUgaW52YWxpZGF0ZSB0aGUgbmV4dCBwb2ludGVyPw0KPg0KPiBJbiBk
cml2ZXJzL3Njc2kvZm5pYy9mbmljX252bWUuYzpudmZuaWNfY2xlYW51cF90cG9ydF9pbygpOg0K
Pg0KPiBsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUobnZmbmljX2xzX3JlcSwgbmV4dCwgJih0cG9y
dC0+bHNfcmVxX2xpc3QpLCBsaXN0KQ0KPg0KPiBJZiBmbmljX2xvY2sgaXMgZHJvcHBlZCBpbnNp
ZGUgdGhpcyBsb29wLCBjb25jdXJyZW50IG1vZGlmaWNhdGlvbnMgdG8gdGhlDQo+IGxpc3QgY2Fu
IGludmFsaWRhdGUgdGhlIG5leHQgcG9pbnRlciwgbGVhZGluZyB0byBhIHVzZS1hZnRlci1mcmVl
Lg0KPg0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQpUaGlzIGlzIGEgcHJlLWV4aXN0aW5nIGlz
c3VlIGFuZCBpcyBvdXRzaWRlIHRoZSBzY29wZSBvZiB0aGlzIHBhdGNoIHNlcmllcy4NCkl0IHdp
bGwgbmVlZCB0byBiZSBhZGRyZXNzZWQgaW4gYSBzZXBhcmF0ZSBkZWRpY2F0ZWQgcGF0Y2ggc2Vy
aWVzLg0KDQo+IC0tDQo+IFNhc2hpa28gQUkgcmV2aWV3IMK3IGh0dHBzOi8vc2FzaGlrby5kZXYv
Iy9wYXRjaHNldC8yMDI2MDYxMjE4MDkxOC44NTU0LTEta2FydGlsYWtAY2lzY28uY29tP3BhcnQ9
MTANCj4NCg0KDQoNClJlZ2FyZHMsDQpLYXJhbg0K
