Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA4FC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1835E23122
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbhAMFkM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:40:12 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56222 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbhAMFkL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:40:11 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5XZRc144549;
        Wed, 13 Jan 2021 05:39:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=hiKNIrjyOK2Km2+jT57W/F+lj/mmbbUPPVM/kUhBh9Y=;
 b=tCfHTpKO4cPLIco0KAvPKKIY4ujhz30rqwH6lNp/xYcBDSuiuNrYtLtRf1ztsmk/KQnH
 ZiE5klS/aRAihekFmQFi89gYcxmHxOGH1Kf+B2lAX4NgsdqBBq8etQVWFSiZUBb71L0W
 rOebl+lCGbKNzf6ln2nTDHE2iXjQ5x23cWJOEZpGkZlEkXOC4R99oQQ0GMXW1v3iquVF
 lxql55XRAcoKbXba33tyyUNjAVv5KqUoxHe9blChbionSQcL2yL78/QM+e6o3O1nUkrU
 8B1MkbC0Y7lk36bSCAiDp1/wPQaCduXftczMidHNbD7cVnYMYSsTHQz3oDUzu8nYZsJC sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 360kg1sn2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:39:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5a5Fe122807;
        Wed, 13 Jan 2021 05:37:28 GMT
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2058.outbound.protection.outlook.com [104.47.46.58])
        by aserp3030.oracle.com with ESMTP id 360kf008ta-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:37:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETY/QZvXPombaPnEkdNyztgXu3uVGJMf5g/u4Y743SqCaQp9FYzVZMyfyD8DVXv4m6YsePO/H+eZQqVyNyUVdSAdk9Q0r2AFnHspLu8tmJhw2RcD+vHZQ8GZ/IRgpyy8fKDvFwCBZUcxUebrMI68PU1nGqeKLMp4Y+4+/ezd4szJsUAbUsBdgttca7B/IQ1bVEm64tdVyTT5dUXuFvZsHRgkQEGYUlisyeY+SJUqg+Fc9tFvXweVCm01s3pgWLzvhoZs992KBnNKZhD3MsA7qoie5Z9qPMw6jgXC7TVeO6lM7Ieo4qjKziZLlH/5uu+MYcxYhQN5oigStSoNasImJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiKNIrjyOK2Km2+jT57W/F+lj/mmbbUPPVM/kUhBh9Y=;
 b=S7Axcms0lV3s00Mmdt85x6x1nD41QrOMxpRJUUk5K6x+kWLr8vXOaN5ixlij1FW2eThCH6tDODyjUgw6n8ztLjkmq5dWA0JmlQsOjtakUCqfUGQsZOB5yXA/TTODjwJyVygw0uVSLFRiWIyMA1dLwDvPtr2EPJPl+0QPnqZaywXzcYqBaXm6O2Amz/9F+jHXvDn3rQegBPGEJ29QVXfd9q/n+oHE6MgLxAKfEXcUi2TzXZHrr3rNDpS+/86xrBm1BK/xWaVSk45FgUQV0fC8JnelSWTOU6A8/eCLYWr3b0LLLCOfuch9QS0dBw4DlfKfcYfiLm6UE+YJlnyz7hDtYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiKNIrjyOK2Km2+jT57W/F+lj/mmbbUPPVM/kUhBh9Y=;
 b=ObGCTFkCC6+54OO80sAhakgz8BVVPpwtNN+5oJCKEhy2A+4cCXf4nVH3OQC8usAmz0Nrp7vlR6DUSlLqIh5pNwCaTF9ycu/Rg/Dz+yt3sXQoFAD/Nz6hFHPJGYYrwBSb1J81C95bfsq+kxlIyCHJT/2Dkv+tWhsPHRWyhWNhz2Y=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 05:37:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 05:37:26 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v4 0/7] qla2xxx driver enhancements
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0sh1jp2.fsf@ca-mkp.ca.oracle.com>
References: <20210111093134.1206-1-njavali@marvell.com>
Date:   Wed, 13 Jan 2021 00:37:24 -0500
In-Reply-To: <20210111093134.1206-1-njavali@marvell.com> (Nilesh Javali's
        message of "Mon, 11 Jan 2021 01:31:27 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR07CA0090.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR07CA0090.namprd07.prod.outlook.com (2603:10b6:a03:12b::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 05:37:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da8eea5e-c543-4cfb-ce90-08d8b7854f77
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB458422B53453879602E9CACA8EA90@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEiUcrhrzrTNrAJ8e9iyyxSA4S1WEohE1P3amkOEVKkFjxtSbsnsTuvOAJl81IjrX1NjUCWRFhGx05DjjZ49Q6fOwVoctUvYEt9k7/18J9z4LuoeUzEwtIauw5QUmGTzTiv8YkPUVcBOC6Wu1kHGMp7WI2mHToLavbOCPUoDHhbF2EMGgldt9vv+J39KX2QrhFgsd6IrPyTDtpbJUTQYz3V0rGwPqzDXOb+GuiSXFYOj7p6w9rosTp9IlL7t4TzPTh2fPIfn6VcENv2onZLCgmvJdqERs2yAqPFERM5CZAQ481MWEl0SPJ16bJ79faJdnwWaHcAlPaoekmXLmsNhb97FzfVFB9CGfljXmwsaaIJDeyT4bkmwx482Y8gP7lLWs3hAUx/5I0md2olsSh899Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39850400004)(376002)(396003)(346002)(52116002)(956004)(4326008)(8676002)(558084003)(7696005)(316002)(478600001)(36916002)(66476007)(26005)(55016002)(6916009)(8936002)(5660300002)(66946007)(66556008)(2906002)(186003)(86362001)(54906003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cjxcZEDNUozu++13KJvtNbCmcOeQdP1AlU/+8bSXQY3piWzWZKRaUiwLrAYJ?=
 =?us-ascii?Q?DfnUdV5/OeQdK7qz9ictH3q34h18DMidNsAscG1Yz9IVqeoQ2/K0m/pAgIHB?=
 =?us-ascii?Q?EAsRFGweLiR9uTv/97vYfqwUpno5XJfr8aHZBFoNUTH9z2xRnBvof6SQC/u5?=
 =?us-ascii?Q?SBpLM3t7pwbN5iqBlPUliWghKLvU8eqv3rBxn8Jv8R+GfzkOi1z6cwJIiJEj?=
 =?us-ascii?Q?TMamXZ+H0YRJxmrFDzRIcFdb2wclaZIAkXDTlEPpjBKEzVPWIy9FVwNKteUj?=
 =?us-ascii?Q?LQw/XZkyJnW8Y0L6mBGqyIQLe2FKK4qnPOgSrPrdCBHjK4Y7X2j/5mTpp16c?=
 =?us-ascii?Q?S9iYPqDAV4/oDCShWQsC/GenzGdphSbJWflSp1x7u/6cslVd0xBOnJIhTunJ?=
 =?us-ascii?Q?/ts34DcbpflfPJZ6NF69OLAWxSE9PeYPn/sMBq9gmKXtnAqHa/8knHHurc3T?=
 =?us-ascii?Q?zpllFpH9zdHg6BWwJak/Q54Ivz/8p5Eh9qWtuniyBbECvyCD9t4A1oVc2qGr?=
 =?us-ascii?Q?aGUriZR5FSTkcywmIaaU+6MRbXZ03cyj9ifYxALwa4nCAx33JZ5n73FhQovM?=
 =?us-ascii?Q?43Z/siM95TgdguunjNBTsrnJVG6J2R8SR7wZSvod1Xm6HPwHJ1z9l2M+Z7wc?=
 =?us-ascii?Q?w4WqT1zFphLQVoPWSjoWhGLiqmkzHjunpxKtPUYRYx3+I9ZgyOf5qJ8aSF0u?=
 =?us-ascii?Q?PInQcbMBRxiUoYOSdgdEc5S4WayfjPWPeQ+HQSmmGDx6IhFJ4h9QCkJ2GHrd?=
 =?us-ascii?Q?R178WcfMXT4nxAE782Dqj2PKz9Uag1z3rF6YP5Yw4+YIzRv04QFhFS1wyYWq?=
 =?us-ascii?Q?s14TLKSt1qmKQjs/Ke3fs67sRJ+0XuQfbX6uUOx6JZYqI9Z+dT28ynNU+Wol?=
 =?us-ascii?Q?a//BOtn05hXhcFwM5l8BfgwJXdnKlKg0P8IPe1bAYoArlMYl/9PAoG9y0FB3?=
 =?us-ascii?Q?iY8V7WfJAjpaHO/YMdgVBHaKBlCqvPARPRWDz0kMg6LV8PywfAHptiU9e7lq?=
 =?us-ascii?Q?WYDz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:37:26.4102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: da8eea5e-c543-4cfb-ce90-08d8b7854f77
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7hlE72Ezn8rB/9CX0FsMcLdOlEYgPo9AILHOx3r1SEHxUZipD01HK0hjQ3M2pEVdheTqlZ84XVFT9rGBmLJXhM+6TM88jG3YlBEsJWliLTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver enhancements to the scsi tree at your
> earliest convenience.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
