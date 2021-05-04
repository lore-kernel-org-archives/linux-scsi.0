Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8320CC433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 10:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 476CC611AE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 10:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhEDKB1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 06:01:27 -0400
Received: from verein.lst.de ([213.95.11.211]:38803 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230033AbhEDKAT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 06:00:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1320A68AFE; Tue,  4 May 2021 11:59:20 +0200 (CEST)
Date:   Tue, 4 May 2021 11:59:20 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 07/18] scsi: revamp host device handling
Message-ID: <20210504095920.GE25986@lst.de>
References: <20210503150333.130310-1-hare@suse.de> <20210503150333.130310-8-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210503150333.130310-8-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

So right now scsi_get_host_dev/scsi_free_host_dev is entirely unused.

І'd rather just kill them off rather than giving them a new life and
hacking all over the core code for them.

What do you need the scsi_device for instead of just having a
request_queue for comands to the controller?  If we need a scsi_device
can we somehow make sure it doesn't hit the scanning and sysfs code
from a much higher level?
