From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7] cxlflash: Simplify attach path error cleanup
Date: Tue, 8 Mar 2016 11:55:44 -0600
Message-ID: <56DF1220.9010000@linux.vnet.ibm.com>
References: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1457128520-53056-4-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:33154 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbcCHRzs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2016 12:55:48 -0500
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Tue, 8 Mar 2016 10:55:47 -0700
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 28E7D1FF0050
	for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2016 10:43:54 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u28HtiFU32440490
	for <linux-scsi@vger.kernel.org>; Tue, 8 Mar 2016 10:55:44 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u28Htger022943
	for <linux-scsi@vger.kernel.org>; Tue, 8 Mar 2016 10:55:44 -0700
In-Reply-To: <1457128520-53056-4-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

On 3/4/2016 3:55 PM, Uma Krishnan wrote:
> From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
>
> The cxlflash_disk_attach() routine currently uses a cascading error
> gate strategy for its error cleanup path. While this strategy is
> commonly used to handle cleanup scenarios, it is too restrictive when
> function callouts need to be restructured. Problems range from
> inserting error path bugs in previously 'good' code to the cleanup
> path imposing design changes to how the normal path is structured.
> A less restrictive approach is needed to support ordering changes
> that come about when operating in different environments.
>
> To overcome this restriction, the error cleanup path is modified to
> have a single entrypoint and use conditional logic to cleanup where
> necessary. Entities that require multiple cleanup steps must be
> carefully vetted to ensure their APIs support state. In cases where
> they do not (none as of this commit) additional local variables can
> be used to maintain state on their behalf.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

Reviewed-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

