From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/4] target: Drop lun_sep_lock for se_lun->lun_se_dev
 RCU usage
Date: Fri, 22 May 2015 01:10:45 -0700
Message-ID: <1432282245.25585.6.camel@haakon3.risingtidesystems.com>
References: <1432278417-29994-1-git-send-email-nab@daterainc.com>
	 <1432278417-29994-3-git-send-email-nab@daterainc.com>
	 <555EE165.3090709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <555EE165.3090709@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-05-22 at 09:57 +0200, Hannes Reinecke wrote:
> On 05/22/2015 09:06 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > With se_port and t10_alua_tg_pt_gp_member being absored into se_lun,
> > there is no need for an extra lock to protect se_lun->lun_se_dev
> > assignment.
> > 
> > Also, convert se_lun->lun_stats to use atomic_long_t within the
> > target_complete_ok_work() completion callback.
> > 
> > Reported-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_device.c    |  1 -
> >  drivers/target/target_core_stat.c      | 65 +++++++++++++++++-----------------
> >  drivers/target/target_core_tpg.c       |  8 ++---
> >  drivers/target/target_core_transport.c | 22 ++++--------
> >  include/target/target_core_base.h      |  9 +++--
> >  5 files changed, 46 insertions(+), 59 deletions(-)
> > 
> 
> [ .. ]
> 
> > diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> > index 8764f1c..f60b74e 100644
> > --- a/drivers/target/target_core_tpg.c
> > +++ b/drivers/target/target_core_tpg.c
> > @@ -601,7 +601,6 @@ struct se_lun *core_tpg_alloc_lun(
> >  	lun->lun_link_magic = SE_LUN_LINK_MAGIC;
> >  	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
> >  	atomic_set(&lun->lun_acl_count, 0);
> > -	spin_lock_init(&lun->lun_sep_lock);
> >  	init_completion(&lun->lun_ref_comp);
> >  	INIT_LIST_HEAD(&lun->lun_deve_list);
> >  	INIT_LIST_HEAD(&lun->lun_dev_link);
> > @@ -638,10 +637,7 @@ int core_tpg_add_lun(
> >  		target_attach_tg_pt_gp(lun, dev->t10_alua.default_tg_pt_gp);
> >  
> >  	mutex_lock(&tpg->tpg_lun_mutex);
> > -
> > -	spin_lock(&lun->lun_sep_lock);
> > -	lun->lun_se_dev = dev;
> > -	spin_unlock(&lun->lun_sep_lock);
> > +	rcu_assign_pointer(lun->lun_se_dev, dev);
> >  
> >  	spin_lock(&dev->se_port_lock);
> >  	dev->export_count++;
> > @@ -683,7 +679,7 @@ void core_tpg_remove_lun(
> >  		dev->export_count--;
> >  		spin_unlock(&dev->se_port_lock);
> >  
> > -		lun->lun_se_dev = NULL;
> > +		rcu_assign_pointer(lun->lun_se_dev, NULL);
> >  	}
> >  
> >  	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
> Doesn't this need to go under 'dev->se_port_lock' like in
> core_tgp_add_lun() ?

Yes, of course.  Adding the following change, and will squash into the
original patch soon.

Thanks for reviewing Hannes!

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index aa08d6b..a3c9121 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -641,9 +641,9 @@ int core_tpg_add_lun(
                target_attach_tg_pt_gp(lun, dev->t10_alua.default_tg_pt_gp);
 
        mutex_lock(&tpg->tpg_lun_mutex);
-       rcu_assign_pointer(lun->lun_se_dev, dev);
 
        spin_lock(&dev->se_port_lock);
+       rcu_assign_pointer(lun->lun_se_dev, dev);
        dev->export_count++;
        list_add_tail(&lun->lun_dev_link, &dev->dev_sep_list);
        spin_unlock(&dev->se_port_lock);
