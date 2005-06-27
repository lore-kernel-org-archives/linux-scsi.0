From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Question on "embedded" classes
Date: Mon, 27 Jun 2005 19:19:22 -0400
Message-ID: <42C0897A.8010705@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262118AbVF0XYY@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

I was wondering what the reason was for allowing
class and classdev to only be at level 3 and level
4 respectively of sysfs (/ is level 0)?

1) Some devices would not have any relevance
ouside the scope of the "parent" device.
2) "Hooking" them all at /sys/class/ level
would create quite a lot of symlinks (and with
cryptic names in order to reference the proper
"parent" device in the same directory).

E.g. Some devices, like SAS host adapters, have "devices
inside devices" and I'd like to represent this in
sysfs.

/sys/class/sas          (a class)
/sys/class/sas/ha0/     (a classdev)
/sys/class/sas/ha1/     (a classdev)

/sys/class/sas/ha0/device -> symlink to PCI device
/sys/class/sas/ha0/device_name    (text attribute)

/sys/class/sas/ha0/phys/     (a class)
/sys/class/sas/ha0/phys/0/   (a classdev)

etc.

Question: how does one "marry" the class to the classdev?

Or what is the alternative?

Thanks,
	Luben
