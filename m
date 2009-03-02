From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Mon, 2 Mar 2009 09:19:16 -0800
Message-ID: <da824cf30903020919q2d3496e6sb5a253b0acba681a@mail.gmail.com>
References: <20090227230927.GA21377@roadking.ldev.net>
	 <20090302153246A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:49565 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZCBRTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 12:19:23 -0500
In-Reply-To: <20090302153246A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mike.miller@hp.com, jens.axboe@oracle.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com, iss.sbteam@hp.com

On Sun, Mar 1, 2009 at 10:32 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
=2E..
>> +/*
>> + * For operations that cannot sleep, a command block is allocated a=
t init,
>> + * and managed by cmd_alloc() and cmd_free() using a simple bitmap =
to track
>> + * which ones are free or in use. =C2=A0Lock must be held when call=
ing this.
>> + * cmd_free() is the complement.
>> + */
>> +static struct CommandList_struct *cmd_alloc(struct ctlr_info *h)
>> +{
>> + =C2=A0 =C2=A0 struct CommandList_struct *c;
>> + =C2=A0 =C2=A0 int i;
>> + =C2=A0 =C2=A0 union u64bit temp64;
>> + =C2=A0 =C2=A0 dma_addr_t cmd_dma_handle, err_dma_handle;
>> +
>> + =C2=A0 =C2=A0 do {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i =3D find_first_zero_bi=
t(h->cmd_pool_bits, h->nr_cmds);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (i =3D=3D h->nr_cmds)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return NULL;
>> + =C2=A0 =C2=A0 } while (test_and_set_bit
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(i & (BITS_PER_LON=
G - 1),
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 h->cmd_pool_bits =
+ (i / BITS_PER_LONG)) !=3D 0);
>
> Using bitmap to manage free commands looks too complicated a bit to
> me. Can we just use lists for command management?

Bit maps are generally more efficient than lists since we touch less da=
ta.
=46or both search and moving elements from free<->busy lists. This prob=
ably
won't matter if we are talking less than 10K IOPS. And willy demonstrat=
ed
other layers have pretty high overhead (block, libata and SCSI midlayer=
)
at high transaction rates.

If nr_cmds can be greater than 8*BITS_PER_LONG or so, it would
be more efficient to save the allocation offset and start the next sear=
ch
from that location. But I can't tell from the code since nr_cmds is
coming from the controller:

+       /* Query controller for max supported commands: */
+       c->max_commands =3D readl(&(c->cfgtable->CmdsOutMax));
=2E..
+       c->nr_cmds =3D c->max_commands - 4;


hth,
grant
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
