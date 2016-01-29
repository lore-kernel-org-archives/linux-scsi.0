From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 11/15] megaraid_sas: Make adprecovery variable atomic
Date: Fri, 29 Jan 2016 16:52:48 +0100
Message-ID: <56AB8AD0.1060203@redhat.com>
References: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
 <1453995276-24955-12-git-send-email-sumit.saxena@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbcA2Pwu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 10:52:50 -0500
In-Reply-To: <1453995276-24955-12-git-send-email-sumit.saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com

On 28.1.2016 16:34, Sumit Saxena wrote:
> Make instance->adprecovery variable atomic and removes hba_lock spinlock while accessing instance->adprecovery.
>
> Tomas commented on last time sent patch asking to use u8 instead of atomic for adprecovery. I agree that atomic_t is not required
> here but this is done for not to touch legacy code of MFI adapters and replace hba_lock with atomic_t so there are no changes
> in this patch on top of last time sent patch.

The way how both, the atomic variable now and the hba_lock we had before, work
is not equal - the sw will now behave differently, so you can't replace it
and expect nothing would change
The protection they provide was/is weak anyway, I think that it does not
protect you from anything.

btw. you forgot to remove the hba_lock in megasas_complete_cmd_dpc_fusion

OK, old code, you don't want to touch/test, and the maintainer has accepted it
so I accept it too.

--tm

