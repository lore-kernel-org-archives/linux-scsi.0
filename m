Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FF213A878
	for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2024 06:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729145961; cv=fail; b=I1pXEsScV2aSgBtNAByXQ3dvXxZD5Z1KDkeEqPBxOlEFTtrXsuksoxI4G3ytBloLVnFIN1sXoFqQKmfgqRrIdy3ncHiSdvI8D+g8cXpN/6bFVpT5qrypGHyPBgzj9a1os8vgxfFMOSXD8osW5vwWkKWHoLo4kfyEGjbidQ47rpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729145961; c=relaxed/simple;
	bh=so/yzF74SNRcoWccNWocHjHJ5RDZOBikcPNh4jtnc6U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PFE4/CKJzOXIVmeeoH5qrIVCnCXGMsuDKwKOEfx6CcaHHJLCBD0Y+YRZMUicG00NeieWZqnICq3Pr/DngXSfyhq8ElMuJyBNCoAK3Z5g24AvEiKjiHdmVstJhzGad6Nr9pBQvkG8VUu0xUrdolcahWEYItMZfrKDwM72dt/0trI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PxRb0TvR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=BhvG4NFA; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PxRb0TvR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BhvG4NFA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729145957; x=1760681957;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=so/yzF74SNRcoWccNWocHjHJ5RDZOBikcPNh4jtnc6U=;
  b=PxRb0TvRKtDXzoMC42OsQHUvbdQOHOyfhquK07orZTwamCekcEPkRHzB
   gAjKNV3ipI+3seBHgKrRwHCKXTss1uwluhbnsVGiv+NWX4VRkI7Z+lUwG
   ENHapdr0FUxPpTMwWZHjC4EKMymhcCY5iwW18vZ+HX79QS469iMxs57Qq
   zBcSiE4tEwtuY5V7t7v+gHLjC9xU9I82DyLIvW8XqbenrHCCBeuEuL2FZ
   fsY+my++11tumKXarkiSUdcchIMtmV7V1dqgNGLWUqYeUkjs5I7KRvxmf
   sNukzBmejIXr5HqnTpLtIkfLQqqszWqj7HP6y6OyPDhZS/Ir2yHZXK/iu
   Q==;
X-CSE-ConnectionGUID: 5En8+a2uRy2smDVjO7Z7gA==
X-CSE-MsgGUID: ma3+T9pQT0utLShFRlY9+A==
X-IronPort-AV: E=Sophos;i="6.11,210,1725292800"; 
   d="scan'208";a="29156006"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2024 14:19:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JvCT7+Kv33wJ4jUheSFfxUZX1WOQB/qfsqTwsWZX7oEsgISBqGJ/HH5Gxxj4GNDtqs2plqAQqPkO8UzHd7qNE3hzXHESZZHleQGMzBi/DkU0j5NkSmFuygZlRjLNH7YSxTOC1EuDtAco6NQWbjIZ9UPrdwhou6JDTtesIUhMEfEooiaePHTOZkElGiSr9A38uF6cmdHZ9IyuYbeAUqEmSgoSWlsj+SdusUZ5P9TLkkaRg4nmlOTyCfbfiMwczBYEstSNgJ2kGEywu+DvQ4zrw+IdS0F6Hgq9K+4acAZyws4D1y9oa3QqDlEaVdO41exc1grw8H3QTdawC1qvbJPYeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=so/yzF74SNRcoWccNWocHjHJ5RDZOBikcPNh4jtnc6U=;
 b=nFaNvoH0fNWJcEZJ0WmIBqC4bU2qtcWexvrtDbzQnQ/rSUoHPG4BJkya/oWDXw29VVKQa59A6x0i/0hdtALjaJBxwaKAqJbpSEPRT8HxooJ4k9Nn+7xf8IcmfMwczzKS67JwSp0ozr6smkCQ0xJ0oFCfprgGlv1MzrokwUl5kBCMp7uL4paUwhRnUWoDEo0Y8K4M6/+ZMqualeXrCWv4g1h9vBHhyIOg9ar9aPoIzXJdIFQZSBDH+c6asbZmJqb4NcIqB3GzXPnxGomsUsLsJb8MJXyWFFaumNIG1eM5LTh5ByMr9h8UAmAj0LRi9W1N83prtrcf0W7tYW9I2qCnJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=so/yzF74SNRcoWccNWocHjHJ5RDZOBikcPNh4jtnc6U=;
 b=BhvG4NFAnMaCFhr9eBzwWWfHlXUK4FA598msAtN7SywOfCWH5eIzRe4e17ObqDXVfvJ6O1D2Y9lDyeiGyL7AdtHL5fNsneHV7RtPlmSFQ+QoMKzbOEPbAn/djvE/EbWxidZWE+7n1k/iAhe8P+B4zFtHE+tjhPJQhGQiaWLLfAk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA0PR04MB7465.namprd04.prod.outlook.com (2603:10b6:806:da::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.17; Thu, 17 Oct 2024 06:19:07 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.019; Thu, 17 Oct 2024
 06:19:07 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Peter Wang <peter.wang@mediatek.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: RE: [PATCH 2/7] scsi: ufs: core: Remove goto statements from
 ufshcd_try_to_abort_task()
Thread-Topic: [PATCH 2/7] scsi: ufs: core: Remove goto statements from
 ufshcd_try_to_abort_task()
Thread-Index: AQHbIBAcLZSn0DkJQE6nLOmfP61qPbKKeJzA
Date: Thu, 17 Oct 2024 06:19:07 +0000
Message-ID:
 <DM6PR04MB65755A00A2112ADC3A4B154AFC472@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-3-bvanassche@acm.org>
In-Reply-To: <20241016211154.2425403-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SA0PR04MB7465:EE_
x-ms-office365-filtering-correlation-id: e4612a48-a201-4a1b-d0cb-08dcee739b3a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?b6N4knC8CGiN7ZNv72AvrRDulVMw/uiLv6h8orDIyMNh2pGKtM4GS/iPXOpz?=
 =?us-ascii?Q?VLDLraufav5gwc6pyWV4xd2E21Cixhu61pEJZHXZhv6AQeqpxBiquOAd70LH?=
 =?us-ascii?Q?9Z8bb64INANstK4IwbpM0tcOEnoWmZ+x6FsIuFLFMJ8Hq97Maye9f9WlDVSH?=
 =?us-ascii?Q?wV48cCdHqbp447SlgJvhvsUvVJik0EfJxwIeRtiPLL3VHoDN/siqM3q3Z0R4?=
 =?us-ascii?Q?bKCRCSXcqqJDdqXjpXNzf0XVOzKvqYuRtXBuBvT1HAnhELgaCnIuprj4Z4Tv?=
 =?us-ascii?Q?Vl4Tw/RC0DbbRF2UvH3Om6Hr7O96zESDjiOqkZsNSyjcCOJxExBvZ03J2tmM?=
 =?us-ascii?Q?viwjqdnXqWuXgn34dnB6FVFKrI177NxpgQnV1kl0CczFQUSo76nywB7xs65y?=
 =?us-ascii?Q?TfTFNcc9it844JhE2jis2yb2WkVuvR/LNRDv4qteKWBRsivktaRC8T2glXha?=
 =?us-ascii?Q?zZRphR22Vo/sCKGo9p8rK3vGDDe99/QUoQzGrl5DNaAF1d5PJpwNA0usAwB7?=
 =?us-ascii?Q?+uqyi6hZylC9WFO3EHIPWOoGvJfejeU8MBnXZX/pYObrbD7EIK1NCzDhXxhL?=
 =?us-ascii?Q?yar51lwnlODEcSD9shh9C2A+ySKbQqPY3452nmIjU6sNr7ppSd40uUzjs1wP?=
 =?us-ascii?Q?wn9PTeqdMVTyO2a/cRULWH/+7MSNy3zwa9wz79ej55D3pF/s+WQeR+cJwF2f?=
 =?us-ascii?Q?fBJXRwvff+BHLhG7pc86kZo9XP89YzK5tomqp3SuR6jA/sWNweqLkHPiyriY?=
 =?us-ascii?Q?AYbhokoWi+DGbKed49md2pS4DzIVpby5PfrTGzX2PDl7U6KstwG+Rzei1oom?=
 =?us-ascii?Q?h0xsXH5tLd78utXLGl7O855QEYrHh2As4A21myPpbGWMwBdPm98cS9BtlRIz?=
 =?us-ascii?Q?a9o0mkXD/DPLwTx9iKiQmKDYSUvhy7W4Mrlu+r52jmv5hbRvyIG2b5NIz47E?=
 =?us-ascii?Q?hgVlh5iV+K95mJYf/fSQegJiX1ke+scLXA+TBMMXG1PKR5Ims1L8P+LZ2g9+?=
 =?us-ascii?Q?i2OrSYoTikO4BHHhWvYm1lbJ+65AhfRxWgn0ePHl5EuG701FG6g+hKSzn0BI?=
 =?us-ascii?Q?jv+XCefz+G6Sz46TIOwI80GENgHlVwGj3o0vPt4MHvSooDrgQQUz+RnQLuDg?=
 =?us-ascii?Q?r/qKZWDL2Ug03TnBBnvUfDq1TaBdhhS3JF420lDSM+e1Fg7Qw9MMXef9RAst?=
 =?us-ascii?Q?P2KFrFEZsLykw+0tyRM+Kp4REKWPDaJbBxbNSQhuU3+2e3rOfyrdO9fNjGfB?=
 =?us-ascii?Q?qxyuJtIIBoW6ANq9VCMhFv68nI7zI8ZpZfbas34Lt4JoGUeiBOqxJWCQs1AA?=
 =?us-ascii?Q?w4+lpwQ9feOGzs8bt41ELNKrihvDXcQsGwmF9UTVVNGZFp4LGIdl1aj5DmAQ?=
 =?us-ascii?Q?Jbz3q8Q=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ui26WnrYdH5PiyXlfectZpfPPiXkJalOvOhL9cohGhi/mhvjgWO1h06CY/SX?=
 =?us-ascii?Q?xUrPe/lBnmJRenZILyq4e1zPoPnt+kW1NgDnkSCLNgg9ZnCkSHuRBHDSSAC9?=
 =?us-ascii?Q?aFppJTuEoi+35hq+d5X0rvowzAPJCFsrwxHpNQQ1+G1cDWdYVTajdB6BaVgF?=
 =?us-ascii?Q?uwKygK4ZRBwA1cMZm8q29yuI16v1DPZjxYSy6Rra9SVOjpNtdP7QRQXA1YwR?=
 =?us-ascii?Q?7drIm1xp+ORGvaNx1szjDf4zcR+7/P7+7C2DiJ4zWUFzDeILpB7eYPHoRvHD?=
 =?us-ascii?Q?MogAnLqUsjisxQf6vr6vbuOzrMOim2aWQswZguY6UGYuwajiz8e1k0YBKhjb?=
 =?us-ascii?Q?AQ6rVZDOlZVv8WNyPGjp4/gt30tSzlcwgco9duAXGUZgcxxkRoYDLivfxe3G?=
 =?us-ascii?Q?uTjV0aYJX4HfG9ULg4l7xaaUMPNPL7+wwtUR67vspkoCPYrs0MfKqg4YZSdg?=
 =?us-ascii?Q?YAkYSFk+v/weFiw2sfkc8vQ7lyymBoFwUGCgJW4Q0iO5qUFiDev7o+JOFInv?=
 =?us-ascii?Q?43+UyfGrnetTLlZW55Tt/scSxjxWEZTfuUaHSqlZESeVw2Frc8qB5Kfv8CIY?=
 =?us-ascii?Q?b1fwvmf/WWCMo3gh4i9YLgChNqHjsJdcbN/KmnvFPELJeqpyiJwuATKXkFjA?=
 =?us-ascii?Q?xMwlO63gOaJwv7qJW3+kQ833PF7kZO1SFxNw0FOYBmx77BCLoxIJgxqIfC0V?=
 =?us-ascii?Q?N9gfcrjX3/ZBRojo/MRdUJXpmxGnu4f7LI7TgUoGga+/KMbBG1Wc5Cvnyvmr?=
 =?us-ascii?Q?7zQL6Rk+9LrJFZJvBARQYB2KWob8rywd+7NDc0KEVmpJNRRa0bgVxv0Wvidk?=
 =?us-ascii?Q?xGI1/oZg/N+X3mGKqOEr8xLlmBqXqzRlIxccBJcnsxBbZ1Jb68R2SUeaUrGL?=
 =?us-ascii?Q?2qBvOc3VqBeCeDyZvT1oviiot+JSm6oFpy6ooV/n72BZtha10DjmqbbXTqOR?=
 =?us-ascii?Q?d/RwJ/+SHz3y0fpoddmDzqHtCBDdRTUlCNtgxeiaF0o+pFEnA0K1GEqyjGSI?=
 =?us-ascii?Q?ku0ir+ajwB15cSfDInws1uStNkqZ72ApyW61sqlpXTCmhtB8OuTPb0MmCqfo?=
 =?us-ascii?Q?x5gAV5VWE07xgMI0jP+5VFOIb8y1Bz5oGff9MgL6KJa6Hq1FdkVLpZnQVIWG?=
 =?us-ascii?Q?ze7iIAPAhuAq6qLHLLwIJHfUB8ImozG+4b+vT4piu3qK4MHBMvNjMLgUi7st?=
 =?us-ascii?Q?idg9MW1HcnOWx5/qNp5rw1oA6P2gRArfFVGnFX4S4CRMwqP+WKI6UaLsrpTS?=
 =?us-ascii?Q?aLvuhi+rN9HnizsiEJLQyKRrG4k87+hIlh2iu+C7Qg7zI8HT6tDKtWx5GiFW?=
 =?us-ascii?Q?VmXwgBuWtEUxEjONDp9GuToUN3aZ1zZPDeBBCd3sxAAZc8yru5RhPtwiRIZl?=
 =?us-ascii?Q?C2czY8IREFMfUUHvII6YqdTjFN7v2uhdufs5LqGVX0rgier6Rfc4cBCIQEm3?=
 =?us-ascii?Q?AIAylP/qrBnAe1FNBvwzYGCrSHvOySD+NVlSqHQ26De7NcbHL9R5IUv+JbzA?=
 =?us-ascii?Q?6QJnBXOJV6Wn5DtwLaAJ+UpDI1hilyxodJ0WYTW/IxmwEOELnIUPGG1kfH9j?=
 =?us-ascii?Q?Sh0FZRpQUyeQ/KPu7z44u9fbhYwVdoTqQIqIYkCSVWMyB1ijKkEzBvlQk/Zl?=
 =?us-ascii?Q?QV2GmoTdNk4bzIj/ZcwNtJJ2bTiaEWaG76NRBmsR0R1M?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vB+7aEaMHPm3ZS/j/G+ZDx4h+Jmk/72Nh7hD3wCuH07cN5k36umnobFlk0HMLV05YKwPucW/7LhIWysU+8OItoZ01Ls/ttbR000AMqVTphA9dqjiroS4kQl+H5Ga9Q69wCERRUyoLIpr9FtvfxnTCVQDPOAGLC9Z7OYWMV9ZpSkTp54MttgQDrv2C0t4X8sTT532MGOgl45YVunnFnN61fTZgjDKFasQkhMJCn++1RfYjmCAolOTJD7xftrgR9depuOp/MJpZRydF1LIpTtcUj/KbICUhA6GemS/Xf9tN8VTqf90N+M1d8mleVUr3JvmuT9pfxT053Pm4qHljXAfgYDw08zKPLxS85/nZMbplPbMrJCggcenBFAHdVddtccGkdsvuCqESOnQIu1kvMKhjI4+EMjJZyPBjFhVwYmgO77C1w0Uy6YHrbNYIh6UuccS//L67JZue4Lyxty3Wp8JZOnFdLnPxrJZ9p3ldKkIxonFGygQZwGY+g0Cfu6vo0NWGAcaTVjiYxfQM6ly9XO8usR+1TolkGuQ5tM2enO27mxY0MYjqz+8zjpeoyetvXoKNco27mNQtzJE6ZSG/MZGkTnH60nbmr3GdTZAoTSDgjG7mLhcFXomdZ9/Cq8o83SS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4612a48-a201-4a1b-d0cb-08dcee739b3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2024 06:19:07.2351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aMxDc8MExQWkKN0/1+6xiWOhqr9+T1nvzJn+OQ1AuZFD1t5BShS+k0xrEJ66YmdvF5fl9bebYrO9gA+MNTsUmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7465

>=20
> The only statement that follows the 'out:' label in
> ufshcd_try_to_abort_task() is a return-statement. Simplify this function =
by
> changing 'goto out' statements into return statements.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
