Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674E6C4727C
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 14:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED8372076B
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 14:36:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aXXmZ0eJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgI3OgC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 10:36:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730410AbgI3OgA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 10:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601476558;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/a9Tpj+6eiviKN9p7WLK/3O42gTjbbcwJ+HjUyyeSGY=;
        b=aXXmZ0eJbiriMhGoK1QEXjINBXrOcA8jvoXLJ2MtqcYfD3nOyjVK/gT798svvRNCuApCi4
        kdRiTl0B0qv4QcReTCq8SJRCan+8UBGxX2tQosBoY7z1sZpi5Q42f6gnzNX0rw3nddJe8p
        cdVq+FgKPxP+CqGLGWoxx6HkpSgBumw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-4J5aQA2gPfqxq8HFKRcBUQ-1; Wed, 30 Sep 2020 10:35:56 -0400
X-MC-Unique: 4J5aQA2gPfqxq8HFKRcBUQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F166B109106A;
        Wed, 30 Sep 2020 14:35:54 +0000 (UTC)
Received: from [10.10.110.11] (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A70B85D9D3;
        Wed, 30 Sep 2020 14:35:53 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-2-tasleson@redhat.com>
 <20200929175102.GA1613@infradead.org> <20200929180415.GA1400445@kroah.com>
 <20e220a6-4bde-2331-6e5e-24de39f9aa3b@redhat.com>
 <20200930073859.GA1509708@kroah.com>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <c6b031b8-f617-0580-52a5-26532da4ee03@redhat.com>
Date:   Wed, 30 Sep 2020 09:35:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200930073859.GA1509708@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/20 2:38 AM, Greg Kroah-Hartman wrote:
> On Tue, Sep 29, 2020 at 05:04:32PM -0500, Tony Asleson wrote:
>> I'm trying to figure out a way to positively identify which storage
>> device an error belongs to over time.
> 
> "over time" is not the kernel's responsibility.
> 
> This comes up every 5 years or so. The kernel provides you, at runtime,
> a mapping between a hardware device and a "logical" device.  It can
> provide information to userspace about this mapping, but once that
> device goes away, the kernel is free to reuse that logical device again.
> 
> If you want to track what logical devices match up to what physical
> device, then do it in userspace, by parsing the log files.

I don't understand why people think it's acceptable to ask user space to
parse text that is subject to change.

>> Thank you for supplying some feedback and asking questions.  I've been
>> asking for suggestions and would very much like to have a discussion on
>> how this issue is best solved.  I'm not attached to what I've provided.
>> I'm just trying to get towards a solution.
> 
> Again, solve this in userspace, you have the information there at
> runtime, why not use it?

We usually don't have the needed information if you remove the
expectation that user space should parse the human readable portion of
the error message.

>> We've looked at user space quite a bit and there is an inherit race
>> condition with trying to fetch the unique hardware id for a message when
>> it gets emitted from the kernel as udev rules haven't even run (assuming
>> we even have the meta-data to make the association).
> 
> But one moment later you do have the information, so you can properly
> correlate it, right?

We could have the information if all the storage paths went through
dev_printk.  Here is what we get today when we encounter a read error
which uses printk in the block layer:

{
        "_HOSTNAME" : "pn",
        "_TRANSPORT" : "kernel",
        "__MONOTONIC_TIMESTAMP" : "1806379233",
        "SYSLOG_IDENTIFIER" : "kernel",
        "_SOURCE_MONOTONIC_TIMESTAMP" : "1805611354",
        "SYSLOG_FACILITY" : "0",
        "MESSAGE" : "blk_update_request: critical medium error, dev
nvme0n1, sector 10000 op 0x0:(READ) flags 0x80700 phys_seg 3 prio class 0",
        "PRIORITY" : "3",
        "_MACHINE_ID" : "3f31a0847cea4c95b7a9cec13d07deeb",
        "__REALTIME_TIMESTAMP" : "1601471260802301",
        "_BOOT_ID" : "b03ed610f21d46ab8243a495ba5a0058",
        "__CURSOR" :
"s=a063a22bbb384da0b0412e8f652deabb;i=23c2;b=b03ed610f21d46ab8243a495ba5a0058;m=6bab28e1;t=5b087959e3cfd;x=20528862f8f765c9"
}

Unless you parse the message text you cannot make the association.  If
the same message was changed to dev_printk we would get:


{
        "__REALTIME_TIMESTAMP" : "1589401901093443",
        "__CURSOR" :
"s=caac9703b34a48fd92f7875adae55a2f;i=1c713;b=e2ae14a9def345aa803a13648b95429c;m=7d25b4f;t=5a58d77b85243;x=b034c2d3fb853870",
        "SYSLOG_IDENTIFIER" : "kernel",
        "_KERNEL_DEVICE" : "b259:917504",
        "__MONOTONIC_TIMESTAMP" : "131226447",
        "_UDEV_SYSNAME" : "nvme0n1",
        "PRIORITY" : "3",
        "_KERNEL_SUBSYSTEM" : "block",
        "_SOURCE_MONOTONIC_TIMESTAMP" : "130941917",
        "_TRANSPORT" : "kernel",
        "_MACHINE_ID" : "3f31a0847cea4c95b7a9cec13d07deeb",
        "_HOSTNAME" : "pn",
        "SYSLOG_FACILITY" : "0",
        "_BOOT_ID" : "e2ae14a9def345aa803a13648b95429c",
        "_UDEV_DEVLINK" : [
                "/dev/disk/by-uuid/22fc262a-d621-452a-a951-7761d9fcf0dc",
                "/dev/disk/by-path/pci-0000:00:05.0-nvme-1",

"/dev/disk/by-id/nvme-nvme.8086-4445414442454546-51454d55204e564d65204374726c-00000001",
                "/dev/disk/by-id/nvme-QEMU_NVMe_Ctrl_DEADBEEF"
        ],
        "MESSAGE" : "block nvme0n1: blk_update_request: critical medium
error, dev nvme0n1, sector 10000 op 0x0:(READ) flags 0x0 phys_seg 1 prio
class 0",
        "_UDEV_DEVNODE" : "/dev/nvme0n1"
}


Journald already knows how to utilize the dev_printk meta data.

One idea that I've suggested along the way is creating a dev_printk
function that doesn't change the message text.  We then avoid breaking
people that are parsing.  Is this something that would be acceptable to
folks?  It doesn't solve early boot where udev rules haven't even run,
but it's better.

Thanks,
Tony

