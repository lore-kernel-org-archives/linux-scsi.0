From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH] scsi: mpt3sas: Fix memory allocation failure test in
 'mpt3sas_base_attach()'
Date: Mon, 07 Aug 2017 10:25:48 +0200
Message-ID: <5988240C.1050702@bfs.de>
References: <cover.1502058761.git.christophe.jaillet@wanadoo.fr> <20170806225134.27079-1-christophe.jaillet@wanadoo.fr>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806225134.27079-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



Am 07.08.2017 00:51, schrieb Christophe JAILLET:
> In the lines above this test, 8 'kzalloc' are performed, but only 7 results
> are tested.
> 
> Add the missing one (i.e. '!ioc->port_enable_cmds.reply').
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 1a5b6e40fb5c..8a44636ab0b5 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -5494,10 +5494,10 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
>  	ioc->ctl_cmds.status = MPT3_CMD_NOT_USED;
>  	mutex_init(&ioc->ctl_cmds.mutex);
>  
> -	if (!ioc->base_cmds.reply || !ioc->transport_cmds.reply ||
> -	    !ioc->scsih_cmds.reply || !ioc->tm_cmds.reply ||
> -	    !ioc->config_cmds.reply || !ioc->ctl_cmds.reply ||
> -	    !ioc->ctl_cmds.sense) {
> +	if (!ioc->base_cmds.reply || !ioc->port_enable_cmds.reply ||
> +	    !ioc->transport_cmds.reply || !ioc->scsih_cmds.reply ||
> +	    !ioc->tm_cmds.reply || !ioc->config_cmds.reply ||
> +	    !ioc->ctl_cmds.reply || !ioc->ctl_cmds.sense) {
>  		r = -ENOMEM;
>  		goto out_free_resources;
>  	}


obviously it is better to follow the pattern "malloc() , check".
Even the programmer lost track.

Bonus points if you malloc the buffers in one step.

just my 2 cents,

re,
 wh
