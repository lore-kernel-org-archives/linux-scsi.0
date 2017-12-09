From: Rafael David Tinoco <rafael.tinoco@canonical.com>
Subject: Re: [PATCH] scsi: libiscsi: Allow sd_shutdown on bad transport
Date: Fri, 8 Dec 2017 23:31:46 -0200
Message-ID: <F7DC7920-76E9-4F8B-8E62-8E1B3F69C5A3@canonical.com>
References: <1512683953-5959-1-git-send-email-rafael.tinoco@canonical.com>
 <1512774750.26126.15.camel@wdc.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51596 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752235AbdLIBbx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Dec 2017 20:31:53 -0500
Received: from mail-qt0-f199.google.com ([209.85.216.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <rafael.tinoco@canonical.com>)
        id 1eNTzc-0005IU-Fj
        for linux-scsi@vger.kernel.org; Sat, 09 Dec 2017 01:31:52 +0000
Received: by mail-qt0-f199.google.com with SMTP id v30so14747045qtg.9
        for <linux-scsi@vger.kernel.org>; Fri, 08 Dec 2017 17:31:52 -0800 (PST)
In-Reply-To: <1512774750.26126.15.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "lduncan@suse.com" <lduncan@suse.com>, "cleech@redhat.com" <cleech@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, "daniel.axtens@canonical.com" <daniel.axtens@canonical.com>, "dragan.stancevic@canonical.com" <dragan.stancevic@canonical.com>

Hello Bart, 

I am returning BLK_EH_HANDLED in iscsi_eh_cmd_timed_out(). Do you mean something different ? 

That paragraph means that I have tried to return BLK_EH_NOT_HANDLED first, because that would be the other option instead of BLK_EH_RESET_TIMER (which is causing this issue), but if I did it, the EH logic would try scsi_abort_command() and - successful or not - it would try to get sense before completion, causing more traffic on a bad state transport.

Best way to allow faster completion was, indeed, returning BLK_EH_HANDLED, but changing result to DID_NO_CONNECT, because that will tell block layer not to retry, allowing the completion to happen in the SOFTIRQ handler, informing result to the upper layer. 

For the queue, simply now allowing queueing on such condition (shutdown + state != logged in) seemed correct. 

Let me know if you want me to try something else. I would be happy to.

Best,
-Rafael

> On 08/12/2017, at 09:12 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> 
> On Thu, 2017-12-07 at 19:59 -0200, Rafael David Tinoco wrote:
>> This happens because iscsi_eh_cmd_timed_out(), the transport layer
>> timeout helper, would tell the queue timeout function (scsi_times_out)
>> to reset the request timer over and over, until the session state is
>> back to logged in state. Unfortunately, during server shutdown, this
>> might never happen again.
> 
> Hello Rafael,
> 
> Have you considered to make iscsi_eh_cmd_timed_out() return BLK_EH_HANDLED
> if system_state != SYSTEM_RUNNING? That could result in slower shutdown than
> with your patch but such a change would probably be really easy to review.
> 
> Thanks,
> 
> Bart.
