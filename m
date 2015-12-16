From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: kernel BUG at block/bio.c:1787! while initializing scsi_debug on
 ppc64 host
Date: Wed, 16 Dec 2015 09:15:05 +0800
Message-ID: <CACVXFVNJR_uo5GU6+Yx6Qq=hRpS+cDzM=xuwDN1V9OjQCm6aCw@mail.gmail.com>
References: <20151211115340.GB19209@eguan.usersys.redhat.com>
	<20151215112057.GC19209@eguan.usersys.redhat.com>
	<CACVXFVOPgONuXjGhBnFVxuRVr+=LFe36QR-VTGVvTkEK+V0JLw@mail.gmail.com>
	<20151215130631.GD19209@eguan.usersys.redhat.com>
	<CACVXFVM_bSd=SQeNg8gjaXd1R1oFreV+jnWgEVDoVwozcQ5Nbw@mail.gmail.com>
	<20151215165658.GE19209@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37947 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933807AbbLPBPH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 20:15:07 -0500
Received: by mail-wm0-f48.google.com with SMTP id l126so17893135wml.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 17:15:06 -0800 (PST)
In-Reply-To: <20151215165658.GE19209@eguan.usersys.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, Dec 16, 2015 at 12:56 AM, Eryu Guan <guaneryu@gmail.com> wrote:
> On Tue, Dec 15, 2015 at 09:27:14PM +0800, Ming Lei wrote:
>> On Tue, Dec 15, 2015 at 9:06 PM, Eryu Guan <guaneryu@gmail.com> wrote:
>> > On Tue, Dec 15, 2015 at 08:06:47PM +0800, Ming Lei wrote:
>> >> On Tue, Dec 15, 2015 at 7:20 PM, Eryu Guan <guaneryu@gmail.com> wrote:
>> >> > On Fri, Dec 11, 2015 at 07:53:40PM +0800, Eryu Guan wrote:
>> >> >> Hi,
>> >> >>
>> >> >> I saw this kernel BUG_ON on 4.4-rc4 kernel, and this can be reproduced
>> >> >> easily on ppc64 host by:
>> >> >
>> >> > This is still reproducible with 4.4-rc5 kernel.
>> >>
>> >> Could you capture the debug log after appyling the attached patch and
>> >> the reproduction?
>> >
>> > Thanks for looking into this! dmesg shows:
>> >
>> > [  686.217682] bio_split: sectors 0, bio_sectors 128, bi_rw 0
>>
>> Then I guess queue_max_sectors(q) is bad, could you apply the
>> attached patch(and the last patch) and post the log?
>
> [  301.279018] blk_bio_segment_split: nseg 0, max_secs 64, max segs 2048
> [  301.279023]   bv.len 65536, bv.offset 0
> [  301.279026] bio_split: sectors 0, bio_sectors 128, bi_rw 0

Now, the issue is quite obvious, and page size is 64K on your platform,
but max_sectors is set as 64 by commit ca369d51b3e164, and I think
it is wrong to set max sectors from OPTIMAL TRANSFER LENGTH.

Also it is ugly to set limits->max_sectors from drivers directly, and drivers
should have called block helpers to do that.

> If full call trace is needed please let me know.

Thanks for your test, and the above log is absolutely enough, :-)

Thanks,
Ming Lei
