From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Tue, 21 Oct 2014 12:14:43 +0300
Message-ID: <54462403.70700@dev.mellanox.co.il>
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

<SNIP>

>   			spin_lock_irqsave(&ch->lock, flags);
>   			ch->req_lim += be32_to_cpu(rsp->req_lim_delta);
> @@ -1906,7 +1970,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
>   		goto err;

Bart,

Any chance you can share some perf output on this code?
I'm interested of knowing the contention on target->lock that is
still taken on the IO path across channels.

Can we think on how to avoid it?

Also would like to understand the where did the bottleneck transition.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
