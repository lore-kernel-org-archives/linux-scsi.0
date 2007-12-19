From: "Filippos Papadopoulos" <psybases@gmail.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Wed, 19 Dec 2007 10:48:27 +0200
Message-ID: <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <20071217031841.f483e5ac.akpm@linux-foundation.org>
	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>
	 <47666904.8060605@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:52116 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbXLSIs3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Dec 2007 03:48:29 -0500
Received: by py-out-1112.google.com with SMTP id u77so4746498pyb.16
        for <linux-scsi@vger.kernel.org>; Wed, 19 Dec 2007 00:48:28 -0800 (PST)
In-Reply-To: <47666904.8060605@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Dec 17, 2007 2:18 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> I have found one problem. Please try patch [2] below and report.
> If it still fails try to enable debugging by setting with patch [1]
> these values at top of drivers/scsi/initio.c. And send dmsgs.
>
> Boaz
>


I tried patch[2] (addition of   sg++)  at 2.6.24-rc5-mm1 but the
system hangs after some seconds when the initio driver loads.
I will try patch[1] next week to see what happens.

Would it be better to open a bug report at bugzilla?


	

>
> --------
> patch [1]
> --------
>
> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
> index 4c4465d..61edcd2 100644
> --- a/drivers/scsi/initio.c
> +++ b/drivers/scsi/initio.c
> @@ -138,10 +138,10 @@ static struct pci_device_id i91u_pci_devices[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, i91u_pci_devices);
>
> -#define DEBUG_INTERRUPT 0
> -#define DEBUG_QUEUE     0
> -#define DEBUG_STATE     0
> -#define INT_DISC       0
> +#define DEBUG_INTERRUPT 1
> +#define DEBUG_QUEUE     1
> +#define DEBUG_STATE     1
> +#define INT_DISC       1
>
>  /*--- forward references ---*/
>  static struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host * host, u16 tarlun);
>
>
> -----------
> patch [2]
> -----------
> git-diff --stat -p
>  drivers/scsi/initio.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
> index 4c4465d..61595f6 100644
> --- a/drivers/scsi/initio.c
> +++ b/drivers/scsi/initio.c
> @@ -2616,6 +2616,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
>                 scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
>                         sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
>                         total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
> +                       sg++;
>                 }
>
>                 cblk->buflen = (scsi_bufflen(cmnd) > total_len) ?
>
>
>
