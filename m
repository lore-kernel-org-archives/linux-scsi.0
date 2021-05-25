Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED70C47085
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 221F061408
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhEYSUL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60708 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhEYSUK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFOLT121981;
        Tue, 25 May 2021 18:18:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Hft5e0cjXmPiPX6DU66SxRl2JWYYGb7Vp64GRZ2dNqk=;
 b=J+HuvXyAwu1BRqvnHzzb1PBB13ny59+6o/7lYYnWPqQZGxP+XaWA7/MGKiAQJYnlwQrB
 69O8Ll8B21Ukn213askSGFNjU+WrqluR9svmIDXXSpuEfYVm6g3KJvWOwRSp+b4kwqDD
 0Fet8JgQURO1WZWdSO83lsf9zc8IgT7saZLUnvd5R3M55ZogB0KNRdcmtfRD6Ya4Kux0
 iW+XEHmg4ag0/pzSeqAVZ9VlqMSETiHRxRVkVr0fGWjUP5OzHe1T9FzYXU3FQm4EBVAp
 lxEtvEnN/Dv1eYzMMkQOrOk4O/UDhXKt7+ruaFdulYy9H7zsJzTJDah7jaF65Aqf9w6K KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q8xcur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEtmE166080;
        Tue, 25 May 2021 18:18:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 38rehaq4vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrt4N0jzL237C/dnSpi7tmsWq9ReYAxvulZtbXTCVPb8hsvdfu50vVgABNdQ+SZyvDKlqSeduvitq1Jt03KC1+wDqPLHofSefHeSbfA/KxZFR3o8HzHm5trAXdyGdJsfq4R0M//bBXCsObEt2cknhYo1VWTT2ufaO5LmTpZtBMB10aom0CSZKPGSAN6lx0+lOopNWN9nFRjRSmy0oVyzgYni2ZVYJUt5WUAzi0oy6DRSG1+z6bWkyJsN4rTjeVySSwv4NI4eS2GDIktyXP83QgIbJsQmww5+tEzJ3YGFVucWvV42IqBvNQnE9eefyr4PIVBkRCBwzzqRWoPqfV07/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hft5e0cjXmPiPX6DU66SxRl2JWYYGb7Vp64GRZ2dNqk=;
 b=fx5Ik6T4vS3FHol4t+Je+cQu9kWnmuStjuEMrgajlF10t/fx5bUEcm9xsMK+IfeB3AMvef6priTU8ppL4EhTQNNrlsBlmWNleS3wPgTv6dz8BR97sJV6cYysBmRnIFeznAQVV/zP6hYdCsrSrRZao6hWSKkxF/rRIEwo4/4H5uxNMN/cY4uYhYtQqqvCuDxUTThYRqTfI2KrOUnFmziAIVpB8NEHNTkWnQvCIOxunZjPSD/cfT1+4ScQNZgsKC+ScAFTZlulajXv6KH9wKF19Y4FiIhQQU7N0GR+UIAGGslSyF4bD9SV0vRST8GSNXQ3ustYA/Y1YZwI9QpWkJ5vZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hft5e0cjXmPiPX6DU66SxRl2JWYYGb7Vp64GRZ2dNqk=;
 b=HPqYQGpD6cayhBwIVIg/iizPA/HQyK305BKvOMfZ+Ou4CsF8eagBvE8XG4znMbAgkpFFbCzV3cI/KmgqfADzCUVq1OPl/nDEmMoE9c4Qtk3PDdc7hQMk/9dMv74ospd6OKTjqbD6U/jTaoXfs4JzQ6j65iicmKahuPVk1Vz+50U=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:29 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: iSCSI error handler fixes v2
Date:   Tue, 25 May 2021 13:17:53 -0500
Message-Id: <20210525181821.7617-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da55836e-0e11-4429-8095-08d91fa97f00
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4767210C826572CD727B23CEF1259@SJ0PR10MB4767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uK/XSt9m3vtfjf3X7Ew8Ozmz2O+MUkK78h5bsJArXTcLuXLukR2W/hFAZFNr7Bqp/Z+F0SoqDWMYthmRLQ4u5BA8N74b4tN65w08yyGIpjCa79JiNUjLETheOpf+IVnNVz6IrBFsrSabnjQiVrrLBBkF84UEAEFkI9yoSXx4XQXukzsIu2WZMSvS3GG8Snt6+pQDZhtupY7lRzuQwLJt0sCmYbD/SAtf8W4nLEj5WO4HwdLB5mhfoYYf64IZ8f4FoNHiddE/u45uaFzmtoqvZ7HB/hwW0k4xpniqtZY+JxK7gTMvwtArlrATYndv3zeZalOcV0NdF4bJum8uqeuDv8/YAckBSjlO4huu7uMZHDLUL22Jy0yfv+78jDrtXjVjwf4E6kOwDaUEtP4QT3o3kjRnU03hqsBJaWnErLe7ukL3wJOKTvOh3l+RIYLBSxr36wGzcnnnq3lrmjr2RrsPsTYZ8+rH8xnjC00aPtKjoVYkBGtwmwEEvRCbvf36gJ3XSu90Wka9EMkrrJIW9dXVfUfWALfsOYBrx3Xlglyu791VLuGcYMwiAzHnyTN1KvY4nfF1BhBJ+WnLz2LwBqtdqQtQ55Uh40k/XGPsENLzofiog4Eefe01SOe4D+bLqZ6uGD/cRo3muf84+MKKQsixYyay0AGSFddIZ93gqdOZdIjs3YzwgYUfzwDMo5MB3MWO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(38100700002)(6512007)(26005)(1076003)(5660300002)(956004)(6486002)(6666004)(2616005)(558084003)(38350700002)(86362001)(36756003)(8676002)(16526019)(8936002)(66476007)(2906002)(66946007)(52116002)(6506007)(316002)(66556008)(478600001)(186003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9UBHZS5w9CCW5oR6FiA/j7cvFAyf77vz/zSj5GYDAXoe5Z7Val0OJnWQDZ//?=
 =?us-ascii?Q?E7HTK2EkPthqVsEshlZ/PW1blsTR17qJWwnnCqhm3p6DwlZV4jghEQBEWWH7?=
 =?us-ascii?Q?9123V4LMvgwSUT0w7U9Xvrec2D5uVF/vA8tAQY7/yuOPQgLphQ60xNBgE7dW?=
 =?us-ascii?Q?dYYtjqM4oiRbf4Y27iNlr/njqR8bqDu+oUTKC92QtH6Sx3hvKCnrCxAnbyPU?=
 =?us-ascii?Q?3KZyrXujOANQ73DBDuAzW14gWClkZ4ha+HdzQjRDqln6vztjEQ6PU5e2GU80?=
 =?us-ascii?Q?ULb8dKgQqjRfVbIK6tMsQZ4P/TCT97mqNkmqV6MgumH0HCadAPcG/hCV+Qkx?=
 =?us-ascii?Q?yDYr37AViOnia/gofJ2gGWmqRMEUtHQURxW2YslikXCGMssc5dEv6UZ4Z1Hs?=
 =?us-ascii?Q?goqkuXhUqGUU4ZdhALaG/+V06AeXh8YgI4XEQpECxvySsDO8QjwDS9+exFsO?=
 =?us-ascii?Q?HgbNoSsFkFSBudyT4Iturq3pVC8jyKPJr/iKnZKViRNi9UyIf0ZKgVNlPLLO?=
 =?us-ascii?Q?Ci0hgUQ9slljUOpF6Ku0SmtD/mIpPWfPHc6/Eit7Mqeto31AKGBc3gz+zwBR?=
 =?us-ascii?Q?yRPn+2G9PJO3FMDh6J2wPYOzYM9FjQhmRMPzXaiYcgJtkruINxgQ1UkCo8JD?=
 =?us-ascii?Q?1k2E0od716r3KM8L1wKMv7weXCQLZbzWgXUMeTWvW+lNbMaJIcmRwPvGrE3b?=
 =?us-ascii?Q?FmAdRqhZJfEYuKAFjVKgxuhRxlaIMqiyAn94CCCuhxymRza8SqhbOu8eSuT6?=
 =?us-ascii?Q?vm5BxBQFBNdbCl/Vc9mmSG74SgIyIW8MHS6TaYN1NavE0heUPxUzagFJLicU?=
 =?us-ascii?Q?iWInxi/R7ZobJMj4oaiG0tU8UKz42KbI9BXRt+GQLXDuWIlUVg5CqJRx3W3S?=
 =?us-ascii?Q?MplWJrpo5dBcuB1J4EgyXAEuKSlaOoQLRoG2E6GRWDDZblgEcvNja5YuUN9/?=
 =?us-ascii?Q?GeVKfFz1ZBguIQVO9gM94eyj2Jokn9R/96AtO0UXzGW0RDuHdmTvO7kKrU2k?=
 =?us-ascii?Q?M1ypiSI0JwwSkdqeb+HYRGCz8eS5N7PuIUhZflT7HWqchHKcuEBMWx3CSbDD?=
 =?us-ascii?Q?vby2wuZND4c4PRdfzkq2WNRL8CzYAsn/hPXkDvhItCU1XlsKEaFDfHukVxBS?=
 =?us-ascii?Q?2T1yksgE1MvGd4WElpUb4Sk41+EW1ynQVt7i+AKwAeSaxLuExsI5hRvQFKNj?=
 =?us-ascii?Q?+1kdY9QOJFaglIweFZZH6nTRyGz8m0/X7YAHclWbtV9c3VXNb+XxKCw7Qifx?=
 =?us-ascii?Q?23Ir+s80VwjZnUYD9U1+5/2Bwk8MLzwU/busljIyldLOKqDrRMG/J/kMd7MN?=
 =?us-ascii?Q?BOPXgjmjpNWkau4YZliAfqpS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da55836e-0e11-4429-8095-08d91fa97f00
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:29.2128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K6ITOLTKJ1+IwP8gq3tarMFEhpAKqT0+KhFQeXrdXZKzd6zeBSDLsX4gfqIo8zbXxVOFNfCW5w9p92ZHbrb+8qV8Kb5Sa3DMHImJfmA+HAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=986 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-GUID: HWvWTPb0RRZ088wd9BsZNYbPk6a9IBUL
X-Proofpoint-ORIG-GUID: HWvWTPb0RRZ088wd9BsZNYbPk6a9IBUL
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 5.14 branch. They focus on
iscsi and scsi error handler bugs. This set combines the 2 patchsets I've
been posting to hopefully make it easier to backport just the in-kernel
fixes.

v2:
- Fix up git commit typos and spelling mistakes.


