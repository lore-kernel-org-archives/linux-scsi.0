From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] SCSI: SD: set max_ws_blocks as max_unmap_blocks if it
 isn't provided
Date: Sat, 6 Dec 2014 00:21:52 +0800
Message-ID: <CACVXFVPNEnCXz5m5KOvZN1tTqjpeqr6C7dA-5OvLbOF3SZ75zQ@mail.gmail.com>
References: <1417782952-19908-1-git-send-email-ming.lei@canonical.com>
	<yq1r3wefe6o.fsf@sermon.lab.mkp.net>
	<CACVXFVMB4GT2XewVh3CbamJUqb2VbaW=4yxJnQjw39z1rBgdNw@mail.gmail.com>
	<5481D415.3070102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36506 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaLEQVz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2014 11:21:55 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43])
	by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.71)
	(envelope-from <ming.lei@canonical.com>)
	id 1Xwvdh-0000cq-Ql
	for linux-scsi@vger.kernel.org; Fri, 05 Dec 2014 16:21:53 +0000
Received: by mail-oi0-f43.google.com with SMTP id a3so663614oib.30
        for <linux-scsi@vger.kernel.org>; Fri, 05 Dec 2014 08:21:52 -0800 (PST)
In-Reply-To: <5481D415.3070102@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Fri, Dec 5, 2014 at 11:49 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 05/12/2014 14:05, Ming Lei wrote:
>>
>> [   50.112885] sd 0:0:1:0: [sda] FAILED Result: hostbyte=DID_OK
>> driverbyte=DRIVER_SENSE
>> [   50.113859] sd 0:0:1:0: [sda] Sense Key : Illegal Request [current]
>> [   50.113859] sd 0:0:1:0: [sda] Add. Sense: Invalid field in cdb
>> [   50.113859] sd 0:0:1:0: [sda] CDB:
>> [   50.113859] Write same(16): 93 08 00 00 00 00 00 00 80 00 00 40 00 00 00 00
>> [   50.113859] blk_update_request: critical target error, dev sda, sector
>> 32768
>
> So this command is zeroing 2^22 sectors (2GB) starting from sector 128.
>  How did you run QEMU and what command produced this request?

It was found in xfstests, and turns out it is a QEMU INT_MAX bug.

Thanks
