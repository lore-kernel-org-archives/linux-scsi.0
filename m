Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E953BB9FE;
	Tue, 17 Mar 2026 12:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749280; cv=fail; b=n5e4BYszQFDP8dkspCGVwT+iPBSAAqKnHxHfckw3GPQR+xfkt8ehOTI28LD1h/UDqKdJohZTHSnDjppcVRJnFCEEFY4fFUAnkG1WDTMk0xsFs8/D9lpuyQh2lhWcJmtHZilo/1dMJ23vynUApIxixyjRx2j1e6Q4zv61P4B3AuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749280; c=relaxed/simple;
	bh=o86DfHwRxxs6+Wc0pYQHL6ENdy+fjg1FLkw9PH3ymZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FC+w1xmovCSJ2l5oQAoNtD9pXI34YhRTLjdxio4UiSvwwfHNFiDQp7NFZAcjfEqJKYwpjgFNCq5M++G+9aDIqkug/RuQJTwlCGCyVoTg5zS59Y8EX+eRJsJGn73XPxsCEv1dRTYHT/U5/EPJCsRi2R7TQCV3opcMEKX8EyLbzXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MtMjEoUA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m0a5l1jw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MtMjEoUA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m0a5l1jw"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GMNvq9220822;
	Tue, 17 Mar 2026 12:07:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7ZQtHlmpkLo5vShD7NjG0mJ2gw3epdlRnE4S3t/wSnA=; b=
	MtMjEoUABcitiIDzJNNjcQd3o+RaY4WGBnvQGn2EdQwtcPGBAtRgXpLX76tB6826
	jtgpC1Utjd7YO+H8+w6KkPXO2z/tN0MbHe/YvQUG2wq6LmOmVt4kAF5AhDbu/YMN
	MT5YH9VANrpOIRcqKPTt3kxNJ9HLQ2E/+q+jFRDhlflTiVJiKsCz0qomFBslLNkc
	5xBgiD/+RuEU4yeKQFw0hbqdFrLJywSG+D3kMLznQB0pKiPICLLeeV+9iaaVC47n
	EfCnAEpPO56raFdaCK9ZnnHpnWGYpsZqGYcKHSaYdxTVa+s7Xe7/bxKkUvQktu9z
	ZOlytlhht9IC0qby795P6A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvx8x41q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HAFxKm014028;
	Tue, 17 Mar 2026 12:07:46 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012048.outbound.protection.outlook.com [40.107.209.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx49yrnm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wEjClswdSF/8NwcupXQ9K2fDg171KjYiKIfR6D7BmJbYAJnsJ4YBRlwX8X96WNpHoX2b5AB41V1VALLckOtiecSIdK0OLLXmRbGtTcxE4YUn2hHiinxKEYLELa/XyPrEaXF6gBsGpoP1Yeo2YnGdqLkkLenjKLg8vVFKjtR2iZu6M1esxnfV4+lJEKsXDOkSx7aAgTT9T8DIt3i9Ir8nLmtejP+A+hZdfEPIM7D2HGpSRdn4UG91oriZdUgiCgpoLUp2GZmkCM4rdcFkS30YkXlyfMWIXALRmX/qtBzHGkSFWm1YLVdih3reu+OTiEASGD8EeMrEALOkXJexZ9irhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ZQtHlmpkLo5vShD7NjG0mJ2gw3epdlRnE4S3t/wSnA=;
 b=VvO6Y0bgMgRVbvHlOvowwP5cdDAuWIJeVyGsQc811LovIW+Qs+AbpD3jixLqUtKVAW+trtdERvgHwzzoldCddrmY+qsiAHT1qZEaa1p6FLltskN6xfan+iUAiFKc6Smnr47E1ILHhHmCFpJ8vrqXxpnOwFjzQ6XQHC1Ip/H3zR6dy+AEYr0S65KoYqbLvZfPMHNRiPLg5Wyk6NV+dYBjJd2GUTZwNjhShLHRg14TYSs2rdITi+O7iDCA48/9yXhc/Rqpx7xUGFgLJ+TmNO6ECa6BNi8jD/OTBCntk3xPUbuWTe11JnE89suvIm/G8IhlV91HRB/asYwWR1xztBED7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZQtHlmpkLo5vShD7NjG0mJ2gw3epdlRnE4S3t/wSnA=;
 b=m0a5l1jwlfu6bJydh5hHGD3F4kGxFoE3Jy/y44ZtgxdLz40ZDNpp6BN21WQBRiINDXF1vIz8xLhKGYfPGNceOiOEHjCy7HC+h8bpV1/fHLCarKMR2FwSeMa8t0GbkmiF/DfMsA9/6HzFQjoH272+vLh6ojfo2bJbqpnNH/FZZ6g=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS7PR10MB5976.namprd10.prod.outlook.com
 (2603:10b6:8:9c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.22; Tue, 17 Mar
 2026 12:07:43 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:43 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 13/13] scsi: core: Add implicit ALUA support
Date: Tue, 17 Mar 2026 12:07:03 +0000
Message-ID: <20260317120703.3702387-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::35) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS7PR10MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: fcc20bae-69b6-4991-668f-08de841dcafd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	nxkNqeU0XinqMqcfklT+kxuM1ncr9+iUILwg0frcJngFVJfsVrKAjjB9N2CgvmE9oGS0V+qwp1TYoe2S55pWB5AanGLbPsE+m1GjjBxKCEuthfKZOPIR91AieiLe0KfbFg91pkCOLeEZ1q6g8ooO2LmjKfz+9Fx4w4uFxBUMrbvILcUpz2ovP5PdR5mipkwjbG3fTeJmEjS64R9WOHE45wpXfwDhZIqZxoqPvuvCel+ATF8rOE7cHZbPFKy4NkblOcR05KXeLEfQZjQMmXDIX6u04UpgquXKuPrH66F6BmOlJe0eQFg51bA7gSEx4K+YNd7Z753Z/jwYWS/VSqqXKhLLlZ6w3mg25KVKWiQaynPmxKOOhoyu/MGPfBK9YgLlRXiGbdg7yPXuxBpbhY4gbORyJ/swKggGOEkqre7Yl5Ci6Ca4+FI4l8+6RUfqmECkQ52MNylh46VUr1DsHzcIt62QUBYmY8ayuNPemTdPtJAeQPIOPVTNPwRLPwcXghE2lCb6Nv7TNhA/sOrjZ/FTaeYwYoij5HAWFWZI9FVW9tSfKGbTVC/+JwlwVgkslSI4s9Ity0vFDLXnL1OOamrR07ZM1VdVLKyibqZkKUeqvUEcAUY4tvod70evPx5NDmqxbFPiqJDGCunJMZlmNFuDwnFMjdJXzRzQw2JrQT3DCwpExzs0xIboeGpW0to4ocIsmxmduxAzA/OC3nanDNDjLDwfcf5zmEDWjwJ5QRr1lnA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IgtxHF79eoMI2PhMa13qZ9Ncb3EslidjabUGLjD+ltmxpAP1z+6aL3ceIcea?=
 =?us-ascii?Q?CB/cQitucQgNgnGrhIvllD411FUlNPjT5ZJ9MWhIo0q0GF6rreEYRTnW8jnK?=
 =?us-ascii?Q?EYumj9+oeCYY2Guwh96p8lgW6NqTCX/xGDd3SIKrpUy+k8Q6Cj2ebpnc5PiI?=
 =?us-ascii?Q?Kd1hBqdnpukXoAxx4xY/Qmqe1UWpIbndajTbd0rwVCDCTEbk1V9FYcDENWyv?=
 =?us-ascii?Q?XqOUO7s1wO6b8aFFve8VIqFBH4MEK60kHrdK24ZfH5rJjPFku41rqe03F5QR?=
 =?us-ascii?Q?eO+cAKGiVKNMRZIlxvWRr60d+FIbgY8Ww1oDGQWghe+cumhdYLdivNF1SWeR?=
 =?us-ascii?Q?tgxzMBK7Z3cCfF7hEyeriu10XQ1v1RXiEzcyghnWxu127Y19e9cdnfCpUiOe?=
 =?us-ascii?Q?65i9oGMQhv1DCrghZhdMtPUWPLY0rj2xF7VQj7wKBOOz6XAM5+GkYFg+EHJM?=
 =?us-ascii?Q?BKSovOsBYzSBwf5EduZPR9g+CUz98Dr84kQUh4S2mkwJ7BJUesdPeOyoC2e9?=
 =?us-ascii?Q?BX1y55iu9NRtRzv6HI1HtgmW/NU1YsUaqqbp/kxuenI29vVOycAAYOnGb1am?=
 =?us-ascii?Q?3rADAg47q1eZ9gB/vVFCgOiMTm7nmMVacVcUEtInD8/V+y1ByWxFz8aIKSFZ?=
 =?us-ascii?Q?VYbC86ZAfnlmVFJOGYDpuXmuxeIIFb77SUmjojBq6E66ASTWFYnuzoW46ULZ?=
 =?us-ascii?Q?oHHP7Toh1W6hJ4Xburoifney31hetGSMESSbFvNxQargLI2m/rXvFoSJusNs?=
 =?us-ascii?Q?K62kufiiGxGC6cEc8oopmnZVrgLI1pwqXy/uREgqodqOAZfjXVnTd4puNvwq?=
 =?us-ascii?Q?mYCLdxQSW6eoOR5gQL8u1poQEUN/EQ1bMGDzC//kbp8XMVdJLVATkSJkLdR8?=
 =?us-ascii?Q?7ZewQlWCj5g8FmqmUNONNujG0NolAaRGLQ4cQO3R5xFi7Ov/8r7Cl1QjIdpp?=
 =?us-ascii?Q?FNPjBloPjFQT5Uk0+6HYPCB2BO+pibRj6Js9FUkS2NuW7Y9TMjZcbMYYfVUP?=
 =?us-ascii?Q?ofWVDo0754sDwwhrEfdxW6Xfk111hBx1duKNUnvh9SlwRF+jGYNoF6V/8gvq?=
 =?us-ascii?Q?5dUZibXRWX9rgzUHUy93zk3sstgPP1NVbwmc4B9m0t7hJ2lvsE8PH6oozrTF?=
 =?us-ascii?Q?WrjJFi4rFvf671/7mQi8MGEVYq0a6bkyZYLtbI3GgciKFB72zqhQeNYJtShB?=
 =?us-ascii?Q?b/RtQ84n+7HdDfJhyvwc6cVmUE4X1cZ+uT+NQDMybr9Ymc1MGnOE4eqy/jyL?=
 =?us-ascii?Q?cQ1+RDzHU3rbN7EBo/FlCY5jjsi5ySVmE+76wuL3M8LCmC7z4er06ypSEbM5?=
 =?us-ascii?Q?anGgx5b9uxiDvAJyQLfNqc65txapH8Byi1QUMJExXlYv3fWGwehFHQI5O6yY?=
 =?us-ascii?Q?sIF7rfiElBRuaKcQL+IrDNZ+02SJ1/rswJk4GkFp1V/n8Bd0wqN3cbHLGSvD?=
 =?us-ascii?Q?L+8/XghzGWv5Sw78X/tktMehMT+LSRohSMqs/W4JaQFmCR1hnlL1K7OYw2dB?=
 =?us-ascii?Q?ebcxl9Aorbi/n3fh2z2a+MljQgexMkg7B6Ok+fmA7neVuFRvODjek32GE8OY?=
 =?us-ascii?Q?hZnwfOD+2z7K7BFz0ZDLTH2KANfp+JubUyAY1HwzF33ABHvkiFB6HmypHmcO?=
 =?us-ascii?Q?ANy2olwK7Jdcr7TBdOFqzCNk6+tq8vyVNe8sydlPmwqRTFBfCi+6jANwwzPN?=
 =?us-ascii?Q?V4uL98dYZgpcARsu4X/ReJh6/3d2t40/iL/nh4YDJkuVfKoZ8cnq29p/TjMO?=
 =?us-ascii?Q?mFoTOfBP4w=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	SZQ/ljOPauiiwGD3ctr/aGH4tFy7W2BzIOMy5tPPReT76I7icUPVgoCsG0LWiRfY/iBeZng10Dt/vX6Wi4qcn500NghX53JEDwXtPPO7HsEbqumdVWqpHZaWnRFYrqPIYDadV65M676L976dssHM4XQsFpjuBnQG4ctUBnnKnwSbrakZ8FSTbFlN6CrIRVX6wznxMQLbegih34WEdruu7Bf3/b/JoDbHlDkhc7WXXWxRrb9khXjCoWXahaAldaA9xSDZXHCEgaECGHiqUQw8zkfTs08VBufn7mCqZCHrd5OSDVzcnL+/tyt9oTY9w0iqv/goc75L+qPKB41xJffHRA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R94xLDrUZhXgFq9o7shs+8dKXrB8zQRB8fAkVIi054FjjvN+9NvUyAD8U5IOQcpZ/iGlQAMB7nhsMGrJAvO0LrsSOjkXurKSy+RGN6a/WxIeF0pG73d2tojEIJ5MV2+7YBH0EGSsleXIRkKRCyKRjV/3DNAu9wokcmuqnh73ieLXQaA/FRDq9u9xQ8okeTK72oMjT7aqontRvveOXBeXi1MKoH60zieC2XSP3WUlVZvIiPGMNDqHWjSCRZLbg9GFrbj5s5EwnnJNDGrXQ0xZfMxJxHuaKQ37tK6J42R/chTYj7RSuGMfHp1/1F8tTcnRs8Mk+qoDicZGGvz1wMQhEtnQggLZbFj4/2JfYDuyCeWCCLsmD5Gyqe4wBGewo2eCuYwoZy8q2TYCDNC8zOhLvFoZAmx59nWbgmiN8PPUBtWz747v1B3hJsth7i2byl9+MtH/kU4zIKjylGKlY3dQ101JWkE/uDdtBU/G/+nt8B6ZpGcow2P8L7vudhd2u9NGCWa9BRVqVGbyzi/XND01mxr9RO6BtAQJnGeX9QNSF1L2rSM6aOpAEuxOkJUO6b9B+EHu+D1Jy1jGIg24I9RW/jj915nOmCvzqE/enjOIFoM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc20bae-69b6-4991-668f-08de841dcafd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:42.9523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6YSZt2P3iU/eBE2bMX7/R89Q8jsGdXnA8yIAMJGlWdYRqkYlPX5Fgn4pzhcJXSeGo4ni8h/pXtKu3+hpQc/YLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5976
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603170107
X-Proofpoint-GUID: Ow8dLIoNOMhcG6tJlC0_8rb7z68ASJSJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfX+xUrtAphYccR
 e6gEa22c8DLg9vDudLymektWLmBDDl///Tf/Xzes7UgYTyk1NpW2C8rRecRY/ZT7pELWYX3CuGR
 vVLKsavGv1iOO0Ol0rrYJcACVhxuLaYq9JcnrNEiccRPWXb9XnjpOYzOi49pn478CIptLc8XOJF
 tT9793KJ9oPQY7aiw0Jfwg/4eid+TzRSN+Z3Cdkfb2R4ecG7pI7eamCrVgwa8uk8yZ9Z2vM9sfA
 FJqnzFMaCvtqMst973bQeSR3dc/iTqQpxnehTa5QXMqepPNS6elAeuIXyQN6qa3VkpZmKzrvnBC
 JIUjxMd6wUcEUYRm4YH8TDzrsgWiRnPr4LIrzzm7QBWoR9FehpaF6p3uJyOPFwjoMTB2w0edaTa
 LkyOfz2B3BGmcaum+kqtSn7ho+cYLMFEV/PVPqozy6vPePcIIZhjfGl7tbqtOeqVDOzLmZ5WlA7
 Bfa6VtCa4emcV6qLI/A==
X-Authority-Analysis: v=2.4 cv=dJmrWeZb c=1 sm=1 tr=0 ts=69b94413 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=zsePKhMgOjo2tptVz1EA:9
X-Proofpoint-ORIG-GUID: Ow8dLIoNOMhcG6tJlC0_8rb7z68ASJSJ

For when no device handler is used, add ALUA support.

This will be equivalent to when native SCSI multipathing is used.

Essentially all the same handling is available as DH alua driver for
rescan, request prep, sense handling.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_alua.c  | 93 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_error.c |  7 +++
 drivers/scsi/scsi_lib.c   |  7 +++
 drivers/scsi/scsi_scan.c  |  2 +
 drivers/scsi/scsi_sysfs.c |  4 +-
 include/scsi/scsi_alua.h  | 14 ++++++
 6 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
index d3fcd887e5018..ee0229b1a9d12 100644
--- a/drivers/scsi/scsi_alua.c
+++ b/drivers/scsi/scsi_alua.c
@@ -562,6 +562,90 @@ int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize)
 }
 EXPORT_SYMBOL_GPL(scsi_alua_stpg_run);
 
+enum scsi_disposition scsi_alua_check_sense(struct scsi_device *sdev,
+					      struct scsi_sense_hdr *sense_hdr)
+{
+	switch (sense_hdr->sense_key) {
+	case NOT_READY:
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
+			/*
+			 * LUN Not Accessible - ALUA state transition
+			 */
+			scsi_alua_handle_state_transition(sdev);
+			return NEEDS_RETRY;
+		}
+		break;
+	case UNIT_ATTENTION:
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
+			/*
+			 * LUN Not Accessible - ALUA state transition
+			 */
+			scsi_alua_handle_state_transition(sdev);
+			return NEEDS_RETRY;
+		}
+		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
+			/*
+			 * Power On, Reset, or Bus Device Reset.
+			 * Might have obscured a state transition,
+			 * so schedule a recheck.
+			 */
+			scsi_device_alua_rescan(sdev);
+			return ADD_TO_MLQUEUE;
+		}
+		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x04)
+			/*
+			 * Device internal reset
+			 */
+			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
+			/*
+			 * Mode Parameters Changed
+			 */
+			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
+			/*
+			 * ALUA state changed
+			 */
+			scsi_device_alua_rescan(sdev);
+			return ADD_TO_MLQUEUE;
+		}
+		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
+			/*
+			 * Implicit ALUA state transition failed
+			 */
+			scsi_device_alua_rescan(sdev);
+			return ADD_TO_MLQUEUE;
+		}
+		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
+			/*
+			 * Inquiry data has changed
+			 */
+			return ADD_TO_MLQUEUE;
+		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x0e)
+			/*
+			 * REPORTED_LUNS_DATA_HAS_CHANGED is reported
+			 * when switching controllers on targets like
+			 * Intel Multi-Flex. We can just retry.
+			 */
+			return ADD_TO_MLQUEUE;
+		break;
+	}
+
+	return SCSI_RETURN_NOT_HANDLED;
+}
+
+static void alua_rtpg_work(struct work_struct *work)
+{
+	struct alua_data *alua =
+		container_of(work, struct alua_data, work.work);
+	int ret;
+
+	ret = scsi_alua_rtpg_run(alua->sdev);
+
+	if (ret == -EAGAIN)
+		queue_delayed_work(kalua_wq, &alua->work, alua->interval * HZ);
+}
+
 int scsi_alua_sdev_init(struct scsi_device *sdev)
 {
 	int rel_port, ret, tpgs;
@@ -591,6 +675,7 @@ int scsi_alua_sdev_init(struct scsi_device *sdev)
 		goto out_free_data;
 	}
 
+	INIT_DELAYED_WORK(&sdev->alua->work, alua_rtpg_work);
 	sdev->alua->sdev = sdev;
 	sdev->alua->tpgs = tpgs;
 	spin_lock_init(&sdev->alua->lock);
@@ -638,6 +723,14 @@ bool scsi_device_alua_implicit(struct scsi_device *sdev)
 	return sdev->alua->tpgs & TPGS_MODE_IMPLICIT;
 }
 
+void scsi_device_alua_rescan(struct scsi_device *sdev)
+{
+	struct alua_data *alua = sdev->alua;
+
+	queue_delayed_work(kalua_wq, &alua->work,
+				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
+}
+
 int scsi_alua_init(void)
 {
 	kalua_wq = alloc_workqueue("kalua", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9c..a542e7a85a24d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -29,6 +29,7 @@
 #include <linux/jiffies.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_alua.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
@@ -578,6 +579,12 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		if (rc != SCSI_RETURN_NOT_HANDLED)
 			return rc;
 		/* handler does not care. Drop down to default handling */
+	} else if (scsi_device_alua_implicit(sdev)) {
+		enum scsi_disposition rc;
+
+		rc = scsi_alua_check_sense(sdev, &sshdr);
+		if (rc != SCSI_RETURN_NOT_HANDLED)
+			return rc;
 	}
 
 	if (scmd->cmnd[0] == TEST_UNIT_READY &&
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d3a8cd4166f92..e5bcee555ea10 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -26,6 +26,7 @@
 #include <linux/unaligned.h>
 
 #include <scsi/scsi.h>
+#include <scsi/scsi_alua.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
@@ -1719,6 +1720,12 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	if (sdev->handler && sdev->handler->prep_fn) {
 		blk_status_t ret = sdev->handler->prep_fn(sdev, req);
 
+		if (ret != BLK_STS_OK)
+			return ret;
+	} else if (scsi_device_alua_implicit(sdev)) {
+		/* We should be able to make this common for ALUA DH as well */
+		blk_status_t ret = scsi_alua_prep_fn(sdev, req);
+
 		if (ret != BLK_STS_OK)
 			return ret;
 	}
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3af64d1231445..73caf83bd1097 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1744,6 +1744,8 @@ int scsi_rescan_device(struct scsi_device *sdev)
 
 	if (sdev->handler && sdev->handler->rescan)
 		sdev->handler->rescan(sdev);
+	else if (scsi_device_alua_implicit(sdev))
+		scsi_device_alua_rescan(sdev);
 
 	if (dev->driver && try_module_get(dev->driver->owner)) {
 		struct scsi_driver *drv = to_scsi_driver(dev->driver);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 6c4c3c22f6acf..71a9613898cfc 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1152,7 +1152,7 @@ sdev_show_access_state(struct device *dev,
 	unsigned char access_state;
 	const char *access_state_name;
 
-	if (!sdev->handler)
+	if (!sdev->handler && !scsi_device_alua_implicit(sdev))
 		return -EINVAL;
 
 	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);
@@ -1409,6 +1409,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	scsi_autopm_get_device(sdev);
 
 	scsi_dh_add_device(sdev);
+	if (!sdev->handler && scsi_device_alua_implicit(sdev))
+		scsi_device_alua_rescan(sdev);
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
index 2d5db944f75b7..8e506d1d66cce 100644
--- a/include/scsi/scsi_alua.h
+++ b/include/scsi/scsi_alua.h
@@ -24,6 +24,7 @@ struct alua_data {
 	unsigned char		transition_tmo;
 	unsigned long		expiry;
 	unsigned long		interval;
+	struct delayed_work	work;
 	struct scsi_device	*sdev;
 	spinlock_t		lock;
 };
@@ -35,11 +36,15 @@ void scsi_alua_handle_state_transition(struct scsi_device *sdev);
 
 int scsi_alua_check_tpgs(struct scsi_device *sdev);
 
+enum scsi_disposition scsi_alua_check_sense(struct scsi_device *sdev,
+				struct scsi_sense_hdr *sense_hdr);
+
 int scsi_alua_rtpg_run(struct scsi_device *sdev);
 int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize);
 
 blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req);
 
+void scsi_device_alua_rescan(struct scsi_device *sdev);
 bool scsi_device_alua_implicit(struct scsi_device *sdev);
 
 int scsi_alua_init(void);
@@ -53,6 +58,12 @@ static inline int scsi_alua_check_tpgs(struct scsi_device *sdev)
 {
 	return 0;
 }
+static inline
+enum scsi_disposition scsi_alua_check_sense(struct scsi_device *sdev,
+				struct scsi_sense_hdr *sense_hdr)
+{
+	return SCSI_RETURN_NOT_HANDLED;
+}
 static inline int scsi_alua_rtpg_run(struct scsi_device *sdev)
 {
 	return 0;
@@ -66,6 +77,9 @@ blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct request *req)
 {
 	return BLK_STS_OK;
 }
+static inline void scsi_device_alua_rescan(struct scsi_device *sdev)
+{
+}
 static inline bool scsi_device_alua_implicit(struct scsi_device *sdev)
 {
 	return false;
-- 
2.43.5

