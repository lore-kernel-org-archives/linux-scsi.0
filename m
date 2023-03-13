Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D1FC74A4B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 14:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjCMOOY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 10:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjCMOOB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 10:14:01 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DA2302B8;
        Mon, 13 Mar 2023 07:13:39 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id AD48C3420C5;
        Mon, 13 Mar 2023 17:12:59 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=mlZ+JAFFuM3vyxXBiIq4CVvsCPYlrgUuIpoeAJiQIIE=; b=
        JtwIv/1jOXuw/uFLwxfQ16H3gG3tZ6rQCBBwBgoZTpjU9V0GBzD7gVrX7Qx3Ovri
        33dFdiVpbzDmYM8qUgdUL/uDobqUofyFp/i9zb7NgRE4HHAgEYxp/GcPjriEoDqT
        1MhEZQMCtfoYW1V/OxHYOJdeluKpIjiq0roLQqTPPSw=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id A1FD234209D;
        Mon, 13 Mar 2023 17:12:59 +0300 (MSK)
Received: from yadro.com (10.199.20.11) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Mon, 13 Mar
 2023 17:12:58 +0300
Date:   Mon, 13 Mar 2023 17:13:02 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: Re: [PATCH v2 12/12] target: add virtual remote target
Message-ID: <20230313141302.GA1031@yadro.com>
References: <20230307080742.24631-1-d.bogdanov@yadro.com>
 <20230307080742.24631-13-d.bogdanov@yadro.com>
 <f1f56999-931a-ebed-6458-89ff45573e59@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f1f56999-931a-ebed-6458-89ff45573e59@oracle.com>
X-Originating-IP: [10.199.20.11]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 10, 2023 at 04:32:32PM -0600, Mike Christie wrote:
> 
> Just some nits.
> 
> On 3/7/23 2:07 AM, Dmitry Bogdanov wrote:
> > +
> > +static int tcm_remote_port_link(
> > +     struct se_portal_group *se_tpg,
> > +     struct se_lun *lun)
> > +{
> > +     pr_debug("TCM_Remote_ConfigFS: Port Link LUN %lld Successful\n",
> > +               lun->unpacked_lun);
> 
> The l in lun should be one space to the left so it's under the ".
> It will then match the other code and checkpatch won't complain.
> 
> 
> > +     return 0;
> > +}
> > +
> > +static void tcm_remote_port_unlink(
> > +     struct se_portal_group *se_tpg,
> > +     struct se_lun *lun)
> > +{
> > +     pr_debug("TCM_Remote_ConfigFS: Port Unlink LUN %lld Successful\n",
> > +               lun->unpacked_lun);
> 
> Same as above.
> 
> > +}
> > +
> > +static struct se_portal_group *tcm_remote_make_tpg(
> > +     struct se_wwn *wwn,
> > +     const char *name)
> > +{
> > +     struct tcm_remote_hba *remote_hba = container_of(wwn,
> > +                     struct tcm_remote_hba, remote_hba_wwn);
> > +     struct tcm_remote_tpg *remote_tpg;
> > +     unsigned long tpgt;
> > +     int ret;
> > +
> > +     if (strstr(name, "tpgt_") != name) {
> > +             pr_err("Unable to locate \"tpgt_#\" directory group\n");
> > +             return ERR_PTR(-EINVAL);
> > +     }
> > +     if (kstrtoul(name+5, 10, &tpgt))
> 
> Add spaces so it looks like: "name + 5"
> 
> 
> 
> > +}
> > +
> > +static ssize_t tcm_remote_wwn_version_show(struct config_item *item, char *page)
> > +{
> > +     return sprintf(page, "TCM Remote Fabric module %s\n", TCM_REMOTE_VERSION);
> > +}
> 
> 
> Do we need this? I saw other LIO drivers like iscsi, fcoe and loop have them
> but they are never updated so it seems useless.
> 
> For something like stable trying to manage versions is going to be difficult
> as well, so it might just be more confusing.
> 

I absolutely agree that in-kernel modules should not have its own
versions. Kernel version is enough. 

But targetcli tool reads that file for a fabric and I don't want to
work it around when I will add support of remote fabric to it.
So, I am going to keep the version attribute.

> > +
> > +static int __init tcm_remote_fabric_init(void)
> > +{
> > +     int ret = -ENOMEM;
> 
> You can drop the -ENOMEM since we set ret the next line.

I can drop ret variable here at all.

> > +
> > +     ret = target_register_template(&remote_ops);
> > +     if (ret)
> > +             goto out;
> > +
> > +     return 0;
> > +
> > +out:
> > +     return ret;
> > +}
> > +
> 

