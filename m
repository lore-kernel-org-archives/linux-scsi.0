From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/3] scsi_debug: fix data integrity support on highmem machine
Date: Sat, 27 Apr 2013 17:51:02 +0900
Message-ID: <CAC5umyjZbRDA7L5V=uFW0LA5AXMbtU7wSebvvn5E8OtdamZRHQ@mail.gmail.com>
References: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
	<1366535879-20775-2-git-send-email-akinobu.mita@gmail.com>
	<yq11u9ztl1d.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:48557 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3D0IvD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Apr 2013 04:51:03 -0400
Received: by mail-oa0-f45.google.com with SMTP id o17so4641389oag.4
        for <linux-scsi@vger.kernel.org>; Sat, 27 Apr 2013 01:51:02 -0700 (PDT)
In-Reply-To: <yq11u9ztl1d.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

2013/4/25 Martin K. Petersen <martin.petersen@oracle.com>:
>>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:
>
> Akinobu> kmap_atomic() is now using stack based implementation and
> Akinobu> doesn't take the KM_type argument anymore.  So nesting
> Akinobu> kmap_atomic() calls must be properly stacked.
>
> Akinobu> This fixes nesting kmap_atomic() calls for scsi_sglist and
> Akinobu> scsi_prot_sglist in prot_verify_write().
>
> I don't see how the prog_sglist is incorrectly nested? Also, with your
> code you also end up mapping and unmapping the protection page for every
> data segment. The two scatterlists have different cadence.

I meant that the unmapped address by kunmap_atomic() should be the
address returned by the last kmap_atomic() call which is not yet unmapped.
Because kmap_atomic was changed to stack based implementation.

Specifically,

    /* For each data page */
    scsi_for_each_sg(SCpnt, dsgl, scsi_sg_count(SCpnt), i) {
        daddr = kmap_atomic(sg_page(dsgl)) + dsgl->offset;

This kmapped address 'daddr' will not unmapped during the next for-loop.

        /* For each sector-sized chunk in data page */
        for (j = 0 ; j < dsgl->length ; j += scsi_debug_sector_size) {

            /* If we're at the end of the current
             * protection page advance to the next one
             */
            if (ppage_offset >= psgl->length) {
                kunmap_atomic(paddr);
                ...

But this kunmap_atomic() for the first time in this loop is called.
The last two kmap_atomic() and kunmap_atomic() do not correspond and
it breaks kmap_atomic/kunmap_atomic stack.
