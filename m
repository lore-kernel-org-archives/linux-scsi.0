From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCHv2]sd: Don't treat succeeded SYNC as error
Date: Thu, 12 May 2016 15:22:50 +0200
Message-ID: <CAMGffEkTLSqy1KVwoDHEWGCR0wCa2KvHheNov1=DRienvrQomg@mail.gmail.com>
References: <CAMGffE=C8mr_G=X8quAO44_0+1u_YNHDULwpBEJzSJnU4A4q9Q@mail.gmail.com>
 <5727266E.7040905@suse.de> <1462196672.2665.5.camel@linux.vnet.ibm.com>
 <CAMGffEmxzPrTKv=6Z=Nsiquk6L0OvZ3spYUR47CYUbaf5Spbeg@mail.gmail.com>
 <CAMGffEmCz1vcpOgPznC+Yn7XuikbaFUFVDmQv_T4KjZqOt4hnQ@mail.gmail.com>
 <CAMGffEnM_w8us49dCJWHU=UeDhyk53DRt5AD=sdezY3=Rv=omQ@mail.gmail.com>
 <1462892898.2320.18.camel@linux.vnet.ibm.com> <5732CF6A.20802@suse.de>
 <1462949004.2674.6.camel@linux.vnet.ibm.com> <1462979120.2356.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33139 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbcELNXL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2016 09:23:11 -0400
Received: by mail-oi0-f49.google.com with SMTP id v145so118815193oie.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2016 06:23:10 -0700 (PDT)
In-Reply-To: <1462979120.2356.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>, Bart Van Assche <bart.vanassche@sandisk.com>

On Wed, May 11, 2016 at 5:05 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2016-05-10 at 23:43 -0700, James Bottomley wrote:
>> On Wed, 2016-05-11 at 08:21 +0200, Hannes Reinecke wrote:
> [..]
>> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> > index 7cb66b0..68c0e74 100644
>> > --- a/drivers/scsi/scsi_lib.c
>> > +++ b/drivers/scsi/scsi_lib.c
>> > @@ -693,7 +693,7 @@ static bool scsi_end_request(struct request
>> > *req, int error,
>> >         struct scsi_device *sdev = cmd->device;
>> >         struct request_queue *q = sdev->request_queue;
>> >
>> > -       if (blk_update_request(req, error, bytes))
>> > +       if (bytes && blk_update_request(req, error, bytes))
>> >                 return true;
>>
>> Um, I think you mean
>>
>> if (bytes == 0 || blk_update_request())
>
> Actually, even this would be wrong.  We expect scsi_end_request called
> with blk_rq_bytes() to complete the request and return false.  If you
> do the above, it won't and we'll trigger a BUG lower down (or retry
> forever).
>
> James
>
>
You're right, I tried a similar patch:
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1f832c8..d10dabd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -692,7 +692,7 @@ static bool scsi_end_request(struct request *req, int error,
        struct scsi_device *sdev = cmd->device;
        struct request_queue *q = sdev->request_queue;

-       if (blk_update_request(req, error, bytes)) {
+       if ((bytes == 0 && blk_rq_bytes(req) == 0 && error) ||
blk_update_request(req, error, bytes)) {

It lead to BUG below:
[  590.180455] ------------[ cut here ]------------
[  590.180600] kernel BUG at drivers/scsi/scsi_lib.c:931!
[  590.180745] invalid opcode: 0000 [#1]
[  590.180962] Modules linked in: ib_srp scsi_transport_srp rdma_ucm
ib_ucm rdma_cm iw_cm ib_ipoib ib_cm ib_uverbs ib_umad loop mlx4_ib
ib_sa ib_mad ib_core ib_addr kvm_amd kvm acpi_cpufreq mlx4_core
irqbypass tpm_infineon tpm_tis xhci_pci psmouse xhci_hcd
crct10dif_pclmul crc32_pclmul tpm edac_mce_amd crc32c_intel k10temp
processor button fam15h_power edac_core serio_raw evdev i2c_piix4
md_mod sg sd_mod r8169 mlx_compat ahci libahci libata scsi_mod
[  590.183546] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.5-1-pserver #1
[  590.183693] Hardware name: To be filled by O.E.M. To be filled by
O.E.M./M5A97 R2.0, BIOS 2501 04/07/2014
[  590.183974] task: ffffffff81e0e540 ti: ffffffff81e00000 task.ti:
ffffffff81e00000
[  590.184225] RIP: 0010:[<ffffffffa000b248>]  [<ffffffffa000b248>]
scsi_io_completion+0x658/0x660 [scsi_mod]
[  590.184519] RSP: 0018:ffff88023ec03e20  EFLAGS: 00010202
[  590.184664] RAX: 0000000000000001 RBX: 0000000008000002 RCX: 0000000000000006
[  590.184811] RDX: 0000000000000007 RSI: 0000000000000246 RDI: ffff88023ec0ccf0
[  590.184957] RBP: ffff88023ec03e70 R08: ffff8800b5e033d8 R09: 0000000000000000
[  590.185133] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
[  590.185280] R13: ffff880234665590 R14: ffff8800b9e26780 R15: 00000000fffffffb
[  590.185427] FS:  00007fed4a8db700(0000) GS:ffff88023ec00000(0000)
knlGS:0000000000000000
[  590.185677] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  590.185822] CR2: 00007fbc1e037000 CR3: 000000022b6cb000 CR4: 00000000000406f0
[  590.185969] Stack:
[  590.186110]  0000004080304680 00000bb800000000 ffff8800b8418810
0000000000000005
[  590.186531]  0000000000290670 ffff8800b9e26780 0000000000000000
ffff880229fb7c28
[  590.186924]  ffff8802294ea000 0000000000000004 ffff88023ec03ea0
ffffffffa0002037
[  590.187316] Call Trace:
[  590.187459]  <IRQ>
[  590.187540]  [<ffffffffa0002037>] scsi_finish_command+0xd7/0x130 [scsi_mod]
[  590.187829]  [<ffffffffa000a570>] scsi_queue_insert+0x140/0x750 [scsi_mod]
