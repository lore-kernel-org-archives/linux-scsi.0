From: William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: Re: [PATCH RESEND] scsi: ultrastor: Use correct format identifier
 for kernel pointer
Date: Sun, 1 May 2016 19:18:31 -0400
Message-ID: <20160501231831.GA17680@sophia>
References: <20160501215740.GA22213@sophia>
 <1462144105.2337.11.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34806 "EHLO
	mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbcEAXSl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 May 2016 19:18:41 -0400
Content-Disposition: inline
In-Reply-To: <1462144105.2337.11.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, May 01, 2016 at 04:08:25PM -0700, James Bottomley wrote:
>On Sun, 2016-05-01 at 17:57 -0400, William Breathitt Gray wrote:
>> The 'bios_segment' member of a struct ultrastor_config is passed to the
>> sprintf function with a respective %05X format identifier. The
>> 'bio_segment' member is a kernel pointer, but the %X format identifier
>> expects an int data type. A cast to int is correctly used to satisfy the
>> format identifier, but this assumes that the int data type is the same
>> size as the kernel pointer, which is not the case on several
>> architectures such as X86_64. This patch removes the int cast and
>> replaces the %05X format identifier with %pK in order to print the
>> 'bio_segment' member regardless of architecture.
>
>But this statement is wrong: ultrastor only has seven possible hard
>coded bios segment values, all under 20 bits, as it happens, that's why
>the printk is %05X.  Unless you're proposing to alter values in the
>static table, there's no point in changing the print, is there?  Are
>you proposing to alter the static table values?
>
>James

I'm sorry, I didn't realize bios_segment values were all under 20 bits;
in which case they should all fit within the original 5 digit
hexadecimal print. Please ignore this patch then as it was a
misunderstanding on my part.

Thanks,

William Breathitt Gray
