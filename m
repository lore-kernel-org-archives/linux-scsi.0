Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868EE175A76
	for <linux-scsi@vger.kernel.org>; Sat, 28 Feb 2026 22:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772318267; cv=fail; b=JFkROtRlrqV4mU93mGbrMeYxTTP4DetX3L3NAXRq/7Rm32jKaofMrxD+SjaFD6A4MXTio3dm4F7HDV65rJfk6BWivWMwdP0A/wXeGQvAAONkDrENqDRYZT6CplHHkcCN7/v4EzKPOBVJKl8SZmkbBAk33EgCJxDbiFn5weiBSGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772318267; c=relaxed/simple;
	bh=Q4uHsNOay6XFPpqMC4M3jKbqEVG70IByjS8V6VNH0/Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=cQfMUmwvEA/n1m9yNWT9TTYJ64J0U9jfu6lSxX8+MxuIvZqKD2hbB3LRbya9ejG3y8Wn+y826W/c9UsS6d5amGOMVX+ijNzGTa6pSFKApO+ZaHDq86Nk8jIE67NbYzE8eR57rVoxrXIg+/3odB802y2/+UxXo1nElbVJ8g+cVRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wk+IyirD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G5tF+vUM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wk+IyirD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G5tF+vUM"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61SJkbN93660623;
	Sat, 28 Feb 2026 22:37:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WEAoRDa+D5A+AiBgD9
	pmCssEQRoW95C9ffkxEECCz0E=; b=Wk+IyirDESZ/BqPYIxaZRzPm1KE9c8i+Eb
	vCKsU9yIiFcQ9BPbgxRTBplfHG1AiKCKrFxyBICwwx4kj+9CdssllOcM4OVYW/fh
	ylCOlgBDGKtETRZxGMb/hswybmOF1V+279lbodH39XoeLyv0jwLr8sbSa+FAtOQd
	pUDIxBSZJf2IRwRSU3AAPMV0ZM8w49b3Fp8ztwAG/cSmJvAu2p1hhgBSMbWLMjQ4
	ASu6wp1KRnxbfjA7xpnunSb3i5jOTFfGrdtlI1ZwUnvBCgMG6zmhJ2HroFszKwvR
	a8N48fzQ7E4oj16RsPjkH8+nk84MVcQNTB4x73dg/PIA2Vdu2k2g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ckshbrkm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 22:37:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SGjYMf037893;
	Sat, 28 Feb 2026 22:37:30 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011061.outbound.protection.outlook.com [40.107.208.61])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbuy5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 22:37:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vcBH6IftIvv8tVUA183TePSxBnq6nZiWyt0gBpVDXTDSS+W+vOEIUAjSUoPiy5IXkt+bu5QFCMj2gc5u8NnoT75LCX0pAQwduH9lyMU5emQo2YDlqV9ljcvdpahBvxsb8wmTVTQ1Z0HK8cH2AjYGC36UZrbrYhjtgXrroruaqOcBOoxst24bMjLRUGplbB9xWvZeX/rl6LViSkkrDHcADIvkWow60o3qe9CSmsWrGJqSIvIGixcz7Ois46pYGvjVHlx0DZqLxc06mCSKmfzQ73Rl5+WFL+9WAnK7IYmvRqVWzRA3/AfLK5NhD3B475VAqBDtLDHo0R/+hDJ8tc8Vnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WEAoRDa+D5A+AiBgD9pmCssEQRoW95C9ffkxEECCz0E=;
 b=nwKLMRdrmPg+R7HPMfszslB5YKZzt2p860iMjGpHh9G4hg4XyHmoqa48+etq28s491AXq/+XLEmUqCsA7b93JTanSTHtXJn7kV7OyHCwvN1KA5EbCJB7b0MYW39SzxrDcX+HUSkXoFVAUQOj+yIXiUuYnBrGu/MFbk+jYNNEAqzEwEUhGrZuioiMXMC+bxDeWMqbVjo5nDzJkCmJ1ryW5z/7PHRZveoS/Wn+Ah7HuIIEkGmQAeuiAhJg58m3N3UZDNGD8+UTZgFWb24F6TiIoXI4wMUiUeemSpCmFmBd+vOYFr7Cx2h9nNzgUuBXbq38SG82rvmd8aKDQv2YetLiMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEAoRDa+D5A+AiBgD9pmCssEQRoW95C9ffkxEECCz0E=;
 b=G5tF+vUMPXrZWnoUL2Ou4qg/IGyRvkhPO8efOZVChqt7mkrKX8EpY8Q4lmEm2+dRAbAHOtmfXXtPuWQMcEuTxkBbTw7+wo97mWzctM2/wd0us+a4qmR9kAqY5zOUu4Y5Ix7SnHrNU+g3GyGtGTzThzEvuhn/J8z4wx6ddNkEocM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LVUPR10MB997808.namprd10.prod.outlook.com (2603:10b6:408:39e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Sat, 28 Feb
 2026 22:37:27 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9654.015; Sat, 28 Feb 2026
 22:37:27 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <avri.altman@sandisk.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <peter.wang@mediatek.com>, <wsd_upstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>,
        <ed.tsai@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: Fix possible NULL pointer dereference in
 ufshcd_add_command_trace()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <b680084c-88b1-4854-981b-316311452e56@acm.org> (Bart Van Assche's
	message of "Wed, 25 Feb 2026 11:45:29 -0800")
Organization: Oracle Corporation
Message-ID: <yq1seak33dp.fsf@ca-mkp.ca.oracle.com>
References: <20260223065657.2432447-1-peter.wang@mediatek.com>
	<177198526950.1649777.14781899060414426367.b4-ty@oracle.com>
	<b680084c-88b1-4854-981b-316311452e56@acm.org>
Date: Sat, 28 Feb 2026 17:37:26 -0500
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0060.namprd18.prod.outlook.com
 (2603:10b6:610:55::40) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LVUPR10MB997808:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bf8c819-eb88-4937-5c47-08de7719f367
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	hDx4IrxckPPjFdHjXBnh1j03B0MpcQ7B6awdmNRIURdZhJxzUyghr1he8y+m9dHOW6VkkLxxB1kTd7f5rQ0XB5+nySpkZaQ+dFYqCtslCTfxGCmV4BMAzl72IL/4qFefxGybahBWQ6dAGGDq2fop23BlsiquYuv0jIvv5AsMECZDqJpXHuyPzsJSe+P2dzUvv/fKiKq6MPJMWJGsiWNNLANBsZWrvVblOOjxOzDnhcCVoKWG4USxZfm0vtZifxK00+k2ruhUjbYQzF6Tac98yxJIRFgsfgkCKCoZQqZwvgdLQ25FseZyCmAGOHEao4Pdm9eeAjpQMyfm2u5yWJlCnxIqRK5zgFe40fldCY9fvN+wRI8CgXKWc+v94e4WoOGrm/SIDZ+N+roAN/tT+mzA1h/3vdLiOuDqeNpOE20QP7ZT2erZxFBilDzeUJnW7FMQZWKvGku4wVwDrzl1Oq7lEVFx34mey1wVdpJCvkDOoreH73gXD2qii2UMRY4RUqFwJOoh/Y6FUChzhTmwt8C1aRrL5CUEvyUF4NKLdMq3RA7EHOaNqugASF0wn/f4aEeWTTi7AEFhlDeWjabbzt05tZx7Ry0ZPYhT1GnHZzCM/x4m/Lkf0nzd39IKdyU6VDD7Zutjw0e0qecTC9ij0fal6uDo4ZWkQEQERoZUY3zXAGCUlVFOI918PGU0uVDp1XzC8gwBFuBSZIfVskulK5uhvxN/EpXcZQ0No3YtyQq0tKs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3GCZhF7VBe+cqRcjtn0DjHn+gNMm4bNojhbF0SOuVb7GAm5Sz2oAkslkqWav?=
 =?us-ascii?Q?PDIDZY5S2u0KA1h+9YVVC2eW34PmLqVyazBhRTbmMJ+MjGwI9t0dU/cjsEuk?=
 =?us-ascii?Q?Ljr+ShiVTu82VGCLKz3SBn2uijBj5rl1A6IpaqGvxm5yezvTJBFNcqOlSrEl?=
 =?us-ascii?Q?dDV/rM+n/CsXcGK8Ks/hDZSFYf+2yqMFnjk8JvMV7Q77wzCuvSfYar4ts7m2?=
 =?us-ascii?Q?bSBiremYgXa0wiBvI36WMthE1wj7a8NMgqON5L+gUr6cr2EAGrfxu1K3VQ4Y?=
 =?us-ascii?Q?8ieis9sVeRbbZa340Sb1EZae8viO4CEAVP/WnQk34sZJfwFZ0d1I4Wq3Apsj?=
 =?us-ascii?Q?/h9PM0hieGqlrTZjpcWy3jnB/j/PJA7VUbU3wtGNwOTUrKHVMXZjHyPlGVfq?=
 =?us-ascii?Q?IuVxY4pNoWfpu3TbFmdhlvLKFRjI4mpy7rtR02Fqe79IxqRf0tcUYoLhdRVR?=
 =?us-ascii?Q?9tmkrsOPoEhxFz0shbxLe0mZIaDyj6ewTm0J9IQmIOPLe2clqdl9zMpkkqbJ?=
 =?us-ascii?Q?CtyqQMwFnqvothjlTkWUs2/Sm/2IP1tJE1gJKBpbqIkbBLRXMLMneBgCZyG1?=
 =?us-ascii?Q?gZCkC3kGzOvz8B9FjeU8uWOrQc0JmX33vmcZVw1hhuQm+DFBtSRzClJwOJam?=
 =?us-ascii?Q?ItcYxh23x/3UuViEW47Am6R9gF3fhs4EWHPbgGqs/CfBLIPdcWKQZSvx7yUb?=
 =?us-ascii?Q?Ioe1pSEVL6FE7itp4LPqDLWDOCy/wJe0OqyZlb/i9zwcEQ3Bg1vXgE+0MAgb?=
 =?us-ascii?Q?WL523ECxthD6W/GvlPFJeb2MKeVWhnOUMRBQB0RWm3kqyZGvdcsS3FA8hG/K?=
 =?us-ascii?Q?g3SLRlTpkPKvyNMnNLxqph0iU3XW3o3OJQo11jQlXOGMk3TptydSG4bxekF8?=
 =?us-ascii?Q?g60IPCDGcggC1ZP9Of9fIP6qqUnpAVTO8YZNthVHwfAJbDmW1qiaZKPa4MT9?=
 =?us-ascii?Q?Z74I9K1mr7TEjlbFWy+myPYlMkVo1XrO1BxM/AbkyX7yqb1QhbfJhL/w96bt?=
 =?us-ascii?Q?9VG0+UazD0XJhqW50bLKgiLUxCJ3Ey7P2MtnOGQ8yg1fOG9m4rCLa6qJd03y?=
 =?us-ascii?Q?cz6q/q9/QOdpCJ8Aq+CqZeTiv+PMm7ty5cPMmFZD9MVqfWqadeVjU2Sa6/pp?=
 =?us-ascii?Q?4hVlluhWBuLkA4LU10LymdoP/SXp7LDP6Hafs52f9sWjA8789IJ9xHMjLl5A?=
 =?us-ascii?Q?vczkkyMic0ACnpI1jouwroqIF5bei87Qjg/Anq/rhDxHhDhpmRHf+tkSoqUS?=
 =?us-ascii?Q?5Zr9rHA3Q5kmRxrYAh21G7iEykrtvgU67jfaL6oQsipjAwESGo1kJzsVUVV7?=
 =?us-ascii?Q?e2tZvIHCsW9XhKcOGFPMw3jTBTtxRaWhmR1rXtmjSSzbmns8YJQ5uvJ7eN7d?=
 =?us-ascii?Q?cxiUBzO5T6h3WT2x0mC1j9RDlLGzh2D4A2ehZvevCUh4LPMOCzcy+3rW5c3L?=
 =?us-ascii?Q?7nuhHbtUQZei59YXgs/k6PEurJ4nKCJm0oLijh1brsBArPpPL2FilnG1oeGr?=
 =?us-ascii?Q?RaqT+swTg9BLQW269lnjU1bDI4zqIxIGCYwG93KQq8ZDt9TYcc0eezMuqwFh?=
 =?us-ascii?Q?s+bSHAJw+rUxfXqCtT9FFMQR9JK6ei8y6mkprg5D8TLYuxfCqtWJb7u8KpCe?=
 =?us-ascii?Q?JTUgspdbUnZJVjnIgFZZ7gquQezeGCi/1LFVdt1zsk8EFn6ePu9jk9GsUaSn?=
 =?us-ascii?Q?bNBvcDUnkXfVL+Lu+4tfbQiPlzI5uMZ4VSteICVwlisrJ9C7jRqefsAA1zMZ?=
 =?us-ascii?Q?NPEEGrni+tGPTc6Fe1QXptIuZ2emtjo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	poW0yKj4TjGg3noNLLRMqee55wroH3A/4mLP6OFbkv8d6DsI3OZuPg+6CGbs0jfuoa/DvbY789JhyO252WLc6oQhRWTgkZJ1TyOAllqrJp2SzCM+q7yhUWcebc3J1J9Jsp2tGoX+/A5rAjrdB2oixavIVnO7k8dHfdqVGTMioZ4H9eXiGiMUXEaVbN1sTz3jSgVgy+QVKMQ8MkCRdXEkxb36k7ipzFr1hYAqzWZhahirY7S0A8ACeq+BLrUSK2TVJw0RI6YOudTyaltcoiA27yhBwqrirQc0U0EoHZ2tKiP/Uu4e4VzMbNpbOTfkOyIiRoAxMP73ZFHE6I20O8Na7vM2KEO4Ny3xnAKgQ/V50RjkmbZKMxUKj7tNdt//4CPxX4wBMw4W7cn3PoJlw0Cx/m7XUOM62LHo7uoWbnTqXHdAcgf7pVjaChvBGQR2mcp26Y21iArM2R4uQZNvzvpduNaHmB3pQVLVO03D1W5QydKHxpGiNtNzTUO2SQoxlA6XzVenBGE5O631AQaaVpqb0fJKV6xSrL4rCoZV16JidNUl6mMs+j/9FznWbeoyHoVkSwndDXzoRsEyLx3w77lvoHqpBSd3yIFp2XmGt0VPzBY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bf8c819-eb88-4937-5c47-08de7719f367
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2026 22:37:27.6383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XN5ycaXIMO6hUVXVccfBprOsa/sQmLFe5bsPme4uXyBwKeUdK+y7armQ3uPlk29HhdIUcA5SqsPnRVSCknuwcvC2TKsNasffRD0ZVWiQeVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR10MB997808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602280211
X-Proofpoint-GUID: tGMj-olckYN5u2SI5BA18x_P0_Z6pxxL
X-Proofpoint-ORIG-GUID: tGMj-olckYN5u2SI5BA18x_P0_Z6pxxL
X-Authority-Analysis: v=2.4 cv=Qaxrf8bv c=1 sm=1 tr=0 ts=69a36e2b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=Lm2FMXjhbsI5m-5NRS8A:9 cc=ntf awl=host:13810
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI4MDIxMSBTYWx0ZWRfX4N7AQe9vW1vo
 2mt5Xe7QllnoUOGMhdR0gt7WdDacrRWlHsK5/qQq144Y3lhdpENTSQ6m542ZbhwxXbwaachTlmg
 7Es9BPXWG8hbtJPdgZpMQFOva9fpwbe/yLp04BArhfph3yhpUfynmk/YcHwx2Q8Fsy6C8xeG8wl
 4aK2RWLllxr6UIFYS9GzoytQLpDn4tGvcw/ifj3xt4Z+LzFJe5Nv3LOPJmNXKXXpscERu6y2WaS
 +CKY7h5x77HIq879GmCLLMXZJZj/eCm3Xj+uoLhKxjOMB747cyt1Gk5BO8le5tmR67/8sdUM4Gq
 M9dK56dAnXVvpIICt92AeVtCqRK7Qdh6D9j8cNYvb1Wmw+g9Pw25T62NLyJ/GxxQ8bhrmE6A2SJ
 XpX3aRQ1EHsEkDzsvWZ8BxC0wiud7HhtFFZ2OSXqON8uQ1cNC9GmIX9dozQH9YdvExMV4Rxsk1X
 BLvsz7MUX3ihSrpO5F9ViE2lueFo5L/NPF6h9KwE=


Hi Bart!

> Do you agree that the following should be added to this patch?
>
> Fixes: 4a52338bf288 ("scsi: ufs: core: Add trace event for MCQ")

If I hadn't already applied the patch I would add the tag. However, with
"Fix" and "NULL pointer dereference" in the title, hopefully some AI
will pick it up.

Worst case we can Cc: stable once Linus has pulled it...

-- 
Martin K. Petersen
