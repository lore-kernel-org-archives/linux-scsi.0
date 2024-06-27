Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83466D1C1;
	Thu, 27 Jun 2024 09:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719481701; cv=none; b=AoKQKFSNk/g/IlwF/fV3jJVQV0w7GpV53qZSpi9hUXCQ8lGCZE6kfY292zqPlnKWwc2w+StLeqN3ss3NLsfj3OtNQ07XswP76ugDgBmIvp7sEIt0xKXGrPeWIL3tQenSlj7Z8SKMhBk4851HH73uLInDqirCMT42LlDeCs8QqVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719481701; c=relaxed/simple;
	bh=bsV+8CFhTqU6lJ9Mn2nop7dlaesXLAMgRe/XWIxlbN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uzkvz39QVeTjQVWeb8ENWn3v9dJ2gTYv/QIAiE29GwcT01+OPD6Pvl0fK8V+ilL5/3vSh0qbw1WbQqy77hNM6otPaH+mxAni+krUrhbUZxCGn+582OH4EpMcA4PeC6wC2ApSPsTwK+knB+6K9lnLABAjutp017Nk5FgxMTjzrZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DcLrFg2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DcLrFg2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1525C2BBFC;
	Thu, 27 Jun 2024 09:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719481700;
	bh=bsV+8CFhTqU6lJ9Mn2nop7dlaesXLAMgRe/XWIxlbN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DcLrFg2iS0bxFCFe2J8h+yGXC+7t0BrGnN/3PPh9bFihen/BoDLAuqQAgQJL2smby
	 Kkruy2v4r571+8bA7C5ik2HlSpkvwQvXFfw5WWit/8bWRUu7ZNKFIkQd8VttTLn4jY
	 YBjjWSb7rkh/BDSZO/fCBpK4xdmb7sJmzb0H3fKDBLdBDKzPRBpCZhOHERKHyrf8ti
	 uw/DiNFvAzR4y56SnW8hiBA+gogIN8KaC8rXlY87yeLurPRKcMg3N2OpvgDZCG1YGi
	 evwiB1vYgXW3n/6Ok25xjpoWqHUPp4hiSsrojp4ho7KEme7RNNkd3aWalDrXPECgNF
	 6L4HBuZQnsgow==
Date: Thu, 27 Jun 2024 11:48:14 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 12/13] ata,scsi: Remove useless ata_sas_port_alloc()
 wrapper
Message-ID: <Zn01XqPMga6aG1nL@ryzen.lan>
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-27-cassel@kernel.org>
 <83125236-7d07-4b62-b86a-5a70f3ca578e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83125236-7d07-4b62-b86a-5a70f3ca578e@kernel.org>

On Thu, Jun 27, 2024 at 10:46:11AM +0900, Damien Le Moal wrote:
> On 6/27/24 03:00, Niklas Cassel wrote:
> > Now when the ap->print_id assignment has moved to ata_port_alloc(),
> > we can remove the useless ata_sas_port_alloc() wrapper.
> 
> Same comment as for patch 4: not a fan.
> 
> But I do like the fact that the port additional initialization is moved to
> libsas, as that code is completely dependent on libsas.
> 
> What about this cleanup, which would make more sense:
> 
> 1) Keep the ata_sas_xxx() exported symbols, even if they are trivial.
> 2) Move all these wrappers to a new file (libata-sas.c) and make this file
> compilation dependend on CONFIG_SATA_HOST and CONFIG_SCSI_SAS_LIBSAS.
> 
> That has the benefit of keeping all the libsas wrappers together and to reduce
> the binary size for configs that do not enable libsas.
> 
> Thoughts ?

I think that:

1) These wrappers are like a virus... they are completely useless and
   having them will force us to keep adding new wrappers, e.g. we would
   need to add a new wrapper for ata_port_free().

2) Having a wrapper that simply does an EXPORT_SYMBOL is not only useless,
it also makes it harder to know that the function (called by the wrapper)
is actually non-internal, since the function will be defined in the libata
internal header in drivers/ata/libata.h, so you might think that it is an
internal function... but it isn't, since there is a wrapper exporting it :)

3) The naming prefix argument does not hold up.
   If you do a:

$ git grep -E "\s+ata_\S+\(" v6.10-rc5 drivers/scsi/libsas/
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ata_qc_complete(qc);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, (u8 *)&task->ata_task.fis);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        task->ata_task.use_ncq = ata_is_ncq(qc->tf.protocol);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        task->ata_task.dma_xfer = ata_is_dma(qc->tf.protocol);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ata_tf_from_fis(dev->sata_dev.fis, &qc->result_tf);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ata_tf_from_fis(dev->frame_rcvd, &tf);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        return ata_dev_classify(&tf);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ret = ata_wait_after_reset(link, deadline, check_ready);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ata_std_sched_eh(ap);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ata_host_init(ata_host, ha->dev, &sas_sata_ops);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ap = ata_sas_port_alloc(ata_host, &sata_port_info, shost);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        rc = ata_sas_tport_add(ata_host->dev, ap);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ata_host_put(ata_host);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:                ata_port_probe(dev->sata_dev.ap);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:                ata_sas_port_suspend(sata->ap);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:                ata_sas_port_resume(sata->ap);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ata_scsi_port_error_handler(ha->shost, ap);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:                        ata_scsi_cmd_error_handler(shost, ap, &sata_q);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:                         * action will be ata_port_error_handler()
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ata_port_schedule_eh(ap);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ata_port_wait_eh(ap);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        ata_link_abort(link);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        rc = ata_ncq_prio_supported(ddev->sata_dev.ap, sdev, &supported);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        rc = ata_ncq_prio_enabled(ddev->sata_dev.ap, sdev, &enabled);
v6.10-rc5:drivers/scsi/libsas/sas_ata.c:        rc = ata_ncq_prio_enable(ddev->sata_dev.ap, sdev, enable);
v6.10-rc5:drivers/scsi/libsas/sas_discover.c:           ata_sas_tport_delete(dev->sata_dev.ap);
v6.10-rc5:drivers/scsi/libsas/sas_discover.c:           ata_host_put(dev->sata_dev.ata_host);
v6.10-rc5:drivers/scsi/libsas/sas_scsi_host.c:          res = ata_sas_queuecmd(cmd, dev->sata_dev.ap);
v6.10-rc5:drivers/scsi/libsas/sas_scsi_host.c:          return ata_sas_scsi_ioctl(dev->sata_dev.ap, sdev, cmd, arg);
v6.10-rc5:drivers/scsi/libsas/sas_scsi_host.c:          ata_sas_device_configure(scsi_dev, lim, dev->sata_dev.ap);
v6.10-rc5:drivers/scsi/libsas/sas_scsi_host.c:          return ata_change_queue_depth(dev->sata_dev.ap, sdev, depth);

You will see that far from all libata functions have ata_sas_*() wrapper,
so all the ata_* functions that do not not have ata_sas_*() wrapper are
already exported using EXPORT_SYMBOL_GPL(), i.e.:

ata_qc_complete(), ata_tf_to_fis(), ata_tf_from_fis(), ata_dev_classify(),
ata_wait_after_reset(), ata_std_sched_eh(), ata_host_init(), ata_host_put(),
ata_port_probe(), ata_scsi_port_error_handler(), ata_scsi_cmd_error_handler(),
ata_port_schedule_eh(), ata_link_abort(), ata_ncq_prio_supported(),
ata_ncq_prio_enabled(), ata_ncq_prio_enable(), ata_change_queue_depth()
are already exported using EXPORT_SYMBOL_GPL().

(And yes, some of these exported functions not used by any libata SATA driver
(compiled as a separate .ko) other than libsas.)


TL;DR: I really think that we should kill these wrappers.


Kind regards,
Niklas
