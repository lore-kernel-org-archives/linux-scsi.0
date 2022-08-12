Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974EAC00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 21:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbiHLVRn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 17:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiHLVRm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 17:17:42 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48737392D
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2022 14:17:41 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id CB4E47072D;
        Fri, 12 Aug 2022 21:17:40 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id AD97D60543;
        Fri, 12 Aug 2022 21:17:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id xduQNCBO1jLu; Fri, 12 Aug 2022 21:17:40 +0000 (UTC)
Received: from [192.168.48.17] (host-104-157-202-215.dyn.295.ca [104.157.202.215])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 5157B6053F;
        Fri, 12 Aug 2022 21:17:38 +0000 (UTC)
Message-ID: <7a3b2aea-336a-c2ea-155d-de2b08380793@interlog.com>
Date:   Fri, 12 Aug 2022 17:17:33 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 3/4] scsi: core: Remove procfs support
Content-Language: en-CA
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220812204553.2202539-1-bvanassche@acm.org>
 <20220812204553.2202539-4-bvanassche@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20220812204553.2202539-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-08-12 16:45, Bart Van Assche wrote:
> There are equivalents for all /proc/scsi functionality in sysfs. The most
> prominent user of /proc/scsi is the sg3_utils software package. Support
> for systems without /proc/scsi was added to sg3_utils in 2008. Hence
> remove procfs support from the SCSI core.

Perhaps it is just me but I find 'cat /proc/scsi/sg/debug' very useful
when something goes wrong with the sg driver or something that it depends
on. Part of my sg driver rewrite (3 years and still pending) was to
transfer the output that formerly went to /proc/scsi/sg/debug to
debugfs instead (or as well).

The most recent version of that procfs-->debugfs work for the sg driver
can be found in a post to this list titled: "[PATCH v24 35/46] sg: first
debugfs support" on 20220410.

Put another way, there are many hours of debugging experience that will be
lost by:
   drivers/scsi/sg.c           | 358 ---------------------------

Doug Gilbert


> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/Kconfig        |  11 -
>   drivers/scsi/Makefile       |   1 -
>   drivers/scsi/hosts.c        |   5 -
>   drivers/scsi/scsi.c         |   8 +-
>   drivers/scsi/scsi_devinfo.c | 146 -----------
>   drivers/scsi/scsi_priv.h    |  17 --
>   drivers/scsi/scsi_proc.c    | 477 ------------------------------------
>   drivers/scsi/sg.c           | 358 ---------------------------
>   include/scsi/scsi_host.h    |   6 -
>   9 files changed, 1 insertion(+), 1028 deletions(-)
>   delete mode 100644 drivers/scsi/scsi_proc.c
> 
<snip>
