Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D731CC432C2
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 10:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0179217F4
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 10:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfIZKwB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 06:52:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:60134 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725975AbfIZKwB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Sep 2019 06:52:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 76427AE91;
        Thu, 26 Sep 2019 10:51:59 +0000 (UTC)
Message-ID: <767fe8f1a50b10d430c30886031251c8f9e4c2dd.camel@suse.de>
Subject: Re: [PATCH v2 04/14] qla2xxx: Optimize NPIV tear down process
From:   Martin Wilck <mwilck@suse.de>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        Quinn Tran <qutran@marvell.com>
Cc:     linux-scsi@vger.kernel.org
Date:   Thu, 26 Sep 2019 12:52:02 +0200
In-Reply-To: <20190912180918.6436-5-hmadhani@marvell.com>
References: <20190912180918.6436-1-hmadhani@marvell.com>
         <20190912180918.6436-5-hmadhani@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2019-09-12 at 11:09 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> In the case of NPIV port is being torn down, this patch will
> set a flag to indicate VPORT_DELETE. This would prevent relogin
> to be triggered.
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c   |  2 ++
>  drivers/scsi/qla2xxx/qla_def.h    |  1 +
>  drivers/scsi/qla2xxx/qla_gs.c     |  3 ++-
>  drivers/scsi/qla2xxx/qla_mid.c    | 32 ++++++++++++++++++++++-------
> ---
>  drivers/scsi/qla2xxx/qla_os.c     |  7 ++++++-
>  drivers/scsi/qla2xxx/qla_target.c |  1 +
>  6 files changed, 34 insertions(+), 12 deletions(-)
> 
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -66,6 +66,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
>  	uint16_t vp_id;
>  	struct qla_hw_data *ha = vha->hw;
>  	unsigned long flags = 0;
> +	u8 i;
>  
>  	mutex_lock(&ha->vport_lock);
>  	/*
> @@ -75,8 +76,9 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
>  	 * ensures no active vp_list traversal while the vport is
> removed
>  	 * from the queue)
>  	 */
> -	wait_event_timeout(vha->vref_waitq, !atomic_read(&vha-
> >vref_count),
> -	    10*HZ);
> +	for (i = 0; i < 10 && atomic_read(&vha->vref_count); i++)
> +		wait_event_timeout(vha->vref_waitq,
> +		    atomic_read(&vha->vref_count), HZ);

Are you missing a negation in this last line?
Also, what's the point of adding this loop? 


> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1115,9 +1115,14 @@ static inline int
> test_fcport_count(scsi_qla_host_t *vha)
>  void
>  qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
>  {
> +	u8 i;
> +
>  	qla2x00_mark_all_devices_lost(vha, 0);
>  
> -	wait_event_timeout(vha->fcport_waitQ, test_fcport_count(vha),
> 10*HZ);
> +	for (i = 0; i < 10; i++)
> +		wait_event_timeout(vha->fcport_waitQ,
> test_fcport_count(vha),
> +		    HZ);
> +
>  	flush_workqueue(vha->hw->wq);
>  }

Perhaps here, the loop should be exited if test_fcport_count(vha) gets
TRUE? And again, why is the loop necessary?

Regards
Martin


