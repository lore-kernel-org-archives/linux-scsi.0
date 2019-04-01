From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/1] scsi: storvsc: Fix calculation of sub-channel count
Date: Mon, 01 Apr 2019 15:45:13 +0200
Message-ID: <87imvx261i.fsf@vitty.brq.redhat.com>
References: <1554076559-14873-1-git-send-email-mikelley@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554076559-14873-1-git-send-email-mikelley@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kelley <mikelley@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Long Li <longli@microsoft.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "emilne@redhat.com" <emilne@redhat.com>, "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Michael Kelley <mikelley@microsoft.com> writes:

> When the number of sub-channels offered by Hyper-V is >= the number
> of CPUs in the VM, calculate the correct number of sub-channels.
> The current code produces one too many.
>
> This scenario arises only when the number of CPUs is artificially
> restricted (for example, with maxcpus=<n> on the kernel boot line),
> because Hyper-V normally offers a sub-channel count < number of CPUs.
> While the current code doesn't break, the extra sub-channel is
> unbalanced across the CPUs (for example, a total of 5 channels on
> a VM with 4 CPUs).
>
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 84380ba..fbaa11a 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -674,7 +674,17 @@ static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
>  	struct vstor_packet *vstor_packet;
>  	int ret, t;
>  
> -	num_sc = ((max_chns > num_cpus) ? num_cpus : max_chns);
> +	/*
> +	 * If the number of CPUs is artificially restricted, such as
> +	 * with maxcpus=1 on the kernel boot line, Hyper-V could offer
> +	 * sub-channels >= the number of CPUs. These sub-channels
> +	 * should not be created. The primary channel is already created
> +	 * and assigned to one CPU, so check against # CPUs - 1.
> +	 */

Indeed.

> +	num_sc = min((num_cpus - 1), max_chns);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

(nit: you could've written

num_sc = min((num_online_cpus() - 1), max_chns);

and got rid of the now-unneeded num_cpus variable).

> +	if (!num_sc)
> +		return;
> +
>  	stor_device = get_out_stor_device(device);
>  	if (!stor_device)
>  		return;

-- 
Vitaly
