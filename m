Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7836CC7EE31
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 17:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjBXRsK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjBXRr6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 12:47:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1396C358D;
        Fri, 24 Feb 2023 09:47:51 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OHho7T007318;
        Fri, 24 Feb 2023 17:45:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=YEzbpGj6/LoSgBG7rs+Pg7PVeHHoSV8eTmrlogtg8os=;
 b=OKfYII0brY+/FjsS0QTFcHc0tmlApazqMZWGW6j4H1WHR++6V+edKdI34xTa7ylsosrr
 WIXWtVVcYh4Typg9SuskyKxocLt2Lm66LYGrx5jNGUGpjvPwLtnHH/BU08QXt3QCOH88
 MhC85UBbXNte/X6k2p0WE7IoecdHHx5bZfvSQeDfaXWrOhve/LRJiD1qvaUmlpPlCnKH
 i4z/bksZZn4WRi8dwg/0Xzd7PIdc3KsUjl1R+WUULEsTfwNf/7lQLU6O8CRSiFEAgvO+
 uoX4bd1k0L+curVG3IXFymtreTFAeuQ4Ns+AEtXNyn55D+f1If8sO9Os8NcWM1DeKCZt AA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn3dwpyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:22 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31OHJGXX031548;
        Fri, 24 Feb 2023 17:45:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn49wjuh-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEJ1ZQfLyu3xht+uRgO3/aejL1+FGRy6omt76eq3mCvSImx9spPy8fIz7Q9HB8w0DEtuDp7NCi7JG9TNwcUDqX2X1X4JnjaurU2QSpSC661ZQBdcCDVCVbRWCUsw/1j/6i2BG6VTaMYAfKU2pP2+VIW+icqRaqg3AEub+rMIGc/9yhWssPT3ytePXDaa+FOwtHzMgnTq339Wit/lGgjFoRbJqYecSFTX0kTVnRnS7IwsQjReVpgvHHxY1vgrwM0mZ5SoTi/GWN11ODaZDQhenF45d/t4qPMeQ6StmTi3uRrxIHy4njvH+kZz0hmXTMTThuyNUZhF1ms7kSZR6z4iKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YEzbpGj6/LoSgBG7rs+Pg7PVeHHoSV8eTmrlogtg8os=;
 b=ivg/q94A6Uemh5D4pdpMKMYePxVb/Wto7SM5wOAmDpeXT8wWwWHTvfPvmN9Pls+nU+ipyipTcF4nIsrWtnm+67D1crr6MjOZnf4V1+1ijeQJ8Us7EURDLgnL88ChRKzjesnnl6EAjOkg1ahjZs4hzZ/VJ4D7kZrcuXERmu+wso/EfeQPjn69G2VBsIWg3qI63Sa2K15xK5jB8FS8zDs1OFPYpy0lFdy/uDeyQKDTOeUBEWpzQ9O5jiklyEY2tCK9l1uCx/62D7Mi57ejqUOEp4J8s/1oGuyJNdCeBIAhzAvm5rz6QcGCIHY8ESU84hWy72zzKm5eqvKEqoJ+uJLfpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEzbpGj6/LoSgBG7rs+Pg7PVeHHoSV8eTmrlogtg8os=;
 b=IKjK5bi1VjNDJHlRbWiZMBdcrW4b0c2LHxQ7tqV8xsmFNyae3rJwjzW4zqfeTJHFYaxMy9A0dDvlPN/kWrr85SQZ3k55sLj1WWHmplSn+cmNVtI0PDR2g+MNzmdeYNaefedmX0UfHjRQoCGeKyaFBJ/bBDUn2WthHK3uLbZTJLA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 10/18] nvme: Add helper to send pr command
Date:   Fri, 24 Feb 2023 11:44:54 -0600
Message-Id: <20230224174502.321490-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0326.namprd03.prod.outlook.com
 (2603:10b6:8:2b::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 211feb96-6bf0-416d-16b9-08db168ee5dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VRy4eALglemKT+6kf/0fpJ9ZJKX2ucgSW258QMBa2C2xXjrl5QEBh6OMqGC3SSpsKolwD/O+25GsrP+M/LHRbz0J6QQA71vX2oAUh4XcsrAdlUMlGr3Rk9FjWsTgLmzosws5U1YmRIIndG4tazQuUcURKy2yAvZON0NAqBMPQ717e/yVxQ/5jfGh+GkzBt1yY/XOHm7PdZYu5VjLMtUbidAUYwqkRJuK6x7FAVdypvXondUwcLvuYeCWMzSosv4aBjHTX4N5rmhoczNtcf3QYNqXGEevMHieeMb+W08Ecms4HPWSwEoyI+P2KEG7hz3k1xbPyWKrvMKT9ktv+fFi8nC0tySlqyAlyc9IOZCS5J2eyrjCxqWQWrNpYuXtwABuFUrsPOOXLcLu9PVXR8KgxWCxP3cmEQqeeXPh3vg8Yoz2zMKpwJnZ8drQylkRXiiL8gLvnYt0A/X2+lHPHhqvtUU+JoXyUixMEEc1c3kW7lZeHSA5BdRyy6xRzkfx1afwhNKcKYtfBsgVLsEKVXEQrY7J2u0r6/54HBC8rqqr0lffGEHM8mt1g0r0jYchUYqLT7j6H/NeYJ11lzuZMhmjbBlQJguyANAjd7/xI+sS3Qb8OL5ynVIiuAl7Z72BbE225f53JC8xlEawl7BxOa6tkhlBdu1kLhAHSPOTGHjYIcYOZ43dvFq4yjGnq8ERhNM3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4K+Y95CKTM2MAsg/ZEU1jxOeC7miBfY5a2FkEtr44nYHt5capRu0qVs5i1s4?=
 =?us-ascii?Q?IdEqPuKj4r0IJlhO3fvFj/n0RjL/ioYgZaHKxDPTE6DDik0AlpZA9oozA/q1?=
 =?us-ascii?Q?ryTtdlNAD5KYnjXI82kAWrsOU5UYfxl7upUo0Zay9ubmkQz06+fwfDRglP1f?=
 =?us-ascii?Q?/gojRB8JpMeG6LqZWmoZSRnHDVDx1YcqjnSWnzvYHFwYXuubmRd5ekDSWc47?=
 =?us-ascii?Q?GB8HHzdOrWtRDyOBVisJWzJzHiLBs9g8pM5Fy7fq7FvWPTHJdpfvz1Z+iL1V?=
 =?us-ascii?Q?pgjUvGnc+EMrNV+s9tg9ybECxjJuENyc4SjeopWb4BpABGZHiihD2jimDIqz?=
 =?us-ascii?Q?UOEk7Ge1h0yZSgEdtVJr/biE0GrkXTSYr9sgEyOVVctYBDYdVsil4xu7F2TH?=
 =?us-ascii?Q?U+dx6mAV31+/ttz1w4BpuIBwbkBH5yOtNMNJwG6QfC1di7NpamQyEEHkubv2?=
 =?us-ascii?Q?uR9i9HKdBC1OQGGG0n1MGzptNP2PeL8Z+/NTrIUnTUzhCcTsNmZYydtUNQKi?=
 =?us-ascii?Q?sma72KKRPetXYlh7cKgO7kajuewAF8BGUG+QdxyfFBilN4U2lWlBz1ax1Fkw?=
 =?us-ascii?Q?myCJC1Y9UpMNlkOTLFbQdQ1xqI8n3DyojxdsHS8ZlIqDo13ESwNFPY6LxHkR?=
 =?us-ascii?Q?hTkiRQJfkeV4g188oRaPEW6g4dzFXJfxHyOlo7n37MxlDZU7imkZAIMgQcWp?=
 =?us-ascii?Q?Z45UA4uffCsoJlnoVe8bsI55ujojHpMJTdWcYElTXuTUwcsNIgI69re9ytYy?=
 =?us-ascii?Q?PUbT96AFFt/St2VW4CHqVAa4Z9QElzwcAOoGZhU/8XXFvF+AU6ITXL2b+gMW?=
 =?us-ascii?Q?XnoNGZTr5xwwB0UV7yF7XtdpGDSOnWSFAkkr9NtvUaMoLUrWzFtcuTJDVQDE?=
 =?us-ascii?Q?ajeaptqH54W3QI1zG3K7fTrPuU5XHRxzdPQ2F/3Q4uIirLAbX/IUYFObLFqV?=
 =?us-ascii?Q?ErYsSh2V2Jworzr6ZjtbldAdKbpNUZz7DSyJaFCeuPmgQ3dVy8MjholOsml8?=
 =?us-ascii?Q?tsKoOUOxOOUVQICnyK9X7MhpyQJsBs/dz75Gc/rI7o3axyO1/zKVu258vIB2?=
 =?us-ascii?Q?mCuYACyRQOMXpvkKrifvqaJ0/wvy5LO35BhhKvuIBwHfzjSfFOwpDG12pphn?=
 =?us-ascii?Q?JVgVibDVIl4MHpK5OCo78woy8szeJvHDoUz3OfQnSkflPYQNxC84GXxwKEsN?=
 =?us-ascii?Q?H2aZ36PhRW4jHsRUKzLholqAJcE9WQxpIV/63LkMvRQisTLIldM4BqYpznXo?=
 =?us-ascii?Q?Q8oiefQFuJpkRBCfxAaOJUkRZhc5J1t9ChnsB72oEll8+7KvTT+mNZnApbH9?=
 =?us-ascii?Q?riPVTtXBN/9qxpQ8KhkyGo44/dj+NK/Nq4SCON4tQM865TwNTarqXis6/cnK?=
 =?us-ascii?Q?0RSy0NtvL0HdvPt58rXTNQzMZP2EkmE0bNPrNgAqJfrvgE9u77ntVNRkN1Ac?=
 =?us-ascii?Q?+MW4VzCvx8eCMv73HTi7sgMzb7kZ3vbIxtSdJ+jPCcmxNfV339rCE335a94Q?=
 =?us-ascii?Q?dL8TfRKFOyrSsnBFMV+JKI9of8RexkMrIKjGaEIi1+njCkj+8salHwTJ0V6h?=
 =?us-ascii?Q?QdofyGXrqhe2eTHMQnPeYndlN+Lb+C3pp2mRNCB9bUrWdGGB2Uq7A52vAjfS?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?05bckQf/lFxZbuU7GTt4XIZgcQhexaLhQcGGaZtHHHMOV87GBFXjvnUIGvtw?=
 =?us-ascii?Q?rlG6fvk5vWj+r/vf8SISgghtxX9d5pEOHtZbHEsOJGk89VzXPaskq+aPpxPw?=
 =?us-ascii?Q?8SVi+LMypmANYYqg6IY7o1GJLsB5s48V4v6YUJWl7v+AwzwL88fTbDufila1?=
 =?us-ascii?Q?N6pGr+Wzq+qw8z3CETdXyyJWodOa2kfJtv8G2chZtj+ciguWDJlyrj0kuLuI?=
 =?us-ascii?Q?m26uIwBysZqzVNJ7MKaER868oqXbU9UaUqmbHYOB5X9X1BL3o11s/CUsf8NW?=
 =?us-ascii?Q?JUYcbDW07Ax7qyG5/OOwQ6bwMJC796eoO91krR9d/rGBXY34eSjvrH58yBWR?=
 =?us-ascii?Q?0ts/bootqCvxKlz/H51d12SUlTr1RFajUGTRk2n/CBhs9/CQiVwibzBbM5/F?=
 =?us-ascii?Q?SXiKBYimqaAwK1YBKGLYDDdBjTgyUn1dkmbfCzz+HCY86Vngf80t4/eTv3tn?=
 =?us-ascii?Q?Ltjc7mqd+lP687B8cHpTD14P/TibtrH1IeMrsvl7U7jeqJPO+ZSqBgo0IJdo?=
 =?us-ascii?Q?2I0pDnmV5REByyG0NZi//mhVMxfC82FyDPinp9Ej1tD9pvXtYC2MzrC7DFc9?=
 =?us-ascii?Q?IpWNOUEuA+UAh6xBi6ZlLTQKkCywuil4cZh0L8Pfd6jMWmBneFVX/Wn/YptR?=
 =?us-ascii?Q?galCVeSRm5mWo5Nu04cxiUYzKWceGhJkX1hNH5e2D7Nr5TcBSx6DrfJ2Wk8p?=
 =?us-ascii?Q?vBADoI6FjxkaulhI4BUVw9XvJhbhohaDKMktBb5gtAeX8Fwa5amtZIaKCOq7?=
 =?us-ascii?Q?EiWlLaF9Dm0EhQWYD0lZyCAH4YO6S+2B2WwI9BR6SjGoMW/f8n/TynoF3vFC?=
 =?us-ascii?Q?/wDbSfP/GsYPBxggbDzzN5Xx2DAOUP5YQF/nPyaQg3BuXebUm5loYMdItwMw?=
 =?us-ascii?Q?cY+DQ+7rxLW/fTvuLzuDQuyyDWoWK9Nli75x5NXO/s8cnfgBpKX2KL30T8jA?=
 =?us-ascii?Q?uN9Q0eC/As1qPdD15h1ycKqCV61iATbNVukEQMZVkhWUN0FFwO3vnJ7ePNSX?=
 =?us-ascii?Q?hsIkTMiHsH9b0Fas/HrQ97Z65A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 211feb96-6bf0-416d-16b9-08db168ee5dc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:20.2036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PZExdwekgjO2sO7eALSWdlhC91w1Usnzm8+VuiomCZLb3f5Lw6l0dKuej7tclLTCx6iw/izvlOpqmNMbaYezTe+zHqQHrNOYZ9yi9Au9frw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240139
X-Proofpoint-GUID: Irxz52Esgb89BfOIaa9Bftvy9oduZNAF
X-Proofpoint-ORIG-GUID: Irxz52Esgb89BfOIaa9Bftvy9oduZNAF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the code that checks for multipath support and sends the pr command
to a new helper so it can be used by the reservation report support added
in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/pr.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index 26ad25f7280b..7a1d93da4970 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -27,7 +27,7 @@ static char nvme_pr_type(enum pr_type type)
 }
 
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, u8 *data, unsigned int data_len)
+		struct nvme_command *c, void *data, unsigned int data_len)
 {
 	struct nvme_ns_head *head = bdev->bd_disk->private_data;
 	int srcu_idx = srcu_read_lock(&head->srcu);
@@ -43,7 +43,7 @@ static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 }
 
 static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
-		u8 *data, unsigned int data_len)
+		void *data, unsigned int data_len)
 {
 	c->common.nsid = cpu_to_le32(ns->head->ns_id);
 	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
@@ -71,6 +71,17 @@ static int nvme_sc_to_pr_err(int nvme_sc)
 	}
 }
 
+static int nvme_send_pr_command(struct block_device *bdev,
+		struct nvme_command *c, void *data, unsigned int data_len)
+{
+	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
+	    bdev->bd_disk->fops == &nvme_ns_head_ops)
+		return nvme_send_ns_head_pr_command(bdev, c, data, data_len);
+	else
+		return nvme_send_ns_pr_command(bdev->bd_disk->private_data, c,
+					       data, data_len);
+}
+
 static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 				u64 key, u64 sa_key, u8 op)
 {
@@ -84,13 +95,7 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 	c.common.opcode = op;
 	c.common.cdw10 = cpu_to_le32(cdw10);
 
-	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
-	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		ret = nvme_send_ns_head_pr_command(bdev, &c, data,
-						   sizeof(data));
-	else
-		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
-					      data, sizeof(data));
+	ret = nvme_send_pr_command(bdev, &c, data, sizeof(data));
 	if (ret < 0)
 		return ret;
 
-- 
2.25.1

