Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A73EE49A6
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 22:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjHUWLP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 18:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjHUWLO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 18:11:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2EA10E
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 15:11:12 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxUrD009106;
        Mon, 21 Aug 2023 22:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=vX0M2rF/5NeRNG1uieSxF9wRkAhi8n/jH9L3X3R/PRk=;
 b=QQ/j6yy+jIB6p+88GE+/7Q2bwzqNK8+lZ0TyRZRkWIqaevxiUmWelp9KdaIrbzUMOC85
 MhXd349NRBP55F38ArhAZXXNRgx7gkmbNNoZQWZ4LDKfnOCzPFnXKS642KwB0DbH3USI
 KvG5+VfV9w1zKG3T1ggG5P0Xq/zcNqXV/PNgcoe/P8fQ2l6TFqyDaeTEbctFtlpLIT8e
 sqgTjULk0YiXxnAHXXgkmz+6HOTY84m0bULnsd/azmdTkkvTcGDSCE8HaVAuHqOGj6Mn
 Iub2II72gqEVku/+SODiSNKsJ6cvq3CriXBytqkGu1OXhRoHly9/fyivKyTGK88kfRE3 dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjm5dv260-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 22:10:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LLUPTT018659;
        Mon, 21 Aug 2023 22:10:59 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm64hwb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 22:10:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6zAi7WY7Ah1nXH29bnw5AJi3yrdvhqV/Bs6Dw5PbRfPud/wV3ElOwl+RPH9NIDKtW/tap6nByQ3P7wgWiiiDO6QtOGEtXIURRFvGl+tOAAxJuLXamORFN8el0wGZE9/MJsuIgY6kZKLVgoR7G8Qm5BephO/J5n4I4RvZMosdJM2m5awi2OEab1wFfCFMTSIE+BTpzYatTIEaYNMxt45LG7hD9+TU/Mhx8/5QoUWAu6QSboOxT062zsdOn65gaIMbBnKPKFsW5OtmygN+f4hW2pXPjNnyIXD5RF5Q7Y2nTxKsEawUZf9etwcnAvEnRGUDjo4qFZv6L+cW4PDLs+nrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vX0M2rF/5NeRNG1uieSxF9wRkAhi8n/jH9L3X3R/PRk=;
 b=e/2XYN30ukLQAuAhVLCg9GJRFpFaK42WP5eKTNndbh5L4mNa9a3ctnUn0nIY0Yj7YPA1T/7QIsxTkKAzMMqZOfeBV3zUmwkAQudktGh9rtn+fwrCZNzwga9FMIJtvNkC7OqGFqdzgcp4aJomzdF+SDW2VO2IOlOvV05n1GLW8scHoHP2Ya4R8b9Rwrz/TCcGvFXfNgYu1ea2HlJ4dXI+v0eSlNjvezEd2bOvEVE+TM2CrxvstiE1jTDV/UPo6tOtGvrUp4TEah0VitexagI5P+6xPrsIOLwfiafY+5Uf/v2vkyQK5igMGoSx1VibYld5KWkut7LDfaODsZ2x36NZtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vX0M2rF/5NeRNG1uieSxF9wRkAhi8n/jH9L3X3R/PRk=;
 b=xBZE4boboPr2bEXCJV4ysHccT6qyWu7G5yCw2Uaix/BYLwZVT+i5PEIC3pKwHgiUOZaFcivD6Xzs+x5/lf8VxRxB/EzFW07R83VncEqknOCbIQCgsedCVpMu9oRT7QMb/KWc6WqPcacJKQcYPzcC/CpZT42hIGTHNOnvbRoQetE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB7781.namprd10.prod.outlook.com (2603:10b6:510:304::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20; Mon, 21 Aug
 2023 22:10:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 22:10:56 +0000
To:     Igor Pylypiv <ipylypiv@google.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-scsi@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH v2 0/2] Returning FIS on success for CDL
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1il9859nf.fsf@ca-mkp.ca.oracle.com>
References: <20230819213040.1101044-1-ipylypiv@google.com>
Date:   Mon, 21 Aug 2023 18:10:54 -0400
In-Reply-To: <20230819213040.1101044-1-ipylypiv@google.com> (Igor Pylypiv's
        message of "Sat, 19 Aug 2023 14:30:38 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0035.prod.exchangelabs.com (2603:10b6:805:b6::48)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: c1426193-b379-4cf1-5339-08dba2937e0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gNOct+PYDTZ+72akvNv7lceyADhrGRnDUGnCPII6uxg5dTJd9jVGcL4AtJDto4c8C1+YwjvRBOKW931ELJhl/UoQMG1tlDP+M+eeyr+vaOrTSA9QO/Qr7tRFAbNC52Qtw7BIh217BSOHH7bgb8VjBLvnmo22/D1E3XYRrO/uVJ7z4ZcVDHcElCc0MP013X4JkwYXeXcFnQt43azQXCUlu1vbwWxN/usozpH12+bs55cd+T5EQKARURRA18b2mimTTU3NSbDtzgqrFtS00cu6ZvuIzkCL+3a3wFuyboRu2yMfS89Eki6Tw3e8Pveff6XmI0VuOrcRvwPzo40dvL2ygDw4O+lfPCwnfAUVh7J82uwhOq3t9U5FNpPiqX+ooxAIw/YnZMJW+NQ72fgUMpf2H3/lPFuyjAmgmJWM9F6VI8j9Ux9azChHCeNIj6A/XV5zzqQo81YMhjsWLqkqbCko2WDkN78vgYM0veYah23MLVB12p9l1DkrkPp/YXlR5yWe7nJ26zBM730jjgiy8il/I3PuXOwN2GgU2evMQhLLy8K8z+T2/Z5tEuE+DNbBSsJp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(54906003)(6916009)(66476007)(66556008)(316002)(6512007)(66946007)(8676002)(8936002)(4326008)(41300700001)(478600001)(38100700002)(36916002)(6506007)(6486002)(83380400001)(4744005)(2906002)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lU0CIbU6FWObXg830pXuJe0zgvo0f4h40EQxo5L4smz9fjHqerkI+X1iheU3?=
 =?us-ascii?Q?kH0wiBQIRiqXiC9alGzar3zbqXpS0d3bWXoMcvcIHKcAJKCOyBBdDVM2r3UU?=
 =?us-ascii?Q?ORMeTl7izlbsgO1NcFUKMcuiXP0/kB/spy6b0BQqon/TSEMsrkX6ZTwso2Bn?=
 =?us-ascii?Q?InHK0VHvKEVKJNwceDJ845do88myw/dSZUAb6prUC1IQ8Jb4L5Zjo4r7dV02?=
 =?us-ascii?Q?kVx9T4Z2Ui6iGmtx/E/UXrYuk9IyqQ8jsPCuMoODKI6yInDUsh/spqcvZJom?=
 =?us-ascii?Q?qlBJbmt5AlV5EesWiILOckIKsk4oTDGjP8dK+RwdPRXvrZSybo23cXQAh4rz?=
 =?us-ascii?Q?L5h/+58v34LX60HKMi49YHRGPLEZiKZzKl19P2GevLeDu04PVs1uuP/DjdQJ?=
 =?us-ascii?Q?4ASfYugsQ64kmEku79+f35v+3vsd7GDePqefZy0qXmp+IWpYRSEfdKdNKKsQ?=
 =?us-ascii?Q?dfzXjRWBjLYeA2eRA+jHbNvLdJFtShZ1FVTk4ZQ0B2W4vA/wN2DJT7e4faCZ?=
 =?us-ascii?Q?0NnX76Ol14ix7oITZ7ylPjIq6NCLPyxS1M5BdnlIzT7o+sIsfPjIqkiDh7bu?=
 =?us-ascii?Q?gBWwjXejaOF6C5P4UaK/XgR/KqdMBqOsaK0lDzv39FvfpU4PRk0o8NoVbHfo?=
 =?us-ascii?Q?YceOm2lQbUIKcg0rRkDMUjEEd6gkDMvNgr0p163t4XLzTNaJMk7eIvnrbtB3?=
 =?us-ascii?Q?liHPN1FSUuUWPiYTHI3+8iFZgtw8CnSx7J/+sVwXioDqk9dvWqDfDHAtkl82?=
 =?us-ascii?Q?mQEzY54YkWTmt4ARKjguNePt8EQfbOuUy/pYu5hdJncEn+0RDNpPng6dGZjD?=
 =?us-ascii?Q?D6RN6CtwsxCdp+y5IX2FzTunpHjcp/ChfAme1KzLImS9u/3gV3Ck/z8/4RQ1?=
 =?us-ascii?Q?aRbc4xQbMG8R28/acd0Fs15EkKWALvafOsjSsKUyFaKuNE9hGu/HdNGktK34?=
 =?us-ascii?Q?mjDMwFKPrMw8dVedT8IefxsAy/IJysXmKAjU0wEWZ5lFhTQMbXeztkREeZcY?=
 =?us-ascii?Q?I0zYAvbhdMN3aQmv10bh7qJllYS0QpUF3wspadTvxtWq5lgGpKr7pHzTjfvX?=
 =?us-ascii?Q?cuwbZTQ6OZBRst0p2LqDlrsN/rJptsPsuFpj4Hwn7V0bq7+hDPDs7gUd0/h/?=
 =?us-ascii?Q?HOp2Ub1RufV5v7Zw/70uJcGE2mBESeqpcgcZNYefv6ipHIDAn0Yo1BjYQddm?=
 =?us-ascii?Q?Y3JO7dSjA6soNqvh6a7YEMo0Gu7OkBuzPMMAlVgjxOKq4ewm+WNQwd0FshHN?=
 =?us-ascii?Q?aUSkIqTbpKIyNN9SSbR/3toVC9+lij21EUOHr5unxTEGTpeonslnNp8hgbkj?=
 =?us-ascii?Q?8un0/0JvzVTdZbO3PT0XeTgg5qCleU7ryK0sNRrBpUx9kS8c8eRXrt+EjuFd?=
 =?us-ascii?Q?IxZTpbP8stgvmDnMm27UGiKXrjjT+HtgsZAXAfgOmVg+gmkimoyA+38gyvLR?=
 =?us-ascii?Q?31wG7Biuhwv3YKVhU710pimBQSmYitRHXmLOMk1QxoX9BBqABvASOKVUp3CU?=
 =?us-ascii?Q?2BkANjQCFkh9ksYde//EH5V4pFTJm3V0737vvP8AlNVVt9+Wd5jYg7rUv6GK?=
 =?us-ascii?Q?tqT7xGo6yz/KAtVeb4S+Y47YrhGQAmiVdCSLhq2e4yV25NErxwD2bUjTLx9c?=
 =?us-ascii?Q?kQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: BBUCNAr9X/iAHOs1Md865dyZbbErNusGTkrUflWo7F6mVBXBER8IpZfq+YDLOrIrlC110yYTo8+rh42CqewpRAK/FKcD4TD9ro7yr+obolEVKmhzteV3hmiknj8IgK/5HpGYUCu0BIFGpGfkxGfonaA3tMc7xU5y0PGzgiQyC0kmwnfvfEaulgP5BkLGqMZQqwSh9wmBwHPfIvUv0el8xXCguTq4M/eBETRo5ifOxc3F8wVGom8E1z3CLsAngJ8xxqVv2QURpNHGiAMpdcwW/LJiJlsNY3iwpHpC70wS9CYGo7JiLJW6uiGdcq35KjwyaafHF3GKyJtUJNhnnOaYDMmx4ciaWmTPFtxW1FWRyiA0xSyubyEAwY1s7rZQYJGF+aTVlkvUG6RSVB2Wv932hZdrVw7pkobNsLDWAH9PljwJEbu0PchO2TxpyX8J0kp4U1A3ltIzR7wrnH7o/4VuYzRf97kw5z4wonld+vVX8pXEIZjEf+M86AAtgxcT7UM19MV6ckgiif7OfGKpi9V2rM0jrqkwQy1f2Rutacr7fhNiF7VH0f61/qAniJBJQpDXzkmDvbbX2wG3EJvP9jvVuJVlNDSUP+I8vyPRPFUg1opK3LqPtcbiZFf/Zi8eH0qR9KDlVbJNHhaUK3qyIrmv3QVkvq7HGC2NFRimeGVWBgMVg2o27TVSzpXY/eX4aSNO58m/q4p3rAWzLPxqYTWiwlga9dqUqtKEZwbEiFxd38BYiBx1TEtOv6t3NgZ3qwtaKSNsCideKEP/n6jkOXRR9HqaW87+oczZ+niVdS0u0byxQ6Ku9eoeYW7WoPDaNc7WSvuko3eVYr9jHeIZ5bb6P4mPAf4nIDaMw6oaX63WNjMg9ncNg+IAkd6fR6W1Yq+fE5UA7KbJ+Oh8JfbZAlU2PMV8o6kPfr/A0N780q1XiVw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1426193-b379-4cf1-5339-08dba2937e0e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 22:10:56.2962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rj71sy7F6L4UxFlmAyhYrJYY3OMUMOoCZ0i87eDvLt/Kd6gvMcxadV8aW/xMLheYQFROhUCp53wXpRA7/DrkRL3EsJ1aoFGKGHu08k4hz/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=650 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308210204
X-Proofpoint-ORIG-GUID: P27q4QyMt0fAETw4m8_WSAlYdDNsSoKN
X-Proofpoint-GUID: P27q4QyMt0fAETw4m8_WSAlYdDNsSoKN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Igor,

> This patch series plumbs libata's request for a result taskfile
> (ATA_QCFLAG_RESULT_TF) through libsas to pm80xx LLDD. Other libsas
> LLDDs can start using the newly added return_fis_on_success as well,
> if needed.
>
> For Command Duration Limits policy 0xD (command completes without an
> error) libata needs FIS in order to detect the ATA_SENSE bit and read
> the Sense Data for Successful NCQ Commands log (0Fh). pm80xx HBAs do
> not return FIS on success by default, hence, the driver is updated to
> set the RETFIS bit (Return FIS on good completion) when requested by
> libsas.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
