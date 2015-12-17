From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6] cxlflash: Fix to avoid virtual LUN failover failure
Date: Thu, 17 Dec 2015 16:19:59 -0600
Message-ID: <5673350F.5040501@linux.vnet.ibm.com>
References: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1449788029-23093-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:57619 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933927AbbLQWTt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2015 17:19:49 -0500
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Thu, 17 Dec 2015 15:19:48 -0700
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id CDEF23E40048
	for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 15:19:46 -0700 (MST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBHMJkBo30343208
	for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 15:19:46 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBHMJjZx031085
	for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 15:19:46 -0700
In-Reply-To: <1449788029-23093-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>

On 12/10/2015 4:53 PM, Uma Krishnan wrote:
> From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
>
> Applications which use virtual LUN's that are backed by a physical LUN
> over both adapter ports may experience an I/O failure in the event of
> a link loss (e.g. cable pull).
>
> Virtual LUNs may be accessed through one or both ports of the adapter.
> This access is encoded in the translation entries that comprise the
> virtual LUN and used by the AFU for load-balancing I/O and handling
> failover scenarios. In a link loss scenario, even though the AFU is
> able to maintain connectivity to the LUN, it is up to the application
> to retry the failed I/O. When applications are unaware of the virtual
> LUN's underlying topology, they are unable to make a sound decision of
> when to retry an I/O and therefore are forced to make their reaction to
> a failed I/O absolute. The result is either a failure to retry I/O or
> increased latency for scenarios where a retry is pointless.
>
> To remedy this scenario, provide feedback back to the application on
> virtual LUN creation as to which ports the LUN may be accessed. LUN's
> spanning both ports are candidates for a retry in a presence of an I/O
> failure.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> ---

Reviewed-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

