From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: An oops will occur while SCSI core is being used in 3.4-rc1
Date: Tue, 10 Apr 2012 11:45:12 -0500
Message-ID: <4F846398.5030609@cs.wisc.edu>
References: <CAAxnys5O7PfWYv0q+BvhK2CP7X-_pNRa4j-Z1gSWHqLm8D8XmA@mail.gmail.com> <4F83EC71.90904@acm.org> <4F8461E3.3050808@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F8461E3.3050808-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Elric Fu <elricfu1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>, Alex He <alex.he-5C7GfCeVMHo@public.gmane.org>, Andiry Xu <andiry.xu-5C7GfCeVMHo@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux USB Mailing List <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 04/10/2012 11:37 AM, Mike Christie wrote:
> On 04/10/2012 03:16 AM, Bart Van Assche wrote:
>> On 04/10/12 01:22, Elric Fu wrote:
>>
>>> After debugging the code, I found the issue happened while the driver ran to
>>> line 782 in scsi_send_eh_cmnd().
>>>
>>>  778 static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>>>  779                              int cmnd_size, int timeout, unsigned
>>> sense_bytes)
>>>  780 {
>>>  781         struct scsi_device *sdev = scmd->device;
>>>  782         struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>>>  783         struct Scsi_Host *shost = sdev->host;
>>>  784         DECLARE_COMPLETION_ONSTACK(done);
>>>  785         unsigned long timeleft;
>>>  786         struct scsi_eh_save ses;
>>>  787         int rtn;
>>>
>>> I know the code is submitted by you. I don't familiar with the scsi core.
>>> It seems like the conversion process from scsi command to scsi driver
>>> encounter a NULL pointer. Any idea?
>>
>>
>> I have observed crashes at the same point while testing device removal
>> with the ib_srp driver. As far as I can see that code was added through
>> commit 18a4d0a22ed6c54b67af7718c305cd010f09ddf8 (February 9, 2012). The
>> approach of that patch looks questionable to me: what guarantees that
>> the struct scsi_driver will be available at the time the SCSI error
>> handler needs it ?
> 
> If a scsi scan IO timesout then the driver will not be set yet. It is ok
> to use scsi_cmd_to_driver in scsi_finish_cmd because of the req block pc
> check (scsi scan IO set that flag and so do not hit that path).

I meant to say that all REQ_TYPE_BLOCK_PC will have a NULL driver, so at
the very least there should be a check in scsi_send_eh_cmnd for NULL
sdrv or for the IO being a REQ_TYPE_BLOCK_PC like is done in
scsi_finish_command.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
