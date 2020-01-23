Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECF9C2D0DB
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 10:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB09D2467B
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 10:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgAWKgo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 05:36:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:58174 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgAWKgo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 05:36:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B7192AD07;
        Thu, 23 Jan 2020 10:36:42 +0000 (UTC)
Date:   Thu, 23 Jan 2020 11:36:42 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2 4/6] qla2xxx: Fix sparse warnings triggered by the PCI
 state checking code
Message-ID: <20200123103642.znoywsm3o3pbuney@beryllium.lan>
References: <20200123042345.23886-1-bvanassche@acm.org>
 <20200123042345.23886-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123042345.23886-5-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 22, 2020 at 08:23:43PM -0800, Bart Van Assche wrote:
> This patch fixes the following sparse warnings:
> 
> drivers/scsi/qla2xxx/qla_mbx.c:120:21: warning: restricted pci_channel_state_t degrades to integer
> drivers/scsi/qla2xxx/qla_mbx.c:120:37: warning: restricted pci_channel_state_t degrades to integer
> 
> From include/linux/pci.h:
> 
> enum pci_channel_state {
> 	/* I/O channel is in normal state */
> 	pci_channel_io_normal = (__force pci_channel_state_t) 1,
> 
> 	/* I/O to channel is blocked */
> 	pci_channel_io_frozen = (__force pci_channel_state_t) 2,
> 
> 	/* PCI card is dead */
> 	pci_channel_io_perm_failure = (__force pci_channel_state_t) 3,
> };
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Daniel Wagner <dwagner@suse.de>
