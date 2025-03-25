Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFB91953AD
	for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2025 22:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742941347; cv=fail; b=OyS/Wjwxj2Tjof0EOlIH4BBOolkHxjqBVtMGq6dpno9LMIRAs7XIK7NXnvdoozREEYSlBIs9MwsX+3pJihQ6JtggQrfgbGda4jKuemAjyrMojFs3Hawt4JcU71bOa0GxIyM0P1d7uWYOai/QJHsFzfKcBAnJrFOxLuwUq/BhhYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742941347; c=relaxed/simple;
	bh=7p0/q7Lz+efg6U4vMPRs+iCzZsfDZeGXLEHzBHaa9u4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=plxtZHuXWZITwzQ2MX2cLVWpM/+ZdUwm1aNfagp48TpTH6GZMZ+iTWxPbxzxeIBlvEWNBfDiGQgoU8lmKIqLs74LRf2F6yWtQsZ23RPN2Q16PgRrkq+aryg4ONRkCToCpU3gWvfA5juTEL2AnRT9Y90gXaPHJsqv9voTkQpuNxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=md6k8ano; arc=fail smtp.client-ip=40.107.92.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="md6k8ano"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NNJ1KLTEobC+lU8VQ3pt33/ul478tnKBeOOk9L90p67ETJ6qg9uzjUlMtoIgwXy65lQIcMeIiwiTHtgUMi/+s6qIyw80fFS5dJ7+xG7blBRGJsfpqwcydLzXEtYvDk5R8iPsPi2QdIBjuNdxzMPphk3fo40iImWiP/IL9zqlDMiBe7GDRJLbZWz7EL4hAscitaJ/uWzZ8aPo66axfYzuoPLOKXVZY/6dnXN5yCKQP0mP4+jlEJj8id08QetRZ6nuHS1KPlp4Qam2VRjEyywCv+pmQPn8sRCNwjeUxqA+/V3BCfktkOHAtY9GkqMQ0TyMw370if3y3SDsFegDRbqrKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7p0/q7Lz+efg6U4vMPRs+iCzZsfDZeGXLEHzBHaa9u4=;
 b=B0jOV+cRmCp8bYp64Oc+h4XIbZYHzKNQgr8Nr9Nk1WHIuA89FJt/vQ1R4uQ069B+zjZpUqXEro2LMEMhXHlHHzXBGswrHDmhcBVOrwct4nEFIoJ4WLg4AC9dp6kf6cocWY6feOmeeqvK/s+gpDkysRCu89ZnGtJV4O4PNrAQ59rcBJpUKDO7Q5ocwjIle4l5ZXkAkkdVJi21hEXRiH58lBrF4Pph+tU3mhSxvDuoBqk2hcc3ZBr6eyH8/Zc9ehlx3Znwuqyrw617/xf3ecgy4prqFF8HlaXV2Cs/y846i2QskujIregSusthgz679SmH8h8refm+ROrj6tlD9AJtzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7p0/q7Lz+efg6U4vMPRs+iCzZsfDZeGXLEHzBHaa9u4=;
 b=md6k8anomRONg8Z4CYxICi0B1B6qYTLeLeIpJc5XsccXjZQGcDgXZUfSp141PaMnE5u23Nx0o4TQcGcq2aDrd50HOuU6ROMkbuldYTNF4rP6PWQGRvlVXh15xI/HZzQ0WnqXeNhyZSK/Z8pqbTaBDq6P+drlxnyGTJEaGaPlzPuRfe2vfjNRb5lvUnbwt9uv7E022go0pX7n1yOYp1wak3bqW+z/WlzomCsauf1F87b8KAGjHqg2tvJNc7dMYicljpr25haAe0p6GPmmg3J/79G5SxQqiTKr/JHuZ3uziyN4uPeG6IyJ6iaP7d0MojRnN2PRWDfFwXBd0fEVwCltEQ==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by CH3PR11MB7763.namprd11.prod.outlook.com (2603:10b6:610:145::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.43; Tue, 25 Mar
 2025 22:22:19 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::4db1:768a:9a46:3628]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::4db1:768a:9a46:3628%7]) with mapi id 15.20.8534.040; Tue, 25 Mar 2025
 22:22:19 +0000
From: <Don.Brace@microchip.com>
To: <martin.wilck@suse.com>, <martin.petersen@oracle.com>,
	<jejb@linux.vnet.ibm.com>
CC: <storagedev@microchip.com>, <linux-scsi@vger.kernel.org>, <hch@lst.de>,
	<mwilck@suse.com>, <con.brace@microchip.com>, <rwright@hpe.com>
Subject: Re: [PATCH] scsi: smartpqi: use is_kdump_kernel() to check for kdump
Thread-Topic: [PATCH] scsi: smartpqi: use is_kdump_kernel() to check for kdump
Thread-Index: AQHbmrFJOjABv2c3LkqThvc3FTaVFLOEUYYogAAhCfg=
Date: Tue, 25 Mar 2025 22:22:19 +0000
Message-ID:
 <SJ2PR11MB8369DE36B46686DAE2F68068E1A72@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20250321223319.109250-1-mwilck@suse.com>
 <SJ2PR11MB8369D63E81F34CEC0438BB37E1A72@SJ2PR11MB8369.namprd11.prod.outlook.com>
In-Reply-To:
 <SJ2PR11MB8369D63E81F34CEC0438BB37E1A72@SJ2PR11MB8369.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|CH3PR11MB7763:EE_
x-ms-office365-filtering-correlation-id: 3d2c81c7-29fa-474a-372a-08dd6beb81a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?6upBUIV26SZinGmy54zOd174pUT/96c0lsB/qXul/10L5uu5w3LgvARIbF?=
 =?iso-8859-1?Q?GvE0RhXCggdjBGvXabbNcE27eGRV4DbDLgPStD0lmsUi21G5Dme1Xz319K?=
 =?iso-8859-1?Q?iujS6ZX/G2P1GtMC7SZFaHFgxEuESZOBDj9BDVd0ad3YCnwFrfOdkXbULB?=
 =?iso-8859-1?Q?8hdHa6zAkiuKwc10xS8ncSdJmAfJbEVyHqmTePkkHtDGUNvy7wttvAMrkq?=
 =?iso-8859-1?Q?Xx7Dw5/zIr5+lXe/1qSPBARv8ttKoJd3RDD3OKRnmoG77bdoZCkqPd5RUb?=
 =?iso-8859-1?Q?n8kU3qAMiLqJpGC7+WAELurzuIebe978IcsI151BWowLCVn0RkAHv1s71n?=
 =?iso-8859-1?Q?RuMLhEBMpcEk1toIgXifySXF1faAq832Rnn8XwSEgrRcDrmZXMIGDHyM+K?=
 =?iso-8859-1?Q?PYHMKkOnDiNj+huYfFpFfK/O0ble5eiU6YORC+r+VJhEIazSEAeevrBo3E?=
 =?iso-8859-1?Q?dx8jEZVNu2/1XFovAwtksxxvIqtjLegjD3kk4Sg/pDd4UODb4ghDJw0BN5?=
 =?iso-8859-1?Q?gbZ0QYiMVvLThy849EdAuNQey5XD2LkH5awlMg90ldwuM1BC4VPGADUj4L?=
 =?iso-8859-1?Q?Ces+ydQl1/hTKDePI1aZo/IN3jNl5+ai77mvSYSq5x+0zhyae9ogDNeY05?=
 =?iso-8859-1?Q?FyMxaZ8Ka9eOJYqSfSP6S2FKGFUVxJaYMpkJ4ibww9Kwc1pl0VWsz+Dqk8?=
 =?iso-8859-1?Q?gC8+0Lm+OP9ebipbmu1tZuCdCmKncSrHSdx4B0Qajmk3jwIZgJJnN+n1J/?=
 =?iso-8859-1?Q?7Yxfj8lmef+UV63YxVI4BmhMs3qReZdeHozv75Nvc7HWFQzrluaywqc7Pu?=
 =?iso-8859-1?Q?C9uqBNUcioUcz6bxmtTQohC1iFJuAv2iSW/ltqTA3PNTH0PTJ6klq214JX?=
 =?iso-8859-1?Q?nG7Ler9UULsg0Q4fNQodbvsbdBtZPeRWFGQTqpruOaIVVL6Ep2Eh9V2nld?=
 =?iso-8859-1?Q?ApetFXxzi11WMWcjOVaZG5kSEYYAl077DOzLdVjqdOa9f81Tf87aas8Q07?=
 =?iso-8859-1?Q?KSNjVXblFxwargn27JQ9X86/LT4vx1/VrYGYmsc/QFV4BZS2LC0Oz+hzZK?=
 =?iso-8859-1?Q?vzdRfotUzMUBSLGqReL6osQ6+s+ux0gSlYxOhPrciabfzhXxrODSULLO36?=
 =?iso-8859-1?Q?l5mLlGFphrO7pnr1PbG7i1Z5FVKddYLA7RLFbi3kEO2C+rLagKXZLTia87?=
 =?iso-8859-1?Q?hTX75+rUp45rUNsllqvLRwSeLnTDhFsc+Oz2Y6lJY+xc5O9h+LLse6jQ0G?=
 =?iso-8859-1?Q?jF4yIyqi/R28ZcXOEmFvyRrUdvGXWgrpFPPEO5BhUtOPBrJAQiYEkvP5zd?=
 =?iso-8859-1?Q?jlBPTy1fI18kAs/Qv0W5BUuNfTHv4rAAyWhMh9j5WF3OLrRmpFrYP8hr/E?=
 =?iso-8859-1?Q?hV6riu5mHvIOmPUDn8toRoeAKAQ3/CJFYcXisqwPZxegs/ufeykjP1PMAl?=
 =?iso-8859-1?Q?rMFdNaqBBogi+B3x/TtaWOu+asv/DLCZpZVrpmjNhfSbaNzM9t5rJwoBiU?=
 =?iso-8859-1?Q?jjaXPpbLjxchv9LPMgTgdw?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?4V/pduKWonIlrwV0p6JWnl/uuTtP7ONQ/zkLLJsapsUt90BMhs/Ftj11Rl?=
 =?iso-8859-1?Q?3Eg/lZ3R4XPSJggXdFVxbUGRB4+YDz21mAUBuwlIl0gsYvwli1Fq3luisg?=
 =?iso-8859-1?Q?yoEaw9UbZp6J5TGeh6fLOm8ydWYr7GGhjaM9EMz1lkthIn62ZDM2G2Uo9v?=
 =?iso-8859-1?Q?ynpjOY/h+PN0gG03WBPcRR+yLTjnDeme/YmvWaziVLeI95xAuKgHHwZ4qe?=
 =?iso-8859-1?Q?cduV1398MsHoQeh39QYhwK23+K3U8DSd/atxvG1m4Dky/wC6sp262a+XTR?=
 =?iso-8859-1?Q?JPYVsgR5tTzr8Nv6D8daatp0cIvi67aEhVE9BQU9pnRc2cISCOSc4hOthZ?=
 =?iso-8859-1?Q?Hwtw11QZCbq/V9YKeMrKv68X2qJ/q87mB0ubcR4z9l4paAbJEWAUEzW9bM?=
 =?iso-8859-1?Q?NKKreHe7igmBicXcXjmjp4lGsgv/mLw4VP925aeFVHRzxSsHEmBLu5SBG0?=
 =?iso-8859-1?Q?svARygCqVgbcckwxpqkSKTK+4u/DKW4s+XOOlzmpWbiUPnseoVCP4GlXI5?=
 =?iso-8859-1?Q?PP5x3jFClFwBDlg2TbMavLKDEu8vH/J3ybFq4SRfNOkI1nos1QjhcrOOZD?=
 =?iso-8859-1?Q?WmMkm2dd4GuoJnoRmLBh+egggq6r2MVd367ag1f4WDtrLyyF0u2JQnE+hV?=
 =?iso-8859-1?Q?2xmHdA5MlX2wJhTj9+LYlIy1AW9N+ryz6zAd5/JqT+Tk1ig9DFEKgp4grP?=
 =?iso-8859-1?Q?APKaHX+4JkaCOSgDc7bHiXqkWRI2EhX6s5n2FTWKr/+3sNlkXY1YUsLlU1?=
 =?iso-8859-1?Q?tONOoAkZmpK7na41H22TVw39Dc5hzNQJKrdMukovNDyIRl1+A9vRlg2AWn?=
 =?iso-8859-1?Q?cPb8LS6MCADr5DfqF0RZxUQlZuQC9f9NzOUxZCjvh+jbCRP8Sh/jXjUsgh?=
 =?iso-8859-1?Q?FN1NkPngL88IYhqGLGsMl5dgZnMrqZwj/5AcCf6GkT8fv/QCyA8e0uAj5I?=
 =?iso-8859-1?Q?mMN8nbsttVGIZkHLyLNQ+Sw9oL8nMTez2plwPYh6INSbeBcImoDqI/oBK7?=
 =?iso-8859-1?Q?7JkB4OYgL6yK5TDQE/FEud9SKxTFDxvl9Aq9WxGkfB5yUPFX7zUPvpkbZF?=
 =?iso-8859-1?Q?55mJKvdEGkyPEQ1QEX022GHtDg68oe2Majjizkzf3x307sg8KKX+O7OT1h?=
 =?iso-8859-1?Q?Zwm6TqcsxZxaey+VueAux1reh1TP3IXuJs5sFJInAfylM2E0UmDfJliiKr?=
 =?iso-8859-1?Q?okWShdPvKonLc1Q5VIkAeFJcwKQMFasKoQ8ZLBflrwe9Tfze/uIYxTawDB?=
 =?iso-8859-1?Q?HOQolTDaTtDrG3+b9Z4IOzDfyH6WduISrOVQurErPczjj0zoF1UFqhBVn3?=
 =?iso-8859-1?Q?7Wzy7Ks/423j9G+Od6xkvgu6TNea+WgiXMxyRcyhfbyyxhIABIaiU+rJXH?=
 =?iso-8859-1?Q?df7/i0zDWcxsSp/ci/cU+kVqaLCb6lfr3LKNe0FJxIlIIQYyvr3Rv2HM9L?=
 =?iso-8859-1?Q?ndRFn1VsHrJHZslv0ydgOUIP8SPLu9ip9gfV6MNVWod0dPbVz39EEP4tde?=
 =?iso-8859-1?Q?ZNLdie1NftbyP1CFVpjaoLzO2HeiKJ2yl1W1QnhFABxxSIGpcm7Y3fW0p6?=
 =?iso-8859-1?Q?cYswaF8FUtJvfnllj9YcsZCSPFlWUz/B5gfiKc+RiYJwZrKLpNFByb98V4?=
 =?iso-8859-1?Q?zdbQrldPtwJiMH9fnMcCwCoaHlm9CsdM3E?=
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
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8369.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d2c81c7-29fa-474a-372a-08dd6beb81a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2025 22:22:19.2424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vSYFvWxoe+zgSpm7c8MeBTWg0WzTpTWlTktM79wg/xSG25aOMMxlyyHsHTPPJMQ5FYHeCIhSSN0uEfTHnBpi2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7763

________________________________________=0A=
From:=A0Don Brace - C33706 <Don.Brace@microchip.com>=0A=
Sent:=A0Tuesday, March 25, 2025 3:24 PM=0A=
To:=A0Martin Wilck <martin.wilck@suse.com>; Martin K. Petersen <martin.pete=
rsen@oracle.com>; James Bottomley <jejb@linux.vnet.ibm.com>=0A=
Cc:=A0storagedev <storagedev@microchip.com>; linux-scsi@vger.kernel.org <li=
nux-scsi@vger.kernel.org>; Christoph Hellwig <hch@lst.de>; Martin Wilck <mw=
ilck@suse.com>; Don Brace <con.brace@microchip.com>; Randy Wright <rwright@=
hpe.com>=0A=
Subject:=A0Re: [PATCH] scsi: smartpqi: use is_kdump_kernel() to check for k=
dump=0A=
=A0=0A=
Sorry about duplicate e-mail, had some embedded HTML in my last reply. =0A=
=0A=
With Mike McGowen's permission...=0A=
Acked-by: Mike McGowen <mike.mcgowen@microchip.com>=0A=
=0A=
=0A=
=0A=
________________________________________=0A=
From:=A0Martin Wilck <martin.wilck@suse.com>=0A=
Sent:=A0Friday, March 21, 2025 5:33 PM=0A=
To:=A0Martin K. Petersen <martin.petersen@oracle.com>; Don Brace - C33706 <=
Don.Brace@microchip.com>; James Bottomley <jejb@linux.vnet.ibm.com>=0A=
Cc:=A0storagedev <storagedev@microchip.com>; linux-scsi@vger.kernel.org <li=
nux-scsi@vger.kernel.org>; Christoph Hellwig <hch@lst.de>; Martin Wilck <mw=
ilck@suse.com>; Don Brace <con.brace@microchip.com>; Randy Wright <rwright@=
hpe.com>=0A=
Subject:=A0[PATCH] scsi: smartpqi: use is_kdump_kernel() to check for kdump=
=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
The smartpqi driver checks the reset_devices variable to determine whether=
=0A=
special adjustments need to be made for kdump. This has the effect that=0A=
after a regular kexec reboot, some driver parameters such as=0A=
max_transfer_size are much lower than usual. More importantly, kexec reboot=
=0A=
tests have revealed memory corruption caused by the driver log being=0A=
written to system memory after a kexec.=0A=
=0A=
Fix this by testing is_kdump_kernel() rather than reset_devices where=0A=
appropriate.=0A=
=0A=
Fixes: 058311b72f54 ("scsi: smartpqi: Add fw log to kdump")=0A=
Signed-off-by: Martin Wilck <mwilck@suse.com>=0A=
Acked-by: Don Brace <don.brace@microchip.com>=0A=
Tested-by: Don Brace <con.brace@microchip.com>=0A=
Cc: Randy Wright <rwright@hpe.com>=0A=
=0A=
With Mike McGowen's permission...=0A=
Acked-by: Mike McGowen <mike.mcgowen@microchip.com>=0A=
=0A=
=0A=
=0A=
________________________________________=0A=
From:=A0Martin Wilck <martin.wilck@suse.com>=0A=
Sent:=A0Friday, March 21, 2025 5:33 PM=0A=
To:=A0Martin K. Petersen <martin.petersen@oracle.com>; Don Brace - C33706 <=
Don.Brace@microchip.com>; James Bottomley <jejb@linux.vnet.ibm.com>=0A=
Cc:=A0storagedev <storagedev@microchip.com>; linux-scsi@vger.kernel.org <li=
nux-scsi@vger.kernel.org>; Christoph Hellwig <hch@lst.de>; Martin Wilck <mw=
ilck@suse.com>; Don Brace <con.brace@microchip.com>; Randy Wright <rwright@=
hpe.com>=0A=
Subject:=A0[PATCH] scsi: smartpqi: use is_kdump_kernel() to check for kdump=
=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
The smartpqi driver checks the reset_devices variable to determine whether=
=0A=
special adjustments need to be made for kdump. This has the effect that=0A=
after a regular kexec reboot, some driver parameters such as=0A=
max_transfer_size are much lower than usual. More importantly, kexec reboot=
=0A=
tests have revealed memory corruption caused by the driver log being=0A=
written to system memory after a kexec.=0A=
=0A=
Fix this by testing is_kdump_kernel() rather than reset_devices where=0A=
appropriate.=0A=
=0A=
Fixes: 058311b72f54 ("scsi: smartpqi: Add fw log to kdump")=0A=
Signed-off-by: Martin Wilck <mwilck@suse.com>=0A=
Acked-by: Don Brace <don.brace@microchip.com>=0A=
Tested-by: Don Brace <con.brace@microchip.com>=0A=
Cc: Randy Wright <rwright@hpe.com>=0A=
---=0A=
=A0drivers/scsi/smartpqi/smartpqi_init.c | 13 +++++++------=0A=
=A01 file changed, 7 insertions(+), 6 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c=0A=
index 0da7be40c925..e790b5d4e3c7 100644=0A=
--- a/drivers/scsi/smartpqi/smartpqi_init.c=0A=
+++ b/drivers/scsi/smartpqi/smartpqi_init.c=0A=
@@ -19,6 +19,7 @@=0A=
=A0#include <linux/bcd.h>=0A=
=A0#include <linux/reboot.h>=0A=
=A0#include <linux/cciss_ioctl.h>=0A=
+#include <linux/crash_dump.h>=0A=
=A0#include <scsi/scsi_host.h>=0A=
=A0#include <scsi/scsi_cmnd.h>=0A=
=A0#include <scsi/scsi_device.h>=0A=
@@ -5246,7 +5247,7 @@ static void pqi_calculate_io_resources(struct pqi_ctr=
l_info *ctrl_info)=0A=
=A0=A0=A0=A0=A0=A0=A0 ctrl_info->error_buffer_length =3D=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ctrl_info->max_io_slots * PQI=
_ERROR_BUFFER_ELEMENT_LENGTH;=0A=
=0A=
-=A0=A0=A0=A0=A0=A0 if (reset_devices)=0A=
+=A0=A0=A0=A0=A0=A0 if (is_kdump_kernel())=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 max_transfer_size =3D min(ctr=
l_info->max_transfer_size,=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PQI_M=
AX_TRANSFER_SIZE_KDUMP);=0A=
=A0=A0=A0=A0=A0=A0=A0 else=0A=
@@ -5275,7 +5276,7 @@ static void pqi_calculate_queue_resources(struct pqi_=
ctrl_info *ctrl_info)=0A=
=A0=A0=A0=A0=A0=A0=A0 u16 num_elements_per_iq;=0A=
=A0=A0=A0=A0=A0=A0=A0 u16 num_elements_per_oq;=0A=
=0A=
-=A0=A0=A0=A0=A0=A0 if (reset_devices) {=0A=
+=A0=A0=A0=A0=A0=A0 if (is_kdump_kernel()) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 num_queue_groups =3D 1;=0A=
=A0=A0=A0=A0=A0=A0=A0 } else {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int num_cpus;=0A=
@@ -8288,12 +8289,12 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl=
_info)=0A=
=A0=A0=A0=A0=A0=A0=A0 u32 product_id;=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 if (reset_devices) {=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (pqi_is_fw_triage_supported(=
ctrl_info)) {=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (is_kdump_kernel() && pqi_is=
_fw_triage_supported(ctrl_info)) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =
=3D sis_wait_for_fw_triage_completion(ctrl_info);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (r=
c)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 return rc;=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (sis_is_ctrl_logging_support=
ed(ctrl_info)) {=0A=
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (is_kdump_kernel() && sis_is=
_ctrl_logging_supported(ctrl_info)) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sis_n=
otify_kdump(ctrl_info);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =
=3D sis_wait_for_ctrl_logging_completion(ctrl_info);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (r=
c)=0A=
@@ -8344,7 +8345,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_i=
nfo)=0A=
=A0=A0=A0=A0=A0=A0=A0 ctrl_info->product_id =3D (u8)product_id;=0A=
=A0=A0=A0=A0=A0=A0=A0 ctrl_info->product_revision =3D (u8)(product_id >> 8)=
;=0A=
=0A=
-=A0=A0=A0=A0=A0=A0 if (reset_devices) {=0A=
+=A0=A0=A0=A0=A0=A0 if (is_kdump_kernel()) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ctrl_info->max_outstandin=
g_requests >=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PQI_M=
AX_OUTSTANDING_REQUESTS_KDUMP)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 ctrl_info->max_outstanding_requests =3D=0A=
@@ -8480,7 +8481,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_i=
nfo)=0A=
=A0=A0=A0=A0=A0=A0=A0 if (rc)=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return rc;=0A=
=0A=
-=A0=A0=A0=A0=A0=A0 if (ctrl_info->ctrl_logging_supported && !reset_devices=
) {=0A=
+=A0=A0=A0=A0=A0=A0 if (ctrl_info->ctrl_logging_supported && !is_kdump_kern=
el()) {=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pqi_host_setup_buffer(ctrl_in=
fo, &ctrl_info->ctrl_log_memory, PQI_CTRL_LOG_TOTAL_SIZE, PQI_CTRL_LOG_MIN_=
SIZE);=0A=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pqi_host_memory_update(ctrl_i=
nfo, &ctrl_info->ctrl_log_memory, PQI_VENDOR_GENERAL_CTRL_LOG_MEMORY_UPDATE=
);=0A=
=A0=A0=A0=A0=A0=A0=A0 }=0A=
--=0A=
2.49.0=0A=
