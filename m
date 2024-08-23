Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE55B66F;
	Fri, 23 Aug 2024 00:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724374560; cv=fail; b=fRdx9YITkt77wUDGgtKmPiT77Y5qRwhyXEdqorCFG0G1edrpPtKVsLgBSoGTYy11HoQbX7Cvmk2LKu98lvydYugkZVtwNp2dCjhIMg0ntzhA7hTnLB36vBKHmq+1a7az5kwZblv5vWYbDCK63Nbwd0t6Zi4S9Qy9dgpiWdOn3I8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724374560; c=relaxed/simple;
	bh=6dIde9mihA8BZLm1W1Hngm/OrCU60FjghnfnIqfPcKw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=pXFHMaY29l2abssi1dpwToIEe1Hpnidk6RxxWAaKiQK+BWBz3WBO4USBubw2ZEMX0clMrTJugwmLVeteemPUm71k3zS0WpLRxgsxxTj5lU5v5v+W9mptTxsSUrw07CljuFx58EvV8ix1ePl2CGBCJxPkd5zILxvEGDTRv7usOL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=coEvqVx8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i9drnEeV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="coEvqVx8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i9drnEeV"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0Bm91007750;
	Fri, 23 Aug 2024 00:55:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=BXzzUbH/MJIsQt
	YcY6e7KnHHIK30omUf6UEc97xu3jc=; b=coEvqVx8h71adXyrp71l45TsxjdCKb
	RJKpHoUZ4KSUdt4HERvMKaDPPAEdd3WidGwBC47AdqQa1JBPGt40bBm8ZqPLM2Ws
	9y1GJ9b6J3eibt5w1JDWNi/dpRJiDjhCrpRsWWOyQOHAd+qCVzMElFMxkWoV1WZM
	jtiE3Z+3S9L69MZawpTsEu+0OU9Z8D4CRa8PUU3o8x37oE3v1pTOpy0083EZLTpZ
	Aie5aOGO7R5aTuFg2RItsjRC8AalZe4HxYzxQppwuA6UMGRC+gcGnyCw0ErMPS59
	5OSxA6l7KZucPn6Z7qc0SRC+ea38CDaVDjN+Dr1fQ+HZ2km1eoBDTgJg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412mdt3aa7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 00:55:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0J2kJ025733;
	Fri, 23 Aug 2024 00:55:42 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 416fsbgu2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 00:55:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A13X0stwQVJjHEd3nyT40e5XOXNuJtO+AxDwzbEsq8YLRSQ/P/U9URhcu5auH6cCZa+5LLgzbuYwkIarsanz/v/4dLvVIDtNVz+PH6GXnqMjrmwmBKtd2C6se9pNxMKjVrWGf4SfKuKQHf+vcbhZ0avCYSKHijzv0CrMtbEt9s6q3rnd8r/jr262iMGUt7WDX61Iw0JZ1x2suhb78SFswk8TtHbshw6lVM2BoiCmzqLLb06f87OqWjLM+jhLXhUud2pgIlZJoiwGHGdrQrPnqT1zKVV+DveESFt8kV4zn5gzP3q5kLBaMW2rGpErA37qB6XHi12df8HUFdkbuRj8ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BXzzUbH/MJIsQtYcY6e7KnHHIK30omUf6UEc97xu3jc=;
 b=fycGCTv/S5zdd4Mj2OFfAoQdmcNC9yVi+ZxZEE84pICaK0YqYugG4/x9QBIjwFU5ev2S+KgA9k5iutud5mQ6pSHFiz90sAPsrXInMDmVI3gZam6dshgW7gA782YC1h49/OmY1n1eJoxZ0BkZOkcYQVArPElgw7kAum1xx1pWJAfAvXemKywRP53cH+Gvn2HXv07loNnUKMqF0U0vXVuOajq9rz6g/yhaG8KPbMkhWBKuETO3NAoCUy2UFZOozcOr6DVwWGe5vjEJnJy6ty80rcm/J0BEkdVdzQX2evngMuVr1NejS0OteRBANzNGx3Db8XJSq/c+2XgIf2UG/2LUtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXzzUbH/MJIsQtYcY6e7KnHHIK30omUf6UEc97xu3jc=;
 b=i9drnEeVqitXsK+d7t2RQZZA4ycSZJHwKB92TQzbxffZ75LqU6B6HHm1tOcwBF4tMYv+M5T/gusOM0DDAFZtGmg+6b5qu2I7axioikQ1L9gFuAG5aO1icWE/oi5Y12rAKg24NDtY9+Weh1+2Sv5st2+nKy8mNDo7lEJIDINFvsw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB4916.namprd10.prod.outlook.com (2603:10b6:208:326::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.17; Fri, 23 Aug
 2024 00:55:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 00:55:39 +0000
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van
 Assche <bvanassche@acm.org>,
        Johannes Thumshirn
 <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH v2] scsi: ufs: Move UFS trace events to private header
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240821055411.3128159-1-avri.altman@wdc.com> (Avri Altman's
	message of "Wed, 21 Aug 2024 08:54:11 +0300")
Organization: Oracle Corporation
Message-ID: <yq1zfp4kqhu.fsf@ca-mkp.ca.oracle.com>
References: <20240821055411.3128159-1-avri.altman@wdc.com>
Date: Thu, 22 Aug 2024 20:55:38 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0381.namprd03.prod.outlook.com
 (2603:10b6:408:f7::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB4916:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b0d0c51-b93f-46f5-67c0-08dcc30e4eb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0x6bbbKHVNC+mqfNOgDdi8Lq8d/wBiMs1YwfHADZ4faBT/+vgMbhr898JKyF?=
 =?us-ascii?Q?yOFJgIg2jfm7LT5yquQiSYyLUDWBbN2gNoAjIUMC6fmUirH/EVFDui8QDj31?=
 =?us-ascii?Q?LYUr17mvVbBviigqbcxW83oep2iLLUdseajsTGL0TCtOP4OjL6RVh7aTr5/2?=
 =?us-ascii?Q?8tYaw1ajMmQkKR/Rkb/iCoJ0OYxHGDBpD0z/YaYlI/+1FN3J6By8VqJSSvN2?=
 =?us-ascii?Q?zYQEdQwS0/RxmQnLqx+Yv9xti+WWmEstRzQ+XusedusPl4hnK0wIiuLakmZT?=
 =?us-ascii?Q?rXHCvV5QBpNu32iQUxL0lIn0VevglcoCiSG549GzYdRqPazmxM3O2XDv3yjd?=
 =?us-ascii?Q?L9hVzMZvWxXr2nO8PiHsIwtQ9d/4qqkSHy5dTl2Rk9RYyrWhotH+DaqYdM70?=
 =?us-ascii?Q?BgKrwN6cK1NwWTWwqT7WBNGdGgb9iNeJfkwQPAV5jMs8kO2KxKcB4nQDP2sc?=
 =?us-ascii?Q?6wlJFvm52vEG32zoNoJCcxsKl9CB/yqCGevcdrALk1RutXHx/rs9IhnIjQMy?=
 =?us-ascii?Q?P9k9XSs+ZieRSqwlW6mRYnfk5ccLzAbs49zumt7yQyoAPRrIRvzh7O67OUl+?=
 =?us-ascii?Q?2+uK39entA1DeRLQRxaHkmEYhKj0WKoNsOz4bjtK+VpaOo4HPqdsCIydFKpG?=
 =?us-ascii?Q?9VuM6v3LuqEk1yo5aQ6eHHT2p5XF/Jlj7UwI4zCvACXjrvAZUbffP7zlscwI?=
 =?us-ascii?Q?B8ihmP+WzwtRBgLVFcP72R9Fwv5dn1QENGhmDf28oy+inCheBgqYR2/KTlJG?=
 =?us-ascii?Q?5NHxvC+Wmphf8T7VFhVKhwKQFB3PFxwgf6jrl9t7UdTpf5Sw+JTHcwRh/g88?=
 =?us-ascii?Q?X92QERK7/qGtVtXffARB/iC3nhZC8EO/sCjPpdV7yuEw5IS1PDb9Bnq4fhJi?=
 =?us-ascii?Q?ID9I2XHqg34OuzbgJjFQP8gpUkozGlk6n4p5sdKONOyzLTyavmaGPF9O3Bip?=
 =?us-ascii?Q?pUguBrhcBgQKzOKCuPsktugx8Gzh00NJt8/+GJM+2ALwMyLzLaHZEfmstwGE?=
 =?us-ascii?Q?U1VipkcOosm8aeS/sllBkeJZHIGN0b82VxRHYLV4pBQGuuvWm6YkgvRsMca+?=
 =?us-ascii?Q?vihK9hlHl/C8smdOhhxd6mfECNq7lfXbfegdbY2c9PG20Ty+YAzamQuSZ/l7?=
 =?us-ascii?Q?n21g0cL+OMJ4E7GNFXb46zeGLkSXz2c1+Yf/WIvws4DUo1XnekeSvRquuIhM?=
 =?us-ascii?Q?GupZ386CrNLlXesKH7vsu5VO9nfndkbvbtEQhbSCT7xr2dp9FshcQ9TDS8k6?=
 =?us-ascii?Q?+qWqlX/ScCOUOx5OZkco06Ssn9Ykq1XXfkffDzNL6csIQxPeaWcUPZQNL79/?=
 =?us-ascii?Q?7v7nl+9dHEAyLU/ty/K+mYpwSab9hcOoa++j6JyhwonhtQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gf00oGYQ9NAVAdzZPyxGWf/P4Yzk4iZUL4rrh45xdKU+cy9NB9N59jw5nTHk?=
 =?us-ascii?Q?TkqsCnKBkic45EJ2TX9yq/vwwZvfoDDqdp2H2XuIOtcC4AeOl99Vs+datctl?=
 =?us-ascii?Q?fKHgHeFXXFls1CJrg/TqVpkKcArStbhsZEWcgXKUgtjxWPaVepM3K+T0WaB7?=
 =?us-ascii?Q?hqOf/qSFh7+cm6CSSajw7764ERvDOob6eRqO4cHh9KN/fIr34/qJ6pl9Sax3?=
 =?us-ascii?Q?HFv/xSiEIBCrWk8he2TfepShl6s2jF/RK7PU2hzzcU2ch2tWG3RvXfert9Mo?=
 =?us-ascii?Q?ZrXsWDPbvUiswzSAmEnhXh6CodSbiFgRgFKLWmnzWn7jfpSCr+dJc716myQ0?=
 =?us-ascii?Q?rAfv3Y9b19oyA9taCAJBaZ5v1R9OF2zmiqEnmOPSegrbCxMbJKy71GZLV/x0?=
 =?us-ascii?Q?ggZPSgFiFpUIRqWOnhXADuhyzKPDhmrT44UrK1Zc+t/R4copcKozml3WZnxI?=
 =?us-ascii?Q?N7vQ8oAtSo0R6lNqGnaeXY4fSt7w+Fz3aSlfuA+Yl63lM/B9vDmexirJXEm0?=
 =?us-ascii?Q?FlJ++w3Nl1bZYfCUKlay4aY4n+9pKHIa2LQ4+ZbwUp3/Vh3DMwMioTl84HRX?=
 =?us-ascii?Q?YkbQpRQlpJter0156j4kPO+1xrohHQttoRsDHURasj88cWu1T/usxvUpLcWm?=
 =?us-ascii?Q?A0688tEXzqpsAO+S6tA6FtcONHk2Qv7SHf1HuBBBUrKRR2kanybD74d6LUXa?=
 =?us-ascii?Q?Fs+3L3VkHS9cH19n8l+Pn4JATedAU6vV42IarCbpL8cdzoYu+2mpO836o3uk?=
 =?us-ascii?Q?vfVB2ZGjC+H+HKaP4J5wN4OIf6mQO7LZvYACQBO2Gq30XG/ul0s5ViBv4lyr?=
 =?us-ascii?Q?nWtyVwitUZmf+oGDwlAPlGiN7vLQm7pLZU7JCr3EgeNj2Vwnk5qmnb+hbjwn?=
 =?us-ascii?Q?3hoJR3+HPFYeZlUaGXrM9Dppmbru3zRQKmFGUqkyN43A/jIVQRaEGQBcrgFG?=
 =?us-ascii?Q?0YawwMYE25O1+GUlnEAo0QmD5qYEsrzlBbzAEr5Vff/PtDXjeOg93Oqn4u+b?=
 =?us-ascii?Q?7MYgnbsD7dymRGlaiDgKarzPm2ZK758FGhJNdD6I/QI2GzRI3Bg/D2oHYTMp?=
 =?us-ascii?Q?p09bog4ATTouD4nRCUYfCgtS1LkR5lhdhtNMh0yYmfsCl08hODUIJTU5PniV?=
 =?us-ascii?Q?/q/Cg4Ww4/G2VDsuXqSqBttTQq0zE/aojVWKi97xdwNzDg/hPg2GljmKvAAV?=
 =?us-ascii?Q?cOHXDMkBLLYx9uODEhrj85NEmrilLGHL79o3uay1M68QwixQ0iW22xR+s3O8?=
 =?us-ascii?Q?vdBXiNCHdIl2adNVrF+tN8gtjN7ipwQ8zxbAKMlDzfAnMI5i9bbNdnaUvtT2?=
 =?us-ascii?Q?ae2lk/GTBiFID6EwJie7NEpX/6tJ2H81svJ+soV9IQsRGWE096bV9TG3gfuz?=
 =?us-ascii?Q?3nGwFyHSTCDrIMEgAzvnnGlhEpMXAbxt+qdresb/J6KovqV3uKeSPypXc5S/?=
 =?us-ascii?Q?3nxpkT7DcE/Ai/8cHSkV0AW8wSbtJgJ4aZPLpcjlio1sL5Bsk/kbFPH7OEzh?=
 =?us-ascii?Q?h/bk+of3FJzm50oVsmzu0l/2fqdD4GJFs8+FbOajlHZsD3e6Fq9Re8tiVOlI?=
 =?us-ascii?Q?6FmrdeVFYBfrGWftZC9gmL1Y8jAAf2TQVn5UgUcgfxZ8xWTKRzkY7lv0RbgN?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nPXbYYMbcqyKR+YNgrRwLa2nXxgCbjzsQQ1JbMQ0xr5uX+NwObF0E2GDPl8MRr7ERAGYjZBXZNahy4GiMVey9SKIPcyfJI3ZCiQhIgmzGz+fIkpz4/xJLQTu4rJa0iH7neGYpfLuZ2+CY9SjGnHI6+z/R4z+z/b5wgkE/pH4a6cafp5unjXLzTyftV1eIrCZ64T5iI7VdDb/YJqZ9KUnL85S9GL4tFtZZaz2b+UdyWQ2JDSr9Ppc7xlFQVHm5RZppMEPpbi1oOYkKjJbQ2ReuR7+r+oJnvN9Ns2gxgwMCNduEfhq9bQau2jC/PWvFyOzJv7U9KbiFJeDmlPF3y4+EG1NzirSdRoAIYZBJ0nQjtF98l6ntI2ELIhm9GsrUnu9P6E7dy5ODHuwrJCkLvz08jBHr4Zue1zUkOXTSdbkybl9VHsIJlJv4HQG/CSevKTyeChZdEJXohPoDaqBm8kEUIyx+5sh27DerpNE8en4JGiY2D9CI6W/jUn/Naby1MBYaN2OrCG2samkgw+lff0B6fiFmYRVW8/WsmkxGoi/IWu78kY9M8+WpPWBvjaPGGO65+Y/iXHi8arx15J61QR4bTGrR+HSUHfJzEWBEKrENMQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0d0c51-b93f-46f5-67c0-08dcc30e4eb9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 00:55:39.8812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFfEgSiL8z44JOD93DhW/yvJsh0flf2nSTIbUzq0iIaBak86SXy332qr5TDjf8QBUegydC63kEY9v9FnLH1Ha5exJYwF5NSmhyOiLS3QsVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4916
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-22_17,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=853 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408230005
X-Proofpoint-ORIG-GUID: c3oe-71k3toMmEqSpHxFTfDE5oJ3Ce_5
X-Proofpoint-GUID: c3oe-71k3toMmEqSpHxFTfDE5oJ3Ce_5


Avri,

> ufs trace events are called exclusively from the ufs core drivers.
> Make those events private to the core driver.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
