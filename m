From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Wed, 05 Jun 2002 21:08:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CFEB617.A9651F70@torque.net>
References: <20020605151336.A1139@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: sullivan <sullivan@austin.ibm.com>
Cc: linux-scsi@vger.kernel.org, mochel@osdl.org

sullivan wrote:
> 
> Thanks for your postings to the original RFC submitted under this subject. Based on your feedback two utilities are now available at http://oss.software.ibm.com/devreg/
> a. scsiname utility
>         - Makes sg calls to collect device info used to make naming decisions
>         - Hooked into the hotplug interface using Doug Gilbert's scsimon patch
>         - Targeted specifically to scsi devices
>         - Implemented completely in userspace
> 
> b. devnaming utility
>         - Utilizes Patrick Mochel's driverfs fs to collect device info
>         - Can easily be extended to support other device types (non scsi)
>         - Includes a kernel patch to create/publish device info in driverfs
>         - Hooked into hotplug interface using scsimon patch
> 
> Why two utilities? I see scsiname providing an immediate fix for 
> providing a persistent set of /dev scsi names across boots. The 
> devnaming utility is more long term in that it anticipates that 
> driverfs will evolve into providing the device information 
> necessary, removing the need for interfacing through sg. The config
> and hotplug portions of the utilities are consistent and should 
> (hopefully) provide a smooth migration path.
> 
> I'd appreciate feedback from anyone that has the interest and the 
> time to take a further look.

Mike,
Looks good.

I have just updated http://www.torque.net/scsi/scsimon.html
with a version of scsimon for lk 2.5.20 . The patch is
only supeficially different from the previous one (which still
applies with minor noise in drivers/scsi/Makefile ).

Your devnaming patch contains a kernel patch against lk 2.5.14 .
I noticed that driverfs changed in lk 2.5.20 and Patrick Moche
is proposing lots more changes soon (see lkml). Tracking it should
be "interesting". The PCI, USB and IDE subsystem currently have
slots for driverfs, although the PCI one seems to be the only one
active. Getting your driverfs changes for the scsi subsystem into 
Linus's tree may coerce Patrick into keeping the interface up to
date ...

The hotplug facilities that you are using in scsimon are probably
good candidates to go into the scsi mid level in lk 2.5 .

Doug Gilbert
