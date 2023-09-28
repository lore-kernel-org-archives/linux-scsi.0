Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59124E810D5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 02:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjI1CJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 22:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI1CJO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 22:09:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22A2AC;
        Wed, 27 Sep 2023 19:09:12 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RL7HFV020994;
        Thu, 28 Sep 2023 02:09:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=LksiKq3xV5vyyzccUTIyw9eUH1MabWrvGSZxWp1Gg8s=;
 b=vRqy+xV/sA64wxw74yUF6mpWXyAWQZlSTq08AG0jOqJxZKp/Fflkh11wL0f+0AtkstjM
 sQdz/7kAs14cyaMJ8P+IstMW5NBsbAFGSwPLMoXattHc9IeDy0E/Y99ZPnoq4nKshgbQ
 EA2L0rRa+skDo1vTd/QhOjOYKYfojwqG1cn6e8eUasDWy14KloyX/m+WqW1FuLy5yZyG
 G7Ccj6WhbC9sc0WA4pAmSeVHk6CnjQji+IWEfrcodHRNCQykMkPKihlGGFBKJTfWGhNh
 7m9emp2f96nttxWDDNJw99cC6Sh5ALxKZcG7rsqp4RqDnH1PRlfBx4ngtLJwecO+D9YV NQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9qmuk384-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38S0kn2n030876;
        Thu, 28 Sep 2023 02:09:11 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfeurp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ep670oJDhOB2k/7E1UMPLxJuXdll0ccLdqkeXnd5tzCyMnQtl79NiqTIaobAz2PVGfUJIZwPsVH8jzKYPBj6JmOdZUy9aWymVUUg7Nzxid217Ic9+BWlbI6sfvzxjXi3rIqw9jxmlk0t/PRo83BCoe8tKS2W+5Wjga0Bsaa05BpH2mzLOC/zuv6o1YDjwXObaL0pm8RHStYJuvfLeosSqR6gSPHbzlMEswWs3W6prQZA4zLlxICIpZXIRaKN+mXHoUiPoGdjdQYSlWSuK+Vo0B2+1EG2zfltVTBi8KCd6VGT9zsKXoaXhecHpkyTLcSBuOQex4CjcoRbmXMvr1pHPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LksiKq3xV5vyyzccUTIyw9eUH1MabWrvGSZxWp1Gg8s=;
 b=m/v1N5lMjB90c8lbmJUgORAOyVW6G6dzEdoJR4wgUMJf5tSk5XmTazPyr67kIs7xbM6RuWx/qkJkPp5k0CQQQh/+BzYqyqTQm+wgJIphF0ZjyAItLq3kSAknjjz4MT9aC7/K4A9Jvy7BFskpaXiujv2oN1VUWTwta2FLDEw3Flx3C5TfcxJOhOcuzO+YyBVvwf0lLd0fRvvCJcawm3r8NmafXC6/49EBEd3iVTKr0JzsCJPZ7eqOlFjAqJsbqzW5rrTUNEVyBrRMn6zkkRgFTDMAaLHnzDKZf0HbC0p7G3ni5GR6GazBuZ1xXMM95wUWiun7yv5f1jQr2digZ2Lo6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LksiKq3xV5vyyzccUTIyw9eUH1MabWrvGSZxWp1Gg8s=;
 b=nXsc8Ic/VIpnUYhE54DA9YBUSS06v+CbKtbCxR7bwLFAB8e84yohb1Djp3PQvskya0r0ROXspuWwUA7gaYZnDvuOFy2UFGqEndU7iOH1esxjHu4Q19eAkURl/W1eSJVBoNknpWtx6J6xbroNvym7L59hvUa2H+4DpCecJpSpxus=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 28 Sep
 2023 02:09:09 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%6]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 02:09:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 1/8] scsi: target: Make write_pending_must_be_called a bit field
Date:   Wed, 27 Sep 2023 21:09:00 -0500
Message-Id: <20230928020907.5730-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0253.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::18) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: d32ca2a8-c9c2-4e97-f1b0-08dbbfc7e66d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k53T+WK/8gDZKVgB3j66/cG8IZ4kgSQ9eRXxmYxh+beWPDm9Id51Z454T8Rr16uXET+w+uuwC0mAXdXVeecEpz1Nx6yJ9XAe5fmWS9PSYBWGMq1f8KIaHdrPFLhRjPI9DzXyIDgmJooJw6SFIwyuVhr2NKWvp/X4Iu4H5PY8B48hloSgVatxDi6BvAe4I1jvBNYgA4PTZvoBlH95yKkAMb6hCmjh+rAEx9NA+w1ojD3iKwdyGb0936RQ0cS7t9gmXndzKOnr6hpxYbfMbaXIq32mcIdZcudEXyRYwFIZ6dNkBkNPOT2xruTvCTbT2Rt95vToTQ4zW7vW+AyKfeKgioRFknFx9atjm+p3XvkWyIbIIMFKJwfUp29RrGB8ugEHmmG1Gnl7/Z69Ab47B7JgshcYPNrMzCFfr/EJytlatb7Q3n/bdoV8GurTjORpz6dXQWlvD659jszZcoElaKDCpYOVlXt9hqp3wH1RYJGlISEWs7Id7VWHaBudpZ3Zcmth8Oc3qY73dQ6f1/oJrgEaxO+/2AJWwU5DDuTcWFYSyrDgO4Q/pMqfrSEclx8fbeYE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(346002)(396003)(366004)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(6506007)(6486002)(83380400001)(2906002)(478600001)(1076003)(5660300002)(4326008)(107886003)(66476007)(8676002)(66556008)(450100002)(66946007)(8936002)(2616005)(41300700001)(316002)(38100700002)(26005)(6512007)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t6wlwz8KSM8SoqyfsAm2XYtcH2DhWdpz36jrnb1N5MQo9giPSyKic/+CkP4m?=
 =?us-ascii?Q?UqzYuGqBIfrx7AqVlvXdPjgrknw8GpQwHvAycblmvEiq1SLJLT1sy8818m/q?=
 =?us-ascii?Q?1cAjog5sV9GT+JQuGJMeGqX282h+dVviqSgjRS+Y0KesSlDImifAeA7kyw9g?=
 =?us-ascii?Q?g3v7F1t+eegWFc0sdKw4Adhe9MCbiB8LMSnZLYbubYApr2g/xE0t3ftyUiPm?=
 =?us-ascii?Q?VpQVmdWA4CBtXPo+jgNcWQkZnz04XnJmSEvt4neNsZAPEqhWoT/13iKJhXBB?=
 =?us-ascii?Q?waGjA1DoBzfIOjyLrTwQKdMFgJdl9bIbxPduLD75fbNpovjCF6Phks/bjazL?=
 =?us-ascii?Q?9MsFVDw9+gzEbQe/+H6XFvy1UsQBfovoi6X2/AM0PpGtw5+j9r0STOEPhTGJ?=
 =?us-ascii?Q?6qVttiSjVYQYB/CYwUgWekQKyq4hndJoKCFkPpw122+kTHT7vMud/6noO6pt?=
 =?us-ascii?Q?g/nthwvPYuvxge5p/benGfqOFtNR+Vrr5NIv1P72fp2HAtHJHDwXa/tj/h+f?=
 =?us-ascii?Q?gx0a7VuYRJJhYkfL2P8nrxzgBASTUOdnVledjn8JiUJ16cxV361R8vWbt65f?=
 =?us-ascii?Q?GPPgQxZcpUWL3VtmwCFQ6TR9XjSvWh/9PHVZmKOFF3qO+in16BTXBoIVxw+l?=
 =?us-ascii?Q?svI7CPPrFkwwd91XDk5ghtU8rcEhiP3+07Eoys1sBWz4cimYDnIOamCnvCDs?=
 =?us-ascii?Q?9tNue7FY77hCjFW15xz2gqWkYJ3Z9xoT9uPLp1wFBdC7PzKxpBGPZaxZpIyY?=
 =?us-ascii?Q?fGVzFvzcw2Zg8IhSF5cJFE0LjlE5021y+kfGfR/sFk/knMHl6tXuNxi3+fFR?=
 =?us-ascii?Q?0vv1/c0lrMatLw+23E0GYX9m2GzM7n4tKtEYi7OUa/A2YWhMEfBHqut7Ibpk?=
 =?us-ascii?Q?J08Tz3E6LD1rVbfvdXkA/TbF7lQNcaOxeeHbAMHCqhw4V3GAzyoAn98yaxem?=
 =?us-ascii?Q?f+OBadRqBeV+C8TC2ZGzTXk/cthKu+31EHSpwog0iElotpXBfefaEhHocuAs?=
 =?us-ascii?Q?OZPwAKnBoSj9sDfnxdo67F4snehcDaiJIDPwfrW5QYNh1mJgs2R1ADQmhDgj?=
 =?us-ascii?Q?t6LPrcGlTKqDQLTyBA6x8QjqPU5efWBJRmnecXJsomaCIA0GksDttcqMjgRe?=
 =?us-ascii?Q?xDhtBE89QlJ6xj4KjaLQayhRJ+LI72oRFtU+3Kvy0r2gGkISaJj2ompfR+yx?=
 =?us-ascii?Q?xZVqfXTKOaV9QCXc9vP7soko+/UPtY8L5B+blH64xxSpX5HwWCJxbNoKsU2E?=
 =?us-ascii?Q?M3v1gC5IN3bUjc8sSHDTLgd+UP1YHaKcI3Nqf5o5HnWRr2i/FUH4LF6V8wPa?=
 =?us-ascii?Q?ReHt8gd/tk8kzAmGW4aSx8gmkRmLq677fDxkdWW1zHMxYNni2qu151aITVoC?=
 =?us-ascii?Q?8AYGxyOUNUb+fr+lJKYdyCWd0KIEG03UltNCBucwAQx6Eluyu1aIO+9vMk3D?=
 =?us-ascii?Q?RxMXMcA+CCG6ndh5ASt8k9mQX/JPfb5C5EX2EJFH7DO90OYr+0z8qaGoXpOA?=
 =?us-ascii?Q?j4mvyDBTuHh3pv/nVzI0BLBrAjzaRTBV5p2VMXv2Vc9WDmLOuBRMDXFNEI9+?=
 =?us-ascii?Q?BwvdPlkiq/oIsZQGo3dproaXJjxsTihDJi9PFk1CsZzIXa6TdwfOle48LRnE?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tUA1ccVxaR+FHAGOXaRc/e81LyI0VruPVwLXHmYeS+qJWL4bUM7Efx/3ttFIhh8XdmmiTn/xY+f/WagdJ+8MkpXKo9oSiaB+dwPJpcVRJWSziDFZulb25iu4fHCiekZ9Y7GI3mofUMK3zu4GDOsxpzo73G2O3s+EtNcw/RnY80HwksGojCoxqItQHYU771fmXczIMViZcMNW/4odTRbks9K5bmXE6uQy4OIUmUnzXK6kI/OQv3Q66OShm3h5WY1b9KNoCGIfHal+I34VhfaiqpVNySsC+ezRO1QCjx3GsHPHE2mBEnnLJAn7CtCv4aw5tqgrKNrpxlKbQEBFkusWsV46lDtUzv8EUDrH8DseWTYBsdZ8OmLtj6uWMefg7BEW6hBIkOt0LWliCHHMJt8sm4juArRk3Y5wx0WLh4pbF/xBCWTIqdL9mnpIkPM0Xwn6+gzdu8kd2W6HKHMqkjyE0K15SWoEsOnn4nkuxRmC5+5VbKPszka+66341iCZghPmQ5Yc8T5dcdjrE+0OOmByL9dhjeF9Z4PTxP1EDt+8Hj7DnBmE8PFcXTU9dLczrdhdI272FwhFdeBSBocj+w1cYMN/AEeRaUS15bfTKTpItBafsnYfxHnwu4yi2u2TkBTY3F6Q69lSFqQAwlbpYiAEZxEUz+Ir+1wzx8okz4U5YSURfFfVPlnIBTx6G4oJXtTnzM1PqxyxZIEvypfPs/vlUEUlr7I6Ln5GavqEN8f2SbgjXB/QNVpiqMaRywlrtY0WKcIqI9OAJNK/HzTpZqB4oQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d32ca2a8-c9c2-4e97-f1b0-08dbbfc7e66d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 02:09:08.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gcFNekdBGuXki/eL/FMu/8MokGbOwGPK22bUK/ym/AvyRpCIvBf35FxuHvHmI7zKXaqaoIOOVtl01SsXEFmKJnvsIA+CTD1DY3DVzH3xENg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_17,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309280018
X-Proofpoint-GUID: ng8qz8B9s1GkRstYWLep5fr5TIn95jgY
X-Proofpoint-ORIG-GUID: ng8qz8B9s1GkRstYWLep5fr5TIn95jgY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches add more on/off type of settings to the
target_core_fabric_ops struct so this makes write_pending_must_be_called
a bit field instead of a bool to better organize the settings.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 2 +-
 include/target/target_core_fabric.h          | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 1cff6052e820..bf190dcb9eee 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1589,5 +1589,5 @@ const struct target_core_fabric_ops iscsi_ops = {
 	.tfc_tpg_nacl_auth_attrs	= lio_target_nacl_auth_attrs,
 	.tfc_tpg_nacl_param_attrs	= lio_target_nacl_param_attrs,
 
-	.write_pending_must_be_called	= true,
+	.write_pending_must_be_called	= 1,
 };
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index b188b1e90e1e..2a6c4c935666 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -113,11 +113,11 @@ struct target_core_fabric_ops {
 	struct configfs_attribute **tfc_tpg_nacl_param_attrs;
 
 	/*
-	 * Set this member variable to true if the SCSI transport protocol
+	 * Set this member variable if the SCSI transport protocol
 	 * (e.g. iSCSI) requires that the Data-Out buffer is transferred in
 	 * its entirety before a command is aborted.
 	 */
-	bool write_pending_must_be_called;
+	unsigned int write_pending_must_be_called:1;
 };
 
 int target_register_template(const struct target_core_fabric_ops *fo);
-- 
2.34.1

