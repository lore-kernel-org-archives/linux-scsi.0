Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0B81A5B9C;
	Tue, 29 Apr 2025 01:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745890307; cv=fail; b=ptWNl62F2GRskbzKWHfVV1LoNNs/fyqkAqSmoLwzliqR28RdGxtS7vrKKFzjkiUuQU6jQJDyLmEE78lHVA5nvLI3OdCdl28MvNvyjWDK3kjBOHi24B74C49VHkJnAZxny7y/arzLsfIS+R75NkCKVRlcshu+RQWS1YJztFMj7GY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745890307; c=relaxed/simple;
	bh=l5V2nPtFvdvQBw7oYzegAnJZefVxNxw6sBgtCAlQQwY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=swp82VRoYESWBILW7FfGbsxQlu51ie2MYH0f4AL5Wwe7ytkbCAouSDxK0wjyYdvp1w134PdfqrOrphhcim27AqU60xH7Mboa2MHxP0t15POFFg3bIpyDm9pRBw47GcQ+jDS3/gq+mtGSbq+/fqPyMManO6P/Qg8/9gEjNnpes9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AtYXEVmz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0S4jhOET; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AtYXEVmz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0S4jhOET"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T13G04028530;
	Tue, 29 Apr 2025 01:31:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Etqs3p7bP6oqVa8aMn
	y0VJTZveydRFqB7BGm2D5ytKE=; b=AtYXEVmzZMvXtwv3wra6WstL/ZPQ+Byq96
	LGHqhXAZb35RdTMqmZOGO730iI9CE8foYjD0TNJVp5EPDdT7vZh/STdG5wW711g6
	ApQ50sNnKYe90HJMq9bo8Wm7HuDi68jS+pFMMZ3xIlwg4VcQunepxb0ZEF0jTVBN
	aDMpD2KFyVrHTtefFI8hAbiLh11WcK+LbSvCotEyDnFx1PCVMa7pBMnqfv4IQ2K3
	/BLr/mqRY1gxoY1GL/gl5OO3SyVB3+UefSBjAR5uWPy6By3QpN7ZhcVKc+QUfZ7E
	KNN6Sm8rUgOXZ3liUepqc0KnTEf9skt91HKdY9JUiNeYbF/Xy7lQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46amreg0r0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:31:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T128UY023842;
	Tue, 29 Apr 2025 01:31:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxfed6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:31:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f2c276yWmFkih0CHcwwRG8SXcMQqwzp1uH6iIuyfIW/lmfHrP1Ii4Xk6S/EhDzHQ6irOYWDuKLi8SpAtHmrCKEufZ6xBT5zUswIHmDudjNTV5veUIoUxVH4WlxyjF3N4jTv3CrKzxRoIiHeeIeNVtD1Kafpaern5mKaN0CEyKRA4JarVXVRBm6AnVW3vzWy/LQq4pgC+EpXPVVqRaK7FjHYaWMsXQwOA4btf0estrH79ttZI9Omc4ojufLfOU7kbYnU4AV3MWf33UIV52JDk2n2cIXKUgIjpH9uuWwPx78hOye8+wW7DBtrIBS0C1Z3A5C2X3TlHW7b1CzHKXE54/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Etqs3p7bP6oqVa8aMny0VJTZveydRFqB7BGm2D5ytKE=;
 b=xyi8UaJCEQ605s+XEgNy4SRRdPyoOJRYHWVpCWbFfuGMoV1hBwM4TG+aabdnJPWW2b3fVH03yTrqH+PHe4Owu2iII7zjkStfwA3lBJhMDsP1SIBC5vl4M/n5YZ1rdwddaF+5jips3vS8DSFV3lzVKrofkTT4or2psTiqCq7TyYvDmY9mfXhOGsjOPK1V2mnPSGMIhDlcqz8IspEvED7+DIvZhVGKqRjJiFjw16VlF/FyKc+ZGvVxbOzEglLPlIOvxoKwAGU6LMR7k8D4Qu4FfBG/glnFihWStZSBThosnecPHVW17SaaL6VrUWypYsHwfviNbucUrUTVlRr3dnIKhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Etqs3p7bP6oqVa8aMny0VJTZveydRFqB7BGm2D5ytKE=;
 b=0S4jhOETITS9cnLxiNc5sYallTWGrMVUi1VdFuTBVt0DvaDuxil9nlJG6HljRD4DKgOnob7OjQm2MTi9Z2gUnpwAiorUwrpheCbeJyZjWuzPYS8LgKITUXYvekZRoaTozVYnflhSMrz3vWggRgds8IRoPq/DeCCZGlMVMdpEh3k=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 MN0PR10MB5910.namprd10.prod.outlook.com (2603:10b6:208:3d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 01:31:30 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 01:31:30 +0000
To: Kees Cook <kees@kernel.org>
Cc: Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar
 <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: Remove duplicate struct crb_addr_pair
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250426062010.work.878-kees@kernel.org> (Kees Cook's message of
	"Fri, 25 Apr 2025 23:20:11 -0700")
Organization: Oracle Corporation
Message-ID: <yq1h6273g9i.fsf@ca-mkp.ca.oracle.com>
References: <20250426062010.work.878-kees@kernel.org>
Date: Mon, 28 Apr 2025 21:31:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0032.prod.exchangelabs.com
 (2603:10b6:207:18::45) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|MN0PR10MB5910:EE_
X-MS-Office365-Filtering-Correlation-Id: d5cba6f1-0acc-4be7-bd26-08dd86bd9193
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1zdIn2beG6qiHoYJGlMI7uil6x4CCf9X6GK/0R+mW0NqUc78Ot7ARjZT4ztc?=
 =?us-ascii?Q?xuFQ+b/qCCajUKiwTAloTKLmF2JB/JNurtJvhEA0YGbTp24/fo4A4UCRv77y?=
 =?us-ascii?Q?h6mR8aXk4bhK7OrYmA3zXYg7BAxmdRq481n+JzxgXvMm2RdoxYmLOctz9kBX?=
 =?us-ascii?Q?1+GKau5TVABQrgZeYXH6UYOMuP/lKBYFEiCnAEhE1poDQDAPa53S68Stpz0F?=
 =?us-ascii?Q?I8u4eWpnwEHg3hq/qy2mLfjNux9rl8KSknN4VnnqY9Fiqx0p5cIOu/oE7ZXL?=
 =?us-ascii?Q?5ikLZwLEbpoVDNevyfATWiwZTzV3mUK6eLcMHlDoH/LGzoAE3BtSX7kFC5go?=
 =?us-ascii?Q?PLL1q+BZ90Ji0VECy4Vi6mJgxlxjtqHQJEbToS9YqF/wMBo4MGcW8OakxAZT?=
 =?us-ascii?Q?gr4QlR35llQOKUkeJB0/wgFTuIP1BOjeuS/yzywJPq6QtlhWNzJJUiKj3eIp?=
 =?us-ascii?Q?H6/ffWTBHTIJtrPb5sdn/JupFcuofIKvCpb2Mdr4J2UOH0ZA8BeDxGplWjRL?=
 =?us-ascii?Q?T/TE6gwm87ldkngqMy1F80gL8wI8oz9t8EJBCUL+KhEElHGNSNR/qLQJDL4K?=
 =?us-ascii?Q?NUm3mk7azyhYJX4xIsnjAg9+7fZ+H5VBgZIOyvUN4HcmvXriaizipiXgjf3n?=
 =?us-ascii?Q?gBx6WeWUeTtGVBdsqlDdcj5LcFUP1cEifH/F1yEbZEKttAxb9/u57Z6WkqVz?=
 =?us-ascii?Q?3LHSW5CmAL79Sk6brSkw7tuhKHyDtiedAHwucTnaW77O76X+ryHzyTLt4Gd9?=
 =?us-ascii?Q?s9fjck8Ty9iHW3wO7QnUeP2uTYjMfbYDT3+c8S0I+4frg/j7WSMBRDZudwmR?=
 =?us-ascii?Q?PjTAM48ycINDBFEcYKHHzMIkM1kSRAvr6HLyMgvXqqSw/3u0TfdJVDSfMpKq?=
 =?us-ascii?Q?Kk7aX06gyQKLJeVvwwcom+lzful8IR45SmZJgSr9/zzYQSA6DPqMkNylugl3?=
 =?us-ascii?Q?uYiFpqdCq4DYqfVsiFJcIh0WmtkO2BPevacSSVNEBuDvcGpda5OO03E5HNEn?=
 =?us-ascii?Q?ukvPkzCkTtLgjkAgknWKuPKaDAZxBBcM4FkEYUjosTyQ1JvQFVmUPTIPGrQT?=
 =?us-ascii?Q?IQx6bR8ObqiBs3T8nAB0/GJSw/OwOiCvdZKIL4ZLpLGAUJoxU9ymSS6N1CWL?=
 =?us-ascii?Q?8NNR2FhLKNfcyJl9b9yEzm1Key9jESO4Q8Egcb3bOdiA7bGbgCLz/ebzJ4JE?=
 =?us-ascii?Q?vXw9wB3VA+oaepIv5DlnPzm7dc2G7eozYV1ZnsGPfAMWO9Wrb+Rj9Jh82vg3?=
 =?us-ascii?Q?AazMwI8AEIandpQNeH/tX8JqM3jS8p3q9g5Roogr8qqFaZ3mbkl6PfUSN7+u?=
 =?us-ascii?Q?Dex2haUyswlvXLWCfZhl73/P9ZOxLnPP8nhWCcK9t0bNQhSpZk/OCV6Cd+m8?=
 =?us-ascii?Q?FBEMEL94H9HDqtIgRXF2QzfN0tkw7hqC48G33rZ0Z75ZwNs60+sMdrbIEqze?=
 =?us-ascii?Q?rNPl58ABbro=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tafTmW1nuJL51rdXGN51ej/t/h8Cj8LgPOVwX4u4Csu+ICwDqbkPuRr8IaCF?=
 =?us-ascii?Q?cBDfuFreHRLhP93EffwkeROrC+5neaAG60BjoBbdLcchA4EZKIh69BJNQLiJ?=
 =?us-ascii?Q?dyLia25ZEf6cGh50b3W4kgNgLIrOTjfjcbmXBcKOZh0Vw0cAPG366C3hQJrf?=
 =?us-ascii?Q?Olvu29HgVMgvQ+INbp0krS/CmOFR4UGUrl5713wDXBIVgGEgem6I8XfAGn9J?=
 =?us-ascii?Q?er8IomIfOiF0b6Bi7cgxNqJp26xj0m5/1QjADWFX1PPjOXYZHq1Dxf2CllcR?=
 =?us-ascii?Q?Hc2abCUmQqHTDmdKvL4Qt8vR0DUKJzqpWyDVW2lde6YkUayP8Ymrdsa/wtsD?=
 =?us-ascii?Q?5sd22dhV5hITewlYu4iUgSg2W7zK6Ue904xctCt550b+wqIlKJN8/fN4uEHV?=
 =?us-ascii?Q?CUDPMRe5KfZhtaN04/FRBtcJvBEP85R6tSy+3la8bJWWSqOyRCFATJaGEfeQ?=
 =?us-ascii?Q?YjEx5gX9epuGQ1MWEOoqH3Mgh1dCE+TDTJAqsK19q8DR4IMHLfTg0S9PKvXl?=
 =?us-ascii?Q?IEJaLCaUxUjgwkoLaKdslPSY4NV8MtdmAXaF2F5K/XeHGW4w5eqnL7WuAzRf?=
 =?us-ascii?Q?d+hu9h0nPJvTwj9CxyLhtPy2U7NvUsVyPB4iVb1ByQszet9M3sSFw4mm8uid?=
 =?us-ascii?Q?aL03EpAVws6iFonRwr9wDBEK9nnOgoC/KuGd9qSD2wyMno+skD5adHh0kfJd?=
 =?us-ascii?Q?xrzNhc0N4EonIKORS+sIHbgdoaNOffIKXi1DVCXBECCI1OIrMP61s19Tz/R2?=
 =?us-ascii?Q?t+Fdt5IWjLX0cBUDf0TA0xNb6sBg9Pg7FFzHnWV9YGiIG3w/yLo74zRKRTEC?=
 =?us-ascii?Q?3dpExzuLq2K/8MhLF/7yICtIxfQK9cCIm4dVPtLi1KwAllokMt53WpxXRWFc?=
 =?us-ascii?Q?mtesyLAKNCCKowkS8ua3U2LfW4DL3sBslPRhOlvygFb8lRm8s2Rgtu8ZqyoP?=
 =?us-ascii?Q?XTk0QgBNpWMokyKVb2XCXe2qHEOuu6f+KRbH6DssucjhbNjdaYhhWF6G3tjX?=
 =?us-ascii?Q?Rk/NxYHtrYkPuGoTfvmJiDW4BRug59QLzJcc7rGoYzQEwgIRi/F5r0tpCJBX?=
 =?us-ascii?Q?paPsieYytZAlyIi3gYzXmOVyW+7EHffdLK68Qq3O4yoiUlK5rYQfHcNlPdK5?=
 =?us-ascii?Q?4ecNZl9YLikK9EQNTBKEG1J8WFNqGrRVpDC5ykPKGwonRxsvi9XfL7NOJHzZ?=
 =?us-ascii?Q?CsmoCDiYbCMrWk5m/rmjOeFBZAJW6VFhrZ2jdIOt7WsXXi4tC4/W043RE55x?=
 =?us-ascii?Q?h5uLU9zCxvs3rwiTufHtIZvLcGT7JfgyIBe+dnjfqmcn5whcoPViCerGU0bu?=
 =?us-ascii?Q?0tx5HgKJ7vAUCqZr4TL3HJYR+8hUrTh03xSNzy1eiFkPESPdM22jZ6fgEk27?=
 =?us-ascii?Q?CPJw4FmtVdvxHC1/Iz14wsScpFKz6yXaXGqjYaTnrONCpFpMg/Mosx8rstlb?=
 =?us-ascii?Q?C36jEtS672BxWQkr6IsqpO41VkeEDJSmcqOj1vLvTRV+8vv+FhJLYtoToBhR?=
 =?us-ascii?Q?x8Jc1kVDYBK8z9Ntxzhuwp05X9wbiPRuJLftzD04KFVMsB6+f8R3amfYqong?=
 =?us-ascii?Q?9kkYh0n4TuKuwPO4qd8lPQFG7x2SmoinyurL5YA/evL4VbWsQRfDnp7BDczl?=
 =?us-ascii?Q?lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cdsOFjMSIxjIO5bjhIIK2axe2HeoNKXzhidvUxhq8rW8m6g41PiNYM8JGrWf9MQ/sHNaq1qxXN5ECO+xu8Ye+EVLv/ISAqy/2HLoHh6j0OiA8fFC+1L9bDFmu33GPjSxv2BSOrAT0V67+wEY+ewG0hkEOxIjmm3SFco35MLk5qGlmg9DuVuN/wbdjTU4M3eO8w8+mUiV9ufXJXbZydlaCe1Hna/o5Y4X2cRQA7KfKrN5eOnpArDbvfzriAGaxKP2t5aE/Lb4kK2FQFnPnH/5KneQU8y0YgDxAwNqwOTF47dD4n1E8DSe0fyZ12QAy26aDDXB6DD6jsjRGvpMjAvVCcvxYIC2y8unjjhxN8Bbms/QkuThLXK4PshDat1PZn1GP7plPegxOG9sKhCSOxmelnwrZIjVng0e+Dw9Gbx/ALiOTsRys8wBefTHD0jZZzv3l5XRCiFvky60bravMrsZ63VUFmOM5ErFIWTEmom4SQMjCh7tgwljkTb9gGF5uGXP49CxFPmNEfdXGoEf0Q6WErHAuNdoETdrFE+3U7zbZ8B5ZehU1Yb5DtZ0DQQkFXO+HQMAyTzKL5UiY3Eb/+qds93lm74hst6ikvFYpBnvZeI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5cba6f1-0acc-4be7-bd26-08dd86bd9193
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 01:31:30.6799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RjpwVudoW6zL/dguzWlzX0uT0fzdJbhMT+hA54mCo5a+vqMbFL4BBPrjE37zU1zxMKDavzFMhbsJJncEo+3JeQCqZ0q16TL4xvVRyEC01q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5910
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504290009
X-Authority-Analysis: v=2.4 cv=EdbIQOmC c=1 sm=1 tr=0 ts=68102bfd b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=cNMCkp2XhuoQE_LABBQA:9 cc=ntf awl=host:13130
X-Proofpoint-ORIG-GUID: WuapEAxKiUO69sV2meNA3JBCNJ1sF0Fy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAxMCBTYWx0ZWRfX9LjLOOF4LOo4 ESWMc7YYtrDp9jFhtDfN+LDaNPD7aKH9OUuM8/SMSjF35o8Jb2VsI/e4MZlvfgK7nhWP+uUTt1n tyTuwDl8edYWr1ebEhI78xb8OKH+emhaD/3r1gDc+CgI8pwjTytlzip13+Lfgfqv6bJ3Zkyn4ck
 kD8087oBBN/JjMVxS+MKvaB5Kk34O9f7BI2ItIM/n+Mln+FNXFfA4RNAIp/8vAEa+ndgzoYMUrw 7e7tMUNuA3SFbtCxzY6xo11Yd4UYF4K7ltjYGQxEja7LRp1gIfMScS9Tsxo8B7Sg2S1vPAlQcvU mqStJpL5l6s+atkWhlakCMW2RkXox2yZBfGumGAJaRfRxS+V7f0sshxSGYYf3CCXVY9fVf/7QGW wHMaUlJs
X-Proofpoint-GUID: WuapEAxKiUO69sV2meNA3JBCNJ1sF0Fy


Kees,

> In preparation for making the kmalloc family of allocators type aware,
> we need to make sure that the returned type from the allocation
> matches the type of the variable being assigned. (Before, the
> allocator would always return "void *", which can be implicitly cast
> to any pointer type.)

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
