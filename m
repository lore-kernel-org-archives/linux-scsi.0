Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1910BC2D0E5
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 18:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F19FE2074D
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 18:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgCYSVA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 14:21:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:48150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbgCYSVA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Mar 2020 14:21:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4DEAEACC6;
        Wed, 25 Mar 2020 18:20:59 +0000 (UTC)
Message-ID: <940e20ba5d117b6fd181e0acdac14b7682ff2d64.camel@suse.com>
Subject: Re: [PATCH v2 1/3] scsi: qla2xxx: avoid sending mailbox commands if
 firmware is stopped
From:   Martin Wilck <mwilck@suse.com>
To:     Arun Easi <aeasi@marvell.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Daniel Wagner <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Date:   Wed, 25 Mar 2020 19:21:01 +0100
In-Reply-To: <4fb2d29be88dbef2050cf51210d8e4e14a4b8ac2.camel@suse.com>
References: <20200205214422.3657-1-mwilck@suse.com>
         <20200205214422.3657-2-mwilck@suse.com>
         <alpine.LRH.2.21.9999.2003241648560.12727@irv1user01.caveonetworks.com>
         <dfbd88461ef4b5f56a83db7095c6e3f36b5a485e.camel@suse.com>
         <4fb2d29be88dbef2050cf51210d8e4e14a4b8ac2.camel@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-03-25 at 18:20 +0100, Martin Wilck wrote:
> Perhaps the (!fw_started) condition should be treated like
> ABORT_ISP_ACTIVE in qla2x00_mailbox_command, i.e. execute only if
> is_rom_cmd() returns true?

No, this won't be sufficient, as e.g. MBC_IOCB_COMMAND_A64 is in
rom_cmds[], but has been found to hang (this is why I had the hunk in
qla24xx_fabric_logout()). The list of mailbox commands
that must be passed on when the FW is stopped has to be shorter than
rom_cmds[].

Better suggestions welcome.

Martin


