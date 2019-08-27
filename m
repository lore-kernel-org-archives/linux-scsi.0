Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DA7C3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 14:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ECA920828
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566917179;
	bh=LHGCrNu5rDJVquYQttS4aKuvxdf+oT7fIO3ZM/wqjNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hfQf05YAMGo5OyzRi2VlcekZxTTIEierQNBi26W5nnUvixAbCOsAo4NA19XaxZYF6
	 cjOlmLDaFsT7sdWzWHR8RGEasPdOYhy1kabDmJmObEVJ1DpQ19YxE8I/nYhHSVVg2F
	 aBqo2pF0U1CyvADO/IcJkFfphZNTdexiAXoUnYMg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfH0OqP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 10:46:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:63035 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfH0OqP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Aug 2019 10:46:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 07:46:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="331841011"
Received: from unknown (HELO localhost.localdomain) ([10.232.112.69])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 07:46:13 -0700
Date:   Tue, 27 Aug 2019 08:44:26 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Long Li <longli@microsoft.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] nvme: pci: pass IRQF_RESCURE_THREAD to
 request_threaded_irq
Message-ID: <20190827144425.GA23100@localhost.localdomain>
References: <20190827085344.30799-1-ming.lei@redhat.com>
 <20190827085344.30799-4-ming.lei@redhat.com>
 <8837ea73-dcf5-801f-f037-267936bd65bc@suse.de>
 <20190827090926.GA30871@ming.t460p>
 <20190827143421.GA23091@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827143421.GA23091@localhost.localdomain>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 27, 2019 at 08:34:21AM -0600, Keith Busch wrote:
> I think you should probably just have pci_irq_get_affinity() take a flags
> argument, or make a new function like __pci_irq_get_affinity() that
> pci_irq_get_affinity() can call with a default flag.

Sorry, copied the wrong function name; I meant pci_request_irq(),
not pci_irq_get_affinity().
