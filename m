Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23697C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 02:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5A206198A
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 02:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhC3CmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 22:42:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43780 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhC3Cl7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 22:41:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U2faqd183449;
        Tue, 30 Mar 2021 02:41:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=j9UpyU5miwetbkCkypeGkF6zGb/SU3v7v8gka17rqnQ=;
 b=I1LgIc4K8c8LEhyzDD7pCSpx8m2yF8dtIBhZRwWuHWXDKPaRz5cgaYf6KttLuxBJ0As+
 tHCmnvH2kj4lML0wlO102IQka8vpvuvVIwGJ01xi7EZ7PWa8hoGs2E2jYKgAp6XxhFG+
 DUY6Dq8QC+YM7rV5N98Xefr+CgyVsPByZYFPG3PbVs14PJVIAh0YDDcfbypCt8aT5rvA
 LOqiuAnyAOM+u5VaQfUsuMlL4pIpr0PlmuGY1Ohd4lyo4sQ6Kn24ZCY/39DuZLw25bMh
 UDwk7sP4iDWNflGQZVwG/Q/q5E9Rbl4C5hX6KzWHdztnCHuLkkUl9c6e3Tqp5xomrGUF Mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37hv4r5fqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 02:41:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U2aXOJ070481;
        Tue, 30 Mar 2021 02:41:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3020.oracle.com with ESMTP id 37jefrhny3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 02:41:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+0tg360sQLhISUnOWESvTD7wSLES1sYeo3FcFbaYnQiN43IrlbM3n5YUwcAPrIFN1HLc3+GSY24TorjuGN9Jw5iQJvVPCs1/QDbdQABMbdPA6gKGW+Bg3U8HRJsKrMf2pYHwohreZBV9Dxadyyz2CeDHJsa/1JMhEZ+svuWz5s5/aDIWgXo+IbLjwafIgl3ae/VhGHtEgopXvZnYI3/+YfUbgYVVc6kiHC6wxCrjkHbzBcvJomqAy6PUC6ms88fAc4mnBgFTm50FqN7fkDwUMUvUMzGzk09l1loWGAcZNMBw5g6cl37EVpkMF54EeixDVqZJWDKv1BV+TKcikBEJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9UpyU5miwetbkCkypeGkF6zGb/SU3v7v8gka17rqnQ=;
 b=OmWZ6Z7O8yl2j32+4aOMEnAzic7P9E0tROwoxDoDqhHrvbNg5lERkg6XuFhVPfbtBLj1XuuDszbJbFsK9n2aKazyK1ZgBopSBpC32468QnHpyUvrLHFwPROEIbmvxUmGLa5o6eExd/IUvmS2iiJAhI8gFWOswxaqFeCMLwQ+uSPWhv0sJruQezhp9B9ti8/d1vKyQF9FlA24HTwQF44sNN6RLjBGVRTsHTKseurRg3fceuzFzC18V0EE+3lphgsP8a6xvllgQeJuXFKEMlvWe+WzLXM6+bMHPHADBPH7Qt4ZId7s9np3nkrrSg4QC5+bhSPDmxC2xR/Fps8PC0KfNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9UpyU5miwetbkCkypeGkF6zGb/SU3v7v8gka17rqnQ=;
 b=EN8+YYdj5mhP76eitLJ+y8iKN+5LftqzB34vGSPylgfGWxQ6mKGQayNJ5exsUtHNQXGvI/oWxN8XhwSLWmzTFCxIVsxFzeHr+eT9ylmgheRThh3du+ZfUpQ5miLYfCHUa3BOdEIBgAFF2zcFQhZLI7hUCXztNEQJZoi/WybRg+g=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5468.namprd10.prod.outlook.com (2603:10b6:510:e8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Tue, 30 Mar
 2021 02:41:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 02:41:53 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <loberman@redhat.com>
Subject: Re: [PATCH v2 00/12] qla2xxx driver bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s65icrp.fsf@ca-mkp.ca.oracle.com>
References: <20210329085229.4367-1-njavali@marvell.com>
Date:   Mon, 29 Mar 2021 22:41:50 -0400
In-Reply-To: <20210329085229.4367-1-njavali@marvell.com> (Nilesh Javali's
        message of "Mon, 29 Mar 2021 01:52:17 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR05CA0059.namprd05.prod.outlook.com (2603:10b6:a03:39b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.16 via Frontend Transport; Tue, 30 Mar 2021 02:41:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83596730-d031-47bd-3cb4-08d8f3256055
X-MS-TrafficTypeDiagnostic: PH0PR10MB5468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54687AB8BF51CE47411BE7A58E7D9@PH0PR10MB5468.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YN6Ry93Yvg1Pp4Mthy2G7/lG4pHmS3/26Voqx24DC14Nrnv2miaw3hIELpBBOAsE1u0dlp0ffigq2P7JFF3/yvtNw0J60qq37yoknzc8Xb6KT3snYaV6gcX7w4JX0AuJblwXgdO5/Ow2Dvr1lSN4MPKasAau5uWGf8KRNAnA6RV6CPNdLmRDDgZPRJV7QMgsDIRz51cADbZ0N1pt2KAZ+O7hJVDcK1tVp0XA9e03cOMyG7zinRUvp/44/nwIrSN/oppx1FodISmESX0ahEus8GuprtnLVx0WhnmIzHBH5tpSYAm4Y/GFzsrjytGVM/xq/4lO4AySZyDgEwrpTLiXE08OK0QmCtOy92QZZSHniXXWJOo8d2qpImWeX/d2s/Sy8AvW5aAAqV8a+WBWUTaQ5o3QiGJBQbi+us9oHAx6JXmerr31CSJ4mdsBJFGiyUruIPVdxMiH9BxiptDv3x7A+9Nfi2xNxKLxnU/mwpxtk1PdOnWuq377R2XarPgvJDVmgCA4WtQUFTT5SZ8pnTl2ybg2OFe5yZZ4+vQYv0ZCQ5E6S07JK/Z7IoWxhoGHwxhQZ3SI3HjLAbA7iNOmTt+zqU+Hnr8lZNYQJl4vkjtYPb7D7rHAoSMBHFXDiI7Yld8KLwLHBdzJMmtigWJWSFCYOA5BR6UNCJ6aVqq0ui1esrU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(366004)(376002)(346002)(52116002)(8676002)(478600001)(316002)(2906002)(66476007)(36916002)(66556008)(4326008)(86362001)(5660300002)(8936002)(54906003)(558084003)(186003)(38100700001)(55016002)(7696005)(16526019)(26005)(956004)(66946007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h2qbAlEEHWzeyN/K+oLQti+blHWuKKhSeAILfhvwbKj+iZeLRO/Zn1aJ0NBp?=
 =?us-ascii?Q?LWPR0o0dWtOLUA5TzbKCSOAQ5TUqcth+KLRZf0mPmfOXsUS3Od1qD67K9QhJ?=
 =?us-ascii?Q?CPOKjk2poqq1D9u5JWwnFbHZ/2tSAeNRKYAy3EZswO+FYwwIis9OUw4QOOyi?=
 =?us-ascii?Q?vUQ0BkWplAAfrQ32DDMuWYu3ibxW0vcf6d8QAa8AwEIiRkh1pnChXGpJFms5?=
 =?us-ascii?Q?UCeADT+sET/muC6hP3/bDz3bCEVeDsCGfPX3BoZG+4xZ/CBh1nV6aNNa+PTI?=
 =?us-ascii?Q?qwicMS94oF8FGonOCQD8x4b3LY2sDfEoohj7DoCtyNajTMUIWZNR3p3lwllg?=
 =?us-ascii?Q?AH6p35cIBPCodYqlrFgVqozxQDmB0lY1x5G0Usa0kNDPlRA5UzwxOE3SjS5j?=
 =?us-ascii?Q?UDa+yXqNNz7Rn67gTPOlhwsu1rKIny/YjCEovL1/dT7gSfDZ8sL+cxmHT1+i?=
 =?us-ascii?Q?KXDV6EnFlScb0uy2JhyfRwJ11tnBObXLwJ2meEJHKTCRII357ugemP3xAKCB?=
 =?us-ascii?Q?EoIDl3yiQgJEz26lYRpZWMEF/248TXg+ohEsOqrJFW/31CO9yP/i8JcLyz0C?=
 =?us-ascii?Q?XcuWT5nIHfpDE1xvNiP1wHMIVe1zusXJC1YZlnB7OpTvCzyIYoEQceCl+8ac?=
 =?us-ascii?Q?+0Ztw9l5YtgL3OckznLoopewGjfrxR36QWL4pEYi02lbflV0aRJapqyPHb5y?=
 =?us-ascii?Q?egWraYalQBZGOvnmV+al+kqptvK4pj644RIT/38Nn6V1bW2CF1VXqEWDelEN?=
 =?us-ascii?Q?yQFjUXdNDvK7dZ3/daRe3Mh34RURbLQhCjfcEH1N9Be9nP+C3bQxiCzmdqfX?=
 =?us-ascii?Q?5ecOAVGjm5ScjESiyWp0PWZCBzs22z5mg/WLJElQqjpEIy4/L5QEWX/LyC72?=
 =?us-ascii?Q?K62D6sST54V6qubnkAP73Hz89UsIOw3Pyd7hL+Xx1YoYAXZh8IFB3xXqVbqn?=
 =?us-ascii?Q?cJW0WDNDwAGYZbXa96n5sv+t91UO10OKzP6TI5DhJc4KNzpr+CGNZXVnGF3/?=
 =?us-ascii?Q?v5mwazMp9Yd6yDo5uYjR2cJ0hN2QGW9jJd3s9ShGB1B+ypRziNgQ267Wn7eJ?=
 =?us-ascii?Q?rI3wiLES7VLP/cUwSQqkIu5FPtErtalDmGvrDWKI+urGp7rE+qFHbw5ttPA+?=
 =?us-ascii?Q?/L44ChU8W4E11At+sgi6UkJSe/3EvCbgDGeKq2wDV8eMiDgpSCX7tWU0fH3Q?=
 =?us-ascii?Q?gjjjL23XDHejB3/zLaoQu+DlMPH/d2Dz4tdJ0lyGm0E58VxSJ6IxSbnlb/kD?=
 =?us-ascii?Q?ttbpyyvfzbX3qf70aGa+pXCR4bixpu+/PErVTKyxJag7gmUgATUPjRm8Ip1G?=
 =?us-ascii?Q?v6gqHYtB9QmgRZtuYrJQlnmB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83596730-d031-47bd-3cb4-08d8f3256055
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 02:41:52.9747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nfmvK6lk3b2p6fz1M3Maz66cHw0B+MY1CgThgCoLlXhk1kGq2tUCe1zcbo7Q/OOJVk9sgS/czFbVYrDca7yVRTxsR2CBCSQsP1Q/olRSsfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5468
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300016
X-Proofpoint-ORIG-GUID: d7OSz4EkeCqY8ko7KONm57w9PTTsrus9
X-Proofpoint-GUID: d7OSz4EkeCqY8ko7KONm57w9PTTsrus9
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver bug fixes to the scsi tree at your
> earliest convenience.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
