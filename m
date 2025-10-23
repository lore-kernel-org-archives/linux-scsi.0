Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF502F619F
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 08:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761208109; cv=fail; b=H7z0CGPE+c3e3uehdrhfXzPgiO1k68TKk5KrxcTAZcO4Y2HV/p33/b+ZWz60aZqwCVorY6F/bgXngVmsiq1krAdvKbeavLg+5tZ2oWw3M65oZMOQnJWHBHmBpGnqSFDr9Zt5EJ8+R6u8MLBMNiyx9KZfpKuEy3J4kBPxOg/73EA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761208109; c=relaxed/simple;
	bh=05ONNfaYopER7wAffyJm4q5dWL7e7DrhmmM0FEXMrRY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pbzHjlgSoBBe+ZMC9+IcPy9BoiuVWxVN8YYHJBcNBMNLWkrhHBdTLaeAJDACPisBcgeO/OjU3ZT17kbSGt6PTuaVQmP4bDMJiBcl/jpKVqJXS7mEjT1o+KpnrJMIetMAAnV7aehpAWv0y3BM6i5gukl5vKTZ4gJ3MGS555Jroxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QUVLI2uI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AqcU3uXJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QUVLI2uI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AqcU3uXJ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59N7uYxP022604;
	Thu, 23 Oct 2025 08:28:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=47F2A5enzzoz3omV
	3Z6uUacPaumD8/1ZooQ4qGXScFU=; b=QUVLI2uI4eaFIiPFnmYoPc2t9/kQNjRr
	T1b6bEfiAFMB0zm7Y3Yp2GUlFCgBy/9kIZnP3QiefW97JopnsV3WvsJp+DyXZ6da
	mkg8pazcf4WslljgxDt74wfEugFudDLltTu1jmKuxXKN6h8vTHpRJOF7P7TpNC5c
	k8vLdmDFs4KLE0KeSMVPM6oA0/TJCfYHMxis6S8/Zj6nIdvXDaxZnKj9/nFcUI7k
	IS/KL+TgtWggcTYaFrmjTAcOOkV/N4mD9tkaTqkh7wfYmuZ2aSK/kEriNaEDjVdo
	lDvCBGlHyNYghO5TtbqMJ506VF53CXSEyWx8LTku8KnpitLm+YHk9g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv3kt0fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 08:28:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59N7Q2eC000812;
	Thu, 23 Oct 2025 08:28:21 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013001.outbound.protection.outlook.com [40.107.201.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1be8kxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 08:28:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NFd2UN9SdjhEvZ3fK+sa1QA5Nps1hAvle9AOIhIPkNNoYp2NRojjnNs6IDkNbhYEBpklve4jz2OwWtAhQzNpxr9uzGc17LQ/ul3C/Jxw6Zr+zzLoUgvAb9TQicJh/dpQY3H4ybdEqdrkZTagTIaic+DEFFozvAQSnrGRRLlY9VU9bqO2NQCDUBKp6uecHpP7+wgMzcSZmWOrq9OyFN58gfefl9T7CYv0rjKGFpFHQPe28XlOIzxeHqQgrOPvp75ufy5Af3EnLpwPYI80tc3l2ZWQH09k75OQr+NMXx3w3WLZrt1d+NOgq+p4WtRUGtbLrCTf8v6P9kNqOu7zMEqnmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47F2A5enzzoz3omV3Z6uUacPaumD8/1ZooQ4qGXScFU=;
 b=wXB7eZXFM0o8wAiEMk3uzrdMZ+jDM32bSZdnq3S3hnczgYk9Q7ld6v0F/NGh1Sb+lnvhq3JT484tRtwAdci5OhVaxTraM/UoT8tchUZ2dW3U78K1ZmN262PYbo5G/51nU2ahcitIoDEaju35+UYvuxkv6UaojEaq4/casSHtA1y9skmx4OufgOy3J3xQbPme2EntJ0/h2Gu8VDpxyXzQiXpaDOE7lPoE85okzesX4mqsCcsAjK3yxXgMfItvNTcf+U1UNBgEBYpp09Sp0FE0ttvCamV+nYZSB5L7ZDCS8uKkY3+eE/SG2vNA0eK1AdWwjNUHvlJFJVYX875oUji6qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47F2A5enzzoz3omV3Z6uUacPaumD8/1ZooQ4qGXScFU=;
 b=AqcU3uXJSIh/MOf9Rp+dCWCdnA4eyGp98vHmReFKZFom5xirNjrniw5zRurEBbM5SuVZ1iOOp5Opi+pfXMSN46FI/iEs1s3jGNB7VmPKt2wERixgVB0h5KaLX3cgphCifZuKNiVklDtitACdoJ0l9y7tYUeDs8ZCCmu2+JsFYuc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA0PR10MB6721.namprd10.prod.outlook.com (2603:10b6:208:441::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 08:28:05 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 08:28:05 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2] scsi: core: Minor comment fixes for scsi_host_busy()
Date: Thu, 23 Oct 2025 08:27:59 +0000
Message-ID: <20251023082759.3927000-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0206.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::31) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA0PR10MB6721:EE_
X-MS-Office365-Filtering-Correlation-Id: da7ebe55-5bf6-4566-2427-08de120e16dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BZduMMWThfl2E5H/yBKhOP/iaI/nDHX55unRVDJB3mTgRXN5g7D3pJjELduv?=
 =?us-ascii?Q?HP7AxqN5LsrCp+4FquX+edJncNmPm+xffrEvMD53et6gSA2mTzp5M2lfiiI2?=
 =?us-ascii?Q?+FgPoIE2I59z5188qlPnSiMdxVdaWLR6Kw/cMpeN6PA0ZH2zIoKWOZ1FwlBV?=
 =?us-ascii?Q?vu7e+fXvkMK6L/IMasICKB0Fsk5R46hPRCNN4veWjpnyulG9fEnls3255fpQ?=
 =?us-ascii?Q?+NfrqWxFsJTFm44OmWLqcHu6ZRuBj575iUJ9qJmMnAC4d5NA+O4dIkr/uF9G?=
 =?us-ascii?Q?EOupbiCNJu9VZmF4czuK7bArU87QKIDwUcydfvQApXjdxzxQsWZmXTFN+2/V?=
 =?us-ascii?Q?rj7z1QfOrme5U4X0MiYFFSzoZk2foaUWueZVN00Rw27lANuyAqWOdGslc/yI?=
 =?us-ascii?Q?mAbWHBFRXTLx/8SePoQdorlUAnZ/HVJIdYeCGS0ZxE9hZrYpq0YSUW3djjo8?=
 =?us-ascii?Q?J0IaxXYRzBhvpobGtudNI12bfVJOx5yVq2y2uz9M/hhBL8Vxt1hkMPfnI/Mq?=
 =?us-ascii?Q?fRasbeUPzeITijbHa38udCaOzY223KMZZ86JVwYObdOT/tNkbzcZ87nRCepB?=
 =?us-ascii?Q?gw1GOkR7KdiDEPngzJbA6ubFSIyNtNZu1hybgLZtg2rYS3X+35gi6fuY9gPQ?=
 =?us-ascii?Q?Nekf9HBcr003NjY+bUC/FgmyqKxwr7WodJjpqbpZc4/4l3BHxf7f3962xPlp?=
 =?us-ascii?Q?mkviq7QsJhDMoAA0E0LLbFkeOXawm7ubPU14m6CljGgOLc8kNSXQwu80Ruze?=
 =?us-ascii?Q?hslRTTRSBfbm+a4oGLF8v41HlJX/trIX3n9Ik+ekuK8Pi4/zRX0qkc5L/6XP?=
 =?us-ascii?Q?w8QPBrXWye5jsggFx5Nc5pN4DjXpMa3NWNVkecyyR7ezopGnQIxmCMLXQpop?=
 =?us-ascii?Q?mETpd1O7jiv2IH9JvrPmB6zAXyNQeVKei64486PSojcQz2ZMUMazQggIgYBd?=
 =?us-ascii?Q?IMjUGlYduxCDYPoxXsDYED5r02z3xX8tKhTVjs8pL/8id3DOMF5NMgmWyH2e?=
 =?us-ascii?Q?50qbwB19/rrbjHdkue2KsnjvONf/pZg10r/Cm5hvtHAOVCzX6WVBIJ3dM2Xz?=
 =?us-ascii?Q?YDkIXU2G8ivFwi5qIUBOxC2JnkHXsVEJt3K1hg7X45aHOmkDj4lO9IXvaSAB?=
 =?us-ascii?Q?onlPVl+Ak6bcIkzFwLkuskFDdvpM+Bn3oYoh2IM1LrO7cBaT0Ts0x0emXBo9?=
 =?us-ascii?Q?oHaf4AcVhKmm+D5HdeG5Xh0JT4BXJWahlgJQ5W0TXZ6QRTn7QUrwqkSgLX3N?=
 =?us-ascii?Q?11iyLSFZAWE2yuYqg+bQWsecu5cC2C/ZcvBuAO/rPkcFVkjAAC8sOTEx/9by?=
 =?us-ascii?Q?3ebxGbFCJXTpkT5B9Cw+qy/pWRXd1vt3U27XDt3rOajzmrUZ8ZkB8f+zIACq?=
 =?us-ascii?Q?PoEsfxM3Q1B4cvRztcLMo0pf1EzAI4pET/JJ8zx2K0ksu6wRDXazxxPF1ZNj?=
 =?us-ascii?Q?s9jOAAjSBpCMiBE+wCaEW2MStkMvY9re?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4ZVi4w3oiOicMVumWi0RBfKI9cd5hywVowQbAntwKdQr5Q2C4Yl2pUlwoe3d?=
 =?us-ascii?Q?hLvbV9EgtfecgskI7Pbsz+iK6gpVNGt4gCShiAbCbAUscMoD9kV7fg2UxiJs?=
 =?us-ascii?Q?mzkRgcCeHx2U7+0Z9fznQh7x4jmzcYg00WBOOTQVFlW6nYbDXezzmcoDr+p0?=
 =?us-ascii?Q?FvmIo+9s3XzsHw2flaaq7cGjhxWrxKJYKarZ6L8UDEHkdtocdqlSl6CVooKy?=
 =?us-ascii?Q?+9i+8OXJ9LsleErmwjTfRMzKjkzRIKm1A+EJ9LM681Ih+bQJtDLibR6BpYr1?=
 =?us-ascii?Q?q66LjCIJJaKIJpSEcs+MSTYCJvxwbOfvJ8hPDMqg1bFdYFHNCGHWxuOdbyGG?=
 =?us-ascii?Q?VFzVHrWo7WuLN5LV1I1Bt/kqZjiLtGGr3Npo20ElHQoWUF0LjzfZ45F4cQjm?=
 =?us-ascii?Q?p+KkHzVN64NuA7SYJDnZsynPDAEJR6EmsC+kiZQ/htcPR3kCLV4Ic3isxtKj?=
 =?us-ascii?Q?YMl0L4RdoWmSMxlL2omMbq9/cjP25YoR695G4cvHYOU7LPLfNbBbNSqRDwY9?=
 =?us-ascii?Q?dhFpd/3VLCmSqL0XkWeTLO0AOlQpbb6mCyq6ZdYbHYQXLpKVl4qltM6rMvqS?=
 =?us-ascii?Q?4UuqsueO7k2AHUKmkUvQx/0NLRXDmWrHqmwB0EN3CXFRfPHtfa8H77kCr7pt?=
 =?us-ascii?Q?b4wGIJMaNc4UDxGOhr8StowTmea75EHQn0UhEhRH5g+Uz3L4DutJJ643896q?=
 =?us-ascii?Q?Nq5TMbSK9OQbgTcAcbDBxk8vSNr6fWP7DUvHD+zbHjg96CWJSGRaJ9JjDkln?=
 =?us-ascii?Q?13IkjssXFOwkMsxk+RMfWRD5VHK4ZRZHic7O7uUEy02jIV5hS6K6A0FMcC0X?=
 =?us-ascii?Q?a4J85OIcQzm+wkKZEnYZyPpMKc7xg6wW9f8mfi9bd25LQGl8CwD/kVP0r7yA?=
 =?us-ascii?Q?tind/xTC17A8TTWe81UXVVsyOfdDQTc/iplRiFcHMcgcuUGfPNIfDDeo/Gx7?=
 =?us-ascii?Q?RlZ6BloqCHq5CbtEkdv1oOM7zCraqFhqxpOZ3sWb2JevlQDEbV9vtuyCcxGq?=
 =?us-ascii?Q?UQ5yhoEcZKhxmsV708y0JkqHPU3MqPk5efK3uLca7GjHomx4t/psLGTfX3MU?=
 =?us-ascii?Q?jGx9Y+UspI0jq0k7+SkutTYuSvjJdxgcQMxejoYWBJ7tmoPlyzfEqC+EJjvd?=
 =?us-ascii?Q?0kJ8/is/zu+NplLsosrePmKeEOlYcjoJn1K+UFdLpz8QrMTeEIER0+YQO2ll?=
 =?us-ascii?Q?1+Tyhh7fbldMuvSUt+eleNvbUtcpiuo8h+MzNeuXRHSebRDHIX5GqziC93lb?=
 =?us-ascii?Q?yC0DzAC37UaBUWM4LqKQDr0t7L7LGYRsLtZSWDZCZAyS6mYlXSwaeRmPRLa9?=
 =?us-ascii?Q?XbyFqsCvKMbhP7lKCkMOTazs7nCzMBHSrzDZcDbEBMIIOQjNQdqNc016KOIb?=
 =?us-ascii?Q?7Yj8JAs4YrJQMHJKHt6a8m92GFFpT8/gPYsUIihnEeomd381MfGvCNspSni/?=
 =?us-ascii?Q?c4VyGD3jWzacuXCO2mceXEQY4iL/m6saZdWGMSuf/EY9hePjdgJG6trU7E6H?=
 =?us-ascii?Q?a3H5RQx22Y5ttAnoN3RAo8VxIVKCcqAMKV+g5M7jkeM/j4BCKtM/Ivufyiv6?=
 =?us-ascii?Q?/ZCDqau5MtkrZgW5TM5XO1qAr72xluTYjFi2xYJnndIH03YlpU3+wBPojU9b?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H/520x9/Wfcd/WAzZftKBEuceNBS8E4AiAVadPngus+5Uk2hKyrO29o9Zv8GNXnEjAg9alCBe73t42k9CCgesgog+tyyD7gUbzqdXbxsZbs/FU8DY/G11YLp8IMeVWXkvmhkVlgMGbgfwN5mi6+zqlB8sKiKE3yjYZxxGomFHNWQYPPEfaB7msrhJzsq8j6+Zy5/t+WCrQbWUpZBBe5q8IVAIH6srSqFbh1nhR0CQtrIHr2MaqTslLLQg3p18UK5ljsHMgEnNE+xtllABjwHawTIPl4g3o/hKRz3t/T5NAKzY6dRx/BV9SqboBjGFgJnsRoF5GowUu0RjuFwQtuW2YNiJUYMX5Hp9DnWRdxGvHJ4jCDPkD93ivCq+ShN2vGqHUqPAJFtvEmzguyvPGu33xuIhui55ybXzQ9OCLaZBz/6yQYzLhaAFNkybmIB6eJKAl/Mirv1FH9oGqEydcKQsJlxHaaulNY+YOJxFfsjrp+ZY2DlrLwv3/M9umWSaU3r0SgkzrW5Mn9wCIhMdOfer2bc/YFFr6iGCysVdIzBfKBLRKomSDNUwW3k5Ek6s+iu4J4CCMY2omxEP1fghYed47rTi/65Zw640LS21vXbemc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da7ebe55-5bf6-4566-2427-08de120e16dd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 08:28:05.7705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYPMdChcxgDvQffHigEjWwYeUTonwohup/9a1T0TcBsU+43dQvvHfOO2nSUGeiDezNyTuWzT2lIl7ic1CnLk9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510230075
X-Authority-Analysis: v=2.4 cv=acVsXBot c=1 sm=1 tr=0 ts=68f9e726 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=e-O03FiwzoraDiqANIQA:9
X-Proofpoint-ORIG-GUID: klx0yHught4AIOvQYBYcwtnFY6qU5EA6
X-Proofpoint-GUID: klx0yHught4AIOvQYBYcwtnFY6qU5EA6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfX/sYPS3J+9EyB
 +/A5G6yzD0rfwqGIh1kW/Cpcd7WUZRftWatdQlDRDikxl+k8ecM3/ueK2kWd+4wnZq1ZC6hpsy7
 za+hTGS0rjiXLg3f57qLSubZhiuceMm+ApS9ssh0Pn0SmZMIyx4L0N6EE2/1olVV4Dj2jhE6a8D
 UZ0FAmA3b1q1UotS/sxsB+gW6mapWBtD18kk/8KgIJmYUtW4pcRnPdPD1v+N0Icg5tPpCj8OMBZ
 1fiuoHT6VfRM06P+RhzDCd9Jd69YNB5mP4HWsMZyIOmhw212f1R/awQMA79zpYQyta+gFLfVxYw
 li3OkN6EvVG6ipvcV1fzlHygOGye7aF8sRQJv2ms2+4mWcPWUbUTAJqs/0du2IJ7syxsGFLM8no
 xu1DjYgxLXbliV3Sl0/Dvyr9mSKLbA==

I guess that the @shost comment on scsi_host_busy() was copied from
scsi_host_get() (as it is the same), however they do not do the same thing.

Also drop reference to busy counter, which has been removed.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
Difference to v1:
- Update comment on scsi_host_busy (Bart)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index cc5d05dc395c4..eb224a338fa21 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -604,8 +604,8 @@ static bool scsi_host_check_in_flight(struct request *rq, void *data)
 }
 
 /**
- * scsi_host_busy - Return the host busy counter
- * @shost:	Pointer to Scsi_Host to inc.
+ * scsi_host_busy - Return the count of in-flight commands
+ * @shost:	Pointer to Scsi_Host
  **/
 int scsi_host_busy(struct Scsi_Host *shost)
 {
-- 
2.43.5

