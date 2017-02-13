From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Mon, 13 Feb 2017 13:21:37 +1300
Message-ID: <87efz3hre6.fsf@xmission.com>
References: <20170212214920.28866-1-anton@ozlabs.org>
        <1486941294.3401.67.camel@kernel.crashing.org>
        <20170213104723.7741de0a@kryten>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:51790 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdBMA0N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2017 19:26:13 -0500
In-Reply-To: <20170213104723.7741de0a@kryten> (Anton Blanchard's message of
        "Mon, 13 Feb 2017 10:47:23 +1100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jk@ozlabs.org, linux-scsi@vger.kernel.org

Anton Blanchard <anton@samba.org> writes:

> Hi Ben,
>
> On Mon, 13 Feb 2017 10:14:54 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
>> On Mon, 2017-02-13 at 08:49 +1100, Anton Blanchard wrote:
>> > From: Anton Blanchard <anton@samba.org>
>> > 
>> > We see lpfc devices regularly fail during kexec. Fix this by adding
>> > a shutdown method which mirrors the remove method.  
>> 
>> Or instead finally do what I've been advocating for years (and even
>> sent patches for) which is to have kexec call remove instead of
>> shutdown.

Ben what happened to those patches.  I don't remember them?

>> Shutdown is and has *always* been the wrong thing to do.

I won't argue that.

> Good point, at the very least we should call remove if shutdown doesn't
> exist. Eric: could we make the changes Ben suggests?

Definitely.  That was the original design of the kexec interface
but people were worried about calling remove during reboot might
introduce regressions on the reboot functionality.  So shutdown was
added to be remove without the cleaning up the kernel data structures.

I am all for changing the core to call remove.  That seems to be a more
tested code path (because remove tends to be part of the development
path for modules) and thus much more likely to work in practice.

The challenge with changes in this area is that when the infrastructure
is changed for everyone someone needs to baby sit it until all of the
unexpected issues are resolved.  I was hoping a couple of years ago that
Ben could be that person.

Eric
