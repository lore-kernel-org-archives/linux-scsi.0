Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA3424A076
	for <linux-scsi@vger.kernel.org>; Sat, 28 Feb 2026 22:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772317743; cv=fail; b=ONK+ixZGCGP5FnjXaLMtOF8EvVIUGO+W1ihw4lcsMJvrEZBhQivgIF5vgWhObj8OyL3cZPFCI0VHPW/qBRlmL4Rpu+g+v8L03Xpx9u0v/pts5Vtu726OoHbiwbOUXL3AmbMjmID4gGo+Tx5Jp7bNkLJBD4l4YbR1hNsC4+pOsoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772317743; c=relaxed/simple;
	bh=UigXOrbPp2483BwOuyAzyrIcAPAuDAFV8Lbhn+4C7Ec=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=US0Styow99Bl/4x89z1dZds2XR1mO4oltJ6nGFjujV7lLib5bLM8dvmzQ+ANXi47FJKE4LRawyhYw6BQ9fcWhRy0TJanGIrwJPW1Y4upzZdRfTC88nzR56KW6BHWoblseAk5Rbrb6xWx5IOkkWHiDv12nWj8IbRVh0W66fzD28M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XszaOecL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pj5pA+/h; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XszaOecL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pj5pA+/h"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61SKmGV21983174;
	Sat, 28 Feb 2026 22:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1ePHqWYA8BE6TDEpN6
	VzTgx7YJfBWsIrb+W0cZsNsHU=; b=XszaOecL5ZtoTuafh1mLmM1/wJUgbHczgN
	mfTWKr78acvzCoXVRfvEhxleaRD35FrELFnTnf5ul8pHV+TFv7Oef8voP9sHtEGV
	oD23BmPOjzi6hYTwtxfS7suHH7hYNsxDceMInvodY1CSuzc1plHtFPcWUPc1l5So
	uD9eilaCCrOoL7VXlS3VR7bfUQr0xncHN6wpfh9geSRnrwsrrO0XDdHMA/A6qxCv
	1DGy8VCIy6dEUJHSScVtx6On4UDndTpUc7JrhYIbXWHiHAuYuToPO679MwkPasXv
	1zUQKwzXzDQYrhDaewUX8qYSBOpm0ei2NRpp/ktXpDwJLCZEsmXw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksqu8m33-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 22:28:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SMQL8s037966;
	Sat, 28 Feb 2026 22:28:54 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013039.outbound.protection.outlook.com [40.93.196.39])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbuuuf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 22:28:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JUoR20lhLoDCjPDtmbT48stS4QIvfIG5udI8JVLKWKrsaWqOIqq522UxSLKHwCm88svOkZf6Ooq2bf0cNtjlJk79qlk0p//VMgztd+iaG4RuzJ9cnSTZAgAgDso9VtiSdlzQ8OWhQ4xvDPsZNrPjctyOGgjHqiZdlgShnbCtYZFbi77IfHxXXOoqh373DvKeniyW+3wtuVDKp2ZgFJkram4qxHeO2tSzk11SMSl5P/mPKB7KsDlnpVmYQf6i20b0GU+TOhjv3LzTF91PFhIIGEKNRJl096qaMVJzatoKrLbe4Z0lU6BiONyi/4dBABGXJIhpOm3CldsW3/cL2qyqzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ePHqWYA8BE6TDEpN6VzTgx7YJfBWsIrb+W0cZsNsHU=;
 b=fQCwja8TmMYr2+7wkpBfvU8c3ByGawQ2/YX1lwnxNfUMDGBuZCgim6YGr9gF7QSGm15BPaD61K40LbpgPxkhlgI0pGwKXsm30rQVD3GgooyIrPdmC1l9iX+Cieevvq6TzJEjiXekqBr3MySGR9qFdTFUQ6Xf7uj5WtUUiP5WMpcd0FzvOz/JHo4LWHomeZDRBqYRb3DTRmTPY9diirUliN67nPDdqG+ebQd2w4fISxVpQH61lB1AFpMWlPfM+jZtUGsD8wABfCp1LMbhftIWVn4nY038Wqxdmldo2JaYC2GZgyP/tVeL+FvUV9qx+y7v9miTLhuTKQOfVaboCxSybQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ePHqWYA8BE6TDEpN6VzTgx7YJfBWsIrb+W0cZsNsHU=;
 b=pj5pA+/h8OLMsJNDEs06rhO2o3PX93TM0/BfKZ9WBW09MyeYX3YLeAmbeYpbmna0iOByzgCNeY9Gw5Gmur36WIeae30mJ/iFflXlfqNArFEAJzUvz5GI6B36pfalBgXVP3UvU2KYMJucC7NnIyjs528zHGUEHWcoCE+zmF0vDAc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB4944.namprd10.prod.outlook.com (2603:10b6:5:38d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Sat, 28 Feb
 2026 22:28:14 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9654.015; Sat, 28 Feb 2026
 22:28:08 +0000
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: fix refcount leaking for "tagset_refcnt"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260223232728.93350-1-junxiao.bi@oracle.com> (Junxiao Bi's
	message of "Mon, 23 Feb 2026 15:27:28 -0800")
Organization: Oracle Corporation
Message-ID: <yq14in04i6q.fsf@ca-mkp.ca.oracle.com>
References: <20260223232728.93350-1-junxiao.bi@oracle.com>
Date: Sat, 28 Feb 2026 17:28:07 -0500
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0203.namprd03.prod.outlook.com
 (2603:10b6:610:e4::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB4944:EE_
X-MS-Office365-Filtering-Correlation-Id: 80ffd107-fcfb-4fe8-1e1e-08de7718a615
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	AgrNxpjEn2NgP81z7LODbDlElL1wZy4u94F2DjIBQUfDqXlCsRMAeBUgVB97XnqN9PCQPy7W8UvRfvSzM/pf7E3CMcQn4fPnnU7CrcGhYfrUrckEz828rP4LPva3CttnBSWXZ1YDTDeGfIz37yw3GrV+IpgDAZMUJS+bnWFxehTf9j1VWOpr25HZ52rslLu8eCBXXSXKj0xs5RNgcto2YHGraq+OoruUqd9/E/HTLWfiZL+qArXJBBiagfq+HN7uIU76WbNZvfku21n93GAGDve2rwEtLdQgtTCKRYcS3L7/DBL2a3E5kUM1Jez+SjxdzbFScsaPtuj1iIPKrdviazJRCB/lFDDaUCAjg09Uq9Lu6HeWur3lg5qX4sCeyNvRf0bza7QVOeuohgOOhVhIqKpof0DcQMR+F3tSwp3vRJhkHM9iUykIAkX4roMVHBnGnw9lIZDK5D9PPNUjluPXo+f2Ej5NP4zmnXXymxXbIk1Z4b3Cpm+xCQ2VyOqzxG7lVE/iPp19OgTHeoyMs9KURXxo+DKolQd6ZJ/NIlxcOFUNoGzWXYC++LRdjVQCnF9pWVP00sUbZak2/kwtr2r2CQImmnxVNKmxtUeLwI/hXMDpyOhM6pCK8o7P6E7Z8+4YsgCMMCqtCioWpzza2QJTqvhbOZkutLKuGbgW5k0g9HZiZjxPPTCkxFqTg7OAZwrfZyma6Qf6gIM2N6XPWim7/qoKa90moHzTEgOUE2hQvqs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cHKsFzRVKm+5iswLYjtgNEl9y4tY7GRDrrcoO14ltLH/nd14q8zdH9zusaFR?=
 =?us-ascii?Q?I9TM5RfsGffdjXHy0JXiDC0a97FlNKSZPVSUeNwgG/CWVwGPsmfuuxrIwxT1?=
 =?us-ascii?Q?3nywjFtt+g83WQt1QKnr6beO35zJrKjvR5u3S0G5cy/Ir5DVLO0t+fyWdBRp?=
 =?us-ascii?Q?1dwzmv9QG9VrPe1Pegzyb9WPOia0lRyZdlm0ABgnTJtgx8Z6+eQhORCzXh3X?=
 =?us-ascii?Q?Fon0uNev+Gi2piTvIJ7qn7LOPq3zmoFpWl0sey0gDzUWgMtLRoV4etyy4wbE?=
 =?us-ascii?Q?tJcWkyOjIVa9oOsdzlRZ7mDY9stIjsMPFj9QOYQw55yGIhpGju8r+vAFL0CU?=
 =?us-ascii?Q?L+JPlXQjbCr49iHRremGHIJTRXOBH365CyoR9zhDR5Q2KSxQ1ZvRwzEmGqyX?=
 =?us-ascii?Q?th+WwFOtqCDnCVWQ8mZ/CU8sI6YYeglJhfbqwDVLoNfsncyJ6zbJhvb2A6KT?=
 =?us-ascii?Q?wJ8Pu5vDHBHWGtnfMwPLH0hnp6PbTYR2YemPdoIgLhT/tR8RFqWFJOWS5IyO?=
 =?us-ascii?Q?csGcMElcxkLmtD6xGnunjCROatX453KuIST+ztHmDKA4NFlARRsjaMeH9gLu?=
 =?us-ascii?Q?d+MyaF0ZzW6VF2O76yOpHK6PvvS+HS63+kq+8lWGeYmJdWyO3LVikgh1FUyR?=
 =?us-ascii?Q?N4OO3/gHIBACMZ6sZCuFf5dzGtUSPDl9x5KGtI1+4kPvcHPywFsiQJtdtftc?=
 =?us-ascii?Q?E9DTmVT1uTasvqa8ljkrkm5CNhBnIX5Grq51VHUE6pDkHEtluMkuoTrJEjFI?=
 =?us-ascii?Q?CrVEQ4iCHvu/NFxdRo35yoePCTveSopUSYGndEDRZU1L0Ud/M+0D6hkoGSnL?=
 =?us-ascii?Q?tgL2YRddfDT0iNnl3hdKNmmSAbA8frnPdhdW3z2r8f6x0diZogDm9xpvKr7M?=
 =?us-ascii?Q?MJgahOE5+aKJLiS7z/e0mxB/4hwz8VqhMK4+2L43M901wIR2Nu7Jk1ilOVxP?=
 =?us-ascii?Q?Ck05566zo0d5UC/ugj1jhFoigq2lWSnAy0iV2C8NT4HBpUFRWMW82N9BGqny?=
 =?us-ascii?Q?S1w6VlXAh1yOf9AL5+LPSPxhY1I3yNEFNNQq6InjfEzA6Qq0uQ8NjlvC+7EL?=
 =?us-ascii?Q?hPr0BeNCCMZWMiHvnrK0VjqHGvr6vd1wk9nt7VfvGuJudUDjy/OKpWkMQqWw?=
 =?us-ascii?Q?yo/VMihhQbOm639iK0XqUfDpwm+AUDfwuuTmR9cZ7pVgEQsSf2/VAy+98vEU?=
 =?us-ascii?Q?Wt7RYs2zhfwrdiHpvx4j1Goxi4JylAzzVtbA8+y78QgBHfc3dzhRzF//dOOO?=
 =?us-ascii?Q?RaSkBnLQjnUXQzTm+NLwJViphMnmSpXjXtS8NxRRj0+CDgcv9xzekH+OxEPk?=
 =?us-ascii?Q?wQmeQtrn/tQJl9tWmE83XTS4+AawsoM60QffdvuHs8kewW6El1bO5QynvGoi?=
 =?us-ascii?Q?Tgg2AiRGKvDhPEUKiXFKxDqbFyCs8OHkqOXsxGj39EtaF+utxK7V9aIM3QIn?=
 =?us-ascii?Q?CNQAYkErgpa8cqGe4I1Qkah+K5luOgJ/t1WPB5/bb3oaS8G8hZkXUSeVf36U?=
 =?us-ascii?Q?xpMLm20Xh9MG/wBr3slIVgh/3FeSYTwrjByYh1lLRb4HvJaxX3hxILYUtDHR?=
 =?us-ascii?Q?Sc4aIy9VOlmDoPdhTVjah+NYBhquhfzf3GpJdjsWT6T47pnevpC3X8bV6vQw?=
 =?us-ascii?Q?HxlJJl6YfxJEsEu3Gtm51J7/ildd5x3tJLm4sgxnAGUDj4X0Zhg6ul9Qh/Mt?=
 =?us-ascii?Q?FsyVUoVX1COBZhhZOxBzWe7+rGltO5CEBDEA9JA/qZCwEmLq7UfBgAvkBX4l?=
 =?us-ascii?Q?LbDQB3Fo3UjgQaJHF2ai8rowEU59QW8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bgNZln5mVXzJrn1jiELjNQ6pLgDaKLHizAKF72g4reIoJ5beN48U/mthsnSfkW/iKdE/P9D06t6UtO3ZP7E51X7R/Y7YY1lLoZwiwcNcVbkAGYugfyeputiFwZO+q2ryNMsevTXQRF7hxIouPyXMJOs0IUsRpeIO6ZogWIUJOoS24KR4jogNG5qDcO6qMXdSqbE5NO3/M1mHIAn23c3r8jpzabvsThjqKt1k7YgPMhBls06cHXkg0kwxmqL1Zi54REUaEvqujfrpbJgdg8of0FvnrASsiVBwj8I77tjrMbGuUjgzP878S4FE9kkgzwOSGyhFp0X+RpBnaFYNsVrEyZVW1p3AS/Z9doC8ID2fjvLH08LyVhK5zQpGlIRmzfXciiQOMm/gqUsj8q7APoFnDZEKzfGWH7v39HkAn10XPfi/2b58BfW+Il/TFiiK83LRwFCOXFQBByYSfxxumXnBDYM7WDl2MAoOp754rwL51e2dppuAHaVPqyvWXMNrKldliIZXcWRfaK4lwq0vpJKlolcmzFYAyymJKn00qmeL68NgSmXiexHDEsC0dNwv6T5Avg7kxsUPVs9OTVY4wCnD4xhKLIXrmm8OMculAEBKNHE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ffd107-fcfb-4fe8-1e1e-08de7718a615
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2026 22:28:08.4014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXEIi+9EEgL2O8qkAQ3nqLNYGayFP2zvM13mwl5t9oZisR9U+PH2yx6EpwtLIW37G54XBwm3YlW9iXAudamT0Rb/JYkfFmtJMjy6/3PKbeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4944
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=664 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602280210
X-Authority-Analysis: v=2.4 cv=DqJbOW/+ c=1 sm=1 tr=0 ts=69a36c27 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=FIlN-pqBaJ2kcBrbKSgA:9 cc=ntf awl=host:13810
X-Proofpoint-GUID: _J_Y5kfK_zXI6gdJtj61i5jspj0Y-DUT
X-Proofpoint-ORIG-GUID: _J_Y5kfK_zXI6gdJtj61i5jspj0Y-DUT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI4MDIwOSBTYWx0ZWRfX2E0zW5VIPGJF
 /Y8gO4k5U6iiw1N0N35yxB9zygq2gFoU+qSuljC4j8LRoGsmRuVRM3tRPv45bgiKGoQq6WiAd4s
 fvs1CLQxffnSzlL8vKiJbMajysdvktUC47uZU29+BGlWvfQiFlljFj10kmAMvjrny3kD2UsH6OV
 i7xOtLZQ/DnHSh86uCCZ/yiAkTpsKmvC1XSB/m+FC23/m3s34luLW8S5dGu6OKCOds8Nzbsowy4
 u3SnWpiRHJzqNqM32zofnG+4eStVEeE78VvUjmvw11KflklL9p3i44ND3SqduCcLM4Wcq/C05pr
 oXwB1nr9NiR7NqpuOpXrF9FuefiFh8ewhnFjMA+Ah81xrmfzfVGST9Np1Cm4zDPPcauxuGNPhDb
 i5sT4wJ1ZGlFCiIAXhVZ9cac/gkAAUGGZV60afIc+fYnjPNm+jHrNPg263yctwhWzkuMt7lVnmx
 G+aPwLuG7mivqBTf9KxEcIW6Zn7XQQkXu4kYsIzY=


Junxiao,

> This leaking will cause hung when tearing down the scsi host.
> This is an example with iscsi, iscsid hung with the following
> call trace after this kernel log.

Applied to 7.0/scsi-fixes, thanks!

-- 
Martin K. Petersen
