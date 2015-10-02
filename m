From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v5 01/34] cxlflash: Fix to avoid invalid port_sel value
Date: Fri, 2 Oct 2015 14:43:26 +0200
Message-ID: <560E7BEE.3000001@redhat.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443714878-11649-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbbJBMnb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 08:43:31 -0400
In-Reply-To: <1443714878-11649-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, Manoj Kumar <kumarmn@us.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 1.10.2015 17:54, Matthew R. Ochs wrote:
> From: Manoj Kumar <kumarmn@us.ibm.com>
>
> If two concurrent MANAGE_LUN ioctls are issued with the same
> WWID parameter, it would result in an incorrect value of port_sel.
>
> This is because port_sel is modified without any locks being
> held. If the first caller stalls after the return from
> find_and_create_lun(), the value of port_sel will be set
> incorrectly to indicate a single port, though in this case
> it should have been set to both ports.
>
> To fix, use the global mutex to serialize the lookup of the
> WWID and the subsequent modification of port_sel.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

