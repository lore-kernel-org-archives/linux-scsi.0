Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2525C1E0DFE;
	Fri, 10 Oct 2025 14:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760105736; cv=fail; b=nYWoPAS20vYeHpbFpmgFFmCQ5+LL+7pyIeo6uLP/IdkprgCA3e86PZSk4kn7WqeW7mmJwuhuq8bzeEOUkpd7ZoIIUAN5dgelLAAP0tIf7aOTp6HioNngiPrXqclwLnnnSzn02QFTrQ2d6un0D2ZUZsI+RpJEwgr8nOHk6Ls3sLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760105736; c=relaxed/simple;
	bh=kZLJWXlPobFPOkkPGLp9OksXFkAVsxSQjuviY65FRNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FS5LvA58jG8JLc4zq/7Zdt0MuJKbdpOXHl2DDNytcaZkjkbnj7r+Iff2XDd38tyTYay52JA0ViGp9KuJHRa8fE6vAqRBveqtAGp68WLBWxH5KFtWyj53Of7Uxrxp1nEPT4qFwRlz0lRGcMJ4tm5Hl6EHU1WabzwRMMvKqnlOAcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Cbvcheur; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZLGByMxN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cbvcheur";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZLGByMxN"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A8tMVg032425;
	Fri, 10 Oct 2025 14:15:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RV2xenPGdUewoQxdW//8FEe4aqjuVmY2eLpJc4yV8VY=; b=
	CbvcheurdrKB6M7KYX+tGP8MqBzsQ9Evgg+iUCTtdc0eU3kj9+mw/7ry7KJbPbzG
	L45hLJBRs61VXLpE0oMCMVqJeCBKCSKWivz67A0WJIA80edqC8URKOVLxzRcJdHk
	wSuehvfFzSV41ZPOiM8FcywWiw7NwmQZFAE1SjCEW1b+t5r+TD11bGjBApEA5aVu
	w4yccGSqY7O18Kl6UwUMimqSX63GlZe1ZO3YuVEpjQBr1Drt8EMF3iiXQuSlgMV2
	gNhL0zy9eqaZRhsYDrO8j7b3xEP39ILEfnhJJw9juSSDCcbcCQVFj8gmB5fDAPWa
	dpHHj8dKMO+qDh/Dso2UHA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49nv6d3t80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59AE0VhT014586;
	Fri, 10 Oct 2025 14:15:31 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010066.outbound.protection.outlook.com [52.101.61.66])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49nv68s36e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kqJNFcS9kQqdMhwW/plXGPrxCLaHrYTXdmxHGLiIUMv/BsrK0BLnRuMvqdQNk/qmbiNOdd29IYpExLPcknlgvy6CJ+V/1yAfMf60FjpHmeYSnG20Z2uOU9hHj6psg/FzbivwZruH+RJwoXyDWWCuAFZuha2n/dOEzwVLOn0TUVwk+rpEDasJCbQMqF1GpcUgFJ0UYKmikNssLziTakPcwcIj0rAtV6Ln6YcSyvkJeIL1+0/xtK5eVJ4JL9u/8tVtehr4hW3VRbmwb9sJhEluAt4QPIOcZ2svSDUcvESGdeJxZMOC9twgUdXyaqKT3qgl9ugemYBnXtG7dbAOa77yaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RV2xenPGdUewoQxdW//8FEe4aqjuVmY2eLpJc4yV8VY=;
 b=rgCaOsYxOvb2cwRne+2uKe3YIWeSvFOKXAS5uZbGzBaP5vZCYJJPBk/5ghMG+RfwReqcTLDv55UUlaW4R/eeNBBkUEd/nanLevx3JnSlct43dknqSqXxmPhw071xZBCSXJ4R8mipYkTZUk1Wpmb0utuM2xNlqvXir5FJpYE/0925ew+B71Dxc5z53QHjHUfUufL1zkmzbPCmZR+sSp6A7TaoMQp0xpz4yKXTmcjOPpdgj5CnYBu7sU/1MzX7PwQ0CNGA1VGYgYO62a5RuIKJXzvvTc0YNIHap3VnyuGsUWLU5He6ZPcVFCOrrVkZOhsv/t6tY41p933XHONQNVt4nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RV2xenPGdUewoQxdW//8FEe4aqjuVmY2eLpJc4yV8VY=;
 b=ZLGByMxNBoFmz4Y2RjPxGXXXidp4GfA54CvMKChQktc694e0zlzK5Kk2TWq7vu7x9L+3EJpQrzxLovSmNEl8V5d1Zkz9cy4H/BBnUzXnWMnququUPcEJJh6kTlLGtASu/Ie4SbWBrIFfXunrBB9hVlGtVPkviMiVTgVhXCcQXiE=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO1PR10MB4723.namprd10.prod.outlook.com (2603:10b6:303:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 14:15:29 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9203.007; Fri, 10 Oct 2025
 14:15:29 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 3/7] scsi: target: Add helper to setup atomic values from block_device
Date: Fri, 10 Oct 2025 14:15:04 +0000
Message-ID: <20251010141508.3695908-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251010141508.3695908-1-john.g.garry@oracle.com>
References: <20251010141508.3695908-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0116.namprd07.prod.outlook.com
 (2603:10b6:510:4::31) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO1PR10MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: b19ee748-8a32-4fb8-1339-08de080776f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eO5IpcOdzUnNXDkY8Ur9cGZmgeJI083m3WiVl8/weE+UIWZWQSW2up88IyK4?=
 =?us-ascii?Q?HH2ZJsxcroVVzAcjmaldjmTTSMfs2rK36ylpQciC4vGLew987b8CCwKZF3ek?=
 =?us-ascii?Q?lCvUoRh2nf0vVTm0weRx6k3NeeWsVooCXdFLTSXv9yPCFOX5UuCQ9yArKwdS?=
 =?us-ascii?Q?zCK+RD2JmtMOlDGVwayfGe+M74z5NKQL6RPWWUFA2s15gpscsYFQR86s3fKg?=
 =?us-ascii?Q?nrKRwnWWaWcf9uRipYHmGZ8mXRfC/IP4P2hUuZiFKnYIyoQvV6ws2+Tsbecm?=
 =?us-ascii?Q?rTJ5aLHVDRD4C/CWGAuKjm5wWr35Uopby/Zw69lc0KfQDXpNkj5/KPt7Y1jK?=
 =?us-ascii?Q?SAiLbaQ+bC1wDlTPl0zbKZ6b3MQfY+93TgoETmLmL6FghelUf3uF3H2RS2df?=
 =?us-ascii?Q?01s6S4zE5UdgsooiiwV4KLYoN0wQsuwq90I26HL1tO3DynxEM0W6B9R0oos6?=
 =?us-ascii?Q?DnE+pQJNJWDwUyoRiNohy4wgJ5CNS1WPPE6QOhzdn0YpR0og8rNtE3eNScpK?=
 =?us-ascii?Q?ItQxAe4nPJR0P9uugjmoAMMCBJgLjsy13X3AKgXA3lITd27ri9+69k8JbZVC?=
 =?us-ascii?Q?xqhnPnyS6wFAIX5745PdJw7QXwM4xGeW7srRbJG/9Ryg6OQq3Vb5I6ftXwVx?=
 =?us-ascii?Q?uh1ML2X0WYxp/C6W70vpOdN3JsFV23mGh0P8HXWlVMlzmyzzzNVTG98knB7J?=
 =?us-ascii?Q?MOB3CVEF5KepUU0ZXRxFxw/9VIzxWXOPZ3cqvpIj7G5nLtq7I8VqehlpW8K+?=
 =?us-ascii?Q?xxT7aGPjRisa/Zl2bNZ/Z7PtqL4sXlBEcHMxtQhkY2E954bO1ZlHrNg1tFYd?=
 =?us-ascii?Q?hweP/4JIwl9DQUu43tjR+yxYuZViwSqvVw959CmE/+xK0nhnQgyczN5W7loV?=
 =?us-ascii?Q?meP9VVZQ6r0ch9tECORH0c8kwEOehvVl4h8mSN+F0s3T+UX//paLkCLl21qU?=
 =?us-ascii?Q?PphgUNKuYhrjFt2ZHX3Ug2JfXYEMOTxGKST/OGx1hUbh0CFECiOjahJgejV9?=
 =?us-ascii?Q?G5+gerIdD7d2vp4JBKuWdVERxqfeX19ZHqe0ZoWO94wOB70y+DX4K5AEQUHS?=
 =?us-ascii?Q?QdGwbawWRzRMiiL1hxWFpyzpekDm4kI9CndlHf/KgIGp5VR67YjhA4tC4uLn?=
 =?us-ascii?Q?Bwi96giAdRmgMUyoA0N2UTHzKJuahc64KmUcjDO/4PbgrGmDpjtXYdD3h0CM?=
 =?us-ascii?Q?i88avHHeR87mmIF2qENJrbktgD4JAq4nv/RiTfGFCtWGAPD3UDJmFJGsNfEK?=
 =?us-ascii?Q?TD3gO/Fuk4MR10A3jv+c6lzGuHuxmD2iQEjE4DmNeKahm3+VINFORm3ylT9Z?=
 =?us-ascii?Q?FHccCJceOBIH7kZqrbI/decPXIoORmf77BV/esgh1KfAFaLXPW3IO3SiH7hg?=
 =?us-ascii?Q?bb7memHd0ahJafc50aT51KRWl+pXSLu2N9GJmBQVj22FxP9KH10xTHLzmhrG?=
 =?us-ascii?Q?GkuTPOY9HYCYzEt30B47T/+WO3Ouwgqd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WjBlO9zA2brN5wL00ADPYj42LzsmiSa7ofGyElX2V7MiH2NT6mQ1y5BKqciK?=
 =?us-ascii?Q?3Yh+5CYBtp2nbPrOdwrS6oFR6HeeGHbgDZAPCiS7QuLeI2u2ghuPVkGQsDlA?=
 =?us-ascii?Q?vlcQPlZ1rFHGMUa+vqJbvXOcezjurp0uPKRAuTW3WOYCs6CaGBr9jWbVV3Em?=
 =?us-ascii?Q?f583JHwmXQ31kCACf2bz328SXHDHMkVGbDK/gWaEPmu16GAMvxGEe8BZ6VTO?=
 =?us-ascii?Q?E6MY//8VJ0nW79CWV1eoCj/jXwCeTT0VLxEFvr0qAJua8aNs12rHAdLmrPyJ?=
 =?us-ascii?Q?RfYrWx6OREkaxgfJvQxFqUiReKzqK02Y4U2dwci3rUCk+CmGEl+470rk5fK9?=
 =?us-ascii?Q?d93V8OtvN1QplWbiofdFqTiw8Gn64po/d+ow+Cr7cCcB/yGnX2a2moaqdns8?=
 =?us-ascii?Q?DVz0/KSqGCv3ofLjsgATVuOUNm6CoolG0YZYAdiARq4fp6vCcFGCqlC+8e5r?=
 =?us-ascii?Q?pksFCOJ8WKZNIxtwvkBYBYkdPi+/+kmluyTkt6tfnIekxpP604Jxm1lZD9yF?=
 =?us-ascii?Q?66ZZSSu99WHi7mcyIv9/zNDlNY5AbNdQB7UYDf5L5xbc7movd6zfYhXgAXIH?=
 =?us-ascii?Q?Tp0E7TRCxsifs4tgnzaRNhSUb0I/jY3DHM8mTOfc4h3+ruNAOTs1/74SJPus?=
 =?us-ascii?Q?C8FNmJtcyFy3scYONhJz+gMBF2MfLDXdOXZdSoCLku+Lpcsrg7ARa3k5EKYZ?=
 =?us-ascii?Q?nzBfoqLCz9RsPRB9Em6SXy+REcv85BAShYKqRxt/nqgBj7qQcHm+NkkBRaNV?=
 =?us-ascii?Q?aQmohQAGqg3a0jhcy2MLIx5AB51D8RbbRg/4ur13AZgJEnxApUFryHLmMXQj?=
 =?us-ascii?Q?g6BudcVBHcMXuWH98fc8x05w+6CSRt37cI98iZQ3gcjV4ZvyLVSwZvgRXC4Y?=
 =?us-ascii?Q?5OTVWKXAOnCRzC6C3jwE9DwoyKmBpGN0ZSjdktEgTC7k/l6Ux13zpZ5+VL8o?=
 =?us-ascii?Q?mef/psaWEF42tHNLKyqQNbY3yjCMXDs7oH9JT0/BJUqf86Sea8tSEOXNJ1M3?=
 =?us-ascii?Q?F/V+JHv7UQCvy/w+w6TLa08Mm+x7Op/CEli0Q8XtbHJg2zRkjprTcbYY8uey?=
 =?us-ascii?Q?GzQpH8kEQPKAva6RxDfHwR9oMuIe/xu0/Rilz+pdG7d2B5GbELOyKhQtbUDS?=
 =?us-ascii?Q?X+IvN1MyUBtFjSoYXaPyrw79XcsdOTCKHhUdbvSidttxeBjcgkaY8HuTwLho?=
 =?us-ascii?Q?MuiSWpzmMJ0aNZK7CZxEuHG6KBxk00BaXS3iTK5SER+Uft4TZ0BRgK9hTV/t?=
 =?us-ascii?Q?neLxWaQZ9d2fDeJanq9dH17yGpDsTTkHEMveaPHL3XodjkI52NGMAmGByBB1?=
 =?us-ascii?Q?o3Uj5xcuziewPDGxp3ebv0HPswbqZZyxXZrqNp6ECR9aw/FRoTEN0Ckn+1YU?=
 =?us-ascii?Q?/ozVKYw84fNqe+uAdDrnBqh7X/P1NEobpG6CIA1C4VVg4eTDApTHU5nhTZgC?=
 =?us-ascii?Q?hfvy0UXwU4lPDn0VnBzwJcPlo9XZua8rPE828ziUhCZyTD0V0OuCnoz0Hf+4?=
 =?us-ascii?Q?SYD7RPt18Oz39Ylqadd4hPzHFDBGXvFydB3/osiu9v/uFCRJJyI/7Q3W84Bv?=
 =?us-ascii?Q?KlniAP11u51UdO8RM9VFLx0hnpOXJqEvgetUck/1C/MyIOwDkiEIMYNflxwK?=
 =?us-ascii?Q?QA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VudSqyGqqvTgE0x/loJYDIqH8AAWpSOdoHHjD50l4apvyCC+uORKzIRQzdl+hcgjJ9b8zRFqrgq2rfMa1ZkhPJfEvW0rfeRDJRw8DIAcOGtHel/+AMb3+KEs3pM9IsQHV74HewzcZEi8KaJiiZeI0DapnTDJQ3DnZjbGV/lJsrgyr7YgK1qZVY6X/fZ1HoXZ7cs3Qie+0P6XRQ/SA4zhKf2HA4neXQy/F0HwAZkyVHvfk+4Qsxpb97S5yEu4X179+OpIYEz7ObafQeED3UUv33jFynzdeAnb76j9ryhTIh8gJu9p+iMBeWxBhoGf9JbXNUZNp0Vjp2x1Jv9D0Z9Dl2wbvetC8MwvjH7Tvd6OOnmM2ewYM4PjQirTkh8okBIWb/8f6nnIjPWGFRcqwcnm22wiaFq1DrRqs9GICvV1tR5diAR1isipg+iYz3V3vdRER7JdWiCK2SxyZQBGCNLfeKaxqVaiILvCWoZlJNWEL+sxAIyjywUhqCGWsXszPk06QY4wMv0EGtzwVLz0MEl34q2hCDKmjWQ0wrPQWOy+ZZsxJtoFV8dpPxZhCV8Pc4aabFtdLOSEMI8EWK+uYFWo8lydExjLtm5X5NFZHzLjDyo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b19ee748-8a32-4fb8-1339-08de080776f7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 14:15:29.1225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pkq/X1zK1FhazBlH1whh2BXVivgLdm54U6vicYgmYOayJlFAQmtO8KxtyfsJjEf/2RKI78Nvt8beODGz92bSBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_03,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510100082
X-Proofpoint-ORIG-GUID: k4wF3YBKDNdRr2bywfMtFu1GPPYXyLZX
X-Authority-Analysis: v=2.4 cv=bK4b4f+Z c=1 sm=1 tr=0 ts=68e91504 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=CwEbvQVFxUf5aZh4TjcA:9
X-Proofpoint-GUID: k4wF3YBKDNdRr2bywfMtFu1GPPYXyLZX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfXxFVs2nMmWE8K
 dP2nYclCnYohd40IR9MSI5ObTZFc7aYUu1XscIgLwSkAofFsh0RcHPSBdY7lkkIvxqPJmkxGmP0
 Hc7NSPsqpKp3ZfcZrwvMqaHlYqBC0ZraV3xhmTcsZLUsbY9U1ClHsCd4gIOxStJTTlRMCqLs8om
 8ONeHfty9eEk+5w3g72hbtLNbnkbUPzbvl2zJwMbAV25pzCk6O7OZqtJqSp/DT9GGhaKksu0MNw
 CbsrydKwRtk1eHC6vqjDA5h13VNP+yNUh9OSMhdL4HjOaf6SvxxfduWGKObxrx0fuP9T+T1hxYB
 KUbFitwoEeqSFkKbBP6VZ2MLOCKGOOIU0HYtKaJbhfI+/B0MxqK6HMcUh6BRyc0YK8y5yD6Ky2B
 X47mBHD3OEERMY6D/KfMAO0ZaYxXOA==

From: Mike Christie <michael.christie@oracle.com>

This adds a helper function that sets up the atomic value based on a
block_device similar to what we do for unmap.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
jpg: Set atomic alignment, drop atomic_supported reference
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_device.c  | 17 +++++++++++++++++
 include/target/target_core_backend.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 83fe3d9a9681c..39a2d9c3eb9e1 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -840,6 +840,23 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	return NULL;
 }
 
+void target_configure_write_atomic_from_bdev(struct se_dev_attrib *attrib,
+					     struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	int block_size = bdev_logical_block_size(bdev);
+
+	if (!bdev_can_atomic_write(bdev))
+		return;
+
+	attrib->atomic_max_len = queue_atomic_write_max_bytes(q) / block_size;
+	attrib->atomic_granularity = attrib->atomic_alignment =
+		queue_atomic_write_unit_min_bytes(q) / block_size;
+	attrib->atomic_max_with_boundary = 0;
+	attrib->atomic_max_boundary = 0;
+}
+EXPORT_SYMBOL_GPL(target_configure_write_atomic_from_bdev);
+
 /*
  * Check if the underlying struct block_device supports discard and if yes
  * configure the UNMAP parameters.
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index d394306f8f490..e32de80854b6a 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -123,6 +123,8 @@ bool target_sense_desc_format(struct se_device *dev);
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
 bool target_configure_unmap_from_bdev(struct se_dev_attrib *attrib,
 				      struct block_device *bdev);
+void target_configure_write_atomic_from_bdev(struct se_dev_attrib *attrib,
+					     struct block_device *bdev);
 
 static inline bool target_dev_configured(struct se_device *se_dev)
 {
-- 
2.43.5

