Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EC763CB
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 01:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740445760; cv=fail; b=AY8nGh61TCX25XvnQQO0T8Bk6Ipt+g7QStHTITniR2K4gj7xZ9wqQTidHYFNY6pjp1esvEmSHHok7kBgfMnlQCAfZWIYamDC6EtumjL+SnPF+wl+uiKKRMacqQ0wdA3M+OOpa+3bFqJbHiabTfRWai8dQDhPf1Fn047KNZbUu/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740445760; c=relaxed/simple;
	bh=iddYhxScehlAvhmcnFQU69qYeOa8SKrzVGmK4hV4sZU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=hHsarmFLRm2DiUiP0xuYdJtjtElCDsFBqprYLxY6/w+fd5eDu6J31jrgJpRrrsH6WNUqNrASzHre7bU0u6RK52WjLQ3SBdLDTrkuA4WHDCzq9EQIf5sheGh4ZwWHyAN/uBf6dS7JnBbrWSlZaNhnlXx6+CrXhFhc6/bCo14FvJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cVhsSzEG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rQj1zR2r; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cVhsSzEG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rQj1zR2r"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OMKf33008635;
	Tue, 25 Feb 2025 01:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=BC4+QFhhEYdxUrmrop
	ns/ndY92ho6CmWTNuxYhMil00=; b=cVhsSzEGJGmil7ilIhLqY/+n0s9NaC10eZ
	GKvdBT7HvKNtqfoqUYXYPixFOHITF9c8J6c+6xwKxwbpNM/0jFo3UJmQ0fXt2c/h
	8E4Y3GUTYKY6qVNpuySTQ9HAEbWBomk6cPm1ZJXeS7LoUrAzxxEpVA0gpAZDHJeo
	hzVegyRgaOLj8Rp2q7+MLbl/IjkzZOfJfNx3UjK/XrMXShzJa3I6lbIUtu1baxE2
	I0dR89JCIzi7ss3FqUfkcFn0aNvR6iFTMVMWXg0qIEzM81z50ZaTvz68Q+7ZcivT
	Rth5Ssz3ew1TQaIMtIaIGpoBo0TyGopWGFU4OkMQBRor1/DtlV7g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y6f9bw23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 01:09:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51P0GtMj010028;
	Tue, 25 Feb 2025 01:09:14 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44y5188d9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 01:09:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n7yJuMpFMG/DUDxdEQYq3Dg3z6zIZfwKymRfpZ1Fge48ZAzdi65OghTCn6HgJ+RkrOZzIVysqg7dlQWB5NQaygEu5UC8ojFVLk9aip6NlriqMETL5Pb1R9RQRHNvjnCge5X3AzsJ4e/U6ffKq1TQPPEmqqQTpWHBfdZUZPnspSnp0HiEnaZ+yxn0Ccym0hYuRyBTi5GitTb/j3iRDqJZwOA8Cd45P8JInlRVq4LrXSo3OJbBTKNyRyJgwXLgkEqfVmi4QKt0xrcbtNSuOjZqRMk3XikLt/cc4WteThOpUHHxupytCncTKrVvCoxemZNr8imQnY3GzMNaxsCF1xU/cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BC4+QFhhEYdxUrmropns/ndY92ho6CmWTNuxYhMil00=;
 b=I5GPoR/Lr7+xzSsny/U95LHZVSBZS0A2eHJDZNxpedHTFZw5oX4X2t8uBvMuHX+rP7dQVGLAh+nv+UWzwK5f4U1Kb2EzjifzITt6rHLkKoSe65NUGbl8tCNYOU8riJsMcGBlBK/DngwuKw8mngBbV8rFycyFCmFk8yItJ1GeAF97cavZHmamjHh6kyxTEgeM6I8FfzhHHD/DQ97uffBDKFGMunwcb/TgqJQ/t7pDbhwAzE3reiSjEsRHGC+YvfUhVF+3MsaZa14GaAq5Ek/J7tEwLqefp432AK831KDMTBm2nhoTQBl5HrdAvEsB+JyMpfIu7T3+//7I6fj7lxUe9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BC4+QFhhEYdxUrmropns/ndY92ho6CmWTNuxYhMil00=;
 b=rQj1zR2rxPbAUV1No3dapRUVSEBwyhOhMVzU9t09MHNzg0+V3ibsmSh4RjNJCrOgT5erHJjz4n3nPbvMssh3SIjNCQl37pLnQO9Hjf8qMRQ939uQsuHShHwFVu1YMqutdM9wyTd82S7C13qEDFo/3tLBi0JHP6F7blQ7mihVJuQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6449.namprd10.prod.outlook.com (2603:10b6:806:2a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Tue, 25 Feb
 2025 01:09:09 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 01:09:09 +0000
To: Yuichiro Tsuji <yuichtsu@amazon.com>
Cc: <linux-scsi@vger.kernel.org>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix typos in a comment
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250224075907.2505-1-yuichtsu@amazon.com> (Yuichiro Tsuji's
	message of "Mon, 24 Feb 2025 16:59:07 +0900")
Organization: Oracle Corporation
Message-ID: <yq14j0ide4z.fsf@ca-mkp.ca.oracle.com>
References: <20250224075907.2505-1-yuichtsu@amazon.com>
Date: Mon, 24 Feb 2025 20:09:07 -0500
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0029.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6449:EE_
X-MS-Office365-Filtering-Correlation-Id: c1eb861b-b177-4350-b60d-08dd55390214
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wG4JPgGpHBQ067ivQ9YYcCoPbFDGEvUMwuX2PM/1ikGACJAtaXvMlXg8Pkxf?=
 =?us-ascii?Q?+eR/yormzXoLZEfXQvMEmnKZeHGlus9WAMy4RFVjmzZpsgH+9/ivkMYn/JdM?=
 =?us-ascii?Q?GiiGdc1jDSnhrOhXIZ5CwsG9e7BNfY8uXb3OOQdgAQvKsj3kqI4lwy9sCMQX?=
 =?us-ascii?Q?amVMMHHiZ62h5WrRdHf1ACHMxkNEtuopPWFKvVEEMVdNy3sqGARi3HfmOXJ0?=
 =?us-ascii?Q?j9d33tDRvR2S8RVn9k11D4hVHSbW6LbIqMN+c1euPIqciCWH1oF0uur5nyfP?=
 =?us-ascii?Q?Nd8elgTMVotkG5DEsyKpEL8n4jt5YrqesptHbvPoyILOSq5OfFO3mrVr5WmU?=
 =?us-ascii?Q?nMU849/IyF7bnEqqQnshF5h/opdTu4vxOcIhAqsRVfBcbebqxGZxLjVmvKOD?=
 =?us-ascii?Q?No0vKCEvj7kK+KajjHqWxOfNmirZ5K+O/nlNnmSBvODcACk3Mw9UZOtFOdmf?=
 =?us-ascii?Q?LNmz1+9PNRYvGWQ6YZyDLCUSzDJQwQhlDQKe5EHOvBdyzEAFBFiH6QkvJ0T2?=
 =?us-ascii?Q?xAGkrCNn/ohkZD2ZkWlsyKHNtrum3H7BS9OVjO+bk0VceO6zOWcFye3jtGG7?=
 =?us-ascii?Q?gPi3VQ9huiweYLiBOGwgN17lUbZGCowj1oIpoASryauO4K5ecO0TNRRBhxu0?=
 =?us-ascii?Q?BKTfwS9Mdodso+IEN7PU6bgrjsNiUCbDfbq6QJE9dTAc7bCqfHbSkBoFxul5?=
 =?us-ascii?Q?yAB2zCq3rrcez6FWK4fV7PtzL/uM+aknEvRSqJZxrvzQhgUpyxX7DidjBxAW?=
 =?us-ascii?Q?zcorxAGwBYa7KFL98PpN9pj2/b/thAGP0aNTjUktMx9KfxwdBarslbcUGjox?=
 =?us-ascii?Q?xpL9Sb5sEaXmskyao80nMwzQyrOk+NcXJ5LnQ7ctvaUde/biERanqtga08j1?=
 =?us-ascii?Q?bxoyO3I2nRCrdvIgZOeJFonybO9oc1mRhBnK7VaOswnjchtXpmRtBlNPM4km?=
 =?us-ascii?Q?lOg39PcY+in/gl5ZKiq2y9XIcQEQe7b+Sa4whZ0Obop+O6z6XsncYJV6rOfQ?=
 =?us-ascii?Q?5wEkTehU2Y1J+Oh+slK0dmKj2NCkZ50Dfq2sEYLmzN2FSb0VXb5KAL3vhQJf?=
 =?us-ascii?Q?h+jYHFk0aebDcPoCHw84Se139AMLA0Vh+fbgb3Wyk6Fg2R24wH9Fl3tYuK+a?=
 =?us-ascii?Q?2xj633Dk9xwPJAgPDTNTQpoCYQGeUmJtl+yhdw9e0iYs4Lo+6kMHKIfhtehs?=
 =?us-ascii?Q?GXvLQmXPNv+/q2Et6GijUY//1CH11qMlU9MRv1zMSAEnlg8Nr/uaYCF3AtO1?=
 =?us-ascii?Q?t4zUMpjToBmMWn7B3cPxxtQjWOawTRn2aKjylDjFEMzdV3XxTQuX7k17EJY2?=
 =?us-ascii?Q?vrOZbNh19lZhrxAtzY2KVOgC9rnY4Kw1Z1XyYQSqj8ibrk+p54NEvxnNcT/4?=
 =?us-ascii?Q?SIkfEB+4XqueI9AG69zqsa5etPYI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t4nZb1qtLgkhHDE2EIWwRoZXZcg4yiqgW+LijYt/5Ss/3T2v6cZud37CvC2C?=
 =?us-ascii?Q?LMU9W8FaNPLiHzYC3yNlsRgwmlmQLYxp2T847zxhcBwVjJRBm120V7uRrayC?=
 =?us-ascii?Q?507xGJj68VYRpd+GlrSfJkiZnTW2+C1VDX+k0q617ILtZ8/wNbDytAhw5XNw?=
 =?us-ascii?Q?6gqs6nLYT7QkuFpeSm3S26s/h6dw3c6M7lFVkswvsB/RARXo/xkS11OfQyNi?=
 =?us-ascii?Q?1jKfFTF7p/8VtI/Eisv36xFV6OjYHLPtmvl7ypaGpShkaHkqn4QWCsmuaLba?=
 =?us-ascii?Q?hAfCSTIFzQqkvRtK6UGo2Wpk8OLfQZw9Gc3bTGcC3GHL07cMGuha5FdZEaYM?=
 =?us-ascii?Q?AMYj5YmLHV07KHFZFdnfbJ8GXix/A5VsIS3zPnat965tYP5AzVrFP+fRiPzx?=
 =?us-ascii?Q?9Klrh3nzn441lC19Nrh5raIHhHnFYC7dyyVG2hsGbLvVeKIEHTYR9WfKDPSo?=
 =?us-ascii?Q?HlxuyWYe17UbKB/4LRTZIs9RhNGo3ihE2IJcKbqcDRZESVZUZ/DWhmOQ3HQ0?=
 =?us-ascii?Q?vMc1ctIP/KDwmUC3L/olsDwcNCHymTfokqls9/KY1FE6kBzBF0qgjJaOEDH+?=
 =?us-ascii?Q?XzW3e7b2bf2/Av/cyzv7ag1k5kP6K4jlVrQBG4rVVy1Qqko1rDYwJxrCscmJ?=
 =?us-ascii?Q?j8n/VoOAII8J4eujH+d0+/p2Fd1YT9PQwCCKd07vgWa0Y9h8DalO6n7vAhyO?=
 =?us-ascii?Q?LgWtsmgMAs2i/lGPWSPoUEIX++wfhHMcgv5U3/bVy1ExhKAQTPForDgWovHM?=
 =?us-ascii?Q?/8ePctxw6E9YOtX/9QPQNsZLmPCApUMZUDW7vVUObG7Q908O6G27U2sKnQBo?=
 =?us-ascii?Q?AFSaibe3krhI8cw/KNQHZjWWxk/CvYgXzTHe/44/dH53SY/AMeKJJCybGdC2?=
 =?us-ascii?Q?eML7cIkSmjxxAbO1WskkmHjowVW7y3tU9Xlx0DJiJLNk0GAhRWOKg7nFb4La?=
 =?us-ascii?Q?qc+z3hzI/MpefWBQPHblZpSBPSfyHMXOguVQmq4zu64YRX+zKFt4gHOr9YGg?=
 =?us-ascii?Q?FLLbBOp1wi7ffKNGnU4JJpH6CYpGFAxSeVAaLTOGX+QNdpMRUGhTDt32O3TM?=
 =?us-ascii?Q?8SunpKQ2RgMXcDVOzN4pH/AznybEj+6RXK/ND6Wc3SlrEAWawIbcqscfQz/h?=
 =?us-ascii?Q?17XbFG6BF9GHNd5Sv3r6MBoqYRHECu/xYbYefyINjuSMhphiGUBeeqUAY0OG?=
 =?us-ascii?Q?UVBQfvcaup7U0rJwjXDS634C1cY+r6rHrlw5UeH7ZCXMnuNGwNYbUEK+/7nO?=
 =?us-ascii?Q?+xfxani1JYRYTqiobVAT9hsSbikek26GaaN7L1azt65PJJOt7NEDuVg+NbI8?=
 =?us-ascii?Q?B9c3SKz0tguGX/KsTuS4CPrR2jWF6PZaQXoZy4SP/Uz+6FtaRw7orVGHvOiX?=
 =?us-ascii?Q?xvFEaT1C5FKAk1wr00opcsXjnk/q8VNbSiNjcPjE+m0d+yFrW53Uj5aM4qo8?=
 =?us-ascii?Q?gbTtSOVNqdiUu3MGbliHFU2I3qxNSY08Y7Xz5FHtGoTZuvkJOAFbjHnqoQft?=
 =?us-ascii?Q?5SFdYyex9bfj/xigMdn1Xz9x27JeCAVWP4jRjeuHKTydo2ZlrFLqZ/UkawCq?=
 =?us-ascii?Q?WBG6lEX2OJ0c8HswToVLoCespsP1kSq/i0S1aoE05bjWUd8Lpr429tdWdFT1?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xTYCYf7mx51aEj/v4fHWN1XcSsngMykyaDGTZfmttdFcU7JawauiOvdTakCKM8TyMIJFU85cjhMkoBErYGm6sSLw+vzJ1z4Ig9DCrLbT/pfw2MKfFOB+5wXjIHvmGNWWOfyFXGuBR7OZ8OAXy/HhKYe+j5hKfO9WvHDJF8JMLE0/LonP+Re9Yb5nA/lrX9QqON8AqCSD1Uo4MtcX2lP+sTEs2miYqMVfSLUBOOxntC6+O5xXH8U/mSYbEtR0pxwI4Cz0ccFzdbEKQBWmFbpMkcf+oiDwaFVke+vbIk/jeA7BZIl+K2x3Y020pLZHFXIiuCcHACw8j4JwUH3V9zwQ+pCmj90L3cuqS6YanpYFnSfaOu74rva1J0jkqcjQfjy1AT1U318TvDNVeD+9DFYuXQnBm8/q9vU/uC3OQPQEB4aOq/kZOyiZGH0qMwyB1ToIAaL0qQ613itpzFEmtCtatT26A/5GA8hdKejFKsHCKVpdbzR8cLhMSf2K3u1SSRFG+6QzWELqLKAMJwqUl78tVOFtEETag7I3PwxvbkjmZ4JMMPvC2pfR479fMf7m4wO+RiTyYsHm1E6o7gu5Ic3eNUPIxYmYQb6FBK/hFcl2ne8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1eb861b-b177-4350-b60d-08dd55390214
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 01:09:09.4354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pavj0k22y4Pdq7M5ZvwjTHi4cVPNygsApRSKZeVduS6b+JnjToMCPwi96/yFUS7gpgW67nz9uSCSrreDSnSPY/fZLZl3fs3cD5H7sMvWeFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6449
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_12,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 mlxlogscore=781 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502250005
X-Proofpoint-GUID: 2dZum0k405fghUgIKqcAM8NnCwd2KTzr
X-Proofpoint-ORIG-GUID: 2dZum0k405fghUgIKqcAM8NnCwd2KTzr


Yuichiro,

> Fix typos in a comment.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
