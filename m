From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Recent kernels fail to boot on POWER8 with multipath
	SCSI
Date: Fri, 30 Mar 2018 07:49:27 -0400
Message-ID: <20180330114926.GA7000@redhat.com>
References: <20180329083909.GA15766@fergus.ozlabs.ibm.com>
	<20180329151654.GA3839@redhat.com>
	<87fu4iylwj.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87fu4iylwj.fsf@concordia.ellerman.id.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@ozlabs.org>, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 30 2018 at  5:04P -0400,
Michael Ellerman <michael@ellerman.id.au> wrote:

> Hi Mike,
> 
> Paul's AFK so I tried the patch you sent.
> 
> Mike Snitzer <snitzer@redhat.com> writes:
> > On Thu, Mar 29 2018 at  4:39am -0400,
> > Paul Mackerras <paulus@ozlabs.org> wrote:
> >> Since commit 8d47e65948dd ("dm mpath: remove unnecessary NVMe
> >> branching in favor of scsi_dh checks", 2018-03-05), upstream kernels
> >> fail to boot on my POWER8 box which has multipath SCSI disks.  The
> >> host adapters are IPR and the userspace is CentOS 7.
> ...
> >
> > Please try this patch, it'll likely fix your issues:
> >
> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index dbddcdc5a4ec..746dd8a75b4a 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -887,7 +887,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
> >  
> >  	q = bdev_get_queue(p->path.dev->bdev);
> >  	attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
> > -	if (attached_handler_name) {
> > +	if (attached_handler_name || m->hw_handler_name) {
> >  		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
> >  		r = setup_scsi_dh(p->path.dev->bdev, m, attached_handler_name, &ti->error);
> >  		if (r) {
> 
> And it does indeed fix the problem. The system boots happily with no warnings.

Great, thanks for verifying.

> If you like here's a:
> 
>   Tested-by: Michael Ellerman <mpe@ellerman.id.au>

Already sent to Linus and included.

> Any prospect of getting that patch to Linus before the 4.16 release? Yes
> I realise that's in ~36 hours :)

Please, see upstream commit e457edf0b21c873be827b7c2f6b8e1545485c415

Thanks,
Mike
