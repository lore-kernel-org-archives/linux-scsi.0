Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DBBC432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 21:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73CC62070E
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 21:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKVVf2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 16:35:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:56654 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbfKVVf2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 16:35:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2BA40AB76;
        Fri, 22 Nov 2019 21:35:26 +0000 (UTC)
Message-ID: <139c4a1040a9077fff39486f47134960d543ca53.camel@suse.de>
Subject: Re: [PATCH v2 00/15] scsi: qla2xxx: Bug fixes
From:   Martin Wilck <mwilck@suse.de>
To:     Hannes Reinecke <hare@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux@yadro.com
Date:   Fri, 22 Nov 2019 22:36:06 +0100
In-Reply-To: <b84e274f-c20e-9351-27de-4cf1b34916d9@suse.de>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
         <b84e274f-c20e-9351-27de-4cf1b34916d9@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2019-11-22 at 10:14 +0100, Hannes Reinecke wrote:
> On 11/20/19 11:27 PM, Roman Bolshakov wrote:
> > Hi Martin,
> > 
> > The patch series contains fixes for qla2xxx and solves two visible
> > issues:
> >   - Target port in N2N topology doesn't perform login if it has
> > higher
> >     WWPN than initiator
> >   - ABORT TASK TMF leads to crash if it's received shortly after
> > ACL of
> >     an initiator is deleted and there's active I/O from the
> > initiator
> > 
> > It also contains reliability improvements and cleanups.
> > 
> > Unfortunately, there's still an issue the latest patch. The discard
> > works but ELS IOCB for LOGO is likely built incorrectly by
> > qla24xx_els_dcmd_iocb(). The issue can also be exposed when "1" is
> > written to fc_host/hostN/device/issue_logo file with logging turned
> > on.
> > 
> > Changes since v1 (https://patchwork.kernel.org/cover/11141979/):
> > - Fixes target port in N2N mode were added (patches 5-11);
> > - Target port makes explicit LOGO on session teardown in the patch
> > made
> >   by Quinn. Together with patch 1, it helps to immediately turn
> >   fc_remote_port to the Blocked stated on client side and avoids
> > visibly
> >   stuck session;
> > - The last three patches address violation of FCP specification
> > with
> >   regards to handling of ABTS-LS from ports that are not currently
> >   logged in.
> > 
> > Thank you,
> > Roman
> > 
> > Quinn Tran (1):
> >   scsi: qla2xxx: Use explicit LOGO in target mode
> > 
> > Roman Bolshakov (14):
> >   scsi: qla2xxx: Ignore NULL pointer in tcm_qla2xxx_free_mcmd
> >   scsi: qla2xxx: Initialize free_work before flushing it
> >   scsi: qla2xxx: Drop superfluous INIT_WORK of del_work
> >   scsi: qla2xxx: Change discovery state before PLOGI
> >   scsi: qla2xxx: Allow PLOGI in target mode
> >   scsi: qla2xxx: Don't call qlt_async_event twice
> >   scsi: qla2xxx: Fix PLOGI payload and ELS IOCB dump length
> >   scsi: qla2xxx: Configure local loop for N2N target
> >   scsi: qla2xxx: Send Notify ACK after N2N PLOGI
> >   scsi: qla2xxx: Don't defer relogin unconditonally
> >   scsi: qla2xxx: Ignore PORT UPDATE after N2N PLOGI
> >   scsi: qla2xxx: Add async mode for qla24xx_els_dcmd_iocb
> >   scsi: qla2xxx: Add debug dump of LOGO payload and ELS IOCB
> >   scsi: qla2xxx: Handle ABTS according to FCP spec for logged out
> > ports
> > 
> >  drivers/scsi/qla2xxx/qla_attr.c    |  2 +-
> >  drivers/scsi/qla2xxx/qla_def.h     |  1 +
> >  drivers/scsi/qla2xxx/qla_gbl.h     |  2 +-
> >  drivers/scsi/qla2xxx/qla_init.c    | 21 ++++++---------
> >  drivers/scsi/qla2xxx/qla_iocb.c    | 42 ++++++++++++++++++++++++
> > ------
> >  drivers/scsi/qla2xxx/qla_isr.c     |  4 ---
> >  drivers/scsi/qla2xxx/qla_mbx.c     |  3 ++-
> >  drivers/scsi/qla2xxx/qla_target.c  | 34 ++++++++++++++++--------
> >  drivers/scsi/qla2xxx/tcm_qla2xxx.c |  3 +++
> >  9 files changed, 73 insertions(+), 39 deletions(-)
> > 
> This patchset has the nice benefit that it has fixed the crashes on
> rmmod we had been seeing.

Well, I investigated two distinct crash-at-rmmod cases, and one was
already fixed by the earlier commit f45bca8c5052 ("scsi: qla2xxx: Fix
double scsi_done for abort path"), whereas the other is still present,
even after applying this series.

Not to say the series is bad - we just shouldn't raise expectations
too high.

Martin

> 
> So, for the entire patchset:
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Hannes Reinecke <hare@suse.de>
> 


> Cheers,
> 
> Hannes


