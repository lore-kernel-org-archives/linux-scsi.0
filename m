From: Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Tue, 12 Aug 2008 10:08:40 +0100
Message-ID: <48A15318.30600@tuffmail.co.uk>
References: <Pine.LNX.4.44L0.0808111209100.2142-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0808111209100.2142-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> Antonio reported a problem in
>
> 	http://marc.info/?l=linux-usb&m=121802760208717&w=2
>
> and I have traced it to a bad interaction between the last_sector_bug 
> flag in sd.c and error reporting in the midlayer.
>
> The last_sector_bug flag is set for devices which can't handle 
> multi-sector accesses at the end of the medium.  It causes such 
> accesses to be broken up into multiple single-sector accesses.  For 
> example, a read request for the last 8 sectors of a drive would be 
> turned into eight read requests, each for a single sector.
>
> The problem arises when one of those single-sector requests fails with
> an I/O error.  In the example above, the total length of the original
> request was 4096 bytes.  But scsi_io_completion() is called with 
> good_bytes = 0 and this_count gets set to 512, the number of bytes in 
> the failed command.
>
> At the end of the function, scsi_end_request() is called with error =
> -EIO, bytes = 512, and requeue = 0.  This results in a call to
>
> 	blk_end_request(req, -EIO, 512);
>
> and the remainder of the request is left hanging out to dry.  It never 
> is requeued, it never completes, and the caller hangs.
>
> This suggests that we need to change the call to scsi_end_request() at 
> the end of scsi_io_completion().  If result is nonzero then nothing 
> will be requeued, so this_count should be replaced with the total 
> number of bytes remaining in the request.  Does that sound reasonable?
>
> If anyone would like to recreate the conditions leading to this 
> problem, there's a description of how to do it in this email:
>
> 	http://marc.info/?l=linux-kernel&m=121805565105096&w=2
>   
It sounds a bit like the hangs that happened with my buggy card reader. 
My card reader returned errors because of the IO patterns from the first
version of the last_sector_bug flag.  But instead of reads returning
with errors, I just ended up with hung processes.

It's great to see this tracked down.  Keep me CC'd and I'll test
whatever patch you come up with.  I can simulate the old last_sector_bug
behaviour by changing SD_LAST_BUGGY_SECTORS to 1 (instead of 8).

Alan
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
