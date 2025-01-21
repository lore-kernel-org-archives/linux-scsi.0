Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD91F5028C;
	Tue, 21 Jan 2025 17:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737479948; cv=fail; b=Pkbk55AKp9B6D4gEqlHzE1oG1NmNxG/DchSxMTwhrVExFG/uTvXx3La7KqyatXcZYIDF8rxITYq3inUfB0Ldt4nxsFxCT1gsTjthkZLhLcVW1c7RBVpQ/d95+bFS2mRalrfvfHuR1Mw7T2c8fc5aFlUhe2j7iUGmN0K5tu8PGCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737479948; c=relaxed/simple;
	bh=vH8bEwmTXhM7Ej0elmYjuJ7RnPGBdFehilUIV0xjNsM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=u8BmFWc8g55CxUqc8zlAlqEJ+VNVXOKffhwBqMcGVcKL9FZ2lU+LVOS6ROptcMCkosfVrMdDa0lIYhxwROQZCdZ7jO+oH92dMlNvAMhr42dVXDOBkWVO/TpLgHCoD6qGJHVyikuZhtr6V2Mz3tnRKkG0Megf795RZKoVHX+8Zcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=orcwgzj8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t92Z/Qw6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="orcwgzj8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t92Z/Qw6"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50LFDusU019389;
	Tue, 21 Jan 2025 17:18:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=2iFByMExhNskQGUxr4
	xkem78LPKRORAzgNjwiwNe1ZU=; b=orcwgzj8TpYaNTBIwKrKuYd4xKRtG4q017
	UXs5NMyOhFGI+czV6Tx2xkPmy0bmcb4+pJsYqTqYG84/FK6IX+BmnSxfVKJLYO5P
	7MzFeoP3JDlXV77/1u5Tlfu4y+GwM1vHrkCaiRZKmXQSN5gyQ47VzeSj/afuBMQe
	l5GmmFFpMyxRYpldjX70DXtVWNb4VH4CIhAASh3cQCt9HFi5cUrQN9VIiBoWaquU
	81YYOD7AbByPexU7+U8vpy7LLhte1pGVTfRPY7akU52HEBuwjzThhnJzXpMndQJw
	BUT2brDp9BWa58EMAT/Ojo8smizL+hxvO3CoaKKhgiiT9UpXZgug==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4485rddy6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 17:18:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50LG8AF3018665;
	Tue, 21 Jan 2025 17:18:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4491c2jndf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 17:18:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qGuK7cDuRtjr6figKPwgkNGpdTwk4lK3gP5j/3rM/ZHQ+T6+4kUfwiZKDaDgldxylMoRn/wKHK/FbnNMib+qs2k7Y4qE0CJEy29/1F1CXcAxH0Hqxh6MPSmBx9oScm1nE3D193iuhmYWfiiu5AKoTHZwRv5wJ5AsjNBxeqa8fpCt71FHcGHPveDn5iNCWVCP9T/ntuEf+fus+tTUvDDj9TB6tqRIc3fFGwVxaDb5tCMJacnsPQkpjT8lPCMwJFnENG2f7ScdH9/fL94VbV84KhS+gcTUMxffaFWp1Gy1i4uVxwv8bcg1IVtT+eIi8C0paTY+3pbjV5GeV2MyjRXxeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2iFByMExhNskQGUxr4xkem78LPKRORAzgNjwiwNe1ZU=;
 b=BcrHFh+MUk5e7OqVgMnwlP6/rWCq3aEpcwHSn2uwA/mfUdXrKNuW9V7WwuMODvXu697DZ4BipIJq52Y4SPEIBaH+QojbJL6tf7Nn97EnDZCkjYVbOQkjRUZGGRUMd3gtTfrkJFSRTastoWCUXz3GzsCmztFEITEHPBuaYImBG0yu5sxBo9oaWRkrFYoE+U8V1mqYlttz1y2E2xqVHug+OVn/k5/mQId+nz3mYCWrvkiWbRTIiM6Am91W3/LphvunaP99QAywcgSp2BHxxDDe84PTRcanqDQVtJiZeD82YoWjG8BmGIsNVG5qqFl+fppNoEZXmBgWn5Li4tL751QUJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iFByMExhNskQGUxr4xkem78LPKRORAzgNjwiwNe1ZU=;
 b=t92Z/Qw60C/YDoZAPt903iT11rtVfJ5nk4AlVpHCVHqrB+IIdicLADBuqLawaCduQEK6RJh/GTBvr0aM/n31kjVy1cO79BbZF4sGXeYzuVOXmOwyH2Qvkt2Xz47DkHQaG+DL+m2klvP2DGyTR2Vch7vw6kxfHRDjShOHqNSeLbg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BY5PR10MB4113.namprd10.prod.outlook.com (2603:10b6:a03:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Tue, 21 Jan
 2025 17:18:29 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8356.020; Tue, 21 Jan 2025
 17:18:29 +0000
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc: <quic_cang@quicinc.com>, <bvanassche@acm.org>, <avri.altman@wdc.com>,
        <peter.wang@mediatek.com>, <manivannan.sadhasivam@linaro.org>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <stable@vger.kernel.org>, Bean Huo <beanhuo@micron.com>,
        Daejun Park
 <daejun7.park@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>,
        open
 list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit
 Definitions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <69992b3e3e3434a5c7643be5a64de48be892ca46.1736793068.git.quic_nguyenb@quicinc.com>
	(Bao D. Nguyen's message of "Mon, 13 Jan 2025 10:32:07 -0800")
Organization: Oracle Corporation
Message-ID: <yq1wmeow0f9.fsf@ca-mkp.ca.oracle.com>
References: <69992b3e3e3434a5c7643be5a64de48be892ca46.1736793068.git.quic_nguyenb@quicinc.com>
Date: Tue, 21 Jan 2025 12:18:26 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0336.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BY5PR10MB4113:EE_
X-MS-Office365-Filtering-Correlation-Id: ef78c810-c690-4955-00bc-08dd3a3f9f72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SEwDJrhWoBtpux4VQrlGmRNojbxeT9VTsFug8SZg2NlKidcM8ZDJ7SGjf75J?=
 =?us-ascii?Q?gvrb5bib28N4ucTglt9sqZvG3/gvmVj13/v5u/zlSfSRusrG/N3kAt+81vgh?=
 =?us-ascii?Q?lOF2WQMgdnlvkWMFaIIPsjvWdxqQ3D+fB01VK9fG268MlCi69NaREHmfqE4W?=
 =?us-ascii?Q?gOx8OpyTI0oSWPNBXCQv8E7YzCmqMQ5QpM7SL5T4IzTPdfXmmZRrIHlEbG5E?=
 =?us-ascii?Q?NRPUNWcoWVGbrjr3TZvPFURwY0XqBEYug2YA3bfnAnorpmRqM+y32hofVqoq?=
 =?us-ascii?Q?gkkfPBlkAi12LBd93d6FP/aS8XZ6eyiyqp8y7tPG7z4L1SkIwbBUkn5tNrAt?=
 =?us-ascii?Q?R4IrwlZso25kF+58zzmstnnag82M3QtSOi57njdxaNDCABfA7T4kj1jnv6Cm?=
 =?us-ascii?Q?xiFwa/gQUrOHmTeGjaOn0+74cPxzTttnrKVIPFaUpyDkFahwDi1VNjykTs4N?=
 =?us-ascii?Q?Z9wkzZHbAsc99+ROZwz/MZTF9YCbSmbaqOvTL9JSnDp2Nqhw63QS9j5HoZ99?=
 =?us-ascii?Q?ze3fng2WEtTe0VGY5UnJLdE66SpDHaW/5P2oqTCV+MjcCuINKY9azU/XzrZC?=
 =?us-ascii?Q?dhpF25pNiO7TJRPz6BYPCgx26AFQIQbSpHbYx70Ysnze/bEqaAkppEE/0jKD?=
 =?us-ascii?Q?Ezvl+Q2LV85f8LnuOrPJ/Bdtq4cDB6cZjnqrIWSD2SyCabH6IQbcZPQmphbA?=
 =?us-ascii?Q?pwzINK0hlF/54WOLUcz9rY2AovBRsBEutXPTI5bUHnVDvERID9NTFXSLs+Ph?=
 =?us-ascii?Q?lTICEZ81LaxOmCpLCEipC1eSBOrUvj7HcXJ7n4F5TrnsqRb8ATZRz823MENe?=
 =?us-ascii?Q?w/YVlJsM6HMYoXjXaBAV8nzlSajFV4m+u5IEz+66PUnqkIZmB+igJ9N6N+9p?=
 =?us-ascii?Q?HvAPR8cWpTxoH1/Y6TIUCpr0ek79SJA8cH9N+UUJ6b6BhaOUaFJUsjDd8Tho?=
 =?us-ascii?Q?zT0U+hUit7PRO8EOCWBLmhiyM7POlR2r7FR2EZ51cBQDjSnuJm5hVVjwg/6N?=
 =?us-ascii?Q?R4D9AtPjEoD/HhqBwrNy0fQL26gFC9ohc7TtxNUQ714zCXV2urzAmKGQk0Xt?=
 =?us-ascii?Q?+lG4ZGqpN12me/uo8p31TOyEHhKDGJjgZaz7agQ/PPvWVpzHujbbvCtQuOI4?=
 =?us-ascii?Q?h6d+9ch1jiQCHarVU5CfER0+9J4+ZancYsaNSjQV4M4eMWwCWCC9iFJoBkZ7?=
 =?us-ascii?Q?4PKNaSUFwF0QltvGq74u6svW4z/6qeFIhlMWMXnWo7vHVER+iEh0KR9QW2mk?=
 =?us-ascii?Q?pldoNcqfZ1sQQNp+VTch7LVxkuUGwrHnSqrpD1jcbSdCCCvzw7VtaX78XkF1?=
 =?us-ascii?Q?TUdb9Ito7BwADsJH1xAs9GhH48WgiXmfdzsTWcpE0CAMybBLs7J33XnA6Ksy?=
 =?us-ascii?Q?/rcnovQHoS8GZWARmMOM1G9QlS8m?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ln830gyLVGhV9bvlbF0w7Q6fljVEBkR9PijUditepWOnMEYiEAFMuvbBbAM1?=
 =?us-ascii?Q?7RKynFkQ+N3RfWrFqSz9tjG+g1vmIZfuRXCAfi3SnR7kmyHe/DVMkypEqyOa?=
 =?us-ascii?Q?tqxqJKsdsmzstxCtxstxKibyxb367wW0lIlkC90jE6h3Zuw7Bu1g6zsBX9H9?=
 =?us-ascii?Q?1Tnper3KBzQbjauEdZz1nq1uCi5unA/BNNsEO1tfG9iw0UyUzfTnobJgpmWa?=
 =?us-ascii?Q?Z7uVPLMnOnjguAppFX7Rcj2HWSSYr8T31wn6DfWC4+QgjH3OUU3MxkH8v+1s?=
 =?us-ascii?Q?aEeVDtNN5aKOHEcBSnKvZbJ+8DaNz4AyD6lJxA6H2D1Tehs4FUUHLK+EqzaQ?=
 =?us-ascii?Q?RJlRfXepfojeygryuYuU5MaW4CZHooyMapToDnZsSpOLZez8r2aJ9dKbySOh?=
 =?us-ascii?Q?rw2zsvfTUWhOj+qj1RXBuTUIpL9eyMnhlmpRMIAZY5xrkaBCbIxajwv/Ow9N?=
 =?us-ascii?Q?6vZ6Xvixx2xpaOHJ0BXVsrLJerVczv8mGd/890xFJ33w+6ZbPFIII9gbZS4I?=
 =?us-ascii?Q?LKOPBqKJbnFDT273l4FHqR71sZnV5K7tJ2bqXU1kKELdbZmNSEOyoFnMpsHt?=
 =?us-ascii?Q?PN3Zl6Ac66JWf6UKDbgEm82X3+ZQ23ha0fEbF3dERW93ujJJeRKmmqKgLBID?=
 =?us-ascii?Q?TIlrx78cjudU0lrfKh9nFVw29ovmAeqQn8nqVHauaj4xlOdWxx2MGE0yq3+c?=
 =?us-ascii?Q?oJL/hoepf2ECyfgeGAPWQ249DjoywoAfXfcB8eCHdF7UcnJZJBsqvsQlNKbY?=
 =?us-ascii?Q?NaC6NoNU6hHEDnj4bXjJla4YK6Jbx5DvRtZPqcK1DuUK5qEKAMrBv8wuHKAI?=
 =?us-ascii?Q?EzvtpPg33vpwB0PJHvihmb3D9DNU/iFXSLQW32fhrl9gsFigs0fBJNKdF/8S?=
 =?us-ascii?Q?O6/ifBkwnldFxEw70zSzV7KUkUaQz+Aj8+4Iy2SvBSmftnlYU6BTD5Arewyb?=
 =?us-ascii?Q?qcXLtkbu9QpiH3z2SaReMdDS5UfELXmpXRzJDf7F+ECKDgnKmA9IhTrZSt0s?=
 =?us-ascii?Q?KP8bAomUL3Y1ddeuW3IWbwFKtBMnZEPtiVJDpW1rcdeMh14alNeLbcfjEBfo?=
 =?us-ascii?Q?dM3mbjEjvXyPyrQBAlkudw1n4LPYo73jcwHwCS0KclyIhhCej0ohRqd3JWtZ?=
 =?us-ascii?Q?EuC7UrVn6HS29wdSdSfY9HvSSYj3fdO/4OcUnNNiNdxRi4hoLFUXIB0VQdFM?=
 =?us-ascii?Q?PyC4/l1cfzExufbUJknJBwvh3c7A7OtkLgWYXmmyrVieFSAlIBKs/Gsxu1Ej?=
 =?us-ascii?Q?nmNhxikA0DzJnqf4jycT+YkfjtLzWqVExbpqd69bC9Zk95X2nX3h59kQ6AhP?=
 =?us-ascii?Q?7c8H4zflHGn80Mtxco+UB+L64QWFe4Y46Its2wgcxDyC77DY0S4ZDW0krEsd?=
 =?us-ascii?Q?+AAnXI2TyoKiyRmLRSeXURCNKHhfqINgy3QPyUJ7DNxb47fnRbECtAaqvINa?=
 =?us-ascii?Q?Oz5SsUPYgD+hrVZqhDBHWKFRzoK72ha0pXMoko+KhzoQ0RmQP/xGFk1tmF+P?=
 =?us-ascii?Q?P/fYE5RTg8J6yiNOl5jnUVSz68DJ6seg6kOzfGrWwzmvJLQR40inbMRFuZ8x?=
 =?us-ascii?Q?afEf6zUwCGYodL40q9r+yALBFAu5DPgvEkqajcjbnhZfYNWgMnYYX4JjoeGo?=
 =?us-ascii?Q?Ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EHZjAMfeokW1T+rYSLJZUs9b6MBoyRLCDtOm4voIZCPWrIomQt28iHCl0UNnsAdKf82n+5C8L3qi2NKoUo6UUV6qRrE+tpRQGHEvV1tr7Ah7JNqA6mQD3ByWqvfmEc+dejIn2LMnag3ZkGO4e58UNj11vsCubjFJw6iY3Z56ROiOQetZJOSiUDuXRXwTmLhw6dhCo3r2pnLxCo8L2eRPeIyDHgouuPoShduYAqu1PpWK3AfJ56f7GSvMEl2QeeJPq+NM+ZXYv8Z3AbHppr1Wf9ylU6XxGlhRTVAnSxHLTcFRDFPHJ0kyySsodG5OBkN+tDCR2Tg/4z0XgTxUjonmpuq+ImUEzQTD4rmss9oFBZw/ukF9s+BPxgdv5hDcAWjjXlN4aYh4emnJV+hmMDamnaggtJJNtVdI+j2Mx5B4BfnwcA3wwb5oMcE4/8Xvs7mDwAxkc/vKtCcfmDcmOjuW5a311dgoKkPRoKghLegCZNKXZTe/yvD/xGXgb2f2qCL5hQH2GvVxpq+BVVHAo6j1uePJ4V7krHX1EU7EfOOtP2mR2BrKPqynMa3k/zZDvOhchrhpbbJLPOaUiRlQ9yqOa5zBDQHZpDcWEgRKh2IqfM0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef78c810-c690-4955-00bc-08dd3a3f9f72
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2025 17:18:29.0156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zTo36ldVwGV7pa8Zn8/HEGZV9+WFQiFwIEmphOmXzNt4PE3CC6ZuQ7A8hX8CDI8dni72iKS9wplRnFiXJGWUUSuqGYu8LjmyJgmKkuraQPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_07,2025-01-21_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=764 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501210138
X-Proofpoint-ORIG-GUID: G5tux0OwyiX1w7GmHS44Y_G8jcqI0dNN
X-Proofpoint-GUID: G5tux0OwyiX1w7GmHS44Y_G8jcqI0dNN


Bao,

> According to the UFS Device Specification, the
> dExtendedUFSFeaturesSupport defines the support for
> TOO_HIGH_TEMPERATURE as bit[4] and the TOO_LOW_TEMPERATURE as bit[5].
> Correct the code to match with the UFS device specification
> definition.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
