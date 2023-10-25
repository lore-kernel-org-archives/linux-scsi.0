Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED36C25B48
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 02:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjJYCjG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 22:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbjJYCjE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 22:39:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE5010DB
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 19:39:03 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OLUTY5032550;
        Wed, 25 Oct 2023 02:38:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=KcnizXCNrEoYFUAtf4EWgdIA4JdIQ38D3F1xqi4jcjs=;
 b=R15uRUyk4hGA4jYJFtWXy63mc3y7rKVe4y8eXlAucxy3H5v4QOM3e3G7fns/dIWSuAI9
 tIbGWzfmKaYW+Pvna7EqMBueP8tI72cDy1Xe0bFWnRCMhTHZ0FuO5RacCiMN/CoUTaom
 M4sh0W5ESV8jqHvncub2ubpTuNJ9qmeZQzYajzaZJX8tKDHIRr81fd+pSCCb6bgJzTAw
 D7hWLX6OJc7uTEkEVwPMGCWYHV+Pp2EWJsvTymQuVWxzVbR+zWs9dMwU+VVRZdFQ1O6d
 idkarsB3pkE6NJqfpqLdtDfwFJ4TZNihjDPVEc/h5S9U+r5gGqE1r/FVsja17Uh/iChe ug== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv76u6qmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 02:38:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39ONtJkP034729;
        Wed, 25 Oct 2023 02:38:56 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53625sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 02:38:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnWnPlA3qasiLvbKZyTCb/Mf2cVS9medaPSdgYithcYfVgF8B0EeUVcAWQ5FnPZIbC14ST8gaHbFbUyCkNmEt59OEBRPfNbPO/8TZ9czL86Wj+Ebm5S1jmO5AbD9WgMFEVOiYGBxTWYa1ZYprdqPXpMU9BupjdAbBXGFAYGEjVxrczLMF7qxc0zHdB7ydEvCedyJwrOXluKLLSyadVw5sRr+N/dNrc1ePi10o8eDcgkI2xZBZC35KvQRN0Mtm8ScLVs0VawJ6phL/09YCx56luz98o90gfj5OdJHSjhyjToJb42GW8e/nMoRY0D4jnkJLQRgACQyU21iNREQVKvHGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KcnizXCNrEoYFUAtf4EWgdIA4JdIQ38D3F1xqi4jcjs=;
 b=hy6JX6VuMYDC2Smr5+gXaJJ/c5EmGIIVJBzXgVdEEkJXtxataBv4vYCLoV4rq0kIYvhV2PhvJvubJsqDL0m13XzGWs3ZRp3H48T7iElNZEFBpupl+AKmczqOSOzSYr6vWB1O/7m5ag/OHUkEbuJSRc2iTmkP0vRIPKS3iM8i4zcd0sur2l4LBLHpOBpPfKxalzSNosolnHOabYVyBwroet/9qdOyFR74xfjnYZE/ba+SEtAcpp7X5YqpYqSLgygmj3a71Vs7cvqX7+2zFzLQijVWSaW0KCI82R99TQ+ntDpgCV1ynwHAkKJw9i0YTaAdZMmGOhBIigZXNG4j6HqIcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcnizXCNrEoYFUAtf4EWgdIA4JdIQ38D3F1xqi4jcjs=;
 b=x2IwwoCXveaO01bXobpeOllNfxGRMqwMixeWReBChJ6qhHrf76rwoatHlWVJ+C7YwkReWDN1Ws1Fmpm1vLf+wOeD+0vIglU3iIIFnrSZVj2TRg5XAswepm7whQpqL7O5j16ZViFtoXC1RKUdeSaSr7y9Ecig8oONb8L8RaKSMCw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB7401.namprd10.prod.outlook.com (2603:10b6:8:188::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Wed, 25 Oct
 2023 02:38:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7afa:f0a6:e2d6:8e20]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7afa:f0a6:e2d6:8e20%3]) with mapi id 15.20.6907.025; Wed, 25 Oct 2023
 02:38:52 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] aic79xx: fix up NULL command in ahd_done()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a5s7e896.fsf@ca-mkp.ca.oracle.com>
References: <20231023073014.21438-1-hare@suse.de>
Date:   Tue, 24 Oct 2023 22:38:50 -0400
In-Reply-To: <20231023073014.21438-1-hare@suse.de> (Hannes Reinecke's message
        of "Mon, 23 Oct 2023 09:30:14 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:a03:332::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM4PR10MB7401:EE_
X-MS-Office365-Filtering-Correlation-Id: 566323a8-eec6-471a-f732-08dbd50386e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dSdvPa9YecjBEO4v8OdYnhVeo53oONJrmRusGiYBlWEfokitNpxW53gU1T6R/hKYT3v5hlk/bQJyYpNKmyOjPUeUY+E6GAN76UE+iALT6xejLdIH0oMLLlkU1pg5yfVh/izEUcAw0FSSNjmyMdoFDri5Q2MiN1CWGQMB1Hh9EPl6O9maNMj3W/7hUCDzbsRCFkNGRarGYbTLLKajVBV8rqlF7Voj9+h1XozRJOeNzoBFPIus9BgilYhHmj16TQnd1Wdkb/jRCxjwMRFz4pALVVdT8WCWY3j4F6WHJnuwIfUUkfgGWd/rSoI1jMvbiNrH0xJdqRi/gZx6p/JDV30Dy+JcQuph/xPKGYcGToDmePAGXQKIApmPBbvXnD/nixKFyqrltncsuibifrnDYEiW+LE0prRxkDIa5DWkqEnTh03lW0kxE6tZf1s7sHOOixDXTPNtxMKgGg3y0mLF/BXUWWvz6Hx0VnqKxv3uOj9PYYXCdVh34cg+FyCL5D4D9txVZ2NdFHfeUnlk9gxAcTknA6w4lhNf0wjBIKWmNpiTRSvInFo17srNrWqe0pFex44E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(39860400002)(366004)(396003)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(26005)(478600001)(6512007)(86362001)(6506007)(316002)(6916009)(54906003)(66946007)(66476007)(66556008)(38100700002)(558084003)(6486002)(2906002)(8676002)(4326008)(8936002)(5660300002)(41300700001)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hzfYoteAtV9ed80ZjHTuXz2aClpF260z/lwK6uJC3mnDSiU+cpBkVNvbW8sQ?=
 =?us-ascii?Q?bLSXnh4Jrqw9908c6zcHpSZL4fKaVHRbyGF5mm5Vee8dinRZZtDFQxUTzD38?=
 =?us-ascii?Q?Joecy274fKJI5XYQL6CiCW8aIPprdM1laEu2tmS2O6kpXZKU0OvfOTLCFmB2?=
 =?us-ascii?Q?vJD+hfQBRU2wxP37nVvoRu7Kxuosdj2SgVJAsVkT2Kn+lAVPe8UgMoi+ryyV?=
 =?us-ascii?Q?xUlQPQFoGb0tlz0uTB0eLBEvQuP5UkCcrsrKB/5vXVFKqTmgSOWiO72+FR7b?=
 =?us-ascii?Q?iLyqtNevy0VCW5mDZfDDRsVWaK3fQXNCJ/EfiX1AgJCkA6KpmyCjkyIhvwL0?=
 =?us-ascii?Q?VVvwZfye2dYxwJ7MmBPaihDhkA7p6tqnkdWLHO44ghpm1okHaUfzU0UoKW4i?=
 =?us-ascii?Q?e80WMDBXert3pGpNUgeVsrB26FjK5GB3+3vv+RMYgUu+dHUTdbr09aaMv2Z2?=
 =?us-ascii?Q?JayVn9PIqEHmCjIACXUdFSuY1NqmiudP/Lb21jJYyOreo0DCOnlHrnT2Lmm6?=
 =?us-ascii?Q?iVG7SyFqq3198h0ph1EFm/06ssoh5c/tEwuW9cCrNkLBMwpxum/NFcwfPLhI?=
 =?us-ascii?Q?waicQySnuerUHEF0pvD8ll+Jvg17FbnsYgH3BU5fmxjMhoMdsj/2d9jOu2Qy?=
 =?us-ascii?Q?Cbd5p3pfpv2MBM72IIp2iebWdR1/gbcSUTXAJB0XeuSUWh56kLTCAISYchHz?=
 =?us-ascii?Q?Jz1XkaXDhO4vPBDtFfz04OfkyD7D/gxdUYnjGnzwEbIgqEamHBZWeT1tL7ER?=
 =?us-ascii?Q?blezKOb5d8P4Mzj/F3XIQAwe2L1HEzsbOBOwaBf63UASaNMszVOezKRImQiQ?=
 =?us-ascii?Q?TmDOZfmVP0y7nuXpC5AcSylnWdqyQYiRTwhi2nVdDh81oQP/JcZYsfsGudPS?=
 =?us-ascii?Q?uT2DATlp4Dl9Dtw/LsdnQp5f9kIW/QZxQAv+VCHc2YF56qktql75ERDR96P0?=
 =?us-ascii?Q?KevMbTios0WR2RXNKR+2IVkdrlHYxIAR4N/qu2nuIzJ6MxQPNNYzx8q5H9zF?=
 =?us-ascii?Q?vRlYrh04awXucCXHwaS2xFjbAQBowNGbKRPAAMkhelvaq2f6lnUkA5NaYjjR?=
 =?us-ascii?Q?lyjYtTIETwFeoaF6lQ3cf1TsGZLMaaZ1GgZaqjoZTq/1nuxZe0TnHZKzPqF+?=
 =?us-ascii?Q?n5oRXR0NxeX6SUGjI42WH/WiILU7Gzxk0eC2psbnQX5RUOrrudUHjhglp+0g?=
 =?us-ascii?Q?3PZnnzi/zdkZtR7WhEqyRQ3dlW393pZg4RMe2E3+SlCiSkuUzEbsw5F43940?=
 =?us-ascii?Q?OI3hr+rG+VbGEZF/b8a0bqC8JcuxU8JCgp6AyUB84HITwyjQEMI48PeTuiEf?=
 =?us-ascii?Q?mENrqm8DZQ5rsg38c05hG4Vn52mmqiEbwwGjv+q5wE+/iTZZSLgySkuFS7uq?=
 =?us-ascii?Q?hOYRfTIxgBTg6h1cKRnV9Sjhoe5wGWyscDm8VpgFWBo3Ffe+YLda+wqxlmQM?=
 =?us-ascii?Q?OUBMT3YIfCbCjm+gpPqXlfTzb7Xo+XW6ckkm8tNhqbWAzbSvadz6aYHwRqZ6?=
 =?us-ascii?Q?hff4jcMPyOTMkew1sh1gN0EBqGgPqTtICMQdf+LVPcbhK+kI16MEfyK6Lf2V?=
 =?us-ascii?Q?mB8EelfYZoqggygmY6vT023Wp5xILgBWAyTKus6BcKYFpLgZFpWZcr2Pnp+a?=
 =?us-ascii?Q?nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: r8Ql972eA6tQ2T3n/vJg5Xa6AEiRZD6f6o6QUDJnYjuqNLtVsATLhwYHtbPjzL0s+4WU55E4F1wWtKWWhkDInvZZuouC/5PSQ/nzQ7TQipqCFU4OabvaFKQ71/m3FK3nd1mFxFoCQqNiOzYh/puco+vCWJjGyo2DaV+UNpT8ezlOLiM4hVPcFX/gQHeua7g8VyIM9GEAZFcw5WJmV3hscmfDfLmMDNePmDSnI55mkrrK8DA//GCxM9KsmvYs0ng4o01JssOVndqYanJCJ/ZBzF50jpBaXVCXrHsJGBjq+L28Vk3vWH9hM+stbKNf7RVRavV9/Fhhi42HhaoqepBL3oBBS9SWQrWZwvIR/2al5AHyY4al99azsqdcqdcz3WRfXpYWWSiVURf8+1FsuapA9q0dgHcCgkAsxtzHwRAMaXjTGuL6jKr3xKuXA/BFBSvAqdUwLpj9pRtZX3ZcsEJkr6F+6K/+jEiiU+63f2LYux4MzaICV2U0CUuil406FQ5WweZvMJgy/xx51rQjWKTeKDL5qWEQm49SxkYqygKzvkNXMwx4/hl4f/rXW1CTptKzVdREfsdB2w/DCXD6mNX48jgoNYHaqA9ZYxLFwPJ1tEM4g8AWXXMrjVCfWSEdm/uJnL7CHKCLHnWacdqTyyAulk3Y/4QW57b8oyHdVp9IJTVRqyVgwncS4gTxAKIHGwRb69Ja8OTiY6CcpzndQdAQ3i5rtn6WORmwRL5LNOPIwwOXYh0a9uQYymn9FQx83ggHWhZD0PhATJY5m6xgh+VvQ/xcK2AZaKwqzc3MfURiWoGrq75MOYHfaANLAHRpJaNu2pMWnDfMhHThRa3d7VfKl9wDFnnucQCUwsebqtFFfGX4zTHtTlMcfH0ZnSeofzWcD6vnbmsuoyzWy4fr1Qmfuw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 566323a8-eec6-471a-f732-08dbd50386e8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2023 02:38:52.9023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z+HrSPChY8mUiR7X2NEB9e6EwmVT7gZ8MnFWRwRqGMO/dm341af0LesjZsMIPmqXjKj015FJoD5yxbSgKb+K9GEyXe38TfDB5pHcfVkvTho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7401
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_01,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=800 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310250021
X-Proofpoint-GUID: oQRraOm4_HK2_sS6whzJqCwFu3mzYqxO
X-Proofpoint-ORIG-GUID: oQRraOm4_HK2_sS6whzJqCwFu3mzYqxO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> Found by smatch.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
