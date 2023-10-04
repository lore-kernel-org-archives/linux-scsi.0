Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3545FE936E8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243974AbjJDVC7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243898AbjJDVCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:02:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6701CFB
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:02:46 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FJ0jC014856;
        Wed, 4 Oct 2023 21:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=o0MJR3MGYLY/0dELN1iGZSmHDYSeiZaeJq1jeiZ/M+M=;
 b=Qkcvdk76v6qIQXNndmZ/bFbSO5LP5JM7o8C6y0dQe629/RxLIlsQAry8otr56iYv7kT+
 BHuWmiPj+z1Xn+3Ck3MCS0eQnkvbYJBmd08TtxKs8uzuMk6CXmaO3wcfQCj6zWlpVDOV
 gMQYHoQ8klwbpgfmJT77x2W5Wma1aFpgH24VsldYIa4U0OV1MsqqyHQTfgV4Vwk4gyTY
 MHVjRQyNWi0fxONtPaUcy8Mzp/drP2QFmmP2jVHpLXGV5urw21m44HqpDN/cyphUqfow
 GaT9h/DtlJ3dhqbAeqrSPZ+/z5WP0X1hCVNU7ixag1kkIaOQWHzh7daxpKSY/Tj8ePMD ZA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tec7vg0cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394JbOfb009654;
        Wed, 4 Oct 2023 21:00:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3thcx5y47y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFpM12lXC4jJf2Jt6FZRoJKLJK/z7U883sE8pQ8aVqjjSca0WIhosZN6mjJIb4YNd47van1fKU0zH5oOS6qLtQSEpFg2pbl8dxppo8a54ZXpFuGABu83QenrBOdMpqqlCqe+j0Fv3XMk4/z4+zwVcaLiemvTGtAkQLnRpf7pDf/w0ee824IntH5yq7yWNUVn5mw0/pUeCbeDDeY5/gCTLKkHRCUREQkkEocEwL9bBN+eYYrmjhMWG1MOvlM5xtonPl4/rAU7ccS04MDtQeeUZFSyIOd2BZqpn3iHOCx/63J/5xJdPSV3ll44w81vBzGEIXq02mvXZHwUn70dn9XKcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0MJR3MGYLY/0dELN1iGZSmHDYSeiZaeJq1jeiZ/M+M=;
 b=ZkYLB0EMslE50x+jvDQ+V7YBgHXTunfD89jvwCvnxeaZRar1JrDUl/ut2CsXQk5FOiII/fSVwRDnwAoc/BkbsmkiyPvMUIimfNxg9YmaoQp4rbPmJ+OVkTW6uFCa9M14xTQaHXnfW9NCrsGnJ2lAbsvwQ3IzzyFC1DfM1/5jR61RlWaxL/eDOenwWiDj7jspTTm5y1/S/3sxo38icaK60faUJXSdrb3Ur5l6lrPv3Q6u1tyd0gh8CEpX23bdM3D4A/mXW07FQxrLduP7Eb35VacdcWSbeCnP+2CS801V68XyWW4ya1lqf1sr2qtRKN5Ru0PpHZ5rcFYSB9FbtxvhGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0MJR3MGYLY/0dELN1iGZSmHDYSeiZaeJq1jeiZ/M+M=;
 b=FhB8y5LD/Gqm8Z4CEhRlJfvp92No5YcXZoS3S/purQ1aGphaqARjjJKRYD8/uCddM/I1t4Egmd0KaHUchUk0/nBze+HW0/1IExd/8IilofLUZo7Z+Zn4z2iAS8wsNwvJ7JbGA81VbvIvxhwMCPsKlSKR0x7cmseESMgAiMAsFSI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7413.namprd10.prod.outlook.com (2603:10b6:610:154::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Wed, 4 Oct
 2023 21:00:30 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 07/12] scsi: sd: Fix sshdr use in sd_suspend_common
Date:   Wed,  4 Oct 2023 16:00:08 -0500
Message-Id: <20231004210013.5601-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0254.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: 67dfb977-3f5d-4167-7ff4-08dbc51cf12c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zh3qgUY8ELq0c0Nm3TSe2X/EGnKljW6mk5Hy1sw5wbYuHCfx1RT73b7bgB1zmYCNhlKqmCDREkqtcMro6bzC+TBJouzpUHJUMklXHCNg0cm9C+DiZslNIoq/dVh/sd31GI57oSI/rEzy/qNjll6UdU//P7woo7GPsS6zgnggo6y2TUrv95QodI1dIzQxSLpQcLIRgyakQG2AGJRFbuyPmVJWLoS488BIAv6eFyEcjW/tC8Gddq3F2YkiN/YT3ovXjzuxTNFZbPgSmNrjdnxLO4UsqlHyrDRgTSFHMh8fHzZXrmkIQN72FMm5m1f5anqjerM7dxNl42CN23Zzkv+IVp1aFrqgwv4lquQ0bcL/wS+gJbjXkIPKMe1YTg3YES6f35Rge3yzaN0RPeU9f9lDW3tzl2nB4Rxkk+fUw9TMO4Y5mSjxLS+TQltO5c9grHTfftCpk8cGQ7UMm6x9/mB61Rck2Qd0/zKsfik9admxmdX2HqRjaQeWPvHvaL+odzFna9PwOh3fTC1w/OzWWTuREtPcq/JWtYL5/DTUVPW/dRDAXVNGU5FHHUhiJKrgw6cT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(39860400002)(346002)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(6666004)(83380400001)(6486002)(6506007)(38100700002)(6512007)(2616005)(26005)(107886003)(1076003)(478600001)(86362001)(66476007)(316002)(66556008)(2906002)(66946007)(41300700001)(5660300002)(8936002)(36756003)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CHzHc4XB7XPKsaW/KBtHEOAR9mtxCbdWanBmnREamKXKZLRZ2j7OLhspCqUC?=
 =?us-ascii?Q?xbree4kMms7iWNOQezodUvYV96wO5IAyLsUlktKcnM4W0Mc1KeDK6GgWg9rw?=
 =?us-ascii?Q?e83O39ycVyorWo2esk6bP895xflFajp3zPUPgtYdE13E1ogYPYSoBf7p3q3o?=
 =?us-ascii?Q?ZBodyty3+Y5tcC7rlfa2VEqA8uG2ySpY/SzjFW5JOtpb/w6EW4nxZwFyaJD7?=
 =?us-ascii?Q?jzf7N3NUXUrxC7+ruBvX3zMPIo6CROi4/sA6R8MFxAY5kLj1rhcPDQQlq35p?=
 =?us-ascii?Q?qMgGwUZowo+oFF1G6d1TgJWJmcNEKLEEN1EzLXE5rcwi6CC8C12hrSBC6owY?=
 =?us-ascii?Q?N+UID0EC8bQ449hEfw9Vu40QooyQkshwgG6fvW7S5u5MbqlzhogMNsA15VPb?=
 =?us-ascii?Q?XDIjumr/3evgsl7Ao1DQ2bJ5EJUc6JSBWddOJKmMcqJ1DKYtMQ0xwd0BHdYh?=
 =?us-ascii?Q?+p8uZzicpKuOBuuivPwuq3JsRqe2DIEs5Q8SP9flyg06l98V5SppxmDocEK5?=
 =?us-ascii?Q?isZU6mRxF8tKIalNF2oSEoHMFNWUSby373kCLsfum4KCDPafLxZKAarH+7O7?=
 =?us-ascii?Q?6qf+QY2Z1RPQzL8Cnjscedm74dIOF3b5nEPJgPzcgJA+8f5n9yKs2zbzKUf4?=
 =?us-ascii?Q?R/1ynpNvHqp4tUjrgXAzkqNcfA02bED958WiorOvZfUXQjZ23WFEv9Vc/zm1?=
 =?us-ascii?Q?FS/7z4jFdBsgWCl7KWn8vMX4e2HBXdRBOp7x15kF82hC0ZM/2ufJSup4wLV1?=
 =?us-ascii?Q?+CLQvdEjjw4QH08vUMVBUkHRTFlyozlSb529AtXFvv9BvYw26/qQSTE3c0X8?=
 =?us-ascii?Q?umuyJReBDCrgepTwrcNtqsprb2zRL9I6Ae2TjkMNjAxUHc6Zqwd3WMygCMGw?=
 =?us-ascii?Q?Wr6RN3IOXsR/ghYygiYg7Vc5ngLraluiqrns76Zfrgicpd3OVhctd2cubO9G?=
 =?us-ascii?Q?deMZnUbSdrvtkr2nHFa5a0glX/vaiyj4k7gBMOQkFJOZJqLAJr2PYa7PlRDb?=
 =?us-ascii?Q?dBGDEjWtjzgEWAGClN7d7EPprDeYd3IhrCbAFi7PCdAjXFuliJb7GDIJMQZp?=
 =?us-ascii?Q?MSXkzWooqzTnfEyuGLiovNKB65S4WrKg2Tzd+3pIPWV352i9gWY6uthw/xN6?=
 =?us-ascii?Q?TcSHMKKW7m+yk7trCbETkblxo8HTGMCCbPMABOBXZwiI1Rs59DUHWJ7Wwqsv?=
 =?us-ascii?Q?kMYfaNQvox5EMXmiULzhuT0Jlz07RurPCeHFWBPQFd+l15f6hE0n+LQ6UHsr?=
 =?us-ascii?Q?+ol8OEeX/9v4e/1+ypvAXz24by8cwMlWmhOMCCAOxxUnnU1sq/CxhNO999Uq?=
 =?us-ascii?Q?OI/p4xfaGxTRzamR20RMfQKm2rPgGezrP1O7TLQnjxAvnG08ZDfshUf+qYa+?=
 =?us-ascii?Q?sTw2UYhAzGhoaGEKVfTSEBYTAC9eTfMm/aoveS42ntB86kUc/4cbdA/KjUs1?=
 =?us-ascii?Q?fXh+UG3YaoNbkN8frLcEyq09dErWKg9fk2XMIyXGbS3FqQca4a4INxfR6JeR?=
 =?us-ascii?Q?pYVc60mFIq8xZS9om9vmxceDdSBc5ZwZU74DC1mwH0c7IDJdlamsWzD/uzRS?=
 =?us-ascii?Q?WgDfsi0yojJDU3lj2Bsvrfe6jzcRN2UvbORi0Xms6A98UMGB+65KWtLWOxRq?=
 =?us-ascii?Q?5g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: egEJh3kq7CG757eoWCciLUPy3HF6z2D9NqU30Bs00/r+a1n93BYNhGDWEQ7cF889QZv0a94ZA2/2wBMkKue8w4fgR4jgio3XeTMwA61X6u40EfUuqnb08HFmuTY0z625XunNLTdjrfceskTT0gQkHg9mSMzbaw2TJZhUsuVfRINaWIc+HciET4eo9xIaoVTnU/oTawFOtbqGCu9q7ctfwIL8QnQGP9avhL+4QY8ExBsYPgTe1eIbC3FxFtZ1fT6LbhHbV3MZVwePp0kYHJt3wSxRVQ6ZB0IKqFOItn3fk3MmM4sni/MT2t3fM19VeFTGQytQtWT5myPj2XaYHi1hjtYrh1Ua/X0xls6LTn4wYLatct8Otj3FIzRmEQDtmkybiz1BAw5zL/AoN+cM0zJwFoL0PRXuL6BTFyjQtk6wiRRXWwwQRK36QJRl3LYpk6TeMWiIqnFe8ZviZeQZlls+tnXMaIAW9BVWmVvC1x9/p0KGC6skmx7Z9qlmKyHJqYhoLlSrlxe3GR36/84p8OCNIEDuvbSUG1I0MWIfSak3qvf54wr/r79adQ2GPl7orJW8TVGW/BohlNseMzK5usPk6MEdAryDCxS1tKkctgTwCXpKdasYN6euMVRLNvVu2/TVHP1nrtBqmvxeDw/87OpxRftU8Bl/PlxviMQfNTghpZ4ZBN2Bl50QSCerlm6W5nyNdzllUvy1hVE5lTuRfA8BkwQPTe3DUMOmG4hBdgGC89SEXGpZXy2tWqvu2MiMucQ+ko7Prrortxcxh7WorWFgG1zUnk9VsCUVivndI/rQIOB1EwVv3ROmyle5Q9ApcWwG94Wpq1ARKU1xZnh3D3vsSDrB46pyPnVHYhspsekhLInG7uNVgVVFyIXp4Id4e300
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67dfb977-3f5d-4167-7ff4-08dbc51cf12c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:30.0188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YAVNno142WETk4lryijBYCdGNKaKy4tTGNRgwKkKV//aIkLH6sbMU8V+agqtQDzyY9tyzZDFQ6bY0dcJ/B0Ve1voQdY8/rzJQD/z1k6XCoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7413
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040155
X-Proofpoint-ORIG-GUID: iRn-5pir3wEmNMFGEDtSQLZUBoCNWx7L
X-Proofpoint-GUID: iRn-5pir3wEmNMFGEDtSQLZUBoCNWx7L
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
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 53 ++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6e306fe8cb5a..6d4787ff6e96 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1611,24 +1611,21 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
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
 
@@ -1653,15 +1650,23 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
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
@@ -3817,7 +3822,7 @@ static void sd_shutdown(struct device *dev)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp, NULL);
+		sd_sync_cache(sdkp);
 	}
 
 	if (system_state != SYSTEM_RESTART &&
@@ -3836,7 +3841,6 @@ static inline bool sd_do_start_stop(struct scsi_device *sdev, bool runtime)
 static int sd_suspend_common(struct device *dev, bool runtime)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	struct scsi_sense_hdr sshdr;
 	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
@@ -3845,24 +3849,13 @@ static int sd_suspend_common(struct device *dev, bool runtime)
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
 
 	if (sd_do_start_stop(sdkp->device, runtime)) {
-- 
2.34.1

