From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 00/11] st: remove scsi_execute_async usage (the first
 half)
Date: Mon, 01 Dec 2008 18:19:45 +0300
Message-ID: <49340091.4070507@vlnb.net>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:55751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbYLAPTz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 10:19:55 -0500
In-Reply-To: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kai.Makisara@kolumbus.fi, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org


FUJITA Tomonori wrote:
> This patchset removes the majority of scsi_execute_async in st
> driver. IOW, this converts st driver to use the block layer functions.
> 
> We are in the process of removing scsi_execute_async and
> scsi_req_map_sg. scsi_execute_async in sg driver were removed in
> 2.6.27. Now only st and osst drivers use scsi_execute_async().
> 
> st driver uses scsi_execute_async for two purposes, performing sort
> management SCSI commands internally and data transfer between user and
> kernel space (st_read and st_write). This patchset converts the
> former.
> 
> The former performs SCSI commands synchronously. It uses a liner
> in-kernel buffer (not scatter gather) for data transfer. To perform
> such commands, other upper layer drivers (e.g. sd) use
> scsi_execute_req (internally uses blk_rq_map_kern and and
> blk_execute_rq). scsi_execute_req is not fully fit for st so I adds a
> helper function similar to scsi_execute_req and replace
> scsi_execute_async in st driver (I might modify scsi_execute_req for
> st and remove the helper function later).
> 
> I'm still working on converting scsi_execute_async for data transfer
> between user and kernel space but I want to get this first half be
> merged.

May I ask a possibly stupid question? Is amount of overall code in Linux 
SCSI subsystem after your conversion is fully done and 
scsi_execute_async() with scsi_req_map_sg() completely removed going to 
get smaller or bigger?

 From diffstats of your patches seems it's is going to get considerably 
bigger (171 insertion vs 61 deletion). And this is only in one user of 
scsi_execute_async() of 4. What's the point then in scsi_execute_async() 
removal if the resulting code is going to get bigger, not smaller? And, 
frankly, it doesn't look as it's going to get clearer too..

P.S. Scsi_execute_async() is just ~50 lines long, scsi_req_map_sg() is 
just ~80 lines long and both look like nice helper functions, which are 
not worse than st_scsi_kern_execute().

Regards,
Vlad

