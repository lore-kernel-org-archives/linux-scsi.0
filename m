Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D08C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 04:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 710F561108
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 04:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhIHEOO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 00:14:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19886 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhIHEOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 00:14:11 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1883qaIZ028205;
        Wed, 8 Sep 2021 04:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=GA8Ozp9vLTLvU6aEljBaBngaZunJE4aSAR2Ra2fG7kk=;
 b=KRhK4XXcLvwmjmEOknI24KEEIUupxbS1nOAQ90mJnRvHdJVqPPyZQhFMlLtZY2vMZy7H
 3DC7KHvZlyWT2jGP1rL/5ZkL9Z0ncWGxmpMfY8U4l2OlTPWNTmfZBYJL/wXsnOXj1Z9x
 /aInkhBSo4vOKR6ZFkrwfwOBV1MMVGsQsZ4/shCYtjmg0wnjPCT+j5yjFgGj4x/JeoAg
 bhK6vzm38243A9I7pWM+kELEu5zGMpxTRQG8ogixRjhkzzVkgydXasVw7BjuIEPXWnpH
 oshcI6YJ0Pm3u/h4sfZYtn+bXBuRCYFE7t2o0EQ8GFshdf4VT2toTg7tw9ZIDvLxZMjt 6A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=GA8Ozp9vLTLvU6aEljBaBngaZunJE4aSAR2Ra2fG7kk=;
 b=bwm7EhEKPJTiFXyiwyIkmY44deaKBB1mWwuc08T5JWp2ZxkodNFn9u540P2e9JJkkjs9
 EaLF+ySOiw2er4bOAy9vSQjxmN2JPqS9MEsFMyS3MYdTmFphyRPTXzK9h3/FqxjV9+Go
 WmRjTW9aXpl8O2n28ButXv/K5OQN5IbdrB6cZPMCVSfE5+z/zaBjCVcEVKeJeHRTDSv3
 /bv8u2mzaYA3Mc1Qu5aZiknLeOBWKk6Yf0BvhvkHqI7mulzrWTqBZ4CWtZxJIrNKJ6rX
 TPSdyaUvIxl2F8nZda5Q1DHkN+q35U1UWVTuck/C4irE7Ln9tEmJNoojGjpwz5GvQyok 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axcw698b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 04:13:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18844ois066083;
        Wed, 8 Sep 2021 04:13:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3030.oracle.com with ESMTP id 3axcq0qexa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 04:13:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j88bkjSfVRGIYUY9FKdkuAeAljkT+TuIObZpUwWngLJZ6MQdYW3AKTo9YY+3wVCyNA7SUvs0VpsMQ8rPRm/4Ugn6SbsVBvM2snqqJDk1uX66O7hxfY/QLVvFlKr2V+l0eIjAObY1kT73Af9606rxX/61qVJmYdlt8p1DEffymoFK+G9jTlykZclnYj5y6rhm1AlTeg/4BWwhWLkwkhhUoOL/vCW/oulO4Rx/gT/A/4LbRni5MQIVLgF6ZOiMmxu2di2u0j5It0zUuAklPOKi8N6ztOk0ym9I8SNufWmJYpPlnJG2ZNgBiYotnLTMRSxDTH+YzhlbqkqvkowYIoKEKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GA8Ozp9vLTLvU6aEljBaBngaZunJE4aSAR2Ra2fG7kk=;
 b=kLH56Y8AvS1JQjHqXlikRIt2OWyGD0U+Mz31VYwpd3mlR1RXRQpDVt1+c1fCooMarChCZI3L+3rK+2CA9GZumI5fP/hkemmbJ07rVd7Pbzdm9+EhXjxSFnAUAAGBJZxVbRgVj2IJl+Fe7bkuccAhoo2gHl/CBICK48hOZvGUIfR0sX3XTnGf6AC3CE1LwkIwlsOOOVPszpnF0xYCfDLAyaaokQ9a7DF6EkoejyxhVpmTnGGuI9DuQGIkFfn+Y3YNUTIz/eJh9TeHdaGMsgcgNjss0uI8LNDMIzw9TDDPkVcqANFa5t5kAP8hrZrmHXPBwuYAJF+RVlY+fE1YaZrp+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GA8Ozp9vLTLvU6aEljBaBngaZunJE4aSAR2Ra2fG7kk=;
 b=inTr8BmZskwnEGfID4WMQ7Rri6oErsnP45lF2EtW2WtRZF5hW2kYeaOO9EBOLkfu/Hgb3PPa7Mp8w9cT2dvCy9EBrK1q1VJUyPnsPGVA47FiuR4v02gO5XlB2NfH/mIT9xrn3gblE0QYS9Zz+wWg3PzEx8Vdwgqm4cTM55zHCto=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4712.namprd10.prod.outlook.com (2603:10b6:510:3f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20; Wed, 8 Sep
 2021 04:12:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.014; Wed, 8 Sep 2021
 04:12:59 +0000
To:     wenxiong@linux.vnet.ibm.com
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        brking1@linux.vnet.ibm.com, wenxiong@us.ibm.com
Subject: Re: [PATCH 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
 during
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7ev4t43.fsf@ca-mkp.ca.oracle.com>
References: <1629230255-11616-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Date:   Wed, 08 Sep 2021 00:12:56 -0400
In-Reply-To: <1629230255-11616-1-git-send-email-wenxiong@linux.vnet.ibm.com>
        (wenxiong@linux.vnet.ibm.com's message of "Tue, 17 Aug 2021 14:57:35
        -0500")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0164.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.32) by SA0PR11CA0164.namprd11.prod.outlook.com (2603:10b6:806:1bb::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 04:12:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a696d55-9e6a-4f3a-f785-08d9727ef142
X-MS-TrafficTypeDiagnostic: PH0PR10MB4712:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB471253E03A6F48288069577A8ED49@PH0PR10MB4712.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jlAp1tOzpdIwYEMhUjT1Pwn9+rRHMKW+EbWo2iT4hQN6V97vK3z3uTt5NCQp6LRfpze1OTJEZdO/tj6Y0XhVdWrhGor2l3wae9HqYDG+bEObgsPPT7vw4dWsbM4HESEKnSVUu+WES14Fanc0VDMJ2N9hXsKk2LW7gVPOPJDywUuMaIRBtYesW6u3BR0v8MCPChPrIJ2CEfsJqLRAkwxiTiSeZyC2gmVrHa5/G4oSucL3utaI8959tbvpZln/jHtKJJQSeIXKDTblNomLZbpvPza4NFw80oAUcbnMci4fUAwmJ92i4u1vTUiXlrz9IG1AAj6tmb9OGpkJ6uoqCdPGrtXw7JP1K4WeTwyo8wq4PR7aXx2U5SrxfV3p/MdkYsWug20Ou8kXH7EDSx9ZJFa4paab5dma/H6Cd2b4L0sH3RRwnDDMRlKT3rnQZgCYKMGHrgqaAfdqnukXyAGfmyYviGgeEe55zq+m0bhqyYk08QtCHDlo1/1PJFxmjK0foOJ/VLQoiFw/gEcq4HfVjjt+lUkYdZEhSI+EVGowEo/mJoB8r1F2WOk+bg3PbLZlNWOUovzUSGMEBJTOR65r9rudRgXJhCPK3L4o1qZzqMgJ2DaPflwBVbJyboVJuNZ7bMFHRLGV/8p2cUDHm4C7C+UuyvU1fYsJhYKssTuADPI3QdgO0VZMpiesTqe7o5h3Z12rji2aPXkJKlOhxsBHsNZIyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(366004)(396003)(4326008)(8676002)(38100700002)(55016002)(86362001)(38350700002)(956004)(8936002)(66476007)(66556008)(66946007)(186003)(5660300002)(478600001)(26005)(4744005)(7696005)(36916002)(52116002)(2906002)(316002)(6916009)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZKRp9mZo1ZKL9n6GZHJolvWhnrPT9SMePMkNWsNMOBvqYMJrSEZV6sPstq6e?=
 =?us-ascii?Q?UjMJB60Pz/1cf2lNWwqyPBn5IXvQUJm89+Fx1SUN54jkFF+RLuD+HLxeyrJ3?=
 =?us-ascii?Q?7dNv5joz8TFwwZgwYQUCZxvA0oM1TdE9eBTldfLm4bN7bOYcJsFhFN0tTVaq?=
 =?us-ascii?Q?dkLm1kfJumc6WBd8epRpxWFrnqFmqF/NPnionAtQ8ZyEenync4uNC1t+/j5z?=
 =?us-ascii?Q?nTVoJHSYBFGvO0yBuXTyQxLuGF2JM1dzK2TJfPqrusNWrJEexOSGxMe7jKOk?=
 =?us-ascii?Q?vUAVjp56ebK/bU6bLP1lBIz6TQNsuuJqjbvVdbNoJS4k0l6hRlVQJS/FqKjQ?=
 =?us-ascii?Q?77rzV/cw6NM6W1MqHGcIbhJofGTGqAupqvnM+klTdZRNhyo7B8CXVnBEve5T?=
 =?us-ascii?Q?TO5EaVw+PEQ+hEDq16f+kW0zjwxZntGuUxNUdeWUKkjh+oKjsW5CZAzJ+eET?=
 =?us-ascii?Q?liExicZphGH4laP9UKi3RzOErJ18xqJ2aFyje4qQw3Pj9cVgjUwFMAnMLgmm?=
 =?us-ascii?Q?/wWfSiCSSOwBvQpNuJf4z8auL3eQWnuWbUXf/PK9brK4aPOnBiXPxCGF0JMR?=
 =?us-ascii?Q?UBoAh0157n55EP1fiYtiSYIwuyiJtv8vk2X5qgRPOeiG46x8+LCUitS35wgM?=
 =?us-ascii?Q?LC2qKkP6UplzjFk3ApzUuRvQp+hFIXZAvOIHUS3CvLLcbozAxXk1CD8+dEYE?=
 =?us-ascii?Q?nOA1BZYEdfKtrYCm2z/yevV5m3KHcFACmwrY1G/25byavcs4QWurH7D0b1DN?=
 =?us-ascii?Q?azf685UDBAZDBjiAyFoI5ASloewyNLYJP4HwYcL5K85/Vmgzoc1RP9ISo0z0?=
 =?us-ascii?Q?cgyobAy95tluvmSJXI1e2e+BQ5Bo86SZtFDcv0gQ/EmTL7rdfBynZ7LdGr7C?=
 =?us-ascii?Q?W6VO7Yhc9mIqXZWTxcZJ6KA+KAWmy08kBfz192UeVnSgxzy68YTYqjopzWY9?=
 =?us-ascii?Q?hJd2nEn1mAnNJX+y553gLoLOlMQkQpAecGdaTujOtHd6I9PKsjKr6cld9C8A?=
 =?us-ascii?Q?DlWx6S0pZJtpDFS3ZtC0s7w/x7kfswDcuwI5ncUs7S1Ha7BE0tpcVGY1w4LY?=
 =?us-ascii?Q?M//SSsTKPzeELuu/rAi609Uso2eYxw/d3sbSUUmjPEKLeiHi8ZEQA1CIvzF8?=
 =?us-ascii?Q?t9wpbS7+tHOvgyo89F60yGKJH+yopZOWoFZnhPZ+d4l82s3tGtSPly+rTSlg?=
 =?us-ascii?Q?EbocYGyDez7KOqAECSNxA+t9Df4ftcqhiB7MwuarGFLxLxFzywkwQ6CJUcPy?=
 =?us-ascii?Q?yj/BO6kZ0Zj7b1z9LsJbIlVRh5DIvY23iPfUN51J3SK6pCkCY0RDQRE3lI2Y?=
 =?us-ascii?Q?xAfroO8wB2bopuGWrbW8+/59?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a696d55-9e6a-4f3a-f785-08d9727ef142
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 04:12:59.0013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GrzsiwONscrRv6Vbg9BQTSr7VeKApumwWimUar5aJod+WGQQpFhpJz8C0w/A9nAt7rOYkfO9bjcwuhgyvIow6tBhtCPlLCYcyfNMXoAGqec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4712
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080025
X-Proofpoint-GUID: dlMMPj-V66REtwD9jDiN5eiZYvzQiR6a
X-Proofpoint-ORIG-GUID: dlMMPj-V66REtwD9jDiN5eiZYvzQiR6a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Wendy!

> From scsi logging level with error=3, looks ses_recv_diag not try on a
> UA.  Added scsi_test_unit_ready() which retried with UA. The patch
> fixes both of above errors.

As your own commit message indicates, scsi_recv_diag() does not retry on
Unit Attention. I would like to see a fix which addresses that
deficiency in general and not just during the first invocation.

I suggest you modify scsi_recv_diag() to retry the RECEIVE DIAGNOSTIC
operation after getting a transient error.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
