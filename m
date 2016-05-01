From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND] scsi: ultrastor: Use correct format identifier
 for kernel pointer
Date: Sun, 01 May 2016 16:08:25 -0700
Message-ID: <1462144105.2337.11.camel@linux.vnet.ibm.com>
References: <20160501215740.GA22213@sophia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:53858 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbcEAXIc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 May 2016 19:08:32 -0400
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Sun, 1 May 2016 17:08:31 -0600
In-Reply-To: <20160501215740.GA22213@sophia>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: William Breathitt Gray <vilhelm.gray@gmail.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 2016-05-01 at 17:57 -0400, William Breathitt Gray wrote:
> The 'bios_segment' member of a struct ultrastor_config is passed to the
> sprintf function with a respective %05X format identifier. The
> 'bio_segment' member is a kernel pointer, but the %X format identifier
> expects an int data type. A cast to int is correctly used to satisfy the
> format identifier, but this assumes that the int data type is the same
> size as the kernel pointer, which is not the case on several
> architectures such as X86_64. This patch removes the int cast and
> replaces the %05X format identifier with %pK in order to print the
> 'bio_segment' member regardless of architecture.

But this statement is wrong: ultrastor only has seven possible hard
coded bios segment values, all under 20 bits, as it happens, that's why
the printk is %05X.  Unless you're proposing to alter values in the
static table, there's no point in changing the print, is there?  Are
you proposing to alter the static table values?

James

