From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [RFC PATCH 0/2] block,scsi: support host-wide tagset
Date: Tue, 4 Apr 2017 15:46:27 +0000
Message-ID: <1491320786.2513.7.camel@sandisk.com>
References: <1491307665-47656-1-git-send-email-hare@suse.de>
         <20170404153234.GA3234@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:19158 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754863AbdDDPqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 11:46:30 -0400
In-Reply-To: <20170404153234.GA3234@vader>
Content-Language: en-US
Content-ID: <38B818EFA0C34644A6A3DC0BA94F1E84@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "osandov@osandov.com" <osandov@osandov.com>, "hare@suse.de" <hare@suse.de>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>

On Tue, 2017-04-04 at 08:32 -0700, Omar Sandoval wrote:
> blk-mq already supports a shared tagset, and scsi-mq already uses that.
> When we initialize a request queue, we add it to a tagset with
> blk_mq_add_queue_set(), where we automatically mark the tagset as shared
> if there is more than one queue using it. What does this do that
> BLK_MQ_F_TAG_SHARED doesn't cover?

Hello Omar,

Today blk-mq creates one tag set per hardware queue. The sharing by
scsi-mq is between request queues for hardware queues that have the same
index but not between hardware queues of a single request queue. My
understanding is that the goal of this patch series is to make it possible
to use a single tag set for all hardware queues and all request queues that
share the same SCSI host.

Bart.=
