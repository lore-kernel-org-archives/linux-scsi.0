From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [REGRESSION 3.17] scsi (uas) disks no longer using tagged command
 queuing
Date: Wed, 10 Sep 2014 09:21:24 +0200
Message-ID: <540FFBF4.9090001@redhat.com>
References: <540EC52C.3000804@redhat.com> <20140909152730.GA17882@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140909152730.GA17882@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-usb <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 09/09/2014 05:27 PM, Christoph Hellwig wrote:
> On Tue, Sep 09, 2014 at 11:15:24AM +0200, Hans de Goede wrote:
>> Taking the uas.c file from 3.17, and building it for 3.16 restores
>> the use of tcq (debugged by adding a printk blk_rq_tagged + request->tag).
>>
>> So either uas is doing something wrong which happened to work in
>> 3.16, or something has broken in 3.17.
>>
>> I've already added debug printk-s of scsi_device->tagged_supported,
>> queue_depth, ordered_tags and simple_tags and those all look good
>> (1, 29, 1, 1).
>>
>> I've also tried setting disable_blk_mq and that does not help.
>>
>> Any hints to help debugging this further (other then a bisect) are
>> appreciated. If no-one has any smart ideas I guess I'll end up doing
>> a full bisect.
> 
> scsi-mq isn't enabled by default, so setting disable_blk_mq should
> indeed not make a difference.
> 
> One interesting thing with uas is that it uses scsi_init_shared_tag_map,
> which only few drivers do.
> 
> Can you apply a debug patch like the one below and see if that helps to
> poinpoint down the issue?

I've applied the patch, this results in the following new dmesg output
when using uas:

[  120.602632] initialized host-wide tag map!

Thank you for looking into this.

Regards,

Hans
