Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63AAC25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbiHLBAu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiHLBAp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:00:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E4F74CF1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:00:44 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN6ftX023117;
        Fri, 12 Aug 2022 01:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0QLKe5jbBkVuExRrCxCmWUELSE6zTcBSJiAbPzLfFI4=;
 b=gsotiykc9q/f6cPUCIsvm/wQ2FAf57kqJRqxWWNMr30hM7u8AG8vVtg6yC1g1oVAYrfD
 r7WehTCw3pVkSbFgShW9xUBVSBs8U8naDwtkvu88a4tQ/WPprc4WvZzUfNgnIimfAiiK
 f/NsQ992648fe8FXc0b2X8Apgwa90PLIeGSnQhD7fTmdYDgLqQe5oExnGKhX8Rh1rpqX
 mXTs4mg0CTp23m3ZYQJw8Ds6raV6RbTI0GjRVTWDmElIS6VGgRm+M1DfszDrrDoAMvko
 ZbXUzPaAhbLFpfwwL6kK0n8tsVADIvUQoNrzJKC195bPaKVo/cU9e2HAO8I5p8wMmupi Ag== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqj65k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C0BuYi023733;
        Fri, 12 Aug 2022 01:00:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqhnq3u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmCf7IsDDwYVy2mOr9oPBrBKHGro4Lv/2PHdS5ftaLDOU7FLwGm43t0VgyonyalelZU7lcbUil/b9iBHUPXst5Wdmt5mZo9izIHve3YTtaeXoO5BOEohaesv2e+mEgLe+rYGEJchcFcnS23kGtMuPFhCTvEyyI6EKTWsRMFdU22zQkA9CGDOSoLfZaWaLV7Alya1aaJE0ZTplwX410lVUcpIRuxGj6pqm33vK6O7pOxd4Ru7xt7N5Q7Wl+uLnx05JLWXZnJ3N9VEQC03Tad9zEbN91g2xr82gVeEnLbAMZ+k5qSnTFVV7C9dwethngtYVD9UDOZC52LiX8j+IBsseQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0QLKe5jbBkVuExRrCxCmWUELSE6zTcBSJiAbPzLfFI4=;
 b=OLVuesRKyz/z/MxlJkQezfYDgXI/bo8PUSbSKnW+XbYmervj3NhYD37etsLq/AlvX+6kC8hmWCKJHVYB09h+hj9h4U4igMSn4BD5Gp6nSgX2Kf9Nip8fa/KlJlXLfI4y8E5i7ZohirAReRWk2r2t/flOTE6LGJQ4r8Ch8zdO+wJghs80h/wEob0yEPJkuFwJX4UYK0J2wxD+tKTX/Nn1cUtz0WlgzU/2wC1ZjBM5ACGIwHsqPFDxDRLWiAZ0mfXcWHXtN3KvgIloo2BipgjLYVbr73vROeasCv64CYkpefFESHpQ5quXpYT30fDARNBtgGgh3oiGux8r55v091p+Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0QLKe5jbBkVuExRrCxCmWUELSE6zTcBSJiAbPzLfFI4=;
 b=bzu4+7FN4Bc4mat4JMTK9boI7qni+BHRhen/ria/ZvntjceH8K816naQJyBxTLjrslsn8e3ePmQYs++YTIq5dPYL7w73wxp2GipnHuX9jRf5/wBSuKWPLVOTZdcdtuz6ihcdkVzF+HSfGANftHEqNPGiMy9Tmn1r28X718ddhc8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5386.namprd10.prod.outlook.com (2603:10b6:610:dd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Fri, 12 Aug 2022 01:00:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Fri, 12 Aug 2022
 01:00:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 03/10] scsi: uas: Drop DID_TARGET_FAILURE use
Date:   Thu, 11 Aug 2022 20:00:20 -0500
Message-Id: <20220812010027.8251-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220812010027.8251-1-michael.christie@oracle.com>
References: <20220812010027.8251-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0351.namprd03.prod.outlook.com
 (2603:10b6:610:11a::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01b31674-f0fd-4872-cce1-08da7bfe0f80
X-MS-TrafficTypeDiagnostic: CH0PR10MB5386:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YCxLWJ/Lcbi4DSXjXUF17JApacrGUubzLmr+PNBxWRhL6dyCVYubqXQTEbWxudCSfP95sHyeQL9beX5EqItcfk7bM7EEVxxUdOd8/A19/2GnNzFE6PdU1/tCOP8EeDdTgYzamyfrB7x2FoDAuyCQnq2aETi3QGFk6szBVICucv+URrGabrpSeDkOHAhdu9rCtEPo99r35Btg4UMyEyS27tWhF44VoYGwuUdGfAnY4oVNj3VDS+9yf+Wh7G7EFo6U4v+aztN6VF3w2XxaHQ8N107Jb/CMG7ta67bNa5GWZ80dFH/AcavIOYBZVAlGytig54DW8ybZfKCeYpCd33dfXqRvSOgwyaDz/jd1yLP4lzvICVCJMiHd7RwxmxqExefU8edqozpcTa+C7jhe7aFuc9szBZ9ttz2kpI7or+6uozzGQCck2/fzWbd8Loe7l7sRCUAKV7x83JSw2wKdU4e1EC5qxirjm1zrozuWtRk0BEla0LmmdGEK/y8FOr0gVVP1fO+kzc2P3NqcR4kxB8Seq1AqKBvV7DcERVzfeTs1BwkQd6I+N0s0HBpmu0JFJCNYfESPx1N2gsHKEfaMcJOYqTwaYDEztBJ4/PH28sDHH8EO8UNGMeutsOd5UCBVvBcMr4albTriBZtA2XYvrMtTLuXUUm/lh1PrCtArwnkokCvlt5B39chKgAstNdB2UQJ4M5FtpEqhs/uZZirAPlRUR9OX3J7rmzWd2GFsOvPZaXaxpEZZMw1gPJmcMwR1HISB0fpajsg4XculoaSftEVtII7iw9W0k6Reccfhbx+BnzY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(396003)(366004)(921005)(2906002)(38100700002)(83380400001)(316002)(4326008)(8936002)(8676002)(1076003)(66556008)(6512007)(7416002)(107886003)(186003)(6486002)(2616005)(478600001)(41300700001)(86362001)(6506007)(36756003)(6666004)(66946007)(26005)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gO3AXEnEaJEzC4d66lTvu1RjGFX3+A0DSzWrj8EU7snguGe9rSqN65fozvEM?=
 =?us-ascii?Q?TAjerQQ9u3tW/3q14+LXKu5bUf12b6koQGNgswlRwCR+9ADkimE1/UoQSbXa?=
 =?us-ascii?Q?fqcoDOUcOoMhuKXeG9soRsJ05qZDlM8/79flNlKJ0b0ahK8T7sERDdVWNOJm?=
 =?us-ascii?Q?203zBz8pE6ECMRQ0/+xGcId5+uOGAjFYBt6pxD1euiouOB89R4fVfebHkRMb?=
 =?us-ascii?Q?V+EsvOF4gBYKhfHxbGE752DUMzcv9221Tc/mtSla9j+q8XpsHAA+LZmc3APA?=
 =?us-ascii?Q?SqgHD+5FmuXzFBowx9b2X+S+dqEAes0gswbVLla4VL0VSOQ9nbZYnisebgCO?=
 =?us-ascii?Q?s/xnndgkbLUUtMM0syOrFEV2aIe6H2v7MWZw8xEQiCBZ0EN2tQL62zOBjeg2?=
 =?us-ascii?Q?5Bxkx9qsQXzvk5hb0qPlOo8KuU//F0NDHhzYshjMR7Q2OULgz8uyA/6CTqlZ?=
 =?us-ascii?Q?i+cqBFPpcsvcxQZIJfRRYyrTBsaX33TeBcHK1UnCRIPoMc2kneBJuhWhf3Fv?=
 =?us-ascii?Q?0+t1dp8/VUhEkJWm+QjL/EKpoKwCMyyrt4+88OHHzCVO3jyfA8e0xP/nNiRg?=
 =?us-ascii?Q?TF7uAe7iXXglXtzpUYk6pxac46fqqelMNkdmYOs+RewHfist3WlU9QhnXVgu?=
 =?us-ascii?Q?d1Mby2Y86nXz3iJHPZJTJRqAGMPEAMrVg/X8WbNkVXO1zetrZ3acP+anywPr?=
 =?us-ascii?Q?bjC4wA3QlC/H+8X7q37UJwqbkEA2TDCv64jmY0D5hUzzv0aNp5BTvyzXtyxD?=
 =?us-ascii?Q?uZLnTSXJMPF1I1fVKWOT0qPnj5omRxRAwqMKj/U3wFyk881gZz+yljNPxwbb?=
 =?us-ascii?Q?wnM5gyAY8zWe6rHM2kJN00d7dHx4Vm9CyQ8gjJwH6ncg4ze49PwyYRRtko1u?=
 =?us-ascii?Q?gxHLmgTfuU9rozcADE5Mp1iy6Z0L20x2ft3g1mHe5rvcY1924lKj+BcHuLJ+?=
 =?us-ascii?Q?AMreZKcpYhe/9nn2J2quKBeyALdMp36imDMQVauRgKKEFzwpGLHXh3lQUIs8?=
 =?us-ascii?Q?7xB4D/vjmd9BSc8aLpq7YXznznGEmxqs4dSzRdXz0pdmpmrDwd1MXpoo6CmK?=
 =?us-ascii?Q?jT6VCFHh3kq6PY8RO1eIOWbt7efn2nDmHRpHH7qECUBhKKQDayymrKtSqb08?=
 =?us-ascii?Q?grf19yaCzZ94o8hD+BKIBQAnLzwJ8d5TS57njVaKi48ZhC1OxyAsyQfKmr4C?=
 =?us-ascii?Q?h5QiYkEqLKsGsPDcRuZ+ptYFVD8uA7V+Ua/YP6eU4DNr/gEJtT+00onlqIHy?=
 =?us-ascii?Q?xf22pPB63TOyQk8LuWXhHyQWf+bwmj6iM/7gKQEKK/gtQH6ksYBzsrt78eaw?=
 =?us-ascii?Q?PGQ31DbplMgT/4q+g3wcxKg+x1VU55FzlfYzQRAhokIBxHBrh7KZ2h0Tee0r?=
 =?us-ascii?Q?PsTBZWyqaEzdPr8kRaPUlmpImeSru64ozzwx5pxfq6mY+L/mFcdwcnFkekKs?=
 =?us-ascii?Q?SnFUe/3HXrxr5/f2OkYuQGDH26aB7zpFy+2yqxEVApYWV4RmpTfD7JzeMGWe?=
 =?us-ascii?Q?8MmKAa9DadewHoAgYUpRaWRCURUPo9LT0YFT+7ArrF6NSJmrxclQMLkvutFY?=
 =?us-ascii?Q?9pVEuouk5l9X8ZUegq47xnfFIDiSgVA08gTvvYfqeyTPExq5T1JAOzlSb86X?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01b31674-f0fd-4872-cce1-08da7bfe0f80
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:00:33.9605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ln0zlFop3z3VjfqUo6sJX9VUQLm6bT6Q1gdYTNlXnkEJUBozQgv7Mt7wVF60j8VFYeGBEHKV8JelVY340Atr54YydjwYHL+QH5JGWZsNqEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_14,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120000
X-Proofpoint-ORIG-GUID: RfQryHBuvTrGh0CkNutdXeuPdlVPvx47
X-Proofpoint-GUID: RfQryHBuvTrGh0CkNutdXeuPdlVPvx47
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
because:

1. It's not propagated upwards, so SG IO/passthrough users will not see an
error and think a command was successful.

2. There is no handling for them in scsi_decide_disposition so it results
in the scsi eh running.

It looks like the driver wanted a hard failure so this swaps it with
DID_BAD_TARGET which gives us that behavior and the error looks like it's
for a case where the target did not support a TMF we wanted to use (maybe
not a bad target but disappointing so close enough).

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/usb/storage/uas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 84dc270f6f73..de3836412bf3 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -283,7 +283,7 @@ static bool uas_evaluate_response_iu(struct response_iu *riu, struct scsi_cmnd *
 		set_host_byte(cmnd, DID_OK);
 		break;
 	case RC_TMF_NOT_SUPPORTED:
-		set_host_byte(cmnd, DID_TARGET_FAILURE);
+		set_host_byte(cmnd, DID_BAD_TARGET);
 		break;
 	default:
 		uas_log_cmd_state(cmnd, "response iu", response_code);
-- 
2.18.2

