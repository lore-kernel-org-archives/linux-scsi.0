Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5A2EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241271AbjFNHX0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243451AbjFNHWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:22:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B58B2117
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:21:06 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k6D0023018;
        Wed, 14 Jun 2023 07:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Y4k0njxw1hdTy52GV5HCgvJiyjKOUrWe93X82nTIIaU=;
 b=fj/h+U6bF12gpHJeb+nT3v8MGyXRPunDE30NHOveahr+Zu8XGu3CBZ88nnpRuoMMHxGn
 qJ5cF8Se2PJRhX3ptlP/rK+415FOehmkBow5UnQYE3stKG3OQtuEqg76zVm8avKsU9Z5
 SZZwA4idaFOBRKaWJx9Rx5mJrADo8tBh/64NT1IAH/6ha/TQqMPffiqqgFMkRTe59Scu
 /WzJT3g1gXg4/QtszT1zwCPdptQi1zuBoNpwHfIQKcH6hYUQ17MnzV62ntBbrG0/iWtW
 5bKghWWLxldAKoRLbwuHX952L7wcmMyrkCkpgWmZEyeuFL0JbiLDsDVO1FbLbaLv9D9F SQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hqupw8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5bIXd021593;
        Wed, 14 Jun 2023 07:18:36 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56cnn-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1g7kCx2Biztm0WFAoXBHzBLZR5IHaRDDm78OmjY+zo3uGh+NDt+DznNxyuinx81n7wUzlJjGte9uJ/i7JWczJ0ACJOYL5HKjbeUaxLeAn+0mI1nBKyfx9PkNS+/ELBA2xZpWDVk24OMB3ZwYkRcT5gMlAEkvySX8yXuaLLkmHy9C3hp1Lt2a0CJ9/+4kkI9shGKBemWW6rl5LGQdBZkJCuJQyD3acenm/rXPtb1XrVU3snMh1K0REjQ8y2jyD9odmUWvL9xMzGT4/b4p0bt2TryYdXVzrU2TSpLLHwyOShXmdsrV9rIbZ8LhrmEkqy8x5sawWOLHxvslieo7aEfTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y4k0njxw1hdTy52GV5HCgvJiyjKOUrWe93X82nTIIaU=;
 b=O+dmyXJf2TuYVJQh/0l5DnRzisUBI1Mx58PP/L7K0CDSoHtHqWo37BA90B4kjvHyE8rkIwMWf0IUGXH7hQOfvYnNTVId7mfkbLJDMTAhy00o6PBfYDKe9vpGNrX4Tj/6mp4BqD1D9pznpxZP48Q+LHIl3iWIgk2UAzIV2GwExLiTSNOKQDeiAPZqLVpyQzw13/DOqA/3ouLJ5BfVVv7Hho4D1ovEYBeFlfsHvQ+RlFp7yZzwlmrrCYdneCZKko0wuck8G626DqS/wJUWfR55pySik8jkOBrhZHMziYCDQSujh/dQynxt1ZT5q+iejQDq8GCoEoTYBaycwglTVO1Ihw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4k0njxw1hdTy52GV5HCgvJiyjKOUrWe93X82nTIIaU=;
 b=zvXWfn0AUXLvkI9r+FqyGJtTZyt9qpmuk/Jgx+ed0hTtzTN5SNINDZEGsYvZvc6e8ql2rhflK4AZc3MZp9DNpxD2sPc5e7mzxfo+O2XyJijSV9rYlzSXZvKIlxR2+w2B+W6nqSdvOdKmV5cL+nkcsR0Ds7DrkpcXzRgEKjor5Bk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:18:14 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:18:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 30/33] scsi: Fix sshdr use in scsi_cdl_enable
Date:   Wed, 14 Jun 2023 02:17:16 -0500
Message-Id: <20230614071719.6372-31-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0098.namprd05.prod.outlook.com (2603:10b6:8:56::8)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 34684e26-6f86-4272-fdbd-08db6ca78468
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0caJWhulXBW1kSTi7i2c1CV0bnWO4Ep4jBd/q/+7U8WkAbBYvPByBMMEeLmXCoSSakIPE3ppZM/iXTXsmEfvG53J+ZvxpC0XahpuxIsEaeumZzwHNKmF761NgIcioLtec+zw7ZfxM6eBWhoPhiE81nLcyNL4HAZERrmZYf45pzaAh2axEZOdSpY0Hb5SxU8KAMf4jjW8faCpcXP4hdubmy9T1RE78T2ykHT+dSjsW/QYOwMBeijCu+7ovG2VaIEAmq35noJ8hZE3kW+RVOR/5QgV73z46jgix/8dgRBusp/n0H4/My5mW7frfpB02SRmvwxzIoejR8fttvEnwTv+KfsPaPRVluIYVewZD8LsGv4eRt0PZvFVCfZeNwYwMwbQAyzZyPxocpobzBSXjMaK4fdQ57VCDIcbaq5O1kf2QVVXtqmlxulMAQsx2fNQFf3iALaIdH0wObNNpyN/yd7OlVELoXm8VNQGqg0kDNnvCk/lkwAJXchT4eym2L69JTgguvt9W0+TAPv4LgQdyFzAJ5jjOT9vAmitgSQZtnhTvi9t6Ehv5QbxS/m/54KHXXsJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(8936002)(8676002)(2906002)(4744005)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hx0im/60F9XaJKzPIilajGO37SwLCko91LZ8HEraMMJ+IZcM1KJwWiPHwHfL?=
 =?us-ascii?Q?EzrxBWu+nX6zAhJggr1xrAUEYMZsWSOZuX6N1Z3ZDtx3QeLflCnrAwvWMVR2?=
 =?us-ascii?Q?P+yVLT1PUuz8sOIY5k8L4puo5gscPEDs3C9ZHRcfvk4aS2GrgJoAwfXNkvlj?=
 =?us-ascii?Q?xfUURX2lYjU4RUl+q3qEZI0zVB7HYfLFPeZifFdcOYPCiebiBow6bA1JrEZJ?=
 =?us-ascii?Q?gpIwf7ndjb7xopbYWohmcuakBO531B0cvYqrECiurRN1rOrWGu2pZd9U5O4q?=
 =?us-ascii?Q?8R+9TdYOuUEiTXTDH0T4ewRmxUAG1TZLAL/14huvVhIEeVwJdJRvXMsa8I18?=
 =?us-ascii?Q?Fw1XIumcIhaUvPdE7SgOs3LdbN09eIT+tCJz200e9zL49t6lytpqmheNqNa1?=
 =?us-ascii?Q?wARY7UwPIVyQF/rqYNXIlCX4/dHBY4gNw0d6HWUAULC1mSR8pkEBRvOyo3js?=
 =?us-ascii?Q?PAp2d8sAv5VJDPm+eiisw3AORyJeBU/dZfixz8ydpdusqoSZ3v5ixTAsVbeG?=
 =?us-ascii?Q?kNl1Us2sVXkyS4ghy9LT7B/5itP+GXGZLfhbiXBnRMHOIGtJfi77jZQQQTYn?=
 =?us-ascii?Q?jRFXtjMQMvyuhpO1TdUpsW+sdFOzjLXLt/Di63OyuB1f+ukwse/iXS7F16SP?=
 =?us-ascii?Q?FPhf1AqdU9MbjPNhx+Z54aX9YsZWYBaykQit2hacDkLyh0N01UJAYK6sIBKP?=
 =?us-ascii?Q?+fhMDhPi3Hp6/lI9XEuWYE+lazhzOggtymvBh0gtfmB6/JCsw+2Wa1mfklcd?=
 =?us-ascii?Q?p2k0ZetMoEiX8Nt+BZIJdpkcC1rxvblXf8pEJbBC4fxyLv/azC1szUfqb864?=
 =?us-ascii?Q?A/m2xNHPtFg3knPG1HcFrzZJEJ4qgs/7gtLz9j5VTpVAEMsmjtkKwItClD2Q?=
 =?us-ascii?Q?voc1U8q7TMlUTzNpJK4kKBaOxqgaSW7tcj0fm2pgeaUcF+QYolanvzphZ3ev?=
 =?us-ascii?Q?iaSn9RvEN5fwKQBi7oujltXe880wJAoW6pORWoiOM7+aaoEffJsttHL17ztl?=
 =?us-ascii?Q?0BpGfLt29lUQX8kBToU0UFDoAFYfwCF06oOk0eLYJHC3ie1rqyvXipsGK/zA?=
 =?us-ascii?Q?zYitapCSiH/Ib2VgLIROWj1Fp00kUv1ul9TgKWisAjoEfUoinSqc3Kj9FTQx?=
 =?us-ascii?Q?3Ljrk2xIyTfwM35ozp1CS2V2c+lhG5LJStevNsGGGS2d6Q1sLb8IhNeq50l5?=
 =?us-ascii?Q?knuS3scDFQV9VdcIo4ViQPWAp/X7K5ufCC3ibvfRKSKSTTzUNaQy5U8YD/7h?=
 =?us-ascii?Q?IRC2P3QJ3Gx9aVhQDf1DNZ2XgS3NMnbZV5uUcq155bAQTBjIJmJAbPuTVa4u?=
 =?us-ascii?Q?umPIuDKjsaY2UTRWw4Y9HpCGxrJBcC3Im1of9LY+BYgmK4yPXJesSk01bGjl?=
 =?us-ascii?Q?ku3EZ4PKsdoVnZn97p2jeGdn5ZEi6TbamTeAR6ddiPd2UzmfJqX5LiEcMjRR?=
 =?us-ascii?Q?NdCJh6zFgs/YeuwjrleVivK+nuQdBoKF1sCdOyrh2DovbX2OSTkleHKOqz/q?=
 =?us-ascii?Q?AZzp04qfy+cfY+AngP3LybEA/Wm9md1dhNIkyPJdSPFXrzwYfXTpusxWjNfV?=
 =?us-ascii?Q?TbWU7H2sTstRu2vML3/S3PXyWJljAMsT3CDYjtVYz0w/+tthpUexciAbRkoQ?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7B/v5zuhNJKE6lWUvZoqs21mEHnJVb/ziVXoEIcrDaY+EjVXfB5zs3beNw1svBlzwXQj5wZ9vEGh4XrbK1Ty2eUBFnMmGnIrwQiON3p4KD6Dsy5zogmkDaG3gQq6SdainVVumH4cIo+7Qa8UFHg5qj8iJc6kcvMrYoE7nI2dZBYf69E37FVfMIRlk3/f/iVeXu2tgcvmRfZ3SlisHpsIsdc5cxMeZVehNZ1a02Vu883/aLSUGEfmhtU/VDQ1W6Vq5UKBvl+66TTi9g8HNMKzApXb/YooquMHoK7/10D8QAxrk4Z9CF8Hf4SQQNv+zQXBvRXqlgO9kicUAkcDAjjkiqsmjb7rpmA0R/n0HJqiVDBPxM50uBBkuVj/gZOMq7E4mAI1xPwAi+u1vYNiMhst7+wIdtQYMow+3YRqJUmz1zSzu2BKTO5PP3u/qqkvMSuswV7e+3AAQw5aPuP9NNRyADtemw4WSrSQ2Dmfhn/9XIJ/InJ6Fa0guwy+MACjZqk1/FCmFlsfuwlciYTYz3jFfG+Kcf1zrinCx6z8S53rKXFdD29uCVhB+eLkd/pdzoBVsMD9kWIPkZDED3PaIn2liuO8vwHmwxY0g5ONDzs3Se1o2TEgSuXIG8rDcTFzbiUJ+5WczJTHGyPtiaamhlqu0n/GIcZ7OdJUwuHkMOWlvOT+8teNmrBRV41sgBkefHiSB5Qk+zblX6nkMeGA1zpKWJNWN9mmBLAcztvl0gUQ3vC3v3XWpvCICMsRAPjV5k8Oy2mj3ekj39ZQoZIjWDPVkUsVCud9EZ2b/CtuIsQtCJQnTJWl3QeIN6Z7yv6fKs/IGFPK5bPpJwhGzxsFoTGVpTmXpT5duYYfegGrctZBxd0s+5En1dV5HIPAHecbxd+A
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34684e26-6f86-4272-fdbd-08db6ca78468
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:18:14.1038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +U/qQees191DCP9WdJ6rq83HGTFRCLNf/rPiqvrvl1VSdzEtasO93N8YCnzQDr4VYpF43cNqY3hcO4mJ5UPwDo99bcWeyXuZRLjqaWc7KaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140063
X-Proofpoint-ORIG-GUID: 2tfaSGHVDrk9HXS6RL7dJHS2xwXapsir
X-Proofpoint-GUID: 2tfaSGHVDrk9HXS6RL7dJHS2xwXapsir
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0 it will not have set the sshdr, so we
can't access it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c4bf99a842f3..92bc026364c0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -701,7 +701,7 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
 		ret = scsi_mode_select(sdev, 1, 0, buf_data, len, 5 * HZ, 3,
 				       &data, &sshdr);
 		if (ret) {
-			if (scsi_sense_valid(&sshdr))
+			if (ret > 0 && scsi_sense_valid(&sshdr))
 				scsi_print_sense_hdr(sdev,
 					dev_name(&sdev->sdev_gendev), &sshdr);
 			return ret;
-- 
2.25.1

