Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE42C25B50
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbjAWWMf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbjAWWMI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:12:08 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B33339BAC
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:47 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLhwgW029679;
        Mon, 23 Jan 2023 22:11:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CZtTPJGyqsi6Tm/xsLWLNv8mtCgR/rKM8dIu8RzfoOk=;
 b=SBJhrC/j2H9NAO6dnuBLs3V0W51RDabaDz97kfhQsAXumxvk45bsuBqwS7mTCJr/AVVs
 qhq8gpv0iiPgX0iqnuXD/r3S2pjSwsQcAaxOS+al0yto/aitjNRmEZYWSN3vlH45EURH
 kPYhFQ591p9cbsKU6khN4wfhU47n62CY9WBoGDKPo1QXivYpYkL20PSw0w2BvWDCNHl7
 ZXX5rI36Oa/5vBZEUAis3H1/X2IBZtkyR0PaKShJ+Mr1cJDOqkLYhSyn9M2wvda4bzMS
 lghschaoIk+A/3Yo7J/n+h7QNca4y7svX7F7njLR/QEhT5GYV1awl6diVhuE/ixpAEN6 0Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n883c41pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLMEwI023119;
        Mon, 23 Jan 2023 22:11:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g45en0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LX7kG3Uz8R+ICExuC7x+ix6UN+lke/7Dp1SkBqpHnw6ZieNFsMFcKlivsNc5OjSErPJ/B6rZVuRJUYWWyHV5fiuspC7cOrGXwvBJB8occ3N38LqD4VM/Iq6cKWOqeLCHxFIiMVD7GBaeFa5KGIce0hxRqN4DG4+oX375dk/eaeoIsOSUITtNexIfl0xbQ3V4D7A1gFgOzzx/fBiSM7LgXXaynRdVtDYeCbE6PsgWo9u0Y3mcluwT6/JzWu9QPaWs+4xKaxulgTxd9j95D6H2b3MRHrsGUYJnWhIOLTFkXwi8V2MCppHCXYzR8GjuWX8llCSnuBddKQ3z+QEOLtwKvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZtTPJGyqsi6Tm/xsLWLNv8mtCgR/rKM8dIu8RzfoOk=;
 b=nzpYETcu10qr+7a6ZgN6Y072OI8EoxIEj6vNjl+yG9kPudsXQ0PIxHI4HaxsQkqrYykGceqSGinDyRpLMGfZLL9qq8WKZ/rQ7696IXn3c1HhL6pkz8pTxbVG1mV78SRQ2EgXGCIZO0YYK3fJcPjmnvTTVnurNpjCx1xzbwDC7ujPTcqPdvySfQSc7mMrVQH4uacz9NFRyTMsHpB9ZD2ciFAgcXKWQ/ezCq/YPXwo99YPEjHpbucm7SeFx8NIM7EKPwihhQa1Q5iYntCoPsDhqkwJAmWl5g092Yz+gWqCSlWf9tVRATLtdHFXWkActAAUdiwgcnGknJZ2L8DBtvz0GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZtTPJGyqsi6Tm/xsLWLNv8mtCgR/rKM8dIu8RzfoOk=;
 b=nYf1+a+Yis+PKNBOMVK57P2FzJ+bkvMB56Ax2vopq/QIx/dnD6DlIgburCsKy7SSTsN80JNCG1se2hCDwgVC02zChdm43PRLf6LIjUdTJK6AEFMKjb4AQ4HrESqGvfgf0fs7VgXDtaQCFXerxfObfjL3HpyNpABerpbE2TxAyYQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 15/22] scsi: Have scsi-ml retry scsi_mode_sense UAs
Date:   Mon, 23 Jan 2023 16:10:39 -0600
Message-Id: <20230123221046.125483-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0003.namprd08.prod.outlook.com
 (2603:10b6:610:5a::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: e7a8e0ec-38cc-41ee-8a0f-08dafd8ebda7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ezLIrRkyLCG4obeCDR1WgraIn7VRuJV7XrM9oNSMo2XW+QOaGhumscuVKd6xVIq9Bj5hzguPd+l1kvLDp/Yie7APcSD5xert+I3qCHV1E/FBriL/7/64rGVmpYNYG4O9RxspjSK6mWlzXMLDH/AslcIKV4LSEkoqXs5awgetG/pV/s+POSBF4yHssDVdyzsdbk1UBe2+3zRniTJCs5f0XphJUXUP7lQACdAPbsfwGXvaqe8mTWbLI/A8kJSPRS8F/DqSvClkOu8jAYqr2Qoz1yUWEUSxVXm/DAyQh1wZ1OtBvNyDD3U6z4hACJfunVV2XlXL0GBI3Ek/3n8oFkMNjxiFEFTCcEn/fZViNzuwLq4tCsxpIYThZWVSHJW1C7NaIk2AJdFju/yxdf2KtqPyYeczgxnGxjA3UWpJ6C8xg0mgi4ri+cN4cJy/mevn753a+ZRVsuYyk8qv8ha2pEo6WwpiYDWj+pEu9DgKYLVl8nQZ7O0yKb3OOMYwKdzMAI6bA89aiJ/XU7PdkTIU4d3zIwVBYue+kUHVycnZhzMWbrnD8NcMNTnc+YWDR4HVPOcgvGsUgGRhTJy59Kbu+xYXlFE9IA7vVrhLso9KPaeAfOigfoVykOsT6tpLlQcm4DcXtLN8nVfKRn1F1+u9Zz2G2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yKkguV2Z+KDsZmMYTKgNohmBgLGn8sV2dv05XMJ1OnTC28nFlCPvUF6w8EoU?=
 =?us-ascii?Q?znJTTLqZQw0Kzi/gq+lfw31vRFWlUKYh8dLOm40d1PJimZauzR59zjxBE+zl?=
 =?us-ascii?Q?6YawSBWh6ZQoDQeQsm2vDAHMEKXooR5HwTlm398wrGZHJwHUvK1uYXfou0oL?=
 =?us-ascii?Q?bFUYSJB9x/cOjoKgS4r0+Zcbmrp/bc7hHZStpFXNnZYFMhAle5tA1aK4u3vM?=
 =?us-ascii?Q?c4uCQ5vYbbAgUWhHBqMxTPG+iIvwUgv9bcVFYHu8FVrVLpmOxN1EBn4Ps5mb?=
 =?us-ascii?Q?iIoqw3L6EfpaMwqTUiQEQv6aD7FN7LEpR1aZ+vZ7d7EejGKwqUonwfYR+S3U?=
 =?us-ascii?Q?8oqCsT2/E+cjJjKDLw4dIgRNzH3bKwCCcJTALLJQ/7I3AXAUwuppvXP7ybOh?=
 =?us-ascii?Q?xYkWHoexTd5GYPL3nGqZPyItxdIT2Yq5BhmUess28yx+m40lxHG7PP0udOSU?=
 =?us-ascii?Q?78cXhalXw5IAp23w4tSye+L3reb7wAQjtouhijnOnyR3wVEhGHShAikNRnt0?=
 =?us-ascii?Q?HB0H+A+dQQKlc1pMt/nPm+TXk8EfmXYhmhaKmEemT0ciSrZ3P+ddrI7cYYYV?=
 =?us-ascii?Q?601lPFSvb1FRcVU00eNEWnY4t+XrtrCnLuT1eaWG9330eAhXWEu7TGWSV9w0?=
 =?us-ascii?Q?s0bP9gjpNd+Xwj7Okvv4TpuSFRrztTRAgFWcQK3rN4q5atMUne3qD9hRkkSa?=
 =?us-ascii?Q?DtpI3DO9Heq7iQVRyOx5x2NONJNYIwhgGW6EVSaKt9J+l6f7zYIUi9EF7PCU?=
 =?us-ascii?Q?eRKDQRfGbefdtbgn5C7wdcnNZljfgI8MU7KIWOtRBOnLAkRVbXyq39ZoXp0S?=
 =?us-ascii?Q?bM355sPItKFpW5m/d/hPil2JFYQ8MqKnMt7sqNIPZfruoSmiLQV+Fn6ZGlbU?=
 =?us-ascii?Q?r4nw5zJK1vEfsC4mIsw0rfLbTy5rDcVf0Vy+na/sEqXcslZq45NGEP7x+b7g?=
 =?us-ascii?Q?k3Gss59G9PV8zDsHegNnkC7H0K5lAqArlnvz1/DHJjsvOuvOrCjeVzR+MHQE?=
 =?us-ascii?Q?KcRDPQ3VtrKquExSuf4QdAeZuZ+rsYqCIOfgbdQa8KlrSZv8GtS9rQDEyXLM?=
 =?us-ascii?Q?971aVbQ+O27TAxqLUq7sQXYj1sivdrQqzDQT8LyV9np3qgvx7s0YZKtiID3A?=
 =?us-ascii?Q?yuIu+GeQKJgiPz7tGzv/if3k4XxKLK34FeRb6c6m5hcD8T4eB85IYjHpKsTv?=
 =?us-ascii?Q?A3hNZfYxg/5643R4Dj/VNqyf/41d6oeT/ImIv52zk6xPQgT2HmtSTepkVBNZ?=
 =?us-ascii?Q?//8zLC7JCWnciVWs67hpA1b0XSJIi4k4iOcWYRKmywwm6w64Ipn6Z0j/xIp4?=
 =?us-ascii?Q?+oW8OwI36TmBlL546y/4kx78q6LIRySdHIa3Dm8mqejlou/mYXuiLlSRbCVI?=
 =?us-ascii?Q?obDq9p0C9QMVqM48CHadSmwFtDwJvslGpYqKjoCgx9mch2CKrQQqoOzBi5Kr?=
 =?us-ascii?Q?l4ML/82qnUizj5lrIb16SxfQibfXWf4W2eSg1RmhRl17fayW8XhDPI3kqtAY?=
 =?us-ascii?Q?OFEUh0CFL/YZO/eIm/yNQ+tQft69Gkh2dYCX1m4SSaqQMtsLfz53yzNdBHXK?=
 =?us-ascii?Q?9Y+xVBvNMafLx4/eJhzT3TiH4zg8QPCSnrMWT+knnS02wdkhHSPPF8AZtYxY?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iv/iHoMVtMvOPzswEfGB32Bk6XJN+92IXSR0UjEw1zX/3UGIaEUIRX8Ro2jgV2DTN3tWE4OFOYYWdCGueKQcgPaIv4D3hjWCf48JYOHnNJ+YXoAY/emVC/eugQQx23BEPMZvvNyF7xW1fL2pvwZdVoLRqBlCy1K1UCH9qrRWKbElKEfOKFbEnFimWKoIbPcA1L/qdz+upbcBlo7BxzIVvkuPwf0HRLYXQS1QvtI8xr5hYNxvm9Wh9HyMM8O6WGpsyBTpasqJt5YIr92bpNiKxByEqWLk6Af2mVihUW52xgTxbA+dX5PJUX0VJCl5UTwqUjAi2ozSKGe1YkTnQI8UqI90AIWfupHRaWdGyqdLijMb1NwpBzMWHfFrCKxa2S0D5tDQOUPrbrsftNSGdTkTHfXNd5dEcoXFZfx550KjPCr1D4proTV+4wvKoN26DDAqFxJe3+bdb+u0RsXQGYIMvC+DF4uZJ0wPFU82G/BmiHMgPd/BB1r4w2z3TPE4TVbg4zN01uBqTohcPDc26r/30UxgZfrmmwNW1CwoTmNkSt0JSHW5oayeGbinnmcNFYcg4oifhQOTn2sdDr+4Klk+YbSI07AX3BvILsqB+8QmMKInFV4RLgSvNXXT4SVUOQznzHJnYNTlZKaYwwbnzA0UuhrpdtQRNR2/C5BSGdWQUvbGFHUFDjbmuzOcjUvGM6Fr3FJyzcZtwfLNtcrs+e4PRy5KsJZiM39O8PKjIhcZ+aPNLXjG4keHTvQ81tye0aKgP6Dc+O/x2BC/g5mzteV2TnUwAv0RSxrRQYUPvPjtzUgUrX54gTT5AW/q9V0jlseaYGfGyfMRgwCf/9M83+r99lZC+6RM/BI0ZLe/S0N8iX36d2lhMwHLMvYeawWR5M5Y
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7a8e0ec-38cc-41ee-8a0f-08dafd8ebda7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:13.6653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ba9CeG6gTok5H+pvMVNOwMiLlfmSRYprlcV5NAtJar60hUFNSGmGpSdEg99HVTPO2yPCilXGOQsWH6k7IZkeG6o/1IGBauN1G402zNTS++8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-ORIG-GUID: KI-g5IjRvSrE7KOw-PKghiTpVlyEMpLS
X-Proofpoint-GUID: KI-g5IjRvSrE7KOw-PKghiTpVlyEMpLS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_mode_sense have scsi-ml retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 50f6c967bd4a..90070b33061d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2177,11 +2177,22 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	int result;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = retries,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		/* caller might not be interested in sense, but we need it */
 		.sshdr = sshdr ? : &my_sshdr,
+		.failures = failures,
 	};
 
 	memset(data, 0, sizeof(*data));
@@ -2242,12 +2253,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 					goto retry;
 				}
 			}
-			if (scsi_status_is_check_condition(result) &&
-			    sshdr->sense_key == UNIT_ATTENTION &&
-			    retry_count) {
-				retry_count--;
-				goto retry;
-			}
 		}
 		return -EIO;
 	}
-- 
2.25.1

