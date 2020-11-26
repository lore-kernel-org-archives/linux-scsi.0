Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AE0C63777
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 08:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99A6620DD4
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 08:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389038AbgKZIvs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 03:51:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:51054 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728127AbgKZIvs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Nov 2020 03:51:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4919AAC22;
        Thu, 26 Nov 2020 08:51:46 +0000 (UTC)
Date:   Thu, 26 Nov 2020 09:51:45 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com, lenb@kernel.org,
        rjw@rjwysocki.net, gregkh@linuxfoundation.org, tglx@linutronix.de,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, linux-acpi@vger.kernel.org, maz@kernel.org
Subject: Re: [PATCH v3 1/5] genirq/affinity: Add irq_update_affinity_desc()
Message-ID: <20201126085145.jjioc7belyny5kp4@beryllium.lan>
References: <1606324841-217570-1-git-send-email-john.garry@huawei.com>
 <1606324841-217570-2-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606324841-217570-2-git-send-email-john.garry@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi John,

On Thu, Nov 26, 2020 at 01:20:37AM +0800, John Garry wrote:
> +	activated = irqd_is_activated(&desc->irq_data);
> +	if (activated)
> +		irq_domain_deactivate_irq(&desc->irq_data);
> +
> +	if (affinity->is_managed) {
> +		irqd_set(&desc->irq_data, IRQD_AFFINITY_MANAGED);
> +		irqd_set(&desc->irq_data, IRQD_MANAGED_SHUTDOWN);
> +	}
> +
> +	cpumask_copy(desc->irq_common_data.affinity, &affinity->mask);
> +
> +	/* Restore the activation state */
> +	if (activated)
> +		irq_domain_deactivate_irq(&desc->irq_data);

Shouldn't this be irq_domain_activate_irq() ?

Thanks,
Daniel


