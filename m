Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5627C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 08:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B07B20738
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 08:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731834AbgFWId7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 04:33:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:49736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731769AbgFWIdz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jun 2020 04:33:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3828CADC1;
        Tue, 23 Jun 2020 08:33:54 +0000 (UTC)
Date:   Tue, 23 Jun 2020 10:33:54 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 7/9] qla2xxx: Fix a Coverity complaint in
 qla2100_fw_dump()
Message-ID: <20200623083354.2fldcoancxym6s6n@beryllium.lan>
References: <20200614223921.5851-1-bvanassche@acm.org>
 <20200614223921.5851-8-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200614223921.5851-8-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Sun, Jun 14, 2020 at 03:39:19PM -0700, Bart Van Assche wrote:
> @@ -1063,7 +1063,8 @@ qla2100_fw_dump(scsi_qla_host_t *vha)
>  	}
>  
>  	if (rval == QLA_SUCCESS)
> -		qla2xxx_copy_queues(ha, &fw->risc_ram[cnt]);
> +		qla2xxx_copy_queues(ha, (char *)fw +
> +				    offsetof(typeof(*fw), risc_ram) + cnt);

This looks pretty ugly to me. Any chance to write this in a way it's
understandable by humans and coverity is not annoyed?

Do I understand it correctly, it's valid to read after the end of risc_ram?

Thanks,
Daniel
