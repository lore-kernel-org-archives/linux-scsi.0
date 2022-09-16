Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21F4ECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 01:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIPBnd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 21:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiIPBnc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 21:43:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E593C792E5;
        Thu, 15 Sep 2022 18:43:31 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FNnCWB020734;
        Fri, 16 Sep 2022 01:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=T7I3Gt8N35rM+MZO3U8utbT5BnGZn51XgoBVcuyToY0=;
 b=peVdUJoYIgzr/MIB2w3ld9M0EZN7IrE699srE9mSmWZdFOSZOiOTtaMlODwjr5zxriot
 k5zA4fXnZ/FnJ6kk9Xk2G9Q4nJDfHJjBoQD0TTZTayiCmYkeXBR4fq/VCeIrU8LzFTWT
 mX9/fMoCb4eN2NYFhXPxvJisBSDm/S07W4xV7sEGpgrCTSxvl2KxPu8co1CVbIGYLLHy
 bdsW1eYqyZfSBIH8eSYx5jfvDnmIwTBGNYtwFZpi6iqX8Yvi0mg1sfXLcwo1EI7/MEpt
 C4ddIhvqtDHBrrty4X6MH5bUOGLEmqwmi+Q1wpip9z/5hoGZxnFTJAmYiWjpaZANRhjz aA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jm8xc92md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 01:43:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28G06Lth013243;
        Fri, 16 Sep 2022 01:43:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jm8x959fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 01:43:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNp7IhaWjNvCvC/0tCBixju2PoueZEjGVIiIh2Nt6ZUva8DcSEyx1xxun5kReAzC8jDFE3VlZJESviIS3yA4N+C00sKR0s1q+xhFA2WCqqsq0DWSxCOumxPjNLYCZqKj8C7X4D0xGjkVKcAEFKVVxGnqyhWotTFQoIQ/yFB++FkLJcS1VkH7n5PnS2Zds2YJDuj304sw65xVbBcM/K9MjeGPZ84O8jTpxKXPu34vOynDUsS4ccMUCdIDReIjF99NWyUdOuKSAmxAHFeQYKtSQsDHwHQZQNNS1NfbxVn2rh0xF6TFx1w6wJ4s19QbyPYqjPqV0+r2MFkHUHJyhRz+Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7I3Gt8N35rM+MZO3U8utbT5BnGZn51XgoBVcuyToY0=;
 b=iGhg8iVpnTtbo8UPQ8A0VuUQJIJMtKiOD/ZiVr1xluqS6ALmELlQoDS1XOdg0ZlSHGElIorwaoJODXwZgMXXaeFlRUj19fskh0wz7Q8FYrOqCHhAIbiMsjg5X3kIevmZsL8Mu6tBHrhFLvBSgfLKQ4tZt++2mBiS0xs3SygMNj7fNurPEe63sigM0BBieyFUJiij0qY9JTtPf0/A35c3+5l06sSujEKoiooOaqFtpY/GAZ2eEFfQfIzx7k+SbVJR/3I3t2jWFdWoSGocYYqueg55wPYjp9Hsgf5SpFUVXIgN5CuKzbVJsjyOuETJ8FeGdTCsa4mIxv2O8tdmhZYhOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7I3Gt8N35rM+MZO3U8utbT5BnGZn51XgoBVcuyToY0=;
 b=yatE2MGVaIYYQkxyIwLsp/9Sdqo4wfBBkszkS25czWHwUNRppXm/rBLuKH7pp+o8VQy8i+PEdb8O9GhvYNhBFPwYbi6+3lkz99SCeHeWbsDrkVi65ZrA7WUWZKhTrJY2yngUH5cWl9eOYAuXKt1X6qKcHegWgCCwb+zx5d4FXHo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN0PR10MB5960.namprd10.prod.outlook.com (2603:10b6:208:3cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Fri, 16 Sep
 2022 01:43:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 01:43:23 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH v3] scsi: target: alua: do not report emtpy port group
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7vg2ixd.fsf@ca-mkp.ca.oracle.com>
References: <20220912214549.27882-1-d.bogdanov@yadro.com>
Date:   Thu, 15 Sep 2022 21:43:19 -0400
In-Reply-To: <20220912214549.27882-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Tue, 13 Sep 2022 00:45:49 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0138.namprd11.prod.outlook.com
 (2603:10b6:806:131::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN0PR10MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 6181f1d0-6477-4124-195e-08da9784d6d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3KPhM4Ihvjyl9GTCIoCpCkcxAjZ6Cr53jGmXcl8ScYMR8Kh5mcccsegsvvrUasKJaZjC5ZxzwmucBEA31rYURl9DYDyDn7HlyOPtuzdNhn33Y6eRZxcWZspvJdWbyHKf/TceCFGqcwhBCE+i4U/sg/Kzfa8n+BsO1KM2ohhBAuuQ49qirg+zGvgAQCJ+bidBxCsuDvlWyDUMcGdLDPbMUdB2qYvQ7DFudF39LHAAuGykgkQqFd3wOV9EVGueh/T54+nQkQWxucVBkowsGpdnjkPJwlin6NZY4zYwjGdv7J3w4ZIHcQ9YenvkV811TSf+Xx47tFNCuidYWHnjKlPOpTX5pmKDc7qN9BDiqtdSWldxJfXW4DBlPU/sbAoQ/a5KjxLX0pUEkgsWA+u+KqJj2t1lEvwy/BbWPJ1ZJtO9mJ1ULpTdGkcrlMl/atbAvlkUMjDPGC5bRm49n+wpF7VYh+ELPBvfu0IlWE9xupIZN38cOimdMCDM57vVbYM7BhFdBKSlc3KMtICUi/do7uNNb1O+GMJvM7DcC000LQ6RlU1QpIosH1oZQpP+BCLaZ19StuIW316W5vPzVqPy8DLBIuiOim/p6aoJ8RrV7V7GEZgHpf4dbpZcYxoM+GBjJqepxyQ4PghBile91NFSlMghyMv55qS29srTJxBs2O0SpLWqSk0r4odUxwxwp79b24DK4KdoEluHNSVnor8K/wNLKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199015)(6916009)(36916002)(26005)(86362001)(38100700002)(66476007)(2906002)(6666004)(66946007)(66556008)(478600001)(4326008)(41300700001)(5660300002)(316002)(558084003)(54906003)(186003)(6486002)(6506007)(6512007)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?28OuCXHrO2Zla0W96fYER1e90mnch8foP0yWB9cJFIJ1qKm0eM4gGcQQkveV?=
 =?us-ascii?Q?V2JS6GYYa9SAwCsC+cvz6xB2SRp+NMUsn8gAkANfT2DR+za6zHYkIfpCYL9+?=
 =?us-ascii?Q?7gRmExioZ3i+b3kzbCtCVSJbLqYq3JuxzE0gbJ1XQ28+VCJy0LPaiw147n08?=
 =?us-ascii?Q?btRmtVaCb5AzK9svXs/xz9VvBEv2+WGeqkcb3P/qjofVlq4oP+Cxc1NYSt8q?=
 =?us-ascii?Q?pn8x/ioHpq+p7o1ruE2elZJrgGYO4/ojLV0jKliGwrKdMsbx7PYIXbrftB5R?=
 =?us-ascii?Q?/ljruBOAVfXPxxaQCIXu5NjJKZ25dovpLX/OQIqVIAFWyYEJN4XncKaYA/MC?=
 =?us-ascii?Q?TVUEU0KcqkzqvGNP5W8RqHw6SJ8kVj+4v4MMNiZFd4c8Lktx8qpJO39vKulO?=
 =?us-ascii?Q?rKvbCRYQ++b5KpZ6b7rCSCQXdVOetDPyuPOsDI0rXjdID4/+DMpNT+VLGxpB?=
 =?us-ascii?Q?TDGOev8c6d7TtJg8x5cLPi8nH9AiA16a2cwb5NjUP4oZ1V9BMZap6XDgbfi4?=
 =?us-ascii?Q?5iNK/di+r+gYl6K4HFkbYp/HY1gutnIzUXyV2A/9iDEiXY73tYez4QJyYtHK?=
 =?us-ascii?Q?gJ3mixycf0Sk/4vFvE3NxV048JsuerXOa739V8ZvGl32LDuG2Yn53D1Ah+ZU?=
 =?us-ascii?Q?AWlfvN4uvh7zB+97lkKEz2sqqwGOe3s3IyLe+RYHZ+UC6xfE7fzLQsKLp2pu?=
 =?us-ascii?Q?8w+qtVldTj44Hig4q9QEw8ZWu4Tz8pBMlF1poQYTpmOcgGHk/1Soei2GV7fM?=
 =?us-ascii?Q?hA7MaO/z2ZXdcl4Nr29TMGf3lVnQoo8YLuj8YEECukWm/dmuWH/SEBWagtpB?=
 =?us-ascii?Q?9lEhRmQuu4vl9Ajt//JajnqTe458BWs/0NL/k4X6ixHeKvhbCXEbICPIsG/o?=
 =?us-ascii?Q?HLBnHcKQUowc28nvnRYykj+JQ9b5rdXYV+VOtPdhiZ91ZiJeOX81duN4eLP5?=
 =?us-ascii?Q?qr3K5+wi/SpAiWJimdfOlVUDL4dsZlGNZWQnV0SSqBk+WQVpY8iwWUbhT4mm?=
 =?us-ascii?Q?aVRn6KCxQAl20UVSwj8tcpcaQ6aDXGeKSIcS9XUFPBejssgoq3JRfXmVy6b0?=
 =?us-ascii?Q?sbHdG57SzmO+mDi1pxsLPatCflapCNxycodsp+Ceuy+ri4XQFSFl56lBBvUf?=
 =?us-ascii?Q?isAjzGKCQ4ksh9fepUIHxiDje/8vzD3kcPqFHzzX033zhvgYxDzuPK4Fm/dT?=
 =?us-ascii?Q?D1I+LcvhwFeT4F4lvG8Oiwz8Gg+fyxyIdQbxcLtjwy9pwerggWMQTyGzVqX3?=
 =?us-ascii?Q?mPHznDHIpUYx7oRg+JdCBO4B//yKBlmbByePjQqLNdGxvi8NrPu6R6ZjisAs?=
 =?us-ascii?Q?qf7mbT/sOgVtX1qUYXOiJ0BnXBmKPSi2v3S2UuL+YQTJDt6Q0Hqxgo5M8sLq?=
 =?us-ascii?Q?amFsgAUPl1RKkiptfrar30fJKiHJwI9GQoNup2AO7hEevmFsBTMdsE35UmLR?=
 =?us-ascii?Q?2fapvbqw+62hx2NT2I2clgRqgeu4jrplbN1kKJIqAClnYzaTTFZ+oj//VjQ/?=
 =?us-ascii?Q?VnoHiQmJq62asUNZ92kMLAY8Ho4JJiQTrhSMQYwPhnkXz6XqC1L8OXMwPeun?=
 =?us-ascii?Q?mJR06Hpew7CZ0RRHl2Jg3JRn3hsq7fETT0ihbsj/DYmGoM6tHgNKm0McreKR?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6181f1d0-6477-4124-195e-08da9784d6d8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 01:43:23.4495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z/SqsnYNfnqWLBH9IIgHQR0KK7myHcAWr58JNQkPBoUW9Fh81uHx0YwPR7K/Z7uEDqd3cFByZGLtbT5BcpJCHaG1zsnRbhIV83moh2dfQIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209160011
X-Proofpoint-ORIG-GUID: Pw11tL_2QPeiN2eZwQ6bCpqn8caNjIFx
X-Proofpoint-GUID: Pw11tL_2QPeiN2eZwQ6bCpqn8caNjIFx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> Default target port group is always returned in the list of port
> groups, even if the behaviour is unwanted, i.e. it has no members and
> non-default port groups are primary port groups.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
