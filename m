From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 09/30] cxlflash: Fix to stop interrupt processing on remove
Date: Thu, 17 Sep 2015 11:55:25 -0500
Message-ID: <F82115EC-8D08-40D7-B4BD-DE1796A865B5@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com> <1442438881-49507-1-git-send-email-mrochs@linux.vnet.ibm.com> <063D6719AE5E284EB5DD2968C1650D6D1CB98C57@AcuExch.aculab.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:50142 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbbIQQze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2015 12:55:34 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 17 Sep 2015 12:55:33 -0400
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id C44416E8041
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2015 12:47:13 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8HGtU5W58458196
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2015 16:55:30 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8HGtRMt002403
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2015 12:55:29 -0400
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CB98C57@AcuExch.aculab.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>

> On Sep 17, 2015, at 6:58 AM, David Laight <David.Laight@ACULAB.COM> wrote:
> 
> From: Linuxppc-dev Matthew R. Ochs
>> Sent: 16 September 2015 22:28
>> Interrupt processing can run in parallel to a remove operation. This
>> can lead to a condition where the interrupt handler is processing with
>> memory that has been freed.
>> 
>> To avoid processing an interrupt while memory may be yanked, check for
>> removal while in the interrupt handler. Bail when removal is imminent.
> 
> On the face of it this just reduces the size of the window somewhat.

Agreed.

> 
> What happens if the interrupt routine reads the flag just before it is set
> (so is processing the entry that is being removed) and is then (say)
> interrupted by a higher priority interrupt that takes longer to execute than
> the remove code?

Understood. To completely close we'd need to either introduce a lock or a
reciprocal flag/count such that the remove doesn't make forward progress
until after interrupt processing has completed. I can look at introducing such
a mechanism in a later patch to fully remove the exposure.


-matt


