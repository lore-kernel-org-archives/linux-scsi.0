Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64630C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 06:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241733AbiFCG4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 02:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241459AbiFCG4E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 02:56:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2BB38BF8;
        Thu,  2 Jun 2022 23:56:00 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2533AiJV010186;
        Fri, 3 Jun 2022 06:55:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=s7TiXyeIfyUugeBJ1sUfhbikzNNoui9aqCOCPKFZCxo=;
 b=ggGwlthBe9D9UR6Ojo5t4Cp1fCKtj0nXWxbDvIhRrXYnvW5cOMIp7SFN3W4cyDaXKkvp
 WZEcJupn1UAWv397/v+H09qInN5h5lSl0Awsj9WcDeEKoiNjFd9LXUPm+amU+Vz/9+fN
 owx0Djh5GVcp+eWKvigqpfYrzwfb46lcjZ00GIEgTf0Irh1KU3CuphRkMLGBQQrKNEpI
 HEEy1mlV76ghTFGp4Y9ESorvOJL3kOISo2wP3VAUAtLGcBALEUmBjiZWVCR89K9MXN0Z
 sTo1GYGQ6/ydHWQZttvZzGYa6y5+e8z2RjH2GFtVZWZupQb+Q3mPJKxaFzRmGIa2LUb+ 9A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc4xv7sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 06:55:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2536oNhc025389;
        Fri, 3 Jun 2022 06:55:51 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8p5nyqv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 06:55:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWJ9jXQsCSPrr6l0oDB00n9nK4QPAdPKYg1pto57hPI0DNmGNpyS5c5CePJacU9KZY8zvwZP/Q0F0FQjV+ne9BmpPep4iWGGKC0YQpwVSjphlUv916ER6WI1uYmYmA5pPV3nAZxIWGZVUSYOSgtHB9XFcX8GZPpAylfVgPjjzbuufUxu88FU9m7LRiSyadiBfFuJ+oIi3De0VCrpw+M810NRPEzX4iJTnZQLETVakbpyq8OyYpgWqkJI63JG3vBSbImNh4Wb7RBWi9+e718GbC5h5nljP+Up9BPZMiqbxmeSj9nWSQhgesCF1HfPzodrmJ1ZvgZs12bs6NZnSxTLpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7TiXyeIfyUugeBJ1sUfhbikzNNoui9aqCOCPKFZCxo=;
 b=j2JQGAcBsTe+/LOuZLKJn+PSuTp+gzK8tDNF17sIFvMKnAvkkG7YxaG9WraPTIO5W02KwTpe4sT5S0ZBg6eBZGxrBQQbcqWpEZpIVDhPFqGkMXdg8CpzacuFwRIELOV6VC7t2JxbAJQquM4CCjaFAhT9JmpBV6DG/r78HS/6PYKLUBXVYj/i3CvSWD7lsUuC5vxC5XY8w9KZ15bi9DX1lF03hBFURZ9hPOsfPvRDMSPENak7auOSBwvzUPrwILwyH51WSO0lX/Uyd7ygeMcf228XnaQnZ/8jYhmYPSmdHbqebNtuv33UiUdED2vF7YDD3eSSx1C2kYDz8miVkHQnQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7TiXyeIfyUugeBJ1sUfhbikzNNoui9aqCOCPKFZCxo=;
 b=l7MH4tAt74a/aI6bfdN0YuwT4Fy8UtMiFevAtC+IUSAyOkkU8687uOZ5EqQkOTV8ZRpLU395fU429A5t8BvvvY9j8qXOo+i4Cr+GTgY2DmHnwpN5ope6NPqI4X/mM8rY70nWWp6XRWgzwgPbpt1MvajVByPpHrdPTDuGzCOUTBk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2789.namprd10.prod.outlook.com (2603:10b6:a03:82::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.19; Fri, 3 Jun 2022 06:55:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 06:55:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/11] block: Add PR callouts for read keys and reservation
Date:   Fri,  3 Jun 2022 01:55:29 -0500
Message-Id: <20220603065536.5641-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
References: <20220603065536.5641-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:3:c0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3834d5f-bc5a-49ad-b456-08da452e176a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB27890E40C191E304E02CBE70F1A19@BYAPR10MB2789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TTw0BtoMvlrTbC/la2h4ZsZYxenE1okmCjtLrorXweFslk+QJTA3vMutGuMSjS021tkaOhiWt9vwUWgFYGgeS2scUb9bczd9A+iSii4TbBdM/5SL4U5p++V+FjyB4R5AMypzF47HmtF4uHxCLf89a6/aw23naioyGKpIS7Jpc3zL/ibZB36Y+RsUlv1IX1eSFacmIgi72QtLhB1hKlVrgEYgar+/hCKK4Jr80cUipw8SHJMQmlPtr92YffdMesTXoMyk/apsDPYm0A9e6EVRsdRGMlUUHRL0ocAmxJ29k9Utm+8j93sWjAgm/9Y3C3CiRMQ7seJnAHb8bpn2iALCHyhDFe9k0M8SjaeEXukIFTFJQnhakhj3fC1yuC/88CN4KB+CV/mCWbkuPIEBQ/ytoQ4EQ8JVKjo/x9nCHYSGGskIBUdF8ytPL34WCEUwrypwToCgkNKzw5JKOZdeQtLhAYNweLdQv0R8UeMmH/H2UrLHl/yuEsFx7N8FQbNxgO0k/HNvIuczm/PxNaLuFDgelw4heZxlwrEgXq9neUJx2c9zdJv+9Lcn7DBL6A1lz9X27J9RSM90s6fXxLK0l6W1jcKXiyIrvB663dy6hZ+1Sf3RuJGsrjxzWFoDRg81ysJkGe7jOvux1RutObF2dnrOEDs3hozeq3X+yHvlEHsu/iowsxNZtB14A1e9AseE6IzX8/Fbt3xbKp0v4La+SPAPLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(8676002)(38350700002)(38100700002)(66476007)(4326008)(66556008)(86362001)(83380400001)(36756003)(8936002)(107886003)(6486002)(2616005)(316002)(5660300002)(1076003)(6512007)(26005)(2906002)(6506007)(52116002)(186003)(6666004)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q7B+2KzXDdKVaa7mfc2pF9DubtoSL1H2ql7Uv5IUza3lSjNOEA5xw5n/XXiN?=
 =?us-ascii?Q?5D7amh/5blIHTXIc+PIL+aP1BChN2cyvZunCOCuwna4dFJZlcu2yWOav6mNe?=
 =?us-ascii?Q?G3OUcWZv3M9Vj18fncf7qPunJ138rZMUBAmcQdjF+4N3F2edP52BwX/FH6m4?=
 =?us-ascii?Q?c/Ao4qcalgC51PksYRgFVd7qhjjkIB5ZOmYvdiKLVrJRQuTmRT2C1TdRfCso?=
 =?us-ascii?Q?0gGXYXsME2Z+QhXeeWE1pYa+FkDPLMnYdnCxDk08WOaUjdYJtzKP4kkEQB7U?=
 =?us-ascii?Q?2uXXMOiAoBIx7UIepsOOD3WmXAtL6XdgpUynMAhjmAaWzFFTjHZOmQzg8Ckl?=
 =?us-ascii?Q?ss65oHRl/MEkjLQHLMbYYKSW8Ee5kK3wfQHx1syaFn6Pswap7vPgKsvHcb5C?=
 =?us-ascii?Q?ryBcF+ACpxvtzpjT/7KIxg1Sj1S/wqcLQc2SXK+CFhu8TYvxvKkd05t296W+?=
 =?us-ascii?Q?PBS2Pss5m5Xdjd4/M5jLwxLoX0mTgdgX4q2UOahWFUIpFjcFk3JQ5+fn0Muf?=
 =?us-ascii?Q?T9AP0N8Epe6Utd60Rix4SWjeA0BM+wFL1U49dREl8mOpXmmLc8AscK8vAZeX?=
 =?us-ascii?Q?RJykHQqDyVQ5KrJ9OFyX+Rt985CGRIuagTZTqBHWV/hWs5az0s34kEu9CyS/?=
 =?us-ascii?Q?e7R8VkzMZOdIEswOWRP8oUtdN48Qoir4eDatX+L4zVHTfcJpoqlKe4lXs4zo?=
 =?us-ascii?Q?v5WO4JLGVBjLMWBeTk2HbAY+1Jo5HpT57zvw1CvL0sZTiWNteddIdipy2Lb7?=
 =?us-ascii?Q?QT0FC2OQBE0n+cgez/nqZJbytllei9NYyIl41vDnyQjlJNkqWG7ZCajSJXM+?=
 =?us-ascii?Q?YWQk6J8kA3Tw/iFDeeAKfGYyeBNmlvkcVcPZ4EKaUtJJUcNet4BxTRPK7ghA?=
 =?us-ascii?Q?5qFWRV4b9TRJULIfoQYxO6wy64GR6qbvRjx1pvZzWRrVNUqz1s7xjtGHCfnG?=
 =?us-ascii?Q?IpHAo5Swjf5Ox8LOpKoAjAYIjHi4DTPRFOHrQ3aeFueRIk7vdieGBWvddDe0?=
 =?us-ascii?Q?xCnRBMIHC4sKJ83FJHfM7j1Kc0woCt4/ex1w4syDgah8p9h+DVgYwK4SU/IK?=
 =?us-ascii?Q?1D9l5OMX75vEHmKKKKw7Kq95xzJys0mX9e1wruAT5meZ1m+mjqVQkNr9h894?=
 =?us-ascii?Q?px2A20u6qE5QdpqPxqcLeS+K2ZBEGB3ZOZ9/kipNKvtzHNn4t1GANzXZpvN4?=
 =?us-ascii?Q?qJ4YqvWlx7aFrbzCZNMOcc9k2tZVjPoLp7zwfN+L3SVjgyIDF7Zucw3j/NW2?=
 =?us-ascii?Q?AGwpNHDCoc8gbzv6eGUFFJm7Q06oVZg5qGVsoG/q9l8Kwqi0Bpp9W2OqIcYx?=
 =?us-ascii?Q?jEQrs+oAPlF72xnuSK6tMQQS7Y1pW0qH38yHgkV69I2OVO0OMi1nFVNlF12a?=
 =?us-ascii?Q?ewAKvaeC6fwIIAU9pgCGbK08STiLE541OEXBQBjku7byrFl4sWx1+XGdpLhn?=
 =?us-ascii?Q?wF0Ie3JjOpaOxn0dqVaZAyv1HFGaxLfg7QZSJdXLUiH76HLBMX99BU1vD0S1?=
 =?us-ascii?Q?A3r9+8InjFihqzlIBAbBF4EjVyfeXpoonEWvlRhxOR3Eze5cDaQm3eArHhfp?=
 =?us-ascii?Q?DpXc8e2cyxVcrASfuErcZiDbKF+qGeAwkr3CGHyRhDDSIDor3es3cHyKmVHX?=
 =?us-ascii?Q?Pi03xo2cdD3v8f5itos95hXM2qTqPp+6lSR5S96Ua9I+WpUBh703eOoZQys2?=
 =?us-ascii?Q?SKwGIKUB0kEGMgyWlQTaS+qXzb+ysQ4vSXbV+sIHmRk8/IPRoIznZcsQt9c+?=
 =?us-ascii?Q?2op0p2fmkoVerBcNQ408RK3RxIsJ8ks=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3834d5f-bc5a-49ad-b456-08da452e176a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 06:55:49.1746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zv8EKqhi/AIaEwusXmn78d7CFPIPxuQA+PDKCFggltSppARlwUai73pDUzFKsTcZc05UQGyRSUvuzwEsMoAsBRoRHqLtm4mnx5z8nn5yads=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-03_02:2022-06-02,2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030029
X-Proofpoint-GUID: 55Clha1AkpeCod82uKrc2wirAmUI9ZKb
X-Proofpoint-ORIG-GUID: 55Clha1AkpeCod82uKrc2wirAmUI9ZKb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add callouts for reading keys and reservations.

Note: This only initially adds the struct definitions in the kernel as I'm
not sure if we wanted to export the interface to userspace yet. We may
want to refine internally for LIO and when we can enable it for NVMe then
add the finished interface to userspace.

The latter is not done, because NVMe's report reservation command is
similar to SCSI's read full status where they return a remote and local
ID as well as the key/reservation info. However, a lot of SCSI devices
don't do remote/local ID parts correctly. It seems that read full status
might not be used very often so does not get a lot of testing.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/linux/pr.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/pr.h b/include/linux/pr.h
index 94ceec713afe..21a8eb8b34b5 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -4,6 +4,18 @@
 
 #include <uapi/linux/pr.h>
 
+struct pr_keys {
+	u32	generation;
+	u32	num_keys;
+	u64	keys[];
+};
+
+struct pr_held_reservation {
+	u64	key;
+	u32	type;
+	u32	generation;
+};
+
 struct pr_ops {
 	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
 			u32 flags);
@@ -14,6 +26,10 @@ struct pr_ops {
 	int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
 			enum pr_type type, bool abort);
 	int (*pr_clear)(struct block_device *bdev, u64 key);
+	int (*pr_read_keys)(struct block_device *bdev,
+			    struct pr_keys *keys_info, int keys_info_len);
+	int (*pr_read_reservation)(struct block_device *bdev,
+				   struct pr_held_reservation *rsv);
 };
 
 #endif /* LINUX_PR_H */
-- 
2.25.1

