Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0A0C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9564F611CE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhEXIri (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 04:47:38 -0400
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:65249
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232471AbhEXIri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 04:47:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Czf4XKfW5jRn+x8cg/4LQ6rraEeavj5UHxzEirwzM/mK49Uowl7aHfpx2UG3SjCTEgQFqAiznVBIpdPvBhbsJJU9GMuqLWlKOo2KeLhpCsBsAjU5EpIN8ZPHpKKkXgDDOaXt4E60rCW04a88wI9NYBqBH3hkk9IiGTjfi9M3JjH2UNLMHMiPO9TKVMEAm4ZiJi/TkJASyjJGTqmHgI629mumCyIx85scG4h2hFoTy2UD77QBlNrMp9naj2hnIkcibkdrixUk0mD2bmXj8J6tzKAX//6nyj/gVsnIRqn+YdK2HwdCl9+JJVbsZXsQg5IcIQ+yqbU+GhYi2465yT/2zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeVM+0nugZkkR9PiwP69ivGT8swxfrI40WenT4ez8fk=;
 b=kqX1Tm90O1nHSFQ7oCF67RocE32fvx6CqtUpKTwK4CnskZEN3TDzUp+KVkiPTx7dcyQ+sCVSP18ZtZDGLLaGQ2jUrCwMIlMrZs6P0UYjK3HdP1hg7trt/6snm0MaqAkM/bX74ySvICf9aifRKru635D+k6sih6t39BZzBuH3pGa8Yg4QbcjzdlXx6/96Gp5kulCgLT5BZij1KzGS6ozB3ac8yAGhZqsWfgXiBIocWeSgZ1qmwhVqslJiCndXYEzC7/5tUCuV4tP/a99X2q9yxSDq2XhK4U3wqRLN/9k9+5Yu/TaDwcdCIfRvMtyEwk1r4hBBuMPp+dqhV1RguVP7+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lst.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeVM+0nugZkkR9PiwP69ivGT8swxfrI40WenT4ez8fk=;
 b=t5LKVMjYeOtcd0uzP+7fOyh/r5ASDACc3IR59fPUpBFJc3ncBULB3aaDkAT0CB5DLr8jFS4XfjLXxLHj8ulnNWY9DSRajRvMkosqS8pDKfNsil1qaE804ZQNrSBLWLhX5XLif9dy3nsKgSruuMACgP5l0ZCWKYhcTCitMtQrhZpQ/Q81JPuy9HBhhvXJYAVBETtlvMCm5TWu399eMySHIQyKebYW3UoeKXP4FZn9Vedb4cS/vXUd4mtFpvYgFhCrALWHV4636SkRW4O3m5yyaP773kiHjQnh7RRB+unCtsWeoIrkx+WZ24uRZ6sDiU98s51mhssOFoLgdjVYwL0byQ==
Received: from DM5PR15CA0052.namprd15.prod.outlook.com (2603:10b6:3:ae::14) by
 DM6PR12MB2939.namprd12.prod.outlook.com (2603:10b6:5:18b::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.25; Mon, 24 May 2021 08:46:08 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ae:cafe::66) by DM5PR15CA0052.outlook.office365.com
 (2603:10b6:3:ae::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Mon, 24 May 2021 08:46:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 24 May 2021 08:46:08 +0000
Received: from [172.27.15.6] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 May
 2021 08:46:04 +0000
Subject: Re: [PATCH v3 08/51] RDMA/iser: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>, <linux-scsi@vger.kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
References: <20210524030856.2824-1-bvanassche@acm.org>
 <20210524030856.2824-9-bvanassche@acm.org>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <e5afcba3-747b-236d-487b-fb221c21d75f@nvidia.com>
Date:   Mon, 24 May 2021 11:46:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210524030856.2824-9-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1ddc0b9-546a-43ec-ff18-08d91e905feb
X-MS-TrafficTypeDiagnostic: DM6PR12MB2939:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2939FF60733CC9291EB8521EDE269@DM6PR12MB2939.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QA/ZmadIaRjMHYni6hz/Xr+W0M4u6e5NDYbXYfLctW94JxgC1M4JziFxq1ouVTaSarEsHr9/+S4FE/p5/PnGx683ytcYnp+YSWdQ8qWnA3fnwSp2khERXDWCsvDN7Q7Hn1c5rW6TRbTnbAN2YpRRuWQGQp4xkYlzasbwhE5QydJ3ezJvTZYAtOksRR8Rq/P8sOElZEC2nruCsO5KXjl+LmdwwRC79U3wkVQ95ii2042/sdu5Zb8IN5lYzf26NHAwEtkThvy1XvX0wtGXeYjcMZQK/SX+sKGrF/4ZWm0yuyTanFlqo0RCFn7axOYBtwL7tydNhq5iyb2W3NK2b+Vw7v6RYmYEjfR2F24ofb1kWvOUAvsUuu++G2sVp+B+HGX9vdzX9gyBuKmemt/5sHnLxe3N2hJyqLY+MojfuZdxJUriCY77Y9lDkfUIIB00QKT4RocFShy9pDIlopDfu/Od/khPBKM2+H0gqhsKGFgDVvoUtN36PxAWEO+k0Ll5I58cTjZfc0I7U9JZS3qNOSib1H5DpCe6iRXXw3dvbA+OCrFaY01wL1pgyEkEUjdb9ROPz+auH2FAmlWtAJC4Zz+jEAGrPd307xipicsPIH51bsw3J2FFfG75tQ3PcKrySzz6mgvgVx/rP0+7zeU2C+/eVQLfTpQBwuva9f15dm+Iz+yA9VofpZ4ebNpne7IApELP
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(36840700001)(46966006)(47076005)(54906003)(8936002)(16526019)(36906005)(82310400003)(8676002)(16576012)(82740400003)(4326008)(110136005)(478600001)(186003)(316002)(83380400001)(70206006)(36756003)(31696002)(356005)(26005)(53546011)(2906002)(36860700001)(7636003)(5660300002)(70586007)(426003)(336012)(86362001)(2616005)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 08:46:08.1872
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ddc0b9-546a-43ec-ff18-08d91e905feb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2939
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 5/24/2021 6:08 AM, Bart Van Assche wrote:
> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
> instead. This patch does not change any functionality.
>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/infiniband/ulp/iser/iser_memory.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
> index afec40da9b58..9776b755d848 100644
> --- a/drivers/infiniband/ulp/iser/iser_memory.c
> +++ b/drivers/infiniband/ulp/iser/iser_memory.c
> @@ -159,7 +159,7 @@ iser_set_dif_domain(struct scsi_cmnd *sc, struct ib_sig_domain *domain)
>   {
>   	domain->sig_type = IB_SIG_TYPE_T10_DIF;
>   	domain->sig.dif.pi_interval = scsi_prot_interval(sc);
> -	domain->sig.dif.ref_tag = t10_pi_ref_tag(sc->request);
> +	domain->sig.dif.ref_tag = t10_pi_ref_tag(scsi_cmd_to_rq(sc));
>   	/*
>   	 * At the moment we hard code those, but in the future
>   	 * we will take them from sc.

Looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>

