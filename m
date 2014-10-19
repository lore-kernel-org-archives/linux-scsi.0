From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Sun, 19 Oct 2014 20:36:31 +0300
Message-ID: <5443F69F.40606@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5433E585.607-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/7/2014 4:07 PM, Bart Van Assche wrote:
> Improve performance by using multiple RDMA/RC channels per SCSI
> host for communication with an SRP target. About the
> implementation:
> - Introduce a loop over all channels in the code that uses
>    target->ch.
> - Set the SRP_MULTICHAN_MULTI flag during login for the creation
>    of the second and subsequent channels.
> - RDMA completion vectors are chosen such that RDMA completion
>    interrupts are handled by the CPU socket that submitted the I/O
>    request. As one can see in this patch it has been assumed if a
>    system contains n CPU sockets and m RDMA completion vectors
>    have been assigned to an RDMA HCA that IRQ affinity has been
>    configured such that completion vectors [i*m/n..(i+1)*m/n) are
>    bound to CPU socket i with 0 <= i < n.
> - Modify srp_free_ch_ib() and srp_free_req_data() such that it
>    becomes safe to invoke these functions after the corresponding
>    allocation function failed.
> - Add a ch_count sysfs attribute per target port.
>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>   Documentation/ABI/stable/sysfs-driver-ib_srp |  25 ++-
>   drivers/infiniband/ulp/srp/ib_srp.c          | 291 ++++++++++++++++++++-------
>   drivers/infiniband/ulp/srp/ib_srp.h          |   3 +-
>   3 files changed, 238 insertions(+), 81 deletions(-)
>
> diff --git a/Documentation/ABI/stable/sysfs-driver-ib_srp b/Documentation/ABI/stable/sysfs-driver-ib_srp
> index b9688de..d5a459e 100644
> --- a/Documentation/ABI/stable/sysfs-driver-ib_srp
> +++ b/Documentation/ABI/stable/sysfs-driver-ib_srp
> @@ -55,12 +55,12 @@ Description:	Interface for making ib_srp connect to a new target.
>   		  only safe with partial memory descriptor list support enabled
>   		  (allow_ext_sg=1).
>   		* comp_vector, a number in the range 0..n-1 specifying the
> -		  MSI-X completion vector. Some HCA's allocate multiple (n)
> -		  MSI-X vectors per HCA port. If the IRQ affinity masks of
> -		  these interrupts have been configured such that each MSI-X
> -		  interrupt is handled by a different CPU then the comp_vector
> -		  parameter can be used to spread the SRP completion workload
> -		  over multiple CPU's.
> +		  MSI-X completion vector of the first RDMA channel. Some
> +		  HCA's allocate multiple (n) MSI-X vectors per HCA port. If
> +		  the IRQ affinity masks of these interrupts have been
> +		  configured such that each MSI-X interrupt is handled by a
> +		  different CPU then the comp_vector parameter can be used to
> +		  spread the SRP completion workload over multiple CPU's.

This is fairly not trivial for the user...

Aren't we requesting a bit too much awareness here?
Can't we just "make it work"? The user hands out ch_count - why can't
you do some least-used logic here?

Maybe we can even go with per-cpu QPs and discard comp_vector argument?
this would probably bring the best performance, wouldn't it?
(fallback to least-used logic in case HW support less vectors)

>   		* tl_retry_count, a number in the range 2..7 specifying the
>   		  IB RC retry count.
>   		* queue_size, the maximum number of commands that the
> @@ -88,6 +88,13 @@ Description:	Whether ib_srp is allowed to include a partial memory
>   		descriptor list in an SRP_CMD when communicating with an SRP
>   		target.
>
> +What:		/sys/class/scsi_host/host<n>/ch_count
> +Date:		November 1, 2014
> +KernelVersion:	3.18
> +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:	Number of RDMA channels used for communication with the SRP
> +		target.
> +
>   What:		/sys/class/scsi_host/host<n>/cmd_sg_entries
>   Date:		May 19, 2011
>   KernelVersion:	2.6.39
> @@ -95,6 +102,12 @@ Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>   Description:	Maximum number of data buffer descriptors that may be sent to
>   		the target in a single SRP_CMD request.
>
> +What:		/sys/class/scsi_host/host<n>/comp_vector
> +Date:		September 2, 2013
> +KernelVersion:	3.11
> +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:	Completion vector used for the first RDMA channel.
> +
>   What:		/sys/class/scsi_host/host<n>/dgid
>   Date:		June 17, 2006
>   KernelVersion:	2.6.17
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index eccaf65..80699a9 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -123,6 +123,11 @@ MODULE_PARM_DESC(dev_loss_tmo,
>   		 " if fast_io_fail_tmo has not been set. \"off\" means that"
>   		 " this functionality is disabled.");
>
> +static unsigned ch_count;
> +module_param(ch_count, uint, 0444);
> +MODULE_PARM_DESC(ch_count,
> +		 "Number of RDMA channels to use for communication with an SRP target. Using more than one channel improves performance if the HCA supports multiple completion vectors. The default value is the minimum of four times the number of online CPU sockets and the number of completion vectors supported by the HCA.");
> +

Why? how did you get to this magic equation?

>   static void srp_add_one(struct ib_device *device);

...
So it's pretty late for today, this is where I got so far...
Will continue later this week.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
