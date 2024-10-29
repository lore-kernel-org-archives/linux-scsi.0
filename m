Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4805DD51C
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 02:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730168350; cv=fail; b=eSAEPC/7WsirnO6OnfYxdSAaV/Je45NBJ1nKg5DGpHojeQ70ar8gawOrNXnyII9Cm/kN/wmHJRrr6nNh3qcSSOMcsh/SLXK3nSvbxrCqivbnRNtwE1X4iBrlIOnKlbGHbLZrJo3M1us0xf76B6Ygv/2p94FaquUyd/v4/8SNdUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730168350; c=relaxed/simple;
	bh=gQANpltRQ73G9poQZ2m6KMEkUOR8Syeslqa0BgyZrFs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=L+pIaf8T6Ncxh1/TcFuKdyZLk9dCn7UCnCaRuJNxrNo3KszidZcesEz5Ku090em6DQcvCsjFO0vWQL9+CciKPrnFBUSkIaU28BiRPg1tLAXbXD0uTFgvvyaYVReuwipjOITcSPx+hFNevBYvcpkeFi1g+lJdfWi5ZapoYj1HyKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AtXdaIgm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=opdeGt/p; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AtXdaIgm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="opdeGt/p"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SKtbae032558;
	Tue, 29 Oct 2024 02:19:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=aOTD7mNLotFVH3rmiK
	Ia/nRbc++th8U48mEdyddk+EA=; b=AtXdaIgmeIdltBagDoqIZOSikKwVeEFhzj
	GdWn8PiXaCa5qaQ2HMcGuhwx0AFmJC/hWiS4TP0kQfaWHhgt1SnPAGwg/juOhP/G
	PbFNvwTirGbvl6j/mGksLzzxdej1kZQA4N/gR8HhZ7XgCWPLfJTIvcRAlUrxcPP5
	R6mSMt52sinltBBt6oBmf20DGrtvF8FoK4hQWEJl8lxaWowRbJcW3sibS+CrSbcS
	PxacKD4TpkXjAaxG2FtX0Mg7Cn5SPVNA2uuZ4gI9YW/MEBAeC3rlXNjPBLgocyyT
	JA1iDdArIY1eWfu6/p/0e6qQDksodL82kRe00Zs+sPnXd96YvkCw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc1v9w5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 02:19:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49T1H46Y009964;
	Tue, 29 Oct 2024 02:19:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hn8w5bsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 02:19:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u54W1WAfUXNNclpeo0xX3Iy6p28WOtb2BtpO+eQr7NtRs/f8UnGsiwd0MAJAzW13MRxs9vKnu+CacnlNULuJ8te7LAkueKxbu8BJHAEjuiCT+Phjh7Gr35WkzOZBy6RWx7yUFYaDpt8H8ur21QUx/c3OoMSbYECesA/5IzA/O5p2p0rzP/ajUyDDUt0DrzyF/4fPFMo8Bh7kEctJvT59EN2cESy1MKelTWnJNpKN0XPG5lXcuJyo9kb+x4d2kbhjsqSDQk2FGDZKEdeIeyKh2dveAbexpcTTxxctjUqVTpYOMYqLei0RnNVtGvhEKshJBmyUzlizaD6E4Yh8TIVNag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOTD7mNLotFVH3rmiKIa/nRbc++th8U48mEdyddk+EA=;
 b=QB27l/WWDuZNAaETiUL3WjrlpTZwcWfwu0uSPvDnwe2ulfZrylTXdpzitb/F6biEO0KtPPw58+0RK3IN0kuGJwPw+zFkGd0+j/6/Zt3A65BZ4AVv63yp0dIMeGUPrH29TDm/jbDPARpJml/JHI3MBVK+1xxHwMES2QoHkEN0s0cLHMrQHkY99yUeyQYpLSkrtV5NogMGg5r5sASLKnpKofW65RzgN1QQ4n6NbzvuItd94DA7LY6SY4AHgG+RhDFje4/uN8gpsLpoTNeAu9mDMcB58na1c8yNvi7mpmgluvVStp6Ln6cndSgjB/tR9+lp4n8H6keJmuKES7FeiHQWRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOTD7mNLotFVH3rmiKIa/nRbc++th8U48mEdyddk+EA=;
 b=opdeGt/pWF9umvclHNjf2unjsrx+qlsXTRfOAFczo76Ccmz55amP/ZPTj5L1oMmtLoAfi35OxkKrWGNkYPF5CU/o0eCX239nd9k9u7bAI1sJwJjqCZszpmPkJ0gWoLPn/KxvS6wCHUkGjG635G9lfkQJwm/ySIiuv5EVW7PYqHk=
Received: from DM6PR10MB2954.namprd10.prod.outlook.com (2603:10b6:5:71::29) by
 LV3PR10MB8131.namprd10.prod.outlook.com (2603:10b6:408:27f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Tue, 29 Oct
 2024 02:19:01 +0000
Received: from DM6PR10MB2954.namprd10.prod.outlook.com
 ([fe80::3d89:e811:9df9:6fc6]) by DM6PR10MB2954.namprd10.prod.outlook.com
 ([fe80::3d89:e811:9df9:6fc6%7]) with mapi id 15.20.8093.018; Tue, 29 Oct 2024
 02:18:55 +0000
To: Magnus Lindholm <linmag7@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
	(Magnus Lindholm's message of "Mon, 28 Oct 2024 00:05:50 +0100")
Organization: Oracle Corporation
Message-ID: <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com>
References: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com>
	<yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com>
	<CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
	<CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
Date: Mon, 28 Oct 2024 22:18:52 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0248.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::13) To DM6PR10MB2954.namprd10.prod.outlook.com
 (2603:10b6:5:71::29)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB2954:EE_|LV3PR10MB8131:EE_
X-MS-Office365-Filtering-Correlation-Id: ede32278-ad56-4727-6246-08dcf7c009b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tq5Xpj0I84GRChP2U6Vsrb2hDJK2YgJOdLU5spQ18DGVpJgg8ay4tcFMekEG?=
 =?us-ascii?Q?nWOSc4v0TfCYcuJQ2N71feizDbZkbOyKYJoLQpLYmQgs5aTk/mQRxzq63qCD?=
 =?us-ascii?Q?UD/lpcDEYJB45e16XaQHT3NDQcXxlPc7KUUhDDdXFdO6ZpTHunGPx1I9N3iq?=
 =?us-ascii?Q?cXZjFavxzhrNUjKltqcnfFFQav0nBtJCFokGRTKFomV3VF9G6teD0qD8U9G1?=
 =?us-ascii?Q?ts7VKzZYPc4XT49yvNcvVxPLzBD5jyI14MxPjg2vLQKj+PsgngzTUhsYJm5X?=
 =?us-ascii?Q?yS7ou+WU+Cm4y/rZ3g0BsP1u1kZJB5xNiv8BUzgkSl+dpey4gH/83aIMEZpp?=
 =?us-ascii?Q?DLle6dOialTwkAcLJwHcZhblVlw68+EAmVfAJpoemXhXkSjkkuzebuXS0c68?=
 =?us-ascii?Q?/BChbzT5S55s8Qjx5dL4fjnFFDewAPRPY/BTz2/YH31WUUWpWydxo82mfwLl?=
 =?us-ascii?Q?4Zxl6RiC//+CsIxlAhu32ry8idG/qf8xJ8NLRCL7R8uva4EtBgN/5SdXKenh?=
 =?us-ascii?Q?wXXFYw2oOev2/QIt7XjadArm07NrnXxnMLCYZVS8srqiUnqT0dLkQnM2HHO+?=
 =?us-ascii?Q?zueG0zp6Avh1AX6e5bhOi67Hy5IKxPr1a8i8N+AHOtbA3nEUL+8rPYIMxAxQ?=
 =?us-ascii?Q?uscwqbccSP2qBBqmnRElIwH/evhMgXF3MwV3llU86Fh0I41WKmAc+O6/2aRD?=
 =?us-ascii?Q?eRcP+kSj8Hq4ZVcHO5+5RBlehaaLCFCpOzGfGyniVggDKUYhb0PSqyqh1sA4?=
 =?us-ascii?Q?8/e2nv3FiBGyKy5ix37fVOa6f8bS4LDzXLgzMOs1bxM8sY+/l33aH8gQwUpz?=
 =?us-ascii?Q?kKL2IVfKuNaJGYPj596B+mnN0UNvL0w+MHkOS/TJE9Y2lgL5HjAtaG/nZ7Qf?=
 =?us-ascii?Q?SmkgvLcRkzXtSV1WlriPjIICKLLDywfS2mA4SClk3q82pi3AzI0dYYezhQwA?=
 =?us-ascii?Q?e7M1vxrjrClefVvNTr+TfpxuCFFvfPqCzax0OkuTbavRtPgbI8c3Ih6lbhkE?=
 =?us-ascii?Q?mX8ND0UAzt07g02OfymDjZhwLxSw0VYUAJYNdTTKWjW8DLBTRP6zIjuU/Z7Y?=
 =?us-ascii?Q?/IYt4YQ+EeROpWgbFgdh0KlbJREszWDMv8EGE6CRkz5WUsw/NfO1Suigh2Zh?=
 =?us-ascii?Q?1Csn4VvHPTf9H/OmIoR9TSkwHdwAkYId8X2zrK8UrJZEBbZ74GdFBMEnC2Mo?=
 =?us-ascii?Q?Zcw5Yx0C8MMAgaAAUyn1jG5g0xoBYKgowgg0G5qn3Z6G56V2ziamB/5zzN2W?=
 =?us-ascii?Q?KRvZTLFXBg0bPf4oWT2qDmO4YEtXhqWOuETEbh9epEAdwqeLcoZGeIz8zbcQ?=
 =?us-ascii?Q?GkZPwyVe6wbYDqTcYfDn6U0+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2954.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DY1gHH2Q7bH8+EthrvxvzDHnUEDfB8iUi6A93+dRQXjc5eZz133E5G+a92/t?=
 =?us-ascii?Q?yEwzNJ/tRFzqMbk3TWLE4siwBcqSIMlekR0uACDtdqyGbxy2x4EZ8AcYQpR7?=
 =?us-ascii?Q?i+UK0UbYKgayUQtYk/e+JnfuDbgIjERvuWJlNUfgomJTE1e/1zQmAGKMf8vX?=
 =?us-ascii?Q?K490Lcmo2R8mkVmkuO+/uBuOgT9dbJdd28S2bq4mrYwUEGRiMpTGoGiRf9bu?=
 =?us-ascii?Q?RVauh7vGO+xR0jGlViJgftjhrW2VpKzhBmLlkhso9n5psk25NKyjqg3IxWAy?=
 =?us-ascii?Q?yTnUENN3/FfoWJSu8xNWe8THngizffnx9tm4/A/Ii89WVlKPDjbUPTvR6v6b?=
 =?us-ascii?Q?8TAwEuHgaE1mWlcKBGLYN2nqj+2CralNw8IjWXrjvKSZmcPHZesiCSQrwUCV?=
 =?us-ascii?Q?xw7edfGEBzEYhzVVSsVVQ1ka1VdTpYVrrmsbNe1HIK9UxBVWdvvzMJeBy4Yw?=
 =?us-ascii?Q?bke952hM9QEqLXdGBlwKvOYvhitbQApD3f1RLCjko41CKEbfiUcRvAJQo6a9?=
 =?us-ascii?Q?UY7SJq1suEfnnBYvyeZ+fMbfsosbhZ9mZyepI4pcF3yQziqxhAa+e4lQUkLX?=
 =?us-ascii?Q?IdGOYSQqHm2wan+urXZg5ngbObRLPGtZnSzekA8gCY420FVoZhlBDbC5lQqz?=
 =?us-ascii?Q?wReJxUlVfC0Ix6sgb2hEkxIPXCEgWRdXwLWyvgNSyqjijcar3GZts+Wjst6d?=
 =?us-ascii?Q?Lc4wwA4pmchktxhdsyuErxHpk8HgEoM55d9aCbzB21sQ5kcrQ+6yMP4phLzx?=
 =?us-ascii?Q?F9kwXMj66boudpUzSEsFgbxC9p4X3zXcigiJzpbOA5EUEjvvryKrcs7DSivh?=
 =?us-ascii?Q?effBFGrxk2FrShX2CjW3KzkFLJHaPw3Z0ynkV3LJxbGMg2si1PZIUB79ySaQ?=
 =?us-ascii?Q?qigR8xgqLHkfnJ21x1/vW/1yvL6S/eQCwlG4tY19WH/Lh3IWjn3elXsya4+q?=
 =?us-ascii?Q?ukMvd8g3IIPvblHVBNfMIsbWr+DMWN40dGQXlkjgOI6gfVX7J2D0IQhO32Qh?=
 =?us-ascii?Q?U6VwyotKs8X27x8F4fMZ9meLDk6bXu8v7exQD5FrZxDeKCvasUbCjGL5gM3m?=
 =?us-ascii?Q?5EyFCWuOfp/n6nikkLf7I+I/71vmB4qbGJ2fYlp82aHEui/IOEGLD7xjbGXb?=
 =?us-ascii?Q?91DvkXnAItLiLCDpYJHQB9KwNcpZWkCM/MeJ5T3qHqg+sfW++CGWe3jC0wyb?=
 =?us-ascii?Q?xKkLXOP26Kt4LpJsJ3OBtc1iQxSYUjoCHp77XL9vcBVmxjR/IwP74bTNXGeh?=
 =?us-ascii?Q?+BroAtkuZYrBBjI7HtqvgQEo0Iv6PgMHN++yeWRZF3oqBggmwI2uOYjFW5u/?=
 =?us-ascii?Q?6Mq+CXAY1UOIs1Mivpuy/2y3JbfWKm4itZOHzaZ4X1ITB/RonbkgF5Q+7loa?=
 =?us-ascii?Q?1PtA2FyRX0fQCcM1evwbvuZhtC7J2oMpoiDLbIUILIcSOYb0usFCyalFtUEr?=
 =?us-ascii?Q?94wYthdG6mX7zQHWDIAXFOtN/AGZNsjzaEioArgE9edAPvQgLl9EXONHnyrz?=
 =?us-ascii?Q?+WKhi8DvhDIuoQSKgPyQzCF8hZB/e1n8btS68506W6UeeTWppJbHsgDsZH60?=
 =?us-ascii?Q?Bj0nV7aVjGKVw4WkWg0vYilmTjZv7bybMqeHnlOZODcd9H8OdZ0sibg6WjO+?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1lEMhfQCe7VIpapWiP+ZnjUcHG6IjXanWDjMtkDw7QVoXVE/6qgOosLZrWqbiTI2Pt3WsMc+JrSGeb5rqz8oPgWVfQ/CtJrhKXCc1jTHaqGgBQ5X78lQYjseB99qdOWrSFvpZnrHN53Lwtos06qeJBBmb2QPyX6fM5zrPw7M+QphKTyPAVuUjfteizd/d/s7CjImxxWRGw4z7o+rY9cV6eoyEXF/Aq4Zu2DuKUcHXCvaBX/qISa5vdKjr7G1AwTuOpWPgnHuIDintzmBBmBqmfwLz78fXzNxM8yQeC90W7ts+SrQ8iz4LdMhgzQJqRti2C/FEQD7hVos+GRVIFY4a4Gmvl22i+rXZn4ZdutXJvVzz5Dpj1KhtFPuXCTP3E48CVUUFyay6vyhRb8Q7xkGeg64U7WSY4UeXlvz/pYodxZwK5stszyMAimiKEPVlCSMWifD92s33+qbuE614pRGL0v2u+GUSdPwOlHQW2upirpY6vGZ5/0ND7XcL9OSWImFwZeRrx4kyqCjpdHERDSFX/Xeu1GBHmIHrPXPacT8x2T8fY4hGONZpZAZxDLILtazjG3hOkwiKrP6ax5IYeIifV+gjpgZh5c1Bvq4YxLhYSk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede32278-ad56-4727-6246-08dcf7c009b0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2954.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 02:18:55.2010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nuHekR68ZV2BCZu0pcYnebecVegn0Ezl8VofDCQ+6dIBC8bSp2koBL4EpdQgW2njxFQwekdZDbI54JkIah98phUC7t8IPsmrIkVREgpsBBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8131
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-29_01,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410290016
X-Proofpoint-GUID: Id8-e0NyPMKMD9EtSlJ-v7SLBAU4gJ_t
X-Proofpoint-ORIG-GUID: Id8-e0NyPMKMD9EtSlJ-v7SLBAU4gJ_t


Magnus,

> I've made some changes to the qla1280 driver, the changes include
> things like checking if the card is in a 64-bit slot and setting
> DMA_BIT_MASK and enable_64bit_addressing accordingly. Also in the
> driver information string, it now shows hardware revision on 1040
> chips as well as printing info on its PCI slot (32 or 64 bit). I've
> tested it with a ISP1040B card and a ISP1080 and it seems to work
> fine. This may be of interest to others still running legacy qlogic
> SCSI-controllers?

It would be great for the driver to have a solid heuristic for running
the older ISP cards in 32-bit mode.

You don't happen to have a qla1280, do you? I'm afraid I don't have one
anymore and it's the model that occasionally pops up in bug reports.
Would be nice to validate your changes against that ASIC.

In the meantime I'll see if I can locate the qla12160 I believe I still
have.

-- 
Martin K. Petersen	Oracle Linux Engineering
