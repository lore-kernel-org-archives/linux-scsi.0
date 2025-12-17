Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D849237163
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 03:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765941751; cv=fail; b=CFEmK11U0LL2hEa1C8rkVl21qABIa1yAh/gVGvdQzADGRsDEU9SQQcpVJiIAfVA29AgUZJZ573xb6GT75gBJL+2ML8MPKyhUinKha3Bdbd42aUg7VcNykl01b4NfkU8YrPnQ+I8vmvlbXFN568/xhUQNqbHzcYcWoTBl/QIHX/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765941751; c=relaxed/simple;
	bh=PouEM3VsOqryJe51Ch2Q6+SaNCcjkSe3N8QDAsMjeqU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dQzHg0eeXuMll6qfbDJBdqg22/9ArU0AyzKi5Np8faj5he41fLlcPwreR7YDZbvjjhH0f/g7mkuFn+JrnbmD7HsyLcHYnYtBf5vQ5eqiekArVjCxIy7aTXzKmiSa7z1TTE2rYqqD6jf1xjwoZ+gn7fgw5+oX3lnM6xBN7O/7USY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OdatNcIu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jQzCDfHN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OdatNcIu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jQzCDfHN"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0uGbD1821589;
	Wed, 17 Dec 2025 03:22:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fp/Ys2wiayr9ZY0zxI
	ageKoWMVsa5HrCNcqRD1Pc9dY=; b=OdatNcIu6S+uTPFn4aHw1KSAtb4IFylEAN
	37EoJunhAEZPm8iyq0jJEtuFkyay5DFh9D5jRBndg7q4QQoiSoELA7qCBfrE4r/R
	RP3ji82t2gcDu7LFPioEZ7V1lM7Gy6kTDRcY0MFATLm4RoaOoveez5NOUfY3TbYp
	J6SK+k5XahGozGlhlBmobIU4ASFXn/EMHhgXq5sx4wmMxy63qAaXxKCI3ICqDxfM
	tBCPFhp8oXoWAhK9/zcCKrAXcTMcDn+H1T0OUpcZPjdhUgkhApj90+7avgG4CMtC
	GnhabG6t9ySEnByhxVKn7jW03BQEG86wYlB6se4uhWsYLB8m6Ztw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b106cd4ud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:22:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH02YvT024951;
	Wed, 17 Dec 2025 03:22:19 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012021.outbound.protection.outlook.com [52.101.53.21])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkb0hmd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:22:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hwZoCutsssYivQAqCoN87yFHxRyuTt6sms4HvHeMxoRbtbN1G672/BanwqjZPrQqgyKe/tpSZ0wIoqOpR2e0ZQ3WQdizc8sNTlySi9lehSLI/F3+bctZJN17iX3iXKXTGIajgIh7JRHpTGMTvUTv+f/C65TuC6UoDfEOxOCn379UuPrTNmhRpaD5ugjnc3/QHIOihTfcoWAGFh1dcmhJDBEANAIFGEgwHoSbBnk11Nj0iUyElUHmyW97WfHpPe48bsPuNg7gJ1Oqvb/KyI4eA7afMXEszjTCRVApV2kzK+yGUuI+YIAUskd1rPqNjBw82S8Y28YPoUo4gTaMedzqWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fp/Ys2wiayr9ZY0zxIageKoWMVsa5HrCNcqRD1Pc9dY=;
 b=nV2t9f20hPknOdEHtKHU5ueJLKdaAZ0xxK+vXwAO3MOARproq86f+rgTcoTnDnJZ9K6Padzv1+V1E71/Lhw+IIcs2vXBjyPrtQPrvQZ7DPVVsFb6kdqLnYIFa2vNcoJj7T5JMPghEnJgnbb25aYcUCii8xxkrDEoslVTI40m3n3e/a4e6WdIETEdsG/3KIsQWrM0rg/sJa2cRMaDmbRZ3I3PuunLpN6W3+6Ti9KHsmkQv1WDkdGyaW3YSchwh7FBzaYxpqlfyUYk2ImvFtROSgsdsv6VPVYK2JDP0JhdLD8nYGXU81FnsvY8uucaD+aRNyBEbcOIItO7mk8yPjJyDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fp/Ys2wiayr9ZY0zxIageKoWMVsa5HrCNcqRD1Pc9dY=;
 b=jQzCDfHNAeCIL58gN5rI4eeJE4y/S0wsVl8EX20x+B/3eIKMoCwJ1kdxLmmv2YeKmUKaxXwgWR7ZBuE7Oq7uE2ywOFtS/cHx6HkbVOgCqQIp2nh7QTcMWRepPRz4Fj6GpRGgprwqYxKVwyivhF1gXwkaZswOsBIdxHdN7WCUov4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM6PR10MB4123.namprd10.prod.outlook.com (2603:10b6:5:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 03:22:03 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 03:22:03 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, John Garry <john.g.garry@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: core: Introduce an enumeration type for the
 SCSI_MLQUEUE constants
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251113181730.1109331-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 13 Nov 2025 10:17:30 -0800")
Organization: Oracle Corporation
Message-ID: <yq1tsxp4wtw.fsf@ca-mkp.ca.oracle.com>
References: <20251113181730.1109331-1-bvanassche@acm.org>
Date: Tue, 16 Dec 2025 22:22:01 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0069.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM6PR10MB4123:EE_
X-MS-Office365-Filtering-Correlation-Id: d89f8476-cd38-4342-a3e7-08de3d1b72c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cGXUMhZWv5oCfpQy3+FpfGw7LWe25kzJlAga2Ch4+MAPpnMZxwOQv/kfCVFc?=
 =?us-ascii?Q?M8jQLawG1A156Mb/KFbGnsdpflvatp57621cf/sZBzkT3k53fOaNOgtn0EP+?=
 =?us-ascii?Q?Hw9i0bXzQLsOUJgJ8xUxEgQAAkNG3b8F9SaMWKsWMZAmJgKTEFtbC4t88rKO?=
 =?us-ascii?Q?Mt9wirHzZonBhHJYyTFZzkfKH8NqVvwyKdWbtNGiuVmg+8Rb3P+u8J40tLb1?=
 =?us-ascii?Q?daJv46HMU2FcCMakPRt3Fui2NGMTTn/IuVmlPnCPQneaA3P9aK7EWCbBLqT5?=
 =?us-ascii?Q?UC8kHXw+8YQgGI5MTivbzSWDGYkTpiTMgXLyoVltvT1fH/3lrw5DJ0z/f1oo?=
 =?us-ascii?Q?xaSSp68cVOWBF8aBZKpXRPzi8E+y+iad7SaD7lk+vWVL7sOgdPOSUGvJGfd0?=
 =?us-ascii?Q?sXGQifkQsTasG4AyDAjyITdxay0Mz/V/jCz8aI9hdLbf7aPotifZLnVI+k0F?=
 =?us-ascii?Q?K2DUZtWHnyJvkbyduhiRDgOsgt5BXhSyif9FEpiMSxZn5wcn8RLidIy2zdcG?=
 =?us-ascii?Q?rLWO0d55Aw0y0R6IpPSHJ1ASM9UQrx0dJDXlY1BwqZJl6lChTHamsEJxdmzB?=
 =?us-ascii?Q?h0Nj9NOTYYM5LNMcRXO+Psle7LsXVoiJUNGj64qmUHCBAFZ8YAn8wr89SIUc?=
 =?us-ascii?Q?cbA7gILYqJAIAidacMx1W12VrvOCu71mAwlZ2yfhFijFhUlJEt6UiA7Olmwn?=
 =?us-ascii?Q?9XrpUBgN9q9aIX3Y0XxCGzPb7GPpo0Qj3N3M1DHY00wlW/NsFMlT/uQgi8g0?=
 =?us-ascii?Q?6NUCUTrAhEU2haAMTxpty0PFe9r3I2qID/q9WmK2j2n84EY27yMZTxSdYGlA?=
 =?us-ascii?Q?PKvh5h+baMdnSeTmodWC2TZG9slY0ek0vnaomeCnbRFLyHx7FPcdhKe6sBev?=
 =?us-ascii?Q?bRS0gq9X7Y+D6qlvdrQViBw1jx/qsJdEZRrFg6mRangGnKTMDsj5ige1NJpH?=
 =?us-ascii?Q?F428i63OJXjWDdXQdXn8rNVKd2HMLvKGeN0ByG2JTUhho36eNyprYTHgi60B?=
 =?us-ascii?Q?sy/hu0D6HEDhWIjV2zH7dUCuqhjSOnfvQD6W74NbrLr0tMOX5Uybi2le2ula?=
 =?us-ascii?Q?9HH0gxg5QJ5aIH4z1/ErucHtNdpuXig188e1+wpxjvQ/9L2MmTqStIwVQ7K/?=
 =?us-ascii?Q?wN5bTFiMrD0DV0YQSAuuvWOvcUMA/VBy5UFMvUd87dRTDLqla1VDPFDIZQZ0?=
 =?us-ascii?Q?Nvfu+xZEY9AQaviYloviNvTIbCu3M+Bo2udljsniekkbLDaaA8arcrzvr9c4?=
 =?us-ascii?Q?Ne4ppWMdsYAr/qI2yV0UCHFnM4mMzBUS7WKCbIH5/7QhCAUS9IeJhn/ZasTQ?=
 =?us-ascii?Q?as/sC8Vo6LxwUlKYJL0MP5A6rLh2JN4jSClJ/3KdXPT8YFEjwHqeLniXJgje?=
 =?us-ascii?Q?po4r7FwOczV3OmsWl5143U7S0rf4MnOpLDlpPcQsSClgXwiJQKSRYpzqmD4i?=
 =?us-ascii?Q?VGsACjQoEuFT69CQ7eiXfKdTM6OQY3l2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lsuNszTmT2KkFnCSPCsV1C+NQeCTfts/VB2tOV92wDl5i31PjAGebGj9rS0t?=
 =?us-ascii?Q?vl202Fdx3uuigOOgFrFvE2d1BWQsVbximvffCdrnpjq8BpO9Hn5nzHAChwOO?=
 =?us-ascii?Q?UUY5n43RrNrqrK37XNAEgbjCO1nN2HxEp5+wDVSVte3CfloJeq1LLFVCr5tj?=
 =?us-ascii?Q?a8xH5gqzcfxYoJsneGxZdYEGsy1CHa3gP8mZiRyL5dxwi6tlsMx1gbkJ+5Y1?=
 =?us-ascii?Q?eXs83+9aTq2Sjn335T8kMPY7NCyd+gdea+muGmz62UJ6F8WYBRjQdStWZce9?=
 =?us-ascii?Q?No1iXsp7w+O4g6xUVYI4/bzB3X9Oi1SxZ/VBLw/SWHARJ5TbOM3aE+K3R03A?=
 =?us-ascii?Q?NE9wyVEjEGfXMUw5VrpvlLqrKf4sx+8Olb8JXS4o1utoHAQcmLKTK6sXYXiz?=
 =?us-ascii?Q?UyYSjKR/ED8geP/sQxrT3nkgbq+kwjVUuUso39GFAGdTH5WHVVhsf9Hqm7wq?=
 =?us-ascii?Q?p39LXE7MDoR8ADdUOeKrNq4lu5t7vOVLyFA3TVmMQfSW1WSQtGBM/xSWdud4?=
 =?us-ascii?Q?JkSWkzZjZ9xpUPf/2GaQRLcjsFxjB875a35uplBAwktHnBMXl1xT8b9UsYDf?=
 =?us-ascii?Q?bhzzEEStJrCIypEYnKQWwSyNHQGm/ju5TdXf+lOaM/pgUsvSbvYq1+8MFwvn?=
 =?us-ascii?Q?G4O1p2YWw8wmmNgnQHObPnYfGbrCg/urlseLU4Qvf96UaLxROR7Lfgmj7nHJ?=
 =?us-ascii?Q?+NCeeFd8knF6LF7ZcllImSdpVnhugxXJ0B9hJBHt312iwWljBN7sTlJnfWVa?=
 =?us-ascii?Q?DG5/je4tWiWi0wwlJI+Yc4GidKk+gW03T0zhKJK149FPEwyx//MJ7H5C/NP7?=
 =?us-ascii?Q?PMJdfW9LPdBQE5Pr+zw5YeTNEq6RePrz6jsX+vOoFezU9ygSnAqhBqt3iIhY?=
 =?us-ascii?Q?opSqhl8SCzltT6tJGqYtSVOlt0FJNCuQJKjOQV+bs9sMhI9A3NpvnD4FG6kD?=
 =?us-ascii?Q?D6xpgtW9fZm929C1G3ABmZiqa574z6UfVFsoxQpDguz0iw14wPqiU35JM7p6?=
 =?us-ascii?Q?6B1qk0dWghyCLtHMsqrYTHb5Psis5uYsOzkefw48zQZ9nnWPfWkV8yVQg8oB?=
 =?us-ascii?Q?owe8wmh6AOE+AL4culg0nkO62FhlONi3/0MyjF+LPu6an/Y1o4NePrpj4M5T?=
 =?us-ascii?Q?C5XoDYJRjRism3C6jzmt9EeLU75y99Z/qi2wJrRYUK/4iDH7L7MuAMdiivCC?=
 =?us-ascii?Q?bltJbqm70pWTMaHQ+mhMxQr03KuPGtrHVZSKfLQmocfHmW6HWoc4kdDD0AZN?=
 =?us-ascii?Q?jsbZfttCyGTvvUI5jnb5N0e/Xg2zF3cwAgGHsYCdYD5woRgIK9hEOYAaJ0wv?=
 =?us-ascii?Q?TaGGrLPSpJ1kAvxyMG9TP3by5y1hmAJbfNA6kZ9sF+R3TuqalS7e+SKpcGOH?=
 =?us-ascii?Q?YvYWnQ6ArTbLRC6ywVDNtKd+LVlprLkbfneXE0CTmM2cp4rVdV8oejseSpOL?=
 =?us-ascii?Q?OkQrpD/Ec/1GEKVkyEz11fAeKYgH33rrmcXyh2BSj66AoB0K7E0yoFQeErmw?=
 =?us-ascii?Q?kLk/yF/hko3uhq0y5KatBqnk+04BiREgutlrszoEEOB/be+UtKqdlvClMQny?=
 =?us-ascii?Q?9QKnQSJmAM6aZfK9qmmqZmYHs/6Y44ED1++5xFiU4XhyeX3046TGVz+qYgUt?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ckCUNFPN9fXQ/KCYz5ev1KcosDe5vzWX/5HB8J7nY1IVy8rgnPwa0rfP8nfJW99uDWGI0n+lc+JzHzEjYr9hYLbklJkvUkwEAuPkICVZHKUaw9k81A4LxUPobVnZDXWvBjY7zcQ+htSI65G6nCRAY9gGrjI0wcNLcdmQh8oXPNNwl3QE1RaR5BmwPrHS5XJtOPU9dfdPP35d0MOUxmbS2LL6oM5zVFBHiYw+1vI9phtD/UfRBH7aoMAXFcBjBXxsWWzEeieWCpI4xVDtsBMQTc7LaauoGP0PFCNLs3fnwZy7mO/eXSkD/p/I3cfT6Xjt78uCZ0yj/hcRcqfC7SMSF/6txj8RRT4j/zagg4fvRB+6lZK3bhku0X5PRinSoY9moQbrO3KzqbNVbXifGQIkr7w1rlf2AaLyzc1ReKLjZPSO48G1ig35HWKwqmMvf/J8ZBN1cUP5NZb6RcgFIzzuV1J4YwYiQWL0Je0YymTQfoR/voVKbTumdOzNdq9lwvXneTyonxOJyu50RzdWHFLmsrnBOvBTYtgNL99wJ+iKDPg+Ug3c1V9R1DEEZKXdLgSMAgM+gRB3B7vVS3PWAkCSlte8evAN/7E23hFyF38Llc4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d89f8476-cd38-4342-a3e7-08de3d1b72c6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 03:22:03.3272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZPXlV+D4J7xiUc9U4JNBE4ch5yQo/kdjWQyqM3Sy4G5WVsS1P8S0oPJ/so6RcnH0Ez5bHp2bR7nYxFh1TsJiPrs0+s5zQauHVAoc6SBGvI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4123
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=974 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170025
X-Proofpoint-ORIG-GUID: cKaS91mOW-FKd6_W1RgDaHqaDh1FdCDo
X-Proofpoint-GUID: cKaS91mOW-FKd6_W1RgDaHqaDh1FdCDo
X-Authority-Analysis: v=2.4 cv=et/SD4pX c=1 sm=1 tr=0 ts=694221ec b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=8OhoyrWyNRS1XNtXBHsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAyNSBTYWx0ZWRfXx8tbzn5kPRcL
 /pMoW84iRTKNZeKUwVJVCkbzMDBKFyDigDXmKint3O9FFGJzz2YycYtSqMRUn+JhMRzfSk7iTQc
 xOmB2vWHdyZFPVU/7gVGlgcsbRGDMfb+GLvGeftUyDbjS4K5qXQdrQgA7txGK3+EDqv14zAg/Ho
 HtdvqFUG84QiXYK0/TQcvIaHRgsQtcWtDzLiGWAO3ojGo6LWRH6yabaC3yjzDxodnapRS26kmi/
 ZE1JrwjtMCUwwkecwXbzm4vzxUg83XWan4qpoyj+WXhxmlLBiJCCVMRI8P53/7D9ZpSOnka3nUR
 FYbNSg3K0fg9693s/5zGa2Qw2AS4pfVZU8zI9u2aG3NSuNC3vX1po6ZncqYrqsVnSUaF6o+ULpD
 kd3+h4zWi+MZLIM7mXWTxJ+XWBvcfg==


Bart,

> Multiple functions in the SCSI core accept an 'int reason' argument.
> The 'int' type of these arguments doesn't make it clear what values
> are acceptable for these arguments. Document which values are
> supported for these arguments by introducing the enumeration type
> scsi_qc_status. 'qc' in the type name stands for 'queuecommand' since
> the values passed as the 'reason' argument are the .queuecommand()
> return values.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
