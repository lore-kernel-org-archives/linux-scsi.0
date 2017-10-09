From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH] scsi: libiscsi: fix shifting of DID_REQUEUE host byte
Date: Mon, 9 Oct 2017 14:26:02 -0700
Message-ID: <80ee964c-5e48-9059-12fa-7aa61d6b893d@suse.com>
References: <20171009113319.9505-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171009113319.9505-1-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Chris Leech <cleech@redhat.com>
List-Id: linux-scsi@vger.kernel.org



On 10/09/2017 04:33 AM, Johannes Thumshirn wrote:
> The SCSI host byte should be shifted left by 16 in order to have
> scsi_decide_disposition() do the right thing (.i.e. requeue the command).
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 661134ad3765 ("[SCSI] libiscsi, bnx2i: make bound ep check common")
> Cc: Lee Duncan <lduncan@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>
> Cc: Chris Leech <cleech@redhat.com>
> ---
>  drivers/scsi/libiscsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index bd4605a34f54..9cba4913b43c 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1728,7 +1728,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  
>  	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
>  		reason = FAILURE_SESSION_IN_RECOVERY;
> -		sc->result = DID_REQUEUE;
> +		sc->result = DID_REQUEUE << 16;
>  		goto fault;
>  	}
>  
> 
Good catch.

I know you're working on fixing all drivers to use the correct macros
rather than rolling there own.

Acked-by: Lee Duncan <lduncan@suse.com>
-- 
Lee Duncan
SUSE Labs
