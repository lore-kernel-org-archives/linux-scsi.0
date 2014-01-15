From: Daniel Mack <zonque-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Suspend issues with a LaCie USB hard disk connected
Date: Wed, 15 Jan 2014 11:58:55 +0100
Message-ID: <52D669EF.30405@gmail.com>
References: <Pine.LNX.4.44L0.1312181542280.1029-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1312181542280.1029-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>, Aaron Lu <aaron.lu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sven Neumann <s.neumann-5g8ninUHluJWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

Sorry for the long, primarily holiday-related delay on this.

On 12/18/2013 09:46 PM, Alan Stern wrote:
> On Wed, 18 Dec 2013, Daniel Mack wrote:
>> I'm facing an issue putting an embedded system to sleep while a Lacie
>> external USB hard disk is connected. Relevant kernel messages that occur
>> at the attempt are:
>>
>> [   13.834731] PM: Sending message for entering DeepSleep mode
>> [   13.846575] sd 0:0:0:0: [sda] Synchronizing SCSI cache
>> [   13.858818] sd 0:0:0:0: [sda]
>> [   13.862432] Result: hostbyte=0x00 driverbyte=0x08
>> [   13.867349] sd 0:0:0:0: [sda]
>> [   13.870626] Sense Key : 0x5 [current]
>> [   13.874602] sd 0:0:0:0: [sda]
>> [   13.877879] ASC=0x20 ASCQ=0x0
>> [   13.885053] dpm_run_callback(): scsi_bus_suspend+0x0/0x20 returns -5
>> [   13.901130] PM: Device 0:0:0:0 failed to suspend async: error -5
>> [   13.907507] PM: Some devices failed to suspend, or early wake event
>> detected
>>
>> What happens is that in sd_sync_cache(), scsi_execute_req_flags()
>> returns 0x08000002, so driver_byte(res) evaluates to DRIVER_SENSE and
>> host_byte(res) is DID_OK, which is an unhandled case that leads to -EIO
>> eventually.
>>
>> I have admittedly not much clue about the SCSI layer, so I wonder what
>> would be the best way to fix this. Should DID_OK just be handled as
>> non-error condition in the switch? Should the suspend call chain ignore
>> such errors from sd_sync_cache()?
>>
>> I'm open to suggestions and happy to test patches.
> 
> The Sense Key and ASC values indicate that the drive did not understand
> the SYNCHRONIZE CACHE command.  A usbmon trace would verify this; see
> the instructions in Documentation/usb/usbmon.txt.
> 
> Assuming that really is what happened, we have to decide how to handle 
> the situation.

Ok, this is the usbmon trace that I captured when the system goes to
suspend with the USB storage media connected but unmounted:

cebe5e00 3629314504 S Bo:1:003:2 -115 31 = 55534243 10000000 00000000
00000a35 00000000 00000000 00000000 000000
cebe5e00 3629315214 C Bo:1:003:2 0 31 >
cebe5e00 3629315413 S Bi:1:003:1 -115 13 <
cebe5e00 3629315492 C Bi:1:003:1 0 13 = 55534253 10000000 00000000 01
cebe5e00 3629315571 S Bo:1:003:2 -115 31 = 55534243 11000000 12000000
80000603 00000012 00000000 00000000 000000
cebe5e00 3629315606 C Bo:1:003:2 0 31 >
cecd4580 3629315681 S Bi:1:003:1 -115 18 <
cecd4580 3629315744 C Bi:1:003:1 0 18 = 70000500 0000000a 00000000
20000000 0000
cebe5e00 3629315772 S Bi:1:003:1 -115 13 <
cebe5e00 3629315817 C Bi:1:003:1 0 13 = 55534253 11000000 00000000 00
cebe5e00 3629319750 S Bo:1:003:2 -115 31 = 55534243 12000000 00000000
00000a35 00000000 00000000 00000000 000000
cebe5e00 3629319826 C Bo:1:003:2 0 31 >
cebe5e00 3629319856 S Bi:1:003:1 -115 13 <
cebe5e00 3629319910 C Bi:1:003:1 0 13 = 55534253 12000000 00000000 01
cebe5e00 3629319964 S Bo:1:003:2 -115 31 = 55534243 13000000 12000000
80000603 00000012 00000000 00000000 000000
cebe5e00 3629319996 C Bo:1:003:2 0 31 >
cecd4300 3629320026 S Bi:1:003:1 -115 18 <
cecd4300 3629320086 C Bi:1:003:1 0 18 = 70000500 0000000a 00000000
20000000 0000
cebe5e00 3629320111 S Bi:1:003:1 -115 13 <
cebe5e00 3629320152 C Bi:1:003:1 0 13 = 55534253 13000000 00000000 00
cebe5e00 3629320360 S Bo:1:003:2 -115 31 = 55534243 14000000 00000000
00000a35 00000000 00000000 00000000 000000
cebe5e00 3629320610 C Bo:1:003:2 0 31 >
cebe5e00 3629320670 S Bi:1:003:1 -115 13 <
cebe5e00 3629320714 C Bi:1:003:1 0 13 = 55534253 14000000 00000000 01
cebe5e00 3629320752 S Bo:1:003:2 -115 31 = 55534243 15000000 12000000
80000603 00000012 00000000 00000000 000000
cebe5e00 3629320809 C Bo:1:003:2 0 31 >
cecd4300 3629320834 S Bi:1:003:1 -115 18 <
cecd4300 3629320863 C Bi:1:003:1 0 18 = 70000500 0000000a 00000000
20000000 0000
cebe5e00 3629320885 S Bi:1:003:1 -115 13 <
cebe5e00 3629320923 C Bi:1:003:1 0 13 = 55534253 15000000 00000000 00
ceb36280 3629350243 C Ii:1:001:1 -2:2048 0
cecd4800 3630011191 S Ci:1:001:0 s a3 00 0000 0001 0004 4 <
cecd4800 3630011333 C Ci:1:001:0 0 4 = 07051200
cecd4800 3630011574 S Co:1:001:0 s 23 01 0011 0001 0000 0
cecd4800 3630011699 C Co:1:001:0 0 0
cecd4800 3630011745 S Co:1:001:0 s 23 01 0014 0001 0000 0
cecd4800 3630011789 C Co:1:001:0 0 0
ceb36280 3630112579 S Ii:1:001:1 -115:2048 4 <
cecd4500 3630112825 S Ci:1:001:0 s a3 00 0000 0001 0004 4 <
cecd4500 3630112952 C Ci:1:001:0 0 4 = 07050000
cecd4500 3630113001 S Co:1:001:0 s 23 01 0002 0001 0000 0
cecd4500 3630113084 C Co:1:001:0 0 0
ceb36280 3630122552 C Ii:1:001:1 0:2048 1 = 02
ceb36280 3630122566 S Ii:1:001:1 -115:2048 4 <
cecd4500 3630152573 S Ci:1:001:0 s a3 00 0000 0001 0004 4 <
cecd4500 3630152625 C Ci:1:001:0 0 4 = 03050000
cecd4500 3630172588 S Ci:1:003:0 s 80 00 0000 0000 0002 2 <
cecd4500 3630172603 E Ci:1:003:0 -19 0
cecd4500 3630172744 S Co:1:001:0 s 23 03 0004 0001 0000 0
cecd4500 3630184219 C Co:1:001:0 0 0
cecd4500 3630242590 S Ci:1:001:0 s a3 00 0000 0001 0004 4 <
cecd4500 3630242657 C Ci:1:001:0 0 4 = 13050000
cecd4500 3630302564 S Ci:1:001:0 s a3 00 0000 0001 0004 4 <
cecd4500 3630302609 C Ci:1:001:0 0 4 = 13050000
ceb36280 3630315035 C Ii:1:001:1 0:2048 1 = 02

FWIW, the following patch seems to work fine on our machines, but as I
said, I'm uncertain wrt to whether that's the right approach.


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 69725f7..ec99787 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1469,6 +1469,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
                                return 0;

                switch (host_byte(res)) {
+               case DID_OK:
                /* ignore errors due to racing a disconnection */
                case DID_BAD_TARGET:
                case DID_NO_CONNECT:


Thanks,
Daniel

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
