From: "conway, heather" <conway_heather@emc.com>
Subject: RE: Patch from my store of obscure fixes
Date: Fri, 16 Aug 2002 09:08:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <FA2F59D0E55B4B4892EA076FF8704F5501C1A31B@srgraham.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Patrick Mansfield' <patmans@us.ibm.com>, Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-scsi@vger.kernel.org

Patrick,
The device returns a sense data of Logical Unit Not Ready - Manual
Intervention Required to a Test Unit Ready.
Heather

-----Original Message-----
From: Patrick Mansfield [mailto:patmans@us.ibm.com]
Sent: Tuesday, August 13, 2002 6:26 PM
To: Pete Zaitcev
Cc: linux-scsi@vger.kernel.org
Subject: Re: Patch from my store of obscure fixes


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
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
