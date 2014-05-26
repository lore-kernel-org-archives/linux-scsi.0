From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [target:for-next 20/20] drivers/scsi/virtio_scsi.c:531:48: error: dereferencing pointer to incomplete type
Date: Mon, 26 May 2014 13:30:33 -0400
Message-ID: <yq1d2f0ih1i.fsf@sermon.lab.mkp.net>
References: <537d6b74.lQGMmmapPq/MP5Nx%fengguang.wu@intel.com>
	<1400791590.26558.6.camel@haakon3.risingtidesystems.com>
	<537F12C1.4080407@redhat.com>
	<1400867110.30565.6.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23819 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaEZRan (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 May 2014 13:30:43 -0400
In-Reply-To: <1400867110.30565.6.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Fri, 23 May 2014 10:45:10 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "Nic" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

>> What about #ifdef'ing VIRTIO_SCSI_F_T10_PI support out if
>> !CONFIG_BLK_DEV_INTEGRITY?

Nic> I figured it was slightly cleaner to enable BLK_DEV_INTEGRITY by
Nic> default when referencing struct blk_integrity (following what
Nic> IBLOCK does), than adding the equivalent #ifdef's..

Nic> MKP, do you have a preference on this..?

Well, I guess how important the virtio stuff is in the embedded space?

In the block layer we have all these wrappers that allow things to Do
The Right Thing when the BLK_DEV_INTEGRITY is disabled. I'm not entirely
sure it worth the hassle to do the same for target and virtio. The
memory savings aren't that big to begin with.

And besides, the bip pointer field in struct bio is about to become
generic with my impending copy offload patches anyway,

-- 
Martin K. Petersen	Oracle Linux Engineering
