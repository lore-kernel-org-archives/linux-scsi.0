Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11013057.outbound.protection.outlook.com [52.101.67.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760321D7E21
	for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2025 10:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.67.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743157387; cv=fail; b=DRNvj503a8HvxSxd19Pz2QCUdpcKaJsFOJn0tcoXzFixsCnIThD1p/xJP/zOlittOrzRH9HZndd0Z37OIMdHkUEebrLHOFChSrYiI9d4O/G4s7u5MaEw8evprxI2I/MZjpMguxDsRZn/xpPe02NnG8qlUjcwyWoDfsCl+HUx1RY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743157387; c=relaxed/simple;
	bh=z2WrTzp9G6DmwQ5bO1HZVh9P3VYdhC3lSbNHtFrAWxU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G87V80i/Tv5wcFKEqROqBYtFkefrA8Yj38uRiEY0fF7FHREAle9gVP5oQadyR+bglf+jjynx1DhYG5RK44bGfffr7e2xwGGnB2txlKG/vRckjjRavYl3ifGDOhepH4KtYSTH4zl84y0pCnLBBJ6HwNyXbCjY3kN8NeGZyuqlhCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=in.bosch.com; spf=pass smtp.mailfrom=in.bosch.com; dkim=pass (2048-bit key) header.d=in.bosch.com header.i=@in.bosch.com header.b=hx2EKzl5; arc=fail smtp.client-ip=52.101.67.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=in.bosch.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=in.bosch.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=in.bosch.com header.i=@in.bosch.com header.b="hx2EKzl5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T2HgLeLsoy5b88yJn8c59P6L3vJCgBbCrJfU3grbTk3mcfBHk6Bj4G93D9EL4tckWglr7i8ubw/slh0UXpLyo6VqXBBfF/XTg4BcgjQ4D+PC+AuMplLvE67yK617zoPYsrwrZYB25A+I7IguDhi29TV41V64Amka1mQ6xX/YsQcDxDCRsYTt29VEq6mu4A305zDWcUUnRn5k3/0Ni+stXLzn11v18KKnExYnROp3Grem2kCKZBrL2V19+rdPV9/izRJ1l4btkYU6EfI4hrQ9u9SJ1mw9kwqfosl0My+zXgBSNqKGfwvccbC7ga9QcH67gY1fTYy+KMIAuOVbMX/Dhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGaG+xV5gB12H+oee2oTmfV1EFGpNaSdMzV5b3dahfs=;
 b=VdIBqD8qn8c656pKJzt8MgCtOmhOhykkFFk7wH7maSLjtBc44UdhV8Sull5QN9wuFWAUQ/dOr9ZS8uWfK3oWjMlJgSg/pBqKItrzT42T33I8l4RAUpY/AJguVjn/wFq0a+JPRYEs3dm0dwG/DvdVUxIbZeht/2NJPc+9Wql6pXjqHhZmxATZfkGpOsdTGSHO+9S8VhlNNylH9aRoRTZw6oxTvNUj3a5WvGIV1JZrMxC0Qie7qLyudGHUuhhJhPufMGBQpUhWpaor3bNksMubraUQqMGV+W4Aqm+JTjP+1WRyUu9lNeLDM3AxzFoVBNSAa65yqlzmUO1hHMjXYUyymg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in.bosch.com; dmarc=pass action=none header.from=in.bosch.com;
 dkim=pass header.d=in.bosch.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=in.bosch.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGaG+xV5gB12H+oee2oTmfV1EFGpNaSdMzV5b3dahfs=;
 b=hx2EKzl5sqvp3OqFzhbNO+YSYyeXdP1Ab3SC98/gNeDukYI0s/kh+IbwI2HgHbs5fM/ymhOnJVvhytxSA3/MBlN8PLbHRGs3uk3Esn/hxAme4VhKccT+VFOlq+a/cR6taaM0+rICqRAgVexxHUFunYLhMlP6IQRftzlGcSEX0XEpsbH7WTdjK8f+KdzyOpI6x32i32ZlrMGrzRnHgk3XzN22Uu76LR8Fq1jYUhofteoxr46S4L4lyuR2Mf9iL/jPYis91mL8erw+XbrNzVhQfubtpBANsWObjXnlYPaqyC1/U3rmMaO5Vt+ZCmz5KlVQEYnS2TMh6MmmZd63HxDYnw==
Received: from VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:16a::10)
 by GV1PR10MB8419.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:1d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.48; Fri, 28 Mar
 2025 10:22:59 +0000
Received: from VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::67b6:6edb:8a95:c33b]) by VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::67b6:6edb:8a95:c33b%7]) with mapi id 15.20.8534.043; Fri, 28 Mar 2025
 10:22:59 +0000
From: "Selvakumar Kalimuthu (MS/ECC-CF3-XC)"
	<selvakumar.kalimuthu@in.bosch.com>
To: Avri Altman <Avri.Altman@sandisk.com>, Bart Van Assche
	<bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, Peter Wang
	<peter.wang@mediatek.com>, Manjunatha Madana <quic_c_mamanj@quicinc.com>
CC: "Antony A (MS/ECC-CF-EP2-XC)" <Antony.Ambrose@in.bosch.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v1 1/1] ufs: core: Export interface for sending raw UPIU
 commands
Thread-Topic: [PATCH v1 1/1] ufs: core: Export interface for sending raw UPIU
 commands
Thread-Index: AQHbnw3tp8bUIs282ke9V8AWlRtforOG4MIAgAAAnQCAAUA3gIAANbLg
Date: Fri, 28 Mar 2025 10:22:59 +0000
Message-ID:
 <VE1PR10MB3936F035CE799C994E16188DB4A02@VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM>
References: <20250327114604.118030-1-selvakumar.kalimuthu@in.bosch.com>
 <20250327114604.118030-2-selvakumar.kalimuthu@in.bosch.com>
 <9c791cf0-1853-415f-a037-0578d6573e45@acm.org>
 <VE1PR10MB39363AD29DCDDD5CAFD3B6FAB4A12@VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM>
 <PH7PR16MB61962ECD8A529648422CFC82E5A02@PH7PR16MB6196.namprd16.prod.outlook.com>
In-Reply-To:
 <PH7PR16MB61962ECD8A529648422CFC82E5A02@PH7PR16MB6196.namprd16.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in.bosch.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VE1PR10MB3936:EE_|GV1PR10MB8419:EE_
x-ms-office365-filtering-correlation-id: 172ad096-0371-4879-b4a6-08dd6de2839d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|13003099007|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?63I4uOXBke14qR4kNM6mcdNptu0gYCtwoN32XoIYD0T/B65XVXARxbKbbp?=
 =?iso-8859-1?Q?us8cAMCYsErlO8lxR7iMBA2o7I0Zh2nhg8bkb/ByUJQ3kJhkBA8zSlq6y5?=
 =?iso-8859-1?Q?JBqcjKTgV7k9IhuUmyRtuUrdLXUzWO4vuUIpV4o7b50tJFY2Oqj1PdKGYb?=
 =?iso-8859-1?Q?vEQQnt3AoTPqS+rizrywvE0KUla8TVHkKZ9aOOOU3hu31Z9bLSjzcZDHF7?=
 =?iso-8859-1?Q?j5a+kenk5uaKdbXebQIFo/kkDCzF8oIBTEJ+PPFd7XATtEd17XWrqONmjO?=
 =?iso-8859-1?Q?x7hyWIV0IAlQsHWIblvMUqJuyAQsA4hfK9ciSlM2XUK4O2kwtPOuNxXAxC?=
 =?iso-8859-1?Q?xbBCZ9cdOuxJCl6Jm4yYvh3hKOq3Lj++woEYwJu8yKKhXT4HlwDwzE4sSC?=
 =?iso-8859-1?Q?1YlnD8v3LgLDAbg4VmxE9L35WtVum3d4BGTMVHBhG6RfXbVW0NBWv7SG1o?=
 =?iso-8859-1?Q?28jpY79FIGxiTA3pHHQPUnHS6MYs7sy7cvLHGsrusXGpRgId64xxOPb8vF?=
 =?iso-8859-1?Q?IW4MO4pRtVcHzIPGwtiJ/DfUINxyeWvfuiHlaME5rTEG94FZvsyWMYEj2h?=
 =?iso-8859-1?Q?K+bOm7itNnF2ZCcOXUUyHTEMDu3zfUbxfZ5dsus7VNwlGoMOspSHwW2Rql?=
 =?iso-8859-1?Q?HVtH3xDb3kJE3iH2a7Xnxf7daLHG7NYYbTq9O94sAPC8GovqnX3+LLpcWr?=
 =?iso-8859-1?Q?HO7h/0KwJRhP2zvGHdsL8pKpGRFaqkjUQ3zzqFXQrl7rqQ1AwOJ7Pv91n8?=
 =?iso-8859-1?Q?5A1IUzhsO5q6a9zwPSixyGByVxyvtB4erJyhRjEl2hEumJFuscHykTai9J?=
 =?iso-8859-1?Q?viPlR6398QpPxmvmVKkY+JEya/vypOOnIbnYirAs4eKU9O12+Z7Fi3VHCr?=
 =?iso-8859-1?Q?QpEOz8Dk64t2HxCyTm365WJ2zWpZseaEyA9DbOAbJlBN3NdgDewGAx/1ZA?=
 =?iso-8859-1?Q?+rZECVtItis2/g2WsNh+wiVjZ/HcwHZBp4Jdwq6n1xYe3w/s+kjSYKVrf9?=
 =?iso-8859-1?Q?DILAr49LFRzLMokHMxk/39p3qCS16lv0G7pPjBsIP5B+zLa0Q+h74q3Szq?=
 =?iso-8859-1?Q?pCuI2M7HRit6u5PPIL8NCZKJOEf+BI5CHTuZF6WQdnUVpyr//LdO20eEK9?=
 =?iso-8859-1?Q?vRlPqPg2rBrHVX2QuhYcuNC3AIkL2i2vRzcScXKGX7k8HbfcoOW5i/Uko2?=
 =?iso-8859-1?Q?I0BOYuuXBHBtRWMyF1H+NbQbhGyr5xuf7NB5ORhL/6DJabmFLtftm/KSDS?=
 =?iso-8859-1?Q?Q5l8oox0VJhlk6WHCbcMU5jzpppkAae1iCX78MniUsM7dLffqKeyb8mGVS?=
 =?iso-8859-1?Q?Qdm0E66Rz6I29C3Pmst30QQ4FecaC5QtIqLAwKh3dGrZxhkeikfSxe/SLu?=
 =?iso-8859-1?Q?mt1++AgGwok0PS44QsCcoXKpM1X24YEJ8qtiDglncwUIGk3rkDN9mycU7E?=
 =?iso-8859-1?Q?MM30XgVmsOkvw/KV81kh7ZmcupePijXApoeBnw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(13003099007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?QxVTQqTKgPcXbrNqyhXlaaNDjAhpfERx6ieVTI7V+TLPscU/5H35UHFYEO?=
 =?iso-8859-1?Q?mCYL9u3XlXEFoTTzV0DOMKkWOo8ewbqrDQ/kCd+L2Rw7hGg//BZUSTCgq2?=
 =?iso-8859-1?Q?iGZ4nGgStdcDjkliqJXDf+aQanBEWfKIPVXGgbOW5fEfpYlT7mRKDQ8zpk?=
 =?iso-8859-1?Q?ilwvJid6f1Goeaik8EVab6+urAWFrVjVKajAlZlD8oxLT2AZ4rav3a1ZWT?=
 =?iso-8859-1?Q?vXlufsTtweh6yC/1h885L2/4sd3x3MpI1OYm4yI+DnSL3JOyQ6482vJ7VQ?=
 =?iso-8859-1?Q?JLcY6k0jr6aHi/PUIYK+AmVYEBnb21wvIMa30DWlWsmf/uCqlXNEB8FxNi?=
 =?iso-8859-1?Q?rqxJLJyplfgeul9jMQz9FKuY8SUq0vwbSx3vq6KodkebjEfwcUaL1A+mEC?=
 =?iso-8859-1?Q?tlo9MjFyMhv365rjJZ4CaOxPB7hw9xHW6kFL46VhvtmEKvCgMNp2C9Z1ED?=
 =?iso-8859-1?Q?cB2Do+p1BNkxdq9yDGer9WsB75TNx/P6Muzj/G+keGDXGzipI+cWVXp+Y2?=
 =?iso-8859-1?Q?Q4kqQ/+EX/NaraboOUPWhiq4ohGrFCep9PNCpIXjYOwG2kzzCIx0DdPTRh?=
 =?iso-8859-1?Q?warqhSBy/owdBiZuDi3PK8EoYeCbN5rmeOglFKZDI9CZ3wfezfdfv94MuH?=
 =?iso-8859-1?Q?nWSq8qV67r0n/syNKB+Bbj0FhNXIzVznHUpc48oNbWOCzTDa5344iFmZkn?=
 =?iso-8859-1?Q?OO1/zwCcoPzscjkxb0qfqc1l+fhV5AMqUmQ84Ps4PX4/Fkb3E0+2z3qDDX?=
 =?iso-8859-1?Q?O+VvX3qmTbsfSqoq+ACwHrTneHnbLGFVrAIFgkXEBcEJ1hAXbzhdL7dOZG?=
 =?iso-8859-1?Q?0hIeERgka4cvekXgTMbaWCHZqsJOtpntzheIdj6UHssV94RMRCNXFoeUwY?=
 =?iso-8859-1?Q?rjiNx0vINyScy1+h5kuuSYFD0rAqaW75UWPdCApDoVuEQfMSXzC1kC/EdQ?=
 =?iso-8859-1?Q?D3icFXk565X/oiUn2scWW2xeFBUlWqP9uBLrXOrgXi5S03o3CL/7D4Ju8U?=
 =?iso-8859-1?Q?xkuB/gEJ+mhpLTgtmjPTrCJ0TXjSJcAoPgvYBmZY1xOQrc1NtFpC4Ry7K2?=
 =?iso-8859-1?Q?QlfiChdIf2umnqAEdyvTnsqiY0UdRAV0c1Sjha+cgR1KViQgH7Bf4ozssT?=
 =?iso-8859-1?Q?M1GB/NraWWBMIqyHDSunNTn+KnREMHHCFlsiM0k8CFibKT+1cUc+aM7acN?=
 =?iso-8859-1?Q?seqfouuvV+aWH2Nd7EABSY4tEu2lOhA//LezX0j52pf6dQ+kyfQERPVF5t?=
 =?iso-8859-1?Q?TYgCelzAbvkNYze6FnbvroBlJzM9V66atuSz5AfdGoV/w34lOXbbfp5LX9?=
 =?iso-8859-1?Q?P/3yneJjkEvzHqsxa/2vV7NOeVzYar9WZMyG8BU3CUOeU4wtYwMNGGPpmK?=
 =?iso-8859-1?Q?R2fu6K1P/DdEvh+LRi0M8LQ42wZ0KC5AQ0QthoKLqkVbBmlGlbY6XflHne?=
 =?iso-8859-1?Q?dm5/rILs9yEOKL8lbWks9qQRFy9qwyIl9F4+C9k704HTuywarj96g6vOO3?=
 =?iso-8859-1?Q?QZGLiFQPLUrXi15n3MvuaRaXe9RlHmrUOgpAZw1XQKyHSXQqiBTunXSJmh?=
 =?iso-8859-1?Q?kXkNIKq5StvftX5p9lUjMI+JsjlW80AHeCw18gt8269zQl25YyWn8DULI1?=
 =?iso-8859-1?Q?ZtSaeJWMdooR0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: in.bosch.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 172ad096-0371-4879-b4a6-08dd6de2839d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2025 10:22:59.4516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0ae51e19-07c8-4e4b-bb6d-648ee58410f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: arJpo9f5mWIvMbYRn7mS2P/jLT1ohmJZ2pM/Aw52NKkSSTOajcJWhDA0O+dVsYKzKDq6YTK7DTqnTnGtRHKuxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR10MB8419

Hi Avri,

Thank you for your insights.

We understand that vendor-specific query commands can be sent using the ufs=
-bsg module. However, there are a couple of challenges:

* Some vendor-specific commands use unique msgcode values that may not be h=
andled efficiently through the existing ufs-bsg framework.
* In the Android system, access to ufs-bsg is restricted, and not all proce=
sses can communicate with it, making it difficult to use for vendor-specifi=
c extensions.

Given these constraints, exporting ufshcd_exec_raw_upiu_cmd provides a more=
 flexible solution for vendor modules to execute necessary commands without=
 modifying the mainline kernel.

Looking forward to your thoughts.

Mit freundlichen Gr=FC=DFen / Best regards

 Selvakumar Kalimuthu

responsible for Platform 1 projects (MS/ECF1-XC)
Robert Bosch GmbH | Postfach 10 60 50 | 70049 Stuttgart | GERMANY | www.bos=
ch.com
Fax +91 422 667-1208 | Selvakumar.Kalimuthu@in.bosch.com

Registered Office: Stuttgart, Registration Court: Amtsgericht Stuttgart, HR=
B 14000;
Chairman of the Supervisory Board: Prof. Dr. Stefan Asenkerschbaumer;=20
Managing Directors: Dr. Stefan Hartung, Dr. Christian Fischer, Dr. Markus F=
orschner,=20
Stefan Grosch, Dr. Markus Heyn, Dr. Frank Meyer, Katja von Raven, Dr. Tanja=
 R=FCckert

-----Original Message-----
From: Avri Altman <Avri.Altman@sandisk.com>=20
Sent: Friday, March 28, 2025 12:36 PM
To: Selvakumar Kalimuthu (MS/ECC-CF3-XC) <selvakumar.kalimuthu@in.bosch.com=
>; Bart Van Assche <bvanassche@acm.org>; Alim Akhtar <alim.akhtar@samsung.c=
om>; Avri Altman <avri.altman@wdc.com>; James E.J. Bottomley <jejb@linux.ib=
m.com>; Martin K. Petersen <martin.petersen@oracle.com>; Peter Wang <peter.=
wang@mediatek.com>; Manjunatha Madana <quic_c_mamanj@quicinc.com>
Cc: Antony A (MS/ECC-CF-EP2-XC) <Antony.Ambrose@in.bosch.com>; linux-scsi@v=
ger.kernel.org
Subject: RE: [PATCH v1 1/1] ufs: core: Export interface for sending raw UPI=
U commands

> Hi Bart,
>=20
> Thanks for your feedback.
>=20
> The caller for this exported function resides in an=20
> OEM/vendor-specific module, which is not part of the standard Linux=20
> kernel. The intent of this patch is to provide an interface that=20
> allows vendors to send raw UPIU commands from their external modules=20
> to retrieve device-specific information or execute proprietary commands.
The ufs spec defines a wide range of vendor specific query commands: 0x40-0=
x7F, and 0xC0-0xFF.
For those you can use the current caller, e.g. ufs-bsg module?

Thanks,
Avri

> Since vendor modules cannot modify the UFS core driver directly,=20
> exporting ufshcd_exec_raw_upiu_cmd is necessary to enable controlled=20
> access without modifying the mainline kernel further.
>=20
> Would you prefer that we also provide an example of a vendor module=20
> using this export, even though it won't be part of the upstream=20
> kernel? Or is there a preferred approach to enable vendor-specific=20
> extensions without modifying the standard kernel UFS driver?
>=20
> Looking forward to your guidance.
>=20
> Mit freundlichen Gr=FC=DFen / Best regards
>=20
> Selvakumar  Kalimuthu
>=20
> responsible for Platform 1 projects (MS/ECF1-XC) Robert Bosch GmbH |=20
> Postfach 10 60 50 | 70049 Stuttgart | GERMANY | www.bosch.com Fax +91
> 422 667-1208 | Selvakumar.Kalimuthu@in.bosch.com
>=20
> Registered Office: Stuttgart, Registration Court: Amtsgericht=20
> Stuttgart, HRB 14000; Chairman of the Supervisory Board: Prof. Dr.=20
> Stefan Asenkerschbaumer; Managing Directors: Dr. Stefan Hartung, Dr.=20
> Christian Fischer, Dr. Markus Forschner, Stefan Grosch, Dr. Markus=20
> Heyn, Dr. Frank Meyer, Katja von Raven, Dr. Tanja R=FCckert
>=20
> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Thursday, March 27, 2025 5:28 PM
> To: Selvakumar Kalimuthu (MS/ECC-CF3-XC)=20
> <selvakumar.kalimuthu@in.bosch.com>; Alim Akhtar=20
> <alim.akhtar@samsung.com>; Avri Altman <avri.altman@wdc.com>; James=20
> E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen=20
> <martin.petersen@oracle.com>; Peter Wang <peter.wang@mediatek.com>;=20
> Manjunatha Madana <quic_c_mamanj@quicinc.com>
> Cc: Antony A (MS/ECC-CF-EP2-XC) <Antony.Ambrose@in.bosch.com>; linux-=20
> scsi@vger.kernel.org
> Subject: Re: [PATCH v1 1/1] ufs: core: Export interface for sending=20
> raw UPIU commands
>=20
> On 3/27/25 7:46 AM, Selvakumar Kalimuthu wrote:
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c=20
> > index 78b57e946cdf..226cc90c74b0 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -7360,6 +7360,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba=20
> > *hba,
> >
> >   	return err;
> >   }
> > +EXPORT_SYMBOL_GPL(ufshcd_exec_raw_upiu_cmd);
>=20
> As I already mentioned off-list, please do not export functions=20
> without adding a caller that needs the export.
>=20
> Thanks,
>=20
> Bart.
