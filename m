Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016692512C5
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 14:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743689381; cv=fail; b=h7JCx5cMlEtNzsjUYOzXlHGZZqRLqSL0rRaAFwPh7LeCzwx29j+wbuB500CDT4cbxKsrJBWmQsExriXrZ3Gd3Lxjaxf5QqxRUbe5vDBSmhOHc3OwY9s/QlxTwEK2Q4WfNxzHlJhvBkWwFqFi1g3dIZ+r67Xp04Ff2L8nyGqe048=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743689381; c=relaxed/simple;
	bh=Z0ywSdVyhd5MQW07HBf5O4xzhn9cM2IJjoWKOboQamk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lBUvv2/iVIo2mXcTgbfe/05JzsbrbFvpSNJ3SZOf0MYmEmz+hbJ05lQiK6b4HIvWGR3S3ZhSMXahuhNlt1GjsHgSKvKT3p8mgQXLexfiuyGF+YIj0rEl6jmptO9wZRELos/IMCzy5a4HQHSJ6qqOnYHXoZ7LQSEgyt3tkm9K0YY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EUJLZAbE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jpwMIWi1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EUJLZAbE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jpwMIWi1"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 533BHWku022236;
	Thu, 3 Apr 2025 14:09:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=0LRZyG/NGceBE2VmS2
	iqXYMGtDMscOX0yrvK0Da1hgM=; b=EUJLZAbE0VD4K9SKK3EMjAO0O6+UZRfcnx
	pz2g/Ma12wRHw+t8giP0oYlPN+SzfjmnawPW7Oi78m+t+oAyV4XR+CiZmhucx3q7
	OSCW9+BxMJcPlOojH4UXooKGb6v8g1MesqGmcou2UkOr8uaNwt22gcRk3FNFgCTP
	xgY3VBBVEwMhyaPa9UFZJIE/BL5x8FJGXqLQYFBMUJCEvlwmrxMIoxn3ZPRAplf+
	2YRCxBXxoCpVN1anTWYTvPpWN2oR3q0aLjWIgfus2zB9zx0GzpuOhx+qniwb1K1I
	y+PyopnyrXBRKnsJIzyhcny2cdLBcXqoBAlup7f5b6ATIZ0Npyig==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p8wcndhm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 14:09:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 533CWM53003370;
	Thu, 3 Apr 2025 14:09:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45p7ac3rhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 14:09:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WlgDrt92dC5tJUQUA1TMpj5Xs07ElokctzVfH9Y2mIh8e957jF8ZJpqr84RHSbFuJthZLMIvLP1Y45DCNGWwdTIsydO5MUN995Mi1P9D+wFeNPvBpBga/k/gJb9ZMu76WSsvCuK6nqEhCkvbR5RbUYE4F7nHr30XFu4+dod4D5n34brFhUgQzIjNrM9DJTApE/WffungFI3oGrn9aO7yWSGcvJ8kCP3tVp1ieLCg2S4qU7MTTWx0ltWTjghbFhnK4YY5o5S5ReYFbXhofV3vH20rewfZWKfrDE2GFtDlwn2uTyYId5Hr4QbpRMm0bXL4VWsGEaHAzG/P0L5yuX9zRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0LRZyG/NGceBE2VmS2iqXYMGtDMscOX0yrvK0Da1hgM=;
 b=T5SeoAijJxalr4XcOxnhgCMSaws5uo9xU2ZUzwAGPHYdALVhU+joB0CJEv4BGCIzl9ObS0az7YSAES9BqlbuQ1TUMYOwU6kfuoFD14L2xzH8hiP14cXkGLNFeYkyhkO+iBOvy3+Eiym6VEsaT8rxAaD7a0BIdrO+90+EG3Z806ELza6MCA2jEdjy7zOgaS8skI/u5O7wnMBTyxta4zFVTgrMnGATbBrdQI12ZCUYUcxAO4Z63+PQzhXWkrGM+3P5pNJ1i11Ef0KXNyMwbmXJXO6fT8fxHZoNgk3nZQjeTDhufg1LIplr00MNsTUIcgWuIXy0J4E0ThO94Oc8BYQy9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LRZyG/NGceBE2VmS2iqXYMGtDMscOX0yrvK0Da1hgM=;
 b=jpwMIWi1Jj8oR85H/RoJ8UG9wl2wzVGy4fEOAnSfa3/AQAxFQbTFW7Xh//wJAswfnjD+Q/AVTRMoyVCBSAEUui5IVTrE/p20sUJib8HwN4axcddmr0CegwLxeimSGSC2K29mBNRO62JbKltpNXa+txMhF0xOHIZ2XTubNd2DHTo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ2PR10MB7109.namprd10.prod.outlook.com (2603:10b6:a03:4cd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.43; Thu, 3 Apr
 2025 14:09:27 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8583.043; Thu, 3 Apr 2025
 14:09:27 +0000
To: Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Don Brace
 <don.brace@microchip.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>, storagedev@microchip.com,
        linux-scsi@vger.kernel.org, Christoph Hellwig
 <hch@lst.de>,
        Martin Wilck <mwilck@suse.com>, Don Brace
 <con.brace@microchip.com>,
        Randy Wright <rwright@hpe.com>
Subject: Re: [PATCH] scsi: smartpqi: use is_kdump_kernel() to check for kdump
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250321223319.109250-1-mwilck@suse.com> (Martin Wilck's message
	of "Fri, 21 Mar 2025 23:33:19 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ldshuyl2.fsf@ca-mkp.ca.oracle.com>
References: <20250321223319.109250-1-mwilck@suse.com>
Date: Thu, 03 Apr 2025 10:09:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ2PR10MB7109:EE_
X-MS-Office365-Filtering-Correlation-Id: 86429b82-b580-47e2-0cd4-08dd72b92533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ELokng94ud5sSiBd0SHLskoKNe1uphqdb6CgO2+1jIXUgNi2EulbQ7sLQ7IP?=
 =?us-ascii?Q?ipP6zh76EhDUXl/qK3BJiRhmRQpfBUSYX6O1V2qigRm1wwF6f8f0IcXWTPwL?=
 =?us-ascii?Q?5pZmiCo9frYfN8zN2n60G8zPwAwu3Sv8plDIJeiusT5hP4f2vR6ubVW0LXeq?=
 =?us-ascii?Q?wZfTmLXr22dQSBjc1yP8FP5z0lQgiU/Wj2EvDYMMPRJ8sS0kNGgMVeriFq4O?=
 =?us-ascii?Q?5BokvAuQhyBvDWbcry6Ut7OdTA5g3sOvKBdhkJ0El7loO5YpNe0TJuALCtAl?=
 =?us-ascii?Q?62kvNSvU4/Ukb/kvLK4ogGtWUfMZtr7hOO3+Q53ck/wccDg1OQeRsr0cFYeq?=
 =?us-ascii?Q?s79/la3AoY8HhzpvzLz8UozoDJ6dQ10nRTAYuxsFHVCK6HBbIX4Rt2SSyfyE?=
 =?us-ascii?Q?kkZOTx64LkqsRnDqGzYeu5qtmvpIDRRpVUFSJRyk5QBcYnOnVou9BgxuzBEx?=
 =?us-ascii?Q?a4mfowS/2M/Dq8j2YGYvRjH7M8n1CG59wx9b5jbW3pRWOoMJic71a3+Ev5NF?=
 =?us-ascii?Q?bwEkOaTOC4zzdxJzv07+1LrH3GgXOg8sOuQWyOXcHzpW/IBjpq5DCozq3c8w?=
 =?us-ascii?Q?dOHGYb4RGm1uZVkucDScaTdBz7fWwrS7bDQdlBHLGleDxZhxztDBt6hQqeiv?=
 =?us-ascii?Q?kPX8bcS/mkEXaNdpw1FnAHS1jDDmf09FOZB2GanDI0+ixu16NQGfwS/zrMZE?=
 =?us-ascii?Q?4bR3/Hd854Ttg2bgvlXvHoXO+jvNzz0f9P4VqzkknRCa0YrNZKtksjvto+92?=
 =?us-ascii?Q?vbtOrg98C9R7JzAiyuCrUPamlDssqazd0PJ56BZtCrEGCHtwYR6FWSXUX5/v?=
 =?us-ascii?Q?7VxFzc/KDAbswP3k6eTdj1IeGR+r0mHO/TmdN+TxR931MY4H6k3ZX5mPwdHI?=
 =?us-ascii?Q?hVI8BuuVpXzj+W7PfljTSZeyWw+IUz7EbY/uvk+V7rkU4f9cC3YYU08cijfg?=
 =?us-ascii?Q?ILgFC8aBOVhxgRSbJLsQFjQw8s4KDvCJNHVF+KIl0ynTdvtVOd+8PeE+OA9Y?=
 =?us-ascii?Q?VNvQM9XeCEb8rGeLqIiVWT0/MQd047OYiAXf7FAZfYsmxg0a5WfU1qJaEqDo?=
 =?us-ascii?Q?VU5RjALc4FpUhj/peFuOxeudaj2eacNTb3nlYvOYjRoJiHe/EYgPZo5ya/Fb?=
 =?us-ascii?Q?JABOyE6d2TbLGQUNrlGAuZh6YdTZ0bo/XBcr4VhY/QMEsyx7kfBc1zTKIH4r?=
 =?us-ascii?Q?V0LTs8CvQuyLFw7yA/ob52+j7i0AmKZN1CCinL9EWfQsTe/QfDM8Cy+ztUh/?=
 =?us-ascii?Q?fHeYkUBVq6pUAwDjlTqZVutlEBv+ZcPca8p27bC+2cLXz7ygg2KCHiT8kJ83?=
 =?us-ascii?Q?kRoOR3kaPtIvtk5LN24tXuL9DaRkEled3YrVHHZY35xhN1Ma3KdTXXBLPaNS?=
 =?us-ascii?Q?yX1FUGLx27jZd3FNVlg3Ry0/9CNhTEs9qlQygGEfrg7fK586qPa5WpN0XfVj?=
 =?us-ascii?Q?cYdsteOVn1o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X80MsOP/p9K3EDompsRQQbELRG3eVT1uBmZ7YrFeqh4gbfCxaew3vu6zqTBW?=
 =?us-ascii?Q?VNUBvy7glLl8G33uy4AT9snmn6Gkhz8GDJJJzK1rVmFqdIlUr8gWIgQwBtQT?=
 =?us-ascii?Q?nlaHnulTRnPqlARbMKZOPEHgmkod8QF4Lt69z+beYzTkV76F4RK+ulwWdSOA?=
 =?us-ascii?Q?272IxUhY5rNjTUVdYZpt1S6eBoplu/gHqMU8v2rq/yBntJ1Mf+yWyTYJw5l7?=
 =?us-ascii?Q?opr/dAPXMawxV6cjJEMkMJ39aODOiOF0SkUh/8/uUG70O8Ik2xA9+esUT6XB?=
 =?us-ascii?Q?b6FsmkYQ0hZTh6Zts+438mXzTHlrxCtnIsVXOJIyo0o3OVsni69GCNYpykom?=
 =?us-ascii?Q?WazCxY0qIEHwkj4Y9vBXOZWBEj/G+AYJGq9qyjyBuldHxYwcMYLwxpX3Bl8O?=
 =?us-ascii?Q?TCCLscWFt6GFc2Ivajtkb73mdHCFJtblUq32fxM1j95/8b2l8n5UWDO9J/BD?=
 =?us-ascii?Q?FdQjo0yDAUfPBFUy2nLVGYOjmzTuMRJSAqDLj/Kg8kg+5HpC2hYWp2aJpSyZ?=
 =?us-ascii?Q?nKTaro+EUR4U54cdAiYKxGeGC7AcAsl31YC6gn5vNlFPDrYEZYBqNezjgFxZ?=
 =?us-ascii?Q?nA9CFoLxnGz5SFcSdXuzb34yVKs5p+fQiGBSKaEgcV+wLFD/YT9y/4h4bE9f?=
 =?us-ascii?Q?N7V03QZW2D+qbYr59yNGeCHGAxNDgEzyhdb1FOo/HUSB3HrFSbAn1lwCuiXf?=
 =?us-ascii?Q?CFgWNuHo7KlVM2EU/Y2VwApb0LbI0QeqGwnsA1YKz3LKhmdg1hPA0mwFv00I?=
 =?us-ascii?Q?rE3YEZ4kDRm2TFBeQmRimqX1/lVoef9qfAxVTV1nGP6JcY/M/RQ+lb1xQUz9?=
 =?us-ascii?Q?WCzipItyVJXEcs82AL1QOeubak60eLcnBK3YomWcIIQ1qvQqn7VapqeqEc4n?=
 =?us-ascii?Q?Pwu6XK7hrQ7DRoBVfh3+I6bUfoc5UU5R1ZybVp6GMvuY4mwmmQemikrynHPW?=
 =?us-ascii?Q?3SNYbZcFjCIOaHnD1rhUqg70bJ5cvhO2eiixsOT3KUbgACqg8hF0QfTMp67R?=
 =?us-ascii?Q?4q5pH9emH31LMyDQ3ZpZNcWBLC/U/+Fcyj5le1aJwPMewQcF44V64J9vl+LU?=
 =?us-ascii?Q?5w0uktCSYOGrQcikFj3S3xenMthPQyNtVZxBJmyBjbEKPVtPzhE8RGz3JcvP?=
 =?us-ascii?Q?+ftzN4vkcBsbN8xCVMe1xNQGf+O8iduQyo0rYNauhN998S5eIOVMWSMZ3DKS?=
 =?us-ascii?Q?QjdOgmCZmFQeb8dY0dcA29AuV8AwYr21JrD6+x7gP2aWoVmYbJ5i3AWo9IYN?=
 =?us-ascii?Q?Rzi1hiSz9/B+7k537fYDrbjpVzxnN+HLbstqOx9nFIm1Z4jfoSMOGhuCM901?=
 =?us-ascii?Q?TyqcbYDHJ8ogM3k9wy/MvoskC3a5ioIG5B876QmKx2F4yxl3K4HL/bt3B2hL?=
 =?us-ascii?Q?heMgW1sHb1V0qcV+cFJlI/rGJ580Od+8lw7sf8YQm0nJTlYrCRUHxdjrTak/?=
 =?us-ascii?Q?D4TAYNOjkKnwFxerLFPHpl/oWXt+JGdguXDA5nkOhYGe+R/DGQEgdRtuwNMx?=
 =?us-ascii?Q?bA2QonIjO9I0TdQlKqIH7aeS8gofrW81mNgAwM9u+vUQaBYomkGLcDOXgDK4?=
 =?us-ascii?Q?hmASrdO7PPpUGWxfcy00B5yfQrrUfRHRoHJBEdxwKHUQiSqDksMcBN5BGajn?=
 =?us-ascii?Q?Qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ig6EAKd+n9hQPbm7b3JdMEYy08cgfQzQL/Lx0p0lPH7O/te2/1XSfNMulqIf8dPu5RNDzgwpXg+ZoOvEUij/tOwWs+JvGJ7wUQtSQgTxbSUaZ4mS1BfVlqXO12m2Oxz1lUErM/e6LjmThhxRfCJZNPXlYzamoWMdmFeP+PfsxpGzKZtGnJ1RbKYyinvQrzP4wxpnOPbYJQJaHnhrCcdKI+KbhKCnLew+7oygvx08n3ujypvD9Z8lTnTXI5kVruUm9ChGqpR2VJgG91M1sWRIiT2HuRrku2CnCWaNipZoXUMdIfxlqBkvmaj/GL6cLTVl6FcTsCwQkwVt0QvLOTPzy/b9glgVdXi+shixsJzZ3fGDc8ZvI4YzzuYq3ZMkmggoGOlIks9BcJYAsPzq3HDeuOdhZg7NZTS+4rPz9vmZkZ2Fo53uLM11UgGSpI9rvfh6t2ppBu8HQRMPZQ+5KgVYP2TrsvYx0ZaLDhhX0hsIP7Uusx/MmjZiBT2iimVRCGwUGzdwJk1mmsLLjmp9P0bagHARn+P2R2eSfUIzltvPEYpCcR7UrVvz+XeGX0WjeT+dfOxmJs1e+h6VIxE46yoh50Rr6zAkiBYnvWyizJsfJFM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86429b82-b580-47e2-0cd4-08dd72b92533
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 14:09:27.6527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cgBNYHl9w553NU3uHchzuOrbY30rPxXyWckdGYSTyasZb+/YFa8pPXnqD2960o2F842dno2dalcgp4k9NDVm3xZjXw9g3Oiy9nGWbqQdPN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_06,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504030065
X-Proofpoint-GUID: 9WgiUTIZPRi5iAwf1TSNAUwurj5zKqUa
X-Proofpoint-ORIG-GUID: 9WgiUTIZPRi5iAwf1TSNAUwurj5zKqUa


Martin,

> The smartpqi driver checks the reset_devices variable to determine
> whether special adjustments need to be made for kdump. This has the
> effect that after a regular kexec reboot, some driver parameters such
> as max_transfer_size are much lower than usual. More importantly,
> kexec reboot tests have revealed memory corruption caused by the
> driver log being written to system memory after a kexec.
>
> Fix this by testing is_kdump_kernel() rather than reset_devices where
> appropriate.

Fixed Don's email address and applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen
