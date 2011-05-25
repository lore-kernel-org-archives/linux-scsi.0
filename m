From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
Date: Wed, 25 May 2011 12:13:44 -0700
Message-ID: <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com>
 <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com>
 <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty> <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
 <4DDD5240.2060308@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754947Ab1EYTOf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2011 15:14:35 -0400
In-Reply-To: <4DDD5240.2060308@fusionio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Parag Warudkar <parag.lkml@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Wed, May 25, 2011 at 12:02 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> This is before you get that far, it's actually oopsing on inserting the
> request on sdev->sdev_queue that is now NULL. The prep state checking
> happens when sr/sd pulls the request off the queue for processing.

Ok, please just add a "sdev_alive(sdev)" helper that checks for sdev
&& sdev->sdev_queue. Apparently the issue isn't "this device is
SDEV_DEL, so don't send commands". Apparently the issue is literally
"don't oops".

Or maybe the prep state checking could be moved earlier. It seems
stupid to have a "can I do this command" function that is run too late
to actually catch the problems..

                    Linus
