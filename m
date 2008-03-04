From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/1] Fusion SAS and Fibre Channel: target missing after resetting external raid
Date: Tue, 4 Mar 2008 10:22:11 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70D5544A@NAMAIL4.ad.lsil.com>
References: <47CD7DDE.7030907@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:49633 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761430AbYCDRWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 12:22:16 -0500
Content-class: urn:content-classes:message
In-Reply-To: <47CD7DDE.7030907@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: Jeremy Higdon <jeremy@sgi.com>

On Tuesday, March 04, 2008 9:51 AM,  Michael Reed wrote:
> Subject: [PATCH 1/1] Fusion SAS and Fibre Channel: target 
> missing after resetting external raid
> 
> Following a hard reset of a SAS raid, one of the raid targets 
> is occasionally
> missing.  I tracked this down to a pretty obscure little bug.
> 
> The LSI fusion drivers for SAS and Fibre Channel both use 
> their respective
> transport layers.  Those transport layers increment the target number
> assigned to new targets.
> 
> The routine __scsi_scan_target uses the "this_id" element of 
> the Scsi_Host
> structure to avoid scanning the scsi host adapter.  Both 
> fusion drivers set
> "this_id" from a value returned in a firmware PortFacts 
> response.  For my
> particular test case (SAS) the firmware id assigned to the 
> initiator was
> 173.  After enough raid resets to cause the raid targets to 
> go and come a
> sufficient number of times, the id assigned by the transport to a raid
> target would match the id assigned by the host adapter to the 
> "this_id"
> field, resulting in that target not being scanned.
> 
> static void __scsi_scan_target(struct device *parent, 
> unsigned int channel,
>                 unsigned int id, unsigned int lun, int rescan)
> {
>         struct Scsi_Host *shost = dev_to_shost(parent);
>         int bflags = 0;
>         int res;
>         struct scsi_target *starget;
> 
>         if (shost->this_id == id)
>                 /*
>                  * Don't scan the host adapter
>                  */
>                 return;
> 
> ....
> 
> The fix is simple.  Fusion SAS and Fibre Channel (subject to 
> same bug) should
> just leave "this_id" initialized to "-1".
> 
> Applies to 2.6.25-rc3-git5.
> 
> Signed-off-by: Michael Reed <mdr@sgi.com>
> 
> --
> 
> --- kou/drivers/message/fusion/mptfc.c	2008-01-24 
> 16:58:37.000000000 -0600
> +++ ko/drivers/message/fusion/mptfc.c	2008-03-04 
> 09:01:18.428176326 -0600
> @@ -1238,8 +1238,6 @@ mptfc_probe(struct pci_dev *pdev, const 
>  	sh->max_id = ioc->pfacts->MaxDevices;
>  	sh->max_lun = max_lun;
>  
> -	sh->this_id = ioc->pfacts[0].PortSCSIID;
> -
>  	/* Required entry.
>  	 */
>  	sh->unique_id = ioc->id;
> --- kou/drivers/message/fusion/mptsas.c	2008-03-04 
> 08:38:58.000000000 -0600
> +++ ko/drivers/message/fusion/mptsas.c	2008-03-04 
> 09:01:04.284807301 -0600
> @@ -3176,8 +3176,6 @@ mptsas_probe(struct pci_dev *pdev, const
>  
>  	sh->transportt = mptsas_transport_template;
>  
> -	sh->this_id = ioc->pfacts[0].PortSCSIID;
> -
>  	/* Required entry.
>  	 */
>  	sh->unique_id = ioc->id;
> 
>

This looks good.  I had deleted setting this_id in mptsas internal
sources long ago.    In addition to this change, we need to fix
mptscsih_slave_configure so it doesn't set the queue depth to 1 for SAS
protocal when sdev->id is greater than sh->max_id.   The sas transport
layer assigns the target ids, incrementing with each hotplug add, with
large topologies, it doesn't take long to hit this threshold.

Eric

  

 
