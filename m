From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 29/32] cxlflash: Fix to double the delay each time
Date: Tue, 29 Sep 2015 15:28:37 -0500
Message-ID: <11CB17AB-0383-41C8-8398-7B875E480A82@linux.vnet.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223157-10039-1-git-send-email-mrochs@linux.vnet.ibm.com> <87wpvat33j.fsf@gamma.ozlabs.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:50478 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbI2Uds (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2015 16:33:48 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 29 Sep 2015 16:33:47 -0400
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 37F2A38C8041
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 16:33:44 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8TKXi5x54067298
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 20:33:44 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8TKXg55025345
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 16:33:43 -0400
In-Reply-To: <87wpvat33j.fsf@gamma.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Axtens <dja@axtens.net>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, Manoj Kumar <manoj@linux.vnet.ibm.com>

> On Sep 28, 2015, at 8:40 PM, Daniel Axtens <dja@axtens.net> wrote:
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com> writes:
> 
>> From: Manoj Kumar <manoj@linux.vnet.ibm.com>
>> 
>> The operator used to double the delay is incorrect and
>> does not result in delay doubling.
>> 
>> To fix, use a left shift instead of the XOR operator.
>> 
> I can see that the patch is correct, but this commit message is a bit
> confusing. What delay? In what circumstances are you doubling it? Why?

This is the response delay while resetting the master context. The reset
is performed by writing a bit and then waiting for it to clear. While waiting
for it to clear, the code relaxes the delta between MMIO reads.



