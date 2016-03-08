From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] be2iscsi: set the boot_kset pointer to NULL in case of
 failure
Date: Tue, 8 Mar 2016 11:28:13 +0100
Message-ID: <56DEA93D.30206@redhat.com>
References: <1457084509-7368-1-git-send-email-mlombard@redhat.com>
 <yq137s1zpwz.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261AbcCHK2W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2016 05:28:22 -0500
In-Reply-To: <yq137s1zpwz.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jayamohan.kallickal@avagotech.com, ketan.mukadam@avagotech.com, sony.john@avagotech.com, linux-scsi@vger.kernel.org



On 03/08/2016 03:03 AM, Martin K. Petersen wrote:
>>>>>> "Maurizio" == Maurizio Lombardi <mlombard@redhat.com> writes:
> 
> Maurizio,
> 
> Maurizio> In beiscsi_setup_boot_info(), the boot_kset pointer should be
> Maurizio> set to NULL in case of failure otherwise an invalid pointer
> Maurizio> dereference may occur later.
> 
> iscsi_boot_destroy_kset() checks before deref and the other use location
> just checks to see whether it's NULL. Are there places in the core iSCSI
> code that use this without checking?

1) At the beginning of the beiscsi_setup_boot_info() function there is
the following check:

----------
/* it has been created previously */
if (phba->boot_kset)
        return 0;
----------

If the function fails and the boot_kset pointer is not set to NULL,
subsequent calls to beiscsi_setup_boot_info() will incorrectly return
success because it assumes that the boot_kset pointer is valid.

2) it is true that iscsi_boot_destroy_kset() checks whether the pointer is NULL
or not, but it the kset has been already destroyed and the pointer is not set to
NULL, then it will dereference an invalid pointer.

Regards,
Maurizio
