Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE23EE49A0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 21:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjHUVVw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 17:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjHUVVw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 17:21:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE38C7;
        Mon, 21 Aug 2023 14:21:50 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxUt6003614;
        Mon, 21 Aug 2023 21:21:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=i7s/LlFGcQILghTKK73zpd4WoM4mSuE+FNvUWSR4inI=;
 b=vPlAQFCXYY0gJ9+snBK/kIvuuInL+yJENOl1UQH5eWcQ5roZb9adAAkwqPFjsmR6wNe5
 C67A+mhE6sRf36p4ZdsobclRBAqXzF3JedMwOgjQjfNZnqSwOK8XIxOW5hWqhSZNvUfJ
 r6kruj8bOTRWwXInUwk2bFpygE0qawrYh79z/SvM93hapayTF/taH3PZcZpXvY4iEPj0
 n2q/YFU8x6puboBB6xUibAzIztTu7hcaGvGAjUW27ciXiTtV0sK1jce7d0oZoxxjcXkl
 tPJINkgKCH0ECIeVCmEWhDNKTWFre8U1joHlZiQMLNN87JDIahj1Nocp3se6xQxAR0Rf mA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjmnc3wt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 21:21:50 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LJg9e7018680;
        Mon, 21 Aug 2023 21:21:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm64gcr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 21:21:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vn3MQqHEj1NokK8USGF4PAa9/p0AY7UGO4s/XXIM4iHbtsQ+3v8dl7zoqxew7KA9ebpLubXI0vhv3rmHHkWgs4DiCKB405WR45bRcXNHEcgAQI6YUXPeQcaNClBk8rkdxM0CMIVI4tEEse/ZQ3oaEmj2A8UL/hVFbqMcJ8OAbmYVAr7l9SqieS53DnIRbhMyLNzDGyy1k/f/ytNT5x4DA2xK2Zn5IPn56YeEU5atLiZfqSCijKlXHMpExd4cdSGzlnWQSm7dVLjwc2RZR69o1EtXau6K2jb23xeOFE+YGU35zgQuOsbYEM2bBAgyiyLCKw9pmgbTNnSU9PNZtnLPpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7s/LlFGcQILghTKK73zpd4WoM4mSuE+FNvUWSR4inI=;
 b=RelX46f8aQ5+4Tjy7YuKeTS/J3FUSDh+8gDpQEP3fKjswopS+TcLcrY38ocX09ZWvuX6W9NyvDT+mOGdIblHKaS7ZbK4JiFW5oKTRINBE00kvQgwnUwz4k9MTA1hldXyHFlgk89T2rtdYbEIH9+E+rdJha3nZ4DKdVtGgzpIxfFLroLudDpzDWHC1MW2WuLPByUqLMDoGl+4IWH0WQSX5/T7jSl8QJMjolH/NhUsPK+h6+ep3de3GA5tAGxjEiQURlkU/9/OJoy6uvSaNYr3wuP99ueyi0QWh9fFlRihqav1vTzQbPrG6vC/lhFIhj5tFiVmnTFPwbJjR0T849b9Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7s/LlFGcQILghTKK73zpd4WoM4mSuE+FNvUWSR4inI=;
 b=aTtAKS4RiZGJfAmk6l8kc+cbSULcVEyL8JIOBrq4DFisxTSQTWTTKDr+7++whY0STJxE7QT5twRP7C3Txzd4Noz85LgtsJgZzt7LoNg1bKmlfdYLJ0o4mfzcVC5mcTdJM9gRzruAkzZD1iFYo8wu9AKjXfwIAkd6AfvVj/9gRso=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB6056.namprd10.prod.outlook.com (2603:10b6:8:cb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6699.24; Mon, 21 Aug 2023 21:21:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 21:21:47 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: target: Fix write perf due to unneeded
 throttling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ttss5byk.fsf@ca-mkp.ca.oracle.com>
References: <20230817192902.346791-1-michael.christie@oracle.com>
Date:   Mon, 21 Aug 2023 17:21:44 -0400
In-Reply-To: <20230817192902.346791-1-michael.christie@oracle.com> (Mike
        Christie's message of "Thu, 17 Aug 2023 14:29:02 -0500")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0018.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB6056:EE_
X-MS-Office365-Filtering-Correlation-Id: bf34ddae-33a3-4d51-7361-08dba28ca07a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: peSHb899EfgDQfoP/iZ/gWE7pcEVKoorN+CjkIkZ9QSxta2C3D/0qbDgBHopi3tFpf/keSNBeLwFIZ0lVJGnqhhN2n3KHJ9EdMF8Xsv9xYfCzQlBtjpvbJLDYn4TOU3DRVehwxjVxTkmtSZnGE7AYJDT05CBZxCuo+YOsOsgkRW2TUF+cWv8ZWM/mSvBis4g3Ay7SMz8BjhnpR+rRTFsqaHJMFLAGbVTjBkwwwRhusTfrZoNWhJYhXOKVhEw1bU72JfQYgogZ0/SpvKF1gpRi6kh13uabmtQRKTwvowYVbTamudOu6CGX2n+5xMrFiy0FaYSprkPiSfySjTiE8rkpfaYB2+6rJWBnTMEb//j7v1+XVxqtPg8SNKT+w8/A/Ex0bdxNyLWhs0Psuhu9IY/X6P7hLMWJbYqw17CV4XoyoFT43Nh0ZkoUlqr/jmI/JPM1DQGEKnxYKMmjxCrWEPPFa/mLrzXRcRA4q1XqRP5e8CykwaZYiJtaJ6sAJ/F6hqtzhUmF4Yj8pAz0Mgeny6lgiwwXaVur6vPswm9KNobHGMDEkeNdJjox7A0x1YYZhFu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(136003)(346002)(366004)(376002)(186009)(1800799009)(451199024)(6636002)(66556008)(66946007)(316002)(6512007)(66476007)(8936002)(8676002)(450100002)(6862004)(4326008)(41300700001)(478600001)(6666004)(38100700002)(36916002)(6506007)(6486002)(4744005)(2906002)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4DXTczO1kmqCalD/A/47dPbLY8aMZK01YyyeonHy0Derfe60LtzaEdHjq2So?=
 =?us-ascii?Q?nhl7HAjBmOLg1zvH90W1s6GP+9PkDsOphhyB6gX6qfDeHwx88MXM13s9Qbai?=
 =?us-ascii?Q?QUINe8lFVPFepXXSomAebQcUSHjyO/oGvU2UE0OYgumfNM6HCOXgx1LUjsWZ?=
 =?us-ascii?Q?CGAFpmfovPzw5xSa/cIUsDKfSv5PhU27r8aaagu1EB0kmMw7AnczZ6+CJP/c?=
 =?us-ascii?Q?uiCcaUpMmdjW/YGx9oPHyWz1FpJZoQ3K9R3qn4DvmwAWtcGwS7O6vJzS138z?=
 =?us-ascii?Q?TKfJLr4L4U5mgvslklB3YstXHPtSNmGHP+ElX77DE0GuMAg0dfm3M756Wp0P?=
 =?us-ascii?Q?6Qv55qxI/zNjPLh2YAjHvB62Q3fHTIfF/0z4w1XeL55oGveHkZli1CjW0B7k?=
 =?us-ascii?Q?ICrXKJCbFm8VKkHNAbuLzbSaVqiUYb+2xqgon7mUjfRaLufC2hZZn1v+k5Rw?=
 =?us-ascii?Q?aZebY0sp/rTfdbE9B1OcyOErUBHVe41yXTP2RWnFjt8qUWewzyBwGklQ+WOg?=
 =?us-ascii?Q?AqLSnqRZ4aPlJOHwlKce8+XpsU1KgP2LhJd+Vy4SgFSMYZh5amNvO6p7HRXb?=
 =?us-ascii?Q?13IjDZymhJ7UkW373fipFAWPKFi7/6Dr2MWRSWgf899xOksPSKWwaKHdUSx0?=
 =?us-ascii?Q?y1sZAo9NLwMkHyxh+zKwC5bYMB2YBQn9bIKOC/Ong0ePhJN+Uq7OiSS6joFA?=
 =?us-ascii?Q?QdoExJdvlzp0JLDxDJ1CIgyjPKWNfZIHwbOBnzuFBant7iGgnzmFSBsnm3Q/?=
 =?us-ascii?Q?AFs51oBdNGFPs13J85241AgJK7LSTCtf+MIv4HsSB862aNSympWJ5j9cmkqJ?=
 =?us-ascii?Q?UjkgT4rDGrg+gI+AEMY3zQy29/ENqFIU/omT7IV564EkTDKxvs17EZoFP6SR?=
 =?us-ascii?Q?xROJr29kKqtDdWy0/mWfKc/1uL8hPD/gGxPxNCFGqrz1VCgw6AnifWUrV8Qm?=
 =?us-ascii?Q?Y0EukwyXzIIQ8/ItpvwiZMeLoYNjNa1+rAnZcL8F951mxBimbMQiI05sdfxI?=
 =?us-ascii?Q?fd4cRca6oQL3nB/EHM6Ow/4+R3zYS2rmsEf32fcllGxbgXmmHpk35RPOqSra?=
 =?us-ascii?Q?LbyiV8GQlLsRYO/vJVDK03W8rxkFVaeha1mQDaqTuQtav2+BMKPk/e+5m/To?=
 =?us-ascii?Q?V44iR/g6vTDK2WMkHlHs04FZz838Ylzeh7VFceLSJrpf/mD6EMgqPAcaxhyD?=
 =?us-ascii?Q?f5uOBQY04KM5ORYHorzUpIGsKxxxJGuZ+8YgISqcQFOuObPGH7+eFVt920gw?=
 =?us-ascii?Q?LvgZY/tUsM1PbSw/yv8NCvTWJHvxxcF3be15r1XOs//8kBEylpPRCnO0pP3/?=
 =?us-ascii?Q?YwiNeqIOyx1bB4LSd0j4LI+2zAweUka1EH3MnrDpT39oJqKqL0M+r/qaeVuM?=
 =?us-ascii?Q?QsFm1C64YML3FzvGc6wlanqsK54ysT+eNLCxVjzmKw1FjPzqD0UOYRnumWV4?=
 =?us-ascii?Q?pLGUWh7RqmtWLAbjZOmAsy8XRgO0eQiz+lppQhahZqcuqyP1XbsYHIXE4mif?=
 =?us-ascii?Q?TAzcrR4S++E4v/KZcHQFSR4rCWs4Sl0ZjZ+jyyFTNtxyg6TEf1stitM6lQ7R?=
 =?us-ascii?Q?bzDJAFLzs+IL6r/uf5NSf22fQsPEwzClo1a804S6+yxaUqnigkaN3CL8fSpz?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: B+Xr+/tNw2mVQw57XZ1plcWyxJQBYcf+05mHS1PeHt2nYhW6x9+ttaWuTHE76ofwPeMFgAcug2dYRREpVy4mjbJKfx2X6X04k4VfbDnjA/cSNg1BA13F2EfJcujkKBoKHMQYVXcWvL8gnNva1LItBv9JUonYJfB1Ja6eK54dMcc1AVl+3QlYSMWT2Lzxfs0hBb7T3tioJBrjRonqMR0zn5PriZmol/AC7zQW6aXtaYVpMdR2O3hYGNwmqpM3jpBTzaqs0I3IuuKIpuoAVTQ7fldnjq/4T7nlOJabSlQZvXv3MoNYi5OwqEQpzowLVxH6iRmmPqaSK1lHW4oZE7zHI2H15YsBbfN0YWpoUVimdOahefN42ENT2tj6uLAucHfCJAKa6UJTS2AXJKviB6JlcY1jxs6M03ESV9sSErKgCUkFhsV2nD4ZAH1gbO/SWmM/3vWsrEjHUU/jDC/Eftx70hHlDYZPOCoobb5QfMVJI9B/LYO6PB5PAzQUg13saWfgTg8auCVeyci6g/66fGdgPNKZSdvX4Ap4IKUUFAayXnQTvevgk8ahl/u5wc1ZosjeR6sfCoNhqpSODU2Dk0VHb+Uj5MXBqh5pgOUq8IBdfkvWLhdd3sATJwS7UUCt/QL2+HR/IHeqomxCu1lFJrLDlt1ABcLZnTOnERgz6OAIHpyxWHbAISODsWzlAnA77aduSld4SXLLVpHNR/SGxH4HtGe9s+Mjg3MqNl7jpn74KQvb5jOBfDDACmo83Y77UXSFTMx7xLgjfvGbXmYLAi1bNg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf34ddae-33a3-4d51-7361-08dba28ca07a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 21:21:47.5799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RwQECXIu36He94gGCBIKclXYrK4Uh4k19v66U+Wdbu+BrR7qEcuf7pss47PcIkV033wvIq2rMSI+mJWNV65i4Uxd8M4jvaob4JCN2E8w2CI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6056
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=769 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308210198
X-Proofpoint-GUID: EAdHff_5iYTDL8F0O5It8VvJP7OYkC1H
X-Proofpoint-ORIG-GUID: EAdHff_5iYTDL8F0O5It8VvJP7OYkC1H
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The write back throttling (WBT) code checks if REQ_SYNC | REQ_IDLE is
> set to determine if a write is O_DIRECT vs buffered. If the bits are
> not set then it assumes it's a buffered write and will throttle LIO if
> we hit certain metrics. LIO itself is not using the buffer cache and
> is doing direct IO, so this has us set the direct bits so we are not
> throttled.
>
> When the initiator application is doing direct IO this can greatly
> improve performance. It depends on the backend device but we have seen
> where the WBT code is throttling writes to only 20K IOPs with 4K IOs
> when the device can support 100K+.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
