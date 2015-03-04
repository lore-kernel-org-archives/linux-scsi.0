From: Olaf Hering <olaf@aepfle.de>
Subject: Re: crash in pscsi_get_device_type
Date: Wed, 4 Mar 2015 16:00:04 +0100
Message-ID: <20150304150004.GA22266@aepfle.de>
References: <20150226092604.GA1119@aepfle.de>
 <1425037939.30824.89.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:27516 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbbCDPAH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2015 10:00:07 -0500
Content-Disposition: inline
In-Reply-To: <1425037939.30824.89.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Feb 27, Nicholas A. Bellinger wrote:

> On Thu, 2015-02-26 at 10:26 +0100, Olaf Hering wrote:

> > [  145.661468] IP: [<ffffffffa024f17b>] pscsi_get_device_type+0xb/0x20 [target_core_pscsi]
> Looks like a PSCSI specific NULL pointer dereference when reading the
> dev_type attribute if a backend device was not able to be successfully
> configured -> enabled.
> 
> Here's a quick patch to address this case.  Please confirm on your end.

Unfortunately I can not reproduce it anymore. Maybe it depends on the .config?

Olaf

> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 1045dcd..f6c954c 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -1121,7 +1121,7 @@ static u32 pscsi_get_device_type(struct se_device *dev)
>         struct pscsi_dev_virt *pdv = PSCSI_DEV(dev);
>         struct scsi_device *sd = pdv->pdv_sd;
>  
> -       return sd->type;
> +       return (sd) ? sd->type : TYPE_NO_LUN;
>  }
>  
>  static sector_t pscsi_get_blocks(struct se_device *dev)
