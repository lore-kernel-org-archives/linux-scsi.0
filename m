From: "Rustad, Mark D" <mark.d.rustad@intel.com>
Subject: Re: An oops will occur while SCSI core is being used in 3.4-rc1
Date: Fri, 13 Apr 2012 00:30:28 +0000
Message-ID: <A9180604-6CE7-401D-933D-D3487BD10996@intel.com>
References: <CAAxnys5O7PfWYv0q+BvhK2CP7X-_pNRa4j-Z1gSWHqLm8D8XmA@mail.gmail.com>
 <4F83EC71.90904@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58899 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab2DMAaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2012 20:30:30 -0400
In-Reply-To: <4F83EC71.90904@acm.org>
Content-Language: en-US
Content-ID: <835E112E9992194FAD2FBE52DC3AEB23@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Elric Fu <elricfu1@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <JBottomley@Parallels.com>, "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Felipe Balbi <balbi@ti.com>, Alex He <alex.he@amd.com>, Andiry Xu <andiry.xu@amd.com>, Greg KH <gregkh@linuxfoundation.org>, Linux USB Mailing List <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Apr 10, 2012, at 1:16 AM, Bart Van Assche wrote:

> On 04/10/12 01:22, Elric Fu wrote:
> 
>> After debugging the code, I found the issue happened while the driver ran to
>> line 782 in scsi_send_eh_cmnd().
>> 
>> 778 static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>> 779                              int cmnd_size, int timeout, unsigned
>> sense_bytes)
>> 780 {
>> 781         struct scsi_device *sdev = scmd->device;
>> 782         struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>> 783         struct Scsi_Host *shost = sdev->host;
>> 784         DECLARE_COMPLETION_ONSTACK(done);
>> 785         unsigned long timeleft;
>> 786         struct scsi_eh_save ses;
>> 787         int rtn;
>> 
>> I know the code is submitted by you. I don't familiar with the scsi core.
>> It seems like the conversion process from scsi command to scsi driver
>> encounter a NULL pointer. Any idea?
> 
> I have observed crashes at the same point while testing device removal
> with the ib_srp driver. As far as I can see that code was added through
> commit 18a4d0a22ed6c54b67af7718c305cd010f09ddf8 (February 9, 2012). The
> approach of that patch looks questionable to me: what guarantees that
> the struct scsi_driver will be available at the time the SCSI error
> handler needs it ? At least the sd driver explicitly resets that pointer
> in its scsi_disk_release() function.

I am looking into a similar crash with FCoE, though in my case it is the private_data field that is NULL instead of rq_disk. The backtraces are very much like what has been reported here. I will try adding some NULL checks similar to what has been proposed on the list, but until I know more than I do now, I won't let myself believe that NULL checks are the real fix for this issue.

-- 
Mark Rustad, LAN Access Division, Intel Corporation

