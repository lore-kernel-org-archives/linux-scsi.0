Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70756C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FF7A64E05
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhBKMct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:32:49 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40434 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbhBKM2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:28:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCPZTB098702;
        Thu, 11 Feb 2021 12:27:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=LRt2SeFq6N3QyPTXIiad1uZBJzKkg5h1mMnq6YX9grQ=;
 b=OE/s0HmCtdqjWK86kaXeQ21ajWWbdIzTd987kjP7aq8mqQTRgjEJGoreTDnPPdT7wmgf
 RVtTVmW11sfUNlbnvLGu9C1mn5LkR4fsn9TbmQb0n6diyye5tu2Ty2yuNBJv9+HVZSrC
 Rd1xmausHIFmEhPe8pgymY/4BzyuxAQtGxQrBuWwZHSOxKEug3xx+R6DCCpvVhqj/uvH
 yDv0ic5IZRR6cUBviqkFt99K9hyS+sBi+jgIIevDGetORoM2+AkeTn0Y14+L+UK9gZUh
 VBoAZpH8rqbqXgFRys4qiHk0sgeUs76xqi2fLtzbByJNr9R+TGc+EmLlapWhxnvCsXj4 zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36hgmaqby8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCP7iu052222;
        Thu, 11 Feb 2021 12:27:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3030.oracle.com with ESMTP id 36j51yxty7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTT4X+QxZ4CBgfoDNJIfnr1+dzqBDIx8S94HJFkX0LLJGSux+SmgkfVNxpRAKj5TZ1K6NEjX32SIuFjlL/M8mEGOaqfYo+gvB1pw0+zDGqA/KT+9U0hTWESORCt29IuDvtAy0oA4mteWKF5s0EMWUJbvDQsZxkbMkBRkhURhdrGrnPflMx12jisYc3yOYj0MzxBzdcn5arTLw+sdVx0Jq6J00ltmqfGPqaiVoPz3voSMc6l+wYTzb3t5HVnET2xImJwqlF+hNJm5ztgA74WbjqurcfVx3/EsJ9Vuo8++7j3/47wIEjz2JA2xzxLNnNVyUsCLLwROGhMdOtL4IOJGhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRt2SeFq6N3QyPTXIiad1uZBJzKkg5h1mMnq6YX9grQ=;
 b=nPUbOw5OSaSN/gnZDL9pLZ/A4BRSoiN3Fm/BtL6BANXB1NNCSPTawjrXu36EpBqeaFgQpAXeVg/M+acKM3GW4zPdH6iRyZiHLLNFo1PC7FZil5g3Ef5ISOZrZohbd0glQcBrqXiLGRYvVVJJWVW3f9ilzJtmRVYMwtUMcPW4wv9hTgVde7qHeSL5RXmISNnahenN8MjowYYz6Kg06Q0dTvlBWGMTWVWH/g4hYxTJDc2eT2/nt/UBDxYmHezCaLi2zDVAaPQlHGDQg0rTcnqKlgnW8lOVi0mS+ArARcDtS/p5O6Za8DCRiYAhifJvsjRA46AhV6yNgyyluuDH6255yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRt2SeFq6N3QyPTXIiad1uZBJzKkg5h1mMnq6YX9grQ=;
 b=ewL+/G4vMFGO+uIWjxYTIt24a9O7DB7QFuP0jDLHHY76gBKdXfDUhVpBDyVpVZ2asBjQTXw/2Iwcl0eE/Bxew3za+uRn0JdATYmgzF09gIHDuCx6dTh2TTIb96y3jWw6FtZUOzApWqewjtJfOzSMAVx1L74IIU7wQV6ndEDKjg4=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:48 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/14] tcm_loop: Convert to new submission API
Date:   Thu, 11 Feb 2021 06:27:22 -0600
Message-Id: <20210211122728.31721-9-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bca1d3de-03ac-487b-1e83-08d8ce8870f2
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4339EF316877ED8DBAF776CBF18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CAdk+hsOwD/orJ3bkhUfR8kCE+mhwbm6UckFyvs0PKH8b7Eptvib58ThZhNwsnE7LKd7OE9bFYFlrZyOUd4Xy0JRgHV4hUs+F1F1wlXRlkZYmqOTeDhENkccxiIv9DQ1PpSfgE0Sz15w2th568DsCDFkwYrAMWsDfFQmYX26P32FElPmzMC+EATTsJYLGoS59kXMgq6J2gpjUn7OqztLbjq3vvP3V8aOe9yXskv/wPE5EdDm+3Hb9KjomvJhmLNczrovIIJCLkcTINRs1E1gfnOX4UsJ2MJ3PAklM2A9P/TtdiXJrbEKpC1I0N1bHPWCEQzBCzzCqtEJ0uwE52X50p/bKvn+oQ/oW7088Z0b+F3iiwn6kX+R/fM6Y57McCp6X62oqS30fwzfZ8nNIg+fwuKPuiNFtrMZ2CmylXSm3Lzh6E3zpxbkgv3eMYMV/n9qY+lwz7ESa9qIUV+xGE0N4wuGgjEOmRs5dhfZbax+hr2xx0Tu2gpWdpQc/AtzcsCpLs+hGCuEHD6MVAL9wPb+iv0RwPDo2DLpgOGm61DkFMxCG47EYtxG9cjeMMVv181jYa+ZeokGJQKcU3iiDOP/8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(107886003)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HAUNBnD4YzKR1mdiZxJjSOYCjb5xpxDiWn7m8D9tO2ijngfUwsI4iuJQWDhj?=
 =?us-ascii?Q?A6gg6kIDh3hTNXCTYa6N3QeISSZhnicWIMXP+snNl2rvJvTgO+Tc9r5doDHu?=
 =?us-ascii?Q?E27P9SizQa2FcDnZZFCunei3SsUTXUptPb0UnydIy3Jk03InWyV1fkSgvm5l?=
 =?us-ascii?Q?UETAJmGqd0Ll8y9wPWlDqtovaOU657YwkTi3XRDGUL5rjmCuPNdT9JyKtcG1?=
 =?us-ascii?Q?jHNc0eOv4rtaeeYt1tcm8QFY1+nGEawsGECM8/w0dGgl5EbrN5ibN2y0yWxe?=
 =?us-ascii?Q?Ritud7yb0saJwvPWBjofU4PXCqi0e+SX1ba9tvTmCWoXCK/BdWaWuIHC9ln5?=
 =?us-ascii?Q?Hn4vlwslry48Nudoz9IpV/Lr5wLB76Ji6R0kGP0bKAsEilioXZWw+49NXfoX?=
 =?us-ascii?Q?Kq+EADBjwvC2+O/0gVlMFRgfdikeu9IJu63efwQasRMz7ltD5he+h8s4fNhU?=
 =?us-ascii?Q?o/0CM+lUv7tR4Du8MQpn0NMtt4tI1mx5NMXnpdl38/RpDXk8EEyQwgITUJlq?=
 =?us-ascii?Q?ko0JxP2WZsVGzaWrP6WCeAu3QF+KJuR8O7Ypv3E3iCsq6F8Jc6hyl2pbGg0V?=
 =?us-ascii?Q?SVSRek2TtKc7ZtFIFO9Mn4rO0EvtHg5yiex/eg5TsTFLBZUu57dxXSfq26G7?=
 =?us-ascii?Q?qLRsf1t+kDZyT405dNvpTh6nDphoh4tn2io+NCNO/813ZuVQcjKCf0hp03J/?=
 =?us-ascii?Q?ySdHNfEtWe36MlnY9wZIoT0DzgCOspCz6beAMSWb3HH3KvYmYo0FP92d5rEb?=
 =?us-ascii?Q?W7lx4rARzLX7JzkzZ+0Q/DviP1elVHehAdsibL/+cywtYFqzKOBz4lAUXFnT?=
 =?us-ascii?Q?2yTL2XftqL5PdwuKMWz+DsAPSPaxP02P1Ag1EFTxn3FneG0yPQE2brDhmtS0?=
 =?us-ascii?Q?Z5PWPtttgYj5DUiAPO2E7QlrhyRouYdgTobY5VddbnKSbDtgR+Vc0BKTD47c?=
 =?us-ascii?Q?oWiqn4CV0XMIxtq/a1ztW535xfRvUnCIsp6yB8fVKMH3b99iDZ6vwvMIOSz6?=
 =?us-ascii?Q?32e3KokbVKEQ+W4apQOaeBb2VszsOiVCqxCAFfXb1jnUkm5oG4Bv53H9ED5S?=
 =?us-ascii?Q?ASeKPisgnXXA3ap90ZmysaAOtMsTMGf8xsoJEp0+XeFstZQmcFwND45AvDrQ?=
 =?us-ascii?Q?CDimYlug531ODe/CDREEf34F2NvKu0gHa0E6yisEa0yLB9xojAj692X9e1Vy?=
 =?us-ascii?Q?1EdvKlsivkvZ9xp5dAOhX63eRVmV08RhVIWyMKFRlB2onZpmHshVRW31VRXg?=
 =?us-ascii?Q?RZNCQqFYN1LixIwAyAoRhzdp6wvWzFV88pEsu2Z3rkbIy5XRKvAHBXPkdTLW?=
 =?us-ascii?Q?C3HHHczhrC4QdxFWqb99si2q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bca1d3de-03ac-487b-1e83-08d8ce8870f2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:48.1403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r9A28PECfUN9gYsFxDrbUnkYnfARctkXl5brtN3RHis01iwnuUvx+f2tnNIRl8zRazi3erXAk3Xmg+u0+CXxR0S716vQG+QdDX4T5YC840M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd_map_sgls is being removed, so convert loop to
the new submission API.

Even though loop does its own shutdown sync, this has loop use
target_init_cmd/target_submit_prep/target_submit since it
needed to map sgls and in the final patches it will use the
API to use LIO's workqueue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index badba437e5f9..461f4125fcab 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -113,7 +113,6 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	struct tcm_loop_tpg *tl_tpg;
 	struct scatterlist *sgl_bidi = NULL;
 	u32 sgl_bidi_count = 0, transfer_length;
-	int rc;
 
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
@@ -151,17 +150,16 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	}
 
 	se_cmd->tag = tl_cmd->sc_cmd_tag;
-	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
-			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
-			transfer_length, TCM_SIMPLE_TAG,
-			sc->sc_data_direction, 0,
-			scsi_sglist(sc), scsi_sg_count(sc),
-			sgl_bidi, sgl_bidi_count,
-			scsi_prot_sglist(sc), scsi_prot_sg_count(sc));
-	if (rc < 0) {
-		set_host_byte(sc, DID_NO_CONNECT);
-		goto out_done;
-	}
+	target_init_cmd(se_cmd, tl_nexus->se_sess, &tl_cmd->tl_sense_buf[0],
+			tl_cmd->sc->device->lun, transfer_length,
+			TCM_SIMPLE_TAG, sc->sc_data_direction, 0);
+
+	if (target_submit_prep(se_cmd, sc->cmnd, scsi_sglist(sc),
+			       scsi_sg_count(sc), sgl_bidi, sgl_bidi_count,
+			       scsi_prot_sglist(sc), scsi_prot_sg_count(sc)))
+		return;
+
+	target_submit(se_cmd);
 	return;
 
 out_done:
-- 
2.25.1

