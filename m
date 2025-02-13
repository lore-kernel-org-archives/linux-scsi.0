Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5421C28A2C1
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 21:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739482308; cv=fail; b=qa9+05pOOoaXgchwrEW1bbwUUQ6MHAH5cQyVZ1d6e/asAIyj1MTdhIV8enxf1/jrlJggLbr/3HFpFhMiNbSMABZ4OVjUoJG/o65qp5T73X0pqG6boc6m9Gp4/7mNdnbbz+3TV+sXznUy8hL55x3GeeWgg3XUbR72bwiIirfremU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739482308; c=relaxed/simple;
	bh=1ntvrtbatdzC0Rru2hPI+lVgmdGRp7h16SIEYarFYY0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rR4GxFwe+ArzzhPOsPCl1mhXOkjMz+qj4eKuO2qQDrNfE5ovYNnG3Vr+5ILj7FjdyAzgLJgrLSN6gb2SBaQW+ghoZOCZ6xJlJbjRZI2gZVYyOY4/WP3gy2sketHv5K3//zVrS+1io0/KUrAZFsZSBvcuzjFl1ngfAY0kqPqSHC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=WpOXlaG/; arc=fail smtp.client-ip=40.107.243.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="WpOXlaG/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l9FHjjSmlQ6GvruID1J16X2Bp6L04zKb5NId3z8014dTSREMLgA9m0qopmiMImM2IxU76C0G3CNk12N7Y0wwjo/dVA8tqTuDZEfbBuG5jZuzGV1qn0AR8V7l/ku4wiK0wF2nBHJtfC1D4gBio+4Aaoi/yk5S4vOtvbkizZ1WvO+oLODw2pyt0jyZgvDozy86V1zmwJ8+RZX/zgg3+o/mbjOdT99KX4xQp3muGJokJZa1yIdQ2VXMtrmbVDtV19OrJeQO6afgRSnAFSNB2rE32axAG/pK8ePKfeSbm2hGEqMXTyEm02q1A1vHXBt2kCV+KVTp3uo5Mq+qLO6tWeXn8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ntvrtbatdzC0Rru2hPI+lVgmdGRp7h16SIEYarFYY0=;
 b=voxhUOYDcnubsCH/klBzXDd/OKCUV9lmvULWT+yd7RoDkVSmKlLHMOwm3CocJmOFA3mmM6WAmTN/OlwRwHj1afqUpgKgNJQ0zkharMlBpKNYwxH4Rz0Z7yUAkSLTXiVvDK0+xvWFLxMdKvhK9qtESahW/NrRs+OkZnOTW0+HEp6ZBl03hvT0NkZsNvYN5/Y1ITH4uDJgUtYjYH5LCmKYwLTkFgbLzyi+XRUmSRddH6yhM5Tk74PBxvvKrEmgB4VC8ypw/ztFXA4xvLK6hkv+0fEPW0AVyP3pqPlG+C48SjI/FdSZrT+J7Vb6DOJwBhPB6DfW12oUql/p6+6SwQjc9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ntvrtbatdzC0Rru2hPI+lVgmdGRp7h16SIEYarFYY0=;
 b=WpOXlaG/ol+BJT7BzRn4xahYb5DAJgnHFQBju0M9mD8KpODMploBEYV3e6OQXE+x8YztyOXUMMV99aFA48yb+rcIwBnPXP52IiMHU3bzWCJx2wzPUWolExd5vb4uofpIlt09lVkNPjXqjXlifOYNqJqBKQzAr7vL1Spv63L2RoIkJHg+LFPE3w9xw8s8Yr+dTm+yAGghlFXcqW6MjPkAlx+EMlIDMs/unDBl68GvjpYcHyJM6bFIkyUTF7NzsaI+LhgSfzyBnnFRIB7SbaQ97yoWz6TcNcdCqJvWzpyqLHOBYCW2tJ+NSvFXsESzXAx1RPcPQ1nXh/crBvgc6F70jw==
Received: from PH7PR11MB7570.namprd11.prod.outlook.com (2603:10b6:510:27a::8)
 by BY1PR11MB8007.namprd11.prod.outlook.com (2603:10b6:a03:525::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Thu, 13 Feb
 2025 21:31:42 +0000
Received: from PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::f249:c679:94d9:9898]) by PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::f249:c679:94d9:9898%7]) with mapi id 15.20.8445.008; Thu, 13 Feb 2025
 21:31:42 +0000
From: <Sagar.Biradar@microchip.com>
To: <martin.petersen@oracle.com>, <james.bottomley@hansenpartnership.com>,
	<jmeneghi@redhat.com>
CC: <linux-scsi@vger.kernel.org>, <thenzl@redhat.com>, <mpatalan@redhat.com>,
	<Scott.Benesh@microchip.com>, <Don.Brace@microchip.com>,
	<Tom.White@microchip.com>, <Abhinav.Kuchibhotla@microchip.com>
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
Thread-Topic: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
Thread-Index: AQHbcz0tB0IW0OqxSE2ZE7WljSjIKbNEoY/mgAEygn2AAAHmBYAAALoH
Date: Thu, 13 Feb 2025 21:31:42 +0000
Message-ID:
 <PH7PR11MB75705918837682314E5555BCFAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
 <yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
 <PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
 <PH7PR11MB7570E9E65153C48BA7C5679EFAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
In-Reply-To:
 <PH7PR11MB7570E9E65153C48BA7C5679EFAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB7570:EE_|BY1PR11MB8007:EE_
x-ms-office365-filtering-correlation-id: da9b5dba-b71b-4df7-46a3-08dd4c75cee8
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB7570.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?3GNiy0y6uuCTCcwuz6Cv/ySLNGbQ0LsRkrxWlGp+BCOpYZrZ0fLaoc3oN2?=
 =?iso-8859-1?Q?RpAziiRIXbIK4mwzV38vR4L9St+JBpbuyM3NU2Rf8YO6glMu7ADd4UYPJ9?=
 =?iso-8859-1?Q?yMLyb4r1NSPg0rnutLxBgtfOVvRHq6+ymJC0HfJpMU7TfvSoWR7eESh0Pt?=
 =?iso-8859-1?Q?kEXYpUOPTjD05BgxkeYozLx0hLKg9x+zE7lU1SJtYo0NYpc5EYAQKG234t?=
 =?iso-8859-1?Q?hCGR9GvgXOo2gWNj+IaGoJDXihGbtLwGH0SHPQ66pvjc/K8JKeVTa/H0/I?=
 =?iso-8859-1?Q?hAosBpeydtXxu6xdpL9/a5qjT/HgtrBuyITKn5+GVUUipo4MDJ5l2zlg/G?=
 =?iso-8859-1?Q?RPSQRd8RFVO2/AbEJwBgd7asee6qhEPMUZEcSVIbdMlFWFAuUFLAymXXVf?=
 =?iso-8859-1?Q?Yn/RZ31cLjRAOM/u7cJ2UPFQehROJdm488AYMoOSzFZS6znh8fNZXYXW5o?=
 =?iso-8859-1?Q?kAiZpou2euB5YHQixo3Ub6WQuZ8BxgC+82cE5SMsE7UMrcnHyu8UKgEaOX?=
 =?iso-8859-1?Q?ExwjO/qpEhA7ZhJ7iA0aqN/4FFOdFJdoTaSmEbXq+dPKthPzfh4QyFP0Yq?=
 =?iso-8859-1?Q?/TVfUdFdfdx31btGFCTfMftpjxAc4CrgaBtrxfn971Y/toaKIBjm43M4/e?=
 =?iso-8859-1?Q?yRGCcUkQBaq0ItTOMsi2GTis7o+EihmRBMXSzyR2yDMfldh47A1RCd3NFB?=
 =?iso-8859-1?Q?ZvI/jeu7/nMCk5ok1d/mvjWsD5kyFvOhTx4gIrA5kcFOPZ4Fj/pZ3I+58c?=
 =?iso-8859-1?Q?e4fZx5Qmd38JfeXX9XjhWzv10BXZsutQsPEYjSxCQtNKZuNBeLXFl5dK6R?=
 =?iso-8859-1?Q?OrHPe3WJzpFOBmru4pzSGMMrsIVusuKV/NsjC6CL5OQbfT8ZLhvRhhWJr+?=
 =?iso-8859-1?Q?T3oFwlray/E64DXysH7nZ/cnDtHch9N2lRM5HSrQL/yNTOF8g4pmOot68R?=
 =?iso-8859-1?Q?4tXi1XKFmr/Qd8zP/0uFuzIEc3Rr1Sj+2w95nU9oussYGKo7uwgQr7p1XZ?=
 =?iso-8859-1?Q?nHE9h1dWO2wMOO7yWcjrBHDVK+vxlGR/2aIgcXOQkXhowvBMXugLwhYqrm?=
 =?iso-8859-1?Q?4UZ4hqqmOYjmSSy/9Lm0EEYBwE6Bku4PBOirmpX6tUvpFOBudnoIKoEwWj?=
 =?iso-8859-1?Q?eyOPG0WAJx7LYP8M2/AJQQuqa4ZbCAOtn+Okp/nc+lfyqSQNJnTwo7rOgt?=
 =?iso-8859-1?Q?cu66Vgomy+n1USJpBZEE7RcNdkZsHNCgfqOSmKvk6YT0o2yhCey4XiJtrp?=
 =?iso-8859-1?Q?mt+6iJ550GoQyN1Na1LBJFrkMc3m2R5yxtXvyXM7M7re3+RUftvKpz+8CB?=
 =?iso-8859-1?Q?tUPTV8MgPaAKIn4c8Eig9ll4VWNoxUV9/x+U3sPEPo582F74QNW1OFqQYB?=
 =?iso-8859-1?Q?3utMklic+ftGB280RgteLdPx097CKeGtGv8d+QVzWeM7getoh0RfIuwByn?=
 =?iso-8859-1?Q?wApcGda1hzU2ksvvvnoiPCT1vQAPcF9AD+SdMPJ7/8TQu0TAfryR4waSDT?=
 =?iso-8859-1?Q?AMaZ55rJIpMME70t4KCMCb?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Nx0dAuFN5dE5ZLN+hKNpZPGb73Tg2Bcg0S+QtGJy9W0D+B2U9oOg7EE2/A?=
 =?iso-8859-1?Q?gzHUBA8WpCNl2hCNL5nqtcWAezqk0+dUAWIHZpteP590GB/29JwQBAr1nf?=
 =?iso-8859-1?Q?cVemOeNFZ/U1bEx8CsF9uQ5fbZQ8TDPnzE2e7K8hwQo+djmJ3hCb015NKW?=
 =?iso-8859-1?Q?TlqKqlls/F5sLiSHcrvUfoZpH2dQdz2OKc050du5N7lrVIQSv6q+ZAVSij?=
 =?iso-8859-1?Q?1t8j9dxrwZBFDEPBB65zTmnxU6QDny2GwqKJ4zohOnMDRKvtk6eeF25J1T?=
 =?iso-8859-1?Q?qB74mu24UXu5ev5QLWEqdgwGjbGoy3bu6YfvG55uQONnwfBu2kCuShzzw1?=
 =?iso-8859-1?Q?TyapSARqgyEjbI8NTtJpzoeM+03BuoREnV7Xc/thY3Issht0mRbTSwin9T?=
 =?iso-8859-1?Q?OHR1YgaUYKbO7PzJbY3PTRDtm74W6Y26/pRd3bcrE529aV5+lzqwbiJxg2?=
 =?iso-8859-1?Q?rkMcVLpxmhYitDRrzpe4AqTu4uD58r3upPI2Q9pB3d3RwznMJc9mL3WMBX?=
 =?iso-8859-1?Q?lAwWkXDg0G7K/A/JCYA+Y5OlqtQVsNQIuSeZEbnzN2IkTN6dyEBzx2tJI5?=
 =?iso-8859-1?Q?z36YL9JqeJJZwhl3GulSkHrurLob2pDZ/+9+5goOwl1Uh5LdCi9srl5udG?=
 =?iso-8859-1?Q?M/mM7u9zPjsnlWy1B49oQf8G8sa2ckTflGAFWu41begBagm5ZcB4cfqpcx?=
 =?iso-8859-1?Q?RsdSvmP+wcbTSoZiMakhn34F6q/IHLi8n5Nijjumb3EiJBHemPGINqDAA2?=
 =?iso-8859-1?Q?QWB4Z0ISCCDX81DfYZiVSq3EYAAb1Dvc7C0OojpRUIzqDT0f/AzXR2UOLU?=
 =?iso-8859-1?Q?PCSvMNL9wKZyteLcHlPIJKBZRNINlu5xRGZsyi13bWlJAiR+fc1uQYj+2q?=
 =?iso-8859-1?Q?6OhATBLUaGR+CuBl4KZOlq8so8IDEvaKxAZTdYUaWyd+yH731YviSTSiXu?=
 =?iso-8859-1?Q?AgeBJNNFyi5xK9MtLHXtUGh4qb1Wbwm8qLKXgJayqQA7T+HFGFrwBeHSvM?=
 =?iso-8859-1?Q?xJEu2kUXJgthofHjdTYcQPRzjEq08VjrO818Z73mYixW76yHa9UJ+2JBCd?=
 =?iso-8859-1?Q?exm5m7OcXxGmq1J+9vbaIRePSjiZ+YfYpgGZfh+21eTR9flFq8xlL/kmKv?=
 =?iso-8859-1?Q?OGdHn7TIxoC2MIJf6aW8wQJjjmyDuIfZAqcJ0Jl+jT8Ig51+bn6eq3gSGw?=
 =?iso-8859-1?Q?+eU+IOorfJr/rxBT8KByu+tA8Q7Df8lxJ/F67BGi/uFzqdom1AgUJUiKiv?=
 =?iso-8859-1?Q?zkUBgRzySIJkd2AVFep115KIfpvcpoP6uA2XqnGmd2eO6DczUXD8IZhDX4?=
 =?iso-8859-1?Q?OVi01/sVpyhDpuoBQpwS+pad95VZ+9NzpQfH6uWpnFIf9GTzhRbn+s3Vb/?=
 =?iso-8859-1?Q?izLB6TW90yIhCiJhAAI+FEGZZmeLwytWQCV8xw2qTx9G04NJSuM7XJ/5bj?=
 =?iso-8859-1?Q?n7XJy+nCXRdCrCmD8pGLswbmTXHndS8JS6TxEao6TxK2gps1m4hWVQbQ93?=
 =?iso-8859-1?Q?St9axbjTIaMF/Y25ZXAz0VQWRhVHIehK6ZkXQUUQG7Idx8SAMQDrIK9quJ?=
 =?iso-8859-1?Q?5borWCsCdWoHWiitU9D4jvbHgOfR0bQTvn4mrJIZcVRD1tcTTTV6/knSEF?=
 =?iso-8859-1?Q?y4HU2Ie+gsN0it/kKs2SHqp+MeENpOlwAW?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB7570.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da9b5dba-b71b-4df7-46a3-08dd4c75cee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2025 21:31:42.2036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yuktpcz4O2L3mpdt9Ti0mTYH+gtBuT5B8tKrfTENEI+z88TMkrevQgBqeR9cZZyXhU0burMjItiVBmDAsuTZuqY02MjYil7GGnx0XebnbDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8007

=0A=
=0A=
Sending it again as outlook threw some delivery errors.=0A=
Response inline :=0A=
________________________________________=0A=
From:=A0Martin K. Petersen=0A=
Sent:=A0Wednesday, February 12, 2025 6:56 PM=0A=
To:=A0Sagar Biradar - C34249=0A=
Cc:=A0linux-scsi@vger.kernel.org; Tomas Henzl; Marco Patalano; Scott Benesh=
 - C33703; Don Brace - C33706; Tom White - C33503; Abhinav Kuchibhotla - C7=
0322=0A=
Subject:=A0Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IR=
Q affinity=0A=
=0A=
=0A=
[You don't often get email from "martin.petersen@oracle.comjames.bottomley@=
hansenpartnership.comjmeneghi"@redhat.com. Learn why this is important at h=
ttps://aka.ms/LearnAboutSenderIdentification=A0]=0A=
=0A=
=0A=
=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
=0A=
=0A=
Hi Sagar!=0A=
=0A=
=0A=
=0A=
> Add a new modparam "aac_cpu_offline_feature" to control CPU offlining.=0A=
=0A=
> By default, it's disabled (0), but can be enabled during driver load=0A=
=0A=
> with:=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 insmod ./aacraid.ko aac_cpu_offline_feature=3D1=0A=
=0A=
=0A=
=0A=
We are very hesitant when it comes to adding new module parameters. And=0A=
=0A=
why wouldn't you want offlining to just work? Is the performance penalty=0A=
=0A=
really substantial enough that we have to introduce an explicit "don't=0A=
=0A=
be broken" option?=0A=
=0A=
Hi Martin,=0A=
Thank you for your time to review and giving your valuable opinion.=0A=
There are two reasons why I chose the modparam way=0A=
1) As you rightly guessed - the performance penalty is high when it comes t=
o few RAID level configurations - which is not desired=0A=
2) Not a lot of people would use CPU offlining feature as part of their reg=
ular usage. This is mostly for admin purposes.=0A=
=0A=
These two reasons made me opt for the modparam.=0A=
We and our folks at RedHat did venture into trying few other options - but =
this seemed like a nice fit.=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
--=0A=
=0A=
Martin K. Petersen=A0=A0=A0=A0=A0 Oracle Linux Engineering=0A=
=0A=
=0A=
=0A=
