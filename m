From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Tue, 17 Jan 2017 18:50:10 +0200
Message-ID: <e2b16f22-5743-23c8-cd20-13a20ec956b7@grimberg.me>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
 <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
 <499af528-7810-f82d-1f11-cbf8f3a5b21c@grimberg.me>
 <CANvN+emx1-F3iAY45t1_MQRcijw7sf1jPvjwv0uh8A3GzzQwMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33301 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdAQQuP (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 11:50:15 -0500
In-Reply-To: <CANvN+emx1-F3iAY45t1_MQRcijw7sf1jPvjwv0uh8A3GzzQwMg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Thumshirn <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Linux-scsi@vger.kernel.org


>     So it looks like we are super not efficient because most of the
>     times we catch 1
>     completion per interrupt and the whole point is that we need to find
>     more! This fio
>     is single threaded with QD=32 so I'd expect that we be somewhere in
>     8-31 almost all
>     the time... I also tried QD=1024, histogram is still the same.
>
>
> It looks like it takes you longer to submit an I/O than to service an
> interrupt,

Well, with irq-poll we do practically nothing in the interrupt handler,
only schedule irq-poll. Note that the latency measures are only from
the point the interrupt arrives and the point we actually service it
by polling for completions.

> so increasing queue depth in the singe-threaded case doesn't
> make much difference. You might want to try multiple threads per core
> with QD, say, 32

This is how I ran, QD=32.
