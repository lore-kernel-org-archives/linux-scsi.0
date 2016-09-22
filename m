From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH next] scsi: fcoe: fix off by one in eth2fc_speed()
Date: Thu, 22 Sep 2016 12:48:33 +0200
Message-ID: <20160922104833.lyjkysd7lwww7xco@linux-x5ow.site>
References: <1471613617-21291-1-git-send-email-jthumshirn@suse.de>
 <20160921205407.6304-1-vincent.stehle@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38615 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933276AbcIVKse (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Sep 2016 06:48:34 -0400
Content-Disposition: inline
In-Reply-To: <20160921205407.6304-1-vincent.stehle@laposte.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, Sep 21, 2016 at 10:54:07PM +0200, Vincent Stehlé wrote:
> This should be "< ARRAY_SIZE()" instead of "<= ARRAY_SIZE()".
> 
> Fixes: 0b924e5505a568e7 ("scsi: fcoe: provide translation table between Ethernet and FC port speeds")
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> ---
> 
> Hi,
> 
> I saw that in Linux next-20160921.
> 
> Best regards,
> 
> Vincent.
> 
>  drivers/scsi/fcoe/fcoe_transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
> index c164eec..375c536 100644
> --- a/drivers/scsi/fcoe/fcoe_transport.c
> +++ b/drivers/scsi/fcoe/fcoe_transport.c
> @@ -110,7 +110,7 @@ static inline u32 eth2fc_speed(u32 eth_port_speed)
>  {
>  	int i;
>  
> -	for (i = 0; i <= ARRAY_SIZE(fcoe_port_speed_mapping); i++) {
> +	for (i = 0; i < ARRAY_SIZE(fcoe_port_speed_mapping); i++) {
>  		if (fcoe_port_speed_mapping[i].eth_port_speed == eth_port_speed)
>  			return fcoe_port_speed_mapping[i].fc_port_speed;
>  	}
> -- 
> 2.9.3
> 

Good catch,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
