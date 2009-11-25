From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: BUG at scsi_lib.c:1108 [Was: mmotm 2009-11-24-16-47 uploaded]
Date: Wed, 25 Nov 2009 21:22:57 +0100
Message-ID: <4B0D9221.2050103@gmail.com>
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>	 <4B0D4949.4090109@gmail.com> <1259162399.2535.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55455 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZKYUX0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2009 15:23:26 -0500
In-Reply-To: <1259162399.2535.8.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>, neilb@suse.de

On 11/25/2009 04:19 PM, James Bottomley wrote:
> On Wed, 2009-11-25 at 16:12 +0100, Jiri Slaby wrote:
>> On 11/25/2009 01:47 AM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2009-11-24-16-47 has been uploaded to
>>
>> Hi, I'm hitting the BUG below in the past two -mmotm's
>> (2009-11-24-16-47, 2009-11-17-14-03):
> 
> So this looks like some type of bug in the barrier code. What the BUG_ON
> is saying is that something sent us a REQ_TYPE_FS (which should be a
> filesystem read or write) with no attached data, so we can't process it.
> 
> I've cc'd Jens to see what he thinks.
> 
> Could you bisect this to find the offending commit?

Hmm. I bisected it twice to
commit 1bebedd653e1bb0440ebf40724c55791c21ad7cc
Merge: a8d5ddf 62fa36a
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Wed Nov 25 17:42:47 2009 +1100

    Merge remote branch 'md/for-next'


It doesn't make sense at all. How can empty merge cause a regression?
And md/for-next doesn't produce the BUG.

After the 1st bisection I did
 git checkout 1bebedd653e1bb0440ebf40724c55791c21ad7cc
and built it. It crashed. Then I did
 git bisect start 1bebedd origin/stable
where origin is next. And got back to the 1bebedd by bisection.

-- 
js
Faculty of Informatics, Masaryk University
Suse Labs, Novell
