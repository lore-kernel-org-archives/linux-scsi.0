From: Daniel Mack <zonque-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Suspend issues with a LaCie USB hard disk connected
Date: Wed, 18 Dec 2013 17:22:52 +0100
Message-ID: <52B1CBDC.1070203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>, Aaron Lu <aaron.lu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

I'm facing an issue putting an embedded system to sleep while a Lacie
external USB hard disk is connected. Relevant kernel messages that occur
at the attempt are:

[   13.834731] PM: Sending message for entering DeepSleep mode
[   13.846575] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   13.858818] sd 0:0:0:0: [sda]
[   13.862432] Result: hostbyte=0x00 driverbyte=0x08
[   13.867349] sd 0:0:0:0: [sda]
[   13.870626] Sense Key : 0x5 [current]
[   13.874602] sd 0:0:0:0: [sda]
[   13.877879] ASC=0x20 ASCQ=0x0
[   13.885053] dpm_run_callback(): scsi_bus_suspend+0x0/0x20 returns -5
[   13.901130] PM: Device 0:0:0:0 failed to suspend async: error -5
[   13.907507] PM: Some devices failed to suspend, or early wake event
detected

What happens is that in sd_sync_cache(), scsi_execute_req_flags()
returns 0x08000002, so driver_byte(res) evaluates to DRIVER_SENSE and
host_byte(res) is DID_OK, which is an unhandled case that leads to -EIO
eventually.

I have admittedly not much clue about the SCSI layer, so I wonder what
would be the best way to fix this. Should DID_OK just be handled as
non-error condition in the switch? Should the suspend call chain ignore
such errors from sd_sync_cache()?

I'm open to suggestions and happy to test patches.


Thanks,
Daniel
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
