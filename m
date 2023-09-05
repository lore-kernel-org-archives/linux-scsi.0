Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5FDCCF9E1
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240049AbjIEXQT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbjIEXQS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:16:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A586CEA
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:16:12 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385KnrDB009449;
        Tue, 5 Sep 2023 23:16:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Zq7qNAdJZjgzIEBP7/l2W78FJ5pHv0OCfaaegkaZTqs=;
 b=xFi9bXRP6EsIpVypbFm2BTfOwoU3w2fFWd++x2nJhKx5eoLz1Vgrhhgyp7+qUeXqbi2k
 sfuvJZQ+QHlyCIxf8ebHJeJ7GVxqBLN3Njx+VWyUCTAXZJ7bHNYyrja1+kyP8jBavJ0p
 G1oklz3IeVgOR6/TPgFog3q2KY4OL4j2RVf0d4IspG5s7Oj5wtFM8qKHcuzdcPrYTfts
 0oXkdgx2hfx0PSipKOBUXAuBScAXln034V74mx3DAzc80dlDEPnguNNkbZ0DG/Z7W5/4
 S5P2+x/MYODVuVYgVuzTYsbrhTKvu0Ng0611rCrTuuhccKC+RrNDu2S4Or/EOPv21g6N dg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxbq388x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385LV2Uf007675;
        Tue, 5 Sep 2023 23:16:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5exba-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4HGIADeZTS/MYmf2XVAiO6xDrRc8Q54G0JCo5MIrWm0w7y4vi+hjMtiMTDLiNnC6UwciY34r38BhocUZUI2cFd5MNXpl8ykJ0kObL7ylfJuB2znOxP8Kcip/EqoeNzEH+Gb3dq4gNwxjOwV/3s/aTLKlAsoIx0M6kPLioSchNuXo2VzdFYv187YEyY/IUE7uVwNOqa9cj87CvItDcGeRTPgb2IsLPxc24Du2a4Mjz+Y/NzE4RyEmZx1ZLX4eZWWCQOUFY5BZQ/Pd3SzFAz1zWcoG8N+Unti1dFqYFUmeDgbebQnJHb+elUgat095dj7/3IcW8RpEvUdWVDF8q3Q/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zq7qNAdJZjgzIEBP7/l2W78FJ5pHv0OCfaaegkaZTqs=;
 b=ZPFH6br5k7cLOMH/DJo2a0fiWzRFYYX8LxL9NRRbcjceAgqBKshqgyivfxWf4QMGWxKlfXOB+b/C4o/pgkMtQAmu0uQEEJNznMMRFOCVcdKqvFTLM05Mbq1iUzUKfxjh/HEsmPM1KSOZtV8WA5sMgxgpfmfHYIi3IMU3ycibgwh5qiSX+SruwXVexFu6RprZC+IzB0GIuKRBpftQbeb3FglcDQCv5tRGAdK0sCEpbHoTcg4SgwnfiEcZ2sZVLbxxOD7bkf838JJuFEoFnssAMSxgUys6mAD6ucLPHRlB7MMRBYtWz6Fb2y/aDQA9OsrZPU6Mz16He3JFNKzrJDl3Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zq7qNAdJZjgzIEBP7/l2W78FJ5pHv0OCfaaegkaZTqs=;
 b=dh+bG/uv2aRKTWnOuLL8RNlYeqA4cBqjMhliHYLVkRi4o4w18eLxw4ziUfa04uuEcIJYplR8dr3C08WHeIFlOMdEj55r6LIwRyeI3w+lV2pVuewPKFnda3ZG+oyQEdjuuwbRwZyKsQLiNoeOcQmkb6OXqfiIDfvB+pCCWvlVncw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:02 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 08/34] scsi: Use separate buf for START_STOP in sd_spinup_disk
Date:   Tue,  5 Sep 2023 18:15:21 -0500
Message-Id: <20230905231547.83945-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0015.namprd08.prod.outlook.com
 (2603:10b6:5:80::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fd389e2-d937-4656-6eba-08dbae661229
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: maTBvnIxI8w2eaWEHBr+mY88cbB6xWO414ZxY2dY0+r/U8EYsvJXeDSJ/b+1f8BuDNDkTHYmoLd5MJlARIywMbOK0RHvqkC6fgjaXwA62B/cj4ay3Y0L63UMOZ79HwyOkMmfhBeWm9MtfTuEAtuuS4zffe+lgo43J22i9Zzwah4qHiNqXXSoiG7uX7Ij0hLEr27N5DkBnsCQlI4aOJy+D36ySnj9voOFhYht89oUSvYuoyPkQBriAwFTraqMHZknAyQ7akS34PnGue2rKgpdmOKJK5BfVlomGZe5qgaO5xtllV4vqx3A4TCYh/qoFhUcv9VY5zRes0IvU2VeVXQh7AbxYveOrXzFuGluRiyCK4fB9Ub2i+jAHPMw2o0FK+31P2Bwv8t7b6pCFZ17cGbaI669ZgnA+2lcJawxv0iNWe2qgzSA5OnRUabZLZ/0XtZi91u4p83mM/rmEkXyS9/zYZf6tVuoSKA6Zmo+RHMW82uuPPDlauCLTWLzR3IgydBDABEyCOPAQ7LeiktSNAFYHsXCkTNE5qQD8D+yBGZ1Uf48p4i39Q3Zensu2z0fR6FD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PoNDpWgUC6zwvNfhMr9Fjst88J42LJxhkzNW3sIkR+Qhy70Glb3TPto1rnjZ?=
 =?us-ascii?Q?9Q6yurdSf2K4/4DGUDn406Fzk+8COdSdOpCkOgVUG17FYd6iq74KJCjrE4RE?=
 =?us-ascii?Q?xu1+FmEo8rhYxBgS4MJLGX+cSm22pHds4d78MP1l1g5yz2mMN/g+NESXL9TZ?=
 =?us-ascii?Q?Gtv7kioqd5TQBoJbuMiHOnp081OtGOj030fPUvspxL8m0K1WeOjvCphF0Dz/?=
 =?us-ascii?Q?eKx9KUBoWkWQA8dsJBxE33hVouF4zCMefak+aQgmBiSly7Xwt/C15yNlx43H?=
 =?us-ascii?Q?MhHdhdzoTZJrVdGo205+cgLO4uUcwe95Vfj95bx/x06X7Grg5umuQBtuhstm?=
 =?us-ascii?Q?ZgsNDippLdG+IMscmnnJC24NOZ9UDnP0Ec/O5FIHVVIMo8c5sNQQBoJo3AD8?=
 =?us-ascii?Q?/As3ZbenHzGC+y3j8/hV5saQesqTT3Pfo9AhH+popJqrfoxgTh7erda8OwAa?=
 =?us-ascii?Q?zv+DkVgFZoi2LliljxzMnAgeTO+hyHGyBTAVEjJH3DLHO3HaSX+tEiieCH5m?=
 =?us-ascii?Q?lmB9QJGqwhDSIRWW43IiA7mjqtoapku9YxoSgulbx/a4wIvhSg1nYRO9r0Zm?=
 =?us-ascii?Q?xdOqqH+1EGeeREY9IejczRRP3bzo3OCzyuNK2usK03qPsiECBIX5ewsFN6f/?=
 =?us-ascii?Q?L3fbvduRFqVBAR+ZpmKKpo81srwQOEtPj6XGkPAUNGFigYGdmkDyiE+JcElM?=
 =?us-ascii?Q?LdIs0pH0L5ex3n/mjagRE+NVee1u8R72pmt9ZL+UQ++DbkNuWhsv0y52X1UY?=
 =?us-ascii?Q?vudHQL6/BwoTUi09WQAVjpXktOTFcpytL9SuNA85gN8S+dRTNlqNm3xY5SXD?=
 =?us-ascii?Q?Er5hrlUb8UZ5LJdn+Wzyz0yTj3JNz0732geA4bnqN5qucQ3sEXCe+n9ZuM69?=
 =?us-ascii?Q?UNXrChZ7ukw7Xl1tTzOUJS8Y9NtmL8LNBXLnYZjl0uUFiPGxhBCg6wLMwqIM?=
 =?us-ascii?Q?f5hrfI21oP2TIs9GjH1W8CybQKCws++IR4HlLO8HkxM1nThR1EiwzKdHjFRY?=
 =?us-ascii?Q?UIrtiTwOWLJ/omVDHc6l+0QoVZCJ5L+xg1ZlrEHFP/Fxibg63Xi58kGgXAbb?=
 =?us-ascii?Q?+8BjF9roEwBqK0eA6ieVtNbG+X/5u1E7suRIAsDdcAs1lfaWPOhhInYIu1Mc?=
 =?us-ascii?Q?deeGHSfjSKvwVDxOqKOEu4bvBDn8dfvO2LNUl1FpOIdJoQRgvejTdBhz7lsb?=
 =?us-ascii?Q?u7k6SyrchXMTxRkKQO7a+JS1XkSBpcTnMMZmXbb6otboi6Qw+JkkcSaxfeQ+?=
 =?us-ascii?Q?o0uAuubE5mcM2wc+wCWU/6ZHB02VQdTAjG61m4d5ffj7Cnx9Ydr1KrGGYDjv?=
 =?us-ascii?Q?/NORQykGmEAqcB95Hl6zJvN7cvhhytKIcjh5mPMh/+vQlLZGQfTkYJb4yJQC?=
 =?us-ascii?Q?U/rPO3kZzOtRyCrSnhtCnG5WbnUwX3c75VUQ7Wa1yKXZKDH5EyD0eTLOh7Fb?=
 =?us-ascii?Q?O4P3i3lvv7V8hRtCG4Ar/Clyp1/wmNY6YNiFotzogKIaN6Fy7OLKVbvtgbmQ?=
 =?us-ascii?Q?/dFnmyB9LigCJriF/ADq3kY4ffeACAZGKGpRfi4ln95XK5wxS443mYUULFdK?=
 =?us-ascii?Q?YQxezUJy7tmV+1+iJmsZYDoq79HH505+ySQ1QYc/vv+m9qd9IVdPt6wckKsd?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: aM/M72cbXK3tm3FrtzjPS6Knto1tZHh80azP5qGabDGyD07EaXyL8gvp6wB7pWtrM/QykXm0gIAZbk+hb+SVxNI48VhfH/+jzGKaYnjG51y99F2syAtYRcmxwsc+HWzt5zBqklrawHTt4FYTusKx3KnsTN6fn/+6b/nsMoQyP/TX8q8jf8xdVZl7ptzRbUNWUN2WLhDkh07wO17UtRYTtsCr9hndvZDxs0acN3hWGjAZP01LZEQR1YN08SxNiAwVd87fbyanKjPFbZ23YvfqcxmN5LwtYggKSMkU+4+qLD96xUeen3q9rH7t2gPk3CkAT/h4/viWbGsVI1W4xmidI6k8v2+kt7uqWwtaIpyN7b6hIgqqJ2PzSsTdU+dGY9ynPxkzMlAzA8hF2eRUVMI/aF0d+9lG0oTwy7MVpMgPSrQ1qHyoO/2olo/+MpaJKsQQW364/12/zQJEHlhIENLmunj/bH+Fsj8x3NXVvFdfZPnX6tzbdAn+7KsRhBj0HEFyyMtNRYP3iaGAz+HOD4nhD6ie+BZ/cIA8TZHAFg1tRMn8CAz9V7DHTEYeUkmeq0JeE17EqNiaQzTdTyEmO6TRwuC1ZjT/EwsNoa5yiRehwTHKmA/Y/nqxLEOG8ZzRu8NXTPu1VXRgUH092Os55hcDATgzrZ8BuCyd2ghJmqbpi1F41SsP33eeM0yckhLoD64ozGgfdz1IIfSpA3SDJLiEhURhAQpZ+8PYKktO/TzlGLo79LUSkjfL41xjNrknFVg9zj1wKwT0et4g/C6u+1WqKjrUeI+qJh6v0lVjU+8h5kppRAhPSmipELFhwfFw3E3e1xaIsIn/lR+B1CUU0SgO2B+5NkwxXYu+Wnak55SM5LMfCvJV9AbaWB0kGf8NvFwS
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fd389e2-d937-4656-6eba-08dbae661229
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:01.8940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uhUOdKQ/FfMUHTenLFacxdAY6M/zSte9VLqiWsiosQ7opg9Kt+wtNfUYR3sK7KOGUv+IsGEi76MCwBhhtQZyxX//VN15fSN9CCfwgEjPJnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: i7K9oqwLct8Ut7TN7RvZPgGKJ85ul6gt
X-Proofpoint-ORIG-GUID: i7K9oqwLct8Ut7TN7RvZPgGKJ85ul6gt
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
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 69188b13f5e2..3aac3041c83f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2228,14 +2228,16 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * Issue command to spin up drive when not ready
 			 */
 			if (!spintime) {
+				/* Return immediately and start spin cycle */
+				const u8 start_cmd[10] = {
+					[0] = START_STOP,
+					[1] = 1,
+					[4] = sdkp->device->start_stop_pwr_cond ?
+						0x11 : 1,
+				};
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

