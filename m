From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [SCSI] fix media change events for polled devices
Date: Fri, 21 Mar 2008 13:12:07 -0400
Message-ID: <47E3EC67.4050404@garzik.org>
References: <200803211559.m2LFxPi6017869@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45678 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbYCURMP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 13:12:15 -0400
In-Reply-To: <200803211559.m2LFxPi6017869@hera.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

Linux Kernel Mailing List wrote:
>     [SCSI] fix media change events for polled devices
>     
>     Commit:
>       a341cd0f (SCSI: add asynchronous event notification API)
>     breaks:
>       285e9670 (sr,sd: send media state change modification events)
>     by introducing an event filter, which is removed here, to make
>     events, we are depending on, happen again.


By simply reading the code history, it is trivial to verify that this 
description is false:

Commit 285e9670 depends on a341cd0f, so by definition it is 285e9670 -- 
or rather the incomplete update of your original patch that resulted in 
285e9670 -- that is broken.

Since commit 285e9670 is broken, you fixed the wrong thing.

Furthermore, you broke a userspace interface that was introduced by 
a341cd0f, by removing the event filter controlled by userspace.

Did anyone bother to read any code at all?

When 285e9670 was updated for the scsi_evt_* interface, it should have 
initialized the supported_events mask.

And that is the fix -- initialize supported_events according to sr/sd's 
needs, and revert this change (4d1566ed2100d074ccc654e5cf2e44cdea3a01d0) 
as obviously broken.

	Jeff



