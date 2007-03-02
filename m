From: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
Subject: RE: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Fri, 2 Mar 2007 09:45:24 -0700
Message-ID: <A67893E24596534CB03DD02157A7FBF701879048@NAMAIL2.ad.lsil.com>
References: <456D532C.6040008@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53585 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992607AbXCBQqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Mar 2007 11:46:19 -0500
Content-class: urn:content-classes:message
In-Reply-To: <456D532C.6040008@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Hello All,

I am noticing the following panic on SLES 10 ( as well as Redhat 5 ).
I modified "scsi_lib.c" to print some debugging information.
Our driver is a Multipath failover module and we are using
"scsi_execute_async" API for routing IO's.
In earlier kernels we used "scsi_do_req" API.


Messages
--------
Mar  1 20:20:35 linux kernel:  mppLnx_do_queuecommand :: cs 10, bufflen
110592 use_sg 27
Mar  1 20:20:35 linux kernel:  mppLnx_do_queuecommand :: cs 10, bufflen
4096 use_sg 1
Mar  1 20:20:35 linux kernel:  mppLnx_do_queuecommand :: cs 10, bufflen
4096 use_sg 1
Mar  1 20:20:35 linux kernel:  mppLnx_do_queuecommand :: cs 10, bufflen
4096 use_sg 1
Mar  1 20:20:35 linux kernel:  mppLnx_do_queuecommand :: cs 10, bufflen
4096 use_sg 1
Mar  1 20:20:35 linux kernel:  mppLnx_do_queuecommand :: cs 10, bufflen
7168 use_sg 7
Mar  1 20:20:35 linux kernel:  scsi_req_map_sg:: calling bio_put
Mar  1 20:20:35 linux kernel:
scsi_req_map_sg::i=2,len=1024,data_len=3072,off=2048,PAGE_SIZE=4096,byte
s=1024,nr_vecs=0, nr_pages=0
Mar  1 20:20:35 linux kernel: scsi_req_map_sg:: bio->bi_io_vec is NULL
Mar  1 20:20:35 linux kernel: Unable to handle kernel paging request at
ffff82bcfe3c0030 RIP:
Mar  1 20:20:35 linux kernel: <ffffffff80175e92>{kmem_cache_free+86}
Mar  1 20:20:35 linux kernel: PGD 0
Mar  1 20:20:35 linux kernel: Oops: 0000 [1] SMP
Mar  1 20:20:35 linux kernel: last sysfs file:
/class/mppUpper/mppUpper/dev
Mar  1 20:20:35 linux kernel: CPU 0
Mar  1 20:20:35 linux kernel: Modules linked in: ipv6 af_packet button
battery ac apparmor aamatch_pcre loop dm_mod shpchp pci_hotplug
hw_random ide_cd ehci_hcd uhci_hcd cdrom usbcore e1000 i8xx_tco
parport_pc lp parport ext3 jbd mppVhba edd fan thermal processor mptfc
aacraid lpfc qla2xxx firmware_class scsi_transport_fc mptspi mptscsih
mptbase scsi_transport_spi ata_piix libata piix mppUpper sg sd_mod
scsi_mod ide_disk ide_core
Mar  1 20:20:35 linux kernel: Pid: 1085, comm: mpp_dcr Tainted: G     U
2.6.16.16-1.6-smp #1
Mar  1 20:20:35 linux kernel: RIP: 0010:[<ffffffff80175e92>]
<ffffffff80175e92>{kmem_cache_free+86}
Mar  1 20:20:35 linux kernel: RSP: 0018:ffff81007c2fdd88  EFLAGS:
00010086
Mar  1 20:20:35 linux kernel: RAX: ffff82bcfe3c0000 RBX:
ffff810037fbd000 RCX: 000000000000003f
Mar  1 20:20:35 linux kernel: RDX: ffff81000000c000 RSI:
0000000000000000 RDI: 00000007f0000000
Mar  1 20:20:35 linux kernel: RBP: ffff810037fdf640 R08:
ffffffff803d2240 R09: ffff81007c2fdb78
Mar  1 20:20:35 linux kernel: R10: 0000000000000001 R11:
ffffffff8015a4e0 R12: ffff81007da72880
Mar  1 20:20:35 linux kernel: R13: 0000000000000296 R14:
0000000000000800 R15: 0000000000000000
Mar  1 20:20:35 linux kernel: FS:  00002b7d68de36d0(0000)
GS:ffffffff80444000(0000) knlGS:0000000000000000
Mar  1 20:20:35 linux kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Mar  1 20:20:35 linux kernel: CR2: ffff82bcfe3c0030 CR3:
0000000067dc6000 CR4: 00000000000006e0
Mar  1 20:20:35 linux kernel: Process mpp_dcr (pid: 1085, threadinfo
ffff81007c2fc000, task ffff81007c9bd850)
Mar  1 20:20:35 linux kernel: Stack: ffff81007c69f328 0000000000000400
0000000000000000 ffff810063368d00
Mar  1 20:20:35 linux kernel:        ffff810037fdf640 0000000000000400
ffff810063368d00 ffffffff8017ef77
Mar  1 20:20:35 linux kernel:        0000000000000400 ffff810054239188
Mar  1 20:20:35 linux kernel: Call Trace:
<ffffffff8017ef77>{bio_free+51}
<ffffffff8803ab0e>{:scsi_mod:scsi_execute_async+480}
Mar  1 20:20:35 linux kernel:
<ffffffff881ae827>{:mppVhba:mppLnx_do_queuecommand+2577}
Mar  1 20:20:35 linux kernel:
<ffffffff881acdac>{:mppVhba:mppLnx_scsi_done+0}
<ffffffff881a469e>{:mppVhba:mppLnx_dpc_handler+531}
Mar  1 20:20:35 linux kernel:        <ffffffff8010b672>{child_rip+8}
<ffffffff881a448b>{:mppVhba:mppLnx_dpc_handler+0}
Mar  1 20:20:35 linux kernel:        <ffffffff8010b66a>{child_rip+0}
Mar  1 20:20:35 linux kernel:
Mar  1 20:20:35 linux kernel: Code: 48 8b 48 30 0f b7 51 28 65 8b 04 25
30 00 00 00 39 c2 0f 84
Mar  1 20:20:35 linux kernel: RIP <ffffffff80175e92>{kmem_cache_free+86}
RSP <ffff81007c2fdd88>
Mar  1 20:20:35 linux kernel: CR2: ffff82bcfe3c0030
 




Scsi_lib.c ( scsi_req_map_sg )
----------

static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
                            int nsegs, unsigned bufflen, gfp_t gfp)
{
        struct request_queue *q = rq->q;
        int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >>
PAGE_SHIFT;
        unsigned int data_len = 0, len, bytes, off;
        struct page *page;
        struct bio *bio = NULL;
        int i, err, nr_vecs = 0;

        for (i = 0; i < nsegs; i++) {
                page = sgl[i].page;
                off = sgl[i].offset;
                len = sgl[i].length;
                data_len += len;

                while (len > 0) {
                        bytes = min_t(unsigned int, len, PAGE_SIZE -
off);

                        if (!bio) {
                                nr_vecs = min_t(int, BIO_MAX_PAGES,
nr_pages);
                                nr_pages -= nr_vecs;

                                bio = bio_alloc(gfp, nr_vecs);
                                if (!bio) {
                                        err = -ENOMEM;
                                        goto free_bios;
                                }
                                bio->bi_end_io = scsi_bi_endio;
                        }

                        if (bio_add_pc_page(q, bio, page, bytes, off) !=
                            bytes) {
                                printk("scsi_req_map_sg:: calling
bio_put \n");
 
printk("scsi_req_map_sg::i=%d,len=%d,data_len=%d,off=%d,PAGE_SIZE=%ld,by
tes=%d,nr_vecs=%d, nr_pages=%d\n",
 
i,len,data_len,off,PAGE_SIZE,bytes,nr_vecs,nr_pages);
                                if( bio->bi_io_vec == NULL )
printk("scsi_req_map_sg:: bio->bi_io_vec is NULL\n");
                                bio_put(bio);
                                err = -EINVAL;
                                goto free_bios;
                        }

                        if (bio->bi_vcnt >= nr_vecs) {
                                err = scsi_merge_bio(rq, bio);
                                if (err) {
                                        bio_endio(bio, bio->bi_size, 0);
                                        goto free_bios;
                                }
                                bio = NULL;
                        }

                        page++;
                        len -= bytes;
                        off = 0;
                }
        }

        rq->buffer = rq->data = NULL;
        rq->data_len = data_len;
        return 0;

free_bios:
        while ((bio = rq->bio) != NULL) {
                rq->bio = bio->bi_next;
                /*
                 * call endio instead of bio_put incase it was bounced
                 */
                bio_endio(bio, bio->bi_size, 0);
        }

        return err;
}






regards 
Sudhir Dachepalli  

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Benny Halevy
Sent: Wednesday, November 29, 2006 3:30 AM
To: Jens Axboe
Cc: Mike Christie; Boaz Harrosh; linux-scsi@vger.kernel.org; James
Bottomley
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()

Jens Axboe wrote:
> On Mon, Nov 27 2006, Mike Christie wrote:
>> Mike Christie wrote:
>>> Boaz Harrosh wrote:
>>>> Playing with some tests which I admit are not 100% orthodox I have 
>>>> stumbled upon a bug that raises a serious question:
>>>>
>>>> In the call to scsi_execute_async() in the use_sg case, must the
>>>> scatterlist* (pointed to by buffer) map a buffer that's contiguous 
>>>> in virtual memory or is it allowed to map disjoint segments of
memory?
>>> I thought they were continguous. I think James has said before that 
>>> they can be disjoint. When we converted sg it did not look like sg 
>>> or st supported disjoint. The main non dio path used a buffer from 
>>> get_free_pages so I thought that would always be contiguous. The dio

>>> path then always set the first sg offset, but the rest it set to
zero.
>> And the len is set to page size for the middle entries too.
>>
>> But for the non DIO st path we can end up with some middle sg entires

>> that are not a full page so that code in scsi_execute_async is broken

>> for that.
> 
> If something doesn't work with non-contig sg entries, that would be a 
> bug. If the question is regarding holes in the sg list, that is 
> probably unchartered territory and I would not regard that as
supported.
> 

Jens, I'm not sure I understand the terms you used.  Can you please
define more clearly what you mean by "non-contig sg entries" vs.
"holes in the sg list"?

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
