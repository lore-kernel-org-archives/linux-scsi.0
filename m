From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH] SCSI: fix the return type of the remove() method in sgiwd93.c
Date: Wed, 3 Dec 2008 18:52:54 +0100
Message-ID: <ac3eb2510812030952k5b57a9c7qb68e3684de170d75@mail.gmail.com>
References: <1227140357-29921-1-git-send-email-dmitri.vorobiev@movial.fi>
	 <46353.88.114.226.209.1228321494.squirrel@webmail.movial.fi>
	 <1228324123.5551.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:17302 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYLCRwz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 12:52:55 -0500
Received: by rv-out-0506.google.com with SMTP id k40so3572281rvb.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2008 09:52:54 -0800 (PST)
In-Reply-To: <1228324123.5551.25.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Vorobiev Dmitri <dmitri.vorobiev@movial.fi>, linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, Greg KH <greg@kroah.com>

On Wed, Dec 3, 2008 at 18:08, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2008-12-03 at 18:24 +0200, Vorobiev Dmitri wrote:
>> > This patch fixes the following compilation warning:
>> >
>> >   CC [M]  drivers/scsi/sgiwd93.o
>> > drivers/scsi/sgiwd93.c:314: warning: initialization from incompatible
>> > pointer type
>>
>> Any news about this one? I think this patch should go via linux-scsi,
>> unless you would be insisting on pushing it via linux-mips, in which case
>> I'll politely bug Ralf about it. :)
>
> Looks OK for the local change.
>
> Globally, having driver->remove and platform_driver->remove return int
> instead of void looks wrong.  Particularly when the only use cases are
> in drivers/base/ and they all ignore the return code.
>
> Greg and Kay ... shouldn't we simply redefine the return values for the
> remove methods in these structures to return void (and thus match the
> use case)?

Aren't there many many drivers across the tree, using the "int remove" version?

Thanks,
Kay
