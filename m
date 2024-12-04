Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4481C3C1A;
	Wed,  4 Dec 2024 19:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733342019; cv=fail; b=rM674azf0S8kJtRqgo80Etb8CooeyzeAEbAPKaIOjwI0tfcmV2XeEEJcOzGz5Z5GiQNfNUAdSnSWyaBZfI7boq8k4C5lyeEWQbXFbtdjmIWCtVyKnIcwlSv68DoVtvOrFoCF0gwm5NRuEKNXKMnATyF7bYv5C0m5ptgAqc/9wt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733342019; c=relaxed/simple;
	bh=MLzzqDdDcwu/kUVYZw3OGTAlI5lvEOAWL5hGLS647qM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=QpHlQ7dhcKV7KSk3HPi76+Z/WG1EYL4MVMJsyEril5j0zInwme6aofNUviVmJ+xJG1StapDv6bK9R4yQLR18WflKV7RNN2NVwuVy8t6uD8v/zuecqo1KmYZ3b9VuWYaTGpeZUOnt87pizaEqHi3SHC+BLmrSxyQ4juA/vFgxnWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NS7ABC+p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MKZG7NlB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NS7ABC+p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MKZG7NlB"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4ItrG4018503;
	Wed, 4 Dec 2024 19:53:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=c6e80dzcNmAcJENiC/
	ym+p7DI9leNlAfW7flgJZSlK0=; b=NS7ABC+pKCVRi1I3qVxHKl7VzxnZhXK6bu
	S3qV+jswIzuX9vg0KsS0cmAJsadt6uUxbbLXJFonggrVRkS5VIfMdL0WFkSNz7wn
	sUup1VFFqR0GXqybQ4t9rYQ+454jR2AZgnZswi3B/g6vazsB9PPF6Ppzl2gSOvKM
	4chboaXnowUcwTvM8xlmIkP5XHT+eaJwUhrTqdk+S6SIqJ5xSBZIGWXMIilR3tJK
	3wOImb4eOLpW8Guv3upEfmNJ5di87xu7erY8qkVam4ZbDcNBXnOT6HIwXy8X8DiR
	pa045XWOgFuloe35488SuUiN7XnFHruqJESfCIuVABtdGXWlKgDg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437sa01c7p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 19:53:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4JV0q5011768;
	Wed, 4 Dec 2024 19:53:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2047.outbound.protection.outlook.com [104.47.55.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437s59vxb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 19:53:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NpQdqwcyJdxuHMJkHZaLeuYjKD97c0FBHDvsePTI+HIkb4iFyEppPNgzRwvlmbNcXQRMEQwOLhigo1C9tdaeCStzDrXZjcX7fcUvxQlla2obg3+34o8Je0+wzKfsecHQiCTTAGnV+mck7isrgIJA1+/3jfB7qrou4KLtMqOMYXVHLdLpvBu8Hk8UaWOpJsgacCVy5sF0hzV5uMwmk6uQcPNiBJlagMKdWZTPn0tYx8fDKj47bx5z3k3fkJVD3q8NMot+yYABxXPwisec+byQ6hZTYMp7exzV7CsRsZpDzL+413rYWVmxmJlxo1gGan4VJ5s5fsMfDyxHsXRWEuNW9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6e80dzcNmAcJENiC/ym+p7DI9leNlAfW7flgJZSlK0=;
 b=lg2RYO4tdmjd1Kq1QnnoGRfWlnyBqd2pAYR0+NsqSQoiQ4ToO4Tixw5SE9txvefCFxhjMq+mpjcRMAJ5Lqia6ps0cHUN2aNai7j3WgLAcbogxgWIXYLGOdXuCt2vMh8Bs3Mls0lnBLXe90XsvSGalMF3M1xbqgMOtGrhBzJco+fhq7glQ34RZpFWX/J6TF3zTVk1r1OQLCwjYnD/Fn6pksMH+QJFEEWsoO+Nxwb4o+xDcdSY+3VhjkARi+DiVaS8cgMQo+ewHR8+QKwA3rfMacdbUd+y1Or0ykeI9rYkGyAtESaHArUrhoVEHKdBnqeIPchYisrBTBP8WPDuNEQjiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6e80dzcNmAcJENiC/ym+p7DI9leNlAfW7flgJZSlK0=;
 b=MKZG7NlBXdaR1KRgHEkUkMgQimqLd1AsncwFys/+pz707nvFGOwrF+O/KSxpa0ni3MZJYiV/hQEmP0TV2suo2mTyx6e01OW7V1s5d5oyulad0qb7SSk5tXr8OHItJ7fwmaCgn67B9P0HpT4IEzKxm7JcgyP2gtNDD53ka34KYLU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5153.namprd10.prod.outlook.com (2603:10b6:208:330::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Wed, 4 Dec
 2024 19:53:24 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 19:53:22 +0000
To: Salomon Dushimirimana <salomondush@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vishakha Channapattan
 <vishakhavc@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Improve debugging for aborted commands
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241126225546.975441-1-salomondush@google.com> (Salomon
	Dushimirimana's message of "Tue, 26 Nov 2024 22:55:46 +0000")
Organization: Oracle Corporation
Message-ID: <yq1y10vp6ow.fsf@ca-mkp.ca.oracle.com>
References: <20241126225546.975441-1-salomondush@google.com>
Date: Wed, 04 Dec 2024 14:53:19 -0500
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:a03:180::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5153:EE_
X-MS-Office365-Filtering-Correlation-Id: 5eebb961-e399-4cb3-47a5-08dd149d4e99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ov5JMlIOGKJaua91GHZVzR6lKu4OrkEasg8Wd4haYj9R6eLsiyiaW6sohhWF?=
 =?us-ascii?Q?9Z4FO7i2X7aMASt4SD6nfg3PnUCZK8wAhaoDB2NQ/EuXbGkUCdDIGJDpEekP?=
 =?us-ascii?Q?CTGMoHSxnDQLi/JulonS5GxuSSOvjLX60GWsXs21dg9n9zPXICqUDLrtaVf5?=
 =?us-ascii?Q?ozKgeJKjLG0gaqSOPNLGoU3rxIDWPdJF71h9WaknjtGWXxTJGxmrnEthDw/G?=
 =?us-ascii?Q?I5csyPC121hTazXaBnU2qi+IAxiXoKnRA7MCQbJkiXbKTITKrbRQ298InIny?=
 =?us-ascii?Q?Qnyn5SaD7/SZMh0xEsVZZM1bV9lqaSpUFC4xbCcY9Pn8tb1kIu0XjpPdRd4/?=
 =?us-ascii?Q?rjSc6xQTMl+iE3SYv/DAHFFSzwJY3iw9YPfFiYxtlqI3XatwqoQKxpy5DrnB?=
 =?us-ascii?Q?+R3HEHB72zFbuJ1dE8OpAX+hcOzDVIvOMNgVOugwWKvXmPlzAAbL/ghQtltr?=
 =?us-ascii?Q?BdwWpXyZ6XYJP5RcxFEoG/qmEeXuD9XxVLqs5puQA84wW0Fi7YNN/x/v8QcG?=
 =?us-ascii?Q?vzDpqAbRchSsfIxqobkeB3MqOfn68q70O5ybUu+2SZpOS20Nd5qjs5OyVril?=
 =?us-ascii?Q?fWm3j0HUE8cEMc+OW9Bvp0IDAyNkV/phMyi2zKkqo4ZJrm5iV4Y0R3fcqdC1?=
 =?us-ascii?Q?7p2lMGJ9mpC2sTM4T4EQygztf3oL+qyCf+QlWG0ahEdiX0CTdcP5v1YVBr0Q?=
 =?us-ascii?Q?IzPCB0Y8RWFKj8iXL7+7Dika3Bp4vCRSG03GN9uD5L2Oa0xY/CPAVsoxJ/FI?=
 =?us-ascii?Q?5PtwkrpljT9kZXkIXFD/0aednQt+yHAW0jKfWW0hx/GPtSlJqBJD6C7A0RAx?=
 =?us-ascii?Q?aa5dHJROOT+5Vn1Lb6JA1nSeYfHS0KnBEBtzA74gbYChhfeqQyfbmxsFeo2S?=
 =?us-ascii?Q?PIi6b3esiwLHJNYzKqOMHJ6XmHNbTAKvdtCLB3slXgTv6eUg67H/1Beayr5t?=
 =?us-ascii?Q?A7zk5zDL+UDGs6zvRh5Lcf8sfDJg+y0iqJ+unUnLUwHKyKTmFRbyyrp6vUjy?=
 =?us-ascii?Q?5lEi17t7y1FS+rV0+GlxROwcpbAhdyd52qpd06IWlraDeR3HDGN/1x0dYbmO?=
 =?us-ascii?Q?kc4r8AZuu+nWfneilQdTdbx4zc7NvNbZcbIMxpY7eRNyZlpMAVDfLcUl0Y4v?=
 =?us-ascii?Q?R6z/eeCXyEfUfZPEOtGwh4b3LDOY5pSEjTuz1c+DYnWjn/DDtVpObExDyVzi?=
 =?us-ascii?Q?jBgdTGdhNA1nk2Yys89cNw22EgUiZ29nxFEH4Gh5uT564WCTfYODYWleUrHo?=
 =?us-ascii?Q?DiLvFjsewDTQAHkZk+8mMJn/lAl3GAt6VEo+vzWhvr+qUHnNum+MfbMj4k9n?=
 =?us-ascii?Q?T2zjNMXmyQzezuMv/VuwMhXUUgBDRnWiuXE8m+cTB+1B5A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rsLUC3Qk6ZnbCU/oJ/D19LrnaecNQHlHaABaIXl0ZmHAQPP+XyqEeGHd5/oC?=
 =?us-ascii?Q?G4O63DRy+wpnVZE9slg7dHazNS2Y4vn+AbhSdbBz9p2x/o1aWMkFNfsv7v6Z?=
 =?us-ascii?Q?jWgenlsu781OKPnAD3+p9rjhjtnuOQ2Un2VZ7UARYBPSgXLtVF5k07Vl6VEk?=
 =?us-ascii?Q?hCu/s+8/XJRAQ2XarqvxC6L1tH4avrKbrYHGzKhJD3pPsiZtzLJP7k+bo6UI?=
 =?us-ascii?Q?z7yCDlTmTTy23UH1M36WcNuIAJIpAbI1UyZP8A/zojM4BUfiKto+SaiY7vjr?=
 =?us-ascii?Q?4/yKJ0YKyHXFPJRV62FN4h2Fmi6tq0IdRAyAGZ5YMEFmX6wI1M/iqBQD50HL?=
 =?us-ascii?Q?FRt5WmykA6/XdbNoVfZQ6mw0Ljun/FoQymh7frnxoRBP+dAfTESavyFbk1xq?=
 =?us-ascii?Q?zUgkbDFEq48EAzzEMy46V5YbPkKBYQWDA7KsbXnHHswXSNLeg3RdRY0vLf2N?=
 =?us-ascii?Q?L1ded3Gr7+9R8GAk4AufqpsiWemHHm3KLLJhRCXyPsBgo7lMhOvTj88cpd1E?=
 =?us-ascii?Q?ll576+EF7tMEH5RTBxUT9poyawm6UG7PeBRbaUPAXhx2kDF1Zr49Phoq+t+Y?=
 =?us-ascii?Q?mt/JSbIaO/kpFpR6zuVSl70qqwqMapYh1e4dxqtx2+hmJDVZTHTmun3yNaPY?=
 =?us-ascii?Q?FD5whrFsQM4KBFt23kxx0+Q9RMkCRH2tWyv3FmdZOAkIVD2bpbItjGw8G/6i?=
 =?us-ascii?Q?SKxiLwyewqyHwrpAPQFXFNlTNuAzW7AphVA/iKDwuUdmm+cTbbatXHCPxS/A?=
 =?us-ascii?Q?5JuxTIkpVNpDpaEiXJLO928thYoV9TqT/UrKp75ArFzv3LWEclcib+YsOYGF?=
 =?us-ascii?Q?XMkwlx2vGsQrOWCGhqLQO8jPG43hAWb3WCDIuuozs2qploLLxG/0mBt5mu0n?=
 =?us-ascii?Q?XOco6x2/pP02NQW55LRxOR0L79QRM2TSfyuyv63x1xojus8M7q2hq64haHEM?=
 =?us-ascii?Q?VtOM6kaXEU9Pfbk1Np2sLBqvAqmevUwlxmJYhWQ9nYei61OLuVvuHqLBT+0l?=
 =?us-ascii?Q?JwMxiqWsG8gfi4MZBZewYWnTPjwfQB4BAlO/QnMsvY/9x92giCe7iv7NXMej?=
 =?us-ascii?Q?7S1h034pfOBx3fKZe62QQutZ42DDqLoldGIryHpTQGWA4dbNina3QGaJBGox?=
 =?us-ascii?Q?3Lv/FuBnViv3drUdGJUgIbp/aZw/pKk6u3+yI1E8lWjOaCAR91X9ZplWY1A1?=
 =?us-ascii?Q?j2TojiBqppFuARZ7yB9BY1Su9hiYm8YZOOlNUQBJ5GWz4sCx1Z0K41W0wHP7?=
 =?us-ascii?Q?ylvBL4/ZeahSj1bSz/5LZnGu6pG5ec663wWGj8iHpEYR9yagEiRdOocFjuao?=
 =?us-ascii?Q?+axMsbMgMcpp1h3XJej7lGw0FVH1Rgop8szK4zIdgKoJVjTlTf54o+c7z5nx?=
 =?us-ascii?Q?1X77RoBbxe0kamCASjruOF8H3IpKL3CvRqYCX6dNAeHNWRdcYrDt7wZtAcWl?=
 =?us-ascii?Q?pCGKG7E9gl2hm8L3zO6sIUpAM0qKoYNE3jmo0a05zoKS74RY+u0W+JerJO3u?=
 =?us-ascii?Q?73ywvyrzqdzbJLnfbrld0UQsveXL/QqwjXSNrgeGl5fZfY5rbv7mfyB5NBt8?=
 =?us-ascii?Q?nDkQnl4FXi4ppfnkuBP9wQLV8B8+Kqu1JdW+gPmngZuAMEWRyPSXtP8fQAh1?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J3/srUg/S4fHckRllvckUsYKlrr5n1QZegpIhB+Eur+hhDILy0rOxKaro/NbDfBDT1tmydykEvn0cGORvdTyY5x4C1IcTmuAMK1VArOYdjWaJ/cmpp3YJMURLNfnEZB0bfVSxAuC2PnpIinMUyM2rnmBjBkcUAqE3FDH44zLP87AH/DXS4pqWtbE6qZPg2/OwYAB7G3nP4zuGIBDUzACLSgKkbe12MBSdPRy2F2BF6spCgRKWptyThSdzK1cgAQKlU9dEN4zE7fGZ/vXcK5qN5TvQHUMjwxh4Ea7aE3nctAAI08YJoqSz6CZhGBDVBbU5Vd2k5uJ39Nayv6o1Yl4XvTIFmjx08cEMQgu3fGq2pFO6wRp9nTYdErPNg/5albOyRgBaU7vJsCGTUshtkRviCvQuEqj0sga464WB1JtG7I/TK8K0Njcyjh+zSNhty/C6IrVbcCJisG6iA9zOfepoMaqAFHdT2aX+AgkWGo4brhnG0pD237bdUxtFi2LCNzIKdVFafy+rLQ5ASj/s7vFJo6+cEnw7Q+bCq9M5A0MykJTYww/0Wdh5S2tA6ovN7rECQ8Ni1PjsXMPetv11N6b7OqPlbPX7v/hJWKQMtQrT3c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eebb961-e399-4cb3-47a5-08dd149d4e99
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 19:53:21.9705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gE/lHQV7qWM55CvW80CbkJESNWuMVr2ieQF+tgXKfJDxC448BADN1qPXmrV3qz5oDZkpHAYUt+BtaLIP0Nj0DTpd/1emD3zz1ndxFgOgoU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5153
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-04_16,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=598
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412040152
X-Proofpoint-GUID: NTS9iAyfnQn27KGV57gsiSyfBOP0-NnF
X-Proofpoint-ORIG-GUID: NTS9iAyfnQn27KGV57gsiSyfBOP0-NnF


Salomon,

> This patch improves the debugging capabilities of the driver by adding
> more context to debug messages

In the future please use imperative mood for commit descriptions. See
Documentation/process/submitting-patches.rst.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
