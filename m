Return-Path: <SRS0=AJIY=36=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C02C3F68F
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 20:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C1DA24650
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 20:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581367397;
	bh=KwCHrWA0wev45KvANN3aYLit9yFcWT8lnBqLoNfSfto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=oJEl7ThEJKrOdSYZor+zOuTk9n09g3I93LWdV0KgEwUrUZZaHzH3ze1ve4pEUlVqa
	 bn1sN692Nn6c1GFdKKFRV7I9qV5xuzz2kMgG7Nd7JrZU7yrX6Q8WXxrpVxNWL/5BBZ
	 27xgiUyWHT5qvEI68S5EWjuDjFJairuhHnaLtyNI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgBJUnQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Feb 2020 15:43:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgBJUnQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Feb 2020 15:43:16 -0500
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30B81214DB;
        Mon, 10 Feb 2020 20:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581367395;
        bh=KwCHrWA0wev45KvANN3aYLit9yFcWT8lnBqLoNfSfto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fka3jkqKrIkS/psSk5OgilmAPgjyLDfVTYwfRIQHQT3TyEoMXHlEFQ64fhkC/1+hb
         cjtrxqEWWbNkjWg+w0dXmwniLwJ7anlBdzRaZN27CFODTA/ZjtWfczVjkYt2vnS4VV
         YD1/rdBYN8xbNKNRpg1bZF7kuRkjp59Gj2SSKe7A=
Date:   Mon, 10 Feb 2020 12:43:13 -0800
From:   Keith Busch <kbusch@kernel.org>
To:     Tim Walker <tim.t.walker@seagate.com>
Cc:     linux-block@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nvme@lists.infradead.org
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200210204313.GA3736@dhcp-10-100-145-180.wdl.wdc.com>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 10, 2020 at 02:20:10PM -0500, Tim Walker wrote:
> -What Linux storage stack assumptions do we need to be aware of as we
> develop these devices with drastically different performance
> characteristics than traditional NAND? For example, what schedular or
> device driver level changes will be needed to integrate NVMe HDDs?

Right now the nvme driver unconditionally sets QUEUE_FLAG_NONROT
(non-rational, i.e. ssd), on all nvme namespace's request_queue flags. We
need the specification to define a capability bit or field associated
with the namespace to tell the driver otherwise, then we can propogate
that information up to the block layer.

Even without that, an otherwise spec compliant HDD should function as an
nvme device with existing software, but I would be interested to hear
additional ideas or feature gaps with other protocols that should be
considered in order to make an nvme hdd work well.
