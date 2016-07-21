From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] block: add flag for single-threaded submission
Date: Thu, 21 Jul 2016 08:37:10 +0200
Message-ID: <0030fdc3-bd7d-2e91-56ae-c20086a55d22@suse.de>
References: <1468936978-9124-1-git-send-email-hare@suse.de>
 <1468936978-9124-2-git-send-email-hare@suse.de>
 <20160721055431.GB14568@infradead.org>
 <2cef3971-54cc-73d6-dbff-acd1379d19d5@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <2cef3971-54cc-73d6-dbff-acd1379d19d5@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel-redhat.com@suse.de, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

On 07/21/2016 08:01 AM, Hannes Reinecke wrote:
> On 07/21/2016 07:54 AM, Christoph Hellwig wrote:
>> On Tue, Jul 19, 2016 at 04:02:56PM +0200, Hannes Reinecke wrote:
>>> Some devices (most notably SMR drives) support only
>>> one I/O stream eg for ensuring ordered I/O submission.
>>> This patch adds a new block queue flag
>>> 'BLK_QUEUE_SINGLE' to support these devices.
>>
>> We'll need a blk-mq implementation of this flag as well before it ca=
n
>> be merged.
>>
> Yes, indeed. Will be fixed for the next round of submissions.
>=20
Hmm.
Looking closer do I _really_ need that for blk-mq?
=46rom my understanding any hctx can only run on one dedicated cpu, to
which the hctx is bound.
So if we only have one CPU serving that hctx how can we have several
concurrent calls to queue_rq() here?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-block" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
