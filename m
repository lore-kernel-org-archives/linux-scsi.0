From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/2] qla2xxx: Avoid that issuing a LIP triggers a kernel
 crash
Date: Tue, 24 Jan 2017 13:12:14 +0100
Message-ID: <20170124121214.GF3609@linux-x5ow.site>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com>
 <20170123163446.9227-3-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170123163446.9227-3-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Naresh Bannoth <nbannoth@in.ibm.com>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 23, 2017 at 08:34:46AM -0800, Bart Van Assche wrote:
> Avoid that issuing a LIP as follows:
> 
>   find /sys -name 'issue_lip'|while read f; do echo 1 > $f; done
> 
> triggers the following:
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> Call Trace:
>  qla2x00_abort_all_cmds+0xed/0x140 [qla2xxx]
>  qla2x00_abort_isp_cleanup+0x1e3/0x280 [qla2xxx]
>  qla2x00_abort_isp+0xef/0x690 [qla2xxx]
>  qla2x00_do_dpc+0x36c/0x880 [qla2xxx]
>  kthread+0x10c/0x140
> 
> Fixes: 1535aa75a3d8 ("qla2xxx: fix invalid DMA access after command aborts in PCI device remove")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Naresh Bannoth <nbannoth@in.ibm.com>
> Cc: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
> Cc: <stable@vger.kernel.org>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
