Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76660C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 21:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33B5B61A1F
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 21:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbhCXVva (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 17:51:30 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39996 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234578AbhCXVvV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 17:51:21 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 657544131F;
        Wed, 24 Mar 2021 21:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1616622679;
         x=1618437080; bh=1xLhmrlm56CGNHui4+V1hNsy6UNkhH1NglMLyFHn0bs=; b=
        DHnMYUfNCDXdRUC4HWiIXwjH5YXPw6kcy8BdrIIeUCfV73IPhRUXPEuWjhEfHghM
        7pz/9puhVqY45Vk5lcuH9tfkTjOD3uJfIDLqqZBc6mO5pmf7UWDXPybwosWo2zks
        KOtEvfXoHjA5EHEG9Ye++iSJJd0gsIiehUnMRaOJPK0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id O0koYXOT_QBH; Thu, 25 Mar 2021 00:51:19 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 16772412ED;
        Thu, 25 Mar 2021 00:51:17 +0300 (MSK)
Received: from yadro.com (10.199.0.74) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 25
 Mar 2021 00:51:17 +0300
Date:   Thu, 25 Mar 2021 00:51:16 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2 1/7] target: core: add common tpg/enable attribute
Message-ID: <YFu0VFEJjUJy+vF9@yadro.com>
References: <20210322080554.7611-1-d.bogdanov@yadro.com>
 <20210322080554.7611-2-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210322080554.7611-2-d.bogdanov@yadro.com>
X-Originating-IP: [10.199.0.74]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 22, 2021 at 11:05:48AM +0300, Dmitry Bogdanov wrote:
> +static int
> +target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
> +{
> +	int i, k, len = 0;
> +	struct config_item_type *cit = &tf->tf_tpg_base_cit;
> +	struct configfs_attribute **attrs;
> +
> +	if (tf->tf_ops->fabric_enable_tpg)
> +		for (i = 0; core_tpg_base_enable_attrs[i]; i++)
> +			len += sizeof(struct configfs_attribute *);
...
> +	if (tf->tf_ops->fabric_enable_tpg)
> +		for (i = 0; core_tpg_base_enable_attrs[i]; i++)
...
>+CONFIGFS_ATTR(core_tpg_base_, enable);
>+
>+struct configfs_attribute *core_tpg_base_enable_attrs[] = {
>+       &core_tpg_base_attr_enable,
>+       NULL,

I believe that there is no real benefit in core_tpg_base_enable_attrs[]
with only one attribute. Just use core_tpg_base_attr_enable directly.
