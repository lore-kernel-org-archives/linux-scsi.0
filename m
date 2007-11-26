From: "Miquel van Smoorenburg" <mikevs@xs4all.net>
Subject: Re: [patch 20/23] aacraid driver fails with Dell PowerEdge Expandable RAID Controller 3/Di
Date: Mon, 26 Nov 2007 11:28:07 +0100
Message-ID: <E1IwbCB-0002Ft-M9@n2o.xs4all.nl>
References: <200711212312.lALNCVWt014163@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2888 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbXKZKfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2007 05:35:32 -0500
In-Reply-To: <200711212312.lALNCVWt014163@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>

In article <xs4all.200711212312.lALNCVWt014163@imap1.linux-foundation.org> you write:
>Path: news.xs4all.nl!newsspool.news.xs4all.nl!post.news.xs4all.nl!gateway
>The enclosed patch introduces a new adapter quirk and tries to limp
>along by enabling pass-through in situations where memory is 32 bit
>addressable on 64 bit machines, or disable the pass-through functions
>altogether. I expect that the check for 32 bit addressable memory to be
>controversial in that it can be incorrect in non-Dell non-Intel systems
>that PERC would never be installed under, the alternative is to disable
>pass-through in all cases which could be reported as another regression.

>+static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
>+{
>+	if ((sizeof(dma_addr_t) > 4) &&
>+	 (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
>+	 (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
>+		return FAILED;
>+	return aac_scsi_32(fib, cmd);
>+}

I saw the same thing in the 64-bit dpt_i2o driver, but I
wonder, shouldn't this be something like:

#include <linux/bootmem.h>

       if ((sizeof(dma_addr_t) > 4) &&
        (max_pfn > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
        (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))

e.g. use max_pfn instead of num_physpages ?

Mike.
