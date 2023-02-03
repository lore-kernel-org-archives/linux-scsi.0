Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E276C636D4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Feb 2023 15:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbjBCPkX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Feb 2023 10:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjBCPkV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2023 10:40:21 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C77012053;
        Fri,  3 Feb 2023 07:40:18 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 95937341CB2;
        Fri,  3 Feb 2023 18:40:16 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=4M3BRHS3kT0ZiUd9WdlJeLBYBP7mxP034J8rr2w3T54=; b=
        cvvJwiXPwnHmhZmu4cQxvmMSZz0NJmAvCpIvfYGxbvC/ErUyHKpKvbYYOJqykDhm
        3Q2PJH2PFHTNh/fnIPm3Ezp5B35HCP9yUpQ2JKvmHwbZ1qOVsQFUZ0jRc872t9Ek
        mdYrDGhU0lIQtG8Mk+0JtOAmVsZ4jcJ3ae5u9u2DDHc=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 8C178341CA9;
        Fri,  3 Feb 2023 18:40:16 +0300 (MSK)
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 3 Feb 2023
 18:40:14 +0300
Date:   Fri, 3 Feb 2023 18:40:06 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: Re: [RESEND] target: add virtual remote target
Message-ID: <20230203154006.GM31614@yadro.com>
References: <20221202122319.28508-1-d.bogdanov@yadro.com>
 <4c3e72fb-a61e-2cf4-31fd-51ccb8104792@oracle.com>
 <20230201084852.GK31614@yadro.com>
 <221bc4d0-082d-e313-a11b-4d0eabed002f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <221bc4d0-082d-e313-a11b-4d0eabed002f@oracle.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 01, 2023 at 11:00:01AM -0600, Mike Christie wrote:
> 
> On 2/1/23 02:48, Dmitry Bogdanov wrote:
> > On Tue, Jan 31, 2023 at 01:09:57PM -0600, Mike Christie wrote:
> >>
> >> On 12/2/22 06:23, Dmitry Bogdanov wrote:
> >>> +
> >>> +static void tcm_remote_port_unlink(
> >>> +     struct se_portal_group *se_tpg,
> >>> +     struct se_lun *lun)
> >>> +{
> >>> +     pr_debug("TCM_Remote_ConfigFS: Port Unlink LUN %lld Successful\n",
> >>> +               lun->unpacked_lun);
> >>> +}
> >>> +
> >>> +/* End items for tcm_remote_port_cit */
> >>> +
> >>> +/* Start items for tcm_remote_naa_cit */
> >>> +
> >>> +static struct se_portal_group *tcm_remote_make_tpg(struct se_wwn *wwn,
> >>> +                                                  const char *name)
> >>> +{
> >>
> >> The patch seems ok.
> >>
> >> My only comments are on coding style:
> >>
> >> 1. I know we have a mismatch in other lio code like above where sometimes we
> >> don't put any args on the first line after the "(" in tcm_remote_port_unlink
> >> and sometimes we do the above. Since this is new code, could you do the more
> >> standard style?
> >
> > Yes, I will do it.
> >
> >> 2. Maybe for some of these callouts where most drivers are returning the same
> >> hard coded value we shouldn't make them mandatory. target_fabric_tf_ops_check
> >> should just set a default callout.
> >
> > I see that those hardcoded values are different (0 or 1) in the drivers :)
> > Most likely they can be the same, but those values are exported to sysfs
> > and potentially it could break some userspace. That would add a much of
> > questions.
> 
> I think you misunderstood me. I'm not saying we change any values. We just:
> 1. Add default callouts which are set if the driver does not have one
> and/or
> 2. Remove the requirement for some callouts.
> 
> so drivers don't have to know about some of the LIO details and don't need
> to fill the same thing for these callouts.
> 
> For example for the drivers that typically hard code values or have empty
> callouts similar to the new driver then we could normally have a default
> callout that LIO sets:
> 
>         srp    ibmv    loop    sbp     fcoe    usb     vhost   xen
> 
> tpg_check_demo_mode
>         0       1       1       1       0       1       1       1
> tpg_check_demo_mode_cache
>         1       1       0       1       0       0       1       0
> tpg_check_demo_mode_write_protect
>         1       0       0       0       0       0       0       0
> tpg_check_prod_mode_write_protect
>         0       0       0       0       0       0       0       0
> tpg_check_prod_mode_write_protect
>         0       0       0       0       0       0       0       0
> tpg_get_inst_index
>         1       1       1       1       user    1       1       1
> sess_get_index
>         0       0       1       0       user    0       0       0
> set_default_node_attributes (only used by iscsi)
>         empty   empty   empty   empty   empty   empty   empty   empty

Thank you for the table! I was looking only at sess_get_index that has 1
or 0. Actually I may make sess_get_index_def return 0 and for tcm_loop
keep its own sess_get_index function with 1 to keep backward
compatibility.

> 
> Notes:
> 1. qla, iscsi and efct allow users to set some of these values so I didn't
> include them as they would would always set the callout.
> 
> So you could probably have:
> 
>         if (!tfo->tpg_check_demo_mode)
>                 tfo->tpg_check_demo_mode = target_enable_feature,
>         /*
>          * This one is a weird one. I think vhost should actually be disabled
>          * like xen/usb/loop. I think srp/fcoe/efct should have worked like
>          * iscsi/qla. So just make it disabled by default below, then let
>          * srp/fcoe/efct/iscsi/qla/vhost set a callout to override for now so
>          * the behavior doesn't change.
>          */
>         if (!tfo->tpg_check_demo_mode_cache)
>                 tfo->tpg_check_demo_mode_cache = target_disable_feature,
> 
>         if (!tfo->tpg_check_demo_mode_write_protect)
>                 tfo->tpg_check_demo_mode_write_protect = target_disable_feature,
> ...
> 
>         /*
>          * I think we want to have tcm_remote_sess_get_index use 0 like
>          * all the drivers but loop/fcoe, and can use the default then.
>          */
>         if (!tfo->sess_get_index)
>                 /* this would return 0 */
>                 tfo->sess_get_index = target_get_def_sess_index;
> 
>         if (!tfo->tpg_get_inst_index)
>                 /* this would return 1 */
>                 tfo->tpg_get_inst_index = target_get_def_inst_index;
> ...
>         if (!tfo->set_default_node_attributes)
>                 tfo->set_default_node_attributes = target_set_no_attrs;
> 
> 
> Or instead of making us always having a callout, then make it optional.
> set_default_node_attributes can probably be optional because only iscsi
> uses it.
>
> > I would like to keep this patch as much as simple.
> >
> 
> I think for new drivers and features it's common to add new code and
> improve the infrastructure you are going to use. If you think my
> suggestion does not improve the code then I can see that.
> 

You've convinced me, I will do it.

BR,
 Dmitry

