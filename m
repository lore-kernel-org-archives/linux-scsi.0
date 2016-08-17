From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6] cxlflash: Avoid mutex when destroying context
Date: Wed, 17 Aug 2016 18:22:38 -0500
Message-ID: <423f2766-2a70-9794-77bf-fbd14b66d7c7@linux.vnet.ibm.com>
References: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1470785958-9152-1-git-send-email-mrochs@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46520 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752761AbcHQXWp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Aug 2016 19:22:45 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7HNE1jV069175
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2016 19:22:44 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
	by mx0b-001b2d01.pphosted.com with ESMTP id 24vky3x9yh-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2016 19:22:43 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Wed, 17 Aug 2016 17:22:43 -0600
In-Reply-To: <1470785958-9152-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

Acked-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

On 8/9/2016 6:39 PM, Matthew R. Ochs wrote:
> Context information structures are protected by a mutex that is held
> when accessing/manipulating the context. When the code that manages
> these structures was authored, a decision was made to include taking
> the mutex as part of the allocation/initialization sequence and also
> handle the scenario where the mutex was already held when freeing the
> context.
>
> While not a problem outright, this design decision has been deemed as
> too flexible and the code should be made more rigid to avoid future bugs.
> In addition, further review of the code yields that the existing mutex
> manipulations in both of these context management paths are superfluous.
>
> This commit removes the obtaining of the context mutex in the context
> initialization routine and assumes the mutex is not held in the context
> free path.
>
> Inspired-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

