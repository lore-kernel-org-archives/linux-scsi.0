From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: Blk-mq/scsi-mq Tuning
Date: Fri, 30 Oct 2015 09:25:19 -0400
Message-ID: <alpine.OSX.2.00.1510300919390.2511@administrators-macbook-pro.local>
References: <D256A425.229C0%chad.dupuis@qlogic.com> <56331FFB.9010703@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1922859884-1446211522=:2511"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:16365 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932230AbbJ3NZj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 09:25:39 -0400
In-Reply-To: <56331FFB.9010703@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "bvanassche@acm.org" <bvanassche@acm.org>, "hch@lst.de" <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Nilesh Javali <nilesh.javali@qlogic.com>

--0-1922859884-1446211522=:2511
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT



On Fri, 30 Oct 2015, Hannes Reinecke wrote:

> On 10/28/2015 09:11 PM, Chad Dupuis wrote:
>> Hi Folks,
>>
>> We¹ve begun to explore blk-mq and scsi-mq and wanted to know if there were
>> any best practices in terms of block layer settings.  We¹re looking
>> specifically at the FCoE and iSCSI protocols.
>>
>> A little background on the queues in our hardware first: we have a per
>> connection transmit queue and multiple, global receive queues.  The
>> transmit queues are not pegged to a particular CPU.  The receive queues
>> are pegged to the first N CPUs where N is the number of receive queues.
>> We set the nr_hw_queues in the scsi_host_template to N as well.
>>
> Weelll ... I think you'll run into issues here.
> The whole point of the multiqueue implementation is that you can tag the
> submission _and_ completion queue to a single CPU, thereby eliminating
> locking.
> If you only peg the completion queue to a CPU you'll still have
> contention on the submission queue, needing to take locks etc.
>
> Plus you will _inevitably_ incur cache misses, as the completion will
> basically never occur on the same CPU which did the submissoin.
> Hence the context needs to be bounced to the CPU holding the completion
> queue, or you'll need to do a IPI to inform the submitting CPU.
> But if you do that you're essentially doing single-queue submission,
> so I doubt we're seeing that great improvements.

This was why I was asking if there was a blk-mq API to be able to set CPU 
affinity for the hardware context queues so I could steer the submissions 
to the CPUs that my receive queues are on (even if they are allowed to 
float).

>> In our initial testing we¹re not seeing the performance scale as we would
>> expect so we wanted to see if there some Œknobs¹ if you will that we could
>> try tuning to try to increase the performance.  Also, one question we did
>> have is there an official API to be able to set the CPU affinity of the
>> hw_ctx_queues?
>>
> As above, given the underlying design I'm not surprised.
>
> But above you mentioned 'per-connection submission queues'; from which
> one could infer that there are several _hardware_ submission queues?
> If so, _maybe_ we should look into doing MC/S (in the iSCSI case),
> which would allow us to keep the 1:1 submission/completion ratio
> preferred by blk-mq and still use several queues ... Hmm?

Yes, each connection has a transmit queue.

>
> Cheers,
>
> Hannes
>
--0-1922859884-1446211522=:2511--
