Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7208BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5769060F9B
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 00:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbhJ0Ag5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 20:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233975AbhJ0Ag4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 20:36:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A52660F90;
        Wed, 27 Oct 2021 00:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635294871;
        bh=C9OErPbaRFk6CuwswcjzMEVwAQr8NaLin+SOUz3xjyw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oz4Mg7ErI7Sa7b+vg0R/zPv7p+Cs7eAZKs7DO+CYqK9Zr+5orANOZ+aslWm3YE2UD
         KhOslPQXlQ5mg9UF52EPoZ4pLO+91iaZGfTrI+i+uetqoUc7n4R3OIqKR4WvfhkvkY
         jlgVv3DxBB6iUanL2R8fZ4WlrhBK8LbO9UW06OTdBrPKfQqf98E7mCOR02z1W7qmsD
         QOq9inDzJwBBUKoBPzagCkdfz8BkXu/fc3YuRK9bpfSE/NFO74T8cZ6vHlnM06ipiK
         qKd3rgmVBawgeNiKcBtLQ7iukELqwycJuU3AxK+aDjkXAjQNPwYGtjMUKkiBNMoZNk
         19uarj8w/HYqw==
Date:   Tue, 26 Oct 2021 18:34:29 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Message-ID: <20211027003429.GA88860@C02WT3WMHTD6>
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909023545.1101672-1-damien.lemoal@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 09, 2021 at 11:35:40AM +0900, Damien Le Moal wrote:
> Single LUN multi-actuator hard-disks are cappable to seek and execute
> multiple commands in parallel. This capability is exposed to the host
> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).
> Each positioning range describes the contiguous set of LBAs that an
> actuator serves.
> 
> This series adds support to the scsi disk driver to retreive this
> information and advertize it to user space through sysfs. libata is
> also modified to handle ATA drives.

This looks good, and easy for user space to make optimizations.

Reviewed-by: Keith Busch <kbusch@kernel.org>
