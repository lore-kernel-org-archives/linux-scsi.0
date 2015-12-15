From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v2 4/6] cxlflash: Fix to resolve cmd leak after host reset
Date: Tue, 15 Dec 2015 13:45:10 +1100
Message-ID: <566F7EB6.7030005@au1.ibm.com>
References: <1450126293-47440-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1450127222-48145-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:48881 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbbLOCqp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 21:46:45 -0500
Received: from localhost
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Tue, 15 Dec 2015 12:46:42 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id BE0022BB0059
	for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 13:46:38 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBF2kUBS15859748
	for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 13:46:38 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBF2k5e3025998
	for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 13:46:06 +1100
In-Reply-To: <1450127222-48145-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>

On 15/12/15 08:07, Uma Krishnan wrote:
> From: Manoj Kumar <manoj@linux.vnet.ibm.com>
>
> After a few iterations of resetting the card, either during EEH
> recovery, or a host_reset the following is seen in the logs.
> cxlflash 0008:00: cxlflash_queuecommand: could not get a free command
>
> At every reset of the card, the commands that are outstanding are
> being leaked.  No effort is being made to reap these commands.  A few
> more resets later, the above error message floods the logs and the
> card is rendered totally unusable as no free commands are available.
>
> Iterated through the 'cmd' queue and printed out the 'free' counter
> and found that on each reset certain commands were in-use and
> stayed in-use through subsequent resets.
>
> To resolve this issue, when the card is reset, reap all the commands
> that are active/outstanding.
>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

Looks reasonable.

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

-- 
Andrew Donnellan              Software Engineer, OzLabs
andrew.donnellan@au1.ibm.com  Australia Development Lab, Canberra
+61 2 6201 8874 (work)        IBM Australia Limited

