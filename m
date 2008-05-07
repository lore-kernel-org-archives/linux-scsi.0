From: Jochen Radmacher <jr@jradmacher.dyndns.org>
Subject: megaraid_sas: direct drive access for smartctl and hdparm
Date: Wed, 07 May 2008 16:11:37 +0200
Message-ID: <4821B899.9080901@jradmacher.dyndns.org>
Reply-To: jradmacher@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gentoo-mail.speichernetz.com ([217.175.253.24]:53698 "EHLO
	gentoo-mail.speichernetz.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755728AbYEGOSV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2008 10:18:21 -0400
Received: from [192.168.178.2] (unknown [192.168.178.2])
	by jradmacher.dyndns.org (Postfix) with ESMTP id 4A538166ADF
	for <linux-scsi@vger.kernel.org>; Wed,  7 May 2008 16:11:37 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I was trying to get some useful SMART Information from the SATA drives 
connected to my PERC5/i controller, but the PERC had no options for that.
When browsing through the kernel sources I found this:

static int megasas_slave_configure(struct scsi_device *sdev)
{
         /*
          * Don't export physical disk devices to the disk driver.
          *
          * FIXME: Currently we don't export them to the midlayer at all.
          *        That will be fixed once LSI engineers have audited the
          *        firmware for possible issues.
          */
         if (sdev->channel < MEGASAS_MAX_PD_CHANNELS && sdev->type == 
TYPE_DISK)
                 return -ENXIO;


I changed the if{ } to:

         if (sdev->channel < MEGASAS_MAX_PD_CHANNELS && sdev->type == 
TYPE_DISK)
         {
                 sdev->writeable=1;
                 sdev->no_uld_attach=1;
                 return 0;
         }


This way I get sgX devices (and no extra sdX devices), which work fine 
with smartctl 5.37 and hdparm 8.4 . hdparm seems to need kernel 2.6.24 
or greater for the pass through to work.

This only is a proof of concept and I have no idea how to implement this 
correctly.
Regards,
  Jochen Radmacher
