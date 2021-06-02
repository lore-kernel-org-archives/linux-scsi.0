Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F51C4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EAB961001
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhFBDPz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 23:15:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37898 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhFBDPy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 23:15:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15239UF1046596;
        Wed, 2 Jun 2021 03:14:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vVnYzBkKCQ6Ca5QmZJnoPMwpCTt5vF1LsW4XwwXFU2s=;
 b=uE6lYXEaA6AcpTRm/0lD5kLy4LpRC4XQ/5aengbdSmAAng6OeT4fxGr3DgqzcQi5px+/
 Bq+MIEKYBd3OmFy0COsUmulzW72v67MfxXsZZSb6BLB3RvHO9aLMAbdefYlmX7OB0qD2
 3V6BlH/olwtQNakHZ+ZF8Epa445F9MItHqMYBfm0tIlohprataPlQUmMjs2BTeAC+th3
 LaGD6pZl4IoKg1GIcFCCg4JCHVh4DObD+bEwcUKUmPTypBCE9J38t3Pjkok9spwR9Ij1
 +FQoBQFOqn4/aioYBVVx9fUYm/iKVHv6qdpKjYupAnIM6Y9dCz3OVe1xrJzr9BdWqkqz ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38udjmq7ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 03:14:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1523ATTL141349;
        Wed, 2 Jun 2021 03:14:08 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 38ubndp11u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 03:14:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbwL85AudcAaoeKv87xmvUHo/Fef1xIvwJrLN5TxZiXQ+tyihawyOhyS46G2HLBuh0Ts3udmxDw9EbFHvKkiA8N6y2OT5r1L5cd60aws1HBSfofZkMPVH+onQqvZ3VIK7V3Bd5v0t/PDw4TnG/43FxEEo0J7+oUKVqOjjQnc/4pRotByV4quO79s2wmu4fK2ZklWR08Dv20oubEfukU5byzf2Ilf7n0tMFxJM5l2HDp8b/4AJiBHLJEnYCsh2hhTGSi0JQrGafldKCz/9EbOWAkhDCuOyiz8PvZvCBPirrNyJALz62P0g/6y/z1ALshSahX/V40PWAZahbfCFuFB0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVnYzBkKCQ6Ca5QmZJnoPMwpCTt5vF1LsW4XwwXFU2s=;
 b=Pqr3xDpSreyGxpFV3sQuCJG540PkgPZvZhvQ6SxFWZCyRW5vRzISN1zoERTkXnycDKNXVf9RqisH7SYEdizLAI77nkkwAiSw6mZLUi5RfT85vr+KALRMZiidJco8F+xvU/A8ok5zqkPhmcOodVVB0BHrZmKTpRG7M5j/ejJSYuWEahgncxOCUsoeb7O1iEMS6wY5IPYENuP1d273HhGY0sRNsSOzO7/abPT3ejrcQO1G3SOc38eH/mpTjbCU/ADijQSY+h5oyARdjdVN9jxXLRo/H7Fs3Uk+ev7qdRBJCoNMn62/jiZRRfuvVaZHn4remuNleSjH3JUjP5YaeGvk6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVnYzBkKCQ6Ca5QmZJnoPMwpCTt5vF1LsW4XwwXFU2s=;
 b=CVv8YpCRq0mqClmWATjQcetJMvyjnLk4YV+eS3pbnHwZUHKrU1qNazhJ2r2wYEdiRZIjZWKxiYdTtx+5Apl6i6kZT3uBMwAJfgz8YF9wCxNFYyPExXyAF+XnLZt9kcglfckvIQKb6qXrck1orQWi8/yWiqz4H269HbfdNgeL8sY=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4517.namprd10.prod.outlook.com (2603:10b6:510:36::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 03:14:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 03:14:06 +0000
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH] qla2xxx: Log PCI address in
 qla_nvme_unregister_remote_port()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r9lq7pp.fsf@ca-mkp.ca.oracle.com>
References: <20210531122444.116655-1-dwagner@suse.de>
Date:   Tue, 01 Jun 2021 23:14:02 -0400
In-Reply-To: <20210531122444.116655-1-dwagner@suse.de> (Daniel Wagner's
        message of "Mon, 31 May 2021 14:24:44 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0058.namprd04.prod.outlook.com
 (2603:10b6:806:120::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0058.namprd04.prod.outlook.com (2603:10b6:806:120::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 03:14:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38ef4f2a-9228-4469-f32a-08d925747af6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4517:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB451784B55B31D7611395812D8E3D9@PH0PR10MB4517.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D8wHWNAOBS/wr3GN+acWSOaohNXh/lUuJqQtAlVWsPtuKIVrpWUgTcN03ie1pxpv/dsTBeKuMNojE/pIw1wUbogmpP86uSlRZbp0K9oYGP0c8ajEY4f3XwoH1Zb1x3QNQvBTs9j9yY2ye3sjuU9q4zwqBmscKzkQq06CIJmy9C8a8nwUfwvj3KHnCEjDp43C89SpKxPEutMbQK+0udHIvQmlbNKXKjHCj8GHszUOqD15FFbSYpAmOJjIwVOoH8Qpljnoxv8NFmDkOciIZZ4RxOzgALJN2xZZnde4NfnKJajJ97nJXREcZh1Jj5+6TZuA/FBdUAt4fJ00GpNrSVD0oBP8WJdn+FaZ+9Jj8+qW1x44NUL/C4YhrT/Qbe5Dbqu6DJzndER+ok6s/ssNGgyRYgWBEJUscaXfaahZh+LI9J/4tP1lCcy7zSCXRBmRRTAODfA7csOi9O/Y7wLWN5lUpsfvkdbdU7cOBsBBWkx/0m3Q2J37TcWBhGHTUJHBLTD7s1de4Krm9eHfxcdpg7mIaV4tyt+yNIUWiTmsZAOFW6QItF9P55eJaPibNpKZ0xlHC1nY1JiCCh96kW7XCSPJGiNXaLz+t876FAqfch6JGjDkA8GasorRKRSdLUnXEo9iFodCfLhnpLCCv+9VB2p99vw43EX6O904Y/6CsnCO9YY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(39860400002)(346002)(55016002)(558084003)(186003)(86362001)(478600001)(38100700002)(6916009)(956004)(36916002)(16526019)(7696005)(83380400001)(316002)(26005)(8676002)(8936002)(66946007)(6666004)(4326008)(38350700002)(52116002)(2906002)(66476007)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?08CMdFEPRxbxIZaor4kf0t8inFLYfecigV0soXUJOFej9te94mXpj2jzioES?=
 =?us-ascii?Q?+y3Ru2xN2sc0bbfsF8604jctU7jK0DssPUCuLxHQwlnZaP/AjZENIbrx+Msg?=
 =?us-ascii?Q?1rA+I/07H3DTyt5fhUP2cI+/FIw5y2GwYtKT3tkKH8LFg/RTMSFs7FAUXW/0?=
 =?us-ascii?Q?Jo+bgFYIKjZ7Qgy6joNkRh3HEsdC+GJZaLnd6qwtYidG4MFAuAw1dxHqvRcS?=
 =?us-ascii?Q?CXBdSk7uUGCXmDlKe2H9GTfz0Ei8sIk+9f3LCRQBUDoy318dNUgS2ehcgy9/?=
 =?us-ascii?Q?xQkA48Dvzz7WYD6bsLeOHFUDIGcoUaxamv3/26wgbgyxIvM+a9ldyuP8ayPf?=
 =?us-ascii?Q?WniZi7BYfdiOS7fksiHpH5ZriCBXAKX9keYIAxEzGDdNYDvoKX1LyeCmFoeI?=
 =?us-ascii?Q?wHFvhmqQ96DM6cA5weEwC/DdszwgPKQuOrdXHduVLXF1jE44Rb/apqkeKsSW?=
 =?us-ascii?Q?gyboXEdH1130P9p5xjGjHo39Sk5o/0ag2RC+3Ef3na29p+YVX26WHWtrY4z9?=
 =?us-ascii?Q?BVvE5lPdXqMLeMpPzEbQVYiaIyWf07slAncPTGrFR9w1vx4f6LWgufDt9WY8?=
 =?us-ascii?Q?Vw98A+l6YW/NpHuJQx7/vrJ13yIphXHllBPgH9j8f3kY/kAcK4oeb8MGARzU?=
 =?us-ascii?Q?IGg4pcaEk8KgXZ17qaXIQ80p0tTO9emGj+sZBRqvT98zmzkt72U+rbF3geRg?=
 =?us-ascii?Q?nP5USNPhfRDtRiyOPCvej+SF45xEIjXagKnpkry+IxbEMAn0xRHcaSp++A+a?=
 =?us-ascii?Q?+RCdxRcrHeizgnQzRAEhRPs4RMO+4Z1zBJXLMx5Q6EWLb+xzIraIpzfOpqhK?=
 =?us-ascii?Q?EH+pcigZ1iDPdUNs+CkW9zBzjsicdFqT+x3FZ/W1UM9486P/5IhTW9+XNN60?=
 =?us-ascii?Q?85iNhlY3ZsBVMv9kBXdsi/nnL748JX4YjGV//QArkd0KsLcEpqPmgi/6aoB9?=
 =?us-ascii?Q?p57JoLjv9/2VxC5ROVlYgOgxQD6xfDhpXtb26T44GQCbVywFFBKhiPoQ36wW?=
 =?us-ascii?Q?C6rM8idTmuPni2qfo9vIHZXpK0C8jo+vZCNmcAXR+x1n4y+8qBt/6wRobH6C?=
 =?us-ascii?Q?kr4g0bZ8T5VGbzotY/7VQ4gXiERaZab6BxrHO14pvGAb0sg49jsmTyE5doNr?=
 =?us-ascii?Q?nAwnn8X0GTwC8kRwN9zdVY2Z0Y3aAwN3wE4fIhFcW8kZ9XJZot03eZEgR0lz?=
 =?us-ascii?Q?EOtSNPe+RWJKQASqhZSmUvZOeYFFn9PrB86LLXJ3acB0YrAwpzwqOasIZ3vy?=
 =?us-ascii?Q?pGWUv/ZOJxrUJoFjuIi3eAc6d0FPlgIA7F/d6Mdnx3fk+n6c5cnEEdcQl+Pe?=
 =?us-ascii?Q?l0XEHAWm1lH+JlH8VSQPuTCj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38ef4f2a-9228-4469-f32a-08d925747af6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 03:14:06.0010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZC7//fGwiH9Xqe3x+UO2czIp+9fJJxoGGyxKduHb4l3fVnVRCcXXU2IQ7EcOqgYN0ueG4RFRBobGgvcaUVoq/syDj11cNX8fMVkevAEV/ls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4517
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020018
X-Proofpoint-GUID: uH8zsV-tcNLiKeI86wH_W62_P_Kesv5p
X-Proofpoint-ORIG-GUID: uH8zsV-tcNLiKeI86wH_W62_P_Kesv5p
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Daniel,

> Pass in fcport->vha to ql_log() in order to add the PCI address to the
> log.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
