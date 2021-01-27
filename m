Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BADC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5502D2070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhA0FhR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:37:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35080 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238627AbhA0E1H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:27:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4LfLo001639;
        Wed, 27 Jan 2021 04:26:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+8YOsfkv3mfolnJWhsvca/ymVDVX42COyo9Y2Nvx2Bo=;
 b=WTMC2JZnjrAesK5EF3c/VjsEczw6jpyobj2AWEGzk1xzqtSF73MG2CNMPy9KSwXznQk/
 YOysg9PQL9Sjv0BEs3yE+jm9XVK4DCsEk76z8WzUaMPRr1L++DB4V8RipGEiizs/SH5h
 cFRI2Bzju6Ex7og35uAi+UqKsSI8fOvbqniycjWuRzX8vkpEmAjH5jK8AzK7UktQTu3E
 sjqa02UV7lpEC16705dqaPs5iqtd7GX04aEcwD4K/MvKPkMQc9gXxpHWZ1sla4v5HqcZ
 ZY7Kfj/svY2RADwYScWJlUZm59+x5JwgSyDvdrZbpQUEADr4mI7JydtBVqO29fyi6ls3 ZA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 368brkn272-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:26:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4K8Rq010944;
        Wed, 27 Jan 2021 04:24:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3030.oracle.com with ESMTP id 368wqxahmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:24:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmdpA7pcuKyVv1NOYPMbfjynp3Q+/PVdmFYhmbyjEG1M/izVTX2Jy5ARvhJfNF7VJbF7xpeNrqmWQKeNlugyb9620SuJNCHliXWjj9247GvXxWG8Gy988OUDr2OIlMjLcN4KkTH8ygCLiAzmqLqUCfe99eBHb1NSJsNyci6VDjV7FGWaeGbaDD05uOizxChNo0OXc39R3n0OIM7iH/uhBIwUSCWsuNMF85nt/FKy9QNzKGHu7j45UTBMwQNDg/XY1yK0yq42mMGWPl9yhV8GAiEiJTLMTi8yrgkXN3eq7oK/i6s6JiEhNB9QdwYTUXWqW453AmnTRNvRt5KqOli0Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8YOsfkv3mfolnJWhsvca/ymVDVX42COyo9Y2Nvx2Bo=;
 b=juYr0q0TEHBM/wEqoIi5RDrOb/OIA20PA/Zs9vqHRVRv73a6t1SRmrzbo3RBvoigmC70/y8+ySDilFp+WhFUNUvenCiwLlmpwlpQLPhA0B+aB+7lbSD+IV1+tZLE3WHHUGzbG7Wr+sW0jC72sTlI9xmmvdHlRKnegxZ9iVpQZsmM+Cxnli96srp1yvU0Lfwn08ZDMzvX84rn3ivzxP8g2jeoZjflFKrSK9xlciW+i/hkVFwXdY3uFMlV+tK84UFTreFqsWUC6piao60q+OcL6OAJG9zc0zZCq7moZVl1Wk0q8ohvGpjJ1SQFJannFmgaABJiC5DO41xDIUSWqcvpQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8YOsfkv3mfolnJWhsvca/ymVDVX42COyo9Y2Nvx2Bo=;
 b=zOkiNWk06ria5H4wKU1ghxBch2CzWbyP87/jxEtsunMpWr1shOortN7zcSxQPj7QEQVb8NWvgz4qQnjxKTRSccP+FPE77oRZRwzzUODIkooRudjiQtGhixvFdOHFA1FvX4dQA5q8SnQkxdL561CnuyrTfcU+pef9caooWGbtpZ0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Wed, 27 Jan
 2021 04:24:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:24:10 +0000
To:     Patrick Strateman <patrick.strateman@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] st: reject MTIOCTOP mt_count values out of range for
 the SPACE(6) scsi command
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czxrqai6.fsf@ca-mkp.ca.oracle.com>
References: <CA+-=Uwah2MS_aD+PeSBkQa_=1wCD+3=g6W4PvLnbJ_-px8G97g@mail.gmail.com>
Date:   Tue, 26 Jan 2021 23:24:06 -0500
In-Reply-To: <CA+-=Uwah2MS_aD+PeSBkQa_=1wCD+3=g6W4PvLnbJ_-px8G97g@mail.gmail.com>
        (Patrick Strateman's message of "Tue, 12 Jan 2021 21:24:35 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR12CA0001.namprd12.prod.outlook.com
 (2603:10b6:610:57::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR12CA0001.namprd12.prod.outlook.com (2603:10b6:610:57::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:24:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9ab4e42-1623-4a64-5c90-08d8c27b651a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46152691A8C79378212A2FDF8EBB9@PH0PR10MB4615.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WIE375RpbwgVn/NKp4ywb5ZL7pbqzpnFw/7Qg5E/J95sgovix2p6VWQXadDwogO/okBnDQGlEwDinYiIMy4RrVSW6f0Sag1+Ay3W4u1bpBc7qWkrAc6euyP/BbS9O/1go7NZv9JECwdHOs1ufOu5M3ru8QrT/umAnp4nnk9YjBwniCndD0ABCfw/1/IR93i7/ulwYXWUYRJaMRg938GgHHKrFzllPAI/kUPpnl5/fRhbmBnNIvPE4qXGzSdpn9YxaZPmrqucVn/25/xhIxTfeVOiTmHX1MPXRweONgEbH2YGbWZp1xhsqiQ5bHLyO70KFWywrUQmEhbo3Q20xMllc+ctgrmUpsjWtTPx+ENOUTAOxdwfnL8M2giw6cxxYFkuQeeuvggg9og2cLPy2DnNdasyPOK363DWRe5sC6GPfly2BdAS540ahwDw8cP3FbnGntG3LmbBMLMw+aEger4bu58U3N9HBVfe5+g78v+beueMgX9a5tYOzLk7LFxEUcddrHrt0bSFX9GM4f1k1DoCZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(366004)(346002)(6916009)(36916002)(4744005)(86362001)(52116002)(6666004)(66556008)(83380400001)(7696005)(66476007)(5660300002)(8936002)(4326008)(66946007)(478600001)(8676002)(186003)(16526019)(2906002)(26005)(956004)(316002)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4f9EVH/cwb3a3QiozNiMux7KzgHeBh8mK14gGwa2YccXPd51J6zkzth0FO2C?=
 =?us-ascii?Q?ZYg7YcfTvAMk+vdWecqZW+yzGfkBNq1ttGi48XJUkg0soKFaGiyKrJ4dpzJE?=
 =?us-ascii?Q?tTFqzocgBy8u5FSKur4+j8kif7c9aqP9M75edz4NKNrWFAg1Chez/xH/bLhK?=
 =?us-ascii?Q?PhYORI8IOq3DJXr5OtF0gWTsn0r1XARyYb2lIjVhxKENzn23lzH/8pyLZpuq?=
 =?us-ascii?Q?uelORq9kSubhXWmZeqGJuur1u5RbttYf0A50Q9PznU9PaAzrOlC/9XoyNbgD?=
 =?us-ascii?Q?jtfLI44a6k1GKUflr+wXDYA7ThgCZsh7ghk3/VrznU6HspZTJTzT7IhEo0J5?=
 =?us-ascii?Q?bPHxUW6vr2dFtG6IlLR+aEDNuyCayYIPOvStFo5/kNS4wXFVLMDabJMV3cvi?=
 =?us-ascii?Q?VMPHBgVLItxedVMvaYnZFIhV5MY0ZFaaUYc5oLYzNmdqYeZl80wZdyXjLLnl?=
 =?us-ascii?Q?69Q6sLnmkctdRJxUOwVH2pONjEgNBi8vG5GjT8EtyroLeSMjZsouhVtWHfAE?=
 =?us-ascii?Q?43Uu+qvXE7LSRgptMjrblMskuGW50x692VWpAIxDfPOe83gzaGGYF29lppNX?=
 =?us-ascii?Q?72iGX0HZrqMtRUQUW9wXhU9Zo6y+V342YleReLwb0Nw8kXEWn+RDsuBUYq6C?=
 =?us-ascii?Q?B8+hgfToSe8ix9n9aJj37TCV1Ac41r1+g6qfclFfh6lF7vuf/SL1XI49Ti3F?=
 =?us-ascii?Q?kx3yg8UF6YF0L9LLlLV0wB7fmZ2IBbvK6DBb7Ihws9eOCuNLHzAxqUVYMUOY?=
 =?us-ascii?Q?1iFXv/+p/jjYIf7XfT5ACDYhylC9staPowwQT4Ng5sBIrQHA+PH2egQkAAuS?=
 =?us-ascii?Q?nbH1VnrJqLWvZ3qumILp1xov0WNgTp5sUWED098B+wTrUnRUe5SSMZQZUFKA?=
 =?us-ascii?Q?Vr6U6q3IKHDSFTZCY+v5Fdy0ViXABn6XU0zGYrhQAUESGmjOynLfaKiCvAFd?=
 =?us-ascii?Q?MkX3rWuz+fhKWtPrSktArRjH4UQ75CSnmTaLEtWxO47ZGqGY4yBBzHmJhQYg?=
 =?us-ascii?Q?1oxUVoyQeLtepWpcFjl4WvDsNgs0suT41HaZ/BS4pBJY/xygCMB7jfTCtzX4?=
 =?us-ascii?Q?nDvjEqa+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ab4e42-1623-4a64-5c90-08d8c27b651a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:24:10.8167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R1qiIgNbg2DTvDddJXeByiqM+XHXLbC2dMGTB6+dPsXbkNkPX30CMikXYPtG5JAE8YYBEAbR/5AQBNpEZp5mOIqGDvRiiERxQimApVhSH+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4615
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Patrick,

> Values greater than 0x7FFFFF do not fit in the 24 bit big endian two's
> complement integer for the underlying scsi SPACE(6) command.

I was hoping Kai would chime in.

However, since SPACE(6) has been deprecated for a while, I am not so
keen on blindly enforcing this in the ioctl interface. I would rather
see SPACE(16) support added and then have the supplied count value be
validated based on whether the 6 or 16 byte command is being issued to
the device.

-- 
Martin K. Petersen	Oracle Linux Engineering
