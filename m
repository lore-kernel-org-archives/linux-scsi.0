Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C4A1CAB0
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 11:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718708504; cv=fail; b=mSl3SlMGgVsJpkMZV9gYPGzJ3XGvTNF/9RMFM5h6Rp2z4YO1mRTA5UJArXC9X9/zyrTJe2oFDI0m+IZ/iK+9slCzVI6uvPEim9NFMXrIdRBQX4gqZ0uIIYUo8TDFaM1RJlbd/VAlf3HEhMfNhML8dGaIuyvHyZJN4TBoDF2Bc9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718708504; c=relaxed/simple;
	bh=ypmERQuBLikuLri59Qi/dT9q3+v/7JsRKWPPmaag6w8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bAXSEVYNjmhB7xF7PAFsbpNRqEdhSUMVMWqYkeq7wqAfXPOYSGPLtVmNGTSmuIGj4Mjl0nrAV+A54jjljJ31G8sYTHLWRa2wMvh92y0RyINyuc3mXMe9d6wxkl4aGHqPTy2ZOYJ3AflyyRX6pwWVnm8aV1sEcfDTAMyKROTVKcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=d6ssWOgA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=qmWiC3bW; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="d6ssWOgA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qmWiC3bW"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1718708502; x=1750244502;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ypmERQuBLikuLri59Qi/dT9q3+v/7JsRKWPPmaag6w8=;
  b=d6ssWOgAcS2G9RjlhNAKBLuUi7hdAibzXm/NpmJN128fuvU0QzlYbrXz
   QzB7gMnG/A0aIy+ZDcZxXOT2HqQap61QtHtvYXgx8U1r9DRyL067+qhfR
   2NrWNo5SrWp6ay36CXs0krKnG0fCDrgm4ljqBAGeT0iubVNnlTUTBdRUv
   lrci7nVUeHN8V/waaczupUu5pgnl7k1rdAEB1+ZiDe2A/RUNWx/KqTUQC
   jK5ss6UBbTE3SpJSkC6gZnlZKHfhgr6SkQ70IneWyis58JobGm7VTDXnt
   8UOfZ3WdIqvu2sltyaN3iO5Ipb8kdCOG35MJFT2O7WjOHmhqCJKMKoCa5
   Q==;
X-CSE-ConnectionGUID: lJoaji4FSfSmdf8Gk6+1cQ==
X-CSE-MsgGUID: T2pxN1eGQAmUjxDWjCTl9w==
X-IronPort-AV: E=Sophos;i="6.08,247,1712592000"; 
   d="scan'208";a="19710285"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2024 19:01:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MLLsyI1XUexdgXxibprs6aeQ95KPY6VSuz638OdkGBkDp329xqjokXJcwOMkgkXNh//Ws79pOmKldmtqIEnkKXI4pyXnKdVZh1OUf6mp4gzTz/W0ZX2G08RrUWTOih3HKuncYDto4injkhepbTMf0y/WHIa6Z818o0MADaYzMxf49QAqS72g1xAPWs1BA6p3ETvXBeJhzznk8V6V9fpBTKzFkAfig4SaDjw3khs8PMLGpU0k38zODdAgjZRaWImFcWlLnfvFHhWHTMG4cvxt5EEapuq+iTU4opY2Yl9p+5FY+zwkrCouswjrkdLtqozRHC7chjB6krvyNL9O/FcNSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypmERQuBLikuLri59Qi/dT9q3+v/7JsRKWPPmaag6w8=;
 b=aFpJfse+sYEMl0Sj0vIM+jAebU49eMOvYkAkMTmKlxDR/DX5hYcTrhUtCAW3KlP1A5kN4BjkSus8N0Ut+6JnZ5CgGPGY8gzqAY4kXmQT00gcDVFBVizyYirlj8hxXlckiSefx4CIuPVrWFyJwNcKzXRHOc7/LAzqXFpqHamjEECu4oifp/pJJHnojdkFCsaDnziAm7FAp+RrzPr43NeMA1CaG8tIfIXUjN0KGTvgEZAdb7WloumdvpilLS12wpcyx9MjEHvELCnovuv5veRPkab6TMtbtf7dnF8JwU1oX3iL13qeXcdfpqPdFpwQIZ+yq67RWv7Xe106eNfg2SrvFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypmERQuBLikuLri59Qi/dT9q3+v/7JsRKWPPmaag6w8=;
 b=qmWiC3bWXRBNxo2rURda6i9nmUMFle9cRw3VOrZAxVVtomBJzGeNRJ5lYr1+JzkU/0aBvueE/PfFHSjOYO3JiVvj9ZmQaqZ2Mc/VmnCUOx/GT6rWgi8vRhz9kuWVmF80UASLuH+P4aDp7r9baDgFgrgqy3kVeoLNK1QviSmivDA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BL0PR04MB6578.namprd04.prod.outlook.com (2603:10b6:208:1cf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Tue, 18 Jun
 2024 11:01:38 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 11:01:38 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Keoseong Park
	<keosung.park@samsung.com>
Subject: RE: [PATCH 5/8] scsi: ufs: Declare ufshcd_mcq_poll_cqe_lock() once
Thread-Topic: [PATCH 5/8] scsi: ufs: Declare ufshcd_mcq_poll_cqe_lock() once
Thread-Index: AQHawPqxjJJv27P2d0eAhauIqFWrn7HNW6Xg
Date: Tue, 18 Jun 2024 11:01:38 +0000
Message-ID:
 <DM6PR04MB6575AB2A723653D28F5FB885FCCE2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-6-bvanassche@acm.org>
In-Reply-To: <20240617210844.337476-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BL0PR04MB6578:EE_
x-ms-office365-filtering-correlation-id: 4d6d31e0-d380-45e4-cce8-08dc8f8606f2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|1800799021|376011|38070700015;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?rxRRLE2tRdO8pvd4oCopEO9GJSJ91ioK5YUEZILx2Oww0iVvyx0dhZt1+jB0?=
 =?us-ascii?Q?0vu7KhvSA9NcpKVyxu/wTReyMyOF+IyHxNAZn4v7C2SNpxKmZm3ccJhYIMeJ?=
 =?us-ascii?Q?i/oojHuyE/FceTwy3ihGybDkUZbAqKa+P0xj4zSShePxMOwHiq7MllUgaGeF?=
 =?us-ascii?Q?bP9cw+KRLicvlX32K5C8WJRrOshMEyHekXGVoVfOsEMT9YCogpzHhopWC50l?=
 =?us-ascii?Q?SJvhhXkmTUXONAlmBqi82ZyCf1JOowQdgjYMdkhl0V4ab0YnqJNz/PxdMBxt?=
 =?us-ascii?Q?a9ln3DUTrmvMlu2SoudkRMVXmcJoHezBoEb2qUYZagPQllcEWHPGUWGyYTIy?=
 =?us-ascii?Q?EqHnT9SW+k+L7ESb7opRvV3kfQ/OuKh7yXjFBhMJhvxoMoqCO+r/Kj3BMBfd?=
 =?us-ascii?Q?MrbEOLX7FzsAznHT+FFmpiy8hg39W8ZihkgT/W/JnxFeXI6rAXqAdNgTm7Yu?=
 =?us-ascii?Q?/IAum26AjpcRZs2nKnAMoUWyKl2nRLZEPzfwsIv0SuCfNLJ74QcXc6YgPFHt?=
 =?us-ascii?Q?nE0gbTYhy2f11N2Kisutuk/iMYJ9oewSz2A1333vS1+UnIIfaqT5VYhe/WM1?=
 =?us-ascii?Q?v1yMrArpxHHb7ErIqb7aVyCTHQdRVXd882maHvFTY4dPv0J4BfM+/jQSO94M?=
 =?us-ascii?Q?kmvOeoetXvROWwnGuCfS40yRo8C/PcjYidDXh7faonPWRKFxMI7OZE/y00SJ?=
 =?us-ascii?Q?muH7BZXEepVtT+cwouJgA5uqlXc8LPgWKxefZ/c4uPDgsLpViHgjGipvtZvk?=
 =?us-ascii?Q?g9OQTuuJ4MKJ9WU5jEK/1jijq85wkso79nlEIIDcSl4wgq6sImMHpWWIZWeT?=
 =?us-ascii?Q?2j/FsKAlyRqPLnLET04fQpCJOxPHRSJ98zCj/k2yANQhYpU8+2sFpZF9vrFL?=
 =?us-ascii?Q?pwDLOmMRr7tj6UTHwBaRRltUzwzjTI9gD+LnYytCw71qKBEGDE4GMluXxGzt?=
 =?us-ascii?Q?RWk28IiBqiKbdXUdlfsYYGRZht8dUgrROvrjQjgpM7WKSsrmiiORPJNc85oA?=
 =?us-ascii?Q?iKRy0GvsyVlfKp4sy/84OUFsHGWNezdMm/DH7j2ZR9cbhrt1BhwL8+/wqjNE?=
 =?us-ascii?Q?YAZwXYgrS+RJ/MmeC80FHqxeKqPvVWGpW3jXBQCKxUC46Kpmy9zleGWDfu2W?=
 =?us-ascii?Q?ZmNCGtxcny09N/6M26UdKp4oPH3TnIwBcn4zxa4GHjcjDhs4y5/hKPU/EKdx?=
 =?us-ascii?Q?YcieZNWCli/eill7khFkrh1337BjYdNUsqWbyY4FnmyGlEGSN7ySg+PZ80nn?=
 =?us-ascii?Q?E+jPasDsAtBDGQ/YTjm7HDKjCpzbUwKwm1GR7JCSd4I5/yuVKh5Tzk/f83QW?=
 =?us-ascii?Q?Ht0+rUXWr0CapTc80wK13G0EnEQlXtL38ctzMTxiQM8rsPhLr37DqINjCqJC?=
 =?us-ascii?Q?OWEFWnk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?M3gnngJEVkei2neMHsQBKzhlycWpQ08E4Oo+kvCkK0y8fWkaaWde8kwI16sj?=
 =?us-ascii?Q?KYsUazAuIlHZ/15lwz2EPS4lNd9pdyIDDmXFIJ7bwN04RIbE50R9JZi2f5Ax?=
 =?us-ascii?Q?uF94X7/3FYQH2nZOX/5xFFBMYphvcNkqmSLSqsswm1+d1GZ7dzQj8qYwWsml?=
 =?us-ascii?Q?ScUo9siiaV/58rvdsRGPcGYvxw3kg9wmmnIosIossZfqztp1DXNdYN++M3Qr?=
 =?us-ascii?Q?8semZf7Sl7G+2jezxKU7JO3eFqU0/uiYY2/OjC3NOldURXfW18nOUj9ovqhG?=
 =?us-ascii?Q?Iqqz7JEhzqoDZHrjJWzl4pY2EQVudEzSDcTtUjl/jqBuuaYlDqzebaNKTYen?=
 =?us-ascii?Q?/yvtK45I8+ndpk+hD2v0rgbWEuBwaN32eIKaBFvfsV3ayfO2rFw0JQiJ69Wx?=
 =?us-ascii?Q?Vm7NUh4rtEPyRtkKxtaKCQImp/Caa6C3vCn4JEod6CYL+il3Vphbuwf0+BHT?=
 =?us-ascii?Q?y912r5bPEw5VPHdbz1an6Jb5EV0DabB78bM2jr7pkhfd/10Sgx6a+LWNNG1o?=
 =?us-ascii?Q?wZNry1C+YhowPbulwm+rYMmZiaH/gJ47Fh0zzn6ayXZKTmYBOdvOSwACNaWf?=
 =?us-ascii?Q?d/ui81BLhE9ny4Z03UKpQgBKIxInE64VOD24/LlgyolhWUTA8k5v8w8AN1no?=
 =?us-ascii?Q?FxbALNARonaGpkXj7HKQxOONmQwgd95u/6ZcRz6ZgU7IN5AnFRPHyGxzDhHY?=
 =?us-ascii?Q?K0y/mM1tQeYK/PgHLZifBr2y/rbidYpJmxNT/MCzk91o6AVT2Jw25QCJjq01?=
 =?us-ascii?Q?prUuYp9Acls6KiIyW7vKfjFx+71OjBfi3til8/qoIXVG8/TUMWRk4Vc6byu3?=
 =?us-ascii?Q?z06kA50JrZWg9cpzJiF+rKf09fmubOrpPs/zuxS3ahKo07eStg9VvABF97o3?=
 =?us-ascii?Q?nnTNPpPMCd4L4Dp0D8b71fEl9y0Y7keh170fX32tNUzy1jQqQLPBjsyMBzNY?=
 =?us-ascii?Q?kdR16j8YF1zRmhHvgLPjIRDuoe9qFxFOYPVn1rfj2IfXQOSo05YJVuLkDj13?=
 =?us-ascii?Q?JJP5c+33EPDSYekJ532K93G8T4+87IIJ1JeTxrbSXqZTVFNOT/sEM/M7/eUn?=
 =?us-ascii?Q?ZHJ3i1nGY77K0W4ZZPTycNDVun1eUXMCremQUgY2LFsH4oior3npLaxK9Gg2?=
 =?us-ascii?Q?cmbjwrCC2jtBag/P3R7iJxvvepYQQqmn5rVvmdYG95Gk+8AEP+Bzc+cjwOLa?=
 =?us-ascii?Q?T+iMqKGI8jWiEfY7w9I/BSJMAwdP+8QCAOTHkfsSpE1ltdxVtDMhpurZJxjy?=
 =?us-ascii?Q?kLLo+eL82uEHqQRbA2G946H1LUYVS0UDCh8V2TKQofSGyT4UbgQR8upD2G4g?=
 =?us-ascii?Q?RrwmZKYT28PjLIp4JTqArWyBNpLvXA9NgIQmN7V0NxSCZmLlRWVENEGwJdFq?=
 =?us-ascii?Q?NP8QOg/6Xvmb+xoc9nTRfDfbRKxFD8H6Am06FWv/979vIX5DSQDm5RkKYyEP?=
 =?us-ascii?Q?wqJuBVP0tae33zGnOE6SnWeEOL0Pjr3PDlVXlIybGYxWwzg9r1e9UGYtG2wI?=
 =?us-ascii?Q?PszZ8k50FIxxTg9P+grqDjtvx/sUgBORqu0PN32iLAq6vrJ1kO2h5pSp7B+x?=
 =?us-ascii?Q?wmnFqPeXTHohU6w3P00Y1oTcBgjMNB1tUn/2beVc?=
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
	Hmej7FmCivHtTwglNHptyvpJDZOalruLmHWg++zlA9b8J3dQVLrNXug4UKkhtohQ4gSDncWr1bxTEZiUCJnw1g8v45IBuXT3D9hMIxEWyoq3pswQpxCkQSwhS+hzRroNd14VIM0gqTvDwT2AKfnd/IgmuqCkaKuWLngAk3Er0MO1ZbY28sLeYCtEjX2/Uaim1WFXgGmzgd+/d5ZC79Aqj57jY0Jx9JE1a9C+tPD7RFiBV59cc5Mmo92lBBJ3EK4j3Ji/ud8iGqYJPs/1G5yTXeeLSsfobyNgImCteda1HqHVKH8BnSAletm7FvquoChkkQB74ZI7Moa3WRUbW+ZmtloZz/HlEe6tVMdtJxprEYHu4Z9HBHnKr6iVxZTl3xGndzI4M63alFbCMr60OUGqwDmo33Pd3l3YGXc7DIFl8pYTe3wGSH49DPfxMxOsS6hSzIEOuksE28kXyuufKnKULAHPtkKS7U8H/JMNRXulDod9Jr92DO0w8LHR2C4xmtqYl0Ri4Ed3nQLsFxdceuDCDWUU2RyOBrPdLcxOq0jbzwxvnjQ8K/CcCZmY/GvhVMVu/H0udhIoDWHt4aJS0MD3NiPTFBeoYxZ2ij/Q9mc/JYo5iOhGafBKwaGPfCfCrTz1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6d31e0-d380-45e4-cce8-08dc8f8606f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2024 11:01:38.4168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oRLnZuHS+zKhiY+KS7JmBpTBhCg235cNyoSmgl/ymATckX7UUuDPZ7Zui1aySx5Vhoo1/os5NATWVHiPQnGXJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB6578

> ufshcd_mcq_poll_cqe_lock() is declared in include/ufs/ufshcd.h and also i=
n
> drivers/ufs/core/ufshcd-priv.h. Remove the declaration from the latter fi=
le.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
