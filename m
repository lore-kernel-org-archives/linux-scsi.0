From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: An oops will occur while SCSI core is being used in 3.4-rc1
Date: Wed, 11 Apr 2012 20:48:59 -0400
Message-ID: <yq1y5q1ai6c.fsf@sermon.lab.mkp.net>
References: <CAAxnys5O7PfWYv0q+BvhK2CP7X-_pNRa4j-Z1gSWHqLm8D8XmA@mail.gmail.com>
	<4F83EC71.90904@acm.org> <4F8461E3.3050808@cs.wisc.edu>
	<4F846398.5030609@cs.wisc.edu> <4F846506.4060801@cs.wisc.edu>
	<yq18vi2ckrj.fsf@sermon.lab.mkp.net> <4F85B3E8.7040704@acm.org>
	<4F85E312.6070205@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F85E312.6070205-HInyCGIudOg@public.gmane.org> (Bart Van Assche's message of "Wed, 11
	Apr 2012 20:01:22 +0000")
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Elric Fu <elricfu1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>, Alex He <alex.he-5C7GfCeVMHo@public.gmane.org>, Andiry Xu <andiry.xu-5C7GfCeVMHo@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux USB Mailing List <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bart" == Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> writes:

Bart> That comment didn't make sense - request.rq_disk is not modified
Bart> after it has been initialized. 

Correct.


Bart> Yet it would make me more happy if scsi_send_eh_cmnd() could be
Bart> modified such that it doesn't have to access struct scsi_driver.

Well, the whole point of the original patch was that we wanted to enable
upper level drivers to interact with the current (SPC-centric) error
handling.

I understand your concern given the recent flurry of device lifetime
issues. But I think the issues my patch tries to tackle are important
enough to warrant the change. And we definitely don't want to start
mucking with block device-specific commands in the generic error
handling path.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
