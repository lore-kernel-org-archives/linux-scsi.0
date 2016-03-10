From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] megaraid_sas: Don't issue kill adapter for MFI
 controllers in case of PD list DCMD failure
Date: Thu, 10 Mar 2016 22:35:26 +0100
Message-ID: <56E1E89E.5000306@redhat.com>
References: <1457604877-5280-1-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbcCJVfa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2016 16:35:30 -0500
In-Reply-To: <1457604877-5280-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, jbottomley@parallels.com, martin.petersen@oracle.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com

On 10.3.2016 11:14, Sumit Saxena wrote:
> There are few MFI adapters which do not support MR_DCMD_PD_LIST_QUERY so
> if MFI adapters fail this DCMD, it should not be considered as FATAL and
> driver should not issue kill adapter and set per controller's instance
> variable- pd_list_not_supported so that same variable can be used inside
> functions- slave_alloc and slave_configure to allow firmware scan.
>
> Killing adapter because of DCMD failure when this DCMD is not supported
> causes driver's probe getting failed. This issue got introduced because
> of below commit when MFI IO timeout handling was introduced-
>
> 6d40afb megaraid_sas: MFI IO timeout handling
>
> Killing adapter in case of this DCMD failure should be limited to Fusion
> adapters only. Per controller's instance variable allow_fw_scan is removed
> as pd_list_not_supported better reflect the purpose.
>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

