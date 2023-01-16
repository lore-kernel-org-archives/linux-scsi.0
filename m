Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36992C63797
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Jan 2023 21:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbjAPVRI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Jan 2023 16:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjAPVQn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2023 16:16:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02FA23DB0
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2023 13:16:42 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GJhrAu032333;
        Mon, 16 Jan 2023 21:16:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=lrvKMbX8opy73hVS3Nt81wt2wR2J2ekFJUlYEZGDANI=;
 b=h6YOOic2CpYfeBv+mWtzGsn+15WR4QnsEa0fRyoHQaRr46AlGQ9TEUxsTlMiDkaa8Q5t
 TSJd4osJPpHIG/aIhxJmBOOdEGN67Briq1+PfeK5oZvoseYzSzpUDgGSRIYEPB/3yw+J
 5tKTKmeHwyaYV6WWz7At4RHXMvr4eS08DsHhLcdzBgx6+8Z59NIL5tipHVJM3L23KOt7
 xoT7Q8LEymbE/qtA1a+BU9IdDj/Kb+PqAflugi7qCG3xU9YNoOQNO0mJNHYiLtIfmX7c
 Ncc6yE2ONuykRgUllo2pz/GDWF5A64twVCjtRAKMXbGCeIOpD3nbHexWaIEepMC22l/U ug== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3kaabfjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 21:16:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30GINTeb002546;
        Mon, 16 Jan 2023 21:16:39 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n4rxca6k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 21:16:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJXDfNdHUZ20lTM3lq1Ix24nQBDImBPf2HSgUAXNlnjVb4G+UR2DupSdArFi9rqYGF+//czfxEsCn00+kAik4DV9adjeGdRj2JHTGiwFqGUFRtAnlf/2MrjFSTx+stykR8xIqidpUT7z61fpuTNsEwnywqZH6WRCwFP5JNRDYyjVhItqMrszPi5Bshudtc/8M7zXrxI7XL1rhBe5DzhalKGv/4RYahYw3e3ogpK3F42/l4Js52Nus6ZJDUavFUJFNBEOAakbzDizM1ns0pAQJoXRWTVSByeMvflDXcU4p+UAN8K3Q9rU19a2rzdxk/PjW9usLJr6sAwSoBD1g8+bdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrvKMbX8opy73hVS3Nt81wt2wR2J2ekFJUlYEZGDANI=;
 b=RFBjpJi0QTybykeDkrEgCnSo97n6vTXAkogtrlNP+7VJSa9nyAdqVu2HMm9uTFMoebkalPefl/3A2Si8v6WLWTMAWVq7kb1R08D7YLQKZlFCRkSKaGVudm+xjcEKLYWZoSj6SRjYrO4MbBqim3CHbJovnCcxp1Esh1fKzLbtFb78/eB+PAxhP2p9UOhsEWE72CUI2i61djGOim0uGFlPfVBJut52kJFZ77TlCaW2Kg0gU0w9/esf+5gWVQnVHOueuMGO9DU5hPfwN3OMM4kr1peMhTTSXyWVy2CxAQiMU+bi72dOl7HoYbz6yRDcxu8X9Sgt5P6xBLOVdrmKt9dD7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrvKMbX8opy73hVS3Nt81wt2wR2J2ekFJUlYEZGDANI=;
 b=nu8Ht1CjZcZ7CKnyeytiaYMMX+1RQCsLS8sB8O1fEhUofUB15S+aTSl6fmocebhC2iWmw/JB2gh5NjEBsFxdK50GhCfFRkIGa55Gm02xT8Lsxg1MVYNQJyLGZTjotbCdUtkxyAFoaF7rgisfddTg+R9K+qSRmJxETz/smflmoNc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY8PR10MB7292.namprd10.prod.outlook.com (2603:10b6:930:7a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.19; Mon, 16 Jan 2023 21:16:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Mon, 16 Jan 2023
 21:16:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: cxlflash: Fix compile error due to incorrect scsi_execute_cmd use
Date:   Mon, 16 Jan 2023 15:16:35 -0600
Message-Id: <20230116211635.104999-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0086.namprd07.prod.outlook.com
 (2603:10b6:5:337::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY8PR10MB7292:EE_
X-MS-Office365-Filtering-Correlation-Id: 644f3fd6-9258-4f09-1dc8-08daf806f3c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tiIQDcBEwaADlE1YUbn2/r0CcuEmYuPSqAv075OqpegQ+pNbVAU1bVE0QPt4uP51ZxEgcwwTCLIYSe+QJCjYi1eEvSl8G45mxCskrD9d1hRGYia7h6ilTu2HPo2Ps+fXpcFVgCiv+HyQdueK7j17H/R9k37/GXreSAd4JhLh4grOA+IFtNRe3EZciYCkmTR4SXm1ofIMSQjlDwNgMk5SXxvtmBe6NXRu+9C99eE/by+DXOdWsEA64gmZAxDnTej9RkGNeC83DMWc9IvAKdgm6fhwS/y5McqTqO6XlPvDmVsRQlz/vo0rl4qYrOLK91Mj0gs1BsAYXVbWMFsZtNWzsljTfPVmrGVBwAPty6XNqzQAwhYq6xfpizbEIEPb+/544g69EhxlEPMLHxFOMJSly1u1nN8zPWA360HSGPYmScUGyyGCmwZKLdQq5QrJC7xWipG5I1eo2/nC77m1qaJIU6H/qvI6tyC8RpfntSkTfAWqvGNhK21AWiOq9pxNbJFkbc5BHpje9d2fIt66vzpLCGKwqic5Vz02K5bOOk3xILPxFb5KOPIBtSkzB1OW3XHEbEmnoWyFLO6kWDEKGt9eB8CA4HZ0U4FPEhK/afKh7iiCTyc9skckfICTjd0B+AExv01CydfGpejzUROiqfviig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199015)(36756003)(38100700002)(5660300002)(41300700001)(8936002)(2906002)(4744005)(86362001)(83380400001)(66946007)(66556008)(1076003)(107886003)(6506007)(478600001)(316002)(2616005)(8676002)(4326008)(6486002)(186003)(6512007)(66476007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UOnZexVknmiQgBhoc1cJLZCfGWCVKg2mBpW1mlaHVbQzbZ6KWngzfRkiVGXR?=
 =?us-ascii?Q?TV21m3l2jXW0pykkZzBXRL6Un2PptENXqw9DDwWcNAcWRuzxGOpC+QR2GtJF?=
 =?us-ascii?Q?0zNVPqRrmRxlDuTC0KR98dRvpxZY55Ko7EwaD/ZWaMwvg8r58U9kimduii/Q?=
 =?us-ascii?Q?BaELLd9qtAMhcMdHmWq9cdBrhSsZ6lOgCSwtciMdkxDPGiGaLgu+5T63jTT5?=
 =?us-ascii?Q?AH4X0bBSvSZULi07zuVdM3xIsQRarH0taegAN6erF2+jeZBvHC+lmQD1wWtg?=
 =?us-ascii?Q?wAsr3vYPpsiUAmFe6y1ii1xL6G31RuwY3W6GULpTQsef+Fr+djstqCm+yIGp?=
 =?us-ascii?Q?MgmA2YPoyOrxGbdcwyC3qObeKXFmHJN23Zu9wSU/6Vbh33emn7ptnOrKIa/y?=
 =?us-ascii?Q?JrNhlI8yJ9lF/zRHkVHMfPlKOxA5UtY+LP+M8/v99sqsIasPRRogL69rgbGo?=
 =?us-ascii?Q?K2oHMY2fLYLEtPP2xocqwwRpaL2/9pCCJTIGRR3wSLtnuu5yxUS+6SMSu1Bg?=
 =?us-ascii?Q?g7Od4tvtLimfE6Ov7i64F0K05IbwR3q+mH8IQjsfkgWW+DXr5VA4ureaV1Xc?=
 =?us-ascii?Q?kU5hBNiJQPi8/0yQSCVnKokr3sWL7XSw4a3EqvrcS4aJacwfVQkjMn6HQdbP?=
 =?us-ascii?Q?CoY6dkhhQFgIQYHsufDNVgLqoNm2rZOqUcZaryu1/xDXdQlYPnR8D8YS2+5o?=
 =?us-ascii?Q?EPwj2EarHMuwgg079/slp79Jm5MIVOk86TNdGfl+cqEf/2u8bogHpktYX1EQ?=
 =?us-ascii?Q?3EkyzHYUZaKWg4OCyqibBBlMwM6Dsmt+m59Q3THIvpqIUZeEPDEL8S3Vcxvz?=
 =?us-ascii?Q?2zpjsfGqEpWT6vL1YYeTyhXhQ0n5srt3v6kRh3I5+J/QNbF5+wPzvMZfk9Nu?=
 =?us-ascii?Q?mxPf9iZeOppjCOP7QczQwSa692D6W4gcLxTsbpEtIxgIhk857sw19hf9yrNG?=
 =?us-ascii?Q?A1YKGq/XAuDfiTmHtW9pwhuHwF9z7cWg2PgwL4EAuzMEP247HrIL2+ko2w7N?=
 =?us-ascii?Q?Lg596sDL5Glr5tduFDIsfXYVbYCXy2/Kn1j5Wvyr+fsJ0Z6rVsL5hFwUHGyD?=
 =?us-ascii?Q?axrtZL2OeRM2WEyO8VVdRsoVxxj9wqXZf33CH4jBsfwfUaK5lm36wCn86t/z?=
 =?us-ascii?Q?jRx/UdvbOo/gaqaiahsRveQN+Kcr42+wP7f192/OhkDWoIE/XsgPgj7/9aAu?=
 =?us-ascii?Q?lfvK5f+uprBfMC8U768zw0mNSvHhXQQx9vbws3/m4mhB7FtNC0aTYD++RPsD?=
 =?us-ascii?Q?rT60us/MevXLVAsL7z3wn53QuTNggq6MSxAoH5760m2Mgjx4gHcrCOaN1VhO?=
 =?us-ascii?Q?jxpGA7qiuZpKhvc6CeqNH5UDgKOn0gFzSyAWbSRr+rObTLk/mzpHehcYz2Y9?=
 =?us-ascii?Q?trSAKaUUnj1b+1G7Atf3Fcyq/WIuJh1uKLGXIHIMZGlBHcTJstdclmwZ9EtM?=
 =?us-ascii?Q?5zs3LTgsiLtvmdrkIJh29hwFG96AqiWQQt1pd/IK+c6VgQ4Ncbf7o7xif7fE?=
 =?us-ascii?Q?f0nKMpSzQzCUMhXqNtKbCd/Czw8eJyrLnrd5E0fLtfjJeXvhaR3I7F2g28ff?=
 =?us-ascii?Q?1SvdaQ46BpgiJYq9y4phbYwhgN41OTGT45zqFsE6Xdbe7asGQfu3+GPqTv9B?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ct/sWWmwLfX+yAkIIis0+DP6/LOewxoq1dqAkzXIhJi4sTXsjxJQ9Wat1Cs70xrO5xr5ADdhkPaAnY5qUDxyumZjNMBqEmdFGHYLSTbvsODp2S14qKOJoLgULFZFhT9lTxjrmBzikdbPJdUHf6JghnfkuEPWZvQ4CM7qUnwTsKvcGND5FyG73cklXWoRJEQhhsb6t234H8slXJ4lPEiWqCVfGAQeWoZtDcUyt7ORHnFKeBp8tgTuUsOKkcr/eYmwV4c9FA5tZNE4qAkIELbmuqUf9lnT9dnTyUFQwqRKPQG/7F7Ddgnn1N6/bItXE5lx97JxgGo3AMYwzaZO4kKhJtjYeMMZlJUG6SqRS5g02xvpkylczdsf60noFrDIGvVO8gcNHBmCjSUtSt5JNP3XnnrSx/BDQ62TtZtC98bhswDdeg7DjnFaquttNN2qgIf9W2Zz/m87MHpWS2AfDrRF40KJOoWNV7q44uDI14RSdLKXro4aqP/IOot7qsjSs8QQx7TpZ+FWlmoRMObaWdqanmJdpd/7/uFlTU1zxNALl+la3wO31vbU7AOkTR2nTBw0PjUyIOHD28VwPT9TZbggxBwiE9cKbpZPY1fPVoBHhhvbYoTUX1tkqjGqFBY61vswaIp5kyovtcwjZNP5zdviHtJmlR9qigiCy/dm/3iDnn6eRKEI4snHDMNT3Ls65iQCnf46203KWptlDS1UhC+TR5xPROzDsqyymkXCgTqdvJ7m9UfctY3eYTEj6moxKn+UIshXfvtlXQgwwns60//UpG0abbGah9lsT7lz8GJbsUt3PrAGGHc4JXO9geP+zI6F
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 644f3fd6-9258-4f09-1dc8-08daf806f3c0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 21:16:37.1948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UD78fC6JdXM1GEJJrymVPwKR5DBWpmb6ZstXFCe3tUdc2mFFBpcpPSumtdJZdUphYXJO12GyqOiL1BmT9Xf/0tvSdzg2DL9vTzTERHosaDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7292
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_16,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160156
X-Proofpoint-GUID: gch3lWVE-sUBFqFieQVa4VHn3pQMcB3U
X-Proofpoint-ORIG-GUID: gch3lWVE-sUBFqFieQVa4VHn3pQMcB3U
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_cmd takes a pointer to the scsi_exec_args struct. This fixes
a compile error in cxlflash due to the driver passing in the
scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxlflash/superpipe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 9935c47712dc..22cfc2e1dfb9 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -361,7 +361,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
 	result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, cmd_buf,
-				  CMD_BUFSIZE, to, CMD_RETRIES, exec_args);
+				  CMD_BUFSIZE, to, CMD_RETRIES, &exec_args);
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
-- 
2.25.1

