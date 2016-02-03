From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V5 07/10] aacraid: Created new mutex for ioctl path
Date: Wed, 3 Feb 2016 11:37:31 +0100
Message-ID: <56B1D86B.7000402@redhat.com>
References: <1454461088-32482-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1454461088-32482-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbcBCKhf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Feb 2016 05:37:35 -0500
In-Reply-To: <1454461088-32482-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, shane.seymour@hpe.com

On 3.2.2016 01:58, Raghava Aditya Renukunta wrote:
> aac_mutex was used to create protect the ioctl path for only the
> compat path, it would be make more sense to place mutex in
> aac_do_ioctl, which is the main ioctl function call that handles
> all ioctl commands.
>
> Created new mutex ioctl_mutex in struct aac_dev to protect switch
> case in aac_do_ioctl and removed aac_mutex from aac_cfg_ioctl and
> aac_compat_do_ioctl
>
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
> ---
>  drivers/scsi/aacraid/aacraid.h  |  1 +
>  drivers/scsi/aacraid/commctrl.c |  4 ++++
>  drivers/scsi/aacraid/linit.c    | 12 ++----------
>  3 files changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 2916288..75bc65e 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1124,6 +1124,7 @@ struct aac_dev
>  	struct fib		*free_fib;
>  	spinlock_t		fib_lock;
>  
> +	struct mutex		ioctl_mutex;
>  	struct aac_queue_block *queues;
>  	/*
>  	 *	The user API will use an IOCTL to register itself to receive
> diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
> index 54195a1..4d5f4e7 100644
> --- a/drivers/scsi/aacraid/commctrl.c
> +++ b/drivers/scsi/aacraid/commctrl.c
> @@ -855,6 +855,8 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
>  {
>  	int status;
>  
> +	mutex_lock(&dev->ioctl_mutex);
> +

       status = aac_dev_ioctl(dev, cmd, arg);
        if (status != -ENOTTY)
                return status;

That return^ needs a mutex unlock .
--tms

