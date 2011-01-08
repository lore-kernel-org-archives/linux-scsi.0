From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: Re: [RFC PATCH v2 0/8] adding support to FCoE transport
Date: Sat, 8 Jan 2011 01:33:49 +0000
Message-ID: <1294450430.4676.672.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
References: <20110107174027.14631.47077.stg.yi.zou@intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1960 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab1AHBeE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2011 20:34:04 -0500
In-Reply-To: <20110107174027.14631.47077.stg.yi.zou@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yi Zou <yi.zou@intel.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2011-01-07 at 09:42 -0800, Yi Zou wrote:
> This is the RFC v2 of adding fcoe transport to support vendor specific FCoE
> transport into the existing Open-FCoE framework.
> 
> v1:
> Initial post for adding fcoe transport:
> https://lists.open-fcoe.org/pipermail/devel/2010-December/010865.html
> Follow-up comments & discussions:
> https://lists.open-fcoe.org/pipermail/devel/2011-January/010890.html
> 
> v2:
> 1. Per Joe's comment, renamed the libfcoe_fip.c to be fcoe_ctlr.c. I
> also renamed the new ibfcoe_transport.c to be fcoe_transport.c.
> 2. Per Bhanu's comment, I have merged the three follow-up patches
> from Bhanu with the following changes in fcoe_parse_buffer():
> a) Though not a problem of the existing fcoe-util since the sysfs
> entry is changing to libfcoe anyway, I still want to fill the buffer
> of drv_name with default "fcoe" so default behavior is still the same
> w/o changing cfg-ethx.
> b) Fixed the '\n' ending in the input buffer in fcoe_parse_buffer, we still
> need that proper formatting logic from the original fcoe_if_to_netdev(),
> otherwise the ifname and drv_name will be messed up, causing the lookup for
> netdev and transport to fail.
> 
> Testing Notes:
> Did the checkpatch and tested w/ overnight stress FCoE traffic on 2 LUNs using
> fcoe.ko as the default fcoe transport, that seems to be working ok. However,
> loop create/destroy testing is needed before this gets committed eventually.

Thanks Yi. bnx2fc patches got installed cleanly on top of your patches,
and we were able run FCoE IO traffic, and will leave it running for the
weekend.

Thanks,
Bhanu
> 
> thanks,
> yi
> 
> ---
> 
> Yi Zou (8):
>       fcoe: convert fcoe.ko to become an fcoe transport provider driver
>       fcoe: prepare fcoe for using fcoe transport
>       libfcoe: include fcoe_transport.c into kernel libfcoe module
>       libfcoe: remove libfcoe.c, use the same fcoe_ctlr.c instead
>       libfcoe: rename libfcoe.c to fcoe_cltr.c for the coming fcoe_transport.c
>       libfcoe: add implementation to support fcoe transport
>       libfcoe: add fcoe_transport structure defines to include/scsi/libfcoe.h
>       libfcoe: move logging macros into the local libfcoe.h header file
> 
> 
>  drivers/scsi/fcoe/Makefile         |    2 
>  drivers/scsi/fcoe/fcoe.c           |  183 +-
>  drivers/scsi/fcoe/fcoe_ctlr.c      | 2682 ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/fcoe/fcoe_transport.c |  548 +++++++
>  drivers/scsi/fcoe/libfcoe.c        | 2708 ------------------------------------
>  drivers/scsi/fcoe/libfcoe.h        |   31 
>  include/scsi/libfcoe.h             |   43 +
>  7 files changed, 3367 insertions(+), 2830 deletions(-)
>  create mode 100644 drivers/scsi/fcoe/fcoe_ctlr.c
>  create mode 100644 drivers/scsi/fcoe/fcoe_transport.c
>  delete mode 100644 drivers/scsi/fcoe/libfcoe.c
>  create mode 100644 drivers/scsi/fcoe/libfcoe.h
> 



