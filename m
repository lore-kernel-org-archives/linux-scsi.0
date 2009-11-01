From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Add missing #include for include/scsi/osd_protocol.h
Date: Sun, 01 Nov 2009 12:15:27 +0200
Message-ID: <4AED5FBF.6020308@panasas.com>
References: <20091031093337.GA3339@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42649 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZKAKPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Nov 2009 05:15:30 -0500
Received: by bwz27 with SMTP id 27so5170021bwz.21
        for <linux-scsi@vger.kernel.org>; Sun, 01 Nov 2009 02:15:34 -0800 (PST)
In-Reply-To: <20091031093337.GA3339@deprecation.cyrius.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Michlmayr <tbm@cyrius.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On 10/31/2009 11:33 AM, Martin Michlmayr wrote:
> include/scsi/osd_protocol.h is missing an #include, leading to:
> | include/scsi/osd_protocol.h:277: error: implicit declaration of function '__constant_cpu_to_be16'
> | include/scsi/osd_protocol.h:362: error: implicit declaration of function 'ALIGN'
> 

I cannot reproduce this problem. What platform  (ARCH/config) are you compiling
this?

Because you see I have a source file in the tree that has this #include as very
first include. And it has been compiling in Kernel and in -next for a long time.
(drivers/scsi/osd/osd_initiator.c has osd_initiator.h as first header which has
 osd_protocol.h as first header.)

> Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
> 
> --- a/include/scsi/osd_protocol.h	2009-10-31 09:19:28.000000000 +0000
> +++ b/include/scsi/osd_protocol.h	2009-10-31 09:27:42.000000000 +0000
> @@ -17,6 +17,7 @@
>  #define __OSD_PROTOCOL_H__
>  
>  #include <linux/types.h>
> +#include <linux/kernel.h>
>  #include <asm/unaligned.h>

>From what I can see, asm/unaligned.h eventually pulls kernel.h through
one of it's possible implementations. Do you have a special asm/unaligned.h?

>  #include <scsi/scsi.h>
>  
> 

Please help me reproduce this problem.

Boaz

