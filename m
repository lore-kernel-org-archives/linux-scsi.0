From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: 2.6.30-rc4 Weird messages with ext4
Date: Sun, 03 May 2009 20:45:51 +0000
Message-ID: <1241383551.5596.116.camel@mulgrave.int.hansenpartnership.com>
References: <200905031508.06053.papadako@csd.uoc.gr>
	 <49FE0105.6010107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <49FE0105.6010107-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Hancock <hancockrwd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Panagiotis Papadakos <papadako-YET4oHL9trYCep0kKqy/Kg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2009-05-03 at 14:39 -0600, Robert Hancock wrote:
> Panagiotis Papadakos wrote:
> > Hi.
> > 
> > When I connect my ext4 formatted Seagate 1.5 TB USB box,
> > I get the messages of the style:
> > 
> > [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE           
> > [sdb] Sense Key : Illegal Request [current]                     
> > [sdb] Add. Sense: Logical block address out of range 
> > 
> > By the way I am not getting such messages with 2.6.29.
> > 
> > Anyone knows what might be wrong?
> 
> Sounds like something's messing up with the disk size detection, as it 
> gets detected as a 2TB drive. CCing linux-usb and linux-scsi.

There was a screw up in the READ CAPACITY 16 rewrite.  The fix is here:

commit 8f76d151b010980d137bfdc736d1d8f64b489165
Author: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Tue Apr 21 16:43:27 2009 -0700

    [SCSI] fix sign extension with 1.5TB usb-storage LBD=y
 
It's just gone upstream.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
