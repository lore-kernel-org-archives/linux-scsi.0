From: loody <miloody-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Some question about usb scsi storage driver
Date: Fri, 4 Jul 2014 22:44:55 +0800
Message-ID: <CANudz+sXH55BJDWf3zy18ERixQWDnqtfv7GHmHPsqqJG9EGyxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

hi all:
when I trace kernel driver source about usb scsi storage driver, I
have below 2 questions:
1. in sd.c -> static int sd_probe(struct device *dev)
    we use below macro to get scsi_device.
           struct scsi_device *sdp = to_scsi_device(dev);

    take usb for example, is usb storage driver allocate memory for
scsi_device then calling sd_probe?
    I am looking for usb_stor_probe1 and usb_stor_probe2 but not find
where it is.

2. at the end of sd.c -> sd_probe, why we call async_schedule_domain like below
      async_schedule_domain(sd_probe_async, sdkp, &scsi_sd_probe_domain);
    to finish scsi device initialization?
    Couldn't we put what sd_probe_async directly in sd_probe?
    is there any benefit to do so?

-- 
Regards,
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
