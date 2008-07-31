From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] cmd_filter fixes
Date: Thu, 31 Jul 2008 13:55:31 +0900
Message-ID: <20080731135521N.fujita.tomonori@lab.ntt.co.jp>
References: <6cf6b73e0807271302o77700222r321102ef7be0333b@mail.gmail.com>
	<20080728111915N.fujita.tomonori@lab.ntt.co.jp>
	<6cf6b73e0807301259s309f6332wef74d2ac5bafe691@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46882 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbYGaE4e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 00:56:34 -0400
In-Reply-To: <6cf6b73e0807301259s309f6332wef74d2ac5bafe691@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adel.gadllah@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net, matthew@wil.cx

On Wed, 30 Jul 2008 21:59:41 +0200
"Adel Gadllah" <adel.gadllah@gmail.com> wrote:

> >> > Anyway the look fine to me from just reading it ... have you tested if
> >> > changing the filter actually works?
> >> >
> >> Should be "Anyway the look fine to me from just reading them ... have
> >> you tested if
> >> changing the filter (via sysfs) actually works?"
> >
> > Yes though not much.
> 
> OK, thanks. Will do more detailed testing this weekend.

Thanks a lot.


> > BTW, I think that we need a document about how to control command
> > filters via sysfs (and IMO, there might be a better interface to
> > change the filter).
> 
> Yeah agreed, will add some docs this weekend.

Thanks again.


> As for "better interface" ... I am open for suggestions ;)
> This was the one used in Peter's original patch and it looks straight forward.

I propose two changes at least.

First, The current code can handle only hexadecimal notation but it
doesn't present hexadecimal notation properly. I think that it would
be better to make it clear that we use hexadecimal notation. I prefer
the following:

fujita@clover:/sys/block/cciss!c0d0/cmd_filter$ cat read_table
0x00 0x03 0x08 0x12 0x1a 0x1b 0x1c

rather than the current one:

fujita@clover:/sys/block/cciss!c0d0/cmd_filter$ cat 
00 03 08 12 1a 1b 1c

It's the same about changing the filter, I like to do:

clover:/sys/block/cciss!c0d0/cmd_filter# echo "0x00 0x03 0x08 0x12" > read_table

instead of

clover:/sys/block/cciss!c0d0/cmd_filter# echo "00 03 08 12" > read_table


Secondly, getting the different results from the following commands is
confusing for me:

clover:/sys/block/cciss!c0d0/cmd_filter# echo "03 08 12 1a 1b 1c" > read_table
clover:/sys/block/cciss!c0d0/cmd_filter# cat read_table
03 08 12 1a 1b 1c
clover:/sys/block/cciss!c0d0/cmd_filter# echo "3 08 12 1a 1b 1c" > read_table
clover:/sys/block/cciss!c0d0/cmd_filter# cat read_table
02 03 08 0a 0b 0c

I can send patches about them but before that, I like to discuss how
to fix the oops.


Someone might think that it would be better if we can change the
filter without specifying all the accepted commands. For example, we
could do like:

clover:/sys/block/cciss!c0d0/cmd_filter# cat read_table
03 08 12 1a 1b 1c

clover:/sys/block/cciss!c0d0/cmd_filter# echo 02 > read_table_on
02 03 08 12 1a 1b 1c


But I don't have strong opinions about it.
