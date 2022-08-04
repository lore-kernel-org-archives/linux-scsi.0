Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBEDC00144
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 03:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237667AbiHDDlv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbiHDDlX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 23:41:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186C13FA01
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 20:41:22 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741i841011148;
        Thu, 4 Aug 2022 03:41:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=TjRaEpSfj0LgRSoqfMkL64I7FvrMSt0c7IHdn0Bv5lM=;
 b=atGyyOg7TmN25ZRpCKEVunvg/5ECWzWIsHWF9ttWrNok6A3s8rf5g6rSJEyx7lTB/jcy
 1qytvQc+hp2eLFgBF/2co4Dsmcw/WrAy5HXo80e5qgBz351kE8oMrGXxog5bfOhIXEho
 wyKTsf/ROBjRmW6lmId/e9cnDXCwci/x4BgVOmAPN94cQv7O1rXGTxnwKLTrGsxz4RQ0
 x3FqjPH8Rn1l7emV4I0Qq4bfuYv8KgWshfZ9eWDRdtMljilDFVzwGyf6XeTwPRpfwOWd
 I+2n6/6fiPr6OW5fShRP67JN2hHx+Rp1vOq1SeNM2RPOQHXQfCf367DHuH6S9u7TiLCc /A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmw6tkpwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27434jEP010909;
        Thu, 4 Aug 2022 03:41:13 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33u06w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoUIeRZTpl9XwgSIEZ4+aLqDCaIlLk91CB0MCROCI1mIqKrYtThDlluiyINojSLLIBwtT5I22NnXQeg0GfuVkBYMgN8EJnCGtI1C5o+RAaEq8FY7aofb2CGcPhY5aTwjI/2vSBD+gH2QqYBZrHqA7uXJL9/cGtI+34Z8bRjC/EjKvHa+B8sL3/yH2gx8/DvTG46UvluMiR7lyZ+2LHuJ8ZHCmh9aFHejYjbGhkP+KHi9AzNncp3uxELTvX9SmRlyquHZrzgD/n5Oie6ZX452nifpfYMUJMrukqohKGzHhDiL4Opcsj5xJEw8P2PM8TfSk2U37rA+JbdNV7sCFPusCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TjRaEpSfj0LgRSoqfMkL64I7FvrMSt0c7IHdn0Bv5lM=;
 b=F0+4JsT+hTgHgfn93nCtgz5ei3qC4fsp3flki3SShf2L3mh8+fGaRHqYFuuLwyEs1M4dHsxUEs483v5yPPWi71e0nHHlK9HjntvEb6CI9JZrVL3CyJ1ZqPz7dWJF4Ez1RIK7FzAsgQd5zX/0HkYtXh9BqZX9CD1ZMXtHIWw8Mc9rk1BM6YXZMJpHV3yC9suAxWol1AGfbNSJ7iNxkZP641WE4YD4h+v2dvC9vh7tKBmn2JT6VlwVjdw+gjkdCb6cos9OczROnC/I22yLrTHug3CfgjugNM0u0dVZGeyDoqseAMDBItTIb0hf05DgJXGk0xumWH9xp5m3o6HZAOUr+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjRaEpSfj0LgRSoqfMkL64I7FvrMSt0c7IHdn0Bv5lM=;
 b=wWSpBNxl+bvpTW5z+7juD9uTWdq1CZefqSPD5XP2PimAtEy9c2Q7NFEwfOXBHskgIIUNrUeL6n9Hby0daTlhz5Wmpv49QwBOGIBiuy2R/sFrvDbKxRU99qNnYwp6wq7CXf4n/q8zLQ8n5jQPePta3SqwUP5YTxRk6+53eLOL4/c=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6037.namprd10.prod.outlook.com (2603:10b6:8:bb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Thu, 4 Aug 2022 03:41:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 03:41:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/10] scsi: qla2xxx: Drop DID_TARGET_FAILURE use.
Date:   Wed,  3 Aug 2022 22:40:56 -0500
Message-Id: <20220804034100.121125-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804034100.121125-1-michael.christie@oracle.com>
References: <20220804034100.121125-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0219.namprd03.prod.outlook.com
 (2603:10b6:610:e7::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 068961b5-9b2d-446a-52fc-08da75cb2c8d
X-MS-TrafficTypeDiagnostic: DM4PR10MB6037:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HXB0negHhdpxHYbG8dZKwnKRFDynOcUcb0B66Caq8HAeee1TgHu7gmJ5wtEh3DbGPw3GE59WBn1lmzPuFO6AzFBgEOBI44gdLGIry1Pr3hCApRLTvv8UF9P2zBIcEr1LPgrcBP+Cu5hSCqno6LW0bB8sQW9jMPdrnfDzvAGJDbkZWL6O6fN+X+fPKidjBdOBLUreslT9g1zChLeRul6VUihJVUmhTL73e8SSneZnFmdLxdvJxs04L6oXTu3Oky1lDMjsWpHqxHOkHPUg7aL0fHZoHIEMRZM0ZwXPq+01uZskWpqe5l35AFt+6UhkwvqERZB/MYkVz+yaaF1m4TJoSF1V/mKfpUTYzXlykmC+hzlx0bOoyHL0D/KaRy2kw1ml8mBD5l9hvyAdkcS/VC5kuU2kSeyCjbGUe4ITsHSOgV2FzvPX8D//1ZjpKQpdYlUAuSucmVM9ldaW2HggLyG+TIbO1VYgMFxrMEVCaA+PhU3j/iCUPnhETfjHgpGe69xrmp48z39+mY2ivk7+7SBotyblmTnnqnun4CXsnznPx9GYqRrVkCvW/cpH/MVWsUIngC41zeilK5B8s0VfmoC2VoFH6Y5lVmZ5xvNQC6AwDPpzk212AfBaeCjcNa8js0R27a7CyEOKzbxyo8n0C6XxXh8rK6fjxQi5u3zZdOx93QbFzdQVE4Web+Twnr6gmaiUqVDe4/xMUJKzffu15x1fPR3PdBDRXk5eJSRGhoPWM/f29/JMclilwMeyqI4BHCRFj/wge5KVsn2aEKQj23X8GTMg2UmSqrvzRG7yKFYjuxw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(107886003)(186003)(2616005)(41300700001)(6666004)(6506007)(7416002)(36756003)(2906002)(5660300002)(478600001)(6486002)(4326008)(66946007)(8676002)(86362001)(66476007)(8936002)(38100700002)(66556008)(921005)(83380400001)(6512007)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YDewcz3Jlfao/Pa2ON8EaYa8diN35Lsdar4uicb6YNxXT7fmo0SxGvEprhxd?=
 =?us-ascii?Q?QrxvX2wOCAg+QKzTCEq8BCCCF5tBiO6y3FncTwjutqTBVPlCziiWjGLtrqFV?=
 =?us-ascii?Q?qlHgOvMwc5lB7HvJR/WlI3HhyyiqP+gKKZMVuKbIT5HJzusc3070hzEOTdI6?=
 =?us-ascii?Q?oBMKFwE2Xbr2qmyIHsN7Wh3HUGBM4msb0oiqkjuZMxMaGrKcrOOOSh8qKKvz?=
 =?us-ascii?Q?hu58BdU8124ayVOu2hXycu41XhOe3EN+9kEQiUaawgkClFOnUDB8K+pcucmn?=
 =?us-ascii?Q?NeUSEnOwOD2+F8cia43lHHbSZ8+1Oym/fDrtsepw7EwD3MoD3hmLA10UkBY/?=
 =?us-ascii?Q?0cSt+oKXOuK1c3SvFS1EYtREW0wODDg9EO+UDcsgBz9iPipvmCkoNKKQsTek?=
 =?us-ascii?Q?VcKC2h7Qp5drpUY6RGNb5/Oej7j+Cw3tvcovVVpoZpaQNGyIIo1LDNhpR71z?=
 =?us-ascii?Q?BV1Lel6TrJ8VymRycrOJGwixbpX2V7EPe6K8ouPbShgO2Ma4lKZ9Qt9MVYGv?=
 =?us-ascii?Q?0ABj69Pk9RmjDfLvq0xRsbdGdYPV5YwBaLd3+TIvjJez6pb+aoyxMgsgNFQF?=
 =?us-ascii?Q?O/+Eb0OCn4c2YffnI+uiRi7IyDbz43oc9tt3kuZyIErAbmICOSOlRO8B4iUA?=
 =?us-ascii?Q?UIX0BxpZO9wlXN7s8OFxCL7izK3ZsAu2bs3dXg3+42XvgVsw8W4ZoHk2DWrK?=
 =?us-ascii?Q?J5AaE0Sl1iCd0rU0cmhSL0eGOOnMCUU66u2UnJabAZ1q2kaFPwaWHXyUhDnJ?=
 =?us-ascii?Q?Dp3ns2drSKK1J9RFC0pg+Bw2H+AMRS7m2pUfT7WpUHER1yCAEaffFQzUWRiM?=
 =?us-ascii?Q?76cJobuI6A1ZqhNKTIOBBUoRgm3rGzldpq6l277xEzQ7MU18wsju9AKCIk8c?=
 =?us-ascii?Q?lryLrwX1k+JYqkiL0uNZtcReH1MKpWt6hGalW9MjiwJKcdVpDWYy+v83vqPB?=
 =?us-ascii?Q?Uzcis+KpUALoELom9nRrGH+4yXBasKS8ga9z0lfHkuzhE0Td1PtHjdHcs0Xu?=
 =?us-ascii?Q?AWhBWC5SoRP2VcTtMSrUvSyoXuBX4Jl99OyDWPp7YsRehRD/p1GhXBIfPL9z?=
 =?us-ascii?Q?Sf2Ql/Y1KO1rgVpzRX83KN0NvUL4BqlCSeindhVF6soyIuzoTpLy7zeebDKf?=
 =?us-ascii?Q?WKVYSJa4hd3WtzFMfd6ARDTv/GmWeYtcL6cxx1CmWCdQYNTVfMaLXauVNFXB?=
 =?us-ascii?Q?fTt7N7K6v20yoQwH8IclGny5oE/qZuOp9K0jejhTVG4kHAj9R0pZXBZZFjNJ?=
 =?us-ascii?Q?KshS9j2GcrE3sJPwic3kjGkSWcr8l22NBXag6d5Cvrgdifdka1akFp9pROHM?=
 =?us-ascii?Q?tpVjnQxrIqmv9QrvfiJbkrf5oWreLDxoQq0dHQUHTmCx8ZbggqQles6Zflv2?=
 =?us-ascii?Q?Fk/6TV2wbi6ynkUlBjISac2oAH8fLl58ZMXKhBREABFHgOgMUYso5lEwU9uO?=
 =?us-ascii?Q?VuT0JqkT4i43S0IzvGm2/mAF8parzwRl8ToLwktBdiQFXU189+6AIwbQ/6HG?=
 =?us-ascii?Q?Cz/8RXWfuV5a1KUALe8gyc92HZg9db1HvhtFo+n4nuzlmEATrkcnsfL8+f3O?=
 =?us-ascii?Q?+MVOAvVCZBWYgQWQoeBnAfYa7gqDigqcjIJjLT2MKrVjhOrrvFKx6xA69ZGU?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068961b5-9b2d-446a-52fc-08da75cb2c8d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 03:41:11.3866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c1llDYgazXMx9Rdwmd+6GPV2aNk1wCWgISa+RR1S9e50nSo3E8vdW45AcGwu7iaGh5lYGQv5loyQKU9JiCOqJWErNxKyQlMLB8YqlWofbTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040015
X-Proofpoint-GUID: SbBY6EOkrZcbAKKrHDK1Fw3e_p-kq8wq
X-Proofpoint-ORIG-GUID: SbBY6EOkrZcbAKKrHDK1Fw3e_p-kq8wq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DID_TARGET_FAILURE is internal to the SCSI layer. Drivers must not use it
because:

1. It's not propagated upwards, so SG IO/passthrough users will not see an
error and think a command was successful.

2. There is no handling for them in scsi_decide_disposition so it results
in the scsi eh running.

This has qla2xxx use DID_NO_CONNECT because it looks like we hit this
error when we can't find a port. It will give us the same hard error
behavior and it seems to match the error where we can't find the
endpoint.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 400a8b6f3982..00ccc41cef14 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1551,7 +1551,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 		ql_dbg(ql_dbg_edif, vha, 0x70a3, "Failed to find port= %06x\n",
 		    sa_frame.port_id.b24);
 		rval = -EINVAL;
-		SET_DID_STATUS(bsg_reply->result, DID_TARGET_FAILURE);
+		SET_DID_STATUS(bsg_reply->result, DID_NO_CONNECT);
 		goto done;
 	}
 
-- 
2.25.1

