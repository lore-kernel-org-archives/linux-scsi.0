Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B042C184
	for <linux-scsi@vger.kernel.org>; Thu,  9 May 2024 01:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715219312; cv=fail; b=fVbcZlm3pIzU2BfnMIK3JOElMxzl+1Sqr3j3ikIwC5QPPmeI4N8/xj7BNSH/wfR9HSi3j8jGBTVYJCxga2cYqKHpNzhgTPG9Ii87purGvCEjC0p0f0nK8elO9LuxPS3DzIs0wNgCm6qENr+bAu1s+zvb8Zrp0rRMvop6Xka0mps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715219312; c=relaxed/simple;
	bh=TUFpqiZ+dx/0W814heG+pUDDJxfXUFrC3TaKkApx6AM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=X9QV6HJRYUpDf8rqpCfWZ0kU3676+5Hf3hFzF29+UEbDSIz0Sv3QLWRBPbGOIbrRGf9gCm6eLgllwBHopZ5CK4RL7hw8j7bbdXj3VM1i8ylBxg8xNkv/RmZO8qfyBY+jMQ+qv7G8mFdJzFC5ZGV3lavBK23rqi0d4o6SOSpIkDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ecPgehi0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IOorP3a2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ecPgehi0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IOorP3a2"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4491lrDi002604;
	Thu, 9 May 2024 01:48:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=WFFXqkLdDqUWPlY1TR9lVB7DhZlxet+XVf+GI4jMyhE=;
 b=ecPgehi0mojeOVYHjHDy5DwkkZd5Gu1dSUT2SW8tVVmg/CXcEQrYROOHNmKW3KrqvzYN
 KiaKpVDYPcnsC06O01RJY1f1w1m1LpaxCK/nBJdwDMPsGAwM11M9yPqUUUXHvcprY9co
 QJj58eU2YCuX5ZvXv2ghCt8vvZ8DnnQfpiA2XLXoXetulAnAeCG7TQtKD5yZlg29tTEB
 cK5XUCbGpNam4QiNeo8aqd6L6awwNMYPckVjAYwEC4g/+BBZaa7HAKiv9EWJ3YqrW8Jt
 qtrpgxPqcFlgcZcbKTYdnY66bsqkHtTXWd00REAQ23iSGNQZ78qMEWA/sQSjtz4p8x2l NQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y0n4mr00t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 May 2024 01:48:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 448N0pW8023582;
	Thu, 9 May 2024 01:48:04 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfp3xa4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 May 2024 01:48:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uyum524X5N1kLE32sEDBqFw1lnFVXChbw5FJUvzUWfoAh1pQbwj7LHT8ELwc2V2HR4c+eCT3ieey+Hq/rQgM0Iqk2z4SnrJrQCzL+m3OpJTkNrV46XcLb0rnERGYOHzoKGSbDHXS/5EvJlQbCVwprjngvV2ovplyT3wDNoSmVhsfFyK2QMhBh4O2x80jrflhXt0ZbXxsC3CVkSgd6YZyqlHzbEa7Lif9nHPJzZBggYfimtssbb75BMi+43hLsZg5Kq/fHq9D6tZC7muYC15gYGtXFCIlj5QdYmTmLDEb4nT1dBzwBOvmywaxMOP0/4uGhzobD8BxjF1mUAbRBHQvMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WFFXqkLdDqUWPlY1TR9lVB7DhZlxet+XVf+GI4jMyhE=;
 b=hyoSiKsb1tHfvOeZQ3T84Wd9pYVJSmJhLr3eY7GSGqGm6VuJEVCtzt6ITqifo2ZNeGZ8TnscQNVyYTmi/WPy+X1HCH/2ujMEVXMrmB7eVa7COTpKWH+iUO/OWg0wrxU90E4IPzcZ+ogAjv1eTicetRQts4UZND/FkeGveL6LOBGEUhGgJyV/MsMGZyKAulTX+beb+tOiZYEb5XoUTLCicu/jp5ipcQ4P/P/Uy8uXR7eotNiLyHggjm0RZGJdxVCwMSHbA83jf9q0grOqzVOLZPBd2lO30wVyi15Om/Sa3SYMm+X2HkJ/Q4L68VjqmQx53jdTGzOXuSMLjGFolfvNgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WFFXqkLdDqUWPlY1TR9lVB7DhZlxet+XVf+GI4jMyhE=;
 b=IOorP3a2v4ERfhkf61o72p2yihVXQ8PTl0FFj6gw86NzpPgZHQXSXE3Cp0Pvjf+o/SfJ4Qu2aReFq3N/1RflzsnZgIIqyeMhxGm9OsNr5rblsnqEENTestTSSwFKaqnwC73frFY6GDWsbAE7V4gnC6/I1P2sqnQPAj1KasjtL4s=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4983.namprd10.prod.outlook.com (2603:10b6:408:121::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Thu, 9 May
 2024 01:48:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7544.045; Thu, 9 May 2024
 01:48:02 +0000
To: Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig
 <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        James Bottomley
 <jejb@linux.vnet.ibm.com>,
        Ewan Milne <emilne@redhat.com>,
        Mike Christie
 <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van
 Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>, Martin
 Wilck <mwilck@suse.com>,
        Rajashekhar M A <rajs@netapp.com>
Subject: Re: [PATCH v4] I/O errors for ALUA state transitions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240508102426.19358-1-mwilck@suse.com> (Martin Wilck's message
	of "Wed, 8 May 2024 12:24:26 +0200")
Organization: Oracle Corporation
Message-ID: <yq11q6bwyf6.fsf@ca-mkp.ca.oracle.com>
References: <20240508102426.19358-1-mwilck@suse.com>
Date: Wed, 08 May 2024 21:47:57 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0342.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4983:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f37de5b-fd41-4e7d-a277-08dc6fca0fda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?sFqiODFx+My6iddi2WkHKhuWq2Pkz/MjjUZmbABjKEu3yJM27n+h8/lFLD4b?=
 =?us-ascii?Q?uV4RwJ2DvGJvNXf6yZgG44HB9+FzFHAdzEOfW6oehU5jbOUc7m9o+elVZVOX?=
 =?us-ascii?Q?NBwEiFKltER1puGCdvFQR1wAm33BfaCEIov21/w19AbjWHTUFTN/dTOzx9yX?=
 =?us-ascii?Q?Iiw9wY911telXrOzb+RffHfN2AiHk/2lSXZ9JP2MdwYI27Vb3l8a2a1gcn3W?=
 =?us-ascii?Q?jkjYBbj2gs3seOHBctpZ+PLLvPPnKK5BKxtZ39uBvdp/9mbd6I/UO+nq/4sq?=
 =?us-ascii?Q?SeUS6E6BpcO/kkz70ZEOGzsfMFLTZYgp/kLN8mfUbczw0hyhIy+UEIodmS2V?=
 =?us-ascii?Q?06rWwwbRYclVD5QfhCUlezRTzQXvAsiCvfzx1pz0cgULDC2Fdse+TzmNedw7?=
 =?us-ascii?Q?YlNRkLa36mV4MUTFn1grj2uo6gDdbY/uQPiadYhlnsWIOO9h2JuJoRGOCzr9?=
 =?us-ascii?Q?06MzBh39rb++TIMzFRhNeiivgi6N2vUa9fiB0YW3f5559U6NALf14OphMnfD?=
 =?us-ascii?Q?sB1g1zMzZjxSJH2cy2D1biKKUSVwge2LKtZ1D0vPGtz5cFN0FsT0Ft+fvq4n?=
 =?us-ascii?Q?qG51xOe8ZZlu6Q+b9fb6qKomI3npC1iNN9KOxgIoqAluAAIsZHcE2Hasin68?=
 =?us-ascii?Q?zvLiwkou2VhssgJHg2sJQYupkpD1bB3KWx6A0Tc6BTec6XcVZcUmonCtU5AD?=
 =?us-ascii?Q?juuVrHH0KUHX97lVvlmhBEZeCqDycsvil1JhutSImzVo89BlEJRfAxuTFrlV?=
 =?us-ascii?Q?TBKLyRwpuNAp2w6CJskrUR51moWPab3v/9BasH1Z6refbVGQ6H0b5VZxJGpz?=
 =?us-ascii?Q?/4FxhkUfSb5GOniClcLx3vNBucgWkOHwCOoEnQBnnqd/LrGt+pPjTSBt1WQJ?=
 =?us-ascii?Q?3m6Yyuj/7o2hxQT31z0NSrb1fNEdl7Buv+j+snVl5KR5Cmww4QwtueLmwwLq?=
 =?us-ascii?Q?zQuXsQFXIiGb3mH+M/kzQ7ASLn9ygUJzBBvG0jEi7BS81kXlD6fJ6En298/Y?=
 =?us-ascii?Q?4IJ94LvF8D7wpLSwGRMWTbOcQxhT+trBfQzy8I3LyQjy3vo3aEU/mMNJgN/o?=
 =?us-ascii?Q?r1z+zmjl9q7Pai82oq9SHJhPq7eWa9ZupbtEQRC+HrqSE9HGsN4sQyBW/ujU?=
 =?us-ascii?Q?JC4ypY9P9SdBGIXf6y6N7cas84CHswLhxi0WQrWk15RPnUM4yKKRBRZ70VHr?=
 =?us-ascii?Q?twviDOb0hXJK/KDgyaYMaR83L/L4zisZbjriowskeoAkuauhbdQL6hlo4sEq?=
 =?us-ascii?Q?IK8hUmUmlmJy3d/Jll2qJ3PDgB+S7Dax5oU4eM0L1Q=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?c8oVh6DL3x3tUf+C3wH2FAm06gs1jAYONWvy9GLL1yUda+tdRJqsGhgGDvXS?=
 =?us-ascii?Q?I+BX+/qT/bNZMHvOc1zwlKo0vKXVgXuh8qJODeDkDg89i2UxR+qMyot8FBfJ?=
 =?us-ascii?Q?51siLccphalB0BkZVz1I77Cv+b9Xco6IytxgnGosagvJaGGO/uf62wg6Iib3?=
 =?us-ascii?Q?C8t/rDacsv1xbx1Y9qQo7Os92MEeDIFy5O40c0VwgpVxWWcIFM8+0HMUdmwm?=
 =?us-ascii?Q?MQYCHY1uGqi/+BpctRoOqwe8DFNPvRmqLGHzr8/W413by+iwgn5Tpc/AGuC3?=
 =?us-ascii?Q?sutz3UxmD6ltv96ruXHkn/UiiDJZAOY6+RrKuf/IXnjW6DAfIv9FZqSUHS3O?=
 =?us-ascii?Q?mklKlni/TypxRmJMfRQECIbqZ7tUzXnoDC3T48MdZy222zLM85asCCZmo7kZ?=
 =?us-ascii?Q?XgIeYU9bHmltU2SHCSjOHLzwUTH1O0pNP4EOl5ggbfTKcknK80D6ZjZT/xzx?=
 =?us-ascii?Q?MnWJbnFiM2Jv0UklHEIfISWVnAbYbcANZj4i2nvGRuggpeNyHkuP1ygH+QC4?=
 =?us-ascii?Q?nhzXB6O/eoTQj2ukCWiTz2jme9YZ0vpnjgt+fG/cvH4SWQ9x7XoY+GQB37aL?=
 =?us-ascii?Q?LOJxxu2Fbmuu1Vx18CNKbyASS8pXtIpZUVHC39Tj1gb1RbBhd21b7obh4rY/?=
 =?us-ascii?Q?M/RYHjVrP3ZVX0o+DZdAI+QLhUAlgj1HrJ3akHjyzlYPD32gwkLX/kkxt+Zw?=
 =?us-ascii?Q?Z1w2luUxaF0fds4l0HLyQt1mvxxxB5VHdZf7qM4GkQ/uPRzzc9JnFykzN/8o?=
 =?us-ascii?Q?h/4/lrKj2tZlU+yAxcWUFmjF1+mGhTwne2LZiiIgkQt9xvIcRK8nltK22t/y?=
 =?us-ascii?Q?HV1uyF/ew6UL5+4ZxIgB4yEuRXGUbABwlv8AvEfbsNC/lq+tMFSgXxRS/6tj?=
 =?us-ascii?Q?oDvG5LlD3XRNHTygrrCi/OOat2DovwVLKbnt3gY77nnVLdUucpf9d0E3bk9u?=
 =?us-ascii?Q?ZeH46b7k+ZCnoYL6aS7rh2H3RiRWI3phPEyfuPFcYImZ0veOkWb2k3Wtxpwc?=
 =?us-ascii?Q?Vz221OwC9i9HYEsCH/IgSvC5eoxVvp6z5OtnnY6ShN1lMx01ShQT7NXcOuns?=
 =?us-ascii?Q?j/t6vFCEvNwY61lxw6jzSJJJN8HLQ8Q7UoDUNIaW1g/morclLZHcOoFeTBTd?=
 =?us-ascii?Q?yQNqhX+aafBXqi7GJR3XJHZpC8iTv92ZEe1XD5dBcAI2+6hCUELFwKOzDn0M?=
 =?us-ascii?Q?3SjOLLdlhoGbmb1oZYPmsdtkMBj5EDTCYIMpP+8u1/rvVdkLwe0irYmTG8Dk?=
 =?us-ascii?Q?P0p48tC1heT0O/Gi2KhYS1eZ6pdylrjo527k4CCVxdL0pYMLzP+zA6smjYYg?=
 =?us-ascii?Q?jWIkxJg713XmDDaH4P9OQ3i1pQCetbqpLc0Kh1bRls8VH5WDmtNrXrXhL+//?=
 =?us-ascii?Q?DrAun06oRp+1zYsaYRWAkWjJG1OF4s/ppsV88kSKEhSlP6Zx9FaB8uRNtCxx?=
 =?us-ascii?Q?Fcmdks/re71t27AWLJzOVc3KFxF+Tfa/fgBjSzi0tCLqHBOU7WzpxqKJMbG/?=
 =?us-ascii?Q?miBDETeDW4FNGMKM5B0wy0Fn2fvB3LXnhdZBzHDP8Bc2eNwWTKolpIij/+aC?=
 =?us-ascii?Q?uuye22M12+TkRxMQ3iQhVi3wFdUvNvsjydAE0B3XiQr1500O1q8alsOeCnnv?=
 =?us-ascii?Q?Fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	e7b/Mtm8rnRczbG4Nxl0jrp4At9P2GakrklM6PbGxtkdxnKnaNnT3Jef0X3vX+08Nr0q0SrIvsCvlL8ccdT8/aZC8y+l8//V7Cong2CMwQn4GoCDobXQPA6EC146hQ7E28bsSvFunjImpHUm7ydyQsRf25oWIhvARMSflJa8VN9cnAYl3yl801/I8AulMEzlD8gRk9che1b1/0NAbDnakB4lcFvnwoge0SSWibQjpDJfOmxgTsl4bqFWLBQeevDAeoYIHuiwXWgEpKETrJxvY8MbZQYIY3MzFkNvDD2RbFwxjoTfrCpZHIodrC1dz68tp/AF2mvkjdN7ez8fBQj7A/J56fow3i4Lyr847jQVMnL9tWmHVyqgi8bHIys4ekvpRxoeoJHqx9ogFTw77fWiMEaN2P/6cqYJtUWYjOfWARL4YBiaQdk1/Zu0Ojd+HoqESJjGPzYF2GzqkXQPD21Arzc+6j8xew3RYfd5Ty+yuwRSRVDbd8ee5XjKpxEEYS/bzJMeDLkJsEiq2343tkHzFI0T7J2+IQ0q0DLDLjYbi2krcAvQPsm8lch7ZWNM3gXqrGsZ7KFUJRA2o8thYe1iEEchJtbsHDh7kAIFAbyJ2zs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f37de5b-fd41-4e7d-a277-08dc6fca0fda
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 01:48:02.0787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qx/rvZ/tyXTGST3S5k6hs3vNBUdCaj4aBxnId3io+XoflBenPkI9MpO6MFjHJ/kBjEpjT2VPnACc/ldQxcmFQUQGiMpV1S501wFEBUfomx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4983
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-08_10,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=701 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405090011
X-Proofpoint-GUID: XSEC6Qu7QUaprZhSVVcipK_YUBvIi_QS
X-Proofpoint-ORIG-GUID: XSEC6Qu7QUaprZhSVVcipK_YUBvIi_QS


Hi Martin!

> From: Rajashekhar M A <rajs@netapp.com>

I can't really apply this without a formal SoB from Rajashekhar.

-- 
Martin K. Petersen	Oracle Linux Engineering
