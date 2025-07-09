Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5459C182
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 02:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752026878; cv=fail; b=YPytVI9hl30LoPACF5KpQXgkxijzJeayzHB4i+NPv5pioftKysK/gbHkEOPWMzrTzjkKwg3TWJpAb4L4E2u+IjYjUAtNHicJfWqgJJnVWi4t3iKc3E746Q6IgTu3ogZ2ydJi5incgoIMX1NxMs6uuKhFurAqR3HmwzGGXLffH50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752026878; c=relaxed/simple;
	bh=WGZO848X3E0q/9Qe5LmlueTga7B572eX4xSeBBgHWhA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Wrf+ax2Cg9UlD1bFs3h+EBeaLa+hPPg0GIsSFP5YFJL3/B0cQs4t3lvV1mXlL0InUYtDhTFQ0VCDmNtz9H8Hlul2ijXmqzzgD9zFOWQJGjmgYtb9WbiBPS/YmpLPqdjUjx22DQlymqkGx1R0SVx9UWdVf5t8iciLNmkJKdycgJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aWeavJsk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DW7+BFt9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aWeavJsk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DW7+BFt9"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5691kB3m026493;
	Wed, 9 Jul 2025 02:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ANbNzBmyPcZKVOkrP9
	zlqbIj0OgUnW2naWT0NJUH1Xw=; b=aWeavJskxEh1Ce8TZ0S4InBkj+iTs6PHmv
	dzKHe0OkOXne5rxbhgtLwS14buKm/MATkS9FcOB9+jIhF2upnUPI5vAHyGTVfRFr
	6OAFdtyhMRjTZYH0KW3HG4DwywuzH9n3bzkad1trIzEkN9+Wsof/t6ERZ2vB1p03
	ERoGpI37sr9QJkbRP+DpYVukC71pu7xYIHnBm1OkW2yq21y60uSGOPCBrJuSmVih
	2LLwTjosO+PicEEGs8tNx4LuEbpwMjmgqR+J0aCECJkwJsobp4Zojub20g3J6VJc
	h+QJtRBvmyRw64ihX+A+sa1oENf+k9pPgCTKC5AFrX0CXppttTtg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47sf1wg0j9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 02:07:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5691ZaoT027486;
	Wed, 9 Jul 2025 02:07:53 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2078.outbound.protection.outlook.com [40.107.212.78])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgabqr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 02:07:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bj9oXps4UDEstOGEoeH3Hu0MAg+uJl8YxQMkKtu+7NHzELSBOUTp5KlfbeXFmffjw0MznzGjYvrqrrsO0yTx25oa1ll4r/05JvzG+7Dt3GZByOhcb/2ebhJ4kJH/7MoEXR/1lqrEmijEL4NBzU0wBBK3+0N/+3yO77pP7D4m2cDybKU347cP4FhZhC2JArnnayNA8/IjsOo6P33r/9Jrq/wPYsRmUCgbL6uEUuCYsxDCbGRGvMdpxgBstOBjmRS6jO7T5x41YZOk3C4TvMfBnaJSsmYNCeszcjGYrcQp1hqduhS+HBpFZ9VZqw8ou0zIZmzQcv5pwZtv57ZR1gmWPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANbNzBmyPcZKVOkrP9zlqbIj0OgUnW2naWT0NJUH1Xw=;
 b=X+DbjfEqXsGcQ6vfSNYftR7Mp4QhfT5/sx6L+c9mihpcP10mOtTm5fI+1NwmyoApCOM18SsWuUY/a+tIcDOmUfT6mp+VAqv7hvBRlf+bwhVNrT/cqUow5s09VYpHiymVxB7K8xdcTSmODtu5umMayi061Fh1NStkt/4DNShoceE2lCTZPvpLu9S9MbMxhdKew6p3whNgZJfdIWIrVuNCCOFjBm6DEczRLKoiIqBbhTXduey4+78aw8hG/uA6uLJUOGxXBlepaeAdHZaErRnMuF5S7tBwsffk61nFpK+TFcK/PnpGeEXNS06RQhxeEg9huvnf/HwjK+qLdLL+NvUrfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANbNzBmyPcZKVOkrP9zlqbIj0OgUnW2naWT0NJUH1Xw=;
 b=DW7+BFt9oKK3E0Y0kQ+9UT+rn9g3V5pM7H+Fmx4zy/y4/rcAzwZdLLuKq36ZSxagPIvl4ksC6t1WbmDj4K6R6bATWBIbQ1w6UZJJwZAwLseY34mD8ovh5uIyH2qqCK38c0hHC5n2GtYleBy9xcvdR3YluGUl1eHiZVzLpruYZBY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7977.namprd10.prod.outlook.com (2603:10b6:8:1a8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 02:07:46 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 02:07:45 +0000
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Nilesh Javali <njavali@marvell.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        QLOGIC ML
 <GR-QLogic-Storage-Upstream@marvell.com>,
        LINUX SCSI ML
 <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: remove firmware URL
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250624190926.115009-1-xose.vazquez@gmail.com> (Xose Vazquez
	Perez's message of "Tue, 24 Jun 2025 21:09:25 +0200")
Organization: Oracle Corporation
Message-ID: <yq1sej6ce1i.fsf@ca-mkp.ca.oracle.com>
References: <20250624190926.115009-1-xose.vazquez@gmail.com>
Date: Tue, 08 Jul 2025 22:07:43 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7977:EE_
X-MS-Office365-Filtering-Correlation-Id: 751430c7-5adb-4c7e-18f4-08ddbe8d655a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N3x32H3YJRBAXfgcDFjtWYQ14g/yhrxCcnniTPy7nDufsYaRtUnWSrGLxJKx?=
 =?us-ascii?Q?TlrSAnDw6OPQzORmB4KjNBD2Ssp1meWVCP0d96KqHnhGT3hjNjYVK+6o+70c?=
 =?us-ascii?Q?5lg0ofg42OBXEfyUa1xeC44zmBvLvXcrQhShfZBdqAlNpbsK6hQ2KS4EPkSv?=
 =?us-ascii?Q?1KtMqvtXgCPQkxYTcM4zs/vfhqGh8P6+Dp1YvLb0wUGcQuYtbekdDHdBZMSQ?=
 =?us-ascii?Q?M6cSdHS/T1ldKgzCpodPd8rzBCeCgs6LIgLjN5chDIzY1dji/gqcCelsnbfH?=
 =?us-ascii?Q?c4YHS21ziTcN9D7sg1dEElgjttYioE6u406anlDBAJXVU4pPOke5rXiyNFdt?=
 =?us-ascii?Q?DKEliSdJgjL3EBHxKqalYWxDldK2NpT1kfKFwTzryPnFmzn3C/ip1IQgadBc?=
 =?us-ascii?Q?rZVb6juCPQ5e3rA2q29CVqpxqIwxnxOgs8xpTCy2Swa5L+7/JuhcEZ2WuWgy?=
 =?us-ascii?Q?CPIdzqBoyWIqB/ibFZ5OYkAvf2uWqTD/7TIGMS4Qru0R5LWHXyyeKXNgVCdQ?=
 =?us-ascii?Q?n5iEyq/LtM00flL/J7j/MD2edrXIrrxFeS+K1TxcJ5OzmAXO6QFS+IRb0v7T?=
 =?us-ascii?Q?oVdLvieuTj3w2uAbP+JCPzBlWuZM/4bcYqB1FBvr7oVtTEwp/60aT720faDB?=
 =?us-ascii?Q?tARRUNNUCJ+//6UQRDlPevqeOQO2BLC9/RNg1oFbydzgH8T7rhi/PILc3JC1?=
 =?us-ascii?Q?9iQda0ltg/UvTeGkut24Mm8vuGx1JRg6lp7RKO6QuyqS8vFIAaF7GGvJ46AI?=
 =?us-ascii?Q?gtx9n+RUUnE63+f11awDxKhuLWMQ+Wamkva1Flvs+C259v9062bCGNtwsnlj?=
 =?us-ascii?Q?2KIva3Ru4m55jHy2dk3BnA+DyQdrRzyizOe1qPQDF9g9wDEgG9S5h9WRDkkk?=
 =?us-ascii?Q?rUkz2IjkYpl65cNIb7tZ3M4K+BydCcJrWOZZPB0XER/f3hlrJP7EyRLEL59u?=
 =?us-ascii?Q?D2YYpU/wqHtKuZ2sox33iaFh/7lo+18dJJIFCXIAfNquxQCv11zvW/Xtg9fX?=
 =?us-ascii?Q?ueWjt6plRuge9t+LEsTzXS1hWhIFFkXMMAMFZY+b8nrYiHb5iZPktbgE3Ebg?=
 =?us-ascii?Q?AXuUMFR4wXudJpRnMBB7Y7R1lDpuz69xUBTh4v3As0b4jwE1jkDn4b1UkblR?=
 =?us-ascii?Q?m6ntf8z/5g+/YYXFUX4RtnnjFd3j58T8YK+of9I89G7GqwF09UuNj/EMjwOV?=
 =?us-ascii?Q?Vt8Er+K3ynKofejsx4zORyk6QJ4uqUeAXCVhSXgcH3+2oKRDHAsMDzvypFVQ?=
 =?us-ascii?Q?gsVIZwyAolqP5Eojfup6NYo0SUWJJ5QGdS+7pnoilWJhOu2hzbKsy0jhlm3F?=
 =?us-ascii?Q?4pawFjzhas1xq8qZifXGhlnZopu3+jshcI9iEeyScXQDecoW2zrfEfwYYN1C?=
 =?us-ascii?Q?sIDkWBN4laxNIbZO+UVoWsvYbpPQFK8TeImBokWo17nMue7w3G8jhJkKLSsY?=
 =?us-ascii?Q?m6o4ZQjGvKA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mtvwa3ePqw1ekvg48oWYMbbbDR8qTnKyDauKPZL766q8rNILgKea4fdpkzrf?=
 =?us-ascii?Q?8/lZRiGdEDylEW2Qg6YUnJ3IeEBn8N4cuAdYHMqw4z3D9qgjNBsh0wItTfFb?=
 =?us-ascii?Q?WVO0hBFGN3Mu92phfrbuY5c/X1Own4iGWyHZ2PNyqViE0jAHcF2GuSlmB3lM?=
 =?us-ascii?Q?x7z1GJwo3zGSOxOS5j7403fADZ5enMVWopfdkoGNJ4I1yAeTNlG49KfCgf89?=
 =?us-ascii?Q?yyrQqG+P3dyaNgL8Vab8339pxQDc34GrXUu9Qh2WaJ/1EIAmM9AwKpUM4BEL?=
 =?us-ascii?Q?6TTkyXwFfwv5yLg5kO6LNQR+PTIgIph7bftXGS5R4rkq8Ehskf68npCu++9w?=
 =?us-ascii?Q?O7QNHZentnMTnUGvqePweiwI02MFRKshDNRjmek7bUCCEysbDytCSNl8Z7Oq?=
 =?us-ascii?Q?ks8zPUa0PEaFVx5E30rkZ86TijP3kx2X4rM5FPLH+F9LpzFcfkapaJe+BJ+h?=
 =?us-ascii?Q?Z3gulRWjOCahyZLVwGu0mV3mUBOBajDz3yFvSGe+rvE9GJiXhDchm7YVv9qJ?=
 =?us-ascii?Q?dVjp6gBT0ale3nnltu5OJBGM9EFGS7RypBDaWtQjAKXUIZI0TPefKJPcCgMr?=
 =?us-ascii?Q?McP6yzezKHp3z0wXrTRKvcLtTdGQhmNzC0tXJ8Y7gfFhR0Qmu2ZqPWmJe6EZ?=
 =?us-ascii?Q?YWm86bOsIKY6wOo2sImHpzjjs2cUucwWbQdo7PdYOurAgNcLDExVYyhEK1Br?=
 =?us-ascii?Q?UOefr2c5FMjehrA7p+rzwWDXt1npAtxYxr6PWj1nxmYR2LJpXshOQJRAtrEV?=
 =?us-ascii?Q?IDDVnPUd/5OM0OxJ/KmjfixqLTLW7heCT1GUpl8y2k5wXaV3Uvy6RuMIPBvo?=
 =?us-ascii?Q?bRF6Ne0P8PXyO/1KKrEm4tm3mNJ4imujz+zP2OK6v1uYT/ioxITTFd7jhly7?=
 =?us-ascii?Q?NrWTIU15vYlyPspcdDiq4W62gfNlgPyOTGFLxJGeG2gFveFO/BFTLtUOFrBL?=
 =?us-ascii?Q?mvpF0QKAGjmqJCYGFoSKa+yh8aG2Vho3cA2Xx5A1SkVNFmLbp53a6Vok9yzm?=
 =?us-ascii?Q?yluUF6lpUMYzqN2XIhZQLcobsxB/xn29+CqsYP7P0/1oNRoWtCsI3evTvDWw?=
 =?us-ascii?Q?fAqaJn1SlkqqBc1Wfk0yCp/Ee+QdnjZDVi4X07uFo7ibXJ1PjOiDUEbdJG0C?=
 =?us-ascii?Q?Au9gESOoSQg0TlNPaKTlpBfkDrz8gKTIoINeZWzubYnaStYDNLyq4fvVzVUM?=
 =?us-ascii?Q?x5HONbCHIU7671l8FQaFqvCgXpf7lEPrEQ211DIqtlbCnMw8SyXSZg51bBiI?=
 =?us-ascii?Q?fLEM7LUorihOULHgsS9EoLXRzd37o+R7PjMaj6zRT701q7E9AaNE8TVbTxpU?=
 =?us-ascii?Q?FHKL9+R5pEtCkY35ynE1iF8siAW4MG41zuadjJ2WfpzPD19ly7LHiqUVMWG9?=
 =?us-ascii?Q?p3UZERSPmIKIwXu71RZhPWYKxcegal9vYD78GPupKevlznQQFykMBI9QzbZp?=
 =?us-ascii?Q?68dijK7F94E8D8Q618KYoPQqkVHf6oa7HeFg/VNvcKU9iolDcjz1PlEb21sY?=
 =?us-ascii?Q?jJwD8DaUcR8ik2YR5IXaedb4WYwkz8iE6lwl855LyGVKYxGf9X6CQqgtdBIt?=
 =?us-ascii?Q?7wkk3bhy97BAHhnJgvfMKdtgUC66B61Bsu1GxtzO61PWYOkezd4J4dctYCtD?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2Adud2QaYQqUyQmfmKdsh/n/EfLQV+jb9wQbPgiBk7d7c9f5vB5rtLdMYBPRvniakifcY/OoTOY+ndOQsu7R/UPwuj9qltn7ppUPUz9vIOpOBytmDhBEsXYkX80Oc5dU+dLfbWvCJ8Ci2BrfbecT7F/U9QTsAiHLfilj0HPLtrCIcghgb/Cgt6Fs/mqJhlJ6ytJcb+KY/qEE5D1+Ger0Cik4Mon56+Og1C5jGXbr4HffKSV9x8k8sNsWIPbnMTTTnpbEEwYySL+w0zHaDK5GNazXrQJakcBJMyZJE9IhfTZQApfg/b4dGb2iXz48tYYfYo9Nch4TajxYc3GYqUcby0+GhOoJLLIzeK+5JYB4aTN8wDdCZ5y8mBFbf8wV8oLa/surA75NuHXSGgZBUSWalVwihMki08+MKPUSqW2bDZhd8Mgmb/8ESfO/hnZPdlZpt64rX54slKFaTwJN8Yz+ac0DZIGAeMSGUc4dkdBqOT1zsCsLzT9qd+FmHZsmTEezh4SAq/z9puwe+4+8rnFH79eR9c4uofidxMp6kIoE+1wS8j5WjpGm6sLk5orJMjTbuifRwBkVSnXkBvYnjZEB7xbhBz/v9Optbj0QZOqs00c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 751430c7-5adb-4c7e-18f4-08ddbe8d655a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 02:07:45.8577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjvqwBMTJsMgrGMwAPgkvlGlj6GhMNOllwCKeApEWd4r5aa98a+2035Ungr0npnd+TjhFXAHP8k3T5+mTA6Mb79ebTp0xJzS3KsRKtis2Yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_01,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=959 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090017
X-Proofpoint-ORIG-GUID: YjbB4brgN9079NNZpxZiDl8WBwb5Azjg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDAxOCBTYWx0ZWRfX8cxcwffQLhRd ABTY0LO/ax8g9h6V+cmGxcE3h0xqU3ldw8LFKaVCL3YWalogNSDh2cdbdIIT7vtojEozng31N1j E1CKynyCBEt7noLdqm9V3oM928AnbyhatgafIpThsLs7tTxSyT6QpKcX+rp52bc7GXJX+rca+Gs
 oRFxVZrP6lWJWQuVnQ60QtBOlID6fw49c/M9O04Kq0q6V1ImVvavYi1NBJly3rzUiMWln5Z1+f9 4tw+zzPhytUDb9FE/9EOzFdluuGF5hAP3MHpWGMhtTsQXQRGKaFsdyTawhjHV3fnzs5bXJ0LQYj 1QFztEEMwB9Gi/ZtUDgw2jQLh4kUxTZ3XR9hP9DBagF4fSjS+6zCC/m+Y9FJZtROfKYcbx9BhQc
 KjfqfDvy2h51FO+LWj/XF04UJCTIVSpItIlGLUWFaDNWzXRe9ecEtrU0WOjagQSDsLP6cBiI
X-Authority-Analysis: v=2.4 cv=VrUjA/2n c=1 sm=1 tr=0 ts=686dcefa b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 cc=ntf awl=host:12057
X-Proofpoint-GUID: YjbB4brgN9079NNZpxZiDl8WBwb5Azjg


Xose,

> redirects to a marvell URL, only with drivers.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
