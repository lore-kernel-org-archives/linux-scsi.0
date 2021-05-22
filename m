Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C8DC2B9F2
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A0026100A
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhEVEaH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:30:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57210 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhEVEaG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:30:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4PAAC002868;
        Sat, 22 May 2021 04:28:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0uSGgdGbzXCdqLraPMUZK/42wb6EI6ehj02K7UCSncc=;
 b=yYFG73d1TvexKnOtY+DsoiKjaOp1SPvlryeDUHK0bbJJFSdAIv+MFQGFUOqsndAVsxxF
 fFxixXRLOEQ+IFivTww9jZmZIBe8WwaAaUhYcLpETPssXXhwnMRrFm61vnjvtbuiB0Lb
 BpFVYHQgRrcSyHDjz3Y5JMGdVrFZJ1dKxGHjHUW062Fqd2MvEoh9istPVCPlqlLEOGgr
 MuaVYV/7yeMlTfjmPFS/riqUbSa4wX7iWJCfuNrIOLGoELD1xASc0WIbjSo4Kgpk2JVy
 e2UoJ5iGL6aAEPNdnYH/UNejuok1t6oMmbPPp01kxLxfaJruU9rJmvBbEwzqFB4vr9kN ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38pqfc841e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:28:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4QMTG115722;
        Sat, 22 May 2021 04:28:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 38pss1besd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:28:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQbp+yFv7bxpy7FbIhuV9DF73yReTrzYJwVjKzUtTkYa2tZ4v0uK6Z1R8KtBZ4LsmvcFHbidkoTjXx4U2MZlV0wKvnTNmduVOJqKTr05epnLuQMFAcAi1k+dcvXnjKZyWDFNIgylixGyXs9jocxTCg++vj29GnbF/V+q1R1lP9jgxZS8XJTJGaIaioPb6M+nxHKZsOKaxOjnJRDMvyyoJzbVWx5zZuKr5xJZe6QgLmwDk7QU0dE1OwledTkAndlE/jrDwYy6HA4x0cSpgEvFwUWIqEdSIQWnRdYFPnTdiZSIripgvuhpkemcvwhgwBlX+dLdH/Wua8m1dWjaJ0sUeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uSGgdGbzXCdqLraPMUZK/42wb6EI6ehj02K7UCSncc=;
 b=dJf9sfN/buBxFrn7aYGvYn1WrhIjp7GZ0KmmA74T8sWGHXkoq1QJiEI6St+NAuZfSMxIIFA2N8k0BD/Wxq3uGVdDXdQIcpd67PF6KomnjQHFXNf9Cy5arjJ5/dDxIArZkQkpMBHNpe+54AMvxMUyfWLCYUF+w2N5n7b92gBzc4VARlzpBZpuelLrR2KU6CLP4XHPahATHp6p3rqzGVoV2j0tgbK9rA+Suzg9Pflx4Wt79QLC6rDIl2XdBBj34k6JGGlCl4sq4/RmnQKtgyoyNmZLESQxaycnHDTZliRt6iyCCSCLMWN8ubel6JRizSImkFjoCi+iNL73g0EecqDgCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uSGgdGbzXCdqLraPMUZK/42wb6EI6ehj02K7UCSncc=;
 b=DMT649MWjcSCfhK5/yur9iXJ2MTVvRInGiYjw146g2bW/3sm9FQggcpuw8+AjsJnuZKyMBHfd4LlNtWmeBl6FLRAb/FNxgz7j+8wwzu7JEwDBfxMRSxWVpMHcbx2eI4RZFZF+FVKUSdwdNFIGms3WSWmT6jisyV+0ks5kCXKEK4=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sat, 22 May
 2021 04:28:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:28:25 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ming.lei@redhat.com>
Subject: Re: [PATCH] scsi: core: Cap shost cmd_per_lun at can_queue
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bl93z9su.fsf@ca-mkp.ca.oracle.com>
References: <1621434662-173079-1-git-send-email-john.garry@huawei.com>
        <988856ad-8e89-97e4-f8fe-54c1ca1b4a93@acm.org>
        <a838c8e2-6513-a266-f145-5bcaed0a4f96@huawei.com>
Date:   Sat, 22 May 2021 00:28:22 -0400
In-Reply-To: <a838c8e2-6513-a266-f145-5bcaed0a4f96@huawei.com> (John Garry's
        message of "Thu, 20 May 2021 17:41:15 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR04CA0014.namprd04.prod.outlook.com (2603:10b6:a03:217::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Sat, 22 May 2021 04:28:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3508e8ac-64b3-4a01-e5c5-08d91cda0a52
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46966ADF551C3C9DBE90059B8E289@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DJ7/OCqVM5UGthufD7CgSTmCSvsbf01a47EVNkl6VvVLk8VMxHHcV2AriWukwP9A0PAyZ6AK3KzcsQVVOv9ZRyQdBfbSLe+N6W38lb+D5mJPAfu8urv2yT2suUnXeWBGV+gwi94mMAAUObqpBslyq+HGXM7Db8X4Fa19P7w1BjHfYfS/V1rWyTQTnYu8LL/0H+uwc9Z3Wy82dQWkUrTvYqy0hQx4/9jqtV99Z7TR7vLvJcxZppkxWly/mMz4txPb4jgnBVr6E3A3zTi/QdEqmUXAoKK4lLxIsUHMeARvtOIujjJMLmImkPON3sk4CQ9+AVSV2p71RsGO3H68sW8EsPdC7tHPJ3bG4xRyUlE0SQ3UnDnxhobNylT3BQdUxufxnTNqhpBsWF0R3ILRa8sP6WmuliI679k3wqRkzc0Jd66L76j48Q8knTo+/IMbjDqUdc2Eb1jujxRR9YxtZYgk6adJimTI4n76VpNDzsuCt9RO537XGxWuh41yVQDcnInZuoKovo9Apx4BKVEQYvdF4CKO9n6N2SInkqiF7qyt/cTxCRZeBpHNxu79pH9uk9k/oHDANZZ+Mx9LFlKinpB1t+pQCvZQSS06vTL6+xMEuDBwS8jCFcOS4m+Qu0K3wnjN7CoGnBov7p5sMsamtSeGNorJ2N2RPeukQ8BvdKklEU0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(66556008)(316002)(38100700002)(66476007)(8936002)(54906003)(26005)(66946007)(2906002)(86362001)(8676002)(52116002)(7696005)(36916002)(83380400001)(478600001)(38350700002)(55016002)(4326008)(186003)(956004)(4744005)(5660300002)(16526019)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kupXbMBNw6iD3DGq9T/ZilFrajQLB+yDiIDaVYXuMjd0hDXzEazERMK87u8Y?=
 =?us-ascii?Q?oQ+0xmKHFIqLXoAUD8BFA9Eqhh9KGTd4OMAWXcWMyvFckaibyNdYBeFSPIcP?=
 =?us-ascii?Q?9HSLiLD+75DY7FKN0KytfQ3y+XFaPl90S0ebPWoBXbU2Az68pNcs5FcFUgk2?=
 =?us-ascii?Q?ny5N74QvvYBqoKe82aAavcqjXhTkHo4GG+PPQDRjJWKsQeoWA6a4RzGTQfRq?=
 =?us-ascii?Q?8KkwE5FQa24SrG/EEIYoWgTiKmT+FMD2E7LKKLc4oKMZS0XcSgJ09gCkJXoO?=
 =?us-ascii?Q?eWkAYidm6kzzYc4ZdD25GnvLGDM3drX8nbXmR7AWzXnmz5/wv0C2F65pPe5/?=
 =?us-ascii?Q?8hIWypJP2bW1KwWocJ7NmHZh+H7DdW6OH0EwBoW8MhX5iXeUR8PfP7Rjxj/o?=
 =?us-ascii?Q?H4pP2r+lP3om4sLLnslKE3jOvJNEmX7zJ0O/5mGclZvo0XWXujvdRh68LNmV?=
 =?us-ascii?Q?KGd6E0Xe3a4g4uyJfbyWh3Df6ODn/FvF5legLwulmzETb6B/Kwg7LAjbS1vA?=
 =?us-ascii?Q?qWAYktVM/9GaqQTcXSYsK50BGeraCrfwLvZNH9zuqJPEnWRGLzgtQrJe05A7?=
 =?us-ascii?Q?u6XSn9q4z9daH9Yo9YYUOqf1x2+YS3+WEh+quvJ6sSSZwMqO1uMSDSNyiW8G?=
 =?us-ascii?Q?kyIbBysEHfu3d7ogcNfkxWJVUpFpltxj/yJMDCRpxZIJJFsiPdCdo/plXNqh?=
 =?us-ascii?Q?kpdsyO346HWLPoGn7IH06UikEzRDnGy28LuUveX73oXOLF4iW/3D4nHjah1h?=
 =?us-ascii?Q?S1aNW5p4ejC3pZITndBsAO6+MyxQKwHQPTGI1Pc3higZNecB/vEoBI3XUMO5?=
 =?us-ascii?Q?AkdMY2rz9L7dX6hXWzjTiammgk/29h75VUvaVC0W/QrpjlES3fR1QeraT9bb?=
 =?us-ascii?Q?cLtjmhjZh6LaIM9lhN5RrLsbmLgAJMmdu8ppvziAMV37uY5I2PjgYsDYOIJE?=
 =?us-ascii?Q?bOhrI3RPxk/ZOBz+1umpB7bnNO6ZdYa+1b/E1Tg2UPAYSODbPXi+OcoHYiU8?=
 =?us-ascii?Q?XgJbFX9+JNYoeja5JtPC64gBlWutFAeybOgi62ZHK8fJNA0kWNFW9i16oWpG?=
 =?us-ascii?Q?OZ6ZI3rQcCIH7MJWOh1u+X/3wKg+KYIllB5PsWfzVmD4lq/iWtIGEQmfF+WD?=
 =?us-ascii?Q?TTmpooED5/Cj0OXPR8pnZxRFuIqLkTzrkIp18w2d99nobipMNrtO60Wa4LWs?=
 =?us-ascii?Q?AAtdsCueUNjb+RZ8nuwmBcj4iAmf0E0IcGSwt/zpYUmD8mLlLQ/MJin8yBA9?=
 =?us-ascii?Q?MbyC/j1r6aI87KGdrQO9J/ZI+FKvrs6uDEq0r52mGADWyb77kyylZM1+QV7X?=
 =?us-ascii?Q?smT9j+XmTl4typdzVwXsREjC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3508e8ac-64b3-4a01-e5c5-08d91cda0a52
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:28:25.2812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uviSEVBu61t0faDvIQQTci9YDRtCbLDo3prkA8cpy6KpfTLQ/2EgcohfPAFSOlgx48P486OCgOP4nLmQDqwtkdOhm6opr0mnASDVJ2vPcXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105220024
X-Proofpoint-ORIG-GUID: fvzWp2pUfBA7PAbJ08ymTX_vRFIG5t26
X-Proofpoint-GUID: fvzWp2pUfBA7PAbJ08ymTX_vRFIG5t26
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> I don't mind doing that, but is there any requirement for can_queue to
> not be limited to 16b?
>
> It seems intentional that can_queue is int and cmd_per_lun is short.

I suspect cmd_per_lun was originally chosen to be 16 bits because of FC
(SPI was 8 bits). And that it seemed unreasonable that the initiator
should be limited to what a single LUN could express. But this is all
guesswork. This code was obviously written a very, very long time ago...

-- 
Martin K. Petersen	Oracle Linux Engineering
