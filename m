Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B77C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 20:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF73A20786
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 20:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgC3UPv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 16:15:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:53422 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbgC3UPv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Mar 2020 16:15:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BB247AD60;
        Mon, 30 Mar 2020 20:15:49 +0000 (UTC)
Message-ID: <05c22eab75d1eefb5c76d85200770bce8d791563.camel@suse.com>
Subject: Re: [PATCH v3 5/5] scsi: qla2xxx: only send certain mailbox
 commands to stopped firmware
From:   Martin Wilck <mwilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Date:   Mon, 30 Mar 2020 22:15:48 +0200
In-Reply-To: <20200327164711.5358-6-mwilck@suse.com>
References: <20200327164711.5358-1-mwilck@suse.com>
         <20200327164711.5358-6-mwilck@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-03-27 at 17:47 +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since commit 45235022da99 ("scsi: qla2xxx: Fix driver unload by
> shutting
> down chip"), it is possible that FC commands are scheduled after the
> adapter firmware has been shut down. IO sent to the firmware in this
> situation may hang. Only certain mailbox commands should be sent in
> this situation.
> 
> This patch identifies the mailbox commands sent during adapter
> initialization (before QLA_FW_STARTED() is called) and allows only
> these to be sent to the firmware in stopped state.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/qla2xxx/qla_mbx.c | 46
> ++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)

Testing with different HW revealed that the list of allowed commands
needs to be extended. Forget this patch for now, please.

Regards
Martin


