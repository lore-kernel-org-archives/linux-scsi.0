From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] cxlflash: Move to exponential back-off when cmd_room is not available
Date: Wed, 23 Mar 2016 16:24:41 -0500
Message-ID: <B3487E74-E14C-41AA-A3D7-80599D5912F0@linux.vnet.ibm.com>
References: <1458762572-44316-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1458762636-44422-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:43706 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913AbcCWVYs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2016 17:24:48 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 23 Mar 2016 15:24:47 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 0493A19D8040
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2016 15:12:38 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2NLOiMR32243942
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2016 14:24:44 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2NLOhc0010822
	for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2016 15:24:43 -0600
In-Reply-To: <1458762636-44422-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@us.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Mar 23, 2016, at 2:50 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> From: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
> 
> While profiling the cxlflash_queuecommand() path under a heavy load it
> was found that number of retries to find cmd_room was fairly high.
> 
> There are two problems with the current back-off:
> a) It starts with a udelay of 0
> b) It backs-off linearly
> 
> Tried several approaches (a higher multiple 10*n, 100*n, as well as n^2,
> 2^n) and found that the exponential back-off(2^n) approach had the least
> overall cost. Cost as being defined as overall time spent waiting.
> 
> The fix is to change the linear back-off to an exponential back-off.
> This solution also takes care of the problem with the initial
> delay (starts with 1 usec).
> 
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

