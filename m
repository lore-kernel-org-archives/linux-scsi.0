Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3555EC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiKDXTs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiKDXTp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:19:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED6CBCA9
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:19:44 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7ci012094;
        Fri, 4 Nov 2022 23:19:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=0Euk36EMJqSy1BBC7zMK13TlVfRsYMiUPBV4sWhte2k=;
 b=omXSBUhytJyL8pO+zG55If6qWS9crPDdkGStdRTTSl4XN28qEnLci3URddYGXUnLsjdf
 Ao9QXxOZZJa4FgrWzD2hOz8LY9nZJRQjAFwqwAqSxz7JharfFHzQadXy2L0PbzXWLpcd
 a7KMefww7J71XoL33j+Lrv1QTzRGckvi1fdyEP0KEWnWQXtkO6q+fZXRZxdbppDCZ9uA
 egdOlkc5yB7Nav/+f4J6dvXG7sUHySTZUsSpPBekc4+cBRD2uzgM5Q25HZsKsAwhFDAz
 KifKYYacFPtSZyCxL7l1aXLvgka+FXFC8sJfqNutTUriEA9jql5Rkl5AsM/qxDvw42by tA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqtshtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:19:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KKBjR023392;
        Fri, 4 Nov 2022 23:19:33 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpwp08d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:19:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGGCP6/ITXyvqGkbrPH2uRtdnCOYaEjyOs2t4Qy0wA2kdlYQVA4oK0eQHO2kGmXtPCuxCG+QeoF4qRXO9Dh8Q6oewGzYNkSuCvQuCz+WaEHDNPc0Zg385emaYVT7+NKKDNNQNRTSprWM4eqndlfHHJR+O9yQFFXZrEu+82qI49X+fosbXX5/nun+OR1jaf0L8JvBY5SPqxGeZlBO2mCoNdV0m3Cj8cIong60zDSQT3gEXW5P5vgfPa0druHc8YchnFe2faFfEfCISWL6ZZb3HdxN6oJUyBSIvjX9BR0/0Q6cfBJO+WLKgxpHOcuw82QhCnLCTkVzKtRRnnp42vrKmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Euk36EMJqSy1BBC7zMK13TlVfRsYMiUPBV4sWhte2k=;
 b=oWwZPbpf6DWC6pe9drm0Dsoa4C3+jDhG71iu7LOJ5mEEByrPFnw/fd5bbkxL2Oe06R77W2m3NyqilT7fQlrKfeJmaORLEpyolpvU5bDjrt7nFq5vYoYyUr+ClyjBY4gLChs/yCQUpA/OHhLDoB6JUbnSN1rurfGmkE371bvxlr5FRcbhq4xz1CcTleVamvgdCFfQf1kgfe5lR8w7KcCIPc1hJfKNSuvQy/F/9r+EtM1fW3ee+Lnq+3Dyw7VHa1DD8pmeLU1HIXe5D++oO8i0z2f2S6MKf8+W1Vw4vim9/9bI+EujPBeJdjkF2tnlxNclzCCy6tPgmBr8FpxUR+/9zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Euk36EMJqSy1BBC7zMK13TlVfRsYMiUPBV4sWhte2k=;
 b=lNw+Db0vTwsNYRwpNF1yk3ojF2iqMZdEh+6fILfvCy268XipisbWbteDan4edPUDFx6Zj+ulwTdeODG8lauy56RRvL0DkinJqn27+fDRp8+JYLfOv7tOF6JfulztBJj0+IiYub+/lJxovnMI5HtsBIQaD1nZOwMeOahEc08RIw8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4743.namprd10.prod.outlook.com (2603:10b6:510:3e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:19:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:19:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v6 00/35] Allow scsi_execute users to control retries
Date:   Fri,  4 Nov 2022 18:18:52 -0500
Message-Id: <20221104231927.9613-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0254.namprd03.prod.outlook.com
 (2603:10b6:610:e5::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4743:EE_
X-MS-Office365-Filtering-Correlation-Id: d0781f1b-7287-43b6-1ab6-08dabebb06cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: scWj3UMA/SDnKhgBEBLdru0lMEGfdEycWLm/N1Gy3MclmexpzbHVRNh4axtokSwXTINtFBw7jPwRQwkTE8d/iOWbsZykruYvwfNfWerlFYRG8uArHkzuBU2JXePHZCQYg7h01+kDO3q9p50LluFnkTeBRQKDHiyvdHCf8A/572stCFEb7XCvvEH6UL5ODK8jPo4o/5Tq4l2jKlZSWc3eONY3oAXKaXk0L3VUROsA2nPnKLDCB+xtZnYPMx3iwrpQSHpEUFBzZXTDbEkYFLVucVfPNUc7UwkNJxlB3ojP+gAF+zuGZsy527RbmHKZTOAkm3Rw9hFMdGUj9ixwn8jYEsVMuk8q74dvJMBOVP3ldiqzlKyWAsORCB/3ywByCBbD4I0lns9mQBhjHDKkas3WroZab0eCDdlp8F7RMSlODaWlzOG2uJADmTnsmothKJ4n+z7ysPc7EI+zbdlKoUYNAPOeqSyFL01YnTWJamIuLLIt4ORvxpwQ0WUK8gm2X8yUOTZa2D4r/fRDB2ljs/DNg2amS+J36xPwOaxhYAyBv9LfO9ofziJu7LeQ5R68m7yQ5LTsgJDMO3H3MZPuEN+4tNWlbpzEYATVDaj9iPuWtdgqwB5ZWPXgPbUanjz5S+5o7Dkhl4iDDZu/00ZyNM/5LiZPF5MGG3+NrctXxRScprp4UnyseBPLBOfvBzB1DXjjk7gsoNfc8hWTU3wO3yTZoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(186003)(5660300002)(2616005)(1076003)(478600001)(6486002)(86362001)(316002)(6666004)(38100700002)(36756003)(66476007)(66556008)(26005)(66946007)(8676002)(6512007)(8936002)(6506007)(2906002)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5vvvIP/qdiz3AJc3NPXNSPFDSRX/1MIGBaxoFYxTFeSKcC7w8PEMAS3Zxubj?=
 =?us-ascii?Q?+0xFuPiwWXZCIz/r0cVUfsPfKdWmaRlgG3m1h+LJ486VVAtOCuTQ+3NH6oNp?=
 =?us-ascii?Q?VoUNHUQEbK9SEcuYguqBOmQc0QBW6hf6ZRXltSx7oYRo2jJpaht2bI52UiIA?=
 =?us-ascii?Q?qdip8nswg0Sr4f5JikXPiVQOi5GmNCEFC4J67p/1Vj3+ym78/qn36WK0WPFd?=
 =?us-ascii?Q?dQMFvwRqybRFBfQTILax1/fK6AhMNL5rUh5axJP4PVKq5lfBgjNAgVjXlNN4?=
 =?us-ascii?Q?EEAgKmRWjd+sL1eLt8Ur/3gyZ39woish/kUrMXSE6wJu3idXCJ2zJ7aL97l8?=
 =?us-ascii?Q?c1Qqt4yYUDRE/07DcYMfoMWDREOIdKYa02O6aQKkZuO1ggi2u2/UBkNP29Y4?=
 =?us-ascii?Q?/iaQ1qOrwBBM46J0Xo3e8+iuAJ52qD5if4l6jfjzzySGkgWhbqrU5rt+/qIE?=
 =?us-ascii?Q?uxRq+wTLCN/1w0xK5lPpRzu523mMHoHMpiFNx4LGbEmK+GH2VnTMRz/+X+to?=
 =?us-ascii?Q?c3s7Q0kJMyUg2VNhx12XCPW4wujaSJ7IB7v5AeUF2U5p6TLCJ3IMfFYQZll2?=
 =?us-ascii?Q?xowDsYWFAbnSVHlj3RW7Nxb3cn48F0W+Qy26USjAWqI78Th+LMwAnYIWf7pQ?=
 =?us-ascii?Q?C+V6H/Ot31Nqb1EveYTKwpcQA3WCofvEbTMOE8g2REF53dAB/QAHYvXrhBvg?=
 =?us-ascii?Q?mLGLGxlaR687fStnAhbqQFkl8hGhUGzcRS+e0a3s1CwbHk9sg8ennQjHX9Qh?=
 =?us-ascii?Q?vZrAiX5gCE9T++HLjuTrKr+TKpLEF9/YlxQRmxbMPvzQO8jha+9xptD8ehL/?=
 =?us-ascii?Q?/oK8zWdYMrHPYQlBqpzLdUtsjgBj37bRTDjE150FIX7UTRqBY+asEGPAbJCY?=
 =?us-ascii?Q?XVbivb1WwQYOaTj6tZT2IvQAeXgfQRbMBmIfxwFoOqgiG3phZiEELWymtims?=
 =?us-ascii?Q?NR5BmMxI+nc7ATo17M/DKxOUhWdJm3IOAcaQj+p7jG92ZI8OnTYFWmfcNe7C?=
 =?us-ascii?Q?OQEANajX7v+DOgMeI8nh5rkpiS7ED2PKVukzFyjiPpQt7UXuleffosSQEV8Y?=
 =?us-ascii?Q?uGw4lOBetEs0Z2S6cYfltTcQublRE+OgsTglLyZbunNC5tVVVR4nnpQVVWoK?=
 =?us-ascii?Q?Miw2pS8bAfMnUNA/sgbuqTwxeeGdWsr4q6MyUR4gyMm3tH0f59kZ0fSySeHy?=
 =?us-ascii?Q?tYoy3aR+4RwdysNazRiQAcKPWBHCE15OYkK6O15xzOEZPBH6yK3/j50TgeSb?=
 =?us-ascii?Q?tGcWnTyaDMwfzuVMG+0YKfFW8xdoH5xEKzsgo4XSg/6/CLjfNSilplvjhdB5?=
 =?us-ascii?Q?79s9iTPhQeKJ9W2mDP1D2xgyKhq6GChNQZcYVDku+02HBwqh5BSpyGNGenlj?=
 =?us-ascii?Q?B55owZ+/Xlp1poG2OEtTrUgrA9XRCXPS4091Xdxref2YscVR3Ea0GYvM3fEL?=
 =?us-ascii?Q?xLoVo52APYktHU+4uiX1yr7M0qu/HYUwLmzk9v+JFOrmAyNog+N7hfc+pdRc?=
 =?us-ascii?Q?GbwtCv+D5f7Kt+H3AP1PvDqyhlpD9weXiuY23AqxgFvT7YAHxWN+s5wZ3Prl?=
 =?us-ascii?Q?nuFkHgb/hBC6WPe8ciQlj6c4FlNZ9kUH8aPCcD9SIIchTx3F+ZfuMRj1aI3Y?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0781f1b-7287-43b6-1ab6-08dabebb06cb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:19:30.9888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NFitGdNM7IGCXEcVCzBBHswWdFApyiTm/qd9u4ijJeIML0nsEma/edWzzeVN4XVxGlDAvJEK6Y76/dwncole/+k2CtdH9Lwr0pBE445jXpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4743
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-GUID: uK10GLfC0RZdxREKZhCidDXcJspNXCub
X-Proofpoint-ORIG-GUID: uK10GLfC0RZdxREKZhCidDXcJspNXCub
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches, make over Martin's 6.2 scsi-staging branch
(there are some ufs changes in that branch that drop the scsi_execute
use), allow scsi_execute* users to control exactly which errors are
retried, so we can reduce the sense/sshd handling they have to do.

The patches allow scsi_execute* users to pass in an array of failures
which they want retried and also specify how many times they want them
retried. If we hit an error that the user did not specify then we drop
down to the default behavior. This allows us to remove almost all the
retry logic from scsi_execute* users.

v6:
- Fix kunit build when it's built as a module but scsi is not.
- Drop [PATCH 17/35] scsi: ufshcd: Convert to scsi_exec_req because
  that driver no longer uses scsi_execute.
- Convert ufshcd to use the scsi_failures struct because it now just does
  direct retries and does not do it's own deadline timing.
- Add back memset in read_capacity_16.
- Remove memset in get_sectorsize and replace with { } to init buf.

v5:
- Fix spelling (made sure I ran checkpatch strict)
- Drop SCMD_FAILURE_NONE
- Rename SCMD_FAILURE_ANY
- Fix media_not_present handling where it was being retried instead of
failed.
- Fix ILLEGAL_REQUEST handling in read_capacity_16 so it was not retried.
- Fix coding style, spelling and and naming convention in kunit and added
  more tests to handle cases like the media_not_present one where we want
  to force failures instead of retries.
- Drop cxlflash patch because it actually checked it's internal state before
  performing a retry which we currently do not support.

v4:
- Redefine cmd definitions if the cmd is touched.
- Fix up coding style issues.
- Use sam_status enum.
- Move failures initialization to scsi_initialize_rq
(also fixes KASAN error).
- Add kunit test.
- Add function comments.

v3:
- Use a for loop in scsi_check_passthrough
- Fix result handling/testing.
- Fix scsi_status_is_good handling.
- make __scsi_exec_req take a const arg
- Fix formatting in patch 24

v2:
- Rename scsi_prep_sense
- Change scsi_check_passthrough's loop and added some fixes
- Modified scsi_execute* so it uses a struct to pass in args



