Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735221E32B9
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 18:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750790802; cv=fail; b=PRRe68ZnIRgXa4pssJO6/JTNQ9WoXXhvm6+SlIzF+AzH9W3mikP3DjM/AEWJKpoTj9nuo7MMRG07r2aZSqHclXcyHE7sXK3wlww8J08AFuJI70acUcCJMrfaRkRDCNuVdKmqglQaHbqwG5p/Njw4dTgP2mpgkNup2wxEXdboSWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750790802; c=relaxed/simple;
	bh=ztPbh7GVWILHqWZsdTZZOxOC/VFXQu1KPpYAyPoxjP4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bkizoY0lpE6q01k8D7jiWLVxy1KRa6Gk62wGxQvulO5nQOkbw02UGmxlGr49g67uF0+A1u80yeeTuYawCWL4CCB6rG8O/dsG0zzXL/iVMlDXkZHxE7mJtOdAL8CdKpAYBc8F+Dt+isaZrRk/YIO2rdmT5uRKmFXmvlJRyDWl5z0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=B40rp/0v; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="B40rp/0v"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1750790800; x=1782326800;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ztPbh7GVWILHqWZsdTZZOxOC/VFXQu1KPpYAyPoxjP4=;
  b=B40rp/0v8Ck/4CQ+lqqZQB5l5+5Y+5q1qQgIVCiJvWoi2lyUIm913Zjh
   7rzLYFyrtLZjewAI7VEwEjoPCOcyh3H62sSHpztY6dkqGs+M+quBWffr5
   G45g7zuLVGLnqih1RAuMdY80y20uHbyRpC3jUzCH2YhuecaFa1N2u8M5o
   vtim9nKaE03571z91RdiwCkRdKTXhayACYSuyLphbbQMRnMC4/2LxhyOx
   S9GSYcPhjAO/ru1UtYGIl2uLNcTIkZdsuBe5049cmYspeW8Pp6kx0LQd7
   Ert8jcFB1j5yut32xtClMBw9XrLGtYwFnVv0FQ0QnGlXCoOic6+Y2ybEz
   Q==;
X-CSE-ConnectionGUID: AxXqUaRPQQqyTvSf21EgRg==
X-CSE-MsgGUID: GPUtJuDqRGeERq01cHdl0g==
Received: from mail-dm6nam12on2128.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([40.107.243.128])
  by ob1.hc6817-7.iphmx.com with ESMTP; 24 Jun 2025 11:45:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JooK3TlDJWVyC+vjuYoZN5unOqJl/KQq7JiXPbZPSvjGXXGRkI2CTbSeMw/N6ZAxcEDvF2oMthQyS+QnX1VUAs1L+d+r5xpDwulKwLcu1WF3CNjjCh0CsWuURP5n0CUuCe/o8A6qoOj5wAN7nGkfgbTsTl5pZjQLEykF8o6oBO/9LpCvp37nRx7TUDfjKK0vKBvLo/aM/1CGKg4pIjDOJquvTzgYpm+BshDmrnETxf1pAojGBuRa8o/gv0W3SukJaiglfFThrw5lJJGJsD0g6a/wY2kxNQhxmSfFNG1MiGQmF2DHWTbgxE+t3nzmFFZ4gvXKiTz0va5sGSZ+WKS2Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztPbh7GVWILHqWZsdTZZOxOC/VFXQu1KPpYAyPoxjP4=;
 b=AjPCKSomNneQlH4KApMTR/HD5EonJx1d4kUMbm/O5YRFrpgoYqinnClmjCuD19eySh4A8t1ViLE6zd0vYia3dVuP0gcZcSkQOuEGkA/p4BgNYIMOQwMUcc9FN0QFxYzjfFPPB4MbT/H9y6JesFsZd2Y6803nEz9pnme491piFaP5PSwZrWqCXtDInG4bN0a5uKwQry93K/BEBABqazb5ec2rRPStDE7I2FUFJUb5kTZ2Ae56SrssQqioTlW5o5BY/J3TmRj3fMQkHdsF0sdXqQiQab3TQL813bgu5SHwfQNzIcrAk1oGa0AUyhEpGWPzeowP1RN5rltrvNPMyAXd/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by SA0PR16MB3792.namprd16.prod.outlook.com (2603:10b6:806:85::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.35; Tue, 24 Jun
 2025 18:45:29 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::436c:8204:2171:b839]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::436c:8204:2171:b839%5]) with mapi id 15.20.8880.015; Tue, 24 Jun 2025
 18:45:29 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Bean Huo
	<huobean@gmail.com>, Huan Tang <tanghuan@vivo.com>, Peter Wang
	<peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>, "Bao D. Nguyen"
	<quic_nguyenb@quicinc.com>, Ziqi Chen <quic_ziqichen@quicinc.com>, Keoseong
 Park <keosung.park@samsung.com>, Gwendal Grignou <gwendal@chromium.org>,
	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: RE: [PATCH] scsi: ufs: core: Fix spelling of a sysfs attribute name
Thread-Topic: [PATCH] scsi: ufs: core: Fix spelling of a sysfs attribute name
Thread-Index: AQHb5TQ+YKFFjqSKIEeGm1M/32S02LQSpXgQ
Date: Tue, 24 Jun 2025 18:45:29 +0000
Message-ID:
 <PH7PR16MB619639617552B6860B564C01E578A@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250624181658.336035-1-bvanassche@acm.org>
In-Reply-To: <20250624181658.336035-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|SA0PR16MB3792:EE_
x-ms-office365-filtering-correlation-id: 263a10c0-699c-4acf-5407-08ddb34f4adc
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?fXVEF00pv1cwdEykrSWdydagrSQbxPtqxXQWpqWeVifSsT8FqrmJH0bfZ8NG?=
 =?us-ascii?Q?jXFkugwZ0rGKpqj8bJWs52h7EivJ1OBPjL9ITfj3RGkSsCcPSS7ltt6BgVxF?=
 =?us-ascii?Q?9A0KO2Wf5ZczlcINbp8s4G5QX1HHV2GYXva0rSW3rjLOYyiQjHLrE9/7YWxT?=
 =?us-ascii?Q?rMoI4BWcG4RZjVZ7Ny/l+7UaKUpUOmnSNWBp7ZifqNwc3iz6/tXYVuYAI5T7?=
 =?us-ascii?Q?TAZTyTyDPogVrPBnUk2JATtrIFAmrKgwvdvQMRND8NoUQ80F/rcewIFak8q5?=
 =?us-ascii?Q?lWqYCHjrvQvDhDDxYbpLrFoOokToABFWsftUMN0R1AX1X3UVfwfkN6yqKESZ?=
 =?us-ascii?Q?j+gyyFp8jAychdGvkXbvOMjgx2p6SPCwDE3saTkQLyYhrGcKazhxc6DbRa/d?=
 =?us-ascii?Q?BSY9UkDL4xXG8QldjNpMUNDmQgcUPvbn7UiwRwA2df+fDzHsPsrwTugzkMjt?=
 =?us-ascii?Q?5xJbyqZ8ymq+pFI8n6+/9Hnw49KLPKIvjPhdcAkAzgAmLkDEAOdZQPl21VQt?=
 =?us-ascii?Q?Ngcd5GN/NjtwgINFX0uOlE1HAMfqXSkQ59bn4DFRQEz01BWC6ILQ0TKO/CUp?=
 =?us-ascii?Q?tsOJy7vr3x2ptVH3diVYpqGv6qMVZnvfjx4bgTRMru5z4rKav3Rvzj1Gcnc5?=
 =?us-ascii?Q?STCN/CrqJJNMBqzLJO1zwCknfni7zGR0ooglo8LEQp3N3Pd8xqen5aOARyIJ?=
 =?us-ascii?Q?RzOSJ7WmbPX3Zvc5rTXlY4EsyUsBfQcqLZvdL8gdVsagbvYuOhvt+KZlqEBA?=
 =?us-ascii?Q?D/sg1sgHQ+bd+gxWEqKZjJWzFVHfhi/qzTXFUo5AoUf/goknXVyBW5xFAUke?=
 =?us-ascii?Q?URymFNJ+pL/bknP3JMbRkdaOGfeKYb/PIL0pE1oALoMZW2qOk+x/hfLow12o?=
 =?us-ascii?Q?4PKnWSGTN9E3HEY1mzqQza2XhT7id55bEm8frnCfp/gNd6+QxcaWX0V8ZjDa?=
 =?us-ascii?Q?lL64zE0BOaJt/Emp4Dg+iEXYUwt5VegXPStUGmmWx6hQzfP+3xGZ0umDD5uP?=
 =?us-ascii?Q?20b0mgRw6X5gDJRDiw47s1hXEhmjeDUV9vry4HPvjhAo2Rc8nu6BBgW8pDeK?=
 =?us-ascii?Q?zr++6e4YxNiUU+/MLpTJrw32J+oVG6nhypoIQSPAXy5SaS5MVd3Dm05Onfk0?=
 =?us-ascii?Q?dMeYFkbV0uC0vUxEvtLYnEBu0Fc3MxjlMlBh5zVgkGI6bXKVuYVJG3fN/RMv?=
 =?us-ascii?Q?dMIdD5TirDUGKYBIHXyUNqPjPZEsjmZoYht+NpW69jyX7HTF1y8/H/1LncZs?=
 =?us-ascii?Q?nXcqbOgBHGs8fIP7lx9WL4AcJ3F99WnAEoJnAOtVmuGVXJGHifbXMI7DklTA?=
 =?us-ascii?Q?/0DckA6td9J9jUn1k/l0H0WXuZXecpNHHdEfAl+ms3IGByeH3KOk4zbj2Veg?=
 =?us-ascii?Q?Nj3Yw1NSB7pIHUoPNMop8jgx94TaIDn4OnT+2pV/z6Qc/1nu2WA5KdbMH91r?=
 =?us-ascii?Q?mxFTO7Jd82ksrWQzO6SyIeVbeHntV2Jclo3aYcDXYsjHNE+tCnvRlg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?o+k+tk7HepY8wi0pgRKiYYUOU7gI8w7Mnu9EnVSbj597bN46dkZzbkG5tKh/?=
 =?us-ascii?Q?oSN+FnLK79d0izLaD1Gan4YT2S9ygWNlxYanbfsUlCtc1LYmBSAaKZ8F2jP8?=
 =?us-ascii?Q?FqFCeRlOCv6q9jBvzjdvcqrxhwLKS3sZu2fvjmSaRoSS/YyiQ0IhG1Pf6kTY?=
 =?us-ascii?Q?uXXEZgFsqIPy6uooHe2wKH9Stj/lxrv5wK4MZXsqlEW8XcfvpOxAIyqZ18P2?=
 =?us-ascii?Q?L6kX7OjcvLHqdwKVlxvU879+rWZKr0R+YfhcxIfkq6eLcEpjvhHSuiK8/jkE?=
 =?us-ascii?Q?3keQ0pv6FPytCUwPPDfod0rq4sMO/H0jas/NQjfJrJroSC2KJmz/5uP4QHO4?=
 =?us-ascii?Q?gHFCM2Cy2oBPMRo3pvhcK9BB9OsnWpnuXnVMce/kgsd1b1/OwgQvy6JPyiHv?=
 =?us-ascii?Q?4JFeKVs6v2PQN+R+P4i4n0r/NuFc6L6pf+JxiWSTkx9dDHwG79NgySMcHJB5?=
 =?us-ascii?Q?ZnlHLU6nObop8GA9QrwLTYX5waTX1CXOvM6DIm+XfdrLCpo2YNle3DtIgEYD?=
 =?us-ascii?Q?clfcDuZFsLgIynrPSeSV+7Kls5sk3wX2juJlZm6CGlr+46ZP93yJ9Wx+BCqa?=
 =?us-ascii?Q?dlVoB022hLav9Tgdbjgu6xaj+o7XfBv1w9JQ6p7iFaTbTXco3MzM5ie8oIH0?=
 =?us-ascii?Q?dWXXfSFmXcBhEsu2e8vo8vhSvk35+Nv9dovu/2ZUcvJ5FB4jIP8KLYuTfE8X?=
 =?us-ascii?Q?ChXjzcbGwg/tAHUZfc+0+fg1Pd48pYdxX7A2ebKYR0p2COwvo2/3v5BhcoST?=
 =?us-ascii?Q?vsqfWu0M/4ev0LcstZzP25Py19Nduyz7R2y10oZT+4JmIHzbQdoVE87WxLn5?=
 =?us-ascii?Q?6Afw7yzMNKwLNosDGgfwWpUJ7I+i7aDI7u7oCd/y3IAdrFrKmySND/v2MlDl?=
 =?us-ascii?Q?5YDgIVv0J9tQ/U4tPfJyCibQ1Wx+jGdZv6qwwupTK8jUkjIU/63x+H5NuAis?=
 =?us-ascii?Q?gCYF3Lvbei52GVxG3KjW1PmoekbzRlCEPoZ2WO4SBhdHHkTTzCEf0h5F8ngQ?=
 =?us-ascii?Q?C1sV8JEuiJQUI/lHp8JT8GNdR6UpOo4LznYYAh90JZ5eXJC1CcWBWVG9nQgD?=
 =?us-ascii?Q?F0FpPErSI6cRXifMeCyDkncWMkRTO6+m5DfrfPxrGfmFduJHHHSkq2VkAq9j?=
 =?us-ascii?Q?/hPyCKxZ3I2hr//AdirJMs1nkG43APPyDU+Xh/tfp7Q4hmkgaJ2TwSCFr+iH?=
 =?us-ascii?Q?ez/e2zAfKE6epi6mG6JFgjvQfOVqMxbzg7eZxyQ/8TY9MQ/NhSeZElbhoHYY?=
 =?us-ascii?Q?1b4Sdk3TpcPGLSA54rQwEo0rsQhzuCbufjKwm5TixToBpYFmhSaM0wwjraK4?=
 =?us-ascii?Q?YoOG8yvc0D0p4PkipfVV5o0Bek7Oik3HenwWTuAEOBX7nejrRZWuJaEuKzjN?=
 =?us-ascii?Q?DjOFSEx7JLZmJrSxCouypSH0FXWCFYUAefc3me6SwEaHOOL/AMmbg+hSLRbm?=
 =?us-ascii?Q?v850JEhgZx3+uKKB5RpiIbp6qLQQGh06h7/bzj+VaDQtjzTyLdrPQIDmZ5zc?=
 =?us-ascii?Q?nGbLKDRlX+45AihVoAk5OkhbJ2WH62nWVH8rnCOR4xIR5GvseqyF5CF+F5dv?=
 =?us-ascii?Q?qbWCLhF/EvLVxTZ7/rVd/o7bAAZ4/pOJrrlYmSac?=
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
	RsY3eCiCN7v6gg5oODi5V2rGp+ccIyEB1MmDevRn1yrVat/brYuxxWfcSbNELae6K/4FOHYAUvz3O7dX8vZaYJXvOthLh/NWuxRnX2nnpK1nE1u5y02C+OKO7yJR7PX1pUfyq96naR2HPyz6uZilJ49+Yti7OqXA5SgtIuPyzrzdi5DWGNWjVLPlncRv+QaJL7dnhhsyVELlnz5H37pV3ceoAxC78IJLDYq3Qruini2AHbg/5mJ3tTYz+CjLjZaaVmUfyecK4qgbvQ69eeUkbKgegqhCdnSouj29++eGwhbH/+tjkgAkjlhGE6aDafso2Vob9g363+u5aieQxwxlqFgsyjWty7BWV/8KLO8zf/u4sGCeZzhcyWhcalaaOQw+/MnjAbQynTG9WOt/SDVRQIIqlPbmrIcDVqvH9k5po3jeXp8wI6I9afGDPWmxgRYjF5o9dhcbXW2tkFnetAFYEc2vjtGFCWPYBbLcjV/TMpecPNmyEn8fB89adGpBYcC+Ij0800cQMnkZ0RFjCMGnOxCwo+Ll5MPj4WLQoDUJ3pPq/zKOqcVeSuEhRhMW0GrYXKt4J1RvCZ5LOzogjE22hCdC3ymDSmm6x+a+MRiwQxGZpTix2t4esIIJiO8JsaOs/8pHNtrF4bVmj2owO4sptQ==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 263a10c0-699c-4acf-5407-08ddb34f4adc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2025 18:45:29.5871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R/a3wXZBxtuzbi4Yll3wUP21aFU55MGncSAZZ3SqKfPBQpWnk1reEFnkrvCcGeYOlUG3m4j2ytLfaJkpwvDSZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR16MB3792

> Change "resourse" into "resource" in the name of a sysfs attribute.
>=20
> Fixes: d829fc8a1058 ("scsi: ufs: sysfs: unit descriptor")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
