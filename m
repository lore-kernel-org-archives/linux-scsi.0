Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6F0C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiKVD3m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiKVD3l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:29:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BA325E90;
        Mon, 21 Nov 2022 19:29:40 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM2BNTP015759;
        Tue, 22 Nov 2022 03:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=DKvIvtmDNZOn23K4StqJhTyUyznuhS/Ar0rF7ABRIBk=;
 b=ydxxnw32TQOEMVYBr4NvaJXPDNyLQxo8ZPiXSTTSYouaDFBndALMpDKgq0IL8DK/l4Ux
 Zzcyv1qlOYWBdtIgqfBoOgo9Ebp6Jb7/lltNoIBG+F1L/cJOZbdttXEJ+HTci9ahRWbC
 S5Jg1O5XoiEjryvXyFANbr3MKMtgOKkhfxa/YkATLxGv3bYSv+PU+vHEO0iP65O25g1K
 H1V87PrA4crLUU2jBtQ6xqr6Vtj8EV9MqiyblVRMqPhP3BSut1wFukwz+FdEV8qO+DYM
 DGnM6JauZsr6wllq0VjDFZIEbklQAL/a7FS+gdw0zADKpiRwSmXyXVuVrPt/XvDwZzHK mg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0edq1bw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:27:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM3B2l0039613;
        Tue, 22 Nov 2022 03:26:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkb0kxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:26:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsEa/uK/PlPLv+swEb2bxEkbS7+o7G2dXwF0hOv6lzq0WF1mgRccPzCxVMI6Kt9YQiprkJXZKC89vzS8Oj8ZtaH+5b6DzZCXHjz2IYMOgWfWbilMSlg80MxAOWbg6j9M4BWqFi69tbscDfTxtrQ12NSHz/R1ZkkS3i/o/Vexx0WWY3Vq4IB6dc+iLERDHYw+77Y5UU0Ems0hUkVeHCKdhsyZl55EU7PqKTjuTpGP5Pu2xMKUsuJlywaLTsT0ICrWDpTPw+5XJcE2BzCTAgM7Xm5i1pua906+dce8U43zLf+587r6V1nNvyK5p/0zYE4POyGuRLagEhceu3Pn209qqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKvIvtmDNZOn23K4StqJhTyUyznuhS/Ar0rF7ABRIBk=;
 b=AOjTRTs/Z6Tskgi4Bf+3nLzyxs6eN9u2wkAZRlD6A3YvYcC4G40MkWpMQ2nKpUTTzwOCjxOB/jrmJ6Gzi+pBs5zZjC/+7kyC/w8zMzTg7BxvejktGns/KuJiLqZuWGr/mreC83jPRbt4ZoWXbx4NpdoWP7ClJ5bqSuRzVaKcjyRqlOqq6OuJMOSorrm4wMd2x8H+KmTiqtGmwkuvCVjXEPP8HyQ11kZ4/KYN3xibFgLPyD9FuZzftleu7bSeCYRHbEDXneVjlkizvMo2BFq6yb0SuMVPUi0ka4X+SMpM7sqgMb8vum3QzOTJ/P2XHChOJMdPqX6loL4Qp/tqveaedA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKvIvtmDNZOn23K4StqJhTyUyznuhS/Ar0rF7ABRIBk=;
 b=rPxSTgn+doelC0Y05Hw9mtdfhs/laglfBVfo6CUx+PmTLlciq3sWSma5DKkH9ZfAyt1oN1FduxvL/cFW91FN5xVwP8+3TsVdsMBiyd3Vz/FgYOZMwOdbN+xf7InLrJGJtzCx35kvrAZyAy91c1xcWulxb+1qcBd1wVty1fUl5mI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6130.namprd10.prod.outlook.com (2603:10b6:510:1f6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:26:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:26:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     chaitanyak@nvidia.com, kbusch@kernel.org, axboe@fb.com, hch@lst.de,
        sagi@grimberg.me, martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v3 3/4] scsi: Convert SCSI errors to PR errors
Date:   Mon, 21 Nov 2022 21:26:02 -0600
Message-Id: <20221122032603.32766-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122032603.32766-1-michael.christie@oracle.com>
References: <20221122032603.32766-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0019.namprd12.prod.outlook.com
 (2603:10b6:610:57::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6130:EE_
X-MS-Office365-Filtering-Correlation-Id: d7f3150f-b831-4df9-d985-08dacc394d11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DGThxK9iHbgrkLAzON00NLc5qI/FqW/L8YtlnSc9QPYNLpGy95N/xo/ijcfsNyGQvgPMGWmykCkbG39DFUUlj4/nY1kkRd+fpMWfCKcE9a5bXR7wYdhnV5VnEvWIkNsv8mvvU83DwYLTv+dgYEDgYVj4lkjgCaZuEAmiBzpJxSaw8Ht3Zzl7VGll8iMx9ayuNwTIQL5ss+EYu7Lmt/gUxUPrFVnkf2+8t3jtTxGQhVkWSAHp+HSmN0VLufxgEh7X3maVu0qUaO4N7GUtScVyrm+eUa3PILkvxg7+hrC5ut/9FxKbesPcsFenGiu4zn7HGTGkn7ohPnSZ3VdsQ94eTVVsnx4X+dig1ibnVDQ8pRNb4TUiUwkzklQrSDjBvLTguiK3zdiE38xE5Dc4xOs5YyPVBQ6cloS35coBLQvhLwAiNySDMD/ishIG3cgmtBptmDmlD57hkgi/bXuVSXSjkGIiM/nF1a+41YkMoSldLcPkrNjFaHAukeRomh5n5YkkbOsjEGs1q6n/M92A0uVxfHGBj0h6hQQiAR9ja7z8xKOgVBE2Rk21YYoNwew34j616KoY2KslwjaGyVagZJimkTAcirjGuZM05UAhUZw2KWQILPfJKMXAOcIBlRwNhozkZHgsrfUvninKzr6LGm78jElU0aPs9mcR2ueIYhvgo1X3VouFc4/ExBUKJMe1o547
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199015)(4326008)(8676002)(36756003)(83380400001)(54906003)(86362001)(66556008)(66946007)(316002)(66476007)(26005)(478600001)(6486002)(6512007)(6506007)(6666004)(1076003)(186003)(2616005)(2906002)(38100700002)(41300700001)(5660300002)(7416002)(921005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ydrqfpbv+HDNSxjW3wyrxxSaQM6f/tUG3Aa5bzNrNIwEtEKtlKC22Vy7mm7h?=
 =?us-ascii?Q?MRHNp2EZziR9yYtqGf2T1RZwb0G6JHmC3EAtVNspIln4pmjONdTTT1lkUEa7?=
 =?us-ascii?Q?B+bOjN2wDZU8CiQZMQ8B5grrYkdkPZSbGEMTamuo7k0c6WlQvoxNLIYPO4w8?=
 =?us-ascii?Q?XPoiyjgpr33h6Y+yZqXycAigMdKGzVSQ6M7EVoyt06jPpe3McBgKGsSaQd81?=
 =?us-ascii?Q?ryQSeTGCXSQYRg05pJNIGEi6Y4itW4luzlh8Z6RM9nFMEXmR2XHTWKXyXbgn?=
 =?us-ascii?Q?YLrZooY3Rys4Y6oCtTpmqy0/IWAysSv0+PFXULRO1CSJNNy7CGHhvBx+arrp?=
 =?us-ascii?Q?Hc4hZJVAWF9YjGFIJQ2WWgdvLnfonqxoZ38DTKVvTTEOlMHLfxbwdFS26KBs?=
 =?us-ascii?Q?qXVNVVcjn3XAyBwaZJh0jPKWuRkMDVl7D4LngIqR+H0KUJkynnO80qwrnz08?=
 =?us-ascii?Q?RnE/EEh84IjqWye/d7DrgyEOvw3+7oWuHRpiTkZQM8N92Rf1ikttcXo4lKyy?=
 =?us-ascii?Q?JDeIfFW7JdrTXPZJy7KGvkPVoXohut0eSpg3Igea9ATOxkxsuGDjXQHYk9nL?=
 =?us-ascii?Q?62kUS55iFKwE61tHyXdbKWQRSUxM7iOhmQdbR94v89kH3XB0HBSVRepenPTu?=
 =?us-ascii?Q?r/TrUhH6aAhnIxd+V3siu5Qk7aeJmX+DZtg7IYIsnHm9tFKLSC/hBuNociLE?=
 =?us-ascii?Q?oXVG0BB1pQiFFNWUia6YN8+lRyCI2BA0dghgbgPa10tcquxAUCltinHFTRtJ?=
 =?us-ascii?Q?mWAB+ZuZ6MbGU1oIR/Xdbj4Q21POQSlsAJF3GmZ4wnzwuX+A6w1aEcMYFAHt?=
 =?us-ascii?Q?w4Z2j1UewFoOafwx+tjG49ITEWADEulyhXNcbuP330A2MjfsJ3VqLEYq3Md1?=
 =?us-ascii?Q?44cMyCKnw6jarA0ktWD69sxKwv6njPbvi80qffoxNJzGYHYMBJNqh3F9DaSG?=
 =?us-ascii?Q?HqXXAG8etqGm5jju0rshCvmL7DPanzNlk0yqknExcKt9ccSWGcya4hfo64vj?=
 =?us-ascii?Q?8JIOlpIIqHMlxyEIKR+pKwdJwFG0fW77cdsJTq7K1TyMc8JVNCcBJ0xm3K0f?=
 =?us-ascii?Q?oqrpOEPTeguYy2OdfAw3x+ek9DLE/kT1aNh3VzkJranAPmTOxkvFybQNE/JA?=
 =?us-ascii?Q?It9s7NAF2oqVGTl4oQpMzf8mQv++AiNJKf2krpWKNpAFty9KCg9g79dY8XeY?=
 =?us-ascii?Q?Gmzte0swYTl8vjwiQ5eDTlMryrWqLMn9XvM47BP2TiE9rRVNy96Rk6SjTZyv?=
 =?us-ascii?Q?JAy6VnjFIeGOVOGT4JA+aB7QIcO+YdoOCDyVvoTtZ+MS30wDMSsQgq4SIM8b?=
 =?us-ascii?Q?nXEKpDEWVQXbWniLs4wPnCARArO23wXJjwwQl3y4XGjsTT4foFtW+P4x94RM?=
 =?us-ascii?Q?04j2jJmIXdoaVnTGXWRIuSdXrcYAOdhx7wSuTdajfBGx7/I84wgMybezbDKk?=
 =?us-ascii?Q?Stf8QTA7s+GkTb4eowk6iZP+njTu/OQamoQNYoZjCwbuYxR800pK+I5aPThc?=
 =?us-ascii?Q?7LzW7o61MCl9g816y1L+Hx2eQcrqfOCLeOaw70KxHiUvGUu2YaDMWgb3+hOB?=
 =?us-ascii?Q?FD6NqktB/qZB0TL1nBD8m4z0SDIgPt605D5xOYubjvqrJx35HPzX+NrwilI2?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?kh+9Sfeh2vFgyCiOmAVKjzgivNAs3lWf+37R+zEDhWs+pGNO7fmgh5cUpuUY?=
 =?us-ascii?Q?NA8joqyTgD0hOtLqhULDayEtW1yMtpfo6w7N/ZQs6AjHTfcYeaDd5CR0cgLs?=
 =?us-ascii?Q?b5yTlRkOhrAHta5S2JPw7r+6Zf/V7ovVbIp+5fR1JEHbnCl7tJB7LUkJzQtE?=
 =?us-ascii?Q?covbkfZf1IfYENg/gPIkd/m8CZVmbnBc2F2lDU8jxtGbvDccva1dJhFbJ0TV?=
 =?us-ascii?Q?yeXSQMVi8nnSc5pOqvbZrbqNuUqgx30ebNjn4oM0qiO+jajSi4ci1Sqvvl01?=
 =?us-ascii?Q?qNROACNzEcbsNYX2V7a4Si12tIsv9bo8w9k3rujWjrGLWicDtvAiVD2nzA1l?=
 =?us-ascii?Q?lijL7k2cMS6xFAsgYgpGpc24Gk54UtLvMz6gveOfJKdYg+kR2Ib28hW1/pxe?=
 =?us-ascii?Q?v7TKjsWyUsZM0B9zbhkSY1PL+yDEuXMtg8HN/VySL0i85v17JvywX50vLZAT?=
 =?us-ascii?Q?ttTb7xGn5bKW6bU0jgcfJukc1UfePQzGEiRJLp8MinC3M5PejbOkz6HCTxY8?=
 =?us-ascii?Q?dse5qe50qX7YoifUUVBvvwnfDNik1rpTxcla/6iX4Fv6Ts2qodajDpINVRIu?=
 =?us-ascii?Q?xnJPYGcepYw8qwTthTrS+6pfs1Tc6oXyhgn9K/jv/EBff6a/OjxyxlgQtLyH?=
 =?us-ascii?Q?TG+s1cSkFUfYJ4v24tHt+LRdDlJGgG0Hug5fLOI545qGMRHVcK2OZmjgrvF1?=
 =?us-ascii?Q?f3VSEU+3LO2GwkzJnRO4s91YzZm17y8cKrNUKMYVor2pugwcIDmDA7vP2ZAs?=
 =?us-ascii?Q?OQSdoW4Wx8PGc4nFTvJXskHFbSWFSmsapXfYV7xrau/KXeJJajs420MJSOxz?=
 =?us-ascii?Q?S5xkJz6bRBpct9E1QbYkliL2xp7txAq0tZuxRpkVM2iGgEpvEWRoOoWEIJM2?=
 =?us-ascii?Q?7YNVrtu7k2jddYxnlFNe0oQBkD5bA3ISucAISHFwUjsF9vgpePwAgnEBRBol?=
 =?us-ascii?Q?y4Z4vbpZVZV6sAfgF1N12Y9lUAGhhG36LKLHTeuUrdQdJwWHja+Gr4PRa2nn?=
 =?us-ascii?Q?ZMzLecjGIn7+Y5ptKy4lIFf6NHWRsdlsnNxHICEPIQ+MaHE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f3150f-b831-4df9-d985-08dacc394d11
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:26:10.5813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQMdjR6div3R0KRmTbxBrO6VJIrRv4fw8+iEc7YzFADRDZrEZZSElYbcFey882eTVx0o6lBu2n+ogLepKmrj8B6Ggbhg+MiF1iSNMD0AK+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220022
X-Proofpoint-GUID: cnizTGfbAGTLMRGRxE6HFjNY2V9I1hTG
X-Proofpoint-ORIG-GUID: cnizTGfbAGTLMRGRxE6HFjNY2V9I1hTG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This converts the SCSI errors we commonly see during PR handling to PR_STS
errors or -Exyz errors. pr_ops callers can then handle scsi and nvme errors
without knowing the device types.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/scsi/sd.c   | 35 ++++++++++++++++++++++++++++++++++-
 include/scsi/scsi.h |  1 +
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index eb76ba055021..bc60ec91dc8f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1701,6 +1701,36 @@ static char sd_pr_type(enum pr_type type)
 	}
 };
 
+static int sd_scsi_to_pr_err(struct scsi_sense_hdr *sshdr, int result)
+{
+	switch (host_byte(result)) {
+	case DID_TRANSPORT_MARGINAL:
+	case DID_TRANSPORT_DISRUPTED:
+	case DID_BUS_BUSY:
+		return PR_STS_RETRY_PATH_FAILURE;
+	case DID_NO_CONNECT:
+		return PR_STS_PATH_FAILED;
+	case DID_TRANSPORT_FAILFAST:
+		return PR_STS_PATH_FAST_FAILED;
+	}
+
+	switch (status_byte(result)) {
+	case SAM_STAT_RESERVATION_CONFLICT:
+		return PR_STS_RESERVATION_CONFLICT;
+	case SAM_STAT_CHECK_CONDITION:
+		if (!scsi_sense_valid(sshdr))
+			return PR_STS_IOERR;
+
+		if (sshdr->sense_key == ILLEGAL_REQUEST &&
+		    (sshdr->asc == 0x26 || sshdr->asc == 0x24))
+			return -EINVAL;
+
+		fallthrough;
+	default:
+		return PR_STS_IOERR;
+	}
+}
+
 static int sd_pr_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
@@ -1729,7 +1759,10 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
 
-	return result;
+	if (result <= 0)
+		return result;
+
+	return sd_scsi_to_pr_err(&sshdr, result);
 }
 
 static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 3e46859774c8..ec093594ba53 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -121,6 +121,7 @@ enum scsi_disposition {
  *      msg_byte    (unused)
  *      host_byte   = set by low-level driver to indicate status.
  */
+#define status_byte(result) (result & 0xff)
 #define host_byte(result)   (((result) >> 16) & 0xff)
 
 #define sense_class(sense)  (((sense) >> 4) & 0x7)
-- 
2.25.1

