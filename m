Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82E254BCB
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 12:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715171595; cv=fail; b=s1UC9L/aWuxyYFSPHbe8PbKqRXO85FExtqEAmexl8DI2NJH1c1AQiEcgcsQPHTA9QnPwmvjQDU+xFkbP7xkDCJORQf9MrL8VsyhtOdHwA0G3skqFQ+rqgfS3mCIY3zhpyygFRzNek2tNfLk5cf950GTwPmWRHtNGks2trmEKzqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715171595; c=relaxed/simple;
	bh=s4IEcoENbptIUn39iHPUD1jOLwHV/3rXHKWVp9C96qo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=k9CJdQBmvSNSetw8tSTn4mQLbS/HcgzZBqKuNZw/9XFQxokMoBIPHF0DkoTrwoXPbwgvB34KA/RmXZQaOewp/sP39zYGhCP7q6++5je2SYIWmiLL6Xwisnzt2Ql+YGuKiidnD1y1C2uhS/HghZPUJV3QtH1Rdg2NsDWu9S7AirI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N+LXDdXW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KyFL7vjO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N+LXDdXW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KyFL7vjO"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 448CPc1r022480;
	Wed, 8 May 2024 12:33:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=/ryBh0+4Ezi4TJKBzCUztl3QFHeWPIu8bL8Rl13FNJ8=;
 b=N+LXDdXWY1+U0XjvemxxPPpnYkWBh8uaV6sHlvE7XFvlQt9vIq/ehHGzTHbhWsOxXVqq
 oXyWtdQn6mV0cpI8RhcNer0VB0997N7EGrQLst9X/hyc2rQepjhmHCyWw8cEl5/JgBe4
 z2Y9H3te6bIWSLdmwk+ZDL3FbmTr2CtTOwurohwaAkAlsdAwQ3X8ltPJCUZ9hY8nQLMV
 PIZnEdVu95uZGKubZiTzlS3Q0CwrSpkTXLx6XiRhDZVCn76f/x6Saci6huYmChpDhDyI
 WDZiYXamYcSXaJIQbevYOJLQGwyOjMaXD7TOmEYfdcdJyo6lLtRUEXwEKlqv7cqX8utq /g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xysfvhmg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 12:33:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 448C1KfT031006;
	Wed, 8 May 2024 12:33:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfkykdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 May 2024 12:33:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+smizc5daWeOmLPRNgYn2jfi6NhxG81EeIuSx58WIAQ5bxQCtaO0j8HgV32pFBNfXn9sy7kh9/RJTfLtiR4B6IVD9wRiBk4/eosG+mtj58kqmTQhDKNrDDQAlJK5LtT3fgMFJVsYLTUxcmdihEPMJnSZezJ+Pgf59oNt+SGzzIPwI8E5kuTd1Sg3RHgJWDbIhOZTYBTw9qdqD8MjF2J134XXayFpeOYb2/yqajCPD7y55xxfhFCOXBFNhdFmF/gX7N9Gop2L95A8DABaB7ZBVsZAtq5BKyVe5PQpLp6N/SG+zS6C2qSrNvenB6TUN4n1LgQBORrrYBegPsa6RDP8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ryBh0+4Ezi4TJKBzCUztl3QFHeWPIu8bL8Rl13FNJ8=;
 b=HXwFNDPfdNKM5q9nKLqqB3gDz4HGq/NAMHInGkBLOhXWJSVXyWq/C1Z2F6AKLrGXs0LDlGqawNximCHuSTJNqqcB9jqKK/dqCQ9f1XPQwlAXul2pYv7CxoYJirxqDdu985xysP6ZibBcQerff2ZoQR+WVOtdKut31tHnU2df26sKvLrVvkqHntqtqfZbF6Hv5Ez5n9ftVtx/O26GgZfoNbzzMQwL8wVgWx8hUSRkHeaYP65FgjsTGuedfvQB34rui1/zh8Kt+sO35hdyQviKBdbKhcMoCe8z+OLIIWFAb5FhCS4Bo9a8GL3IfEbVAazb8Uyc4Z61NvBMQz5eHiRUqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ryBh0+4Ezi4TJKBzCUztl3QFHeWPIu8bL8Rl13FNJ8=;
 b=KyFL7vjOtNvRNw28DyyYIkk/LI/Z2/S8gChJYCXCjfd9DYSeS8xYp+xFs1Zm91AhpzosGQ7TdoLGLKvLTo24h5HTs6chp267Gzrm+eX4lUaBbM8uiK/kRded2VzuAry3bFOrt6gp5bocHKdD1UgmQrQ1DehACLb3/I6L4sHDGhA=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO1PR10MB4595.namprd10.prod.outlook.com (2603:10b6:303:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Wed, 8 May
 2024 12:33:02 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7878:f42b:395e:aa6a]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7878:f42b:395e:aa6a%7]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 12:33:02 +0000
To: Martin Wilck <mwilck@suse.com>
Cc: martin.petersen@oracle.com, Lee Duncan <lduncan@suse.com>,
        Saurav
 Kashyap <skashyap@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/3] qedf misc bug fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <afc8819fcc0f9acf23ecea3730203444fed99713.camel@suse.com> (Martin
	Wilck's message of "Wed, 08 May 2024 12:15:10 +0200")
Organization: Oracle Corporation
Message-ID: <yq1wmo4wkph.fsf@ca-mkp.ca.oracle.com>
References: <20240315100600.19568-1-skashyap@marvell.com>
	<CAPj3X_U4RWi+3Lgo9bOFNAUcyK9AfzNFJ0E9YhCQRf2qUS_W6w@mail.gmail.com>
	<afc8819fcc0f9acf23ecea3730203444fed99713.camel@suse.com>
Date: Wed, 08 May 2024 08:32:57 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0036.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::7) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|CO1PR10MB4595:EE_
X-MS-Office365-Filtering-Correlation-Id: 2797bda5-5d00-476e-a3e0-08dc6f5b0091
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?BZEQd0pOSGKzhLPUkcAiuDJPupyXtjgT51Hi03zRFdStpzcF1WrgGxeYicN+?=
 =?us-ascii?Q?JXhK5Ky/LMPrXhbwiagXx7Jwxz6UzUaCyI0yRsRLhz7Hz1dpG3lJens4R7OU?=
 =?us-ascii?Q?XZsmAw08fW9o/Lh2yrBKiYWZ64VOvfh9B/Y+5vp1SmNrGELtJU2jMNmvKmQw?=
 =?us-ascii?Q?RCrEDShEkvNOF10QP0KAxXOncBQLSt8i5uVnoSSrTDJM114Jhx3Bagg73QLu?=
 =?us-ascii?Q?PzNSu3WCM54m7MBYTCSuy8fAREa3XU4GYRNWuoLiBoJAqxUY9YH/ugcEZzk6?=
 =?us-ascii?Q?gIvPGDScqKuuBrkAJP//oaoTAZTA/BR4XJBKvcwpgvq/aNf2bytHzSP+EC0f?=
 =?us-ascii?Q?ywjQRxGeGCb2EQXP9ese0/Dx8njA2owgxw/X5wfdsp3JDC9Rem+8fBfjKIgT?=
 =?us-ascii?Q?FpYfL5G62h/F/797y5XPb4n0nr6WKB9eMJSA2GEZnJDXIBU/OvF+9ddU+rol?=
 =?us-ascii?Q?hnJEUbKXysHwhXZawazwvVwix848dQNVuas48KbALO7XXs0rpK44L0K6w8MF?=
 =?us-ascii?Q?CEAQqL/QXZE+AWjhqz3DUYmt4Pj00Jq4akZyr3dRkAcTJzxw4hxx14gIR+eE?=
 =?us-ascii?Q?NXOVkO/B6vLt+GuCarVljQUF0ir4kPox/hdYIYpkhL9J1FMLFLIYrHxTLGpA?=
 =?us-ascii?Q?3VgZwl5Gou2mZyiZt5Bdbw2pcvBZ/bqHf/C0OWHv9chlBIwbenF0HWoIHsLJ?=
 =?us-ascii?Q?XzPGA0+UMr9FxDIyejoQbORnyylabJViqtQ6rg87BDnV6MFfYFH+JUqz9rwr?=
 =?us-ascii?Q?SrqeR29+005I1TQkO+p5ez2x2JckMKZPM1/N4VbEN7HyJxXMu5llB5XsQQWI?=
 =?us-ascii?Q?cU1BQMt7WH3XPWFRI/oBwLEHIP/1iOdNkva3sVXu+wZFb9dEgweSE7dGzZan?=
 =?us-ascii?Q?JHte86OozFVRaex7iNYYpvPrjuWPWjL/qTQ4ewyQ7Ro6j8xSC6FnLJBvdcVS?=
 =?us-ascii?Q?pjZFRYcpJ38IAS8QtGrcup5NCqG1mB4hocoh9cOK+QvfZtEhMPz7KPbkBMwt?=
 =?us-ascii?Q?eo9cJFCnYzNCGRjtLVokiq/daRHDQaOt86Z6sRU86wJsinwJZMwfvQ6SXeAi?=
 =?us-ascii?Q?lzRrNdoLHNUOrPTS6piXmGIF2NNZljQiptIMRTDAuzUbKJ670ltnorkk1ZKs?=
 =?us-ascii?Q?VvRbBQMUiVm4jvokd9HNinqIKUAf84EN/V2FOzRhDbDnIS3GMxM6XcFP++15?=
 =?us-ascii?Q?kNIIC+uHFAWVQAqjEDhmKd01fWmQUSl7o8rIdVGwL8U6eCfUv9b/8WdQEtw?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?xpCb7aD6V5KQlQ7bBxT8nzms2XsJ0qrLZczMSPG8+tyTkgKXkEn09H89/niv?=
 =?us-ascii?Q?8+5DhutYpQ3vanzic4iAi1a4DFKMEBVCSNv+Pw6KabmOEBk1Vv9xQgk7iz4c?=
 =?us-ascii?Q?w2zIlAqsg/3zdKKXfOnV7LA2IdEF4Aw/KhBEpnpHrUe0LkNxB7xbbtyiysgP?=
 =?us-ascii?Q?y6rIQoAqEOEg0Vx/UWpgyhZJ9Fp9YDc3MYk4drH4gQacrq6NlDTe67wPpKxd?=
 =?us-ascii?Q?qpoks4EwNaQG8cQ+Zs6pTKoTkyR/xcW68MjeEG1jFCVWXAomD2QXiOiQI6YR?=
 =?us-ascii?Q?TnJwzP9DV62QJwxevUoCRTtNamIMY+8V2Nqp27qZEufW357MsTe9nLwgrEL3?=
 =?us-ascii?Q?8a6SOkZHV1pe0sp/3GEwY7Dti3up+oTbtbKs0qT2Ivvp0vQeJtDsv9ZBzz8t?=
 =?us-ascii?Q?B5+FkoZTMiXOcsF6IeLzuA5tm/qaxaOVTCIPyjQpqKnEzD3cRJ98V9I0T5Hi?=
 =?us-ascii?Q?CwKNRrnA+eXxzBT/CJNH0QtUWvzZyoah6VqZeXxHwoqsDHZEnLSjIhsqf5dA?=
 =?us-ascii?Q?Nu1SZYfS0W0JBybNwMPTCH2zPLt/guB+JiTq3KsYU0CCiax7nXsHXqEd+JD6?=
 =?us-ascii?Q?BHDELp1f3qUbbYHet2/NdJgzPsTm8oZlEZx9lEaUTJc8EUqZs+6SuSqbT7+e?=
 =?us-ascii?Q?/78Qi56vIK9/+ousLx3t7EI5MQwtOe8P2+TuLc7s9SWKdAqcaxnmjJ/uAy1y?=
 =?us-ascii?Q?7Cz5l6FUE6pfi1xW0j+jWCqwulfLC7+E3hYA/7YfCY3o/IW2JrVvScgLDryM?=
 =?us-ascii?Q?pSogkJdEfoWKPcPfaezLUk4suu85/aDZGe7ZrU0Eh2+VqPvQhkLlCv1pdohI?=
 =?us-ascii?Q?G8s5uEM4xmu3tYrPSd+DCr9jtRODSbjnnj9re7KBlW5GOuKDbQenr0xwLtwh?=
 =?us-ascii?Q?Qvm0Y1CN1GBi6MgV+FWrHErVEbVTJzhUAe1b6SV02we7THbVBHWHmzRPivaA?=
 =?us-ascii?Q?j5qyOnpYgmvyQ8GiMGosW6qTP6LophDctQmia8YfaufxF8r8rwUnH9yjNEw2?=
 =?us-ascii?Q?CgUClkEuyW3Af3joKM3M6XkmUM33X8oWDqE36dZkWyAwSs725L7jVKp21Fx7?=
 =?us-ascii?Q?Iygsuyeoez1pUsRD14kYyiYn4iBSUJqCQVImqUKymmz/EIVRxRZRlG/J/lGK?=
 =?us-ascii?Q?qLN4dC8FKsVbdjG5RPRMFb5hvqzbStULT5VZoX4Qxfmo42reS0dxJFbHdODH?=
 =?us-ascii?Q?hoklXE7GcrG+eA73Eu3nkwqww1XJqRtdyC7lh0KI/PYjXhIb4SzFvaUtAMpy?=
 =?us-ascii?Q?tC4LtLYzgep/5aFg1f1JjgKRd1jul4GPa0jjruUt2m9K6jC1PYZqSJujkIOc?=
 =?us-ascii?Q?8rkNHg9qE9it50QDbkx6vf0/4NxIpcqBaAUISi4iXfIg8oCT/lEpMwfAhTv3?=
 =?us-ascii?Q?niondnRbuvRFQLVNvOg9IiZiBvktKT/2ZnrUs5oZnCbVb/Vaw2wxm6qs8CyB?=
 =?us-ascii?Q?bLHIZnYRYhr4yvZGb2j9MCUZpZ4AxIlmNkhh+723Mc/hwoe8cSgiSYqpCG4T?=
 =?us-ascii?Q?lXJ0KJQMBfDLMMy0PblIqIShmxjw0pnSGwJ0+jXN1wLlQcdb0oOwmjcCk/Qr?=
 =?us-ascii?Q?QNV6fJZOwX7u6F84Qqz80sGvaZ2AqzBAtmi6Xmw7QAJseDGSkXWkvoqcqLaq?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	BeRflf3HXgQDNaT0fsQxjN1g3W4Ll5A0Dx1acTWFhOg6uGAGJXRvhUJoyCAahy6Bs8MO/s0Xttr8lYBpXtOLaccAOOwsa+RXhvP9j8+CpkMvR3n62dkNQa4FDBL09DfWkJWhzpWOCbMX26Mrt7RtYo4ZnyMC/FNVks9YDdUFMb4pJph5XmQGM7IyU5Q5BGZVFCLWfUbG39MsP6av4AhbuZqouwg+nGWLOrZxXOIj5pby7x2cgugcodYnQbuDxlSJWMq0G9k6RNdudHAlyVbC5aszPXYlx07auEADepx4pqFJBSkfkZn5gm+6jIIp2H/WwKvvmHWVA8VZARRDzWTq/EG2DLr39Tva/SCMUplJqfil2J9pbyI66YB68fsKO8ryLLfVz4j1BL3VjoFP2lB0KR7C1XCEppUhNUDjRl9ZI5ZZZIhxhyHoz8bEGaNoR/iH/PpP9BEv2r4N3Adh4T/O/j05Vgu85lnZNVMIPQftuG21TKFsf+X1SwRYP2VymqHdcJYHsnii/Ljfc5oghP5JtjjwuldFQ879hib+UIDohyJCm76u1CMjyF1zBjG2Uaqdc9TBUb4UHaSArU9/kTQEEYhTOYDRHtumN1x0wJSY80E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2797bda5-5d00-476e-a3e0-08dc6f5b0091
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 12:33:02.3731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D44CZYr5awhrR/Pnsx+oE8pADD/LFD6BaQbA5M3dN26FOAE5DgvzxhyYbNHjz29Mx85AgVnmI2AmVd3GDnS3VUa6ggYBmwdWPtupNCzfdtA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-08_07,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=908 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405080088
X-Proofpoint-GUID: JOK7CIJxJHUdDrZL7RRfh1J29wUOoNS_
X-Proofpoint-ORIG-GUID: JOK7CIJxJHUdDrZL7RRfh1J29wUOoNS_


Martin,

> Martin P., any chance to get this set applied?

The series had a test robot warning and I requested a v2 to be posted
with the fix rolled in.

https://lore.kernel.org/all/yq1h6fq8cv3.fsf@ca-mkp.ca.oracle.com/

-- 
Martin K. Petersen	Oracle Linux Engineering
