From: Christof Schmitt <christof.schmitt-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 5/7] scsi-ml: adds queue_depth ramp up
	code
Date: Fri, 16 Oct 2009 11:29:12 +0200
Message-ID: <20091016092912.GA7199@schmichrtp.de.ibm.com>
References: <20091016004639.22451.76363.stgit@vifc.jf.intel.com>
	<20091016004700.22451.42962.stgit@vifc.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091016004700.22451.42962.stgit-M4Lc0Xp98oKtqXYlAKuG4QC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 15, 2009 at 05:47:00PM -0700, Vasu Dev wrote:
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 7b1e20f..3379da6 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -331,6 +331,42 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>  	}
>  }
> 
> +static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
> +{
> +	struct scsi_host_template *sht = sdev->host->hostt;
> +	struct scsi_device *tmp_sdev;
> +
> +	if (!sht->change_queue_depth ||
> +	    sdev->queue_depth == sdev->max_queue_depth)
> +		return;
[...]
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -251,6 +251,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>  	sdev->model = scsi_null_device_strs;
>  	sdev->rev = scsi_null_device_strs;
>  	sdev->host = shost;
> +	sdev->queue_ramp_up_period = SCSI_DEFAULT_RAMP_UP_PERIOD;
>  	sdev->id = starget->id;
>  	sdev->lun = lun;
>  	sdev->channel = starget->channel;
> @@ -312,6 +313,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>  		}
>  	}
> 
> +	sdev->max_queue_depth = sdev->queue_depth;
> +
>  	return sdev;

Running this patches series with the zfcp device driver increases the
queue_depth beyond the maximum. The problem is that after slave_alloc,
the queue_depth is 1 from cmd_per_lun and this is the value used for
max_queue_depth.

zfcp then adjust the queue_depth and tagging in slave_configure. Now,
the queue_depth is 32 and the max_queue_depth is still 1. And the
check for sdev->queue_depth == sdev->max_queue_depth is never true.

What is the best way to solve this? Move the initial assignment of
max_queue_depth to be called after the call to slave_configure? And/or
adjust the check above to sdev->queue_depth >= sdev->max_queue_depth?

--
Christof
