Return-Path: <SRS0=JQ6K=7B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF6EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 20:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1190207E8
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 20:12:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nvidia.com header.i=@nvidia.com header.b="dCVmoykd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgESUMM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 16:12:12 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8004 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgESUMM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 16:12:12 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec43d900000>; Tue, 19 May 2020 13:12:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 19 May 2020 13:12:12 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 19 May 2020 13:12:12 -0700
Received: from [10.2.90.179] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 May
 2020 20:12:12 +0000
Subject: Re: [PATCH] scsi: st: convert convert get_user_pages() -->
 pin_user_pages()
To:     LKML <linux-kernel@vger.kernel.org>
CC:     =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <20200519045525.2446851-1-jhubbard@nvidia.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <7440e420-009b-20cc-e1e6-7e2a212f65fa@nvidia.com>
Date:   Tue, 19 May 2020 13:12:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519045525.2446851-1-jhubbard@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589919120; bh=h4cufiww8/w8HkD/l4w692Ys6fjo7TCvsNPHCpacNHI=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=dCVmoykdYEnMO/LJ4vZPj/vPDQ4DQTIkm8c8f7q9TgapeB1ly3TqfXiI2PdmWPdXG
         r+eSaXqSLlaX/O+dHMYBK3yDuxZRb6lAS30wyI5HPfNIBkI7FU4DrH5QooJGmExPgL
         RYS81XBSdciLDqJeg/MXIRrg8HEdbM+0FnFHzW24+sahiMy97WwAsY6OtnSyfPIy32
         jD31T73s0zpQ33lR1vst0NDmybjgRPUu3nOXGi2JIJN2FLnjD4CDnvjlBxOWyBZ++T
         6sLApM7R8geu3Nh+gOTnqu9Z/bwR126u8jWCLba2u6cERO4bVPLQ4qo8nSzpZgwpXp
         7MpHhj+lTX6bQ==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-18 21:55, John Hubbard wrote:
> This code was using get_user_pages*(), in a "Case 2" scenario
> (DMA/RDMA), using the categorization from [1]. That means that it's
> time to convert the get_user_pages*() + put_page() calls to
> pin_user_pages*() + unpin_user_pages() calls.
> 

Looks like I accidentally doubled a word on the subject line:
"convert convert".

I'd appreciate it a maintainer could remove one of those for
me, while applying the patch, assuming that we don't need a
v2 for other reasons.


thanks,
-- 
John Hubbard
NVIDIA
