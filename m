From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 09/12] libsas, libata: fix start of life for a sas ata_port
Date: Sat, 21 Apr 2012 02:20:49 -0400
Message-ID: <4F9251C1.8030805@garzik.org>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com> <20120413233737.8025.24108.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52603 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2DUGUw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Apr 2012 02:20:52 -0400
In-Reply-To: <20120413233737.8025.24108.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@parallels.com, linux-ide@vger.kernel.org, Michal Kosciowski <michal.kosciowski@intel.com>, linux-scsi@vger.kernel.org

On 04/13/2012 07:37 PM, Dan Williams wrote:
> This changes the ordering of initialization and probing events from:
>    1/ allocate rphy in PORTE_BYTES_DMAED, DISCE_REVALIDATE_DOMAIN
>    2/ allocate ata_port and schedule port probe in DISCE_PROBE
> ...to:
>    1/ allocate ata_port in PORTE_BYTES_DMAED, DISCE_REVALIDATE_DOMAIN
>    2/ allocate rphy in PORTE_BYTES_DMAED, DISCE_REVALIDATE_DOMAIN
>    3/ schedule port probe in DISCE_PROBE
>
> This ordering prevents PHYE_SIGNAL_LOSS_EVENTS from sneaking in to
> destrory ata devices before they have been fully initialized:
>
>    BUG: unable to handle kernel paging request at 0000000000003b10
>    IP: [<ffffffffa0053d7e>] sas_ata_end_eh+0x12/0x5e [libsas]
>    ...
>    [<ffffffffa004d1af>] sas_unregister_common_dev+0x78/0xc9 [libsas]
>    [<ffffffffa004d4d4>] sas_unregister_dev+0x4f/0xad [libsas]
>    [<ffffffffa004d5b1>] sas_unregister_domain_devices+0x7f/0xbf [libsas]
>    [<ffffffffa004c487>] sas_deform_port+0x61/0x1b8 [libsas]
>    [<ffffffffa004bed0>] sas_phye_loss_of_signal+0x29/0x2b [libsas]
>
> ...and kills the awkward "sata domain_device briefly existing in the
> domain without an ata_port" state.
>
> Reported-by: Michal Kosciowski<michal.kosciowski@intel.com>
> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
> ---
>   drivers/ata/libata-scsi.c          |   35 ++++++++++++++++++++---------------
>   drivers/scsi/ipr.c                 |    6 +++++-
>   drivers/scsi/libsas/sas_ata.c      |   33 ++++++++++-----------------------
>   drivers/scsi/libsas/sas_discover.c |   13 ++++++++++---
>   drivers/scsi/libsas/sas_expander.c |    8 +++++---
>   include/linux/libata.h             |    3 ++-
>   include/scsi/sas_ata.h             |    4 ++--
>   7 files changed, 54 insertions(+), 48 deletions(-)

Acked-by: Jeff Garzik <jgarzik@redhat.com>



