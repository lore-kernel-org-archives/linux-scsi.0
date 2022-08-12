Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0754C25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiHLBBQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbiHLBBH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:01:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D85085A9B
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:00:58 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN69SK002833;
        Fri, 12 Aug 2022 01:00:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=iJwwINlI543lcOaATounOylhj+uAB+yZj8+elPRRi5c=;
 b=0fNrJ7Ue9ctTMdbhWqwfi4nZvkXqfU8LmZuFFGEpQG6/qYPzSGdpUH5gx+vXbLvXQvHY
 q8Yy9pA6qwrsc+9j7opalUkoNasaNmFNP7HPC0xNjkfjwu/cR8iDPQMTc7N4rTTKpn4f
 4MDATlSaNYHgmjejOIt0cKeoYqMnxjcBV9RzVAOGk0TyPKf2JUNzvk2J1cnRzE5m+Q6O
 ArAvHQpDsHz0ZQ+Ay5I4etLPtBW5OCux8tQSFhNyCPxe3pAFZlwDhen5IpGwBjk4jklB
 YrqI/6ODV4tf6lBKENVJNC91sXHxL+Hxjpxhl3rnen2r5mqwf7xXWPCwqt9SGTSWcXNq Wg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqdx97j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C019dB019052;
        Fri, 12 Aug 2022 01:00:43 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqkmy70-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hD2Qg519xI0nXqKx6s1S7lm5kehip7efnIQd6RMV8xQQ5OWZH7Lu5ixVmtHPyWo5uf7TTyrMny7Y+3TOCmo/gxPW4HDvkpdQ1yHO21h2Ssw+s2uvyE/OKhEmzeMx2w4cfnzY+HcXz+2y57bcWjwDnmVRiSkoCdMzBuE7OYaK58j7OCbIW7U7CMujpvjDHO+yIx+2HjCsaVK3TUzdFVLv09813ZEj95knxj7tahgUhpMOmXsjOIJG7v9M9kg+pCV4cW88TqMCfJQq7SIs449zaCdYqd4U2Oxs03XoM6DWjVSkZrSD3mLyv3vrj14Dsf60tX8ZDcnOSmeSahYyrz6yew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJwwINlI543lcOaATounOylhj+uAB+yZj8+elPRRi5c=;
 b=dUo5LOfNR7ckFVL8cTewiYhnBz6C9M1NV4DRsmFdlTRUwjjh7vgZPedSywBFO9idhRW2v7thToCtov/ytARXU4lJ/gf86CawNCcH8AhY0TbQkxHjtvh/M2DXZ8Ivo0uxDTlklQf6u2ds3yCj+MpYd7DKXj7Z3RABpKbONJssbJbjmyouJTXFxSjeQy6yE3eT/aumWf4LCqHF0fLh80OQKQDmycf13lHsIU+KgOe+ufsqfYaNkv+6oK8xzrp1YirzmqqwUjNPWavCQwykaiOoeFQWCPK8r47cHR3sK+GS//24RgJrc8+eUkEfrM1ks0ShY0ZjADXp8HsHvjBu4E9GHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJwwINlI543lcOaATounOylhj+uAB+yZj8+elPRRi5c=;
 b=nDU5KTzfWIeGP+KC/8ShuqQIUqyBoztupGCRkjvFmL2dGkU/azgg5dnrUlDM8IHQG+ynwT8E1c1GzNL0MYnj6LaMS96n8z5b6RmKgQ0T5AJVRTxEA7Jzb0SV5/oeHvv3xJkYWrtu8bO+l7XkKHxEecb+NUKlZGYWpy7ME3y+NDY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5386.namprd10.prod.outlook.com (2603:10b6:610:dd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Fri, 12 Aug 2022 01:00:42 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Fri, 12 Aug 2022
 01:00:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 09/10] scsi: Convert scsi_decide_disposition to use SCSIML_STAT
Date:   Thu, 11 Aug 2022 20:00:26 -0500
Message-Id: <20220812010027.8251-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220812010027.8251-1-michael.christie@oracle.com>
References: <20220812010027.8251-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0030.namprd10.prod.outlook.com
 (2603:10b6:610:4c::40) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf81b392-6763-4ee9-0567-08da7bfe1443
X-MS-TrafficTypeDiagnostic: CH0PR10MB5386:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8IfRzSen5kTl8ubVUsG5esReQIrGkikhHPtWEDat+rFciNVQDHs+F+hZK1TC7TAF7ZwCZIslkZZQ9qUIQV2zDACw37R3twZKT/x8uk1lUybks1U9KtJheIXqtY/1MAjodop3fyQ2zLaCO+qxSh2UzkK4ayOVCG9yl7/ihR2YzwxvqvienPpCYjlQJO5KfkJ8S9vseEKhY0GW7/yoxVAoJmN8ZaovDsE0c1zdLeT7ez7Y61ivRoF0Wf1a1gXdhNGcag704gy7CerPMs0BiUwGrdl2yqk/P3VMVEVJcSkO3TYQNIcK4r78zR3452cG0AD+QS5V+ot0Lqj5jOUg0JMUXmAuQWHbDHGo9NFhamFnErDgo2htUBgF4OHbbFq2k+0XqWp2nX+nHOmtR60Y6ldzSVeWWWnkks1GZtNnfvcnxelQMPG39+VoLBVcT7jsyittAvAqjH5T4Pq9RUMBnF35buX2aY7NEmhTzEtqP2iHuKRcEFYXyBOtNFn1lFDVWMK1GTr+1C0/Wc+DdwJ30xOMVTDnHzSDINiGzt4caNmiAKNyNJ0+VP3cYG14zE+V5CB4b0vuiKYKJ/yRCJZ3s4raiifggA1Ngh+J8m/g78ECN0EC/OCS47CocF1SZczCwBWWqPsBg0qdSqLWZKtW1fVTeYauRxxYJ+HCvCZFQkZ6BOI0yUN4Asy6Lnv14vwY2EUfjdkV+ETvtAJ5uENxzxqQuFNdXsgQQTnwz+lCcRzV2N75u/pvvbdVxrGcTjPAV32IX3IkivX4UGyoRCHVo67yq+PUMmOMD0dYOLpw/cfDcN0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(396003)(366004)(921005)(2906002)(38100700002)(54906003)(83380400001)(316002)(4326008)(8936002)(8676002)(1076003)(66556008)(6512007)(7416002)(186003)(6486002)(2616005)(478600001)(41300700001)(86362001)(6506007)(36756003)(6666004)(66946007)(26005)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Lwq3LjuTe26/JkO1yJ/7Rp6mx2km7Ew9jxCEZ9QqqQoCtAW6p9e3MWts4To?=
 =?us-ascii?Q?aofyDFo5Y5p/e+DphSNGnMChB1RaD0ic/IqkLQ6Xo7F+PgLLGYdcnZE1iiUo?=
 =?us-ascii?Q?uAF96ZEiBoxTrzLLSh/hUOLC/Zeh/bSr9gXGeqXqGTztrJfCdoYUVDZmvO0b?=
 =?us-ascii?Q?774/mYAacoO6Da6gmLgOLN+xYzZt7fNvF7PABbwOcvVzdq0DrrZiS8y1/RuP?=
 =?us-ascii?Q?/wd9SIc38jYU81bPSaIoL3ppVPbm56PFiE9FwukkSNvyI9FadsXlW6DZpJQw?=
 =?us-ascii?Q?m7Hn5vUICqI01aXpN1/SGgxBpgld8wWaSV5BYMtw+V5w3wsAcRsi381DrhLz?=
 =?us-ascii?Q?YEnuOPyj5Fk+e4731wF3yqvo40fi70Rb4iduKHHSCIqIfqNuoXPhjiNL+apJ?=
 =?us-ascii?Q?uusmOJSW83F7b3p3B5PzyMZwVOTUK3qrOlqyCMghuxrnynZeQiyx+cbymRWM?=
 =?us-ascii?Q?fvclZunRA8PfoKy9NOsIlvgFrU6B3/URPXvMcbiZJuqEK4YNUive+cL/So6B?=
 =?us-ascii?Q?9VeUEPnMC8iuaZzP8uOIBZg3mc4/xTwedJ8CiGjifJr8CB1rPpy+TxPRki3e?=
 =?us-ascii?Q?Q8uMtsXxXAEHqrmdrMWr3SANB55FQGt5hmRcrOiWTo7mMIVnTLFzgFuJFkwK?=
 =?us-ascii?Q?nsBlajwQTx7PJzrPOOr6Wk8IAZ+jMVEYseZALgN7XCfGU4SXqjeRH8VxatxI?=
 =?us-ascii?Q?knsDfByQesuh+/FNvSofvljqkpy63Lhx1PzeOzJPCX1+44217acqg03zABs7?=
 =?us-ascii?Q?BJDpUsBQ146LT/dRn+vR2os2T6uV5Mkwk2/STOvC+tH07SMP3TWEIf+nTkC6?=
 =?us-ascii?Q?nhtPOsnTKbsxkNKHpgfWFZ37+lLPJdkq9FCLtWkhH5c4VXzU/eCrmElAjLDL?=
 =?us-ascii?Q?pey0CEz7xOGJgS6ykZRNT6gLzPU/3/yDq8WcBn/SnMQN812aMkJBgpdwS8LU?=
 =?us-ascii?Q?Izu3pwN9rt9GFcNohrQgOS2ZhKpzYambAb5+fD0T2wcsm00c4e9X5DGsCAh7?=
 =?us-ascii?Q?nNvGmpYb7OofQZpqGiNwBcJZ6ADXkAMt8Kl8dJxFseOzxTkwHB4+zmnoEZQR?=
 =?us-ascii?Q?wSexuOT0Y5gIppt98tZftlVqaAVh+0CDberPZPGd8ISvreRyUZQHvF8S8uVN?=
 =?us-ascii?Q?mj7YnGIGvhV1yvdajMtSCkTN7ujjIAOQrMA0sOQza1W+dzfv0CMPrSydk936?=
 =?us-ascii?Q?FFVioVit3V8BeknIMSaEl1ijMaCFlm3lU6FFXQdHG/10UJHgqd3D1XH/71Uo?=
 =?us-ascii?Q?cg0WxveG21rVj+SYwqfdw3sD5WaZYA4pfOw/40UYYu4G0/J9hPbvONosrUJO?=
 =?us-ascii?Q?S/THy5IsKkkMhWzCSswO3HwKKziOpxNHnRYe8w8+ahiRmFUqYJ+x/CGKXI7D?=
 =?us-ascii?Q?IE2g4d8pmQFW73EyKbo1Ld3Lo4SFtI54FC8sPMpyXon5LTypP3auU0WWUt0P?=
 =?us-ascii?Q?pMX5XQeOHSjXTGA4Smxn1tbrLm4RgU235ST+HrHOiB+19N7wH6q75ytgN164?=
 =?us-ascii?Q?v08di9t0Kp3NCzckeXttHvSTRVa3AYbAsB0M9ximpockM1zb5irlaNUAvPpX?=
 =?us-ascii?Q?ZIxrjUlEiFZgb/PxaNDKqwrzrQNkugPvmnw4/mq+C0Fz2INSZtU9oqmNCioJ?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf81b392-6763-4ee9-0567-08da7bfe1443
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:00:41.9286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjLZQ0KavBekninoMrLTrMfY/x08Lnlp3W83D/gxzLl8/JsYZL4GCk2NEVoMs6WfTRYwDaEEBmKDwxDxJwK/P1pixGkub2DFJoB8uOHFdsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_14,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120000
X-Proofpoint-GUID: aUveQDlDS_st1zd_gRcewRISjVIeWJrN
X-Proofpoint-ORIG-GUID: aUveQDlDS_st1zd_gRcewRISjVIeWJrN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Don't use:

DID_TARGET_FAILURE
DID_NEXUS_FAILURE
DID_ALLOC_FAILURE
DID_MEDIUM_ERROR

Instead use the scsi-ml internal values.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 12 ++++++------
 drivers/scsi/scsi_lib.c   | 24 +++++-------------------
 2 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d09b9ba1518c..b5fa2aad05f9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -649,7 +649,7 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 	case DATA_PROTECT:
 		if (sshdr.asc == 0x27 && sshdr.ascq == 0x07) {
 			/* Thin provisioning hard threshold reached */
-			set_host_byte(scmd, DID_ALLOC_FAILURE);
+			set_scsi_ml_byte(scmd, SCSIML_STAT_NOSPC);
 			return SUCCESS;
 		}
 		fallthrough;
@@ -657,14 +657,14 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 	case VOLUME_OVERFLOW:
 	case MISCOMPARE:
 	case BLANK_CHECK:
-		set_host_byte(scmd, DID_TARGET_FAILURE);
+		set_scsi_ml_byte(scmd, SCSIML_STAT_TGT_FAILURE);
 		return SUCCESS;
 
 	case MEDIUM_ERROR:
 		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
 		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
 		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
-			set_host_byte(scmd, DID_MEDIUM_ERROR);
+			set_scsi_ml_byte(scmd, SCSIML_STAT_MED_ERROR);
 			return SUCCESS;
 		}
 		return NEEDS_RETRY;
@@ -673,7 +673,7 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		if (scmd->device->retry_hwerror)
 			return ADD_TO_MLQUEUE;
 		else
-			set_host_byte(scmd, DID_TARGET_FAILURE);
+			set_scsi_ml_byte(scmd, SCSIML_STAT_TGT_FAILURE);
 		fallthrough;
 
 	case ILLEGAL_REQUEST:
@@ -683,7 +683,7 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 		    sshdr.asc == 0x24 || /* Invalid field in cdb */
 		    sshdr.asc == 0x26 || /* Parameter value invalid */
 		    sshdr.asc == 0x27) { /* Write protected */
-			set_host_byte(scmd, DID_TARGET_FAILURE);
+			set_scsi_ml_byte(scmd, SCSIML_STAT_TGT_FAILURE);
 		}
 		return SUCCESS;
 
@@ -1988,7 +1988,7 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 	case SAM_STAT_RESERVATION_CONFLICT:
 		sdev_printk(KERN_INFO, scmd->device,
 			    "reservation conflict\n");
-		set_host_byte(scmd, DID_NEXUS_FAILURE);
+		set_scsi_ml_byte(scmd, SCSIML_STAT_RESV_CONFLICT);
 		return SUCCESS; /* causes immediate i/o error */
 	}
 	return FAILED;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 92b8c050697e..473d9403f0c1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -583,13 +583,11 @@ static inline u8 get_scsi_ml_byte(int result)
 
 /**
  * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
- * @cmd:	SCSI command
  * @result:	scsi error code
  *
- * Translate a SCSI result code into a blk_status_t value. May reset the host
- * byte of @cmd->result.
+ * Translate a SCSI result code into a blk_status_t value.
  */
-static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
+static blk_status_t scsi_result_to_blk_status(int result)
 {
 	/*
 	 * Check the scsi-ml byte first in case we converted a host or status
@@ -616,18 +614,6 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 	case DID_TRANSPORT_FAILFAST:
 	case DID_TRANSPORT_MARGINAL:
 		return BLK_STS_TRANSPORT;
-	case DID_TARGET_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_TARGET;
-	case DID_NEXUS_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_NEXUS;
-	case DID_ALLOC_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_NOSPC;
-	case DID_MEDIUM_ERROR:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_MEDIUM;
 	default:
 		return BLK_STS_IOERR;
 	}
@@ -715,7 +701,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 	if (sense_valid)
 		sense_current = !scsi_sense_is_deferred(&sshdr);
 
-	blk_stat = scsi_result_to_blk_status(cmd, result);
+	blk_stat = scsi_result_to_blk_status(result);
 
 	if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
@@ -893,14 +879,14 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 					     SCSI_SENSE_BUFFERSIZE);
 		}
 		if (sense_current)
-			*blk_statp = scsi_result_to_blk_status(cmd, result);
+			*blk_statp = scsi_result_to_blk_status(result);
 	} else if (blk_rq_bytes(req) == 0 && sense_current) {
 		/*
 		 * Flush commands do not transfers any data, and thus cannot use
 		 * good_bytes != blk_rq_bytes(req) as the signal for an error.
 		 * This sets *blk_statp explicitly for the problem case.
 		 */
-		*blk_statp = scsi_result_to_blk_status(cmd, result);
+		*blk_statp = scsi_result_to_blk_status(result);
 	}
 	/*
 	 * Recovered errors need reporting, but they're always treated as
-- 
2.18.2

