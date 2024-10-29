Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2074.outbound.protection.outlook.com [40.107.117.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5AF205E22
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 12:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730203438; cv=fail; b=pNXXqfuQJVRpll3RC1WiGXpCNS/MJZ5qt9UoeW7llrEfYoFbekGo3RoeMIGN0oXSb8uLXphHZ5fBp0T2z0jYe3zTAwT2ljgzJFpHbF7smTvNTVzmLz82MFQ6zgUrQ/tFPFhFbYQ6dFyx1T+bP93MAjtX6PqTUbs882sunyurGwI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730203438; c=relaxed/simple;
	bh=4/XbrRF7OLwzEj8YD3xqqO/ooIVozpJ9rjwDGu7qt6k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m3Asy24TSCyEY5eRTOn2uLnnXg1NtZy2lsSom0GMx3+PjJNty4WcyjuBj5V17u2wm4sNI0dDX30l1kIofJzVPS/VuJfi1hQ7mWzo4qomJGqQuCg4CxFMmQKqnVJfW0y7EaCAJiY0xHFzGfT/a/wR2xA+ICrmC5SN9CqjI4kEpBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=XKkG7ovG; arc=fail smtp.client-ip=40.107.117.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="XKkG7ovG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZTbz61AdHmEs5D+s0iSnNvaAod3Gd6BVWHsSe3nZtcGBVDi4Wg/RIGxcwlT8OJBOtwatvQ19U6eGSStlPaCzUC18QgycwU4oFtiL65U+X6uTAdXzCkPGCw+rgQ8D92Fq2BirwLYYvnUzviz1F7K7zS+pA/g+l79PsP/nemhym+ivf7Df7O3Z8+lS5Hf3TD+2D+A1UT22BGGMqGMoI/6Qy6K3YW6ZIwCg03aA+Znt0OPsFAMKV5MK7xuNRSzEW/o0/YAZyF0hua0cBjloG9xTF8NwUErFUtf9Pxl/U9ONinDikMENFh/YESPnvgKVWs5QE9fjMIP7Isg0y6l3qRPrXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/XbrRF7OLwzEj8YD3xqqO/ooIVozpJ9rjwDGu7qt6k=;
 b=I8ABriop+4asmqVnhQ200gysaWZ3M5MXIGW7DjkUo2i7IdXzMBVYgv07VOFkFeWahg8gGxL9PI/aRVYEkwy7RdUqv1aSUZ2DVgZaCyEi9mA3KxMNPOM6RKf1eqezfrXtFH3/bdt2nAnVBLMror8bGKBWqKsGxDXuHsMsxRPJs7V2jZQZ9Yh7cOSFdX06yNQ2KT6S+CtxiWpeQyRNMLyUPS+wtpGdUZU9Fs1a0T3KEREeUtCga1EEIzkG7zWOyEgi1IvqjbINOU3XHJUh4jbRBT8sYFMM+HMQx1ltcRDKShxEozIfNoOvulNQtZMzKkQPimysw1p/zO2TFIjqHZtnVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/XbrRF7OLwzEj8YD3xqqO/ooIVozpJ9rjwDGu7qt6k=;
 b=XKkG7ovGHERI7Y6sJN+4KDpu8YXzGhm+ip8B09+cSK4WKebaf8fswZx0M6bufIV2Zxw02WNxZuo4nYTu5tU+83t78eTd7kEL4G3mliqFVSwgtTnj4GZ4cnt8z+HqznZQeSVkW8FcSNM1nMeBxxJjKMrnsvXR9NOOqOBYi2mi2zoKrYojgnsIDAHKNCZxIQorJ2ycWqknE2iZCexnWNRngAWnD3m1Vb7r7A6/fNwTtBRAFrCLRRmQH+xngqg/iirMfOyEQE+PqtZD6iBfGO0X+9ljtaJLvl6dOdUooWJZURvAYyKGeYsaDKhkuQQvN0Hl4viBVAbvvoeSXtvE3JFgNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by KL1PR06MB6369.apcprd06.prod.outlook.com (2603:1096:820:e4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Tue, 29 Oct
 2024 12:03:52 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%4]) with mapi id 15.20.8114.011; Tue, 29 Oct 2024
 12:03:52 +0000
From: Huan Tang <tanghuan@vivo.com>
To: huobean@gmail.com
Cc: beanhuo@micron.com,
	bvanassche@acm.org,
	cang@qti.qualcomm.com,
	linux-scsi@vger.kernel.org,
	opensource.kernel@vivo.com,
	richardp@quicinc.com,
	tanghuan@vivo.com,
	luhongfei@vivo.com
Subject: RE: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
Date: Tue, 29 Oct 2024 20:03:46 +0800
Message-Id: <20241029120346.591-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <330e0b7fce03b2970db80c4b73b611af220b6349.camel@gmail.com>
References: <330e0b7fce03b2970db80c4b73b611af220b6349.camel@gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0184.apcprd06.prod.outlook.com (2603:1096:4:1::16)
 To KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|KL1PR06MB6369:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b8993bd-34da-42d0-4c65-08dcf811c14f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IiJrTcAuV/p8bcCxhsmIaIy89az2LAGO+II8HA4uQZHoU0kWHoGfQIYzV5Yk?=
 =?us-ascii?Q?nbfEhY0WfK96zV4pHlTZ+EIfF8DPw/2Qg1RQKL5y7X6zMhhSML+7wUN8sE4N?=
 =?us-ascii?Q?Zx2xnAVQTIsOeAXerdKowL7OVxmEhs/sIwDpoQp8t47E+xVepW2p/PKxijqi?=
 =?us-ascii?Q?0wy7T/lyUHN8zNLo9oBBQOyOQZXujCjG9dyjuuTqET5iLVZIVFWJ1SXxDOb6?=
 =?us-ascii?Q?4ckAZMIeZQmlhvjR1mGSj6pa3pAQ89KpkKqbjFJ3Vvw5tdA+IU7R5VHDpdzV?=
 =?us-ascii?Q?BzgPpQvz3IiPpd3zzdkR4WrKaSQU70BJHwUuTvLtmrpBN5EBU95BNyHUceeQ?=
 =?us-ascii?Q?tmzMWXebAEbCdqIZK73b5i/OVf1/QTSTahAd3VgPJirvHSVFLoAd0an3QzuC?=
 =?us-ascii?Q?EWcbgCx+y71n+LcxcYMAtcAdM2bKGGo51pa/9QcLUJ8meOH3R2qO7PCiEHyD?=
 =?us-ascii?Q?TLIu1NLQAxwlI4MCXrIcSgyQKPmbSIOi4pk6Uo1Q5xrklx7W8va5FAi9mFQs?=
 =?us-ascii?Q?RpmfXbLIa/+z2DSJ5XKADVXiLxTtFnpyajcimYdqHUGaiLOMi7wE673O4lyQ?=
 =?us-ascii?Q?ZNvWTLcMqt88vB9tNtnOAT+G3QDUN/FQSr5gX0s7/3NyAcJJFRTF7/S0g5TQ?=
 =?us-ascii?Q?qB+TsN2zUaEkNe5WJ3NiI4EUvHnqak5MUqFqFrOqP3o38VKsvdFrbFAJxG7k?=
 =?us-ascii?Q?2L7e540mqUaWlCmqIL8Gq/8FHx8Y8gjiNEmWsDoMesuasD817/rE5uFEBjXT?=
 =?us-ascii?Q?95wCfyQe8+VN5TpSfjFp0J+HpSVF0jMJJDxNjiltEjg2V6sw/ew9pi/QMVik?=
 =?us-ascii?Q?i3MOFUTjbeF1QrJRh+AgVp0K8bFTI4lEk/a4MhtsmrqCTsbbv9hdW9Wn1p16?=
 =?us-ascii?Q?jLf+ymxW1NDKf23b8RbDNWI49qPBDZy5YgU/g1+BYCtFL5Vvk9o9BScBkZbx?=
 =?us-ascii?Q?by0zhumyYPPy00DUHWa8Ih01UWEi3vM08M1zc5hY83/EXZbnIxp3KS/sG+lw?=
 =?us-ascii?Q?f2+zM8wD4XVkbVuSB4K2sFuDxg/R5MUXW1rIuoQWrJY1B84tSq7q7PJ3db1a?=
 =?us-ascii?Q?BUcOm1dcbKYO2fJzbw+oP6BVWTxaLYlwTU85W3akPYLzPQFYtKjEr1Dz3zuX?=
 =?us-ascii?Q?cyYRL//WFbCPb9DFPMFz7Hzl3Sq4wLHSlv/3dE7DujAbcqHJEvUrAe4vOVze?=
 =?us-ascii?Q?JEc0tF3574S79TUEjOBVwRHinEYNHPtDqeLM5JLkVtrD+PNT+N9S+uLiOCht?=
 =?us-ascii?Q?vXH1z25/RGgHB8e4JfVMPznY5nJeqya8jMqLtHfoDyQrw8lNd+eiEUz3vNvB?=
 =?us-ascii?Q?ZfWG/xAgp2vt2ZgrUngbBskgMFWHNLb2DK08Z1oV5zg0wzpZc1iT921UAjSr?=
 =?us-ascii?Q?Qb6VbYo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?evkT0Q6wK+xHApee3g56Cfpd3izrpOBaj0IBj2TgPpwcSUU3svkm9IVXKDtv?=
 =?us-ascii?Q?cwWnR/fqfU5GozzyHJfzipu/CqcIMEu3vVoLtft3t4RQ/Z2/Eq6rT+4FEJpa?=
 =?us-ascii?Q?jCzvn1bw1vkAmcp3z7S3+J96TkEkzdhOKINS2Re57poX3qlqdss3r9gG9bh+?=
 =?us-ascii?Q?o2CFB4bl02BKn0jop/PBWngYC6hXTTkV0fGrL7EJnYmBmm75GsnQBBQSNRT8?=
 =?us-ascii?Q?epuBxw97RlPbPyDeDdBOIweVI1jDKfJyp1Ci0j48nONhFv6+yDUSqYIrdt32?=
 =?us-ascii?Q?TdcILI5juxRGas2eRwCaO7CHLQO0WqSC6u2aq/myH6c76iI0fI9gbWAGnZGH?=
 =?us-ascii?Q?wraOLhjrxfW2RLmi3pyILMp5LSuI8aGQ4v4i9njxNaFdCVBxOqXhYL9FZZyC?=
 =?us-ascii?Q?lUOL9FG77NlIULuYOKcuPja5MKtWFMRaFam84Vr6I71wMJLkJ6HDGzAgIPIo?=
 =?us-ascii?Q?2WKV7m5qSpdJ78HvMOD9n4u4vkorZ13w9rP8i8nVlAkif8p/PtnfvMVtpjG1?=
 =?us-ascii?Q?Or4vl59FvxBszORfHs16aPIYIdyPa8PRHzmDTTQFkqRkKPspMW2qHVUlDHEO?=
 =?us-ascii?Q?X+Ub/ehuUrG8BYFdILaKzeHXx8yfWVzleqiZcEYYaNeBjHCVrzwmbHrZbx8H?=
 =?us-ascii?Q?tTtzOOGhC7sqDduCDxA3eS7Y/AlG9oIHJHS0YwoN5T0KKj/eAvgFqh1vOctg?=
 =?us-ascii?Q?6uCQ7rAuc8USepn/FE333v4WepeJwSzsr6FXWx+U3+QrtkBVEQKzAAi1YvE/?=
 =?us-ascii?Q?k94DOY0utV6XPSaQD42DiXso2wYDjJ1Sl5b7YAW0ecxRx/2sNHJwOdnVMsBc?=
 =?us-ascii?Q?KJ7iaqwYG9bpLWcGSTVoLVHyFPFwWcQB6UApn0Q8vYAgzFJnQ4F055LMCMxU?=
 =?us-ascii?Q?fuBj0wr2m7fc9xt4FujBab6+F1ugKNfLpNkCDV1k6rrALPXHIUWDij7szzdz?=
 =?us-ascii?Q?STNuxYGqU0eayzJeuXxkvCiYFClxAJ5n8ehCqZ/e+0YVi+/tqim4F3sr66N9?=
 =?us-ascii?Q?4ggC3PLSaZYRV3QfOdJvJb2Tk2mgmRuW5YraX/ByZhQ0KDTwtmFAs67CJDiI?=
 =?us-ascii?Q?PcgXyQSL9ArEoVcxjanzI3BhTD4zQit9ZHsmlEdDc0TVlf2Ma+osBrak2Mza?=
 =?us-ascii?Q?0qyKV8doDCtJoZTFjW7EdR6ChzBqYTyO44Ei+uHxmXxPDDu3ToEaKPcjHvgi?=
 =?us-ascii?Q?51V38g58crJqglcz3d9NtnOsseOZ5d2CKvBk3KXOYrOcTxPWPk95yjPfmmEj?=
 =?us-ascii?Q?jz1GOIAw+UYj7kQUZrTsG7frJStBSdIn9V82aUNzyI0fbQStGHSY0fXmH8aB?=
 =?us-ascii?Q?X0EcI30C1jxgAcVgvNCAjHucXbTkjRYcpgCICPNQGmVkdWiaTLPIPLpMiqGY?=
 =?us-ascii?Q?mPGqXJi5wdpJ/WexxYR7oQEBcL9/H0WcCz6YCPoAGpBMuYZIfz2cS24rbRbf?=
 =?us-ascii?Q?5rXvt77xlKWXWobhzqeyOUkPkcm6mOoFbATcnnREc9h5FOxQY69YzmZQlsJ4?=
 =?us-ascii?Q?N7Le8GfV5Iw4FFMIaGAYB8SGbyTRoKmO3LoJCLHHrlq2MdCloLsYm1zYUWOg?=
 =?us-ascii?Q?pzBoW0hsX7sJWDPM04CdgweSMfJ2iCZVufZQqx/t?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b8993bd-34da-42d0-4c65-08dcf811c14f
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 12:03:52.2936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EyVe4vIDR5jyQuiH4afV0I5A2I+Wc2QwNXwpS/0HpL9V/3pKsAdxyYO5vY+JwHUNDQ4+27L0gu/kdCW0cAJmRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6369

> > > On 10/28/24 1:04 PM, Bean Huo wrote:=0D
> > > > Even though I don't think it's necessary to enable a Sysfs node =0D
> > > > entry for this configuration.=0D
> > >=0D
> > > Right, a motivation of why this functionality should be available in =
=0D
> > > sysfs is missing. An explanation should be added in the patch =0D
> > > description.=0D
> > >=0D
> > > Thanks,=0D
> > >=0D
> > > Bart.=0D
> >=0D
> > Hi Bean & Bart,=0D
> >=0D
> > Motivation: Through the sysfs upper layer code, the WB resize function =
=0D
> > can be used in some scenarios, or related information can be obtained =
=0D
> > indirectly to implement different strategies; What is your suggestion? =
=0D
> > sysfs? exception event? or?=0D
> >=0D
> > Thanks=0D
> > Huan=0D
>=0D
> hey Huan,=0D
> =0D
> What specific scenarios would require enabling a sysfs node to control th=
is function? Dynamically=0D
> adjusting the WriteBooster (WB) size on the fly doesn=E2=80=99t seem idea=
l to me. From my perspective, the main=0D
> case for this feature is if the OEM didn=E2=80=99t correctly define or se=
t the WriteBooster Buffer size during=0D
> manufacturing. Even then, adjusting the WB buffer size wouldn=E2=80=99t b=
e a frequent need. If JEDEC has=0D
> found a reason for this feature to be accepted, isn=E2=80=99t there alrea=
dy an interface available to configure it?=0D
> Why would we need a duplicate interface for the same purpose?=0D
> =0D
> Kind regards,=0D
> Bean=0D
=0D
Hi Bean,=0D
=0D
Thanks for your reply=0D
=0D
The scenario I'm thinking of right now=EF=BC=9A when the old phone transfer=
s a large=0D
amount of data to the new phone's APP (vivo calls it easyshare APP), we can=
 =0D
explicitly resize the WB buffer.=0D
=0D
Could you please explain this sentence(If JEDEC has found a reason for this=
 feature=0D
to be accepted, isn=E2=80=99t there already an interface available to confi=
gure it? Why=0D
would we need a duplicate interface for the same purpose?) more simply so I=
 =0D
can understand it better?=0D
=0D
JEDEC draft comments:=0D
The WriteBooster buffer size can be resized in preserve user space=0D
configuration mode of WriteBooster by device implicitly. However, the=0D
disadvantage of preserve user space mode of WriteBooster configuration is=0D
that there could be performance degradation when the physical storage=0D
used for the WriteBooster Buffer is returned to user space, since the devic=
e=0D
has to make internal data structure adjustments as well as flush the=0D
WriteBooster Buffer data. To minimize this disadvantage, the WriteBooster=0D
Resize command is provided. The device only provides hint information to=0D
the host whether the WriteBooster Buffer needs to be resized or not, and=0D
the host can execute the WriteBooster Resize command based on this hint=0D
information when there is no user IOs=0D
=0D
Thanks=0D
Huan=
