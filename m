From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: don't look for NULL devices handlers by name
Date: Mon, 26 Mar 2018 12:56:38 +0200
Message-ID: <20180326125638.2510d7dd@pentland.suse.de>
References: <20180323133705.14556-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180323133705.14556-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 23 Mar 2018 14:37:05 +0100
Johannes Thumshirn <jthumshirn@suse.de> wrote:

> Currently scsi_dh_lookup() doesn't check for NULL as a device
> name. This combined with nvme over dm-mapth results in the following
> messages emitted by device-mapper:
> 
>  device-mapper: multipath: Could not failover device 259:67: Handler
> scsi_dh_(null) error 14.
> 
> Let scsi_dh_lookup() fail fast on NULL names.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_dh.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index b88b5dbbc444..188f30572aa1 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -112,6 +112,9 @@ static struct scsi_device_handler
> *scsi_dh_lookup(const char *name) {
>  	struct scsi_device_handler *dh;
>  
> +	if (!name || strlen(name) == 0)
> +		return NULL;
> +
>  	dh = __scsi_dh_lookup(name);
>  	if (!dh) {
>  		request_module("scsi_dh_%s", name);

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
