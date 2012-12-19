From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 0/2] Change type-2 dif to use rq embedded 32 byte cdb
Date: Wed, 19 Dec 2012 09:12:58 -0500
Message-ID: <50D1CB6A.6030007@redhat.com>
References: <1353528468-5664-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab2LSOOY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Dec 2012 09:14:24 -0500
In-Reply-To: <1353528468-5664-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, chad.dupuis@qlogic.com, giridhar.malavali@qlogic.com, scameron@beardog.cce.hp.com, mike.miller@hp.com, dan.j.williams@intel.com, fushun@marvell.com

On 11/21/2012 03:07 PM, Rob Evers wrote:
> These patches replace the original t10 type 2 dif mempool implementation
> by increasing the block and scsi cdb maximum sizes from 16 to 32 bytes.
> The cdb embedded in the request structure can then be used for type 2
> dif commands, or other 32 byte cdbs as required.
>
> Motivation for this is that type-2 dif commands should be treated as
> any other read/writes generally, without any performance penalty.
>
> This patch set conflicts with a patch previously posted which addresses
> a race in UA induced retries with type 2 dif commands.  These patches also
> address that problem:
>
> http://marc.info/?l=linux-scsi&m=135186352200668&w=2
>
> Testing:
>
> Readily reproduced the race condition panic by simultaneously
> inducing UAs while load testing 8 scsi_debug devices.  With patch
> applied, same testing ran for 15 hours without a panic.
>
> Sanity tested performance using scsi_debug, with and without
> type 2 dif enabled.  Order 80% performance increase noticed
> with patches when scsi_debug was running in dif type 2 mode.
> Running scsi_debug without type 2 dif, performance was approximately
> equal.
>
> Used 3.7.0-rc5 for testing and patch generation.
>
> root (2):
>    Change the cdb size limits in block and scsi to 32 bytes
>    Change dif type 2 commands to use embedded 32 byte cdb
>
>   drivers/scsi/sd.c        | 45 +--------------------------------------------
>   drivers/scsi/sd.h        |  5 -----
>   include/linux/blkdev.h   |  2 +-
>   include/scsi/scsi_cmnd.h | 13 ++-----------
>   4 files changed, 4 insertions(+), 61 deletions(-)
>

James,

Can you give some input on this?

Thanks, Rob


