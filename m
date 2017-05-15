From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] sd: fix sysfs writes to "provisioning_mode" and
 "zeroing_mode"
Date: Mon, 15 May 2017 17:02:58 -0400
Message-ID: <1494882178.1081.43.camel@localhost.localdomain>
References: <1494875606-6298-1-git-send-email-emilne@redhat.com>
         <1494879289.2567.3.camel@sandisk.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756899AbdEOVDA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 May 2017 17:03:00 -0400
In-Reply-To: <1494879289.2567.3.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2017-05-15 at 20:14 +0000, Bart Van Assche wrote:
> On Mon, 2017-05-15 at 15:13 -0400, Ewan D. Milne wrote:
> > From: "Ewan D. Milne" <emilne@redhat.com>
> > 
> > Change to use strlen() of the desired string for the length
> > parameter to strncmp().  Otherwise one cannot simply use a
> > command like 'echo "writesame_16" > .../provisioning_mode'.
> > This patch makes sysfs writes consistent with other usage.
> 
> Hello Ewan,
> 
> Sorry but I don't like the approach of this patch. Have you considered
> to strip the whitespace from 'buf' with e.g. strim() such that strcmp()
> can be used instead of strncmp(buf, ..., strlen(...))?
> 
> Thanks,
> 
> Bart.

I think it's the '\n' that actually causes the problem.
But, what I think we should do is use the same technique everywhere.
So, are you suggesting we change all the other sysfs store routines?

The problem arises when scripts can manipulate some sysfs properties
but not others, and its not obvious why not.  It should be consistent.

Also any change has to be careful to avoid breaking existing scripts.

-Ewan
