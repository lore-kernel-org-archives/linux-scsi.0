Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A7AC433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 03:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE1BF61006
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 03:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhDADg7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 23:36:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36970 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhDADgq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 23:36:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1313Tvv2103570;
        Thu, 1 Apr 2021 03:36:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=LgzsmWWK3GDKTXDpp+Z8T+fgb16wZOO2B92Hb2TeikA=;
 b=A2DlSwmSzFP4S6p6flzIuJsohmugI+1+GQHUb8CQnK/e7f4PdoLkDne8CkNLPJ0dOl9V
 /jZNHivMXfk0sYo5LSgHy5PxrDbgmX5IS8ykEMIAnXL8JA8KNpUbMN9t0VGw3a5QaaOI
 RgggSz7iTMDZRGtPkXF1B0jbg4iBBzh39jNvXoG/ltKPCx8kNn4pF/GlegY9iGb5vWmO
 cBCO0StTcQXcZ7pHjle9CCeOcZvrR6zHaueQOq6xksiiI6V3MOXymqekUCW7jrBS2RTk
 y0FibB1MWeNTWEwQxRyfw4xhPox5PdUfULZbpnpafe27kO8eY7GT99cLqkaKaWVl2/5m Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37n2akgb1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 03:36:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1313UkBm102109;
        Thu, 1 Apr 2021 03:36:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 37n2p9x5e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 03:36:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L28cqyW8r6cCo2klE8awMuDAa7f2ZfUu1O4axtfyG0UZGvWzZUh4OaeSD95qiBJ2NgGlxkZyBzsaOu2ICvMQfSxSGs7F4oVE3nLwD9j0oGBNhvU8RRid8hQ96r5YhylNBLCiIBmOdH/RrTWtBVoRAGhf5NdVvMYrDsPzOnoUbmQUgn3/7SR+8vbAChUtzW8pWszDsk7XqfuNhxGW9Ks7gGyEwtQ+mdY5+wkKx9AJUd72lMzo0oSWgZMW5b7jH3/Rfqev6cTJPi4SQ3U94X69DmvcFeopsl/Fhfs9muFCrgWKLhteg3iitdNQa9S+D0+YnxDS0AN94hgHA/9Tj6lM1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgzsmWWK3GDKTXDpp+Z8T+fgb16wZOO2B92Hb2TeikA=;
 b=ck0hDMGKiOLIeC8yz90HsUsZ8QubxKbpUVI/5g/RphcMj1pfbQ3SG/69IkecTsqd+IG/3TSLDJNviyh36aZyvAxGKfIaizxjA/OsCQwKVjYDeBNtubSwTj8JhC9Ym02b1P9c7QCvkLZa4qRvRoHUS+lxTlJ7Qs5vDBetGYbpNrdVcl30PPx86UHImI6Yw32PbXxoMol0sGYokVykHf0Qt1rsMUPWanmDoUHxAcCoNJJ+biMCpAdoFJRBacR/YdlabnsX1XmKNXTyQBgKTQGStj+HGGkFUru5hejVs5UaFF48YumgB5znAi/DUkGGR5xe2cc15VHqcxXmp2h/coJNAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgzsmWWK3GDKTXDpp+Z8T+fgb16wZOO2B92Hb2TeikA=;
 b=sI8JSrq1jyR00njAqHLh+e+sP8DoNvQ7i0dyTgoFP27b+uJxazktRHoyGAT8ivqezMWZsQkmr14gJ9SklOsgZ7cDTpWE/+ihu9JML4aK6zbJ2Q3I4cIKQfWRnMJEgCI3rncEzFBcXB8cIK5gnc9RcaNL2LPNWY0tUTdSwi+edl0=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5451.namprd10.prod.outlook.com (2603:10b6:510:e5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 03:36:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.028; Thu, 1 Apr 2021
 03:36:34 +0000
To:     <Viswas.G@microchip.com>
Cc:     <jinpu.wang@cloud.ionos.com>, <ash@ai0.uk>,
        <Ruksar.devadi@microchip.com>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [REGRESSION] pm8001: Adaptec 6805H fails to initialize after
 v5.10.0
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7kqfzqa.fsf@ca-mkp.ca.oracle.com>
References: <009d01d71cb1$3fbd5200$bf37f600$@ai0.uk>
        <CAMGffE=B9QRncb2UO3aCfbH9naYU6-pP_c6T3PuHNRKRpnkDJA@mail.gmail.com>
        <SN6PR11MB3488473F4D3CAEEBE583AB159D689@SN6PR11MB3488.namprd11.prod.outlook.com>
        <SN6PR11MB3488B82D4D39713C6AEE270F9D639@SN6PR11MB3488.namprd11.prod.outlook.com>
Date:   Wed, 31 Mar 2021 23:36:30 -0400
In-Reply-To: <SN6PR11MB3488B82D4D39713C6AEE270F9D639@SN6PR11MB3488.namprd11.prod.outlook.com>
        (Viswas G.'s message of "Wed, 24 Mar 2021 18:06:43 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:806:d3::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0018.namprd11.prod.outlook.com (2603:10b6:806:d3::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Thu, 1 Apr 2021 03:36:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90fdafd5-252d-4bde-b0f7-08d8f4bf58cd
X-MS-TrafficTypeDiagnostic: PH0PR10MB5451:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5451F20CC0B4123112BD36CB8E7B9@PH0PR10MB5451.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /JuFMLOT3y8jEa5kLW6ADwk5x/nGHVwx3+LfkLwv+ghx4wo+aAo2W7xu+0m0EmjL5N9lTT6hzk2haLhS0zNSyFYlCXmgIL5wmdf60/GPTwcdKb6nwcIKxlLCdzPh13afTUXn3Tl0zA2s25I+pgiBv1Sjl1imymirOrwSsqK2zJsFP0U/4rumg9KNEFJ+1KEyjyjzREhvBXhnhrtpjgj3Q/EmoH/fw3Z9VfX0f1QO89oD4aeXnusM9+7mI+bOPJB4FWI8Jl6bjIvze64fPy8Ub3y/QFdXUJHgaQd7pR9tD2FfnEBDGFKWnrb1DgiAvbeMNgB8EIDVM5Y9eiCAOyTfv1VsC1vjNhWrvrJ7fDc58kiupVtJd+N3PvBx2FJGiHAAWPTnJebQk8qke+tRAM/nW3S/YEmbsSDqP/pnB6riwiU/5+56K8Nrm5Hvc/wgjD1atB6uG5ZyraJvU5mtKK0TOPaw56rkauTAgdFrdb+tg0wX5vfH7jXaj4JwHldmaH1degB6VN7VjagVGoGTXnvatketr/jIPteMLe9bubHTic2QsDfDfARiOZY4iFzloTJWkhRHB8iAeu1S7Xjv1hMYR0+LhnlONKqTcizOhjTNQeHvuGAWfa0uaefwp91KYB938WW8wOJFUUxf1rUTULLaFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(346002)(376002)(36916002)(66556008)(52116002)(316002)(478600001)(7696005)(66946007)(4744005)(66476007)(5660300002)(54906003)(4326008)(55016002)(956004)(186003)(83380400001)(86362001)(16526019)(8676002)(6916009)(8936002)(38100700001)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wGPHCPOAQgZuJ/4bZzvOJ4uXMhic25S/+i0pI1Y8u6b/hTZlQV7e3ralXIbt?=
 =?us-ascii?Q?LtUvAECyQea3h5Bdv3N2hDRfoiWFGBqFIQPMmoEIGg4Fpj8UnmoAX7H4JQfC?=
 =?us-ascii?Q?tiZC/efAhcLUKB0oa19uZG9PVZdAGahb9PLnO44BDCBueNyY+Gtvehp+hH9F?=
 =?us-ascii?Q?PzjKyo3TrNVezXTvxw8ZXnspQHF5rE8vgwbKuYi1wNk+mVTazB0hC2qPtJc2?=
 =?us-ascii?Q?S/sjV3K9efA/nz1i+m0oJv2+7hkNAfru2Zota5nAhP3lWIOmgB2U8XKhBFZx?=
 =?us-ascii?Q?ocI89/b4dp82qFo24N3L/jlQy6/USdlkzz+jNhkV3A3SwEvqKuw+Fgrc1sxF?=
 =?us-ascii?Q?2Oq8Z16sPqa9lgK1jYmp8EDG/n+WEHUdXEf1mW0tBRg88EohtBwfCPJr5l6N?=
 =?us-ascii?Q?aaAg9GWcfQESy32R/RYVbq7o9U2esUin530fBB0aH1y7a1szuwgXpSUWJPgK?=
 =?us-ascii?Q?IqMWuDK0HUnQnpFEe3zqgWN8WYAj66GU5dQJEmXkw0W9tRKuTUHjzaowpoyU?=
 =?us-ascii?Q?WwGkvGl+RQWXv0RzLGSYVUKnQbGaYHNbfjONddYthExQgO8+J+J+z/B3Gn7r?=
 =?us-ascii?Q?il9xZTB3o0S1UKRCP7a2hijgzEJnmmXiEecu6kdGdNLo65Oi9C4wj6bI5bMp?=
 =?us-ascii?Q?VsBho/hcho/Dcsbchuf93zJs1phr99L1QZEWCLJT95C2X+6AW8IhGuGTFRLo?=
 =?us-ascii?Q?w18m1T0z5yphB/Z4STsbMv0wTIq+2odtORrEtw72HCMltdvrDTl/lp45jJGO?=
 =?us-ascii?Q?DC7NWXNski8tWYM+WQCawWHZwgrjoH1+mIk0Ae8tSja7FizYmwLYj9dqyqjT?=
 =?us-ascii?Q?1o+VcvmLxw0iHWf0tR6ikFNlBOiOkz8ihrMpjgi54+gyrahVzyEVXU1xDDdb?=
 =?us-ascii?Q?OxCK9kvhMYXQWC4jcTuaQmW7u63CCu2O6V2ylCN/1s51th4jlg331Zy5ZoUR?=
 =?us-ascii?Q?zEYESmGFtkqd7NMxH5+clk8nIyhnaW6BvMQuY6+fZVdEl3GLuqn+3Sldfn3k?=
 =?us-ascii?Q?e09+Xyg+I8H7bxt8bNI6mp+UGlBr9CuPM52zJDKlAI4flFOAhS6fEedyzOHo?=
 =?us-ascii?Q?n4bgqrzvHAErfk1f+UsYMoXMd9SMUZqgXENCZQR+H/sX1Yx5OyAcUeAVXx7Y?=
 =?us-ascii?Q?ual6MIPn8vAttw1zQArnQhEKYZqfwzThI0w5H0lWnny3jtSbxnkfBttRnxcl?=
 =?us-ascii?Q?fY2Vwp3GnwNaTpXlgA9RmugoaiIZyqQyefzXrWpD6qLjbc9WBsfLQ8x4NGQ2?=
 =?us-ascii?Q?hq2Nh8MbT4Gqn8RcaF0E0XapjwdwBFbV+KInxihTDpFh7FNT8G8j2W/vaz1N?=
 =?us-ascii?Q?469eG23rw3K7yJVqWsPqkvnB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90fdafd5-252d-4bde-b0f7-08d8f4bf58cd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 03:36:33.9607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b3v9iwghsEkA/pvb2WNO1ydWQS4KNMIxBKcbRB3Ny3d5h4nyzcFlhxwLDs2q7f6Ntgy+d+iY7RsQ6xCiegLkqCX3RAFGDzd4G7kGBSDSTXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5451
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104010023
X-Proofpoint-ORIG-GUID: vKh3TnapeDzrb4KC37vjG9PiCuakOeWa
X-Proofpoint-GUID: vKh3TnapeDzrb4KC37vjG9PiCuakOeWa
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 clxscore=1011 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Viswas,

> Can you please try this patch ?

Please formally submit this fix with the amendments Jinpu requested:

Reported-and-tested-by: Ash Izat <ash@ai0.uk>
Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
Cc: stable@vger.kernel.org # 5.10+

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
