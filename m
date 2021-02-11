Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32B3C4332B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FF3A64E05
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhBKMbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:31:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbhBKM2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:28:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCPhiV050907;
        Thu, 11 Feb 2021 12:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=drov18IvbxJcf1RpDKUP9FgkY5cU2xGkcthCPJKMhSQ=;
 b=kSIFVzBLjge2XWxng/8T/cXdXwnuhDdYWmP2EIlKPCJ2MfEog3hww2x9LKtsfppQqDZR
 XGe6x8UxOkHGJY5zbEP1/VlsrDsWD7hwM5/hTpmWXhK/7dAdWdN5OaKZDlQmQ1rmYEqh
 LjS7WEpGncJe5XDmBk2ixjYNJU9T3c0i9iAtvm43QRzOh47aU2B3KPzu7mq9Ae6+bOQ5
 zDDzuv59azBRDwpylV7VVBQEESKvmO63x6OadET0XzOjM27QD2LsN5CB1QeKskZ1MJcY
 8kdGqomeTcwjOo0e43Zg+xChK1MA1mqgyF7rVPx3y4RxgoDOFek/fIcSM1H59M96I/kN Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36m4upws49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCP6Df052161;
        Thu, 11 Feb 2021 12:27:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3030.oracle.com with ESMTP id 36j51yxtuj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyxOMA4oUUr3dPOPXmYD0c5lp+Oh8oA/mWWVQjbSNTHZmQ+hNasp0G8rv/sQE8Qju4uwWu8hoNMBALEj+q3OAjprOmOnMrx/tITgpi8/152wj13YgaXgSvRgSBt1k6BY5+eXRKinyL5j3uXbjkmZXGMvGCNEPknTdXFnpbLG2tohmbcFfNBD1eBD/8rGXV66HEMPnKvZnMaffa2Kxm2bw4QyunoSvcg78hewR9P65lxrfEWwtJEDc4f2JSDIFeVQobQZf+c+bbViVudSsD8TWFLOt4RPB0RXJAAzHN5noKi6IjGliRMst/qeV0MDX3Rwy0zBG+VQzDsozxB5BnUNmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drov18IvbxJcf1RpDKUP9FgkY5cU2xGkcthCPJKMhSQ=;
 b=hfBeT62/Xk+F38X68llZdPUpSsZ0/F7PimYFL0pM5R1CHfeqpbeUFAlvvxSECPj8R0hUO2lmAgd2bAfYr5Ed2QF+hlsQDWyk4VJvrkbAFCes8i67Dj+8/EcOcof4V0eKoK7x7PiTatrt87QdqhV2iSJ6ZMbNeKv/dRmYUsJS+Hx4GSpajpeLt2k1Y9XWve31ODm6LY54FkOfmaB4nKEoiPgwoR0WUClUkqZ/yo47OPiep5f70Ez+LLIcxfGHEuuS1s5k+yoTSLvs5HzYRc3ubuXiSeW/YL4SO0KOa4XDLWDWzvj8qp3DqjN0+FYyMOs34DLS99TiZF+O+kAJ/ElOig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drov18IvbxJcf1RpDKUP9FgkY5cU2xGkcthCPJKMhSQ=;
 b=XzY0Kjewi0Yg06c3uZ9u+r6nANfHDKp9uL1/QX9LEqasATpDOSrQ9rvAVqD5dXGMOJ7b0zI9PcKwG2XSwD1EJU3TomE2LNaotcw7hH3l1PzGxfY9R7Zz5jvjyMoZ6uckvVc+dH5lFZdvX0DL3QW5Rmx506g5zuCSkNiqvReu8mY=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:39 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:39 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/14] target: move t_task_cdb initialization
Date:   Thu, 11 Feb 2021 06:27:15 -0600
Message-Id: <20210211122728.31721-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211122728.31721-1-michael.christie@oracle.com>
References: <20210211122728.31721-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:610:77::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19032911-8b5c-4928-5d62-08d8ce886b96
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB433980D17F5BEDB2B25C02F0F18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rqrLxRx3oo/XJwtxQKE3H8uPCs/0oBCpRWHV4ooIJb8a1WyEjCBbP9n5Aqwoyhwr8+fx4AdOTdwlZuJGMfWyvR88A8A2SfKtbOlnJ4tn7eQyVDiBZxoXTeNMp8qh/CnjK931d0yiJK9zBbzQqZKmMoZNRfydcoHWse0v9HWJwGwQRrX2e8gdIpRUKhd6qzG8i+jhEaN560Sx0iezl9wBVV9BFv7/NbgbLySVpL8Ry6d6wvh7WeARiu8jG+uUmM8aWYFG0QTPfjtpcEUSnunMmkxIANQZei7vO7apu39mhduBX9s8OAreUexXFp8p4imfP6+gutpgOR4CcmNSliGuSE8PBR3rkFIuDMDJDNujztUFp/XWsP+jJZyJai93bK8DbKj9RGpBShNmrG80tVGs/Gpb10HWXbM5OesGg+oVevGgI+aY+UwoiQN+q2gGR5Gsw0umIoAKwCulpLdLh5dVdfrApfg8njRKCMbpMSTQ2Ws72LLypz/ICRJ461tLNXSM6/+QnO2XFgv2ja+g2tP2+/1FhWYc0Uy3GstcOItiw7HBSfCIigtnJ1vMPQ5Vq7a42zunhIMqF7RwkJFtY8tzeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(107886003)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MmD77CMZo0EJ1yFdZcDxBj2JuvvChCWxW3Aadz2KLQgqEaw8fFuBcDS3Ne54?=
 =?us-ascii?Q?hy7oBsi51g2x6+QuKq9bGNzJKmPXcqtmchm2CR4sgCM9YgFfsd+kHQXNoFwR?=
 =?us-ascii?Q?DynU2MeAJaD1lnUw5ly4JMTj8+Gv8/zm9jDG0Yo/xtTyX+yiSvPy4eb31nNg?=
 =?us-ascii?Q?ygc6WfyHwQMr3y8/cb5uWkbZ7aIIkoJZvi3ngcwlmpmDxAAiz+hvoFN4rgpp?=
 =?us-ascii?Q?AwfXWcQTcw+pElyO4cJkEWBRpSVtNizdM82hOSvNXTvTa64oqrGLvufWR+Yq?=
 =?us-ascii?Q?OjsVamEz9qIGWOCrkglKvrFc+dah7O4S9RNROKmfIbC1gIHouuMkEahspWmO?=
 =?us-ascii?Q?ijiz+Z/qIWpPPYYaiKW8iKIRX/5jW/51kcjFPbUY219GPZjjXd68gCuAJvmv?=
 =?us-ascii?Q?SWXonPcSxcHrdZl9XDXW14zI1vPyVmadfE4LrjR1rKx/T2F6KTkXeAZ3ysZL?=
 =?us-ascii?Q?pE0GZi47AbhIPPh9tnZ8c5ZUeMUuNTUvZX7SEeRArZxuKUJCd9hkoJB+/lD5?=
 =?us-ascii?Q?i0bpnMdxN6Fvh7iS7qyJKgt+MuMRNWb4JJKWmpmbQgK50r/2wgwKL9JVLawa?=
 =?us-ascii?Q?SFyVgjLakDT+x/qAlyAvoWPt90Lgpa31y69+oTXIzEUSzoqyrqeWkLMYiq8Q?=
 =?us-ascii?Q?6n60HuoN4+s7Tm0Kg8XkSTHlVol91kXp6UQDDLIlc0XihSQzIHDtdwPYqq94?=
 =?us-ascii?Q?cnI/9N+ngeQXh1qsa3LXQikpAd1TWMOHUTjHhfqeoMASzjLqYvybSlg5U6Gc?=
 =?us-ascii?Q?GXCSBs9DQbmEHenWd4gSt/uB//bKjcU1usgzKkO1DJSn8Qx8xuHnRKWq509i?=
 =?us-ascii?Q?IgTygsZkqBiOcA8BmytgqG45nx9QgS8wbXtzdN6j8MnMJQdhWHImGxCWS1UO?=
 =?us-ascii?Q?e2l9/F6eoFTXP3EMHPK77RSg23JoO4m/SHnt1O1/t3xnHRG8ouxVzCcWak5b?=
 =?us-ascii?Q?kWU8gfdkI+ex18KZZtouQ0PT9b2KDbLOW0iU5F4jeIA/j6efBQbu564v1eEJ?=
 =?us-ascii?Q?vbaezpfwQNTMdrRvattEcszQndKkwRya1OUySH8MTw72XNp3r5+N9vLOwkbk?=
 =?us-ascii?Q?Hx/auG1K2kxNQarbKsURyo03JAVWovxGsbfC9UKqoV6WBnx8FlAUWmrBovmp?=
 =?us-ascii?Q?FPBtS7B3wBvqxiqeOvSqVWO8/bUn8tUuAXJ5jmhi4ro4nWd4qci12T07Cq94?=
 =?us-ascii?Q?vwtptdjRTmWbUkuZWV6c8RufqEwht78aBWaxN9QSQdmXMFmUYk+yVEbU3ZpL?=
 =?us-ascii?Q?Yy0An2IDo+K+1AD9ZH+RuvucXLRy2LNC1auGoMAo3gki9UAwZQDom7fIJA/g?=
 =?us-ascii?Q?fZ6wp8Fcp7H2iv1nEX0tC60b?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19032911-8b5c-4928-5d62-08d8ce886b96
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:39.2503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I6bUskpzVB8paz1CPNxRdylqxzupTEGdVhBd/FoBgDvk8+w2IpciWAK3kGZXbznQxSXq1kV6G1Nxcx2TFLrvN70qi7bCimKFuXbxj8sUwaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch splits target_submit_cmd_map_sgls so the initialization
and submission part can be called at different times. If the init part
fails we can reference the t_task_cdb early in some of the logging
and tracing code. This moves it to transport_init_se_cmd so we don't
hit NULL pointer crashes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d47bfd8b0f87..5c4adde96d5e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1389,6 +1389,7 @@ void transport_init_se_cmd(
 	INIT_WORK(&cmd->work, NULL);
 	kref_init(&cmd->cmd_kref);
 
+	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	cmd->se_tfo = tfo;
 	cmd->se_sess = se_sess;
 	cmd->data_length = data_length;
@@ -1430,7 +1431,6 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
 	sense_reason_t ret;
 
-	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
-- 
2.25.1

