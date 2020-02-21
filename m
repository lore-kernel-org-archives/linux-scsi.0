Return-Path: <SRS0=iCCw=4J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C990C35646
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 15:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 101AD208E4
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 15:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgBUPh7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 10:37:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:58572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgBUPh7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Feb 2020 10:37:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E0A7EAECA;
        Fri, 21 Feb 2020 15:37:57 +0000 (UTC)
Date:   Fri, 21 Feb 2020 16:37:57 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v3 4/5] qla2xxx: Convert MAKE_HANDLE() from a define into
 an inline function
Message-ID: <20200221153757.qxeustl7k46db54f@beryllium.lan>
References: <20200220043441.20504-1-bvanassche@acm.org>
 <20200220043441.20504-5-bvanassche@acm.org>
 <20200220082155.c2dwknz2hcvwhwcg@beryllium.lan>
 <e91c9277-8a98-6e08-6219-005d03ee97c8@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e91c9277-8a98-6e08-6219-005d03ee97c8@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Thu, Feb 20, 2020 at 08:28:16AM -0800, Bart Van Assche wrote:
> As one can see in __qla2x00_marker() a value is assigned to mrk24->handle()
> by __qla2x00_alloc_iocbs(). That function calls qla2xxx_get_next_handle() to
> determine the 'handle' value. The implementation of that last function is as
> follows:
> 
> uint32_t qla2xxx_get_next_handle(struct req_que *req)
> {
> 	uint32_t index, handle = req->current_outstanding_cmd;
> 
> 	for (index = 1; index < req->num_outstanding_cmds; index++) {
> 		handle++;
> 		if (handle == req->num_outstanding_cmds)
> 			handle = 1;
> 		if (!req->outstanding_cmds[handle])
> 			return handle;
> 	}
> 
> 	return 0;
> }
> 
> Since 'num_outstanding_cmds' is a 16-bit variable I think that guarantees
> that the code quoted in your e-mail passes a 16-bit value as the second
> argument to make_handle().
> 
> Additionally, if the second argument to make_handle() would be larger than
> 0x10000, the following code from qla2x00_status_entry() would map
> sts->handle to another queue and another command than those through wich the
> command was submitted to the firmware:
> 
> 	handle = (uint32_t) LSW(sts->handle);
> 	que = MSW(sts->handle);
> 	req = ha->req_q_map[que];

Thanks for digging through it. I stopped at the function signature :)

Changing the return type of qla2xxx_get_next_handle() would be a new
patch.

In this case this patch is good.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
