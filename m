Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071E3CCF9E4
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242485AbjIEXWg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237641AbjIEXWe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:22:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CDFA3
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:22:30 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385NLCKm030763;
        Tue, 5 Sep 2023 23:22:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=LHk/iC2TIzWyESrt1XKk9AeiPSyTJ9Nr/G4QaEK5XHs=;
 b=nmH4jLHuVHGD0aEBSZT1aTgnhDRUJTqzUehOEt4cs9knd34K0ZQhW4EqUpH/UMVzDEvw
 WxaP8vy0FoHQyxkxDKPH26VjNRtymRaL5weJRVTurRPxv+8lzSRShCX+g+ex5kop0k5/
 sgGgTFmcJ8InO/fAr/m6zWnmM27GLYY509er01A7Rw2CdSGEeUqnvikgTfTYwQvHftRH
 B2ubpFRzDYk7C+X9zJzG2c49oxW/yPDOgbqexhkry/ElhhXuWCuUh0r348FYMDYY3DLw
 bcydR8BHCVgBcZPWQiUk0ouhG0QRrXEpk220JNzoJbBGg/9esrD035bAie1p5iFM0OEY yQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdwu800r-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:22:23 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385M44fu037052;
        Tue, 5 Sep 2023 23:16:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugbpct3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5QicwtY4K547y9hBnf1HcY2FUbGWBEEr1XeI51HLwtajVMbyVnI27KQKFubfClSr1rfp/WCn4CAMJb7U1ODQ7nx7s1Lu3EWsxOknhDlNdofJqy9zIFYQtl9v5BJtjXRRXDwP6frQwpPKIEM+8sdNej0ItMJiyZiaPNubk0inVMnsTd6uUpia7RTPmOJMAeetCaeXcFBW5U4+IRa2Nj10TyC0/He6FySi/E4QBY8nZcft+WqlJ/NTGoYv0CmAoiK2PCo3DN05xsqPgcwc8+39Owvu/IRtXeoCHBzuC3IdhtrRkb/W/HT4IpPazYnzAaBAcUWK3LIFycqEGUDpStAPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHk/iC2TIzWyESrt1XKk9AeiPSyTJ9Nr/G4QaEK5XHs=;
 b=AiIXoe6FdlqUoC9dAocZxjCrc3F41SlOktqOkTcP+to0EmagEnX9CrMQl1XX06D9k0ZDsCtJTqq3EJ6/0A74PVSM4p0t0oxEQJq2eui7Jyz3SZKG71Ca3NfL+wkry6SmMp1YMQdbhA3NiEDQG622hvQIhBLj063rJbMKbxwMc0E6yUW6I0HR2NSQ3TgPGZpMtEVrdgxoDece80JJVzCtHYkDDTXyCakSiDwWAHqzp6nX4pDwNMbOVV+X2xvbSLl8qc3IWzju1wQsU0TgJxY8wRbrduZ1DAqjg4XfhgJNKdroqty6fGVs4lcnOyJuquLrroCr065U4DqMIsFtPFdbFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHk/iC2TIzWyESrt1XKk9AeiPSyTJ9Nr/G4QaEK5XHs=;
 b=dK0s1Zag0LYo40X3tPKI+fvCDyMbBoa8zoCbYs8KvlIG4gLuT2tLc6InaDgeEmmM22CmRqElKupQyY7XMDN2uUtGoxRQbxPGzB8EnNsNyBXn7DltxKfUAzfKRstSNdPPYzCmTDS1WxIIgoBJkA0D2/a9nAM9K1SUSJcf9us65YE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:24 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 18/34] scsi: sd: Fix sshdr use in sd_suspend_common
Date:   Tue,  5 Sep 2023 18:15:31 -0500
Message-Id: <20230905231547.83945-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR13CA0031.namprd13.prod.outlook.com
 (2603:10b6:5:bc::44) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: f80f1d77-ebdc-43fc-1172-08dbae661f74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JuOQHVotSrUrgQTSh5xfedwV+zIkorwBiWCN6E0F+s9+g/KX3A9SjKxIQL57VZKa2/rJiDKjIVFbRv2d9x5taxOUd+u8LOw5N1XwfJvz08PcpSccM0VagO5uN43JZyGBTCtF9mRRXhxabvlpeU3LhzzD3iZmKGdyN59R/7i7RKkFlG4s9Qntp9AG0tCUANPFpNsWgb0fNIjcGorzOY6y2Wiqx6Niem2fP3ppVREXx9TT+q82gvQTIFu+3cic7fucGueQkphnO0PGv6WBjaXrgGQyiE0NQrh4KhmFwYrgIJqDw/gMSgvVkrNpXZch052y+BBHPd4NNq+gVyWL3Mtyn2qBln+iVD0k24KgzZoYyPY6+kerT2J5qifwRV9CvOebCvcedTP5LxYY3isMXMQrfqveyBSZ1UPl6PIIXptKyH4dUEeSSrY1disnD2/oKOFUQUNM6cc/2FdhjjH/30pjD4eZE4sCHycjwtOEitdsASnYfp9yHh803tSTlmsfKRTIz9flalIdrnvsmwQoUtXYLX/li1YYC0OywaFhskGFKiYjQbLsCZIW9DNFylGHRBhe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?12lTOHiKiiCrzr35Cgz0dT45uOgAxyZTVkiHi9xInAUnz4jGCHs9DClrAlFs?=
 =?us-ascii?Q?G422SGfdJLA0DPYqP5ly5CIw1RVFRX9EciqOht+VEBvu3ZyIRBjZoby8QqfY?=
 =?us-ascii?Q?XHFonjLK6iyh+WoN3LvaXyFfWIvhD7W5seC4rE0dmHoYmywCBkLUuNdtVmwu?=
 =?us-ascii?Q?4EtWQ59dsNmJR//Twj3J9t4sh6cAQnnaczRyLze0kcpOZsRjGFhvT5piKxz5?=
 =?us-ascii?Q?N5t4wqNyMvAPXy6hYjCdzJy3Xc+jbAJIlZxd5FY+wXwPsBDAJ1ingCoGXzg0?=
 =?us-ascii?Q?trPSeMZDB5sLiJo03J8p/97VufSmjJ5/BgrCLYIMMr0XBBQsm1aQ2FiIjpSu?=
 =?us-ascii?Q?dlVz4K0PoVqhTV6r+9fVP1xzt531mri5DBDG39bLSyiJRFIjDgUE3aO8XWur?=
 =?us-ascii?Q?qnQAcH95EpqpCZU3zBTsqWFmA7kGro+NFdG4U/7Q/QOd5UqQkF3NRx8L+Jia?=
 =?us-ascii?Q?BU0fSlK7U3JjABC50DJV0D8ChZsDkaJxtoSTjKWnaifQDQS8G6swbDBrbK1P?=
 =?us-ascii?Q?4l1JMmm7p3NFx5TZD1b9nmQrhqO5uPxiaXAZBkeRt3x+UDFvyN8Kz0TQ6gsE?=
 =?us-ascii?Q?GpSn5rQ6mUYevFLmzIve0pjw6Z9wCBe5bl13kIPu8VMHXlm6n5xo8YOXAFxO?=
 =?us-ascii?Q?WHiftCfU+VIXN1bAVOcUk7YguXs8DUycJKai83sFrKTNgV54UzyERx7+ZXvo?=
 =?us-ascii?Q?vMpoM8SzzSG4DI2Yq2RSzxAmnvydXHGAoA4KkPPW/JKl/CIG5+8d9KspfqU+?=
 =?us-ascii?Q?N6VC8H5vDFh0EaATOY5/cvYZffqcO5pn3yULRRKw0uvMtS3Mf+Bzxg5Hn2es?=
 =?us-ascii?Q?D/alCBZVijWqH8icH0uwjB6ZB3j+Szcrexp0wOkt15khVvLHdDkK4IqGUeI2?=
 =?us-ascii?Q?m9S99jO+fGlyDerNHLro9+L3YtFsGVivzIrZgt7wJe7LaNr48D5tiUvvcRgW?=
 =?us-ascii?Q?p9g8uIC+VnlmrZ7OlH1Wpm/jObue0pC0n8V8M4UmbDi1wvxU9wK+Sb9U6fW0?=
 =?us-ascii?Q?Iz/tGDlW1pAEl6AI7RCvCyAaC7fOvKlsi3NnqrmLEJnZ3DrChFkhcAZhT89b?=
 =?us-ascii?Q?9XogpQkHl7o4sft46sW/8lJBNohoGBQ2cLWzvgPdHB75S+RnYLE2HSb5R3QJ?=
 =?us-ascii?Q?pad+haAsOKSqWIpc15MgZpAiSkLgn6u+UvSMVTQvzdYtYnXs9wWIxPIUb+da?=
 =?us-ascii?Q?2i6M8WktEIkfn3G22b22+wAPdFx96uWruTFiBNL3CVOx+jHssgTweuSbn36N?=
 =?us-ascii?Q?2xXkr5VVJy8GtHSaW3xg12g1jzTmIh6+G/tDv8MW3mTBz4BWhWdiTlAdGVDg?=
 =?us-ascii?Q?AfkXYeBodVfR3l8zOOu6x3GcLQqEtAdP6yM+SKmkPA7iERwzY/KyrWlkNuSP?=
 =?us-ascii?Q?eLZPPB9MXgDzRvOC1p/4OKGsit6LiTPTOCM8R5YYwk9tFk/+Oj8REey2Oxkv?=
 =?us-ascii?Q?ZGrb1uT+b89h4NybjAST0ACssfrgoz9+U1SKDSvrIPhjt6OdN58fRk938Ls4?=
 =?us-ascii?Q?f4z49wMm6Mu5OHOWgK7GDQUhToL2h/ngLExnlob8JiTSZ+qK7hAf04nw/bwR?=
 =?us-ascii?Q?Ev1b3K5q3LeHat++9MeykiCkzaJANzNFdm5pzXV6XIBzsblgZRsvCf9+NvHo?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: TodEu36ueLt7A7N+vd27+XSas6gfcx8z1gCtD/JLY9lfePVtQS6y/e2dDz4+5zOyTylbz8dAuRF5s8i7+Ohwa7SumSLRH1VMLtccjsm7sfuUpnKEoNhi0YXtWI1QNlGvotxU7nDOyKxQF9b8yLjZjwdwfZf8hGoMtk04UlZxObEXnSi5566MSQkvzswgJvESL4+OdNIAeJpMlSxg8i0caKSvHmox4FPofZBS1B08AwTWoX+AvDycPWR/+MlxXzHmctWsE2JlBlSYIpicVXwJHQTfE8mIOEeBZqkmGrLAjjZL/NlpBE5oR7QG50bwtRPMybfDo8wFlwPrQYn9Bf4Rf3s+2KHmlP+hIWeXkd1vkYql8in10I1xSThTRFuhCaEClTogDuasEm4CR8VkM9dIxTo35cD0NzEV6eRgAszA2BmHOgu6dGowwVm7e+TGdhxtfDvteHxogFc+KeGkEcj/6UxCERZJUTktl/qS94D04x0l5xjoK4QZ46QwRznnWGIshDCfrjHrh/86qrZ3Q8R4ROjVHwYIX6sK8/hGeBxDNwJvSd1f9Z3NyYwt83TgYyoP/b6Fkm8kWo3/Wtl1PF3vqd/tvua1y+kA6NJbMhPiqQtE6LTYxAVcz67k8enizRhVtD5yhVE2y8eAVt8L0JmzZvw8EadWoZTJCoTHQnWxTS8BUC24JYgkrOlWm5uzabRMwucPrQ0EEh8pUQdNScDbhyfQS9HFLXh/6ha/gmTiCOQqeuNrbifONJD9NNSeojRq3SVLIlMXj1KS35dRdiBxIKYvYRrqobxh3pzNqU3aF+mrSB9aT0oRFITXEaFcI63sbROVfdKgC+GXs0zu8sVV1yvxkuPLStlowEIMhB4Otl/pSQHUvsp5qvJLCvuvgmix
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f80f1d77-ebdc-43fc-1172-08dbae661f74
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:24.1817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: STfry1AHv2i9+jDqvH7+SXeVk2XM0K1Eh653KqWg4qL04wXl7CQafGK2fIQPdA5DeGe/0ig0gDa/kaPFv65T1o3ihW+6JcKEzvveXNcSVsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-ORIG-GUID: RkzzFp4o-nqXnUF_v2kR_sR3WE_E2Z0F
X-Proofpoint-GUID: RkzzFp4o-nqXnUF_v2kR_sR3WE_E2Z0F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. sd_sync_cache will
only access the sshdr if it's been setup because it calls
scsi_status_is_check_condition before accessing it. However, the
sd_sync_cache caller, sd_suspend_common, does not check.

sd_suspend_common is only checking for ILLEGAL_REQUEST which it's using
to determine if the command is supported. If it's not it just ignores
the error. So to fix its sshdr use this patch just moves that check to
sd_sync_cache where it converts ILLEGAL_REQUEST to success/0.
sd_suspend_common was ignoring that error and sd_shutdown doesn't check
for errors so there will be no behavior changes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 53 ++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f5e6b5cc762f..1f6cc24d633b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1564,24 +1564,21 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
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
 
@@ -1606,15 +1603,23 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
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
+			/*
+			 * This drive doesn't support sync and there's not much
+			 * we can do because this is called during shutdown
+			 * or suspend so just return success so those operations
+			 * can proceed.
+			 */
+			if (sshdr.sense_key == ILLEGAL_REQUEST)
+				return 0;
 		}
 
 		switch (host_byte(res)) {
@@ -3816,7 +3821,7 @@ static void sd_shutdown(struct device *dev)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp, NULL);
+		sd_sync_cache(sdkp);
 	}
 
 	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
@@ -3828,7 +3833,6 @@ static void sd_shutdown(struct device *dev)
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	struct scsi_sense_hdr sshdr;
 	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
@@ -3837,24 +3841,13 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	if (sdkp->WCE && sdkp->media_present) {
 		if (!sdkp->device->silence_suspend)
 			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		ret = sd_sync_cache(sdkp, &sshdr);
-
-		if (ret) {
-			/* ignore OFFLINE device */
-			if (ret == -ENODEV)
-				return 0;
-
-			if (!scsi_sense_valid(&sshdr) ||
-			    sshdr.sense_key != ILLEGAL_REQUEST)
-				return ret;
+		ret = sd_sync_cache(sdkp);
+		/* ignore OFFLINE device */
+		if (ret == -ENODEV)
+			return 0;
 
-			/*
-			 * sshdr.sense_key == ILLEGAL_REQUEST means this drive
-			 * doesn't support sync. There's not much to do and
-			 * suspend shouldn't fail.
-			 */
-			ret = 0;
-		}
+		if (ret)
+			return ret;
 	}
 
 	if (sdkp->device->manage_start_stop) {
-- 
2.34.1

