From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Cleanup: snprintf() always NUL-terminates: depend on it
Date: Sun, 4 Jan 2015 11:34:43 -0800
Message-ID: <CA+55aFw8aMBF5uXekxATymQPTqwZHGJTL-jQx8zDqOwbaft+4g@mail.gmail.com>
References: <1420394759-20345-1-git-send-email-me@mortis.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:43465 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbADTeo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2015 14:34:44 -0500
In-Reply-To: <1420394759-20345-1-git-send-email-me@mortis.eu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giel van Schijndel <me@mortis.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>

On Sun, Jan 4, 2015 at 10:05 AM, Giel van Schijndel <me@mortis.eu> wrote:
> Especially since one very strange piece of code seems to be written in
> such a way that a NUL needs to be placed where a NUL is present already.

Actually, it's worse than that. This:

>         len = snprintf(fname, 99, "%s", buf);
> -       fname[len-1] = '\0';

is complete garbage, since the return value of snprintf() is not the
length of the result, but length of what the result *would* have been.

So if the string doesn't fit in 99 bytes, it will actively corrupt
some random memory after the string. It's not writing zero to what was
already zero, it's corrupting memory.

Anyway, from a quick glance your patches look fine, but you need to
sign off on them. See Documentation/SubmittingPatches.

                       Linus
