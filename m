From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [dm-devel] [PATCH 0/2] 'default' hardware handler for multipath
Date: Tue, 3 Apr 2012 21:12:42 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B03A484@SACEXCMBX02-PRD.hq.netapp.com>
References: <1333385035-6663-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:30028 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab2DCVMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Apr 2012 17:12:54 -0400
In-Reply-To: <1333385035-6663-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>

Thanks Hannes. We appreciate your work on this.

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-
> bounces@redhat.com] On Behalf Of Hannes Reinecke
> Sent: Monday, April 02, 2012 11:44 AM
> To: linux-scsi@vger.kernel.org
> Cc: dm-devel@redhat.com; Mike Snitzer
> Subject: [dm-devel] [PATCH 0/2] 'default' hardware handler for multipath
> 
> This patchset introduces a 'default' hardware handler for dm-multipath.
> Modern storage arrays typically support two failover methods, the original
> proprietary and the modern ALUA-based one.
> The device_handler implementation will currently select the ALUA handler,
> and falling back to the proprietary one if ALUA isn't supported.
> However, in the built-in hardware table for multipath one can specify only
> one hardware handler, causing the original hardware handler to be
> overwritten.
> By specifying a 'default' hardware handler multipath will not try to attach a
> specific hardware handler, but rather using the currently attached on.

I think we still have some issues here. Right now we load the driver
either by adding it in initrd or by using request_module call from device mapper.
If the user passes, hardware_handler   "1 default"  from multipath then request_module will fail. 
How are we going to load the driver if these handlers are not loaded. 

> 
> Hannes Reinecke (2):
>   scsi_dh: Allow NULL hardware handler name in scsi_dh_attach()
>   dm-mpath: Allow 'default' hardware handler
> 
>  drivers/md/dm-mpath.c                 |    8 ++++++--
>  drivers/scsi/device_handler/scsi_dh.c |    8 ++++++--
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> --
> 1.7.7
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
