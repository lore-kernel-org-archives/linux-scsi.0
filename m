Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BFAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 21:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242424AbiBKVhx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 16:37:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiBKVhw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 16:37:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C597C62
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 13:37:50 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BL0nsq006473;
        Fri, 11 Feb 2022 21:37:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PVMhQ5ewZO3IKKHBRTqWawl4ieRnVWRKLRqxba81FxA=;
 b=ji2vSMFRHAjs4WpTyiCtJgtSeQ0VZYFsBqIQQRa24kU0WMGvCmp27GUpYSPYMbKYqldr
 VzyeX4hSmPfEbd7lQ5me8JtwXIfN+0DW3ITK/ZjQ7oeIFhwdO3NRHANd29tveewdVhQV
 Fr7ARYJuFyFl5pfgCZXbKXcSRnm3PIy7RhbmXQ+2tRpJseZyf7YS6Og2CKBaiTVnErMy
 tQDYEoJVLqhIg4ngIU98lo1kwYxSOE4KZh/oG66T7IZ7WNb+H0RSA2z1z8WDBXoyT36E
 KvbPQWuk4+UwYI70WMbFM6pS9wVUB1XaPtRkljJKQzSblkbANu829XOdyhTc/D8ME9qr 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5t7kryhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 21:37:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BLVgfl108735;
        Fri, 11 Feb 2022 21:37:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3020.oracle.com with ESMTP id 3e1jpyg0ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 21:37:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AxehGDQ6bPceurWzlXsJLEeXjTeW7pyt95nsB4435dNjXG4igByLOGyr2TWFQjpbWYIl6+ClV7yc8Tfz7djK5V9iWasYXVtumdBGtsSQeUhDTzZSx+XhrztZyf4pXvxT/WZAow9MngQuGg2+9qgCQGnhlVC4qPt5pFu5F6lwgK/UoAh5b5bNLl7GIJNyDoqA5OSwtcSgAqlc+Lrfu6se0g2VHHqpztQcCdpng7mZ/r63m7mayFsGuLNJN74/rVfKKIuFK8hNJ4WOEZO5Ntx5HAAKxraJsU3Gd6YNlYg7EGDAwxgXoftoeLFWzhqJudk/xNeuXekgTI7Q2vq/fBb5Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVMhQ5ewZO3IKKHBRTqWawl4ieRnVWRKLRqxba81FxA=;
 b=J9dX3Exx/7KP40T2Ney2D031+cKzmGc5yTCQhK7vPzOmSSPqrANz2Lgsr1HhVhi5z9HbY+NIIsC0/RfImbxA6/HflkJnIHOoP7/AbeqGQqGXs1JIKeyHYvSQxgnFR6RVeEBu22waZ2m8F6ACI5WJXxv+MHDg076OEUURwCFLHQPIyPyy7JffbFfi+bfjdZCTiNzdXHCjCuHX72hx8VCsX7igULMW4BLRt9CM4Uc0jSq8Z3JlsviQSjc7wFB7NL66bYeC3xaB8LzU8KpKo0JDcH1vTUQMuixCnxLUcWqCVTJvdGe+9zDdJkpMoG+PtgZyGndVXr3Z9Je7F+bIlHmgww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVMhQ5ewZO3IKKHBRTqWawl4ieRnVWRKLRqxba81FxA=;
 b=fSYLsId/2xJgFilO25Ecerzla9fQCKx8M8Vhn34uGrA/MCxo4Tn8uMMfcHLRzB7e+dCQImg4x/XhxRuF2+F5B/MzfiLahxKloPjVb7lhcIE7EeO+FWEqy7rs3pAwbI2xjHQ9lBTApYgKlZurBtnNuJE302/vGjiH+JQxQSqwLww=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MN2PR10MB3264.namprd10.prod.outlook.com (2603:10b6:208:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 11 Feb
 2022 21:37:45 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090%5]) with mapi id 15.20.4975.014; Fri, 11 Feb 2022
 21:37:45 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <emilne@redhat.com>
Subject: Re: [PATCH] qla2xxx: Add qla2x00_async_done routine for async
 routines.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1iltlqe3o.fsf@ca-mkp.ca.oracle.com>
References: <20220208093946.4471-1-njavali@marvell.com>
Date:   Fri, 11 Feb 2022 16:37:42 -0500
In-Reply-To: <20220208093946.4471-1-njavali@marvell.com> (Nilesh Javali's
        message of "Tue, 8 Feb 2022 01:39:46 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:806:120::26) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d27c50c4-a10a-4a61-11fd-08d9eda6bd79
X-MS-TrafficTypeDiagnostic: MN2PR10MB3264:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB32643D84212D0B25659D24198E309@MN2PR10MB3264.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RQpD/T3rDkVLD3b5L0GcDckc0V9NNj4rw877A5lVtq3Vj0H+RGMmN93zyROJE/5d+03OPDqtbZ7YqQJ20oMCp7npVptWyV0zAniEwK0wAn/hx7/VDA4S+hRLNOUwSI7diULJGEI6AYizfYmHrg6xSPSY7ZwolZf+aNrGrQhayRDVM8izqt47ZPmv6sAtpj72fDMFIt5PCae9YJZeOQmU1G4hvLO6vldaxTzIa3wQ/Mwhla9Wq6DdxjaGJqzc9fkokESBjqEJVvMS27zx5o96rJHQ1aTszBxFrHkNc9igdagRipCn75L3L2VFqdwoX3dvkPKqTV8np6GErxkrF0BcCHc+XmGhp5NSL36O9oNgMw6Q5olNG1paBOOS0bz0+7gHhjZCOHNN5bz6wOshhEJU+Nxy1D6jdGRzhqrPJE4IxnGVSfwguDamsxhkVa8+pOhfT4OOcsctssMTOWHT1Sq6yK5OspQ0h2P5TgDTyjC9LFWGNKjPJXUuW2jimtCgTQVahIjWo2E7y/68164mVKIq+QmIvrQmKE1kTFw63Ib2Mb97CJL7yS9lrpvzwGHCEYVs6qlBblMBecuTUjq7M6CsutW2Uc0wA8cDf2mQM8+lQVrGCSyK9wqgXeuuCkYeKKbLr2lVkIk+0b3vJABrAS575RqzdbkXAXmqNIvkrQ3NQaIR2UUB32PfftAaChdcVhCDBKRR4fXOPpJPAUnDpjmjVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(508600001)(6486002)(6666004)(5660300002)(558084003)(2906002)(186003)(66476007)(66946007)(66556008)(4326008)(8676002)(54906003)(6916009)(8936002)(6512007)(316002)(38100700002)(38350700002)(86362001)(26005)(6506007)(52116002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Du9mgA93StSpIAx1YA/G4hmbboartp8TW/OxJB0Fxlo9jZdcZ/oUak+GM85U?=
 =?us-ascii?Q?S3oD3h8GDI8sXVSRa/YEyKfYR4/EXaSkFV1FUlNHOkzBdqIo2TbzDC9jNI+P?=
 =?us-ascii?Q?OhKufr5h0gOJ2RMVQhFIt1Yj9AmqcjoyHIfSeM9ZnsvasHzeNfWgXc78zlk+?=
 =?us-ascii?Q?TDDAKbH3UHaNUbLHm9+uL7yuxYRNtzKj6XV54pyb0zIwcoaW5BEwBKWgGn4u?=
 =?us-ascii?Q?908I8yVQUdR1uJtKPwa4EB7ndAZvzM2huojQkZkUwaunYH8p6u+K5KR638Qg?=
 =?us-ascii?Q?j9K+AQ/Ty7DaMR+RVDsgHkTVqwyN0dIOP39i7XO8S5OpHRCnpKxrFGPfAnO7?=
 =?us-ascii?Q?RpS9mgC97nuMnRc7guoNNm8xsK1bwylH+5FXizB+vivuPjeolrPF4bzbRxmg?=
 =?us-ascii?Q?YHquCtYL+pS0cDl7hLJQgsl7ndVGenFRY9WGDq9M4DY7Nl2TxdQymFLg4BCL?=
 =?us-ascii?Q?FcqZyrnxUAdMtW6duzx4kdweFTFQ/99AUV/lRFcL8bi59k6vk08D+3WOZ6KH?=
 =?us-ascii?Q?rX9pKtmfhFkeO2WB3xOk9uUDixEJbydcxoVJBZ6m66VsGbaQfDyVWArAqR0L?=
 =?us-ascii?Q?cJZbZgoTwxQ+aNu40IlL3SQBBRBuSpwOQc3jDdnlqYi/JNldKamWdJZkywGJ?=
 =?us-ascii?Q?7FGcYMXqa/nzpBoenu6nO5dzKcfSpxSfyFicE5K9j+tjywlx7S6w4v6gSEHq?=
 =?us-ascii?Q?aKlrs9BCrsLTbK/8JHWL3ttd5kerDsAj2IpzBjBdkf+F4jdqvM4W4+/rf3IH?=
 =?us-ascii?Q?tM0n1YtDSw0FDQ8MqpsLw30FWj5E8un/XTDAZKrO3DQ5nLE5Uld7DhuMLejJ?=
 =?us-ascii?Q?+uw5xjG70MthiKurux87SvvOelj1aVrWYvS1CHkeq37lSfjInpMNCy3gvAEQ?=
 =?us-ascii?Q?R0N0x8atVc7YfRMVq9xoAvf3IsudMDGKELLqk7JnvY8CJ62cdRTc1oIuWCZv?=
 =?us-ascii?Q?/X6CxBD2CFxtsX38FlWeSI2bN132PF3E79OsIk/cuL8lmG8cWIIvSL+yuk1g?=
 =?us-ascii?Q?ICKg688kOJUQpU20KBRkp+V7PkF2ujjzUvgo7MkTTuFtiGzrJoqj2GXWB8Ft?=
 =?us-ascii?Q?TZ9cs+dCif96V/8XDq7Ns/m3KPjrQ2qXL9wmCL50qwMiD25u0Q1dzaNR7sYm?=
 =?us-ascii?Q?R2x6Udgu1cURP2uhGBmGlq31DKUzv2TyFf8LL4kDOUgPpsAaZq7wRoDm5EDi?=
 =?us-ascii?Q?Fkk/0hfawHmrxzvCIWh/1hsaGA4wHgQ2ORX1cc4Zr0GqHPtHzpNhEIodYr+K?=
 =?us-ascii?Q?lQafndAHab78kQPZrQctcekjpgzEZpf9yuc9jPfK4CYBfEOWbbQlgSJfGd1F?=
 =?us-ascii?Q?uJIgVr1iqbgEhct4kodLBZYr4wLcpeEjKQVlW+lcoKFrQaOeE5l+4DpadGK+?=
 =?us-ascii?Q?yeL9cRYAMlvwPgfoAVFnF2Ax91Y6pdKbljGOeUCxqbtiTcfEXbLcHSOgvE4t?=
 =?us-ascii?Q?KkGPYLWHqaw8FpLSDD0/mVBhLilOYpfXt4iH+LCkOmRo7IkyFY4+2cEijg7J?=
 =?us-ascii?Q?ZPfZn0YEE2b/eTgsLfOYlzpngMuiTT/kGiOpB8vRtFdrzMutzynsu7clCJ2T?=
 =?us-ascii?Q?RtMKiWdlsEw50NOGYEoikTCINX+3oCmcLnChcis24ZaAOMX3N2S9FCimt4Wv?=
 =?us-ascii?Q?lCzbiEGoDAl/LAXgydXrXDxCydiKA85ngacsNGauLv9QcxgirwvqT+EatpNf?=
 =?us-ascii?Q?FVIGpQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d27c50c4-a10a-4a61-11fd-08d9eda6bd79
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 21:37:44.9911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /w8bH5LZaM26ejuyu4E9A+Kh3zgnDFuRUv6+dUulNLWfpFFKwlMQWtXL9GxGTzOyrx1Zk4AyQI9d/BzPOZ67Yq7xES2xR3HyAA2N8+p7HXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3264
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=781 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202110108
X-Proofpoint-GUID: BmFjmFSBp5txj2dTGthktidtsK2kyHDB
X-Proofpoint-ORIG-GUID: BmFjmFSBp5txj2dTGthktidtsK2kyHDB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> This done routine will delete the timer and check for it's return
> value and accordingly decrease the reference count.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
