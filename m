From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] qla2xxx: avoid maybe_uninitialized warning
Date: Tue, 15 Mar 2016 14:49:14 -0700
Message-ID: <1458078554.2375.97.camel@linux.vnet.ibm.com>
References: <1458078051-529344-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:57030 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbcCOVt0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2016 17:49:26 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Tue, 15 Mar 2016 17:49:25 -0400
In-Reply-To: <1458078051-529344-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, qla2xxx-upstream@qlogic.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Alexei Potashnik <alexei@purestorage.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Swapnil Nagle <swapnil.nagle@purestorage.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2016-03-15 at 22:40 +0100, Arnd Bergmann wrote:
> The qlt_check_reserve_free_req() function produces an incorrect 
> warning when CONFIG_PROFILE_ANNOTATED_BRANCHES is set:
> 
> drivers/scsi/qla2xxx/qla_target.c: In function
> 'qlt_check_reserve_free_req':
> drivers/scsi/qla2xxx/qla_target.c:1887:3: error: 'cnt_in' may be used
> uninitialized in this function [-Werror=maybe-uninitialized]
>    ql_dbg(ql_dbg_io, vha, 0x305a,
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        "qla_target(%d): There is no room in the request ring: vha
> ->req->ring_index=%d, vha->req->cnt=%d, req_cnt=%d Req-out=%d Req
> -in=%d Req-Length=%d\n",
>       
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~~~~~~~~
>        vha->vp_idx, vha->req->ring_index,
>        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>        vha->req->cnt, req_cnt, cnt, cnt_in, vha->req->length);
>        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/qla2xxx/qla_target.c:1887:3: error: 'cnt' may be used
> uninitialized in this function [-Werror=maybe-uninitialized]
> 
> The problem is that gcc fails to track the state of the condition 
> across an annotated branch.
> 
> This slightly rearranges the code to move the second if() block
> into the first one, to avoid the warning while retaining the
> behavior of the code.

I thought our usual policy was to ask someone to fix the compiler when
it emitted a spurious warning.

James


