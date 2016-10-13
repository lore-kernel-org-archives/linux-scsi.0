From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v2 02/16] scsi: don't use
 fc_bsg_job::request and fc_bsg_job::reply directly
Date: Thu, 13 Oct 2016 18:24:05 +0200
Message-ID: <20161013162405.aoxy3bdkc4bqtwsk@linux-x5ow.site>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <b92d12e4f78c4998bc8ad000359c127e673379f3.1476276823.git.jthumshirn@suse.de>
 <2ea07f3f-88eb-b795-fa37-a223bf80e581@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2ea07f3f-88eb-b795-fa37-a223bf80e581-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "open list:S390 ZFCP DRIVER" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dick Kennedy <dick.kennedy-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Anil Gurumurthy <anil.gurumurthy-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Sudarsana Kalluru <sudarsana.kalluru-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:FCOE SUBSYSTEM (libfc, libfcoe, fcoe)" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, James Smart <james.smart-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Johannes Thumshirn <jth>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 13, 2016 at 05:15:25PM +0200, Steffen Maier wrote:
> I'm puzzled.
> =

> $ git bisect start fc_bsg master
> Bisecting: 8 revisions left to test after this (roughly 3 steps)
> [005d51510eee6102636d5dbb06310531c5d46151] scsi: fc: implement kref backed
> reference counting
> $ git bisect bad
> Bisecting: 3 revisions left to test after this (roughly 2 steps)
> [bef6da201de1bb81bb4d9511f9a155862efc251f] scsi: Unify interfaces of
> fc_bsg_jobdone and bsg_job_done
> $ git bisect bad
> Bisecting: 1 revision left to test after this (roughly 1 step)
> [3087864ce3d7282f59021245d8a5f83ef1caef18] scsi: don't use
> fc_bsg_job::request and fc_bsg_job::reply directly
> $ git bisect bad
> Bisecting: 0 revisions left to test after this (roughly 0 steps)
> [81aea44720d22d2e0c4a2613ae8b1c256ef6b0cb] scsi: Get rid of struct
> fc_bsg_buffer
> > $ git bisect good
> > 3087864ce3d7282f59021245d8a5f83ef1caef18 is the first bad commit
> > commit 3087864ce3d7282f59021245d8a5f83ef1caef18
> > Author: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
> > Date:   Wed Oct 12 15:06:28 2016 +0200
> > =

> >     scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly
> > =

> >     Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but u=
se
> >     helper variables bsg_request and bsg_reply. This will be helpfull  =
when
> >     transitioning to bsg-lib.
> > =

> >     Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
> > =

> > :040000 040000 140c4b6829d5cfaec4079716e0795f63f8bc3bd2 0d9fe2256156795=
50be91fbd9f84c09ab1e280fc M	drivers
> =

> From there (on the reverse bisect path) I get the following Oops,
> except for the full patch set having another stack trace as in my previous
> mail (dying in zfcp code).
> =


[...]

> =

> > @@ -3937,6 +3944,7 @@ fc_bsg_request_handler(struct request_queue *q, s=
truct Scsi_Host *shost,
> >  	struct request *req;
> >  	struct fc_bsg_job *job;
> >  	enum fc_dispatch_result ret;
> > +	struct fc_bsg_reply *bsg_reply;
> > =

> >  	if (!get_device(dev))
> >  		return;
> > @@ -3973,8 +3981,9 @@ fc_bsg_request_handler(struct request_queue *q, s=
truct Scsi_Host *shost,
> >  		/* check if we have the msgcode value at least */
> >  		if (job->request_len < sizeof(uint32_t)) {
> >  			BUG_ON(job->reply_len < sizeof(uint32_t));
> > -			job->reply->reply_payload_rcv_len =3D 0;
> > -			job->reply->result =3D -ENOMSG;
> > +			bsg_reply =3D job->reply;
> > +			bsg_reply->reply_payload_rcv_len =3D 0;
> > +			bsg_reply->result =3D -ENOMSG;
> >  			job->reply_len =3D sizeof(uint32_t);
> >  			fc_bsg_jobdone(job);
> >  			spin_lock_irq(q->queue_lock);
> > =


Ahm and what exactly can break here? It's just assigning variables. Now
I'm puzzled too.

I'll have to look into it tomorrow.

Byte,
        Johannes

-- =

Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
