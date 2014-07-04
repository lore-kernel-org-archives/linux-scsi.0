From: Maurizio Lombardi <mlombard-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Some question about usb scsi storage driver
Date: Fri, 04 Jul 2014 17:47:28 +0200
Message-ID: <53B6CC90.4070805@redhat.com>
References: <CANudz+sXH55BJDWf3zy18ERixQWDnqtfv7GHmHPsqqJG9EGyxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANudz+sXH55BJDWf3zy18ERixQWDnqtfv7GHmHPsqqJG9EGyxg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: loody <miloody-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



On 07/04/2014 04:44 PM, loody wrote:
> 
> 2. at the end of sd.c -> sd_probe, why we call async_schedule_domain like below
>       async_schedule_domain(sd_probe_async, sdkp, &scsi_sd_probe_domain);
>     to finish scsi device initialization?
>     Couldn't we put what sd_probe_async directly in sd_probe?
>     is there any benefit to do so?

A possible explanation may be that sd_probe_async() calls sd_spinup_disk(), this function spins up the drive and
may block for some seconds, so it is better to do that asynchronously.

Regards,
Maurizio Lombardi
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
