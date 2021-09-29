Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F05C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FC5F6135D
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244058AbhI2EVY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 00:21:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:21560 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243962AbhI2EVQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 00:21:16 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T2ECsd013609;
        Wed, 29 Sep 2021 04:19:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8Oesj9fIHVSrvVwYPG9RPyj9mFGr9H6e8RkJnDwYag0=;
 b=MNvTIGywaHtlXP+e3jo82SKDCN1z1zCIUIHb1wqWo1YifAL6OfjGqRcZ5Ju5HXISuoho
 dFnvmQE09jJd5QcnNQEqaG0xRa4m/wgWRZBpDRtSKO5VDXXLbejVebC8SWjygPN3lVDi
 L7NgIRN7EKn8w869JzlC3LyzK+Xo8peaQKmMqQ6ySrMP0apHC4LXCizD0FP+Ev0OPKcO
 pOGLDY5AGhzjjdoLBHNmsXqavG2ct6fKIxQJvr8w4aHc0Q9gd2Zo0/wmBgr0r7CRyE6m
 LbIW8yLvM5Y7iBw7w4OilLHIj4zP2qRXQKcRZNydBXpP+4i2WyuYm7CtokEKWYF1RQ0Q 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcf6crd3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:19:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T4AU6l030852;
        Wed, 29 Sep 2021 04:19:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3bc3bjb6s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:19:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZypM1Yf0dWmCnEcGVLkc59Oa4CsKPHbsTYbdTk6GPAAm5PyxGzR84FDfIg6CryrJUM0UxyiNluU+CopDjtZ8GAQuL9hyeR1XrXsLU3BKjfn2GqEUrRkCgqjbH1NCzRthnMC0ZjogybbQIlCFDG39pXUfZxCs4WjTc1c7aHGNNKWI/ZJ8dLrDpXo0PL7qkodnot7SBY7xyXNRjZc+M7lbkY0DuwXHZkh23liYFQRYS4JKGX7X5kfq4cy5VWXwiAb0R1/ejOQ2Evpd/7ffy8sxUT+YNqoRfy0WoXOiaWD/SJmtDt32SpFBmjT3MQUEAdzhJlNcHmlGYb8nLZrOGUOxtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8Oesj9fIHVSrvVwYPG9RPyj9mFGr9H6e8RkJnDwYag0=;
 b=ly9rUiP1L+SM9Gmsv6UJFS/BTjylEwdX4ek9eGbo/Ni5IEycSwN52eueE3NYeJiQ8iDNjoa2c+pHgSxwxXKDCUOw5yUplWiDJXGHz1lzIB6PEdgo5NW5Xi61o5k+4+uO5ACFA6mfUt4Bm5LXXA9PoRyQ/+kUrvX+rm9T2t0H5Fahax54iOotw9DZqgM/DCAgAAwbC9sdII1w5oLlCGhNfFRgFZPRalc98U8U95oezRBJKv2ENLK0oXfWil8+SzgZNITE2i2+tfAZDaH06gcFF3F1v2M5aN5LoeOcWKsa6jnmcTf+7FoZ6T3Y3H81Q/K+i+ih7X045b7XaiXXAoBhog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Oesj9fIHVSrvVwYPG9RPyj9mFGr9H6e8RkJnDwYag0=;
 b=hKTr7HfpidGf8j030OASicRBNcls9Kj+BRgsOwqxLR1mvN19VgUO2q9WMbvMNGmO45cFY8BDCjlD16U7XmTPK5oEinitwJWkBNNaAgcCJnTn6MfrFIGfQWI8uOGBYKu5Wv6uAJGgs5TndfAxiKf4T3ohgx7VhwlAI9myrOLkCJ4=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 04:19:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 04:19:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"
Date:   Wed, 29 Sep 2021 00:19:17 -0400
Message-Id: <163288913991.10199.6433943578236788309.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210924230330.143785-1-colin.king@canonical.com>
References: <20210924230330.143785-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Wed, 29 Sep 2021 04:19:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f5866d5-bde5-4ae0-3600-08d9830052b7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4551557B01A54357E69EC36E8EA99@PH0PR10MB4551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1dZOFCs7s7DS6jWJLf2C3ZZyKkpTzI29uQYlTHZm0AM/PUcCVoU1gtKEzeFZAyp7irguOqMd5CNKJf4pau3k++PihYmgvN9vzRRrQZM4uiQPDlmOI3N5EetPMMioMDjNWIuTaWrqB16/hkUtnVzJ/IvfcrFoOn2ZqYZZzxwbFuZjp1obSv0YfOdqBj/e+3gN5HxyEOlD/wedS8H6D1Kg/c3T7pPCMb2CZ7K3QYdBTkSpRI3I3rpiFk2tYy+0UrpcbU+SevT5LU+QzeHmTAsZozHnrfuh5Xc2lNJYRUiAvNtlITVP4I+4NZCFiV/M3Ga9dAaJnQ1jdJL8ZqhnJIpjOxt07MDfBj2VRQucjeuKum+zP4rZpG1Mh4KPMpCkpGs6cekVmQsE2z/LXgU0lL+1eGH6KZkxaXHn4xal2IohA3Dm9UjC/F8fB61pgGf6kRI5rbXGDqfF5kvgB8L6OhLLM3AX18MdDbFS/e+HSM8Kgr+Po9/tDTh4i4fI68VOK4DEwsqBqs0EZUNQ+tXgWmBjexurI7YLuqv7Z9NDvaaEe2AWwmC4VTcj9zpl0S5e6FWWYXogr/CpMj3r5G4kiYsqY+h6ZBOOt1H7mQ+9l+E1KohwFB+IhRDPdchkdee1AhGkGMaHTCIUykczCkZnRpuxaFbYJ/ZzkMbhK2q8oRaR36rGcVmA83yyf9YHjKdPeOUvFDHCDj9s8x/rTRMfbvfEMdxfVUVaZxHR68IvzmiL0OLikhvb4oogeU8DojjwDSPq2B4oFcQjJ6S7zcATWvMx/CXV2H5noFDofFFMNOzV4TQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(4744005)(966005)(6486002)(110136005)(36756003)(103116003)(956004)(316002)(5660300002)(8936002)(38350700002)(38100700002)(7416002)(2906002)(26005)(508600001)(66556008)(66476007)(83380400001)(186003)(66946007)(8676002)(4326008)(7696005)(2616005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmN6RGQ1amRET0JmekNVSTFEUHovRkJEK3lZR25SR3VLSzdaelU0MjVuTHBx?=
 =?utf-8?B?bFVmV3dmNnUzZ3VMUGt4Rzh4Y1dmbGhJaGxpd01oek1lbHdUcDBHdVBxSGV6?=
 =?utf-8?B?M0NTWkxyRldOaGVKTG00VXNHYWpJWUlTWnFaSzlDTEx3Ky9hMGxpYXVOT1ZZ?=
 =?utf-8?B?dk11NXFDSGpZQktVTmZEMC91eThpSDVsYmxsT3JjN1g2UElHQnRvZWJrTXdC?=
 =?utf-8?B?M3JiYWo3UWJmSTV0cEJIbWNjT0p4WDB6ZTBOdXVESnVPMFREZVhOeDl5d1Np?=
 =?utf-8?B?RWRKUzhvS3F2WGd3eEdLajIycnVBNS90Nkk0Z0RlWWI1RjVDWEpCeXlLcVpZ?=
 =?utf-8?B?RGFkZEFCSm5QWFlCQzg3MVllUUx0UFVNL2h5Q2dZeHkvd3VmR1F5bXBURlZO?=
 =?utf-8?B?QkdMQjBMNEgwTVpxcm1wNGp4aitDcWhqU2YrTnMxUFcrVFlJWmQ1S2xad2Np?=
 =?utf-8?B?SVZ0bjVwbFBNK1dLY3hOZmVaeWFSbnBQbzV5aUtReTlwd2pqVVlQTElOZm05?=
 =?utf-8?B?WDFsVUtrT0V6Rk9wb2dBODJ6cHNzOVc1SklSbkhSUW1SakJlQjc2ZFlWSUlq?=
 =?utf-8?B?eEZOK1d0RVIwNTBacGhhMm90NmN2N2pETmdkaXZxTSswZTNrQ2V2YVlIZnFI?=
 =?utf-8?B?OHMrVmlPQjNuU2NLaFMvRFhwRW9tMTBYalJQUXhtNmZqZWtSaWw2eDh4eWRP?=
 =?utf-8?B?eHRqMnB2UENIcCtPRnI1eC9BR3B1cXMzRXd2TXgwZi9yUUxaTVk5cXoxdHdD?=
 =?utf-8?B?b251VG5PWmxNVDdvQWE3NDd4dnhJZFJOVlB5QXdxS1NMQkh6TDNTQmU1NENY?=
 =?utf-8?B?SXdBVnY0ejJ5UG5PQ1Npd1MyU3lYNDhmYlI3aXZ6TFRPTnFsYXNFMis3ZU1i?=
 =?utf-8?B?cENKOFBuYXVYSzc3cGtrejhEdVptR3FxMm5LVGR1WmI2R3RBMkxyeS9EN2xJ?=
 =?utf-8?B?aHUxdG5HTkhhdndzZUhaTEpQbHo4ZnhUVG03S2JBbTQ3WkpmTXNtdEVoS21n?=
 =?utf-8?B?VWxqTllPeU50cU9aZDdUcGppQUVIL0syajVXOE0zUmpGV1lVcjRGZnRvbEVl?=
 =?utf-8?B?VUw0VHN0OXBlUzhyaFdGVHN5YUR4OGhLaytRZ0RWQXU1NXFNem9RNUpnMTNF?=
 =?utf-8?B?cStUUWx3bkRldjB6QlhPYkphVWE3aENIK2xOZHljMk9sS2tWaHdiS2tMK3Vm?=
 =?utf-8?B?MGZiekdjMEU5cGRvcXZEK0t1Y0ptNlRjaTZkeDQ1UittamZvL21TZWtSUDZZ?=
 =?utf-8?B?MFE4UVRVYzFEbENWVVdPc1A2NFY3ZDJ4OGc5N3dhK1grVXlxd3JBclpLMFg5?=
 =?utf-8?B?RUxsSStBMmNuUEdaRWNpaTNwZFE3aXpHNzRQenFyY3R5eDNGU0ZBWEU3c1ha?=
 =?utf-8?B?djFiRGZvNk52SmhoK2NDcFE3YitQRjVHdjliNWNHa0sxSThlUG9xc1hWdGhi?=
 =?utf-8?B?dENTT3dTMUplNnVTMXZpSEtlaEk0bCs0Zm9kcnJrdmNiNXIwejBrSEtRWVE1?=
 =?utf-8?B?dUZ5elpPOEpreE40S25KMUNyYUtWeWhIYi80eVltS0prbXpFWXFwM1hGaXd4?=
 =?utf-8?B?TzBRWEQ4WFl5anVzejlRWkVwQTVmRUQ0SFgzcFJ4akpXc1ovUnY3SXF2ZGtz?=
 =?utf-8?B?Y0YxT2JmNXZDUVFvODhqOC9jNHJkOWpiclU5OVowbFFjYU5JNURJbW5FelJw?=
 =?utf-8?B?RW9keks1cXp5dzB3ZVora1VNZW1UcVIyZDMvNjIzbVhvTHVVK2tvbVE0TE5Y?=
 =?utf-8?Q?4f8f83/JfyvtdJC1zJkoZHRqi+xhFFUP98/FIL0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5866d5-bde5-4ae0-3600-08d9830052b7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 04:19:26.2494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OvSUGGTkARreGqdoYnyiOtARFrWt9CRu1zHA5qTcXE6D4rwcD1TQm7xSL0gYmZDQcBkpVZXV3+PKT6B5OeRGCp0zc8H7iDiv2ee84ITGqes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=736 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290025
X-Proofpoint-GUID: W5CJG7F7Uyt95TaUotDb3jTlLm79bO7X
X-Proofpoint-ORIG-GUID: W5CJG7F7Uyt95TaUotDb3jTlLm79bO7X
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 25 Sep 2021 00:03:30 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There are a couple of spelling mistakes in pr_info and pr_err messages.
> Fix them.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"
      https://git.kernel.org/mkp/scsi/c/cced4c0ec7c0

-- 
Martin K. Petersen	Oracle Linux Engineering
