From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] usb: uas: fix usb subsystem hang after power off hub port
Date: Mon, 08 Apr 2019 22:10:19 -0400
Message-ID: <yq1a7h0orn8.fsf@oracle.com>
References: <Pine.LNX.4.44L0.1904041522150.1288-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1904041522150.1288-100000@iolanthe.rowland.org>
        (Alan Stern's message of "Thu, 4 Apr 2019 15:33:38 -0400 (EDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kento.A.Kobayashi@sony.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Oliver Neukum <oneukum@suse.com>, gregkh@linuxfoundation.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Jacky.Cao@sony.com, Kernel development list <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Alan,

> So it looks as though the SCSI subsystem doesn't like to have a reset 
> handler call scsi_remove_host.

Are you talking about a PCI device removal handler or a SCSI error
handler?

> Commands dispatched by the removal routines are forced to wait for the
> reset recovery to finish, which won't happen until those commands have
> been completed.
>
> Is this a bug in the SCSI core?  If not, we need to know what is the
> right way to do things when a reset handler detects that the SCSI host
> has been hot-unplugged.

PCI surprise removal should generally work. But it's somewhat unusual
for a SCSI host to evaporate in the middle of error handling. After all,
the main purpose of eh is to leverage the interfaces provided by the
host to try to reconnect to a target that tripped and fell off the
bus...

-- 
Martin K. Petersen	Oracle Linux Engineering
