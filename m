From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/3] tcm_qla2xxx: Convert FC address map from flat
 array to btree
Date: Thu, 03 May 2012 18:18:25 -0700
Message-ID: <1336094305.22393.100.camel@haakon2.linux-iscsi.org>
References: <1336074180-20577-1-git-send-email-roland@kernel.org>
	 <1336074180-20577-2-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57442 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab2EDBSf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2012 21:18:35 -0400
In-Reply-To: <1336074180-20577-2-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Arun Easi <arun.easi@qlogic.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Steve Hodgson <steve@purestorage.com>

On Thu, 2012-05-03 at 12:42 -0700, Roland Dreier wrote:
> From: Steve Hodgson <steve@purestorage.com>
> 
> tcm_qla2xxx needs a map from 24-bit FC addresses to node ACL pointers to
> look up incoming commands.  Current code keeps this as a flat vmalloc()ed
> array with 2^24 entries -- with 8-byte pointers, this consumes 128MB per
> FC port!  Occupancy of this array is at most on the order of hundreds of
> entries (and even that would be a lot of initiators on an FC fabric), so
> this wastes a huge amount of memory.
> 
> Change this map to use the kernel's btree library; this reduces the memory
> used to be O(number of entries) and has no measurable speed impact (in fact
> since the data structure is now packed rather than sparse, the cache/TLB
> effects may actually make this a net win).
> 
> Signed-off-by: Steve Hodgson <steve@purestorage.com>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/scsi/qla2xxx/Kconfig       |    1 +
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |  195 ++++++++++++++++--------------------
>  drivers/scsi/qla2xxx/tcm_qla2xxx.h |   22 +---
>  3 files changed, 90 insertions(+), 128 deletions(-)
> 

I think this patch looks like a safe enough mechanical change in
tcm_qla2xxx code for the benefit here, and definitely should be included
for the initial 3.5 merge..

Applied to lio-core.git, and including the full series into this
evenings for-next-merge re-spin.

Excellent work here by Steve Hodgson to convert the FC address <-> node
ACL pointer lookup logic to use the in-kernel btree library !!

Thanks Roland!

--nab

