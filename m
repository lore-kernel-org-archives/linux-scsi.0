From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 1/4] target: Add target_submit_cmd_map_sgls for SGL
 fabric memory passthrough
Date: Tue, 02 Oct 2012 14:28:19 -0700
Message-ID: <1349213299.28145.74.camel@haakon2.linux-iscsi.org>
References: <1349212618-348-1-git-send-email-nab@linux-iscsi.org>
	 <1349212618-348-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59558 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab2JBV2W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 17:28:22 -0400
In-Reply-To: <1349212618-348-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>

On Tue, 2012-10-02 at 21:16 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a new target_submit_cmd_map_sgls() to pass pre-allocated
> SGL memory using transport_generic_map_mem_to_cmd() logic into the generic
> target submit I/O codepath.
> 
> It also adds a target_submit_cmd() wrapper around target_submit_cmd_map_sgls()
> for existing fabric code that already assumes internal target-core SGL memory
> allocation.
> 
> (v2: Rename to target_submit_cmd_map_sgls + drop TARGET_SCF_MAP_MEM flag
>      in favor of non zero sgl_count check)
> 
> Reported-by: Christoph Hellwig <hch@lst.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_transport.c |   65 +++++++++++++++++++++++++++++---
>  include/target/target_core_base.h      |    1 +
>  include/target/target_core_fabric.h    |    3 +
>  3 files changed, 63 insertions(+), 6 deletions(-)
> 

> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 5be8937..6309298 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -220,6 +220,7 @@ enum target_sc_flags_table {
>  	TARGET_SCF_BIDI_OP		= 0x01,
>  	TARGET_SCF_ACK_KREF		= 0x02,
>  	TARGET_SCF_UNKNOWN_SIZE		= 0x04,
> +	TARGET_SCF_MAP_MEM		= 0x08,
>  };

Whoops, removing this left-over bit now before pushing into for-next.



