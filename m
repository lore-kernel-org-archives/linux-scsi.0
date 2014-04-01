From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] aic79xx: fix misuse of static variables
Date: Tue, 1 Apr 2014 18:45:01 +0200
Message-ID: <CA+rthh8ELxeq-m3-Xs5pzKbk9hSNkX5ZxFdi4HqrkgwGUtOqZA@mail.gmail.com>
References: <1396186235-3053-1-git-send-email-minipli@googlemail.com>
	<1396361441.2187.13.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:53961 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaDAQpD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2014 12:45:03 -0400
Received: by mail-la0-f50.google.com with SMTP id pv20so2912963lab.37
        for <linux-scsi@vger.kernel.org>; Tue, 01 Apr 2014 09:45:01 -0700 (PDT)
In-Reply-To: <1396361441.2187.13.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, PaX Team <pageexec@freemail.hu>

On 1 April 2014 16:10, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Sun, 2014-03-30 at 15:30 +0200, Mathias Krause wrote:
>> The format strings for various printk()s make use of a temporary
>> variable that is declared 'static'. This is probably not intended,
>> so fix those.
>
> Actually, it was intended.  It was to work around an assignment to const
> gcc bug: some versions of gcc won't allow the first assignment to an
> uninitialised const.

Could it be you're mixing up 'const char *' with 'char *const'? The
latter would be the wrong type and would generate an error when tying
to be assigned after initialization. But the former is totally fine.
In fact, it is fine with ancient versions of gcc as well. The oldest
one I managed to get running on my system is gcc 2.7.2.3 from 1998. It
compiled this little example just fine:

,--[ test.c ]---
| static const char *strings[] = {
|   "foo", "bar%s", "ba%z"
| };
|
| int main(int argc, char **argv) {
|   const char *s;
|
|   s = strings[argc];
|   printf(s, "got ya!");
|   putchar('\n');
|
|   return 0;
| }
`---

The same is true for gcc 3.2 -- the oldest supported version according
to README. It compiles the above example just fine.

>  I can't remember how long ago this was, but
> probably at least 10 years, so it's likely whatever version of gcc that
> caused the problem is long gone, but someone should check this
> modification works on our earliest supported version.

I haven't tried compiling the kernel with those old compilers -- I've
installed them in a very basic chroot environment only -- but as this
is a very common used pattern, pretty much the rest of the kernel
wouldn't compile either if gcc would require quirks like this. It's
standard C, after all.


Thanks,
Mathias
