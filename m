From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 1/3] cxlflash: Avoid double free of character device
Date: Thu, 29 Jun 2017 07:58:19 +0200
Message-ID: <4d8934d0-5cda-2800-77f2-a131bd368ee8@suse.com>
References: <1498669929-39684-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1498670061-39766-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:36887 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751596AbdF2F6W (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Thu, 29 Jun 2017 01:58:22 -0400
In-Reply-To: <1498670061-39766-1-git-send-email-mrochs@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 06/28/2017 07:14 PM, Matthew R. Ochs wrote:
> The device_unregister() service used when cleaning up the character
> device is already responsible for the internal state associated with
> the device upon successful creation. As the cxlflash driver does not
> obtain a second reference to the character device, the explicit call
> to put_device() is not required and can lead to an inconsistent sysfs
> among other issues as the reference is no longer valid after the first
> put_device() is performed.
> 
> Remove the unnecessary put_device() to remedy this issue.
> 
> Fixes: a834a36b57d9 ("scsi: cxlflash: Create character device to provide host management interface")
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>> ---
>  drivers/scsi/cxlflash/main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
