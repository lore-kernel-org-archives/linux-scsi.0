From: "Lev A. Melnikovsky" <melnikovsky-JGs/UdohzUI@public.gmane.org>
Subject: Re: reading errors on JMicron JM20337 USB-SATA
Date: Tue, 4 Aug 2009 22:11:08 +0400 (MSD)
Message-ID: <alpine.LFD.2.00.0908042155580.6078@nev.ubzr>
References: <Pine.LNX.4.44L0.0908031539161.2888-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0908031539161.2888-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Artur Skawina <art.08.09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello,

I was advised to move this thread [ http://marc.info/?t=124916632000003&r=1&w=2 ]
to the linux-scsi mailing list. In my opinion the original problem 
descriptions can be considered as a follow-up to a year old thread on 
"JMicron JM20337 USB-SATA data corruption bugfix" [ http://marc.info/?l=linux-kernel&m=121653150327283&w=2 ].
The JMicron bridge is connected to a SATA disk with genuine errors (bad 
sectors, just in case: I am not going to use it but to recover some data 
from it). Unfortunately when a bad block is read no error is returned, 
instead a caller is blocked indefinitely (at least for two hours or until 
the USB cable is removed). The system log is filled with repetitive

sd 3:0:0:0: [sdf] Sense Key : 0x0 [current]
sd 3:0:0:0: [sdf] ASC=0x0 ASCQ=0x0

Alan Stern has suggested that this should be fixed as following:

AS> Tell them that scsi_end_request() mustn't call scsi_requeue_command() 
AS> if bytes == 0.

Is this the right thing to do?

Thanks
-L

P.S. Please let me know if the CC: list is too long.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
