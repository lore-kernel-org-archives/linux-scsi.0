From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] bfa: fix access to bfad_im_port_s
Date: Wed, 06 Dec 2017 07:40:12 -0800
Message-ID: <1512574812.3215.6.camel@HansenPartnership.com>
References: <20171128152657.13421-1-jthumshirn@suse.de>
         <1512542843.29950.8.camel@HansenPartnership.com>
         <mqdbmjce0te.fsf@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <mqdbmjce0te.fsf@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-12-06 at 09:07 +0100, Johannes Thumshirn wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> > 
> > On Tue, 2017-11-28 at 16:26 +0100, Johannes Thumshirn wrote:
> > > 
> > > Commit 'cd21c605b2cf ("scsi: fc: provide fc_bsg_to_shost()
> > > helper")'
> > > changed access to bfa's 'struct bfad_im_port_s' by using
> > > shost_priv()
> > > instead of shost->hostdata[0].
> > > 
> > > This lead to crashes like in the following back-trace:
> > > 
> > > task: ffff880046375300 ti: ffff8800a2ef8000 task.ti:
> > > ffff8800a2ef8000
> > > RIP: e030:[<ffffffffa04c8252>]  [<ffffffffa04c8252>]
> > > bfa_fcport_get_attr+0x82/0x260 [bfa]
> > > RSP: e02b:ffff8800a2efba10  EFLAGS: 00010046
> > > RAX: 575f415441536432 RBX: ffff8800a2efba28 RCX: 0000000000000000
> > > RDX: 0000000000000000 RSI: ffff8800a2efba28 RDI: ffff880004dc31d8
> > > RBP: ffff880004dc31d8 R08: 0000000000000000 R09: 0000000000000001
> > > R10: ffff88011fadc468 R11: 0000000000000001 R12: ffff880004dc31f0
> > > R13: 0000000000000200 R14: ffff880004dc61d0 R15: ffff880004947a10
> > > FS:  00007feb1e489700(0000) GS:ffff88011fac0000(0000)
> > > knlGS:0000000000000000
> > > CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > CR2: 00007ffe14e46c10 CR3: 00000000957b8000 CR4: 0000000000000660
> > > Stack:
> > >  ffff88001d4da000 ffff880004dc31c0 ffffffffa048a9df
> > > ffffffff81e56380
> > >  0000000000000000 0000000000000000 0000000000000000
> > > 0000000000000000
> > > [] bfad_iocmd_ioc_get_info+0x4f/0x220 [bfa]
> > > [] bfad_iocmd_handler+0xa00/0xd40 [bfa]
> > > [] bfad_im_bsg_request+0xee/0x1b0 [bfa]
> > > [] fc_bsg_dispatch+0x10b/0x1b0 [scsi_transport_fc]
> > > [] bsg_request_fn+0x11d/0x1c0
> > > [] __blk_run_queue+0x2f/0x40
> > > [] blk_execute_rq_nowait+0xa8/0x160
> > > [] blk_execute_rq+0x77/0x120
> > > [] bsg_ioctl+0x1b6/0x200
> > > [] do_vfs_ioctl+0x2cd/0x4a0
> > > [] SyS_ioctl+0x74/0x80
> > > [] entry_SYSCALL_64_fastpath+0x12/0x6d
> > > 
> > > Fixes: cd21c605b2cf ("scsi: fc: provide fc_bsg_to_shost()
> > > helper")
> > > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > > Cc: Michal Koutný <mkoutny@suse.com>
> > > ---
> > >  drivers/scsi/bfa/bfad_bsg.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/bfa/bfad_bsg.c
> > > b/drivers/scsi/bfa/bfad_bsg.c
> > > index 72ca2a2e08e2..09ef68c8225f 100644
> > > --- a/drivers/scsi/bfa/bfad_bsg.c
> > > +++ b/drivers/scsi/bfa/bfad_bsg.c
> > > @@ -3135,7 +3135,8 @@ bfad_im_bsg_vendor_request(struct bsg_job
> > > *job)
> > >  	struct fc_bsg_request *bsg_request = job->request;
> > >  	struct fc_bsg_reply *bsg_reply = job->reply;
> > >  	uint32_t vendor_cmd = bsg_request-
> > > > 
> > > > rqst_data.h_vendor.vendor_cmd[0];
> > > -	struct bfad_im_port_s *im_port =
> > > shost_priv(fc_bsg_to_shost(job));
> > > +	struct Scsi_Host *shost = fc_bsg_to_shost(job);
> > > +	struct bfad_im_port_s *im_port = shost->hostdata[0];
> > >  	struct bfad_s *bfad = im_port->bfad;
> > >  	void *payload_kbuf;
> > >  	int rc = -EINVAL;
> > > @@ -3350,7 +3351,8 @@ int
> > >  bfad_im_bsg_els_ct_request(struct bsg_job *job)
> > >  {
> > >  	struct bfa_bsg_data *bsg_data;
> > > -	struct bfad_im_port_s *im_port =
> > > shost_priv(fc_bsg_to_shost(job));
> > > +	struct Scsi_Host *shost = fc_bsg_to_shost(job);
> > > +	struct bfad_im_port_s *im_port = shost->hostdata[0];
> > >  	struct bfad_s *bfad = im_port->bfad;
> > >  	bfa_bsg_fcpt_t *bsg_fcpt;
> > >  	struct bfad_fcxp    *drv_fcxp;
> > 
> > OK, so we had a linux next failure with this:
> > 
> >     After merging the scsi tree, today's linux-next build (x86_64
> >     allmodconfig) produced these warnings:
> > 
> >     drivers/scsi/bfa/bfad_bsg.c: In function
> > 'bfad_im_bsg_vendor_request':
> >     drivers/scsi/bfa/bfad_bsg.c:3137:35: warning: initialization
> > makes pointer from integer without a cast [-Wint-conversion]
> >       struct bfad_im_port_s *im_port = shost->hostdata[0];
> >                                        ^
> >     drivers/scsi/bfa/bfad_bsg.c: In function
> > 'bfad_im_bsg_els_ct_request':
> >     drivers/scsi/bfa/bfad_bsg.c:3353:35: warning: initialization
> > makes pointer from integer without a cast [-Wint-conversion]
> >       struct bfad_im_port_s *im_port = shost->hostdata[0];
> >                                        ^
> > 
> >     Introduced by commit
> > 
> >       45349821ab3a ("scsi: bfa: fix access to bfad_im_port_s")
> > 
> >     -- 
> >     Cheers,
> >     Stephen Rothwell
> > 
> > The reason is you should be using shost_priv(shost) not shost-
> > >hostdata[0].
> 
> 
> Yes, but using shost_priv() was resulting in the crash beforehand.
> 
> shost_priv() doesn't do the same actually:
> static inline void *shost_priv(struct Scsi_Host *shost)
> {
>         return (void *)shost->hostdata;
> }
> vs
>         shost->hostdata[0];
> and:
> drivers/scsi/bfa/bfad_im.c:567: im_port->shost->hostdata[0] =
> (unsigned
> long)im_port;
> 
> The quick fix would be:
> 
> diff --git a/drivers/scsi/bfa/bfad_bsg.c
> b/drivers/scsi/bfa/bfad_bsg.c
> index 09ef68c8225f..075185db533f 100644
> --- a/drivers/scsi/bfa/bfad_bsg.c
> +++ b/drivers/scsi/bfa/bfad_bsg.c
> @@ -3136,7 +3136,7 @@ bfad_im_bsg_vendor_request(struct bsg_job *job)
>  	struct fc_bsg_reply *bsg_reply = job->reply;
>  	uint32_t vendor_cmd = bsg_request-
> >rqst_data.h_vendor.vendor_cmd[0];
>  	struct Scsi_Host *shost = fc_bsg_to_shost(job);
> -	struct bfad_im_port_s *im_port = shost->hostdata[0];
> +	struct bfad_im_port_s *im_port = (struct bfad_im_port_s *)
> shost->hostdata[0];
>  	struct bfad_s *bfad = im_port->bfad;
>  	void *payload_kbuf;
>  	int rc = -EINVAL;
> @@ -3352,7 +3352,7 @@ bfad_im_bsg_els_ct_request(struct bsg_job *job)
>  {
>  	struct bfa_bsg_data *bsg_data;
>  	struct Scsi_Host *shost = fc_bsg_to_shost(job);
> -	struct bfad_im_port_s *im_port = shost->hostdata[0];
> +	struct bfad_im_port_s *im_port = (struct bfad_im_port_s *)
> shost->hostdata[0];
>  	struct bfad_s *bfad = im_port->bfad;
>  	bfa_bsg_fcpt_t *bsg_fcpt;
>  	struct bfad_fcxp    *drv_fcxp;
> 
> Which is also consistent with the rest of the driver.

The crash before was because there was a level of indirection missing,
so what I meant something like

static inline struct bfad_import_s *
bfad_shost_priv(struct Scsi_Host *shost)
{
	return *(struct bfad_im_port_s **)shost_priv(shost);
}

So we're using the correct primitives.  Using a wrapper should ensure
the same mistake isn't made again.

James
