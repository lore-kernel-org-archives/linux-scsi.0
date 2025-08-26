Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AA31EA7F4
	for <linux-scsi@vger.kernel.org>; Tue, 26 Aug 2025 01:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756172503; cv=fail; b=I4FhypXU+HtKhcMAMqLSEmq1HbNCQy/vc3dwSalAWcvoxBpYyZNswn6TvJU/76+jpzkLegRUHyMcvMqJlcAjjSQsTL48MeNP0SQmKaP5ASJ2vIv8GhhkqMAf0TqVPxnxLx230waqR5NDQwK9dvjnvyL2zpqt6XKSr/Pi/iD8G6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756172503; c=relaxed/simple;
	bh=uC/VbHPNZ3kB13a6VztYa3OG8WVgySPE+MhDsUtLigs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=e4pP2qaEUvMiG3QXYWHrjMxtXNtzjetFTdLIkDvcCOIhNkKbjeeoLilcyhmW/y5riWeKet5S23bJnQAdvWaH4nIJhTmYAbzJOb/KSwzzbpYuO63tWXhA7SYLtqP++XYhh+u9ZGAiJuODdzbNjmkVEB50HY6ECQ8TaCV0PUEVyas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kodiQZ/a; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gH6mU61q; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kodiQZ/a";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gH6mU61q"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q1ChUa019401;
	Tue, 26 Aug 2025 01:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+Io9jTPpQEb+zjCZrI
	7bF/UQNLwHsYt/mUDgLMvPx4w=; b=kodiQZ/aLEenu9V8CmU8knaRGzIDORBrPR
	Gtf7oRf38exAvUywIJYmjm/ogDGRBq6NFTJpIqTniwvesuxBgMGzdqP8vMqyjGBS
	AiD2r3F96Bb067AK4y1EL7P9l5K+wHnJVlHFgxQVp6wSsc3eJ3pUCkN3jrwb3LaS
	MZyYkRUwuarhpSbJUcRB9QSzsnFN9x2I+ghFfdJ9pNTNLy6SPXrsS8WwJVM38Swo
	MuGMtDORDWeILnrJXGQRNqQSDKl93HpETYr4itNU+H9sL8wNkhwaafPCbxr0M+++
	5QGXKzZy25IZpGYmAtWrvgF+Yw/ET0lmsYLN8btvWtSwfNrAsAZQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q678ue4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 01:41:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q1ThCh004994;
	Tue, 26 Aug 2025 01:41:38 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012012.outbound.protection.outlook.com [52.101.43.12])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q4393vbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 01:41:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EFZkaB7oTzlwKfdb5WCepw3oPXxwERgiWWIFW0xDaQGzrDjoZTVgX5SUBFzJnSpKxRluwSdm6vTd7XJ0VMm+PZynTXcfgwJMOv0FRkLvOcGl+JM8S4kkvAd8gpaIHYKDoFXtZN5bsRrF3jfxc0Pow4MPI2CoF4/ap3Pq+h17I7ay6taXcnf5dNhRs1rO4jWsxe8lvrGeaOVJ/C3KSbg6APzkn7n2E8zv3K4b4dagPVMn/MzgrzEzMY/0yLQW72Lazd6Yht6bu1/myvQS2NdRVf8tE5XNzElCluQrCmBkRMHFuX/gFaeGRVvZUVEig/VihSPVkfwauHElytNlxq/ThQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Io9jTPpQEb+zjCZrI7bF/UQNLwHsYt/mUDgLMvPx4w=;
 b=FKyG/t2XTK/8/fjity1HrRkDcpx2VTx2T74X8bb/MFqELdxUP4JnJFOpljG2VHrkuJY9fC8FeWWKiU8jSvPs0pKv3Fm1frrSyPWkqytlBIedNYVw74+mLn6LadDJIA0OVweujX6kOMAmWIxOdd59NblJIWL+yY2p4bTYbNmTjQaLMfdO1zVfvpEw5WYtI7Q4rMUJyItkAXmpwbJO0r4J0oy5q8VOEsznTQSVUwUScr+KgonCGfVe/SJnnk9gygAHdu5lqmZfyZBwRxldczfOeb0dik9yZbQEC8uCHTKH5xMgAG9ylwM86IEJapXkUgk498XEpaey2AiudgDZSoKtpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Io9jTPpQEb+zjCZrI7bF/UQNLwHsYt/mUDgLMvPx4w=;
 b=gH6mU61q0b4x5yI4cQKIsvNcvTiI+hy8IHH/Eo3LA4DPvB+Zeah9Ni1t0CL5vdbBiR/dQQSSiWjFkNu3B4oqMbjq35D++rXL3AJmv0aSDAIAY6WLNrsYxET1uJe5CjueQPZqVoo3iPJrV57Hw/C+4d+CzSND7MH134Xg64s7OTo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB6433.namprd10.prod.outlook.com (2603:10b6:510:21c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.22; Tue, 26 Aug
 2025 01:41:35 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Tue, 26 Aug 2025
 01:41:35 +0000
To: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        ranjan.kumar@broadcom.com, prayas.patel@broadcom.com
Subject: Re: [PATCH 0/6] mpi3mr: bug fixes and minor updates
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250820084138.228471-1-chandrakanth.patil@broadcom.com>
	(Chandrakanth Patil's message of "Wed, 20 Aug 2025 14:11:32 +0530")
Organization: Oracle Corporation
Message-ID: <yq1y0r6oo57.fsf@ca-mkp.ca.oracle.com>
References: <20250820084138.228471-1-chandrakanth.patil@broadcom.com>
Date: Mon, 25 Aug 2025 21:41:33 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:510:5::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB6433:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a80d071-12cd-4047-fa55-08dde441b156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YwheyOF6DT9PX9BGWAhiBlY4CuzmIqeXTB0i1n9mX9GZT4xXXlxzi8N1yc1t?=
 =?us-ascii?Q?TCRea5t0l5ka9s6SEel+UR3DBeKHQFu6EnfLggdbAniC68QKaAEm6DeU+iq3?=
 =?us-ascii?Q?ivF3LCF5CP29HaXiuwEoB/CAGQRroy3nqcQ2bqPwsDUeodpRdcid0iGyIUVv?=
 =?us-ascii?Q?YfQlIuWmYXGZMXTPGqZmOJvadvAoDl3cmFXWSrpDGw3w0scOO3+Nbh5JEHq8?=
 =?us-ascii?Q?33rD+u0mCmuiJetYjOhtLG7LiJFEqdXttF+3uB3PW1nabPN/FtovN4e4AoMG?=
 =?us-ascii?Q?/MPTZ7id3+Ehai/qU7NGdgVGfbaCu6RvVh3/rIWgPgaBfH0BfATAA1Wa+SjY?=
 =?us-ascii?Q?rNwpN9+6zsgN2U1TnLUealJOnEcQ22DshZ20PGmfpIlu7EucN1oV03nVVhnl?=
 =?us-ascii?Q?x+CNTEzNAbwv0Ur3QWjmVh4fRIt3GlGvwEMGHHO7L9LkA9pDVELdQYf9voc1?=
 =?us-ascii?Q?2qcAv/EdFmZmC+I0V/8QRF8Q/95Kr+Bhopd9IndalwGsy4ucotJzqYE6zljt?=
 =?us-ascii?Q?gvitonEn27bYwriAqlyKrXopewJlbCIh3EKwxctEor+1EzsYFNh6O87COip6?=
 =?us-ascii?Q?PgpL07d0srZY7oPRWE8qMbODEBMAOLveRcgNeX5DijlKJ3KGQudRDu2Jz7uy?=
 =?us-ascii?Q?caRl1YvNAbIji4Ty+oB/LmU3knq6KYEZKvpwmB6kZCsMjNkwEexb/+IfeNi7?=
 =?us-ascii?Q?TKmsKFBNJUQ4z7nad1QNIXXvENm7DIT2+TA9CqFua6WWdrXD4UCuW4E3H1AW?=
 =?us-ascii?Q?4gMNAL3NCmYzRcaC/KvF2OzLtyhsBVVqFvGxgZb8xkMZ+ipcqODV9Z/clTaD?=
 =?us-ascii?Q?PH6I3t+2hQRzzAz84PA6iNibP13OLzyrK8vA6vxcBL5t94sjbXyXqcKZZw9s?=
 =?us-ascii?Q?W5AY+4t8qbqEM3wUskGQ5BaesYEIQVVkYAV8CwkDgMBDneoot7JJIXDiZoEe?=
 =?us-ascii?Q?phCh7iwPjzioIxBcTm2sh1btkxFF5BHQUP81E5gQBnxwcLzCnKVzpKRgCNnT?=
 =?us-ascii?Q?HeHXWIMV7w1pVyiNCXeedCQxq9axg9GagvHpUp4IceL70kx1VvIlW4kHMZX7?=
 =?us-ascii?Q?tJ30AK0IF8EuLM07jzSc9s6L2baznvSPU4JdBHj3/aAaHa8RC/G7mL6IMgz+?=
 =?us-ascii?Q?C7ArLCA1+QzeD5Uu0fbGavu6zkcQg/3byBGc8F6u3G9WD9Kr8YRM3rTXNqYS?=
 =?us-ascii?Q?OfCNgNksUm9EcnVW4akMsLSAKeguCZDzBzSGdNIla59+VPrVTz5k775oXsqn?=
 =?us-ascii?Q?xFDX4hHxOASYj7Mb6jZsVQ39PDW7vuyp0JCaC+Kl2/u0NZxu+hqJG985gbol?=
 =?us-ascii?Q?rAVXAaWaTRpqZopXRTm+JnyQzHTWenaBdwrdno6jQGJdJVgwUfueDlJgkQA/?=
 =?us-ascii?Q?8HCkF7HV/luMTLIEwIKLqAyal6aednrkVl7N8j+3dHvGKUvrKGlBj/DcUstb?=
 =?us-ascii?Q?JpFtjZCwnx4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?45i+XpUSFiKvulggIZ6/dXUNv5QUgtOv58aFk1WYMrj5iHIicCMoEsAOG4ro?=
 =?us-ascii?Q?riTuaO52iyHqN42g+7OwlL5QutvwLntSC8UJ9jS+eIjklcxkzv7MjHfrtAOr?=
 =?us-ascii?Q?9EBlldKwJB+bmMIIqtr6t+b+tQ8KkIbIG8vHtwNtaBgFVsuFOIPXtTIq02b4?=
 =?us-ascii?Q?NJtqXK8vNnxVfqUXrZe8hItkFiZxaJ26woVxr7QteG6BiiDdbWnFPMtcrjfn?=
 =?us-ascii?Q?reaM8HG/lba3XryTAKxnQvHNzGJyGUopOh+HibjpSdtP1Ju1/64iK8IFT197?=
 =?us-ascii?Q?1l3qsWQFxqOOULrqj2A2mGiJ3TBgvKHFCcsunVShAXUkngpC0Q0+aoHrQFnp?=
 =?us-ascii?Q?shLFWwxpFeZ38PURJ5HnpQpGYTC5DA3sFPd4n9aQ3pxplvzrmzvjP6/kqnzc?=
 =?us-ascii?Q?wwsrr7to3d2VYCvVuXlmePSroIYlAlmRgcFq8GO2E3DDZ2RCWN+sb2FQh8Rg?=
 =?us-ascii?Q?/cJyhWdpjENmnBncepGiixg7AOK49JNvfu38k9kbjAwIaTYYWXuwIRgbhAoV?=
 =?us-ascii?Q?FDCwfwpKu5PDnA5X4WS5zYv6RvRkr8LNUVc3XFnEnc2bedq7wxnBTMok2q5Z?=
 =?us-ascii?Q?3YNXtJYPO/YiTHqygBP9f/PWn3VGwAn0sa/TjjQT5zkYE8+nCXR+ebZHLXSs?=
 =?us-ascii?Q?56Tcy/k7GgXFrV8jNM8JyLxpPQ8cIYmTE1eNKjNRFfArW4bDMBlRPfFBkN0k?=
 =?us-ascii?Q?g7bO5ZKcLOnFBypEQimBsKVOdx0TPl73jab8Wv4vJmiyL0p4bfx+q+tF1clF?=
 =?us-ascii?Q?xH/4IwgKp7VzCCsJpvcK8hMxmhXeYpZEBYxg5SeMuqRp2prB3q3WNu5iVz37?=
 =?us-ascii?Q?Pq5izf+B5GepUh1dIe5vROzWpZsH5ncsRKHSeWmU/193IHDsNHzlkFB3jWuj?=
 =?us-ascii?Q?O+s4VQjvhZkyCeqVLWEk/H3kAluAXhFSFlN7nRWPAlUf8owMqfuvC0jnj/Ww?=
 =?us-ascii?Q?m1ANSfw44Kz+KZwKz0hOgXMbpbz4UkL99PGWgPG4OIJVlhixVtVr9infcfCs?=
 =?us-ascii?Q?2moqmaJyXxrPo2FHylM+OSOOIek9l+dxdabbfXrZuOlcy4o4HIJ8JXm8KABH?=
 =?us-ascii?Q?Tf1rD7d2rThsEccquGbih2Fb+eNPztcFyf28D3U/Xkhe+5LYB+07v/qNMonE?=
 =?us-ascii?Q?V16zIc/NDaea9kMLRrLo7TiClTfy9tuNiFyA8sJ8qhlYTUYAwk+fe3W9mHcD?=
 =?us-ascii?Q?J1fNqUIFH+CvREt6I7bpUveAwF0cdom6xFrDaY2g4IgX8pdEyZKkBC50n51p?=
 =?us-ascii?Q?+8wZuWVLS1D8Bp+FpCWRJ/nuPtKqlCW3vHk0auZbD6fmze37xcY+Jl8yQTO6?=
 =?us-ascii?Q?JscL8lBL/v3Mt/cC7zC5DocEE4XswbtmcxJW5jw7UM2bzw9FYbz+HerznMR0?=
 =?us-ascii?Q?19yXaz6z2S0iaC5R3BySVgONG2Qxhp1HMScSbUXkYAElKXkLPI1G48sBus59?=
 =?us-ascii?Q?mltu8qmrXz3t8TgkG1PQD2H0620FrMyIyd56VcbIidHbc7Qp3fo/pJqzHM57?=
 =?us-ascii?Q?Ow4/abxyx6///G7oEm0dJx8c/3jeIjC3bhSjTCmVxt6tGuWlwvp6ubZ8wVsP?=
 =?us-ascii?Q?za/f09bgxikxTqClaEHj1+D4x4wqowkIVF9p8tI54EqC4S6C/b/EMT3GfYH1?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gPqaaOBVLG4yqwGhUNZ2kJxB/H0NQPANwQVP4MM+lRLrCB0xgaajTpd/CUYqhl3r9m4KyDMeDTT31d3KKI95U5Bx5VUPx9CyBKV6xcNM/gN2WX2W1DYfznulVTXw4aekbkZjvhOHJ3A5Bn9ipIQqkhOf7Un33qxbKfs4nt2DL8teRRQ9BV1MBgWq1Goe4KI7Lp0wcWNGxbObxp/kWepJdEefjm+Qjv66akjJ52R7uJtLS3QNajrTbXAW4yqhOr5q1yJ3CA+yZkWxa6Ed2NFcSmSQba5+HtBUocSiZGfhbgRdAtU+PDYCDXuCLw0OqEYSEMQirJDqJsb11uCk9Fit/JLZq0T+vxjld2Vz6vRuu6B2F7ma9Eb+OkzSxONDUFmOK8rnNW2XAY3tbkFOUaRQ3v0kfJI+h6iTTakrM5r5WY5skKeGye6LWCbBTBNxo+WKNS1fMYavn7yYf7Nnhv0FuAATRXfDPD5+geOJ0Yph7MiS4f6X73qSw7T+nKZ/BnJz08kZhLYyEt+X6OjZe+StOvmeaqJUOAncJvHeCy3A6dtJdzwnu/7MD8YA4v8dnWg+h0MbTMpxTkmDFIxZ32+ArlHI5MUp+F3ezVIAz/sgaB8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a80d071-12cd-4047-fa55-08dde441b156
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 01:41:35.7852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MdThbI9IpNdVIRgXqGrN7Gb2lfX5fLxLET8o50+rUhNoKFFIawENsv6Ter/8TeE7G34lQKlz7EStRUKQcyFVBnbW6mHN4F8v7+4EAH4rEi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_01,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=761 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508260013
X-Proofpoint-GUID: Z9OXIAF_G31kcy9MZC5Tr_dSntI54aJS
X-Proofpoint-ORIG-GUID: Z9OXIAF_G31kcy9MZC5Tr_dSntI54aJS
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68ad10d2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfX7TM0qYpeexHt
 V8QZPRCh3ofVpvEzXjzx/fCHaC2XwppuXZGf4KoUlFi4RW6hqdHtS2cKYwS+jTt0CBaORD7zWGf
 tPpIkPY8ar9tot6N8pFkgMm4phXBP4jyV0yu+mHAv8cP0l5sEOxWpZQYlScjrqtk1TJp2h2Y9ft
 vxWeT0uqMyY40f5bvC+WxM4yUYrEuQilUg3j3ih8rMxaKg2p+3b1uso9sLW2yoW3ZWYt6GsvOPX
 skcvnSNm9b2qCoEhRSsfOsJSDtYvbjZDAw77spkerDpDL6utDOgmIgq9W+c7JFHvHfBnevZ1TsZ
 QlTMdame7V3Xhzs8Hrhd0FFnMJHJi42TR0wzlprQhm4/r/PIPvufUB1AP2dAf0HpV2nZT70H53s
 7CBL26uI


Chandrakanth,

> This series contains mpi3mr driver fixes and minor updates.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
