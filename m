Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28691C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 02:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E318C61A1A
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 02:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhCYCuo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 22:50:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58564 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhCYCud (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 22:50:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P2nx1s013956;
        Thu, 25 Mar 2021 02:50:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=45oemXee9CG2oNhERRI01hqIv+k0PRtH49ViIeIG2q0=;
 b=hsk3wB8Kwq3qL9KdkCd3x/b2GcPBsvipb0swx6U0hSTyidrivJK5oPIVf8wmXDiV4Iwk
 6BM/AB/s4X+mq9U7hWTHNJ68/baCHPWb/JVyJvZlf0PzPjUEKigTtBtw2VF6CjOGQ7To
 tKxBBFYIqbVWSeO93WWAk5JbAbCfQG+3ZZjNQfNpVLAhGjCk/wAi2ZQoh1AzX3djclKT
 pX3bNt9X7PySxXVR0guGV5rmIiWOdNeBzBLFOvDDmyPY/S0K+zgdLBqz/Yfcs/3WvGYl
 Qr4JutiUSq7DRJQvtdnS4tjEeBfFKDD+c0h+DysYa1+Ee0PphgmKzMnm51aBMTBgkNIT tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37d90mmssr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 02:50:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P2ivgK181572;
        Thu, 25 Mar 2021 02:50:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 37du00mcdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 02:50:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmzlL2wonqPVigrdE/B6MWeWkVlODHFnWe+YWVE2Io7wgRpSyxTZ6CoWdgJ4z3juwJjHIT75swL/KZ1ZMZA3fqutKYSHqTwW5uUlhLKqLPEH6XoJpIsoUQD1wUjyZfnObO3yOJeGanbgeLpobmqr2Bbm+GVUIDyZyI7+i9BrBlHa4iTYqulRh3Y+N5WcVzrTNEGcJezUmJJk4bNWTXkm/+WJZsRC7xQ9q2PB722wy+cskkJZQNJ6rgsX4UyvFya0buHuQ1hiRXB+IzJ5zkMnHjxioGiBT+0mojMoWv7iDPOyMZmmEmuMhRpIXTjOEAP+ZG3SoLaruEEBYh/n1TyqAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45oemXee9CG2oNhERRI01hqIv+k0PRtH49ViIeIG2q0=;
 b=IvgktLp3UzZ84hwCFPxiYrycLFMU9I5M/whowd71jxWuFMbaZiMpJdZ833dv+kW0t3vv19DQzdwt6qy4xgpIx/XijZ6HfhPBEJ8a5SIotPLwcF5wkLq2S9LFemjb6OR1wYjhUhm4wLBDisnNwuC4SxtFodj54R+iTCNpYV/Edr9e5wLCzoi0TzApPN6ZGaf/53l2tZPJ8YeLHrid6YAVaV+oLt+IbxlpsZ9yuMR3fM5xDVw7jWMmXlnO0Xt3aVw2JJTbE5xG4sU1DaoaDd0sjW5QuLZ/TgrBnGkgS8N1mXrvjBPZgbeV3+feoRRh4FWpJUvZwXAlmZSyaoe6+hahdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45oemXee9CG2oNhERRI01hqIv+k0PRtH49ViIeIG2q0=;
 b=cyGhwut0Jo1O0ZYGLJH/mMbnSzsd2N5cWuQovZt6jiat1mjhOaILkfT2QgY0TZqKS8oPdQXYxBl+RV6mZ8kY6WUuCBAET3G2+blXcq225ei920PMXuoq7cF7NbKBleYmEeqZJY55bpJ9VZB6IdU5qsoTo/+6cRJ1gI3r86K2vyI=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4728.namprd10.prod.outlook.com (2603:10b6:510:3b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Thu, 25 Mar
 2021 02:50:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 02:50:11 +0000
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <axboe@kernel.dk>, <ming.lei@redhat.com>, <hch@lst.de>,
        <keescook@chromium.org>, <kbusch@kernel.org>,
        <linux-block@vger.kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/3] scsi: check the whole result for reading write
 protect flag
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6qskl3j.fsf@ca-mkp.ca.oracle.com>
References: <20210319030128.1345061-1-yanaijie@huawei.com>
        <20210319030128.1345061-2-yanaijie@huawei.com>
Date:   Wed, 24 Mar 2021 22:50:07 -0400
In-Reply-To: <20210319030128.1345061-2-yanaijie@huawei.com> (Jason Yan's
        message of "Fri, 19 Mar 2021 11:01:26 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: MWHPR19CA0082.namprd19.prod.outlook.com
 (2603:10b6:320:1f::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by MWHPR19CA0082.namprd19.prod.outlook.com (2603:10b6:320:1f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29 via Frontend Transport; Thu, 25 Mar 2021 02:50:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e4038ab-8282-4c77-7eb6-08d8ef38b535
X-MS-TrafficTypeDiagnostic: PH0PR10MB4728:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB472874FB5FB87E9B812F66FD8E629@PH0PR10MB4728.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnJ09ZnFuGxwROumUF1ieLOXnPew/uZSH6pOUxb84lYWJGskig1UYglDmWNvlslhKHn9VgEWBtclZA/oI/jNQufOpmbQAxDlxUfZvNqdsNb2HxbWMJZkRc4xhUdEw4tKgYiuldP2UJZWbje44Kgk32IKl9oO57kJFB9KXGrF3w+tzDbmSabyp2o/Z0HLyGzdb6U5I23XUJsHq953fkOF8yQxJZIctICNcyhXgdZqUzcYaT9tE9hQIEbghOc5MbyCYSSwye31wMVuOWlsHxlfzNKIZ9mdqUdKAK0azSRUZIEAql1miJpL0rkuVtyn3+VrFZ0ZewN9XrCGOB5hLWV5oxLu+dbwFH03m2+DcLx3dex2LPW7b/0YI//MQdK9X0XnBb6m0j/4ssaSyhK2rn/MrIKhu3DjukKMofCgo9Ci8J83rzwLjWSQI81Ff3J3yeudIVnFBmi3UkI/8AsL+xVyiJzXIj3K3hOgg6r/AK2tWiKf7hzhYGh3cmq4Oe13+MayffFbxIIkIorquxYU4OrBPG0+xrr7yXU/jQDDLXUDUnOg203D3IOhRvN9Ciyn/y3xuo5iGeCJl4Vii5hfoc7eMihAs8rp/dav7/RgK5XpZMN3RgMRHytabFGD+dVDzXpKT42If2S+RRIkG6OSdnRn6200GM+tLV6zZ6PyYpGislQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(376002)(136003)(55016002)(52116002)(66556008)(956004)(6666004)(86362001)(66476007)(186003)(16526019)(66946007)(26005)(2906002)(36916002)(7696005)(38100700001)(54906003)(8936002)(6916009)(4326008)(4744005)(478600001)(8676002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/mCXjEe7YgYmYT7b5l0M8UxiJih/EVvDOtkZ2Klu0mj+Cet8nt/x6DbGUUJA?=
 =?us-ascii?Q?P8mFrm2GfYF9kT+tpdARbAUbUA/qgpmK8qhsuC7eRjmIE9VvwMqsj8gxQHOi?=
 =?us-ascii?Q?yEiD3sGzD2IYeTBi4McRIXgRTtCQTPciGwndbRrN3uCmEcrahGPUdCL++ev3?=
 =?us-ascii?Q?guPqdpNqDBwJqRzH4QfxSPwlFD4Pe/K16POHkCwpAnpWnaqLcy6/jL7exWTx?=
 =?us-ascii?Q?Q2Nv71DObww8r3GEa1KxRDj4BWY7HNWPeqGsgNl2EhQFKHQNtJSAbHhLxEes?=
 =?us-ascii?Q?MwntNKEIs/GgsqlSMLSdAyXn50Q1trtYeQFuVz+spNlkHvk72E7Qa5ZnvTQy?=
 =?us-ascii?Q?o/5c3QexjAXpcXJ900t/AYWP8aWITagzM4u+zJHhrJiv3YXz7uvgMgwUfj/Y?=
 =?us-ascii?Q?MSt7tOEyQpD6rXaK6HhkN4TUL2hrHrTonyVDZ0A1DQx9FhRIo2OfRR5rzZvq?=
 =?us-ascii?Q?yUIvLZza2loPbT/HSffOJkJzVfUwsP40nQA0qNQkdZI8Ovu2F6nHN1sDAVu4?=
 =?us-ascii?Q?jNXqVLGpy0vA3QamSJpMy/vL+Q8sTAOjtaDa3YCCWKxu5+UPnEQcgDbnMm1M?=
 =?us-ascii?Q?yBbY8oDppRa578XlisjiOYi4CMTB6u0jiQwgvdwarcnG2BKLnwuJY3mZRfcz?=
 =?us-ascii?Q?YeON7PykX5VV251ceDb0TGDPJY6zFtDaX3D0fCL9/pfyPITlNxXbaDAG/NP+?=
 =?us-ascii?Q?7NqUASzc8pT8Az3nZxhUb2UhgGvzXMU9kS5oNBuXJjUJXfaaopfBAzOluPet?=
 =?us-ascii?Q?B+LVSZ9JluAQJUN/JnHWkX7erAWAq5aJsHAt13IM/Q539dOnBb8JMjS0kJH+?=
 =?us-ascii?Q?IodKkWV+8yiT4DQ5HkuJJA4gvoA42Az760V0qtax0CLHeHzuaiaXmo4B6R2i?=
 =?us-ascii?Q?9nAtMk034H7Ol4ltIVPORKfQB49wy3qJivspXw9gQRE1OxvZRqQyCH6WsfOj?=
 =?us-ascii?Q?LUXr9IkvUQF3EfqBUo5OvG7cg1M4PT49Gi13vcorp5Kqua2DC3hE+6G60IMW?=
 =?us-ascii?Q?WK/z4cyX/IlsvuLmmrULmKlqlc7Cvy0geeBJZ4cum33OpYpaKGjMT/SGsXtW?=
 =?us-ascii?Q?NziTk2wJf5OIdbDuELDuRNRMqSFgRVY5yT89FSB3GKRQ7mb6D5+oC2NmER/b?=
 =?us-ascii?Q?J6Px7YTC6rGvFit+z2xTG7K4qs061fiXNO/yKeRFtO6lCxeIPuIljlJ5XFNX?=
 =?us-ascii?Q?DdmgSm4t9NKIn3TKKLdTLNuoYkYyzvp7Jnv9kjwAv0AQUxz9nWswhJb1MB3C?=
 =?us-ascii?Q?CkUFyiLs9GCBKR0k9gFM/Irutuc5gohZFJr0BuHJHYCbHX7sZpG3fV53OV2P?=
 =?us-ascii?Q?BwsDtbqMShvH8x6tRvIG7qzz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4038ab-8282-4c77-7eb6-08d8ef38b535
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 02:50:11.2006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QF0RVYv9/+0alEpDCxEoF4K9OCgwBwAZHgXrz33tsG99Tk/i9Vlt90ooanxZLekfErwHZcp1kw9aJSndYLop38fnvrLYeJ7/YewwkGP748s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4728
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250020
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Jason!

> @@ -55,6 +55,19 @@ static inline int scsi_status_is_good(int status)
>  		(status == SAM_STAT_COMMAND_TERMINATED));
>  }
>  
> +/** scsi_result_is_good - check the result return.
> + *
> + * @result: the result passed up from the driver (including host and
> + *          driver components)
> + *
> + * Drivers may only set other bytes but not status byte.
> + * This checks both the status byte and other bytes.
> + */
> +static inline int scsi_result_is_good(int result)
> +{
> +	return scsi_status_is_good(result) && (result & ~0xff) == 0;
> +}
> +
>  
>  /*
>   * standard mode-select header prepended to all mode-select commands

Instead of introducing a "don't be broken" variant of
scsi_status_is_good(), I'd prefer you to fix the latter to do the right
thing wrt. offline devices.

There aren't a ton of scsi_result_is_good() call sites to check. And I
suspect that most of them wouldn't actually consider the DID_NO_CONNECT
scenario to be "good".

-- 
Martin K. Petersen	Oracle Linux Engineering
