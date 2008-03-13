From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 1/1] Fusion SAS and Fibre Channel: target missing after
 resetting external raid
Date: Thu, 13 Mar 2008 14:53:56 -0500
Message-ID: <47D98654.1030708@sgi.com>
References: <664A4EBB07F29743873A87CF62C26D70D5544A@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.171.30]:53485 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754045AbYCMTx6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 15:53:58 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70D5544A@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, Jeremy Higdon <jeremy@sgi.com>, Hannes Reinecke <hare@suse.de>



Moore, Eric wrote:
>>On Tuesday, March 04, 2008 9:51 AM,  Michael Reed wrote:

<snip>

>>
>> The fix is simple.  Fusion SAS and Fibre Channel (subject to 
>> same bug) should just leave "this_id" initialized to "-1".
>>
>> Applies to 2.6.25-rc3-git5.
>>
>> Signed-off-by: Michael Reed <mdr@sgi.com>
>>
>> --
>>
<snip>
> 
> This looks good.  I had deleted setting this_id in mptsas internal
> sources long ago.    In addition to this change, we need to fix
> mptscsih_slave_configure so it doesn't set the queue depth to 1 for SAS
> protocal when sdev->id is greater than sh->max_id.   The sas transport
> layer assigns the target ids, incrementing with each hotplug add, with
> large topologies, it doesn't take long to hit this threshold.
> 
> Eric

Adjusting the patch to reflect Eric's comments.  The change WRT
max_id is from Hannes.  FC should also be subject to the same issue.

Signed-off-by: Michael Reed <mdr@sgi.com>

--- gitu/drivers/message/fusion/mptfc.c	2008-01-24 14:58:37.000000000 -0800
+++ git/drivers/message/fusion/mptfc.c	2008-03-13 12:37:52.176015612 -0700
@@ -1238,8 +1238,6 @@ mptfc_probe(struct pci_dev *pdev, const 
 	sh->max_id = ioc->pfacts->MaxDevices;
 	sh->max_lun = max_lun;
 
-	sh->this_id = ioc->pfacts[0].PortSCSIID;
-
 	/* Required entry.
 	 */
 	sh->unique_id = ioc->id;
--- gitu/drivers/message/fusion/mptsas.c	2008-03-10 13:23:46.000000000 -0700
+++ git/drivers/message/fusion/mptsas.c	2008-03-13 12:38:01.912440308 -0700
@@ -3181,8 +3181,6 @@ mptsas_probe(struct pci_dev *pdev, const
 
 	sh->transportt = mptsas_transport_template;
 
-	sh->this_id = ioc->pfacts[0].PortSCSIID;
-
 	/* Required entry.
 	 */
 	sh->unique_id = ioc->id;
--- gitu/drivers/message/fusion/mptscsih.c	2008-03-10 13:20:30.000000000 -0700
+++ git/drivers/message/fusion/mptscsih.c	2008-03-13 12:38:38.070017332 -0700
@@ -2442,12 +2442,6 @@ mptscsih_slave_configure(struct scsi_dev
 		    ioc->name, sdev->sdtr, sdev->wdtr,
 		    sdev->ppr, sdev->inquiry_len));
 
-	if (sdev->id > sh->max_id) {
-		/* error case, should never happen */
-		scsi_adjust_queue_depth(sdev, 0, 1);
-		goto slave_configure_exit;
-	}
-
 	vdevice->configured_lun = 1;
 	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
 
@@ -2461,8 +2455,6 @@ mptscsih_slave_configure(struct scsi_dev
 		    ioc->name, vtarget->negoFlags, vtarget->maxOffset,
 		    vtarget->minSyncFactor));
 
-slave_configure_exit:
-
 	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"tagged %d, simple %d, ordered %d\n",
 		ioc->name,sdev->tagged_supported, sdev->simple_tags,
