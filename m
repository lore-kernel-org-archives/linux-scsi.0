Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22463155738
	for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 10:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724493606; cv=fail; b=jcFLE2lj7781ZabWJC+WIRa016r39+2wQs0XY9K+CAsURP4vwraA5Xl3tfzWvp5N0+ljob6YHUVj2pkNRiAahOSJ3/1ZchZrXwckFl+IYareIfqaQh5twKZVbp3bgmalQyBfyZQBvNRaJss3IfRdGDT6BkEkKyyxcGjOazdbmJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724493606; c=relaxed/simple;
	bh=xdRsKCB6K4NS30dNMLpbVwn0oPpnBnjGWIOWhONCA3M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ChND/DBSYOjnehGWcYjcW5hcpwCsbp6rfOTNvyNbP5dpB9QmnwQ0ZKY4VJxP56ik0c81H0fCJPAPljN1NaeMqfB2ewJuLw11/RQxKWaxBp1z4L3Bg3DvbXJLYRRvzrXvWepuEaslzDcGRACiJ4vO5P1xkibx43yesfhEnGqhPlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hofKxX23; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Y29J8vDo; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hofKxX23";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Y29J8vDo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724493604; x=1756029604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xdRsKCB6K4NS30dNMLpbVwn0oPpnBnjGWIOWhONCA3M=;
  b=hofKxX23TyvESCes692ndZd3+IGXYjZVbQHETGXGgIgic3rzH/f6sTXT
   E1x8/3C41pDBWhMnMF+zetG+KV+dnM95yrkwjC+yi71+2QV/olf32MSso
   yUCxfa30dBxNidMsnyv5vUDXP/jJxX8Y8+Cm6yqyLpyFR9Elc2BzS4GJz
   O2hlPwtHWDBrJqE9GeJzBjVeo2SXuFYJFDLDsnaqUFFd4eo4UMPS6hRUH
   H9nxVmewI1po1U+HekTCeV5ON8ZQkw4+oMiLLs/51Mu86xAfYMyF9ZaQ+
   13Ekxj42k0uK/6PJKb24m0VtSdApJkYBFIes8EWv8D104aSvI8h2aJ4MI
   Q==;
X-CSE-ConnectionGUID: VhLP6Kp1SmujMpe4ip+Kog==
X-CSE-MsgGUID: tHmcboziSqS1XllwvvNVLQ==
X-IronPort-AV: E=Sophos;i="6.10,173,1719849600"; 
   d="scan'208";a="25115834"
Received: from mail-eastus2azlp17010005.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([40.93.12.5])
  by ob1.hgst.iphmx.com with ESMTP; 24 Aug 2024 17:59:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mEM6STqhTiIH3fWOE2aD96w+WtrsuNiLBCAft+34j4LXWmIbIuyrN2Y136GhH0+fmlIqsDnxqpJkWTMpiMZe7wOHspTgiF/JgPpnqOjSJ5J6iTj2KYIflBl4dYfsfZkTKQLm5bqFqxd08n/ylgi2mz2NptRrOqEVsR/UYI3yW+6a8PyYnx/yrIUBFcUJ0pHedX8MZ3licR3JH4aqj3Y4J+L2UnJctWfNpmCPpRH5AK38u1sEwmolc1L0aF81wxwWI7QnDlbqO3k9o9bjYUTq3BfXOOXT0FGXGeYhNWJW1La0c4tJ/bU8LQJ1lBdlpqgP+sdHSfhICTdUvxucMv9g6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdRsKCB6K4NS30dNMLpbVwn0oPpnBnjGWIOWhONCA3M=;
 b=ODXSXPjPuNLILpU006pI+PpmjF1zs6gtmA65uiXoNQaf13dyCe7J/TXdFw6NrTnn3oYKRNaHkv/opgK4B1gk0vXtafTTbajf5d69lXw6TCE400Zu1lREkl+pkz8AIhh7q+NnfpjnJithOB/t6TAzyzxfEr/9LTjHVbzbVGjZnWoe8jAxDwgN5h0XFQyrLefha4B0oDz5CZIcuXr5TJ89mqmqvZ3mxGx8CX6XH6KLapEm+IUwHizpXMSjSfOJBwlg8R7rfxOIsGzQZJQO2KBnPgs8CEdcTwBiXtqvmJKWadYD8YZgqnE6LBwJm4FQ+ycDmyQXpRIsffqBqjz0I5VX3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdRsKCB6K4NS30dNMLpbVwn0oPpnBnjGWIOWhONCA3M=;
 b=Y29J8vDo5KW/cfmtpIfEevCTvTer4+Vv2tEEjp3/zSLWv4gdJOthkEEQQzkdyaIgc4WbpL/v/WsYz5vXNUaRSsu/tZpHqqfXEYG4NOl2fQMFeHN19Ik092mcvgXJ2/u9q3ECbHIWhVqFjlZvFcWZkpGgChqwB9tvuE1dyJjQBiw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN6PR04MB9504.namprd04.prod.outlook.com (2603:10b6:208:500::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Sat, 24 Aug
 2024 09:59:53 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7897.014; Sat, 24 Aug 2024
 09:59:52 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v2 1/9] ufs: core: Introduce ufshcd_add_scsi_host()
Thread-Topic: [PATCH v2 1/9] ufs: core: Introduce ufshcd_add_scsi_host()
Thread-Index: AQHa9NtyuekUPZ/oeUGnIjzXXj0rirI2LrWA
Date: Sat, 24 Aug 2024 09:59:52 +0000
Message-ID:
 <DM6PR04MB6575F1D03790CD2DEEE1B684FC892@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-2-bvanassche@acm.org>
In-Reply-To: <20240822213645.1125016-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN6PR04MB9504:EE_
x-ms-office365-filtering-correlation-id: 0439346e-46c3-4fa0-7106-08dcc4237fab
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?7ZWHAHj9k2RUbrhAQk6dbZmfOnA1xQ9fbxBrJ7s5J7PsSCz6+b+sFTfBGlXC?=
 =?us-ascii?Q?PyXQEBvBv7nFVPYvZHPuhS+Fl8nziQXCkySInkOxGUh92Lkz5lN0a57O2yKw?=
 =?us-ascii?Q?RWAu1sCGE71CfTqaYX8vfVf02zoKorPZdnTT/WI2GKH//4Pq4vrRaV31hpUc?=
 =?us-ascii?Q?2Xz5VkELS+WK/l0SdgSbBhFwxXK7erfEQmlSrM1lDe/21MWW9A6PC+R47joJ?=
 =?us-ascii?Q?rKtXvy5e0m258IJG+6YzQ6R5tDPKVahZfoXj++2m2cmPKIiCOxgs09FgE9vI?=
 =?us-ascii?Q?kH8gYPhluFEQk/byQLongo3dramrKdpEI3BYMIYL0xOL3cO3drsLVHVmB+gP?=
 =?us-ascii?Q?hENlpdmc7/UhLvygEMsxqZWPjehhkKKWoVv4Y6P7xUHlZzFkj/VD1izV35OH?=
 =?us-ascii?Q?KQHUH9lHUv+GcCWPy5fTgVRku0GYSyMJ2mZJvTyPVdJ7sZwXfGQEhmuFrxU2?=
 =?us-ascii?Q?bewhXdoWKUK3oI+0Q8zolgC/wuUzlN+sUBUcl62rKRC7e1ztUc0znWXPG0um?=
 =?us-ascii?Q?0zgHsj2pLd+l9BAZKyn/S2OkU7wQ+k0SHjUd2QFu/AqX22QEtdaEQkN8iTfO?=
 =?us-ascii?Q?eRMzzhhMeecIvXewUAbPFCh4tHc8V6uId6uiGR8oFUV0oBpVFGYyLsMdFbR2?=
 =?us-ascii?Q?bPhpsh1QTQ/BEvtuM2Kmk/8nC0oIjhvdEDYs1JRK97hWaVw5ehE1ORR+V5Ri?=
 =?us-ascii?Q?8QiZVAUiLvhNJFsYtFWOAl/JH4nRzfSzpQfuecOBr1wM1HPHB/e7YCPiWbGn?=
 =?us-ascii?Q?IdEj/0WslJL8fqTpDkHjh0dt9FaOoaW0P3UY8SS/HjcazH3G5elB6FBye0hk?=
 =?us-ascii?Q?DItt6uA+rlrr4IsbyjQkU4DQ0vzX/t1MkDWEsxMGiIrB1GaoPBr86v/bItuo?=
 =?us-ascii?Q?1vU3WO6/0cAKJ1xc98aB6s34wyYBCaPSW9vE9oDhcWm0a2/GkW3l3gPFB1Fa?=
 =?us-ascii?Q?r7aahR87PMfRxSsTgkAyHRoQGjkQIfndv9V6DzxtKHInAnEwkkDK/k8H3SkU?=
 =?us-ascii?Q?alCFteOF0qJSvfV59aEeY2/YIwPl053MMnNoV9aww8TFTcTKsgh1X6qsvce1?=
 =?us-ascii?Q?DePS98RwYsGm9BjMuXfAM2+nHtTf/VJ0iMQQpFTgJhlSnFRTvLtsviI1/Keh?=
 =?us-ascii?Q?shYakjqCHkf0MB/XQySEq7+6uaahZsprkKFmPLZj8j2qx5K6SbjAUpHxYm3n?=
 =?us-ascii?Q?LVdB/0PAQkXWhEPWuKCoHAj+tQX7dtOxmZ1BTW8ueLCdY0W6NhN37iiM/B1Y?=
 =?us-ascii?Q?UM3Gjsfi9CaMU/TkQ9ooKWaij/OMKaUU5oo7tSAebHrlGrK9nm8hWXbqWiwZ?=
 =?us-ascii?Q?Tca9SoGw6l+0sihF9xeCCOdJmHubCKylxKXgw7gF/M8cMdGNLS/SvFiJ0s75?=
 =?us-ascii?Q?+nAONrIaZHi4dZw6EPbJFwC9x9QbS+JFZ51N6S2cuYQzKb9vIA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?WGKUDNmswXr1SxLkgQFY9PHkOuYq0fBaARMcXntQvLtx3xYjvFd4B0ijS1yw?=
 =?us-ascii?Q?Ff7+8RxjNdd+TtTquoqpTIZkq+xnCS7XF7bPV8sRuR7ru5jX6hH1XZ+u6L+U?=
 =?us-ascii?Q?c+GDyfRG9QQ8bUx3U0hZMVJB87Rt+eCSXWcGfeVByMQEFEfzchQZJpkKSyxx?=
 =?us-ascii?Q?xwdwYBP26HpCbbCQ3U77E6owvie/YpD2/ZVYNFXISq4X/hODjaYXmhAXkqw9?=
 =?us-ascii?Q?LtxFN/X+O0j0o7M5qwP9cgNu/IRJXp+daRWuoVUkb1HgHTYRHQUjRg7q84an?=
 =?us-ascii?Q?t4dolsWC24kUtYedZ4ix4OU68NZhqhcp4TqU02uoFHiY4l2jSlCITldasMAK?=
 =?us-ascii?Q?YVdMTPuuNWpLcys8ehhAF/K/60LuANcnC9LMk03k16Aa9ZjzJvLTQkcomEF6?=
 =?us-ascii?Q?4YTJutOq9yB4R5ONY/DwWKn4mX+RuuGdKARyUJesNi4yOA4lkm9Tdryl6v1k?=
 =?us-ascii?Q?JAOTMgRKeeRRHIzbCav43q/Qzj05yREqgNf0TqEQiRr1dlKm2ItggYR+NC2n?=
 =?us-ascii?Q?EbwjeznxNM/QA/MPW9IPfGD+c7devNb0I4VHvnIOeNzTGQ1QlWdI775/d3aD?=
 =?us-ascii?Q?AsOebHog4WsPnpuFYNtnK6Id+4mTUhw02Kcjzk0bSBnZZDaTjpMknK/RHBGh?=
 =?us-ascii?Q?Z20UDgPI5Sr3vsMs2nHre65NS286+JzRhznxftSgjCZB3Dd6L/aLMwEeXmel?=
 =?us-ascii?Q?PPAfM9vdWFdS/LOebOIC3gprDomcEqvgjyfb+5wdJbc/Km8Nmv3yBhZPB7RM?=
 =?us-ascii?Q?62zu+q/edkXcjGcxmz5BADrZVVannaXFiV1m/H8eTJPsTZjV9ARBlXxUUqr6?=
 =?us-ascii?Q?0kFQxAiXwOlYClUqF0wS7dJP6xGT/+cym1OVpwfpoSdK6op0OCu9pSI0QvO8?=
 =?us-ascii?Q?A3rDq4zG+2kFE4E4PXYJtkWvcq3ZQ71Mw12I4KA/DilegGu0i7V7vRjIk7f/?=
 =?us-ascii?Q?42MbZ1EXy7SpYVRcA/RAGqSV6iBW2Aw3pmY2rZCA9+mbVvPOobjcz5N2ueZL?=
 =?us-ascii?Q?054S6i8pCIHPEV1Ly1SrEY05TrZ+PPZO4B9fSnLb8OMFI/dhSk/LCX7X6dh7?=
 =?us-ascii?Q?HK2TnAPyEV5QUmeK+62eH7Z/UpfQHEnydOssj/nD2/1S9BmP9Do86ztIZ2Ht?=
 =?us-ascii?Q?Hk+MG2w7xWtFXTObaQKoGeLg0jF3EvD5U/icbTYVNPTJSjHpz+ovoZA29nGc?=
 =?us-ascii?Q?12Bfc9aJrLultMx+w5oOkUXiAALkH6Xa48KeAy+bYY7RS/C6NVUwj9Ts9+cm?=
 =?us-ascii?Q?dd6HJLMzMNGM6GLs1vxwD6OJby+9eTC62dlL2eDZl1ZL5oEDsjHsd+tSA/yo?=
 =?us-ascii?Q?mZixOc/8isfBlVxkN4fEnXs86OKvtDRy0xIRBp/0b50MqdJC3+Zft1OFDXpB?=
 =?us-ascii?Q?H/kGWL7vmil4n6rPszg7zY/Jh19BZotEue4oz8I03xg2PPM3aNSzbdv6D62f?=
 =?us-ascii?Q?c8Z+5f3zb8802Kp+fPNFrFddox6kNKdj9F6jByAXBYAOcBtU98FTB7m11jn+?=
 =?us-ascii?Q?A5B89P85HFgwRj8tQZ/buRDTQouq/FybF4eY0gwd+pWvucw7tiIUkCeefC65?=
 =?us-ascii?Q?Z1DqqQIlJfXqZ4hXUWngy+VDLZ23Uk/h8jrH8+9F?=
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
	60dAAb4mazubs+RSYFCvNuV3VXggz6Tewap3+78KsiInZ5u+jOz598WhrUG4akhM3LJpCmW0SCeYLrHAmZOitCPPqU6tLi5M8805VWS2fBG04L55q0aNOyRVaJer15UpEBRYFd4kbdI8yotQAH1dUQgF+rvuDLp98KlzrC4+22rK+UwntBU22wZX9po6hE+gkX1DDJ8xPXeoLrpIZYrK6KfQC2M2JI0Jc6JA/OiiywCiudQJVawDfB63QJ6hDM6VOagSvnJ+ZBXC7q14OJh/Wxwh0NMd6WpuzkviOpeOmf2+cWaDJ6LEgUy6MlnnDJm3zjvzmfouuhUpkdpsd7nCcJip1nG8SyWUbgf3E02xtw02JATg/z2ueDknB0Bgd066mY7mCkyx7hUvG0jtvFkz1HfzD9GU8OQrr7f+3MEwUjQ+2AqG2/GkLLjI9NJ6QqtgNu5cAPNEjbK68qf+Ah62wGQYzriAxjmQMFb6g/Qq9mhbkyqs0UY4E4+GzBcqSZrsNoQijFymBp347RcrkTIRtl0Hlwr8yDA/ov2ZRlg1i/Jl7t/IYtkrrC2XEFetU6dpKEG3h5G2pzwoIZ1a3iOLhFZufG1GlCmh6BjmH5hJQ1Lf7IWIcyen4KWSwYk27E9W
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0439346e-46c3-4fa0-7106-08dcc4237fab
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2024 09:59:52.4369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bw+W60OscCbrVnf4FptiAOyZG4UvMI7g6ZKdKUJKh+3fvS6QUtpXhZF0uOt0Jpb6dFnSg1xzgmYUEH77nqZS4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR04MB9504

> Move the code for adding a SCSI host and also the code for managing TMF t=
ags
> from ufshcd_init() into a new function called ufshcd_add_scsi_host(). No
> functionality has been changed.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

