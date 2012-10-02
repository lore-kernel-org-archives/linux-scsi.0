From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/4] target: Add target_submit_cmd_map_mem and convert
 tcm_loop+tcm_vhost
Date: Tue, 2 Oct 2012 17:00:21 +0200
Message-ID: <20121002150021.GA4493@redhat.com>
References: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2JBO7A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2012 10:59:00 -0400
Content-Disposition: inline
In-Reply-To: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>

On Tue, Oct 02, 2012 at 07:15:43AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi hch & Co,
> 
> This series adds a new target_submit_cmd_map_mem() caller to accept
> pre-allocated SGL memory within the core generic I/O submission path.
> Patch #1 contains the core I/O changes, patch #2 + #4 includes the
> conversion of tcm_loop+tcm_vhost to use this new caller -> drop their
> internal open-coded equivalents using transport_generic_map_mem_to_cmd().
> 
> Patch #3 carries forward a work-around for tcm_loop w/ scsi-generic with
> user-space code that does not zero out it's READ payload buffer + ends
> up passing a payload filled with random data into target core's control CDB
> emulation.  Since we're not using bounce buffers any more for control
> CDB emulation in modern v3.x code, AFAICT tcm_loop still requires this
> extra bit to function properly with some legacy user-space code.
> 
> Regardless, the main I/O path changes end up being very mechnical in
> nature for existing core and fabric code, and has been running as expected
> with fio small-block workloads last hours.
> 
> Please review.
> 
> Thanks Christoph!
> 
> --nab

For the vhost part:

ACK series.

> Nicholas Bellinger (4):
>   target: Add target_submit_cmd_map_mem for SGL fabric memory
>     passthrough
>   tcm_loop: Convert I/O path to use target_submit_cmd_map_mem
>   target: Add TARGET_SCF_MAP_CLEAR_MEM work-around for tcm_loop
>   tcm_vhost: Convert I/O path to use target_submit_cmd_map_mem
> 
>  drivers/target/loopback/tcm_loop.c     |   62 ++-------------
>  drivers/target/target_core_transport.c |  129 ++++++++++++++++++++++++++------
>  drivers/vhost/tcm_vhost.c              |   68 ++++-------------
>  drivers/vhost/tcm_vhost.h              |    8 ++
>  include/target/target_core_base.h      |    2 +
>  include/target/target_core_fabric.h    |    3 +
>  6 files changed, 141 insertions(+), 131 deletions(-)
> 
> -- 
> 1.7.2.5
