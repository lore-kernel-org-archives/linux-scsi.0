Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD720C25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbiHLB6g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiHLB6f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:58:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F5FA1D68
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:58:33 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN69YN002833;
        Fri, 12 Aug 2022 01:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=B220vdpt2hZTarsTLvvMkFhCSmfaVeZK4uAXZ1dnRe4=;
 b=xtkULtmwjwQfILzLX8R9TUKhmE/6Y38EO1EOmDBkvPo7cSn2EBlsfXYG7O/FTFcMtt0p
 aKxeqi/31V1s0eKgaVosOl+jo9jxAuWuSmBf8vlqvCS721Yj2oo7JEReNiC0M02lNkcv
 jI8OmmPbEEZ4FCE2D4K/88hH2QVK+TEScAYFqcfA4OU4qMrYlpDqSOkRCm0UYjgJlve8
 ag7nMerw/R2pugc5kbQUGGw7GmPpkOzU1JRzKno9w2Qdg04LrpjJEaNeAWiDSJOais0D
 4vv6MOh0mlnfOflx2tiNACzbe6ShccfBpiRBtFNiF+k17BrHJZ1b7Szb4/PLsk231Ul5 LQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqdxaw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:58:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C04oCs023811;
        Fri, 12 Aug 2022 01:58:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqhq157-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:58:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNgHZYMrzFpP73WH/3BafYSXGEvjTnTezKOTTiohwXOqgZae2LnMdo4N8tvustyxU492lA5JGnVrEpciA3NBkGdAeORFBHWtqKVwZuUi5S4ENy85tOBAezKYc4s9KKYCDbsKpER/EtI2nmOP1XAdxqFg8zrIoQZ6+TXtSW+paz3mBwiR8cTfYs1t/unYRRw5mLOxGK/z0POU8Y2HzSsMmloD/sVI/UUsXX7J+2hAUomllpgQCT3lKJxU0eERx3K90QgX464Fb8qvuhsdoON5QWPX1Pht7FCYqHtVuDyycS9KEfJi1fgLB1qTE+Sb1diRM4BSxROV64/at2aAAHDPhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B220vdpt2hZTarsTLvvMkFhCSmfaVeZK4uAXZ1dnRe4=;
 b=EEY10g8ru2TPPlY+UfnQAkzeW3JyOBMnySOFcfSaKRfNtVr0rogzcDp4mMF5EEO5Wj9jWrhgXkv9tdbJP7mbEoY1rPXE8DpDExf7G4b82cP/ULfM2v6c3YPCq7Re/qLQKIGQ16IrMB/CiS4GkIoHSFcKCl2BoD3cCKZitrJRq7n4D7/Z25AOOWOD6pKv0chLf0MNMZFsGi87piTY4NJQM7cL5rpnFvwHNaKPEuqs5F3WGDSUItq1exjeAYNhVDt4Kt5UxWppgfdxzdOIbZiXW9EtHS1uLJR0ipL2qAMB1VqRmjAWhZt1NJJvLDrhj/eKTp57uM4RRn/hD8VvC2cc7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B220vdpt2hZTarsTLvvMkFhCSmfaVeZK4uAXZ1dnRe4=;
 b=VMGXRGMKqkoeXKt/rhK2WaRwqwNAJ9YQpPTqfvEu1RKENkayLazzvvwMKTvuEtpgs5N3zrMMEl1dDhwAaYb61lzMuWFfWO6LTSkCggxemlr3iCwSLRK/yDDRXMSXLGx2rDU40IZ4vftvMOq8ETU//Ufm0woIp/aSzNw8KLUl2CM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM5PR10MB1945.namprd10.prod.outlook.com (2603:10b6:3:114::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Fri, 12 Aug
 2022 01:58:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0%8]) with mapi id 15.20.5525.010; Fri, 12 Aug 2022
 01:58:24 +0000
To:     Tony Battersby <tonyb@cybernetics.com>
Cc:     Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Disable ATIO interrupt coalesce for quad
 port ISP27XX
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k07emdeg.fsf@ca-mkp.ca.oracle.com>
References: <97dcf365-89ff-014d-a3e5-1404c6af511c@cybernetics.com>
Date:   Thu, 11 Aug 2022 21:58:22 -0400
In-Reply-To: <97dcf365-89ff-014d-a3e5-1404c6af511c@cybernetics.com> (Tony
        Battersby's message of "Wed, 20 Jul 2022 09:43:52 -0400")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0123.namprd05.prod.outlook.com
 (2603:10b6:803:42::40) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e58550b-d97f-4395-74f5-08da7c062443
X-MS-TrafficTypeDiagnostic: DM5PR10MB1945:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ReeEufTR/+SEojFvmVU9vhHsZwO5m10wA0pe0m45QqsWmlgldGx7xYDSsONGbXMpmeza3PFEpO8XvAGIde9aFsztgIlTmEpzy4pLR18UkrXqCo0Ow36HOSzJ3QhY7F9NPuRS3mLzZvZUirSrcT5zuzw/YrULPynvERYJeBtwzlYowg7yfj2Q2LEsmtSxOrcJYCDfK9gAA542XYtAt41SByJJWicj5r0PLCKveJsV4nK2QEHGAXcx5zn0PwaSU/x8rWaQY4j7PgtWMwHJ4H5QIv48OOnPon2M78UYdp/gJ4nTY8DKSZicil2m8bxPYubWzAmnAdmq9ffXVO9XagIA8JJmgZWiiiNdMdL1hLU5RJWfeP6UooMv+f6cntBIvtyOSHh7OQj+US44MN5rX7uZPhVMTBsPaXSOrhaAymDG9b+/XnGaYIXw2gR/wZXJjUkRcVqvsFNft5nfInO6ZL558f+CwcGN2bWKuQgDwoN7Llj+NYLZRtQzfruHaoMth8h1HjnrL3QlTOJv5XQr0XgO8YscAgxfh3rjAa97Cl1WWOz1LR9jL2a1v61Ulk5tAtZXnlfft27p7gIzuXdIVvvXOjlXTOZ+wSdhAgTf04G4eq+1vUjBOlPNMDqZwbeSnnz9dQ8AHwqWRZoLkFnqDZUwH0naSoBXr8hQtkEWYJdV7s8im+zif2H1xIFHn+LaVifA+RMINlHZz35I2BJZbB7xkDvPAG1xY6n7v7QYfK95BvURIJ9UJ9E7G7rKttJ4EKQl9k5q6lnhBN++jiMlWBDWnz08ft1eodXT385SNlHitgws9UOHlF44/71hw9vGaKqX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(346002)(366004)(136003)(396003)(38100700002)(38350700002)(186003)(26005)(6486002)(6506007)(41300700001)(52116002)(36916002)(6512007)(478600001)(8676002)(54906003)(86362001)(66476007)(4326008)(6916009)(5660300002)(66556008)(316002)(66946007)(4744005)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f299QbRAmyAIkUwA0nUxaS7HZMnBFGKfaIpKrBG40RD36TVknxIPLdhc9jv8?=
 =?us-ascii?Q?qHLgzA1KMydeBO3Jbyv+VPG1ckxXGJ7zP5iNMx/Q2SXlkscnGuvrRQCR90cG?=
 =?us-ascii?Q?hDggCjrjZeVW29KecuNE9kSFrzueJSXPH90lY9WsbQYUX/tmALU3Awlap4O0?=
 =?us-ascii?Q?QVqvTQfWcT1y++RL+6l84CHkGodrIkGjNnWrbh5Hx4GmNVKEW9LrSl9VYjNx?=
 =?us-ascii?Q?7pP6b9eBAVauJUv1iDAoJu4kvn5AiL+xBBKfbiIvUB4AlEx8fMy3m7qzZH+a?=
 =?us-ascii?Q?K/h211Jc7CYJXzl81Mif8G0zb2MCPyjJfCA7921oBJZJjbKwPK49XRQ+cGQF?=
 =?us-ascii?Q?pnZPGEVjeG97c1BfcgBY4afcpzpsHkj0db1ioc4yRats77856sS/1B1pqQ2y?=
 =?us-ascii?Q?Ud9wh2DYF5FM96i2uV+Cl/jgAgWNPm6q/xIAvdivqD0S9du0izGcWsgKqeSX?=
 =?us-ascii?Q?SXCBSWDGKan5SsAMfd7Q4r+7EM1PgnozMM7BGs3/3Y+lfLvFkgRQgn2TYupW?=
 =?us-ascii?Q?J8ym49b5KCJjZu21AWU2ON1buJgrn+4QNuu3RjpJrGWdWyRN27nF/MFB7Bvu?=
 =?us-ascii?Q?gRy1bD3Of6QCJVw6dU3sD5mrJm/rhe1Zm0JforCo/zwkuA0GaCyg/zIs+M53?=
 =?us-ascii?Q?iDDtVmXhn0XZ0EILQtQ1FYmCR4IFx3ErFE7hH5WYweOVW5eRFsJU+TILY4A4?=
 =?us-ascii?Q?h4DWucGzDHUDLbcJzWrJDrngs4w4gaQvEpHBpb/hXn1frAJrBLBhHT6qF1i0?=
 =?us-ascii?Q?urxdw6LUQtNioTySwJuwThc7s4SXu2A3WEbjhl60q4UWS/CYFNkl8MpYPUne?=
 =?us-ascii?Q?nk7Ayt4qGqr0G3RE4+qdBHhwW04tK31hjK+VZ74YoA4SPkjE92cBdBa8mj9j?=
 =?us-ascii?Q?1CfYX38xmafpUqhYuYW9nMILzZO8D5+5SS+UpKbXJ7G9ChwnKSsKvySzfD12?=
 =?us-ascii?Q?UONux4zZv31f/LFZlNwS4VC9Hzvuiv8koGl8ROhiYIQ+nwgREIMc1J0NB/1O?=
 =?us-ascii?Q?WoQSurfRyU9BNGt6Xu+DTqpkdwE3xYTV0T66Sc4WItt7P4CTjxWhKmopVtD2?=
 =?us-ascii?Q?5cryxAplUDDKAayaqOvYujg3zyZhl4LiGXu8B41/Rz7o0FixdgwPQRuj6LMk?=
 =?us-ascii?Q?ERQ1uskMjOF9AcWZguAL58cIdtguJc8sGRdIeS6CSaCNiQlEBOyXSd7Z+WWq?=
 =?us-ascii?Q?yzsK2ykLaAenF/nItr8+IxKCOF4M/zxEuDE+/DYhW2ymr4qUs6b8TuVzS3o6?=
 =?us-ascii?Q?2hjKeSXgZQyEIuXjNMJA2F+YKVPcjYktsN0I/I9mn5VM9sQfL7QI6orUisEN?=
 =?us-ascii?Q?U1nkynJZ9+xO7UlPxVMq+EUU21uuFkLCHu70KlYdsiiuAEmQfmJoTnaf2eTp?=
 =?us-ascii?Q?ZhX5LlXYu6AEusxcpYfi8HDW1t9wmiTv1Am23Kyx3vMYBQoF2jrUx0VFGo6U?=
 =?us-ascii?Q?0bf3UjVDq1rq+3U0bYXyqTxrolnn5Du8GIySl15UJnwsi0gXY9PQwwN3HZ3D?=
 =?us-ascii?Q?MIRyH5DQIC2tS4Si5S18314rMPBozzT08gGs0pIg67OFIQUWcEDEFjksDLOC?=
 =?us-ascii?Q?4oESun7dGtUBkOv3XBwrAjzFyL8UaPzEBj5/jM5BJYFt3caS4quYkCJDWAnh?=
 =?us-ascii?Q?CA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e58550b-d97f-4395-74f5-08da7c062443
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:58:24.8582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wtsRcbuKKtsJDkFV345AGCeTBKghFKwL+IJxYWHfWcFR0DkoeZ0l4vnbFsEt3x18kPd8DYcG2PVvk95QH9jhmNnKUWGcVQnj+4nFemAzdtM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1945
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_01,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=798 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120004
X-Proofpoint-GUID: 2KUGWhipO54-bH16IDaYyK0mDNvDEvnZ
X-Proofpoint-ORIG-GUID: 2KUGWhipO54-bH16IDaYyK0mDNvDEvnZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tony,

> This partially reverts commit d2b292c3f6fdef5819a276acd64915bae6384a7f.
>
> For some workloads where the host sends a batch of commands and then
> pauses, ATIO interrupt coalesce can cause some incoming ATIO entries
> to be ignored for extended periods of time, resulting in slow
> performance, timeouts, and aborted commands.  So disable interrupt
> coalesce and re-enable the dedicated ATIO MSI-X interrupt.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
