Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4405C2B9FB
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8303F613EE
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhEVElo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:41:44 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60958 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhEVElo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:41:44 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4ZCq2019896;
        Sat, 22 May 2021 04:35:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=A/IsPUgXJCl9K1GblAPb9ZlQ6GBOMks1ydWgaqnLWEc=;
 b=An69uTzMKp9NcTm+XQc3tqntnbXzcp7X0a5+fRzze684DVMNJNLXC4dqYGAFtBc1Ve1I
 arMKxam/W/Kd55ig3XVXMfSBnp0TeC79iqD/Wxh6k6VN4RCFmdRCE4Mvx8eB26S5hxkH
 MQOnLkEYhi/tHLQkLqYj6sYda+p2S1l4hX+P+pZYWF/82YVakkYlKByNiXXvgrjrP7x1
 GqpJ1zAkPW9tn11uw39Uen2EmJuLCtUdCLU0A9Xy71IAytFaAHf8OM54DOCtUQ9dwdR0
 JmXCt0RTeLXExGHqvvr5yZbV8w1e6N73TdCtnxDJ4TZDBUTlYMFOU1AlyagQPhD6I7/A /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfc844m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:35:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4Thj7161039;
        Sat, 22 May 2021 04:35:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3020.oracle.com with ESMTP id 38ps9j2w71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:35:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Un4FTt9rsC/LGnhBh/6luxpyuVke3QP0S5IWezKJH+rBONntijymj9q+qwl0V4ysFAUpc1y6Mtr5a+iSNhRI3mM7ZiraYsyyhrZCE+mOqZclLMKBDgOw3Ic9aPhCBIIm3D2sfWmNifOqSNfI7VU04wXXb/9cbTNND9iTkW420LwesBrnSd1yOZGY83SqY0HkcmewxJgcY855k0C0YYP4700OS4YmIbjGs38LRHq523P4n8UVfkuD0cGKwO3r+VXQPe8ZBz3OM5aEFZZg7a93b38hp+yUX4IuCRfuRS+uKZvXplYz8hqF6AxOAGoe7LbdE6b9dQu3pGfZ39I24h9N1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/IsPUgXJCl9K1GblAPb9ZlQ6GBOMks1ydWgaqnLWEc=;
 b=VU/W5wab+By7aBKua68yAcVcy+rEXgu6PSJcMbJpULU3sx/gUxU778LZabakkXNXNrAENEbQCbBFFyHGzLo1bll5t/TX5FpzWe3Smc33FP9s5UJkwv9LB1fVhKYjhkFkdkpoPTatF6/FVYuAmNZF2mZd5sEsRzVz38Ts8EqbEa6MDBt53pj+cfuHXLtpv9D2ukZHkd7ms+/QJir0UMa92RqhcPHW4VAMvGPUFDaUZE6+I6vMYJou2IRIUeU1yrlbJAf+fBOs+B6OhoCEs7C/5p/OiMyKfmRiaWV3APVqQH0Uwjhf5BrIlEmy1hGQTRD9kfMGChSlulbT8a59BKvykQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/IsPUgXJCl9K1GblAPb9ZlQ6GBOMks1ydWgaqnLWEc=;
 b=ptSb1tjdcF060hdv+U1rdHcMgSxt7AhXDNtCcb1J+G8nT/kV4pwtXUfMOHt3j5gC5IIeGVaeReb4lK0Vn85J/ybaRrHBcnZn9GGULFQtxEEcpmtL2lQCJtNEm3S+kilDNUg5HpHae4q+AuowED8kfr5VrwcA9fe/t3gfG7Ete/c=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:35:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:35:09 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>
Subject: Re: [PATCH] scsi: core: Cap shost cmd_per_lun at can_queue
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yzbz8r7.fsf@ca-mkp.ca.oracle.com>
References: <1621434662-173079-1-git-send-email-john.garry@huawei.com>
Date:   Sat, 22 May 2021 00:35:06 -0400
In-Reply-To: <1621434662-173079-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Wed, 19 May 2021 22:31:02 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:a03:217::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR04CA0011.namprd04.prod.outlook.com (2603:10b6:a03:217::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Sat, 22 May 2021 04:35:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27572f17-04db-4a9e-e2f1-08d91cdafb1f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54819BEF6A64E4AB20428A088E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZYEtMlOH9EEnk+LeN6IT+gTM681WffUT4d7Oo3qCbOA8OQCcNS53FtYknUZG9ia/61gvzkgvsEDhdVCyDF9BmNLGXUQkKngMlYvqQb28YIK4hHzhTLuG5cTCVYJ5zz3DwFyCV1ySAENjWA1khgPhYjM5FnimoHd8hzH+MJ+ObwiGoCzpYj7MGcISrDIJBrKwKT81ERJbJ0ZGcaRayQghBj71q1rsMmX2GK2wpAf+d5GO5CzN6kvva+eKHHnv+wiGvJ/DsAE41EJx74joOYb99vAjfp2gg3a/yMdpT8FIyfiUlD0fP2BlQLJqBzHJX4rP6tHsauphNm957yDWmor2An97iIerWiRczJQ3Zw0GSMDeIIZo6hXhIGDvQUV63AUfg3hQQFt96uSQn13htkLJjRUQjT9hRKO16QFN249YcKvOJEXholzDk1+ePK9o2MaNCk2tYDL53vrS8W5EW2Zk3iVShzicwinHDj4aYoNQ0XZWyyYxsS4aoqd5WhQyJI8m294IBkifBt7Gwx9s1KdBxsSkxnzvWhxL721OlCet5DAg+53Ve3NEpQWrqrBz1U6m74veiXKQDpxuRa3HlTPYbht1ess6xygCYr8NkC9g3Gjws8vqiqunkJP2Tx0lPkVAqSEiLksdaN/uyvCD/rxg9ECW7blW9wVGLRMUE/nUUJw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(36916002)(52116002)(956004)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(6916009)(38100700002)(38350700002)(66556008)(66946007)(8936002)(54906003)(55016002)(5660300002)(2906002)(83380400001)(26005)(478600001)(558084003)(86362001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ciXV59Nx5jP/vDACkriDaAzz2Q7DwEcpu2FfODH1iY87UKXBe8QrWZrwCtCe?=
 =?us-ascii?Q?Bd6LD+sq0zp3MwTnAYG2c+oA+607eUBUaCLjAxh0jKzs3ysaq8rX/3kqTI8U?=
 =?us-ascii?Q?hfoiD90L4TR1FpDC07YP2sg4bcboxcpdMKXrrJxoS4x4hBLQ2w2OKgslm8pf?=
 =?us-ascii?Q?vX9YYiuV0ixsFaAu/3636liyOZUYdvpk0vfd/KB5/C0/SKoqfIs0QyQxgHPN?=
 =?us-ascii?Q?X/v4IeN/pe/7IzjkBcwEdaG7q7tqaOzroVsYU9yVMJwTRhWmJy4dB/32oB00?=
 =?us-ascii?Q?eecjrI5WSBrjPL1/oSHLhqtGylAqhLVVrGVEguhx8jKrMlgmp9c09BUPy16n?=
 =?us-ascii?Q?AK12se0NZAB4nk8LEpJRWFvreMz0tgvxlD/G3IhCDgHw8FWe8hsExD6YwUBi?=
 =?us-ascii?Q?Uqy5YNxIwMMD6d3V7aW5g1yQXmn6plZFL/RySUSulRIwuv3Q9bFdj4iWs0BN?=
 =?us-ascii?Q?S0BFSpmiyqaPD3KbYk7OT+/nPMyWtSUfWe4wYMkxIm5XvBtfLKO6xW0T5GqZ?=
 =?us-ascii?Q?gnF0KjHfv6R3oEqiqpnx/3Vxj3hoq02TJFdVzMjG8R6onRHTNdkx56h8czVT?=
 =?us-ascii?Q?MrJyoqUAxWdjrXrkTaeOa7xNh+k07nH35vzTYZXk9HGEBARF3qdkfc2nl1CY?=
 =?us-ascii?Q?boDX38FoDa3dp+6FIWhsbsyoq0TVxtZCuXmj9M6stq85Rv6rR4CqnKLFGEBt?=
 =?us-ascii?Q?5SMigbe0B7eMuat6vT0Cgw/YDxW1iuVSYzPdLygR9eGTMQBzCTsGnaJtrumY?=
 =?us-ascii?Q?d7VpsiVYNLf2SEsZWXVVsyhnsFfRJecdNlBV9WrE/3k8RyBmttGfvx2VTe1W?=
 =?us-ascii?Q?Na+nNcKLlvJ9vHetl6HIrSryoVA6a00Pwxf6jkgvivHGIzo6T00/p+GvHgJx?=
 =?us-ascii?Q?Dv6oW5HQd3pZHLfcat8unc+PZfCBWq3xKVHyXTcucAOvxOdowjE+6+JSybBL?=
 =?us-ascii?Q?RjQSr1pvMtswgeqlLo5yVl1Q+at5E0JCXMKgPNTpDCy8RBcHSbA/bQ8Sthbu?=
 =?us-ascii?Q?SG+P2IGI9F8juyvwOtKb8VxjOIFL0YCv4aI1MDhFpZ+RV2xMosEm6qqbqzJS?=
 =?us-ascii?Q?iUKDiIwh574MxrJ9xCyvqB9UGBLn4cgiXigOGKcNm9j53TKXAx8gWbYbWCii?=
 =?us-ascii?Q?83QZJmg6Yfl8FVaK+RjIvstIC+Bp4uHh+7+Ytk3soZnI/fPw4g0I4HCopYNb?=
 =?us-ascii?Q?xW2WSRjnlBrMrtdO5h++LAasTG6kLUMl8rgR6Uzeb1IPc/MDrIpSh6aIRLam?=
 =?us-ascii?Q?IDLKYwnLl+O7l37GyzqBuE+xjCxBXzkDAbd0hI873IxlsUbuwO9t7Lmh23+Z?=
 =?us-ascii?Q?xVJ4EYJwxt92Fmr4ALx68nQ6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27572f17-04db-4a9e-e2f1-08d91cdafb1f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:35:09.2838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PfL2EBGnkihVoiNHWUPFgXaYdKzRm8iPpk7YQN7fqakzFWc26cJCD5IZtqb1rEjlBXFI32qqvm6c+97Itqb4KgrsTnmYZ/oeiRqRK8gdKCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220025
X-Proofpoint-ORIG-GUID: nepW53kVihF9s_aQbGhmR5VCuoh5UEQw
X-Proofpoint-GUID: nepW53kVihF9s_aQbGhmR5VCuoh5UEQw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> Function sdev_store_queue_depth() enforces that the sdev queue depth
> cannot exceed Shost.can_queue.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
