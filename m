From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 11/30] cxlflash: Make functions static
Date: Mon, 21 Sep 2015 17:36:40 -0500
Message-ID: <722EE14C-4D78-403A-9EB4-D8FD8C712006@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com> <1442438888-49583-1-git-send-email-mrochs@linux.vnet.ibm.com> <55FFF579.2020306@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:47094 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047AbbIUWgp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2015 18:36:45 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 21 Sep 2015 16:36:44 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 031FC19D8048
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 16:27:34 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8LMZU4V61407280
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 15:35:30 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8LMadoX025095
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 16:36:40 -0600
In-Reply-To: <55FFF579.2020306@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 21, 2015, at 7:18 AM, Tomas Henzl <thenzl@redhat.com> wrote:
> On 16.9.2015 23:28, Matthew R. Ochs wrote:
>> 
>> +
>> +write_rrin:
>> +	nretry = 0;
>> +	writeq_be(rrin, &afu->host_map->ioarrin);
>> +	do {
>> +		rrin = readq_be(&afu->host_map->ioarrin);
>> +		if (rrin != 0x1)
>> +			break;
>> +		/* Double delay each time */
>> +		udelay(2 ^ nretry);
> 
> Double delay - isn't another operator needed?
> If so, pleas add a new patch for this.
> --tm

Good catch. This was an oversight. Will fix in a new patch in v3.


-matt

