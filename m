Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F82276028
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 07:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758871083; cv=fail; b=bsOHc0k3+pGsxWl5V78elL6n4FnoZsj5ri1HpPS+T5kooojXccz5OalleL6TJtDQ1Xvrix17aorGGn/VAZzmzHhNEH5Cv3/+yeuF9qwC1KFI2heiqZWCmBREHZrEnoTHWJ0rdKg4u8dNPJ8ff4M2Ov6gTFXHpkr2ai2MjjRB9Lk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758871083; c=relaxed/simple;
	bh=CjDPMV22TMxCM4GmJrO8EMAEgGuND5P1GTtunpW2aSE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kX1/QMLZeIAhR6TKiXiY2Zm7tBNGexE5CUOuxwBHLxkT6ts1miIRXyqe2R8AX6wDYiWqy5P4lOkGAzT4Yvn/Bbit3WHdbPVO1JekYQiZxn4vLhbFELgLmJNv8ZEX/1+dkUigEC92t4Aab1jUM7TV9oDL8CImEVqZ/DnuYh9kNfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=b96U6aOX; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="b96U6aOX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1758871081; x=1790407081;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CjDPMV22TMxCM4GmJrO8EMAEgGuND5P1GTtunpW2aSE=;
  b=b96U6aOXRms6917anegmI4DEoGPuAiqXXeyNJup1GCjpro0xMPVQn36A
   JgfR7L+NaC8nU8LJZWeR59Krrxm090BFpJV2hKu/InRNdGWILppa3V2ba
   ofExK8jT3l2GvuSuiuJDDEmZJDxXWRV0FGAMSXZCEeu6Hhzj74ugagmky
   mnRnQPUEMPlBuL9isnnmNO97eJLQPKp6GShqMMPukOgCIE58V0KUACSFS
   vV6/6An3OahZ1C0eqoGte9d+jhaE/N21zgRDSwLFF+eO8qWUYTf/78poL
   Uil322yX63jmqdh64jYVJvJjBPCmYdjhwu8Qtr2jwg1TeWDz4Uok+JXsr
   Q==;
X-CSE-ConnectionGUID: S8LUcr7zTJiA0s/9+cqN3Q==
X-CSE-MsgGUID: mBmWLnWwSHyiuMmgk3Zi1Q==
Received: from mail-northcentralusazon11022142.outbound.protection.outlook.com (HELO CH5PR02CU005.outbound.protection.outlook.com) ([40.107.200.142])
  by ob1.hc6817-7.iphmx.com with ESMTP; 26 Sep 2025 00:18:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KMpsTzWM1TmeglMIDMOQ4LQXCznmXmabKYQRDBUG/GFmB+OATG/KwweraW66QnH03ALojPF9DhL8Di9BOzafir6tWAH3D+Q4AMYAwVV8QfOrmJatKqlKJkzi1OZjrbU/MCWJjoARSilfxVlGF8lRp4hLEyNfqByTSmA09cHJOUdOJDUNgvpzhL+KffDFlrupWLH4Ms8PjbAKDALkzJAHaykA8tIT0aGTrgFsjNaDviXu0WN8VUdZvq1MZEXte0ursl65ELqTVStId7XTwaIHQOPuDPmuuHTWPVpUla1UE21X8QgVAZ6N23yv9TbFY0SBUhYMKKEs1ApVzHhYRgQ2CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Q+MQ8wTu+xiDbCmHMHQDEFl7tlV2wdNmQBceT5oaxY=;
 b=DrxWsyQsAzO3lknr7cSquxcZiPjCtYXEU8H4nzbHpUR+uBj4gFNV0bNcARFcmm5ocLO8MXs7zymq7IVz03VaYhvSbDZQ9Gk4D6txkU/kgpmEz0kO+RbWjQRtH6q4PZ7dyJJPhHr+DWQ427IFU2kxNVJG2jxiciaKZO2EXm1NkYeIaAqO7CdJtP5Vu5rxRkkyujQgNuwcWV1vPeBDRhgb+doSnrRcl+037du+oBkmZI0wpzOhKq4l61gys1qxtbwsfe0d3RtDgW49P2oJ7V9kgkQ+0rT8s/FipfM0kWy2+KKi484tTHJOJnHEVu+oXjlbwlIi3UW+Zy14Oz/odOlbKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SJ0PR16MB4174.namprd16.prod.outlook.com (2603:10b6:a03:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Fri, 26 Sep
 2025 07:17:57 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491%6]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 07:17:57 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v5 16/28] ufs: core: Rework
 ufshcd_eh_device_reset_handler()
Thread-Topic: [PATCH v5 16/28] ufs: core: Rework
 ufshcd_eh_device_reset_handler()
Thread-Index: AQHcLZKFNlst7/Z+r0yMhakVsQ2ca7SlEA2A
Date: Fri, 26 Sep 2025 07:17:56 +0000
Message-ID:
 <PH7PR16MB6196DFFBF5E6067947F12E0BE51EA@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-17-bvanassche@acm.org>
In-Reply-To: <20250924203142.4073403-17-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SJ0PR16MB4174:EE_
x-ms-office365-filtering-correlation-id: 8795c436-e97b-4755-577f-08ddfcccd141
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?YDx0jH6jc9qHsiipxC6xben4MFPfkcw0YE7DK6qLhEPVbTQzVA+15dkHXNkr?=
 =?us-ascii?Q?FAkJPsqOx+mEOIJaFutDd2GxXfEnD71F0vndpbjBJTIfIQF9KpYTfrnHloeE?=
 =?us-ascii?Q?2UXpeedMZiDf4+kOAj11abUtQS9Zwlaxvq48gKcPtr/2zeATuNKKkaHkyySF?=
 =?us-ascii?Q?Dy3zhI0KyqlNWfunHz4nYB2Rv/Kutb2fNVA8mwGKnWbdnIJzhhsc3+y40i/U?=
 =?us-ascii?Q?Ib5qxIZzis9oR0GnGhKc39t2cWR0bEFiR+55g0V8VQhqxvfgOa7kDAJwyx5p?=
 =?us-ascii?Q?K/1kiZdZ42nWANjFgMX0JzfKsQDRd5ShfGY1jnA+rZE6EaYV19+FOcJsRIPT?=
 =?us-ascii?Q?0WkUcqKSzvBbHaW2Os+c//67h9EusrPPvb73E8uMnhdcGwucSFL41r0XdnV5?=
 =?us-ascii?Q?q6EdF+MwGW+/TJF/wkXnSX7J4IqvgwZ+ZoiaNKyiMF6kZ52K29UdRVzDVrBf?=
 =?us-ascii?Q?K2qRAnFN6nK40mCjiOPVfpBJhmDdBAJ+zdmmoul+HuTf07tgfyWRgJ9j3FEt?=
 =?us-ascii?Q?4RVf9Lq3CxK9LwFvx8aZY7ioL0a52InPfjWAeE5f2T8n+HmQ/ExLexyf5m8p?=
 =?us-ascii?Q?DQt+T7YDsx8Yb8L7Qg1XMYSXRDI7UMJJz6NpiZ9SGx6KBceP1ImmUBhLhNko?=
 =?us-ascii?Q?UaGlZkW0RgSETmGrnqxwV2QAJHgyGW3iduI38NYarHBaKPJttV6L2RyaSQNc?=
 =?us-ascii?Q?mA/AQ9/KLoEE6ahG4w7kMH8CuetxTcjqMIhVlL3nNxGunFJfGJpq3ajgbXOc?=
 =?us-ascii?Q?+X0bqIv7dE/TGhyY3Y1MC4O5Hbo2zY63vJ4Tp/xD4Y/TOYfG3jL8rt8cJj/w?=
 =?us-ascii?Q?J0BGcQz3MmyG49UZi3hH9mNMLTjX2rJMFU4KW0ocqAWgNFQGi8L77RjAD/rL?=
 =?us-ascii?Q?JT40IhOctFq7Bw8g0D3DWwfd/3RivWm5xVbwbos+bH+0ZO3qgQ88rT1anY9/?=
 =?us-ascii?Q?gzhnc52Ph4x4/aasSVz1fpp9LPhEQSi2KwJYI1lpT0Zl0NE+O2pR6YgsYHHt?=
 =?us-ascii?Q?erEj87eK/2+ejjuZHIz2o0deHne1OLWse3jpYtasXI5U3lvIAbokNJAR2Fox?=
 =?us-ascii?Q?axjpvz/TqrJe+IbQhjLBrIT21rCheny2tdAkJ9uLby/rE17PDMlmahi8t2jq?=
 =?us-ascii?Q?vq+AKMs+o7t6S4J6EE8nuQXDTGMT24TxhFWpUvOLe87pgUn0JTEuEAehkqXr?=
 =?us-ascii?Q?FftVvQi+IesPOo+HR04U5waExmSA/vE8cyyfiVFc4d9jbKWzP7aO0SzQCopx?=
 =?us-ascii?Q?+Xps548ayNf35GHEVgHSatZiuMo0HAcnNmTXyE/IaVN7Pr/WMjSmC42UArMW?=
 =?us-ascii?Q?/FzzZkSYpJvgZEBx61PfaLTPk/JbLDhsMLh+JbojjBnmj70MOYYX87BzS2hD?=
 =?us-ascii?Q?K4Hql2ZNimvfYvdr6cIFwh+yqQ8AOAz+FaehRhhwF+mP26tq0EWE7qMm4YQp?=
 =?us-ascii?Q?8CfxpO/YrqxulwAKg9hYs+/i5NtzmhZTXRXxOm+XhAEpng19cjRENQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?q4AW1oyi9V3uxrJGJvnILasJPERFzULmA5xTp445HDxsJM6mSSDie44+odEu?=
 =?us-ascii?Q?dDgUwe20/mk1Fyvln0btFz/mkosgknk17GKczVoQCg+bkDJ40BzETNaM8SZo?=
 =?us-ascii?Q?mWyt5bcnU9evsTnrq6RUgqLT+J1isWHCIme0nAfBzd0HdjPuBDoFonsYbWay?=
 =?us-ascii?Q?q+ZoSF6I20p7++ooGCCoUEncuhydykh+CtRliWHJP5X1C6Ep7e2Yd+isf+Dd?=
 =?us-ascii?Q?hxEJ8FrYhhEErCgpwtQnZEhlY8kIu3RiEa/ktAgWAb4e+nd6CnD08AyV2PtN?=
 =?us-ascii?Q?YEnq094BH6rmHL9OEjRZLAVNQtrjZG6ii/VC5739Hacnh687KCkSal0ycBli?=
 =?us-ascii?Q?HYnzlOR4v2f5V69G7cu/jiMgDbHnBLY66KbZX46BFqRtR5Fi6G9UbbRDdAym?=
 =?us-ascii?Q?cWRxvFN+WdqwD6LE39WWJY1v3Aa1YuDcFTjx1V/UXrP7nrIVg9p7wrnNQMFV?=
 =?us-ascii?Q?6gJSK7qOa14YFfQcov+ekey7/X6KmooXbqJSr/kgwIWQVdU4xpu+s1SrzJPN?=
 =?us-ascii?Q?rUkov3Ua4+1bnYB+B3rkF/50PqnJWzxVQOEemRxp5d6R+IMdDQx7NiKvV3lt?=
 =?us-ascii?Q?gr4Wp8T4mdiHutLdJyxaotNH3sHNK3brrKX/GcmQh+b/jzwEOYN4ylGDBgFh?=
 =?us-ascii?Q?wwNmbwDxd7VVoZIUcuSh2ut/XWjv7aw7JqaPyinN3/H7X4hpySayOmcT/Zpt?=
 =?us-ascii?Q?/wCqXXz2/XXMc7LccyfviXL5/3NbTmaYjVuTqcYogVh6Pu4zHlyO3Iy86li5?=
 =?us-ascii?Q?m0BJPUtwzNEgHbfn1YpHx9fBBS4FT6iDFjvXl4tRLVIHVKUWBjFmo1PAUVq7?=
 =?us-ascii?Q?+nGXsMYADMGlzu1Zd6h8XtyL7c2/LAmdHJ3OOxq8na2HEi0vgIIUQ0xM09ao?=
 =?us-ascii?Q?3djd3fn7nmGCRPuFooPUowaVMajyU3tDXrWigobpQSiQXcGB444rK6xVEOhx?=
 =?us-ascii?Q?pleNGm/Tk9UX5+vxx/NHP+A+JqT+YHLLAzmJ9ZtVku4Mr3/SSntdECkqTe4b?=
 =?us-ascii?Q?x2T90QtIFJWEoR9GGy2g5upDc7+EcBnRaT94q60uN6L0gNMWPBTVFpF4a8bq?=
 =?us-ascii?Q?6a9XPMf9FXNCWt3KoMGS6RUkJYSWKiCyTZz6KuOMDBm+ueDEy/fCK0gCnNv9?=
 =?us-ascii?Q?9K0yXQ/ckzXvNZ9t1/7scji2R6x43neIgJhm3W7rk2Zua4sEMhlOTVZppssr?=
 =?us-ascii?Q?NJoWLMYdHmO9yzRH0l1ddhNWhHNaJ+7mo0ecOyXjokx1iyVoCo7Z38/kh9P+?=
 =?us-ascii?Q?AMqTot8jChbN8gGWnpF0TfoK2eVBDK5Hn7X+Lwktzxvw/R/WtOaV1OkoniAQ?=
 =?us-ascii?Q?tw0q25Nfesx4HUbREoOxUsmF4zleNIMa2+Zux8BWijqyQf8dfzYW0wkOiFen?=
 =?us-ascii?Q?Kd/zYOjXooWkZmYzFIDLLyYZaH5PXidl/TYKXKkGRyxDE/T4a1vyzR+qbdpR?=
 =?us-ascii?Q?RI+oNGauDZeT7Lh4arVp5nhO2AUBGWx1iwf7R2wBu9h6KtBSHZIhPigwG3nv?=
 =?us-ascii?Q?4SHyXuMeZF8UOJH/0HgGC9P5uNML6+gOK/ofA0J9jr2qqY/i0xisMYj6X+0h?=
 =?us-ascii?Q?k8hYmYB1sNABfm5DeiVzEkTz6DN+oME2fZSuEf6S?=
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
	5HTVJT+9eH6lf3ZxaxhD4PWLaz/aJZU+7hJoST1vBX/DcbwDThUQH6PB0gy+dil8txmWTiRaVT4U/UrvQ6uP4fGzaq7mYhKZ/TAjyBusxfdKvBrx1rDH/+1p28ukWDPSurDz3QQUQA+IsqoDF080bx5m/zFdFDKoB6lSquozQxtyTQ4NoAutt5a4SdJHfZvthBJ1OPJIzoOnFxCTRyqUH9Oy3ZdH0XS7VYjIAlgPoQ7zO9Y5xuCTPehj6bx/ZBXpeWwDmgFPXHaHg3VfQi7DFrXWXBguNnx5L+u3KiKNwMZVH9424CXVzz6Fh1ZIqdiDV2FmAEA+uTB2cJloONwEsp6M3o2ugQd84r7dCqYT7ZqOQrHsI3Efe2tMxMvcUAm5CrjEG1lyETxgagwlpn0EjmSnvAvlVepteOoJBjMNcMPaFEoHBhjOjIYuh3KEPW4DlEfsYPhDw9ZNP7P71vCrL/6tYjoPMSjQIL/J186zmhEdiq41zdQe1TNNwv4Ai2wtnGXa3F3AaHMizFfa4pw+E1Rfb1VCpDNJdj5ZY0J3g2P6GenFenZSm6peAK5tE4c2vN9m2Cn5TskpmcZPE8TcXlEZ8m/OhoP0u1iT1owr6jbmvzrDllbuosWY0JT2bYbhlJ6b314HLURKqLkRDF5DYw==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8795c436-e97b-4755-577f-08ddfcccd141
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 07:17:57.0204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0qUfpQlU6xOXgRtCktcDnkHM4sVwOL8SletWWJt+gDfxZ51C/2CMwk7Cd1j1WiGxu0ZaQPRrAiV33gbcudvHxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR16MB4174

> Merge the MCQ mode and legacy mode loops into a single loop. This patch
> prepares for optimizing the hot path by removing the direct hba->lrb[]
> accesses from ufshcd_eh_device_reset_handler().
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

> ---
>  drivers/ufs/core/ufshcd.c | 84 ++++++++++++++++++---------------------
>  1 file changed, 38 insertions(+), 46 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> eea9e707ab4b..67607f2d10a2 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7538,6 +7538,36 @@ int ufshcd_advanced_rpmb_req_handler(struct
> ufs_hba *hba, struct utp_upiu_req *r
>         return err ? : result;
>  }
>=20
> +static bool ufshcd_clear_lu_cmds(struct request *req, void *priv) {
> +       struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(req);
> +       struct scsi_device *sdev =3D cmd->device;
> +       struct Scsi_Host *shost =3D sdev->host;
> +       struct ufs_hba *hba =3D shost_priv(shost);
> +       const u64 lun =3D *(u64 *)priv;
> +       const u32 tag =3D req->tag;
> +
> +       if (sdev->lun !=3D lun)
> +               return true;
> +
> +       if (ufshcd_clear_cmd(hba, tag) < 0) {
> +               dev_err(hba->dev, "%s: failed to clear request %d\n", __f=
unc__,
> +                       tag);
> +               return true;
> +       }
> +
> +       if (hba->mcq_enabled) {
> +               struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba,
> + req);
> +
> +               if (hwq)
> +                       ufshcd_mcq_poll_cqe_lock(hba, hwq);
> +               return true;
> +       }
> +
> +       ufshcd_compl_one_cqe(hba, tag, NULL);
> +       return true;
> +}
> +
>  /**
>   * ufshcd_eh_device_reset_handler() - Reset a single logical unit.
>   * @cmd: SCSI command pointer
> @@ -7546,12 +7576,8 @@ int ufshcd_advanced_rpmb_req_handler(struct
> ufs_hba *hba, struct utp_upiu_req *r
>   */
>  static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)  {
> -       unsigned long flags, pending_reqs =3D 0, not_cleared =3D 0;
>         struct Scsi_Host *host;
>         struct ufs_hba *hba;
> -       struct ufs_hw_queue *hwq;
> -       struct ufshcd_lrb *lrbp;
> -       u32 pos, not_cleared_mask =3D 0;
>         int err;
>         u8 resp =3D 0xF, lun;
>=20
> @@ -7560,50 +7586,16 @@ static int ufshcd_eh_device_reset_handler(struct
> scsi_cmnd *cmd)
>=20
>         lun =3D ufshcd_scsi_to_upiu_lun(cmd->device->lun);
>         err =3D ufshcd_issue_tm_cmd(hba, lun, 0, UFS_LOGICAL_RESET, &resp=
);
> -       if (err || resp !=3D UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
> -               if (!err)
> -                       err =3D resp;
> -               goto out;
> -       }
> -
> -       if (hba->mcq_enabled) {
> -               for (pos =3D 0; pos < hba->nutrs; pos++) {
> -                       lrbp =3D &hba->lrb[pos];
> -                       if (ufshcd_cmd_inflight(lrbp->cmd) &&
> -                           lrbp->lun =3D=3D lun) {
> -                               ufshcd_clear_cmd(hba, pos);
> -                               hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_c=
md_to_rq(lrbp-
> >cmd));
> -                               ufshcd_mcq_poll_cqe_lock(hba, hwq);
> -                       }
> -               }
> -               err =3D 0;
> -               goto out;
> -       }
> -
> -       /* clear the commands that were pending for corresponding LUN */
> -       spin_lock_irqsave(&hba->outstanding_lock, flags);
> -       for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs)
> -               if (hba->lrb[pos].lun =3D=3D lun)
> -                       __set_bit(pos, &pending_reqs);
> -       hba->outstanding_reqs &=3D ~pending_reqs;
> -       spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> -
> -       for_each_set_bit(pos, &pending_reqs, hba->nutrs) {
> -               if (ufshcd_clear_cmd(hba, pos) < 0) {
> -                       spin_lock_irqsave(&hba->outstanding_lock, flags);
> -                       not_cleared =3D 1U << pos &
> -                               ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DO=
OR_BELL);
> -                       hba->outstanding_reqs |=3D not_cleared;
> -                       not_cleared_mask |=3D not_cleared;
> -                       spin_unlock_irqrestore(&hba->outstanding_lock, fl=
ags);
> -
> -                       dev_err(hba->dev, "%s: failed to clear request %d=
\n",
> -                               __func__, pos);
> -               }
> +       if (err) {
> +       } else if (resp !=3D UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
> +               err =3D resp;
> +       } else {
> +               /* clear the commands that were pending for corresponding=
 LUN */
> +               blk_mq_tagset_busy_iter(&hba->host->tag_set,
> +                                       ufshcd_clear_lu_cmds,
> +                                       &cmd->device->lun);
>         }
> -       __ufshcd_transfer_req_compl(hba, pending_reqs & ~not_cleared_mask=
);
>=20
> -out:
>         hba->req_abort_count =3D 0;
>         ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, (u32)err);
>         if (!err) {
