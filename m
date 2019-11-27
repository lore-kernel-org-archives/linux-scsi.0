Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08533C43215
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 13:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D61DA2071E
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 13:09:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RozBIR12"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfK0NJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 08:09:18 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21373 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfK0NJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Nov 2019 08:09:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574860157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M6+DDtUgzApiQu4YHE35MwvUiV8KTCoPHcuxsyEvH7Q=;
        b=RozBIR120nxSekCBWQI58NMA3W3IznpZJ3UGtD9cyuJtp1TT6bvRXY8OidtgBXVVtUb1Br
        +xndjO3uEMGk1KlJuPHRwiNdSgwVrrfzNGunhQLBUhI1gLePjNEFr1PEt9frigMcF50xD6
        aNyin3UJw8C93DQCYRI9VnB5WppTCN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-ijxwCcqoNMurXxKPrFl-Jw-1; Wed, 27 Nov 2019 08:09:13 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB275DB6B;
        Wed, 27 Nov 2019 13:09:10 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB1BB608B9;
        Wed, 27 Nov 2019 13:09:00 +0000 (UTC)
Date:   Wed, 27 Nov 2019 21:08:54 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Andrea Vai <andrea.vai@unipv.it>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Message-ID: <20191127130854.GA12140@ming.t460p>
References: <20191125102928.GA20489@ming.t460p>
 <e5093535c60fd5dff8f92b76dcd52a1030938f62.camel@unipv.it>
 <20191125151535.GA8044@ming.t460p>
 <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>
 <20191126023253.GA24501@ming.t460p>
 <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
 <20191126091533.GB32135@ming.t460p>
 <e852331e72532dbfdc7981d958b1cd05ded41317.camel@unipv.it>
 <20191127020533.GA7190@ming.t460p>
 <3af3666920e7d46f8f0c6d88612f143ffabc743c.camel@unipv.it>
MIME-Version: 1.0
In-Reply-To: <3af3666920e7d46f8f0c6d88612f143ffabc743c.camel@unipv.it>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: ijxwCcqoNMurXxKPrFl-Jw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 27, 2019 at 10:39:40AM +0100, Andrea Vai wrote:
> Il giorno mer, 27/11/2019 alle 10.05 +0800, Ming Lei ha scritto:
> >=20
> >=20
> > It can be workaround via the following change:
> >=20
> > /lib/modules/5.4.0+/build/include/generated/autoconf.h:
> >=20
> > //#define CONFIG_CC_HAS_ASM_INLINE 1
>=20
> Thanks, it worked, trace attached. Produced by: start the trace script
> (with the pendrive already plugged), wait some seconds, run the test
> (1 trial, 1 GB), wait for the test to finish, stop the trace.
>=20
> The copy took 2659 seconds, roughly as already seen before.

Thanks for collecting the log.

From the log, some of write IOs are out-of-order, such as, the 1st one
is 378880.

16.41240 2   266     266     kworker/2:1H    block_rq_issue   b'W' 370656 2=
40
16.41961 3   485     485     kworker/3:1H    block_rq_issue   b'W' 378880 2=
40
16.73729 2   266     266     kworker/2:1H    block_rq_issue   b'W' 370896 2=
40
17.71161 2   266     266     kworker/2:1H    block_rq_issue   b'W' 379120 2=
40
18.02344 2   266     266     kworker/2:1H    block_rq_issue   b'W' 371136 2=
40
18.94314 3   485     485     kworker/3:1H    block_rq_issue   b'W' 379360 2=
40
19.25624 2   266     266     kworker/2:1H    block_rq_issue   b'W' 371376 2=
40

IO latency is increased a lot since the 1st out-of-order request(usb
storage HBA is single queue depth, one request can be issued only if=20
the previous issued request is completed).

The reason is that there are two kind of tasks which inserts rq to device.
One is the 'cp' process, the other is kworker/u8:*.  The out-of-order
happens during the two task's interleaving.

Under such situation, I believe that the old legacy IO path may not
guarantee the order too. In blk_queue_bio(), after get_request()
allocates one request, the queue lock is released.  And request is
actually inserted & issued from blk_flush_plug_list() under the
branch of 'if (plug)'. If requests are from two tasks, then request
is inserted/issued from two plug list, and no order can be guaranteed.

In my test, except for several requests from the beginning, all other
requests are inserted via the kworker thread(guess it is writeback wq),
that is why I can't observe the issue in my test.

As Schmid suggested, you may run the same test on old kernel with
legacy io path, and see if the performance is still good.

Also, could you share the following info about your machine? So that
I can build my VM guest in this setting for reproducing your situation
(requests are inserted from two types of threads).

- lscpu
- free -h
- lsblk -d $USB_DISK
- exact commands for mount the disk, and running the copy operation

Thanks,
Ming

