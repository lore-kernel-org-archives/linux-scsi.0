Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2041C13D246;
	Wed,  4 Dec 2024 19:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733342243; cv=fail; b=Vtjs1S8Ai/jEw9g095y0hk9ovm7HUkZTvNAMw11impx4lwmfPdkpuJkpsbirB0T4bHevJDsVXDpQamRHqfrtyDuHYYW9ZF/W67K3Zns29hTCFSD09mb22GNIjCY+oKdCdhS1k/VGUZFTYdCFl1HxuRXL+BaQEyOOb26J0zPrP9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733342243; c=relaxed/simple;
	bh=PgPLZza9uKCA2tZaLgi2W7ljYi9UGf3c62Ww9fTQMow=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=twE0bEPjgMNTxjt6gj0pCwY0woR4gstXIfmbs488cFK1R2LziCEhhuctHj+ofYO/2f3LWxvm43y8cc7p+WjnQ0vzdVsq/nSSdECGkGTqCDiip0ALTGKIZVbq564lq+iC4Sd1k0shj+QUUcrPHJWKtJAK5QJSN6NXJhEkFVaUtn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iP7hmteX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mjGdk0F8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iP7hmteX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mjGdk0F8"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4ItrQ7017713;
	Wed, 4 Dec 2024 19:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=7LZLBePmOGYY3hYTUX
	Kn5Xu4p9u09CeeWaqVeIK+9PU=; b=iP7hmteXXoV/PvX4TDOZPuJ0HuA+WvzRRD
	lDuHJZCl+cvmgcqRFR+JLw4CKUeLFtiBghItK/wVO4kH89ju2j2ynAO7Es5+z9VQ
	QuDW4C+gfjgfT9hL7zX2M/NwH3gATGPmnQo7T5aModprNL/DZYSogv7jj4I3llVH
	v7Kh8XYgPQb2d9xS47Sv3rq5dVsBAhzFhZiYDvLkkjMWteNgkefUuXn7G5S2QI0L
	rFdS4ihh/yTN6phRSflwJduCsTTIh5cQWHy9MQ1qjSCrd0HvWE9zzpyHFJb8+6Vl
	WBVHdohOrjWZKtkyi1cxOU1jea4ggUy+7En+9yKtfMG0dBhBtqmw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437s4c99bt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 19:56:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4JYF4n020371;
	Wed, 4 Dec 2024 19:56:26 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s59xy8x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 19:56:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pT9gFyxxLZt3HTthg47XBWv4yHipbB+V5Dk63M5q5euMdaKAaCXFAgX+o6YyAZkCyJ4VuY0mqfYNzByfWNXzO1JwPNYswwLeA5SY8Yu3yi0Bajt1uggyC+njtVsfiz6YEdbtE4QuRzNi/PBdQtKlCm+k8QjB0cQTSNzCWbVkv2Qra3QmDNKrdpEdSv1kCjQbWmzt+3JKQB2JWC22588WucjkZuTENeC1Wc4S6uN5+hWy3zvi3iFEBawgOXkFgWwGLBqmp/n+JZc5vtONpY4sfzopoOLVqi+MpSKGpiGl5npD0OrX0Bu0AWD+MxpZd+YdRbQMfRBoDsQzipL327BH6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7LZLBePmOGYY3hYTUXKn5Xu4p9u09CeeWaqVeIK+9PU=;
 b=qicVd8vnN5EUcWHEjLe8iaTKT41Lt3J8AHNAxjY46kTxEA/E0jQwi75rM11/eypAUHHwgPp6IgvXoWSwQfAdgfbX1f0CxzZG57Nl2qPxLJdWEGpPF82mnXp6KKfotcr6q/7PIJ+ZYUBlfqKx9iGoIm4MM8oqCrvo0C3RDvSyE9CngH3WBxIpjPk4M/qSKRFtbd7lTAqY3MwO7zYhVm8g8Soptu7mR0eRmVB/TKHBRvepdgJLDpqwDESt7To8gUbGIQLU633q1P5QeC7dFg28ey8/yC+M11pZ+y4YRvbV/aITeAmxgtxsLjOdOEQejbPJckZDe/Jmj90FliA3EpgynA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LZLBePmOGYY3hYTUXKn5Xu4p9u09CeeWaqVeIK+9PU=;
 b=mjGdk0F87bG9TMD9C01S7QgQT5rZBzRZ9FsLAwrCwhg8nuYxXWpP90ZZq4GVR2Zghf4cCztUXjN1LCvrGkNI4kvaJ1ydhDfoiSLdPPYVvs5FCYdDARYUZhKE5oYGuJvNd/IiIJau7834ZHaYH2rjITebwqu/xvvncNC7sHVJGHI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH4PR10MB8193.namprd10.prod.outlook.com (2603:10b6:610:23c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Wed, 4 Dec
 2024 19:56:19 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 19:56:19 +0000
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin
 <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naveen N Rao <naveen@kernel.org>,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Brian Norris
 <briannorris@chromium.org>,
        Julius Werner <jwerner@chromium.org>,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, chrome-platform@lists.linux.dev,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/5] scsi: arcmsr: Use BIN_ATTR_ADMIN_WO() for
 bin_attribute definitions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241202-sysfs-const-bin_attr-admin_wo-v1-5-f489116210bf@weissschuh.net>
	("Thomas =?utf-8?Q?Wei=C3=9Fschuh=22's?= message of "Mon, 02 Dec 2024
 20:00:40 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ser3p6i9.fsf@ca-mkp.ca.oracle.com>
References: <20241202-sysfs-const-bin_attr-admin_wo-v1-0-f489116210bf@weissschuh.net>
	<20241202-sysfs-const-bin_attr-admin_wo-v1-5-f489116210bf@weissschuh.net>
Date: Wed, 04 Dec 2024 14:56:18 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0030.prod.exchangelabs.com (2603:10b6:208:10c::43)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH4PR10MB8193:EE_
X-MS-Office365-Filtering-Correlation-Id: d834a61d-7118-4752-bebd-08dd149db875
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5eMD3wrimCeQXjLmTzOWwpPF8B6C+9pI8PHLdsBq2iv1AwjUdFyRDtOiQPYa?=
 =?us-ascii?Q?7w5ft0L5STnb9p2XILwM5+HhWTM615KlyN0qyj69AN0rezwBPdqrngzD5Zv4?=
 =?us-ascii?Q?9ZtbMDIIKP19mIPJvFeW9WYQjsNCfB5IwKVQWTNhvyw5CLxXsX+yu/8HqNZR?=
 =?us-ascii?Q?joYTMs++Dy+p77m3x0U30KlVB8RpG0osRFYOM0ySwew0YF8kzp3aUjTpIJZi?=
 =?us-ascii?Q?fxj/2CEkk69eE1+KnT9/a+krspxKS8kqYSJpAypHQEU3zirHxbcJ3PkTCtvf?=
 =?us-ascii?Q?UzDmWWcpAMuOL9+wK8f+ZsXxOXV7a60PnQiYRInImr2wBnPBV8rXyLj7iki3?=
 =?us-ascii?Q?YOmzVQYLyfiyzeiWkZi7ye+rUyCU/Hx1DeHe8qGjPLPPhBovdfphZzr3jLyF?=
 =?us-ascii?Q?LcS2RTTCQFsbxSG5AekXGNjrp4/Z0Yeu0axJz4LunGZjgDLWOL8e7XxIMmRL?=
 =?us-ascii?Q?N9exEyVKt1vqR4HxbVvy9hm7B4s31IOX2s8PanIQ4nuKuJ/PkxjfcfTNsCWs?=
 =?us-ascii?Q?KDr5cqqQAKhqUXZYtp/FS7iYdPRhtzBZG/P1iLx2dCKjnc/04nJxKo8IOIEV?=
 =?us-ascii?Q?xXDdqJV0ZU2KVZqKDRdb6U9uys74T4NBhMP3HADM27bj3foWcXoEdYBGCXUt?=
 =?us-ascii?Q?MPMHsMO6JCNQX7oTVtITpcTH4ba3kfMdzPs4CMj8RH7ULgnxxzI4pQRXk2hT?=
 =?us-ascii?Q?F9vOsHsSXMcbmexPb9/Bnx0PnLsB6c/kb2iIT2dq+RwY9PgRSos/rx1CWDbT?=
 =?us-ascii?Q?UYk0zwgdIMcQLFLj9JmF/xNjyzAg3fgl/AyHF6aniacSKi3bdvdgkIVlp9yM?=
 =?us-ascii?Q?sdd6+kaYzTWgoq4HaqvdjZy48lvgnPD/1lLEcToDmZdaJQueUYoQXxFguWf6?=
 =?us-ascii?Q?cF2XzgMVkqOJjVeHvG58uGMcFJJFrZeagjF6crMtx0PNVTJs1PFZxDyVc4i6?=
 =?us-ascii?Q?4eII5tYBicJqYl09R7sEi8BFqKVw08NvHOXOPBoK6s6NNF9CgXQJAmekvmBM?=
 =?us-ascii?Q?hamDFyLvqCPKiJ8GWnAleIpiliqCFhpcuKT9wh/cUonWzzfhWnq2F6kjSwoW?=
 =?us-ascii?Q?CfJ1dJIvawzZkcSYMaqLvipIOxdZd5ZgScAHNN3dWPcF6PDBTXnVir2kDx1+?=
 =?us-ascii?Q?TG5uZFRiRb9+g4MNdkxJGHXGr3QPSKxlfIjxLnbcvdEvEYcZIUxa7rzcyc4i?=
 =?us-ascii?Q?ebVSKEGD3ifTb9Q9o7dQd230iuEyLCqCjGWR9WsGsNDBckQsouMj75YK52nS?=
 =?us-ascii?Q?W/f0jjCfrCVJAicZ6b7jRQpLqnQwKSilgOZR6eLPi5J+okkzIjVNXxo1+vnH?=
 =?us-ascii?Q?T1Fm+vDNWmHKJ9HIOxzedMNmddFTl3loOHr6qyH+M0Kmgw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KuS1oZrpKInn448qQfvg2xhOExmd9FzcRZoLEPhKsDV7QKvrlsGrVkWyhKMt?=
 =?us-ascii?Q?f0gmPLBW7cyd+J2U6r9xmgqT6r/lUZeYZgybypCydB+RhERGb7RaxrF00pA3?=
 =?us-ascii?Q?IQQFNXgMT3kAklECLph5ItgZxoRakdO0cXUL5YzVgSWXmSphrBpqiBQSLMI1?=
 =?us-ascii?Q?ZGzEw5v5JbvJpZCYoWUJ4K9ykFqNp0OEpPPuqFBojjkjF7iw3CRXnb1E7oB3?=
 =?us-ascii?Q?iIcBxKpu/3RN5wagjOyzYZllqoKxZo8J/2JGjwi5rLzJT1iDfWqj2TngV5nT?=
 =?us-ascii?Q?SM27SSL4S3DRJbQIeyJiGO4n5gvaladXDGtLyjksnR3GUH8yFaaQKjerE+VU?=
 =?us-ascii?Q?XKRdFtYXYfZIDYyHrWf+aWDi4wbhzRFAn+QcgQloBT1MSLKl+1F7WiyEF960?=
 =?us-ascii?Q?Z9qPbpHKfIGTCv5rlm6HyesCE9c7YJT84Evlm7MPIUCw9HxkfRntpJsAAmt4?=
 =?us-ascii?Q?U44shEOCsKjIgKW6obQZqefHla8f43cypi5zDkrPvNm4eknJY+HYJhA+hsLL?=
 =?us-ascii?Q?W2zOc/ufILcEbISwMBAd0c5E8wObE5MP2raPWrks6roNp/yAYked1KDoPrYk?=
 =?us-ascii?Q?87buvMtBUMmw9aPVAtQiM+wqv2JwISnIyz4yyzEq26cCnyLqba3XwEXdFMcE?=
 =?us-ascii?Q?AP1fxXLWOwCca/riMqoB939Jktj3ohvQYaGRggSl01znBxeFXXVjDfo95z3b?=
 =?us-ascii?Q?zSrzQk4Mh6Pn4hza9wbPG9qmouYLQGLqWdcOzOgUhjBqNCvoL/tfdQe9v0+G?=
 =?us-ascii?Q?HdXSA2R1E9Bq00sSVMyJJdgZWID7PasotsdDvcnNNi5u7UmmkG3Sm5HG1ya2?=
 =?us-ascii?Q?eA22YTKG0qUUM4cx/CPCCKHHnsjQ7wGRBfPcPLXVceXy5QPwrmivA6fNovVk?=
 =?us-ascii?Q?Of7e4P5E4Fbl2cj3dd65XYkF3JVXF+PVB2HX5/jmlX2k0W1fKi8g9Gwm9lUA?=
 =?us-ascii?Q?2WaMJZqKCvz8icINZaZ5SgoF5hzyIRf1bMwCgK4dayzXuidwnr5VI2MlWMWX?=
 =?us-ascii?Q?yuyFgUy/mLJ5ZG8+bpDAqjFDjLUgW+fQEFF/7B68x6/lNUaN6idFhLgv/5vh?=
 =?us-ascii?Q?1PS9GvQT/6BhMlX2Za6HkfvODmxK2BveJ0A4mgkkftNFB3xf9dfV8k7k20j6?=
 =?us-ascii?Q?m6zE8wA2z4eDKQ0NxWFXsoLEpabFl65SqO4CiShM7CukbYf0WAQWOKBJKPWz?=
 =?us-ascii?Q?71FAqMJZupbhkvuQDrRCNolJ/vuyvLKSfSRHBq6h9Es5HFDKqlOvR+oeaaND?=
 =?us-ascii?Q?7nKdJ77/p55LavkbB9TvmVvOahdALQ9a4H4QrNWITWT5iQb0bwbm5yMfxarR?=
 =?us-ascii?Q?/qdTg/6ycLSixc0BhUkRGzpND96r7xMtCC7GxecdjSV6zVJWY5boveabQ9lF?=
 =?us-ascii?Q?gWBaNqlCge2Yy4GRGd4Ptrxrj65Xo3Ao90jWnnk/LcyosTCnBtONu1t0egkS?=
 =?us-ascii?Q?3SxVMlZSUO91q04MCa88kfIr4fzrn14WKBA2A4ndZzXVNz9R4p0b8iwl82gi?=
 =?us-ascii?Q?KE8RvQKvy6rgaUgmSvSppjPumqAfcEpRrK/wD2zkTQD9tk2x1/m+yvIv3VZl?=
 =?us-ascii?Q?7KkQawfXPwQVhVRjnfofyt3QskLJNf08ETmGRXovm5MaQ05Nm7DZ0/M58EID?=
 =?us-ascii?Q?Hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kiX8GDvvEeXmvTZ+wUCgKv1RjfbT+rjpjRO59gdlBqDzP3xZkhqI+RmJd1QR51rv5XvUBzaKm3xLvzJ1IG/Rk22g2wd3ZUHF/HGkZjKS5vpNJY+YvUCJrggJVKFBKkcVYdAbTio0AJMlMM5DXT7yHl1d9ioceb/NcbNkSebNwRVL6bdwNNa5dJL2b1aSxxSB/oXw1LXet5bF14sGTtcPBObFzX7GlzF7Y9DK66g2wr3Scvzvq+cVSiamcKCKW93c5IcQsvSpv7kCCXYauQpF7vR/RcyYyIVT5huH+a1Zeu6i0mUNhyOjWOClPWnhJQSTrO3TuUpRBC7OewQs9dgWFCATnb7Fs6CpiDJzfiBtzNLtJxwntx4dXA9EcwyJOLKLOKAfvSJ7PSa32BdqR2fU2KedJW80rxATy71MJ8iu/aufVqEqW87fv9LGr8BCopZWiuykqW7Zq5nw1/+QsF+JWhN2KWNhXAE5XoWYEOT4W9WVc7bEQUIRyLvhu/OnQ1Ni8+YORv6v4qUuZ81kdgHOXghjsJuNHLfDkAb9Lynv8nrpeqQHKZ9nFoxkXhvCV/5544hmXTYRBxQQxulp7L/DaVFTNbRW4KPZU1HZ0ND861A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d834a61d-7118-4752-bebd-08dd149db875
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 19:56:19.5153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQgSzQjGOaOKA9gsxooc5GnYH2zEr/xgvdHmAwtxId3LzLOG4JcU6hMeSsyUO8mI5xerke/H56sOGf1X7bmai4tkoc9wdDOBHTROhOLpbAE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8193
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-04_16,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412040152
X-Proofpoint-ORIG-GUID: cN86dme02wRD8qIjCe5Zs3SlBj6FjpQC
X-Proofpoint-GUID: cN86dme02wRD8qIjCe5Zs3SlBj6FjpQC


Thomas,

> Using the macro saves some lines of code and prepares the attributes for
> the general constifications of struct bin_attributes.
>
> While at it also constify the callback parameters.

Looks OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
