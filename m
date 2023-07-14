Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DA5C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjGNVhr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjGNVhq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:37:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01043585
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:45 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4ZFZ029810;
        Fri, 14 Jul 2023 21:34:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=gBSMRjp2ehAq+40L3V25ma6ZjBs+ezfX2HQpljKz3Xc=;
 b=Up/KyCCFbRH+WXazmf6hNHEJYbDwYs5ybmzYiuiPnUy3B/OpDQoD9bZd7CN2z9XJsHY1
 /fva+Y+YIzuNQ0mEQ6cAsBA2A0F51udPY5Vnm3GH9t94t0V7HK/xRXkgxyR7Mgl5R8dd
 Yxejjrgx0gnZKtA/EDBgkU2iENt6IWZiSZaoy3LNoO4rJRIdIsAUqk0XoIdoVfWuAsTo
 cCUD4TWZ/NqJ6HGU18HZas+SLQXondDOnF1E9pMswfXTtN7wKBQMVi1hvbUxbzPT/AlV
 l5yDEV8N5aind42u28YLrQbh7NYSB+nOMMtkoCasLMkFZipsgzyll/FkCpqmgwnn3T2t rg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtq8atd3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:39 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK1X2i007651;
        Fri, 14 Jul 2023 21:34:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvsrvp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5nki6vPaevY0uTG+AgUieWno2gxFkbthIlTP9oC2eRRBrNEDfTNNYugnlWFgjZDOvGj+1yjycclxXjZjf+XjiTRec/iNynM7XmOP2gns1jlP4BHa0c8EPhqx6Cdt1xvw/3nB0pZlnF/543rLsmJOJpoj9UrAVLrtB5i8S120ODHWo6LXMP4h1eYYOQXnC6Cdne7u27WHhHh7JhbBT0aXr0g7H5hpFnjkSAixx/WsfFlIAnVWM3zfFZN24Fy4XuwqTrborqn91jFHGdhwniW9ltPJ8yS+Zf83l/HPzF61cbtq4OAMy9w4IfKOr3Dcn+0h+wa8iTS2lPiqzcY26N9Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBSMRjp2ehAq+40L3V25ma6ZjBs+ezfX2HQpljKz3Xc=;
 b=kBs0jLmh++WtOTMqUhS+FnqivtW11Ge8ZZYrdpFimDasgt4Ufe2w5kUcyu7kb6ZJEtN7bLjC/619AQl4CHwHccA7/ubwrj45ScCUR0xOO3A8IfJ++1qPG5/iq++mtznY1LTj+7kjhs2r7njXAaB8ZRsMSNO7cAWrc64z7jaVAeAk1Rr3dySrHBY442G9ou/q+9iYifCyiIcwvtWIWbkUFZlA6tbK0C+ojt2vpc2OM9Lz68n6NcIQfmRJkSjIr6ryJ7f5ADiFbNRSAGIzQ66Fgjh9f41LkqUdkOD6On31ziu+UV2eMJlTOEqOvS07Ooj6ZadaSllrl2OrCF+3RxTbMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBSMRjp2ehAq+40L3V25ma6ZjBs+ezfX2HQpljKz3Xc=;
 b=s9AXsYeGA3hMKe5vJxlvNrn6U38Ro8LbOMjn9/Z4XUJF+xjRTb7DSaeXyFI5JrKwP+l4oSBhJ1S5EeU/61XrSGGWwfgLKU8/eFGkyYQuKkESYISeWFC+GQWkHU6RfwwiwG13fyQKXJTKwzYeNsFfF8FKD3rm9zXQ5/905juzSZw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY5PR10MB5962.namprd10.prod.outlook.com (2603:10b6:930:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:35 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 08/33] scsi: Use separate buf for START_STOP in sd_spinup_disk
Date:   Fri, 14 Jul 2023 16:33:54 -0500
Message-Id: <20230714213419.95492-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:5:14c::22) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY5PR10MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: 534699ec-4d5d-405e-e769-08db84b21e82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uy8xeyYGMWBxambCoEYstUagxwaFP8cV3Et4UFvuOPyC8/jDhmOsJyRWPktcQXxfJQ1VI5wsyJRAOEzQvuPl9HkXWIXNkyVhV+qg9g8Buhgv4vh7DQ7QfnaD+zqbmEqwiI77DIIZEm6yyRRoNv61vK+IYw178mPQc/y6A++PdQgRhAYmTOc9lPJMQSgDeYQy8GlzULPW63ZVz7WrUZeR9SE+LWEzK/FL4PgTNW3KkfBhKLosWKrwqsA99UH7c40+JsHN/zWUxzpJlGss/CVAg4Z+3lnmgjHKvQNGf2phH6UNZTilBeRhzz6OlqZESIM9dfJfUo3ALIraEF637UB1TbLW2JuM7cz3lESg7rnUG0Ag+C5IxYSUYb3D7o1c7E77cJhN6ZbuaTagps+1iFH8OpErjP16yDRk55I7qrxFVEpI0wMhrydPEnMuB9mYh1viTgg5WV4yfr5+3Ho1RlcMZeJG5vnAq536rzVn37XBg5MGpke2NYVYsS67RL0VUzoXUNA+0+J5cJ3RJTMT3fDK8lDDVtR59GvkbKRctopzGthcne52+6V9Gujj90YjwfrA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199021)(6512007)(36756003)(316002)(8676002)(8936002)(83380400001)(5660300002)(38100700002)(2616005)(41300700001)(66556008)(66946007)(478600001)(107886003)(4326008)(186003)(66476007)(2906002)(6666004)(86362001)(6486002)(26005)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A0EADzCc9QTVExfgtWNui3DWdgC/MQ1J0CwgOgQOZ3cSyikqVFCR8WPCFtiX?=
 =?us-ascii?Q?8D6nOse1QiHYYKx64oSL3csPHsrc49R96XbLFDhP49QoQgDNO8Lcrrek9Rbj?=
 =?us-ascii?Q?U4BR1X0l2jGWyV8V7Tzmad2dqiRMP6L3rwOF/coMJ3YryWN6gbKCVaHjExkq?=
 =?us-ascii?Q?qwtdd8eDwUsGwV+O2ohkYP6aGqe7DAyYNK+S6Z7x5oBOxu4AiAsaDxNHw3zl?=
 =?us-ascii?Q?YZohdnRhF5vSH+5rrUOSP45BHd1PgN9XXv/ibW5VijIylCZVotvxCgR56QQr?=
 =?us-ascii?Q?dFnCkM2cDFO6jqfYXTTcMo3cE8WgEXmn1glk00utP8WDb1DE5YxZrx12GeT0?=
 =?us-ascii?Q?Svuit304g6FBy6tW8t8v2lL3z+phMnt11XtgOQgNZ+SxdluxxEeAr8fqeUuH?=
 =?us-ascii?Q?su8/kUyPSSoRnmphgdEYX3wwRwciciLkrcMxSZjHCcBLpARqMdJZkNLh6M61?=
 =?us-ascii?Q?kgC25QRJeBRhRNXwIWbt09CH1WpdD7X6XK9h8SZ4vNk0tQvlyp32SH1zBtQ5?=
 =?us-ascii?Q?9C/6fXZB62Zd1rTQ2eOZbgcofWNcGyqcXA42ieJLKUIQ4ZUnTi8hi1sTfB7c?=
 =?us-ascii?Q?1Tbv/JHgFowJWp+1ci3PON+psRjY8bpXfoSTYFH8BVKzgIK5bKBqsGZ0my85?=
 =?us-ascii?Q?iLAsfHRhZ1meeaZr6mzhAXhjUh9mkcbra0WYDSxrun0PCI8GhVzlpjWd8h4Y?=
 =?us-ascii?Q?lRD6tnhUzrEcvNpyUYLyGFJZgb+Ok2OBZWO2IcO+bWr+JSrjB2oOziAPsoxR?=
 =?us-ascii?Q?OCtjYikMHVS4L1z79TO2eCuWFHU3F+gVFz9v2Ai1xdop9rgIYe5SHd3kcbSD?=
 =?us-ascii?Q?9YNP7DwUNR4934d9mj98TOdHIFJ/IO1QDN5A+NiAKiR0mqfz/YYlHoQL33BU?=
 =?us-ascii?Q?zPg19ZCUquSV24GIULZB8jYZhaAVz4F2m89ZfGKFDe9akLDobB1nc8KBlDIl?=
 =?us-ascii?Q?tZnuV2mgMxx5g+pTNMf76pnDc2/1JGU2C8dDJ9C3K3ulruYNyGgJryCwfyJ7?=
 =?us-ascii?Q?NlcKLeH1rLAxDrfiXpSBVbAwZvkiwmV1c6RrmyxdB99/aTCV5dChPymFhq8U?=
 =?us-ascii?Q?wargtMAZ8x/tNPq1VZSVDsaM8fFI2x+RB7aUo0iQHQ9q4WrBYZjR2BsaChKS?=
 =?us-ascii?Q?gYZeKLXBAKhViE1g3uDUBUHDIF7VIu55Y82CWYg50iMyuKlRa3Kg2dPcgYoA?=
 =?us-ascii?Q?PNs4XNTUXSrkp7b7gABdRLvQ2PbFcCv3dkp0eVzYfVL1V0s04QrxZBLxtI1j?=
 =?us-ascii?Q?2FeIboCnKIjchlMNBtyeE9aXeSCkF7Cy1bXSdSPJncsBZ93npXlxZD480KPZ?=
 =?us-ascii?Q?DOrttxauh8nRGlO4pp6WYoGNouZRQjPChj3LbKodinK9SbBDlxnr3LPg87Kp?=
 =?us-ascii?Q?k3fubR84siyR4oq1pwYtrSotmkGze+xWU4p8OG9xi4ERYm8gX1UUE2cD7K0J?=
 =?us-ascii?Q?IU+AZC3VFTB2mYEPK2MYYZ1QnOWm3SOp5/E1iEf6NuxZXUhIHZ2Y+hI4JqVn?=
 =?us-ascii?Q?XfK2pW0XRJI+DhXcOlZ1GisE3F3ov166ctuSc0zaoAwBeoLnwrfLGGoEqVEj?=
 =?us-ascii?Q?/1DMKAH+9ysYI93VcZ9b397fL7fgJpZ+CwdtVRngXKrMDz8PdDXgTcOkQY5p?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: odRM6s7HUf7Vv1IYxvdRmKtICQsi3b/EoENjxNPkipey1N4/ksm2TMZiz4hvqyQ1U5F4ABvs89Z0fSsJ6MCaslqyFL4YifJL1c4vP4pgbza5JcuISBFUq2dnA+7FrHHbUE3cpPHKLqrhhvLaU+BhOyY2Fhrh6EBKTouRC72g+VzHH2/KmofixIQcwZZADIrS7xRdDyMU9wQxGVlMG/hnhXupG5Zd3gukmw1RAkaNTKdEkRFDn96ikkDKBGCzgHwCxZE5dG6iynmRhk6JCZg+IRpmAM+7BIOrb4H6kJE27t2IPIxA2Hl81mDlwEl4nTl7ikB9dlDeLQz3AkF8zC2qNS0Eck3xvrIuqBsBAVLT63wAgAYFmizqAKuZvwPxVE0wB9B7W2ia37l9DseJJ4zcofEbyV+mnQEtMoDsul/dJ/kNUcqXe6K3CNjE/UNInYcXkYcStwRSzRJYAMvuMSDH0lDr2wZ2SU5ItX2132fwvc82z/9vHQmKWshN5yWXydRhTDZXAY4bcRhLizRPpRzmapkSISnSHECyFvQHLOPn6duCxspfBSu90EU+WwdnfKNFygDcnMwVutJXfBNTWiiZwnJB3t3CTEAl7TdBwzUARNsYZ7Pq5drym6vgitmHzkeaPBo8uhayYcbg3tdnlW5Fcqf8nJ9xKXJ8t8wVHphyCx1ms+PS48kRC7FEL+LRYOcoF+azv1Ui8R5DCCYwj2Ap7ttaLeqQI/hN6aa6sqUGwgEZwDdTlimq2lGv8+8evN+270vVGVaDJWiqaRKJMVNbolXZ+XEZzbpnN5RBtzairtmUbTEWwi8/pfXGqCyhSO3X/vmGnE8HNjRrNEOd3gK/UpuKEIZffHyErC/XFmTSHSETdpyP9XPXH3NRqXatuSL4
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 534699ec-4d5d-405e-e769-08db84b21e82
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:35.5109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6jVoUohNVZ5vsPkTgR8UPod8yi41hRHSBwJg9D3e8QfZshvG/EzM7yxJqADAhe3RJqllUflLoQzx/ilVS4dXGXa+Lz6WuMREl/hWoyzBolc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140198
X-Proofpoint-GUID: 13km6UGPBzkhhRll-h7nGmFgrpTagvDm
X-Proofpoint-ORIG-GUID: 13km6UGPBzkhhRll-h7nGmFgrpTagvDm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently re-use the cmd buffer for the TUR and START_STOP commands
which requires us to reset the buffer when retrying. This has us use
separate buffers for the 2 commands so we can make them const and I think
it makes it easier to handle for retries but does not add too much extra
to the stack use.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 245419fe9358..f75e2d7a864c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2267,14 +2267,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * Issue command to spin up drive when not ready
 			 */
 			if (!spintime) {
+				/* Return immediately and start spin cycle */
+				const u8 start_cmd[10] = { START_STOP, 1, 0, 0,
+					sdkp->device->start_stop_pwr_cond ?
+					0x11 : 1 };
+
 				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
-				cmd[0] = START_STOP;
-				cmd[1] = 1;	/* Return immediately */
-				memset((void *) &cmd[2], 0, 8);
-				cmd[4] = 1;	/* Start spin cycle */
-				if (sdkp->device->start_stop_pwr_cond)
-					cmd[4] |= 1 << 4;
-				scsi_execute_cmd(sdkp->device, cmd,
+				scsi_execute_cmd(sdkp->device, start_cmd,
 						 REQ_OP_DRV_IN, NULL, 0,
 						 SD_TIMEOUT, sdkp->max_retries,
 						 &exec_args);
-- 
2.34.1

