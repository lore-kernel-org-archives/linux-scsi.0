Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3BBC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07C4861408
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbhEOCnA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 22:43:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47630 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbhEOCnA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 22:43:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2bSXd029903;
        Sat, 15 May 2021 02:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=coN8tXVhQ4ohj3PdwQuMEYho6BvLsj1+rI47m426qfg=;
 b=I4z3DASOZ0sFaA8JJyWT4UpMckZnI4G7ntye9SXzwDPZTqqNZ/juN0mvZzeO4R2ksnZF
 LCY6AADJ6PL7By419lEvC1njdR2/Pef/MlhT/fzU1i0QfCBPjtke3U7VgLwpEGwYQznf
 3/9ibBeiy932Qa5lIKTHHueaBgoUAQb81+6ot0//IFBXYDVI4mejkW5/TIhBsHrCYBkE
 5PhcRobSVKudSti39Dn6S82ZjyZOn8h0fksnIyh9Z404ommF0HYyFzSYNha5wzvLPbBk
 kZfhmz1XtGk0oBoNh/+in/yTNma7O+B31ogFnlDdlxRntoELpNPYiRj7EjTPBG1KyILv Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38gpnunkq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:41:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2eAHN125853;
        Sat, 15 May 2021 02:41:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3020.oracle.com with ESMTP id 38j5mj02m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:41:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iR/avD44iluODuhwW6kW9rCCY3ydQ/gPJ0AP7Xh3vK6RmaE1AilQgNoiWP5NPsdlHMtkP2G4vxEdjWC2hhG8+7sZyM4FCjyv755vGZzcBmivhC7iTFodsc+i9PGBvDObdvGnV6AAUQzHQCvffZiL+QUv8CHf9F+/LqQMToms7Kx+knJXvFPwJp6hW98886o49xo+l9eUhsogps8A7a8DbBUQDeoW5tLNR0SgYDixsxVRKru1L98Cs/bkG07IVRcXCy0IVLGKDQONIcRWqubFMeyaVshwFsc33UIMdTMIhy57F2Yr927PVnepr1YDiuVkoj0oXmSGB0GFU5cWS5T+mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coN8tXVhQ4ohj3PdwQuMEYho6BvLsj1+rI47m426qfg=;
 b=ZpMgkes9I9RPb3zMO09GUZb280N35sURkI2gNgXFe4GdOWbBGi6aYXCKRzBGroPubamMExqVdFuPgGJOfDOPVdQpG6QZr7dTswAd9ewI1voVhK+L15eXKUtmjn+zptn7cYvmIvxwMeHBmpg5+E7699v12w0ZYxI55a+Dh398ZU6UokiBu5lxEmufd9fYLYI9aZHe6lg7lFrN7xmZTZIwJgJi7+Ce1U+LKfjIuMHa3J4zkjp9EP5Qtbbx74tQ+i0EZNWrDslTk7V/vEtK4/R2lIqSiCfFjntfuMvW2xzRu0NJh6lMGWiBbzUj60RPoP9+YwMwAOq7hRLVYTVpIJO7PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coN8tXVhQ4ohj3PdwQuMEYho6BvLsj1+rI47m426qfg=;
 b=yWKlxh/1ES7Ha+zDXj9zXXSlpQPxbKDUnPCDoxZ3SxsQlVyWBI6agjwL8KX/s7heoObmXpx8jqdkKNg7+CBOIZpWyNxeigD6QBCJk3l0oJtRKpFmHK4ruA/B2WEUUo8smg34C9za9Hpu+d4TxQUmLGoj5cDOyHyS4cdcTkMvg0k=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5419.namprd10.prod.outlook.com (2603:10b6:510:d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Sat, 15 May
 2021 02:41:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 02:41:34 +0000
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] scsi: scsi_debug: Drop if with an always false condition
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cztsbtwp.fsf@ca-mkp.ca.oracle.com>
References: <20210506203206.254258-1-u.kleine-koenig@pengutronix.de>
Date:   Fri, 14 May 2021 22:41:32 -0400
In-Reply-To: <20210506203206.254258-1-u.kleine-koenig@pengutronix.de> ("Uwe
        =?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Thu, 6 May 2021 22:32:06
 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR13CA0077.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0077.namprd13.prod.outlook.com (2603:10b6:a03:2c4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 02:41:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fae1bc0-9f9a-47f5-3077-08d9174af486
X-MS-TrafficTypeDiagnostic: PH0PR10MB5419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5419D872FD4012F8AAA489488E2F9@PH0PR10MB5419.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TJxK2oSxT09NcwU9BCH3/LrSfUnQ6QC8zJdWWuQXsKtWdJyvPfODYLsu08F9+fkQ7YPT+67+LOAYOoDJGF2jIgnp0pFBB8ZBm4KNi5uSCQy5YbA3+GGqGzAi/MMp1JLFGM2PDRJY2kyy0UsmsCb/9d5tm8fLB9Z8dYPgvVqcgz43pVm3Tg1YOlihuuc2hA8ToT+h25QKElT7g1LJP3Jgx7GgZA2Xzg6nKcg583uD6tfh/xe+x0BpS6Xt2MBLJMRcbeVocUwT90iu5IM44JXN/wWeRIHdYtzCHVcQtPbuuT+2YF4dM/cp4HDkBs2zRO+STFERFKRXOidhvMhHOFKN4oDaav/rR8EjnR+NlcNzGAlupG0z0oNwZRKm4uS/Bs72zUMY3RPQNiPVTIfQMEFEIGf3LKusVa9H0VCR9bcKzS19DeXUGxRv/CAXGP+4NdqNHqzqYVEUuznTEZtjgSTOdSae9736HAv0qMSUXXxuXFX5L5G5BopIqgRtBVJHFqi0uK8x0dqawoQBjpT2bjMe0GnAhVvl8c+2Ddf8dw7kAo7VbWncvR+5dIbeOvISW6PyHrWQRRFOzuzLmc7iRXjt76OmuQcpD9qGWt7R9xkZHhaZCxsj4sYqYyEquooFni4ETSHUPV5PpmOXCsxzz9/aY5cZlItbJWV4gZTdTLeQx8k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(39860400002)(396003)(376002)(16526019)(186003)(66556008)(66946007)(66476007)(55016002)(956004)(2906002)(558084003)(316002)(54906003)(5660300002)(7696005)(8936002)(6916009)(26005)(478600001)(4326008)(52116002)(36916002)(86362001)(38350700002)(38100700002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?b/D3Ut/fbbnE42/4xvbGqCLxz0cIVUGyjTXjgX/xgDLaLXnKXmu1cl9CM/rL?=
 =?us-ascii?Q?hPWgFCtbCMQ/l2282bHDIYfsEcTv7pJ0Us+KlkYPJVj6OQQtNEqgrb2liLyO?=
 =?us-ascii?Q?2wzXTxy2FlzNvIeIt+DjnReoaqflgtBXCCdH6ENi7yaZ8F0it39AhSSuhMuj?=
 =?us-ascii?Q?C4LAI2YYcNwwTOSOJRcPmaSIKA7nB/mubYxBcjd04PltAZqz1UUdWwr0kLUU?=
 =?us-ascii?Q?8XiUr2gzW0T3jaTOoD1iYqawDBYawsu38btS8PgCpAnutEUc2w55jLOlQYx2?=
 =?us-ascii?Q?9lUjpJMygfN3txhnmQxlD1ZCMdtxxReXmmXtuBnznLQF0EYRq938mxehEqB5?=
 =?us-ascii?Q?WPKie42koF6OxhIh3GlYZuO7uLGQdsmd2a79jQQGOTxM89RLIhnFzn565I6Q?=
 =?us-ascii?Q?5lhy8c2TnsYawkx0bQ9h50WQsLpmJ7jNyl0+VTcf6IFrQVQAbP+rs7L7diIY?=
 =?us-ascii?Q?vsxCp2Ay7rWQ2HFfMGAZbgnawMk35a0JKbwMA5W2cxpqQBT/5QweP1jT56Y0?=
 =?us-ascii?Q?0hRMDyeISPD/nb0G2wY5b218H6UVtzWn9/6DP2HiLfp/8IMkuempYi5yUty5?=
 =?us-ascii?Q?mE30rcl0tlf6pLuZ9i3eIdBswy61D5OZ3BMKobXgCa94oI6etftINzA2/K+0?=
 =?us-ascii?Q?SIrzQygXTtWKcIAU+1i6zT3c+x7w6VI6yT4kaCpDsMOiwPI+q2hatAAZCALw?=
 =?us-ascii?Q?HqfExiao+zEPPa4d1URQyEEwBEDXG/S4XNTct9L0/j2eau+eElnqyOh5sjgm?=
 =?us-ascii?Q?Aqho8yVwst9GCqm0BLtyHmwPUx2Slp40bMoS8sA9v0hjXJO+MkiTGuTCB5rv?=
 =?us-ascii?Q?3avCW8csR78h+vCITQ0liwMXRXdouiUKOf+zqaI850P1/9GTivb2dJOXC4bW?=
 =?us-ascii?Q?NkRPfnFGhgLt/vArFQHo9XZ5h1LE3VFVYir46ulaNXiSsO64sqBNL+YnDKCp?=
 =?us-ascii?Q?pBKxNFhi0zuAB7S39CVRUx3c7Ffv4gAjNdFcz2/LrZyq+eeJV6LQczWLQORg?=
 =?us-ascii?Q?lPBhrQ9ISAerQODkiLizCxQrVvLkC4aoH3fOS2YjxnBD+GnetwfJ+87ifeMV?=
 =?us-ascii?Q?B65TYCZabg5VvquUj+Q6XEWKnQ4ouXESRVDpvullb07/z160i97XsuvRCr12?=
 =?us-ascii?Q?Q63Fb2A1X0oSl+vnaakQQUQaCO5F7DLGCkWU2P0/WHUi6vV9VSP745yVLbHG?=
 =?us-ascii?Q?oJB/JMwnBib7DAe+MNYpPjznr/4JGbIYsHIzmEA1KdpRrYVW2X6qA6fljkVL?=
 =?us-ascii?Q?ixvPHIsoIypzeyPOvlZ0GLRq355Jn7dBYbWiplWOhIsNDzgc3F/CDlyYN9fP?=
 =?us-ascii?Q?tA9AQoqaP9VJe6MhtuZrRkcC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fae1bc0-9f9a-47f5-3077-08d9174af486
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 02:41:34.8403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IFAwOOCjLqOBfLBzpMZHKmUqxdPSHoY7BD9urgiSAxG6rZVBkn6UljesDKSbCzmlpwfCGrxMEEbUlR3ufW7E4BFi/YgR9jf9C9UBIaRTwYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5419
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150017
X-Proofpoint-ORIG-GUID: w4Vq3HTICw-CLAzA-OJcghnHecLii1zK
X-Proofpoint-GUID: w4Vq3HTICw-CLAzA-OJcghnHecLii1zK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 adultscore=0 spamscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Uwe,

> to_sdebug_host() is a container_of operation, so it never returns NULL.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
