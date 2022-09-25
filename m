Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC92C04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Sep 2022 18:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbiIYS2i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Sep 2022 14:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbiIYS2e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2022 14:28:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB492981A
        for <linux-scsi@vger.kernel.org>; Sun, 25 Sep 2022 11:28:33 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28P9RRdr012930;
        Sun, 25 Sep 2022 18:28:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=bKSxJ/bKOsjzTIpgIt9I5k6HjGPou4mIzAIZGgNCjfg=;
 b=m8vvFMPmsJcWrqAUiggL00vLPgfDe16eAwx+pnvgNowAoyN+ty/dxi/mnHnKQo0bZ70A
 mOOcyc0QMJ5YjWgY4YcvRVpXM0gYd7TLU7U06lUt/8Xnhy1XrzElhnwMHumJWZdcPkXj
 F+aZkW2SeTtdGki5tePIGQ0OWfsTrociiWu7b3EhI+w6mh2YJEuN9bnkUJ9wZib65wq/
 tljb1uzqP8uf7E2xh31xdmRhatO1d4uUbcMU1JjfLEAcaZ26pTfTGlAVSrRzLCMODHlD
 APtZpFvs9A77KKIUnF0Io0ita+munltLbdlhsxWUumr/uyQU46u5V+Fm8wA4byitcFoe 8w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jsstpj0f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Sep 2022 18:28:21 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28PCAYxs002696;
        Sun, 25 Sep 2022 18:28:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprsmc20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Sep 2022 18:28:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/2A9Sy244WSXNto5oCyG3BDvmCiTe+nFqKyCzokA2Z1BMwVXAPA6jEsmiq+FXffae6bvSTPyGD34peHqCggvNr/mnH6RJJ8dkjlHmymXqZWtrcakH1ismsw4Olo65YxTNWT3cfwCu6UUKXTYG20sqsOYuEc5q712tAQmTChP02h3asu5mPac2PXrsBT3ib16u+id9EVeX4AWEUx8Rk4BFlFpEaVyI7lAfF/lC7FwXGHS2sods55uZX8HCRhZfqe4sBEu8AX8YH6X7fDyYdajndHBs1rIbURwCHJIbnik37zDzASo4EdD0v8hNYc8j5OB5k/gSdV8tmA622kwb6j+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKSxJ/bKOsjzTIpgIt9I5k6HjGPou4mIzAIZGgNCjfg=;
 b=SEKd4mogmpGXbquNac9djYYN8ddTLMp8QNhrmavkDCVMQ/purrE9Np0v8YdfJU2LBEUUXzYO/5wepE1BL1SZJaPsE1dCY3GVV8PBe+gB+NOYVHUtMyxhOYaoRNHIWpE8+ENH7RvgmBbwME8JT43xUChxr+WCph4qIiZwoP4httx8z2tFc0DYmfBYHXcN4n5xMOryKLMhxIJBKZx95cDX8HBSOKYasoc+GsLyO0+lASWbvw8khQjnpA3CeaWSkhCGj4n6hz7cRsKyFXj4roYM0aPbnTb0JQmv10zOd9d5RnrFbhGJrr/lGgHqvsSKXlXlQKogT25RQpW0WnJoN75ibw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKSxJ/bKOsjzTIpgIt9I5k6HjGPou4mIzAIZGgNCjfg=;
 b=o9aqAiGFEC813h+gKWovIyk4Btef9gXZi1AGp+giZ/VmGAo0g1qY4uHDn58FZzUR9zBa0p0yWUj4Re/YALDEIpooVcGmmShU4ULa4QCwGsMgPavcbTU+kVc2Jyc6/RwXSrbv0V4qHLZv04nR7gzPeQjADGfINq+KGsmkuxzFrao=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB4862.namprd10.prod.outlook.com (2603:10b6:5:38c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Sun, 25 Sep
 2022 18:28:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%5]) with mapi id 15.20.5654.020; Sun, 25 Sep 2022
 18:28:17 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     lijinlin3@huawei.com, lduncan@suse.com, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH v2 1/1] scsi: iscsi_tcp: Fix null-ptr-deref while
 calling getpeername
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jwvpavm.fsf@ca-mkp.ca.oracle.com>
References: <20220907221700.10302-1-michael.christie@oracle.com>
Date:   Sun, 25 Sep 2022 14:28:14 -0400
In-Reply-To: <20220907221700.10302-1-michael.christie@oracle.com> (Mike
        Christie's message of "Wed, 7 Sep 2022 17:17:00 -0500")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0057.namprd06.prod.outlook.com
 (2603:10b6:5:54::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB4862:EE_
X-MS-Office365-Filtering-Correlation-Id: 022f80fd-da2e-4ca4-e4f9-08da9f23b71b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bGaGnmP6CoXaRWN7Q9BHYjcNP3C4+yhUzXylHhN55BWt5qeEm6nxdkDQApNSCIv/0BbiA6yZmTb7bOe2W9Vb8F5OwC9s6rhVIEYlv68UmhDCJZ3F2AAKlu2GT19RSM+XbgiwB6Jt0u1wPPaR4DiyeRBCkloPSe5zOsNGuk7CoPOdnLcsGrGqfH5u9Rj0dzo+5GJyNYs0fUvE/CLlzbbD6rCQ9IladE3DVCLcGjqUwaAm157S2WnCKuHmzYTqBDayhXz8KvjzZ98X1bYg935Lb3yZuFswurwwIkelHAPk/RP4rW2v/JkOFylF9e9hdAstzdydb/wmM2DOI56jnZ4TCYEeggh7gaeMrK4Ezezz+THjFwBnGe6tpX8n80L7VIgy+CvwNUKPNu9ungDVFs7WH2RJ2QMPlACJj0Ss4tq4KsnpiPHEvusjMspqyiqjD0PkIp483h4TBEDKon7YOYsDxj8NKDNCdvo08JCQrbquJwXZn5+GGXWjPg7Y035NTQJR3ZdL6bQFpmbPpbh11XTbsjYtwxHhA92G/nZ7qt2Ni1uRSqZo7tXZUtN66XFwWRdVZvwfucm9hJw2/RqlR4dlQ+VtI5v40+pj7iAKiXM14dJJ26XIsFASDf6ok0rneFH3XauLKNaZLeOHJbu2MUvz0bCQ3R4ikLw2/XA3l+hINuRieCRobsxaT8hAqOTFLm7YemCq4FN5rLlbOjR+3lQIng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(136003)(39860400002)(376002)(451199015)(83380400001)(38100700002)(66476007)(66556008)(8676002)(558084003)(66946007)(4326008)(8936002)(2906002)(6862004)(5660300002)(86362001)(6666004)(41300700001)(36916002)(6506007)(6486002)(478600001)(186003)(26005)(6512007)(316002)(6636002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GsqzD2fBHhe/YYwU9RBHxnuP8cMW0TQ2P1m1oXpt9YPBncAO/SNst4N+zCMO?=
 =?us-ascii?Q?Z2C1dNUgk0K+5CoGb1RblxcMt27z86cVHrYVRMfHIFzzVjCw/mHvvTD8eeBp?=
 =?us-ascii?Q?ZFlEBsNOnoOCl/07+QIbWiuloC/+SYEfzpN3maEijU54v5po0wgQKSD4ygLf?=
 =?us-ascii?Q?pDhIIHK4M9/koPNmhkW1l568MvdjwbNNFIgx4MdFm1KwJFz/d5seOxx06LO/?=
 =?us-ascii?Q?rsVTJTNGHNWtVr/9s0hLBw574zwMI0uljzOv7cY+KoqXASzUPn4iaWLgitCn?=
 =?us-ascii?Q?8apGejL1Ri2DDj1a+6chbcGDuBI7Mom0Q6M17de1bRMW5Mlll2xxpdQLmjdv?=
 =?us-ascii?Q?DCX+78G/8uiIc0p3nP+F2L94YOjdDISf4NnSM2VKBDhkz0LbBsyyzP22iQgC?=
 =?us-ascii?Q?VC3Zg/lJGispzXal664jGLJXamqKFd1dXnwCSL2ZXutwAwDhtHXrDPIpYyRj?=
 =?us-ascii?Q?0/1fLnY7qnObGSuo8DX3qe+RnPnsNklEpnqFBcGrarJoTvqBO1vn2g2YlMj8?=
 =?us-ascii?Q?GlRy+NZlKN4kSZhGKYi6R+2eaO5Hp/5G5+vhheUeXDt7zamAxe0FwaUX0WWG?=
 =?us-ascii?Q?o+dwhVfFj8AlXWKn3heal+02MGo842nlUfd7pzrS3YEApCGYTFB8230wBj4p?=
 =?us-ascii?Q?vQ76W0hOW4fC4ZPjbxdjvU0uOBgHLf/XgqIGc9CyB234K7Jm0pZdAJUGtoBh?=
 =?us-ascii?Q?reFzED+o9Vb57TooPjphpqB1rXg5C0LWR9qdQzq1PIQPR4D3RjO4lCzk7wcL?=
 =?us-ascii?Q?7hCUrtH0/qVSje2srbmMo/KiFHdS763Hzxc7HuPqbXnjGRzatwpgorSmrLOz?=
 =?us-ascii?Q?q9e7D2F2I3zTeJSpUKISH1WEYq4RBPdvNyTDtndhYqTVqQ5UA896IwyLZr9y?=
 =?us-ascii?Q?Kbuy22hkDhNYqZHAb1iVwFRevG0I+jUNwHMHnlILbpz6OvaJgMokN/Zh9zmQ?=
 =?us-ascii?Q?Fd+RCCDfJ84wwxqTaKDMNYPKPgJ3dbNm2oKQTd1LjJn3096PZb4t8QeGGFVd?=
 =?us-ascii?Q?Cy90K+ZoaJsTAE8vDKGNEx05t9d8rxUZFK92kTFyORHslXhCKx0WHgMt9wP1?=
 =?us-ascii?Q?ZOAdTgCIF57XmeIsgyw8q5y8uaqlj8CjFDYgn29ZTb7B08oHcqbp1OQiyPLy?=
 =?us-ascii?Q?PAg5uNoXlvWryXAyWCC1LQ+OBqDJjNmyq8LjFL+9Pf+pvW6zDkTs24ChHT+G?=
 =?us-ascii?Q?chP4C+YTFeyfYg09E4ElhCN8eGPacQ4UxdimV9kAR1rMKkyIEUsbUpzgsmpg?=
 =?us-ascii?Q?BSv3+PDbv3Jvi4AWQS6eO+B3cDSlFDP81qdSgzs0mFEpggPo+C7a54zQmQpH?=
 =?us-ascii?Q?hZOcUJsHWLx+Ylyh78OxEscvQ2hvfUs+Y5+ENbdjemrUGOZIS52ggdzlothE?=
 =?us-ascii?Q?kqV6jkgobj76jCmN4ci5RYCpNGUKe7Y0J1pqHHjSuHQcr+5n2LsvFOWkPO0c?=
 =?us-ascii?Q?VHDtoiEWLwr60dDyJTjFX4V0+oqPqBx8wuHUWqwO3gQ7a66InsLw6yxzy+g6?=
 =?us-ascii?Q?jNJZ0+uppo1X+JFmxnRvQJ+v2TGxkzvz/yf15sFcXdhVIg4ri45P31yrjOhi?=
 =?us-ascii?Q?bsV0va3cENOwAJzeRYliD77SynJ4h6+Js7HrvuLxlnQGzW37L5JADIfPXi+2?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 022f80fd-da2e-4ca4-e4f9-08da9f23b71b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2022 18:28:17.2951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GvIINXuEg0p+2emQFUlo2d/XTA7yLxMO1nOeeM3LMU4CQFBywuz/04F/jPo0PNGRm+aKxj5NWqH5a96BEe0dmxOJLS2D3/38RtDoG/u0SRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4862
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-25_01,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=838 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209250134
X-Proofpoint-ORIG-GUID: baIpByF06EFAxoo6kLTzGIuQ6q-AonEr
X-Proofpoint-GUID: baIpByF06EFAxoo6kLTzGIuQ6q-AonEr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> This patch fixes a NULL pointer crash that occurs when we are freeing
> the socket at the same time we access it via sysfs.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
