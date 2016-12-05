From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: scsi: use-after-free in bio_copy_from_iter
Date: Mon, 5 Dec 2016 16:17:53 +0100
Message-ID: <20161205151753.GI8481@linux-x5ow.site>
References: <CACT4Y+aBd+1pssnsVx2x145n7Q1nDMU=xc7NAiOCtpy-MA-EDg@mail.gmail.com>
 <CACT4Y+auCpJbXhmxbr4OmSHbiVkatyWmDxGGShs=WvO=HCXRKA@mail.gmail.com>
 <20161203103802.dmvqzzquthwa7kd7@linux-x5ow.site>
 <CACT4Y+bB+oxjPoC0WVCUV_Bq9ePqdV3m_V4snsfUrZ2BSWub2Q@mail.gmail.com>
 <20161203181948.GA3322@linux-x5ow.site>
 <CACT4Y+Z4V=9nm04H-uyy0tA4yXLp7Ld7dqgjLiA5_opeQC_m6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+Z4V=9nm04H-uyy0tA4yXLp7Ld7dqgjLiA5_opeQC_m6A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzkaller <syzkaller@googlegroups.com>, Doug Gilbert <dgilbert@interlog.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, axboe@kernel.dk, linux-block@vger.kernel.org, David Rientjes <rientjes@google.com>, Hannes Reinecke <hare@suse.de>, mhocko@suse.cz
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 05, 2016 at 03:31:43PM +0100, Dmitry Vyukov wrote:
> On Sat, Dec 3, 2016 at 7:19 PM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> > On Sat, Dec 03, 2016 at 04:22:39PM +0100, Dmitry Vyukov wrote:
> >> On Sat, Dec 3, 2016 at 11:38 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> >> > On Fri, Dec 02, 2016 at 05:50:39PM +0100, Dmitry Vyukov wrote:
> >> >> On Fri, Nov 25, 2016 at 8:08 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > [...]
> >
> > Hi Dmitry,
> >
> >>
> >> Thanks for looking into this!
> >>
> >> As I noted I don't think this is use-after-free, more likely it is an
> >> out-of-bounds access against non-slab range.
> >>
> >> Report says that we are copying 0x1000 bytes starting at 0xffff880062c6e02a.
> >> The first bad address is 0xffff880062c6f000, this address was freed
> >> previously and that's why KASAN reports UAF.
> >
> > We're copying 65499 bytes (65535 - sizeof(sg_header)) and we've got 2 order 3
> > page allocations to do this. It fails somewhere in there. I have seen fails at
> > 0x2000, 0xe000 and all (0x1000 aligned) offsets inbetween.
> >
> >> But this is already next page, and KASAN does not insert redzones
> >> around pages (only around slab allocations).
> >> So most likely the code should have not touch 0xffff880062c6f000 as it
> >> is not his memory.
> >> Also I noticed that the report happens after few minutes of repeatedly
> >> running this program, so I would expect that this is some kind of race
> >> -- either between kernel threads, or maybe between user space threads
> >> and kernel.
> >
> > I somehow think it's a race as well, especially as I have to run the
> > reproducer in an endless loop and break out of it once I have the 1st
> > stacktrace in dmesg. This takes between some minutes up to one hour on my
> > setup.
> >
> > But the race against a userspace thread... Could it be that the reproducer has
> > already exited it's threads while the copy_from_iter() is still running?
> > Normally I'd say no, as user-space shouldn't run while the kernel is doing
> > things in it's address space, but this is highly suspicious.
> >
> >> Or maybe it's just that the next page is not always marked
> >> as free, so we just don't detect the bad access.
> >
> > Could be, but I lack the memory management knowledge to say more than a 'could
> > be'.
> >
> >>
> >> Does it all make any sense to you?
> >> Can you think of any additional sanity checks that will ensure that
> >> this code copies only memory it owns?
> >
> > Given that we pass the 0xffff as dxfer_len it thinks it owns all memory, so
> > this is OK, kinda. All that could be would be that user-space has already
> > exited and thus it's memory is already freed.
> 
> 
> The crash happens in the context of sendfile syscall, we the address
> space should be alive. But the crash happens on address
> 0xffff880062c6f000 which is not a user-space address, right? This is
> something that kernel has allocated previously.
> Do you have CONFIG_DEBUG_PAGEALLOC enabled? I have it enabled. Maybe
> it increases changes of triggering the bug.
> 
> Do we know where that memory that we are copying was allocated? Is it
> slab or page alloc? We could extend KASAN output with more details.
> E.g. print allocation stack for the _first_ byte of memcpy, or
> memorize page alloc/free stacks in page struct using lib/stackdepot.c.

It comes in this way:

drivers/scsi/sg.c:
sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
580         struct sg_header old_hdr;
581         sg_io_hdr_t *hp;
582         unsigned char cmnd[SG_MAX_CDB_SIZE];
[...]
598         if (__copy_from_user(&old_hdr, buf, SZ_SG_HEADER))
599                 return -EFAULT;
[...]
612         buf += SZ_SG_HEADER;
613         __get_user(opcode, buf);
[...]
614         if (sfp->next_cmd_len > 0) {
615                 cmd_size = sfp->next_cmd_len;
616                 sfp->next_cmd_len = 0;  /* reset so only this write() effected */
617         } else {
618                 cmd_size = COMMAND_SIZE(opcode);        /* based on SCSI command group */
619                 if ((opcode >= 0xc0) && old_hdr.twelve_byte)
620                         cmd_size = 12;
621         }
[...]
625         input_size = count - cmd_size;
626         mxsize = (input_size > old_hdr.reply_len) ? input_size : old_hdr.reply_len;
627         mxsize -= SZ_SG_HEADER;
633         hp = &srp->header;
[...]
646                 hp->dxferp = (char __user *)buf + cmd_size;
[...]
654         if (__copy_from_user(cmnd, buf, cmd_size))
655                 return -EFAULT;
[...]
675         k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
[...]
752 static int
753 sg_common_write(Sg_fd * sfp, Sg_request * srp,
754                 unsigned char *cmnd, int timeout, int blocking)
755 {
[...]
772         k = sg_start_req(srp, cmnd);
[...]
1653 static int
1654 sg_start_req(Sg_request *srp, unsigned char *cmd)
1655 {
[...]
1757                 res = blk_rq_map_user(q, rq, md, hp->dxferp,
1758                                       hp->dxfer_len, GFP_ATOMIC);
[...]

block/blk-map.c:
148 int blk_rq_map_user(struct request_queue *q, struct request *rq,
149                     struct rq_map_data *map_data, void __user *ubuf,
150                     unsigned long len, gfp_t gfp_mask)
151 {
[...]
154         int ret = import_single_range(rq_data_dir(rq), ubuf, len, &iov, &i);

lib/iov_iter.c:
1209 int import_single_range(int rw, void __user *buf, size_t len,
1210                  struct iovec *iov, struct iov_iter *i)
1211 {
1217         iov->iov_base = buf;

block/blk-map.c:
148 int blk_rq_map_user(struct request_queue *q, struct request *rq,
149                     struct rq_map_data *map_data, void __user *ubuf,
150                     unsigned long len, gfp_t gfp_mask)
151 {
[...]
159         return blk_rq_map_user_iov(q, rq, map_data, &i, gfp_mask);

and so on....

So the memory for hp->dxferp comes from:
633         hp = &srp->header;
a.k.a.
sg_add_sfp()'s:
2151         sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
And then taken out of the pool by sg_add_request() methinks. So yes it is a
kernel pointer (and the address proves it as well). 

>From my debug instrumentation I see that the dxferp ends up in the
iovec_iter's kvec->iov_base and the faulting address is always dxferp + n *
4k with n in [1, 16] (and we're copying 16 4k pages from the iovec into the
bio).

HTH,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
