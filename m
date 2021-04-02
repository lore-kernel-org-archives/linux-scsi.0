Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D867FC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6A660FEE
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbhDBDUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:20:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35310 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbhDBDUs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:20:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323A4Bf027616;
        Fri, 2 Apr 2021 03:20:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=WB8xa5cUTDLz3UbI8cPvfubuJswS4G5PMM+AqUwIuC0=;
 b=GN4FxIe7WA+Sh6vVE6eW1/yCj1MWlKbZoT6moo6xggToaxLtSA2Foe+yTexo1ALVgJi+
 t08No2RcYMP/R1hRedG1YqMJd8NaXnXKhhY1j++qAhGlIc6Nu/b7zfjiA5IPLQotuAil
 5JW4eGTfedtyStYbWWwP8TyFvWHnQPTnxMWxtDHH9upNa6uYZx4lof6rfI+TGuTac6ju
 7TnOMYtPzpwSSIuIJv4CScPM2TBkCIwVNyCVPQEV9a6nUqin03Im+jiqNLHBxxnkZiBH
 u0LDiUb/GpADRO9EWiep7VdYQAoaoPpiOixq0SG2AU/8+Cz6hmKaoonQpRMe+8q/3fah KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37n30sbk2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:20:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13239cnT009146;
        Fri, 2 Apr 2021 03:20:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3030.oracle.com with ESMTP id 37n2atmcb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:20:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIYOu5vwJeFerdPJHTO+SQ1YL3nl9O0aikcJeUlkItq7a2cqL8YR5sZUZa/FBKW6i7V2YlBVVN1CxRFzKG0HCLO2qd+Mr07rimWQ8CgYpziFGnb3MUsfu9z45wlYr0tNqSrsLKP0DNTJtTqe9RzXf6/uEsujivqUIzOiqKRePgQSMp6uG5onvqcJ1AI38fnMzqKv/z/SKTrvbGKUMiSbirtO+HjhGBwPMKtU1bMGtmkmJ8TeD6ZZrKrigeQJon2CfTLrS7vEMH3UjNEjsi4g92hSPsfgTQuTCbkBRSg9QEZ+Gf5en/1PnCy8yRlSEmFbgqlX9g6kMHeOWXVSzTT29w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WB8xa5cUTDLz3UbI8cPvfubuJswS4G5PMM+AqUwIuC0=;
 b=kLvo99kx9H80RlDjoi1pGfR1pH67mtyqAFPAIQlZ3yW0LseeTElxWt88zBwuzuuDIo3GqCXIlb3tPeHiVyDj441BWTtDk+HiNNn4R8YBI4LCjtWfawOkWEmUOeXDU/NZl1D9orrReaupXH5bsxRLfaAFc1MfgPsDyIKZu/srfYg5sKCybBvVhPlkgL9zBJI9CvfhZcDPn6qtL2q9jxrk3kFb8xqBEEwVLHwn3UepwY/4XuUv7Hu5YmIh3XLyLPulL01QsaSVgxIcpkTiSEW1+t1B/DUsIpczodDBtsmzpjZdfemaXVi+ySlxxkv2psoMjx5wbvVy/DBHLtABvGiTIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WB8xa5cUTDLz3UbI8cPvfubuJswS4G5PMM+AqUwIuC0=;
 b=lH1ZvxBp+jGdTiE+wTHrFR314EySWxbB4t97TesJuyDrsTLNRame4wcPkDQcKrN1zUXs0m9Cpw31gfs0cAUeXNA8hjnDWOPvExOfoMf0X4j/M5seM9ybmmJpBXq0e/3aFEDxQ7uZVIh8cEK9fYq61vSWSIlrix8V3mHCzwwAyWE=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5419.namprd10.prod.outlook.com (2603:10b6:510:d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 03:20:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:20:31 +0000
To:     Viswas G <Viswas.G@microchip.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Ruksar.devadi@microchip.com>, <vishakhavc@google.com>,
        <radha@google.com>, <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: Re: [PATCH v3 1/7] pm80xx: Add sysfs attribute to check mpi state
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kgpfk6o.fsf@ca-mkp.ca.oracle.com>
References: <20210330064008.9666-1-Viswas.G@microchip.com>
        <20210330064008.9666-2-Viswas.G@microchip.com>
Date:   Thu, 01 Apr 2021 23:20:28 -0400
In-Reply-To: <20210330064008.9666-2-Viswas.G@microchip.com> (Viswas G.'s
        message of "Tue, 30 Mar 2021 12:10:02 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0007.namprd05.prod.outlook.com (2603:10b6:a03:33b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Fri, 2 Apr 2021 03:20:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b43def27-0e1f-4096-da2a-08d8f586452b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5419AE4E8F5D2E3668C542748E7A9@PH0PR10MB5419.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kemLjk5mY3fk+aaOlGkGM+UGcszcBkCCaINnASNbTl9PaY3YCzYxGXcHxIlw5S2V1VnRBJaGUxrHwFuSoqGLEs2osYo92ATTdJZNqDVDZnp67WNiHotTsPAGmuss3UZSQOTgd1H1xCwCB+iJnS0GcdciG32a9CfAkUwM3sUlskDQ+gQvN/4JpTjRLMcKEJeJVu8T+Tk7lEFyZRdd0VpKA21VVUQcsRMPuZ8YVax6XPWvN+9tCmqxJSow43hQ4hsJPuHmSMoWhXZT/aijHH8aV5bwkrK2kqkfpzN+2P7FjjyhdvAMrpcxU+ExX0v78IcxWuViP0noVf4JC+yS6XEy1yxdwCG9ioB1OLWNIopaU6DwSUj/hkKCBFBEo+EIHmP6tsBTeRMLj6zORz2psEfF0+UjVGYtFpEh/e0IurH3dGWqyrtt/3EBMzCZdUWTQfDhOXH2fZ6cNma+2mJ2V+wk68MqBr63+7WLTUhWmf+COF4eSQQeAMtaRckzmb+B4IwbZyVPAOXHxihaGEu8N1QK0FCdGu/OJauRUggyqdCaqLGneKoVN/YhKCMLWHz1vS5peyst4Mq8ZcQLXRVF6vGRQsoajFegA8d7g5JhYvGPdXZ0ZMCoRyy8OxHhmWj/sNj9xXfQK++7Xei8oZftW9W4BZcr2CUPD8/T2ED8z1HEwBA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(376002)(346002)(38100700001)(4744005)(2906002)(4326008)(6916009)(55016002)(478600001)(956004)(316002)(54906003)(36916002)(8676002)(8936002)(7696005)(52116002)(186003)(16526019)(86362001)(26005)(66476007)(66556008)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KzyGB0hGpydP1EWB3Qzfs4EM5Ugaia2zxt9lit1RDqDSzAX7Nz/KKQ1mntqz?=
 =?us-ascii?Q?KOuqVph4ly3YJRQuffI9uhorJWukwfCScleCS5AQzCrZjotIzig4q5q1LWpC?=
 =?us-ascii?Q?0MqKczBzKje+VSW2gk3idRf/j9M8mKmwUTBR0nnWVBwtClatVDO2YQx7/pHi?=
 =?us-ascii?Q?QCJ5LscCjh+TNscLRod8R1BydW3YyQs83amj7BOiSHqcuTkF6/HeWL0XNHTR?=
 =?us-ascii?Q?EEebSArTxdDBmZnVDUBNHkxi3siQbw8wwC5hV00HvfwV1hdEEvqQr9HW9N5j?=
 =?us-ascii?Q?Id3c4j+0m/CN6KEBhAHEO+ZXBMvXQmnZ+5CYCY9ZhGvoonEvZWu2xlMuSvh6?=
 =?us-ascii?Q?DX3D+YNfL+8jqd9MsRA8Ixa2U/vzbyBhz+pUd9XYT1wINqx7InWv8H5qT22a?=
 =?us-ascii?Q?GOqfmzC0g7DQIgm1pp6dSFMKg5Xve4O5FokhsoCx5q23U31aCnUAPYT5eXHy?=
 =?us-ascii?Q?H/1Osoh5JzXRGXXsArnG/QaQotEm3KDkVdAHzezt2QOg4wozGlfP83+r4Sep?=
 =?us-ascii?Q?3VNSKIl2QSN/Vza5I15RWBjPTEPjKLjsk90Ro5rkdAGSdBpBmNkB9Y7mNMEC?=
 =?us-ascii?Q?JMEmNghaGFflZxxi98ZRzx/jQ4LZpTGGugDB5VzBqtwKGzyBK7e/3c7PDu72?=
 =?us-ascii?Q?74ZQ3nX2i+uvLe9nonzwOhZQWlyU2GkGmfMbCT0wzekxjArVAYJeUokjxvvU?=
 =?us-ascii?Q?CXCe3fIzvMcfWvJdUHjiI8ijH4m1/cK0P7cwpeaQ/bYcLAY9qy3Ke88RtQVP?=
 =?us-ascii?Q?njiofN61n72l+aa4Dc+CC0DwQMdSO+7UR0WgX5ZRTqsU4U2Un4p7DgQdQxVy?=
 =?us-ascii?Q?2KGzk9/CkNWxdQMfpRFRdpoC3u7nH2F2SrazPiu2z90o2M16JJORi8gIMcoW?=
 =?us-ascii?Q?T5R/0I0nDSerOvqIlM2KRn2BJdfUjlHgVg8ZAmXvK8T+1CjtF67gjs/hu5Lw?=
 =?us-ascii?Q?b1m07np0pSCgcNns9vyBSQz4di8CiEiBD9VdK2JuLVA4HdBI3tTxEDH2nMQB?=
 =?us-ascii?Q?wIeif8OT8NVeaaNZKFoRV9vGRjLVJffOzYHvwMMW7Vx8NG9U3mow6LyrERO/?=
 =?us-ascii?Q?lFXkxLw1EO0zpIPk15MkkXM1uQ4BBxsEpx+SRWEwpYzSMEAEUSYbgywhIH67?=
 =?us-ascii?Q?pvY4sPjaSD+epVMUpD07eViPOQre0yzcEWCeQFWwvm4N1tFvpltS9gvVL2f3?=
 =?us-ascii?Q?YFUsORbrHOJ9hDi5RTwtE9ieEdnzeF5mgkyMEUFmq10z3Y5bd0YNAi0585TA?=
 =?us-ascii?Q?peZhIYzls400Zh0WMgroq2dqMvmHlecL9PhyyiudtI6JM5BnAFd4LLcAVpEs?=
 =?us-ascii?Q?kbYdvNbxpfxR5BuPtbQadRhS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b43def27-0e1f-4096-da2a-08d8f586452b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:20:30.9890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6be1C+vs82kf8BwIBXGsqkwvZF2D15LS/Hm4FOddHCY7Lbu7omzNiqW3VhsfeoLuFsIW4+h/Cq6eP9+Y3FqN/kLQEiFhtoHOaj8HFDFFV0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5419
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020023
X-Proofpoint-GUID: VC7Or2sAH7G8ZHhCJxjnFYIbeSGLLoIa
X-Proofpoint-ORIG-GUID: VC7Or2sAH7G8ZHhCJxjnFYIbeSGLLoIa
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1011 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Viswas,

> A new sysfs variable 'ctl_mpi_state' is being introduced to
> check the state of mpi.
>
> Tested: Using 'ctl_mpi_state' sysfs variable we check the mpi state
> mvae14:~# cat /sys/class/scsi_host/host*/ctl_mpi_state
> MPI-S=MPI is successfully initialized   HMI_ERR=0
> MPI-S=MPI is successfully initialized   HMI_ERR=0

This should be split in two. Only one value per file in sysfs.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
