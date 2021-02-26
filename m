Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9F7C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 05:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D776E64EE1
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 05:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBZFyg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 00:54:36 -0500
Received: from verein.lst.de ([213.95.11.211]:44552 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhBZFyg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Feb 2021 00:54:36 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id EDBE568BEB; Fri, 26 Feb 2021 06:53:52 +0100 (CET)
Date:   Fri, 26 Feb 2021 06:53:52 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Tom Yan <tom.ty89@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] usb-storage: revert from scsi_add_host_with_dma()
 to scsi_add_host()
Message-ID: <20210226055352.GA2996@lst.de>
References: <CAGnHSEnetAJNqUEW-iuq7eVyU6VnP84cv9+OVL4C5Z2ZK_eM0A@mail.gmail.com> <186eb035-4bc4-ff72-ee41-aeb6d81888e3@redhat.com> <X8T0E2qvF2cgADl+@kroah.com> <dd557c38-a919-5e5e-ab3b-17a235f17139@redhat.com> <20201130172004.GA966032@rowland.harvard.edu> <abb0a79d-63a0-6f3d-4812-f828283cd47c@redhat.com> <CAGnHSEk1GixNK71CJMymwLE=MyedjCkiG5Ubq1=O_wFxBBM0GQ@mail.gmail.com> <CAGnHSEmPpbDokAfGkeCkvo3JuYfnosVt8H+TK7ZWFNsdyWAfYQ@mail.gmail.com> <20201130203618.GB975529@rowland.harvard.edu> <20210225163557.GC1350993@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225163557.GC1350993@rowland.harvard.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 25, 2021 at 11:35:57AM -0500, Alan Stern wrote:
> This thread seems to have fallen through the cracks.  Maybe now would be 
> a good time to address the problem (since we originally planned to fix 
> it in 5.11!).
> 
> The questions listed below are pretty self-contained, although the rest
> of the discussion isn't.  But I never received any answers.

usb-storage must use scsi_add_host_with_dma to use the right device
for DMA mapping and parameters.  The calls to set the DMA options
on the device are needed so that IOMMU merging doesn't change the
imposed requirements.  If these requirements slow you down you need
to relax them, as apparently the hardware is able to handle bigger
limits.
