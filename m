Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71E2C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB21361101
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbhHMCVM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237804AbhHMCVM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 22:21:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F66C061756
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e+nlkE820lU4KobT+HYr0X8I0SfcV+5x8KDeOW4LtAM=; b=KdIJwgu4PZQHdOAKoIlKq2vOA7
        Zq4fAxwQuF1hVzOXH5cNJ/Vwgzk2Uedyta66qHuLRIQF+JbRBNdxDzIVL34t794smIPd8pzxsEMxE
        z59WIj1Pg5M4eudyZhZ6COE1cV20c79khf0BbYIJL3j0Y/1gin90e+ArVOWQQXJ7Ds+UBHiWxhss2
        12p4dZ3rFh+U9oJMi4Y3uMBtvUDj4+y7J6AnCpeMeqwxAEz/AGtpcMxdgPXbt50V26tSk3kYblHlh
        7ard6aPhwcPuoXKui+GfI1y7H8uanYHMXtHBEwRJ4fz6qSIc1glE5CfQiuw4z3++la7JndJNYnIgF
        lPG66dLQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mEMnN-00FEFh-9v; Fri, 13 Aug 2021 02:19:50 +0000
Date:   Fri, 13 Aug 2021 03:19:41 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v5 14/52] advansys: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
Message-ID: <YRXWvYiOd1pRcTdJ@casper.infradead.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-15-bvanassche@acm.org>
 <b4dd9bf7-1d4b-9a09-2100-dcf0c3aeb434@suse.de>
 <95223f29-1ced-a7a7-7fc7-90a3578f0447@acm.org>
 <yq135rftlva.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq135rftlva.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 11, 2021 at 10:58:10PM -0400, Martin K. Petersen wrote:
> Thoughts?

Seems a bit verbose to me.

> -	qc = ata_qc_new_init(dev, scsi_cmd_to_rq(cmd)->tag);
> +	qc = ata_qc_new_init(dev, scsi_cmd_to_tag(cmd));

	qc = ata_qc_new_init(dev, scmd_tag(cmd));

would fit with scmd_printk(), scmd_id(), scmd_channel(), etc.

