Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF61C1975A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 17:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EE1620772
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 17:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgCYRUC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 13:20:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:55368 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbgCYRUB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Mar 2020 13:20:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 14F99AC22;
        Wed, 25 Mar 2020 17:20:00 +0000 (UTC)
Message-ID: <4fb2d29be88dbef2050cf51210d8e4e14a4b8ac2.camel@suse.com>
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
Date:   Wed, 25 Mar 2020 18:20:02 +0100
In-Reply-To: <dfbd88461ef4b5f56a83db7095c6e3f36b5a485e.camel@suse.com>
References: <20200205214422.3657-1-mwilck@suse.com>
         <20200205214422.3657-2-mwilck@suse.com>
         <alpine.LRH.2.21.9999.2003241648560.12727@irv1user01.caveonetworks.com>
         <dfbd88461ef4b5f56a83db7095c6e3f36b5a485e.camel@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-03-25 at 17:28 +0100, Martin Wilck wrote:
> On Tue, 2020-03-24 at 16:51 -0700, Arun Easi wrote:
> > On Wed, 5 Feb 2020, 1:44pm, mwilck@suse.com wrote:
> > 
> > > From: Martin Wilck <mwilck@suse.com>
> > > 
> > > Since commit 45235022da99 ("scsi: qla2xxx: Fix driver unload by
> > > shutting down chip"),
> > > it is possible that FC commands are scheduled after the adapter
> > > firmware
> > > has been shut down. IO sent to the firmware in this situation
> > > hangs
> > > indefinitely. Avoid this for the LOGO code path that is typically
> > > taken
> > > when adapters are shut down.
> > > 
> > > Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by
> > > shutting
> > > down chip")
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> > > ---
> > >  drivers/scsi/qla2xxx/qla_mbx.c | 3 +++
> > >  drivers/scsi/qla2xxx/qla_os.c  | 3 +++
> > >  2 files changed, 6 insertions(+)
> > > 
> > > [...]
> > > --- a/drivers/scsi/qla2xxx/qla_os.c
> > > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > > @@ -4878,6 +4878,9 @@ qla2x00_post_work(struct scsi_qla_host
> > > *vha,
> > > struct qla_work_evt *e)
> > >  	unsigned long flags;
> > >  	bool q = false;
> > >  
> > > +	if (!vha->hw->flags.fw_started)
> > > +		return QLA_FUNCTION_FAILED;
> > > +
> > 
> > I'd probably not do it here; rather in qla2x00_get_sp() 
> > /qla2x00_start_sp()/ qla2xxx_get_qpair_sp() time. Not all works are
> > for 
> > posting to firmware (QLA_EVT_IDC_ACK, QLA_EVT_UNMAP etc.).
> 
> qla81xx_idc_ack() calls qla2x00_mailbox_command(), which should be
> avoided IMO. But I'll review the various cases and re-post the patch.

Thinking about it once more, the approach is racy. 

qla2x00_try_stop_firmware() can be called any time, and it sets
fw_started = 0 *after* actually stopping the firmware. Even if we check
fw_started, the firwmare might be stopped between our check and our
actual mailbox / FW register access, and we'd end up hanging.

At least the check should be as close as possible to the actual FW
access, e.g. in qla2x00_mailbox_command(), or before writing to the
request queue registers in qla2x00_start_sp() etc.

Perhaps the (!fw_started) condition should be treated like
ABORT_ISP_ACTIVE in qla2x00_mailbox_command, i.e. execute only if
is_rom_cmd() returns true?

I can re-post, but I feel this should really be done by someone who
knows exactly how the firmware operates, IOW Marvell staff.

Regards
Martin


