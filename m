Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2067.outbound.protection.outlook.com [40.107.101.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A203B12E7E
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 22:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738275728; cv=fail; b=V+4mf24szwqTqqAyl1R2DEIvGrOoV0i4S3Lag7j0PQQLbcB/vJjhNVXDpk6aC6oFD3WHa/L1symbLlED7oc4+SRjQbaiwYhMkRTuULRzW0fqn2WNpN3pGSNYWE42dQuuVnPqwBdkStY9xV+Hyw55oPvAVFrERdmMX02nZ5hAd7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738275728; c=relaxed/simple;
	bh=NSK/XmhY4vQaRAVEl5Dx8MDMCM6PlgIfKwylO/m4dpc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hPe1lHVkKUr6KFOCKfPjhFPCfP4IcK3iVqj/lhb7gJQWmWdjTzs848itxEkUlh+AaCaIMn9PnsWIiT381hhxc4/jRwYPcNg3IvVd0ORbrXU5TkH0KUi7kVCh2U5LqqOS1QMiCF0/DSJT4Od5Ps9R7dc/0d8vJgelaNjzxnv+FEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=ET5S15BJ; arc=fail smtp.client-ip=40.107.101.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="ET5S15BJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fA4GZNFWLkDC0Z7J5iYj44YHxDVmI+Zd5ynVVlLJXFCQJRhjtYAg4Yq0Tn8hFehhhFYmXZQBZW9ZwqpAPt3EZ1nO8FlrnBQvdbl2EgpZ2PPbrWyqJrI5usKeRuwXMSkII6z5YLe3SN7oZiaUrUd4Tt7+clQSRBKH08K/Pksp2BQrVa+Jx4rfXACwGzkD2Ue29IvyIyQubuTm1A6X2TzeeLvWu0pGZrOzy2eVOaKS2jklN8gUVW9vGl+9IDwwLDGkKuedg7mSFBisCQcj5QQJSohKq/iiHgJF7pJBG5huxeS+1pHhqUbfHmNXtlOrMaCSXbexCmBLW/O/B5Vsd8W8IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSK/XmhY4vQaRAVEl5Dx8MDMCM6PlgIfKwylO/m4dpc=;
 b=GvGjct8p2ATNBXHaZkCvazYGMKtLwiW1krY5imJiO/9x4xIu9jumjtw2/h31Z/VRR/y/HgT4tG+vAwaIalnghjdKf/7AxYNz9i2vjx+afvy43iyGvK8Oa66xOvjFWB2798bRg9OHZzJjnqeGUXEeH9vf8kbygWYOLJaHzMI5H2Y328jm01nyxP7NVrXgDw7V5ale9osNiF3bviEoxW+YQ4rqd8WXC4/hd/PIwpr7cjOGxXw1jqlJO4a1A5Mn44Vw7duAD4Ne7+/roxWFU+LuigAWVkmQnBgBlYa6SLij/UBzCB9e14EKwCrUsH7jhujdIvvZK8UD6hrlP7FERbWaQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSK/XmhY4vQaRAVEl5Dx8MDMCM6PlgIfKwylO/m4dpc=;
 b=ET5S15BJVRxaWuU2m55yUPBlHbWVcTkwnTdahJ+6adllqI1wB/LHjDnb/fHKDLmZShi7H+cxsZVZS6eZDNX+FR3t2SUiBxM5BU/pLJfPnF4MZClkBFavVltBZCaR8Q6lBcc5IOQdRl8hTLJS6vxktWMGezhGmFWD3ipIQgfnosR82bJoTdacOiDgrpfGOOg2sKJYujyXsxCeR9kXpfwlQkqb/rZmK23DglQ1EaJW/XsOAGijcubBaGwcqE42BaiPj2m66zLGtpfMS83JsxXTH5z3zeZsdU/V2ncRXPKxvqqL8wfkCIvJ5XTx9TyGbeqGThwJyNFgEbbifzZpdb7fJQ==
Received: from PH7PR11MB7570.namprd11.prod.outlook.com (2603:10b6:510:27a::8)
 by PH7PR11MB8526.namprd11.prod.outlook.com (2603:10b6:510:30a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.17; Thu, 30 Jan
 2025 22:22:03 +0000
Received: from PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::f249:c679:94d9:9898]) by PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::f249:c679:94d9:9898%7]) with mapi id 15.20.8398.017; Thu, 30 Jan 2025
 22:22:03 +0000
From: <Sagar.Biradar@microchip.com>
To: <jmeneghi@redhat.com>, <jejb@linux.vnet.ibm.com>,
	<linux-scsi@vger.kernel.org>
CC: <thenzl@redhat.com>, <mpatalan@redhat.com>, <Scott.Benesh@microchip.com>,
	<Don.Brace@microchip.com>, <Tom.White@microchip.com>,
	<Abhinav.Kuchibhotla@microchip.com>
Subject: Re: [PATCH] aacraid: Fix reply queue mapping to CPUs based on IRQ
 affinity
Thread-Topic: [PATCH] aacraid: Fix reply queue mapping to CPUs based on IRQ
 affinity
Thread-Index: AQHbcQMKpgCjOokuCU2o8D6HU8kV77MuC6EAgAHclds=
Date: Thu, 30 Jan 2025 22:22:03 +0000
Message-ID:
 <PH7PR11MB75707A6A080C259012803F79FAE92@PH7PR11MB7570.namprd11.prod.outlook.com>
References: <20250127213223.318751-1-sagar.biradar@microchip.com>
 <1c2b135a-cb9c-4107-a198-7544d2433d5b@redhat.com>
In-Reply-To: <1c2b135a-cb9c-4107-a198-7544d2433d5b@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB7570:EE_|PH7PR11MB8526:EE_
x-ms-office365-filtering-correlation-id: e21e98db-caea-4a41-86da-08dd417c85bc
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB7570.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700018|7053199007;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?kWn2jen6gz/LFLTK3qVsyUt3ZAQGjL+SkzEo0FzgXgV5zTbezcpp8B6ZPy?=
 =?iso-8859-1?Q?65mLDAdgmyOcwOmcgXjmX0lladTqkdGX1Rqd60l2994gYrJ/ffSHLp9yNt?=
 =?iso-8859-1?Q?gSUB+qh29iw2AsyIOn/eBq9nQSignGSBiDxVcFjF0jAlr7oww4kniXLm42?=
 =?iso-8859-1?Q?HsPUzv5UWEeqypRxzV0VCn6xP0Fll0aua0FwiPOj06dN7hP06HBuD4LFdd?=
 =?iso-8859-1?Q?25MhzBx0iXlJZQE/Cw5q611xEa3g3yeAyLvA0xCYNtgqVjv6n+j/bpplcB?=
 =?iso-8859-1?Q?Oy3fceTFEUEnyUwisuHWYPHO7kJahEJzN84KwvCeIT0BXmtp1HwIKWc+mQ?=
 =?iso-8859-1?Q?u65pLcAtyQVC0tk6TzaZdABxc3Uq4d4ogkSZ+x2Re/1qGEeVYR2F/GDPKZ?=
 =?iso-8859-1?Q?FvzlyzILeJj60eDk9Z8or56gM2IpYkDmDSFUiAjokDPEgpGx2bbj7zngZe?=
 =?iso-8859-1?Q?zY5gx7FJQTwzk/dVAJcENJXE+ViEkxq4Om7dPXUZMc2i7bmLxrN4+Q4zZm?=
 =?iso-8859-1?Q?nSrp8Y3Unj3S5fD8VnpV3Q1j6spTjuKtkG/1seuDz9daJOxahr5HKJpvb2?=
 =?iso-8859-1?Q?Hst3WhD/aWLyZQDnvB9GDXtXh9aQY+qu6W/n12MO6p4RPfqDfSq2EGZddd?=
 =?iso-8859-1?Q?2JdpLr/41SZrEWc1EHGCPJQw40Wqm9haQYtiMSiDd65PWPN2KMYLCFZNxq?=
 =?iso-8859-1?Q?PD0K1g9xdc7QGuHnuUwNCUTVtZCaLFnBG1AGlX2nDNgoMyGEzCcd6sgr0W?=
 =?iso-8859-1?Q?Cmv6aJQIk4egtndSH+qyCHfax4IDRIbnQ8jYrZwlS0mtLs30KRk0hhEHna?=
 =?iso-8859-1?Q?AysUa5v2/o8rDCwllk1ViO9oBfBHai3FP/v/PGOhz/FGvgCql60hPWnePO?=
 =?iso-8859-1?Q?GaEarb6zTsWRuZMmG7B70Se+WUPPUsHc1/dvDp1YUXePp7FqgH4VfewIgQ?=
 =?iso-8859-1?Q?JRt76IMmhq7cQQa21J87uW4n1ymbSxxFmu3K37bNmZfo0cMfTbO4aIdgeG?=
 =?iso-8859-1?Q?rj2sOcGQqrh0uXETSV+l4sDKZh/V1coFsLAEzdc7zqQVQy1SZoAR+XsOuh?=
 =?iso-8859-1?Q?GnWNi/zWLgvbBdAPHfvTRjJbpZqI994cIQI8QrKqEkiu2IIIK9SJoTSKWn?=
 =?iso-8859-1?Q?Jbs0yZz4Udwm55nL1PO9h0XOByNnh0zAjKh9vOoCmXHw6M53sLDt5s4q2j?=
 =?iso-8859-1?Q?K+wRuyMr9KlLi+0Vpp1+fAr/dIWVXt8J2qgm949+dcvww0qB5ZVX/z/7Y6?=
 =?iso-8859-1?Q?T29wXtfg6i1TYCYuLMM5S+AbAnuLx9HBjOrwq+yr9HP9hzoeDOJEwFIW7q?=
 =?iso-8859-1?Q?8jY8o6aZzTVCKnGfMH6VbwZXoCapChlNKQEA0jNiW/zvfHONZkgA1Yz0ba?=
 =?iso-8859-1?Q?UQNxyu/cZGUU2cMv+4EMSsgfAYJOhzcJDI5AQEFSEo4jQbz+g8CkqN8UKV?=
 =?iso-8859-1?Q?SRVGvSGVxXzXIUFNlByvm5dj0ec7ePQ2dn/wt+vQM6TpdgjGsOH6JoUJN0?=
 =?iso-8859-1?Q?Ue1bQUxNy8VDcD1EL3VpZZ?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?9ILkows99LBfQW+c6P1EBTid2lMmnZ6T7H7T3w4j/2ozqJWB8QNCflzzYx?=
 =?iso-8859-1?Q?gdfryPyBMfhoXQ1pk/9LeVb9ZkEKEb2FlDY+vWuTPGopS9lzBwzdD3iA7E?=
 =?iso-8859-1?Q?mKwwJHBA1s9CEHclzvgVBsiK6sA2rI9tLimm+IYpzxpLt5i1v64i7byRxg?=
 =?iso-8859-1?Q?SZ0C3czhLb9mtvy9Ayp84RGuBS9QVlcWgLp9REg7U1eXvQUSg4hTJr/dWx?=
 =?iso-8859-1?Q?NRXxRS6npTTWm5EQDP9jne7PBcN6RKiTUNFPn/eXTncZ6JtYL/mmHUVK9g?=
 =?iso-8859-1?Q?tILU0U7onAtRwDXf4XnhRB8TY3JrKsjULlLJ2BjLR2olrGGs6VTOKc8vMC?=
 =?iso-8859-1?Q?kF0BM9lx4zfzGEJqwqIl/atjecH9D6nLQBWUrmGZG7VwKA28s31OC9KJ35?=
 =?iso-8859-1?Q?6LXDaDgOWxNgci53WeylZECzfLSD+4AfZ6bQFPyPJwClS87FUOPx8ZU2ya?=
 =?iso-8859-1?Q?R4SSfFR9NDwFQKvqRuoANt/xvzlb0FFMDSN27E8keqinJzvnD2vQc2N4dY?=
 =?iso-8859-1?Q?42FQ+6JBQRYtHGddgC9WCOJoSx54VPFKDviX4q7/qW1P0OP/7gcZYQ0AKZ?=
 =?iso-8859-1?Q?n4jYrl5XjF/c/BUCuWVpBcJkQgqTGBfm1aqsHCZcCzVSAU+f1Grt6sJBHf?=
 =?iso-8859-1?Q?7nRfWAgcn2jK5Ru24AMgxBWXs/tA3lz2mcpjQ3xlLp72WiX4OkMNnkNaKn?=
 =?iso-8859-1?Q?2GigU+K3zaXWJbkmMxlC8cA4iGofgT7NupFF/YbbHToxQdEZ5uxGoPrwAd?=
 =?iso-8859-1?Q?yEJfPc/QKTvB2Y/UNBS7WvvY3YFbj10/JtCfhRrRajvvO7jXgzdyZMXKlO?=
 =?iso-8859-1?Q?Tf1Ip+G8Az0LA0my0sjKs+4Qg0AZntSkOmFeI7HuggHDLGrdcE1TpjaEKJ?=
 =?iso-8859-1?Q?i44InNvlpT0A/VoLBmU5f7RYc2aypaNbH8FRiyp8YQurdJ45CTLLQGVkLW?=
 =?iso-8859-1?Q?9sipzndylYKPjOnrS9sutU1g1TXk50qgmX3AbpwtMXX3ntCqFdtDD6lfsZ?=
 =?iso-8859-1?Q?1V5Got5w4dyY+8kcVKF1ZfMmcinc/GHFE2w9fRwGsVlwEUMvkYvLFg7HwS?=
 =?iso-8859-1?Q?DVJYHwOuJKO4Hm29L1l2EfW2C7DSU7FTtjFV8DMzRwwR2OXlIeMXslQu4r?=
 =?iso-8859-1?Q?dIS/pnapfy8XWwhAz3m34yfTsoukrmiWLeE3RiPv9YCjwBAaHsnkkPRF/k?=
 =?iso-8859-1?Q?1pAg64LHIzb5Btn7tLfJjiEWyY2vxGpA+WiFfHJA41IVk0xqVH+MCAu2mH?=
 =?iso-8859-1?Q?HUCr1kwXIrH4gM5WwEqyAY7sG++ih2owSIj8BQL6TkFV9Za7t5lc9Xm+Qi?=
 =?iso-8859-1?Q?B5lgnCaDTFj5GgcSlT8q7jURuIOvNAUIriBrWCWXAen+n/n+H+C8wdmk4C?=
 =?iso-8859-1?Q?m7zBe3vBOc1AGXjpxhsx+nhvSs97eMsoH2VNDS1VGKALcl2t13VmRt0XNi?=
 =?iso-8859-1?Q?+/OcS1pYs3UZtBOJ7qB5lY7zNxnSgvOkNaA0hB26Pgi7RB4inshtena5aD?=
 =?iso-8859-1?Q?CNyoaCm/jXEx85E9tUGQzQspYywSf3aDJph7bjM8puWRAyJbLswZ8fYMwC?=
 =?iso-8859-1?Q?TAeYydyI3xMjkHWrAk0k/AsTvPVlN5VDu0MUIb3DrdvuvPZHuDzWdW0F7T?=
 =?iso-8859-1?Q?vtZiJhpqJqNyeSrJWkEwJxMPtoiuRuHYDR?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e21e98db-caea-4a41-86da-08dd417c85bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2025 22:22:03.1846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D+k84f/W49fGph1A+igjL4mc8In/3PL5nPROVWb2SUP6KNP9qCutx/+FJiz/fE7iG7AJ5BcMTZO4EX3yqFBgYZJSNe+c2lMCT4oHJmkT4cQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8526

=0A=
=0A=
=0A=
=0A=
=0A=
________________________________________=0A=
From:=A0John Meneghini=0A=
Sent:=A0Wednesday, January 29, 2025 9:54 AM=0A=
To:=A0Sagar Biradar - C34249; jejb@linux.vnet.ibm.com; linux-scsi@vger.kern=
el.org=0A=
Cc:=A0Tomas Henzl; Marco Patalano; Scott Benesh - C33703; Don Brace - C3370=
6; Tom White - C33503; Abhinav Kuchibhotla - C70322=0A=
Subject:=A0Re: [PATCH] aacraid: Fix reply queue mapping to CPUs based on IR=
Q affinity=0A=
=0A=
=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
=0A=
=0A=
Sagar,=0A=
=0A=
=0A=
=0A=
I'm having trouble applying this patch to scsi/6.14/staging.=0A=
Please re-base your patch and submit a v2.=0A=
You might want to fix the broken "--cc=3D" argument in your email.=0A=
=0A=
/John=0A=
=0A=
Hi John,=0A=
Thanks for the efforts and pointing out the merge issues.=0A=
I have submitted a v2 of this patch and also added a comment before the fuc=
ntion, as you rightly pointed to.=0A=
Could you please take a look and provide your thoughts?=0A=
=0A=
Thanks in advance=0A=
=0A=
=0A=
=0A=
=0A=
Applying: aacraid: Fix reply queue mapping to CPUs based on IRQ affinity=0A=
=0A=
Patch failed at 0001 aacraid: Fix reply queue mapping to CPUs based on IRQ =
affinity=0A=
=0A=
error: patch failed: drivers/scsi/aacraid/linit.c:1488=0A=
=0A=
error: drivers/scsi/aacraid/linit.c: patch does not apply=0A=
=0A=
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch=0A=
=0A=
hint: When you have resolved this problem, run "git am --continue".=0A=
=0A=
hint: If you prefer to skip this patch, run "git am --skip" instead.=0A=
=0A=
hint: To restore the original branch and stop patching, run "git am --abort=
".=0A=
=0A=
hint: Disable this message with "git config set advice.mergeConflict false"=
=0A=
=0A=
=0A=
=0A=
John A. Meneghini=0A=
=0A=
Senior Principal Platform Storage Engineer=0A=
=0A=
RHEL SST - Platform Storage Group=0A=
=0A=
jmeneghi@redhat.com=0A=
=0A=
=0A=
=0A=
On 1/27/25 4:32 PM, Sagar Biradar wrote:=0A=
=0A=
> Fixes: "(c5becf57dd56 Revert "scsi: aacraid: Reply queue mapping to CPUs=
=0A=
=0A=
> based on IRQ affinity)"=0A=
=0A=
> Original patch: "(9dc704dcc09e scsi: aacraid: Reply queue mapping to=0A=
=0A=
> CPUs based on IRQ affinity)"=0A=
=0A=
>=0A=
=0A=
> Fix a rare I/O hang that arises because of an MSIx vector not having a=0A=
=0A=
> mapped online CPU upon receiving completion.=0A=
=0A=
>=0A=
=0A=
> A new modparam "aac_cpu_offline_feature" to control CPU offlining.=0A=
=0A=
> By default, it's disabled (0), but can be enabled during driver load=0A=
=0A=
> with:=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 insmod ./aacraid.ko aac_cpu_offline_feature=3D1=0A=
=0A=
> Enabling this feature allows CPU offlining but may cause some IO=0A=
=0A=
> performance drop. It is recommended to enable it during driver load=0A=
=0A=
> as the relevant changes are part of the initialization routine.=0A=
=0A=
>=0A=
=0A=
> SCSI cmds use the mq_map to get the vector_no via blk_mq_unique_tag()=0A=
=0A=
> and blk_mq_unique_tag_to_hwq() - which are setup during the blk_mq init.=
=0A=
=0A=
> For reserved cmds, or the ones before the blk_mq init, use the vector_no=
=0A=
=0A=
> 0, which is the norm since don't yet have a proper mapping to the queues.=
=0A=
=0A=
>=0A=
=0A=
> Reviewed-by: Gilbert Wu <gilbert.wu@microchip.com>=0A=
=0A=
> Reviewed-by: John Meneghini <jmeneghi@redhat.com>=0A=
=0A=
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>=0A=
=0A=
> Tested-by: Marco Patalano <mpatalan@redhat.com>=0A=
=0A=
> Signed-off-by: Sagar Biradar <Sagar.Biradar@microchip.com>=0A=
=0A=
> ---=0A=
=0A=
>=A0=A0 drivers/scsi/aacraid/aachba.c=A0 |=A0 6 ++++++=0A=
=0A=
>=A0=A0 drivers/scsi/aacraid/aacraid.h |=A0 2 ++=0A=
=0A=
>=A0=A0 drivers/scsi/aacraid/commsup.c | 10 +++++++++-=0A=
=0A=
>=A0=A0 drivers/scsi/aacraid/linit.c=A0=A0 | 16 ++++++++++++++++=0A=
=0A=
>=A0=A0 drivers/scsi/aacraid/src.c=A0=A0=A0=A0 | 28 +++++++++++++++++++++++=
+++--=0A=
=0A=
>=A0=A0 5 files changed, 59 insertions(+), 3 deletions(-)=0A=
=0A=
>=0A=
=0A=
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.=
c=0A=
=0A=
> index abf6a82b74af..f325e79a1a01 100644=0A=
=0A=
> --- a/drivers/scsi/aacraid/aachba.c=0A=
=0A=
> +++ b/drivers/scsi/aacraid/aachba.c=0A=
=0A=
> @@ -328,6 +328,12 @@ MODULE_PARM_DESC(wwn, "Select a WWN type for the arr=
ays:\n"=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 "\t1 - Array Meta Data Signature (default)\n"=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 "\t2 - Adapter Serial Number");=0A=
=0A=
>=0A=
=0A=
> +int aac_cpu_offline_feature;=0A=
=0A=
> +module_param_named(aac_cpu_offline_feature, aac_cpu_offline_feature, int=
, 0644);=0A=
=0A=
> +MODULE_PARM_DESC(aac_cpu_offline_feature,=0A=
=0A=
> +=A0=A0=A0=A0 "This enables CPU offline feature and may result in IO perf=
ormance drop in some cases:\n"=0A=
=0A=
> +=A0=A0=A0=A0 "\t0 - Disable (default)\n"=0A=
=0A=
> +=A0=A0=A0=A0 "\t1 - Enable");=0A=
=0A=
>=0A=
=0A=
>=A0=A0 static inline int aac_valid_context(struct scsi_cmnd *scsicmd,=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct fib *fibptr) {=0A=
=0A=
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacrai=
d.h=0A=
=0A=
> index 8c384c25dca1..dba7ffc6d543 100644=0A=
=0A=
> --- a/drivers/scsi/aacraid/aacraid.h=0A=
=0A=
> +++ b/drivers/scsi/aacraid/aacraid.h=0A=
=0A=
> @@ -1673,6 +1673,7 @@ struct aac_dev=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 u32=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 handle_pci_error;=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 bool=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 init_reset;=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 soft_reset_support;=0A=
=0A=
> +=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 use_map_queue;=0A=
=0A=
>=A0=A0 };=0A=
=0A=
>=0A=
=0A=
>=A0=A0 #define aac_adapter_interrupt(dev) \=0A=
=0A=
> @@ -2777,4 +2778,5 @@ extern int update_interval;=0A=
=0A=
>=A0=A0 extern int check_interval;=0A=
=0A=
>=A0=A0 extern int aac_check_reset;=0A=
=0A=
>=A0=A0 extern int aac_fib_dump;=0A=
=0A=
> +extern int aac_cpu_offline_feature;=0A=
=0A=
>=A0=A0 #endif=0A=
=0A=
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsu=
p.c=0A=
=0A=
> index ffef61c4aa01..5e12899823ac 100644=0A=
=0A=
> --- a/drivers/scsi/aacraid/commsup.c=0A=
=0A=
> +++ b/drivers/scsi/aacraid/commsup.c=0A=
=0A=
> @@ -223,8 +223,16 @@ int aac_fib_setup(struct aac_dev * dev)=0A=
=0A=
>=A0=A0 struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd=
 *scmd)=0A=
=0A=
>=A0=A0 {=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 struct fib *fibptr;=0A=
=0A=
> +=A0=A0=A0=A0 u32 blk_tag;=0A=
=0A=
> +=A0=A0=A0=A0 int i;=0A=
=0A=
> +=0A=
=0A=
> +=A0=A0=A0=A0 if (aac_cpu_offline_feature =3D=3D 1) {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 blk_tag =3D blk_mq_unique_tag(scsi_=
cmd_to_rq(scmd));=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i =3D blk_mq_unique_tag_to_tag(blk_=
tag);=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fibptr =3D &dev->fibs[i];=0A=
=0A=
> +=A0=A0=A0=A0 } else=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fibptr =3D &dev->fibs[scsi_cmd_to_r=
q(scmd)->tag];=0A=
=0A=
>=0A=
=0A=
> -=A0=A0=A0=A0 fibptr =3D &dev->fibs[scsi_cmd_to_rq(scmd)->tag];=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 /*=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0 *=A0=A0=A0=A0=A0 Null out fields that depend on bein=
g zero at the start of=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0 *=A0=A0=A0=A0=A0 each I/O=0A=
=0A=
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c=
=0A=
=0A=
> index 68f4dbcfff49..56c5ce10555a 100644=0A=
=0A=
> --- a/drivers/scsi/aacraid/linit.c=0A=
=0A=
> +++ b/drivers/scsi/aacraid/linit.c=0A=
=0A=
> @@ -504,6 +504,15 @@ static int aac_slave_configure(struct scsi_device *s=
dev)=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 return 0;=0A=
=0A=
>=A0=A0 }=0A=
=0A=
>=0A=
=0A=
> +static void aac_map_queues(struct Scsi_Host *shost)=0A=
=0A=
> +{=0A=
=0A=
> +=A0=A0=A0=A0 struct aac_dev *aac =3D (struct aac_dev *)shost->hostdata;=
=0A=
=0A=
> +=0A=
=0A=
> +=A0=A0=A0=A0 blk_mq_map_hw_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT]=
,=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 &aac->pdev->dev, 0);=0A=
=0A=
> +=A0=A0=A0=A0 aac->use_map_queue =3D true;=0A=
=0A=
> +}=0A=
=0A=
> +=0A=
=0A=
>=A0=A0 /**=0A=
=0A=
>=A0=A0=A0 *=A0 aac_change_queue_depth=A0=A0=A0=A0=A0=A0=A0=A0=A0 -=A0=A0=
=A0=A0=A0=A0 alter queue depths=0A=
=0A=
>=A0=A0=A0 *=A0 @sdev:=A0 SCSI device we are considering=0A=
=0A=
> @@ -1488,6 +1497,7 @@ static const struct scsi_host_template aac_driver_t=
emplate =3D {=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 .bios_param=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 =3D aac_biosparm,=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 .shost_groups=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =3D aac_host_groups,=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 .slave_configure=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 =3D aac_slave_configure,=0A=
=0A=
> +=A0=A0=A0=A0 .map_queues=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =3D aac_map_queues,=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 .change_queue_depth=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 =3D aac_change_queue_depth,=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 .sdev_groups=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 =3D aac_dev_groups,=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 .eh_abort_handler=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 =3D aac_eh_abort,=0A=
=0A=
> @@ -1775,6 +1785,11 @@ static int aac_probe_one(struct pci_dev *pdev, con=
st struct pci_device_id *id)=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 shost->max_lun =3D AAC_MAX_LUN;=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 pci_set_drvdata(pdev, shost);=0A=
=0A=
> +=A0=A0=A0=A0 if (aac_cpu_offline_feature =3D=3D 1) {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 shost->nr_hw_queues =3D aac->max_ms=
ix;=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 shost->can_queue=A0=A0=A0 =3D aac->=
vector_cap;=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 shost->host_tagset =3D 1;=0A=
=0A=
> +=A0=A0=A0=A0 }=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 error =3D scsi_add_host(shost, &pdev->dev);=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 if (error)=0A=
=0A=
> @@ -1906,6 +1921,7 @@ static void aac_remove_one(struct pci_dev *pdev)=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 struct aac_dev *aac =3D (struct aac_dev *)shost->hostda=
ta;=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 aac_cancel_rescan_worker(aac);=0A=
=0A=
> +=A0=A0=A0=A0 aac->use_map_queue =3D false;=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 scsi_remove_host(shost);=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 __aac_shutdown(aac);=0A=
=0A=
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c=0A=
=0A=
> index 28115ed637e8..befc32353b84 100644=0A=
=0A=
> --- a/drivers/scsi/aacraid/src.c=0A=
=0A=
> +++ b/drivers/scsi/aacraid/src.c=0A=
=0A=
> @@ -493,6 +493,10 @@ static int aac_src_deliver_message(struct fib *fib)=
=0A=
=0A=
>=A0=A0 #endif=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 u16 vector_no;=0A=
=0A=
> +=A0=A0=A0=A0 struct scsi_cmnd *scmd;=0A=
=0A=
> +=A0=A0=A0=A0 u32 blk_tag;=0A=
=0A=
> +=A0=A0=A0=A0 struct Scsi_Host *shost =3D dev->scsi_host_ptr;=0A=
=0A=
> +=A0=A0=A0=A0 struct blk_mq_queue_map *qmap;=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 atomic_inc(&q->numpending);=0A=
=0A=
>=0A=
=0A=
> @@ -505,8 +509,28 @@ static int aac_src_deliver_message(struct fib *fib)=
=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if ((dev->comm_interface =3D=3D=
 AAC_COMM_MESSAGE_TYPE3)=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 && dev-=
>sa_firmware)=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vector_=
no =3D aac_get_vector(dev);=0A=
=0A=
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else=0A=
=0A=
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vector_no =
=3D fib->vector_no;=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (aac_cpu=
_offline_feature =3D=3D 1) {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 if (!fib->vector_no || !fib->callback_data) {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (shost && dev->use_map_queue) {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 qmap =3D &shos=
t->tag_set.map[HCTX_TYPE_DEFAULT];=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vector_no =3D =
qmap->mq_map[raw_smp_processor_id()];=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=A0=A0=A0=A0=A0 We hardcode the ve=
ctor_no for=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=A0=A0=A0=A0=A0 reserved commands =
as a valid shost is=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=A0=A0=A0=A0=A0 absent during the =
init=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vector_no =3D =
0;=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 } else {=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 scmd =3D (struct scsi_cmnd *)fib->call=
back_data;=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 blk_tag =3D blk_mq_unique_tag(scsi_cmd=
_to_rq(scmd));=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vector_no =3D blk_mq_unique_tag_to_hwq=
(blk_tag);=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 }=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 vector_no =3D fib->vector_no;=0A=
=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (native_hba) {=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (fib=
->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {=0A=
=0A=
=0A=
=0A=
