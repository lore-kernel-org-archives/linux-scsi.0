From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] bsg referencing bus driver module
Date: Fri, 20 Apr 2018 11:55:26 +0200
Message-ID: <1524218126.3321.6.camel@HansenPartnership.com>
References: <CANFzKepsGq0EHX4GPtC0RZOWqVf2fTJ6uA2WH-SZNsBuwMJ5KA@mail.gmail.com>
         <CANFzKer6QDaJALX3LKPF2DV6LgczTh-efQe9+zeK8BuxTWFt1A@mail.gmail.com>
         <CANFzKepRSA+VoVAvOfW6U_qHFVDZex+=hQ=QhU+7Z=unvwejJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANFzKepRSA+VoVAvOfW6U_qHFVDZex+=hQ=QhU+7Z=unvwejJQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anatoliy Glagolev <glagolig@gmail.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, martin.petersen@oracle.com, jthumshirn@suse.de, hare@suse.com, bblock@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-04-19 at 15:10 -0700, Anatoliy Glagolev wrote:
> Updated: rebased on recent Linux, cc-ed maintainers per instructions
> in MAINTAINERS file
> 
> From df939b80d02bf37b21efaaef8ede86cfd39b0cb8 Mon Sep 17 00:00:00
> 2001
> From: Anatoliy Glagolev <aglagolev@purestorage.com>
> Date: Thu, 19 Apr 2018 15:06:06 -0600
> Subject: [PATCH] bsg referencing parent module
> 
> Fixing a bug when bsg layer holds the last reference to device
> when the device's module has been unloaded. Upon dropping the
> reference the device's release function may touch memory of
> the unloaded module.
> ---
>  block/bsg-lib.c                  | 24 ++++++++++++++++++++++--
>  block/bsg.c                      | 29 ++++++++++++++++++++++++++---
>  drivers/scsi/scsi_transport_fc.c |  8 ++++++--
>  include/linux/bsg-lib.h          |  4 ++++
>  include/linux/bsg.h              |  5 +++++
>  5 files changed, 63 insertions(+), 7 deletions(-)
> 
> diff --git a/block/bsg-lib.c b/block/bsg-lib.c
> index fc2e5ff..90c28fd 100644
> --- a/block/bsg-lib.c
> +++ b/block/bsg-lib.c
> @@ -309,6 +309,25 @@ struct request_queue *bsg_setup_queue(struct
> device *dev, const char *name,
>   bsg_job_fn *job_fn, int dd_job_size,
>   void (*release)(struct device *))
>  {
> + return bsg_setup_queue_ex(dev, name, job_fn, dd_job_size, release,
> + NULL);
> +}
> +EXPORT_SYMBOL_GPL(bsg_setup_queue);
> +
> +/**
> + * bsg_setup_queue - Create and add the bsg hooks so we can receive
> requests
> + * @dev: device to attach bsg device to
> + * @name: device to give bsg device
> + * @job_fn: bsg job handler
> + * @dd_job_size: size of LLD data needed for each job
> + * @release: @dev release function
> + * @dev_module: @dev's module
> + */
> +struct request_queue *bsg_setup_queue_ex(struct device *dev, const
> char *name,
> + bsg_job_fn *job_fn, int dd_job_size,
> + void (*release)(struct device *),
> + struct module *dev_module)

This patch isn't applyable because your mailer has changed all the tabs
to spaces.

I also think there's no need to do it this way.  I think what we need
is for fc_bsg_remove() to wait until the bsg queue is drained.  It does
look like the author thought this happened otherwise the code wouldn't
have the note.  If we fix it that way we can do the same thing in all
the other transport classes that use bsg (which all have a similar
issue).

James
