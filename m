Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E9D155A2F;
	Wed,  4 Dec 2024 18:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733335604; cv=fail; b=mbM2KfSWAsyNGoVvwQkfd/xs4Jq29jRNYQK3TwojIbKsqKQMQrFRz5EXAkxMRT8wlMlBg/Q0YV/bij+w3/T1vn4wvGxiEO8lKPpi57ND+qVchuguLwU4w+DQaNGQcoPmKjkDBOl5YmPlr8a4KmV44ifM4OvoIPaOiP0cWWshCu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733335604; c=relaxed/simple;
	bh=7NYGk8+IqzxqbAso1lxNyhRUmv2Jatz6v1EhUvzunHI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gRizktw4UrWmRVey0yL2Z0PRcWLlAgUiqqVUpye8X9jpKzvIHf3M0NkjTZswvZw8vbyxDo3BE/hRi41zDbfr+JGpvLKrbFvDQbztDiDJnAo3sziWNaTsKf7mR4hmahQLI8ryAN9uc2RumvhE/BAneNdZPWrQzAM8YQgsjkE920A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TEDAuvsQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qeP5k35r; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TEDAuvsQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qeP5k35r"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4HtYUt014319;
	Wed, 4 Dec 2024 18:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=gxwH8h/CeqkdlgdFTh
	3L1QpbfBi5+P++wQ9G/ib67kE=; b=TEDAuvsQZEPr7RQgoIICwooSIDpXJIJ3+C
	m7/eNjsKxcbsoZBsIj+LNRbvX+Pfm0ZeJBK8sOk2D1OQlc8x3cm4dPAwxewtE8M2
	7PqUL+oQigZYK82u0vriOwdMNdSS0I1HkqJL2nBr2p6vfPRiQLEAdWwTdaGXfpLI
	/pz7kLHDShSwGylff1gHL9pLNtc1H00VG9hSaM0cy1pO+piAfdOJjFo5qExi050m
	uwUwPnWveaG/UOXHNX1rqaYtwU4M2C3/hCFrUPPS/tlZcerOWPR+2xP4yWVxadXz
	eEM0fUUr3rb6+98hDqJWjXHDQFjhYZHwzC9IV9rqeUaGKEQgaXzA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437sa01489-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 18:06:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B4HiPdG040091;
	Wed, 4 Dec 2024 18:06:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43836vrbs2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Dec 2024 18:06:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hSSM7eOnMRJbmk76W1bgfztsujHVdlrlmjpOjlbcDLgMrcYWuKBw3IGb/PHHBOLSItiJAbuZR8uxMGeXJjqGgzaUjNmLxxkB+Das+05wgvIFVj4ZxHScvF1C8aM5wTnEiM7m/Md6ZHkvuIcZhcT7GOIfXxDnvrVtey89DO/2HidOfsAp0iqZi2EE/FkjpWnVQ43VZhe7rzPirTJ+t1xQuirkIgjIPgADhNyYf3DcMYd7twzGE9H0+SQnAbxPgR01MtDh7WiNv8BKn2TowZYAZm7mK8ndUW1GX9RnmtXqZshhP6oPMs7L9y5th0iXJd+4o7Ncz62ruxDKLU/hfLme2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxwH8h/CeqkdlgdFTh3L1QpbfBi5+P++wQ9G/ib67kE=;
 b=VPmhvWKe33V7YRc2+5tJKsSjCpDAOYDfIx6QqYzC4Vg7wvVpv9WoW6YqvkgJe+2i3aYqXX0BGZDN9cetYhPgXS20881ghe0r50Zl+ThvjD7UoPf9LwvehBJGDelH9R4vHFj1+uemQ9MZ/gQ5GgctAWJne6M0SY606/88YDvk1UmPqoUGm8oeIOQ4/KiHQ0eb8+XvpL82+z/3LLpzUo/7I4/Ka2NAjnNaxntEhHg3qASIka2Boy1ypJ8/7AIdOLVDoiEy+MqkxaT4kXdXf0SG+ajPjngVLqS+O7pTD18VIBc3DxIPSmstiPN73B1IUQMmMuaw0gPoS8lSMB1kSbSvbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxwH8h/CeqkdlgdFTh3L1QpbfBi5+P++wQ9G/ib67kE=;
 b=qeP5k35rgEI+VdIv7mwLeSEAHehiicWCv+RhVUEOP3CllLVJ4Pg2TrxorH6ZlEenxQLDpn4J4PzNMOryaieHdSZAKet0aADbBOSfPx10trJuqyYX1UT1q5uiQclkoACB8BF6wx3vh7GX30ZaywdeI08U8a8/XZbTvGMKq5VOBB4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ2PR10MB7083.namprd10.prod.outlook.com (2603:10b6:a03:4c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Wed, 4 Dec
 2024 18:06:21 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 18:06:21 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela
 <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn
 <johannes.thumshirn@wdc.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v3] scsi: fnic: Use vcalloc() instead of
 vmalloc() and memset(0)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241107104300.1252-1-thorsten.blum@linux.dev> (Thorsten Blum's
	message of "Thu, 7 Nov 2024 11:42:59 +0100")
Organization: Oracle Corporation
Message-ID: <yq1wmgfqq7g.fsf@ca-mkp.ca.oracle.com>
References: <20241107104300.1252-1-thorsten.blum@linux.dev>
Date: Wed, 04 Dec 2024 13:06:18 -0500
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0005.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ2PR10MB7083:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dc5ce16-a861-4038-8527-08dd148e5b9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XOq4bjX8yApLGOYMdvYx13XgRic76ezcG6rNHxRbuNSgWTi+Q7CAm3gA0jOy?=
 =?us-ascii?Q?gdwM9wOHK9dcP+kHmkicDukCm0VNpFCwL1G70KKJB9rZ+hiLyF1rb514488v?=
 =?us-ascii?Q?sG0tGLk1CS9HdBFbaRtm6TZ5zvR8kHneDaLCaBpmmYhoZyG+kzcAIffdyf2K?=
 =?us-ascii?Q?9M/ikkPrtcTpnwExPkOT6QbMP9SZc244xjcvEp7iO1z96nRve2JqBYp8yeX8?=
 =?us-ascii?Q?wE2bxH6PcE01KKLWwh544iAuf8fyOQC5fUaehdfcNImM3rZrGjS0zPfHij7J?=
 =?us-ascii?Q?FF6NO0GTjnD7rlOXQ+b8TnJ1+U8V/eJ8tkvTjfzq63jGJh39WGSmmPLxs44l?=
 =?us-ascii?Q?kHckPN6b++m0lpIdu9NPM93Z4dMWeB6moBxt84/YBGtwtTWVfpiuhb/p9cqr?=
 =?us-ascii?Q?6lygKuzqp5b0oHV60N277ydWDnxPJlAzXZmHfKLIRbM+Ypr86Uvgy9GUoY6a?=
 =?us-ascii?Q?6/YqpS9m7mAASB0k6zmZbbDfqr38r4RMBnoididooam44oxdg984s1mMFyVJ?=
 =?us-ascii?Q?hgVucNlreIK5TBVfB1N7isquYretgFClk2bxKe+NXUKKSXOhxCLWc0tWxc5d?=
 =?us-ascii?Q?w+SXHwzSNj0D/vzs/Dny1rd+JGuOyDoF7qcwC3KGjWIJB1/K8i5S7Mbpc23h?=
 =?us-ascii?Q?Zby0vIcuQrgPFe/mPi7OJY33BGKWEgTmGafqeH5EaUzOLwdua9y2FNgbBSj6?=
 =?us-ascii?Q?M+K2LH2zKMeBKy7MUL6oQyhq9gRdPMwmUE/ZxdrkWv7OJ6swrFhgQ3i9kRxK?=
 =?us-ascii?Q?wSYxWxDEJtG5WIsSxnxaQ/yHbwoVTsavoZsw+wDhVo+YK1iFa4INGwh5v0sU?=
 =?us-ascii?Q?JaJ7Zl8xQl7Hhyw5L+8ctHa4Ts/0Vg+htf3H809oRrtcPGTpgtHvd6wJGsgu?=
 =?us-ascii?Q?vtIgwKBP5VecB8yXPaDiplYsl7C5zdlBkwh5C1kVaAgKqVcQdtBGmk1WnEP4?=
 =?us-ascii?Q?Jn135luKfPCt3IHFl7sBoiQmWcXvVW1JWA+B2PGvSdnznot5vxqKaS+upThB?=
 =?us-ascii?Q?x+6IBvrcGlK4sCtoQ58efmmEnkbsOntRCMRr8c6byGjqz2eg9yGnR0WcaRMB?=
 =?us-ascii?Q?G/e44+S/hWqJcHc3SmAuSnaN5aZ/wXJeeZJ4IdWdPe2v1Xq9CP1OlYMLujzG?=
 =?us-ascii?Q?i0jMSx/37Hs5RzruQT4NGOkwdqFzK2Z7iNGFBoEf7GE+MWZtDHgGPYigUsFU?=
 =?us-ascii?Q?IYRVzbZT8cxRh6N15fqfepR6aWjhc78+tDzrlouDZUI4YAPGOyrrb6gdz4Ag?=
 =?us-ascii?Q?BbDcwiSUQ7CCBIjreZ7psIEz+Et3VjLIPkC94JLGay4i/WqeHxnddYlQy0YJ?=
 =?us-ascii?Q?k1X2Q6hxp+Nr6S3/RiQ/WKeGgthLZx0eXxTljybXxknqcw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SvSyuHOqz5iuH8oN3nUqiUfSXjawOBTubdz/nMY2KjhY5hN/UBnT2nf/4DlO?=
 =?us-ascii?Q?EpKJOfTFsH2zHwgcY05B+yYnUIAFOFK7cuRPPRq0toYA9AxR166M5zIIvGza?=
 =?us-ascii?Q?CEEJAA48ORCTnh9sdwK77g6XZgTHv55a//FcXi57Hp6S9BiVXbEAeic6HC5u?=
 =?us-ascii?Q?e15NIKFFaIRxmu0cbZj8y+gur/FhqMG5v6is2PV0S1iAdOToUwQe4Pfi9f35?=
 =?us-ascii?Q?G6ALFwe/6TgqSQyWfAuv4qrTgr7MAlvmCESqaeoz1I6vTih4ClJ9xEWvdp8D?=
 =?us-ascii?Q?F+5NSLVG1SRjyV0p3mOwhICqG64ZwCFb7cFis09amVj7ZMM4iaVKjAnooDbr?=
 =?us-ascii?Q?u3LmeYN19Fxf+A6TkS6P7kygtJzZghW5N4xlnvKMEOfudsncw1G7uR7W8SmU?=
 =?us-ascii?Q?kkRJTScQp6ltomNJ3llV6yvMD9a2UjOcqikgVV6WG3AiEd8g6gnzJgsVYNH9?=
 =?us-ascii?Q?tl6wFOQOvjHNRW59P0LusphPZALEoD4PDdnR3tVKEtNM7d707paotDNEFTb2?=
 =?us-ascii?Q?1N0/xEi0TkZMmW9RyQy4MdLLPZx2PkczzfVRc/LAukIUDMHr5407WaFUC4Ot?=
 =?us-ascii?Q?R6BmzySZz5e/dc9S4vhW1tHY4hAayftOtqc9on28gR+Q1Im0K5X8hfGQ5+It?=
 =?us-ascii?Q?E7+O5ZXF4wxQb3w32qJCS+u++Idc5cnLue0ErWiZ6mG3ecXbgJmy2cRU+Yj2?=
 =?us-ascii?Q?FUnD+x9bewS1hCpkQopo8Mhq6e6cD/ptb2EPu453Ozx6WuXE/Rkri/zQ2XQj?=
 =?us-ascii?Q?vN+iqBQKWLeKvNZ59VnQWK6rN/BNy3d7dfDm6EYOBX2IHkKLIepWM5yd/djw?=
 =?us-ascii?Q?HqYwrqS3n1eNVb6GEiKBtq6QiKy3KtDMn5Fmwsy/Rrq9Xz3w/TRwLqouKmxA?=
 =?us-ascii?Q?6IHJIfq1G9MhXqsJe/sx+JHfiVYnusaFGECGDDA6mK6AkULddrdxeNALebnk?=
 =?us-ascii?Q?sfPyapLhP/fMG4r28uTMkIui0SeJcZUo9OZt1GtEwykpY6ai/Qx9bka29/as?=
 =?us-ascii?Q?/ffZtTBcKF9a9HcIR9d+VOFJPlbsjV3iCpo9hObhONVtMVSp/3FGhzVXQ58G?=
 =?us-ascii?Q?0L8D2WbKAZNU+L7lXx6wV4CxD96mwhM/tgdxhqRreC6bXHyDNm53AIJkgTqm?=
 =?us-ascii?Q?4QZ7MQkCduAD0AO9ZcrW1+tvN40MTifeOm2Fuq5aNXtypw4hjhstAfTImxOl?=
 =?us-ascii?Q?Hy/WAopujA+59jKi0zHC/6Q2zErg4In3YdMljQBbTK7ZIBgxqpC0GxxdS6Tt?=
 =?us-ascii?Q?7jVwe7QRxQUPNoZ3DAXavHZNs0VhZVvCoj2NPP4Q9SiOpZ2h/HrVwwvgUC+n?=
 =?us-ascii?Q?7BJJnHbPmnTAi63sfWMtY48AKgFASXbd5Cp0eT6pDIq+3qm1MJFFIbPIfWTa?=
 =?us-ascii?Q?6x+abTus+y0f+w6gcI4sta/fD/JlQTA9SeGMKC5bzaufdzYxOcfRdgdgvAkq?=
 =?us-ascii?Q?lLdAq6NlGuyldMei+iOqc2ScH392Kq/2/NMKDpupz3YuUACGr/LkAEeAs38O?=
 =?us-ascii?Q?vso0RRiaSK8A5todTU7Sbo4n7Fj6MlYsIXz6d6vrnkkWh98bbxsivxTdJmZk?=
 =?us-ascii?Q?pwRRLnhnxiLLN4vzgXjOvKC18AqPf9o1xfZEUehMA+5TSUc4Q4Nsqzqd9s3G?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AMlfOuA3iS3IXMONqbyM+F/9Prps+Es8VM7NhWr3gFs/6EkTNIIZhMYavlv+DzusE/SIbDbEcG3YE0XYwOsrvniA8XMGXUyx/Axf0sQxtNIhXNAENFxln8ImXiOj1Lhn5WrxwQ7DLbgbkYXUwRMx1Pa3vNcyaalOeiljqJnuBvq1IwmkGfDHu4/kdIRiu8viiuNcRWqaxMEDpqcoGI6uMH02TkW6wlzii/KVqXB0kEHuj1sqb0GKZv8oG8SoEFYgteWRtsDYUUsXGMw4VUin6pKv9JxEXBkrw3BwYeikE/38Lt5oMZonSK+FWn0yoRvxnw818/I+LGwWx5A5cIS0OHkvhAAacr5vpy/KGaDhqBRvEaklJh9VkQSLuORt8CzUJc2RTkt9FiMAjVpdaOhd4YvAHL5Aln6JflupuhecjrUz+TNfBh5vROdoD4VX0eRn/MMyNp6fjT74ccGONQjMoni7ZJfC9Sj5WYdTb8Eq/GBUlFMQeB80UpMvew4SlLKc4sAXE+217JmqKAjUmpnyoxjzVpH38ntLd3PBIVEX//lXXPf9CIJ7y/mdA28cRmQm+35aJQblXHXfr7+MpiuAVfPQPDutBSgSOtX9Hd6Zon4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dc5ce16-a861-4038-8527-08dd148e5b9f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 18:06:21.2815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OU6P2cbXKr4h/BC7xkA3WZpXyOv5VuP3K2puDIxVI1EhdRc84eK13t+qfp+cVxlko+f4mEzN4bkM7Pfu7g2C6ofkjbT8TwWCaMGTJmnh3BE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7083
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-04_15,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=972 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412040138
X-Proofpoint-GUID: M7mFd_UWh5WALrN1oY8hlFtSx4yVyVUP
X-Proofpoint-ORIG-GUID: M7mFd_UWh5WALrN1oY8hlFtSx4yVyVUP


Thorsten,

> Use vcalloc() instead of vmalloc() followed by memset(0) to simplify
> the functions fnic_trace_buf_init() and fnic_fc_trace_init().

Timed out waiting for Cisco. Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
