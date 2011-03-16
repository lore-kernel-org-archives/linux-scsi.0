From: va stg2010 <va.storage2010@gmail.com>
Subject: scsi_sg_copy_from_buffer( ) variant for initiator LLDD
Date: Wed, 16 Mar 2011 11:52:10 -0700
Message-ID: <AANLkTimx30jPrDWHQV21Q3OJ96_4sUnYWWrQKcuQ54ok@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43747 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab1CPSwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2011 14:52:10 -0400
Received: by gyf1 with SMTP id 1so786601gyf.19
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2011 11:52:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi ,
=46or =A0scsi READ CDB, my initiator mode HBA receives data from target=
 in
fragments for example a =A064K READ will =A0 arrive in =A031568 + 1200 =
+
31568 + 1200 =A0fragments.
I =A0am trying to implement =A0scsi_sg_copy_from_buffer_variant() =A0va=
riant
which can "START/STOP at will" because READ datacomes in fragments
from target.

I looked into scsi_sg_copy_from_buffer implementation and based on
that, scsi_sg_copy_from_buffer_VARIANT() =A0does =A0 this:

Step 1) Call once sg_miter_start () - whennew scsi command comes in.
Step 2) Keep calling =A0sg_miter_next() - everytime when interrupt
handler posts that fragment of =A0READ data is available.
Step 3) Call once =A0sg_miter_stop() - All the READ data rcvd in HBA
LLDD =A0from target for this scsi command, now safe to call scsi_done()=
=2E

The step 2 algorithm is following:
static size_t sg_copy_buffer_variant(struct scatterlist *sgl, void
*src_data_address, size_t src_len, =A0 struct sg_mapping_iter *miter)
{
=A0 =A0 =A0 =A0unsigned int offset =3D 0;
=A0 =A0 =A0 =A0unsigned long flags;


=A0 =A0 =A0 =A0printk("START sg iterator \n");

=A0 =A0 =A0 =A0local_irq_save(flags);

=A0 =A0 =A0 =A0while (offset < src_len) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int len;

=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sg_miter_next(miter)) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 miter->consumed =3D 0;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(1);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len =3D min(miter->length, src_len - off=
set);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0miter->consumed =3D len;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(miter->addr, src_data_address + o=
ffset, len);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flush_kernel_dcache_page(miter->page);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset +=3D len;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}

=A0 =A0 =A0 =A0local_irq_restore(flags);
}

My kernel is 2.6.27.7. =A0Can someone please review this and tell what
is wrong with above implementation (or easier alternative ways)
because at the end of step3, I start seeing =A0these messages:

sg_miter_stop:404
sg_miter_stop:406
BUG: scheduling while atomic: swapper/0/0xffffffff
Modules linked in: my_scsi_lld
Call Trace:
[<ffffffff8150188c>] dump_stack+0x8/0x34
[<ffffffff815024e0>] schedule+0x4c0/0x908
BUG: scheduling while atomic: swapper/0/0x00000001
Modules linked in: my_scsi_lld
Call Trace:
[<ffffffff8150188c>] dump_stack+0x8/0x34
[<ffffffff815024e0>] schedule+0x4c0/0x908
[<ffffffff81134318>] cpu_idle+0x48/0x50

BUG: scheduling while atomic: swapper/0/0x00000001
Modules linked in: my_scsi_lld
Call Trace:
[<ffffffff8150188c>] dump_stack+0x8/0x34
[<ffffffff815024e0>] schedule+0x4c0/0x908
[<ffffffff81134318>] cpu_idle+0x48/0x50

BUG: scheduling while atomic: swapper/0/0x00000001
Modules linked in: my_scsi_lld
Call Trace:
[<ffffffff8150188c>] dump_stack+0x8/0x34
[<ffffffff815024e0>] schedule+0x4c0/0x908
[<ffffffff81134318>] cpu_idle+0x48/0x50
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
