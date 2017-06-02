From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi: Fix a sleep-in-atomic bug
Date: Thu, 01 Jun 2017 20:20:03 -0700
Message-ID: <1496373603.27407.211.camel@haakon3.risingtidesystems.com>
References: <1496201199-3661-1-git-send-email-baijiaju1990@163.com>
         <1496298093.27407.203.camel@haakon3.risingtidesystems.com>
         <5930BBC1.9070608@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39293 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdFBDUF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 23:20:05 -0400
In-Reply-To: <5930BBC1.9070608@163.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: bart.vanassche@sandisk.com, davem@davemloft.net, hare@suse.com, elfring@users.sourceforge.net, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2017-06-02 at 09:13 +0800, Jia-Ju Bai wrote:
> On 06/01/2017 02:21 PM, Nicholas A. Bellinger wrote:
> > Hi Jia-Ju,
> >
> > On Wed, 2017-05-31 at 11:26 +0800, Jia-Ju Bai wrote:
> >> The driver may sleep under a spin lock, and the function call path is:
> >> iscsit_tpg_enable_portal_group (acquire the lock by spin_lock)
> >>    iscsi_update_param_value
> >>      kstrdup(GFP_KERNEL) -->  may sleep
> >>
> >> To fix it, the "GFP_KERNEL" is replaced with "GFP_ATOMIC".
> >>
> >> Signed-off-by: Jia-Ju Bai<baijiaju1990@163.com>
> >> ---
> >>   drivers/target/iscsi/iscsi_target_parameters.c |    2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> > Btw, the use of tpg->tpg_state_lock in iscsit_tpg_enable_portal_group()
> > while checking existing state and calling iscsi_update_param_value() is
> > not necessary, since lio_target_tpg_enable_store() is already holding
> > iscsit_get_tpg() ->  tpg->tpg_access_lock.
> >
> > How about the following instead to only take tpg->tpg_state_lock when
> > updating tpg->tpg_state instead..?
> >
> > diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
> > index 2e7e08d..abaabba 100644
> > --- a/drivers/target/iscsi/iscsi_target_tpg.c
> > +++ b/drivers/target/iscsi/iscsi_target_tpg.c
> > @@ -311,11 +311,9 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
> >          struct iscsi_tiqn *tiqn = tpg->tpg_tiqn;
> >          int ret;
> >
> > -       spin_lock(&tpg->tpg_state_lock);
> >          if (tpg->tpg_state == TPG_STATE_ACTIVE) {
> >                  pr_err("iSCSI target portal group: %hu is already"
> >                          " active, ignoring request.\n", tpg->tpgt);
> > -               spin_unlock(&tpg->tpg_state_lock);
> >                  return -EINVAL;
> >          }
> >          /*
> > @@ -324,10 +322,8 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
> >           * is enforced (as per default), and remove the NONE option.
> >           */
> >          param = iscsi_find_param_from_key(AUTHMETHOD, tpg->param_list);
> > -       if (!param) {
> > -               spin_unlock(&tpg->tpg_state_lock);
> > +       if (!param)
> >                  return -EINVAL;
> > -       }
> >
> >          if (tpg->tpg_attrib.authentication) {
> >                  if (!strcmp(param->value, NONE)) {
> > @@ -341,6 +337,7 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
> >                          goto err;
> >          }
> >
> > +       spin_lock(&tpg->tpg_state_lock);
> >          tpg->tpg_state = TPG_STATE_ACTIVE;
> >          spin_unlock(&tpg->tpg_state_lock);
> >
> > @@ -353,7 +350,6 @@ int iscsit_tpg_enable_portal_group(struct iscsi_portal_group *tpg)
> >          return 0;
> >
> >   err:
> > -       spin_unlock(&tpg->tpg_state_lock);
> >          return ret;
> >   }
> >
> I think it is fine to me.
> 
> Thanks,
> Jia-Ju Bai

Applied with your Reported-by and Reviewed-by.

Thanks!
