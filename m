From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [v2 PATCH 3/4] bnx2fc: cleanup task management IO when it
 times out.
Date: Mon, 7 May 2012 16:31:15 -0700
Message-ID: <4FA85B43.2000909@broadcom.com>
References: <4FA85912.2030800@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3503 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066Ab2EGXba (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 May 2012 19:31:30 -0400
In-Reply-To: <4FA85912.2030800@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

On  05/04/2012 08:49 AM, Mike Christie wrote:
> On 04/24/2012 05:26 PM, Bhanu Prakash Gollapudi wrote:
>  > diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
>  > index d3ee231..082a25c 100644
>  > --- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
>  > +++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
>  > @@ -185,6 +185,16 @@ void bnx2fc_flush_active_ios(struct bnx2fc_rport
> *tgt)
>  > BUG_ON(rc);
>  > }
>  >
>  > + list_for_each_safe(list, tmp, &tgt->active_tm_queue) {
>  > + i++;
>  > + io_req = (struct bnx2fc_cmd *)list;
>
> Why didn't you use list_for_each_entry_safe()? Or, when using
> list_for_each_safe, instead of the cast are we supposed to be using
> list_entry()?

Mike, the list is the first field in the structure, so the cast here is 
right.

Thanks,
Bhanu
>
>
>  > + list_del_init(&io_req->link);
>  > + io_req->on_tmf_queue = 0;
>  > + BNX2FC_IO_DBG(io_req, "tm_queue cleanup\n");
>  > + if (io_req->wait_for_comp)
>  > + complete(&io_req->tm_done);
>  > + }
>  > +
>  > list_for_each_safe(list, tmp, &tgt->els_queue) {
>  > i++;
>  > io_req = (struct bnx2fc_cmd *)list;


