From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] scsi, fcoe, libfc: drop scsi host_lock use from
	fc_queuecommand
Date: Fri, 03 Sep 2010 18:20:38 -0700
Message-ID: <1283563238.20549.113.camel@haakon2.linux-iscsi.org>
References: <20100903222715.6237.75737.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.re3.yahoo.com ([66.196.96.86]:39628 "HELO
	smtp103.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752212Ab0IDBYj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2010 21:24:39 -0400
In-Reply-To: <20100903222715.6237.75737.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@intel.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Joe Eykholt <jeykholt@cisco.com>, James Bottomley <James.Bottomley@suse.de>, devel@open-fcoe.org, Robert Love <robert.w.love@intel.com>

On Fri, 2010-09-03 at 15:27 -0700, Vasu Dev wrote:
> Currently fc_queuecommand drops this lock very early on and then re-acquires
> this lock just before return, this re-acquired lock gets dropped immediately
> by its fast path caller scsi_dispatch_cmd, this re-acquire and then immediate
> drop on each IO hits performance especially with small size IOs on multi-core
> systems, this hit is significant about 25% with 512 bytes size IOs.
> 
> This lock is not needed in fc_queuecommand and calling fc_queuecommand
> without this lock held removes above described performance hit.
> 
> So this patch adds unlocked_qcmds flag to drop host_lock before
> calling only fc_queuecommand and removes re-acquire &  then drop
> for  each IO. Added flag, drops this lock only if LLD wants such
> as fcoe.ko does here for fc_queuecommand. This change won't affect
> any existing LLD since added unlocked_qcmds flag will be zero
> in those cases and their host lock uses would effectively remain
> same after this patch.
> 
> As per Mike and Nab comments, restored host lock around SHOST_DEL state
> in scsi_dispatch_cmd.
> 
> Signed-off-by: Vasu Dev <vasu.dev@intel.com>
> ---
>  drivers/scsi/fcoe/fcoe.c    |    1 +
>  drivers/scsi/libfc/fc_fcp.c |   14 +++++---------
>  drivers/scsi/scsi.c         |    7 ++++++-
>  include/scsi/scsi_host.h    |    3 +++
>  4 files changed, 15 insertions(+), 10 deletions(-)
> 

<SNIP>

> index b7bdecb..1814c51 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -636,6 +636,9 @@ struct Scsi_Host {
>  	/* Asynchronous scan in progress */
>  	unsigned async_scan:1;
>  
> +	/* call queuecommand without Scsi_Host lock held */
> +	unsigned unlocked_qcmds:1;
> +

I am not sure why this structure member (or any of the other ones) need
to be using :1 at this point, considering drivers/scsi/hosts.c:scsi_host_alloc()
is doing a kzalloc() on struct Scsi_Host to begin with..

Other than that minor nit, I have merged this patch into branch at
lio-core-2.6.git/scsi-unlocked-qcmds available here:

	git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git scsi-unlocked-qcmds

and via gitweb here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=shortlog;h=refs/heads/scsi-unlocked_qcmds

I will have a look at running some modified TCM_Loop and Linux/iSCSI Initiators tests
using with SHT->unlocked-qcmds=1 in the very near future on this code.  8-)

Many thanks again for your very worthwhile efforts Vasu!

Best,

--nab


