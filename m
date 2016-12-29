From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Thu, 29 Dec 2016 11:16:51 -0500 (EST)
Message-ID: <20161229.111651.1486287401918317471.davem@davemloft.net>
References: <1482985824-7270-1-git-send-email-jbaron@akamai.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482985824-7270-1-git-send-email-jbaron@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jbaron@akamai.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, Sreekanth.Reddy@broadcom.com, hare@suse.de, martin.petersen@oracle.com, bart.vanassche@sandisk.com, sagi@grimberg.me, jejb@linux.vnet.ibm.com, hch@lst.de, dledford@redhat.com
List-Id: linux-scsi@vger.kernel.org

From: Jason Baron <jbaron@akamai.com>
Date: Wed, 28 Dec 2016 23:30:24 -0500

> On ata passthru commands scsih_qcmd() ends up spinning in
> scsi_wait_for_queuecommand() indefinitely. scsih_qcmd() is called from
> __blk_run_queue_uncond() which first increments request_fn_active to a
> non-zero value. Thus, scsi_wait_for_queuecommand() never completes because
> its spinning waiting for request_fn_active to become 0.
> 
> Two patches interact here. The first:
> 
> commit 18f6084a989b ("scsi: mpt3sas: Fix secure erase premature
> termination") calls scsi_internal_device_block() for ata passthru commands.
> 
> The second patch:
> 
> commit 669f044170d8 ("scsi: srp_transport: Move queuecommand() wait code
> to SCSI core") adds a call to scsi_wait_for_queuecommand() from
> scsi_internal_device_block().
> 
> Add a new parameter to scsi_internal_device_block() to decide whether
> or not to invoke scsi_wait_for_queuecommand().
> 
> Signed-off-by: Jason Baron <jbaron@akamai.com>

Tested-by: David S. Miller <davem@davemloft.net>
