From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 5/5] virtio-scsi: introduce multiqueue support
Date: Tue, 18 Dec 2012 18:02:26 +0200
Message-ID: <20121218160226.GA28445@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-6-git-send-email-pbonzini@redhat.com>
	<20121218135736.GF26110@redhat.com> <50D078C8.208@redhat.com>
	<20121218150327.GB27400@redhat.com> <50D09100.3060505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <50D09100.3060505@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 18, 2012 at 04:51:28PM +0100, Paolo Bonzini wrote:
> Il 18/12/2012 16:03, Michael S. Tsirkin ha scritto:
> > On Tue, Dec 18, 2012 at 03:08:08PM +0100, Paolo Bonzini wrote:
> >> Il 18/12/2012 14:57, Michael S. Tsirkin ha scritto:
> >>>> -static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
> >>>> +static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
> >>>> +				 struct virtio_scsi_target_state *tgt,
> >>>> +				 struct scsi_cmnd *sc)
> >>>>  {
> >>>> -	struct virtio_scsi *vscsi = shost_priv(sh);
> >>>> -	struct virtio_scsi_target_state *tgt = &vscsi->tgt[sc->device->id];
> >>>>  	struct virtio_scsi_cmd *cmd;
> >>>> +	struct virtio_scsi_vq *req_vq;
> >>>>  	int ret;
> >>>>  
> >>>>  	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
> >>>> @@ -461,7 +533,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
> >>>>  	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
> >>>>  	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
> >>>>  
> >>>> -	if (virtscsi_kick_cmd(tgt, &vscsi->req_vq, cmd,
> >>>> +	req_vq = ACCESS_ONCE(tgt->req_vq);
> >>>
> >>> This ACCESS_ONCE without a barrier looks strange to me.
> >>> Can req_vq change? Needs a comment.
> >>
> >> Barriers are needed to order two things.  Here I don't have the second thing
> >> to order against, hence no barrier.
> >>
> >> Accessing req_vq lockless is safe, and there's a comment about it, but you
> >> still want ACCESS_ONCE to ensure the compiler doesn't play tricks.
> > 
> > That's just it.
> > Why don't you want compiler to play tricks?
> 
> Because I want the lockless access to occur exactly when I write it.

It doesn't occur when you write it. CPU can still move accesses
around. That's why you either need both ACCESS_ONCE and a barrier
or none.

> Otherwise I have one more thing to think about, i.e. what a crazy
> compiler writer could do with my code.  And having been on the other
> side of the trench, compiler writers can have *really* crazy ideas.
> 
> Anyhow, I'll reorganize the code to move the ACCESS_ONCE closer to the
> write and make it clearer.
> 
> >>>> +	if (virtscsi_kick_cmd(tgt, req_vq, cmd,
> >>>>  			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
> >>>>  			      GFP_ATOMIC) == 0)
> >>>>  		ret = 0;
> >>>> @@ -472,6 +545,48 @@ out:
> >>>>  	return ret;
> >>>>  }
> >>>>  
> >>>> +static int virtscsi_queuecommand_single(struct Scsi_Host *sh,
> >>>> +					struct scsi_cmnd *sc)
> >>>> +{
> >>>> +	struct virtio_scsi *vscsi = shost_priv(sh);
> >>>> +	struct virtio_scsi_target_state *tgt = &vscsi->tgt[sc->device->id];
> >>>> +
> >>>> +	atomic_inc(&tgt->reqs);
> >>>
> >>> And here we don't have barrier after atomic? Why? Needs a comment.
> >>
> >> Because we don't write req_vq, so there's no two writes to order.  Barrier
> >> against what?
> > 
> > Between atomic update and command. Once you queue command it
> > can complete and decrement reqs, if this happens before
> > increment reqs can become negative even.
> 
> This is not a problem.  Please read Documentation/memory-barrier.txt:
> 
>    The following also do _not_ imply memory barriers, and so may
>    require explicit memory barriers under some circumstances
>    (smp_mb__before_atomic_dec() for instance):
> 
>         atomic_add();
>         atomic_sub();
>         atomic_inc();
>         atomic_dec();
> 
>    If they're used for statistics generation, then they probably don't
>    need memory barriers, unless there's a coupling between statistical
>    data.
> 
> This is the single-queue case, so it falls under this case.

Aha I missed it's single queue. Correct but please add a comment.

> >>>>  	/* Discover virtqueues and write information to configuration.  */
> >>>> -	err = vdev->config->find_vqs(vdev, 3, vqs, callbacks, names);
> >>>> +	err = vdev->config->find_vqs(vdev, num_vqs, vqs, callbacks, names);
> >>>>  	if (err)
> >>>>  		return err;
> >>>>  
> >>>> -	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0]);
> >>>> -	virtscsi_init_vq(&vscsi->event_vq, vqs[1]);
> >>>> -	virtscsi_init_vq(&vscsi->req_vq, vqs[2]);
> >>>> +	virtscsi_init_vq(&vscsi->ctrl_vq, vqs[0], false);
> >>>> +	virtscsi_init_vq(&vscsi->event_vq, vqs[1], false);
> >>>> +	for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++)
> >>>> +		virtscsi_init_vq(&vscsi->req_vqs[i - VIRTIO_SCSI_VQ_BASE],
> >>>> +				 vqs[i], vscsi->num_queues > 1);
> >>>
> >>> So affinity is true if >1 vq? I am guessing this is not
> >>> going to do the right thing unless you have at least
> >>> as many vqs as CPUs.
> >>
> >> Yes, and then you're not setting up the thing correctly.
> > 
> > Why not just check instead of doing the wrong thing?
> 
> The right thing could be to set the affinity with a stride, e.g. CPUs
> 0-4 for virtqueue 0 and so on until CPUs 3-7 for virtqueue 3.
> 
> Paolo

I think a simple #vqs == #cpus check would be kind of OK for
starters, otherwise let userspace set affinity.
Again need to think what happens with CPU hotplug.

> >> Isn't the same thing true for virtio-net mq?
> >>
> >> Paolo
> > 
> > Last I looked it checked vi->max_queue_pairs == num_online_cpus().
> > This is even too aggressive I think, max_queue_pairs >=
> > num_online_cpus() should be enough.
> > 
