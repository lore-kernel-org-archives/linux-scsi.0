From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 16 Jan 2003 12:40:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2718A0.5020905@pacbell.net>
References: <10426732153816@kroah.com> <10426732212871@kroah.com>
 <20030116093112.B29001@one-eyed-alien.net> <20030116173539.GA31235@kroah.com>
 <20030116114323.C29001@one-eyed-alien.net> <20030116195306.GA32697@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=------------030306080402030805000802
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030306080402030805000802
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Greg KH wrote:
> On Thu, Jan 16, 2003 at 11:43:23AM -0800, Matthew Dharm wrote:
> 
>>Well, we only create the host when the device is first attached.  After
>>that, if it goes away and comes back, we re-connect it to the old SCSI
>>host.
> 
> 
> Ick, so when the device is gone, where does the SCSI host go?  Is it
> still represented in sysfs and in the SCSI core properly?

Just for the record ... I think usb-storage is the only USB driver
that tries to keep state about devices across disconnect/reconnect.

I agree with Greg that hotplugging (including unplug/replug) should
work well with SCSI.  But given the problems of determining "identity"
of a disk (or volume or whatever) I'm sort of curious what working
well should really mean.

Have any of the SCSI people been looking much at SCSI hotplug on 2.5?
I attach "/etc/hotplug/scsi.agent" from one of my desktops; all it
does is make sure the right drivers are loaded, it doesn't have a
clue yet about whether/how/where to mount disks or do other stuff.

- Dave


--------------030306080402030805000802
Content-Type: text/plain;
 name="scsi.agent"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi.agent"

#!/bin/bash
#
# SCSI hotplug agent for 2.5 kernels 
#
#	ACTION=add
#	DEVPATH=devices/scsi0/0:0:0:0
#

cd /etc/hotplug
. hotplug.functions

case $ACTION in

add)
    # 2.5.50 kernel bug: this happens sometimes
    if [ ! -d /sys/$DEVPATH ]; then
	mesg "bogus sysfs DEVPATH=$DEVPATH"
	exit 1
    fi

    TYPE=$(cat /sys/$DEVPATH/type)
    case "$TYPE" in
    # 2.5.51 style attributes; <scsi/scsi.h> TYPE_* constants
    0)		TYPE=disk ; MODULE=sd_mod ;;
    # FIXME some tapes use 'osst' not 'st'
    1)		TYPE=tape ; MODULE=st ;;
    2)		TYPE=printer ;;
    3)		TYPE=processor ;;
    4)		TYPE=worm ; MODULE=sr_mod ;;
    5)		TYPE=cdrom ; MODULE=sr_mod ;;
    6)		TYPE=scanner ;;
    7)		TYPE=mod ; MODULE=sd_mod ;;
    8)		TYPE=changer ;;
    9)		TYPE=comm ;;
    14)		TYPE=enclosure ;;
    esac
    if [ "$MODULE" != "" ]; then
	mesg "$TYPE at $DEVPATH"
	modprobe $MODULE
    else
	mesg "how to add device type=$TYPE at $DEVPATH ??"
    fi
    ;;

*)
    debug_mesg SCSI $ACTION event not supported
    exit 1
    ;;

esac

--------------030306080402030805000802--

