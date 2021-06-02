Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB03C47083
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 05:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BC8A60FF1
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 05:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhFBFam (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 01:30:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53922 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhFBFal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 01:30:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1525F0x0010153;
        Wed, 2 Jun 2021 05:28:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+Q9RjWI99tPTIclJYyb4519vqzra7O2gwR541mSpH3k=;
 b=ASgQaJ58DEHnV90RgAFzi8QuN4N+gu2QPxQq/yVwECaioTqDDyr6JHeLtY8TBwJvGqKS
 L8ZARFTEYJisoW1Ku9Qev5ikVy2QDlEkpKd9W6g8CduhFbX+V2Be6LZXmZ88nhKBlYqN
 AeQkuYDctnMiNkDSrH0opYnkhUW9E3ENHro0Cl60x/1aN9vOsQxSmIyqn0PS8zaY/Eev
 nXY4ei3+FNu+ys81IEL8iDkG3OePvqdPt3JBiPg4VX3uvSswI14nxcgi2QCOL7sTgWmi
 HOXW5rj2a3eKh7qmUVvHudLbxst5GLGYXWmAJ+/SKq5TrDkJORjZSAm4MwHJdTMHVg9a jA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38udjmqbr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:28:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1525FJWS013680;
        Wed, 2 Jun 2021 05:28:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3020.oracle.com with ESMTP id 38udeav3fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:28:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPoNQl1n3Y9z2uJvep/JGRN42z9kwR+MJ1UjWJgVpQB4nIbvrSSzf4BJoYZnLJq6F6n+SXfPh9RLz4tiJd01eg38zVua2wmPZBtMGBsqHeQYv/Ti624g5u6JLC5bmIqh5DdFMf4P2dqYWQpKG8xuymLdAN+o8Qc6kcJm+lD9rvAJbB1oYMeMXW0IPhXeE43+SLluEuidZCa9jzk6f37FsXpRZlEeE2XVhKjFtewrsvpbPQ53yMcw4xrzwd6PEy0EcLtoe0GIiZJNBj06v70Ta/p9UNx9r8ZZ08dxqWR6fbOnl1sXz+sdQZLKu0HNwxXOBhj+L994hiVT31HnRNR+xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Q9RjWI99tPTIclJYyb4519vqzra7O2gwR541mSpH3k=;
 b=fZ5FOA7yuHLoGrcgZhLGbSarKwSnItFcIhqym8jS/4LOVgdSV+tK+wJnjIiMs7xrps7sqTUNuIfnF61lfUp7btwlKlyjZNV9qWcKCkDleUZCKWq4O5fh+ccL2yS3ODrfZj/M54lxRfpn263lIMankki02vwesPuXzX7Yrv5sWQ1btWlcA73b4o2u/aD7RnXjPDAYVstCHAEFcanh6GItUwz2XAdJyEG6hJdhkyyciU7niFPMxdtr0jvqCBavWzX624zdHpsNv3I1Xlys1tJe3Oa3eO6aZ0Gq7kijWDA1jhyA/O7OykUPAgZt0FLYJnQcxGFfqX3Qaf6OJSAUMvIc4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Q9RjWI99tPTIclJYyb4519vqzra7O2gwR541mSpH3k=;
 b=aHauhpv2Z6mA/rrV9lrEXUT9QDw/9hJpw0tIsXvPwveP6bPDhHPG9Ixh2fpx5MqnD71i577VuSwHEIOWPv5F2WSa5A1Sfj2cID6EcwUjTcC/syrrEasc2xmOGVx8rLhqasuIVu4dFeijNDfwncaiLvyDMIs5DW0ZUupvpbbPITA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5435.namprd10.prod.outlook.com (2603:10b6:510:ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 05:28:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 05:28:49 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: iSCSI error handler fixes v2
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsy0omwq.fsf@ca-mkp.ca.oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Date:   Wed, 02 Jun 2021 01:28:45 -0400
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com> (Mike
        Christie's message of "Tue, 25 May 2021 13:17:53 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:806:27::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0150.namprd13.prod.outlook.com (2603:10b6:806:27::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Wed, 2 Jun 2021 05:28:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e832537-ee00-401d-9cf3-08d925874cec
X-MS-TrafficTypeDiagnostic: PH0PR10MB5435:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54355B70212A9490298A42A28E3D9@PH0PR10MB5435.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ByZz00dhnmKFhElqWVKzn5ou3QdSJn061QSbMSc1Dg99rE63sRb9LJDm9Ft8FZCkTN3C1ZkkYBvWXBxcEzC4RtI06L+TfHyeaqDVaJxpN2HWfkczWpFRP4GLoo+rgQZCbeCbJuI4bW2CawIARccq9/LNK04hTZbEmjP+exPoyaCOdXWfNoBq6eni0Yfz08JIX46auq26oaJXCakcPL0wEPgM+bO9R7uScv2cQjUpIUnuSFrl5Dtbdb5c4Ehbc7Ewj6I4OFDq26KmKAt8xDDNs8jzaHJMedK0Gnq9LWMaaau+pNwzXzc/YJmPo6gajXe6ZAVz8Xter53BNieFc8E3V7MVU0ow3gxi0kwv+BjnkrJzjfOulbX2TqB/ju3a4yLcRsYcxKxIHzBeWGqh6K0NDJ9IT9iS2CQAtR2apMZA3fNtV5WAj4Jgc6qA6NCV500Y3hLvDNbD+wrDx3JNXI6adq1Js52jhs1NztUYYFfUnx5JbM9H/qk+m19HRO7giB758SQmAg7uUkkL/gQimPyZq6Ebc16Ik7rlmmEnzq/Nxpv783z674z6RsOrLt7gNiFf3KP9R28/sWbiOMGE0DZi7uj/goD1i2F/os49sAREtR7tNczHGdNy3RC3NnAExgFjVKFcd2v++kSphejkFwfPk/KNySTOA+6ifwumbU4nB3Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(39860400002)(366004)(376002)(6666004)(55016002)(26005)(66476007)(86362001)(66946007)(478600001)(7696005)(6862004)(4326008)(316002)(36916002)(38350700002)(38100700002)(956004)(52116002)(8936002)(66556008)(2906002)(4744005)(16526019)(8676002)(186003)(5660300002)(6636002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O0fzj4eCeBbahcs6iUUYy+pLmAniAhWSEXCCHfa+92N7Aq76XGjSSXO+DRDO?=
 =?us-ascii?Q?aiS80KKyrKYKznNrUUeMBWiRpmN2pJaBWy3fgTHFi62pEwlN6lemE/XhAlMJ?=
 =?us-ascii?Q?0yp1Avx45Gq+POj7miSBMw9lbJsWPIS/DYmzW3+HstgeGt0EnW9UmuRTh9cA?=
 =?us-ascii?Q?CBqDEsDF4+7i0AUMIEBDynlQY4Vsrp2PUSzShTcw+YLL4mTSpptfGr2Uct2X?=
 =?us-ascii?Q?Pa26sTKqv+b2KkihlWQbLMlXGz5HzxWj1igJN8UhGoXXEk6f/Vxtb/T+KCLX?=
 =?us-ascii?Q?qWbc5mdYWidla+6VRg99bncWHRI58y5Bj00ctiBuBbfBeoqhnLdSORfjold/?=
 =?us-ascii?Q?fGNunCH1DTuKbVQpe4Cu/2gZjOYYfBuqp3L/evU1CDc77SydagqOgEMaM2s6?=
 =?us-ascii?Q?Ai5Wipn0Kd2IpNrrhVHWiDSocLIRqovqYbuMrwPXxXhuC4WegKuV80+dhPuu?=
 =?us-ascii?Q?chajB2P2Kn13Z3a1Ql/qW9crtEZoxfeRI+Wkp1qMCJbcr3W2V5Sbqi4XWzzL?=
 =?us-ascii?Q?BUV44/u3++NPtcSlSzMy75gS4Ik/iXpel0gl8KtdRkd0vJBOFfs9NJ65NlAJ?=
 =?us-ascii?Q?RPH5zPhf+d/GSaFisHCeP930pIR3PJ7INavwz9ifbzFKF8aTG6KtanRsY0+t?=
 =?us-ascii?Q?dQMXdqIt6zKOnNYGcB+H5bJ6lFhqyfzt+bF8sQ8CJIYxZZoEn9Jt7fGvuMDF?=
 =?us-ascii?Q?RxO9mWTWxJJSfwKfu82MNHXDqEPYF4f6hefEs5XpauSz88sE6wz7UvmSaGgt?=
 =?us-ascii?Q?4RH+HjTmdSSdbgqgYET20nW4Dlio8GACzs09dxlqbkwZy7PVzdyCqy2Da6o7?=
 =?us-ascii?Q?VxG7WCsuz7/8pj1IPwVZUtO8DAiztfMhvcZCY0CRDw4ZGo+ET4kveW1sE3tM?=
 =?us-ascii?Q?jknHPfTIYWH2He2luIM2Xf2koZMYCbm4wQ7wzCWIY+qDiFWFyrPPFBdsfzX7?=
 =?us-ascii?Q?TnZ8T1eDrscQ7oqM2aona7E0kbqp5XZRJXY8i6HkJEYZhgBt5Tj//bzJ6Npb?=
 =?us-ascii?Q?xV9nZSJ+X9MKG/BkcFUbNOs/06AoJTwH9LqQERZGUDjvtK1dzm0o6akMvvKF?=
 =?us-ascii?Q?0krdSLS7kHfdSRnDsESgWWtILgOC01yiFJIOBN8hL4a0A3WKkAXaqPgEXm3X?=
 =?us-ascii?Q?gVhEYY2hpELEkMI1olAXRs7qwtO/In1loTpqmh53mZrv20BDo4JWaefKUg0x?=
 =?us-ascii?Q?2vSl8CbTyDm2BZ3m+0RV3UQl0LxJJCd3X9RTcXn0XxFkxaqcsEGJ4bYjsIzI?=
 =?us-ascii?Q?fB5NSPlUnryzs9+ON4UE91KTStGzW/ArROlP6FOdmMPKXKKCkLC6d6UbZzTB?=
 =?us-ascii?Q?Fu3R7QsLuvxPw8eRwk3h7iZL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e832537-ee00-401d-9cf3-08d925874cec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 05:28:49.2945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gw/2pKOzcQLzQUnaI6VYBnNFHcI+I3AnEXJ1ea8XyteqZZvmQ2m0YGrrGMuA4E3hcuOXNPL9utq/ktCtfyZp8hFxaX0xtSWrgI1E52fRnfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5435
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=962 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020034
X-Proofpoint-GUID: aZB1DmpcmMj7F7ZWkgFAIdESsvv_KWBk
X-Proofpoint-ORIG-GUID: aZB1DmpcmMj7F7ZWkgFAIdESsvv_KWBk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020034
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches were made over Martin's 5.14 branch. They focus on
> iscsi and scsi error handler bugs. This set combines the 2 patchsets I've
> been posting to hopefully make it easier to backport just the in-kernel
> fixes.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
