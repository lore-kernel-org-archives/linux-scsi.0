Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1A44315F;
	Fri, 28 Jun 2024 18:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719598532; cv=none; b=DzgUeKBkF2zx6+ssJJcgqY191HCRTFzyx9Eje78eWrqxuNUG/BiJqW865JZXAqqPW5uZV9tSIfOdjWO11uyGn90DadKZJyXotzlYJ75KC8SQuYq5JnQyY4BQHqrbYOIziQ8Uwgc1hDRxoiAJj/c6THqCMSOtD3e5qEwHXayzHBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719598532; c=relaxed/simple;
	bh=G6ogdb37vMBiTBHKzuRXgv5nWGa+A1TGusHactB8uGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C4yXovxyjgCYAwt/MdcRMp+Pa8/Pb7O64pd7roqFwPN61miGsyOjU+MIz1Cuw7y4ATGJBDlJ9Mwc+gf+c5DC/Azu4Se2sbyjFyOXpMMJxHbsgd9czps0IWaryE+pF6kjPKWBfbGfuHv+vtosscTS7GVaTYUJ5C67BYpuFXtXjqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aQOzASL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aQOzASL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD85C116B1;
	Fri, 28 Jun 2024 18:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719598530;
	bh=G6ogdb37vMBiTBHKzuRXgv5nWGa+A1TGusHactB8uGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aQOzASL2TQPWjqByWeCbvIZD6ttnaO4CefmI9uFXiG56QvH+Ux579VffYduabDZIJ
	 0OTy7v1EpSahQG4KiYfHEpGYVaOyolfoFArTWEfwdIVFIl4VBfMxL7A3iHh9QO8UIW
	 vUZbtsWT9pXpAF9P37G0Rv6hE1lcyCF3tYvqXzaC64jbwYqVDoaN2fjfO4xCaF4aFL
	 71w4QqrvCl0ONOjzeao9LNlwzrVLr4NAqChgexYGxbvKzEiQ5Eo6OwvhUbwmLIqX4Z
	 Nj21uftup+t3bsmN7R0Qm0anEYquuejEv2OO+am5eMDiIetAt5aGWu38h8M8TTARir
	 RaUdcM0NUd85A==
Date: Fri, 28 Jun 2024 20:15:25 +0200
From: Niklas Cassel <cassel@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 11/13] ata: libata-core: Reuse available ata_port
 print_ids
Message-ID: <Zn79vbjYDhhXwy_T@ryzen.lan>
References: <20240626180031.4050226-26-cassel@kernel.org>
 <202406290027.cdgsPQAF-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202406290027.cdgsPQAF-lkp@intel.com>

On Sat, Jun 29, 2024 at 12:31:57AM +0800, kernel test robot wrote:
> Hi Niklas,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on linus/master]
> [also build test WARNING on v6.10-rc5 next-20240627]
> [cannot apply to mkp-scsi/for-next jejb-scsi/for-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Niklas-Cassel/ata-libata-core-Fix-null-pointer-dereference-on-error/20240627-123023
> base:   linus/master
> patch link:    https://lore.kernel.org/r/20240626180031.4050226-26-cassel%40kernel.org
> patch subject: [PATCH v2 11/13] ata: libata-core: Reuse available ata_port print_ids
> config: i386-randconfig-141-20240628 (https://download.01.org/0day-ci/archive/20240629/202406290027.cdgsPQAF-lkp@intel.com/config)
> compiler: gcc-8 (Ubuntu 8.4.0-3ubuntu2) 8.4.0
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202406290027.cdgsPQAF-lkp@intel.com/
> 
> smatch warnings:
> drivers/ata/libata-core.c:5467 ata_port_alloc() warn: unsigned 'ap->print_id' is never less than zero.
> 
> vim +5467 drivers/ata/libata-core.c
> 
>   5443	
>   5444	/**
>   5445	 *	ata_port_alloc - allocate and initialize basic ATA port resources
>   5446	 *	@host: ATA host this allocated port belongs to
>   5447	 *
>   5448	 *	Allocate and initialize basic ATA port resources.
>   5449	 *
>   5450	 *	RETURNS:
>   5451	 *	Allocate ATA port on success, NULL on failure.
>   5452	 *
>   5453	 *	LOCKING:
>   5454	 *	Inherited from calling layer (may sleep).
>   5455	 */
>   5456	struct ata_port *ata_port_alloc(struct ata_host *host)
>   5457	{
>   5458		struct ata_port *ap;
>   5459	
>   5460		ap = kzalloc(sizeof(*ap), GFP_KERNEL);
>   5461		if (!ap)
>   5462			return NULL;
>   5463	
>   5464		ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
>   5465		ap->lock = &host->lock;
>   5466		ap->print_id = ida_alloc_min(&ata_ida, 1, GFP_KERNEL);
> > 5467		if (ap->print_id < 0) {

Well, the check is correct, but since ap->print_id is unsigned int,
we will need to use a temporary (signed) variable to check for errors
from ida_alloc_min(). Will fix in next revision.


>   5468			kfree(ap);
>   5469			return NULL;
>   5470		}
>   5471		ap->host = host;
>   5472		ap->dev = host->dev;
>   5473	
>   5474		mutex_init(&ap->scsi_scan_mutex);
>   5475		INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
>   5476		INIT_DELAYED_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
>   5477		INIT_LIST_HEAD(&ap->eh_done_q);
>   5478		init_waitqueue_head(&ap->eh_wait_q);
>   5479		init_completion(&ap->park_req_pending);
>   5480		timer_setup(&ap->fastdrain_timer, ata_eh_fastdrain_timerfn,
>   5481			    TIMER_DEFERRABLE);
>   5482	
>   5483		ap->cbl = ATA_CBL_NONE;
>   5484	
>   5485		ata_link_init(ap, &ap->link, 0);
>   5486	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
