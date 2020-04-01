Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A621C2D0F2
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 09:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED7FE2077D
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 09:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732110AbgDAJdT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Apr 2020 05:33:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:48922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbgDAJdS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Apr 2020 05:33:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 70130AD94;
        Wed,  1 Apr 2020 09:33:17 +0000 (UTC)
Date:   Wed, 1 Apr 2020 11:33:17 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.com>,
        Saurav Kashyap <skashyap@marvell.com>
Subject: Re: [PATCH] scsi: qedf: Simplify mutex_unlock() usage
Message-ID: <20200401093317.khs3lvjljv7cveey@beryllium.lan>
References: <20200401090120.24958-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401090120.24958-1-dwagner@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 01, 2020 at 11:01:20AM +0200, Daniel Wagner wrote:
> --- a/drivers/scsi/qedf/qedf_els.c
> +++ b/drivers/scsi/qedf/qedf_els.c
> @@ -388,12 +388,11 @@ void qedf_restart_rport(struct qedf_rport *fcport)
>  		mutex_lock(&lport->disc.disc_mutex);
>  		/* Recreate the rport and log back in */
>  		rdata = fc_rport_create(lport, port_id);
> +		mutex_unlock(&lport->disc.disc_mutex);
>  		if (rdata) {
> -			mutex_unlock(&lport->disc.disc_mutex);
>  			fc_rport_login(rdata);
>  			fcport->rdata = rdata;
>  		} else {
> -			mutex_unlock(&lport->disc.disc_mutex);
>  			fcport->rdata = NULL;
>  		}
>  	}

Looking at it again, I think we could even do

	mutex_unlock(&lport->disc.disc_mutex);
	if (rdata)
		fc_rport_login(rdata);
	fcport->rdata = rdata;
