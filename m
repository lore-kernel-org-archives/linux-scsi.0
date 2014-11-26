From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH 0/4] Fix performance burning or extracting audio etc. from
 multiple optical drives.
Date: Thu, 27 Nov 2014 10:01:46 +1100
Message-ID: <CAGRGNgWCdbqTjbBu9fbwWHe9AHK04vO_5HAwyo4rH80PyUQKbA@mail.gmail.com>
References: <20141121100210.GC8866@infradead.org> <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
 <20141125162620.GA31478@infradead.org> <5474AE9B.40104@fb.com> <5475F2DD.9030906@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34888 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaKZXCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2014 18:02:08 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so4988395wgg.22
        for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2014 15:02:07 -0800 (PST)
In-Reply-To: <5475F2DD.9030906@seoss.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, tim@buttersideup.com, Wakko Warner <wakko@animx.eu.org>, linux-scsi <linux-scsi@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>

Hi Tim,

On Thu, Nov 27, 2014 at 2:33 AM, Tim Small <tim@seoss.co.uk> wrote:
> On 25/11/14 16:30, Jens Axboe wrote:
>
>> do we really need to do paride here?
>
> I did consider this, but I made the change there too on the basis that:
>
> . paride has received a few commits this year (and is listed as being
>     maintained)
> . The change is trivial
> . It fixes a performance regression which was introduced during the BKL
>     removal (mutex being retained by sleeping processes).
>
> I'm happy to drop it, if you prefer.
>
>> Patches 2-4 have identical subjects, and no commit message...
>
> Sorry about that, will fix it with next version.
>
> Having just seen this thread from 2013:
>
> http://permalink.gmane.org/gmane.linux.scsi/79483
>
> I decided to exercise the eject code path a bit more by triggering
> simultaneous eject commands on all 11 optical drives in my test box,
> followed by simultaneous close-tray commands, repeatedly.
>
> I haven't been able to reproduce the error reported in that email, but
> from observing the behaviour of the drives it looks like access to pata
> drives is being serialising elsewhere, so the issue in that link may
> have been fixed?
>
> Unfortunately running these tests did eventually make all further
> attempts to open /dev/sr* block on my test box.
>
> I've stared at the code for a while, but not making any headway
> currently, except that a blocking blk_execute_rq (called by
> test_unit_ready) is then causing all over cdrom open/close calls to
> block (because sr_mutex is held by sr_block_open(), and in turn calls
> check_disk_change... scsi_test_unit_ready).
>
> How do I work out why blk_execute_rq is blocking?

As you're playing with locks, I assume you're running with LOCKDEP
enabled? If not, that might tell you what's going on.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
