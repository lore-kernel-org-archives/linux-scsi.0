Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2754C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 02:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2EB661289
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 02:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhD0CzQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 22:55:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51136 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbhD0CzO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 22:55:14 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R2sQE7114760;
        Tue, 27 Apr 2021 02:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=v2djfT00+wZTk76aEJ6mLIt9ruPJ8adwKrnWLn98ThU=;
 b=xJA1iwEFkEFNn2A6I6zu5i5atQNDZzQxaG+6Ue95hLeDtgxkgfwCX6xoGsLobBuAC8Zj
 v9d3lEoe/M9cDuf7KA/Z+LdC+A9WLIjQHEIBdn4SBXpmG9y89n6IdqgUfT2eUGly2R8Z
 QOc4oxGHqLoRL+SgcYE4hqhpn9SF814Ip4A1PvyxT5WbERLG5E//J1c78IyvHlDmbGyR
 pZLDiManRVzxMFiIhz+Exg0BdITh1CMKviGn865aI4cQ/uVx0ldYEZpPgGIqeXYJuRBv
 Mqs1xnPHHUquWpFz/Pvk03cOWbqyr40nFDz7QclX3KV0vfINySoIuPYB3BkPsXWaqIuM bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 385afpv02q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 02:54:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13R2oR75115251;
        Tue, 27 Apr 2021 02:54:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3849ce2p1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 02:54:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ge1n9swTkBzUnwZHJTPOHyUpPqX4i9LgezisdhLqNxvMD7NjI6d4odmeNgIVu39GLkaM9yRFGVCUjh9CTOJpP8ICCUA554oKbAeCR+huCqYvt5UHjmtQCnAt1BuLZXNBbsEM/Jcj/ZkoCrv2WMnuLlYmORP45K+7APB/r90rFQ4x1wmBPWxAuzGZ7tgWj+wDT1PRm2IYhnXucvpJWB428QnRboV1irSx7LdW4GKlFN4n94veM/NPNUlZgG0kwiK9mpYZqJY08TOh1g9ep0MxphmKYTmcnZ8vgQ9GII2WJqqIc8W7paPJzQdHF1AdhfkWVSVn43oV6YpvKTium1UaKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2djfT00+wZTk76aEJ6mLIt9ruPJ8adwKrnWLn98ThU=;
 b=dlElsgeEW1j5WAeuNvNesEz2M3lfoYC/yWckzhTWMSl87F12q8PbQ70Prvc4lnSMsIMo9t4br09mAG6ZO8xxrnuqQp+7ycXBZ2ZAEboRX0wl4qOXnCMXRELm7q2DY/susdTZehyrNYiN0TWbEBUViyj8WbR+AYrBONqfnRKAp+Uj/WB8xh+sbOkFuF6xyNy5j0ZOXvSPRqus+xGcqAwsFvnrVmaMDI5nO88+s2dLrbm7UB0777SCoOofdHXkG4qIDHFgjeki/QVN98BoT/iOjlnHkfNZgRnoSIOkkG8HeA2QADbt14vpSieA5MeVk6+SFW0tGP8qeeFhSc4Wiz0w/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2djfT00+wZTk76aEJ6mLIt9ruPJ8adwKrnWLn98ThU=;
 b=Lxt5tJv53v70RaTZV9xI9Td3okG6/WJsqVMWa6KI7Z49jMLzUo6cLeGVbmJLimSzpbYT65E50V9U1yqnk+VHFojgs30ja7pm3DA6kGprlD6Ay5kbQL9QJfDs1Iez4Jy9G2GDgHdljLOvB6sRU2cWmqvEiWI/ut4Oxh/otBfLVho=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Tue, 27 Apr
 2021 02:54:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 02:54:25 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_mbox: remove redundant initialization of
 pointer mbox
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dkoo2so.fsf@ca-mkp.ca.oracle.com>
References: <20210420104919.376734-1-colin.king@canonical.com>
Date:   Mon, 26 Apr 2021 22:54:22 -0400
In-Reply-To: <20210420104919.376734-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 20 Apr 2021 11:49:19 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0190.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0190.namprd11.prod.outlook.com (2603:10b6:806:1bc::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Tue, 27 Apr 2021 02:54:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fc38d87-7e68-4830-f564-08d90927c45b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4439E6DADB4F9208F030C7028E419@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XcqSlyptkqfKF10EVuX5xuUeVBs+q+aFgg3BMuyKF6cQN8qMMVXujWRGZJNgucPMoODWy+t40VUFckHiugB0lpC5m74y3t8m3Hhy5JxuU+L98Qkyo2yLgYS3byi2QWOGMiqrjZ6ImcLqyjtwvyWqC1SH/7aFg7XkSTMggk9PACoJy7p0So0dV0NnARiuSTQJX8CQR6+n2ecl/qOpVqPp6IaCplEQHfe3QJccveEIXRKeIFAogngNI79OqkTc0FWswRTfbwE0rFToeI57DiQhbG8qr/MHIgmCqAEJIKUu57vnJOGWpsLKE64Ei8faVg5VUz3xpMIHuCPg+SygCSR5WpbKSxLsYn1B1rfyAsfSltlrjkmhYwXSunnHKW2l2Jt4V/wGEUBHjJa1UoNAwV0vVMlCb636UQEvkNyN6bFjmzzHEHnMbODxkoto3dVVX8/3gvnvioHUgtgNN61PnqJawqG7dzm4RW6C27OwNIcyF6grF7MjAt304hy3Jl2V6VfdMe+HvX4f9nQZ7nAvOAZ+gcdxjPpa0yiYHVxc7u29q+Ysgf4fLn7andEni5AMXc5vfTaFV6JSUawOoIXQNodFXLrXnqOGT3Zh/c0uJxgtCQGtWqL7bCAVbavs4W2JeMZItg1f98R7rT/xlNzQen9VSOl+++zEpRNn8y7rO9wwwds=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(2906002)(8936002)(4326008)(8676002)(86362001)(66476007)(36916002)(956004)(5660300002)(6916009)(66556008)(186003)(16526019)(38100700002)(316002)(38350700002)(66946007)(26005)(55016002)(7696005)(478600001)(52116002)(54906003)(558084003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bo/bIsosIlo3iQFuSP4ELfPmUnoGFhqSe3/0eTXcgIJL/FC+mZcQkolsBSQg?=
 =?us-ascii?Q?GDdH+PocpoNAURLIWBSBaVrqjbmIHOai4gXvMnj6ge8niT+VcRm11YkEDSrh?=
 =?us-ascii?Q?0bGJ5fmOn52TzkPmskW/gCLbTGePDRTfA82glpNdnUxpcnDxj3Rxjqoy4vu5?=
 =?us-ascii?Q?E1AcTqRuZ1JXAmdIp9wMBisZF2b7T3t3goYq5t795908P8q6McczTw1NnU1e?=
 =?us-ascii?Q?TziSzu7wfmomdH/7NZdTkj8zVJHjjeEqySAVJE/ySpzYXUTSxperNcGKDrNO?=
 =?us-ascii?Q?1sNJGR3Nm2zhYXQoMq0RnrNy1YTMVEWiFoK9CGOW/9taVP4t+/9K8X+8njFZ?=
 =?us-ascii?Q?imwWnOpP2126lz8ZttcfoqvV91rIQrEGAFZGLcjLSc4Cpt103NA6BJTjOfZq?=
 =?us-ascii?Q?ziKtNLSwoFKF06CV3CIGjsTUAnXAL5CsqYJe3Xb+HJNIVGlvdr3p6/hwqxav?=
 =?us-ascii?Q?JLtg6Q43ZL2N5+xhbowIHFSTca0dAqVCcfe8yVqAQwUFPI1/L2k0cUhso3Qn?=
 =?us-ascii?Q?GlK8zEcgYweyOzoj1Jmsab+qrvLGn9IKwZkdUCsNJLk2ZOc3lSQSeLYqMh7d?=
 =?us-ascii?Q?iAvGxxMHR3HM58M6lVD4NXyusE74D3WRoxy5tO9alVa+ULTZiRwCVqVCrlBy?=
 =?us-ascii?Q?TaIhfTeHzIegOdouX+xOSw09I6XzyhCqzuvah/mceVktpeoNESrdDk3g4qji?=
 =?us-ascii?Q?smCwsSNY0KB7BE+rQEKNJ4EJMy6mr0R8oBcrK3ideOOVJCGaKQqqVeHcQ7Z3?=
 =?us-ascii?Q?muP7fpV6GVGxexP0HsNTIc4neY+yJKBqz5GzOKQmUyzBJ8PYXz0u9uG/RMn1?=
 =?us-ascii?Q?QMMqgpOHdX5O2ho6jUurZdckQKtHrYMpz5U7I1LldaOKNAT3KBe8m030DnF4?=
 =?us-ascii?Q?kdoTdsHGdIOSwWbPvZttu2ntvNuQnfyJZYOcY6wdO30tpq3dSsbewNtse65K?=
 =?us-ascii?Q?gBcH/4b3hGKSkoWlG7CEnmtpOrpl5MA55YzEpORSQ3b4dvaYzNhOTKcuOD3j?=
 =?us-ascii?Q?i5vN2ZRVEiVFN2iC2/9zltjpnVUiQ5eF9ex9Ze9jwbr5t8WCFT2Zr7sS2rLZ?=
 =?us-ascii?Q?k1kSzFTTYOTyWrm6JvluCJulbC5JsWdL2upUG78fxC5LISKRE3uVurR35JSm?=
 =?us-ascii?Q?BIWHFbGC311Yw1wy9nDgMI630Cifg3ga418pv0rO9QK7m1OWsn4Yg3CXm4Ml?=
 =?us-ascii?Q?h+z4+OV0cpzBXI+kyCaZnGIuTe/cHVOkwj7moXwf2FlB9Xmr5tU6sTTfM/BB?=
 =?us-ascii?Q?fkOBqXBAEGK1xfAnJfED2wZolJUTFrTpHiUIRRm8/X07VeU/A9nMRO4czk1s?=
 =?us-ascii?Q?D4bPmmpEILuEROZ/UKkU5DKN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc38d87-7e68-4830-f564-08d90927c45b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 02:54:25.3595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lxlTbuFGGdNHe+YbpCRx/2Ta/Y6Zo9Jnk+7f0PCOmkBk+roZh8lvxvYoEseX3lj/UsS/bazDCrXgIqWjJaPl9dcVahhdKFrY6jQWpC2hrfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270018
X-Proofpoint-ORIG-GUID: QRq2HTMirWgx1mzPxiE5-CoMuhCfWdV5
X-Proofpoint-GUID: QRq2HTMirWgx1mzPxiE5-CoMuhCfWdV5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1011 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The pointer mbox is being initialized with a value that is never read
> and it is being updated later with a new value.  The initialization is
> redundant and can be removed.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
