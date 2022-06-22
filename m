Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E36C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 01:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiFVBVB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 21:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiFVBVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 21:21:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C8532EC6
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2022 18:20:59 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25M0Iij8002236;
        Wed, 22 Jun 2022 01:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=HJuBcESukAmexgwuXfjTSy6NlT6AKwSt0ZB+0qGzjhM=;
 b=OM6qymzfl7YjYGixOpidhMVmfkz+TqBkL1yakQ2m2XUIQVv3AzHFhWWmbaUjy7XejHBo
 hRy+UTrvPCYbhF3mozGLMhvPWAkyboXaoAVZXqudV5ymD+0AUtpeBqqtWj7kvTMc1SmF
 qjqxbCpKaFIehrhnD6Ee3FRYnuuyGw/VS0aeazYU0xZVnWAUZYGc7nm+SfpnEtzoraH8
 VC2XuFcpW574+5a4Z9bBFuZZwVj7zF4UyyarkEdglipkt4AkUXnHeUUfTWLqjT/7oaUd
 fFvwloKVJG3TpscvgY3yuVfae5w/laUllzYZ4YsOgdyDIENzujBNWLY1GNwRxn4bo8Cc pQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs5a0f4e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 01:20:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25M1Giim039423;
        Wed, 22 Jun 2022 01:20:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtg5uxys3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 01:20:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+XD+I9vziMh1WtWLdXse1wPWBFIqt5+pbGFlgqLjPenp7YGx1uaCmY/2FRFmJqPGp3L8iUJX/O8OSR4sTa1vWwr5oBNl9jPk/Zy1vYrqcPR6agaRtMJESdHrMeCV5vQ/Ctt03senlZdiBY2OQdL/6kW1wYBVHJg94jEks93fz3KE++uWDbZmGbS5/E2946nU+9Nuo5KEe4BuRRxm7cl+G4JXU8Yif4DqP29bhl31aHb0MKZy37oJlhbe7AnoAcZsMvqFZCby/hu70DU9soCdvB2STFN4oFbBpg1IXjCGcq6UprWXKolA6XTEZe4oijs/RKkQv9NIujxGYJAonwsVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJuBcESukAmexgwuXfjTSy6NlT6AKwSt0ZB+0qGzjhM=;
 b=kicKIpraAn0MaX/T/WevTlNwPGr+Kb7hEaNDTiu5vdxJtA3G9/7QN+A0wgkVyJ4KcpS8u2n+ZBV7nisoDeYF3vIGCx1vV2O1Z2GuYz4iyWQSnvmTftE1GkxRq1yzNsdM7sHisxz+gqYNBmxZC2y4iVkCvpka1PnVabRJACHo56Zp3NWDxQ82VlTt+50mbl1cSoY3lbOwhwqh9TDJORUyyPX0+i3SXJ8HngZANvTPNuUbpGKa/FxgIwa8XjHCBBOgnsJwa7tWYZJB0TGJrepaH/yLubMLD1WKR6x79WSk0P9MdQmiEV6stybpxyZ3b++srT9UaA9X5FdXqacxlyUEjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJuBcESukAmexgwuXfjTSy6NlT6AKwSt0ZB+0qGzjhM=;
 b=nc6Fj6R4RMMPXXRIHhVvNzYiuNGX7CVBONnfRBSX3dcPYAbtqrrKXFTAR9blFBwYnhI+l6juNTPzovNC1OnG57HGCXokXfuPRTMbvX5a08a9wgRU/fVvT2H9GaDc91DghglnEzbcUCL0MAPpDI1tVG/N3e/rMnpnxp3vCsFddkU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.18; Wed, 22 Jun 2022 01:20:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 01:20:48 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: Re: [PATCH 0/9] iscsi features for 5.20
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mte5jxzd.fsf@ca-mkp.ca.oracle.com>
References: <20220616224557.115234-1-michael.christie@oracle.com>
Date:   Tue, 21 Jun 2022 21:20:45 -0400
In-Reply-To: <20220616224557.115234-1-michael.christie@oracle.com> (Mike
        Christie's message of "Thu, 16 Jun 2022 17:45:48 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0075.namprd11.prod.outlook.com
 (2603:10b6:806:d2::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee605a35-3220-4731-e742-08da53ed704b
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB14669421FEE9B51B7D6980AC8EB29@DM5PR10MB1466.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 975sLUoKNmwnzcLdHHb0rQ1IA8Ya34Vn6KgFd2jm/S6EB29TNrHwps1+UgIhj20+IeEwvXqiaX4ASbd79IGg1we9Hf0s1bP5KdhI/69IdY2Wg4NY4LuwqL/70fd9w1NdOzJTA7DvhmA2r6kr1f3xnSzzSXwRaogYS4eddnB/0/wifKhxnFswrzbG5yMYlRlbS0m1qkL+bcZx/MpjImiQlzW8u8nFCB0DcWQ77c7zxheM6onaKtqVDcdSNCu9H8yOOhIYQ53f8V2nlZOjUptesSfsTxhiF/oUpU3E+ePVcrer8TEyoQBKDymXOvb92Yq10C9YTMldfFkOHGBixBeLuMXvKui9v+SxPl3Grly8KkUeSs4NjxQ6R9+2m7Z0XzSzCpifSpClm+wsLXJPkInrTSG0brrvkgJsR4sWNvY73HSxG30T8oiaa5cQdidkunT+yw+/uRxwiixN99UJ2stwPbkQQiGkHhK2SilWo8wP3snl1GoOkMlMvgjy7pkBAPGIkUeVBqMg1Y0DC/UHQMaW8M78qOQephbrsBV1p9cxQ64IJDuZRiHwm4ce2Mnw0U84GkCYhHFfafgIb27XZkY1QrAtUNk7mYla0A4cNh0UV22aW501n77l7Esri78JWeW5JoFBYGziQE1HBRDw1EPCU+YKzSx04aRqr8WUKTIUBPoT2tpXBu2LFTQbvKd3QIEn/l4NW8kwQfqYw7YBuxoH1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(346002)(366004)(376002)(39860400002)(6486002)(6512007)(38100700002)(6862004)(4744005)(38350700002)(26005)(8936002)(5660300002)(83380400001)(52116002)(8676002)(6506007)(316002)(66556008)(6666004)(41300700001)(66946007)(36916002)(478600001)(66476007)(86362001)(4326008)(6636002)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1OMemEWrkHXKQCch7yGDPDM0vMyFWTuL29t5gECefivNUMvfG+O18wY856b8?=
 =?us-ascii?Q?jc3yN6/B+FCTpDooIfYKUqE9naDO4IlYLe+SCNuk0oTdhWP+EdMnnvJtTPYE?=
 =?us-ascii?Q?YkPhha/KePFFa9b4ZNNnFOUFCTlzaO5XcSTipDUTsIB6qdOlFzPKCRnNUbXv?=
 =?us-ascii?Q?Weq8VfgGtgcF2WDzYDHk0AjbVZhSJ9xDSCyWxFdf+RfzRUc/FG2UWgslnE1+?=
 =?us-ascii?Q?aMTMkO5ikKO/J5K39g4sQridAlkHThbHuUrq4oKlA1xsqfeW782o9eC9Jn2I?=
 =?us-ascii?Q?VdDIAqYwfxKdy+jWmVhR8COhYwr92hbng8qiGbZeLwIzEz9QLdywRJfFmmal?=
 =?us-ascii?Q?sdfpH5KFXCIGT0AXCs6I1kdJAPlqfFv4eLq9xgdtMRS3dbw1PZ4qh+7m8k7l?=
 =?us-ascii?Q?uB4m2vrVkPr7IsdfSwpVNd+s+3auLiU3V5WV8oYZdOWo5EYFWVaVrRisRcYO?=
 =?us-ascii?Q?IY/k6bHmvExPz4AxAa/9d8O7ke+FVsp4NzeWP72sJJeKZNAYcN65aaJ6/Vk5?=
 =?us-ascii?Q?ucCfEKkUvYeakkNcvW3SweDJZQ9k2Y0bTtomhSCSa8PnaZJs/xM6JqGxOtAE?=
 =?us-ascii?Q?Wx0cXdgsX/Yu3cSsHCs+uYanYLkext3RiYnSjASNsn+AS1xzJwZ+cZJC+rhP?=
 =?us-ascii?Q?RWJjZDoysnlTWVTEg0kAfKJ2XCuRUF9QeuLbNZbDT55pwLdU7MTrnibocZ3A?=
 =?us-ascii?Q?EdOLtwapGwP6nuP6Zv+8I460oBDYnFicLgo0ZAiZizf4QtZNwTV7a1MzCegB?=
 =?us-ascii?Q?M0oJPljQQIq2vSOPG3UcHcgTp996WO0ev+1wStj+cSXzJ4JpAIalwIaGA+7h?=
 =?us-ascii?Q?gYMnUuBtxpMdQiqJUgSknkaiJRMlZuylaWAtmqi9Y/mbuxIqtZkEdtsEHYJJ?=
 =?us-ascii?Q?Kl+DSnR6FVDEOX0tNdjUkVgizTsodkDpOamRZyhmMPTsnoI5PeD7DVJtm7Up?=
 =?us-ascii?Q?Gm3brnsHFHQB2wkFFZcgxgSMR7mfnIElY+crn3KD6rTBKcBEuQhNJ3CYXYyz?=
 =?us-ascii?Q?S+zmP1wFnVtvhILX058TZG7MN4aqhPcoKdxCsGf4zu/F3MayWXA8zRC6p/Sp?=
 =?us-ascii?Q?SW+HfMCj+dT424jH6AbstqPJGpdM3r5MR3yvalggM5cEf6TvCPC3Fv3lASqi?=
 =?us-ascii?Q?dFqbq4trDLMmYplbEELGDzl1iMhAbhOI4nsomIpBX1e3hAMd52EK7t1o01ZU?=
 =?us-ascii?Q?QmAgGqgJJD+2NZKGLZBshCtpUNVfkCNouc1PUSgs0dI2NeEpYHRMXYVQQfzB?=
 =?us-ascii?Q?5BnGpVeo1zvgJNf9DSx3ZW173+Z2wQMz5pMtyo4rNph6vdLh+wWxjvNmHttJ?=
 =?us-ascii?Q?A/TP4owb39I44sovXYJgRi99hmEs2SQpV6765lX+7lPCfpA0EitNUbbTKcFK?=
 =?us-ascii?Q?BImPA0fW+rsv2IQby/ilj4xkS5pJbLLMzEhDeMpXVySsMmt9PR3UpAKqWd3S?=
 =?us-ascii?Q?0sho347hyDx8Yn5zUY1ZYzL+el1lDCI2AHY+mv9E7RfpQKepcgSFVt13tIv5?=
 =?us-ascii?Q?ieUDEHsZgSxa17Lbj2qQj2EByEtzrAoRzjMylsYQKcKUEhqebqDMOPFRBkDM?=
 =?us-ascii?Q?w2EzZI2MlYdrgWM1nzJP4ReP1FOl9e2tMYUKv62qqphEI6UlibVeSEaC4Ik7?=
 =?us-ascii?Q?MWCY4E870WZ+8gGppBIeMeeODYSqT5R4Xsq7Rshr8RtGRFZhTrS69w3Cb3Jt?=
 =?us-ascii?Q?5c17t7dSE1uNgGKuLCtnXpHwYmo1Fi8ILQk7AVQ24ZgbAhixc38MQReiu/uK?=
 =?us-ascii?Q?McIqxu6JEzQQxA7Vdx84P4ILMFS0rhs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee605a35-3220-4731-e742-08da53ed704b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 01:20:48.8360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: So2CYsguuGEB7yA797J0DSTYIm+d4E4gvn1/ezxT2ZaA+sfklOWhHub75b7EQmOzV/aF9cHWbnNpBLlvQizTaJcwp/7Lc/9MltUYpaO8NZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1466
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-21_11:2022-06-21,2022-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=891 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206220005
X-Proofpoint-ORIG-GUID: PzDwv8vEorBvncg3rE-BYZtlVZK9wwgP
X-Proofpoint-GUID: PzDwv8vEorBvncg3rE-BYZtlVZK9wwgP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches are for 5.20. They were built against Linus's tree
> but they have no conflicts with the existing patches on the list and
> can be applied before or after those patches. The patches also apply over
> Martin's staging and queueing branches.
>
> The bulk of the patches allow us to run from a workqueue instead of always
> running from the net softirq. When using lots of sessions we see a nice
> perf bump when doing throughput and IOPs tests. There's then some cleanups
> and locking improvements.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
