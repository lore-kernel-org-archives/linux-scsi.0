Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C1079C2
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2025 00:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742518168; cv=fail; b=OKWlv946CmMEsNe5bjkii9Drg81KDoAWZYnevnObx4x6YWUK2h8sH/RO+dhxbyw+wjtWoNLl8Or0trtFg6FvG3tKw91gLixe5s+AFkjp4iOkaBH701wgKQYdB7PxQvqVF7v/KBmJQJe+/mONKvhTzm+bGB2eFr6a3ltDolfRJI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742518168; c=relaxed/simple;
	bh=qigoa4p08+m4OceFHHWmr0oQGiaCAiGjEKq3T4TMlSY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=oUba3TuaL9kT8W4WsLVzmJs8eBzkgtfAKXkL7ltTj6kZhCzOynpc+RLYPLWLtPwpUdJ+pcb9T2XqMR+Nt1tyqQjnnydDeVSRSjpb4qlFqRu9rrizwNo57VA55b/PY8isZxtvbd2zQhww6r3hkcaLyvrHt3+qMLoEheW0zq5UBGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DLPmclTI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mQHRlcbf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DLPmclTI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mQHRlcbf"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KLB5Nd009658;
	Fri, 21 Mar 2025 00:49:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=XcP7EVEziWIAnOcaLZ
	79IgDNFG6P4zOcWQVoge3Q8ow=; b=DLPmclTIhE7LVe+WEVYg5MXl6zeGAU6y4i
	SZBzT1N+CrRg1HDcQNrNN28BSX4b0DALf5ytqQrpsS408nIiaKc9hfcsYzgdgCNy
	J15hOviSA2KqdYRFEtFExZcrYIFphp43+LHBelEKleoJgAObn5MXuGyG5zBrZ62Q
	R3r4cNrNE45jskpYd2ExMZFfp/AY24PsN/WGdNvieq06iayl7Yvzre2rdOyNZ7uR
	avqqmeGQw8csincJAydRfQ3DBTgzTDu4WAkfsFhcFBckQmmxlfmq/AE8jPZhrQFd
	8bmj85t9VAmVFA16nC39iLZve+cqW8l+DYpjcKnsXcu4Mi/QohJw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1m3y6k1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:49:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52L04H7n009482;
	Fri, 21 Mar 2025 00:49:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45dxm3f4p6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:49:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x1sw1hcAKkaiUYsfMqYTWfWJ0Lf7coKasr93JmYk2bRxa1ncnO3mZzkXz+ZSaKPLG11+uNQWMOLAIXr/s+d9D3fgz4eC1XBVPOv/Tcvqg60TRspMZYJx3OaaOAFYPts0YfuGaONp304yZ5fJ6hBGd+DB6tPhYu1o1uy05lGZbiVwsih1Sb8rwCBSmoagECJP0uINYMesRg1K8d2+AG8lI0KzJSwJzk9NWlebte+5ZAfCsCSijmlYdnMX+s24jbn+TZpe5E4+ECPkwpEEtCZ41xA9kGE/sTe5c9N53F50aPmOm8qyRRavXYiyE0gVR8D3Fm/pdFL2LowebqjKywtKaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XcP7EVEziWIAnOcaLZ79IgDNFG6P4zOcWQVoge3Q8ow=;
 b=ZFIOmsKsykSYLecF797gVFcF0juISYkCC3qKKjIL89FGvThe/N0oADfQBtwadZxsQdYcI12AlNF+NrEwrAsrTY0UQcburN5QEwbXDI8yqDdJIyv+SVVtGJAdc0Ayc6SsDbnpNQRiZ8MA5eNJp+1Cu6BLWuiXovAoSVvlAn46lbFhSg2I8S5EdUiJoGed+/+tT/ZIgA5GQH1YjEWK1q2pWy8UAIREazgMNrcpGSJr5M4UOJm8+Uk1ujETBasZHGbeUG/8eqphbwQBTkabkV+h3nEp/2xe5J3rHkUlyQPiD9NUGyLl8oxxuj51BDt7+e8lOrv2fMwAFgBqwFMDZyocDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XcP7EVEziWIAnOcaLZ79IgDNFG6P4zOcWQVoge3Q8ow=;
 b=mQHRlcbfkgtsHwwr+QVPZDTlHRzCubRB/c/6H9QBf6bPipOkW3naoagrDPTIW0CrkfHmNz2OTC/0cyAq2ghYlsiNA6pInRhtJMQLC2oh5CO08VsRDAL5HRgmAIxJRX1YUyGvdYTm5FwecjCorb8ycpN9NQL3w6JkQA3dvV4tOH8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6675.namprd10.prod.outlook.com (2603:10b6:510:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Fri, 21 Mar
 2025 00:48:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8534.036; Fri, 21 Mar 2025
 00:48:54 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Avri Altman
 <avri.altman@wdc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Eric Biggers
 <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
        Can Guo
 <quic_cang@quicinc.com>, Santosh Y <santoshsy@gmail.com>,
        "James E.J.
 Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix a race condition related to
 device commands
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250314225206.1487838-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 14 Mar 2025 15:51:50 -0700")
Organization: Oracle Corporation
Message-ID: <yq1cyeb9pjp.fsf@ca-mkp.ca.oracle.com>
References: <20250314225206.1487838-1-bvanassche@acm.org>
Date: Thu, 20 Mar 2025 20:48:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0421.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6675:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f922cd1-90d2-4a0f-a9ac-08dd6812280c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vOK2xmJNvN4C0+TWzGweDpT5ufrqgATrd2DaFj5XFeABDFNk+xlImDDHzqLC?=
 =?us-ascii?Q?StLrWd9YRnoqVqngu43t88O9CSfCx5Tan/WAX3QGHWOMcFc8F03jgEktELRY?=
 =?us-ascii?Q?qdkEuNqY/kkpEn9nRfcdoSXYa8MD/XwKjDElDqGr68kO7RbEGOLJ+SENcF54?=
 =?us-ascii?Q?kV3d5gXt3x8KtIPWXGViyCKt5qaZj5GeJPA6JMc3+s/mUYlbSdhwh18g8Du6?=
 =?us-ascii?Q?tBKecgpk7gIpISXeb2qAKOI3VRmR0pdL2MeX3KjDMiwTcFjY8DIDbMZepA/P?=
 =?us-ascii?Q?QhEufSqdmQ1/SSCjuBCGnfsgDDA1sKQfmuQJUV2Fu47AoT7uo7nyls9VCzBu?=
 =?us-ascii?Q?oBgctU3/IMaB2jjz7rQ7gWsqDQK/983KtJhOfr/WW+ZzNDOaiyFlcaHqbzDJ?=
 =?us-ascii?Q?PtKTT5dmpfx6NEW3NHyKyEy8ybLOVbKUUXRwsd/PqPY/AX5zJZCC1kgkjwoW?=
 =?us-ascii?Q?u41Vuz9U13pkOQ63cbZNFRJIvhIxN3i0KfgpIWthWPa+xuHCoTtk2dENev7C?=
 =?us-ascii?Q?PKiMFS2V727hDbaWi3iJaz++/WccwApYj/YcBdsbTkE/8KubODPHqoNcXCob?=
 =?us-ascii?Q?qc2pEa37abXnwI3lf/4CuMGNVWP1Vu7SVDdSH3295I5PtCkXZerZ8vGeCtSG?=
 =?us-ascii?Q?bdOD86szh1QeKjnlpix5yX9Zv9R3Gi3TMi3Inf3ymqTYV+BaPMFbfgyiMhSn?=
 =?us-ascii?Q?QtZ/2FxLV+WkUzz/HkgIrd+OAquAA5VKv4HMpPEvHOW5CQJooDjI6Q+q/sdW?=
 =?us-ascii?Q?UhcPRbDqzPc+Ssg9sJW2muuNLJ4EBQZgq6m3CP+DwqEzyzFDD9W9GMKZfeKK?=
 =?us-ascii?Q?z+0hNSAnvZftdpdtcFx00mz6rofk2B6sK2r2EkK87WVbCJo4WjJqiaiJhBzL?=
 =?us-ascii?Q?AlKQ9/7IGATz7UxeQ+6M6IxV5HE1+sFK/ObVJTxkWJktglJzPNXPXLwdlePB?=
 =?us-ascii?Q?qQsSKqSCiia+W/zoLXcd/rltrZkEJxNUxrMd3imM40W27IM2jlwpRH41GPNE?=
 =?us-ascii?Q?Oaou28rwdCMcfohBIIwpvhjkLc/L6klZU82mCRSDPnLty08ADuPwMwKVHa3i?=
 =?us-ascii?Q?RjXV8kf0YXfangiou49uU/+ZllyUvXgMCe7DSNiSzUxRwp5SM8OBOdMlqTlu?=
 =?us-ascii?Q?5x3aqKezESJh/8rieDOIokVH5TftOp/nBjNxVXwqHYnpPD/ur2iYgkd2BN2H?=
 =?us-ascii?Q?lmU93eaf0D3FvnPkjKZLJwblHOsqJZHmWrAHwTP417pJOih+FNjh5yoNyNDL?=
 =?us-ascii?Q?Wu4RYhteTP+0+slgCqLedDT/tldbLUldbZRI9OjB/Nqv0zDILAfx1608ihJC?=
 =?us-ascii?Q?IKgwoAGoo+7ZHpobbIkFBPDfy0FS75u0GsXros26ErLUVuvT+iNQVayA4GAs?=
 =?us-ascii?Q?tF+8b0xLDkyr9J25ANdHG/3g3xMB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q9k3fvNGDpxvKiyBOJFV+RYv9xha4jTQ2ykoPRN53uaBJPZjFNsaE7HM8hq6?=
 =?us-ascii?Q?bjcTzoy1o58uWhfUNzjXHAT2aF8ezJ0XfwstUQHefeHvsg5lgaqs86/Ggavb?=
 =?us-ascii?Q?4ZLWYSbRfE8vcYUtGjCo/pBC0ZaN+fHbejhL9EYBNyaR6cbvhZQWAkvPG5+k?=
 =?us-ascii?Q?vCSq0ZuMRXPB+TGcYbVgiQy4urTtLT0hHGKMEJnzrc3sqQo13p68d330mwD8?=
 =?us-ascii?Q?HBNrR27dDYTrloR69Lu42TOdUF8bKMa0P5n6jyhuKgSmND9kR3SVyAkKDBYC?=
 =?us-ascii?Q?krBPMq2ofLHaTCHoRJWtbG7e/Hzo6eFycxqRyioxqHz/w7J+IcBoRNBSf3XC?=
 =?us-ascii?Q?Usn2/GVFXJaDpTzDjTpj7bEeAPR+XNW4elKt3rK7i8ryFpCQ8nte+6PyS55h?=
 =?us-ascii?Q?2Py1lghnNGaKVMoz6t33+B8IPMMhBG2wAjOQF/rmLBxUi6IFc+E17eL2/9by?=
 =?us-ascii?Q?VclcyJzLXcYLfiuwWLu/bxIZfs1gulcdIBDcbultHgf2kZ42ME+of4vQv+sU?=
 =?us-ascii?Q?qY1X5tbDA2dMdbrBmYQINTR1rTV23p682lJp9Y5LkmtdL+z478jHzfd6ErcV?=
 =?us-ascii?Q?WcqAsQniQXYfYE+VlDw9BWYuDruLjs5FLP/OekymF3xbBPvDgX0U3ZyW+CW8?=
 =?us-ascii?Q?G1EyhBqTSR+gz1jYXVFxWwelyYpYqDUBHeU1CkrRLjUgrHaN+rvo3mEAXr7X?=
 =?us-ascii?Q?F//VCW5E1w85Zvw1A0bV4XP/XYhSACuydoCjatrPo+ahnwW4kpt1PGUumFI0?=
 =?us-ascii?Q?Otz6qpa0bCMsNzReA/ZCzUnppJmYDrVg7j/s0klArGpU7KnMyaLnDF8Kb4BZ?=
 =?us-ascii?Q?2pv9juLw9e5nWZbBl+g/hgV602tDhyBvNLOMShzD31xf5vK36oOUYZL8JPYq?=
 =?us-ascii?Q?8UPWhinj/4oU391S7QaC6VJGxvhBj+j3O4FiESlEIoKRITfqvzpMwrzD2R1g?=
 =?us-ascii?Q?LsM757NzlqtM8HiNt5WjWSn4OFhb+hnQkAppiIBYUzitVzlMir1HySwHw/cH?=
 =?us-ascii?Q?Ao2zK3XRfYtodsXcN3MTnza39iXDVP/u49GRhEajOCa5ZQqN24d5EIkPB7Ts?=
 =?us-ascii?Q?lY/GiXddGpd5SV8Co3vPJn+sofRscaMLD7TWcncwILI6zHsJZKWU+NTvRAUz?=
 =?us-ascii?Q?hkybiiZtzP6weanJQtDzaUKWJPtvOMRn8Iok4oAKSh9fFKrVBCPwkaoW+IRS?=
 =?us-ascii?Q?zp7RGKAsf/mjARb/KJiabhuKjettYSB8gei8znmrIUd/fLmcea/Iq2oq3Ley?=
 =?us-ascii?Q?56cAtvCDSKYDmMVMGft7U3TjYLbiAOsABKyD8/iGcA1Xmd+xJPjqc6MCD86A?=
 =?us-ascii?Q?maQO3FuPHABbX2zo9G+qqmzTkSpcY2vWj9HfUbIzj4CltacROI3Vqfm7OnHq?=
 =?us-ascii?Q?jP5NY7CIi6DRPoQ5CWMUs9dpVkR8z1lmDJZB4FiAOIr9jskhGtttXcfswPdn?=
 =?us-ascii?Q?RtWD4xhtWsX+PlQpyo2ChE/+o6w+PF56syykYLrMhMxOmJjkFStL8YdIC1sr?=
 =?us-ascii?Q?6J7pRUCYTL0igZLqZqSO1NPKK7FvzmALQNLz5yHA0+lP9LiZKXHnANoxH1sc?=
 =?us-ascii?Q?WJNfEtCXZA1l/8qxdZXlr5yap40CNCrbE1rg1bX1EtmF8pL1axZv+98ywnn+?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wrJ3Sw1JMv438N0vRs1G+agOtzgm3mrFakpwgoV4Lrjbg93jThrOnXUdgjNkNKT/j+zW15DSdfjYfF60ubNcwqEeAzVCzGZiHB1loz4IBqF5OXmvamPW6vNF3HnF6oQwukfnkF+bePg/CdX1o1iAYqH07g0pf8elifBVibgqSBUL+slXW9kBuyo4lgo8IFFUjyr7f0de8ZoxqODq5+G8IJwmsJMsB0rMRmyTay14S2DZyb/KFhTHLPWHnNuVOoMfpiptcgZbDSUZ1SEBTyYBfgTnAqjjEpeHlQpwS+8y9juUp97MfGRzxtBH7q6pmqydJroi1DUzoSzy5peZ1Oh24EiYafhBnr94kKw2fyz8p090yOnHyzDbVYiGMvmX36BnPNHvfW0tk1hQ8oGYXf8mzcONDtH6aUbd8YBv1S3McbapLeAb5rHI/ueJlvXgWuwheLqtoHtfjlFEETkKLuC9jetwpRwpmE5rERsKcpC3qW220l4bpkiC6YK/HHBEU5DjbSrxGQPdwZ4R14TGLghtVALZxCGs/CRpQo9nJNB0GhFbiKsqDcIKcFPNi6n4VeTegGU22iy0XkWfzVscJNXcsaMmQbnk5SDOMohR5n1iZJY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f922cd1-90d2-4a0f-a9ac-08dd6812280c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 00:48:54.8247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0UpRCYEfq5GJ70pCp0n88ZghQbmrqbkiCklDinBzXTynHv/yLmSm5Wo95t0kW3eer4LDZQayfU6cxGfE7C2UGd6WE6BJZGd6yb+O7zAe760=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6675
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_09,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503210004
X-Proofpoint-ORIG-GUID: aOSyvHoXRKD9Gt5n4IWofsh2W3BHCZDY
X-Proofpoint-GUID: aOSyvHoXRKD9Gt5n4IWofsh2W3BHCZDY


Bart,

> There is a TOCTOU race in ufshcd_compl_one_cqe():
> hba->dev_cmd.complete may be cleared from another thread after it has
> been checked and before it is used. Fix this race by moving the device
> command completion from the stack of the device command submitter into
> struct ufs_hba. This patch fixes the following kernel crash:

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
