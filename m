Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69508C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjGNViP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjGNViK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B333E3588
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:38:01 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL3nup003896;
        Fri, 14 Jul 2023 21:34:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=nnccffaNIP8ZkmRsGLKj/rirb6+FSHHlXVHzCwgVhXE=;
 b=MjxpfKKh42y2+9diSPig/Qrk72YgzjlxKSGM7c3Qmcdw8HHUDkUbUDtGCMCbEc2keauX
 0zbJUHNlBomgr1kxUVErv3bMN6qb2aWtcwCDOkNeidl3BsRYQwgAQbbvvyH1Ek3ChsuI
 S57nY+uNVaPC/bXKF6ysSNHmygIKssNU8yhjef9c6gmLVaOUlOhbE1gVogfUscs5bqhg
 CQ4YGoAMW2ePya2B8HgiIytmjXa5M580FXZSfgAIGsxechWSPpADJmAhweSrLLCslaKx
 UetJ49NABYtdyo0fjOdbV6yqC1mkAY4mFUx+82/oo+0RW45ncwFbz3notKL/O/p6UX/K lQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtpth2dwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EJxgd5013858;
        Fri, 14 Jul 2023 21:34:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvs91u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwV/wS4pIJoj/SSOQBcxJlNzXQH8ifVGupHi99liKMvx6nHRMqe9OMF0mHd45emh49fTpRpFg+1pjvB2eem6dXMt05CLtm3tqqPpqpeSLQcBXFQGVSWSxBW1eAeiU69ahqhXQ4Cau0KaOWduQf9Z05SYMcUT0CWXdyEn2NZ5wEPSwEx+gzH3AhFN73AVQ/J4Imn5LQaOiaoocIH5DJJxwpp9l2ofbqBImn6NbR4j2iEFIKZDf2PuhGN3QEC0QTnKMEAtothf8HaDVPYb9rjYEUj4FbD84CWQl8IsApsIoOz4pt7BYfNUpUP0pCnXZzryDfP1x9cFHmPYp2fQRvbuEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nnccffaNIP8ZkmRsGLKj/rirb6+FSHHlXVHzCwgVhXE=;
 b=JbJqGlCSQYkuEJ0Gy3EbduiPPAthhbr0vU8AjoNLmlF93k+C8IE1c+2j4zk7JlIFuVB/jgWrmy7BYNUWAsSczZnneWA+at19GryMHRy3Plm+XiRjcnnWeXnEIdJ0SX/feHZmgKqflwdkvKehjdgf4wqr115cUk86rv95QvSqYuf+LtVQ24fSnKJN/HpVTNIvV6IP1CZfFe90EMd0O0/0q0lvE6XP0hRnOov79+sNGMMDGGGCzqSH6jJnSZ6FCwmB140iIbgHLr0JrCMmOkLun2Cr5kiBNZjhuG/DgAxaoGY/8FI0ZNKvkuy1gjXTROG4QHxVQ6ebFsvD/UsuXCeROg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nnccffaNIP8ZkmRsGLKj/rirb6+FSHHlXVHzCwgVhXE=;
 b=Yt61aPwuQbdPlW30GJFwzUgpwTExk3sQpJ/Uo6OEI6X5dxh13sPEWj7ohLu7Uasx9d+wKeuubMVWcc2xdRIOTuVeo3AfNSDW0y8sX69Kj3cK8lIfbQ751Onj/1kXMuuTDKdUYxNMyy0o3F20d1E57FSAR8Bq1jFlo8SlpPNqjII=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:51 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 17/33] scsi: sd: Fix sshdr use in sd_suspend_common
Date:   Fri, 14 Jul 2023 16:34:03 -0500
Message-Id: <20230714213419.95492-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0185.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::10) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ac471c-80a2-4884-acc0-08db84b22800
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kT+RcyVgzA64Luhi1mC7hfMvBSYtF94hmt2lzjAzc4xTAjBr9fPfE/38I8lOvKkuc9jU6tdnWA2yLnZSPMhdQoy7UF1oYFnMXXYVtObKtrLi6Ih3eLbliUofSrCplWTGeeMzMPFIWG9X6H9SJVbqbg+CmwZn/+te8Ta7E4926anQczZCgBa1QmitQCd3RlR8Qeuf2px/HNUXYV/v7y6qsKqoDCbZciMZ/GB6nzcl4nNDqBJa6xn6cuvb6qJX7SSbZ+cXtbYDeIH1hZbt+pHf5+3Hx+VIPDqjkjFZTq/qoniyTgrQwp1ataGMXDJvS9xqjOB0F6Vqk4hZ9fzuIdkUYtJZXq02+O44s6fJ3scD73bOqH1lO5C8Puc26c1vf/aAOi+7vcRYM/USFR+1iuBxPBUHxwE2aEWSQJpLuYtlG+HxRi3fUTM+VumtRL90B0YYBKL/3zNLdt2kwH7sSjBSaU9DOJN20TehwqvLhosyLYUFVDXHH/Fy3lKiJSU7lDuLz8BOTnq0xkdPiKkg2yZAu3dMMtmsFSP0JXHVDXw8IaDN2aWWFGw1ie5n4ppIcE5B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IfSCFVtrHA24K+65hvRX1ovzjEgLBFQX/fIMwXGvRHxgH1bD0rewvmoWSj5u?=
 =?us-ascii?Q?I36iy6LgFXgCdoWT781NtYlPAHn6wsIKGvypLMVIzj6+iQbUsLFfQY97iroT?=
 =?us-ascii?Q?6EKeBdK+npgNFgwvFr2lAKgGMhPm6kKRVsuswUa9NmMKY1E/xFyTaY1LwK6a?=
 =?us-ascii?Q?Er13OK5gzOKknHavCdiAV0744ALwol4D9wTwpoDMjMD5UYtJClEkxeIegoBW?=
 =?us-ascii?Q?wfADRdH2Tlf1IkqXj8rvGEJh3IERabTk68PhjH5maPbGVd0GxPBeoRHFZ1L6?=
 =?us-ascii?Q?Ia6KeooNKF+zol2hXtxCBql8Ulg5JIJ/ZT7nd3ze9fgnf2HUf70FvB4uDNn0?=
 =?us-ascii?Q?C98ycU1KIuixpnWKy+yUgsfdZib0g+i73XAA3htTPiUE06VczINfLkHSsQ2h?=
 =?us-ascii?Q?VIwTmlu9q9IoQnXrbHHoV8s6Q5XRQ0uzVPSkNaiY/mdh5fvKZb7pgGRAH3RB?=
 =?us-ascii?Q?2QB36Dbbt3LJFBQxAQooCATo6vopmknXG2GZQ1W1zeaZRO/MCNJEK6L2oAnV?=
 =?us-ascii?Q?J8Bjbi6PmXm3PAS+fLWTWCQMbID1jqodPe5WR/at/qd0s5qfDSz2zuEipDhL?=
 =?us-ascii?Q?dCC12DLgv3AsvXPHdvwNY0Qx/ljWZ5d4zjiaMtTLMrGe3ydt186C+dc4IGEm?=
 =?us-ascii?Q?Unz9ocQZBopaQ7fYszbCDSuifQdFHTzkmbVoPWOMWUcnxO8oqzwIJjw2MsQh?=
 =?us-ascii?Q?wnEqzDdxk7sFHquPlLM7peNWs0mIS2LFU71Q8E09qY2Og6WqFQs0/twSr+7J?=
 =?us-ascii?Q?EGPdy6srvJHPCGhQ1OK2AM7Dg/AkiGzVhY7USmSTATdjHirOir1/gH+ouHBe?=
 =?us-ascii?Q?Z/In/RXAinzc48ikiA3zgMMsbuhH63G2CFEY215rPN6HiaAEDcqaRA5UzXDw?=
 =?us-ascii?Q?YC4oWEhro4hN22c7CjI7tmO11U8dl/3WS+bk/BqbFW9WMpHCnRmRW+gCmk8q?=
 =?us-ascii?Q?38ESQHvW4jxyCHzlivb+JtukKsOENpv1XTymNc3bxw1MYjoPa8lKjpvEu2RY?=
 =?us-ascii?Q?BodBqMFmTFGu1COU53piTyZrXATpyCA0RV8HJRvG+awCzRYIDu4K7s2io/65?=
 =?us-ascii?Q?ikfA6JHZW+pHuqlSQU7unoliwaiTbO6+/ESL0oYAMebYnomzHx26wukifmnt?=
 =?us-ascii?Q?2BI3ok/+Yp2xaictRelHRT/N3IlmnRwRuPIFHzR3mhMD3jQH/yjOqGI3ah5i?=
 =?us-ascii?Q?SW1MJguR7LoFtzmsNuXjx20Ze+HYD7LxGYxOxaGDZOcGflQdx2KBe9RSZ/I3?=
 =?us-ascii?Q?mA+81ISxLjZyRjPMgPD7Z416iqOHVzEMyTGMU0BRxBmqBr8SV7sNpb+NCHD4?=
 =?us-ascii?Q?cf7ESda2sLqV4iUkKmCr6WlL8GjsZSnTuQzR7Ban2+EQXsv07HMTDJNiwo9R?=
 =?us-ascii?Q?SedRb2m1I+rX1DE8tGakV+/VvIgqbza+H5fOuJt7DqlRF764RPHwfRPYL8JK?=
 =?us-ascii?Q?WIWzNkdvuJIYUKHDP2joBQAkPatdTrd4hzvOerg7UqXINm3ekdmPumHSiTg2?=
 =?us-ascii?Q?HhFtnAO3BUUjPvNMQgG+wrxCsqNxhCHsQwJzJyrUzoqtMV8ycqPL9Nk/8zLn?=
 =?us-ascii?Q?DJGRsUKEETvDxYdJnB/nrtaWG79+t6QBTJbnvR8epDkU30rF/aRJFwdYFbJX?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lv/06fhXWSHPZQ6cxJFa8vOzcRUgsOZn6dnEyCvZweNPyTq+iFmXEwRFY/vSjBHZgzCAgjveBuO3Pzxb6WrKdyTqxeeWFjLdRZtWvzwXSYR/XaTPjrHTZa88PdDqqmHfyF51Qwvg5xCmOy7Q2FkbMI45BdWa337I8m2rD5rjbCfB7hnjspp/E+GxpNt7YwQenvIHhZgLIoVgGLGRuEsgWuNw5FbvLhB0wIOYgiXameGgGmtSJDo6cJ49UnMPFfdlI6MrE+1OgTWEOxBy9h1EiW2PO5rYPbkcJ0ZsXqJOk6pzBeuFhy6DmijTBwxYJnwQb0RNZ0vBQpA43IXTYJrkClX/pYzdB6VujOeDQ1QfmxnwV8uCsT3bYbfrdw4pa6pF3dqoHCSMA5a3J8xqwrLNqqZrnGdwJ2f/hkvf6DzHgdn+XUX4n2B9e/0RhqyIL39EMJHRs3sGEnIK9jpkN7lurU68uH+1la5gegCc/4oE0P0uTQCgttkr6tlyMMYbIzXvG0iv4D7wBxjENNeyQr76p+VXLMCJ7j+NW6KH43wMPqIFk0AWcm0YhOYMAcDzt/b2TbJOYPKz9J1CRd77DX1thcnPfAJ3R49fk+gdYW4a+IdjNSEuuxe/YK7YQQUD7pwlMCm7aL08tZmJsepN86KgIgWWPVT3bSo912nni6pPhsM3Wp/MlDiYqUU7W/WkaDSk3udms7YV+HN3zGz4L9OiIV/2p/O13wq5rbBakXeyM2S5jJe5vml63IwcfiHW0/acMF1ZTano+/1e8GtyFrSJQaaxoNE+5KPMsO6I+MWoxBrT+AAHZC0cnBQFPpilqVQHTtSi+KAV9bViHusvg/YqBjqfTGA6p2GCHgCFZWeNiWvm+s5FQMZMqPHHJRrY632N
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ac471c-80a2-4884-acc0-08db84b22800
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:51.5147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urNAQHDAmqTg0hRoQyTbgdFHyp07Qa7LFc8f4bGv1MqyaTAU9azY64SbnQSkPaf3unGMCpfwZ4KK2nddqwkxYU72Sy065JMx2PJGeYHAfAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-GUID: MqZiWnRjVMtdac0H9s16d7bB6VVc9CqM
X-Proofpoint-ORIG-GUID: MqZiWnRjVMtdac0H9s16d7bB6VVc9CqM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. To avoid where
sd_suspend_common will access the sshdr but scsi_execute_cmd has
not initialized it and to allow sd_sync_cache to convert
device/host/status errors to -EXYZ values, this has sd_sync_cache
convert ILLEGAL_REQUEST to -EOPNOTSUPP. sd_suspend_common can then
check for that error instead of using a sshdr.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 34a1149bfff2..1f110d646896 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1603,24 +1603,21 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	return disk_changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
-static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
+static int sd_sync_cache(struct scsi_disk *sdkp)
 {
 	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
-	struct scsi_sense_hdr my_sshdr;
+	struct scsi_sense_hdr sshdr;
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
-		/* caller might not be interested in sense, but we need it */
-		.sshdr = sshdr ? : &my_sshdr,
+		.sshdr = &sshdr,
 	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	sshdr = exec_args.sshdr;
-
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[16] = { 0 };
 
@@ -1645,15 +1642,19 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 			return res;
 
 		if (scsi_status_is_check_condition(res) &&
-		    scsi_sense_valid(sshdr)) {
-			sd_print_sense_hdr(sdkp, sshdr);
+		    scsi_sense_valid(&sshdr)) {
+			sd_print_sense_hdr(sdkp, &sshdr);
 
 			/* we need to evaluate the error return  */
-			if (sshdr->asc == 0x3a ||	/* medium not present */
-			    sshdr->asc == 0x20 ||	/* invalid command */
-			    (sshdr->asc == 0x74 && sshdr->ascq == 0x71))	/* drive is password locked */
+			if (sshdr.asc == 0x3a ||	/* medium not present */
+			    sshdr.asc == 0x20 ||	/* invalid command */
+			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
+
+			/* This drive doesn't support sync. */
+			if (sshdr.sense_key == ILLEGAL_REQUEST)
+				return -EOPNOTSUPP;
 		}
 
 		switch (host_byte(res)) {
@@ -3848,7 +3849,7 @@ static void sd_shutdown(struct device *dev)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp, NULL);
+		sd_sync_cache(sdkp);
 	}
 
 	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
@@ -3860,7 +3861,6 @@ static void sd_shutdown(struct device *dev)
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	struct scsi_sense_hdr sshdr;
 	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
@@ -3869,21 +3869,18 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	if (sdkp->WCE && sdkp->media_present) {
 		if (!sdkp->device->silence_suspend)
 			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		ret = sd_sync_cache(sdkp, &sshdr);
+		ret = sd_sync_cache(sdkp);
 
 		if (ret) {
 			/* ignore OFFLINE device */
 			if (ret == -ENODEV)
 				return 0;
 
-			if (!scsi_sense_valid(&sshdr) ||
-			    sshdr.sense_key != ILLEGAL_REQUEST)
+			if (ret != -EOPNOTSUPP)
 				return ret;
-
 			/*
-			 * sshdr.sense_key == ILLEGAL_REQUEST means this drive
-			 * doesn't support sync. There's not much to do and
-			 * suspend shouldn't fail.
+			 * The drive doesn't support sync. There's not much to
+			 * do and suspend shouldn't fail.
 			 */
 			ret = 0;
 		}
-- 
2.34.1

