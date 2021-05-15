Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79562C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E4B36144A
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbhEOCnj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 22:43:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48644 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhEOCnj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 22:43:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2g7XP055793;
        Sat, 15 May 2021 02:42:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Wyc+1Fb1TFnKDTb6fVqRod6ISeGXm41eKSQRUk0Gj/A=;
 b=NcMbRCa1sHW4wy75xRGRl56OTO3XZsjbpRosWFSdGrl8ULDC/5uKpE76rXoWfRvgV0up
 ScjoLnIgk56D7LdDH8XUGceg0BbEE5OpgVQEwq6Ms9igCpkV1vOwYHvWs4RYU2IFYtri
 GxbwjfKMt8AlTJ5sqIQ/mIoL9NwWj7mysczRPQntE0bydKnCX//Aq7qIVLkoPoXCb6b4
 dHGTigb5qRIB8LXEZ96EW9F3HR7uDpIiZiFeSvdAbkNvg4Rt4Qjrmfv5r1MXyV7VDZ23
 a1oyYb7rRecCGOGbjMP5ell2n+drquLIywJx6DviVzrkLimJAq/AINHVaxehL5qgHN/o Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38gpnxwktj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:42:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2e0I4184765;
        Sat, 15 May 2021 02:42:13 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by aserp3030.oracle.com with ESMTP id 38j4b9ha9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:42:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFvhBczgIIm3l6yEbWyd2R5GEjZ/OGFfhaWN4mrHjZsqvblV6J6foK4MKK0s+5ELzdycM+kQw1UaO6H32RTQjcL7mRa566oluK6xiIGR/yEQHcqjxC0ylaJzcdPWRjYmY0Klbf1H+v/8HlgcRKlZpQasBHmMBWFSvqg3MA3t4h/EXDRG4t4WNSfwtMnMSC6mz+s3uV/Q1AfFJY5ZjpdKRWtv9M2xCo21O8CDiPJdq3H9jQ8xn/9mILvXCemngOsWzQKqV/FP51QKuy8fd0L9j11l7FsepyR4FrOO+VsqK62d57up8JV3ST0YP9Z3hXFrU6QbcZCCoEAN4CJXwBYrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wyc+1Fb1TFnKDTb6fVqRod6ISeGXm41eKSQRUk0Gj/A=;
 b=j2kXv1rjKsE5N+nlppxX/XhozTopJsnKpbDn8M97ETAgCsXccyiT6V9CsqwEbFGB7QaCBQsBk4DIL7dGjrr9SZ4DVzsU7gQ7rZpmFOshXKuyLZEhmnlkqI6WfyfmjjsqeDCOqxJGrfJMQVMO/F4kRoqz0YjO2xM8m0zx+LpFKD4gtZPP+O3xojyrnxuaI0VLWvTEDjVO7kAWoxQ6Q76YKX+A0blmVAsKX8ZOhUpHF+meWrdkyKpeF9cHbfotFw9zMRmOyiWagtkWnZ2ToHIIqlRVMkZzVBlXz2wYNBNDQpEani4Zn5jUM0In2JFtISsUPwJtjwXQ2fFRlP1icXPIkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wyc+1Fb1TFnKDTb6fVqRod6ISeGXm41eKSQRUk0Gj/A=;
 b=vYh/dA4ekBNJvNF4pOBwRmiJ0YE6wRffjX/yUZa3H5r7VpvCwY6vU/2UcnZN21+NOmf+wZzEa48FlIAmWmzMgVs3XtkkHRi/6i7/8h+BpIhFsmABAz/knw+xVSHoM7ZaaNmjfZ//XQ8ZU6AEZazfZvN68cIdi0973ZzZiT+rKnk=
Authentication-Results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 15 May
 2021 02:42:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 02:42:12 +0000
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hou Pu <houpu@bytedance.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH] scsi: target: iscsi: Drop unnecessary container_of
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dk0btvt.fsf@ca-mkp.ca.oracle.com>
References: <20210510040817.2050266-1-linux@roeck-us.net>
Date:   Fri, 14 May 2021 22:42:08 -0400
In-Reply-To: <20210510040817.2050266-1-linux@roeck-us.net> (Guenter Roeck's
        message of "Sun, 9 May 2021 21:08:17 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:806:20::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR03CA0027.namprd03.prod.outlook.com (2603:10b6:806:20::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Sat, 15 May 2021 02:42:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be4c0806-6001-41e9-a92c-08d9174b0ab2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4696B1B7C618BD079AD02A2A8E2F9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WdhQjyiDX8umytyivWKmaJsKhInez3XQxbJ30KlfuRiQkwwO/sg7ycBm6M2HCJB6kkhACBQaqEHkRw/uxNNlU+WAZe03guaFxC18p1FcmY0fakCrkMnmFE+r1n+CbJyguA5LduJo3E5ZbLchYndxAm34Dwx/0mCSuTwaYlSNdeXb/ZuC19HK73BpWR33s7fMd1tGvsNtpW+7VDAGZPxjoAWlnIYvh+oMMUzySTtLUfIeyLIAAdpcvATMGYytx2HgysyQApOAGLSZnPeNg2ke14TyvvGDc5KQyJIbDWH2z8kHkNV+ZKkImpccJOczLbA4mJO+erIXkQNVMyQxCMAkZkUQ6ujLQZGIqtAXGTK1sEm5Pf2pDG46CIEl9dW+lrp24jK19v9zetIg2jfLM95ak4Kn3KRa77UMw/Aha6biBx0dngOuV9q3vqmKCYqvqPrBDWIpdpPiDEya5rN9hQ4wIA5oAobeD+G11BkBQLwtHMUDqMAu7mv8F+Nq/SkIAL/u0/YGTti7x3ayCQgk54Zd5bpxNfTQbf9go/5skdId48F21lCkRTtorsbUpcmduK7XSxDDNBd5xmVRyqCJ32CzRHy19ra5vI0KkLQ8pGeh5V2Uf2jC0yE8bBwuqHMqLsdzC/6q4GkrHu2mE98TOGfNRawZWreRgnlbQ5/6gmKTQ/E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(346002)(376002)(55016002)(186003)(956004)(38100700002)(38350700002)(7696005)(26005)(5660300002)(4744005)(8936002)(52116002)(8676002)(66476007)(86362001)(316002)(107886003)(36916002)(2906002)(478600001)(66946007)(66556008)(6916009)(6666004)(4326008)(54906003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WuQvVx+MUkEcAFYIPQo24lfv97DhaH0/52TppGm1ubDHdP3sDtvAtKH07x7a?=
 =?us-ascii?Q?hbO9vS36mafEvIlI5IV1Y3i5YFKOQvN8jUyHGe89JZL9bxq4pwQXbAF5O261?=
 =?us-ascii?Q?5fpVBlfLhHQ9NhEkL2rw6QOxoT1d5O72ERw/Ev2IVS5NFsmOtuOikh4qsYYW?=
 =?us-ascii?Q?ZQKLz+M41SBwcefOKRAu75Dg78hQxnHpdLk6jl56EEETFBxwXV/Oq7E3ZUXG?=
 =?us-ascii?Q?THvisbXH5BdGlMPQMU7J2POk4VaEIz2F2c3cbCB6FTt8jnJcwQkuCGAdSIt4?=
 =?us-ascii?Q?Lqy51TBcpmVP+roBPm6iz690moBS9W/LAKfP/aXg3AW4pD7G+7JKFI+SpVOT?=
 =?us-ascii?Q?l38L6tglB4WvJxshoGlvQjpLXmyM/0dAeVdazVkFUeHu/N39L+g2yRh6Qp6m?=
 =?us-ascii?Q?pWmrq7uKZAzAlI0MRlnHGa7DrGLt4xFeOKmlYZe3M+t1jTgqRlrxC/tlpHUo?=
 =?us-ascii?Q?Hr9yFqXAyA2D52uS3E/11S/5y9nmARHWcPX8TGbPK+v4eXKHJ5BsGitp1UVH?=
 =?us-ascii?Q?LKnPGKse2Zn4w5zuzSLmuqPwViydUZ+F871ULWUyRjlXyW4eILxNAg0ef9Bt?=
 =?us-ascii?Q?ZzIBdwWIXyseUpwoy14+eKz9/BfBodtskTI8K8siRdo6L+GWC0Yfe1U79tRj?=
 =?us-ascii?Q?gnXvyRXuowznQ3aeR87H+Oga2X9kd4RgMnCX2l4JoGcYwH5xGr2YcXFeSgrO?=
 =?us-ascii?Q?J2RL45GXiwiTMYXQTLR88VM9LqDwuoJeB/9nUVzLgeV1ZWDMWzPhitKqrTjE?=
 =?us-ascii?Q?62bBZ2mJbNcNJirJaqHSwJo0I+qdO5bqR0NEI4w3ZMVHKYlacJmkV4mHbnei?=
 =?us-ascii?Q?4pATBrjwHTqkXLCQqFiEW/SBTjTIfBNEtxHf3aCjTBvjONxZl7daiIzPRvYB?=
 =?us-ascii?Q?2LNjCFz8668vsVqOyKLc0EplhyQDrb52jAl3P34AI+OpsmJ4ge57gIB2PjY3?=
 =?us-ascii?Q?xse8vCTQNUT3t9XkbKcXOBC7KgD5oM6vDTsgXGpsR4h3lFVi4QZRV9I/fVLY?=
 =?us-ascii?Q?JJBwRr2XZcmLxy7ucYwvUvVM+NAlGy24Q3f4WKAmKpBS4QJwn4cquo68EKaE?=
 =?us-ascii?Q?WF5/AjZir3yDfhYDTeKGDLClfJ78XYLnkhUT5GRDtxzfPtfkvCejbkyP3fle?=
 =?us-ascii?Q?JlseltUCmilPY28iWFzmDptOFfHW3b2D+VNXu3UwdbSUz3FBAlAyDLmLGxWr?=
 =?us-ascii?Q?yWTMqgKxLpVTpVmb4uUoirrBgWgFyynwu5IjjaRyBFdtln6s+eGO0IGSU318?=
 =?us-ascii?Q?m6T7lG5mj2MchqmN53ZinZ33rnCeuDN7k9sOxRZJ+DGss+nEsbeq/bjBholT?=
 =?us-ascii?Q?DmgzzTTBjE7J4E5vwksfWDoL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be4c0806-6001-41e9-a92c-08d9174b0ab2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 02:42:12.0287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 33l6tzr7HS29UiQsxmZsrf8W+qVhDtFSEzThKZDQln+w27lhMEE7bSyuwVTSVxbtHf/jdQTtjrM1pCGQcWOyYz3MCrClUevkpw3SBlkliHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150017
X-Proofpoint-GUID: u8ag4R3lU2EVhENbNJVaeVYdPLm35_Hd
X-Proofpoint-ORIG-GUID: u8ag4R3lU2EVhENbNJVaeVYdPLm35_Hd
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1011 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

> The structure pointer passed to container_of() is never NULL; that was
> already checked. That means that the result of container_of()
> operations on it is also never NULL, even though se_node_acl is the
> first element of the structure embedding it. On top of that, it is
> misleading to perform a NULL check on the result of container_of()
> because the position of the contained element could change, which
> would make the test invalid.  Remove the unnecessary NULL check.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
