From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] pcmcia: add error handling for pcmcia_enable_device
Date: Mon, 11 Jun 2018 09:21:16 +0200
Message-ID: <20180611072116.vaz4xff4pd6qxtj7@linux-x5ow.site>
References: <1528694152-31724-1-git-send-email-jiazhouyang09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1528694152-31724-1-git-send-email-jiazhouyang09@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 11, 2018 at 01:15:50PM +0800, Zhouyang Jia wrote:
> When pcmcia_enable_device fails, the lack of error-handling code may
> cause unexpected results.
> 
> This patch adds error-handling code after calling pcmcia_enable_device.
> 
> Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
> ---
>  drivers/scsi/pcmcia/qlogic_stub.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
> index 0556054..9287d52 100644
> --- a/drivers/scsi/pcmcia/qlogic_stub.c
> +++ b/drivers/scsi/pcmcia/qlogic_stub.c
> @@ -254,8 +254,14 @@ static void qlogic_release(struct pcmcia_device *link)
>  static int qlogic_resume(struct pcmcia_device *link)
>  {
>  	scsi_info_t *info = link->priv;
> +	int ret;
> +
> +	ret = pcmcia_enable_device(link);
> +	if (ret) {
> +		pcmcia_disable_device(link);
> +		return -ENODEV;
> +	}

pcmcia_enable_device() can fail for three reasons:
1) the socket is not present
2) the configuration is locked
3) setting the socket's power control fails

In all three cases I think it's actually an error to call
pcmcia_disable_device().

Imagine the following scenario:
pcmcia_enable_device() failed because the device configuration is
locked by another driver, then you call pcmcia_disable_device() which
calls pcmcia_release_configuration(). pcmcia_release_configuration()
checks if the device is locked, decrements the lock counter, clears
the CONFIG_LOCKED bit in the PCMCIA config and sets the voltage to 0
without the first driver every noticing it.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
