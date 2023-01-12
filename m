Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C7DC5479D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbjALDIv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbjALDIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:08:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1437F4883B;
        Wed, 11 Jan 2023 19:08:49 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C2ut2I022855;
        Thu, 12 Jan 2023 03:08:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ZH3VBLmwGpTl+b24FoRhrgQLmK/XmGoUFdJHHQ5YtF0=;
 b=WcG2yx30jZU0fNOMrusHtP8MOemXNg1XmvvppR3MIZiUoaLphu23m3fHSYHsjp3qexBT
 QrE7e84pl4ywf9BAN0iIOK644JlcwzJ6P8QJ9++lnCpIplAmPV+S684b99ygK6mXd96t
 /RoaKQN6B0doSOIKA4Z3BNGw+z/UlN2RpY3Wm2R8Cs5jGxQf5Szq5xwQEJOIOSJeG8B8
 bEv7JPvoFzPaCKqoixx/K0yZvzxtBHiQIbfk2jXg6SeTZcyRvHK6YkJkbPdUlkgBIyy2
 5BTojUeUgi2LBnfZPgsQXdFnWpVSMe1b+SGsmw7GrhEtH8+BEX/r2rnPLWtRqAyiipQE 7g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n28ja82mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C19Tc6005297;
        Thu, 12 Jan 2023 03:08:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4akqmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZZD8Va9X7ft8b7X3hP4Ts4vhiN3HkrnjmTFzYOJWtat9XH2S3NKz54uJEoFn1/H3LB4vRLIMHrE0cC8IxivPr9ncwHlB4bdHFMawYgTME1HDU9VO78IzKj5NvTgBi68eEXTVZN2GLkvpDGz/9ObZAopn1ZgwF4Unqf9rsstDUq1bk3tLOnEbBzp3uEcfWw7v1D92dyYXdYc0duFM0NT6guMuCJ7Tqc8FkpgNQ7JFod0emYvjmejjNK6WomMB22n7iON5e+159lxAsFmxnJ307j9115dAjH9z2ki0B2WI0LDkzxw4tPvT8wAkNhVGyPmzYGnN4KvHRpUPAD7NNPdIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZH3VBLmwGpTl+b24FoRhrgQLmK/XmGoUFdJHHQ5YtF0=;
 b=g+60S7QQbvYqw5LqQFnzJFrjeKCI28l/gap8ao9PlGvsJbAj+e7vddOtminy53f1tsGhDWM+HdmVCn7MkcTnbG7wxIIjOYrKwF7fvxPHIgNqXE9fdXbXVKUigenoIa2q22OtFIJyHRBsor+FnZK84luLZueLP7aV4gpQZWEtMZocHVIFqAbqfvi0VijULTS4zwe275IX5oRWJERQwu3KL8h+UHRWq5oVg8Y+GGVtUydWYc/ICNSptuYQ/SGI922nUMKFyFnPwAVnYvOtjvBBnpde59+7UmjC/DFeKKPvisspF1PazE7PJTZsR7QXzp0epSXzzNGmn8S5s+MHRdLN2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZH3VBLmwGpTl+b24FoRhrgQLmK/XmGoUFdJHHQ5YtF0=;
 b=ZMCK6MvnRToT3s0nyfQI4xUPHYVoa7qInWLsYMCI/MUrK0TvrRh6xUT8jv/D0DUwAtQdzl4gJK9bVrux8Ft4fAEaIwOfQChqG7vzqtXr/RvMYO5Xw5HjVbICAUuv0O23Zd+T+RI5v+c/KY0/XpX4UtpQ4arzjLihKCgsYxEVwBI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH v2 00/13] target task management fixes 
Date:   Wed, 11 Jan 2023 21:08:19 -0600
Message-Id: <20230112030832.110143-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0372.namprd03.prod.outlook.com
 (2603:10b6:610:119::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c0cd1a0-cfab-4519-8831-08daf44a4b3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kFIG5pzBPKZeiLnXi941vkZIG6EX+Vet4sQh85rnzpWjAWAsuDb6v+JbYj/bs8fVcTAMSkS1gQpS+eycQfH1lcBO++Nc/SS9I0hBzMmsuJxBAQ1OLtUxC9bTV5adpsdlEvZ+dfblKvMAYxMVuDCK3czNhVP0hn33oO7QJdEKzmukCPkAAjBPpyEYSvHCFXBL8+3gCyeNUr7Tg77KjoRAyn9AmPqytvHQKJzqDr2L6ptizvhAszxFuTBeJaoDMIWgWouHZiYydEQvIJx41Q0iTJT0XWPWpXMaSQE5q5PXXYguCA1vjQRLISLGNB5LTgx5WY+BHe0ULDLVew9N7Mk9eYvuvvX4XCJrybg74rK5lUDolYdoTSSxQjlCYsJS8SkLgsxdN6H+2byIgUm4NJw/qoAPxq0JoSwZV8s9VDUHQhiPk6GPCJr9CBzGd0JcxOrFTwKl+g2IacXpj4huPrBEO9WGFvwrFBCvyslH8KD8dqH6OM58E6SB17Fu/Q5XcEXaxR+3ZMJSKlF2eYgobzSpAk5wm73XXqh18bsMCT+H4f4E22c7Zky11XPtUS0zF0AnNV3m6jiIlvW+KTRW3tRtXyBXeyjR3yIWxhGQvs2194Pyzna9Zza73YeoxpQyA1OFpTXNpHIYAfoLH8svj7GNmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(6506007)(6666004)(26005)(186003)(4743002)(5660300002)(4744005)(8936002)(6512007)(2906002)(8676002)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kdiTEDXQ6VPuhe4sdgX50Kfo6I2zRXJXEcdX9t22pZ02qdaG2qwNNpBiLnE6?=
 =?us-ascii?Q?AonKqoqB3j2SMmpnVvPObHJGAW7eKFzzh6YJbycRIxRZIYdQVZgrX4Gs4HL5?=
 =?us-ascii?Q?zBcY6iasrxyEMUdySW1FB0FPZUtXHADQOrceGQQ+ZW13kc8xWRMwQ7xFanhI?=
 =?us-ascii?Q?Cgzehre04BIIVEBRXsCyKRCFRnYsSb3wRE0/2lAIjQkwHlsqLJyKfhazOFUP?=
 =?us-ascii?Q?WWA+lKEN4BWnkdbeMAcxEa3CIeiEsGv9e4bI+dbmGc4Hu1U+Y5pRBQemN5L6?=
 =?us-ascii?Q?n45NGFAuxhgZw0ZFgI2+xTIHuqQpFx3TmxWXKQ17ieYRrit8EXWZm4lFcobS?=
 =?us-ascii?Q?3Fr4tjrypffJg/MJ4xSUZyPHasZCDIYeYBc9RrGwy4V5yg5slk40f7lt/Nbh?=
 =?us-ascii?Q?+nCUc89EwguONFb31rUBdkqKJe3R9QJ7CwO+S8PJAMFaIhIylYuZ+8h8GpkW?=
 =?us-ascii?Q?SzqjzCeup8FWV4peIwo5DCBJUv+H1Fy0b21DQFq+jHkKmLSxpkKkul7Zo8nx?=
 =?us-ascii?Q?/wZK6795y0NnGYOKIv7bORhCaiDIC3NE0X6XGlivF6otuRi6gsA0Pw7sZErf?=
 =?us-ascii?Q?XQ72QtRMPNvKjWcbhVMaR9f7iCKBaRarncDjSMxctpeZgXLm3UJ2AI+7WlJx?=
 =?us-ascii?Q?e1tbFDVFVZgJTl86H/9M2a8zcmqqQyYwEm1S1hOq+xh5djCbyyp+tIF1SAOQ?=
 =?us-ascii?Q?v+LHUYX/VtcPC33sDxYRPQu4bS306f2Nz0as3gcIeZ66ZsTtmNpbZD1Beuta?=
 =?us-ascii?Q?ws73leQxlFjmo3JHEQSAWLqBe43TUjtZKTvWEuQ+ylPnaPWlRbt2KC0b/XfK?=
 =?us-ascii?Q?x44C9suCngLlX2rf61HrStzeljA6a23H9zWRY0O7BBE7zQLpogl5jWReZOqq?=
 =?us-ascii?Q?wlg5AFqyA6YJZx9eufS4+d4pe1KyRRLg4u49SlTLG/0aixBAqBcNcEwp5/+N?=
 =?us-ascii?Q?P/DEb3UNeZtK1CvndEYU7Vly+qrQI5CeX5iTIFWJapmXHKj8o48HL8QfKJlw?=
 =?us-ascii?Q?QeJZan5+v3FSZGB7TomAR+832TFD+yICJbp54g43CF9O/secvpMRZjQm3N7J?=
 =?us-ascii?Q?k2KMQZ8vc24IJe2IKgS8Szin534A/IOunPDhmlzBhtYndyDIHyQy59TXTPat?=
 =?us-ascii?Q?SA6rvBNzsD6/T46tP5MQFqNevZUrGrZxvKOedle+rK4zRpLUVC+PHQwoxt3v?=
 =?us-ascii?Q?IZanehC+ip8eLq1eAfYoGtXlKST10+NZCIe9zHBFnBrnkKlNR8JQTe+NqS1n?=
 =?us-ascii?Q?VogUR1UUXgt2jHCf3AGBoAc39VMNZS29UTXpizlhLRDum4QOAN6N+Us9auLR?=
 =?us-ascii?Q?KN8JWNtBeTareW/AUytVqvOqvNVdg7XzLfANwg+MLnAn9vykkd4qsAX3MZQg?=
 =?us-ascii?Q?gQ+4+Wi8Y+pWE7keF3yGvGa7aI4lfqHuMnSfv2hKumcWxbpvpMljpi/3hLBG?=
 =?us-ascii?Q?D4eM1bl48aVWx4KDmZVlZLeRHptuI5B2zTe9rf50k2KjL4ktndqt38ne680y?=
 =?us-ascii?Q?zAVHHyxJ/S5itoW+IxTs4WMesNJsM0isYF0tacSWaJXJNrEXiNsCsAQ6N+e/?=
 =?us-ascii?Q?QEaBXLZ3u0tZM/7gz9ffXDXbBibvUaGmr5rUlpE7XnNa+/Rinz2CvozHtpzN?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tFPkycPbiNsHL/qWxBYKktUlgs5NtYffD9V8LL0OQMNoEVdFShpzLkKN8cJyuj37bOPN95P9nOJICRthqQZqsBXe28p4yESU0O4FJK7ePv5qLY22XEjOxx2yKJWkbLWhGw5u4O2xxsGYzHTeIZcVoBMtYxC79bLOlG78Mn38Q3f8niYb8EQb8xXhKBwsDhQFGRVbtPH+DTL5t5JJ1v4Qjfbqo9UmxBKHtRQ2Jf0waOLLG2NZHyqH8fuy/+sQuj/vUqkx8pENx2xKQakva5kkhYGG5ssLlQjHHkwWgDjtxVJZKgS9AolVhWsnBZW3fF4ZtCSSWrrf2diDGJRHbA3PLoFtS7olLCQzrOqr1hbvnhgD5UsuNhIMZM+2H8U1uf3vEnVwtKgucDvO0fTT2bRy7VrNtSyeA7MohJAdvXMbx0SonJhpt1ZXF2yCK+z1wKInqCYuM2w2e/a4kAuHESGYK7EqtLtXcj3rej8PbvKh1KGWl7XI35drdDhJtDBAekRhrNd51QoItLWyxmxi6bV0xCn9hUpnmvAZXrhC0HdovsIiXGxSod1YiPpOC7zTh5lLQErq03fM43NMvOQmsCqzmz6XQNV50KKDHaW1kQBhCeN5l/LpKfaCFSrhBHoz5nlhJPzntyrRZ0wKjxj1PTYNR14Korm7NvWOO08Z7jV5kB6YBge8ZpQ61HpVxC1WP5Hw2YPZB84pJAJjyH9Uuztxpgi9rwhOqlhHHIYWJt7e4IRpnqNfZOYX4kL/i1DUpIn8GlXmUYy4wbLQarfSZV7hefmTqR8PEtLlyovDv4rRamrAVfl8FefbSNQ2Pg0NShJZlBtKzwyrXSgFFG5aH8b6fBwynB9+9FZwUXtcxqz9DldHTc56iliEgmAMbzN3dT+5
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c0cd1a0-cfab-4519-8831-08daf44a4b3e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:35.5680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFXUbeN1DCOLfb9LHPakuMeQr4MivABrJkfDF6jjQ2cYYr6v/2ScVujPCwT3CVXP/RqStAKvafbyzDC/376KFGM2P5uT6wcsh3fE9K9ePdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120019
X-Proofpoint-ORIG-GUID: RSXmHCj7GArrJhBQUuG411zBlkA40ykc
X-Proofpoint-GUID: RSXmHCj7GArrJhBQUuG411zBlkA40ykc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches apply over Martin's 6.2 and 6.3 branches or
Linus's tree. They fix a couple regressions in iscsit that occur when
there are multiple sessions accessing the same se_device and TMRs are
executing and a connection is closed. And they fix some bugs in isert
for the single session case when there are TMRs executing and the
connection is closed.



