From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm: Add feature flags to dm-mpath
Date: Wed, 5 May 2010 16:01:28 -0400
Message-ID: <20100505200128.GA19763@redhat.com>
References: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
 <1272945691-31649-2-git-send-email-andmike@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab0EEUBf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2010 16:01:35 -0400
Content-Disposition: inline
In-Reply-To: <1272945691-31649-2-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On Tue, May 04 2010 at 12:01am -0400,
Mike Anderson <andmike@linux.vnet.ibm.com> wrote:

> Add a feature flag attribute to the multipath structure.
> 
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
> ---
>  drivers/md/dm-mpath.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 826bce7..4200d03 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -82,6 +82,7 @@ struct multipath {
>  	unsigned saved_queue_if_no_path;/* Saved state during suspension */
>  	unsigned pg_init_retries;	/* Number of times to retry pg_init */
>  	unsigned pg_init_count;		/* Number of times pg_init called */
> +	unsigned long features;

Why not use uint64_t?

>  	struct work_struct process_queued_ios;
>  	struct list_head queued_ios;
> @@ -118,6 +119,15 @@ static void trigger_event(struct work_struct *work);
>  static void activate_path(struct work_struct *work);
>  static void deactivate_path(struct work_struct *work);
>  
> +static int multipath_test_feature(struct multipath *m, unsigned feature)
> +{
> +	return test_bit(feature, &m->features);
> +}
> +
> +static void multipath_set_feature(struct multipath *m, unsigned feature)
> +{
> +	set_bit(feature, &m->features);
> +}

You're using 'unsigned long' for features yet these wrapper functions
take 'unsigned'.  unsigned allows you to use {test,set}_bit but in the
end we have fewer flags to work with...

Granted you're introducing the very first flag but... ;)
