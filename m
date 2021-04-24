Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627E9C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E3F61249
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhDXWS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:18:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57176 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhDXWSz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:18:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMGiHW140107;
        Sat, 24 Apr 2021 22:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=6DetpekqDgJCi3ymH6Ng8P28WB6UpVg2PM8ajAWGOBI=;
 b=t5KFh5T4ZIOHLjS7++WA+yGgZTNuBNwbklAto2OoGCB3TVyFkvX3tHoanQNTA2SvAfl7
 0X0OnG67SaJvWzQc9u3fofd8wMz4vKP7QAEdJc3zNU0KNzW8cQViGsJwYD/XqnoSwi4Y
 LtfiLJyPz4HMxeuTfMYf+KiTTTLADWB6M6fXEBfvY3IoJ0TQ+xaKhTRZ2+fgbpkwH/fU
 hQvfFmeUAZ3JBPsswRFsz4ou2c2IfkNiBbhFY1+/58ePZFVSENtIQLWBNpXLqysmcCHA
 203X8gvLsc93qlkKqs4AVKP9icj570ZiVT/5vm4MmStdwhwe8y9td+J6+VIjEDI6P/LH sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 384b9n0snr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMAPi9148236;
        Sat, 24 Apr 2021 22:18:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 3848et2ejm-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=la1Pt6/c9Sl17qCXK2V7TtL+DWKt/6/mtGIYsL7bMbwfMyU8yov7KxbA1O5bwULeNQrDmYmDg2Jfn4a4GdqwJGyl5P0x1lM3dDMXvSrLrcU33jqS2MH614zR5luAJqU/WUI3UObPKclwN2twBzp4a/yEvumoVcIWE2zaAlRSoaaieY44LVc82tGi/aRJ+gS6Py4y6Vs7hw82ohmVh/qv+/oXywHkEN2vzoRx6YN2t01Y2GdFfP20vM2YmC+dDSF+0trNmkZskI6iEDhYcJsoqKSloU4SUoQrcJBgMgluiVy7+Jwdm1dGdDN1+hqdQF3WDbKHRbuboLcFClweAUwb1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DetpekqDgJCi3ymH6Ng8P28WB6UpVg2PM8ajAWGOBI=;
 b=bxtxSHiMgy6Av1hvTesQPGgcqpsp84WeY28ILdU2FylJZk6Zx41GfUCYBhW501C7nAbADNCNHXu8CEw02TAOYb5jGgzTJo36Hp1v/Ljakgey+/5Kc0anUqnEDyyE2RPkPDhTYBNOMp80fmbNMls8Vl9TNz2sW8a6gzPWxx2Clnc3whcKbcPCvuqXoEdp27Rq9cFBHpA7VoYrZbHyfxk2m1GQs5eZYwefNhtM4/IWigfj4XvyU/cbwBtfGPp2w4/G33HQKolqKIxzbk2iyEDhRi3bQHoxPclAoYDVrUI4m8wSMc9OLPmGNF6o/rs+KnGVcDe7PztD/Al78MqQPCaTCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DetpekqDgJCi3ymH6Ng8P28WB6UpVg2PM8ajAWGOBI=;
 b=GfCr/WAsKvTRpX9ANHLhSQ7uWzBxUpxNyLA+Ctj/EbiHJsDx3rIj27UQAjWn0s8ZjolC9d3pCMh6T37pB4bQAqcj/AY3RbCKot7s3pHKOY2zXEQ3CIRR8p+Ia23hxn/StCBmwssNoeXndk1FiAeuhHsV6jrTX5MT/rlnwuGSjR0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2885.namprd10.prod.outlook.com (2603:10b6:a03:82::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:18:06 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:18:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 3/6] scsi: iscsi: have callers do the put on iscsi_lookup_endpoint
Date:   Sat, 24 Apr 2021 17:17:52 -0500
Message-Id: <20210424221755.124438-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424221755.124438-1-michael.christie@oracle.com>
References: <20210424221755.124438-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM3PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:0:57::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM3PR12CA0079.namprd12.prod.outlook.com (2603:10b6:0:57::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Sat, 24 Apr 2021 22:18:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e2e6fcf-0f00-4fae-5f9d-08d9076ed584
X-MS-TrafficTypeDiagnostic: BYAPR10MB2885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2885075A7728ABFDE011560AF1449@BYAPR10MB2885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LVmhcHMeIrAmynzwnVMSjI13cTe7fst19yP/KArSE29T30++76eDMZvAeGr93c85avRnpsorF/I7BIZWYdAMn3Qdjp2+g+Aig0BEOLtUU1CqQMrIjG4W38xUKgaWeSI3s9mS0Dk5NJ4DAAyKQPslt5C2f8U41jqkYlQ1eMLQ5Z/vf7khQVKZyeIagIgCurfsHOU/iGEXW5iDQ78fACF9cYx87twOFkP7nAIJDxOd6bI9E2sgpOd6uDpd2U1sPM/v1JfKJdahPLmiH17RzIAoEh8A8EML6HREhCYaJTYp3MHDLj/TeXPN5TEm4EpfRQeAgEXBH2buhfAYcNYPigmM7XqIWFsoulWRp2JNrYwrx1UA4HVFKHG8+XdjpRElUPMQ1JZMEFrxxGYCDtgr6nM6mvKqiOUyUxyWuFxZ46VSrWA/VOf/xu0J55lkEO8s9XDcVugEeQC99GiDjEi8rkyhrDtpWp0s2Ht3eclz9OfSkhEsZAgz79d3Wwr/BGMXSlzzGLizR7mbYySGu9JkMM9S/ZxWqxbWrn1tXH4bKEDKifhiVRRIykhtM/hF78yDnVCmVFjov4dwv6oB1kszANJ3Ar1oXQwpADbDRyqk4Zbm6zMFiqWv4lI7MQWFSfqpc3Y2FY/FpWniELsvdww494DGRe29TC02b+IwHQFaiZVjvf4DbahiFGv/JOZjYR6TyXL2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(396003)(366004)(83380400001)(6486002)(66946007)(66556008)(5660300002)(66476007)(38100700002)(6666004)(4326008)(6506007)(478600001)(6512007)(107886003)(2616005)(186003)(316002)(36756003)(52116002)(26005)(86362001)(2906002)(1076003)(956004)(8936002)(8676002)(16526019)(38350700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?b/X9Q0LpY7/mdvuHqe/CPUm0ebFFKf6JR1Eg6m9ViOSbXuxRYmomm9zEnTVC?=
 =?us-ascii?Q?VOQYU6hep1kj78bDLV6CTE1F9XAFrsI2l8HCzFFqVCsE6mopihHcNnwTIb3F?=
 =?us-ascii?Q?yzFc+Fjo5P/BVRO/ZAf2okQywI8ajMWuj/QKfPjB3ub2uuBDhlcUDm5Z7Esf?=
 =?us-ascii?Q?7W4b9Fb4OYU0F4NGSBWMHV/Yrzh+hsWKGLJNl6DoYK9dWbR+2wDgkuuMrPIn?=
 =?us-ascii?Q?FqHubQSDj74CXEO5ItTKTFBVqN4qEaeCOqDHRv529/G8QwsF74jVOV2alZtx?=
 =?us-ascii?Q?1meN47dTII2mSByWRZ2mAWEtcCK3RJ2HET66Yuw3EzOY0OQbaXhcwvMCe85g?=
 =?us-ascii?Q?sSTrGrXLJT/9YwAhevMI7sJAEeqoqfuOqDC/VwzU+qJ/ZNxL9o7MXykAa5Ag?=
 =?us-ascii?Q?QCLSOIYtgxJWyxwtFEWDwfoLhj/KcLzSiHjpJuwiQKeqf0DDViShWRE/sUcX?=
 =?us-ascii?Q?Vi3hSwY8/JtWhJMETA4DyE7E3LdDwjcsqG0+yuDUyPySMugzyxjtJXoijyoV?=
 =?us-ascii?Q?fLEwnoqxxCwyozDuVTLS7L8heD3Q07Whs8VXw8HjTIYjOrF+oLroP+UM1c+/?=
 =?us-ascii?Q?EZYwqCIcercCSRfTEhLdAqXdQroKsUGih7G5i3YoIHKe5xy4LJjTusw//Wij?=
 =?us-ascii?Q?IiU2+fdPGFvok9OIuN0DQw8E9R+VDoJf4qJ5N7UHK90S4Gvj/lu9VB9hmrMY?=
 =?us-ascii?Q?m1Jo31ZhIPUkGoLvPAroF7Mq2sGRIuKA4x7WxVLdN8mzhBrSMpjfoJ7vIXkN?=
 =?us-ascii?Q?IIK9CbeC7XVZ5riPEt6Yj6hQoBGYYClcJXzWauFeGLeXTQva90xI27P3znBD?=
 =?us-ascii?Q?fw32a+H8Ix1KTaE8k9vhVLbdILnHTVz8C9ko4RJt7c0xbSbcWWKRaaxNv40k?=
 =?us-ascii?Q?2SKoJnCOWK38kYOhko+VX3Y/el8y6ZKpCgZWU7TIeP6LUuTVZDADhd1XEpfx?=
 =?us-ascii?Q?JaIBElRjf8o5SHN/ASah8JvBYp7A/4lRStp4m9BiIMC0SC53bBXHbLoAN3i8?=
 =?us-ascii?Q?AO+5PzCFX4E4aKh1ROuoiJjYxWbV3oh1h5i2ymXVzJw4Oe0FILoL9zV0EWWJ?=
 =?us-ascii?Q?/wmgELV9gq1GZxIPqbyd3JFPSPR+4+ExOpMxNzlLDbUlaYQ5TXYe0/+f236E?=
 =?us-ascii?Q?d/jq0tiaQxB/RgXi2v1ErhwxCuDwF+kH3gdXpVYZ7VoUv2c1+7ZpmwSvFCa5?=
 =?us-ascii?Q?PiA7tHJrrOaBEQ7lzCW4X9Q+fwFpDDeQxGfkv3FMy6jxOO4w0OJ3zfgg3Uw4?=
 =?us-ascii?Q?Rjruk2N9NBg8XFrniyt4YokVyoPH+q8s0MT9oSRji8wTHsKnM+Gi8e+0niFc?=
 =?us-ascii?Q?ViENwb5BDWxIWqGdxjE1P6pS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e2e6fcf-0f00-4fae-5f9d-08d9076ed584
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:18:06.1344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wpk+KFXiSNxjlirjQjI9Jtbd5Z4+6VkPdNqoic76ZNZVkrhigvVCLfkKHljA5ReVgA6AgHsAb/l5siMT2HOVJXnRy6jKlRoi+GVN/m/KoAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2885
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240169
X-Proofpoint-ORIG-GUID: 2J6vEPKikjaWd9sd9k84iifEVb-579VZ
X-Proofpoint-GUID: 2J6vEPKikjaWd9sd9k84iifEVb-579VZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240169
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches allow the kernel to do ep_disconnect. In that case we
will have to get a proper refcount on the ep so one thread does not
delete it from under another.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
 drivers/scsi/be2iscsi/be_iscsi.c         | 19 ++++++++++++------
 drivers/scsi/bnx2i/bnx2i_iscsi.c         | 23 +++++++++++++++-------
 drivers/scsi/cxgbi/libcxgbi.c            | 12 ++++++++----
 drivers/scsi/qedi/qedi_iscsi.c           | 25 +++++++++++++++++-------
 drivers/scsi/qla4xxx/ql4_os.c            |  1 +
 drivers/scsi/scsi_transport_iscsi.c      | 25 ++++++++++++++++--------
 include/scsi/scsi_transport_iscsi.h      |  1 +
 8 files changed, 75 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 6baebcb6d14d..776e46ee95da 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -506,6 +506,7 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	iser_conn->iscsi_conn = conn;
 
 out:
+	iscsi_put_endpoint(ep);
 	mutex_unlock(&iser_conn->state_mutex);
 	return error;
 }
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a03d0ebc2312..0990b132d62b 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -182,6 +182,7 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct iscsi_endpoint *ep;
 	uint16_t cri_index;
+	int rc = 0;
 
 	ep = iscsi_lookup_endpoint(transport_fd);
 	if (!ep)
@@ -189,15 +190,17 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 
 	beiscsi_ep = ep->dd_data;
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
 
 	if (beiscsi_ep->phba != phba) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : beiscsi_ep->hba=%p not equal to phba=%p\n",
 			    beiscsi_ep->phba, phba);
-
-		return -EEXIST;
+		rc = -EEXIST;
+		goto put_ep;
 	}
 	cri_index = BE_GET_CRI_FROM_CID(beiscsi_ep->ep_cid);
 	if (phba->conn_table[cri_index]) {
@@ -209,7 +212,8 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 				      beiscsi_ep->ep_cid,
 				      beiscsi_conn,
 				      phba->conn_table[cri_index]);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto put_ep;
 		}
 	}
 
@@ -226,7 +230,10 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		    "BS_%d : cid %d phba->conn_table[%u]=%p\n",
 		    beiscsi_ep->ep_cid, cri_index, beiscsi_conn);
 	phba->conn_table[cri_index] = beiscsi_conn;
-	return 0;
+
+put_ep:
+	iscsi_put_endpoint(ep);
+	return rc;
 }
 
 static int beiscsi_iface_create_ipv4(struct beiscsi_hba *phba)
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 9a4f4776a78a..26cb1c6536ce 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1420,17 +1420,23 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 	 * Forcefully terminate all in progress connection recovery at the
 	 * earliest, either in bind(), send_pdu(LOGIN), or conn_start()
 	 */
-	if (bnx2i_adapter_ready(hba))
-		return -EIO;
+	if (bnx2i_adapter_ready(hba)) {
+		ret_code = -EIO;
+		goto put_ep;
+	}
 
 	bnx2i_ep = ep->dd_data;
 	if ((bnx2i_ep->state == EP_STATE_TCP_FIN_RCVD) ||
-	    (bnx2i_ep->state == EP_STATE_TCP_RST_RCVD))
+	    (bnx2i_ep->state == EP_STATE_TCP_RST_RCVD)) {
 		/* Peer disconnect via' FIN or RST */
-		return -EINVAL;
+		ret_code = -EINVAL;
+		goto put_ep;
+	}
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
+		ret_code = -EINVAL;
+		goto put_ep;
+	}
 
 	if (bnx2i_ep->hba != hba) {
 		/* Error - TCP connection does not belong to this device
@@ -1441,7 +1447,8 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 		iscsi_conn_printk(KERN_ALERT, cls_conn->dd_data,
 				  "belong to hba (%s)\n",
 				  hba->netdev->name);
-		return -EEXIST;
+		ret_code = -EEXIST;
+		goto put_ep;
 	}
 	bnx2i_ep->conn = bnx2i_conn;
 	bnx2i_conn->ep = bnx2i_ep;
@@ -1458,6 +1465,8 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 		bnx2i_put_rq_buf(bnx2i_conn, 0);
 
 	bnx2i_arm_cq_event_coalescing(bnx2i_conn->ep, CNIC_ARM_CQE);
+put_ep:
+	iscsi_put_endpoint(ep);
 	return ret_code;
 }
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 215dd0eb3f48..dbe22a7136f3 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2690,11 +2690,13 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	err = csk->cdev->csk_ddp_setup_pgidx(csk, csk->tid,
 					     ppm->tformat.pgsz_idx_dflt);
 	if (err < 0)
-		return err;
+		goto put_ep;
 
 	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
-	if (err)
-		return -EINVAL;
+	if (err) {
+		err = -EINVAL;
+		goto put_ep;
+	}
 
 	/*  calculate the tag idx bits needed for this conn based on cmds_max */
 	cconn->task_idx_bits = (__ilog2_u32(conn->session->cmds_max - 1)) + 1;
@@ -2715,7 +2717,9 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	/*  init recv engine */
 	iscsi_tcp_hdr_recv_prep(tcp_conn);
 
-	return 0;
+put_ep:
+	iscsi_put_endpoint(ep);
+	return err;
 }
 EXPORT_SYMBOL_GPL(cxgbi_bind_conn);
 
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 25ff2bda077b..bf581ecea897 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -387,6 +387,7 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct qedi_ctx *qedi = iscsi_host_priv(shost);
 	struct qedi_endpoint *qedi_ep;
 	struct iscsi_endpoint *ep;
+	int rc = 0;
 
 	ep = iscsi_lookup_endpoint(transport_fd);
 	if (!ep)
@@ -394,11 +395,16 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 
 	qedi_ep = ep->dd_data;
 	if ((qedi_ep->state == EP_STATE_TCP_FIN_RCVD) ||
-	    (qedi_ep->state == EP_STATE_TCP_RST_RCVD))
-		return -EINVAL;
+	    (qedi_ep->state == EP_STATE_TCP_RST_RCVD)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
+
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
 
 	qedi_ep->conn = qedi_conn;
 	qedi_conn->ep = qedi_ep;
@@ -408,13 +414,18 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 	qedi_conn->cmd_cleanup_req = 0;
 	qedi_conn->cmd_cleanup_cmpl = 0;
 
-	if (qedi_bind_conn_to_iscsi_cid(qedi, qedi_conn))
-		return -EINVAL;
+	if (qedi_bind_conn_to_iscsi_cid(qedi, qedi_conn)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
+
 
 	spin_lock_init(&qedi_conn->tmf_work_lock);
 	INIT_LIST_HEAD(&qedi_conn->tmf_work_list);
 	init_waitqueue_head(&qedi_conn->wait_queue);
-	return 0;
+put_ep:
+	iscsi_put_endpoint(ep);
+	return rc;
 }
 
 static int qedi_iscsi_update_conn(struct qedi_ctx *qedi,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ff663cb330c2..ea128da08537 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3235,6 +3235,7 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
 	qla_conn->qla_ep = ep->dd_data;
+	iscsi_put_endpoint(ep);
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index a23fcf871ffd..a61a4f0fa83a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -266,9 +266,20 @@ void iscsi_destroy_endpoint(struct iscsi_endpoint *ep)
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_endpoint);
 
+void iscsi_put_endpoint(struct iscsi_endpoint *ep)
+{
+	put_device(&ep->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_put_endpoint);
+
+/**
+ * iscsi_lookup_endpoint - get ep from handle
+ * @handle: endpoint handle
+ *
+ * Caller must do a iscsi_put_endpoint.
+ */
 struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 {
-	struct iscsi_endpoint *ep;
 	struct device *dev;
 
 	dev = class_find_device(&iscsi_endpoint_class, NULL, &handle,
@@ -276,13 +287,7 @@ struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 	if (!dev)
 		return NULL;
 
-	ep = iscsi_dev_to_endpoint(dev);
-	/*
-	 * we can drop this now because the interface will prevent
-	 * removals and lookups from racing.
-	 */
-	put_device(dev);
-	return ep;
+	return iscsi_dev_to_endpoint(dev);
 }
 EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
 
@@ -2984,6 +2989,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	}
 
 	transport->ep_disconnect(ep);
+	iscsi_put_endpoint(ep);
 	return 0;
 }
 
@@ -3009,6 +3015,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 
 		ev->r.retcode = transport->ep_poll(ep,
 						   ev->u.ep_poll.timeout_ms);
+		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		rc = iscsi_if_ep_disconnect(transport,
@@ -3692,6 +3699,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 					ev->u.c_bound_session.initial_cmdsn,
 					ev->u.c_bound_session.cmds_max,
 					ev->u.c_bound_session.queue_depth);
+		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
 		session = iscsi_session_lookup(ev->u.d_session.sid);
@@ -3763,6 +3771,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			mutex_lock(&conn->ep_mutex);
 			conn->ep = ep;
 			mutex_unlock(&conn->ep_mutex);
+			iscsi_put_endpoint(ep);
 		} else
 			iscsi_cls_conn_printk(KERN_ERR, conn,
 					      "Could not set ep conn "
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8874016b3c9a..d36a72cf049f 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -442,6 +442,7 @@ extern int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
+extern void iscsi_put_endpoint(struct iscsi_endpoint *ep);
 extern int iscsi_block_scsi_eh(struct scsi_cmnd *cmd);
 extern struct iscsi_iface *iscsi_create_iface(struct Scsi_Host *shost,
 					      struct iscsi_transport *t,
-- 
2.25.1

