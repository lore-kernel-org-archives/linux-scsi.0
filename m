Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2229830E0DD
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 09:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761124141; cv=fail; b=r2Jt73lHpmqCEHamCWztGd/YNr1Y5IA3kwu4YRUiCbGKfsvOY+4SVJlvuFeRtHBSqJXZEmZrs//nonuDTCLSOcCLgqoS4DP+XhUu/Se4HgyoDmqYnJkvQtE7Gpv0+5aH6dyx6PbO3/CadQELG3R/kDtypQrXnh77Osc3L+aLLtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761124141; c=relaxed/simple;
	bh=cpSSheiqaV2VRzQ/jr39ocKOeaZyyJLVKg7DqxEGPYE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=XJWrh//GRvAH9/0rTp4bVyeabsCJ3B4PFAK5PJ/2YYzNDWCy9V2mUKXQVUK+/ISQ1cC4o5FJ9n734oObVmewB1fejbhiqItRpIehFV2LQLkJvlYmnN18b3dgvut6hGbrvHyKLcx/ysXFb0hBuT5/f9iFXZmT2SQhRZUOJO2Bbhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EGiCNG1E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MWlRBYZp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EGiCNG1E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MWlRBYZp"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M8CGof009143;
	Wed, 22 Oct 2025 09:08:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=arg/JXZPHmM6Cus+
	4atLg7CxrD3v9Np1lyszQO9+nes=; b=EGiCNG1Eohc57E8EtZXzAYC1p02B+XVe
	FXm0s2XIgpC8BPWgNgdexPv2SvMYA/cfxzX+ozk5ij8WtsQ+VoyJxBk033nOldjh
	qNq6JL3jOrj7/w618x/DB+Otw+Tv1prJwpkiMdTpoLOBqgos9ewZ/QX7EPj/PSDy
	z5XtkIRFc+SG+useiNvenm3wZvnEZzaT6GCToJxf8RhTBtR7xH/OLqMbIcZcm0V9
	m7eXoW/Rn8XyrAcSuerV0dEjJVj5F0xtEWv+1cFxRaHlXGXa6g86+55yvfQApkl/
	S0K0VkXIuDaHkycUtUSPIK5lcWyy5757q1PW1wBovbKPTGxahmevNg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49w1vdpcsx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 09:08:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M8GoNM013101;
	Wed, 22 Oct 2025 09:08:56 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010004.outbound.protection.outlook.com [52.101.46.4])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bcwbbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 09:08:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nerNH0iycdDbBa9NM2Ho+7wp55zbd9zRj9qy2uTxrSjB1jiTao962LXV0i51jdXlsot+/LJ5nzXAoEVE1fYXE1VZvs2oQA1RCsHutS8J71/bhDcg6nHNHtJa0DSR6TBcAqLsLtfXX8d9ofl0IEmXqbGz4/eLj72Xt908oOcaZGeoab+fg0AGZXq4Rb1DtbGtDcv8s3o26bVrlkgnAxPsgKkIafUPrSStc0IYL5MLtV+oRPS9/J1LFGMacxNpu2uHfWOO2krTnBLOozIpCAsJ/WREod2N6ooGq1TKaXVlS2zzcNVSbMo+n58LKd0tbFos1t6X/TPv5ykqnlDV8rxndw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=arg/JXZPHmM6Cus+4atLg7CxrD3v9Np1lyszQO9+nes=;
 b=i3HPeUF2Mvg8dAkup07qNFKn0Jm9gJWFMRmQA9VJKHboqkKabqbl9N4AKLSavMZHz5P7f1zbCZNJwKwnWKGn+mVuHE7BqDWyOvPUfch7mApfqJynvWk7wSuSl+lC3Rm0YyRfj9dOM72mkr6yyjh6efeLaaqz8G8Qa+rfKWe5XoK9zy6t2lnDNdlqjOB1AOcdnA+haShEaNNuxkl1TluPk/fHCSeGheJqcQWIwiiQFy5hgUlB2iSXzqRtNM5uNC0A3Rzop3a3nh6PvsaRRY4YkT6XkWwSMrkF3iQ8Bo2Q1AT6OSNmi6eUlhfdgEbDsUYbnzLCbKbGStwJpS2DosgT8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arg/JXZPHmM6Cus+4atLg7CxrD3v9Np1lyszQO9+nes=;
 b=MWlRBYZpq/oo14idQEneNR/8PIjyrkPlU+ot34On7Ejq4RVRJcjCFvDEEh5i+44CUSdN54VRFnK40afqDgL0QcRTuS8aa1UMACQ4x7O/McJ2+augYmZlfRyz78jYn8Ekqj/X7amVzLSxxDYk+kvA4bTYnI8i/unwIR7fP6jpKDE=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA3PR10MB8516.namprd10.prod.outlook.com (2603:10b6:208:57d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Wed, 22 Oct
 2025 09:08:52 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 09:08:51 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] scsi: core: Minor comment fix for scsi_host_busy()
Date: Wed, 22 Oct 2025 09:08:37 +0000
Message-ID: <20251022090837.3590047-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:610:e5::33) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA3PR10MB8516:EE_
X-MS-Office365-Filtering-Correlation-Id: eb6dedd0-d266-4f96-9c26-08de114a9e62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TCzihGpZoox7gflSfhSdfIE8QXxM8AK+BaqSLPEwR0II3xxrQx7WEGV5J+TZ?=
 =?us-ascii?Q?cV5rMiFva30UN6EPQlMad8VCcqLnEWUeTkxKpIWmISg0wB1GqSAawiz5J73h?=
 =?us-ascii?Q?Y9nm1QZbM9t59jNQHgw/vqrmQSF21vVMX3gkILWZi8C+1qALl0tPIbdkEzm+?=
 =?us-ascii?Q?yN2e1DBU/XT2dkFko/YBBbvrbOazIBVj8ZtKPT12Ars02Zcp6hi9P4moYfUl?=
 =?us-ascii?Q?AkDyb05ik/g68jY0m7y/3aOtqOVuXs5uFeFavDGqx9awbqENRrtEqxZuzP3u?=
 =?us-ascii?Q?UzX/ssGxwMTUwUzwW5Lk55XBf6EmT+tk8+MKxodisrF44Vnn+YI/yLC0I0/6?=
 =?us-ascii?Q?zVnoYC6vj1dAzdqwX159KRnuedhtDRJWQj4IV+wBnMBeoI6QBsI7HTbBQV14?=
 =?us-ascii?Q?VGRSTUOmGNcLGfeo+tstmJXidvu4xUTk1eAeRCPuNHbN5R/7LZc0RiBzLELx?=
 =?us-ascii?Q?k4Ik6R8/njFoGNZFNW0F0lLvz3rq0FwkA8kW15TEEZ4+U5fcqfJQhl5j4sBa?=
 =?us-ascii?Q?olK5K/mfv/ZHDvi/iAMymyYqUMU33t3zOGNgx8eahVgCOTzCtCnvvsYZ/Yck?=
 =?us-ascii?Q?BbNvRhiYEzdi+XcVR8swS0ji0M7ux3K2weWKz42BLARLwCWk08yHnNdnYyj7?=
 =?us-ascii?Q?bxigjau/1LOIImD3/8JtMg+n0Y7v2Dhg126QFC/I+gcx3OWXLNg318vyLXvR?=
 =?us-ascii?Q?NbvCP3yQjyQKuUYnzaBz3F/hVsQx8y4Me5pgDy62K602L3NCyC1ZS+1fFyAY?=
 =?us-ascii?Q?psM7r8vBmjcJWZBtt9AYro/07gGGNIdXK+RvFfRzvof1oHSTHVKiRqPtbTtn?=
 =?us-ascii?Q?xuPfiZoiVO7fWnxrqQTjkyCIU0QgtPYrVX3j6Lzf3PpEX29Fsp5Adji2pXuq?=
 =?us-ascii?Q?+deifyjsZfaAuwd8qdH+SvV8OQn2ZeSLaT47lEN3QUNLTxiGLKDqPG7KzrAd?=
 =?us-ascii?Q?bJiiam9ffAqZ7KlJw8uz7x4+9f6bIQ3fSI/zd16R4nLoonlsx35onL9m58Ui?=
 =?us-ascii?Q?9L3I+RBP0rZjkcmnM0Li8BSmwngGqOlLRD/+twPbJSCl8nJ0BPMV5Jj8Uw8P?=
 =?us-ascii?Q?molGs3QkX5oM9Rbzp6JzpNGxOFn9qV6UAIcDISRrjs9vUdguTM4hyNeDOmex?=
 =?us-ascii?Q?fz8hbfRCk92R9btE7XqiGTYyC5NKarLG7Xnbf1P+7c3oqLO639u9se6/gs2S?=
 =?us-ascii?Q?qSmIjpQtxToL8tv5Fw4tTIqhEvXuLZYc+Ukwn+NXOn2AKG5i7LcqEBEu3WGz?=
 =?us-ascii?Q?vk30PpPT72cfAjeiFpzMrjGC9fnors3rRhHadN9GM9uTgDQqNUkXIoMf5CLL?=
 =?us-ascii?Q?PZ+Z28F4TrbA+52vsxv1EuH6Vx5OJKfBMnohm6hlVhANpYCHil05fWe6JAwz?=
 =?us-ascii?Q?SVqNTPSVzvUVD2Xiqc4eqed1lRyN5PXrnn87IEgdKEAnB7kniTLgL7/Q8qka?=
 =?us-ascii?Q?NcyL0oOosEev/WrmLzd3iM3cqjXD3kuF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cP/tFksYXi6mhrY4TWNHnFrCAS1dJ2isIWG9FGrO/uks8GiEdY/zCPXIqZNj?=
 =?us-ascii?Q?sB76Lv6SOpqFWTL3c+lo5GtpryS3qtvENLpQxYByvwsFKgAmUwTioeqWGZu0?=
 =?us-ascii?Q?vkbQoHsMQlNEuShxdg1t15qGSlFYDKDGhBOcJgsu4DyceoGQorAgTLEY2ouc?=
 =?us-ascii?Q?wwim3p8syoj4XhyM8zGYg1NWtS8F1BRlHqQ0tmymUthach3p5FTzuuv4eHXN?=
 =?us-ascii?Q?Rk5Z85mavulMv7bwONsWHWWWcPI2nIg2wwqAm1FZv9AkX0G6XAbfJqZ+xtx/?=
 =?us-ascii?Q?CkBHu03uvD6h97o2/4TGkub4Y385RHa5eDG3gkLkAf/mXoxgTFD/8YzQAI4+?=
 =?us-ascii?Q?UPFAWwF+jo0dQx//6XAg1xJcVNC89r59j8UM8IUW5rQpfoGd32j/xaWCaYMI?=
 =?us-ascii?Q?6uL5Kw1bI9NXlVHKC5WGuFB0YzDZc5cDL4kI/kR4Pe6SHkJNqcgsPHB84srh?=
 =?us-ascii?Q?5kJhzITYjQ0wKXuq8o6IvwlfAkaJobORLXJqNQHhcFePCZ3ZbKzLpp0+/HVq?=
 =?us-ascii?Q?bT7SNYtj2PRtlo6aibTUEiq5VSvW/l0CXvmWTsCIEk683jZo7PXb8uWyiUab?=
 =?us-ascii?Q?LIBYh7PfXnu0n57GG9SPNM3ibDqih0Wz0D0DJJmMlvma4o8QXwTgtwQvffjk?=
 =?us-ascii?Q?HwqmDIM5TR+bp7eJtKQzTvU8IRiDr23yu8agZ4TF+aoomU8WyQxTYytWzUe0?=
 =?us-ascii?Q?3WWVxTIuppn43HNP4/XESuw1PoCZjnjkEstGyhXyjExfpMo+Za91rpXx8dBZ?=
 =?us-ascii?Q?HjxB7Q1KbcJluytr1BrwcS4XEg4vyCvB+lkKORkyHwtcnNudJVv3Uj+OnGmz?=
 =?us-ascii?Q?gXlas2ZlLa3hUFc3n2STnhZDTR/cj6e+SSg4oyK+eEYK1RHdPQFi9iyW4Rvu?=
 =?us-ascii?Q?prtf598zp6WXycDx6goT9YqhZjWL/u7AF6CH8NuqluvaFCPGD+A7y17WyYUT?=
 =?us-ascii?Q?ZNtZdPDrP0wlG38lR0plq9RKbkvJYcmQ90sjDNWMeULZe/EUYy74G5r7E90k?=
 =?us-ascii?Q?GgqNjtneU/QFBH0k8uNZyUpcTEofhX4XO2rtjWjX4/NWwQbyi8nh40ULTys9?=
 =?us-ascii?Q?eDdVccVXa9duJqvz1ANIVkvP4P31UMJSKL9LjB9rOxEViqUFg1TgZcFl8zzx?=
 =?us-ascii?Q?R5l11SlLvJXnj7F5Cd/3kbhqzWoJKsvA5/n9/wtYMs2spt4aFKC4Uyt7Q1fS?=
 =?us-ascii?Q?pohHx5uuIns1PU6ZfdHpsnBsgR1rSCou1d+QAaClfSZPzjkLoGxDZGrH9s+t?=
 =?us-ascii?Q?LSP+OePAyjlNyNmE8us7agTartarOYsGvzUlPWYe7Ci05alA+VAw/bNhY7pw?=
 =?us-ascii?Q?f/M5JmEY7kcWNp/2IvXOu2MryP+tNdqgQ1RMLIbqMt5ns6qZIWdsS9S77YPD?=
 =?us-ascii?Q?37/j99gWDMxNI65irxMNobOc45SjMxQEyzzZ4A4VtVOKYjPbzUV97ZF73xeO?=
 =?us-ascii?Q?Il3icUwJVDd7/bg0KlfIVPOaAR0ANvPRXFd2tUja/Wo6ERgNwKAJPrN8HXEO?=
 =?us-ascii?Q?flEoKlK4VJ1QYf0AWhGI1c8AqtAUqPEEtiAYuTRuXhZPcPlgjaZ2njSvxLXB?=
 =?us-ascii?Q?iSYMw/LLZ5pKqXRKy3RzpSSzurlnq0mZ4wpHLjVbDfbR1wdxAhCLWafY4Lar?=
 =?us-ascii?Q?8Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GYFpn0QYUt87C5c38Np6TPcw0WqkxFXAqSGT+rwSL7xnO+/HeGloAYQLfpOmvF3ANxc4jksTzS4CkehPABIQtax0+Yunr2I5xcnuEJ8HCwDPaDSqFwkCgX1IOKLWPZ41I87UnVnzZY5gU4/yKGm0wzf8XDVS93xYxQPQFFrSK+TyGrq3SK9OXq3r6sc567xUVClSZdXSX4cjJcJDJkFMOO8AXy2aNb5nLYmVC/9uxBXI1VQ5uQpRAfnjODUraMapITdselcxjybC19tbHZ4Dt8IwMl2O25GwqxjbaGGyygRdUfAuEGKvpa/ndu59ImPUhWGZn86lp+oDtVbjCBLgVxMe4MaSnav7NVxwjs+gnksTPQEy2sxGtgGpyKh+Hu9dxa3oCXOn20EDp2L8L2QQowmPt5nHff1ZNu1PMNbfzMLWJ9WtjY+2z5VbL2tcjiCk3gPylGuUj+byZSLfH0utKZP0gbPO/STGuiuU3Eu9yUAnIcVnxFS58CytRItWWTvkUTwvuom765Pz3jvkjyjnhyglb+cAdT0F3kzhcjGXEInrrjWfk5sCxTybVVYsWRcKcAhXMcn4DgPWNBA3rT9/8fXJ0baYOj4o5oIZ8YhlTjw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6dedd0-d266-4f96-9c26-08de114a9e62
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 09:08:51.7792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wi0yn449o0btZ3xp1atgo2BVbvHNejMLNryyJhp8YAZ2lZqcrhDwznja0qoY6qFTdVJgh33WGkRPx6H3Smmyhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8516
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220073
X-Proofpoint-GUID: Rt4rN_ISUS03RWVm7yaOUfQXVqxiJRpJ
X-Proofpoint-ORIG-GUID: Rt4rN_ISUS03RWVm7yaOUfQXVqxiJRpJ
X-Authority-Analysis: v=2.4 cv=WaEBqkhX c=1 sm=1 tr=0 ts=68f89f28 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Vc4yObdQlkedjWCvVfsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDEwNSBTYWx0ZWRfX/bPKs0uEB/xW
 OhRMd+cOxuczGvwkbyLzr25H+5pKAPNFxfG2zx023vDgg49NFjDncSOg/jQqIw4cca+iHryRErY
 fKeVfLYEMmu5a0Xu0n6TPqGzRPjT/62JZlpwzDbFH5mvsHA6PcY74Te0q8cLR3ic8nWsx7P27sO
 qmsrQ4HUX0ZvTHqqCyuvaCXDbwxO85J/Z1C7MNhJUOBcMzI1FtwwG83LgrbDp7jXJqWHAd2NGFG
 /WJ6V6kzdWOO5QvIfY3l9pHL1INKeTEPD8Nda8PwFT0ISYhR0eyhhOK4qUHsFwXdtUNmtSzgQpn
 ClS5g99DDRZF2aHiJ1eV2KwZB/H+57d2BxcqJLpSL/mNfpAC9hvqE6ezYrPp5G1DqSbCWncP3Jr
 dJNvU5jljXTxd8ZQnSlhy0QLiJKITQ==

I guess that the comment on scsi_host_busy() was copied from
scsi_host_get() (as it is the same), however they do not do the same thing.

Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index cc5d05dc395c4..64de1a647b457 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -605,7 +605,7 @@ static bool scsi_host_check_in_flight(struct request *rq, void *data)
 
 /**
  * scsi_host_busy - Return the host busy counter
- * @shost:	Pointer to Scsi_Host to inc.
+ * @shost:	Pointer to Scsi_Host
  **/
 int scsi_host_busy(struct Scsi_Host *shost)
 {
-- 
2.43.5

