From: Timothy Pearson <tpearson@raptorengineeringinc.com>
Subject: Re: [PATCH v2] mpt2sas: Abort initialization if no memory I/O resources
 detected
Date: Sat, 27 Jun 2015 20:30:56 -0500
Message-ID: <558F4E50.5040509@raptorengineeringinc.com>
References: <557B578D.50706@raptorengineeringinc.com> <1435066507.2251.10.camel@HansenPartnership.com> <55899867.3010400@raptorengineeringinc.com> <1435081516.2251.118.camel@HansenPartnership.com> <55899BBA.5030509@raptorengineeringinc.com> <1435082169.2251.120.camel@HansenPartnership.com> <55899E79.1010208@raptorengineeringinc.com> <1435083585.2251.125.camel@HansenPartnership.com> <1752241556.3143.1435087724484.JavaMail.zimbra@raptorengineeringinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pearsoncomputing.net ([192.119.205.242]:28248 "EHLO
	mail.pearsoncomputing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbF1BbA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2015 21:31:00 -0400
In-Reply-To: <1752241556.3143.1435087724484.JavaMail.zimbra@raptorengineeringinc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Joe Lawrence <joe.lawrence@stratus.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, "Support (LSI)" <support@lsi.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

On 06/23/2015 02:28 PM, Timothy Pearson wrote:
> The mpt2sas driver crashes if the BIOS does not set up at least one
> memory I/O resource.  This failure can happen if the device is too
> slow to respond during POST and is missed by the BIOS, but Linux
> then detects the device later in the boot process.
>
> Signed-off-by: Timothy Pearson<tpearson@raptorengineeringinc.com>
> Tested-by: Timothy Pearson<tpearson@raptorengineeringinc.com>
> ---
>   drivers/scsi/mpt2sas/mpt2sas_base.c |    7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 11248de..b70fa5a 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -1582,6 +1582,13 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
>   		}
>   	}
>
> +	if (ioc->chip == NULL) {
> +		printk(MPT2SAS_ERR_FMT "unable to map "
> +			"adapter memory (resource not found)!\n", ioc->name);
> +		r = -EINVAL;
> +		goto out_fail;
> +	}
> +
>   	_base_mask_interrupts(ioc);
>
>   	r = _base_get_ioc_facts(ioc, CAN_SLEEP);

Just wanted to follow up on this patch since I haven't received a 
response.  As far as I know the (trivial) concerns from the first 
version should be addressed in this version.

Thanks!

-- 
Timothy Pearson
Raptor Engineering
+1 (415) 727-8645
http://www.raptorengineeringinc.com
