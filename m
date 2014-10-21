From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target updates for v3.18-rc2
Date: Tue, 21 Oct 2014 10:54:58 -0700
Message-ID: <1413914098.19021.3.camel@haakon3.risingtidesystems.com>
References: <1413848357.16343.35.camel@haakon3.risingtidesystems.com>
	 <5446266B.4080800@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5446266B.4080800@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-10-21 at 12:24 +0300, Sagi Grimberg wrote:
> On 10/21/2014 2:39 AM, Nicholas A. Bellinger wrote:
> > Hi Linus,
> >
> > Here are the target updates for v3.18-rc2 code.  These where originally
> > destined for -rc1, but due to the combination of travel last week for
> > KVM Forum and my mistake of taking the three week merge window
> > literally, the pull request slipped..  Apologies for that.
> >
> > A heads-up that you'll hit one minor conflict with scsi.git, that was
> > caught by sfr in linux-next here:
> >
> > http://marc.info/?l=linux-next&m=141223868207635&w=2
> >
> > Please go ahead and pull from:
> >
> >     git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
> >
> > Things where reasonably quiet this round.  The highlights include:
> >
> >    - New userspace backend driver (target_core_user.ko) by Shaohua Li
> >      and Andy Grover
> >    - A number of cleanups in target, iscsi-taret and qla_target code
> >      from Joern Engel
> >    - Fix an OOPs related to queue full handling with CHECK_CONDITION
> >      status from Quinn Tran
> >    - Fix to disable TX completion interrupt coalescing in iser-target,
> >      that was causing problems on some hardware
> >    - Fix for PR APTPL metadata handling with demo-mode ACLs
> >
> > I'm most excited about the new backend driver that uses UIO + shared
> > memory ring to dispatch I/O and control commands into user-space.  This
> > was probably the most requested feature by users over the last couple of
> > years, and opens up a new area of development + porting of existing
> > user-space storage applications to LIO.  Thanks to Shaohua + Andy for
> > making this happen.
> >
> > Also another honorable mention, a new Xen PV SCSI driver was merged via
> > the xen/tip.git tree recently, which puts us now at 10 target drivers in
> > upstream!  Thanks to David Vrabel + Juergen Gross for their work to get
> > this code merged.
> >
> > Thank you,
> >
> 
> Nic,
> 
> Why are these fixes are not included?
> 
> Target/iser: Fix initiator_depth and responder_resources
> Target/iser: Avoid calling rdma_disconnect twice
> Target/iser: Don't put isert_conn inside disconnected handler
> Target/iser: Get isert_conn reference once got to connected_handler
> 
> They are sitting around for some time and  were supposed to make it to
> 3.17, I don't want these to miss 3.18 too...
> 

Those went in for v3.17 with the appropriate CC's for stable.

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/infiniband/ulp/isert?id=c2f88b17a1d97ca4ecd96cc22333a7a4f1407d39
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/infiniband/ulp/isert?id=0fc4ea701fcf5bc51ace4e288af5be741465f776
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/infiniband/ulp/isert?id=38a8316b5d80ddee071d493bae567185c07de359
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/infiniband/ulp/isert?id=1a92e17e39b9a5d476e0a7aa52280e76321834ee

--nab
