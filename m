From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH for kernel 4.1] Split SCSI header files
Date: Thu, 5 Mar 2015 15:58:47 +0100
Message-ID: <54F86F27.3000505@sandisk.com>
References: <54ED8A71.3050701@sandisk.com> <20150305142635.GA17795@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0068.outbound.protection.outlook.com ([65.55.169.68]:19264
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751060AbbCEO64 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2015 09:58:56 -0500
In-Reply-To: <20150305142635.GA17795@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/05/15 15:26, Christoph Hellwig wrote:
> In general this looks fine, but:
> 
>  - why do you need a separate scsi_lun.h?
>  - I'd really prefer to only have the protocol defintion here,
>    not prototypes for helpers like scsi_device_type, int_to_scsilun
>    and scsilun_to_int.  The target code should not depend on the
>    initiator for helpers.  In the long run we should either duplicate
>    them, or have a library used by the initiator and target.

Hello Christoph,

Thanks for the review. Whether scsi_lun.h is separate or not is not
important to me. The only reason I had proposed to create a separate
header file for struct scsi_lun is because some other header files only
need the definition of that structure and not any other definition that
is present in the proposed scsi_proto.h header file.

Creating a library of functions that are shared by initiator and target
makes sense to me. Not only the LUN translation functions but also
functions like scsi_command_size() are useful for both SCSI initiator
and SCSI target code. If anyone has a suggestion for a good name for
such a library that would be welcome. Unfortunately there is already a
source file with the name scsi_lib.c in the kernel tree so using the
name scsi_lib.h might be confusing.

Bart.
