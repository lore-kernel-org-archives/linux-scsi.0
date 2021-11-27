Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5905C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 16:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237515AbhK0QlN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 11:41:13 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57020 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351676AbhK0QjN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 27 Nov 2021 11:39:13 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ARDSBFY030027;
        Sat, 27 Nov 2021 16:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ZtqCnxPiRuXLfN8amQQmEtchcnU92k9Y5F9ZvkqBtCI=;
 b=jOVliNO36olJ3CivJ0PpyK3lq6+zoLyvoTC9GpLcXl7L3gqg7N5ESfXzinokxGDEaCxc
 bY7+Tj+WRV19U2Huzf1CQB4s5U2dgT4gqc2g1wkDS+wdRwzJ/XX8j1tlKXcel8xsZT0r
 cRdw+nnuGlYJrrzPydhWMc/FSfLH4ba0LCIvBe7YagceTbQAu17FLz3UhrWU3zBIfQzH
 IatypWGDMNgkz8sf8IethFd1ZG8LAv1xeP0+JOmqwBfTMGaQNggeiZf6MpqnBl11CtGu
 L/W1fE7UOIdaXcefI7eE8KdLwcnctDsPo3804lIDMF1GNvX+x8DnIUOL7Wv5uwCoy6vB mQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ckbf397a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Nov 2021 16:35:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ARGZSmr196185;
        Sat, 27 Nov 2021 16:35:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 3ckaqaneu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Nov 2021 16:35:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XK6APPLBRtMe4UKmsucu/3sbucQNuEl85HXFxDmUKIDiZoks9lOrjBc1ANp89LMW7Mzpb0kJUaw/SFUgs24jELM9LJYpKYObUL+J4A7RAF2ihq3+Vy0hqMnYYr1IPwRjeEr8xWCyKiEhTviwzzkiyH/wKp5GKaNTsqEb5vi6brOrRaX9sa/Pyz2EC6uckXTWU0g7xoOxQu/0XpTnz7Iwjih/6GWlYxt89fSn9z9i+a5xZngR6DxjCM4d/6JGGwAq/WRk5QcE1im5UQyAl1xpCoEk3jaXtpa9LfUu7J/Fs8ygHv3u63CagrlmQKlHBJvY9pIL0tFiHZY/iVOD6tQivg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtqCnxPiRuXLfN8amQQmEtchcnU92k9Y5F9ZvkqBtCI=;
 b=SW0wivA180eX+mpS3WjE1d10+gSo4puqGKtYk2qsGeBIgFcq5Bs6VkP0/ovWKxpm6lvog1I39SWRnGbYIlJKfAHYdrdYa5R6MR4t2t87xjfpoGH233AonvdUuMO96mHaxYsVnvVeL49Ol3iGWBT0LxFfIgVhzTscBukN1vhPZmXQ/zJOHaaStHjqhMR3n0Du+bKv7f/ZqHglwcHS9ZRMgZq2E3dHyg8hei+/n+8zgnJmWnxm9heNIvHDt/3+U8Y8Oj+T9lqMrx0jc5+E2kEF7ztpDkl0J4ENNpdoZrSSKFgSxsXx4qpspRP99k8lGTLXAUDB4dFtvZqJH2sFmLsiWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtqCnxPiRuXLfN8amQQmEtchcnU92k9Y5F9ZvkqBtCI=;
 b=JsI1RhncjcXxz1xylQcdNOpLDmeeLM+fxHPphVNgYyd5TtpOuGwErYXJdX+59Sea9D8Kf8ZRh/Qy6eD33aAmGz4/Vr+gBrRHHlGFUCXg7B8l7mSKGHH1og/AEZskvQEEETyZVFqea0Mvm591nhKkos/4V22BYBtJlspPVFiID1E=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 27 Nov
 2021 16:35:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4734.023; Sat, 27 Nov 2021
 16:35:35 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: remove ->rq_disk v2
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
Message-ID: <yq1ee7136bd.fsf@ca-mkp.ca.oracle.com>
References: <20211126121802.2090656-1-hch@lst.de>
Date:   Sat, 27 Nov 2021 11:35:32 -0500
In-Reply-To: <20211126121802.2090656-1-hch@lst.de> (Christoph Hellwig's
        message of "Fri, 26 Nov 2021 13:17:57 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:a03:74::43) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.24) by BYAPR05CA0066.namprd05.prod.outlook.com (2603:10b6:a03:74::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.9 via Frontend Transport; Sat, 27 Nov 2021 16:35:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aaa085af-b8dd-4e35-73d5-08d9b1c3f00b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4678:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4678FE6FFBF9F6BDBDBDDE368E649@PH0PR10MB4678.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FaH6l8hzE+gydZtO/7kzJ2xmPuRZ3siFFfgd9l4gvEnrQYwK+g6Tus6IZbW22JgXnonVlDJdW2T7vcVIUBAbPDdFe8Y4Y/zggBhXw5HHz4LhCyPESIG6FAnS0rScPaoeb3IBwjRnPUPfMlBW986beUBX8RqEgaNEzYNxN2AnWuqhJvOHx2WIUh1Hd3aG1JwtaEMxes7MfC0o9FwFqsAa2FQv4qsJqFLfsXrUKcdzncfv9rOson370u7l4/8CnFnX+8f7e0Jh/LKbC7lBLJfVqn1zOPldyIayWLxzaBtsNJ3r6M1sclbj+mphFvmJLttff4KI9QxD2ehsBuV436/ksGW1PwrtidspbPnI5tpev/vd8RuQW1NH2mXoYwXhwhKMnpX3xDh4g8WOSg0czy3AIZvnVNXc7kLaZPAvtbaElnvi6ua0DzElSjLzpqi0xa70twpkhpNWfdUPGsuff9b8wMlqfBZGNyH842lTzjy2UfpwndIMwYwm9lsErya48FMoJJHEUNDDsqjHpvDyyyXwHt6lz/fUVJzREOPWmOh+jtbCIhitKyFuqYvAs67v/l0F7DYP83X3CjzsmW2BfOIENA0m321NXeXH1ClhP+GZjdd9qC/+EvWZZ2Xn9muPksZxpzCGXFeIl8aZdFY5vpa+l6mVVA6pjrUnfYkBGU6dILVo77SlXku85OFIBIid3SPUrdn7bPMSg6SaeSGmHiWuMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(86362001)(2906002)(558084003)(8936002)(38100700002)(6666004)(83380400001)(5660300002)(52116002)(54906003)(6916009)(26005)(36916002)(4326008)(316002)(7696005)(956004)(8676002)(38350700002)(66476007)(66556008)(66946007)(186003)(55016003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G6p3Dc5xz02Cv2HN972FSFfFvVpvz/QZKtJgedqHe8qoyqMtjbMy3zJXgmsd?=
 =?us-ascii?Q?SDnqFq1XYqLFI905C0I8X7gHNXEiUWU9OlBCLVV+Fv4DbZ0B+b2x9huIhi+x?=
 =?us-ascii?Q?ao4xniI8PG0TwDEhpnc3sC+qIAdlcPZxOr/PGUGGadeqVL/CgNrkcalMZkV2?=
 =?us-ascii?Q?/6MXcDTvp6QLYXEns3zbL08Euie2o/h+N2O6wFo4/o1snw9vbYQ3hX2J0gfZ?=
 =?us-ascii?Q?/PoidpQOvK1hl4/2u+Yu0AMCclY4WE5HtqEIoUTVDVLmgJdAEzCXSc+J87Kp?=
 =?us-ascii?Q?xoOVmorLfs7m7f+em8DKWDDnnveN8VTFE10Ry0IAc+atSmffgn0XvXmxjp9g?=
 =?us-ascii?Q?Q8ftcS1pcsWnddz4jbRdcjk+OtRP+UjysGBZ8i7GsNEkMbAJvq51+1+EEeG6?=
 =?us-ascii?Q?g8Z7rmBXSTVEq7NS2ppFt/tekjOkylHvIrAlvaE7mZy1ph+1vxL0OmrNWPQ7?=
 =?us-ascii?Q?lebs0maZ9F2vX+qgllHryR7Hn74RZUZ+UCphQ3n66BQfjO+8QBnRkfY1ysXF?=
 =?us-ascii?Q?ccUbAmyyqF/P6KIM++hpQKBv7qhhOJ5ltaTgPmtf8hkTrEFLovcLdWb4GpyK?=
 =?us-ascii?Q?Byms9PSXiqEBgaNTD6Kx0Ue3pTok5DKfBznsExP1YpqaFb8119uG8+oX4PL2?=
 =?us-ascii?Q?tC7VS+fA2rEbnIVo2Gd7R2GhIGtbHKvyjTkxJLkavaxASzDZUULJ4vEcZ87t?=
 =?us-ascii?Q?+1ENQWC7bCzQHhz+PG7IocXpAnxd/ABfGV08DNjEw20XKWpCchLfaas6H4Mw?=
 =?us-ascii?Q?mmE2fVJwOswmi6lG2zgBNUzT0jxJ6uAwGq/4ipMSAKfwJh1P5vHIjgq3ITe1?=
 =?us-ascii?Q?fkQPwhXMrIVrQehgMsdYiHLXNCl0nsa9NIYSugdMl1uTm4Z7/gaPUYLgeJEW?=
 =?us-ascii?Q?Yi//PuTyUYY8iFtND2N5Ka2scAo/sgQreTI4e+zjREDRxFCIBbnUXsVAcLEz?=
 =?us-ascii?Q?K6WUocCWkHXo4VSf7xhB/mTk+bPMWmjvlcvYqTRwk80/ncgpgQgH5lTfsyTq?=
 =?us-ascii?Q?usbH/viOvaRdy9TXC4y1o2IR2LVdKESH5+eYexdTN5IQvEMQNRr2EhfIlGAT?=
 =?us-ascii?Q?mNH3zm71eTULDahcuLnjAbWjVX9C8cam1BH8F236SKpLOHnqDfWH+EALihy9?=
 =?us-ascii?Q?V1dGZg0EGcfqLeOlRNFQAZiTx7399T35SjmdeTktHkBg25ex9jLEamWlW9o4?=
 =?us-ascii?Q?TugDAuWrMJczSjsiu7rMgCV2/xqBeUOR20VDHfnIIiuXn8AMXtR2tOvdBOI5?=
 =?us-ascii?Q?jyB8n0ak2Ll0QhNT15Eyrv0HYNSvuf0iPQjAaL0T2N56uJDMSItAMx6fo0zh?=
 =?us-ascii?Q?PR2bp4IzdoZKomv0BBF4s5KKMFl7sMRvlSY+4lH5gq8mayLb8ZaRI7X8SFVe?=
 =?us-ascii?Q?HwELvHP/Zvm6QJU2M0IZyyxd0uV7/1B+68hk7HOE4romHCarRKqwg2FwvMfz?=
 =?us-ascii?Q?QW3qatJUG82LaTpWTvC4jfzQWGYEhwbnosWfXdYh6PU9BhrZiD2McPfvu1rK?=
 =?us-ascii?Q?lOpbQfRuq0xF1tluOCeA40JkWeHwqwWF84kF74E+LIoEAnyHjwcqL6GAnBal?=
 =?us-ascii?Q?Gdcj+LOUZdCZuy1Jnnn328ufwXB1qO5CqXVVzVyTmDQ0VPUVR5VI3n/AAJ/d?=
 =?us-ascii?Q?mcLALM7Vbd5ptm+acnoL6YzbTDIL+74Wp0P7k1XEb75REZzGDtOam2V7f+X1?=
 =?us-ascii?Q?Lw7aKQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaa085af-b8dd-4e35-73d5-08d9b1c3f00b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2021 16:35:35.5021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5YRAwAbw822TnuTx9FiZoddk7Z5hZh+u49vumt4TZEg6D+iNrw0Cjw+XKwPT3AeeFB2qVR/AbF1bgLuFvScHKT5mHVzP5Km7Btd5MuN5SUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10181 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111270099
X-Proofpoint-GUID: m3QsxiK81u07hQISahDq_DHZDEzZ0oc9
X-Proofpoint-ORIG-GUID: m3QsxiK81u07hQISahDq_DHZDEzZ0oc9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> this series removes the rq_disk field in struct request, which isn't
> needed now that we can get the disk from the request_queue.

Looks good to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
