Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BEE248878
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 03:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763609781; cv=fail; b=E1dCIVixokTI8aLAwmvmKH1C2bClLaEnNzgtZOzeT1cdFrOslNJ67/jcRvKyd2ETdA8Kx6e3vLhVToUcGw59G1L8tMAqreOpVbpgmZdhQFF8a5qfaAuKSnQeJxwR3b5fzcoVhECmINQBPt0OoMHX7RHC76F31H3+fxWs5c7PD4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763609781; c=relaxed/simple;
	bh=BWC74yBPrfXCuydLmrVrXlKE1qf1OgTtY6JuGRpZfo0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=MY3yX8UyMJtVzV2JnEUpy/tXLdO/z1PH1wh8FfVEBr3HT2jDlURZRhoQjr9napwJvWjylligjefqd5KgtznCvBi98t36Lx1GcUYdHe0PJSG5JIf+Rbv5wSGAX0InsFY4Xdd8iiBu1M8e2E1LwgMm6dkAK74UagOwKsmqZO2/UDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L3rGTWLB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Owbkyobc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L3rGTWLB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Owbkyobc"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1Ovfv009548;
	Thu, 20 Nov 2025 03:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TWOQdoK+BJxhS/xJdM
	yuYv085Y5Bvlcl+94VmScs90c=; b=L3rGTWLBs1tA4ou+I2RNWXfFFuPgXXR2FY
	5s/rbvaA8c4CNOaLepdxz8ZRspAnFHg7BC2gKj2qnoWULZrx0Xa0ugYu+8h0UhV/
	dainYb09UsqMNzrgDWLuGs+mGfgsFJT/ZbxMckWOuw7ixpDAk/HtQape/1o8e0B6
	IUpY1RvNCJyasMVzs5ATFJamZ7jHrPraR5oEHuOyPL9/rdnXcEDKcfy8Orm4zYst
	HIh/Zmluw1FUQOlxE0IGAF5miswnoHo9TsDBIFUyjhY8ECiZnG1t+C1XJXZ00XTx
	QqHJAj50xXHcldaI73JMurQm3WPjzPBKY7XTGpsqJQs3yXBgm32A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbgh1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 03:36:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK24pAC007885;
	Thu, 20 Nov 2025 03:36:11 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013040.outbound.protection.outlook.com [40.107.201.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybg3cw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 03:36:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UxTMnFx1dqCS9y2ZMBHJiKO3VWZ/LCv6Ez4YCHega7rRrHZ9t4lXxjT6ecw2RHJLO0M3wb3qOnkhGJHZBNgnqYn+ngeeYqxolJfp33aCoWIeNVZioICy4mXy2dyEGj6lSk2kqNQYSDOzuYlUZIxlyKQLAgn/JaHZhCWvCllB26EP17dqd6Ps9PSZTKKKKQ+egQ8/Ov/OBqVlUmqtTS0cK/8BDrAs+WPy9PZ4Ik3UlJcVCDjKzyQb6fAv9NPbHTkaE8ZtqDwnoEAXOXw+wEGDl1dfbYm0TFVMAzz0X2OKizlPSRf1LvmARoYPYhkSnyJfIOYjWSv7BDyZow8xF1iUww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWOQdoK+BJxhS/xJdMyuYv085Y5Bvlcl+94VmScs90c=;
 b=NG1zqrqORMneBdBW+fK/wk0e9KE+YGjj7BQARycgKhfotWvTvJ/XrxlCEtwvHP21HJEsHlQ/qRIewQKefN3GUHywI7ZhSi/JVunC5xq3tumOgMYiQveTQDz6619GBQ8XrC3rSlgyTnpR+XtT4pFMYuOzaHyfKvgChf92yOZzUweyQhgN2++h8N/JF5KCK6PpKSK4OYKPrx0nQrRjpBrX27GCMTDTm62+JlhqUmkbD2DpycTo2Ular89AhEpTVuIiRHQTobQ41hsU3RRwQO28fFO3gS5iD+EkAoVA8TKXBBOwOSV0zaeJfCPUkL5V+emeM7AnE+xfIYoBszIe0SNSYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWOQdoK+BJxhS/xJdMyuYv085Y5Bvlcl+94VmScs90c=;
 b=Owbkyobcmgz1iqWD6cDhQ2uaO4fXUee7WQjptVHpJjHYrJ9wOpEhykKjaC+u2Wyee/6sVg2iW0ufv4HFgPugUnOt3siR8lmnWBeALrkIAPOQTCFjx8ICJ75zAs89Kgj6VislFe48x9aIugNqlTUXa+w5zUADX/GgO1mPHZ+IdLs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7322.namprd10.prod.outlook.com (2603:10b6:8:e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 03:36:06 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 03:36:06 +0000
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH] scsi: ufs: rockchip: Fix compile error without
 CONFIG_GPIOLIB
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <1763011091-243727-1-git-send-email-shawn.lin@rock-chips.com>
	(Shawn Lin's message of "Thu, 13 Nov 2025 13:18:11 +0800")
Organization: Oracle Corporation
Message-ID: <yq134699y03.fsf@ca-mkp.ca.oracle.com>
References: <1763011091-243727-1-git-send-email-shawn.lin@rock-chips.com>
Date: Wed, 19 Nov 2025 22:36:03 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0159.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7322:EE_
X-MS-Office365-Filtering-Correlation-Id: 913f39a8-1ecb-4469-37f4-08de27e5efe2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EZNc6M3cbJtaI/gi+drKczxCOFWdsQ/srfUpkizM2OgzQBNYWiDSl1+oXpB8?=
 =?us-ascii?Q?r7zUZFdeVLOIrMwQgOpxPyb8lbEaM27zu4tJNxUhLqBNL+zzXM4lGuNZCdIw?=
 =?us-ascii?Q?koFu0YilvKc7f9BSky9esEsm8zRMAkDP75zehlmjQ5Qh6z+Pk/8kdhkStztz?=
 =?us-ascii?Q?dK5/ozXdTduB1FBS0eIcLuxuHpHOxFKgFK4I7unLZmLB2h0xgmD3/dYtI3Vu?=
 =?us-ascii?Q?AMr4x0cOMsYbm/yIh8wWMcxnG24PaH7LsKt/JQ3uWzI8QLR/t/FlWGslhoEu?=
 =?us-ascii?Q?kg4hppz7pAjEHImzy1dpvXkUpAZMDun0hLHeuLqAgfWIFcuzKtU9ACZXPjUf?=
 =?us-ascii?Q?0NEqtN54Awrx4pTLbIVOKz3G5hKCou/qtrxuNrB3ZbGN3Ai/4Yml4jtLStoI?=
 =?us-ascii?Q?hLhMX3iRYHd3Ekqy1dlkF7G64EwD6JXnZhBohRanKBUJpaDno6uvhCixFmms?=
 =?us-ascii?Q?P1EyNdXQb9ajC34SMjY+s5XxPHKMEWCUcby2Q88OvjnuYmdqFdH6Mk5iLBNN?=
 =?us-ascii?Q?eX7wQ6jXJ2VTcW/MxV0K0C/dNkACqUhoQPQPaWhJJtdOhzl0xIfeqp/tfbIQ?=
 =?us-ascii?Q?GauqCU5Ao5Ehl/Ve+2btVzE63OupCEPZRlR3W8tS0QMOrdcvfldB/NMQKvwY?=
 =?us-ascii?Q?7E/AczUurBS+mwnmpVcWzCRxghk5NFMTt/ugGMfHBqWIsNGWNPDXf7g1RsQd?=
 =?us-ascii?Q?KkkmfU+fDAU5c1TeB8Rnys0Q3K8Eykbilo4wTIz8PlHYhgbeY4ZsHQgWN6TW?=
 =?us-ascii?Q?KV+5ZzwIaGdc73KYy9hgsp1PaMa6xyKcyGo+wyfGo0BAPiDcPmOInRj0RDac?=
 =?us-ascii?Q?18xIZDvammK8G1szIpNUlFG7IxCjV9Godh89xR6yz9S47izEsLFOpQfCYEp0?=
 =?us-ascii?Q?AAjsJ+4AP4v+1d5XJ/UyQSJPwNTaCHuQmJqR3mVhKj6w42dtGL8dQyg7zFTN?=
 =?us-ascii?Q?6fs4JuOBCMfBV6iE1iXqq/YddG4Ur5hHXKY3KfV9M00S+j7S+XbTU5OA0Dpd?=
 =?us-ascii?Q?vVwmYBFCPSdd52gE1gqb1yet3Rud34Et93e18cgFA8niwwnnvaetHpgyuWCd?=
 =?us-ascii?Q?xVPLWG6bp3WWDcicSQkAv6sBho7nuol8bfD9iikEsxn7UB9ZUR8MJf5oG6yR?=
 =?us-ascii?Q?ImqGnAFBRrt0hPyegntmmCytzJVbFEzrnhaJjLHmCZ1i8qhwOtnOp4ZdBeY1?=
 =?us-ascii?Q?228fGu96ZvjVNLtVzWSgYknQ4y12ucJTz7E4lo8vXte/r1hj+Z+FWC+HHeWn?=
 =?us-ascii?Q?IUUJPu4lpB9Q8RAbbekaJc13097gGLpJF/0RP0C0ltxKQJVLmWayl6qDT/Wc?=
 =?us-ascii?Q?g0ffEZ1PFtZXNsxWaggCXju9SScn80+VnZnHTa5T9s5Xzafiq1HWGbWXIGDN?=
 =?us-ascii?Q?UegzCf7d2op1/fR8zVNobjwXIaLQWyMVoT7h/Ow6O56ZPNI7CXRmSGYkJ6Uq?=
 =?us-ascii?Q?yoi4kQRWUXoI5ghs00HeAfoQMNK3Z/fe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?39QHpx5PFm6Uvz7oHbFLj+sCXpZKWQO8kzXN6FKmJIUkJDhWeUXL9FMNGAzE?=
 =?us-ascii?Q?8zPHR2REiKbiHHqeYbcAYYSXV7IIcxO81LaWlKeUH2K18PTNLt8UZJ3v6hwH?=
 =?us-ascii?Q?7xI1sj4mOmVW3i08JfI8z20D6Tsu+G9PArf3TgMQuvoVDqbAkEMwEeGRBNMr?=
 =?us-ascii?Q?LmFU587Z2fNP44qRXwnd1LXWHGVBLYHBQenBqGEkLC135KV1Qhkp6fy/bax5?=
 =?us-ascii?Q?ibbuMiTxK0a04lr3x2cgHWLHM6/Ef8ev/2JQOZcjdfQeoyleXwLEgl10mPDm?=
 =?us-ascii?Q?3ZYRRlPMIKeRUY38WPKfShnzVD3z5bXTBXw+9PPHSWEbyo71t6jEUVvvchv1?=
 =?us-ascii?Q?CiMLf0spQTLIWZx1CsYH9z007+wrcI1pwrcqbvWenkqtpfL70qqvx2b2t7Wu?=
 =?us-ascii?Q?93gf6nnOiIU/g3GfSCme/SilXtP+91ETY9CK//mkj/Ugg9xOc6RheHf0EB2C?=
 =?us-ascii?Q?nVZUTsqVttKwxhvCfXuxD0iQTNiJA1LVM6o9+j3nM6nRM+m17IY886/u3sL0?=
 =?us-ascii?Q?GWZDmsWG0m0r23E+tHlhzOpMw6yMuNeXxb9FvCmjt728LLYpKOnV3uBnGQ5W?=
 =?us-ascii?Q?sR/i5qD73wwfBVLLoeg1nX5m9sHi7U0gNjTuMnf7/Zj+PFjQICC/8Tvxw5Pb?=
 =?us-ascii?Q?YvXkagAYAgGXWWBXHMZE1JlGOyi73o651tNI8fpTL9XZ+cWcT/GL4NCnc+OQ?=
 =?us-ascii?Q?TUsJesD9JAuIzBLlb7RtkDgjpy+tHXbuLcd6ZqSPXdjEXcwrDrc8GDbEZ9rX?=
 =?us-ascii?Q?56HA7mrFPKw6HMClUgDGxrAJCtvPicUSuPA+gqKUO5jN9A/N0/MVXJPRAL+5?=
 =?us-ascii?Q?/9A8TvMlR97WbStBDa3EIzXCgYWkzdrIdS4g1cn+NKKmONCItYyMMhBzUraQ?=
 =?us-ascii?Q?CVPMRa1Cyei1jFx8rfJeZyA5xvzJDKciXvVklpx6tKl957tH1xHw5j3h+IQ9?=
 =?us-ascii?Q?z9RYEUGtILrW8UbXVz/oPtdiX3u3JUUCdMDKYnZwmUbfoWOhkUYjdCYnu+lh?=
 =?us-ascii?Q?qCIcFbhM0Slml1RaAF/Lh58Uh+KFvmby+Wkl2UjGDWJqEyNF0GfGKgKwaaN0?=
 =?us-ascii?Q?56wQOiOa7oTn8f7KgrD+q2MUBiQ64W9WoJuqYcJLcNdTyjpyN8aDI8FIESlp?=
 =?us-ascii?Q?7d1uK8eYRF3MGR8zJAIlyCGfhBg3IY2Tet6/OyHt3fMYoNZc3k5FJhMsYauj?=
 =?us-ascii?Q?f27XK87LPeARCX0AYOovFVXW/qj0gx+KeYR26NEi8QgsZqyh0TSWgWxoAQrh?=
 =?us-ascii?Q?cC/9iZ7VbOo9mKyivZjBdToJtflq8o7/z9mljczOJIu+bGOTZ+cVL7ep/tTx?=
 =?us-ascii?Q?UHrjGWIoB0lxIPpSksfcw5H0PEsV/yVt3dknz6/k9z/cV8oaW+mykeAynYm9?=
 =?us-ascii?Q?lt/8cOfUrqX19oyFfAVWLu2hS+O1Yzi+FDLjSaJVLBdXRb+VoulJj3b8iI+8?=
 =?us-ascii?Q?Dqt6VZheBTN7W2Q7aBulKU+zpO6IAus/IP3EtLdCIFShIBqieEtapu63x4IE?=
 =?us-ascii?Q?77f3yBfOMpXd88fY9EI7eiaiN0Cxl1sba8ZWwMPNzhIgCi6W8+DHGhNw0CxC?=
 =?us-ascii?Q?InMORZAez6b2Oqe4sGVhBHRNsEn0/6YNlA4r20RkJgXLp6Atw2lObKujADfU?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dm4Dz4R1yfjHf+5FHNVHDn4+E6Upfz8e+rLN+7qquYGiopNYCyB3w9EL3qOMyiqGGcyaMC+n3f/emJru4WTxZJO7YNsWVOe+IPs/Nt48r7wF2iSZfZtWtJofK5nUtBMkrtnbQ51Iw/+1KmpubpgscE4MOO+KPfuT1Bp+upiZiFvG9y4cTTNiZWJDfEtnWaFZ6iBwm2Fc5wUUc0XnD+q3NFYzd4QgF+vXV037sLffkU1VBGj/NhYEvb1GW39avo7lxLKKBkiZ73/Nyc4oF3yd0DBYKzpQhL1nJZ7Ixf2XNbJ25VkE9dlcJjlDrZWngcXYLivo51AGiecXBtSLlritCrlgmrxMMqvnGvSrD/r1oJVRog/YvaI67gWssSepgYTntz/d2co2TKPkJFmvKOndKFdGNtsy/pi8xYE/4PW9HQOP+uMGvRqOxDqq4t07M7RRDi65/zAFaTeFc4+XdVAsCDk0kJMSw0yvRiyDKNkT+fFA08NNquokpxvy75JNUs1hgb55FwfwgStKU2KoGutp5H58zAKP09H5Eex3BSYV7NcXuTc8g4DpRnOUnCZXlmhCrhKeAmooWmdQihk4GDVdtY2Bvpiuz5dyWJCALNOH7kE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 913f39a8-1ecb-4469-37f4-08de27e5efe2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 03:36:05.9793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EyLg/fU8q6xk3VJoodCBw1w84Hoj8Wew4IVxSOrsGSXilivQLjDaMJgeWyPwc3xnyjhJntiVzDo4osokZ+DjvFJCCjtWeCju6uWXhxpzt6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7322
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=706 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200016
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=691e8cac cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=f_l1T3mUF-Plsrszu-MA:9
X-Proofpoint-ORIG-GUID: lylX9oT0Bjjb1yZCpku59dGeVMHKofwr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX/TlD6QhmJC61
 QtOZHNaAl2Jd+s83Ilww2fe6q94CBwsLH6cM/RnKeoKocU9DXTecMMB1mFpzab9ZJF2gT/jmgNw
 VEH8aZGv22vxwWO40OgbnF6MWfbC771K6SCD/lihjaoM+AdxhW88H0wG8GoBQPa/AoPTEuZTWMY
 IbawTanejt9vaRlpfpoQZjaNzGEyqtCcGuOxB+W6ZMU55g1WOLA1VgvvcbtgWZIH01RutoCWRne
 XwjAC9uHSe/H+RDd2k4qxEAMxYfaE5sepkqQJd9rAo8v5QJM624MrXQCW3lWjzEnj7ayS6rxfIH
 NNB/ojmIEwgBJ5S+jFzOwpp77HGK/c1EB+fKw5J9prRbVxn9jUxcXIVQQ0b7hnIPPnwrvBFYCPd
 8hqoU3E3SMhx6LdZwcud+2G/H/Jf5g==
X-Proofpoint-GUID: lylX9oT0Bjjb1yZCpku59dGeVMHKofwr


Shawn,

> drivers/ufs/host/ufs-rockchip.c:168:19: error: implicit declaration of function
> 'devm_gpiod_get'; did you mean 'em_pd_get'? [-Werror=implicit-function-declaration]

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
