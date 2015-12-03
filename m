From: "John Stoffel" <john@stoffel.org>
Subject: Linux kernels 4.3+ mess up MPT2SAS configs
Date: Thu, 3 Dec 2015 07:32:49 -0500
Message-ID: <22112.13937.759625.629277@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay.lanline.com ([216.187.10.16]:56273 "EHLO
	mailrelay.lanline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbbLCMuq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2015 07:50:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Cc: nagalakshmi.nandigama@avagotech.com, praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com


Hi,

I've got an LSI MPT2SAS controller in my home system, great board,
running well.  When I try to use kernels newer than approximately
4.3.0, the default Kconfig entry goes away because of what looks like
a merge of the mpt2sas and mpt3sas drivers.

In my hand made 4.2.6 config I have:

   CONFIG_SCSI_MPT2SAS=m
   CONFIG_SCSI_MPT2SAS_MAX_SGE=128
   # CONFIG_SCSI_MPT2SAS_LOGGING is not set
   # CONFIG_SCSI_MPT3SAS is not set

But when I pull down the 4.4-rc3 release and do:

    make mrproper
    cp /boot/config-4.2.6 .config
    make oldconfig

I silently get my CONFIG_SCSI_MPT2SAS entry removed, and the
CONFIG_SCSI_MPT3SAS is still left unconfigured!  This is a pain when
you boot up and your home directory and other data files aren't
available...

    > grep MPT .config
    CONFIG_PREEMPT_NOTIFIERS=y
    # CONFIG_PREEMPT_NONE is not set
    CONFIG_PREEMPT_VOLUNTARY=y
    # CONFIG_PREEMPT is not set
    CONFIG_CB710_DEBUG_ASSUMPTIONS=y
    # CONFIG_SCSI_MPT3SAS is not set

Can we please get this fixed so that moving forward this is setup
properly?

Thanks,
John
