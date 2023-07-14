Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40291EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjGNViR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbjGNViL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D02358C
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:38:03 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4cng014937;
        Fri, 14 Jul 2023 21:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=wWBykNyV0W/DWHnV1ut2kLWbv92OoXAV7RUhFvuhhGU=;
 b=D+kBUQw4H2iTbihkUy3cVQpj57+F2z6BQaFwlrw7ox+Yb4AJPIF5FI/fCPKrMes6Axoi
 GAQC+Q8BJ1TiSzqIKZtbh6hM+RoFl6/TQYRuIslZGWdrfC9DaVUimYUi4nu7i6Ui/6ci
 U07g2yi3M04g7GFN3KcanRHuxR2GdzBIEVrpmK3MGR6HUG59RRdEYHuih+ZqVa3Bbi/A
 TgseYo2zGqIbq+OgbwGgS4IZ5DFimISRF/IJMfpV4y/lxB34eltIL904Xh3Gqu5I9mkt
 K7b+JVjAo4g2J+idOas1/zApBIOt0EfJemirPMGC35PA3fJO1mHGIQho+xmFQ80rDY1t 1Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptx2f68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:57 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK6nO4013815;
        Fri, 14 Jul 2023 21:34:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvs91v0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKvRk1tIGNZchofqjMpI1Yn6y7F8Ob/RPkV6zF5YQ+YyiAn268xRu8Dwyl8QGHkUOy8Pi1GUVSBfac5+Fqk1dgF+rFxtH4M2Fz7e/6qkqfqXtAa3JOV4usB4sv3NnJwQr4ieB+sLmGtiFT1PI3yzS5QzJ1thiBhycwLl0IUdJcPj5Qi9j3pXpsWT01BiDf3l4JRjuoLP3SfYVTS0cnuP7+/7QnW3BHJq28t8XkT/N54E8dcW7fdYaoSANpvsnLSYVvhHuD5M03lfe+pXlkoWWv1/YNA5iniffZE6Lgu4XWFXO8qhytGHTpL5T7RZWygHOQWSh3FuJLfPY7duGMp7TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wWBykNyV0W/DWHnV1ut2kLWbv92OoXAV7RUhFvuhhGU=;
 b=B6d3fGYJMrOowjI5bzMFD4KMniH1k/M8pDGgT38xy3zxSWFulIZqT6gfT+PJ33H9+m5iT2zU9y9W8+D6BX8tuGCHEGbpGHZ3nWp2hx8zF7ChkGTfk1jhTp2je2wtvaVtVTSr1Re/8Xd3qAmNuzam+gFbOlXtZZjk/C+Cicy+c2nKt9SOIyue55i/W3CgqvZ1ki0kW5JJaoCdxZPMnvlm3ZyfZhCqYGeE5lPaZnyNIxK9uFy2hudQha+2pUIG666XkPEFEQqo6io6EUIMfOfHN3ydHQTvlZwTUydQAWSoOW5GkA74yKsqikkUklZHq1UpQgFpcdXiF3VUayjfaeVaTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWBykNyV0W/DWHnV1ut2kLWbv92OoXAV7RUhFvuhhGU=;
 b=BNKcaupEnMpEJSoL7aOPpvFf40Mv0MN4gvCd7sQVs4QLjKZMgfqPpaREuPIdVkznoGsM+7HxgWQm2731pxuMTf9Ny7SgVKjeQ1njF2H3eL+wCmWmrkcgPhZoBX08LirFIGRveEic+G2lQ1joxp5ckFUdcDQ1KwiWddYeyVP8ZHA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:54 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 19/33] scsi: ch: Remove unit_attention
Date:   Fri, 14 Jul 2023 16:34:05 -0500
Message-Id: <20230714213419.95492-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0021.namprd11.prod.outlook.com
 (2603:10b6:5:190::34) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: dca0be5e-4cef-4344-cbf4-08db84b229f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2L3Ye3XCNCW3C+8jmVrxbiBYc5u3SGstDzwDEQPkJUhTt7c9zojxq3ZQxcIQV2SZ+mw1Wgp0P8fuGy8FZp3uji0mIGeJmDz6u0XPapW8lqRJCzhwAoWYXocjfkp3LnjuARNgMUZYV0CrrtIPDA5flmLOKXjZ9KXOFiUCtDSnaToZPNTDoX5+/8PdCpJDMKPILmuOWcahRrl2awGfd5CiLsLKUJK/NA0h0Taogivnx76CqezdN81LVGI1LXN0hSjWI63NHE/1Phe4gBA4keRUzALshbP4pH6bG4Kfizc5+YhQ9y6twglgHqKoBQbKsnFwGbZNULG1MPFt1AHgP7y1gn5r8zAaaaeeYZmnj7dfmxxTD3f+NQ88J0LA41eudKZRoPFjnJM2XCtP76N/yecC4YmbMYI9/xBKHAikjQLAP0FhXF3LdiuPMisuoJjKti4kKJf9cQwRrNzcbmdGTFo0TUQVquE0b4hh05/FCzxVPqZJlixo3UwoAqdaoRtJGxTLldBZX89tD19B+qNv5udIBiGkrFaTZQHDmX+NNFSLKW+0hivup6guSVh+QUJv9uRp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(4744005)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yv1DRfafjaEHglAbKOVOvZXVef6S8tHTnNdLCrOGwI8JHvtgI9rX7aa7GJ25?=
 =?us-ascii?Q?Sq1uJUqZPazWxoHqT11kx2GEVCAMc0uRNwnaNa3Sr50emmoGJVqzKFE5fU1P?=
 =?us-ascii?Q?5JaUadRcd4YJ5JF7Gr+xJdxO8hohioV4+sPvs2V2jdP4pq2cpB3ilH0sZNGX?=
 =?us-ascii?Q?myHLuPKXUI2fWDZHdoL5zbu3ipMd48tPqrRZaXIT4R7LCsdlnrYlS+hYWnLq?=
 =?us-ascii?Q?JTv8aZRmj7BdiSutejM30W20zUZvFqUZSfi+lEjAXI6k+/SBOy9WkjbwtURK?=
 =?us-ascii?Q?En0Nxk/sqzqYk/XTvYsPnJuNtas0IMHBs+VQJlncpjR3likD3OCnRSki6tzC?=
 =?us-ascii?Q?89/dy093zm13Q4lxg+zz0FfAjodzTfS6GvNvbgV2ckbeSIyee85zEEWUZgu/?=
 =?us-ascii?Q?Wrdk022RGC4cmGTRtKlTzHHaXSyXhVwaedbChAZQSqyeAD5KYEfx4GeKWbnV?=
 =?us-ascii?Q?ZbK3W0+ZRWJH0GXRChLOCWgYc4vaMmvCXric/tVI7btx3b6AKCWzhpye1R9S?=
 =?us-ascii?Q?rR7muVXnCPqHUhC0ZUKhipuwBxW5SK9wFDuo8KECGDDTgqsjVhpsFdFcrZwb?=
 =?us-ascii?Q?5ELH/4M1nKGiaugFhaHS1sVwEBU1HSji0t4p39srOgGzSxAf2Kp1wU7YyOIQ?=
 =?us-ascii?Q?DFz71PMl8/cMmKfi+8M5MiiJqHih5AkNm5cxixtmhc19JT/74tOAJxHJF0x1?=
 =?us-ascii?Q?c0O246fbbpounz/JQL+Bj0NUwDpUatNbClTOjZ2rlynqcUn6pejCxLwRid+G?=
 =?us-ascii?Q?Okr2oL4bEbQIANOptu/A5N7UKBNYpe9camqfcxvw3OqZIz7KLsmTQzDA4Mmp?=
 =?us-ascii?Q?NNxpILiDUCdLfP3g/6vI7xCn7xQCUnF8OsnjtaRLKKmf7nOpN8+6gdhQkL+Y?=
 =?us-ascii?Q?P1VBn0Q/t6BlxyAnmUgXRGuTkFJqJ6zRxQz7x3BBTulmylWk8agD1AnF2SUP?=
 =?us-ascii?Q?9ymYS+nE5v23RfSqtZX9uVFo73IgSAq3viKtdYGb6cRRiCQIgMvN5k3tEmZQ?=
 =?us-ascii?Q?1BMhYrBOeG1sufhViP+Q7MND5eP/zfdTGgYTkhPUwRCDqawfXJxJY02wWwfi?=
 =?us-ascii?Q?g+nRN1uZB0TolUE+mIodR7V+33W6wPvvoxn3JqpNn2irtu4XSU6qObQa1mLq?=
 =?us-ascii?Q?2l6m/mX7EXxFTumI8g3f75sESgblYt8HAC2ougIAAiBGTGg6768f02+tWK/t?=
 =?us-ascii?Q?iqSOwg+3ngEN7jR46jA+PYIHp7kb+MhkTA+Fodb1wDx4zwSNYpvV+tZIuCMe?=
 =?us-ascii?Q?Oz4U77bR1z/XjgCuOwEMU0/doe/oqJxN1Xx7aHU8V8/eX5K9R9il+fOYyZfH?=
 =?us-ascii?Q?UXNBybUNAbtmycURqB4D7OHb5J3I3p/aHnffE/6NIzExGh0/zUzTIbihgUHa?=
 =?us-ascii?Q?iYXm6vOQXT/h/DDxV626/uWBWrFwwPdrPs15hG+KjXUiov2wVUNzDaMgcrfp?=
 =?us-ascii?Q?yevMKXBkwS1HGk7ae2YVEqy1nTQtykeOe8EI6Ef2xYI1Q7tWexIdErzNZSYk?=
 =?us-ascii?Q?uK2ggBVXzbF7pbve6SpI192KNwdvPONWO3+BsQyePAh3HD4Jfp5XFZ/3diO1?=
 =?us-ascii?Q?mTcXQTY07dy9e1OY9xYwSQ1TbyL0QdyPWwcuCYxnySJN9UcmjM5ZpUxzHpQN?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qVkXZQbyfSdZmORB6vqmnaePquORzukxERdESG3OIOMU6r4qlm6pterdD2rLe/RgKODO9n0RmRxZFk51etNyVKO/gR8rx3BFRGTm3WJUtwGtuNspdjao+X9fq7ql/0OwH6fhlsksRieq+cwPSDrxpzrtoGidBu+5sT1/x8tqfIyiQp3gRytHlU+tuHK42QYy2pz2I2DB4SUb9B3JBqYirunmPS0pbQUERlpSql8YwZJXj7xGH+VdsowgGXh/RKHOd8oxffbgS7yfeWtNSSywds6XsYOcv10Pfz/FZbCATeAqNW5rcCNJs2oYzzzAO+uCTvXrXxV0Fo8mtYRL/j+Ll6kfbbqSGMh5ZZ/Jb9krMuvrmFSmGIA1tyY4TAgYT3zrEPFRWeP5CCWcm/JXz5mq/I0scHC/p6LqMv5/7PP7zODAf0JpGbZH+icOFWIC9BJNcvdNHBaKMne99yMFrneG7VEVAmmKp0G5nTh5tnfP2t9lo9NfyHkcd2h+8rud0U4sgBTbThmA4utfk12MyETZrFERVZMXj1F91utAufO8bgiSrQUVU7lGxNcGbcuAMl8qN/6FBFMmuFvqus9PiS7pVxVwQCxzuE7SOFhFWOeXXqvEJxJKxnfvhVH0a+GjPREaPzSjM9YZ4GjVXx/hKQZ0G4Gc0N+XghxagI15BhYjBbEosdkibo9jGEjzH2fZi1Ppc7aw6wuoili036sAzx2R+QXkQas5tqHREfF2nBBiNRWLgBclw71GE4K8GJcUDyEys9DWcVHpTQ6X/kCmXsHZeevmYit7VdQ4vL0gFNq1Jv8uhUG77smFcwynJ2YeZPIgDi1NrZisypxAx2JY/pfNFsPZOB+BFIU0c9B75LfVP0/HCrTSPpoMvV/jrzR/LIFG
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dca0be5e-4cef-4344-cbf4-08db84b229f7
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:54.7405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJQvEvaMbyKhj619RSFiAIX3cI0c5D4KMhCJZ+FNJlJevNKWqKlFIbMCPhXfR6ahhmlE/LKQs5YNGpxtoQUT6MOZL1UPhemnJR+Z9pQD8Vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: fPhmWMhUa4fbQdde1x_3KCIcthCj-IwL
X-Proofpoint-GUID: fPhmWMhUa4fbQdde1x_3KCIcthCj-IwL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

unit_attention is not used so remove it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index cb0a399be1cc..1a998e45978e 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -113,7 +113,6 @@ typedef struct {
 	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
-	u_int               unit_attention;
 	u_int		    voltags;
 	struct mutex	    lock;
 } scsi_changer;
@@ -208,7 +207,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
 		switch(sshdr.sense_key) {
 		case UNIT_ATTENTION:
-			ch->unit_attention = 1;
 			if (retries++ < 3)
 				goto retry;
 			break;
-- 
2.34.1

