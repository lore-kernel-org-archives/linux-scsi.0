Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DEB1373
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 01:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726189965; cv=fail; b=MfJDqeoYnexncRSWESxcewAue0P9b7U4VEApmEslFBRYYrcalqfiRkB4LKOdD7tYipJ/z3+AEpNRYhDbC3djN+PyOaxXGDMwKr7/pbRubSWYpdUcSFt5l7/3J7ZnI/1VtYP3MKTSse1wb22NEziR+2hU4duFaEQoiUB/OfVFPQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726189965; c=relaxed/simple;
	bh=WQtS+65yTEFi4yiX7A9O0b42IUUXhK8wtk6+gGNeT2A=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rUESmccBxCdgNxEd3VbT4VCOC7jcM5HWsHWSU4Ikqlegu8BiGCRIdQID/0Ez7OYGtX6joufIe3Kv5oax1qVIp1ubQXaZeFMERTNOkcV/qYNFXc25vbbMrKI+q4S/syC6g0Hpu3/bvrqzFVhTLWQ3f0gpbVCXrOLoiibBZpLw7XU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j1ZxBYNQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OhlLVemm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j1ZxBYNQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OhlLVemm"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBnHd022957;
	Fri, 13 Sep 2024 01:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=Ipl3RwWHJjZJOV
	YxlyOEJo85jayelUSko9317y1WqdE=; b=j1ZxBYNQUA69a/yJMcVUuxmXFvQtOS
	6Qd5tyjtyH0k2I4sDIt7gFMW9m3orp7uoE8GKezb7QDvO4wHurMUA/SQxTMZu5X3
	/jjoQnLtWxIOlJSyIy75e45EH4jMtYdA88kHZpZgZWodsg7WecPlV/9WUe3O8Rzl
	mltF4E7yu8oaLnUfNEyixlzVDqiXRPjywtpDLGbRGL9an0X1nJ9lrE/8rpD0ElE/
	h6mLrpJKGvKR3Re7NSHR5zPb8uRdsG1ZwD4QL1kdDg2fB1q48GENgEPaMHOj+MIX
	1u1+glW0TsbL7+yb3+YcRgtgVdXujwHm6nFtBaA63m4wqURYLwyXu4Rg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gde0cbkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:12:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CNo3Nm004967;
	Fri, 13 Sep 2024 01:12:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9c2d6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 01:12:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qLQjdx3nQt+loOgSJyFR0zgXLBf/1JFZJirlHo2zM14CeduFknulNIoLO75DcHx1VMZrAIddQBE2byn1qapwaaHWbicbrmKI0A9WbGxizVF2VP9qtS677fRlgwb79uTCaq9Y41d4dbskWrlhc26wmz2w5iqjPNUjHACrlLpuL6gsLYa3XKPo/4N0bBXK+EH+w9t1f4UtzV5kcK9Gvoxy+yQoBbGXMIrVvstFNEmk0qY66UXIF01YG5Z3jT/VbX2pFIjpBljNrPCyXDrifPtNm0Pvpj29EnnMDKj0LVJ4yA5GJeZ4xESMJepLhJ2ln084fcB4u0egH9Op3Z7wBTGJBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ipl3RwWHJjZJOVYxlyOEJo85jayelUSko9317y1WqdE=;
 b=j+VBC9H1Y7OhQad0uDx+z0wvqg2oOBMMoL4zPYpENw1/m9mgoz3cJD+8iiT5MdXXV9JtO/55MGl2TG+6VgtQqyfD/SZyZFnfqjH5bTJjIcUHRtqLN7/oRMa76l9BvWwmrnIiP4KacWMFVIqaTPYCBupHuFMsrMpipaz9SjS8/q3TVo3b/sNyVdynlM7zqN1eYXeIzfTfPPN37Y9dgoV65fuM5jOvxHxKjeQqGyci+s/MS0pa76Dkr0HVNlB5g5fxL0bLwqHzqzYItTfNygrATBVULHmvyJLb1pwLvpoAQet7gTBQDphv/eSmL9mRHJ1PJF2p4C7u4qidz/P2kF2+7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ipl3RwWHJjZJOVYxlyOEJo85jayelUSko9317y1WqdE=;
 b=OhlLVemmXUiXmZBW0Dp/iTn3gngrwdI1NQWY135RTt9OGgCBdBqvrpubxIcac98Nr/YsEcHNDVK2WpQnCTtH4KFjTTjrmCIu7eWSnFnOxESZEbZyfdMqYCWCT8wzJ4Ouw50J4y3wE9oBub45haTNG9ByI1PzqAv7Yvg6lAooz4w=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB4925.namprd10.prod.outlook.com (2603:10b6:5:297::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.8; Fri, 13 Sep
 2024 01:12:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 01:12:35 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, prayas.patel@broadcom.com
Subject: Re: [PATCH v1 0/5] mpi3mr: Few Enhancements and minor fix
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240905102753.105310-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Thu, 5 Sep 2024 15:57:48 +0530")
Organization: Oracle Corporation
Message-ID: <yq11q1owe5b.fsf@ca-mkp.ca.oracle.com>
References: <20240905102753.105310-1-ranjan.kumar@broadcom.com>
Date: Thu, 12 Sep 2024 21:12:33 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0712.namprd03.prod.outlook.com
 (2603:10b6:408:ef::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB4925:EE_
X-MS-Office365-Filtering-Correlation-Id: d92bcd61-1230-4991-13aa-08dcd39126f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S2Jdhp3QPPG7d8qLuTMnMGZO8ZYBnQMyd9dWmQ6Vs85CxYndk16IpT2tkuON?=
 =?us-ascii?Q?8s5mP7FIYB1G86ea5oRQvtNpw4KUKUoj8bYOqjT3iERFHa1y3GkbmFOseCoA?=
 =?us-ascii?Q?oFpfuEqnjUFOXdfTLS0roHTXanJ1NUCvHnUzfDqF7QxMl7rOrgOysnQLsyiz?=
 =?us-ascii?Q?ICdptOgUwxSOI4R1POnWLOfZIl8Hgr34t0fcTXA3ZqhyLGC9trOJkF5jQaCW?=
 =?us-ascii?Q?eGFQ9jIXcat2MKeHAeIfCQXkU3uq8JFWpVHAjEDGaclySThpYgToT6+9v7PD?=
 =?us-ascii?Q?/qpMw/ojEHreZXwAvnXgQqosm1/tM6G6bHi/qbkft1ZY6Ta7brOIQKMISyeQ?=
 =?us-ascii?Q?VPz9GA7MqVVvvWwUIOCC/5Dv2iMgHKa2NeZTvcn8BuQhrpWnSzld4YTjbqtE?=
 =?us-ascii?Q?b+BVHbwWPl3MFFq3hT1RuQDVIX8Bpg2Jp2NLkw3W/tyJHz6rV+MrpF8rMJiw?=
 =?us-ascii?Q?Q7wMzm6ERfalDbY1RI/603qyPftw8BMJv+1EzzbLRotnJwUj6ZZmc3ZRCyVC?=
 =?us-ascii?Q?aR1mp4CG7gpm56RXOqFJoz1QQq7v0jJwfni9b5hm8U4N6UJ+j/mrOerZ8vIB?=
 =?us-ascii?Q?21AWBh79aXMnYZJs3k5GDxS9ecTWBMohRRDLMGeplXyHpRZygg9NFwGir41g?=
 =?us-ascii?Q?epjDVafUvaE5SKmyt/TT40Hbp7mzzzuRlWylkoNea81N7qRNSnDQihUpxNU2?=
 =?us-ascii?Q?N2mn3wezs1L1D+S/Q+EU+qlthwbyMoGIs5q20v4Z81Nvf8XwgOc2bf9I2KCW?=
 =?us-ascii?Q?hfyGKliwQUKP96LjKQOiegtkNyV5WIyUyqdwlKSy4ihUjg/vPh/PEyfMXrAO?=
 =?us-ascii?Q?5v056yk8BoGjdiZ5xv1jxHBJ22bs3rau2i2L035bj1LrJ9+Sl+8Atzu0bkPm?=
 =?us-ascii?Q?o55RIDSWkDtnx/dyN2T4R4DjN2UV2HxVUqgNxsEQHJNJDEVeM3WAqjIa5ZcR?=
 =?us-ascii?Q?vtrhdD/3FYX76vpO5eCXCTRMckJKkYOxfYkedtisMcvS1R3nFr/9mvmL59E6?=
 =?us-ascii?Q?c3JXc1QnWyhbb9+DLtqf9sSlRSUMAvSfkbgH/H916D6y+/ymANbYmW5tQR5b?=
 =?us-ascii?Q?lbu7oXo4J7jXpNyJ+8FAIOZMLz1O0LBm7hucbmUB/1oacZobthEzHXbfII0z?=
 =?us-ascii?Q?8VuCWHclhUuk2PqKziCMp9T4k6mwERCdVP4NGTaT9AJLb3ArfZIHhS9I4Dwx?=
 =?us-ascii?Q?MGOsHF8SmjmtRPccTNs/pU9Y6SqhDnhQIpo1yxSNPMZbosIva/wq4WiUq2C3?=
 =?us-ascii?Q?aF1Qqjq87isDPBEWFRT9nSp+rJuZbxQpQXmJEbr5y6+MoJYCdXiKH3m0VjHO?=
 =?us-ascii?Q?oIAm6q8hOzdMdMRk01XrVeJMGrnvT0IyAZd77A2U0voubg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KlhpF4DDhKXaTQ4wHyCYe1KXVumyYjtfKuLJDKs4HxtajtQZzP64mGCKZdW0?=
 =?us-ascii?Q?buDZWjzwjZu8sO+hUpeVUt74H1yU+aqwb2klLcYc3eTILN649SNe1gAhpoIg?=
 =?us-ascii?Q?kurwAHR0y0YBr8GIQcQnEXfDKNBfDgdcmEJcCIx3X5qGVhe2Mgpm6e3xVNaW?=
 =?us-ascii?Q?P8rWJTJqBFcm3fuYxPPabgVsLSnaI+ndTyvqdrGdMrxHz4Xlu8c6e1iAcJDo?=
 =?us-ascii?Q?2Vq6kU6Wl5ASVBvjtdkbyR4mLT6mfV/IDF3/Zna6Gg8LbymJgBI7np5tTvts?=
 =?us-ascii?Q?w9DjEB9c/eRHbuQ6bzjl7VtoheJPZgz33VRfSb21tF905UI2okW7J2j8qW5h?=
 =?us-ascii?Q?AWNSymz+eurCIm8J3NzvaIlIFQ5HWNxPjc9ElyxVNDVmRLHNhqetNsD9v8SD?=
 =?us-ascii?Q?mphr+gYn6Yk2tNUL8NMYv/vO+Qe8HJWokFSLIo2FYQ6KgivoQDUXlQ8XL5lh?=
 =?us-ascii?Q?gmaFmJSbfXeHX22p+kDDsrczLrOGjHlQ/yV4+96JYl/OqWZur00bDsmy684Q?=
 =?us-ascii?Q?GMwByiAs04yHNcr7yZzAoKtQ/zStURRuU64HmiFo1cWOvEE+aXFq/mIPbF/P?=
 =?us-ascii?Q?uEayWCR+/klyhBY/gaf1t+3poShqHe465H8hv5whWiqAe8rrHbncEjjY3vvf?=
 =?us-ascii?Q?UmPvKlyGHpuC2naqWgZvU+R3fzuFfmtsQW7VB1aMXCr95ZEcSiNQHISXVCnd?=
 =?us-ascii?Q?qs5IL4x8KAaQyaLG5kqBgBsbLZNF9pem6cUi6LTh1Q1G9Z7sU1eboBttoGwt?=
 =?us-ascii?Q?JuiJT8YAFPlY6qu4Eg0FE47ekr9ow7k9oqTU6om+DI3bjJXCu4z4yFtFG/3m?=
 =?us-ascii?Q?vtXGUERTUQYyABg/giDcrhvZn9hLYt9DPfYn0r1G4IW73GZruWn8+Ot0UFMn?=
 =?us-ascii?Q?H2tAIlBRmFLx6thFo8oJnDj3kifwNFCq2wQPXHuil+PGUY0bwCOYjgDy/Mss?=
 =?us-ascii?Q?snUd3m1Own3c30WDrh5zC3mZps1Rym8EFPpDWdG0pROp6WGs6tF5yw6ctnTu?=
 =?us-ascii?Q?cj0lvM5Nl/8HTcM7/BQ49A+cj5ImFgosakUUe04crT+/TX9tc7VSLUw1510g?=
 =?us-ascii?Q?xPQHAGdFRy6vPlEc6siODhLTrsu2MUALAywqaofgZgQO38fXGC9HI9KVmqFZ?=
 =?us-ascii?Q?WwEbu7dbRevzYBih56k2dQ85OYX5WSc/ZWUb+kZGkrHkoNdQK3fecClUe9a1?=
 =?us-ascii?Q?hpNpSjIRV2Qq7NBLEjO2Nc9z6KlJo2I2ZQlLfVHHW77U5GH1sp8IB4s+CHQz?=
 =?us-ascii?Q?vxKNve83xj+qa/D4jk2xS3y4XIH0O3nB3qSqOv+ts2RG4xbAB3OjBnFSLmB8?=
 =?us-ascii?Q?J2/9rqWf7e6hSV7Li1TG8ngUMfxE9G04Vwu4qG1HED+RVj3t+zGGgq1ngwTP?=
 =?us-ascii?Q?oPYg9J9MnLUay25r/Kl5BHrBC3jmnSRge73fwXK0XMeNHqcycJNSAErQBrm0?=
 =?us-ascii?Q?yRReeLgLYRzZ82gUts6ZbuOyJ93QsgWPsvFN0GtvAA79gCbOSJVHs0H0hYcn?=
 =?us-ascii?Q?Br6pDJ49Y7yUVy7SRt4ap0mha5D17+Miend612c0cKcto2dx9kqoSStjnvdV?=
 =?us-ascii?Q?zGC/VaEgYmK+7ihfygDFIw9aRpfCBVT0VzRJgOJmCKwZtKBDkln0uOVh/tfk?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jlp4c41IUIQFJ7FzVvdHstETDqyhqAeDYgY+E/R7lFwcbPBukLyjcrUohGu74QBnc1yWUe8M4dzvvdXQfVhgYP3DAaWeJW5aJj9IeP/chGaraZhfy45VyKc2gtTHcCNjcIznz3Ru1lBp0emJKtXaW3y/7llgD3AectEaHYfHzeVlOIW1BGB3Uf9h5FJi71w5Ntb/ea/2lD3FnOyCaMKnVkTpWNwmevzFfWDXWEheS/JaIg5fuhwQOAtCdLfJWFECFGQW8lLvIoFnMeilqt/T1E7I/+ga2j8qJPCkvnrwr20n7ynFZsBJvrxz/ODKfTLZNSJ0NDVdpPiIeYX8G6Q+hN1jxBuCEXrH/6Q5YBS1seYqvd5+1nvaKfMSHjs2xtZlzLQexNX1EBENMlixobkmIFb/bDy8GKBcVsPxlMTSZVE4Jy9mcUMysq2VO4QFO1iJvEKfXlRYRIJ3RtIZ+WbKU8lWx7gaaWI4oU5fdG+j5ZvOXsrg7OpMT7WAryYzX32/8z34XDblPcMs6PwWJDeOMLcurTbHzK34VEdZK613V582QNaUTZ5nmNnUhvC6J+X3GpvxZjMOUHs/FG7WzvRh/Yhhym0HOtPLJ1RtmE3t4AE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d92bcd61-1230-4991-13aa-08dcd39126f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 01:12:35.7913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: asTigJlJNEtKRbHXZSaggCE7FOs1BjZec3RykIrAJZtFSXO+7euZxzNFBJcUlC/lJ9AcW/fHTjgQQtWi0ff+5rzrITdEaImrBztiEYd8hIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4925
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_11,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=794 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130007
X-Proofpoint-ORIG-GUID: EBHLb-y5VSsaGbYPnnq7N-IFYeSOtvuH
X-Proofpoint-GUID: EBHLb-y5VSsaGbYPnnq7N-IFYeSOtvuH


Ranjan,

> Few Enhancements and minor fix of mpi3mr driver.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
