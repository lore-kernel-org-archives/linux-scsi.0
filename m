Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F4AC4167D
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 09:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343629AbiBNJ5E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 04:57:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345386AbiBNJ4p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 04:56:45 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5E26FA28
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 01:45:28 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3CDE41F38B;
        Mon, 14 Feb 2022 09:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644831927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1vqtRs7ZGNEa2Dz5exN1o6UntzGxpqKbsatjMWjBCSg=;
        b=HfblhFIjqkgIMPZhK83JijJ8BKIhg/FBq7zNKYvkwGVGJ2/1MWD93kG7IGOuSzpnJuKBbp
        sqitmq7v2nTZSo29FMg6fHcLBQmntmCYZDJQ+RRQvCsUxn/7kikyztTUoo8pimA8AHLEhS
        ghpf1XkyNV5I40YrsITRlqhfq4R6XSc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644831927;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1vqtRs7ZGNEa2Dz5exN1o6UntzGxpqKbsatjMWjBCSg=;
        b=/3wrUHJxzx4Z12w6vpLQ6HxO6k060CPmX0UNfTZ6JyDyXgUr3W/Sej6p7eV+Ye3638CaR8
        wKoHpd31zu/twBDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BEC2813A3C;
        Mon, 14 Feb 2022 09:45:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2zssLrYkCmJJLgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 14 Feb 2022 09:45:26 +0000
Message-ID: <e18ec2d9-e827-b856-e6e9-41e8ada64ad3@suse.de>
Date:   Mon, 14 Feb 2022 10:45:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 06/48] scsi: Remove drivers/scsi/scsi.h
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Russell King <linux@armlinux.org.uk>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Oliver Neukum <oliver@neukum.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-7-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220211223247.14369-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 23:32, Bart Van Assche wrote:
> The following two header files have the same file name: include/scsi/scsi.h
> and drivers/scsi/scsi.h. This is confusing. Remove the latter since the
> following note was added in drivers/scsi/scsi.h in 2004:
> 
> "NOTE: this file only contains compatibility glue for old drivers. All
> these wrappers will be removed sooner or later. For new code please use
> the interfaces declared in the headers in include/scsi/"
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/a2091.c               |  6 +++-
>   drivers/scsi/a3000.c               |  6 +++-
>   drivers/scsi/aha152x.c             |  9 ++++--
>   drivers/scsi/aha1740.c             |  6 +++-
>   drivers/scsi/arm/acornscsi.c       |  6 +++-
>   drivers/scsi/arm/arxescsi.c        |  6 +++-
>   drivers/scsi/arm/cumana_2.c        |  6 +++-
>   drivers/scsi/arm/eesox.c           |  6 +++-
>   drivers/scsi/arm/fas216.c          |  6 +++-
>   drivers/scsi/arm/powertec.c        |  6 +++-
>   drivers/scsi/arm/queue.c           |  6 +++-
>   drivers/scsi/gvp11.c               |  6 +++-
>   drivers/scsi/ips.c                 |  8 ++++--
>   drivers/scsi/megaraid.c            |  8 ++++--
>   drivers/scsi/mvme147.c             |  6 +++-
>   drivers/scsi/pcmcia/aha152x_stub.c |  9 ++++--
>   drivers/scsi/pcmcia/nsp_cs.c       |  5 ++--
>   drivers/scsi/pcmcia/qlogic_stub.c  |  9 ++++--
>   drivers/scsi/qlogicfas.c           |  6 +++-
>   drivers/scsi/qlogicfas408.c        |  6 +++-
>   drivers/scsi/scsi.h                | 46 ------------------------------
>   drivers/scsi/sg.c                  |  8 ++++--
>   drivers/scsi/sgiwd93.c             |  6 +++-
>   drivers/usb/image/microtek.c       |  8 ++++--
>   drivers/usb/storage/debug.c        |  1 -
>   25 files changed, 119 insertions(+), 82 deletions(-)
>   delete mode 100644 drivers/scsi/scsi.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
