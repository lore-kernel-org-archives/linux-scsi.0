Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C76C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiKVD3B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbiKVD2v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:28:51 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E7F25EB4;
        Mon, 21 Nov 2022 19:28:50 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM3Luqk029711;
        Tue, 22 Nov 2022 03:26:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=e1srgqIBCIcZpzXwbvj9Kn0jgXlmj5HQO9vrO9gpiRI=;
 b=y+hoWBbLTVh1nf7M9z+AiZ3yRcZcsCSVbYH1grmnNiI5gAp1vBtxkYZpBQVBN/PSIlPn
 ZolRF9kRKXxNiNkSsVZDBSgKBcNdBJXNPtx1hg4/DAuR8v2NL4J3SA39pBG9F24TDaER
 fV4mfEjOub4c/daB5rshNGet6IcjciuVRCC1pb50B7JfQQXZOsJ1YqGpDfZVYKrnWVNQ
 UKaUZQ2b//Neba5805iL1bcF83lI63oKQRdoJk+9Uy6nZ5cgbdmhAVs578hC7T6TKtZs
 qbP4fRFUArX1cokjlRbB9yvgujZz2yY1gZBUkF/GgZyubNLN0GLUw9pAS9kLwoyjszi3 Cg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0pf2r0e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:26:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM0tgI9008247;
        Tue, 22 Nov 2022 03:26:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk46qyx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:26:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LguCX8XQYDr2BX1f0KWKwkqB8/sZD5nahD0dCvcpN9M6V1TXJTRviV7LQvjnKjScTW/W5Wyg93Puc7m3o6SqOVfysC7o8TwFcnjgkJx3pjjYyMiddVNm8zJacFPe19jxdQKPh+LhxH2Q93hZOhXdlsFlCF0SWy4vXuguTh3nKnA/3S0nRuMosbky1DDe8rDloPuQR+HFw7Hou+H0dz3uBgXkObVGAp99/TzGFd1pYHtxr9tS0wxxBfdYr1XZAUrVsuep52EK3u61dMhsLALpdCla9ILAjsNJBqcblRlc0SLYYqR8p2RxeTsyoe+ltHx7NGuaK2OcHhRZTO/j8P8iRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e1srgqIBCIcZpzXwbvj9Kn0jgXlmj5HQO9vrO9gpiRI=;
 b=K5rQgrdM/VUtkrWy31TKiWQCfWXzsU930V+uqSHPTv0Db24eN8hsRx8LpUZEBDh77dU3MGZSwRH7POa8WAPRhiyUDDJ4O6C4VghlruJ4be8kaa0l647eDz94ZeKwWwlfsR1Pagw9vRHaHzNXSpmGz2gQS78XI9lahQtdsySHfZW6GIDhUXWC3aMJaYFv0CGDtaqHPJD1xjMxLlq2VAZoQ08f+OUBla7W/DUOvYAetc1eZQpIATQdS+oIqBU62GnMdIJL1mVmjbJtbCXyaXcBgkA0nZ2YYOOz9dsN2ukdC+twpPQfMCMXGGCpjfouC6aSD0/gGFSnZzdAdFD3Gdkbeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1srgqIBCIcZpzXwbvj9Kn0jgXlmj5HQO9vrO9gpiRI=;
 b=qH7KzwaD/ubdm6QQbIHMOza1ITKbT7xHdvJ2z0zE6qOOE701o+TDocIeSihXijO2VuEAQBtBDurka8Lzt0M9OTG9vd8owO8ylvtdUxN46Zz+M/s4q3Oh+NIgz/Pd8NXkw0s/hCHiXiIYzH35rfFjFQ/eCmgtMd7X/u9iymGmB1A=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6130.namprd10.prod.outlook.com (2603:10b6:510:1f6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:26:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:26:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     chaitanyak@nvidia.com, kbusch@kernel.org, axboe@fb.com, hch@lst.de,
        sagi@grimberg.me, martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v3 1/4] block: Add error codes for common PR failures
Date:   Mon, 21 Nov 2022 21:26:00 -0600
Message-Id: <20221122032603.32766-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122032603.32766-1-michael.christie@oracle.com>
References: <20221122032603.32766-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0001.namprd12.prod.outlook.com
 (2603:10b6:610:57::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6130:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ac1a4d9-6239-4fae-a908-08dacc394b51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RkeXD/C/Lu9ELjXvtuMhlFbkw402clJMAYFV+bQ7TUFBemeoJFZycWfXhhtDM6ZomGueb9PUyGgHcey9PqWRE+wxtb31W7/ErDgDfw5ihLiSSdTs1vx2P+lPXdRZMegtbsOY9YgNclRPcK9UBhzX8JHTZVC+4mwjlBogjb54AYuZNRMpSGoK4GOe5CNDevQlkUn92tyvccBpuWH1AtOHyql4BCQtAdmK880QUBWWLCZJQs3kDlvCPIt0yqSaTFsG2j+3zcHxt4wKCDtLeBwlCE2TmhpNw7vAh+KJiavkJZ1WckLCjMvLDQJhJnD+2t1TeBmT8RUHtMqniVcpgrzRyOHsm8CpAacm7sMEQFmV8KQ+ZNB6MHpwt0TXCcFYFWuJXlg6HLZI7lQL7/E60yDSGSAjID5e2HMSycXXDkfBM0MOyeFWRvrlhKpvu/YTJFwG4h/vif8njnMW2xQbXTMJvYRcPqRthBKzhbNIsPNdP7fEBOekqUXHDynoQ/n9hkGY1X0lTmsf0Qm2SAQ4HTch/B1OHDEOXEgLNL5uvq3GEzJEgNp47kq1aqMbgy+jesN0DC9uJPqMLjQ9NCBI5VxcQtjEb1H8NUbh2EFcAUMOIBfu10l04c2cas+uTJrknAbUq3BCsx35c3cyZ291bykkJknQuJFpz7q1YqK9Qz1ZRkCfgNfo5VOKmE2GmA24Moye
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199015)(4326008)(8676002)(36756003)(83380400001)(54906003)(86362001)(66556008)(66946007)(316002)(66476007)(26005)(478600001)(6486002)(6512007)(6506007)(6666004)(1076003)(186003)(2616005)(2906002)(38100700002)(41300700001)(5660300002)(7416002)(921005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RarNLtAe671TThDSqp/LCHcQhedb2a9z39WcBuL6GaUQRUGsMYjZgUZMf+yf?=
 =?us-ascii?Q?ddZQ7R4+KYbYriXYs/Iq2hcMzGWq+6VajWySaSqf5iWRjYebezFcK7OcQoXf?=
 =?us-ascii?Q?w4rIIogw3OXn2BkrC4Qv/ygxX8ieM13B8QmZ0JazyLJtX67Shuu2YgT+NesM?=
 =?us-ascii?Q?eipylDGkJGIWPT30QLoZI5Mpca1KDtMug1x6ulULVpLbiuAlVLDsfcXf0cuK?=
 =?us-ascii?Q?SkDpOYRRERpjmRwUmotNcmrlsZ0hNGwTCkE2NgS+KJ019EXo/nV+FV1tivNX?=
 =?us-ascii?Q?CDQ0bT70DIBHY5xyNLPhrFAqHVRjzvPoivt9uHee/iZKeD+7H32V1eB2LBL6?=
 =?us-ascii?Q?vNLkKuF9HR/bdLxX4L+a42xSIJ7uSY6Ew4eSexIAxzuSbwBc6rHRgcMIkuSP?=
 =?us-ascii?Q?rOTm8G31EDvS4o98tIK3U8OJkxao9ci+2gY0cvaXDX26YU4Ct516QRjhf2xw?=
 =?us-ascii?Q?nx9dytOCIbkNY1Tzxhmtr9jRKV2sYkcpQc4vxeFexsget4MspOqL5vFqrW5j?=
 =?us-ascii?Q?ztRs7Lxd3ipSlT9VwpxShQ1SlTuq8ODhOrWutWCBPrFzlMXHuVyTh2JM9f+A?=
 =?us-ascii?Q?sr/HS+ip8n/YruyE0LK3WTdtzQkcziMEfS8JOUOqrlUPZkH/J8gFPfGyDTJ3?=
 =?us-ascii?Q?Uc3u1Z5sKRR7qHXghhQc1nlApXpkzjGoWhf7QmYLZ05jwd0niNKG1jL/N+Tx?=
 =?us-ascii?Q?xY5b/hk3vvwMREtUZof5itaQywwj9fWb36F08pZ6IscVNXWSOqBxNeul7tkU?=
 =?us-ascii?Q?YZjrchKZVbRwH99ge8WFE36LHBsgIpAkATx11W2O5KT301/TDdJYKh1g71xE?=
 =?us-ascii?Q?J6YH60plIgAQx+BNzIJlF4P0ItvV4jCkVdpenIkeSuixD59kIaxlxbzCHt+P?=
 =?us-ascii?Q?9qmsXVXJaU3GMqNZehB2b4+pbIoQNTndrARKkUG8XEw0xQJcHu0bqDk4peFk?=
 =?us-ascii?Q?Es8F/l4d4V9DTTcWP4JopSVS3X/Dn32elamDtISCLIm0AUJcCRMI5pdQKFrp?=
 =?us-ascii?Q?vFd7TqxBFZd+6iEuHYMnwepeBD90ZSdsuUxWeJjglluRFOqMy6c1h4DILCfD?=
 =?us-ascii?Q?UNsU9ADiy8tG2MoOKziiHmKX8WUGWt06CFOEZKIgWYSqoWzHBVVdFypi68Fm?=
 =?us-ascii?Q?p62o+FVuFQpBu+BW8/j95woPv0jZcIqhSgWiDNHKszDRM68uz57vtdHI3kw/?=
 =?us-ascii?Q?DLSkDvvZexiI/cT5MuzwIXt71of9UmJCfnnT+EfRb4UCr6NIx1tsVMBc1n8S?=
 =?us-ascii?Q?ZCb4XY1Pxr166C0wmUblpbiL7NW5a161QgdGyNBMyPupgBqOlS8rxYEPP+nj?=
 =?us-ascii?Q?yEAPd0nTB/kc3LWSKpvGM02VGGk/tWcF7qa8QOXmxDvbPzpNGJe0Bp0IZPW3?=
 =?us-ascii?Q?Q1NjkFAodx7LYWcur/TGq58y5d6APEEPdGgsSd1qv3BbaqNRyou8g72pcLDl?=
 =?us-ascii?Q?efumAFXBvqaGvpQKPxZwS56F/+QeJP3ggaZ7vMrk98mnz5ZlddRctLWKycCY?=
 =?us-ascii?Q?nmvo1GLCArvtAW+sZiwEdxSZ21w1AecsgquJjFuQlHRf8szRP2M/92AzJcZC?=
 =?us-ascii?Q?FQSUVXLThjWii1p/NoxNn3aWUMICyAVXkaXwe8HWyWRCjQy82FKAP5Rpbj/D?=
 =?us-ascii?Q?KA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?DVyA2NXaWkYmQYMRQlnS6adx+yoTagYzka37D/l6hyG/utGo+h3LEOA5SskJ?=
 =?us-ascii?Q?1mpWDp2Gzwgc/PQLPAPWXJe9dRdgJDECzZKcXGTC+ZxIrD67LFhDAEGTXR+v?=
 =?us-ascii?Q?ukm5bNYbe1D2W6yshwcI6M/37/e+Fe2lRvDKCWMfwdCDxoBH44LGfvb2BvSl?=
 =?us-ascii?Q?xUakZFbzqLRJA0MTUt5GMvX1RY+/Pv/ufwyHpKEA9+K21OHdU3+kjzIUnn62?=
 =?us-ascii?Q?aOmXh9yu63eoqqwvX623H2uMG2PxXJ67gMKQHgq6mXxsTcRZJ2hZn1coc5o5?=
 =?us-ascii?Q?oUibc2m3WbrU6FjLqBWBjN2VXOrmMmdPBsFs9iqtDVensm+35sZoXEomvilg?=
 =?us-ascii?Q?m06Nv8QKuMloSg3kEpVopcCvQWS8HlxrtsGqtJKyyYa23OJJ2iGCPb3KnJw/?=
 =?us-ascii?Q?3oE4DcXdhoIhdzRuOiOZ1pq9P1ZOOKE3g2YP7WQ+0NcXJcjCDxJcIwTfJtxx?=
 =?us-ascii?Q?Yhy8e2rcSw8LcsOGKbYRJvN8wFafBn8LoqNm8zGuXuezsG9dJ6CK2Cy0yEl9?=
 =?us-ascii?Q?72UsVV+l3zrT9okImU8Q5EvUr808uLTT7KQeh4d1tjsdosPNhHtEGu4FAkwd?=
 =?us-ascii?Q?hCpVS4IhqENf3muORgIznPwMsd8RYnv2dzYrlcbjHcKTyuFqyB4ZC2StQkKO?=
 =?us-ascii?Q?yfIhL3tbG2Ae7K8mYA02UaMg98N9b/yltdrPB0s0URwvi5ubcy/15NA/9P7w?=
 =?us-ascii?Q?NB5kyNunh1WvQ6CjevRU6BvJlbH75hUTFJQHse68wI0hLpsg7MQDlR1qDpST?=
 =?us-ascii?Q?40SeWtdNzO4osWjRy8LSHo+pdBvfLuPbxdlbZlHXac2Lra91sgDGHpsFID1B?=
 =?us-ascii?Q?8irx6RDg2IPJfbysFzMgBuePxXRmIVoOz7PBzN5xMOToGHQ0yhcngItp+V/B?=
 =?us-ascii?Q?00qTmH1wdaL3gbq8QjpgUJCM9wlG9qSQCBm/9E99Ivyn4quhakaYCx82Uny2?=
 =?us-ascii?Q?0eu8XYqh2RUVbZ6GBSefOf3EOPuE5gn78FR9xLQprgLUhdyOGHV63EDOU35Q?=
 =?us-ascii?Q?/IDrS+dw1IOUm1F4ndGdvBMAmZz14gNCt5uTwr9O0RSFIYg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac1a4d9-6239-4fae-a908-08dacc394b51
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:26:07.6597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9V9TmoEh8fr9UAzYnoVLNK5GHdy9WnoknY+LDZnfZNYFySxm39k1Zw/dai7wIrvTCuAiJgDruBw2HRejidvQnCh7EePuBkovEZKWOggkD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220022
X-Proofpoint-ORIG-GUID: f10CPIblFqCn8Iz4tgDMOQScKs8AxG_E
X-Proofpoint-GUID: f10CPIblFqCn8Iz4tgDMOQScKs8AxG_E
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a PR operation fails we can return a device specific error which is
impossible to handle in some cases because we could have a mix of devices
when DM is used, or future users like lio only know it's interacting with
a block device so it doesn't know the type.

This patch adds a new pr_status enum so drivers can convert errors to a
common type which can be handled by the caller.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 include/uapi/linux/pr.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index ccc78cbf1221..d8126415966f 100644
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -4,6 +4,23 @@
 
 #include <linux/types.h>
 
+enum pr_status {
+	PR_STS_SUCCESS			= 0x0,
+	/*
+	 * The following error codes are based on SCSI, because the interface
+	 * was originally created for it and has existing users.
+	 */
+	/* Generic device failure. */
+	PR_STS_IOERR			= 0x2,
+	PR_STS_RESERVATION_CONFLICT	= 0x18,
+	/* Temporary path failure that can be retried. */
+	PR_STS_RETRY_PATH_FAILURE	= 0xe0000,
+	/* The request was failed due to a fast failure timer. */
+	PR_STS_PATH_FAST_FAILED		= 0xf0000,
+	/* The path cannot be reached and has been marked as failed. */
+	PR_STS_PATH_FAILED		= 0x10000,
+};
+
 enum pr_type {
 	PR_WRITE_EXCLUSIVE		= 1,
 	PR_EXCLUSIVE_ACCESS		= 2,
-- 
2.25.1

