From: "Zou, Yi" <yi.zou@intel.com>
Subject: RE: [PATCH 0/3] Follow-on patches to "adding support to FCoE
 transport"
Date: Tue, 4 Jan 2011 15:32:33 -0800
Message-ID: <7C88852EF6F99F4EB538472FCFEBE222014A4783B3@orsmsx509.amr.corp.intel.com>
References: <1293168950.4676.508.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:46937 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab1ADXce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 18:32:34 -0500
In-Reply-To: <1293168950.4676.508.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "mchan@broadcom.com" <mchan@broadcom.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

> 
> These are follow-on patches to Yi's patches for adding support
> to FCoE transport.
Sorry for late reply, just got time to read your comments after
the holiday.

> 
> This patch fixes the following issues:
> 
> 1. bugs w.r.t locking and is_vendor check.
Thanks.

> 
> 2. Since we are using the same 'fcoe' service for software fcoe as
> well as vendor drivers(bnx2fc for eg.), some interfaces will be
> claimed by bnx2fc and some interfaces will be claimed by fcoe
> driver.  This may cause some confusion to the administrator,
> as he cannot control which interfaces should be claimed by which
> driver.
> 
> 3. match() assumes that the netdev/driver mapping shall remain intact.
> This may not be true. Lets say, 'fcoe' is the only driver loaded
> initially, and create is called on that. Subsequently, 'bnx2fc' driver
> is loaded, which may claim the interface. Destroy will be called on
> bnx2fc driver instead of fcoe.
> 
> 4. Currently we do not have a mapping for create and corresponding
> destroy/disable or enable.
> 
Yeah, the DRIVER_NAME in cfg-ethx will simplify things a lot as using
fcoe_netdev list is simpler. That netdev map list is really per fcoe
transport, but keeping it global to libfcoe won't hurt either I think.

For the "if_name:drv_name", however, we must also consider running 
open-fcoe stack w/ older fcoe-utils that does not have drv_name, in
which case we probably should fill fcoe_parse_buffer() with the default
name "fcoe" when no token of ":" is found so older config (or new config
that does not care for a hw hba) that uses fcoe.ko can still work.

I was hoping the match() would provide the flexibility to the vendor
to make sure the association of if_name w/ the drv_name is valid, e.g.
you can assign vendor1's driver to vendor2's interface. But, I guess
the ft->create() would fail in this case to serve as an indication
of the wrong association in the cfg-ethx.

> 
> Bhanu Prakash Gollapudi (3):
>   Resolve circular lock warning and is_vendor check
>   libfcoe: transport structure lookup based on driver name
>   fcoe: Remove match() and is_vendor fields in fcoe_transport structure
> 
Cool, if it's ok w/ you, I can merge the three patches into the original
series and repost as RFC v2, I will fix the fcoe_parse_buffer() as mentioned
above, and your v2 of bnx2fc patches should not be affected.

Thanks,
Yi

>  drivers/scsi/fcoe/fcoe.c              |   17 +--
>  drivers/scsi/fcoe/libfcoe.h           |    2 +-
>  drivers/scsi/fcoe/libfcoe_transport.c |  200 ++++++++++++++++++++++++---
> -----
>  include/scsi/libfcoe.h                |   14 ++-
>  4 files changed, 166 insertions(+), 67 deletions(-)
> 
> 
> 

