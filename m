From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: BUG at drivers/scsi/scsi_lib.c:1113
Date: Thu, 22 Jul 2010 10:06:02 +0200
Message-ID: <4C47FBEA.2000704@gmail.com>
References: <4C47ED7B.1050709@gmail.com> <20100722173716.66264bef@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59034 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0GVIGI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2010 04:06:08 -0400
In-Reply-To: <20100722173716.66264bef@notabene>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org

On 07/22/2010 09:37 AM, Neil Brown wrote:
> I suspect that problem is that "do_sync" and "do_barriers" in
> drivers/md/raid1.c are still 'bool' and should now be 'unsigned long'.
> 
> I'm not sure how wide '_Bool' is, but I'm guess it isn't wide enough.

ANSI says:
An object declared as type _Bool is large enough to store the values 0
and 1.

gcc spec doesn't say anything, but:
$ gcc -S -x c -o - -
unsigned long x = sizeof(_Bool);
^D
...
x:
        .quad   1

I.e. sizeof(_Bool) = 1 byte.

> Could you please try changing ever 'bool' in that file to 'unsigned long'
> and see if that fixes it?

Will do that.

thanks,
-- 
js
