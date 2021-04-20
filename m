Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6C1C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 17:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80581613B2
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 17:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhDTRUV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:20:21 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:33844 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhDTRUU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 13:20:20 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id AFB9D2EA2F4;
        Tue, 20 Apr 2021 13:19:48 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id inmmXEXVDoIy; Tue, 20 Apr 2021 13:00:06 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 40CF62EA06B;
        Tue, 20 Apr 2021 13:19:47 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 000/117] Make better use of static type checking
To:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <7eaf77e8-ca4f-c0db-e94a-5fa3e16e3b51@suse.de>
 <5c194446-e145-9d6d-3bc2-23254f0058b9@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <18b8e96a-ced3-8ce9-15d0-4705da54e83b@interlog.com>
Date:   Tue, 20 Apr 2021 13:19:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5c194446-e145-9d6d-3bc2-23254f0058b9@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-20 12:12 p.m., Bart Van Assche wrote:
> On 4/19/21 11:04 PM, Hannes Reinecke wrote:
>> We should not try to preserve the split SCSI result value with its four
>> distinct fields.
> 
> I don't think that we have the freedom to drop the four byte SCSI result
> entirely since multiple user space APIs use that data structure. The
> four-byte SCSI result value is embedded in the following user space API
> data structures (there may be others):
> * struct sg_io_v4, the SG_IO header includes the driver_status
> (driver_byte()), transport_status (host_byte()) and device_status
> (scsi_status & 0xff) (the message byte is not included).

The sg_io_v4 interface was specifically designed to _decouple_ the
user visible API from the kernel's 4-bytes-in-1-int representation.
So there are 4 levels of error reporting supported:
    1) from the kernel front-end: yield an errno
    2) from the driver (LLD): set driver_status
    3) from the transport: set transport status
    4) from the device (target or LU): set device_status

Those distinctions aren't that strict, there is some overlap (e.g.
timeouts). The sg version 3 interface (struct sg_io_hdr) is similar
but the names are less generic.

Can't remember if anyone every complained to me about not having
access to the message byte from SPI.

Doug Gilbert
