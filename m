Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C469CC433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 03:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F76C23601
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 03:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbhAHDlr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 22:41:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56336 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbhAHDlq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 22:41:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083TWZ7016748;
        Fri, 8 Jan 2021 03:40:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=YajzJkXDaDsbhO2tXvRxCtn5SnZGSrGEu5fhXa+mqnA=;
 b=ZmeJpEX04m1h7YPX9ZpkVa8yV0UCy3QyUPvaWol6a/CKFYUMJ5/8vRfjgtdayLD0LZqA
 d6c1ldSaPl8zKgxw42kvr/SqMjnTmL1cRJPKGaro65Af5yEuNKoeY7GxWi08pLI3BnqU
 Vmi1KZEEG+tAWLotJ8lTHf5x1uZO01JNDV+51LuF9FsksiUK9w2S/RqLBqGB2KlaijxR
 +mEKJxQoKyoz8PAodtyKoSz+5el2Y6UmzlqLb8vwoVCA8Ffsl0yjaT9sNYpnITc3Hsxe
 g8k4Gn0Avc9XYL2+wlmGWjzuF3VC2s0CGC1TAG5mSQv6YpGoTCg4btpqgR89NtxGt5RM aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35wftxewr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 03:40:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083UUAT146225;
        Fri, 8 Jan 2021 03:38:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3020.oracle.com with ESMTP id 35w3qur59j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 03:38:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lg/8pRwAlbwSBTFHWrxnUo8/b6lmNBVxF7Tpv3iJObxWFJMcHMQCVQTnrmPhY4q7AT1l2fn0VVgwR0m+DbyqSFwTKuRS2bQuOlvwBvA8ms8hkWNZqCZOfblsK5VoFwOraZWZJxMhhEUraGEfZT0tVvNqYoo16kZYIfTr5NEgoDr3aOnI8wZs1/RCF3FoEBkNIlqjUVDlPnHxrcqtb7sXFd91JzwOH5pcWYr7xlUXpCXF1AxEYdy87FGSS7j1hncUkuK9bgQQJGHzS2/RbgGBprTve9twg9TfCVDEO6zLd1uqfKW8fXKocvk3oGW1dUjyh+EqN37Y/OsKEjR5mKorGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YajzJkXDaDsbhO2tXvRxCtn5SnZGSrGEu5fhXa+mqnA=;
 b=oD2li6jpY+1ByCC/vG1SpqU+le+9ubkCkqUi9zosTDK5LGQVaa5VQgzf6MhNvxTgUqLWqUOuw3sE08JIai5i65ShGzt+hulrGxZMaaL7OI4kYAEl8f5Yv4tAe2+QG1XWi6Q/TdGgeqzIO0GqQJ26E7A4hL5/yWPQXKh52Il9DtDY8bvzo5/BWUgyLq1pMT+JQ13tyzNeJdK7ypjRImLLz90lOv/yDflkjPt0DituEurX3I0bdBKgvBJaoTdfhqNN39SIf2QKoPRkYuJe7uX2vOSmeNQpoHGC7EZ7djgxjFIedsKA9gBAMe5ld4pr27d5kax7/VWDAF2wSzSR9roVaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YajzJkXDaDsbhO2tXvRxCtn5SnZGSrGEu5fhXa+mqnA=;
 b=uLaG4r4QGN5ylPJiSwPseS6OOFwlwJLxnTqcxf7rY/SwbjaSY7uSeETpu8Gb026G2Hv2JMxpk++IfI+yvNhh1eRwJtd+geOHwRC8gGcV0AyRCJoQZXZeAsT3jHRrrUwriBhxkYVSwsnkmdATMSj/45soAWaymFsf1oZLlNhQDfY=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4437.namprd10.prod.outlook.com (2603:10b6:510:3a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 03:38:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 03:38:52 +0000
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com
Subject: Re: [PATCH v2 0/5] ibmvfc: MQ preparatory locking work
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ft3ccd34.fsf@ca-mkp.ca.oracle.com>
References: <20210106201835.1053593-1-tyreld@linux.ibm.com>
Date:   Thu, 07 Jan 2021 22:38:48 -0500
In-Reply-To: <20210106201835.1053593-1-tyreld@linux.ibm.com> (Tyrel Datwyler's
        message of "Wed, 6 Jan 2021 14:18:30 -0600")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DM5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:4:15::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DM5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:4:15::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 03:38:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0074805-8f02-4659-718e-08d8b386eae2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB443754D68106D260536687A48EAE0@PH0PR10MB4437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gJ8otq7lRiHb7UBV6J0J2pOoj6/TquduQETqYGzps9LUF93jb9qiy70SbTYBDf93HWNZ7zJJHl3PFxfWprdd/JQnMoTFr5ZcF73rQB8jR/tP9ITaOKnnS/N185FiEHhw0/HHkZuhIhFFoeBE50aM7q+xmHnNoErGkiAecLqwUT1DXMKzwQY4byRyk0wRsCRzaGj3+NHhZ4357Q7vNt2bPRcnNRAEniCq47hNR3Q/xmosAYeM4F/XMzenBbmppr73bS0BzdFgjtT0/KcowWjDvGF9LG8Wfnistq1exldjqOiS/gbJCkzAR760UpQI334aMeGAuKsQQqXOfoMFucS49QnEs9PiURQ67bH2vNGmxNSIHUNEEYZG24jpUYDmmTozFUoe1mZ9oon9tQS1/dRt4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39850400004)(376002)(366004)(136003)(478600001)(16526019)(86362001)(316002)(186003)(4744005)(26005)(55016002)(7696005)(83380400001)(2906002)(956004)(52116002)(8676002)(66476007)(5660300002)(8936002)(4326008)(66556008)(6666004)(36916002)(66946007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tcPTrulh0f8mhcv1WAMBROy4q770hVQRlutH7dNQDMzHF4ZP7ucEaZ3ZhTng?=
 =?us-ascii?Q?PzrbqTW3pgBAHzrZT8MRV6Ed071X2xk77C+ZsjYEIRtDVeo8v8TXW40scva7?=
 =?us-ascii?Q?oIovOV9thX7/zNqacyHcEZ0m+ittJtlssPmeaH1L8xxC5TnC6+BAYWB/OsFC?=
 =?us-ascii?Q?5ujEwNQYS1iOnsTYDrlEJigmZqS8bypWgSSS4Ljo48AihaNCdnHq099uj0+s?=
 =?us-ascii?Q?pwB3eg1HUTIYq/VvI5DXHYWvYtMqxXkB9ChM2bRgJ26HM1+QkInq02traqho?=
 =?us-ascii?Q?67ddvPS7ofdExQwFcYV0lzhY0X6R43abXYLkGFiZCFv+WN3rKc7HQIrHTfjU?=
 =?us-ascii?Q?6/8b8RohfT9an40XZRunbcA4zqChlg3WR6VKU2tlyln/H+CVrZgvQlAboXFt?=
 =?us-ascii?Q?fshmYDiAsM6LtOHi/nJcgh6Xa3CT6ZmZ6Y2J14KzDrN/9Ml2RXYYBsDxI/OP?=
 =?us-ascii?Q?GdXGy/USKZy2PB5BoQfsGjpJ8stWFZ68G7jOw9TWNCUGjaahSnmuc1pafcDU?=
 =?us-ascii?Q?tkz1DYQyo1fwCHLHGXEGu88L6L6boEp3yQ0j8HuOtg4V5Bt3NEGWWDeBQZJi?=
 =?us-ascii?Q?coJ3wyqT2QbOwRIveOeS8Icpg+jvSlSiGfflgYq6LR9ti9EprB1U4hbMhj/o?=
 =?us-ascii?Q?dFyt+Vh2UDRpkjDXPTB8lPfmg8reJY+TMjf7nqqTdgF6xIkzLhUTmnDoZn2n?=
 =?us-ascii?Q?Umvo72bVwKo8am92R0btQg+h4MeB+/s2PCIT45+vFKHda+9p6MuNYW6SB0FH?=
 =?us-ascii?Q?vaW0HNFNsG8vht8lnF9MJaA7vOLTHrbvbXyytNkZKAaqtlOavJkznlhgaADy?=
 =?us-ascii?Q?S/RVyqyq0Mf+VDdO3oo/tSLvvwvV3u7DBdskMQMa+DBid7AD3JgfD4QRUdY8?=
 =?us-ascii?Q?NCm3cG37WNw6KdrWzGNQjyk/3jpzXQjT3bANjPykUWKnTU+80VU3m8y7AZmx?=
 =?us-ascii?Q?IHj17Kn8fVDAiKiSygNcD1bfoYbEkaxnpsSNoTOgUCA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 03:38:51.9209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: a0074805-8f02-4659-718e-08d8b386eae2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hDrcJ/qJBskgBXu4sDePCTUkrPLW1bjO+wlvKyhn0nbYudand4r/QZ6bSjugx3uZpk91oZMCnW8SwtGlWgN9w4RktHQkzENqhvSmytHbEsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4437
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tyrel,

> The ibmvfc driver in its current form relies heavily on the
> host_lock. This patchset introduces a genric queue with its own queue
> lock and sent/free event list locks. This generic queue allows the
> driver to decouple the primary queue and future subordinate queues
> from the host lock reducing lock contention while also relaxing
> locking for submissions and completions to simply the list lock of the
> queue in question.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
