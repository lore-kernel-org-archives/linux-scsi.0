Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF0BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 02:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378264AbhLCC5s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 21:57:48 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16074 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243536AbhLCC5r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2021 21:57:47 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B30lZAb008288;
        Fri, 3 Dec 2021 02:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8Uas4NrzgsPrX6rFQ5SmitQZLJ1XKBtfi6vk2OuCAoM=;
 b=iFJzMtx3FNGzxoYXZUpCyL4kq1LMUBuH14Psx6x83g8b9AEVlasw7d/G/bTBbwYwifUN
 8kZuLfFk3ak2uS0SosGb10zUt6Np/R3RlKCqsBLpY4xSag1Nov33GEpt4cF7y9BDgXe6
 SEP2PWjYRIZBfUsidvX63FOBdESAZ2/dZbUah2I/ICUUVAkWy3jQLTlshwG44PoBCUmM
 DXcO1q46YoKQLqZQnVd+g69ZjEuXpI7gbJmJ+bZomtmyyho5clsrYAQ+ttrY7Nd+NvUG
 cew2/GOx38NntdT1KeBtB00X2hukTr57VPcevKIIbsTPaLY3gLfSAb5A8zpCftiVHSIJ Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cp7t1vrry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 02:54:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B32ppJZ166296;
        Fri, 3 Dec 2021 02:54:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 3cnhvhsye0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 02:54:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1O/TeLiWmQK/PLfp1FBbnkLtG3OWMohbOa+o74c8Ryn1fmQ7JYlb8H+XDwNCDb6Uw1AbeKgXx8TkD9bZ0mAIBdW/MIYwkzz9Y5XQaxJDbfKdedXQd+wc2hfPL+g4Coq2khtZnquNC2oDhxymOTMl7JV4SMP5FZWwnqFisKJCHBUXyF4TGzrw6Zsg2lBLbqk24Ykke7C8yokiMRVq4ZtonRsUMVjAd4iWCtCRYQP4tsG5N5cNYRvX7t15DRKgfikOC+rIFcSdMHqJ/bZhZe6OLGbjRLuyPsRVpuebC3OuI+72/ltszMPnhOwfkzMjoxWuBL7zCyrvS73o4GH+ArQJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Uas4NrzgsPrX6rFQ5SmitQZLJ1XKBtfi6vk2OuCAoM=;
 b=FPaBAGzbJ9ZRHQYVkZoeE+/Iufgz5XpcJ2rA7qybU6bvj7Pjn7VWPWrrwYMz98mGn1dDcPUIfFYd1dvnnZJthmj+8VY93iN6sBLSljaTFQ2bpECLPWGnRtj+2YtaMbPlYs7Ja+0becsyCY+IE4ltOfAV60SnF3r7lMtBy1h1kQxBmnEq2q1LCbNeQSWgbW5KQoooVDkmoIYd26kfDPsR0DYLbUL/9BxrnfDZsAaml0TdzaQH2xVDV/6E9UpOfkwFUK38SWObJtC0VPqYWPoygZODNwEVRYM5/CDOZkaNriYpPAfclJZioai6b0RkUOd48L/ZR6u3pSAVzrhIofd1Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Uas4NrzgsPrX6rFQ5SmitQZLJ1XKBtfi6vk2OuCAoM=;
 b=VmaiLiJ9Tsvf3EMkrn2favL+Vd4cJ6+xmqP/f9Fpjt5b2f0wP7ZYLbeQc+j2/FOZHCOdq/HoKRjn/uustfiSRzXnNBVZuljAj3jnArk7yefUq1WabAaUO3AQs/nPbMPoezuqsfXe2lsbxlPh5xkoGKDa1wu0tq++tUfL4tMYzu4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 02:54:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4734.024; Fri, 3 Dec 2021
 02:54:18 +0000
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] scsi: sd_zbc: Simplify zone full condition check
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rx2wg8h.fsf@ca-mkp.ca.oracle.com>
References: <20211201142821.64650-1-Niklas.Cassel@wdc.com>
Date:   Thu, 02 Dec 2021 21:54:16 -0500
In-Reply-To: <20211201142821.64650-1-Niklas.Cassel@wdc.com> (Niklas Cassel's
        message of "Wed, 1 Dec 2021 14:28:30 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:806:20::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SA9PR03CA0014.namprd03.prod.outlook.com (2603:10b6:806:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Fri, 3 Dec 2021 02:54:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cba2bb5-c80e-408e-5327-08d9b6083332
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:
X-Microsoft-Antispam-PRVS: <PH0PR10MB55649B9A93542D95E205CDDA8E6A9@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8z9Mg1TbONQ8RpGb/3O98OWHg3hVrfxKD33z18R1t3SfN3blWtWqkT6FJzmQQiCvr6Gg4T8hv7goqK9JRtz/50/47MwbLRp4ZyoEYptFTACv9DS+0fqtBYHeoe/ifVGROdDk5d1MkTjiYXOV4hbzE2884RQujjb29MWfm5wc7AIHgnu3wtqkutA6PAH9AzWbIstnOiNBFa4D+CuEde+guKSoQWSHnK+0yhSHgI1LkC3pQv9dtXDvORDDQRcIvzzQ8pCj5QM3G/ba317+RxUQ9SGw0DqJ5SDYvxtZoKFjoOFkpMmD2kKLlurXEMf/0WSjDbp4Tw8uKfk6h4L/1p1c9NXbokrb8SHTImO1Ri0tivQYhxVwN/9SznxjBwdB1nEQCTU1g/ActKP/m3gKFHVD+5GKSEIC3kB0/LkBK3G60WdiVhuuO65V3DB0ZhM2F5aHuTx426U8z6oemAUSzUZsrValP6aff1kwynC9Bgr3Rn4fJfB0GSCLLk33/3RUbAhObsK5OrCTZr/XieqzkikGv1kDMUO5Cn6tYddhVC7NQVnmMAoPAJY5YoMSxF9zR7rWYQi39Xu1to0zCikKmbg/iq5fhnHZfslMiqM6kmT2ZGgO9e+NuZnUxMobhSF0nNnqjV6xvK6aSuI274sSoo+cp7l+0Xyt2K9JBPls0VvkPadFwGiDg8I0ARhPdaoFk7j/FZ4evtRxjIBmBPWKEF275w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(186003)(26005)(6916009)(8676002)(36916002)(7696005)(508600001)(8936002)(52116002)(956004)(4326008)(86362001)(66556008)(55016003)(38350700002)(38100700002)(558084003)(2906002)(54906003)(316002)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?97cHa/D3seNUSrFeZ9H+jMj7/5tgVmLTwjEA0xUiZactQWyVkG180FTBGKNz?=
 =?us-ascii?Q?ojMKEpFXC13RDkxoH1Jnuzl5x+lu5f0/JARag2TeeIlSrmAsQG5IJtXDvKjh?=
 =?us-ascii?Q?OZcDV7wL3DM/y3/s3CC6XVyMpQomOBk6gsmRT3p8B1kUpQoi+/4wB+4YzUha?=
 =?us-ascii?Q?0pw+nrWJgpaseM/MjkTfQJEWpduSPZCDb+V5yHJKlm/qdXMqmIt8CouKFgi8?=
 =?us-ascii?Q?FzrGkgIzRhZfQL4qbJA99rC6ipL0z16ExZLOe62H/FufuS/ZoabXW0w+X4IA?=
 =?us-ascii?Q?j5SDi74ZyICxun9aUEnFaRbAIEPIsTw36rRFtvHCZKGSiO+9LeChAwfxjUdd?=
 =?us-ascii?Q?xyUL0i0d6Hcor9IyZ1e9MXeOINTVLY8Pw/BxXF5q8KL+LdzwB8djdeH1Vfc9?=
 =?us-ascii?Q?9883jE412/CIccLVK5DXxHKNw+7HimmJpquoLqCc107St4Nnd+jLvTqNyGI1?=
 =?us-ascii?Q?J3pT8XMj7sSLTfpO9pqfa/zZSZJ2YQuf4+4nFlQko2pt2IbQ/ZlpqiwD3uIL?=
 =?us-ascii?Q?cq+X16skLWmlHvEvj2X6hTWNpB8dddtNWuOXp6EMxCPM2njnjmxGRds1B6uZ?=
 =?us-ascii?Q?khaTH5WjJ2vXuZEAk41rAorTPGoVRG2/7PJAxXJ0710qAZiRcR1V1ByZWR7G?=
 =?us-ascii?Q?faizBI8ko68dSGrdJ/tHxjhS9+6IFssWM7CnblzBylIJwkFVhOa59+hfoJfY?=
 =?us-ascii?Q?qY/SkLYv82GFgqlNzp2gYCKA4MfJa8/sl8liC72tqQ+6q2n+XBR8IBUcb2Gy?=
 =?us-ascii?Q?GtY9ux+JWexpprAs/RwA1FEyr4ATiCyncRBFMQE/siIi2IjBH8GepGApIkda?=
 =?us-ascii?Q?MJkJn8Jgh8QxfaLKkKaQLRkW4L3YfVzmx8z2SvFbMIvwKrwjhLJtHTCEBZll?=
 =?us-ascii?Q?diKtb6eQNL2L5vmpSG4PkqW8UOrSQIGQ6UYrZLOkvOnzijLO/HIPmsDjk4tb?=
 =?us-ascii?Q?kR/ipR14BsL7wtsB5BmcHIpPff2bT8oNlV2hYxNfVSqcLGmRPXZys+qLvq4e?=
 =?us-ascii?Q?+b8AodDIRAc6sMc8E/P/uy2s5TRUhfR/+fDnRf0EemFJXl7uavEUkX1ttDp4?=
 =?us-ascii?Q?dSz5cweR2xv+D0lOQqHk8xJMxmgDybvRecpCJv7+WBYtVNW4W0kaelHzqrF4?=
 =?us-ascii?Q?2CtBiciS9ziQo9AaiLB8P4grb06/p4yAeW7w8fSFOAhwKnLfNDGpbaExc0pw?=
 =?us-ascii?Q?9ahNWoPFYO04Hw6uKy0FXC/1f9J0FLC9JksLNMl3Fr7/hshGU+PfeOdh6WJu?=
 =?us-ascii?Q?TUJsYJ9uBa3gHJGGe0hDzyhUlVwrNopAZwQUCk0GWoMR+3n7Xcf0zRy3ysLe?=
 =?us-ascii?Q?4PG1YMYGEq2UspNDKbYHTRyvGNRm8VminGRQz65SwpibZZpQjrpQCzlJ52Os?=
 =?us-ascii?Q?vdwY0pP4Tpazo9xxaOdSw2fBxNPYk35yGxpLm5ODglCnmfCb10MdYqD7SAdX?=
 =?us-ascii?Q?GGKOvbzBfB9UgD+k2GzLPIxmj1PXiRDw+i+WARR+F3TkUMRIx83VjlQXgvyU?=
 =?us-ascii?Q?noStUigtsDUswcH76Z3pf1BZLjpvMtMQwH0SkDuzw6kohxuxYuOD8uCo9k6O?=
 =?us-ascii?Q?SzH81UswAK5ucXRpGRyCiKT4DA8jQMnESrCLrhPcIMjIwfhTQe5wUe9itDMs?=
 =?us-ascii?Q?OLMAivk1lf7m4kdpTxSpuxcbQXrlzkvJlMfVmMeb8JVqSCBJtRAq0jHfh36v?=
 =?us-ascii?Q?IJsPcg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cba2bb5-c80e-408e-5327-08d9b6083332
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 02:54:18.6258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YsL5mw+rVMTS/aGwb1KjRq5jttNu2LT+BGTTSOowMjcrf+0Sp1trIdApYgeIk7qPXhKtEkzpqMPR5f3LAzz5bWXi3SJHr5hLIhaUpKUCc8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=971 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112030016
X-Proofpoint-ORIG-GUID: 0BiCjUExJS1mpAcB1JgCZTvAv_Rgfqt8
X-Proofpoint-GUID: 0BiCjUExJS1mpAcB1JgCZTvAv_Rgfqt8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Niklas,

> According to the ZBC (and ZAC) specification, a zone that has Zone
> Type set to Conventional, must also have its Zone Condition set to
> "Not Write Pointer".

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
