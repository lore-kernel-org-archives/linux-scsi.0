Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88DA221FC7
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 02:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755656571; cv=fail; b=mfP7AIYpt4osJAz+bomDEwcsXOySoEQj/VC1rANmzyEPTeZy8aKQgj5O86fmoio+o3mep8Epx9A17Ywjiy1dlt0/P3MaLw5CW7PtQkKepW579kXzSUAdBBsXDXivBCteDOFDlemUXE9DEqr0AlZ8A5l27H+H3sJLY/rCQS4jt5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755656571; c=relaxed/simple;
	bh=EGY7eO3Ni7yFevor3wE9hpnaOb2z8nSxVOL6G22sajs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=R9JcIB1gIv8Tf8/xC05wjRNSmIz4dpEso6c8Aed1Z9370mOqh+goGvtHk0nxeAqPmvjVsOc/HbMFue3HyaJSFSgqZilk/k9ecYmfNNdFbpWf+DyatMwes5iNY3W8ImF6UDi1ULiP1YKSCd73cM2zgUINet9bmvFTPPoydyygoSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Odq+WcbD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XRwFvDGo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Odq+WcbD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XRwFvDGo"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBqv1005563;
	Wed, 20 Aug 2025 02:21:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Ve5bfyUuTHTlgOz18r
	eQ/CPdb7H20UP1ojEPs1zzIHs=; b=Odq+WcbDzMQLXWPEVnWBsv1D4N78w6+Fpx
	95B+UuYZl4eRCu4u2zkYuQ1CLgTv8teJfbBq9ZfCA3+XuqSGAuErawmWWKAoKCe/
	QxabULZeqw3jXxSFQ2BX7KRXlRE1G+2VQyW9/uZBmCQEIldAgtAoaVxiRaj15Iq0
	5IgH1ff/hz8v60fJf8yWwOcWHRIg7EhLpnu6qnVV4/OtiYRt2JHjZXpcDn8G1iSe
	CPmO1dBVfs6ooxEmmFJHhibAcNydWpHwqulMT1UffLPEitvQf3QVn8EoXpjF/mQs
	yI6k2dUnw6IkFPRm05qOj9WFvVrAP9apAa7JMgsrN4M+VG7sBbxg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsr9yd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:21:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNOHi8030147;
	Wed, 20 Aug 2025 02:21:51 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3tc0hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:21:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=heDZteMNzUa2aa0HxqgPRSHa0RREiRqINlUCE3gjauL2VifumFVD+bm/pBK3Hc3S/C487TViq5CLh83nf9tgNuOMJez+YUh8yGGCdulc01pauzEXGVqRFAmZTkfs3Zub6phSpzusVmo3wl4Ahu9Dfbhhlh99MsKW8rJiB9QpXWjVPfYcHq1K0hKsshVDCRgFgdDYCjr67UewA1gxuHz2t9a2ingmT9/y2JMRAvXD8VD7jQNDu7XxSXNOfXTQgCC45aEB7xaH0EJUP+gbMj3vqW5UySGZ7iWKkdAryadPnf8Co1CTpTVTZg0D6Z/UbINDIF8QBrkDtmQOj+K5WnfqEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ve5bfyUuTHTlgOz18reQ/CPdb7H20UP1ojEPs1zzIHs=;
 b=O44gtsm5zTOGRTh6Rl7qU0kf2/VjN7WiImEBCuAQwV6q3qoTSUnM9K0gOWekjWuOup31Joee3XRKf00xcyx8LkkNAkLPz6sYCTGFCsl7IYf6y+RTL0WF4VfqgMXhmJbank9zeERpVv0fDrt83eYT4xjYZTB7rFqqiU+QbA33KolBaQTuM9cCUBqZPQs7v084IoxSj/7y5LYQ7Ja+eEBrcaCJU3XlWX0xsF0i1Hzj70JNb3BMSxTd/IRIzk6lZzo0vb0Mf1sByIfJ8rzaIFXBfzmKLlq9gbO/GoIy4HeOpuhr1btTKuYt3DvqzZ2gqzwts2OIrS/QRAFJebPpNVNkGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ve5bfyUuTHTlgOz18reQ/CPdb7H20UP1ojEPs1zzIHs=;
 b=XRwFvDGoTfEG7GMwh64dMFz3l1zgGkKv3ehShs9nljhuJsMw9GqOoz6v/78baf4kzcrE90MnElXbr4oGvzppEYP6EeRJYHbOyMLNf0s3n0zqKvEfBgyWJjOzIwT12bnaQlQ4NVga6nqOyh9qT6h04/zn9Bz6aBOEwFH5b1xVgV0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4375.namprd10.prod.outlook.com (2603:10b6:610:7d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 02:21:48 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 02:21:48 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Bean Huo
 <beanhuo@micron.com>, Daejun Park <daejun7.park@samsung.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Matthias Brugger
 <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        Avri Altman
 <avri.altman@sandisk.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v2] ufs: core: Only collect timestamps if the monitoring
 functionality is enabled
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250819153958.2255907-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 19 Aug 2025 08:39:50 -0700")
Organization: Oracle Corporation
Message-ID: <yq1a53uwx5d.fsf@ca-mkp.ca.oracle.com>
References: <20250819153958.2255907-1-bvanassche@acm.org>
Date: Tue, 19 Aug 2025 22:21:45 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:510:23d::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4375:EE_
X-MS-Office365-Filtering-Correlation-Id: cdb7d94a-d2cc-40c3-1de4-08dddf9050fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R4oT1Hi1th3zgvpyP2imxnEjzzcTN4AuT+Slf/BKRzEXxC/r2LLwW26AuLqF?=
 =?us-ascii?Q?lpHypyIyFnvvGExvB4DLfTSwliknn6dacJYYq5GsiIk23ZuSpmgbZ+AJkDZ3?=
 =?us-ascii?Q?oiw7W3g0WAku6hPDEcXmV8yhiiNHBGCGh73WGmWZKuQWcY+VsfBB/AksSWrr?=
 =?us-ascii?Q?WsmtyZcnnwl751qpUP+6ysHEgTl9JTn2N/zBObUnrOwuqVBjXTrMV7t6U4M9?=
 =?us-ascii?Q?fi3ldvM2D8oCo0zDOcpxqfmePu6YnB8NUq8c5/hOkR89y15vUSUyzk6CBjSs?=
 =?us-ascii?Q?HA0xZCpoCBWBDUeY7fFhL724eX8bW5T6QwGu2zbW/TuRd1alrKr7Y1E9yY95?=
 =?us-ascii?Q?b3JELOozfgOg4oTrg19S6Snig1HQtwU2zacLhnzPmX0x10gTfk6RB+nsf9at?=
 =?us-ascii?Q?ATo7GQ9WYYtHMMaUo+gjjPYKYB6wZhGd6AqeNh47xDcD7vu83Q3uue0hT95c?=
 =?us-ascii?Q?hpucE+5vYG0HL4LbZURhTJSX86Uk0McP9C+3O9LfwJsKaqKiynDkQb9xrpYV?=
 =?us-ascii?Q?j2DmjlscvL/dtCipK+FXWarAL5leLeNUx/bYxOliIOKptQ5/MHHuUxlcifuW?=
 =?us-ascii?Q?jxMzcApgDqT5G5rDlvPulrfY/VmJ+c7stRp/Yg7f+BzcrvdI865db8mUNfDC?=
 =?us-ascii?Q?TkoDdJS7Dgq6LptOQvsUxdcZgLlGQ5NSKe1BbF9YW4bXeR/cZdK8eXrt0Ycz?=
 =?us-ascii?Q?Ji9nU2MiD38kgd5GGMR/TWFM6Vicnnb1NefBNpEheXaArKwRZWrflKTxagWm?=
 =?us-ascii?Q?2d46NJQWwStSue9taGh9KDmvLS8gYNiS59lCq28ujR5MDfIMLS5U86405LTB?=
 =?us-ascii?Q?uqU3tkL1C1vx4YAYzUrsCEt2yra1aSjoJvOg57eM9KfEfL/8+QQjUi+E2yri?=
 =?us-ascii?Q?aoERkYSNbpMnVGRagCZ3nlIEn3S5VMiBjmbbiamaqomG/Spf7t75Tt377ExC?=
 =?us-ascii?Q?cmQXvRz5NS28+q18Ltw4JxHa2+nRczmxpiZ/0MtBMMD/5uTv/hPDIZs0WUtK?=
 =?us-ascii?Q?Q48UQ7cov2dbVx5AOMaBMm/mcSgvgsDlOBCCtnWeTgOGBNkrHn+DZC1+U5mI?=
 =?us-ascii?Q?kOAnQvCXoEqXD1epBWPeuffwZr8uDJFl3ONAl35eqB6Z/lVmxN9NY0IMtgFT?=
 =?us-ascii?Q?l49OgSeAzY2xH/UA8j+h4KEelnuTYMtiGsmcz0JEvWbPo9sixJElZHGwRazz?=
 =?us-ascii?Q?CS2CScQQ+4lM3+s2HJ7jx0pTs/YmbcJKyTevTpHgsAENSUVAlHUzl/tnZAAD?=
 =?us-ascii?Q?CN2LerX90N0fdSTErvcjPvv7trpbxaW7ZJgLWIpkeJgVWpAGQQpukN9ctn/b?=
 =?us-ascii?Q?l/ScL6Jir1wH99e6yVocYzmrbcJx1h5jE9EiSLsxt7hmuJaZ936hZjodCY1/?=
 =?us-ascii?Q?JIgU50Io4O2+Po4ye4/dWAUapwUpL+yxbjwLa/iH7xZOY09MLw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2pDdMZrobHGgvo28knPNjlmSO0Cg8lOVWyAHg0rk83qH1PWOO14KDtpVj+IX?=
 =?us-ascii?Q?0jbYPOvO8wvdrO2YvH9pc2wY1QAES0a44g9KMbHFRtSPwMqdYwIRZxSEhksq?=
 =?us-ascii?Q?sqqBJDygUYTCvJ5MwSzR209n7yTrIZgDFVYt0Wqw6Dc8Lrfd+Mui1AjysO/s?=
 =?us-ascii?Q?j4n65Za/GlvRF+d8WuioR8cR0irbe9MUN4/4cC4C2DQblZBvuNr86T6kfY//?=
 =?us-ascii?Q?r24f4OvYhyJvamWMtn14hnGJlxp8o8gyGjCwAfFodkahCCYD0AKlHH51+qGR?=
 =?us-ascii?Q?oMYgTH1g3Wx7JF29d3OWEVabjbp568LkZ+y9+n5TYYwBrwgG0Xn/aVGncI2M?=
 =?us-ascii?Q?DUBIq3VDD5GkCZFlyhT9n6FyoOh0eXarNx4QqgAEi04aCzLM6PPP/vqGstt7?=
 =?us-ascii?Q?cVIcBqHaeGbZM6px7loEjFyH+4Tvc5fT3QGmldMLXR1c2Q4gUnevp2iXN03o?=
 =?us-ascii?Q?3z+PmOM/i0J6MqLGFEsQkIMW9COB44+fNP7F/VBrwTt2g5rNCy8RhcPo0W3k?=
 =?us-ascii?Q?12TX4tIy0AoZ9XppH9jVW77mb88Gq5Bz6Wb5y6xhI2aFrHgZ+xhuBCvDPVN5?=
 =?us-ascii?Q?dssUO4Y/5UcJzOpBKjqVBSUC0Lmzj74Hjoo0rY8hfFifizg4EshSiem93LKL?=
 =?us-ascii?Q?oc9Gf52QS99d68Cpss5RSI335CCNeGd9ubt/QW9HAawvASKwlYpXppxQaDdd?=
 =?us-ascii?Q?jCsxUwJmSmTJ8ZchTa0WO02/lJI0g5KAIEmPley7fPHxuCnJk5t2V6+Ks/rK?=
 =?us-ascii?Q?EJKFwd3hecQT0Rae41k8VE5RYbguQHT8iSgcfD9QLjEgF8+y9pvcEZMzIIXC?=
 =?us-ascii?Q?o2TGDlYQoVRP7HWfQ4lrNsDIn6PVhXNxpydzmhUhD4T2ypz9YRJLlJ4z8Vi3?=
 =?us-ascii?Q?t6PEMnRLHiM/n5prhv5Rn8tL2AWde1wmDYc9YgPI+8QbsqxFy4LNzcJ5B4Mn?=
 =?us-ascii?Q?Mhh44c+4dYYONpZmYRhJVEj4q/d/R3XOXydjYzMiMNw2okedLcqYc8Jsmwmn?=
 =?us-ascii?Q?Duecjg2c1xfDWbv3Bbrj3ETQGKdYexJJIUfyPETCP6qxg9yrcamTxwP2Ba6Q?=
 =?us-ascii?Q?E92en4Q41sNWSOYIYOd9IgW3VyKIsQblfNJOAEOetHM0uhrD0q+bz5wm1lDY?=
 =?us-ascii?Q?iR8uIjsDUBLQ8cu11j6doDPdqP3/jklzytJjXtEKBJEW681D/P9vT61CqWvA?=
 =?us-ascii?Q?cfxzj1tkGfClifZQK5ZSYJgY9UTPFpkFkRv/ancTS+s0QusfRPzceQAh2n8V?=
 =?us-ascii?Q?EZVah4a1pkzVYfUimPxm6SJfaagSb0eCTrWPfhCZmBRZcmqft5YKdbgW0Rix?=
 =?us-ascii?Q?YYdaDHXYigWIhPa8fUi8+/RVjYfUuzMIE99A4pNlOVuq3wXfj3GH9fslApCu?=
 =?us-ascii?Q?8f5Z8CBo6WCUVeqo6SZv+SCbZ38zd0JHrUtZBF0wwrr3K3EnWhGpQWPEigFG?=
 =?us-ascii?Q?phAyM30V0xfGshvJMKy4FJzeCEUgep6X8H4PVQcZnvFXhnllqU40oIXwhnQH?=
 =?us-ascii?Q?7dQgP57QeBseRWAmHxYPIdo9gp7jnwOlsWEsfVp6fUx4XwCjtLq2nqEVXmu6?=
 =?us-ascii?Q?oncIGvjSAHJrCObn0JceEQy/TOFzWO/64uF5E7dKZsiXuJL1YB3c31UBs1Gp?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S0+s7k/RIqClUnnWtIC7U4bv3nNHOiI/FEpNsCErImZok2uKWbTbbJiQvD85C+9Q4pkHpAYkImbOTuc+vQPlpYGyH3AHE4l9V0WPxTX2FnuLPrXeE/sE7ymLWRKhjUJcqjXqlKRmij8aPif6YGUnUZsY0kgTO9yOk5Y7YszVEwV7typj08KUtJCX1UEc1bxT/v8VeEyEvbk1LZulEGCNMOrRlEe3OjkllAH64jjxocuj/tio/2/6N4hRJkk3ohfQMDCLC0Y4D/ZlwREirs8kSHi4m+yPhIVtpJxA/n8bIyPur3ox0LJfZzWd2wmdXP7HC7O4GRX/Mnji9D3bs54zply876WaNKKwCpx5qGLcGdgMn2TW3fOxr4DPPK6LvsJq329qHRLXpfXmF2Iamos9Zb48DBtmnndSDOqmO/Lf9FvMFY8jMUKpCQP7L1xO992W6LoAOZv1KNrP5aTO8xQxoNnN7cyYFad/NjFqTw3kj4bQ86MoYpC+/vmeG/WFajV682uXaRekGRNfz5LEpDY3hGM/uARG9TTK8QUXn/iLy1Gu21BeP9Iz671XlV5giPUKH4fpuP1/XRE4yrtMVxUwe714j3vDpA3oohZ20O7lmI4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb7d94a-d2cc-40c3-1de4-08dddf9050fc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 02:21:48.5398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r6+n9y/ja/qc/ut26GLr9N1XAdMhKhBRCDc7xl38PNp8oaPaxEhPEi8kx2CBf7m0+AyLz1klNihUB4BGS1j3PBcFPelcBG3MvELSwlQ1m98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508200017
X-Proofpoint-GUID: LjrGHoeqQk25djkQGCpKJ7muwlMgCJ7B
X-Authority-Analysis: v=2.4 cv=S6eAAIsP c=1 sm=1 tr=0 ts=68a53140 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: LjrGHoeqQk25djkQGCpKJ7muwlMgCJ7B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX2p8fbcKLAMcm
 CIs3QrvhRTGq69O87Lbz6AzMIay1ioaeAgwFVTFFw2e/mQVn81WdY09g38lVObafr3i0dGaDUL1
 PaHrflUeyUtgmFFj9ApwFByD5EV+RHkz2dfigv3Gvli0O0dypJrHH4T0qAuFw+Q0ehrir6ALDCQ
 B9DBNnlhlZDTnEE8KD2CHFoSQOPJoNBINGywSUUvfLK0UcXgIL1v6wMnf7zeYco5BnL2NrgF5Oy
 DhNBsHaLUnWcQBS3zaueVGD4l6ALnmTRGgH2x4eo8WTWxo3tt7Lw7qDTUKoKtl26+3iLQYPW0Fq
 ZHLg/HBCiRciMs1v6cypWN7x6Ju2Wp/P+9jCYgGXmBdUDUZd1wJoM1zJEEKA260UMFf0kgwRbVm
 vYJbGdNPfvi5VrcGOCS5sRCBrws6Rq2rMOEwiKUfXObmIru22Oc=


Bart,

> Every ktime_get() call in the hot path has a measurable impact on
> IOPS. Hence, only collect timestamps if the monitoring functionality
> is enabled.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
