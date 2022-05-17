Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D95FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiEQWZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiEQWZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E65752E4F
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:06 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKYLpC029125;
        Tue, 17 May 2022 22:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jWNhzM2KlwvtPaHanj0R7f0ybWMgdd83/huj0Sg5PFs=;
 b=wRy1i4BQciOrx1ArpY9mM7+nk9zlWjfO9nOgAZDSg0yY7l2x8HmvRcBIoocBeHPbhTze
 iUcSY/0i8AvlUQArvMrca5NJS9DwdE2nlQWMbkxQsPLBZSqw/PU9Rn+vqoFYXyKCWiz2
 3YIn7vm6Si5A+2dRuSzjjWbipkeMLUYcAZnBrlZhTFKLMj/izHpxKoMCJqgRRwgyRdRC
 TSQ8FfyOm7xrzQGueieWmsKBeMnFG10VAIJ2fzIpv44nY3f11B59PopQDB5GaLwihA+y
 MpWCec6zao6bz+ECN5I4SNTyjEa4c6Wn9IXjMzHQuvc34mDmupz/y2/qLpC5iS8WYAVK pg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310qrmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:24:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMLghv031743;
        Tue, 17 May 2022 22:24:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cppmnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:24:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNpzn9MPv16s/41arlfp1mZefnbUgmgbEV52hW88Vsv+9R4Y4+6kWr2kTJUvwiukxJnTQpbbb0vyQusBczvsK2wsK1deXyuR8kMsmumL+RYmGwe+VrwwPonv010MwloKlg9VZJjXw/L2gENgsaPOZdKuwZS5949HQHQgbYXNYBDiU6oxQ/AFzHhJh27uEUA92YYgDuWuF1LswMCeYUISQVgyySli+/94JpDOmsepduTnCSo+G9PebPYGZ3LmlHxPfo9MUCBkQosrNQr89mhteyF1X1463dgAnxBofTvpzeuJISJ6JG5ali1OsSis/KkFnsV+0w04KYqTK6WbcZom2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jWNhzM2KlwvtPaHanj0R7f0ybWMgdd83/huj0Sg5PFs=;
 b=QQ4aJMFD8KHMQzxt4CLphfTISjnJQT6tkjPcvkadm/Fjg05KjFTaMcOk9fd7EL1jV/8AMZmk8qBd3DiRU5iTaLeFbgL10ZtWpin4pGXTrklIC2MqIf6TMM5tfGSegtlz3j3/1p4Ad0g42XdnemW50D8WdmFCYo2d0ykukrYfgmd02jwweS/OL4jvOc770U3UwGtIaHc6q19AofpscrLew5Uw5C2vRrDC+CHNWYvQNszM/i+2c0MlWv9t5ttEFI9Uc03SrYr08Nf1Tv+ooNxnguUk965JtSDMRiC4Xlhcc6VLD8pDHT8jcEVPUFK2T+CrENAeCZ3Nq8LNNqNs0HFlTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWNhzM2KlwvtPaHanj0R7f0ybWMgdd83/huj0Sg5PFs=;
 b=ChwxO03GKlO9HMgfzAICKHUmDu4chAD6Mb+WH3zAhj+PrxYRwE5pe8sSF2OsuFNp5ZvmNbXcBg477Hp0N7gQaF7mlGTgLCEQ77JReAI+qzbz7GGRbQZfagWeqVuz6H7dL3Rmn4FMsG5kTLwIE98H93BIvg0bvMWUvIgyBsoaDqo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:24:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:24:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: [PATCH 00/13] iscsi fixes, perf improvements and cleanups
Date:   Tue, 17 May 2022 17:24:35 -0500
Message-Id: <20220517222448.25612-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 754c808b-6bf7-41b9-1265-08da385411e0
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55170444EB4FEC45D4AE2022F1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aNgURu62mx3LPS0IYQhRM9GV5y2/YKncB7VQq0uan/Bcrarcl/ZaLpZU56f9uhdrOmxxlgUYxvJ2n8N1Nv8iZK7hunXH2Q3jDcZUvIpd+FlbW4pZE6dt+KrJTCniLkgvmJYtP13wx7dRLlEA5vTx7eQXEUR9wuX9UEHhJU8YVLfEeculJH+ZQYztshhGOgSMDq/LOcMYZXLxJUNgH/4vMgY3qdFt23+vOUDND8v3votoJlSmK+srgeP06iFVky9lLKT9vZ/xVcwuNUEDZw/gxYoYIXszBzrFyjjBQGYy6g8cCPweXY1lqSMzrhk9vZYcB2Tfra/b8G8OOlgPSsSG35RCWnRPNL8/nc8GSnG8grSqHk7zLjb0htWwmYBHQtOzIaCUwUp7CEGPBh4x4Kk8sW2TmXiFI2etop116NIDTDsr+oa0CLRimnOdHUnAAknZW6DwaV8Us/A0UbukaRLCO+eH2anEYwlJfZCNiy/VeFeerOURDyQ+Scz++HEgaKiUEGQQDYpfOeCRVOaqy7mtvO117SvTzThZW8mRRaJxMk0Eq6cGG38OFqG61EfclTfQ1VKOySPm0eM6g/kJdgz944k1H/+zj8bODsQg6eAxzT5NtLfkWrmgd3iw1S3exeYoDXieJSn8xv2j9W9eXCoq//LZa/KcB3B+VXXAZFHftQbCwUfYSRQd+o4nhQLmQh+Lt6CBndSxg0Q4rK1Qyj5YVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66556008)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(1076003)(316002)(6486002)(186003)(558084003)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rtiyApHROtiwFcQv1cC1qmwbgWnlHzok+2e5HIbitRdSNIgumee7qFTSgdKW?=
 =?us-ascii?Q?Cr72p3hJLagdedKPxJ77FbZSjPaFIkl+xbQ6RicSNZkDHn+lMinhtG+rJkMH?=
 =?us-ascii?Q?TEHroits54SsI1BiwXUEpPVv5QanJEfaWYPToWxFnysrJdylBhafng+chi2N?=
 =?us-ascii?Q?m9ju8m5e+PyLIflsXoNVQ0qJjw9Pqk8W/Ms6xfPLi6iil0FAi3Xpp16ntLCY?=
 =?us-ascii?Q?+HufO/x5Bbme9hXoxF9j5ulO+uyXWdn+o3tb0+uDq86t/3ubGNIOTykb5Ucg?=
 =?us-ascii?Q?EIh51FBI+b43xu+r0dmEWVURxzfbJgu1Yak0Gc9Ut7p8lNh36gcCx4PjD7jX?=
 =?us-ascii?Q?76xQ6QLyZTN3o/CyanORljJV5is5USbrRa+EiI7DmUZzUZeY6xmFd1D3EOof?=
 =?us-ascii?Q?jWYMBlOxZ2YcycLK3cgh97QlmiF/Mi9UXpeAaiV+Q7XQQy8lJpDrhpJgvucv?=
 =?us-ascii?Q?OQIrGCLfMOAmvbM3uEh2eO/JiAJrt1v9B26EcpS0wOA3C/FBohlhyDseJEWL?=
 =?us-ascii?Q?J8TkROQSFqrPZ9RJK6UiTLHH0fR505UQJ66CIVqbzS5kzSUTgfh7ilqEH959?=
 =?us-ascii?Q?7URuqbRxqIK+8GxAa2L8k6KMxkcNhoI5TTUDDyDohm60Xh0g6HIxN3xdBh47?=
 =?us-ascii?Q?RWyPPeNssqDU5qS/o3sp2Q9evAgLEZJhg/CNWTw92hPh+YXHHzdMvTEhgccx?=
 =?us-ascii?Q?zAmxJWU8/OrnTKXCOIh6raD+e/5mLhCaPk8ItwDVwz+SVov60ygJrj7kWWiI?=
 =?us-ascii?Q?z8WYdzr0RkOxBKVX7QlFWuinwhp5RlP0UlXXJvZrQenreUUEOdZ5EmNNPEJ6?=
 =?us-ascii?Q?og3JTUOx5lU2/xfMPLV34gReIEMhu4yc20qWiR9bUqyoHMdHgW4sLLMd73r1?=
 =?us-ascii?Q?9U+IM0sr+97f7m9yEfrO5yrd2gHJScpOzSj45UVfqX8U8KSXl2Caob7XnfcM?=
 =?us-ascii?Q?dPqc5ImFEV9ic0g35UIRRFDbNgu2kQd6a5lgTKO5aSsucvFVZ91jT5WtBXaU?=
 =?us-ascii?Q?hYt+s73BeX+d+AC6IqXLPNJ2cLiZX46S+ZsazJMFA5ck6QRK9fcLKILbRB0P?=
 =?us-ascii?Q?IN/x1m9yeGhXd8ERZVrwG036Psm2WutdKN6j1KRXnQ+R6OlJHxTqhY5jdPwB?=
 =?us-ascii?Q?aXcYwMDair7Un57Ln3Wh/CMrPk52+qggqWynDRuiK1vUOYz454qqfZV5STYa?=
 =?us-ascii?Q?ehgkHd5nW8CLB+hYSvoRi3boztSgWCDoWcrpXfXFFkUH9CyAIFdLM31yY3i0?=
 =?us-ascii?Q?nwswDukL9IeYBjoAHfI0lQ6jzQQOW+0K0ZNOijCjD3Yx48zsIoByVni4EejM?=
 =?us-ascii?Q?HX1bANRVoFsvWJBUNorU2q5u75VPg8SpkMZTM6Z7GNX+1WSLs0l9i4TYWHu+?=
 =?us-ascii?Q?/Ca4+yHyuEAgwr9y99klV9QaNx6d+fKTMHuR7sZfDfiMdrEigycl57OvmkPN?=
 =?us-ascii?Q?qDOCcrFTQvOpNJZK3TJX15WZq8SUGGNU+IQBJ5psa5ztkZqUF2xIeR7Gc02W?=
 =?us-ascii?Q?X+cXTjB5+C4CDOjR1zOvGsboHj+qimAE5QzhSOjwFeizfDloEkQ3dRXgSI9Q?=
 =?us-ascii?Q?iTnOpwVf4RzhOLX07YCw/9gQ2Alg0TDMscPi+aOk1PK7Y2DNxe5B40CSd4im?=
 =?us-ascii?Q?1KcigDUvPLJZGuh/xppT9Lr8s1CjEFJ4piXhnj6cV5vt7O329QSIdarY6Xeg?=
 =?us-ascii?Q?Gz01NF+i05LRkjZmIZB8oreA4PkdwubsZjQNNZqODt/eEyMft4n0StXZYRG2?=
 =?us-ascii?Q?kwo614eBv8yz2x3idkrDcLo1vBYW4Hk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 754c808b-6bf7-41b9-1265-08da385411e0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:24:55.6526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SzyBV0h6pEt8wRiRnQvk8dSqzPfj4JyQ4dWy6sSAX5JL5RuP2r+kjJ/nW+AEEyiz5gtwGf5Ge/Rw/uAab1MUbstATHxq4yj006NBMgcrQ6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=871 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170129
X-Proofpoint-ORIG-GUID: V-niDo9jpnTA2LHBQATUL1bEPs_T6C-A
X-Proofpoint-GUID: V-niDo9jpnTA2LHBQATUL1bEPs_T6C-A
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Linus/Martin's tree fixes a qedi boot
regression during shutdown, improve read performance when using multiple
sessions, and do some cleanup.

Lee, you reviewed patches 5-13 already. They were posted a couple months
ago. So, don't waste your time double reviewing :)



