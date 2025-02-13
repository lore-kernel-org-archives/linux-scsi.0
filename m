Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340E413D539;
	Thu, 13 Feb 2025 03:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739415899; cv=fail; b=DLPDxqisUErSLEqTRTeAEPVae3RK4/17tNf/iL8LvH1Pf50BKObHcXn9fxa1e8jMmKkXlZ3H1imiaYpRtSPRME/FWLCPyi2vofWCEcEvZQ+q/y8oBramLGvQFQHWZMedFrN220VWhk8RvHvh2SnJk2n8IDBM5+4EpUUGdIJaRb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739415899; c=relaxed/simple;
	bh=nC0zVTYq0MuCs88H5etVgNK8vW2Wrza/b6J5LSSnB9w=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Ew+tfaLEiMTP29DQnJ7GyEcuiwOK4jj/kVCCqG/VOVre3Nzlra8lHXRkX/+XAH2Vdza+474WhTHPv9/JP6k6Vo9+7vf2Fv5ebxKyHUj6YAdBY1f/3qXFSWFubx2w6xLvxplzlbov1jq/5lesSLIVbCmGgAIM6nj/Gyidwi2Vv30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IXs7GiYH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aEy3Qq0Z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IXs7GiYH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aEy3Qq0Z"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1pbNU023948;
	Thu, 13 Feb 2025 03:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=kjDMZ0n+P3LPFYdYU5
	+FQkmW5KWEkbRbBxm3jUoERU8=; b=IXs7GiYHMZ7s8mtVIIHUwQTqtWUvsd008s
	KUIiENT8VC2KSBkRtQsxeVZu74xaqq3hDmWVNdmniOsFMmM1vBjh3jVaJdEhUuXx
	MpVlCePf0aqYS5OqV7yJMqsf8LVEsqi8mRUWj7BI4Ue7x7rrbGH0n8fjAJZN3gCJ
	gV/qzxoLwpW5WeyBJ3U9MQEHsFESBdpggkZlFtw56JUusI22ShUXZdbL2ecrMjpU
	Y9uozdr0pzOD0foFUOV8DhTzB1dj4p21pz7xE+b+ob9pdjP6aNIRCyRIwsbcvE0m
	wgen+SoU5BNric3O3V8wuZ9FeKI0AvI5wMdEAy+EAXBHqRLWcrEQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0qyrsju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:04:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51D0URZb026958;
	Thu, 13 Feb 2025 03:04:25 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqb4362-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:04:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jweEPtbilhNfqVW8VaZTeo0t4GieVh+cEFK6qsuoVyR5gMecZgzbFHAvBK/U3lAmyElh8d67Dn9peSfJoZLi4cT9IoepAPR6vmJ2jabt5I7uCK4f1vnzjKYxr26V51ROpbDtwJtzB3I3d6KLeHf+abEjajhPtlmntw+7+orW5DytoIoB+JW/TA90BoRnNszztPUiP4Z92Mtfsp5q7WPbke9s+LD1LMCRsH2RWCBsHPKxy+QlUlQW66v5yKCYdmUZKOQxpda70v1m6daJIv7GZQZPk5/cV0cY77QQKTYtbuleAzAcpDCcMOKES0qDOWug1cNtVVSDx58etki7brKYsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjDMZ0n+P3LPFYdYU5+FQkmW5KWEkbRbBxm3jUoERU8=;
 b=XDbtgeOBvbaSdCwOuiQCcnCJ/TqIeku8+XMxq47Cvgq/LZh77kq16YY9LttGItyC3vzdSUvgFpEXRj5MKy6/D8X2ptV10YXVM9D+cZTWS4YcAh2zu0Aay3VRG7+rrvmTu6ASioD5aGhFmSljgi4O5TlQRUiSQYHAzTCyeEcJVmPByGKWpJFaCLTKbMdErNF3ktVmtZUfn3bW3S6smUsyED/mtTj3gV2Gw6c08/qSjWqE50Z2lFqCysuPtKC7RuNWUQ348+XCQxeZTxqvgkyVokIGoeeKK5YvvmBXMWuJwjEeCp4t+36QXQP7dec7hSL44Sa3EzgRt0FOHt3o6irBGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjDMZ0n+P3LPFYdYU5+FQkmW5KWEkbRbBxm3jUoERU8=;
 b=aEy3Qq0Z5ieIeH0LxwNDZn5DNDmYIFMP1uv9nfJI8C1CRnxYejpWr4IyKxdw1fF6j+s9XdNXJwC16Aqe3zZ0kJPKGpUlvO2lnsMngStNn34bOlZE23B82iKXrEz1ZMSFDHaxPQS1bjehgkxBFWTz+AaaztmsPFNMZHuRaynnotk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4940.namprd10.prod.outlook.com (2603:10b6:610:c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Thu, 13 Feb
 2025 03:04:22 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 03:04:22 +0000
To: Kees Cook <kees@kernel.org>
Cc: Andy Shevchenko <andy@kernel.org>,
        Sathya Prakash
 <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali
 <njavali@marvell.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen
 <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, "H.
 Peter Anvin" <hpa@zytor.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Sven Eckelmann <sven@narfation.org>,
        Tadeusz Struk
 <tadeusz.struk@linaro.org>,
        kernel test robot <lkp@intel.com>,
        Erick
 Archer <erick.archer@outlook.com>,
        Dmitry Antipov <dmantipov@yandex.ru>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Luc Van Oostenryck
 <luc.vanoostenryck@gmail.com>,
        linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        linux-hardening@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev, linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 00/10] Annotate arguments of memtostr/strtomem with
 __nonstring
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250207005832.work.324-kees@kernel.org> (Kees Cook's message of
	"Thu, 6 Feb 2025 17:00:09 -0800")
Organization: Oracle Corporation
Message-ID: <yq1v7tev949.fsf@ca-mkp.ca.oracle.com>
References: <20250207005832.work.324-kees@kernel.org>
Date: Wed, 12 Feb 2025 22:04:21 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0025.namprd08.prod.outlook.com
 (2603:10b6:208:239::30) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4940:EE_
X-MS-Office365-Filtering-Correlation-Id: 06cfee2f-1881-4bd5-5f7a-08dd4bdb1dbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G56vWQ+W20bwCoOZqU3Fl2hiMNsmKwQK/GcEpM/ZdGv+sp58d3oIX1jZ0v9n?=
 =?us-ascii?Q?KA0u1FIqIo3s0i4PENKOXMgv5tN3b228T5CGRm3RbgyUOyEOhT4KSIKNFDsS?=
 =?us-ascii?Q?qfqGPqL+i69ZAgExto4RlBPW5xgfxdFnQKt44qTet1pSyp27QwxjcZArGMFY?=
 =?us-ascii?Q?KVaeD3HTvm/SrFZj4qCz0ldL0GFDfd3rsvAkgGP0v/KGgmsZ12w2ILqd4RXG?=
 =?us-ascii?Q?u0/mix4JvpvV47wX0z/Jex8xfOhXu/t300ZjsobMiRkYcGubI13TGXP2WYhl?=
 =?us-ascii?Q?m6Jw6f8kFmVcSlg7c/Vzrt4lGKN2SqWlGyd0VDVZ7bwohVrGDDhD5JEM2nVw?=
 =?us-ascii?Q?mvosLO7rltINRu1BrDiKKZ5s/Ig2nY+uyhX4+HB665kx6coEH0cpQCYyJ2C3?=
 =?us-ascii?Q?I6vhXIVf9bJ3wiyC3DAJTi7mcBLAyqk6cD9uZNErsuHEQujRy9eEyMoifyrD?=
 =?us-ascii?Q?3XgvHFk3wdqemTAZrN82njtvRILuA7S4kgEbv4qs1JQGeYaAhwBxZXs5oY4G?=
 =?us-ascii?Q?Fi0bTXVfWXeeBXryYZSNzQ53O9tPUMMrZWZMHv7XU48QhY5NuwSuQ0f25asg?=
 =?us-ascii?Q?GDRsgHW29Pp2MN5p4/T+HCxcz6ScxxZCtexoQo6AveMQ5bxAfmkpttHecBdJ?=
 =?us-ascii?Q?V+PdKgQd3YOqSrLlL3c3yQgKSHdMqNuagm3rkXVfniqYU9OdewriazHGZiXg?=
 =?us-ascii?Q?wLPYz0j9lMObFLr03Hfug/745c7P1Ex97s/Aank/o/T6xe4yd88ZxDEoxons?=
 =?us-ascii?Q?yakuDNyjj/iapNSdA72Rq9cqREOBmIPgOUpVSHPM6VZ8Lr1w8NGlti5+aNZc?=
 =?us-ascii?Q?9oucaQsF+HQXvBWXQx6vdoqKA2TvpojwrukXmWVTHZBs2mQz/i3gRS4oGHvo?=
 =?us-ascii?Q?oIfM9crgPE8tw1mRGfDCnVErTHite6U35py+ruv3K0Ztu9Y0LEixNUZOHw7t?=
 =?us-ascii?Q?fqkQfiMR7YNFeGec0zs0m4rD3FMxr+0kJah3yJbS3VmRDJ4koXTVAPT21lSI?=
 =?us-ascii?Q?sCj+m6EMu5eAFu+8dkgnt742FFouS5M6f0FApnrMXP9DJ/bZuOxWb6vjdNJ3?=
 =?us-ascii?Q?XUrqh3U3CthXeChWI06ycGyvS3uS1Kjof2pctqX/s4v5yYYT6n74DHxt42Zw?=
 =?us-ascii?Q?Iu2HW3D2hKElYhceO20x4NgKC3sb8HrCnYFCGSqNvvqwwu+OVwGpNFFIN2Ws?=
 =?us-ascii?Q?aOD4ZhhM9nldPyt8G9iC3A9lPWmjjds3GEVhKCwI7hgSrij95EWdLoaleIgU?=
 =?us-ascii?Q?zt4MNRzl0K0sbELyzeVWCtwDGVFormHC3arerJqkwP1LvWLfXO872522jWcG?=
 =?us-ascii?Q?8jm+jO/0+Hn3mATMNcroErwpj9AhniW66cH2iPEYu0HQYndEX84BL9LeuAMy?=
 =?us-ascii?Q?/EM4IuK3Bh5vHRsy+/URfu34QMr9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TfC+BD0GJ5vx9SL6F7xSewQHMLfzWJp6dmvqyeIb41gKMyGyKkJlefbg9cyU?=
 =?us-ascii?Q?Xn1+zxNaMVvJRAfq78AQ2ZlFE3Os4vODHX2VdSuGkZHYl3niMxS+qghTrmKS?=
 =?us-ascii?Q?Not71pVGVm3ani85Ayx6Lkjh3KajOP6rqt1Y99pZEx1eus7vnRQPO5LbJEvQ?=
 =?us-ascii?Q?Dy8HWauYsrik7zaNTIQkkmzQfeJm46dOtgHSba1ff4E41V5bMbZezcitB0KK?=
 =?us-ascii?Q?J68GyL+DiFYbc5iru6W0Ik1EpfxUP6czGAT6Y++k4Dc+VMHZ4r/ZIgPeCXFa?=
 =?us-ascii?Q?S6fiAMazt8jTW+O67/G8nGrLTrkCbmDwTcsQjjYVNR5EwYXr9vAL5Z4hgAMb?=
 =?us-ascii?Q?Tb36O/KIrHGI6fe6q8qcUD1Oqwq2aTrDLcBQfr/tCBTugRliIfZzcOcaX/It?=
 =?us-ascii?Q?+p2S1Y7VQciPjW701ui6keEd4BQOwSCdDsLpnl+CHjEJBGl5Z6SFl8pJCvwQ?=
 =?us-ascii?Q?YTTTBp9cS7qE2eKsJ+iaXq3s/4f/z+6OI5THiCJE0BFGeyRG/49qFTE52TZu?=
 =?us-ascii?Q?C1Lgh+u90EPTyYuTk9tH9o/TVaTjbn7KNvevN1vPGVG99gOg3zMxsMFX0R8Y?=
 =?us-ascii?Q?CQ0pgjG4OO8J5qtJj3bbBLiDKKdeSg6p6d2KP1qzmwBAvYAb8WHprqW+jiaU?=
 =?us-ascii?Q?UqX5WCDkF8zkWI4DTcJEiDGsdhDU6TtIjB8mZt890zwXMlDuH0SLa/T/4zFY?=
 =?us-ascii?Q?EA2ZUOm0VyaOsj/o+JnpZtJUNcC7Lb/HEqwVOZ2JGltYeasITGgI7cuFd1eK?=
 =?us-ascii?Q?VDSs2vlowLfMT8mRUBRMdVLpLpKlLml2d4/lh1LyS8jqKMOsd8JqGgZMQ/o+?=
 =?us-ascii?Q?Ywy7NlJgjnoxWUafGb/lAuh7h/c87KVi1Nk1HhO8mTa9V/aBnR/+HEYjT4wg?=
 =?us-ascii?Q?sll7s1OH9SXRepIZ0eIM/m58XQ7ZOzhANULNn1Pxp58gVuQT1MVK3awmvfEE?=
 =?us-ascii?Q?P4arnoHfk/Y9QNw+3oYuY5PmOl2YzZ/KiGjiYRkKBZc78o7mgTURCM3YFqKt?=
 =?us-ascii?Q?2YmdHu58CEjHS+W0zTA8d8qViy2yu0SXr9TqDVYeDAkNNs4PN1XMp7Ulcf2A?=
 =?us-ascii?Q?y0zntFh1JTZyQSe0mQzpDzAKFgyz9gy9l0KNAQiheAIoc8hTNQfOxqL1K00h?=
 =?us-ascii?Q?p8fpwXHlvzlkbgixtfBaZaGqU9EkYaBI/YewczK/CaJ/shiTTQVEihJV6nDb?=
 =?us-ascii?Q?zP8VXTF+3dxJPbSf+5U7ycV0KlB9gZKabyCn+Et5CemUUQXgBktxnzcOVf1M?=
 =?us-ascii?Q?eLARZA9rMKL2/5JXjgoOr4jj46hlpHu0ABNHonrJOXSlMWUWSb4qTc29gQ2n?=
 =?us-ascii?Q?C/GbwCuFE+8b1HRi98CyDlIq9aZRpQvwwsPYWr7WmIlcu8Wibte4zWiO9g3y?=
 =?us-ascii?Q?QYS/54SPjvCHdCRNiMyk3sqTxvga1F4X7tnLii7rD5cT1irE7RySGGwko+mh?=
 =?us-ascii?Q?P+K0U3ei/5kYMVPDrcY1IVqg9DD9ZMMOeitHKE8ZShwucm7QYp3lThig3heh?=
 =?us-ascii?Q?gye8mXvOUAG51QdYUEtA6dTb5ey1mcoozIZYxCzS3zWspndjH4zuZ2v06dtA?=
 =?us-ascii?Q?u4dWrHUXvCKXkQHUS3rmAeGkmTnb6Aq5HWZUR6SsnBw3y5gKF/z+OqNm+rpD?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aEDsyLxI11ll7khstdK+RJ8ZEcGXeaHXNq7vFdOnIDogFdF9wMY/bD0pBU5mulkXXXF+p01V6QyWDtmIx61T+KkoFQZn0qgg+KEieMOlj/sj3+eZHS5Dgpu1KR1wcy1cgM5PlL+uFaEnDTvEo4IBu25nw58LHdl/smlJZV7vKIht3M79UL22cvUPH+N/Czv82oDAybKTh6NZtMrJ/bKAFtOGB3mgFUhDJeqmXHnRiZXwU26gWe1FrJPzrvyLneNCWvy8YMqYdd0gf4231u/iFZfHKEpd6doF4vGiVeH/lBRRqtgNggevMDJDqVYWzSlOqVCW7kexc1w5L5MAXe0Ai0rEjClK6sYWh9w4dnAjJcWcFsFbYiABjrmVRmM1fAIt8nvxVC7k/D0PpnEZJ9RfMVIdl8Cl3GuOl9fRbJ72eSS/LfqLW0BYd36Of9b4o3UxGNgIhFEm8EiMP1t2H8NYShhBfySfuXw7GATdbzoi6Rk4u9DadhDI+3GD23SS4I7BwcN4snU9DP5BOLNKIlqT+y3iQb7dnHs/08uQraZU6+j0rxpzAMxqckwepxrFdUjbRUeqiDOi9jR+WZ+b9jRFKn3H3/DuLurQbpTQvdtriRA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06cfee2f-1881-4bd5-5f7a-08dd4bdb1dbb
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 03:04:22.6240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eWzU32nFtIJ0HQRjlynT1GvlLiuPEx/y196qeqdhMcU/xi290uqR/yR8Lf1fVLPsDH3gicBcUuVg+6Q/TtnU7NmrXQUa4Cvxa9ClClY6vI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4940
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_08,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502130022
X-Proofpoint-ORIG-GUID: La3lG0bG152_KtqWuNY-_I8W6KCPR9iC
X-Proofpoint-GUID: La3lG0bG152_KtqWuNY-_I8W6KCPR9iC


Kees,

> The memtostr*() and strtomem*() helpers are designed to move between C
> strings (NUL-terminated) and byte arrays (that may just be zero padded
> and may not be NUL-terminated). The "nonstring" attribute is used to
> annotated these kinds of byte arrays, and we can validate the
> annotation on the arguments of the helpers. Add the the infrastructure
> to do this, and then update all the places where these annotations are
> currently missing.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com> # SCSI

-- 
Martin K. Petersen	Oracle Linux Engineering
