Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5855FC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1367164F18
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhCSCZx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 22:25:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55784 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhCSCZh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 22:25:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J2OpdP129382;
        Fri, 19 Mar 2021 02:25:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=34lU1e0SNfX8t+Qnn9p4qHLsoQiC/6Zw7Q58/10EEgA=;
 b=J+xXZ4g4IPxMm0MhgUmfG95b9X3eu1ZysKRCP6tlEeRx7x1ShWR/T5RR/k0FdhU9wBCD
 ElzET8ZvwuXYVjqV1YqFGr3aUhvKu5S6/e5BYlIapCWxuCH7nt6GKTR5yFtkpCGaGiQJ
 31C0g41TlLQUHmkNThg5PCLAHvx44++FBLfWldiM3dOUL5ijWXp/+U2ITeLhyV7/A4PB
 uDgiJ62UY8VHOu9MyairFNYD6S/aLbJiS9q/wikrXNQB6hfgGM9114jx8XKN371hUsPj
 TezEm3Ly9OwKIb/0XVfB+kGVVEnG3J95dPKCergr6bNrryF/COC1O0eJox/Ha6x0VV0P Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37a4ekxbqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 02:25:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J2OoiB171119;
        Fri, 19 Mar 2021 02:25:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3030.oracle.com with ESMTP id 3796ywxsy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 02:25:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUjpa9waTtmfbPcl0CK4kfsDj3EuapuBJYjYA5QCcAUaODEvOmViLh1/7A7uACrg5RdR6DAwLx+Obb5uKsUPqPHmYCpoY4TkdJEEZWRquROQiw/CzdPXZcCCnMarOi+Avnyb1jaCeIPLsDhyC8xliZqLtOuW5j7an4ulEoHCokXdIWSs/BS16ieeOA4VGIzuOD/XEtEnKyJJ5q1je2dOz7qXIMwCdv6aLqQz1pomu5rQa2mGk9YECn9wNIv5LdF0EMz8yz6NzZM4V4TX0PYZIWmJQ4U1DcwF13c57cN5wRAbDmqQAL7sn0WWoeRpthlxrjA24UZXeEF/mk3xFaAxSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34lU1e0SNfX8t+Qnn9p4qHLsoQiC/6Zw7Q58/10EEgA=;
 b=Ss72OP/D9d9xdifzr8fIQ/y3Yp6wATQQlmYPyx75xUYRB/Rxfds5rDvUTcUAA0K0e6V6ygpV7NLhXhp3Wdv/QUTx0Yb0lq1itD7OP77u3/m+kZmpvDPNrUkq8OTd/CFy5a7wKlRtcXpJ7XdLv33p/cesqdiEX8O2B0mH4WqzEX+3vpFXdSnViVrr4oVv71ipi3CIXyp8vZQjZAW47hJudFUlzQ3uGL9CDIhhfGrCvQjXZISKsaLDmE17DDq10rnItCrfeiKNCKt6+uDpZuWvTnTa+UvWftyCS4pfc+nVPND3j75B9ujssibaDeg9aZstUaEYYKU1rnlzw2Tdm1kypw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34lU1e0SNfX8t+Qnn9p4qHLsoQiC/6Zw7Q58/10EEgA=;
 b=U+KwsVyO+GWqdmm/4RDJSpWSRjsCu5jI9A+YFGTY4JVdaojow2iNSJBdlpGVpafwAvlelexk2Cvi/wIQX7rIhXQiLZOliA9IB+Kh9UccM2c+SDawGqIUQblDPvDiC6Qoo+iq211U1O3bel1kDzDNcRGAQcvnLu6kh7VHrV2w9m8=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4503.namprd10.prod.outlook.com (2603:10b6:510:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 02:25:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 02:25:20 +0000
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH] scsi: ufs: Add selector to ufshcd_query_flag* APIs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtuzq3tu.fsf@ca-mkp.ca.oracle.com>
References: <CGME20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2@epcms2p2>
        <20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2@epcms2p2>
Date:   Thu, 18 Mar 2021 22:25:17 -0400
In-Reply-To: <20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2@epcms2p2>
        (Daejun Park's message of "Wed, 17 Mar 2021 12:31:43 +0900")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR11CA0051.namprd11.prod.outlook.com
 (2603:10b6:a03:80::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR11CA0051.namprd11.prod.outlook.com (2603:10b6:a03:80::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 02:25:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6f4438c-2140-49d7-e8f3-08d8ea7e3e00
X-MS-TrafficTypeDiagnostic: PH0PR10MB4503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB450339452BFA835563D2ACDF8E689@PH0PR10MB4503.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L9Afg/6BMkNVrEHKZu39M6YsrITzqLkdxUydpCZHJCJICXJjJDwYC3ymNQL56OjqcoAvjo5k6+o70Fw8lA/xBJScyMGzA60Sdr5h81TSTjvQcY05YrFxrmq63OmKMbH0ehdt5zsJrHQd6UPb9U8W6/zHBu6T1P/k8KMyxPN3sVOfELOZggTn2dW0RYGSEWGDSba5s9Y9vYfoX4lN4f6pRVacegUVva5Ib18tf2gbvH4VosogL0tsLYaMJ0EF7XiNQSyq23pWwKq6OsJQNL2p2Eg448Ht1l2L2dFEQSxR2ggp/2LKGYKbdIFu3x5TLZxn6g/pqPGDKtDu70jBMIZuuTQLLYkumpBFI0dQ8bRskwlQwZZ4stq+zxhFGVE9cMW5429tJQU6DnWC5UBWW7Vk6bT6I7oDqSpt060a+06N+DCY6WZ5feix73TEt2bhOVWpLH+yBTSPKI0pDFWRtLFCFmu4cBI+ZyW/9y9u8N+co6bVTikPDpZY3hN+FaE2l4O81A00hUk0Rao88v3Di4wKGOdnxHMTxJtMBXLrJPafV05UBzZJO6ur4WiTGFNbIMRG3SU9w91h7ttyNVfILmfA8OI+jObQfPGwbOkLXdaVoQB2tHjQ1ulBLZPRdlDTIKOou0zdNNZM5K4Udlcyk5+MbnMcd0zt7aVBPFg4hRuRY44=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39860400002)(38100700001)(186003)(7416002)(2906002)(54906003)(956004)(7696005)(6916009)(8676002)(16526019)(8936002)(66476007)(4326008)(316002)(558084003)(5660300002)(52116002)(66556008)(26005)(66946007)(86362001)(478600001)(55016002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SfRzforwbpO1rayEUadRjBxyZBlDQxeJZG+7PN4uLu2Rfa9TnMROFrGf0BY8?=
 =?us-ascii?Q?DidTgpK/C1TOO+/SVhcWpb08EXVZYzD32FQNloXzae1FnuGxbZYt0YeuTBxt?=
 =?us-ascii?Q?METdt3WI8espuJMoU6cANBx0gQaIe+oWY0Keuq6ymAeSHp7p96aeLK3VoOZv?=
 =?us-ascii?Q?0Lf/atIwHIW0z6oe779sVYjPBcUdCOjOJCCbtOzDy1AbszpWRo2dCkq3mXK2?=
 =?us-ascii?Q?3mpg9d09YvNPxvOrpH+YB0rqPztkKnl6IgftOF8f9lIVFFCZ7UxoThS4Tp1S?=
 =?us-ascii?Q?sxni6AEIfgdWq6vOXehhkDFVLNizmGz6DSZMz4hPE5C3VxU+bIr80gzmHgZ+?=
 =?us-ascii?Q?K494fsb1L8hzj8Qjhahsb6W3MLvuWLa6/BtklFxougswEMAa31AAzKNRRQzL?=
 =?us-ascii?Q?kBsp6fAbpNd7dx8es/zO7Fp8T0dhMKDzgyqzAvV/3BPjcyAatICt43YVugG9?=
 =?us-ascii?Q?ANwrTUFl459tAKJN0YiXB9TO96SnQJY4vGW+7keaDEgPjrrh2sJAuQRT6dMc?=
 =?us-ascii?Q?UC2UXq977Rn+Uws8Z9IBRdliDGzo1mGcZyKoDZKoKq3Z6+WoMRtiO1xhPyvn?=
 =?us-ascii?Q?KV6ybTIC6+zgma5BroG4ct+/T+LnXM3jBE3FN3ew6c7uudy9Cz1bNATjy19/?=
 =?us-ascii?Q?0Ds7u9vspqJeKe05ydPsOZX+JcOiXVXe9304WbTy+g/rcyofMxnyYhMsZaJH?=
 =?us-ascii?Q?JY2NZBzmr8/qdb7btEgwGpjceev3tKj0VgMf10K1fTZW7cIqp8fjv9IllOkh?=
 =?us-ascii?Q?HrJPZik13PLpKcKl1kdPnhotE5fQUB3OnN16D6/tuy4NdkrU5TrSTR5IPOn1?=
 =?us-ascii?Q?RwJtCfS+Wrp3Naf9XmQO5HN//SKgjSr3xHugMoF3t5S7IA+9E5njKw7aJui+?=
 =?us-ascii?Q?nb2YuRCVJByhB/spXTcRy1+bOFAz6kYlddkn3pys6zKnQkU3pOU70jQJWgqz?=
 =?us-ascii?Q?QtMTSlNbYhkl2qJ/A5eFD8Hj/RpJrEenk1V5rrYOTbVUI8NWd+aoSnkiF/GM?=
 =?us-ascii?Q?28XqjiCnmIGrPZ6YXXyxDs8ateqvZRrnMHbijZD3j7LwfLeJ4eUXAjAzUtLU?=
 =?us-ascii?Q?YTX0cOZhtZF7OflyJvPUKz5vt7GmQLoVRWUm2Tcb7vkdEj8zwl8obYNfR+g+?=
 =?us-ascii?Q?FIEgVeo99oxzm2Lc4AoK0UkjrXdE0lvG11vF0gDzEOb5iJEe5KItQL4uOiXR?=
 =?us-ascii?Q?fAXbmuFy1lbu6/i/7vndWaN5sg2PmsnKHu21HpoofvwernEkk2V14EqJgto1?=
 =?us-ascii?Q?eSkg6DG/UFWdAMkx165vdERfL38UmcQ1P4lkNAXYB+K0WrlEQIAMhjFLOFhU?=
 =?us-ascii?Q?198WVyd3i+kFLXpjCnJAKEnM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6f4438c-2140-49d7-e8f3-08d8ea7e3e00
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 02:25:20.1145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B2fCc1eh1ofWM5XP3xVJwimimVb4p914XWinu0ufVrsBExAREmmT4suwmbtlZMuv38//EUr5HU25BogTuQFuFcXvOOOOpVmx3XhfnDwWqAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4503
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190016
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Daejun,

> Unlike other query APIs in UFS, ufshcd_query_flag has a fixed selector
> as 0. This patch allows ufshcd_query_flag API to choose selector value
> by parameter.

I don't see any users of the added parameter. Am I missing something?

-- 
Martin K. Petersen	Oracle Linux Engineering
