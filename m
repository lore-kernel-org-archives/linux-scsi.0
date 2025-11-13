Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611463385A9
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 13:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041041; cv=fail; b=Byy5AHgXOimU449T+KbYT3huN/XBEB+oz2Q8knVD+VMi/UQCZhfB9jBjRiLXVQ6ieWKQsgPfBE4yWPErk28jGL41OX6oU8QfE1Z8mWaiwdkMevgNXsGj5V4UiFTCcnYS6MS60H8nBRLrh3mJ4T4+CUU7ucwQ95rk7kOs8LXxwAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041041; c=relaxed/simple;
	bh=+T/Zt1UadbXf3aH1zWpFhJgQH5X2UfARPbSmpRjD5hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jbZyytLaMMsTnl7wOy2JGHCdgiRkX6PR9sAC9Nnu80M1Rq9sRrgmi8eoO8Eitha+JeYbwHZ51lTrCkYRunqt+FCAvibrBvAVXh3eg5TX6KsNmaDrlZFJ+I5d3GhdKRg/p7S4kjO6Rahho669+og8FvdVBhDAr+/Q83fbzkx2m64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A87w7jfE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FOPIjKrR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A87w7jfE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FOPIjKrR"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADCt5PB022715;
	Thu, 13 Nov 2025 13:37:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0iGD0vqU2futjjZB/VlKteJwovOWuelZo3ew3QGTtFU=; b=
	A87w7jfElRRczU+3bnNfnG2lK+mUvPMqgUDUMCYnUQRxmHhMkZAwiqHFBt3Gmtj2
	ibOZ9q9eXiO6AdFknqL1BvdrlqyHzUkiUI24ApSmFNjkkG00BhXCtudvkTvCDCJn
	PbnZYJ2XH5H5aBr3SZye+wobc70jNaQJOALXMQ6zaHBY0cV+Ga0U9jz+Ulr/H3go
	C9/G5JldQjxL178xh0JIDZSEy3igMfXBJYmBKqRpBHSQLIxuT7rdERk5/F2YAS7v
	nywOfJkZB4aEgPAbkONgm9BACHHh9Qdmn3Q0XWyYkAKxe3XcmOzryK8qoaUrucCy
	WwFZJLKdaZjCnPSpZXejlg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acxpnhvp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:37:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADC0MxL003117;
	Thu, 13 Nov 2025 13:37:07 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012002.outbound.protection.outlook.com [52.101.43.2])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vacnece-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:37:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uiE1Wcr3Q0zZ23P8CWICfcmyOkpYPzWgpcinw+gZTcY4i87XuyBCgUFEe5d0Hw9WUnu6BLyqj+LK05q124wrmudwa89dsvjWMzMDO7HE7ptCDBRTrapF7hR7zTq3edJ4eGabjYyKcFfM8TbciQdE7leO0nwHaAHlHh7cEv6jCZiFJc8t25SdrtwkqoMUpL+YRI6IL3j/sGtHbCJxm1eeibtOCk/SLt+XueC2OzloC19Wa+cKYeQG1r6mmbysu6CCIlzweTZeS0zEpCpeA45lGFaoi/qm49e/22+E2LZbwucNKOOMSbPPPtWmxht4YZzM/gY3dlREZ7Fkqe/y4vP13w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0iGD0vqU2futjjZB/VlKteJwovOWuelZo3ew3QGTtFU=;
 b=QoKGJRELktiip3Qre7YiLgdChUtQc/jLuT9pOaYyn1qF6Toce+GXzDXRAf++3yuDmMTNfrsc3HkReRXQc/AQIRo7IEatLDD0MBOfGnMsMe9JEB8dYmr5sPxtLhzTk0oaOIYNLIoxLMkQnxSZV0kMELSQfh23OCmunNTqch3eOUIn2ZlF5K+C7v1LKWy7LR6lMgEjswxBeH1vj6Ucv7FwLqvUI5B352rEX6/jKB65L0BExBKTUWNOdlQUHXtCZAZltbAq05bMZZfPo3sXIssNvf4xt9SlMbDQyJXVt9TMwv8ZV9fwm351gtnAiw8WrVDayV/up6ufa25GTtpVRW+z8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0iGD0vqU2futjjZB/VlKteJwovOWuelZo3ew3QGTtFU=;
 b=FOPIjKrRaFXruC2OjTbwAxKzKEAQSZgDW0U9Yvmlv/USKVDM3nwhNgtqux/rs+s7ZdVba6+lC4SGvoJmLnAKRKmkewSabJ1Kvh2AxKrx+0CvU1TAbBhaxP7N8wMCa6g9oPI4HC+CN783CQdf0uVSKKtg/1Xg+PTjWj/MMEG8TLs=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH7PR10MB6252.namprd10.prod.outlook.com (2603:10b6:510:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 13:37:06 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Thu, 13 Nov 2025
 13:37:06 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, jiangjianjun3@huawei.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFT 6/6] scsi: scsi_debug: Add special abort handling for fake timeout
Date: Thu, 13 Nov 2025 13:36:45 +0000
Message-ID: <20251113133645.2898748-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251113133645.2898748-1-john.g.garry@oracle.com>
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0066.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32c::21) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH7PR10MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: 103f08a7-78a0-4bff-7fd6-08de22b9bc6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w9+J7yi4MJ0QrSXzPlUTFaitVdpBiyjCEFFlP+05QnVsk3lmmUbwRadq2uuX?=
 =?us-ascii?Q?v/sJT6gnjvL3pSadHn6CURb7wsBAtRnhO4bKbiJGS0bOArg/mHGwn/bYLHT3?=
 =?us-ascii?Q?6oyCphsjBUNycLdpG3Ye6dIa1S1EgrP8tKSIp30fltf67CPil0AvNwtqXN+a?=
 =?us-ascii?Q?/m0YW60Hx2N+qRcU0h8VspnmrHVr4KJjkTHAlPaG4dLkZmA9+cF9ItLh5Tcb?=
 =?us-ascii?Q?LN0H6GUUeohnx2qsSEzbWVSlN2Hm9ITlCimoZz3Udkj7KhIKEMwDD68XxLPg?=
 =?us-ascii?Q?CJIhbF2b7VZ4GJT3WZgqdL+kWu6Z2Gj+qeg5Y52dTIqQciGEz1AwWmP+6DS2?=
 =?us-ascii?Q?qYkiI44G6NYGXhV4pmgB3oWaR4D5aYSfZOUCXssZQvsnL+7tnSaROx0u1hH3?=
 =?us-ascii?Q?gKZetU3+LomjmsBGMh6IN2mPvOgts3OWJI875nhYxoQZ7vA09PD6OC/8toeI?=
 =?us-ascii?Q?UlLdVlprGgetBiScqoFWfTj7wUZtCnOSzDpI3yAEaVI9/iLpuMRgnAQZJvCv?=
 =?us-ascii?Q?qf2tcGntlVvdQNyWlNtpXsKXTR2etpB0EOLzfKdCO6BRnx20+59yigINYo+U?=
 =?us-ascii?Q?0i85qJZN+xwr2Ccfzxi17o7o69mFRyzvnK14UL9qtw7PRCS5RF4G1WbI3ldE?=
 =?us-ascii?Q?b6ldqSmQB0veHaxZwWXny9CsWCUa7Gv/y7QWmfSwxG8D7/IkV1GMxbin/DnP?=
 =?us-ascii?Q?y4EzDHfYHR81450ROrqpN5keJYS74njbkFQEEF9mI+srvNUdzqHWQvqPxUfH?=
 =?us-ascii?Q?49XzM8mhLNPy0lJ5o970KNG/x77DQc3QhMQTEEyMVqyI7GbbIT+KrZ8+WG/b?=
 =?us-ascii?Q?0YdFNoI5In0F/Tf7A4Ge/Pm+SX1z7q5+7GazaRybJiueAc777ARll1oZJx8z?=
 =?us-ascii?Q?IQCsZN0uBhkZLiCxuUxFlV4gf9fT64wjb2BCy6NN+r14wizQOMpF+4CvxJ0e?=
 =?us-ascii?Q?M/VzV7ymCkhotxyElwwf9NWa4oJqjJqrC0tdo4AWSBydJ5lCUmq32JgniK4Y?=
 =?us-ascii?Q?0lWen9Gd5xrJNAFjNkZ9C2ADE3wt4dh0pGWCE28K+5FVdNWCw+LEOQJpAvi5?=
 =?us-ascii?Q?nz3OvccH14fVug9HDo4ZAgRSNiAHbxuiegq3riBihzGoao8W28KGpbOrsDVH?=
 =?us-ascii?Q?UfzzdxGLoUC+7JCcsDtjkmbnJk+tgrc4Eh3h6LvKkHTvVQC4TVeB6Jh+Ghma?=
 =?us-ascii?Q?eYOGMbFoNf3kh+18Y+M1kirK0FhhGuExanvkkYSICCoo8YHI1klkUlIYI7Ac?=
 =?us-ascii?Q?IJWRYB8+MN+kjm5sMR89OdOJsBxpoSKCUpSIgO4WId4wC88dBTfUqVhP5QwE?=
 =?us-ascii?Q?mzhaR4VIHFW2JbgYt89lECHgVJCn5RZXgoy+4dffJ6uP0iXIc41NWew7NeOY?=
 =?us-ascii?Q?jHrG3EI3C8abDeFvUbHsPKNzdD0PfgwiADp9oT0gUeJ8AtM1S5/JOjK14768?=
 =?us-ascii?Q?fC9d4dzwFY7ijj9Z5xuerOj00VbxXW9J?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a6nYEwfgSIXjOcSIVqHH5h/t7vMymaHMS28Qcj7fAIrBldFmyYXLbRe9E4Kl?=
 =?us-ascii?Q?gy8C0c4l2Y7D8xop0IqEqvkS5BZn0HSbsdB4AqJbR7ejEHF68kjc1c8/zftc?=
 =?us-ascii?Q?s2I068RXbUaXDy/hB5vfKuKip1Noq+HNgtLqgJHiXvIVSa28vEqlnqZnqETc?=
 =?us-ascii?Q?ZaHl7lZXpzFUZ9dwmEi7OwSL9SsISv3uZE5zfoFW7IqFURCMJVtRud4lHayz?=
 =?us-ascii?Q?a+7eZcLqtUuOfBRIiwJPDekF7HvDmHqQEnTcAJvnbh0dX4SlusvibnktBesa?=
 =?us-ascii?Q?t5NSjkH7p+OSeQkulJL46iO6gr4GqIXSXpDGKjlf1Wk4tinfGbD82Z7zYqLe?=
 =?us-ascii?Q?NnNx/mE7wfarnIT0emVq2w57kgDMe6Js21vNJc80lfrImrZmQmNxcVC+nWzV?=
 =?us-ascii?Q?i1FZtXDo7x76pZ2vUxeXHz2UKuKWr850rMFl2okVR/GVcgsaQigsbF/ypSJn?=
 =?us-ascii?Q?ifOZQgbMZQ56BeSq1kvTlT/46VwLsDS5UCfHtNBVZ8tdIY1UEOSS6A2tYRxn?=
 =?us-ascii?Q?a3llDGTyMoQ063o3DkPf37EWxOGiWfyH+G4+M53oQoaaoQrbzYLNr2iZPtId?=
 =?us-ascii?Q?a3KJGHpy/8LoXIgBzlj2B7FwJaT74APEbuHFPAUGBRPO/OHdGSamphX7hjCf?=
 =?us-ascii?Q?VjfjcNzJVFnZ/oLiqcm1VV/MzRjBWfYl8V9nclIy86+sVWgovO1Y0IWlqepa?=
 =?us-ascii?Q?BD/Fbc2I9Dp0as2mmEVsU+EH39htNhbJsaOpAhftqLugJOWl0zofMW91nwPD?=
 =?us-ascii?Q?BbUvCPySusNAfhwP90TLG0h9d3meBgCWJH5rTikKEZfaCmR9o1fA3s5glr8l?=
 =?us-ascii?Q?N5YPu+uQ9O8WF1h+Fh0uMl1K1pUkZcoB0cnwtu+nzPDKOgDv06d5BjbOza67?=
 =?us-ascii?Q?4KnRszG9F6o3nrRdR8ZdWBkkdbrHhdxRuRjlqpXTKV68oFGqg6c9cBIchwtG?=
 =?us-ascii?Q?v9sO/3UgUf5MkmP+RpoqUDaA0Uo5H1L71CHZse/ff21ERBE7zlJqWFtLDmEq?=
 =?us-ascii?Q?KOA7d0K+i2Y10b9WWs8ZI8X3ZbUjfsqf5t/cnMOkMOqZ+4k2OoXCUHDUvOzX?=
 =?us-ascii?Q?PgGXq7UKp8cSJ6eAq2sMn3QBmhPBite9qwucEakPS4TIBZ7okLfQbv1dFOi6?=
 =?us-ascii?Q?xkoT/rcPzY5jOPzL2vwMS8fu08MuPrwg2jbH4a11TSZVapUKykPEXyUUwS66?=
 =?us-ascii?Q?Fg9UutB2zdVIyr7WZkWxopLUpuIsImMAn4z0rm0cKUg8Kje6AuweGTD+CQTB?=
 =?us-ascii?Q?BDZEfWJiYM4fwvCxPfXvrlGqJXlfkWDPCcffBrcP3rd7RKAAKZe1WK/t+8aD?=
 =?us-ascii?Q?jDI01XTPKu0TmrcDE45k/VqGH7f7e5Ok8TC5tlPXQ7tlDagkeuVbx80pIRIG?=
 =?us-ascii?Q?nB/UJdenPyVBIj6SWb9uwBZ5lyc3LNawImSmNYKbt+4x7ptH/IH4LTDfPZri?=
 =?us-ascii?Q?V28q9UON2tNXDvV17BgRC7HhRctSleA4berbabmtfAitrsHzaCKgdpIuNJc/?=
 =?us-ascii?Q?MNYaWJlueQwOu1Xkbd8qshv0JlYEA94PfNQtppFeHfbogKpbhm5GpYxlaDfA?=
 =?us-ascii?Q?yvgC17pEgP6Gvyq4zp4d50LUdfGcgd036DeiCf/wDOEd0qDIjvxc0aAtr9m4?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gwTBAF4e908ZFv1+FgBgjvjyzpmkzoQaUVM0GEn0wc0xD7mAdJv1S93i1M5n/2IvGbawnEWtOmtsI1qWQNFaa313Q0j04Ts17NFgOR8IuMsunupU1uKATXgtZPHssrk9tzY8kFw7vx/5Ah9NHC//2JZrH6oTgA9P2FtCoO+eKCkniJ+dOufxeXMhqCGngXyocegU9JEBx4EHJfaHrCiD/HjBCXUSn/W58ha2vz+idjnqHyE/C614fuxcIWHu4ZIl3h08HL4WtR/l2Z79mr/f0Y+vZLw0n5Ozns6NWqmA1RI2L658DfxFkVMGohwMh1MxeqiC72ZK0HCNlojRlKhSLpCwx7Kx3bQcr+fRSrnGpUUeB0FX9Eg9Ui+bBNi3cYDgyfqTKJMTabU31Yt5YPjmAWACuylZfhcFMvasWb6zgdn17iTOSYKM5ZwAhChFST3tTp6vPPvSi9DE1LiBzJyX1+IDaAN+HZOlR0guZPY0I9hV9Yg7cPuQuGXGt/Cqpxsbn43E9DlhrXY5loHVWBUIjQ/lI12JrOLc64ur9XZ2Lkee2jKIP8smGii7Fs/9db67bw5BNrE9EACISF5WdXGY6FleFaecjot9kEvaK7JMf+A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103f08a7-78a0-4bff-7fd6-08de22b9bc6a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 13:37:06.0032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RToErQVyd0bNDIyh4zR4W+eQTxYBYd4DmMbyLyaEKRE0ayuyp9M3L0FXlc5Bx8WEpJo53pq2JqoIWPmE4d9OMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6252
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130103
X-Authority-Analysis: v=2.4 cv=Criys34D c=1 sm=1 tr=0 ts=6915df04 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=LKFd_GnE40MRA6j8drAA:9
X-Proofpoint-GUID: orqKm2gbmy1ZYPmK24YW1qkC5CQfDHIm
X-Proofpoint-ORIG-GUID: orqKm2gbmy1ZYPmK24YW1qkC5CQfDHIm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0MSBTYWx0ZWRfXxy7tg0UmkbZH
 A4Hb+EZzvzICuqlEzFEbSnSc6uhphZqo9rO2kiwCyf/Cz7bAi4JnrOxqpOpj5bgZ+5DA6PtOaTn
 bzMTApzUGFmg8fnYZ44BjQm15PiF7GO7QDlUyc5rENBQAuraJDsSsbYLRGaiSDXJk6pgNJQq/5T
 qf9TcV/laWwZdDF5OjnIRP/cdlWxTQ4j3BCN3u2ryEDcEdQIva7Lfj5TfjT/jvh/IMsgKYpyOmx
 nWj/qTEUYwie2XoCYicDyYgDVvG23JuajXSYr2q9bd1whpo8+Mch3Df0GJlJKo3gbKNGVmeLpYU
 xaqo8aDkQpek27eIw0RSNLMv7W6pxExc3y09ohmWZskd0v1Sw8RzH85Cr8lMPPJycXhlv03tgBD
 Mmlekt8RuvIkZqztbw4qSWlYYjLtAA==

In the case of a fake timeout, the abort handler will try to "stop" the
command. Indeed, there is nothing to be done there, so just return success.

For this, add a new sdeb_defer_type, SDEB_DEFER_FAKE_TIMEOUT.

It's better not to use SDEB_DEFER_NONE for this purpose, as that could
be confused with when we want to abort a command which does not have a
fake timeout, like when we call scsi_debug_device_reset().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_debug.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 46883c1d99a48..4f383d97699bc 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -452,7 +452,8 @@ struct sdeb_store_info {
 	dev_to_sdebug_host(shost->dma_dev)
 
 enum sdeb_defer_type {SDEB_DEFER_NONE = 0, SDEB_DEFER_HRT = 1,
-		      SDEB_DEFER_WQ = 2, SDEB_DEFER_POLL = 3};
+		      SDEB_DEFER_WQ = 2, SDEB_DEFER_POLL = 3,
+		      SDEB_DEFER_FAKE_TIMEOUT = 4};
 
 struct sdebug_defer {
 	struct hrtimer hrt;
@@ -6708,14 +6709,10 @@ static void scsi_debug_sdev_destroy(struct scsi_device *sdp)
 }
 
 /* Returns true if cancelled or not running callback. */
-static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
+static bool _scsi_debug_stop_cmnd(struct sdebug_defer *sd_dp)
 {
-	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmnd);
-	struct sdebug_defer *sd_dp = &sdsc->sd_dp;
 	enum sdeb_defer_type defer_t = sd_dp->defer_t;
 
-	lockdep_assert_held(&sdsc->lock);
-
 	if (defer_t == SDEB_DEFER_HRT) {
 		int res = hrtimer_try_to_cancel(&sd_dp->hrt);
 
@@ -6735,11 +6732,27 @@ static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
 		return false;
 	} else if (defer_t == SDEB_DEFER_POLL) {
 		return true;
+	} else if (defer_t == SDEB_DEFER_FAKE_TIMEOUT) {
+		return true;
 	}
 
 	return false;
 }
 
+static bool scsi_debug_stop_cmnd(struct scsi_cmnd *cmnd)
+{
+	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmnd);
+	struct sdebug_defer *sd_dp = &sdsc->sd_dp;
+
+	lockdep_assert_held(&sdsc->lock);
+
+	if (_scsi_debug_stop_cmnd(sd_dp)) {
+		sd_dp->defer_t = SDEB_DEFER_NONE;
+		return true;
+	}
+	return false;
+}
+
 struct sdebug_abort_cmd {
 	u32 unique_tag;
 };
@@ -9293,10 +9306,13 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 				   struct scsi_cmnd *scp)
 {
 	u8 sdeb_i;
+	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(scp);
+	struct sdebug_defer *sd_dp = &sdsc->sd_dp;
 	struct scsi_device *sdp = scp->device;
 	const struct opcode_info_t *oip;
 	const struct opcode_info_t *r_oip;
 	struct sdebug_dev_info *devip;
+	unsigned long spinlock_flags;
 	u8 *cmd = scp->cmnd;
 	int (*r_pfp)(struct scsi_cmnd *, struct sdebug_dev_info *);
 	int (*pfp)(struct scsi_cmnd *, struct sdebug_dev_info *) = NULL;
@@ -9353,6 +9369,9 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 
 	if (sdebug_timeout_cmd(scp)) {
 		scmd_printk(KERN_INFO, scp, "timeout command 0x%x\n", opcode);
+		spin_lock_irqsave(&sdsc->lock, spinlock_flags);
+		sd_dp->defer_t = SDEB_DEFER_FAKE_TIMEOUT;
+		spin_unlock_irqrestore(&sdsc->lock, spinlock_flags);
 		return 0;
 	}
 
@@ -9451,8 +9470,12 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	if (sdebug_fake_rw && (F_FAKE_RW & flags))
 		goto fini;
 	if (unlikely(sdebug_every_nth)) {
-		if (fake_timeout(scp))
+		if (fake_timeout(scp)) {
+			spin_lock_irqsave(&sdsc->lock, spinlock_flags);
+			sd_dp->defer_t = SDEB_DEFER_FAKE_TIMEOUT;
+			spin_unlock_irqrestore(&sdsc->lock, spinlock_flags);
 			return 0;	/* ignore command: make trouble */
+		}
 	}
 	if (likely(oip->pfp))
 		pfp = oip->pfp;	/* calls a resp_* function */
-- 
2.43.5

