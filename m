Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B97EC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 14:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65CB520671
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 14:04:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R4CdLdn8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgEOOE3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 10:04:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43109 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726140AbgEOOE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 10:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589551466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zbiC0TBqmfkvJH8/XqJKEDi7cuiGQIr36gTQddDbT0Y=;
        b=R4CdLdn8FIOjMU+yRH4M07UxigsOzSnsups1kuw8M1QAWAs+bt2P9p0/TaHEnLwFYWhp7e
        YEWQEQewoMDjPTLGhdZBnDKlDEbhuIPf2h8mNETZMAq1dz8rrrj/kVw0Rp1ezkOGldP8Gj
        aOGAKKZ/wtNBj6xTOWHTpuR1uX+uyCY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-GdiS8rhdOpy2faqJ-Vc0Rg-1; Fri, 15 May 2020 10:04:25 -0400
X-MC-Unique: GdiS8rhdOpy2faqJ-Vc0Rg-1
Received: by mail-qt1-f198.google.com with SMTP id u38so2564660qtc.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2020 07:04:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zbiC0TBqmfkvJH8/XqJKEDi7cuiGQIr36gTQddDbT0Y=;
        b=t40yv/zp9m+OIut9DDeoDP45f5gtlMFxuILTmkqqdvXT3fnkYDYWVZRIhPuIDBYMoO
         Hd2hol5Ykfj2oSfyoBXzMxRwGIsNmZmI60FbbYCJ3b+TFAg2Rr/lyz4d+ZsIWMnIB8na
         MAJr7NfFI4a+W0Xb4n2yeJdov0F1jm+bgVAXs1jPYOfNp5EMCi6SNgK8fxihbNdA45/j
         RRvfhqX7H+P2ifxoRkWiPB/0AkhIzxaGX7k1QpobOjtLscXabYUQ5BIMp9FxA0JUn06i
         GL2JPgrVWiIoaBsELj/DQsHP2DGX3xeQVJXjL/B7SydMOCPITOZsX8V6ucuyaOHq8lgl
         3pqw==
X-Gm-Message-State: AOAM533+exJTBZHfEUdTPkjoaOVwS1IzOxSJ0VnbanQD7Uj3Jc/ai2Zb
        H9dXYNvsHkyirEr8XkJo4rdM77XWpjn/cQ9maz6dtNuUx042U4aj2lGJp7XJuoNx2vMKHOtexHI
        ikvidxgybV+gArBGXbZIp3A==
X-Received: by 2002:a37:628b:: with SMTP id w133mr3476520qkb.185.1589551462640;
        Fri, 15 May 2020 07:04:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxV/jkCrxwMX2lc/GdbkmN0VisOUqS36Q5WVUpyh714Sb7KllSIcPdJu3G7tA9C0LSCP1yVhQ==
X-Received: by 2002:a37:628b:: with SMTP id w133mr3476465qkb.185.1589551462165;
        Fri, 15 May 2020 07:04:22 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id o14sm1608274qkj.27.2020.05.15.07.04.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 07:04:21 -0700 (PDT)
Message-ID: <62ac9a52021d3217171a9d1a3ce5eef913780273.camel@redhat.com>
Subject: Re: [PATCH] fnic: to not call 'scsi_done()' for unhandled commands
From:   Laurence Oberman <loberman@redhat.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Date:   Fri, 15 May 2020 10:04:20 -0400
In-Reply-To: <5aa5ed17-e763-4b07-7526-fe1c97c04f31@suse.de>
References: <20200515112647.49260-1-hare@suse.de>
         <fe3e6ab8cfeb23dc46f0413ddfd47efe5e33df7f.camel@redhat.com>
         <5aa5ed17-e763-4b07-7526-fe1c97c04f31@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-05-15 at 15:52 +0200, Hannes Reinecke wrote:
> On 5/15/20 3:06 PM, Laurence Oberman wrote:
> > On Fri, 2020-05-15 at 13:26 +0200, Hannes Reinecke wrote:
> > > The fnic drivers assigns an ioreq structure to each command, and
> > > severs this assignment once scsi_done() has been called and the
> > > command has been completed.
> > > So when traversing commands to terminate outstanding I/O we
> > > should
> > > not call scsi_done() on commands which do not have a
> > > corresponding
> > > ioreq structure; these commands have either never entered the
> > > driver
> > > or have already been completed.
> > > 
> > > Signed-off-by: Hannes Reinecke <hare@suse.com>
> > > ---
> > >   drivers/scsi/fnic/fnic_scsi.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/fnic/fnic_scsi.c
> > > b/drivers/scsi/fnic/fnic_scsi.c
> > > index 27535c90b248..8d2798cbd30f 100644
> > > --- a/drivers/scsi/fnic/fnic_scsi.c
> > > +++ b/drivers/scsi/fnic/fnic_scsi.c
> > > @@ -1401,7 +1401,7 @@ static void fnic_cleanup_io(struct fnic
> > > *fnic,
> > > int exclude_id)
> > >   		}
> > >   		if (!io_req) {
> > >   			spin_unlock_irqrestore(io_lock, flags);
> > > -			goto cleanup_scsi_cmd;
> > > +			continue;
> > >   		}
> > >   
> > >   		CMD_SP(sc) = NULL;
> > 
> > Hi Hannes,
> > Thanks for this patch, but can you share what the impact was of
> > this
> > issue.
> > What diod you see in logs/behavior
> > 
> 
> Unmap the LUNs from the array, and reboot the machine.
> Causing a nice kernel oops in fnic_terminate_rport_io:
> 
> [   41.904013]  rport-3:0-2: blocked FC remote port time out:
> removing rport
> [   41.911625] BUG: kernel NULL pointer dereference, address: 
> 0000000000000040
> [   41.919408] #PF: supervisor read access in kernel mode
> [   41.919409] #PF: error_code(0x0000) - not-present page
> [   41.919411] PGD 0 P4D 0
> [   41.919416] Oops: 0000 [#1] SMP PTI
> [   41.919420] CPU: 1 PID: 219 Comm: kworker/1:1 Kdump: loaded
> Tainted: 
> G               X   5.3.18-16-default #1 SLE15-SP2 (unreleased)
> [   41.919421] Hardware name: Cisco Systems Inc 
> UCSC-C220-M3S/UCSC-C220-M3S, BIOS C220M3.3.0.4e.0.1106191007
> 11/06/2019
> [   41.919433] Workqueue: fc_wq_3 fc_rport_final_delete
> [scsi_transport_fc]
> [   41.919443] RIP: 0010:fnic_terminate_rport_io+0x2db/0x6c0 [fnic]
> [   41.919446] Code: 3c c2 e8 48 00 95 f5 48 85 c0 49 89 c5 74 2c 48
> 05 
> 20 01 00 00 48 89 44 24 10 74 1f 49 8b 85 58 01 00 00 48 8b 80 c0 01
> 00 
> 00 <48> 8b 78 40 e8 1c 0f e4 ff 85 c0 0f 85 b2 fd ff ff 4c 89 e6 48
> 89
> [   41.919448] RSP: 0018:ffffa521c164bde0 EFLAGS: 00010082
> [   41.919450] RAX: 0000000000000000 RBX: ffff8c33633587c8 RCX: 
> ffff8c3363358bc0
> [   41.919452] RDX: ffff8c336347bc80 RSI: 0000000000000080 RDI: 
> ffff8c33632dd8c0
> [   41.919453] RBP: ffff8c3363359208 R08: 00335f71775f6366 R09: 
> 8080808080808080
> [   41.919455] R10: ffffa521c0087dc8 R11: fefefefefefefeff R12: 
> 0000000000000246
> [   41.919456] R13: ffff8c33633e8100 R14: ffff8c24470a4000 R15: 
> 0000000000000080
> [   41.919459] FS:  0000000000000000(0000) GS:ffff8c33bfa40000(0000) 
> knlGS:0000000000000000
> [   41.919461] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   41.919466] CR2: 0000000000000040 CR3: 000000011340a003 CR4: 
> 00000000000606e0
> [   42.066910] Call Trace:
> [   42.066929]  fc_terminate_rport_io+0x51/0x70 [scsi_transport_fc]
> [   42.066935]  fc_rport_final_delete+0x53/0x1e0 [scsi_transport_fc]
> [   42.066943]  process_one_work+0x1f4/0x3e0
> [   42.066947]  worker_thread+0x2d/0x3e0
> [   42.066951]  ? process_one_work+0x3e0/0x3e0
> [   42.066954]  kthread+0x10d/0x130
> [   42.066957]  ? kthread_park+0xa0/0xa0
> [   42.066961]  ret_from_fork+0x35/0x40
> 
> Cheers,
> 
> Hannes

Awesome, Ok Thank you!
I looked at the patch and it looks correct to me at least.
I will add a Review but prob best to have the Cisco fnic folks also
review.
Thank you for catching this.

Reviewed-by: Laurence Oberman <loberman@redhat.com>



