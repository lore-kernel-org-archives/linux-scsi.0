From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: Query regarding modifying the DMA Mask based on the available memory in the system
Date: Thu, 17 Apr 2008 16:40:43 +0800
Message-ID: <5AE055B67BB5764693E2900C7E3699BE010CAB76@pamail.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48686 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288AbYDQIlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2008 04:41:20 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

Hi All,
Currently the MPT Fusion drivers set DMA Mask to 64 bit if the
architecture of the system is 64bit and if the hardware supports 64 bit
DMA address. 
Also in all 64 bit systems the fusion drivers use SGESimple64_t to send
scatter gather elements to firmware. 

Even with 64 bit systems which has available memory less than 4GB the
SGESimple64_t is used, to increase the performance I am thinking of
modifying the driver to check the system memory in the system using the
function si_meminfo() and if the memory is less than 4GB, then the
driver will set the 32 bit DMA mask and will use SGESimple32_t to send
the SGE to firmware. 

I am not sure whether this change works fine? I couldn't see any SCSI
driver using the si_meminfo and this function seems not to return the
physical layout of the memory. 

Thanks
Sathya


