From: aditya uttam <uttam.aditya@gmail.com>
Subject: Problem in invoking the scsi_times_out function
Date: Mon, 26 Oct 2009 21:35:34 +0530
Message-ID: <541bac340910260905s53c6bdc2y3391a78e78f98c23@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:36461 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZJZQF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2009 12:05:29 -0400
Received: by pwj9 with SMTP id 9so1372789pwj.21
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2009 09:05:34 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear All,

I am trying to test my error handler functionality by invoking my
timeout function. To do so, I am blocking response to host from the
device for a specific data-in request. I am expected to see the
=93scsi_times_out=94 function call in the trace. However, after 120
seconds I have seen the following messages in the /var/log/messages
file instead of getting invoked =93scsi_times_out=94 function.

Please find the procedure how I am registering the timeout function in
LLDD transport template.

my_domain_attach_transport(struct domain_function_template *dft)
{
            struct scsi_transport_template *stt =3D my_attach_transport=
();
            struct internal *i;

            if (!stt)
                        return stt;

            i =3D to_internal(stt);
            i->dft =3D dft;
            stt->create_work_queue =3D 1;
            stt->eh_timed_out =3D my_scsi_timed_out;

return stt;
}


Trace from /var/log/messages.


INFO: task mount:3487 blocked for more than 120 seconds.
Oct 26 15:19:57 My kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 26 15:19:57 My kernel: mount         D d18a5f90     0  3487   3486
Oct 26 15:19:57 My kernel:  de6d2200 00200086 00036cdc d18a5f90
0000002c cedf8000 cedf827c c13f9860
Oct 26 15:19:57 My kernel:  00000000 c04febaf fffe5c10 c04f2367
de6f0010 de1065a8 c043d46e 0001e1fa
Oct 26 15:19:57 My kernel:  de1065a8 0001e1INFO: task mount:3487
blocked for more than 120 seconds.
Oct 26 15:19:57 My kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 26 15:19:57 My kernel: mount         D d18a5f90     0  3487   3486
Oct 26 15:19:57 My kernel:  de6d2200 00200086 00036cdc d18a5f90
0000002c cedf8000 cedf827c c13f9860
Oct 26 15:19:57 My kernel:  00000000 c04febaf fffe5c10 c04f2367
de6f0010 de1065a8 c043d46e 0001e1fa
Oct 26 15:19:57 My kernel:  de1065a8 0001e1fa c13f9860 00000001
de093bb0 00040001 c062b9b9 c062bbd5
Oct 26 15:19:57 My kernel: Call Trace:
Oct 26 15:19:57 My kernel:  [<c04febaf>] ? cfq_may_queue+0x45/0xad
Oct 26 15:19:57 My kernel:  [<c04f2367>] ? elv_may_queue+0x15/0x17
Oct 26 15:19:57 My kernel:  [<c043d46e>] ? getnstimeofday+0x52/0xd6
Oct 26 15:19:57 My kernel:  [<c062b9b9>] ? schedule+0x5/0x13
Oct 26 15:19:57 My kernel:  [<c062bbd5>] ? io_schedule+0x44/0x75
Oct 26 15:19:57 My kernel:  [<c04f4f5e>] ? get_request_wait+0xba/0x118
Oct 26 15:19:57 My kernel:  [<c04376a4>] ? autoremove_wake_function+0x0=
/0x2d
Oct 26 15:19:57 My kernel:  [<c04f549f>] ? __make_request+0x2c6/0x37f
Oct 26 15:19:57 My kernel:  [<c04f4186>] ? generic_make_request+0x2c5/0=
x34a
Oct 26 15:19:57 My kernel:  [<c0466db5>] ? mempool_alloc+0x37/0xd5
Oct 26 15:19:57 My kernel:  [<c04f51d2>] ? submit_bio+0xaf/0xb6
Oct 26 15:19:57 My kernel:  [<c04a4f30>] ? bio_alloc_bioset+0x35/0x96
Oct 26 15:19:57 My kernel:  [<c04a160d>] ? submit_bh+0xd0/0xee
Oct 26 15:19:57 My kernel:  [<c04a3004>] ? __block_write_full_page+0x23=
1/0x323
Oct 26 15:19:57 My kernel:  [<c04a7213>] ? blkdev_get_block+0x0/0x45
Oct 26 15:19:57 My kernel:  [<c04a31e2>] ? block_write_full_page_endio+=
0xec/0xf6
Oct 26 15:19:57 My kernel:  [<c04a3deb>] ? end_buffer_async_write+0x0/0=
xd3
Oct 26 15:19:57 My kernel:  [<c04a7213>] ? blkdev_get_block+0x0/0x45
Oct 26 15:19:57 My kernel:  [<c04a31f6>] ? block_write_full_page+0xa/0x=
c
Oct 26 15:19:57 My kernel:  [<c04a3deb>] ? end_buffer_async_write+0x0/0=
xd3
Oct 26 15:19:57 My kernel:  [<c0469d03>] ? __writepage+0x8/0x1f
Oct 26 15:19:57 My kernel:  [<c0469fdf>] ? write_cache_pages+0x1e5/0x2e=
1
Oct 26 15:19:57 My kernel:  [<c0469cfb>] ? __writepage+0x0/0x1f
Oct 26 15:19:57 My kernel:  [<c046a0db>] ? generic_writepages+0x0/0x21
Oct 26 15:19:57 My kernel:  [<c046a0f5>] ? generic_writepages+0x1a/0x21
Oct 26 15:19:57 My kernel:  [<c046a11c>] ? do_writepages+0x20/0x30
INFO: task mount:3487 blocked for more than 120 seconds.
Oct 26 15:19:57 My kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 26 15:19:57 My kernel: mount         D d18a5f90     0  3487   3486

Could any one please let me know is there any problem in invoke the
scsi_times_out function?

Regards,
Aditya.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
