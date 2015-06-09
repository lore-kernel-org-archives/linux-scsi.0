From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC 1/2] target: Add support for fabric IRQ completion
Date: Tue, 9 Jun 2015 09:27:20 +0200
Message-ID: <20150609072720.GA10758@lst.de>
References: <1432281446-31080-1-git-send-email-nab@daterainc.com> <1432281446-31080-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46281 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbbFIH1W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jun 2015 03:27:22 -0400
Content-Disposition: inline
In-Reply-To: <1432281446-31080-2-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index 3fbb0d4..aa08d6b 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -37,6 +37,7 @@
>  
>  #include <target/target_core_base.h>
>  #include <target/target_core_backend.h>
> +#include <target/target_core_configfs.h>
>  #include <target/target_core_fabric.h>
>  
>  #include "target_core_internal.h"

This hunk look unrelated.

On the implementation:  the new target_core_fabric_ops flag and
command flag aren't really needed, just add a version of
target_complete_cmd that takes the flag.

target_complete_irq is fairly misnamed as it doesn't get called
just from irq context, please chose a more sensible name for it.

