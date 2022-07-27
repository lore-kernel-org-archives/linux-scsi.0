Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2792C04A68
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 06:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbiG0G7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jul 2022 02:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiG0G7B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2022 02:59:01 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2620C25287;
        Tue, 26 Jul 2022 23:58:52 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5D60541228;
        Wed, 27 Jul 2022 06:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1658905130; x=1660719531; bh=yYG8gOzPXRUjAarXaHNqmAo/jvZP/bY9zF7
        wQSL8y50=; b=CGtbr7eH+nsnTuQ2EtFKp2rZtvVZDa3d1X6ZJaxm7B2gvxeUuxs
        baJsylJl/lxzRkLfb4jI2A2sjJu36ihawyVgglki50f3YQ3319v4A/Si3IrzSjHm
        U1kurCt6adSraGW3zYGvIYcnebMCkeWEUPi+/W9IssR6z61AVwn12Efs=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Gvc1RT4x0gUy; Wed, 27 Jul 2022 09:58:50 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 10ED34124D;
        Wed, 27 Jul 2022 09:58:42 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 27 Jul 2022 09:58:42 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 27 Jul
 2022 09:58:41 +0300
Date:   Wed, 27 Jul 2022 09:58:42 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH 1/2] target: core: fix race during ACL removal
Message-ID: <20220727065842.GB31648@yadro.com>
References: <20220720112852.11440-1-d.bogdanov@yadro.com>
 <20220720112852.11440-2-d.bogdanov@yadro.com>
 <e82ed8ab-8d9d-c815-e134-26929e3350aa@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e82ed8ab-8d9d-c815-e134-26929e3350aa@oracle.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 26, 2022 at 04:40:16PM -0500, Mike Christie wrote:
> 
> On 7/20/22 6:28 AM, Dmitry Bogdanov wrote:
> > Under huge load there is a possibility of race condition in updating
> > se_dev_entry object in ACL removal procedure.
> >
> >  NIP [c0080000154093d0] transport_lookup_cmd_lun+0x1f8/0x3d0 [target_core_mod]
> >  LR [c00800001542ab34] target_submit_cmd_map_sgls+0x11c/0x300 [target_core_mod]
> >  Call Trace:
> >    target_submit_cmd_map_sgls+0x11c/0x300 [target_core_mod]
> >    target_submit_cmd+0x44/0x60 [target_core_mod]
> >    tcm_qla2xxx_handle_cmd+0x88/0xe0 [tcm_qla2xxx]
> >    qlt_do_work+0x2e4/0x3d0 [qla2xxx]
> >    process_one_work+0x298/0x5c
> >
> > Despite usage of RCU primitives with deve->se_lun pointer, it has not
> > became dereference-safe. Because deve->se_lun is updated not
> > synchronized with a reader. That change might be in a release function
> > called by synchronize_rcu(). But, in fact, there is no sence to NULL that
> > pointer for deleting deve. So a better solution is to remove that NULLing.
> >
> Hey,
> 
> For the line above about there being no reason to NULL the pointer are you
> saying:
> 
> 
> We should have had a NULL check like:
> 
> transport_lookup_cmd_lun:
> 
> .....
> 
> se_lun = rcu_dereference(deve->se_lun);
> if (!se_lun) {
>         rcu_read_unlock();
>         return TCM_NON_EXISTENT_LUN;
> }
> 
> and it would have prevented the crash.
> 
> But we don't need that or the se_lun RCU use, because the hlist_del_rcu and
> kfree_rcu calls in core_disable_device_list_for_node will make sure that
> transport_lookup_cmd_lun either finds a se_dev_entry and while in use will
> never be freed from under us, or transport_lookup_cmd_lun will never see a
> se_dev_entry.
> 
> 
> If that's what you meant then I agree.
Yes, that is exactly how I thought. All access to deve->se_lun is
already under rcu_read_lock. And either deve->se_lun is always valid or
deve is not valid itself and will not be found in the list_for_*.
Will add more details in the commit message.

