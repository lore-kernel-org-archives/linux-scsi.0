From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm-mq and end_clone_request()
Date: Wed, 27 Jul 2016 16:05:56 -0700
Message-ID: <dd513a39-eb62-cc3c-d214-e4eca5e65a4e@sandisk.com>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
	<20160720140815.GA19045@redhat.com> <20160720142727.GA57399@redhat.com>
	<1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
	<20160720183321.GA20223@redhat.com>
	<84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
	<20160725175344.GA23000@redhat.com> <20160725212325.GA23961@redhat.com>
	<1490356d-2c0e-d94a-7a88-5e8bc89953ef@sandisk.com>
	<20160726011607.GA77078@redhat.com> <20160727200939.GA82654@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160727200939.GA82654@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/27/2016 01:09 PM, Mike Snitzer wrote:
>  In addition to the above patch, please apply this patch and retest your
> 4.7 kernel:
>
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 287caa7..16583c1 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1416,12 +1416,14 @@ static void multipath_postsuspend(struct dm_target *ti)
>  static void multipath_resume(struct dm_target *ti)
>  {
>  	struct multipath *m = ti->private;
> +	unsigned long flags;
>
> +	spin_lock_irqsave(&m->lock, flags);
>  	if (test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags))
>  		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
>  	else
>  		clear_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
> -	smp_mb__after_atomic();
> +	spin_unlock_irqrestore(&m->lock, flags);
>  }
>
>  /*

Hello Mike,

Thanks again for having made this patch available. I will test it as 
soon as I have the time. BTW, in the meantime I ran a few tests with 
DM_MQ_DEFAULT=n since until now I ran all tests with DM_MQ_DEFAULT=y. 
The result of these tests is as follows:
* v4.6.0, v4.6.5 and v4.7.0 with DM_MQ_DEFAULT=y: first simulated path 
removal triggers I/O errors.
* v4.6.4, v4.6.5 and v4.7.0 with DM_MQ_DEFAULT=n: test passes more than 
100 iterations.

I have not yet run any tests with kernel v4.5.x because in the test I 
ran the ib_srp and ib_srpt drivers are loaded on the same system and 
because I need five v4.7 LIO patches to run this test pass but 
unfortunately these patches do not apply cleanly on the v4.5.x code base.

Please let me know if you need more information.

Bart.
