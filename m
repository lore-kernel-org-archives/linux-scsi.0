From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Patch from my store of obscure fixes
Date: Tue, 13 Aug 2002 15:25:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020813152533.A3259@eng2.beaverton.ibm.com>
References: <20020809164834.A21474@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020809164834.A21474@devserv.devel.redhat.com>; from zaitcev@redhat.com on Fri, Aug 09, 2002 at 04:48:34PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Aug 09, 2002 at 04:48:34PM -0400, Pete Zaitcev wrote:
> Apparently, this patch comes from an expirience with a Clariion array
> with some volumes disabled by operator. When Linux reboots, it
> tries to spin them up and for some reason it times out, and
> generally takes a very long time. I do suspect that START STOP UNIT
> should return failure immediately, but perhaps it does not.
> What do you guys think about this? Obviously a workaround, but
> is it useful?

It looks good, except the device should be offlined (or ?), and the
read capacity prevented; the similiar 2.4 patch prevented the read
capacity since the code is different, and it returned before the
read capacity.

-- Patrick Mansfield

> 
> -- Pete
> 
> --- linux-2.5.30/drivers/scsi/sd.c	Thu Aug  1 14:16:13 2002
> +++ linux-2.5.30-sparc/drivers/scsi/sd.c	Fri Aug  9 13:47:52 2002
> @@ -847,6 +847,16 @@
>  		}
>  
>  		/*
> +		 * If the drive requires human intervention,
> +		 * don't bother to jerk the drive until it happens.
> +		 */
> +		if (the_result != 0 &&
> +		    SRpnt->sr_sense_buffer[2] == NOT_READY &&
> +		    SRpnt->sr_sense_buffer[12] == 0x04 &&	/* ASC */
> +		    SRpnt->sr_sense_buffer[13] == 0x03)		/* ASCQ */
> +			return;
> +
> +		/*
>  		 * If the drive has indicated to us that it doesn't have
>  		 * any media in it, don't bother with any of the rest of
>  		 * this crap.
