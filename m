Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F421208A0;
	Tue, 23 Jul 2024 13:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721741592; cv=none; b=IBASSslf9H33WFxkG0tDpDXOD81O7LVQ4I0SHhDWsT/RC3V/8goxkhj0pG87yWkMMjGdNppDEbCjGZNB/Bqr/85OVFXZmD6mYk4YPuAFQmXMD2wCTQRicwEAp84I81hYnJmS0wXuVbhYcFlB4M384Ut0KxQsEUldC/p6rkOwa5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721741592; c=relaxed/simple;
	bh=BHxbtpXYINWUUlpOGlyc6yectBbC1j0hOWiHMJY2K2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dlf2jErl4TTFG3yK6ZYk3rsrNsK+KRol1sMXBBYY1AabQNOHd8OQZ3/RGDE+zoX3hQnxS3mi/OEAS+xykFdrIuokA0HXxKEAwM4GSBFsJrkMdlvifxdVdzRK3PBjRFAOIQMZ1Yk0V7Dt98vKOzLWT6ydpgFw7XalSpDG9TJXZXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTHxvJf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTHxvJf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CACC4AF09;
	Tue, 23 Jul 2024 13:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721741591;
	bh=BHxbtpXYINWUUlpOGlyc6yectBbC1j0hOWiHMJY2K2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LTHxvJf7L6IOFN0icPzKHuq/LCXLGvxnpWIaHt+1I4ARdsb+ghxBQn/HLcInGoLxq
	 X3o7THfPt/K0CprYzh45rpuW7IOGa3xz1HI/PaFv8vDcqKWnXP8LwGZW4r6c6PZl9F
	 9MdWa+oY8aQb4jaRTPLuyjn9pofl8Nhs9DgWUXjQ=
Date: Tue, 23 Jul 2024 15:33:09 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Maximilian Heyne <mheyne@amazon.de>
Cc: Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Mike Christie <michael.christie@oracle.com>,
	Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>,
	Li Zhijian <lizhijian@fujitsu.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	stable@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.10] scsi: core: Fix a use-after-free
Message-ID: <2024072358-eleven-etching-1988@gregkh>
References: <20240723115047.13092-1-mheyne@amazon.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723115047.13092-1-mheyne@amazon.de>

On Tue, Jul 23, 2024 at 11:50:46AM +0000, Maximilian Heyne wrote:
> From: Bart Van Assche <bvanassche@acm.org>
> 
> [ Upstream commit 8fe4ce5836e932f5766317cb651c1ff2a4cd0506 ]
> 
> There are two .exit_cmd_priv implementations. Both implementations use
> resources associated with the SCSI host. Make sure that these resources are
> still available when .exit_cmd_priv is called by waiting inside
> scsi_remove_host() until the tag set has been freed.
> 
> This commit fixes the following use-after-free:
> 
> ==================================================================
> BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
> Read of size 8 at addr ffff888100337000 by task multipathd/16727
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x34/0x44
>  print_report.cold+0x5e/0x5db
>  kasan_report+0xab/0x120
>  srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
>  scsi_mq_exit_request+0x4d/0x70
>  blk_mq_free_rqs+0x143/0x410
>  __blk_mq_free_map_and_rqs+0x6e/0x100
>  blk_mq_free_tag_set+0x2b/0x160
>  scsi_host_dev_release+0xf3/0x1a0
>  device_release+0x54/0xe0
>  kobject_put+0xa5/0x120
>  device_release+0x54/0xe0
>  kobject_put+0xa5/0x120
>  scsi_device_dev_release_usercontext+0x4c1/0x4e0
>  execute_in_process_context+0x23/0x90
>  device_release+0x54/0xe0
>  kobject_put+0xa5/0x120
>  scsi_disk_release+0x3f/0x50
>  device_release+0x54/0xe0
>  kobject_put+0xa5/0x120
>  disk_release+0x17f/0x1b0
>  device_release+0x54/0xe0
>  kobject_put+0xa5/0x120
>  dm_put_table_device+0xa3/0x160 [dm_mod]
>  dm_put_device+0xd0/0x140 [dm_mod]
>  free_priority_group+0xd8/0x110 [dm_multipath]
>  free_multipath+0x94/0xe0 [dm_multipath]
>  dm_table_destroy+0xa2/0x1e0 [dm_mod]
>  __dm_destroy+0x196/0x350 [dm_mod]
>  dev_remove+0x10c/0x160 [dm_mod]
>  ctl_ioctl+0x2c2/0x590 [dm_mod]
>  dm_ctl_ioctl+0x5/0x10 [dm_mod]
>  __x64_sys_ioctl+0xb4/0xf0
>  dm_ctl_ioctl+0x5/0x10 [dm_mod]
>  __x64_sys_ioctl+0xb4/0xf0
>  do_syscall_64+0x3b/0x90
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> Link: https://lore.kernel.org/r/20220826002635.919423-1-bvanassche@acm.org
> Fixes: 65ca846a5314 ("scsi: core: Introduce {init,exit}_cmd_priv()")
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Li Zhijian <lizhijian@fujitsu.com>
> Reported-by: Li Zhijian <lizhijian@fujitsu.com>
> Tested-by: Li Zhijian <lizhijian@fujitsu.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> [mheyne: fixed contextual conflicts:
>   - drivers/scsi/hosts.c: due to missing commit 973dac8a8a14 ("scsi: core: Refine how we set tag_set NUMA node")
>   - drivers/scsi/scsi_sysfs.c: due to missing commit 6f8191fdf41d ("block: simplify disk shutdown")
>   - drivers/scsi/scsi_scan.c: due to missing commit 59506abe5e34 ("scsi: core: Inline scsi_mq_alloc_queue()")]
> Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
> Cc: stable@vger.kernel.org # v5.10

Both now backported, thanks.

greg k-h
