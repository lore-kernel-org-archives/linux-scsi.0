From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: An oops will occur while SCSI core is being used in 3.4-rc1
Date: Tue, 10 Apr 2012 11:51:18 -0500
Message-ID: <4F846506.4060801@cs.wisc.edu>
References: <CAAxnys5O7PfWYv0q+BvhK2CP7X-_pNRa4j-Z1gSWHqLm8D8XmA@mail.gmail.com> <4F83EC71.90904@acm.org> <4F8461E3.3050808@cs.wisc.edu> <4F846398.5030609@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42447 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab2DJQx3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Apr 2012 12:53:29 -0400
In-Reply-To: <4F846398.5030609@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Elric Fu <elricfu1@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Felipe Balbi <balbi@ti.com>, Alex He <alex.he@amd.com>, Andiry Xu <andiry.xu@amd.com>, Greg KH <gregkh@linuxfoundation.org>, Linux USB Mailing List <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On 04/10/2012 11:45 AM, Mike Christie wrote:
> On 04/10/2012 11:37 AM, Mike Christie wrote:
>> On 04/10/2012 03:16 AM, Bart Van Assche wrote:
>>> On 04/10/12 01:22, Elric Fu wrote:
>>>
>>>> After debugging the code, I found the issue happened while the driver ran to
>>>> line 782 in scsi_send_eh_cmnd().
>>>>
>>>>  778 static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>>>>  779                              int cmnd_size, int timeout, unsigned
>>>> sense_bytes)
>>>>  780 {
>>>>  781         struct scsi_device *sdev = scmd->device;
>>>>  782         struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>>>>  783         struct Scsi_Host *shost = sdev->host;
>>>>  784         DECLARE_COMPLETION_ONSTACK(done);
>>>>  785         unsigned long timeleft;
>>>>  786         struct scsi_eh_save ses;
>>>>  787         int rtn;
>>>>
>>>> I know the code is submitted by you. I don't familiar with the scsi core.
>>>> It seems like the conversion process from scsi command to scsi driver
>>>> encounter a NULL pointer. Any idea?
>>>
>>>
>>> I have observed crashes at the same point while testing device removal
>>> with the ib_srp driver. As far as I can see that code was added through
>>> commit 18a4d0a22ed6c54b67af7718c305cd010f09ddf8 (February 9, 2012). The
>>> approach of that patch looks questionable to me: what guarantees that
>>> the struct scsi_driver will be available at the time the SCSI error
>>> handler needs it ?
>>
>> If a scsi scan IO timesout then the driver will not be set yet. It is ok
>> to use scsi_cmd_to_driver in scsi_finish_cmd because of the req block pc
>> check (scsi scan IO set that flag and so do not hit that path).
> 
> I meant to say that all REQ_TYPE_BLOCK_PC will have a NULL driver, so at

That is wrong. I guess REQ_DISCARD and REQ_FLUSH will, so I guess we
just have to check for a NULL sdrv above.


> the very least there should be a check in scsi_send_eh_cmnd for NULL
> sdrv or for the IO being a REQ_TYPE_BLOCK_PC like is done in
> scsi_finish_command.
