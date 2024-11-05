Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BC41E906F
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 19:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730836590; cv=fail; b=kvtKqULczYhxduNKSKMgVhOv8uscf8ySe5s17lwAhAOiAOJDHpifRVUezfrWl+vZmoImnuOOeb4KlMPSpiZtDZZFes8V7UFVHuB/ZdJIRXsLvIpI+BDaaA8KwN8xv9b8Ue1zAJ2wUriYHg+XWRtBaZoHDN11PPQMU1c7FeXWs+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730836590; c=relaxed/simple;
	bh=C3rcZpu74iUpUprlGWWTe7H1SuK8fcknu6PdAEK+MPA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TDqjig1oi6i6HNicPNrBAnr1vvrsqyFqih8MYe/qRT500Ug5Ncwa6a2bpfI1PsapSrRjcFwuHMFdp4XzbG3GZecVY42ib9CUc6CR68ZJe5bV37VfX8WzliIQb3eulbxpSC845+MT1rTpMO0IEE64H9xNCDTBNO47V+AXXAc2wFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HhpqqYIC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M2oINRY5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HhpqqYIC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M2oINRY5"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5JYS8H030059;
	Tue, 5 Nov 2024 19:56:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=7FziFtgFiH+AxIBfiy
	MHBJkzO7AUYejQ5K5iyTvo4oU=; b=HhpqqYICE6tcD/bO/A/XPV1wFCKFQOfs+7
	6djgwWs/tB5y+Ei04mfZPwz5xResE6nxW9SsnB1XoZaxNToyNOCBX/JpIcpVFwFe
	874RWDYV2Nx7GIyHVNuxvpG7lzAiMau9zMtyfaSo3AdtqaQZMnjWXAy1g/7xoodX
	mceaOr2YXNTQxHm+EYmjGCi0dl0MUh2/2GwFy59jesu2RVhP3WeUKpPIocOC4uut
	XCHo7L/5EbaKlRO3TBW2fC2oaRy82I+40RhW6jptj5vNCsOoJw3HGqjl5vVBOfz7
	eJ8p0YT+bX480E/QEgATEa3jaqjMwLBHBQyqSu1GMNCZOcj5RT0A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nc4bxbh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 19:56:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5JBmal035608;
	Tue, 5 Nov 2024 19:56:20 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahdwgev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 19:56:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n0W35xtFsMXYdALm1jkLt8UZZ8uPFgV5VbV6AVEnhFeB204xbMGnzs2KRMq0q0Flh4mbr3Qo+yzn+U5rvq8SLJXWYFE7yHh+MOdO/Scoh5VnkN1yyyF3x927ZU2fb8WqlbjGG9CoEKkw2Na50VyJFlnuwJv0SlT9h2G1GYT/qLzTQu1WXZDNJP3RKNDme4h8ZnPwMV7uehZZOsOa8h0+HptfUDVUMUfui8txQrUT4RtaHfJDn2ves7LXb5/7Zdx9bSflr1zl7IhneOnmsXltWb815inc2ntjdb5qr8V991+r5MbYrmEOCCPGfUvVi1Kiyng2KwlraVyVmxClWZvLHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7FziFtgFiH+AxIBfiyMHBJkzO7AUYejQ5K5iyTvo4oU=;
 b=G4V+Q7MjiTDBLpBeL6N7ysisUSIGqAMJRQMOIPVZDu/nSRmeNsFVA/iBwdB/jnflipfoeN6jPccHlebieVlYc0hql5NZAFfde9Zbh6gDFBAkHRos4QZZK6TsINC8KUaRNcY6xoLSe5/h6QusNjd9l7Ay6DKvwbmXpeABDewpc/0ul7dTd+vJu86AnCs8pip3T+Czs716OlBrPSudUCNTs6P3p8O0iV3NCcjaXukReCErHbCLZoKnznZsLkojbQZuF/QcfdhoUUlTm+7rhPaVapaFMf5aicTZoSYKuTy+b5/Z7FoaUxKr0Ml2RbR7hqNrz0XaI8mAcbDJ474FKpBKPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FziFtgFiH+AxIBfiyMHBJkzO7AUYejQ5K5iyTvo4oU=;
 b=M2oINRY5dcWrV7oj+n1bu7NDKakb55oX/S1hwt/FO6kEldpdJuwO/fQdLnGbviX6fEjZuROJl7lFnHBqCZhhEAy+CLq45wVQ3o8AStSafVSXVj5LfxXUzoNWsZY55Nt9daqq63lmgx0QeAhAHF4aSwyi+mFwq/GfxPutz6C5T/Y=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by IA1PR10MB6733.namprd10.prod.outlook.com (2603:10b6:208:42f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 19:56:18 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Tue, 5 Nov 2024
 19:56:18 +0000
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Magnus Lindholm
 <linmag7@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: qla1280 driver for qlogic-1040 on alpha
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <alpine.DEB.2.21.2411051226030.9262@angie.orcam.me.uk> (Maciej W.
	Rozycki's message of "Tue, 5 Nov 2024 18:16:11 +0000 (GMT)")
Organization: Oracle Corporation
Message-ID: <yq15xp14fy7.fsf@ca-mkp.ca.oracle.com>
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
	<CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
	<yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com>
	<alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
	<CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
	<20241030102549.572751ec@samweis>
	<CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
	<alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk>
	<CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
	<alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk>
	<Zyh6tP-eWlABiBG7@infradead.org>
	<CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com>
	<alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk>
	<yq15xp25ulu.fsf@ca-mkp.ca.oracle.com>
	<20241105093416.773fb59e@samweis>
	<alpine.DEB.2.21.2411051226030.9262@angie.orcam.me.uk>
Date: Tue, 05 Nov 2024 14:56:15 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|IA1PR10MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b206bb1-ec7e-41c1-ade7-08dcfdd3e9c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q1DouH0pPOXfVh3+ijeP6IXxjzExynSpakXPrYHkLbAGTHgJk/s5j2H7I4b2?=
 =?us-ascii?Q?1hckguyAiiWa0t/eqbAGlQNCtJ+3SOMH8pqrtajby4c0X3vj5Jym+o5NVY9K?=
 =?us-ascii?Q?0UgNrBfbXojQjkSfUBlqXxtAzeIygrDjWs8ReV+2btiu3zJawjde3ZUr+kqa?=
 =?us-ascii?Q?+vPosY3BvxMD4NqWzGUKpixgmm6vIdSqT8hnj2xShKzuGpsZAgdTIB/OYQYk?=
 =?us-ascii?Q?czga41xAMj8BtSpKX+C+sY8c8Ggenccuu0dej0Zz7ot6GI+8Ii0mC9YC0Xza?=
 =?us-ascii?Q?ROD8o5nicHuUqgktGrnqFjeL7u0FKTw30Tc2a5xQ00uCljlGc+8Fi46B2Gsx?=
 =?us-ascii?Q?NrRz/rABQUUMaS7XXJVajMrvHElwj+dv0E39BgF+Z1WU7vBic1LdBon0JZXh?=
 =?us-ascii?Q?ifhmfH1W1JVjgmgagG9MEVIoVjM0l2xhrAg0NTs2NPJdiKQ5fkDg9sx020R2?=
 =?us-ascii?Q?aDEz1Tac3yO/3GckVqJVFLPOSc1pMrWEzxS22dXDoWt5A0m8+TUBdXZsyEPF?=
 =?us-ascii?Q?cKmU5e81V7h4SCOp+EBMLRIuhSXr3z/2TWlV8cxuEpPM61n2cBNIQxIp9eCV?=
 =?us-ascii?Q?p2HI9hsZJU0Fkm0SZVJT2USuOz6ZZmiId1deNM9T5ZrVBHQi1tP91IkbOiLq?=
 =?us-ascii?Q?DZ8vMQxrfsPQ1L19kfXpYFMjHZtbibeKjZ618rEfdSLFw1SOFO6lPz3pBOJd?=
 =?us-ascii?Q?GQxrNNjQJ3ewKr2AF9iEmpRZoHwp2Eja32TsGUS2meeq+ilr/6Y8J9X3B6RD?=
 =?us-ascii?Q?HYc3gwS9lgoB4urzlnUQt9dd494Ndq4RXiCvm9Vb/Hgz2eWwmAstHk9FSiYN?=
 =?us-ascii?Q?xWGxOdpcKDNPQGIXa/xzG2x/D499a7gOeh8B9255RsbUPcc1M/eQykK55V0O?=
 =?us-ascii?Q?xu1zn5JMi/cSJ8T7oe0da0PBC01a/AXI2y8iOr+Tr10F6cayII2E0Aqdd14n?=
 =?us-ascii?Q?lve+QNoL1LMW/F0m+p9PrLLVxt9v1LGaCS1uXRHIzBKSLiwrzHJbcW8Qsv7u?=
 =?us-ascii?Q?Hf7K8s5hiU/0KO2zuQ3/y5qQ7Q23GlQjHIfOV2dO8ivRCt6MBAqfmy1PmjMM?=
 =?us-ascii?Q?6SlWcQpZ1OX9xXzNgj1SQWajPOi8Jyg0ig38JrCDOdFTL9zYVD4sqgn22aAx?=
 =?us-ascii?Q?jAnvrEZhtIegv3mXJk3ig6RH7DY4wYv4DJdoTyyHpFvukG8b1kBfJg3VDxCk?=
 =?us-ascii?Q?3PzVQ6fTPTbr1Ui40NC/4Eww7ujvGmR96IGadKiHJfeiP6GPfVdnuwoYudcE?=
 =?us-ascii?Q?P5wpSBlD3KWml3GSENdfDKATGmEGYg8JXT8/Z5bQ5sOTJDuXqO9j/Q5tEQxe?=
 =?us-ascii?Q?ShbwfzyykT3sbj0i+a3gdAOn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xTqvcBMM6ZfchmbLwI3LdrQQoJTMYtLrscx8EV4Dey5sQ7Z8KTUSEwVaHtlI?=
 =?us-ascii?Q?jhhwZKMFJ+rNVTrJ0qhF5cJaFaaZMkDCyVrHMJrD1Yhd7CfKyUCQK0JR5uD/?=
 =?us-ascii?Q?w6/V2kt509s/jfGzBQ9zX+IUOk9Ku8QHPrQeOc8YoeaIHsOCLicWzpHUZAPR?=
 =?us-ascii?Q?adIMTr50oxVcAQ/49CQs+B7ONtEkhh18u5uRKmdd4HyA+BMFbCo+ypM6Nzhi?=
 =?us-ascii?Q?F5fklxTgj+4vu7nnxd3i3jJSWk6AJ+zxIDGgyLFWtOJRsBYVN9Itaexj8yXz?=
 =?us-ascii?Q?fPxA9h2n7emDvuIaCdaJ90Yym13lXFe3FlVQUzXSg0Optf5+SAhUyNWLWTZ4?=
 =?us-ascii?Q?sbxSxE35R3iNiSikSq3LJUtr5OUXtzQK4r23xS5S/Z+nK0OulRw21iw2Podr?=
 =?us-ascii?Q?rps9l22hd3t7VsYt6eDNtg7bFSPytcBOm8jmup3kicCzUq8Y0qZhq328DA6W?=
 =?us-ascii?Q?b/L1rbTsF/j63Qx/vgOI5fX/Un9qlrPtGPFcvr4YxaL2I2PdJAbpljvx2X56?=
 =?us-ascii?Q?groKGhAe6wzgzlI4Di9TGJmwF28vMZbjeDwh8iTxAXKBALcv4+S8S9DFHiob?=
 =?us-ascii?Q?5r0+B8A2FqnsStxrXWcF0oSohUk+8czpGdAz2GksYBTgB4a8JDe1scFwAcTJ?=
 =?us-ascii?Q?a/7ueHbiZv78tWQYtFoRBsR8cmNG4XZovs1mEhUm0+gIJDCHBy8Rt6XCdYO4?=
 =?us-ascii?Q?2UFxqHvhAjc4MxIEXcszc96PLoXymmDDa/k/O4LuoHy1CfPYwoGEmw9Twr7J?=
 =?us-ascii?Q?w7+exVmg9VWHG//QZy36js+VE7Y1pA84MWMpDag4eg7ZSno/yzy55FjRve4i?=
 =?us-ascii?Q?2uyVKVRF6U89gocE+r/Njy2r0nq3bNJFYVSzzS0MBcYCv/A0FsRBkV9mkBgJ?=
 =?us-ascii?Q?6OkPeICvps7Lc2SVaeItC2IyJjSBVI4dvqkv5Qi9arPine1ljQKcAJ+qp1kb?=
 =?us-ascii?Q?E4n9A9jv3C5QA9Dx11kk3nYYs7VHwP571DxDRsAr3Wx4y/T2SWSzEjT9j2+i?=
 =?us-ascii?Q?6D/wEfP3ZHw2PhN31PvoSkmmkyzm8hKEWcsGY0Rx+TMciY4Op0Yejyu7ctgo?=
 =?us-ascii?Q?W5G1CP7+V6b72ClPGfyi9biEQnF+weQVhZAhWhUS/pG6Fqh92GuVFEPqubTH?=
 =?us-ascii?Q?XKNyZGbYRYsKC/vXeuzFXUhLi7Gqrj5P7qj+GvNdtECtQ9UzqC5llpQLHVhD?=
 =?us-ascii?Q?IHLkvYTYRHaPSWkEzYJC3hHnZFX7F9NjHzwS3/VPMT7PcYyOlBzdvQCX3FoC?=
 =?us-ascii?Q?D66tIGqvaTXz6rYbu22XQhC5vRi1YFqn0jqHl5OrwKu+nQTOJ9NMrncSnj7f?=
 =?us-ascii?Q?XVDpMzO58RGz6d9m2rsvVOVT7UI6N97sGAPl64Kb/XTqRPQFXAY0M2rldRhT?=
 =?us-ascii?Q?WCoxEOSw1JVnnkvRwWWL/9O+xtJaiK/v8nWjeYaADsK9ovB5eHbZxYI+kJsV?=
 =?us-ascii?Q?32wbK3ySZPPJzoJbs19EckGBM3zG6OBwk7ZE3/Qt2ApTxHHM8XWIvLNShmF/?=
 =?us-ascii?Q?0jaG7E7Hbwy7ILB4lMEMml9btALJTh9dS3pZnmYreyu7yxa5+7BtzsImHTdB?=
 =?us-ascii?Q?71BmRvf6Utu7gEcRS+N6y/08tPG/F3/nWyx3jPwjdzfll+w3WhboriNGhrdV?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JWT04CEwwlYqWdZWKnA9tv+9qg/unaI/LzFqi7CqmnLKd5v9JjUlYpsdzRx3CDU5yDc+HWq13anZYVVJAvYwD5aWLy9mJ7f39K9ueWRf/l2jbb6hHHhzKOvt0dzY4OtqHLrUpAwztcvZIhZp41tJmUjmc6gAXkeDwQQbCGbFo6Lnp4lgtjgrEYds2hQCbDp6HCFvIcq9QFZkfhs7o+N6OK5XXsIkkWBMwTVmLX63/N090Nb5hvCf/QQVk7YxR1EpcyV5MwoDaFn2Zvm1Ydkj4HVBWJ5XgsWd8hJZMp9q4UfNwyWeibWePReZxt5byqMR5y+SdHQVOi6bdFQ9eWalKiM8+9fQ1Y5cFO9u51Xg2Mbxa9HCJGzpyLIEyuY57tLFFSFr4i1HX+dX7BhVQ1563sKRdzS86tDr0Yz/UHejQjVpaG47MX0VwvDUX/xmAQ9W9pvtplZKTlJgaFi+SSct6U69JgeIYuyapkkagJiNw092aMU+Up9eNZNVvPc0kzcVMmzQ9c7zFJugvPJ+kquHJQuDNCarn1noDY5A61iyt+i3YdG9Rv8GmMbl9nYTO1xeTIllviuJMluuN2BiseEoOYZVLjGjLHsN/605bFmTOJI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b206bb1-ec7e-41c1-ade7-08dcfdd3e9c7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 19:56:18.3818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XND9xArW2C+U9tdePlr0XV+/D+Qyl7uZpgqfqr0Yj97Qm/ceg0altutuMktOB0DtInDJjoj6r6ZmsHdk1MWdyW9RSeZ8Z+ELGtaTohIMwEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6733
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-05_06,2024-11-05_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxlogscore=750 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411050153
X-Proofpoint-ORIG-GUID: z8Sxo5ykg56QIwoIOtLyZyuxzi-i9grY
X-Proofpoint-GUID: z8Sxo5ykg56QIwoIOtLyZyuxzi-i9grY


Maciej,

>  Thomas, Magnus, can you please check what hardware revision is
> actually reported by your devices? Also a dump of the PCI
> configuration space would be very useful, or at the very least the
> value of the PCI Revision ID register, which is independent from the
> hardware revision reported via the device I/O registers.

It would also be interesting to know what the 'enable 64-bit addressing'
NVRAM flag is set to on Thomas' system.

-- 
Martin K. Petersen	Oracle Linux Engineering
