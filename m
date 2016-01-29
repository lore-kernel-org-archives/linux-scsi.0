From: Ruediger Meier <sweet_f_a-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: scsi_debug, iosize optimal < minimum (was: test sfdisk, optimal_iosize)
Date: Fri, 29 Jan 2016 17:18:20 +0100
Message-ID: <201601291718.21185.sweet_f_a@gmx.de>
References: <201601291131.29201.sweet_f_a@gmx.de> <20160129113110.o76pvon3wormblgd@ws.net.home> <201601291402.14306.sweet_f_a@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201601291402.14306.sweet_f_a-Mmb7MZpHnFY@public.gmane.org>
Content-Disposition: inline
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

I've noticed a possible problem with scsi_debug devices where
optimal_io_size < minimum_io_size.

The problem seems reproducable with kernel 4.4.0 and also with
stable version 4.1.15. For stable tree the last known working
version is 4.1.13.

How to reproduce:

uname -mr
modprobe -r scsi_debug 
modprobe scsi_debug dev_size_mb=100 sector_size=512
udevadm settle
devname=$(grep --with-filename scsi_debug /sys/block/*/device/model | awk -F '/' '{print $4}')
cat /sys/block/$devname/queue/{minimum_io_size,optimal_io_size}
modprobe -r scsi_debug


## output kernel 4.1.13 (openSUSE Leap):
4.1.13-5-default x86_64
512
32768


## output kernel 4.1.15 (openSUSE Leap):
4.1.15-8-default x86_64
512
64

cu,
Rudi
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
