From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Updated linux uas driver, please test
Date: Wed, 10 Sep 2014 14:13:36 +0200
Message-ID: <54104070.20606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: daveiro-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, tuxoko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sumit.tiwari1943-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, wolput-eWKpJWsLgTg@public.gmane.org, claudio.bizzarri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-usb <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi All,

I'm mailing all of you because you've reported various problems
with the new uas support in kernel 3.16 and later.

I've been working on making the uas driver more resilient to
errors, as well as improved logging so we can easier figure
out the cause of errors.

I would like to ask you all to test a standalone version of
the new uas driver with the devices you've been having
trouble with before, and report the results to me.

Testing instructions:

1) Remove any usb-storage.quirks= setting from the kernel commandline,
and remove any /etc/modprobe.conf* files doing the same, boot your
machine without the uas device attached.

2) Make sure your machine is set up for building kernel modules,
usually this means installing kernel-devel and gcc packages, see
your distributions documentation for more info

3) Download all files from here:
https://fedorapeople.org/~jwrdegoede/uas/
And put them all in a single directory, named e.g. uas

4) Start a terminal, cd into the uas directory

5) Run the following commands:
make
sudo rmmod uas
sudo insmod ./uas.ko

6) Connect your uas device

7) Wait for the disk to show up (wait circa 1 minute max), then do:

dmesg > dmesg.log
lsusb -v > lsusb.log

8) Test the uas disk

Once done please send me a mail, in this mail please

1) Describe how the disk worked, did it show up in a reasonable time,
and did it work?

2) Attach dmesg.log and lsusb.log

Thanks & Regards,

Hans

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
