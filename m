From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: Return -EINVAL when "id == max_id" in scsi_scan_host_selected()
Date: Fri, 19 May 2006 22:21:32 -0600
Message-ID: <20060520042132.GC2826@parisc-linux.org>
References: <1148080489.23417.18.camel@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:215 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932482AbWETEVd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 May 2006 00:21:33 -0400
Content-Disposition: inline
In-Reply-To: <1148080489.23417.18.camel@amitarora.in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Amit Arora <aarora@in.ibm.com>
Cc: linux-scsi@vger.kernel.org, patmans@us.ibm.com

On Fri, May 19, 2006 at 04:14:50PM -0700, Amit Arora wrote:
> The scsi_scan_host_selected() should return -EINVAL when the id is equal
> to the max_id. Currently it uses ">" when comparing with max_id, and
> hence leaves the border case when "id==max_id".
> The channel and lun have values valid from 0 up to,
> and including, max_channel or max_lun. But, the valid values for id
> range from 0 to max_id-1. This patch fixes the problem.

You're right, but the patch is wrong.  It's not acceptable to have
different meanings for variables with such similar names.  Either it
needs to be renamed to id_count or we need to fix all the other users of
max_id.

BTW, I think we have another problem with max_lun:

	max_dev_lun = min(max_scsi_luns, shost->max_lun);
	...
	for (lun = 1; lun < max_dev_lun; ++lun)

surely that should be <= ?
