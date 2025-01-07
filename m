Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E311F2C48
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736264033; cv=fail; b=WU90yZoU8mDMHRRjsO2ay5CJ8mGskUCrJAYMrwxPPZNIs1pC7K9yZeIyZfOhlu8mtKeXzAao39hKnmv8/CKLFNYOCHfo8zTYDSJnFC31KjuhMXya6HdFgnplatZYqnOAkxOmgEo67B5rTNa8eZXxW/okOn/qW+Ui98Hfe7Rxx/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736264033; c=relaxed/simple;
	bh=/VLLpFCqgu6OjDusX5yab851JDWK4s1zDAm7hlPZLJ8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=I0tk4OLylWGb9JAnMmgOqWvgHhZIKp8Lr4yufaPBYMptecgPno2DYFvvd2cJTZAlCsLwmHJaYtVfU9nB3j8Hwq/aJD6B3kKD50wp3oZnJ3WVVFCvw2+MV2sgFsHB3GmoG1nTVFsvZu4LmnMyAjeFUf2z/4q5Fas8RuiezAzhWEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=no0ZDv8r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TH9E865j; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="no0ZDv8r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TH9E865j"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 507FMfMi003767;
	Tue, 7 Jan 2025 15:33:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=II/U9jH+7p4d7Woh
	p3Ye8hrmDrY/xtmVCx8pEdBNeuk=; b=no0ZDv8rOfmO1heectpMkeSnQBKfA83K
	iFeVrK9EWQrl+osaL7PK2feX8UdgMyXE0HMSVPDzw67I+zJQCNbU5GBIb6AFlUtu
	UQTAhCxzSGaOcY6WrVhj6j0P4rKDC7yXoggGcadBYZkyJbo3WZDlWfXmAbOs/kJz
	tMZ1Jbtu3KVXegQsnAfvaaecMPt4u8VolVw9Ja759v9X+pzToOYIXTY7sR+jOznU
	R7dK3Vm+DQoA6jE5uU1ot+YcxoG6omXSr9nZiv0VQAocUpavRFlBHlZvPXbDeKy4
	91ITFr5U0UMATNIxHvMki4DWpr0ag7Smo8CzPCil5XaYI2uzaY9seQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuk058yq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 15:33:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 507FFH3w008550;
	Tue, 7 Jan 2025 15:33:46 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xue8duup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 15:33:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xl2mUwxxsD3NM5OgyLw0oFMFfq1Z+HvaYO8wYHSTJYoydk6OQul5lxnllutPXd7JOk2HUdRyb4pWDFl033VoC7pq7TdhQN2DA7q0ZofRYajaVBj62Tz0rU/y2kS0iecQAPUbFWtEAQ0C9Cwp6x/HV5jaQMmkkr+4jvKo1q5F9DENiKg8Nk3UGH+Rbl8ckwugrnQJ7qEVPhrqhmyOvWf5fsikXRGtd4ILKjGlLWZFom8oPI60uEQjwqC1efH66r4Mbw3b3Oj5q8PZzYGmzWH4QmKGpMPimnsK6csc8xkycYgVC2VVcXKUvJw/RE5XWkbVcgk7sxx5VIhmm3CiS4AnJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=II/U9jH+7p4d7Wohp3Ye8hrmDrY/xtmVCx8pEdBNeuk=;
 b=c44sIQxcqkcoPmafkLRIOgQWzafPwEbydKJm3wlwQ5cBktZA5gNt3GpsRFhVHa9Bt11uRfvWu5gtmFgJmKyeWua1ezuOFtbAfWPogZtX7ErwNEUO9OWXhOdesKC6paSKERPlZEkVbc4oltKRZ3DtJhJVcGFkFkUsazNKJEsC+t2q/WX9X5mcreGTrd0jvNd74Ci1w0KNxwWqjeD6P5d0ZFGYPn1b5GgO+DKXP3KslccA7Yf19xRGrtYvUlSOmeNcLro/35toDfdi4bAq2dnpjMqVHQanN2QWetKnYqJaCLXfo+7i5X+AKZinoLt29OccoprwejpojLI0iap92VMypA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=II/U9jH+7p4d7Wohp3Ye8hrmDrY/xtmVCx8pEdBNeuk=;
 b=TH9E865jqftqcWeGCjGpsbURMW+XBKjQme2uewSQyGWJNy/Cug2+MZHy6GKVmVT3KmdpVcANfgRbubFUEjGdLfDLiFcB+lhFNxP15zi4/ZLao2uoTp+dyu2vWy4RkylCqFE0Vx1w28lp0IgY3j/f/vdaGqFumIQN8UaS6+5su9g=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB7476.namprd10.prod.outlook.com (2603:10b6:8:17d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Tue, 7 Jan
 2025 15:33:44 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.018; Tue, 7 Jan 2025
 15:33:44 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] scsi: scsi_debug: Constify sdebug_driver_template
Date: Tue,  7 Jan 2025 15:33:25 +0000
Message-Id: <20250107153325.1689432-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0079.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB7476:EE_
X-MS-Office365-Filtering-Correlation-Id: 6652b1e4-403f-4ee9-e193-08dd2f30abf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bEKXlewYXYSq4Y6DScAgpiUlGU0BsXTbOnGpNblcHTw8T60KfzL9eAieoN7F?=
 =?us-ascii?Q?uqnvlC028ozuJTlj+5p9TzH6x7l6FatoQm86IoJhiALYtvL/7pNGw3sFDyEs?=
 =?us-ascii?Q?CMQry42Di8Yn1kf/AhneA/7H8/U3In+VMnQbFxtQUbVLMxEQmrRWFlCnbEG1?=
 =?us-ascii?Q?lyhrveyVMmo0cDlFy9BW9mXWWlNwiZSGL/gBAc4PkGOGZqsA/dGmsXrW/h9y?=
 =?us-ascii?Q?3uD+5YfiUC8bMqr+YhEiMRp4LF3IssErmEauPfyBFKsGIa+22/wZr/8tzimz?=
 =?us-ascii?Q?hN4FLKistHrvvGADoWkQTw3LqnSMaoHvFAEOTcxfpK8hLLm15AJg7CLSXny2?=
 =?us-ascii?Q?TD6s7AEEGWqxCKwYcElbQ7ox1HdQoFv6LYVqCvpJo4wifaTmjs9pCVD+DcEi?=
 =?us-ascii?Q?j/wKrCsSqlrUAnViRU8WCf0pse1zexQY+IbW9Ea7/KuQFd+9yFCGQSm+3euS?=
 =?us-ascii?Q?kfCo6/27tHCcFrUDsYk7PP2FgPC2lKmHToFutzhJmZz0nku6tiJQxzGDrmin?=
 =?us-ascii?Q?dpIC8hO+3n84f8CrJh/xOD/KlLU5uZ9ZBh7NOLRWOv4dz+rDx6uLbsynfrzg?=
 =?us-ascii?Q?/7xGETJ1dgeFmfiOJAVQ/6nEh/Gwv/+sXDZ7QtgTU0U6ET5RWlZ3GSYkUOUQ?=
 =?us-ascii?Q?gJiWfrEnku/2miwO/49CTa6dKcAdf7oYgbGHTLXPgza7bFurZS965kYiBRPv?=
 =?us-ascii?Q?wvZd/a/QfdHFa2M9PAzPwddGw4kmRr9STpIC2PxTVquv5ctrTaD5lvLdiZ7l?=
 =?us-ascii?Q?Is19tBtvklwReIgZHVQuXB9qNz4MJcfH+KZPiOzeE3QqXZh6sMUZ054v0yge?=
 =?us-ascii?Q?8wF7fvSdAO6oNeTdbvxr8qJKVf7luw1vKD0oktwiqwUD1CPSPs+xQit9FXmd?=
 =?us-ascii?Q?K17MXxvadmtGDR9skUJvfEyvmwct6qN5TOyhkbo/wy80Qcn6i8WfQKeYYPoF?=
 =?us-ascii?Q?AFuXdoiK77mO7mxbBgISbt1AkkmW2aGvdptbd6ne9ZSxzqOuk5ynLtpt4l2c?=
 =?us-ascii?Q?2bgPC/2Ln6QJjyEJURxPCgUN5rrtjkbRAie6SJ5mP6nFhhMiybysvTs/8Q0W?=
 =?us-ascii?Q?0LWfQN9looAbjc2XTTM4VJqeENMqs7Ds6xvKBoXHODXY6jyqryGkQ97ajh4F?=
 =?us-ascii?Q?IAE4vWTZS8uN2R9bqsBI25yQl8qKSZMKn6RGccFttWfZhfLN7VlgQekhNcy5?=
 =?us-ascii?Q?FmPvN1oZ+wMGknDFIz7LeqGXUHJE7MiRosDFYgGX17yI0qgTO9GO0VWrAk24?=
 =?us-ascii?Q?0Lw9uSDOBZKY+WVzZybrKb6XnGOBBi1l4PnSI78V/Pgc+0STrotPvBvU58Q6?=
 =?us-ascii?Q?AIhib0v4CEMikSr0lnTD7RU8uuYoS4S4l2Hipu/UGEdmoloHlLd9Mp6fbUBc?=
 =?us-ascii?Q?iYCtPKA1jSGnIaw+xzk61l83jxrf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wINI+vXCGyRLjgLzmaEWv556B9mLFjOTak5hKnVCpkIOooe/NSBPPPQ1M4f4?=
 =?us-ascii?Q?qs10cAvaE8Fb7V6a0EtIvPTVd80wYuSpcjpj/KSbLxhMrDMfbZI84Ex1y7DC?=
 =?us-ascii?Q?pLgOmTarYKE0mQ1urdjRdG1zKWUGqgapWZ4/1NYr70Wq501yQQzvxck8U/Ry?=
 =?us-ascii?Q?9qguG9WWyFa3sbiyzvo90Bt+9mmaH9L3XaHqGtsTXEqX4+trQ3tsqPBhZWCm?=
 =?us-ascii?Q?FR9q1nWJp8gi4WS+bQbXfnjrySa/RTwepfn9KyzgrgErSvFPXdW0Bvx9hBHd?=
 =?us-ascii?Q?egNz2TKTgZT7bM7PYV58pQDFMeNfkM+kZW9MrqiAk9BlWlbGvQhll7Z65Isk?=
 =?us-ascii?Q?yrD8b4kWXbVz4PidiKrzHpwCRzoDjOmiUIUiMt3ZZyxseRhP/ZfQCP4ZSH6R?=
 =?us-ascii?Q?3Fjo/TdeKn0V8oagwFfoei8BE+HoCIeUDMN16L/5QibOJVQO6seMbN3rvuN6?=
 =?us-ascii?Q?eMkrY7zpKwF6ritFUTrku/eajsP11OIYrAXezHvBUU8EeSW2SRJve+Hq5Zjp?=
 =?us-ascii?Q?9YHZRwCDwBC/SOtiiLGux7rcnS4sSRGQytoYya7QfqVeVFcUh6Lbnbl33PWZ?=
 =?us-ascii?Q?XNkhSB8hDyTAbTP2yBnycciExRB2moF+AOlREZnQ5cuslWGxBqDpZTIsG6oS?=
 =?us-ascii?Q?GLw1XgAIWiMX1es3Czt2F+tWczrCFY+5VUqC+jvvQYvJ/2jp3zyblzAiFA1q?=
 =?us-ascii?Q?XnnzjlN/XRSgTAXOfKkKeecm+KiyGNvSXUrnjumIhqJGr/JD+v4ApOHQnQCp?=
 =?us-ascii?Q?UQEMcJWrMQLqX3tno77qO7QL9b0HWJTkLYkTue14v4RgrZKezQ82cKa+Qxrv?=
 =?us-ascii?Q?cv2Sp/m2nhTIKXrNtjeaVrG1MF6V7hzRozyNiDGWa4rdAIVU83I1bnb4bmfp?=
 =?us-ascii?Q?BDq9tTJhM4XbeDzej2bxw1SYZyvleAfja+ATQIITONA0+vws5Le90kd522kl?=
 =?us-ascii?Q?hgh0i5/WCO6lBZJXwM1JlMPkvngKar1zgfjVrhJmT+fdKDyNLBjh3v5xwQMf?=
 =?us-ascii?Q?t5bkMFHgwRTI0klEvbsgDVlfjfrMycZ75Ho9CscARxrMMwYtPUhb0c/1g/iX?=
 =?us-ascii?Q?ZRH1kzVV7Jxc5n8FcMNPJyKXSuAtFY5eL+IBOXsI4XVQswfupYDirbcNzXam?=
 =?us-ascii?Q?RipauA1JdFY733yonJl5qnypFZ9mZSmd7QxRbfcrdLQ/LEKSXAiG2y62JTbu?=
 =?us-ascii?Q?ES9u0sdalZtr+bX8x7OCD3UcB0MdDXCOAUx9pEU9nEuUulD7Ias5fuZmN+IF?=
 =?us-ascii?Q?ER3KErsQsiqUR1GO3nhOVeQlFsAQGc1kDpjL2zv7/kRxfuykQ/XXeZsX5XOl?=
 =?us-ascii?Q?23j0lGfMpG0MffKplMdffT9E/glRe7HsVapwUndNSrKsCE/lkGL0cnoEzkAE?=
 =?us-ascii?Q?XwjqGcoG/ddBR3n3lE9k5DF3dOoPI1n7IrslpUjpjv8LyTwvn4SKHFFRoY3W?=
 =?us-ascii?Q?GGMRv7PqD/GFGUWZlAnArY5leGyNGiyFZAHMEs5YoZ97BpsVUGbj0cN0IasL?=
 =?us-ascii?Q?rBZV2P0igPuS1ZsFc+3GF2p0gk7cVGmP5UV0J8LXyyH6IbpsL4WqcGU6GhjH?=
 =?us-ascii?Q?Asdy+v9t01agEUz9pJfyDlSeFlO5XlR8odVTktey7+10aXh+/SXvimdBgOYk?=
 =?us-ascii?Q?fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mbDbZYBWxk6px+L2hE4lzpxmhKZZgbj7mvWQx06Jscdpj83VXVq5q1BI16cNENiQLZ0ogUbOksCUiXJRDoJhwhz5BlOTFhQTMpUoJVw/IlNQnQaMCGqD3h8JVOfu+hf0qRH6LYBM0lCJj+5OcA2F3jlhLv2w7TZdDOvLdlERBeoPYQRbbK1Y7Ym9cpUGuockjvpDbvsxddu4DFSjDURFb42JzOn5SPVG/6PD6wLPwd7OUvTX2fH90RNkXEGe5I8u5d2kgCJZLMAUcFL6Svvkt6HQzE7iwP93m2M9/JfoIVgP6SZv1L8mpFeTqrHMXIQcDEmv8BH5uXypiLeilbcNMA/V7CN+WNw9c6t/B8LF7DN1s4RW69rSJoPV9H1qqvkJ2spys3JvTIcPXTSrJUReBBKVOdf9asjs6EgZHPXNJywLovaOZ8oB34bfp0GFEzmegkNypGupSS/dHsywvk2fskBkaz3q2VBdVjTDl0MdwKO/EptJotcjBuCkHvlkxW05jP3ssxTKzt9FVG7ipJT9kL9VT/XIBvmWx4fJyIjvWb3/0F0BAUsiVhxz5JvzLfHi+PEMdCVsnPEJM3A8otKVLLlTO9fB5X6hI6yP+BcKjp4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6652b1e4-403f-4ee9-e193-08dd2f30abf9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 15:33:44.8756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9kIXGDSYEUS7UaIhuclkB5Y5rVhLP6pvYytuoTRsjvKtEkcL2PEnoTsuP5P+5/7UkGJr1zMmtF7b54lub/0WdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7476
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-07_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501070130
X-Proofpoint-ORIG-GUID: jFzBKGZQJubjWWlTB4UAjZPaDwkU6ekE
X-Proofpoint-GUID: jFzBKGZQJubjWWlTB4UAjZPaDwkU6ekE

It's better to have sdebug_driver_template as const, so update the probe
path to set the shost members directly after allocation and make that
change.

Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b4d425c2c1bd..435c13d72733 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8707,7 +8707,7 @@ static int sdebug_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	return 0;
 }
 
-static struct scsi_host_template sdebug_driver_template = {
+static const struct scsi_host_template sdebug_driver_template = {
 	.show_info =		scsi_debug_show_info,
 	.write_info =		scsi_debug_write_info,
 	.proc_name =		sdebug_proc_name,
@@ -8750,17 +8750,17 @@ static int sdebug_driver_probe(struct device *dev)
 
 	sdbg_host = dev_to_sdebug_host(dev);
 
-	sdebug_driver_template.can_queue = sdebug_max_queue;
-	sdebug_driver_template.cmd_per_lun = sdebug_max_queue;
-	if (!sdebug_clustering)
-		sdebug_driver_template.dma_boundary = PAGE_SIZE - 1;
-
 	hpnt = scsi_host_alloc(&sdebug_driver_template, 0);
 	if (NULL == hpnt) {
 		pr_err("scsi_host_alloc failed\n");
 		error = -ENODEV;
 		return error;
 	}
+	hpnt->can_queue = sdebug_max_queue;
+	hpnt->cmd_per_lun = sdebug_max_queue;
+	if (!sdebug_clustering)
+		hpnt->dma_boundary = PAGE_SIZE - 1;
+
 	if (submit_queues > nr_cpu_ids) {
 		pr_warn("%s: trim submit_queues (was %d) to nr_cpu_ids=%u\n",
 			my_name, submit_queues, nr_cpu_ids);
-- 
2.31.1

