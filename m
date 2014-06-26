From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Thu, 26 Jun 2014 10:55:51 -0400
Message-ID: <1403794551.3572.6.camel@dabdike>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
	 <1402477799-24610-2-git-send-email-sagig@mellanox.com>
	 <53AC3402.2080302@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53AC3402.2080302-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-06-26 at 16:53 +0200, Bart Van Assche wrote:
> On 06/11/14 11:09, Sagi Grimberg wrote:
> > +	return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;
> 
> Sorry that I just noticed this now, but why is a shift-right and ilog2()
> used in the above expression instead of just dividing the transfer
> length by the sector size ?

It's a performance thing.  Division is really slow on most CPUs.
However, we know the divisor is a power of two so we re-express the
division as a shift, which the processor can do really fast.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
