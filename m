Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6162C4727C
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 22:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 850042145D
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 22:04:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WBhHauvD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgI2WEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 18:04:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728169AbgI2WEk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 18:04:40 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601417078;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OB3ESLB6nEiZFjHHmb4cCVa9SrjhknJkIGtA5MjcRWA=;
        b=WBhHauvDv/h93CUz56e28ZFlyHFEl/WzGvVN/1PvFDQcPcaWEsnrsU/FTtL+gAU4Kc69j4
        XncfSXiiBPSuO4Vwt3pxRb+gzCy2z0oolE4vBYO4dUlfHa/Zof7kwE/TFpDf6qjVl8pyAi
        s2UEo1wHpMTc0NN3FrYURETUCOIT7AQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-0AsrE8_2Mdud1gobOU8Bng-1; Tue, 29 Sep 2020 18:04:36 -0400
X-MC-Unique: 0AsrE8_2Mdud1gobOU8Bng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE3AE87311B;
        Tue, 29 Sep 2020 22:04:34 +0000 (UTC)
Received: from [10.10.110.11] (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8884560C13;
        Tue, 29 Sep 2020 22:04:33 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-2-tasleson@redhat.com>
 <20200929175102.GA1613@infradead.org> <20200929180415.GA1400445@kroah.com>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Cc:     Hannes Reinecke <hare@suse.de>
Message-ID: <20e220a6-4bde-2331-6e5e-24de39f9aa3b@redhat.com>
Date:   Tue, 29 Sep 2020 17:04:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200929180415.GA1400445@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/20 1:04 PM, Greg Kroah-Hartman wrote:
> On Tue, Sep 29, 2020 at 06:51:02PM +0100, Christoph Hellwig wrote:
>> Independ of my opinion on the whole scheme that I shared last time,
>> we really should not bloat struct device with function pointers.

Christoph, thank you for sharing a bit more of your concerns and
bringing Greg into the discussion.  It's more productive.

>>
>> On Fri, Sep 25, 2020 at 11:19:18AM -0500, Tony Asleson wrote:
>>> Function callback and function to be used to write a persistent
>>> durable name to the supplied character buffer.  This will be used to add
>>> structured key-value data to log messages for hardware related errors
>>> which allows end users to correlate message and specific hardware.
>>>
>>> Signed-off-by: Tony Asleson <tasleson@redhat.com>
>>> ---
>>>  drivers/base/core.c    | 24 ++++++++++++++++++++++++
>>>  include/linux/device.h |  4 ++++
>>>  2 files changed, 28 insertions(+)
> 
> I can't find this patch anywhere in my archives, why was I not cc:ed on
> it?  It's a v5 and no one thought to ask the driver core
> developers/maintainers about it???

You were CC'd into v3, ref.

https://lore.kernel.org/linux-ide/20200714081750.GB862637@kroah.com/

I should have continued to CC you on it, sorry about that.


> {sigh}
> 
> And for log messages, what about the dynamic debug developers, why not
> include them as well?  Since when is this a storage-only thing?

Hannes Reinecke has been involved in the discussion some and he's
involved in dynamic debug AFAIK.

If others have a need to identify a specific piece of hardware in a
potential sea of identical hardware that is encountering errors and
logging messages and can optionally be added and removed at run-time,
then yes they should be included too.  There is nothing with this patch
series that is preventing any device from registering a callback which
provides this information when asked.


>>> diff --git a/include/linux/device.h b/include/linux/device.h
>>> index 5efed864b387..074125999dd8 100644
>>> --- a/include/linux/device.h
>>> +++ b/include/linux/device.h
>>> @@ -614,6 +614,8 @@ struct device {
>>>  	struct iommu_group	*iommu_group;
>>>  	struct dev_iommu	*iommu;
>>>  
>>> +	int (*durable_name)(const struct device *dev, char *buff, size_t len);
> 
> No, that's not ok at all, why is this even a thing?
> 
> Who is setting this?  Why can't the bus do this without anything
> "special" needed from the driver core?

I'm setting it in the different storage subsystems.  The intent is that
when we go through a common logging path eg. dev_printk you can ask the
device what it's ID is so that it can be logged as structured data with
the log message.  I was trying to avoid having separate logging
functions all over the place which enforces a consistent meta data to
log messages, but maybe that would be better than adding a function
pointer to struct device?  My first patch tried adding a call back to
struct device_type, but that ran into the issue where struct device_type
is static const in a number of areas.

Basically for any piece of hardware with a serial number, call this
function to get it.  That was the intent anyway.

> We have a mapping of 'struct device' to a unique hardware device at a
> specific point in time, why are you trying to create another one?

I don't think I'm creating anything new.  Can you clarify this a bit
more?  I'm trying to leverage what is already in place.

> What is wrong with what we have today?

I'm trying to figure out a way to positively identify which storage
device an error belongs to over time.  Logging how something is attached
and not what is attached, only solves for right now, this point in time.
 Additionally when the only identifier is in the actual message itself,
it makes user space break every time the message content changes.  Also
what we have today in dev_printk doesn't tag the meta-data consistently
for journald to leverage.

This patch series adds structured data to the log entry for positive
identification.  It doesn't change when the content of the log message
changes.  It's true over time and it's true if a device gets moved to a
different system.

> So this is a HARD NAK on this patch for now.

Thank you for supplying some feedback and asking questions.  I've been
asking for suggestions and would very much like to have a discussion on
how this issue is best solved.  I'm not attached to what I've provided.
I'm just trying to get towards a solution.


We've looked at user space quite a bit and there is an inherit race
condition with trying to fetch the unique hardware id for a message when
it gets emitted from the kernel as udev rules haven't even run (assuming
we even have the meta-data to make the association).  The last thing
people want to do is delay writing the log message to disk until the
device it belongs to can be identified.  Of course this patch series
still has a window from where the device is first discovered by the
kernel and fetches the needed vpd data from the device.  Any kernel
messages logged during that time have no id to associate with it.

Thanks,
Tony


