From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/2] qla2xxx: fix rwlock recursion
Date: Wed, 14 Oct 2015 09:53:20 -0700
Message-ID: <561E8880.2060204@sandisk.com>
References: <1444838261-20990-1-git-send-email-himanshu.madhani@qlogic.com>
 <1444838261-20990-3-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0075.outbound.protection.outlook.com ([65.55.169.75]:55762
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752695AbbJNQx0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Oct 2015 12:53:26 -0400
In-Reply-To: <1444838261-20990-3-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com, hch@lst.de
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On 10/14/2015 08:57 AM, Himanshu Madhani wrote:
> -qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong off_in,
> -			     void __iomem **off_out)
> +qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong *off)
>   {

Hello Himanshu,

Do you think it would be possible to keep the input and output offset as 
separate arguments ? Something that is very unfortunate about this patch 
is that it converts the qla82xx_pci_set_crbwindow_2M() function again 
into a function that expects an unsigned long in *off and writes an I/O 
memory address into *off. It is impossible to avoid that source code 
does not trigger any sparse warning if such functions occur.

Thanks,

Bart.
