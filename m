Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5BF1FE474
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2025 09:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750843114; cv=fail; b=OpXhKY6dZJE80tO7eEp84XplBOPgfyu4uWcMVz5er0iyxcypqH/W0XVrPEpcEl0hw3IVwuLoCzaVjzKsqJRrym9Azq7K1NBRMqQHmO56RB073yLTazrN9OaQ8opanTz9xnY4y2/wUvhkX2hH4+esQNHDSIjRfB4JDtvEsSRONDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750843114; c=relaxed/simple;
	bh=y/AJFa/Ixo+pvFNFA1e1ovUpM7wfeM7N4oLzug9CNTs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MUOozEC1eZ/5JDrfmoRevMi2FTabUBiu33TY9uwuAvft8UUvspX+yKDyQXuIRqWMHvFEt6qC3kYeiELVjMnQ0yOsJpbt/l0F12Pv+IkGBF5oZKmd/Q/g+rLF+qikHj+BgzJCdJXx0N5hUa1DF73fWPWTJ/yrrSOao/C4R7qwLI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=mK3NFSdX; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="mK3NFSdX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1750843112; x=1782379112;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y/AJFa/Ixo+pvFNFA1e1ovUpM7wfeM7N4oLzug9CNTs=;
  b=mK3NFSdXQPJe3SzCM5uSnHFrTMZ6p+1FILvJQOpDBqjW+kDt0LtCAKBU
   10PHnSkBFz3r1A9M4qDGHtmxS6I/cD5l6NADFjsNI2b+Ah6g/iE81qkmG
   JxXRoB00wYDhMF6XeR28oRBevzLkPfMaZFz4ZKeGVqeFemZ9JCKO1eFQU
   2fdkXvzCGeJQdwdBmQ/vR5sZC0U0KwYSDgvAFqKBBpO7ILpEX0QNZnYPu
   ZGLxSGLlpG5aL7r+uLTEMNsFG10pUmaImAkgDZEM2Us220GgHYrv76N+E
   D7o7H9i5w/NFcryDJxjYYX3Ee14q1EauIelyIvmW+ogklJ8fY7BUl6n8B
   A==;
X-CSE-ConnectionGUID: Fw5A3/TqQu6PoN0rif3kBg==
X-CSE-MsgGUID: vADwc6ZXTR2QmmvQ5Yz2Wg==
Received: from mail-co1nam11on2112.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([40.107.220.112])
  by ob1.hc6817-7.iphmx.com with ESMTP; 25 Jun 2025 02:18:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ogyPv9zbmYXnvqdEUmaTMEko9Jb0OMLWCFzSvtQ+7/c/6vCpIcHCVJO6SS8bvOzaLCIFF1t8MR0tl5DlA56xSQsncKW/q1go9SAOVgF7n4HEXC3ktG9DPOh4ReeUUPOjH1zY9E4sLDthrgF3GzCVVRw+NgpcQKLRLLNFTFqx6pLlt5vzLd3tBabQ12c/c0mdDA/wDRBUDWgPT1o875fP7EKasIf30xmiA572XdjFXJegBSMU++0f35zrlNx8fJd0BQ6AUUiAelrxUIFdnUjHAM4owH4jxmwBWbrpzGWRVAiHP3Fo/LrQSejUoJKhf6QmBoMwqUnQ2prrCHdp+5hmiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7OQLacowSCVjFJYBxfm+z2x89dugpH+JWm9j8mX0+Q=;
 b=eFzIOExhgX2eOv6ik3mW0zVwHWC6GtmOD5LMWY5MJft/0n3GlATbkyOXmH+VCQbLI+OkZp//ojBkGkMKAD1bmBuvgSPQYAkkA3mJA203ngsa9/z5U2HO/V+ckZR9xFVkNHJuRN6cwktNh5agFmPXJrIzpdQnsnLwoBZt9TZ28q+9nqEabpkJ75zun71ZT8EL/IqZmd2JLHWJfrMFJt+vFv3Fy+SlXmfmOyRbJrL19rvFTombcZEgDP/dEjSRIWI9gGIGTS2hHbSmUcfvmhU2MvbcKyQirtmpHFs6Kn+Hpab6ab+JYhwJTtuVuzqkvPpZQJcK0mnK86hygECVpnQ4cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by PH7PR16MB6245.namprd16.prod.outlook.com (2603:10b6:510:313::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.26; Wed, 25 Jun
 2025 09:18:27 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::436c:8204:2171:b839]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::436c:8204:2171:b839%5]) with mapi id 15.20.8880.015; Wed, 25 Jun 2025
 09:18:27 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche
	<bvanassche@acm.org>
CC: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@hansenpartnership.com>, Bean Huo
	<huobean@gmail.com>, Huan Tang <tanghuan@vivo.com>, Peter Wang
	<peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>, Ziqi Chen <quic_ziqichen@quicinc.com>, Keoseong
 Park <keosung.park@samsung.com>, Gwendal Grignou <gwendal@chromium.org>,
	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Al Viro
	<viro@zeniv.linux.org.uk>
Subject: RE: [PATCH] scsi: ufs: core: Fix spelling of a sysfs attribute name
Thread-Topic: [PATCH] scsi: ufs: core: Fix spelling of a sysfs attribute name
Thread-Index: AQHb5acnYKFFjqSKIEeGm1M/32S02LQTmMKA
Date: Wed, 25 Jun 2025 09:18:27 +0000
Message-ID:
 <PH7PR16MB6196ED0C10AB89377E33F18FE57BA@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250624181658.336035-1-bvanassche@acm.org>
 <2025062523-cheesy-engaged-88e9@gregkh>
In-Reply-To: <2025062523-cheesy-engaged-88e9@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|PH7PR16MB6245:EE_
x-ms-office365-filtering-correlation-id: 43761862-b887-46d4-6427-08ddb3c93ea4
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?dTxrzog8Nu43KQ0y7FhVMLPu0rgLa4Nv57JaHbD0uQX1GmY7aE4DTJg/EGHm?=
 =?us-ascii?Q?+yB19GyAfOxiDKVIa2tIAwgBacSYLxSiD2Zu8H2d+ved5SI4aCmB8SNRXUAE?=
 =?us-ascii?Q?dE4EG+Iujg2NWhxztMy+UpOCfEz+lW88kiT+rZap8q324SjOIzUGVuG1zbUJ?=
 =?us-ascii?Q?xoIZj6AzpWeUkoKVrN+HwDLCa0QPYckKldrv6oQRmBVRM/kc/4Evil6EZdfe?=
 =?us-ascii?Q?TiGPgOt9RNWkBJS8H6VfInvShCMaXVqLPk9+APjw3wgiTNbknYzwrQuZAr0y?=
 =?us-ascii?Q?BI6tXgqGcoNuji6RkabMfcplgHUgc/zhdvl12L6KFjOhMdSV8GzHKZA8grvg?=
 =?us-ascii?Q?siQoER4TePxmNOBbHHTA0x9kt87PtxEUXf0Ek1YjHPsMqiHIcQhm3rS57tMX?=
 =?us-ascii?Q?CAA4Dhds7o2dJ2A3sGZYzU68h/qj/dsBZmahMUqQZuCgn8YOCbTBciXXAQLU?=
 =?us-ascii?Q?zMKr9ptqyK4WzVt3awUGFXcD/qkxhEdYcXgslCVDZ/YGpnC2+lVLw4M43bqS?=
 =?us-ascii?Q?4IlQYKckjaHRP46g/Zl4AnoyjxTZmRS1D6YItqWjOeuC9WSK9ywoCUvCLWRm?=
 =?us-ascii?Q?543aEal78rhUEiH5IkbVlwzgaF83CzGh2wKG3E3x1v9R3Hy64Y4l5ws/NTrn?=
 =?us-ascii?Q?tTnl0PwDAd6qWeLxaGCTawCAAEBWMy7TgHDcB6qwlAbaEzNU1TYEQQSQMYFg?=
 =?us-ascii?Q?HPBA181ae56fQxF4tGXldAMMmYuEffIJIsl+CDKfHzjVcYgUdAyqUEAvfAYi?=
 =?us-ascii?Q?/1Dr3ztFUxWob03SzceW3pV8RqE9R1FRd3SLd4lpT7doF+1GQTK1ITEzsGSL?=
 =?us-ascii?Q?agm7/0adMlhfiu5DZcnQJ2SQE3rZJZxZ3d0iR1Yc5N1rnNAegBxlPbL1tedV?=
 =?us-ascii?Q?pFn7RNN85qM5figEqMaWnDLizxcYXijTqg6Qhg5TbA1PNv7HiafvCzVwafCg?=
 =?us-ascii?Q?O44YbP5lbRGts1wbEmVb5VtubhuktzxTN560hiB0qIsC/LuUtdUDXr5xKDmj?=
 =?us-ascii?Q?GjweSoNp0OnYLwFQgYRofnZR6KGFrMI8fj5cp8jjzMSOpoPUrR9td6AKkTe9?=
 =?us-ascii?Q?D/IYCIlNEMCAWbN/l5KqmAPEYWbTGHPz4Qw2t/NAuoaPGolzKlfqlTKN95Yl?=
 =?us-ascii?Q?TKNoR0/MkviHLgTnd23Tg8gQ6FNPFRv6Z7iwGuFEKLTdpRDueqolsLrJkpJL?=
 =?us-ascii?Q?faZXGs2WVTUy+iD9nsPNMWhX2ckEz2QbMFr9+SjxLCf0KZnhXvmZ0N3ouafo?=
 =?us-ascii?Q?uxWD0gyfXur+YKB99JNNSHS6moH++nd8jakPDkgYXFNBkcWO6o2cDknodYLn?=
 =?us-ascii?Q?5KdW2hX8UGJKL2fID9Y8GJMjCMKr10OXKvARqAgcNJMO812E3iC6fdMy8NCe?=
 =?us-ascii?Q?pIGnQBWpmleBTEqOzLdn/b5byVSpklWlPMVoEOH3ldYT0H0RgybTc0d/UQaI?=
 =?us-ascii?Q?isFhvECaYdrdJfdb90cbgVFqW5/IiVTbWP3LskH6ZNrmtAoElWZ/HA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?okYVw3fNUjVfyig0jr0/+po0/aX0kHaOL31KYtTDkSbqr26mZI8ALtpG6JbW?=
 =?us-ascii?Q?Dx16V/ptNc21uymzAZ7QyHdsiz54qWTfJ89ni2qI5L0jYt+aUypIWfa8NFHb?=
 =?us-ascii?Q?GA8GE+PeP26eZy2n9nG/0UcTU8Pw41hGxJoHkLea3FgMvV1fgtNTMsc9dEW4?=
 =?us-ascii?Q?y1uMNzW8BIuypbRrWkxMVb34Z2MI1fQRdYF/cpWhyd1haf188BUCThIV3B30?=
 =?us-ascii?Q?z7UuyaTVwCT3UbaKs915CDSFz3FEBgTm0wZpLPrERhdnwonNaPH6Yx1E7abT?=
 =?us-ascii?Q?K2PQKxg+k+oRk/5C+nlb7MrN4Sxn4aFEkst4D59VCO4giWkpuFH7woPM8v5A?=
 =?us-ascii?Q?a61pii2Uux2IRLkiGotg2JHFR5GKhQwe9VhxkE2sYJIY2OKzYVeZCOXtQWwj?=
 =?us-ascii?Q?IWABBswEyQrOhJNAw33r8YpowhoyycbasUQMiBMbRtGPB8F7DNWN7WMe6Nf9?=
 =?us-ascii?Q?mT68q9tybAL0X1jkZZ0FScdS/BZstdXTZ+UOpdps6EutaXkaR7bdSIxQhV0S?=
 =?us-ascii?Q?7GHp5FOXUvz04dQy8qInK1ixfUzI33zXou4YKhzOcXiQCWp7FVNww6ouGvzP?=
 =?us-ascii?Q?inOxoX7P0ifa65ZtwRrprDucz7Dr7vQSaRJVQFjXea/c5kgKhz4Ix1TE0M9r?=
 =?us-ascii?Q?wTeVflXci/yeuXuld43KuBCSx48vwCnNrfmKS9wp4jWrITr8sliqj5AoLE+Q?=
 =?us-ascii?Q?74ma2eVEIit5U9hXxJeS3lGGptHdpU1hh2q5hNRYanLtCseUdoDH001ngY52?=
 =?us-ascii?Q?RjCn7dDhngPc+jXjyLOvsI2Sw+z8EMbmFvrLPRZADgr8jmjqd2k7g3ixx+9v?=
 =?us-ascii?Q?DuMdFLIYgYnMrAItWhcKylD1Ud3RwXWDLDcKcg/LproQyz81LeynqVmhOU+C?=
 =?us-ascii?Q?hXtXceBQg7iMGH+hSYSWMSXhqCBS2AAEDGMxWdOdDIoq4WQj0MhQiDXmk1Rj?=
 =?us-ascii?Q?/oa86LOctcqOVb+kshj5RQuZRVjyCWUFt+UpDDR9gbn4aelLi/tfs1i8yS9d?=
 =?us-ascii?Q?AhH77i/Fu0mrb4BFcmy7wCxEh8qI8djQZMJvezPNBoQVvfrt7ocA99elw2XG?=
 =?us-ascii?Q?UfkoVldA6/oUI01PBqbL7XhSTZ+MsLlTdXC94yv6SYryedvXcqcTZjezRjWu?=
 =?us-ascii?Q?aIFxtaZbAKMWTkSrCjfsmPTh402ZQ9IsC8+GWIJO84U8V1Ghf559hIDszsjW?=
 =?us-ascii?Q?lXrHMjLINFC1z9sNnWFdJLD1kSGUSWpFCwiaYWxwWhFax4DLm3h2CBHbDgxB?=
 =?us-ascii?Q?UuyMNMEy5ciq/sG13rL1DbhoBJ1EG91pQeRMLBL9sYyNtnd2KZpE7okjBlVE?=
 =?us-ascii?Q?8zM9j6P094ooRkKzCAbcUjhWlhtmmcy5PqcwLINMBQCJp1csq/3DXlDTtrgC?=
 =?us-ascii?Q?0fPgJhJquuq+36SoaUJgPdeZFDwKd+qlRWuYtzfuEQvjI14QCp1KnbJoLRh9?=
 =?us-ascii?Q?s8NA7hWXleJ8uLUTb6xxwBHMUNcE8J9kYYZaWFrddId8ePOsIxdSI7qsq/ns?=
 =?us-ascii?Q?Yy1CMd6Zqm54dmkcu4xq33X5sNuQYAjq1W2XlkEVh/+OIy2VG15md1loMXUq?=
 =?us-ascii?Q?QHT9E4DgnPiFZIoYUF/UzHRBszOY3HNNDOUqNdPg?=
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
	IsKLny6Ypbldm3R8jUGKD3odSbXP/LLPCMraJtBe+cJIg6z4yD36CaHSesMZnyEMLcJ64anwsGbcXRl0TSLUgxJDnLDOt5ZgEbDH3cUOzUPHjYIv4ctheteY+IjQ8Yza7nnJAdeVvvEsbSjHsWBEyh5BNdZJRlBAx51DzI0DvvzbBmigSarHcO8Y5oODLUA3kEYheCbl2TggEe8qR6HUHtaIXP/HpP+sogsEGX3LYvt1YVTzR+herOxum2BJf/6Apq+M8haqDOmcDs2f0RA4XqEj/LfNczFg+kIbA2UsQvlwHP7U9BEtl7g14w2wuV8FGPjbbpSbs0wQXjqhULvjzURJtfKEGGjok6KrmDK2Fi1D6fdMTCeeoXupns2luqcTMH9eGK1KyLrm81Safr1svJEcl0/Z3aR4X27cIpWPobgFXIHk8KgOl5cte5I7ae7Pq6No7xmefP/9rBZUrJeQ736te9uMURWWWtyBSzaiLbkaLh8leIUlPOOIn6NRL6ghaBruKlHivyi7Mp9qjPs10/XNlTfsMkNCyf0kLhIWkTwLRK8McOvjJM1qEPtxMxNxJiUjqxr8aabl1lsZJPon6p6y964AuPoGaDfa01d7Ic2WFEKTHNYviAnwGF7NA2gIYvLmBX/BmsqoQ3k6kSK0ew==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43761862-b887-46d4-6427-08ddb3c93ea4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 09:18:27.6905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fag2y10l10OVb9EAmreP7PYZJ45DY7/aCWXkkAz53eabRD/HFfJ4scbew1EO+CWNlxzlM+e1gEBmiFY9TF17GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR16MB6245

> On Tue, Jun 24, 2025 at 11:16:44AM -0700, Bart Van Assche wrote:
> > Change "resourse" into "resource" in the name of a sysfs attribute.
> >
> > Fixes: d829fc8a1058 ("scsi: ufs: sysfs: unit descriptor")
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > ---
> >  Documentation/ABI/testing/sysfs-driver-ufs | 2 +-
> >  drivers/ufs/core/ufs-sysfs.c               | 4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> > b/Documentation/ABI/testing/sysfs-driver-ufs
> > index f3de8c521bbd..a90612ab5780 100644
> > --- a/Documentation/ABI/testing/sysfs-driver-ufs
> > +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> > @@ -711,7 +711,7 @@ Description:      This file shows the thin provisio=
ning
> type. This is one of
> >
> >               The file is read only.
> >
> > -What:
> /sys/class/scsi_device/*/device/unit_descriptor/physical_memory_resourse_=
cou
> nt
> > +What:
> /sys/class/scsi_device/*/device/unit_descriptor/physical_memory_resource_=
cou
> nt
> >  Date:                February 2018
>=20
> As you are changing the name of a sysfs file that has been in the kernel =
for a very
> long time, what userspace code is now going to break that was using the o=
ld
> name?
AFAIK none.

Thanks,
Avri

>=20
> thanks,
>=20
> greg k-h
