Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2228378F52
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 02:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755568847; cv=fail; b=NMt8CDCnOU2lE9Fk9IAX5I4N9NxJ96FeovjAhVQMkFOjGEd7yid4x0l9fCC0l8eQVPZ5My2agpIA5v8PUpyA1ko0uaw0GUYHgcQ4RiO47ML7FiYMyQWsE48scI67zfmw7qgxiaiHqtaUv+/9auP6OL8M+Z214ANLNtRqpyfFj/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755568847; c=relaxed/simple;
	bh=BPSmfn2TwcalLU6SOeJipjlQGo5PXMVg51Dm+Z997LQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=SPOcDcYUR8SWTJScKy0aFGZMIIcZloE6GLR/TMua3hhgCJ1D9TaxUetqB2L28kUHC60qsO3OUtKJVPCpKtk9u222DMbgsF7aYA08y9faLzsnppbueuhhWIJOdLu1YggCrA38sKG6SGhu86Jbxjes68AorEfbzoq8NLCexJmhIUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OpNkIHqB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N564NKPo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OpNkIHqB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N564NKPo"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IJgM8W011615;
	Tue, 19 Aug 2025 02:00:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AThK6VKTXf9ogFjRqs
	/QzTGmQz40LvZMwsf3dH9bX7A=; b=OpNkIHqBLdotKjLEwJBk7TS+O51H2QHJbk
	yKaIp7IxUwV+oWNptkSwzr7JAizi5LkzbmwWzGNOVFDLUcVXjZA2hf7sJmsg1mRJ
	9hS44y99nqYhEe81zbQ1kz3ieIm0nSHE4jVcD4qPizxzsigNfOrKZfK0+hJMUH9C
	WV4s0JpHQSlo1AeL+I3aahnBE34SEsgyyxQvaG8nb8IGSfb+W3LO00/FbmEoXGH1
	Bi+x8I7nz50TjYuHyaS3Xw6m7JKJ1k7ba4Xj/sn53bofx7TODoFgl2ttoBt46zOd
	ZU46IdIdyFpzlkwo7ElLJz2hRuRbGATmi/nXad3vd+OkpS256FsQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jhkuv87c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 02:00:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57J0Ap8e016907;
	Tue, 19 Aug 2025 02:00:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jge9rnf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 02:00:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P+STEMAVD7zyt9Kfc3Qw6kVxf1ALtzpU4yXYteoKj/B7zhSp0Kpd0mpJL1o+wTsmuaUiyW+8ldtimAkoKk8PoDsrEP8gwu8AH2t+j9SIXCiqIGTozt0RosIyaEc96S2/JQeVZedd2Tk6ALNgcbz9AZK8FjlHFhDvPKLrPTdmhHm6T6fJVTWVfg50aUVauK5XBsgR1a34V+BmFAzw0xfx89bMltdvhDnRXyeqJz5lbs4ufEzkmQ3hNZ+2Ii7phDEAtXWBOvTG80xiR/bYjRYqS8iJ/D7SldP302piO6REnuhtEuKYmSHmTtLHD0Rtw5QKXvHXeNSMYWj3h672WKQ9rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AThK6VKTXf9ogFjRqs/QzTGmQz40LvZMwsf3dH9bX7A=;
 b=ODWPbd0R2GG7phDLCzdHiOpnOvwiFkCMO+Qx/QQU5qMgco7wc4PUIJI8xhWCwRfpPQ/AgEAJoZtI6lnhpF8XVdwom6Dn4ZxdqdnsvJx7xXc6MycrFJuSSqoBjfhR0Zihp2um2AZEW/gWln8EESSGVvi/zdHzcD5OGKlPpvJ++ZseN1vJG/jGmqry40P1lihoBWVsn3Ne07xH7CWhvXinYHsDdHX7bNnUCM5ALlDV9DtaceKZ05v3TWo+vDEZ6A1g0sfBDWuDPTzGqlQKGiYScp/GdwRk+n/Ju4QbSrUgiUaLxXFPQFT2AnCQGB+AqPLSSNbPJIBF9k7h9pmKN+keGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AThK6VKTXf9ogFjRqs/QzTGmQz40LvZMwsf3dH9bX7A=;
 b=N564NKPoPENFa9vpxOXgYBCu28hr5x9Ydi5m5Mlc78pU25RDaPXOSpwyMFara6f4UWH2g8s9uduNpXipvPZgcNgLXNOxKlVbkVBCEsuvnSt+dbJ/DYTEHG+GP8r8eEiZOGAAykHrSxL1uZgt6lHaPVOlra0kV1jb7CI1f4kKe8k=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA0PR10MB7159.namprd10.prod.outlook.com (2603:10b6:208:401::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 02:00:14 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Tue, 19 Aug 2025
 02:00:14 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@sandisk.com>, Bean
 Huo <beanhuo@micron.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "Bao
 D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter
 <adrian.hunter@intel.com>
Subject: Re: [PATCH] ufs: core: Improve IOPS
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250813171049.3399387-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 13 Aug 2025 10:10:41 -0700")
Organization: Oracle Corporation
Message-ID: <yq11pp8ystn.fsf@ca-mkp.ca.oracle.com>
References: <20250813171049.3399387-1-bvanassche@acm.org>
Date: Mon, 18 Aug 2025 22:00:12 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0100.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32d::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA0PR10MB7159:EE_
X-MS-Office365-Filtering-Correlation-Id: 2990bea8-23b8-422b-d94c-08dddec4236c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fGyotYhv1zOmwSSjyFVPe8WgaF+q3O9d4wtg2XK/pAGfsywcBpXKpn4WMoZy?=
 =?us-ascii?Q?OQbPt0dAKsVisczt4rO3bGOoZHEBFGLVQaqTgJAReJsLMvsUU5d4FnZ0MhNU?=
 =?us-ascii?Q?y54c0WfEvjKI691J0DAspkp5zD7YGyjUnejE+m65uW4byR9d1MyvB9OzcxUB?=
 =?us-ascii?Q?b6KND5/jFWjSbVu0CngSWyAiMox7eSfD+o6TR9qvj/KXkRCa9C+XU8F01Ddl?=
 =?us-ascii?Q?dpMgaLGPcX2eKd0HWLYCy2dUPd+zgmtspbxNDucz7WBCzjKEdTceFvRacR+3?=
 =?us-ascii?Q?tpRiMp5kZs9bM7Lwkx6rOXYnTNK3eaU37VqlpeZ8rSwRFPdoDB3qCucZg6ZH?=
 =?us-ascii?Q?qcKlYg3g+7bA4/1c7ybQOdD63b1dsM0Ws5lnHjJeD8DCG0ZpDFgL8X+BzmX9?=
 =?us-ascii?Q?BUa2Ku1p2S69nMi0XrDlv/BFyyhubFZaTKBu/tDGbygOBh+CFY7mjaVSZNc4?=
 =?us-ascii?Q?DNTzSOc9CfIlCRXgXFk1vU0ltHYDrOzYVAEMapRdraO+0FFChdBKFICdZAQr?=
 =?us-ascii?Q?FsoZhm3BxkiTSHruBljKX966mholWHHlQCeI7Cenz25Ihl/W9GH2Gnu3IUpl?=
 =?us-ascii?Q?CBasmlfs8luPjlPkpeTTkNzHWJjzsRswpyAirmgZ2TiZBOYKey9p0MhWM1Pb?=
 =?us-ascii?Q?73tXRfY41G1GD/3Iki9qm55QKkiuwAdKvHGdSz4+ZECGzAykHPsVeweVyje0?=
 =?us-ascii?Q?pfTKx/VV8bjUGYdMJ7VjujkuQNWWvJlMv11rxb6k80meO969W4cWvGObhuZf?=
 =?us-ascii?Q?Ps7aKQY7YU6TeCp8+DkB8OsL/0m2Jue4vcEW6AFa+htasBGmfFuy6Pq4T6io?=
 =?us-ascii?Q?9x/a2v5LxeErmvfMBemFsuI9/yC4l+TRJiGSwOiAkRTBVdcDseWfOPY1WMYi?=
 =?us-ascii?Q?1j+8pwMgMRD/OceuDUfEmuPLrIOHAOL4HpaKZGJZI51A71+zTnoowpu2jghK?=
 =?us-ascii?Q?hvjo97TrMZt9aGkF9Ej3ek7q2eFmmLJxKTxUumoOTfap1FMDByCzQzts3kGa?=
 =?us-ascii?Q?kE1KQxjkGD82ggsnuZyyhW8HttV8W2GYJ7IyB+3lGbQqnZcDfhoh/d4EhZZR?=
 =?us-ascii?Q?F+fVqEV23vKdaUpLiUY22wU8Y1fjgQ19lPQZUTaz0wAzoUA4kKIZAK5GdVjC?=
 =?us-ascii?Q?YzkBQxeJ4v1uvPyfKfcy/pHtm2qX6680CtrCURCIvofeKytk5AKRQ/tSQV9a?=
 =?us-ascii?Q?Cy/SiplvNSQeVmJfZ1a9clO2DzHlINRsEYrt+bCKRAGh1y0ARpCV2hrSyBOc?=
 =?us-ascii?Q?sMV/5CvT+suZ3N3mK/7isko1paP05E05jzqq2EnmdzudxoQQbf8kbi+opyMP?=
 =?us-ascii?Q?iS3y+yWaIPhlbIgTXGgpTN0/Gi3JvAVgK2LdfG8n3pP37A9IajCcDAp1jIrf?=
 =?us-ascii?Q?S5/MKspXnD0YBfT7kid5B/tghd+YJS3ROGJYQUPchfWEswbslA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YeIweGD502cIN14vPXQ2Z24pWOojmS0z/NDv7qdGfTPovlUoQw5q1iYZBSGy?=
 =?us-ascii?Q?jws5Oz1M9YjafWzRPXfUjoLrb90JkGcHb0G0BGQ8esekOlIAIhdyeEZtirJh?=
 =?us-ascii?Q?m9UOlKHbwcAkYFERyQK9HJVKKRWZWswLIbaIVvXf3hMnvL/cUTZA3AMkvKIv?=
 =?us-ascii?Q?dBjOtpR/M3SHwgTvOhr6fQ9JHbEXlb7Jptqk2mw0knr6UtLVMhiOcePtMDug?=
 =?us-ascii?Q?LgnjmThQ2YGRu+7rhFngIfaMdsK8em+qOptwaCfc0p+D8KIjzgTN3cxOgzw/?=
 =?us-ascii?Q?tPSc1W7gNLuir6N4SMWJqjeZk0Zde2fvxV+AbrTaaFjiZB+5JPWesNQImmR0?=
 =?us-ascii?Q?syGSyR43EYHiDGSf+TNHlxuZMz/y3TUHkStYmAOvA4nI1F/ZrPZjSI5wle/e?=
 =?us-ascii?Q?5BWZjlFgs3fk9P5uLx/OjWlA2JTxvD4m3BOu7KcVoRTQm/LyycLMAdfbR5Qw?=
 =?us-ascii?Q?6iu1zO0xDIx6/zJ5aBSIfnJQIJJ/QYzQskDOBd0ZtWqx0Id/TwaLrEZKr8M2?=
 =?us-ascii?Q?hEE7vxIugIlDCQCnKLPTqcoJXuX55552vYfVIAeyyMc4AzzWhz5Gk02iaHdO?=
 =?us-ascii?Q?8YB8SKjeXNJRAy1T0TJh5J/QOLDq2hsy64BVX/K8TtzhKpDej3M0pQQ0/x8p?=
 =?us-ascii?Q?Ia/ypXagavr92BvWbqBqCPyMx9qTtIvJhOrO9IAqE+eDDmtJ8n3pqCv68iD0?=
 =?us-ascii?Q?7XVFOQXMPAontM2yyY72Tt1OGDHjBXnUw/xZmrKr7JEkTpeX8zUeoFR65Y53?=
 =?us-ascii?Q?hwEoSMpsIUMVaq62b8qiYSqD7UFKoZXlBsMI/rrurzFlLhZTXrCQTi05SCHe?=
 =?us-ascii?Q?xWbsFy8ADIiZrwg0pQ3OtNl9kSa7A5VPba+xnnnmJ0LcUZEdnc0i1lJdkP4N?=
 =?us-ascii?Q?YvES/u2k6+54DFrzdTv6014z5ue7DLPcPdqhuJUhwmcp/cMpcKTrLKs/mpYB?=
 =?us-ascii?Q?zP7asCE3Klc5Ye8nLxLoUYmHBJPaVzEbBU6kZEahuTQ7aZ3TRIZUSaLdX1HX?=
 =?us-ascii?Q?M3WAjsljQxz93GpN/+K7j+xGwzaUO+7PtEWNcMgWHGJFNzHX9Zy+NCYpEam5?=
 =?us-ascii?Q?ZCh26XmkHpLkAqZZ3aOgOW3yOV6lW9yRFd+1xmToMbUHgto5/u4W8m2DzeSq?=
 =?us-ascii?Q?iBrXb0IsYKyJ4w41YvVmF+diYzYKRd0J/WVw0nfnBTXsPs/RBBjPEFAoOSwH?=
 =?us-ascii?Q?0VgjcZZlCa6MoBkFh+k3TaWVp8E4PQXIh5iPUKcFp7o0hTq429cr0SEczc0E?=
 =?us-ascii?Q?sIydtboIiLISgO8OZxH1ZLZjRnf3EUXUziH7E+OiJ+1duAZtowiBfXsfVWPI?=
 =?us-ascii?Q?SRNccGc9XQw9ieqb2vjK90BX94ggiq1LMKzatmA0fIe6LfHF9wJY78y4qhiy?=
 =?us-ascii?Q?UGAdBfh3L2GrONrZVKZOFHTHVd7SaKep05b9cgKB+hiLe/INuBQoPEDrjTrz?=
 =?us-ascii?Q?FDOP10B1af3fhK/pQNagAipDUwBcbm0efPc9JYwRd/CHB8Z6J3pTN2eTzkJG?=
 =?us-ascii?Q?JSUS1zwZ3dJLRTRrluUnrkxjI0EkwR+VuFrETp73xheg8+UtyJ9mfcX5/BaK?=
 =?us-ascii?Q?n1RnvhnIonUOgcRPXuIWAL/V+ctbqRnx0RBASAnmNBWwdTT0DuQoFb7zZeu4?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nYdZKJKwZLYAuZwtqVt1VzhWLC/JMt1CQSKYfwQPCB0plkiCn+t+A5ceRpnIap0SMYhZ4JQS1njglVJxOq9XK1q6XQ3isEZHKKFTBNQ7zGzT1gVR7Cz1StTgCVvoXui+m0V3ch2KDL8LWs2Xy8z0TxeW+8uvfTSgOuE/PohAawfF1NjY5ym0SQ3r+L8guvp1lzkO1Rl2K+oFVlJ6PxdcnCsgfgM1/mfJHCxS7SyqsjI7wZszloGMlbLUaB1onYRSiqra5zs0A8UBIus3qY8g+qLolKVwU96ATNBLPzMGRXPX+2Gst2oLug3fljdzc0fYy6LhDEy5xkMeuKpInMi4kHJ9xPwv6BL40YAoBjJcv/Mj30F7IMzsHE0Feh6sOTCmPuiFhaDX7PTdK8INjhXySklRimbxmQ2gbw9D/lfN6XNmE8wqE5onmfedZ1eVhgdE8ojeu2uNhtOYcwzV1+Flfk5vrqdHcCg5Cy04cPGxY7+WTSS6fvDjVHN3BFKJoEsXmfX4AWxXYm1VIy+iWyRnT4O1C0pQ8yjmE6VQ+Nzm6kmwUFpxG1jHHMvtlroOtM79AZVX3Eq7PZjCzthw5lZICW45oi6/9FauXpDq6Hf9iqg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2990bea8-23b8-422b-d94c-08dddec4236c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 02:00:14.7033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UVcF17orG3KmDdwmpR9+FXHVK3s/FEJFaeGqgKydoUJlb+Vv3XYl9mCNHuQP9lEbUuuv8l8o86oQUA7s7dS9MLgeTCaScWHyRYJLoqjukoM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=899 malwarescore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508190017
X-Proofpoint-GUID: B3_DP_kvFHhcKFUgQJjp0Ly-UVgP30zD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDAxNyBTYWx0ZWRfXx+72FnQVqIjI
 CdxKTAh8Yc4Cw5XZ6yVFEzcIKkGfA9zMULrWeVR4/F1UjWHJXn5sURsr2/1shoyz1MAQwGkn46m
 s+lUC1AGdi8BnNiNjDme3lRASInfSQf6U2OFwpBenZnNj7JvI0gdV+QI6Vs15TsMcZ/Mjdyc7hl
 hmhrjNnWynHm4OQXntWemVWUM/gmu1y7GbbI4klWtqg+DQn1avDyCIt3h62sIhOpijREYHt77tU
 Py+M8tMCf6WumrGwCgnC4B8oPjfL2LRg1jEOoe3LaavUB91tN7/LxPzwtcmc/AiSzw7qpx4Jw3d
 dCyiMCupAV70oHiLNZPIfpfsb2pX6xvaBWcGzNYbsCyrZ05hDVdP9kPBpw9u/cTa74ZDeExjo/s
 MajTwIhPcKWejTkc+9WPvvIFcwdY4Akr39nsGhn9zV33n8jKU3qvx+3ZSTMPMWzHyfYwbCab
X-Proofpoint-ORIG-GUID: B3_DP_kvFHhcKFUgQJjp0Ly-UVgP30zD
X-Authority-Analysis: v=2.4 cv=HKzDFptv c=1 sm=1 tr=0 ts=68a3dab3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9


Bart,

> Measurements have shown that IOPS improve by 2% - 3% on my UFS 4 test
> setup every time a ktime_get() call is removed from the UFS driver
> command processing path. Hence this patch that modifies
> ufshcd_clk_scaling_start_busy() such that ktime_get() is only called
> if the returned value will be used.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
