Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E058DC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 22:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0E8F61354
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 22:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhEOWEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 May 2021 18:04:12 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48652 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235126AbhEOWEL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 15 May 2021 18:04:11 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14FM2oMP031410;
        Sat, 15 May 2021 22:02:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=V2ha0E1EtpzxBkKdlkS+PGs8qU4CWB7I2XGb/33mkEI=;
 b=co1Joi35LTWcIGX+y+83tQ6tbCBKK12sVzUt7hz7SAPaX0NucPPthCRm34SuHamQPWbH
 STH82ujTc+kWJpAh0NsWgGnHOlEk8s0woT1d5INCcT5MrBfraqKRlLfqoItOEZyqYBmy
 sTnMmkuBr0Jx1Kz5mH6rfmDgyDvsQIGeBdBioGItDhxE95IWGXIfXhQEoSF0mkYPdYJK
 mNRo8vzZCDtEiHx61nx0o5WZdcAbgleVpPMd8r03AqiAX35UG+57gzZCTdjOPdqjYcJi
 vlNtynjOAOoxyf4pwW6dB+BEZt/TpLtIMFSQEGQaUudVG/sTra1Iwue1MXo3PBeLEEH1 SQ== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38j6698707-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 22:02:50 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14FM2mMm029093;
        Sat, 15 May 2021 22:02:48 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by userp3020.oracle.com with ESMTP id 38j5mjqg0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 22:02:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZvEbkvqWODZpx1sOPRtnv24QWl2CtKgpMjhiGaAxhNOKTNYshBxn40z17fgc/jd930GyqIK5NFXJgq7Ln1QQkRsLLeuioRVQLSciFPUF9uVEHoUCV1NDmLqUqcl6x5jHqaQ397iDNelQfZT2OHoIbrLKShjVoaNIMFY0viPsn1yH6cIS+/XLiSTa7goi2IZcdCKyhq/fEPBdT1lJzUUKIhuU2qZ5d7NSvhtgZs6YnFKi5pkPyt6fFMxT8TzrCn42EDLnVlNS7/9Hhnqh3YRjf5P2XGs6PNIGq3bxvxR1CXZJYu2qakYivgZ6DB3jfIzpvRFbMT+fenDLpgK6vT6TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2ha0E1EtpzxBkKdlkS+PGs8qU4CWB7I2XGb/33mkEI=;
 b=G71vunwJCtYE/L5aCncCMkp3+SD9zRNCaMZ9WArSWcqWguw+skj4QpKTYu+yMdMs8eYGICeJ8tge89y5oZ8hI28vXYdBmu/GNzsbahORF/UYwxvK9nKPjt5XleKraPAKPkZU4XAhXF2PzHVWDxLjlTW2oVqGrY8gECDbxLuVESeGtSsI/T7FS0VCL7tayCmV44i3ivYu+B1cnF0HRqUWrhjjWz8NarOnj0qbP+aFyClKYVf4wy3vvHdQm3ALWzpY09WGUI06tVm01pC9KuZ4uzALEuE7DOq5TejUg2h6ycp9pkexyQh/069qnK/r3z/BXW23m1YjhevR4c8soV6s6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2ha0E1EtpzxBkKdlkS+PGs8qU4CWB7I2XGb/33mkEI=;
 b=I3s93SacN4xIcJVgU8p0EvYcMyFDcbiu42v97FAoebfWRyfG7L7BWENP/vrLIYsW9cGWSjIWR0Fykv6U06g1A5EvMFNQEyk54UiLMmlQNQCiKuuQ4IYWM+xMNW2o39mBueLcz60dm1iJ7nJF1cwZoOVqcXF29s+kjZp/XNCKb1g=
Authentication-Results: sholland.org; dkim=none (message not signed)
 header.d=none;sholland.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Sat, 15 May
 2021 22:02:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.031; Sat, 15 May 2021
 22:02:47 +0000
To:     Samuel Holland <samuel@sholland.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adam Radford <aradford@gmail.com>, linux-scsi@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] 3w-9xxx: Endianness fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsyn8xkx.fsf@ca-mkp.ca.oracle.com>
References: <20210427235915.39211-1-samuel@sholland.org>
Date:   Sat, 15 May 2021 18:02:43 -0400
In-Reply-To: <20210427235915.39211-1-samuel@sholland.org> (Samuel Holland's
        message of "Tue, 27 Apr 2021 18:59:12 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0501CA0023.namprd05.prod.outlook.com
 (2603:10b6:803:40::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0023.namprd05.prod.outlook.com (2603:10b6:803:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 22:02:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e8434f4-0287-4fae-c2b6-08d917ed2c8e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB461668B7F9D04D77650BBCBE8E2F9@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: liSJvhOLI3i0l/5iB8KpMEW6ZLDUYF221ZvMxakQBZNR/7VLWX6/Eg3q/k6jWXg6pMgxK4rwcCN4mT7XzO4aPrta2NJ1BiCiasmhSJqBp8Uwz91QvrLwa6amsjf18fHbihzRbgehitY3qFogtbzN60vzxYP1ijNsFuj402tSgwB09xZNa2DLQBjeyVDMC9gxcwWhsi8MYYcRAxsryl7XGXix5eqV+gCO4haEX9nQ0KFoWTmSWHfSRUFmGgcxTa/WGqbyjm08+ePcIvCT461ZqHs65/0qcK6xWVs+dWgtwophCdoDjOH6u9ncgug6xYHjpy87mwDTYDMoy9SFiNNmnDwNteN8UDGaOsxr5g/8ZjzPXgi+FETBpXJUVyXta2sJ87hNnNbArv0jMXm/Ffb6dOd6euWkdV52/sS3QXq/Fd8knGUrRfnC16BtLoE7h6yfB4S0gjD18dVn6IZXNJAW+whwH+qTtlizetOffTJhyh0VBarVtsTULQNSWaOfdtZCiaH1a16DnDusPJE9vOyFStQMDHvPzwckB61lnic5MCCtZjzBCYlh7dutdw4yhEfDwTBURfhS3fI0ap5UJDZloidsTCocZSfEW1hILMT1Y94d18J+ErseFWfTM1L3I6IpT/skfG0vS17AQnWxmkOXtRXsEfcVCGvw4bWxz/fupFU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(346002)(366004)(376002)(8936002)(26005)(54906003)(16526019)(38100700002)(316002)(478600001)(55016002)(6916009)(5660300002)(86362001)(66946007)(2906002)(66556008)(66476007)(558084003)(186003)(36916002)(52116002)(7696005)(6666004)(4326008)(38350700002)(8676002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?N8cc8Ryo74kIc+blvsYmSHuI+v3Hhhn5tm0owGSeAMwVAtEQ/WyC0EbZibw4?=
 =?us-ascii?Q?BwzCAjQTZ39Ifso9MbyyQio2gyFZyuCy+4ZdnPyPxwlbZKjCtjETCcaRB96f?=
 =?us-ascii?Q?MTZeQKDGyNM/wEp8wshcdpUYaKEkvCNOOG2YMS88o8wX1PWwplTSZPRUbqNP?=
 =?us-ascii?Q?hzg1xwRpvqncYcIwenPdOsj9trEzGFW0E/XCIGAsYbesRVjIAH5O03/u01Qm?=
 =?us-ascii?Q?HoFEGAMYvv3PULULdUHEq6u9gkJI7+wUnfnkfoVecvAkBRByuL5qING8/2N3?=
 =?us-ascii?Q?QPtc5ZUDJWnqkRN8rPza7npcsdoMiuzTQkUO/u6BftbUYF1hu9hOb7irt2Q1?=
 =?us-ascii?Q?likQTwUWuBvni73GC2mDrTNdk/Q2LrqwddtdhSpcJcZcFxpdEZPez6belCZo?=
 =?us-ascii?Q?QrL1ZWxHRLsSlibn+G5v22gkOFciwAN2fgt1EqfsqzeJJ6+loJ45etyWWA3x?=
 =?us-ascii?Q?S/PquJGbwEIM/aIJQbk8i5vx0l3LSR1K+s0Aa9BjS8tLMGfn7UrKC1OKoT7r?=
 =?us-ascii?Q?uLDsN/cpk7TmXNcwiADKraeKeoTukIMGkLKUN9jbUTSKEEAKA5FKkyjIrICX?=
 =?us-ascii?Q?zRo5QzXDRkk12gb2wR2AuoE+iq+icAYqlQ1Y+mNzqEmbnvRHVe9TV7/Ow1bN?=
 =?us-ascii?Q?XoytXn96gL45alGzc+63/KZ8If1Jx+d79TWHlUmw9w08BHZv0gViaZ/hQpVT?=
 =?us-ascii?Q?o1T0GerWEh1Z7lCLIyOwhCiRko6UqDuba5Axb0Iepe0gmJA+4sTPWFfvixEd?=
 =?us-ascii?Q?Q1wmuuM0KvIADwiAeVLgKQBpSCi978c1FAs+GKIkYCsoVtTisYJZOWqo3foN?=
 =?us-ascii?Q?HmaFGvb+eH5O8Nn+9PB3dlAM2QHDtQ2J6851aF2WAle8Z5pSFZIG8qkak5oZ?=
 =?us-ascii?Q?9fz3vdd50/6IXqSffoKAf+r57lShb3w4IoWIzqCcYEjbU7jn2n53HCaeeNfn?=
 =?us-ascii?Q?HgZfMs95AQB8izYGvJ0yqR3ymLIfC9tJQxZPz5SHw3I7G1YJGdnSh0I8+nbh?=
 =?us-ascii?Q?IohInNzPJlstXL+IGJJGI+He8ZWAfFy5ZW/lj8QHgab8lX7Lz6MKt1nrorw8?=
 =?us-ascii?Q?IzdobmvPlabMrszvx+ZKIIitwv0+NOMeo5mkwkO78xFCXdoqUMMM57VvF6vE?=
 =?us-ascii?Q?/Lu2ZfSvTfCqNU/020QLSyJjeu2wL8PBdJQyvaYx1d0xjZFd1SnYWdtgdEwT?=
 =?us-ascii?Q?2YMF1tBpazZfpSa7C/vBVIGyhSBVTSV2rQjjPnm/w5qFmxwnGJ2f6UF9YNDX?=
 =?us-ascii?Q?/33ZA6zK2P+0S8G0RdthorjuwiE7aqE7lv5u1xYF4oGiyc9UCcqeLcxa8MQy?=
 =?us-ascii?Q?JP4XlWl65PtgBDnQqKWQ1YJC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8434f4-0287-4fae-c2b6-08d917ed2c8e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 22:02:47.3161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BejIhpQ72H9ZNfZxRFYix4pWcJzWnmxjowoSriyzXqmwJUIOSOvFgkEUYQDgCP+pX96IL/EbcEJnVmhVP9qjEU0aKW6IUWkZuXNYM0T1HeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=906
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150168
X-Proofpoint-ORIG-GUID: NXM_NO-3zMuHeihaGh_AGWUUVJd0U_7U
X-Proofpoint-GUID: NXM_NO-3zMuHeihaGh_AGWUUVJd0U_7U
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Samuel,

> This series fixes the 3w-9xxx driver in a big-endian configuration.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
