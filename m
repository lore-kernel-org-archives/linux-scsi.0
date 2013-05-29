From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND] scsi: megaraid: check kzalloc
Date: Wed, 29 May 2013 17:03:00 +0200
Message-ID: <51A618A4.2000302@redhat.com>
References: <519ECEF1.9060804@huawei.com> <519F3592.4090207@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <519F3592.4090207@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: megaraidlinux@lsi.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kashyap.desai@lsi.com, aradford@gmail.com, Li Zefan <lizefan@huawei.com>, Santosh Y <santoshsy@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 05/24/2013 11:40 AM, Libo Chen wrote:
> we should check kzalloc, avoid to hit oops
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/scsi/megaraid.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> instead of checking scmd->device, sdev is more appropriate.
>
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 846f475..6b623cb 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -4161,6 +4161,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
>  	memset(scb, 0, sizeof(scb_t));
>
>  	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
> +	if (sdev) {
> +		scsi_free_command(GFP_KERNEL, scmd);

I think, that a mutex_unlock(&adapter->int_mtx); is also needed
Maybe just setting a rval = -ENOMEM and a jump to to some point below?

tomash

> +		return -ENOMEM;
> +	}
>  	scmd->device = sdev;
>
>  	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
