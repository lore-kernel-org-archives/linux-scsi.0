Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6173FC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 04:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2331D613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 04:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhDME1F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 00:27:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55224 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhDME1E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 00:27:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D4DotI128568;
        Tue, 13 Apr 2021 04:26:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=hvaeVG/z/XZmAZq8V/q/FNS/tMFSYpc2XmsgpnouV98=;
 b=u3ToUwwqrTMa6RrWDj+fbnlEVXIUSOIwucXyHyI8Zu9pH5lREaVmqVPSc8/C2Q5hlrg1
 z3MxllRRtR8PCJofEGh4drNv8r3ielEzVIkT4AV3kW4yWjuPeV0IrWWLWB8oW3QG2k0S
 T3L+mxPnfeWi+R+Q2K5dgON0j/kavqQTqo/dWiG7G6BbAiXWTUxNlxEj10lCQXcdHU6j
 uhxyMQYnE7ZRAqVKKnN6qmB8etIvnPS9wIfhLoRqAb+7imsEhA5TzSb4jtv5zsJ8712R
 TbnncgLoJ6KbgNRx2LI/NpUK85KCZ2sYL+qMhz6ush7o0hZKL/83TDLOlLkcqI7bk2or Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3erdr60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 04:26:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D4GRFb099681;
        Tue, 13 Apr 2021 04:26:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3030.oracle.com with ESMTP id 37unkp1whr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 04:26:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnPP6y0TNtvANf/wUW8srnBTPHMyytcRraMZEwOuJDAv1Wya+gDO6NFXU3H/20H5DBAxxAXNGdKnz2v3fpoZhImIPFPAEZK0sGkXnd0uiBwA1yGp+oVjrXrWcTu3bqCYKD92j8+t8cPb765KjMjxAe3AnGPkuApc94RIZdbj6eoAq9VFPyVHeZY/Ku6XSRX/POzP+TcXZoYyNVvZgweG21715kLjgs0BLVgggf85lc3PAXbQnXsAzmefxcuBhL+XY3rCc5QpNektBZLMFVa7mS8rTdyKgXT7b4S4uc096UhzpZxcz6MZJB/41ouwH1PtDDpal16bepxJHXHhyeshGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvaeVG/z/XZmAZq8V/q/FNS/tMFSYpc2XmsgpnouV98=;
 b=abq+mk9tQkKc2f1Q2WyODxr/Rb7ogtK7VZ5LnLTBuBBUA+qLXeQ/nt/MT48HOaeNr4fjkhHZR9mnY11VMXCETFnNOxFWP/G3u5NqmZiJE8SYYyEOA3bwOnQEritsrJOoycsatZMUus7tc+nNIK08BHtQhVbuyfcVvsDDa0fC6Vt4d5o67CoDtx+8pHZJVwTWZUX0XV3lCaX8P8IsbU57FTt4l/5fkWlVh5CEJzGaRuTOcvfVYXgDO4GxSqoaCY3qrohDgwijOxl66vW3cQx2q37cS/1VI8Td6MjtGWwSp7XvnWo37U9UbAtsIPtXCFiYiqo9JetOAMKGfOf7TGi0yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvaeVG/z/XZmAZq8V/q/FNS/tMFSYpc2XmsgpnouV98=;
 b=ILiF7AC//rTdkxT0ed/yDCBl8cfc6usOyyQ0WyMMqFYDmsQfyNJLVqwQIyjJz32GSvh6uuqPgSfx7WGMA61HHelEeXj+V7520Z68OKsYnJl+Bx/+ZnERwCE7kXdJTe1Ub1R1qrK1eqznBsTPZJgCRu3x3nyOFqWjMl/VcYEDLCk=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4648.namprd10.prod.outlook.com (2603:10b6:510:30::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Tue, 13 Apr
 2021 04:26:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 04:26:41 +0000
To:     Javed Hasan <jhasan@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 0/2] Enable devlink support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg3u7qtn.fsf@ca-mkp.ca.oracle.com>
References: <20210331164917.24662-1-jhasan@marvell.com>
Date:   Tue, 13 Apr 2021 00:26:38 -0400
In-Reply-To: <20210331164917.24662-1-jhasan@marvell.com> (Javed Hasan's
        message of "Wed, 31 Mar 2021 09:49:15 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0213.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0213.namprd03.prod.outlook.com (2603:10b6:a03:39f::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 04:26:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15fa663e-d7fd-4f56-a601-08d8fe34561d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4648:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4648439C7759BAAF83FA1C1B8E4F9@PH0PR10MB4648.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JLvKw3mcL3HlRuQuNLNnkdbP1n4skUVT6YckcZGGB1bf0h+I2FZbMH+D0tXNXWNr7de5rkYSFN3UkzT3dhJOdc606KTHXjMU2aeQbChIWzUkb1n2sSa5hH/ir9sWDR9EcPjJn9qc/XUPQAfiwaiFxRSGO+MrZNGsWrl+5djyEeywisukMjpfYhz9KS28VdrXxelJJez9tanPT5XSXO+A3LTi9HTS5Bwfc4olNr94YJwO/LbgVmx2Y8n0ZBFmTcybaG4ZJre1aTyb+slQK5y4WmJPmlOuiCywI4Q7R27GilA38uvYwicQ/WsxHFQ0afvY+9YQqlyaerQIiiRvnu3cuamTo4SbYQqo8IKzo/A/sz4cGCN5GxsxMnDBgBfRUYuV5ZY4aIWg+nFQscMcZrpD0iqYWMhYGh99rxER+eyhXZpJLk30rkEEpzWMcgyabt+DxbrSHlR/a7KmUZ6E9BTl25Osd5r+f1ILjCvX6YZKxx+4djatvbiTHrPkX1F8kYXRB8+v3wagUSamuaUeVrt0Lj+y7dRTEkbS3Zmu+sDJ7LtLjLH5DqBUzfZwOgpb99L4EzbsaMdAsgOHS8KAv2w+2cpPKOWPZQ1uPNkRldr0acnAI/+ZNxwEitCSvpb8cU9yAqrOCvg9JQqKgsK/NrJU+w9Qr8MW3YW9yqn0B7HD8qQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(366004)(346002)(396003)(5660300002)(8676002)(55016002)(186003)(956004)(4326008)(66946007)(7696005)(2906002)(38350700002)(66476007)(52116002)(558084003)(8936002)(66556008)(16526019)(54906003)(478600001)(36916002)(6916009)(316002)(86362001)(26005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?n02xUFOekTBO/BP5Z0UCIwpDhxu02JNusNL2WsokAdQaGn6gjwgRkdoB67bN?=
 =?us-ascii?Q?u9Kv+dbUqwV6S1gVHuOr+PKJU9CbiE7hApXTFKaqlZuqLfGXBJ4giOc+uGHG?=
 =?us-ascii?Q?ThbYYsw4kg9mnFWWgwgfp6w4vObrsb+gWeRUEnZYNcZHZsTWKKtyFNPMyXwu?=
 =?us-ascii?Q?H+2aFtNVLstrKDb0+JVTPFrNM1PYyxLlnhEi+RZ6enuhJ9bD90ggTblpji58?=
 =?us-ascii?Q?MuvpkR+ceGo4H6ZD/9GXVvHe0AZ2HQSLEmZf1hNP5AeXZ9nEfSc3yYajJBdx?=
 =?us-ascii?Q?ksA5LWdggD82NgEYKXdHDKUe1BLzPJaab0iwF2XT75ObFg0rWDq/keEhKbA9?=
 =?us-ascii?Q?3DqqrE5OK5n50IMHkb51elgZBKwKHWhSJnHF8HL7+ARd19FbZ7FzAPcH9PWc?=
 =?us-ascii?Q?TRRI6c9fBvP2vwtvZEyKbyLv3feybm3AbuRfg/pnzYCl/qumsHVuWqePKntx?=
 =?us-ascii?Q?utG9EbWoYFs/pkrwZrWFeAamQxLF3TWfVDnkJ/xPR0WGRSC/LkzNnuMCrP05?=
 =?us-ascii?Q?LpxInKsXOL4jxRoYEjI6fQeTBomy1nYAH5fFjW3lJYZLeBwH+tFKtbWSIFVi?=
 =?us-ascii?Q?rgN0oguiK1Nd4RJWzMaBMdttiNLnqvGob2aix+vEPDytBNckqzkV2mRgc/lL?=
 =?us-ascii?Q?/8H9H2plJ/e9tG/VWyUHnFXJyyBIyh746Vtw0j4HLRtQTMsi1RaxSjS8Q7HF?=
 =?us-ascii?Q?IWe4+PiH5yfJRPN06sFYNa8TAEZat+2BhK4Ald+hBDcOCyxIRaVnsp6yWwrz?=
 =?us-ascii?Q?MCFVL7jWl2a9ecsAzxom+zxdJPVIFAwOeRblL+WeZ0jR7uZTl1PyOSnZiQu2?=
 =?us-ascii?Q?8GgyWgCLoCnI0qhB0kiNiIcPX8iP9FvElVaE/gvbxx051QRIbRBgn2XGkurB?=
 =?us-ascii?Q?SfvFlNI81Tz20xcA/WRwWzjp5iiozmT13h7RPsy2hViTtIxekeiOAdYeT5yR?=
 =?us-ascii?Q?HQsK7Bo0UqMcWEsClVyD39+OVy5TYJlIIZzi/oY1m3L/FOZseDL3BbU6x8rV?=
 =?us-ascii?Q?rmKI9mB757oLWwRkocwDrwFgffpOnzjhL1dHSk6vJlBOA257jpcpEdXftOpO?=
 =?us-ascii?Q?5OZHfHgh+4lUohly1AD2YVntD513+kSUIMJSz9R4Ngmc77jpRXnAXHDPrQVk?=
 =?us-ascii?Q?yHKYXJICKEd17QnZHOvKiJfLPm2E3J+O4G4OIxsTQIkwgQ9QEXJ3Xx0rHA+X?=
 =?us-ascii?Q?2E67R1N/7WZXnIIVjSg4Lnn9h2jVh4E9rZJ/slYLRaFQ/aTX6EPOYAwgXkv6?=
 =?us-ascii?Q?SqNsca3GBKzslJk4Wl32OpqL79RkbYOHyr4Li0uJHGwKfFbdbWf5hrJCDeJo?=
 =?us-ascii?Q?u1jvCMeI9pROaieUxg27YXyJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15fa663e-d7fd-4f56-a601-08d8fe34561d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 04:26:41.0638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAZ41DsF0NEBZVVP+X5bzmMHzm3pHQlHkjAgl21276M6Wg7DoBX+nbsxtDTSuidw2Ll5LSFgQk2Lr89LE/S+HCihdDfQksRss1Cg6zPPY4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4648
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130027
X-Proofpoint-ORIG-GUID: jZdh0Tw09zRauglDG7s6IQuSmJCHjxW7
X-Proofpoint-GUID: jZdh0Tw09zRauglDG7s6IQuSmJCHjxW7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Javed,

> Devlink instance lifecycle was linked to qed_dev object, that caused
> devlink to be recreated on each recovery.  Use devlink_health_report
> to push error indications.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
