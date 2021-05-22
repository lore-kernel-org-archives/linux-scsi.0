Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C795CC4707F
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 02:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A325613C8
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 02:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhEVCwj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 22:52:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39654 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhEVCwi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 22:52:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M2lBGN060489;
        Sat, 22 May 2021 02:50:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ZMpEBqfY4uyZyslMqzk4oeE1GOdhgf0uBnX8WQX+qcI=;
 b=gzBD0tiO3YWK5sS9Vmel4orL3PjVBu300xLbT2QWHr9HY/dryQZoVlUuVNioH1M4F95A
 WzAtEMby3c3OGIh0xDcHDTZ7QIQU0/8qTrv6J7oU08ZH25+Lfw1W28TBVSWg9AEWRkPk
 ebh8WLa7tCO/CHJcwBnXkLfjdO1hc3lTzici8zBekdQ590mIxe+Fu4QAa72upuPCsryK
 G1iastda4lf6SU3ctstmVbbONBGBkSyPhtCq1TIu6TxDdlWvxEwxp8Ch543AqHue8qe9
 TzEjdgeXkkgzCDTAi6DX0QOnY28oGypETU0X+iqwUTkQKS0sfdVBrVsDrMSbiiM76Va0 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38j6xnrytb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 02:50:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M2niq2004861;
        Sat, 22 May 2021 02:50:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3020.oracle.com with ESMTP id 38ps9j07q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 02:50:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3zvJ9+V5+5w1uZ5pi5ch3/cZmTxx0+2Vn2PQs4i0Th7JOdVKKJFkJSYQg+iVxtNyeVrAnBwFutQVbtmddTjXDL9V0QUWxPE41jJorOyhi4jTse9sVs3RMlsCXzdQYGR5G3pEuPZs+4V+JKeWgfu1L7MV8kPHoY33ieZ/d0GfW2Q/P8Od0S1ZUg+Zxl9yg7de96vLzzfSr08yuoNDJsK6pE0Up8mocfLz8BMWTzWQperH2+v8C8aC+JYMNPvQT0SYhozTdkQsKRoWSleeyrchaGlsq+tcKxafPRMZndQQ+f1z7BPI5/Lz3UWAE+j2RZKj0oxdcxs4j1GvsKIWdhNJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMpEBqfY4uyZyslMqzk4oeE1GOdhgf0uBnX8WQX+qcI=;
 b=nFeHgh7o+f5NYZahPlbjU6hZcfkn2sp5u1z/VkjV6xNFU+8aHOLmV0Yy1sJ2v00JxBGbx1GxsmpqXpcOZdXXQUeDbUYaYzwJaQolBNdu5OTK0c0dSYGX3BE3ppzIw3u9jcliW3xJCl/eTomzqNtvf26Rtn8vfu96s1K8q6xexKxoA29XWvVooWPwQuKLD7Ylc5wW9J8coAg4MWfWpwAgdCRClPDx3UEgJ1RYNdM4OcXweWT8wA2y0+NA/cmyb2vEUt4hLc7XHvVQyCfqXSZ4LyZTospR4VuI0M+leDmfYtizZ7v5hu8DZaL1rJrT67rpNp325/8MoPYZtXui/N58kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMpEBqfY4uyZyslMqzk4oeE1GOdhgf0uBnX8WQX+qcI=;
 b=mOgK+/gHO+HDr/NN4e0G55TipdHMBfs6innTw9QGeWuq/n2H//g08RYoTfrXNVKN8HjZRCTdw4bBBBdKJ4vFGE+kSLKbgOmdh6/KzajnqhGTnIEJEsxvVKnomCEfV4npKW6rP9FBXZ8nRLRfLKTJY8RkGDPYSnXvmDZ7QuZ0StE=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4501.namprd10.prod.outlook.com (2603:10b6:510:43::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sat, 22 May
 2021 02:50:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 02:50:51 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-exynos: make a const array static, makes
 object smaller
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17djr1ny6.fsf@ca-mkp.ca.oracle.com>
References: <20210505190104.70112-1-colin.king@canonical.com>
Date:   Fri, 21 May 2021 22:50:48 -0400
In-Reply-To: <20210505190104.70112-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 5 May 2021 20:01:04 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR02CA0025.namprd02.prod.outlook.com (2603:10b6:a02:ee::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Sat, 22 May 2021 02:50:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28f09781-f6c8-446a-b244-08d91ccc68e6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4501A415880613F2AF2FEAA38E289@PH0PR10MB4501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eCmVERBlw61/N1K3+5J0OmlXg3g2gFK2i3UV9WtAnFFxTCDxY16aBXw2R8huaHfV3JTfG6Z5rYBVy9oi80p7kS6/2MidqZeRlEKBTuX8s1VFt/Jb/LHS/kWqy6J+3rkEthMpYZF1yjCLksi5MX05MXWbn5vRcz0qYq5CD/M08RzD05l/zpR0PQ1QRvbTNK1An5/d3ff0Sbj6pAj0ddUZMC+lFvbHFTuJaH6m0szfS9PbEeKwu6V7vOCcBUMqdIZEV9HVnD+Kd/Tk7m1EIUJ8fCFOiEbcymuXytfXZq34/mTN6F/B2AIrt37uCn9bJetii+oUF7VeyKlipZ9ez3/CP+mU/X+2MJXR4YnDJ7nGLxZ34JUPvnc6LozF+wB3HNLxZE/B4wPVU9IKzwOxp57tyNPXRxiAQ93QB1FoNhLJhfhvrDhbTDH7H+tcwdwgFK3HIwSqZmbjsj6P1elH8uhhOiIg5CxGyWyOF2RTb2rBPdCPPcT/mEI9uf6WsJdj97HkLKZOtUJrQQ9w5LYqKTQ6LXdc+d4qZEfF7TbHzpE3iNa7Ur/E7B8Rb0tBb93ZKTWhw4raiPjcuGFBG1Fh4zg+jBuTWEFrYddyEM0YW9wAKRlH/1a6PyYZUVmRNwrDeMDxfj+57rOo+fYCvLF3i5GiIWW1mP8mf19xWwH11dyCpoA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(376002)(39860400002)(136003)(8936002)(8676002)(2906002)(55016002)(6916009)(26005)(54906003)(186003)(66946007)(66476007)(7416002)(66556008)(316002)(7696005)(52116002)(38100700002)(16526019)(38350700002)(36916002)(956004)(86362001)(478600001)(558084003)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SZBiWrsakXoGXvHj6LNJ474mQvthrd9ruw84j+DNtyLx5RHq68tVUlscM9gG?=
 =?us-ascii?Q?yoG4aymYFiE0N+5Yax08Zq0eR0madaXUc7nz39CEvE5pMk6OgzrA9fDNLM+U?=
 =?us-ascii?Q?rrivc8u1yDYtovkT9ivJ56xyfTgupHSgvvnHzxFMTLF8/flz8SbUqCf9CfO3?=
 =?us-ascii?Q?SMje5/qMb8v1X0E7jmfsnGSiifWiXSh1X/GMjMF7vZa52YcXsiCHdoKVQZLb?=
 =?us-ascii?Q?VZthBdcn71oWS3r/hwTAoWCQqcjd63l/nGPsn56VjHjHMyiycFTpeJ23rQpp?=
 =?us-ascii?Q?41dMTLM0evL4PfGyniNjtKQSn6JkZirR0/Kco8pYNG9nSVY9aF8KS2B5wIx+?=
 =?us-ascii?Q?qUrtU4JcQIjd3TRz2jq1d4AUiW9FgBEbczSZ63hvCC3KV2tfa3t8c+/DxhvR?=
 =?us-ascii?Q?7HrkqNMbjLT0ByrqrM7ZgxSloEZzsZJdLxJf40Ptdoh8tbtg30JgmCCbUYP6?=
 =?us-ascii?Q?LAs3ZV1CJ17GuBLIaQZltDGDbp+GQx/Irs6HPjICLKjPWwBgZ7xuKM34KJfl?=
 =?us-ascii?Q?F3DYKS24sRoaEvaSjsvU7/3r2KE3PIAfIEiHBoiiCHoDDntjEUXJVLDA2qGN?=
 =?us-ascii?Q?v29mR98I0Fyu0HfZn/D6QROF4TFnSSmfFv567qTzF0kexa8MCBkB4eT9UAcx?=
 =?us-ascii?Q?b8ose4RDSykJPlztiEEnnaO+TR4aX0LH41Kn93b0ly/rEL85C/HBmRCEzpHD?=
 =?us-ascii?Q?giNX5absRwlTMp6kTIHeWsX9zV+6kVbmJcnTehJgxbnmHTHW0rJybN5EcFnU?=
 =?us-ascii?Q?E64Wy6A411Jk6THMh70KborG5MqX8+q57t/VncP0YHoJH+v/ZUdFMtq/1xqD?=
 =?us-ascii?Q?fBEbw0EoNay9By0i4s1RRrghEJN6hCOYL9nLpTQyPwAEQJy9woSSuQPe6DR7?=
 =?us-ascii?Q?XGgSVLnbTQHTk4YWD2g1J2VbFcaszWruFdQdiiE2dIcCVMrVy3yyroLTMCWn?=
 =?us-ascii?Q?OFwqjsmVMj32cIx2OCaHGiO0sJEsROeC+WJPAjj0j9DqLG+CtsvOPoDBr7Jz?=
 =?us-ascii?Q?/955ii15hN7B4Z5o47bo/6V0NMOp79wQDwnQR2phS904RVCuW8LQzam2+RdJ?=
 =?us-ascii?Q?Qj715ecbMLMWqTXmp1kC3/PejUDyohMBoCY1q92H+B20WgiNc6SEWirM4Bhf?=
 =?us-ascii?Q?Wulm3lGHlOXkA4ZlyOkW7+jDoZMgbAVLxsBsVtNv7jVPhBB2ucMtwCTQYZTF?=
 =?us-ascii?Q?cW5pmtKpXbeCP2xwMfT8SI7aWXmdwedK04LUVti+apFiKlVWyC1WwUehLMVf?=
 =?us-ascii?Q?gG3edEKFcbojC7C8ZfKexhB7OPFEtRbrgkNZQQNh2GNogDtSOcLKhrSDHsXa?=
 =?us-ascii?Q?/0B1uPMqnApMLsM1zVE6qw17?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f09781-f6c8-446a-b244-08d91ccc68e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 02:50:50.9437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AgfteyJWe9dq4PqETQECaxp0rQXU/bi7/RCM901aIczKI2nXyNkO/Z5SD2dDinlZndX+o/LBtiI81q+ayiEHprgh3kR7BPdgKEfCb+MDBYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4501
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220016
X-Proofpoint-GUID: Xc1QG9ClUCU-pgUNtB88y_bi4z-2lNkr
X-Proofpoint-ORIG-GUID: Xc1QG9ClUCU-pgUNtB88y_bi4z-2lNkr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105220015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> Don't populate the const array granularity_tbl on the stack but instead it
> static. Makes the object code smaller by 190 bytes:

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
