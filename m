From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
Date: Sat, 9 Oct 2010 14:20:47 -0700
Message-ID: <20101009212047.GB27180@kroah.com>
References: <4CA653F0.1010008@vlnb.net> <4CA656AD.8020408@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185Ab0JIVaX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Oct 2010 17:30:23 -0400
Content-Disposition: inline
In-Reply-To: <4CA656AD.8020408@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>, Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>

On Sat, Oct 02, 2010 at 01:46:21AM +0400, Vladislav Bolkhovitin wrote:
> This patch contains SYSFS interface implementation.

Nice, but you forgot to document it.  All sysfs changes need to be
documented in Documentation/ABI/

Please add a file to this patch that does so.

> +static void scst_tgtt_release(struct kobject *kobj)
> +{
> +	struct scst_tgt_template *tgtt;
> +
> +	tgtt = container_of(kobj, struct scst_tgt_template, tgtt_kobj);
> +	complete_all(&tgtt->tgtt_kobj_release_cmpl);
> +	return;

Don't you also need to free the memory of your kobject here?

> +static void scst_tgt_release(struct kobject *kobj)
> +{
> +	struct scst_tgt *tgt;
> +
> +	tgt = container_of(kobj, struct scst_tgt, tgt_kobj);
> +	complete_all(&tgt->tgt_kobj_release_cmpl);
> +	return;

Same here, no kfree?

> +static void scst_acg_release(struct kobject *kobj)
> +{
> +	struct scst_acg *acg;
> +
> +	acg = container_of(kobj, struct scst_acg, acg_kobj);
> +	complete_all(&acg->acg_kobj_release_cmpl);

And here.

thanks,

greg k-h
