From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC] yet more struct scsi_lun
Date: Fri, 28 Oct 2005 12:24:19 -0500
Message-ID: <43625EC3.9060708@cs.wisc.edu>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023070011.GA26569@havoc.gtf.org> <435B6A62.8070306@torque.net> <435BBD9A.80603@pobox.com> <20051024075934.GK2811@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:1685 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751662AbVJ1T1i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 15:27:38 -0400
In-Reply-To: <20051024075934.GK2811@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, dougg@torque.net, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Sun, Oct 23 2005, Jeff Garzik wrote:
> 
>>Douglas Gilbert wrote:
>>
>>>Which in turn makes me think of applying the same idea
>>>to max_sectors
>>>
>>>       shost->max_sectors = MAX_512B_SECTORS_UNLIMITED;
>>
>>
>>Won't work.  max_sectors is communicated to the block layer, where we 
>>limit the overall size of the request for practical reasons.
>>
>>Read the comment in libata-scsi's slave_configure:
>>
>>                /* TODO: 1024 is an arbitrary number, not the
>>                 * hardware maximum.  This should be increased to
>>                 * 65534 when Jens Axboe's patch for dynamically
>>                 * determining max_sectors is merged.
>>                 */
>>
>>Right now, setting the true hardware / command set maximum would use way 
>>too much memory, with no way to get feedback from the VM.
>>
>>This is why SCSI_DEFAULT_MAX_SECTORS is defined to 1024.
> 
> 
> The block layer has had split values for quite some time, ->max_sectors
> and max_hw_sectors. scsi_ioctl.c needs a patch to look at max_hw_sectors
> instead and SCSI drivers could then easily be updated to advertise a
> real hardware value as well. That is what shost->max_sectors should be,
> SCSI mid layer would then set q->max_sectors to SCSI_DEFAULT_MAX_SECTORS
> and q->max_hw_sectors to shost->max_sectors.
> 
> Then the limiting factor becomes BIO_MAX_PAGES for mapping in the user
> data, which caps us at 1MiB currently.
> 

I was just wondering if you give a little more detail in case someone 
wanted to implement this for you.

Would the bio functions like __bio_add_page() and bio_get_nr_vecs() 
continue to test against q->max_sectors. And then have the request 
merging code test against q->max_hw_sectors. scsi or blk would need some 
check that max_sectors was not larger than max_sectors, and for scsi we 
would have to increase SCSI_DEFAULT_MAX_SECTORS to 2048 to match the 
1MiB limit and not make q->max_sectors the limit factor. Or how would 
this work?

