Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7FB301014
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 03:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765249534; cv=fail; b=OE9lLbcHYmodj36bXCHnePknBdSJSCA+k4CGOzTu4j0aIKUAMdHTxm4v66nq7cZLsqsuMG+Ig1ew3FAw82uDc8X54CLamcb5sSoqjZ78SmkP/TSSCffYZN4VeNvDN48NsYoVgtEKXZZ8Ymz3U7zjbfy1+d0U67pmXy4E1rIY3LU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765249534; c=relaxed/simple;
	bh=ScKP8XPDA6GJaHIdW2jQxMOo1Ge7+el5+D6BiFt5xBk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=jSBUCe1ZcRcp93hlvKkl263KFn+jfDXrPieAeWYLoSwMsYp8ubGd+HJcG7STe6x0bsoIT5VpQLwTeTnbbozTO42I2IDuexUWTEGKhlYpN5yybAXOWdSDRBdpexIQXjsnRfdsOxo6jtp5NGIDZ+EaB5CV5ps+v8Vgv70oOozumno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UK5jFrBo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cmj/BmRo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UK5jFrBo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cmj/BmRo"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B92vBRg3947815;
	Tue, 9 Dec 2025 03:05:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=z3iB1oT5DaJurSXAd7
	1oUKcnRBnlnEbMVKA1S49+Pn0=; b=UK5jFrBozpuSDavCOq7KcHFHhbqOZlQ081
	dL1Ub6rGUL2uNuyApbeBAdqa0Ho7BcBqyvZB6z/YCyk7tx8Ow6EyVUvVpjllFrwe
	4NRXj6AFV2YTNcJLdqC7xLixapjMfnklY+RMbyUQykSyu87ykw42dcnNE6bV06bf
	Tg+cHkTXHRflYfqcqmXV7ZWw9E/RUZMtgRoKTc3n4UlohdV4YmXll/uvDh/WCBI0
	8wXGXaDhU8UePTiuusRq6vsj2xle9oeY2Azo6IxoRmCzjZ+24Zfx3f9eVnf48sLL
	QB/3cBxUEGyoakSdbUeiPVPU765SAaEf+OTUNdZKUUiY/JJxTTig==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4axbe6r06h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:05:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B91uk1W038161;
	Tue, 9 Dec 2025 03:05:22 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010046.outbound.protection.outlook.com [52.101.193.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8hnxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:05:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pLhEWVj7DOyLN68cvVLsfHlnMeEdkCaX76o63eLUMBvyuJGKBZzmcxDoXq+qgxdNRzJcSHbHw3tns0Nx/j9abKgJfcAUSWd04s34zIHO8L9ttVjZrASn1pLVKnwVkMEiskT2V8VcMDO6hCUDc0lU4wTGGIbQ1XKYbbVBnHSrHVIfgW7BiEuZb8mXgyhEcZscVWWQuWpIHfdhgSHHg0ssVRW05dmvFer3OUerGU8rF4+Ftgehv6J/SB3o9hS6JEq6Oo7eyRI/D+KujLhYl1kwVWFrIwydg+7/Fo5cPJIEb2RiO7JNAXLtera9E+wkUXJD7/XocJ7msR+fIaplavUkWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z3iB1oT5DaJurSXAd71oUKcnRBnlnEbMVKA1S49+Pn0=;
 b=QEyUmPw/yWZDLZeuBs1rfu2nu433z+WHN2U7g4xywOFebrkCFr+0dhDHm3hSh13Trc3T9UFUGa4A4sLMyUFOw1N8clnl9tdH0aD7NmOUAka5jNEjIHjaBCnfMBtsaZ4chlKSQJEdciBe5GvzwoU6FI9/y92EWfyEL61nzqAhvc70dElpcM8qp5XskYIciNxHE5hpTZPD7P+OVCwCL4iaXgPGMoe+KSdJE/0Ov2kIWn/q7oAiOOPAL95eyHiYku97+8/f6Dl95vc6HHumjE9rf9vJNy9b342icprwdC2N6ftyyX8PHGKWNPxTIVGY6CqUp+YarzbSkKskXeNp0chCNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3iB1oT5DaJurSXAd71oUKcnRBnlnEbMVKA1S49+Pn0=;
 b=Cmj/BmRowmyXDnri8qQ9yyxFH9wIZzmSQMA+jgolA+zt6CVv5nhtGq3X4VuUCak8O2xouRDMZLilzBp3CddAdhTYHDeP3urecLKgnth4+ZNRpZZvPf64S8aDEquh5w67KDBLSeK3KlsmWO7BJPSGEo3hAF6hcACu/pN7HH5p7gw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA4PR10MB8517.namprd10.prod.outlook.com (2603:10b6:208:56e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Tue, 9 Dec
 2025 03:05:18 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 03:05:18 +0000
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mikulas Patocka
 <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, linux-scsi@vger.kernel.org,
        dm-devel@lists.linux.dev, Martin Wilck
 <mwilck@suse.com>
Subject: Re: [PATCH v2] scsi: scsi_dh: Return error pointer in
 scsi_dh_attached_handler_name
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251206010015.1595225-1-bmarzins@redhat.com> (Benjamin
	Marzinski's message of "Fri, 5 Dec 2025 20:00:15 -0500")
Organization: Oracle Corporation
Message-ID: <yq17buwpd80.fsf@ca-mkp.ca.oracle.com>
References: <20251206010015.1595225-1-bmarzins@redhat.com>
Date: Mon, 08 Dec 2025 22:05:16 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0006.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA4PR10MB8517:EE_
X-MS-Office365-Filtering-Correlation-Id: bbf1a2ac-3bca-438e-cedf-08de36cfc873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WdKQ4CZYV+A+Q05WMmJff6pSo8sFUXjc4yZpXDQgwRFKTjoHW/PW04Z+lYQo?=
 =?us-ascii?Q?Thov0ScuuVyfB+dtUd9H1ZgoPPR+mBvIe8XOZx/WKPkvVYXUNIEd4/cr6eun?=
 =?us-ascii?Q?yGsOo+9pbMZ7jrFt54icd3cNMJcDwCMuJUl3dP1PRil6/fmayGkmG+b8c9de?=
 =?us-ascii?Q?lYK3/J7DApgK1gfLC9YxwjISTFnvhQAZsVQWc3RQGcrrbiYMVwB9jfOiFZZ9?=
 =?us-ascii?Q?OfauzPc7LARUhLfKpYEVkk2RtLV35L8q6sTZIftMNE22uO7Y/dEhjauuv5Sr?=
 =?us-ascii?Q?SvhanjpbNr6TQeE+AWNdoTM5GVMrcl2Ak7XRzuCrOXgQBFopt22R5HGTASAR?=
 =?us-ascii?Q?VqaFIJnSwvib4QiF5aJPTCD2/OpuYVGsOxi1Nnj3sLcy2ZIRiXpMqPUmCf9/?=
 =?us-ascii?Q?PUFLZo+NgztVvPjirSdFdnWtfvb0TpMwlZoMtmiN/PdXU0uDVy/ECQzmht4g?=
 =?us-ascii?Q?vYgkJghIhU6vEXMnTx80aH41g9AViCzhVNprAnHMmCGWCvlCBIX/EFLVDcPM?=
 =?us-ascii?Q?Wrj/3qD5vOLL7r5erD5BmfAGFgm8JVXnQAoP/xqjGcZeJszdFIwbxoCpN9Ck?=
 =?us-ascii?Q?UIJJ7+MWoVC/IOggFjDxx+5gCY78jCgmKWlBb8/jxnq+ijIr9MTVJPchPmWq?=
 =?us-ascii?Q?nlLC6z9E3m+OIkj9byGIcr3dqORCvl/xh2uENpZq2hNqv1E9woguerGqFQJp?=
 =?us-ascii?Q?ciS6nJ3sGPVxp9uyJGBUz4RpMvr0pnZmUl4DZGVgKZvYGcwtW7qcIAlW30tO?=
 =?us-ascii?Q?hxWpnD75BtHNcSAJr0YZLR+ZWTJ3zSXuDXQh4YXEsL3XrJi9gIRxY/TkJoRo?=
 =?us-ascii?Q?SfCZ0ja/VPYXUVyKvj3MH9BF7pbw7xbyry28St6gOQPQeCV4nqwKaxzWb3Gl?=
 =?us-ascii?Q?IbHxoLVUXXf3n5QapO4l1at68pS7Xg60kKoRnCc+be5TEbAauc1YJlEx3ylb?=
 =?us-ascii?Q?ur+ch7Xpz6dugKtdQvuf4twDGtSBPC3cKwmITutAZSVFpNttBt77S1kfeX/V?=
 =?us-ascii?Q?HdWRFKRJ76B26qCLMQ35QMbwz1hStsN/EiouL7bNRRcLmtCkbwINJeEaoGes?=
 =?us-ascii?Q?liOCZxCX48fmbUDZlq3lSanTLaRePeQQiEZCij+yrBEcRni1Ed+Cdusioa1+?=
 =?us-ascii?Q?OwY2TaBZqp9oxgavt06biRMVpTDrrPxHQVCXOUsfC0XMe1VBUqixWnIIQmwL?=
 =?us-ascii?Q?g1/V3M4H/St5d4IbBcG5Gf5SG3oJRvfAVWK2hVXMYg6/WZiuyvQhq1Ze1Oeg?=
 =?us-ascii?Q?+iq2nwm24kJCTpM19ydp0/kK5Nnc/w1b6sBSAmTXgPPnpsJFn+WAbe9zlx6R?=
 =?us-ascii?Q?iRs+ITGjDBNJAAki8ji670OswnRiTVINDEVW8wRhgaVpy6x4tbpoX2R5al8r?=
 =?us-ascii?Q?odc2v+niFp/U7I6aKMh6NwyG04X3RCyKfARUJfj1Br7E5JntQEBJzxCFNT8V?=
 =?us-ascii?Q?j6TNWI0rIIFvIGGiOkH0ha0iX39cUq19?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?85hGjwXc8w5jYuxZdNOJFEUKvuFDxdj3NEx9ejCslgRYORwzH+lq2gUmasoi?=
 =?us-ascii?Q?yDtxs9n15Bp2qvJ1LWHBdvVCeeqBxRyZ4VexgwFAFgT+YMqnm8Ngx32aZpAc?=
 =?us-ascii?Q?ABYlXSLxVjoDCSuNLJqRikzXK0Uf2IdqGi/P8Pp3BrfzYUodMR/nQ1vb2DUK?=
 =?us-ascii?Q?P/Wa8Fpe+Lwirn6krDxUdfjcZxqwK0Ho22PAUe9qQ+3bhyUo0LYroecvHPpi?=
 =?us-ascii?Q?uJd2lrEaYgiPA/jvXD7qgxP1tqF6qV0v7kYwDPf1scfhY/WoTGi+HXmw2+lN?=
 =?us-ascii?Q?4tlLWAFmb9M+B5bEAWlSwfzqlzrN+81GGkQwH8BCG7maj+aS7wlY2a4h/LOm?=
 =?us-ascii?Q?hmC3cvQTdVNgk5gcRa5C/6oqgDbcYkUZGk4I7rgCxAG/ToUGH8RCVfUaj2fn?=
 =?us-ascii?Q?vZaZTTKO9Ah+4DhQYgqvFCG6qvxFW1wEvCqIh/h32P2gbMGX6qtlBSRB6Jzy?=
 =?us-ascii?Q?Uas4oX96z9lkIHX+98YhuVwmnth9/haOkS+1hpYYeP1zT/xDJh79WIyyWdDZ?=
 =?us-ascii?Q?QL0v8yzAzS5Eq3YVZfNa/rrhZ3V/jNCfSWk56RuCDRFN3XcByVL5YSoq1Di1?=
 =?us-ascii?Q?/X1Dy6rQ0/PhsBkoMgAD6I3V9kuLsenw8oKIQR6MBqxV5nCAPNM90UOITYGW?=
 =?us-ascii?Q?PrdpKMoywkU6XLL3R4LE9J0RM/CD+vv7yKfau178vDEb0OcPrAxImEkiHv69?=
 =?us-ascii?Q?ohPNwsh46q6crptLcVQT9zlqn+KGcc7agDEtGoaI0X7a3O75ZdXXNJPsc22Q?=
 =?us-ascii?Q?G7wpf3uPvcanyF0ijKnnnaAyEIwLQlSE53io8rLPbUiM9EPUkX7eqavx+Zzz?=
 =?us-ascii?Q?ELrHJKSMoBsL+qddftdz4Rxl/Mfe7WRFJiTjKECaMtQ1Ycr2EcNk1LzKir9j?=
 =?us-ascii?Q?H+/zO8hX/8/2++zh87owRhe9RDmBWpixgPbhPGFPZZp+skChCzidCHGfEyiW?=
 =?us-ascii?Q?BPGbAewIeTHbH3rMx1+17bk7CjGF14BwATxoxhlxVU3ChzQqE1+dFMZhsjzX?=
 =?us-ascii?Q?Oj8lhJma9N10FdM8zq6KTpUrOa5K2fyYb8+ow862XB6HwY8g1bcBOQTYKrjW?=
 =?us-ascii?Q?CP5NdvJnCiNe4EUTwj/pBdLx86zMp/WQG+2kPzjzumKmZP2LVKjHgLJE8vgU?=
 =?us-ascii?Q?rDErOCfbyPG9bNwWNGNZJTV99OO17GoCMY2TaAvB7HH5thjQNYuXV2MvaUco?=
 =?us-ascii?Q?rLuPOUEvJKGKMR2PyJdJ6VZVdnfnIaGOjuacyKSYkAkvtZVq8Hd3Fl9chStk?=
 =?us-ascii?Q?6+3wssBiImtBXmtUf4I4F2DGJpvpLFfuEUhegfzxbRRx3/EoMlUvq2018QYN?=
 =?us-ascii?Q?XZZDkWqqry70+6l27uE/nVGcJ8wdRnlnekIURSM3d6LZKCu9QcYtt7oHYhv4?=
 =?us-ascii?Q?0yXEk29GgQnvUrfbb5UQ88huvs8GHLBaLuaZgU6qPZ9842bK5vCmalAusVKU?=
 =?us-ascii?Q?kPJK5o2fTMrfR55MqulMs5qsZBrBdTMi+VxRDptZr1H8a/9OiuUGLEyEp5cm?=
 =?us-ascii?Q?P3BL1ZQgbkLTzcmpb4aKp66hV9drFYksa1oIoozsBwJbI+h3kIpT7s+2myyK?=
 =?us-ascii?Q?8r2/MW1brg9v8/JkF+52jNcyBSKfL1dBq0tyCsAHP68aIy6dPAeoupsyfQky?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EIu3OJEJ91ZforeY4Tne80u4AnzSjDT3BfJvn7ttvAsqfTFRYrDEiGg/0gqKk2gj+9Nq+VvkxbNWUdheXP1Q/lGn8LFqoa7/CXo/KfRm0RdKoqjwEs85hQE4c0J3a9aJFOCNbGoxSMebTE3M6XdL04XsoiX9LDnOF0Q782ZmHpFR1zgIKN1TX5FmiPuMicUqHYA2c+gdil1fb3kBiQobr0QV6SxXlYVNd7EjUAMVG05XBMPeOMq154h49csfvbVjMMFYmf7f3arpq+jb7omL19i5iGuxq0L7PFWhY9MiECYmrgRrkHhcZgeqF2TGeY0QS5B4VqzxLdWgKY7n+2ypslILDC9+3ZJDPF1nmv0qw9SH/Drs+k4GmowKHllkHuIiwMGYlss283qnacib4ZO8QYxwuwcblugeQ3qnrB4WiAi8KOIr2zPH8jx+xPKI68yLG1iCDxqzaVYhgsPIZtfJMQLJE9QS/f+fv6HQw5XoQKZ4UA6k7mJnqN1j+V0NV/no0rFcJylW65nb3PzIGuPqD35SJ7QzC97EYTlfxcSokaEu+djK/aYxMvEVoT1cxrOWjR60ienXTrk+tCwOCRdBssh6Liiah2/5NwCZLXK61F8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf1a2ac-3bca-438e-cedf-08de36cfc873
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 03:05:18.3490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUc2DMcnb6EkgQhiaWWC+dchZtWPb7+wHYqXAGmCc+ZE7Jwx5I4CiXCbk29BRC/jD3dq9vect06MKUovXFGSwRL0wbK8WEpAZCvZIS4puVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8517
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=811 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMCBTYWx0ZWRfX6wEsuWdu4SJv
 0/EQ9ZbZtUPny5PH7i9hde20zidP/1uSGOsFTJ8UaVaBjIN93eQBNcZi25s8x4rrhdbf1+t6zgM
 voiMPqIX3TtexxTDRkytC7eoRySYk0boT1JcIPqsV1+iUSDFkL+EsNzVOBksKtB10/5qMUB6WGA
 XxBdF5f6WDIPyPTBQs9Qo+v5haPno4KPZSft7v95mIl12J4dt0ISkwnyfIJVbhz9Z0Jpy5FpkiC
 wxUzFuyBWyE1Z5x9LWoQzWPIcvN7CDYK3Yo+cRyuobhjQZ7cWeGLVWM+bueHmezcsba8/9m8mpI
 EEr6v+t7j25HJtrWhY8hfZVWVXmYciurt8NvFRMwwpHD9NFMwvrT2kCLWVvcu13GqQ8V+ccJiUQ
 yr92/2C4SUaSpS6YFJsMy9/RnpzTYQ==
X-Proofpoint-ORIG-GUID: T0q8KGkNFyWCWx34Kg27ZO7WNZ9182lO
X-Authority-Analysis: v=2.4 cv=dpvWylg4 c=1 sm=1 tr=0 ts=693791f3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
 a=FjD-8dGO14Yd8gSk4-3N:22
X-Proofpoint-GUID: T0q8KGkNFyWCWx34Kg27ZO7WNZ9182lO


Benjamin,

> If scsi_dh_attached_handler_name() fails to allocate the handler name,
> dm-multipath (its only caller) assumes there is no attached device
> handler, and sets the device up incorrectly. Return an error pointer
> instead, so multipath can distinguish between failure, success where
> there is no attached device handler, or when the path device is not a
> scsi device at all.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
