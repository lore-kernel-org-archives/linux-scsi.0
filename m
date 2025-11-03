Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410F8285CAA
	for <linux-scsi@vger.kernel.org>; Mon,  3 Nov 2025 02:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762138628; cv=fail; b=LwmbWttjDW0ndH21bzS4bgsObrEtwo+oji3qotTmaP8ZEjoyBWQ9AnS7nRSDPRHaQ2xYsq/+CI5eDZM+YxI87UziSOZV62QcQDTe9j4jS5S+xJ3dZvGH6U3s7qk5R3C6X457r1rfVsi+VE3dFkJgKbN7xA/NKsP/ywrIejLc5Sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762138628; c=relaxed/simple;
	bh=06BPZr/7BaHOjuOE08xBJ45QwYGpzwq3S9woHbITis0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lEBBP15fq3cwDWcSwO3xH/+Td/CcHBuqZR21YiPF5zhIORgHETKZD/Mg/bObNjTqjWXYr7L20P9ImvYZ9vGGpqTG9ywP2S8GFHt96oaNeORl2pYGKh3vxHF7yKhWHrFsPDP30T0L1kXjnG82Tx/2opJJjrDgag8LeWx/wfBbYzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EBOhYAOP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tIV/Vw5h; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EBOhYAOP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tIV/Vw5h"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A32oBJl019779;
	Mon, 3 Nov 2025 02:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zwuAL0RTvyOTR0eRgt
	u0R3jKwYnN/dEzjG1V1FSYbgc=; b=EBOhYAOPtlOpl+Gq8aKJPLjoQZiX+r5HPH
	ME1XPB29xw6yj7eDDHiTewyJokX0I4WWgRK56U00VqItUJhSZ4Va/uXA3yu3h8DG
	uvQ/SeAE4hy4TaVlzz45UnRzHB9EvJd8k8fEKnhRyBrWOzSXs0poWP/tzkaXna4S
	FA2Sf1rUiQowOZ3VlWTX3VNdyR6kKjg6Z2FPfJ9t5OqMBaDyLOvMb9Og7LR7TjYC
	YrbQTJfLwbgwWuxuTsfDyfBwCE1tj9+lx23x0bKimeP6LnWJS72qcQMk6PLv+D5X
	Ult+Cb1b8+GuCRFHPQc6uwHpo7QFJQXzshgGAvNabot2yfPKAFWw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6kxsg050-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 02:56:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A30EpL6022392;
	Mon, 3 Nov 2025 02:56:58 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010059.outbound.protection.outlook.com [52.101.61.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n7jcgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 02:56:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BeqBp8EX2sSWNAZmnzqp897cKai7h8IvYNfZsLntTZUxj/9KshacJKlRdDAsPuAr02s5nmghjzZpkY1gOzzWmLpcSGVGjSXV9a9nnh1wIf43GuDOl3LdBJgqbVyrx6+MWneX4HGPni4rH8gP4nkKBtYtLNOju6XNthaRnwwec2mInfFKyYBq7eXd9dyAE/ktW7NV2I0ZoeQG7FakiiAsxVg2CZ9eX8FLuTMc9ydUwMf3Il8ki1FYxRv4FYV7ZmqIcZkTc5BYvpjv6a/XsRs+HWC7UwhYBRz3xWlkRyzy9b79ibdtpBXoYouTrDlfuOPfeWCTORtY49qxa8ZExa64pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwuAL0RTvyOTR0eRgtu0R3jKwYnN/dEzjG1V1FSYbgc=;
 b=i6IZej5+Tv8mWWQeeLk0ZxmhLCN0fFSFq7mSq+Lnj90C2gdlYMkwbJx0tlRjOOuZ1ZHKb7BSc/LnHa/DAslnefBalHQ+96VIxaW3PKdJ/81t5VAT9iU+hp4DDA01wAdbJSDwCPSOez88OPJ8ZA9gYAStFpFsE3M1RicrNSTuORePr51Q7R0if31tipVmFVp/0H/WjTbvgOmAc2Ndvs5H5NUqFyMdt83UE64WR+3TUR+aPQMWeObFhNtXv1Y0AJijiHRjkdBaFv7bu9bxrkOut8YBdsQpK83ljKC8i4VYw/cxPSreGbpTxCTwuxMk9LZ2nOHMqptMqKQkp/6DqedJew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwuAL0RTvyOTR0eRgtu0R3jKwYnN/dEzjG1V1FSYbgc=;
 b=tIV/Vw5hIa2PB1SuIt+9Sk59+vdRr8gd/ZQwTrskR205bdsF1mHZWaRDNDN9F1japARmka7NhUvwW6i/Ye6Pn8CbFpO3fagbyzkWVxl3Pn3EgBCM5RLbNfLMv3UUUrQpSJPk2XjOoI1jpFv77GlD94FJIfSdOdLMWdKJ2LMsiak=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO1PR10MB4689.namprd10.prod.outlook.com (2603:10b6:303:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 02:56:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 02:56:55 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: core: Improve sdev_store_timeout()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251031221844.2921694-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 31 Oct 2025 15:18:44 -0700")
Organization: Oracle Corporation
Message-ID: <yq14irbsu1e.fsf@ca-mkp.ca.oracle.com>
References: <20251031221844.2921694-1-bvanassche@acm.org>
Date: Sun, 02 Nov 2025 21:56:52 -0500
Content-Type: text/plain
X-ClientProxiedBy: MW4P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO1PR10MB4689:EE_
X-MS-Office365-Filtering-Correlation-Id: a341aa2c-fea2-4bbb-f785-08de1a84a5c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P+zwtzoFTor/PwXvbJ1yqeMs/huzdQUeRYfzPADwwko4+4opa0LW43y07Paq?=
 =?us-ascii?Q?+wBXxJxWMpwLhMKSRdauJ/2fHpEWWc1iS78JPlUpthOI/ZDv6iaRv12m72OA?=
 =?us-ascii?Q?YjU0IJB3q7RaAaCQQchSUIo54m9+THUE0n4wVfIBi4j+Vj4/STe8Dl13t5zS?=
 =?us-ascii?Q?EEGIuLfIV3S/MFZfom6hgsxoSrunr50goZgbI4EfUUcjCXScgyZciIxd5WjN?=
 =?us-ascii?Q?iRexkFbpn8qPdZd0fDgcsOWpxFIx/Ae+SAp07fTb1Rp6Ny8kfrYbOgL4VapE?=
 =?us-ascii?Q?9q1NRE0TOWaoHDAwcgwI8fcJQTMbS3CcwvjKIq6nrzgjf/JVy2DkBjuT6GEe?=
 =?us-ascii?Q?j1DiSpRsJtawwqxaLyb7fHLqkZNP5TpfixI3KlzI59x4n1W+Y14ySCOiD2H3?=
 =?us-ascii?Q?qtMYtEtuJgNmTwoutvSe30dob6YOSEvkVkL4v4jO4xLDW/eFb7WjNpQj7Z8v?=
 =?us-ascii?Q?qJv+0csNk6EHNIuXwf1Ey6Ry0ovDq7vQOdEWYETtSLUizvBIA+ieobMkBqmD?=
 =?us-ascii?Q?a5bLE9vU93LHzOm3ek+wPmKLjgg6Mhw0ULgVIFYuc/J1ro6jTM/6I4c/nQTE?=
 =?us-ascii?Q?LEtpeexl4o2vsLdco3jtuMckUxkh+OYv2tf6MTShcScipJOzqQdFdAc1VZ89?=
 =?us-ascii?Q?6u59kMlJbuPySDxQ5UGZxE3SVIRmXP3X6uxg2bF9B2o5QUwqD8UZNEBGE9Jx?=
 =?us-ascii?Q?PLuFLnkEGAXTJIhu/glZDy5eSCQ5zsBDRwOSo64jRp/N5v5iaz+hyZaH6S21?=
 =?us-ascii?Q?tp56ggbnhJTjuMoEkzQA+qI3i/b6LC3osSyTe5tbZnbXZGk1onS7WtB6pldc?=
 =?us-ascii?Q?sgPDuUhTW0csxz5Mhg4JBY0PsoZkNNzXMbxoIQ/8G9yE/ho6FwX7gdVlyIN/?=
 =?us-ascii?Q?aJ5zObscGmRrhfnjXqur3E9Ueg13/nwS7BRpknCk82GzoAfq5alIx0StSqPd?=
 =?us-ascii?Q?9kVbceQ4jVOOaiCfMg1IgPeXXm/Jxuce6uH4HnNspTSOnWcYCssFX45M/266?=
 =?us-ascii?Q?rmYg/CqyuN9x3ENKkOqQjEN3G+QBYDCZqv3SbMP9hwcS/r8IlA3TCHifKR6h?=
 =?us-ascii?Q?CFeZ0zX2FDxQ7t3E2iN7ir2xEBECX6oumAZMu7dS3CZ/tvQGBGNUGYyXOIFO?=
 =?us-ascii?Q?tkJwvqiHRYgV/1ixpzy8xNhkaTkasD9eszdsPggHlGv9swBj8uozLlybk7wW?=
 =?us-ascii?Q?fETfG8Jt9c9FgpMn0zV3wGEVC27ITch74nHDyqgUJyJ92N0GH+VoNpbE+k7H?=
 =?us-ascii?Q?YmdFqeZURqQLeyGwNf32n/k75PWlLQYlXJVFWeE8cL5D9h2lqduONV+qfqBA?=
 =?us-ascii?Q?0SFK34tEm6aAHOrBIzgCwcL4de680l5Mu5R5r/LuQKfgMIrLQpleLKRNbToq?=
 =?us-ascii?Q?GsvzJyqd2NFXyT1TaIwG6ZhA6pIFXnZVo17mYKmOB8H0aHWqw1HJZ1gtl3u4?=
 =?us-ascii?Q?24vmcPWSjw9zQu9V/iIPMb9fGOP2zpJB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xOAx+7FC2VxOhEq/UTAZaXCzeNbYrEJc4muiF5gXR8l7hkrvmC3510/+4a0N?=
 =?us-ascii?Q?uTiVkSdIyLe3L/0Do4whpdg6TkLAnWuk2JPAp3IlTzGbY05TnK+OPo4/Mhc4?=
 =?us-ascii?Q?OLFzl14MO3UQViusbNyxg9n0nA48/pMIz1AA84SOQh56cgfBhPjf2qZLVoHu?=
 =?us-ascii?Q?qvlHXULo5Urc7vox/nAljR/z0jpxmNibEpv7/kHV6GvZsHvGJZmopkpPQaqZ?=
 =?us-ascii?Q?hxVPwoL5m5+MDWaTijjifnKOTC5MWoNctaMzwmngyrdGWAsg/DZYn0plQXWl?=
 =?us-ascii?Q?BPdvLXpOcj5kPvRlpSBsjrNhhsZEXTfGJy4Eq39rbH9cvdnClS9efzzmbfiF?=
 =?us-ascii?Q?v/HHFJo7ZXj/q0TuMFCFB6MDeaQDCdyCzkgq1Ny1bLBMH58IKtYOKOKKZDwD?=
 =?us-ascii?Q?qM+uwxxMUNBimv0PcyyAkKgPd+O2ihkaAl89Ck6RP7dbjSfeQyZS2YTI1v9I?=
 =?us-ascii?Q?aGauEJYnsMwAGffEOstcUIZsM2GF9Qb5AKy9pMZ2/m0MCAoZKTGYYDxmiBNd?=
 =?us-ascii?Q?c2ISX4muWc4tW7VfnWLWGVqdD7+2m/CqWMoxcyhw5MZyNj4H1nKUHcfDjc5P?=
 =?us-ascii?Q?DNIL6sMZsm867K4J5NC45Mxo8Sb/Y6WXPdSlrjrI1QNNCXuDNooaoVX8T/kk?=
 =?us-ascii?Q?7ik5I5F1cBa5Rb9rECNQV45Lw7D+cQO8OD9gtl28MJYHuQQxK0C3j2onfHOL?=
 =?us-ascii?Q?tzsgCVHRmmLoklG/O6MrKcVWqpG+6UHytMjLG0uEY1L+zdHaj1+RTHL+kqq/?=
 =?us-ascii?Q?bV/gN4FjfZaxOIZdEXS6WT2e9r4ng/0L7BCoBBC70stJtD6DaFiFsTjHC5nV?=
 =?us-ascii?Q?/rZZRuYLlZs9FRO9QN6YLuAWNVrlcnDLcXoZ5iTd0dxyIXWUlcV9iOkZWXJt?=
 =?us-ascii?Q?8TI5IL0ufqmGue2jPmKpCOum/xUcjMZ8/fBKkYnwBLT2DuPlFimMoi6M5lAO?=
 =?us-ascii?Q?aPLWSbvW4DGycJWr2aGcl8leP4pXQvbONyoBBvFiSIWDYYjmcxbL3dcVPyrB?=
 =?us-ascii?Q?9TVt2EQ9D+6/bRKukjSkwSmUOsQxieDfxmVIVnRxH79k5D9f2fn/RGbezeBY?=
 =?us-ascii?Q?2+gkabgQs37k2y+/osIeRJ+hV4L11zHlt7zRldEufuaF22hPMaKX4yo3+F7Z?=
 =?us-ascii?Q?QAgoe8/qwahs6CA7Z8iIISfkQ6OajQ62tjzXy5ZORBArfZ6gyHFiFeRa0qvz?=
 =?us-ascii?Q?+KVpzkm1zXsp39KtHeyP0jgZCf/IDSBa/doNjOKpDCNdxPzBOqCQ23pYIsra?=
 =?us-ascii?Q?dLyUTPcPMOVH7oMs5vY4EgsJ5g5dlmCbmacmFM6Fs1TPVkV7XMEPpEB5yTQj?=
 =?us-ascii?Q?ZZ9iaiy512kiLDJsfw4n9TTnYkvcrxyr1Po5QSaO1GS0gu1mjuBHqMpA4pgG?=
 =?us-ascii?Q?eo/VSZKb2SE71quzzjB5TQmzSszjA5N3rwOaycGRG1trv5hiEFDMfT3y2Jk3?=
 =?us-ascii?Q?BLUZiTyp520VoJB7ugipzMfoF2W5FqNtmgdFkqwq+DOVFBS3KCNONievsdr8?=
 =?us-ascii?Q?J7YeNJaDr5M5lY+tYHWMXAYSle3tpMK8VvlVy1pt6AX26DiW2qfrJ9q+OhuG?=
 =?us-ascii?Q?fMG2WqylLTKzLk27uxpc7DdIE7ahFEWZCnvvlSOwPDoNNaoDk/2Feue6Q+cv?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J1pLTcx1AYJGAs0bMA/qSTZI69EHUZmc5+qWkdoI5TEhhXoGb1VhwejQ0YG9mbGjMO+10HJJ+JgyS1DrsL4HOW4aqPvg2ezxWx10qCOB9URs+xRiv/MKvHKA4kTLl57kUHedf2hIIYQIQxCEP7c9Qjv2M7o+6PnCQBhHrvGCdePWzjDBN0rwVNW9Nn5AingVYssUrhQQesYUJl30aI11TCtxfT1rxXHUXH09VeTn+AIHvcRRgYitpr2jUyYsF6MqqL854PMEj6QQMmMWMhXprhbHuh3wKa8FsBNo5euf6+0oJ25unM3EzabDEsq0psaZvz6qcNSwBXfKyv0mvS+eoGh0UcqFteaYtYbkPZr+3A5l8tOJTrmYjZ8jGsZGTc2MvTv23gcSRDZpA92HR1vuJtojvuK/pbdVmdYLrWWvcinMcqRBW0i3/4F9bKNyT6gC0/24TImHF9stSDQju6GPtBZY9uneo/+FilcCIj9N5AjClEwFzBFrcn7+2BvZ0TdlV8UTMNylQpHjY2aBki98IVsgs+qbGd3Jy8qbTehlwZS9I+ZwbHWqzvLN2r9pPhYWJzEBBtXS90cL65TLZmkPnbN+Xmd+UL8fG60wBo2cWc8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a341aa2c-fea2-4bbb-f785-08de1a84a5c4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 02:56:55.3506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+JKGAcjacTp5wBOZiUJHUCLkmmNOurBglFkeN/3AXLTyq6GZt/Mw0dB8oGQGyS/NUnjsGBTl9e/v51a5dBLAEXW6b8V9xHIWDHBvZCMOH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-02_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030024
X-Authority-Analysis: v=2.4 cv=ZZwQ98VA c=1 sm=1 tr=0 ts=690819fa cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=PHDTixDOG-nGwIsYzScA:9 a=MTAcVbZMd_8A:10
X-Proofpoint-GUID: ESF3eimciizElFWMY06jt6TvpowHKFAO
X-Proofpoint-ORIG-GUID: ESF3eimciizElFWMY06jt6TvpowHKFAO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDAyNCBTYWx0ZWRfX4kA9HTyT/AFf
 NyyHS142VToy7706/rjjmTfMzW80L2z1qx6ok8IJvsWZVq2jfkyPJRJ1InkRT7omITfNoUz03JP
 TrUfSdeTeqN3i5YNrZtYCPf3KPD0hlMjPCAdGMDdYN26XJO8UC1NRRL0RvxmSzmjNicVyt720sz
 BUDVjvqIjjyPwBneFNaPE0CwXR8F5oGgwI91H7TlkLHZDP6jUcSKGT8hTxlOJ6MiMLMi9XyLIFi
 rEetEHvbuNGayDG4ayASRlFta8yJH3/m5+dnBgqbmyoUU6aLH5hoJUXy6Yo2awyPeBBJMX+JU56
 Sq7W97i64zTWfrETYGrVsiOEMD8JllDz7zx0xLKBUrBB0asVA+vEee9opFtGKLh+GaUW1PXmxnI
 9fqrX0WfRoDkQNEueJd2SjvFEJleFA==


Bart,

> Check whether or not the conversion of the argument to an integer
> succeeded. Reject invalid timeout values.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
