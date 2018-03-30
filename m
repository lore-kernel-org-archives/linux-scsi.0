From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: Recent kernels fail to boot on POWER8 with multipath
	SCSI
Date: Fri, 30 Mar 2018 20:04:28 +1100
Message-ID: <87fu4iylwj.fsf@concordia.ellerman.id.au>
References: <20180329083909.GA15766@fergus.ozlabs.ibm.com>
	<20180329151654.GA3839@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180329151654.GA3839@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Paul Mackerras <paulus@ozlabs.org>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Mike,

Paul's AFK so I tried the patch you sent.

Mike Snitzer <snitzer@redhat.com> writes:
> On Thu, Mar 29 2018 at  4:39am -0400,
> Paul Mackerras <paulus@ozlabs.org> wrote:
>> Since commit 8d47e65948dd ("dm mpath: remove unnecessary NVMe
>> branching in favor of scsi_dh checks", 2018-03-05), upstream kernels
>> fail to boot on my POWER8 box which has multipath SCSI disks.  The
>> host adapters are IPR and the userspace is CentOS 7.
...
>
> Please try this patch, it'll likely fix your issues:
>
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index dbddcdc5a4ec..746dd8a75b4a 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -887,7 +887,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
>  
>  	q = bdev_get_queue(p->path.dev->bdev);
>  	attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
> -	if (attached_handler_name) {
> +	if (attached_handler_name || m->hw_handler_name) {
>  		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
>  		r = setup_scsi_dh(p->path.dev->bdev, m, attached_handler_name, &ti->error);
>  		if (r) {

And it does indeed fix the problem. The system boots happily with no warnings.

If you like here's a:

  Tested-by: Michael Ellerman <mpe@ellerman.id.au>

Any prospect of getting that patch to Linus before the 4.16 release? Yes
I realise that's in ~36 hours :)

cheers
