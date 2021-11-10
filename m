Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6856BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 13:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 458C1611AD
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 13:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhKJNdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 08:33:39 -0500
Received: from mail-dm6nam08on2080.outbound.protection.outlook.com ([40.107.102.80]:31584
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231210AbhKJNdi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Nov 2021 08:33:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlVwzBPthIDqG9gULFg+qPTT2redtXAJ+RGPLRNx2HK3Jm277CLiIr/fVRKLCb2uiphMyQkOdFl51dekWevBm93jajoh8idFYj/fGbqDuCA0SWaPdcAwZp9fpD6G6B2Z7ui2fu/2g1xuIYdl9+sZySsfMPVE/srAiYfPrNlH3z9ZvVaK9qWA0dFK+pySBJDmz6beBl5AvH13HMfu+x1HJELf1N4yiMO8/hiIm95tnuhpo9PRns5Ft3+CxYEI8LA0eoFLN6hznhHkAWZECuolC4L3FL4Gqz89+BFHjZQUdhz1HNts7QKru3eCUllISuwpZCs5aVBMGG8MsymSrqFmtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jtEZL2lzreN+2gJGnmrVzltC18uixmfAR9bJn13CNJs=;
 b=fzbkW/kKQ1XUOOcUiVz6QvPGKJODYK4RFYGTkqDxRJ0qFErrSPgLVoKwPtDk/a5QDsgn1gCkkLF0xmatZM8rOUo0yjFDdOzo9xxie0wn31BGaiQTMbGOa6EgPqvbqIEOJZ6Q8SGUq7S1sWMjoMmtf+mQwkZV6GL2PGE9tr9/Mv6wgowXYeNH8zFW+gVfzY4qv/pi+OvwIvAtciRf9IjXcKrhRvBOHzzOcGUDyNDgA2PxjvxxkNYFoR7FZdbjIOeIH3rwGefQNHpy1Yc2dNPV/enVbUglAYdNCUBRsBbC4GBcOuwr/y/DRUwpe1OMaLwiEa0zZmhRFmBBr67g+CDPVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtEZL2lzreN+2gJGnmrVzltC18uixmfAR9bJn13CNJs=;
 b=nYJzgfDTySH4AZoB/vNpVv2B6MuP5reMEIoub21adOM1FiZiSIeNKhyi7QrLxa3qNxpqnZg612B9Bby1tnDLM7ig2KWPFEm/BIcAjMKXeHeCPbUU6n24JRmWoNsX4nRcRKR/DdXV/AR0bo8mG4NuQBIYZ/xMEnD+PugcUeoKIGz2rIQcVM2dOonTm4/CraC3AmZCRKKwAbV6zt3beyf4woLqKD3NGlNYtx1YQ+HH9GgiNZ8ZvINcDmIssdJo6pLamUBbriNiY/wDiQRGfFH9G+hiafUxEnGeRUKKTlGf1CFmDmIRhla+kvdtwSReWLt1gZVrM3nviMbNxF0RJXq6wA==
Received: from BN9PR03CA0888.namprd03.prod.outlook.com (2603:10b6:408:13c::23)
 by SN6PR12MB4622.namprd12.prod.outlook.com (2603:10b6:805:e2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Wed, 10 Nov
 2021 13:30:49 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::64) by BN9PR03CA0888.outlook.office365.com
 (2603:10b6:408:13c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend
 Transport; Wed, 10 Nov 2021 13:30:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 13:30:48 +0000
Received: from [172.27.14.192] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 10 Nov
 2021 13:30:46 +0000
Message-ID: <c84b652e-9a8d-b7cf-11ff-cf872a3a6962@nvidia.com>
Date:   Wed, 10 Nov 2021 15:30:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: sorting out the freeze / quiesce mess
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>
References: <20211110091407.GA8396@lst.de>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20211110091407.GA8396@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1130f85-8455-4c31-e023-08d9a44e4ebd
X-MS-TrafficTypeDiagnostic: SN6PR12MB4622:
X-Microsoft-Antispam-PRVS: <SN6PR12MB4622B94F77B22A804F7666DEDE939@SN6PR12MB4622.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vkAZh08E+Yc2zLTq7qW0mI3rcjokrfhFJxxeUmc6hLtVr52OzrWj48hh7Y2jGVJ677GVA5jln5uG0voopxu9eFoVM2HqnaZEmd9bQq/rbqNpc8CmMCSOryDSzL3NsG+aGId602HAVx5I7yx+Wg8wISsK8wVUHvNht9/w+PeosdmxRnCGGLVQGsyMyOwVDIfYzUn7hA+3lHkBcchn9x5FkmiV7v5s4IvfcTI0P240KGX3CI2fCe3Du13PqkbdDuHsmCMEtnPjOqip60dl68ogaccERpic1aX/OWcsCNDOE8hdoMG1PBr4DYKrv/vMXc8EFvwPfwjjPIXIiltiBDJ1HGF5m1thxWioZbx/DX9VmOTrAkZkrLmzdP4f1AQMffNCTWQFAOOXIqT1OcAe4UUA59kuJKbXdtW9JPlQIJFMXJ+IaI7CWF0PfQzn2M0K2lyi7yvL1G8H89fLsVap8uIpgxPz9xZN6pcovG4TjTg0jL42QiYRIJk8dhuqBdjkXkSoUxMOqdaOTdq3u20NGsAFf2em5EAUhw/NMffK5SzvgQ5Kh4toMNBtslsc0T2B0Ymf0KYpxZLy8v9ubHAT73UtG+kKCFh9z6iBDADBLRqh/tpzaCJ91Ey2WJ04eHo8FPIU1RMaw650HppHy5oqt7ktpLat2GqEMgNOLKYce1qCFP/El073i+7cgo1i0sWFB2WULMA1VGpEGdnRIoQIa2AvforQipV52gC4tS4g1vCHXg0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36756003)(2906002)(86362001)(4326008)(31696002)(336012)(2616005)(7636003)(4744005)(54906003)(110136005)(31686004)(356005)(53546011)(26005)(186003)(5660300002)(426003)(16526019)(6666004)(83380400001)(82310400003)(316002)(70586007)(36860700001)(8936002)(8676002)(70206006)(508600001)(47076005)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 13:30:48.3447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1130f85-8455-4c31-e023-08d9a44e4ebd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4622
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 11/10/2021 11:14 AM, Christoph Hellwig wrote:
> Hi Jens and Ming,
>
> I've been looking into properly supporting queue freezing for bio based
> drivers (that is only release q_usage_counter on bio completion for them).
> And the deeper I look into the code the more I'm confused by us having
> the blk_mq_quiesce* interface in addition to blk_freeze_queue.  What
> is a good reason to do a quiesce separately from a freeze?

I think that quiesce_q will guarantee that no new requests will be 
passed to LLD (completions can still arrive from LLD).

And freeze_q will notify that the internal request_q state will not 
change and completions will not arrive from LLD (and if they will, the 
block layer can ignore it).

At least this is what we aim to do in other areas such as Live migration.

