Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A2018E1F
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 02:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758767784; cv=fail; b=jdUaAMZSdlNWn0YmQPDiXYV0oWlBcRKdbpRk43wiYJPeDIIgX+8G/DBU5465g5mmCUT+KRPLiCctYwq1ooXWPr4xPDBqmuX9KSEVAxPJ1Waayfo8MgwQjYkxiV0qwPcDlwLs/W9rA36PILqmr8kN/FHx4YBnjrXgGn2mPxifI84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758767784; c=relaxed/simple;
	bh=YS1/1+gX61Bkp8ZK2qlh6mO+TZpmW3xxRmkwhAH5k6I=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZAfbVo934KiMA7zaMBtxyZFiuXucokpa26zfcB3FefdqcKXcO5fYNKIVzjkm6WRVkZdjbj3QcwJ1HgCXNWLTzrYhxsrDpKfWzVVRmN4EkhkTd/AD9Q3DbXRfwjAuwdJezdM+aIdI7FYcfrapnlKUsTwCaPoI+CxxlzFr/WvRICU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Apsi555u; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A+HZiO3W; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Apsi555u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A+HZiO3W"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OItuQW020575;
	Thu, 25 Sep 2025 02:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wiGYns2vPNWVkegnZN
	SzAgqoxkkWXdX90XoBfaSRmno=; b=Apsi555uTe0IuKqJUQtpXhTw8h4eeJscup
	xWYsUq46SCVKJ/BP8jmYBx3vsSNF5fxGafkVaW24pU6iy52MRSUBxXSKPo8Q0bkX
	jNJJns1h0aFmWZyrEOiCcTI2/qR+XE83aq4lyeIhMAecJ+2wfNMAsgIKOr1yR1Q7
	96emvITYjrDqcRxKPzvcYpuwz4hZH7li0v7mc/Yrfhvn4Eu4fC5bh5lgFZIquRpc
	ddw4R+yTqngzJWQrpvP3Oym0l+qnjgwcywVh1otnM2/fMySmh+eEOxUGhbIJf0So
	mdUcTP2enKdpU0GAWRvnoXzEgBZmzUaJELeaXHL9ZmLsYpmZyKkA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499mad9432-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 02:36:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58P07tZ6035521;
	Thu, 25 Sep 2025 02:36:19 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011031.outbound.protection.outlook.com [52.101.62.31])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jqarsr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 02:36:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I/Kva62oNu4XuHyPdEKERyJmGv9AAeaol9RxKGwI3MzcS6WbEW+KesSfyeGEy9YTdDEfHX/EmEqQ+jNT1kTE4yhnag5B5f3hekjI7pQGcm5Yz9CftP81xAWoK5fGuzWtE4KuthZ4FN2XFDp3id4/Xndj8LhX6r5nxj0s11rcgANIWH+i8UKM08njNG0bG3HvJGcDpNQchdNNyqjoaONS7a34kRfDpxsWJanFEwtVs1i5zOLYg9fiUq9PA0MPkriWjQ+B2TktF/kpMmugmkb9UKeQives6kuiTaH/vAHzEXPxBYatk5vpw65NSKVFM2ssWKYuKTiIjyl7Cx01JVz/NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wiGYns2vPNWVkegnZNSzAgqoxkkWXdX90XoBfaSRmno=;
 b=J0AJZtLntWUjdiXqT43gONSg1N8zBR6bb5Xeh/4b+gVg5thc1lsLXvyP1mjTbuGzhfMIGWs2VygOy6j9TbJb8A0L6+zW7LVIqNL/hg17YZdBhPJTOruojOgXZucI2EEyXjVg+ez2AXWMrStkuc88pawWO01czzqVK6Q1jRA2dBrIroYTRrxINixMWrghdAf5Iy5Csx5DaCvLJwaU6PeCuk4ygtueR1XQ5eaX337J5L5vntLbiHPIvtD8fNGXDb/9PWBW1IK2bpyPkmoCN9H3g2nKd8hb4i1txgbK+3yX+Uw0YSIJ2Pt6v0KYH3hRESqqAUcHUQ5+mBs+Or93/yNmdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wiGYns2vPNWVkegnZNSzAgqoxkkWXdX90XoBfaSRmno=;
 b=A+HZiO3WpzxLUOSwTVucfD7W1a3ftfxWqjQp47oa/hvukoM9VpDPCXLUgFBcpiYH34IPdcjNPXSYdBpKf8MragjV5vnHThKkara3D/tyfiUyT6utL/6ivNOam3UodW/OIz5YX8WEtmpoRbsCIfB/m+Y2u0ZAmid04zO6mkA8PV8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB5865.namprd10.prod.outlook.com (2603:10b6:806:231::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 02:36:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 02:36:16 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1 0/4] mpt3sas: Few Enhancements and minor fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250922095113.281484-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Mon, 22 Sep 2025 15:21:09 +0530")
Organization: Oracle Corporation
Message-ID: <yq17bxnqmx5.fsf@ca-mkp.ca.oracle.com>
References: <20250922095113.281484-1-ranjan.kumar@broadcom.com>
Date: Wed, 24 Sep 2025 22:36:14 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0202.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB5865:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c2ed416-8725-4a52-ac1a-08ddfbdc4d50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8WNUg57OWzFLFfaWhGoA57tVm1xPgvbTGCwxsG7xX2ldoZ7zR3s6zJpFpRJ7?=
 =?us-ascii?Q?T2qmzZOYW/CJbTxRF5fX1xI3eeK9P1ss2qKGeZh97uexGM1NhmrF7HCpFSrv?=
 =?us-ascii?Q?WQTQLtJDoQ7OD6XZYRz73iSr8RBMPDoxV1VCqvESfSslYrqn5q5FuXtW68E8?=
 =?us-ascii?Q?sZ/LRTn67w0kbZ7VbVGJNnh9IDIpfX+SOj0Yz1kNn1ZL991L9p8FvmFj2ixW?=
 =?us-ascii?Q?Xef+F4x7IBbq9e3rNBajSdTHprBmnzEZQKhCzYBTo/3/NHtwg5cHRd1vNZpB?=
 =?us-ascii?Q?4LZcS/UNyIxV39U9vssR7P1HpnyVfjVe6qe5gzVLqcoZvLDtdhngNt8ifRKc?=
 =?us-ascii?Q?eu87k/ZAY7uFxWvhg27u6gUFVyVQjhsmV3J0paykxbuKvBuL3Ayg356X2+eS?=
 =?us-ascii?Q?VTfZ8DKzsufwJr63curidFSUGeIU6HO7hJGnhXAVdITUZXbwFZ7yRy+0vw8j?=
 =?us-ascii?Q?YHwScbYtoRQjq3qYEurM/3eAbAMABY1yFV7jX1mdRi7yXtMXFmhmLBbJhUNe?=
 =?us-ascii?Q?6K1ATQGvpHVG6RcMLiWKoWAxM40O2c8zYZu/sfnMoWQzvmDn0xFF14mQAo7n?=
 =?us-ascii?Q?m0rzhUCb2zAk86FjxIBQORFJ216GkvbaEawNUcpIAH+Bf5K7oQ5rRamIkYrw?=
 =?us-ascii?Q?KNFvEr7OTkIejHTo4crCtUeITLICnogI1ZSSc0677UPI3RaUBmUxetVwdJqS?=
 =?us-ascii?Q?w2UoFZV3zqeqqAbmHsBHyfb4y9e202Qllq89cPKnX5ExX5O6jCeobqhbdWyN?=
 =?us-ascii?Q?gzFYnmTqtia2VCE6iRqinxNPmJwyOUPjy6T+GrzFjRCYV5bckKdW9TExYHE+?=
 =?us-ascii?Q?PmyH5wBlKtf1RBztuuBN/69ceRTNKEpVI0Iv81cjJOlaQWVcJ5UHg02hYhOE?=
 =?us-ascii?Q?izEgx/FAY/8MjTVulSpSbaGwGO1Ch4Qh10wSY5bCoYYK2XkdaHevRoF7cifU?=
 =?us-ascii?Q?o8XGb5vycCBcIUTP9yU9+Me7jXdX+0DM+a5tRwnsvYzGDXprw0YLpqBWlxJL?=
 =?us-ascii?Q?803WwlSRkW8+X9g/ZcozOuTPw9ik1ohCac17W1oMmXLwIxoH8boTfuaVZlzg?=
 =?us-ascii?Q?Hhp1Tlvt6xBQ03+cbhySlSWKOYl17R0013shl3UJs12cyjCNedZgtMmaAJyW?=
 =?us-ascii?Q?0H/rMVhFQnx8E2QkxztPku9WdP626tdMNhgCXqMgCay3KhgjwwARo1iXW4CE?=
 =?us-ascii?Q?dpliLnTUP+FV2SVja4IEiXW7ml3L3UlAyDeEoc6ztv84wVLuR7HFbAOiptou?=
 =?us-ascii?Q?gB3mGSHER37lH1KgdxedUPnfkxvUU1ho9mVbJ792V1Y+NwUbA2u5Om8J8lGW?=
 =?us-ascii?Q?yqn7ZVnbp4j+xNrBNIeixR5eMO+dkMZGeWonkxrBsCBlmbJl398MFKjQt/SK?=
 =?us-ascii?Q?AEDoK8kVAwiPWDdXXiTi/JKL7j6IVIcXFfbIV24Yq0v7N9pyUu3wspxIsTEN?=
 =?us-ascii?Q?53rlhd+0TuDv7lcfincZ+fSI4XqS2Irl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uqxTXqqjTVlCn8ojF+wfIVjyMtA1N11W0/TVVwJas6FBy5af9G+7Dv8KPkLF?=
 =?us-ascii?Q?hZ+ymAhy9KPRR8I62lfednzyr64oYAmLngTVWPQMMcRGepcYyUrmOuz/5oG0?=
 =?us-ascii?Q?gb6jsvEko7rkrjllcvBdS4ie8Fh/2yrOlqITLhbIM3HnJzS30yMnOtxCpRMR?=
 =?us-ascii?Q?P0GFzXZipqiuUYnjgimFRv0PVrmlEQsAu8CbbOs2q4pSw+9ga7A1jn8G9vtG?=
 =?us-ascii?Q?2jIhg1Nsh4dbxIf4yklJwHYD6dW72EXdUz9LlUfvvR3nTUNKJOB29AJJ1hpG?=
 =?us-ascii?Q?92hqDV7Hvm40N56hAFjd13lncW4MQvOsQBoei1IPF0GyON5cLRCO//RSdc87?=
 =?us-ascii?Q?nV9YLu4IENTGDPTsohsg8Wdr1ZaCokbvEoTrTePTdL6fFO2DdD/5D9Tj7V1e?=
 =?us-ascii?Q?AEzABP3gfQ0IVjWEKo1Vr1+ctgQHGSrGvyld/rqZ/aLO2aQDcR3oBMth+66D?=
 =?us-ascii?Q?exPC1d5ER8UcHxm/YQIE9/nLX4tWOfFtPOmQVy63N5hGzdg9JUWlRDNNnUwc?=
 =?us-ascii?Q?Bw/aBj/HWJ3CT1+DM07OV9nHyonTihq1B01jg5U8w7VGetPwwDM6Y3dP2T7M?=
 =?us-ascii?Q?ipIwP9fBb89EWQWy6IdyWwvVmQJruYV3jlfc3kkeIoe8bagOxb1Cfut7aWzV?=
 =?us-ascii?Q?2slVDeT6PidAYPdhRxcjvMlo2gOizT9JV3B7tq2JO5rPSOrFahjqQKpIgVSZ?=
 =?us-ascii?Q?gpxlPCgOSgvyo+wxE4BlSiqd3qzy5AC9Ixy+7zEsOp3ga/2hL7IflyAWqUNn?=
 =?us-ascii?Q?GrUAmSrsak2o0lL/9S54YhrH21odM2dJQdiYpY4nnwmbxAFpYKjhzH3yuP44?=
 =?us-ascii?Q?T5BRY/TlRB2v5ZoAjZh1BzhSqT/zaeMh/4EGBO2A7k+Hccp9k3O+d2eAoE/C?=
 =?us-ascii?Q?ipWJEsHFsOFa14T7WCXT9dYIbQmgOkc7JNR5TvXx9g8CkqH3sYCNroWmm25f?=
 =?us-ascii?Q?duS42TPPv0JEDTGwwEpTInN2EL0flAeWy4zOC3R25T0qJNgEmplGjy5nWR3R?=
 =?us-ascii?Q?EbIGGhjuwDjGIAi/cpZDAtdcpVJbgwfFsbraPDC38+oJg7MOuYQqb1sORji1?=
 =?us-ascii?Q?ZjlJRZXfQLEEEIODUyS4rUvAPp6hYtPaBm4DzaxpEB3DLDcvSChIbvbA2SB+?=
 =?us-ascii?Q?HhiGlWfx1Ip+jDjPxUjK+F3GbRg3G+9u0F3gvt2mX5xzsyD/dWAVoUPnPYsG?=
 =?us-ascii?Q?tltijmin9PEfQsSjvE+Y4Wj/lkjT5xNdDMjMvwd4950jxckls2xP/OHy3FfH?=
 =?us-ascii?Q?tCPfoI2lZADS6oOHyJH58g8i2Jw8XrYf4N4zzbJCgF2evrHzBzAQ3Vr3KzK1?=
 =?us-ascii?Q?8r1utGlFOlK8HWCsw/htKaNiYQVw98+wqItGRG1ctjNAIjOZu8gOzsiRYRc9?=
 =?us-ascii?Q?7yLYItpte+YugjhNwK8U4IHJBtnTWWyCEUUPCmkU8t61OqkbCFWKtktPdtLg?=
 =?us-ascii?Q?sLxy6RkRcMvGSMzOfBU6Nl4bxlI0/eHJkwz5qrz3/kKP/P0u3HaSdVDA31sR?=
 =?us-ascii?Q?6b/xc0K340NoeycOGItBAYGUoLTvNFbs51YBK4HO9spCpDIZNhrSAXQqXhkp?=
 =?us-ascii?Q?NNaYkp1b0+gU1wDfcgfSggZ3O/2TdAA0ym31POJP37UYDf9gppRyIv5rFf/h?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ifvlm3uzL62kcGBVnaP+fcohUS2Md0p9ZUewJqtWjeWvnMwj33W5NoPz9B6SuHDSAHhpjijmMmjCnIqJCl+Fsfl/GvERwfBQSKSVUeaMW+xNxIg2ti11iXiMX9KKQ2G2cIWY8NtnCOhMsSZQIhNXbID01HdiKbE7C3HnNkp+5PqIZXL6YzjxDO4DBXBOXro2VGntWu/jA1y+8gIIO9VgknjMrbd73HGQsmaTYCYzXgxtU/240kCaXre8PAyn0BnQcQaaaEEctslWNSHVEbboeu67ed97u1Byy709pm3OCfp2F88r+ivPq43F/0WdihjkjHJj90dwnMTGpbO9BEkp1FVGdlt2p6NNPOKPdhntzOAgeFU7n9mPUgg3935hi3azf31hkSxGOtQxz/771ledmfEw3NFxsPkx/egOr2dAmGavCoha6Iq0RlfqV1csarawsgCJ0g827jWKikcqivMofl+sCld41RYrPSAT58LAmfxNagOLZQet77ECmcL6JhIrxb8Au6zfWdb/5sl3AFfqYFOaMvfCvpAsTXm1fj8nkiIhc319sAkm9p/rmhkSKa14nUezXjuAjYGTmOgcYUymnVtAv4SmVEdgDBrLD6EqBkY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c2ed416-8725-4a52-ac1a-08ddfbdc4d50
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 02:36:16.6082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u/cSnFwgy96y98gS1HS3rpl8h8qGcQxTb5nvHWoQEK19eDt3R/BXVPOil6yk4oAgJdoO4Y6qgfKM9uKttd/2MbI0M2ytT9Oecu4pDpkyx64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5865
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=879
 malwarescore=0 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509250022
X-Proofpoint-ORIG-GUID: tdPabxKRh5UXIlBgibsaxSm9ST2G6uD5
X-Proofpoint-GUID: tdPabxKRh5UXIlBgibsaxSm9ST2G6uD5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyOSBTYWx0ZWRfXw29NmJJ6KArP
 572sp5I1/X//qFlYg0MR9d/BaxI+iJE7SYseyVpi7LY9UYJ1BckvM3/oXjkVRyRBF5g/vMx2RdP
 s/TAEMbFQ+2q7OsvLYt/UfzdzjatoMe6KZt39OCzx7jKoF1V1X0wkwbcyc+LhzTpe4mdW+q61pp
 i2nkMxs6vXeWPq4HMPSa2qHzUUQf0R4MTdt/0kK4oBa1L8rokqccnBpCMsWF0oEpML5y1vQM9rS
 GYaPtSNQtQguSpegaxxuoQsZ6SJkkCHwkKYU2Q2ulLabFijFmavAR8OS00KzQCpsHZBRo0f6isW
 1fIicGaWGlys+LeMZPNXCwI+yghSmwl/VpfWOGxwwPVAQ543Kn2p5Kp9uvQaM6D/Zw9yIpDQspR
 Wr/kR/ci
X-Authority-Analysis: v=2.4 cv=Vfv3PEp9 c=1 sm=1 tr=0 ts=68d4aaa4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9


Ranjan,

> Few Enhancements and minor fixes of mpt3sas driver.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
