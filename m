Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26408219304
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2025 11:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740398157; cv=fail; b=aXI3tuI1bTZMf2/88hnKifyCot6A3z/eVI1OVjSrdwa0lhFMSrjm/U+AA+bsJpOS7MYXJIo+4SGvXbFJOjvlZi2l3DZbTtubLASEYEW9BGhDHToSl/y2CLhGdNDZTQ0o98RiyS9Q09zap5KYIN7OZ50kcDKdc1IkHzNfFapo19A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740398157; c=relaxed/simple;
	bh=RKGSshpSSes1hIJO3vb7/S1xEjge5h1Wg3pWqh5h5EM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CQkn5i9dCaK7eVJTAhjRFOsNSELYlxwM6oKbtBAP0M6gY16acdeYa1wMbGLyKt0NO8JmeuIVOSvTpH/jwE5Ga44vrrXrgHxvzjLpWVQlxIyIbgy8vlnpJKowIaLMRa8vyXPKcDjI3tHC8p5JoJTqmKPwbc3vrqdRuKZfk1ddOYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BLKAf2iO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IW0P7x2i; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BLKAf2iO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IW0P7x2i"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OBMZBY010007;
	Mon, 24 Feb 2025 11:55:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=/0nDxWzWbbl/1+8nxyminTE9+UfgzKemMZvQfhAm2jU=; b=
	BLKAf2iOKi9kNH3sfPC16kvFk+3MWCjWrewpIiOg7eFAjFHEZXWTF0IjuwZRAkFf
	aIoEp6NpicszOh9xbQrUjSNz4/8yAuZXHQYZf+35gJMYT7uaf7yro5yjjNH8stRL
	6WzShpTMUsTbK3FkuS6/U35RA1PKz/WSNdyLfFMq3Z0QJ66MNUUX4M+MJM8w32vR
	lIrNS91V2LENl9YvPVCB/+3vMpCRFL+FOhntL7e6dQcUjtBluGRp45vvfD9LsxF1
	+ZNeuzNSNGTKLCYa5IJmpiuMkLeRSMS+5x3V7A+E876oPeyhc3/OIinajtBVrgYW
	YkZhd2yFtkvJ+GA7+YS4Fw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y6mbjdcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 11:55:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51OAUq3Z008183;
	Mon, 24 Feb 2025 11:55:32 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51dj5ph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 11:55:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XTKEUou8A5aSzDVFvWwuEleobwIsb2/o7g3evGJn/nHQQczB22sSWKE8UJaAiAPXiovyoU9+2IK+uNa38ZIiei/5h+NJ8s3/Gz4WqqkNQ985D691VkMiW1tOY/S4LmAmlQyEkaGy3/ko4fiOy54R4oIUHdF9EVRiDE9c/qjj9imszwQ4/F1tF/0ygTLowFlc7Gf3yk9Ju5JcCvl0lDqV9uaubXKkQhgsNkLaWAy+HlwhfKrw5skOAsypy7SoP7zoj3RJMuFPatcI1MEOQmv6Zzwk1Z6eqerlpxpuAcCcbzr0ePi5X3sL+NCAwJRf1ZEMfPCvufuXrTculgyz7K2qRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/0nDxWzWbbl/1+8nxyminTE9+UfgzKemMZvQfhAm2jU=;
 b=bFk4y3dXp2Jf4x1zK56O4ISTL+r9fh+uSamK/0MXFOtQek08jRU3jZp3ltlWgKR6lq249cNb64Us4hdtYwVFZvyXISCb7fzJCL/ynJOrt45bk2WtbK2VEbNUm+7tXpZOjkiUYx0CZRvcd26VZySApl4pcC8EVbqKSZX2C4YS9R0uRpqxBQfVHz1qkfmax3JudcJP9+awcMLdHT0kwQEwFY6bQpldXYkNzK0xn9s8ZcToWQJtXn9C291G3SfbKagq15r3sgGSATReqKNYDyZQrzjIpByg7/njIeIkMsm6OUQz7f47p5Fq25frbSYqtswjOcUjQGJwj0HBm0V1u8fRVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0nDxWzWbbl/1+8nxyminTE9+UfgzKemMZvQfhAm2jU=;
 b=IW0P7x2iJdHEox/Dlw+FZD1kK4YDyfBvJ25fOTnQnVtW1cuEwqcs5h/ncmsPLZwaIL/Ey53cXYo/BX8PtkG6RlgFApa3iE0ejAkXtnr/ok54kYcVRggA0XGK74kqIl9b0uFEPGtoQKtu2Puhj64w/V18bQouSOfuTu7ZNi3HUIE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7218.namprd10.prod.outlook.com (2603:10b6:930:76::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 11:55:27 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 11:55:27 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/4] scsi: scsi_debug: Remove sdebug_device_access_info
Date: Mon, 24 Feb 2025 11:55:14 +0000
Message-Id: <20250224115517.495899-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250224115517.495899-1-john.g.garry@oracle.com>
References: <20250224115517.495899-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:208:52c::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7218:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e2a8b74-43fd-4460-41a1-08dd54ca20f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uq5uMJHY1qiJ7KxZNWkOY77tmwIQo+WUzfphLT2x9TuRfojwWpodu7Vj9YJc?=
 =?us-ascii?Q?A22h9jopF6DkYzcw7whxq9bq6Lr78ZXjwguxA49xA5617jXs9zj1b5JNGYJO?=
 =?us-ascii?Q?rnLSlC/iYvfRtZKbhEtuRcCFB1bnPhP8bqyIttxlKJVkPi86w+emAWba5RIg?=
 =?us-ascii?Q?L1K3JfiTL3Fkh6PslIhhkf7kggEhqBdAu7W4kd0CL8ACFPCXBdquW5GjoaFj?=
 =?us-ascii?Q?TOIWEH/eZtyPa5KirLicBnXLiNCtyeUgORQ2Tt4908l5MyrDlwAAQB00VB4/?=
 =?us-ascii?Q?z2VaNXeyWXWWi4E8tBdYLKcfv6y9TJnkcCDUbiGEsiiwIZporkoN1dbSWHT/?=
 =?us-ascii?Q?gZeMCO74tZyk+g5DmRxnoKulRL0K8TpMii6lWr9WytcsHC7ko9hJZFU48dqK?=
 =?us-ascii?Q?emT4dbDvBfmm+uoPtsi18/Y1CQYfndYeMQ6fSwWAbxeyH0uBzpTqynygp3BO?=
 =?us-ascii?Q?AdWPQDpj7oWYKDC9/K7knlQc5Q1ZKezv+C67uROPz5QMLF8Gmsyi81eLFpwL?=
 =?us-ascii?Q?9fxdYvQhUEhZ4D1d4QhPtgaD2KMM+/FWMyqHCbN5utV7Z92pux5iacKj6qF3?=
 =?us-ascii?Q?Rmi0PbZCTDazlOP0zORis81KxBBMiz3DmTlhEtU2Mvbz3I7cLUJ/rr2S4ijx?=
 =?us-ascii?Q?suaYeunhQEMqbxf6mbPvne/OJzfrQmqnwVwwjWcMODnh3DasspK7H79CqOgJ?=
 =?us-ascii?Q?k+m70TTMXvYWxNJSyfbgRLom+Ly5Jh3JIxNoWdM8ZKdn+NnoRbNYrwj50gzA?=
 =?us-ascii?Q?t3a/ytxq8mdRmTYiDE3cfLr6hgfEQRmpzKXjiuyfzo8SLC0BrCe3+erXxyIn?=
 =?us-ascii?Q?bU6MnH5V0bJui+RX+dHpSHrn/Hx3wPFCI1vopCgfKBag0TA0wzV0fsZfJ01P?=
 =?us-ascii?Q?GC161ljLtJkC+AaopAIRmbsw94CZQyxXCfKSUXP7ieQjhonsoYozOLsfle+0?=
 =?us-ascii?Q?M0JWUvR0qxPyOEdFEm73Lpgbt7oExLneSWyoMyhEaN/qJ8V9vCFGAzFVb/V9?=
 =?us-ascii?Q?8rw/tfhfFa7MS86x7dKJSi1r3Qnzpn0FVb08Cd7elhCC+YwnvLv/Ubtus7k5?=
 =?us-ascii?Q?MnD9mXwyjX4z4Wo0TnsyL3VfdKMqjLf2r8/HPrHH/vWwR5n4E/sIgMdDRpBB?=
 =?us-ascii?Q?Zbdh6TFi93Hmh+RC8/ZQKZ9p3B+ERVFZPCGoRKkpZT51nZ3kYeKSu9jTcKA8?=
 =?us-ascii?Q?NYrkoou2VAS/ZFnH7GpatqcIHHiKe+rtHcCq+dce6zo35/w0N3IXL+tmMfd7?=
 =?us-ascii?Q?Gx67TdTqoz7ABegKOPhoh3x/V8/aLDykrA3rxK7A+GvGvNRjjnO0iKYFd5n5?=
 =?us-ascii?Q?oEYEbSmccFG3t1KGZBi7lZ8xEvuv2kV/30dYE1v2eEbMY/o9n6m51xfRy/iG?=
 =?us-ascii?Q?bHUupol+rBqjkxx9BP8h/ywWj9WF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1zs389JoTuuS5WFJCJ1ux2cn5sphOsIRWoOVvlYDkxxJpKO2pShVZhEOhcij?=
 =?us-ascii?Q?WvQ6LQ64NEs4ytK94t3wBMWUn7xe466RJWKNxlco2DsVVRLfyDIWIAYeJAUZ?=
 =?us-ascii?Q?sh43s3bH9ZLajG00IWFifs9syLnGsfKyH8yh70M50iQNmafLotGSLKC98xPL?=
 =?us-ascii?Q?bEHyGYgHAbNZorjy66q46dDN98vQkVbGou8DXfF4Vh+osvbfaTFjAjOSJEDP?=
 =?us-ascii?Q?O5cXr+e71aTUfr6l5bgY+q8X2oPwDQaP4vgtDGzKJAGsY/rRtv9+uiyYVZeH?=
 =?us-ascii?Q?zLSdOjYOBQ1y7gY1gOcNYDnAvyC/wgoWxLiS4nkNIj9AG8Xx9Sc/e9/XglKa?=
 =?us-ascii?Q?KSamqNCXDXYxzxZnYel75Ct/ni+QkgMWeF1gKH51yb6d/EVMvX13laYTR3ps?=
 =?us-ascii?Q?y1c+tEfi9gxGt5itEtTjJ0e4KuO0V1yh4QCo+FRjxiQLdNABqqW3zkBNUu6f?=
 =?us-ascii?Q?DVsefHKIZBcT4I8O/PK2M3NINuf7d5lvIiEDP68Ll1HRW+colelyvrtgQJZm?=
 =?us-ascii?Q?TqYxDuIZi8JnAGvTeaBD8oW2ACdvZya+oW6COqfK/AOVVZoZREex3HYTy26S?=
 =?us-ascii?Q?LonXFGickl2xzoeRboAw34c+c0gFacyuPff3gECeOJyIgbYC3qv89nSMJRpM?=
 =?us-ascii?Q?1pRt4C8d3Baez9RY25vrhaWjLqeyoRh38kZHBOsTf82iO/+n00j9pyM/3+pa?=
 =?us-ascii?Q?Siaq1FA1l942/3AH8PsPdRzQCiLHEuAzDzw3fmsIRD4I3MV6ZVyirauI0p3M?=
 =?us-ascii?Q?e4TBt75Wo//aP6UHoqQXQ2gkxXkbCYomyb1cHqkx47pQaxJSdXCYZ8P3Lzj0?=
 =?us-ascii?Q?d0DzRT7mTMYtZNpEkKv5rXzLvhtVWIW5G9ezT9J58Bvua/h2aMqkdw1WyzwB?=
 =?us-ascii?Q?ZBikdhh62cbN0Mc/zy/m961kl0Z2X/hJW/mnzroGT8B6ns/MrGf5lybOSfs0?=
 =?us-ascii?Q?OExzJOHhJiFBLVRChPzpE8IdurRTDccC4xEdiE/Q7C1bqrwoAQdkL/EBQIQX?=
 =?us-ascii?Q?/tHr8LKqcyj0aFlIeW/DMh+9ayCIRg8/vnh3qVcaGEXo5yOFiQs1d26E+ptA?=
 =?us-ascii?Q?5DFYZ8pYO/lk5Anman9aOqtPn0hEPnniKu46RMylYEIUfL+5JapK3cY6ILQc?=
 =?us-ascii?Q?H15a21Gnymp73wxjzWF7m39LxB2qsIJj+Eh6EmzT4FNbc731Hn1mEdEYTQaL?=
 =?us-ascii?Q?y1OcgFRUsoO3luLgBFBdHxtQRGDwcPF7poPx4dv9KaExhlN9fW7nCbLh2dvX?=
 =?us-ascii?Q?zO5ex4HqUAyc/VcFCtsPeA64rV8KXE4ZBIm5qN0feKmsd2hb3LJ3sGIKq5ek?=
 =?us-ascii?Q?ZV+IMIHh7Qm01F5GuSW+311KI2E72d2Tctt0dR3cRnDTQptrCIV/gFmC2+vF?=
 =?us-ascii?Q?UG1nOr1Tx8wvBcUM5NavZGKOAop8OTiLy0qT4AaKQUZZ4385KDviDQH8NUqK?=
 =?us-ascii?Q?wm35Pa3m50mGe86nRwxx5olvSnbtEzEL0Crb7p+RRYVDOwt1Gz/98NzJSvST?=
 =?us-ascii?Q?Uewz1nqa/qpcKGGoZgBN2plhStlp1ls/DIxhna1B9NYSfj3MvLCM04hXGcK3?=
 =?us-ascii?Q?RcXWBpvap5HCEFNWlzRJaUYz4G0EQj/WWv9ZuBbGve39vpHi7TDXrNCxJeLC?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YQAzcugKN/w4p8O2YErLoLmN+GrPFCfCa1R2HtMSdfSgppNKumW5LQvFje4FAna3Ls0ZIq8QbES0vmd1mivWo4yw/12PHj7eJklGbv7+uZCgp4hR62dtwFKQ5LdnZyGjlSR3ZLoQkXbPEUjbKdcU2UEPXJ9VzmaiHmk2JsFZcXYwOI8d28zngWrYGFrRaavbOBE7GDb6oMllo9kGd/EP3dfljrFqqb35i7+J4mECUIL6ifaO4mx24gFG3K9PZf7zNoxzIMCkpLQ2pluSgAcESsScDFUzC0OT4BiK622HmNAU4Jr+98CkjFn1j0LUpEPWSpk5TEZxiyg89hesZ2K48wQu+bi2+A3PTF9W2Q5J01OltoWMEy6y2ckOAEm8Y1MlA1i/N3tb3N2NR5MOnFDS2/bPlcGbz3WLuLfFxen1fMb8Acc5Ly7QDhALNKJ0lhm47onNbwrtIqDbZkggOyVyFWxwxMUQUhSS8cX0Z/5Oi0bSEf3ZRsBZZSX7oYNbCPt4pLlvhLu+RVT2MB8eIV5BAEEfeReijx48uVRGnuDEXe+EZLB3w1h05eEI4rj/IBiCuAFm771tvB91BCsWoLh0k9BJGwqOmgtOaf423vmAjM0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e2a8b74-43fd-4460-41a1-08dd54ca20f7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 11:55:27.0780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pA2w7ASF7jAGPuxncMn+hnXe/p40p1XRfpFF0i8/xSizPwIth1i03po21wcHLpqXTYHow2RL3RvUFuqP5BTM8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7218
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_05,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502240087
X-Proofpoint-ORIG-GUID: bCRzsNRAshfdBwzBRQ1MqsBc-R4hKeI9
X-Proofpoint-GUID: bCRzsNRAshfdBwzBRQ1MqsBc-R4hKeI9

This structure is not used, so delete it.

It was originally intended for supporting checking for atomic writes
overlapping with ongoing reads and writes, but that support never got
added.

sbc-4 r22 section 4.29.3.2 "Performing operations during an atomic write
operation" describes two methods of handling overlapping atomic writes.
Currently the only method supported is for the ongoing read or write to
complete.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_debug.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2f60ab9a93bd..e3ebb6710d41 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -460,12 +460,6 @@ struct sdebug_defer {
 	enum sdeb_defer_type defer_t;
 };
 
-struct sdebug_device_access_info {
-	bool atomic_write;
-	u64 lba;
-	u32 num;
-	struct scsi_cmnd *self;
-};
 
 struct sdebug_queued_cmd {
 	/* corresponding bit set in in_use_bm[] in owning struct sdebug_queue
@@ -473,7 +467,6 @@ struct sdebug_queued_cmd {
 	 */
 	struct sdebug_defer sd_dp;
 	struct scsi_cmnd *scmd;
-	struct sdebug_device_access_info *i;
 };
 
 struct sdebug_scsi_cmd {
-- 
2.31.1

