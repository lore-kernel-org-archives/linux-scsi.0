Return-Path: <SRS0=b1yV=7H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BC9C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 15:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C9D620878
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 15:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391058AbgEYPMX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 May 2020 11:12:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:54936 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390992AbgEYPMX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 May 2020 11:12:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 794F6B13C;
        Mon, 25 May 2020 15:12:24 +0000 (UTC)
Date:   Mon, 25 May 2020 17:12:20 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix lpfc_nodelist leak when processing
 unsolicited event
Message-ID: <20200525151220.rtwmlobnkmhwhxn5@beryllium.lan>
References: <1590416184-52592-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590416184-52592-1-git-send-email-xiyuyang19@fudan.edu.cn>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Mon, May 25, 2020 at 10:16:24PM +0800, Xiyu Yang wrote:
> In order to create or activate a new node, lpfc_els_unsol_buffer()
> invokes lpfc_nlp_init() or lpfc_enable_node() or lpfc_nlp_get(), all of
> them will return a reference of the specified lpfc_nodelist object to
> "ndlp" with increased refcnt.

lpfc_enable_node() is not changing the refcnt.

> When lpfc_els_unsol_buffer() returns, local variable "ndlp" becomes
> invalid, so the refcount should be decreased to keep refcount balanced.
> 
> The reference counting issue happens in one exception handling path of
> lpfc_els_unsol_buffer(). When "ndlp" in DEV_LOSS, the function forgets
> to decrease the refcnt increased by lpfc_nlp_init() or
> lpfc_enable_node() or lpfc_nlp_get(), causing a refcnt leak.
> 
> Fix this issue by calling lpfc_nlp_put() when "ndlp" in DEV_LOSS.

This sounds reasonable. At least the lpfc_nlp_init() and lpfc_nlp_get() case
needs this. And I suppose this is also ok for the lfpc_enable_node().

Reviewed-by: Daniel Wagner <dwagner@suse.de>

Thanks,
Daniel
