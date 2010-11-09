From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tcm: Convert backstore ->set_configfs_dev_params() to
 use parser.h
Date: Tue, 9 Nov 2010 08:45:22 -0500
Message-ID: <20101109134522.GA4548@infradead.org>
References: <1289296122-13152-1-git-send-email-nab@linux-iscsi.org>
 <20101109100359.GA26324@infradead.org>
 <1289297001.19946.92.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab0KINpX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 08:45:23 -0500
Content-Disposition: inline
In-Reply-To: <1289297001.19946.92.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Tue, Nov 09, 2010 at 02:03:21AM -0800, Nicholas A. Bellinger wrote:
> <nod> thanks for the pointer here..
> 
> Btw, the kstrdup() is required because the configfs attribute store
> function will be passing a 'const char *page' that is propigated from
> target_core_configfs.c: target_core_store_dev_control() out to
> ->set_configfs_dev_params() backend code.

strsep doesn't modify the data it points to, just the pointer itself.
We could get around this by casting the pointer, which at least avoids
the memory allocation.  But it's probably not worth bothering.

