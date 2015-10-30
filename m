From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: Blk-mq/scsi-mq Tuning
Date: Fri, 30 Oct 2015 10:12:53 -0400
Message-ID: <alpine.OSX.2.00.1510301010550.4888@administrators-macbook-pro.local>
References: <D256A425.229C0%chad.dupuis@qlogic.com> <56331FFB.9010703@suse.de> <alpine.OSX.2.00.1510300919390.2511@administrators-macbook-pro.local> <563372CB.9050206@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-91181859-1446214376=:4888"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:59918 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031361AbbJ3ONP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 10:13:15 -0400
In-Reply-To: <563372CB.9050206@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "bvanassche@acm.org" <bvanassche@acm.org>, "hch@lst.de" <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Nilesh Javali <nilesh.javali@qlogic.com>

--0-91181859-1446214376=:4888
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT



On Fri, 30 Oct 2015, Hannes Reinecke wrote:

> On 10/30/2015 02:25 PM, Chad Dupuis wrote:
>>
>>
>> On Fri, 30 Oct 2015, Hannes Reinecke wrote:
>>
>>> On 10/28/2015 09:11 PM, Chad Dupuis wrote:
>>>> Hi Folks,
>>>>
>>>> We¹ve begun to explore blk-mq and scsi-mq and wanted to know if there
>>>> were
>>>> any best practices in terms of block layer settings.  We¹re looking
>>>> specifically at the FCoE and iSCSI protocols.
>>>>
>>>> A little background on the queues in our hardware first: we have a per
>>>> connection transmit queue and multiple, global receive queues.  The
>>>> transmit queues are not pegged to a particular CPU.  The receive queues
>>>> are pegged to the first N CPUs where N is the number of receive queues.
>>>> We set the nr_hw_queues in the scsi_host_template to N as well.
>>>>
>>> Weelll ... I think you'll run into issues here.
>>> The whole point of the multiqueue implementation is that you can tag the
>>> submission _and_ completion queue to a single CPU, thereby eliminating
>>> locking.
>>> If you only peg the completion queue to a CPU you'll still have
>>> contention on the submission queue, needing to take locks etc.
>>>
>>> Plus you will _inevitably_ incur cache misses, as the completion will
>>> basically never occur on the same CPU which did the submissoin.
>>> Hence the context needs to be bounced to the CPU holding the completion
>>> queue, or you'll need to do a IPI to inform the submitting CPU.
>>> But if you do that you're essentially doing single-queue submission,
>>> so I doubt we're seeing that great improvements.
>>
>> This was why I was asking if there was a blk-mq API to be able to set
>> CPU affinity for the hardware context queues so I could steer the
>> submissions to the CPUs that my receive queues are on (even if they are
>> allowed to float).
>>
> But what would that achieve?
> Each of the hardware context queues would still having to use the
> same submission queue, so you'd have to have some serialisation
> with spinlocks et.al. during submission. Which is what blk-mq
> tries to avoid.
> Am I wrong?

Sadly, no I believe you're correct. So essentially the upshot seems to be 
if you can have a 1x1 request:response queue then sticking with the older 
queuecommand method is better?

>
> Cheers,
>
> Hannes
>
--0-91181859-1446214376=:4888--
