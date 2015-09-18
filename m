From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 12/30] cxlflash: Refine host/device attributes
Date: Fri, 18 Sep 2015 18:56:25 -0500
Message-ID: <AA42C2F0-94E8-45D6-8438-7F7BE0C9E046@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com> <1442438954-49663-1-git-send-email-mrochs@linux.vnet.ibm.com> <55FC8371.5010900@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:36948 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbbIRX4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2015 19:56:30 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 18 Sep 2015 19:56:30 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 624B938C8026
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 19:56:27 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8INuR4M51839008
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 23:56:27 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8INuQqY018660
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 19:56:27 -0400
In-Reply-To: <55FC8371.5010900@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Shane Seymour <shane.seymour@hp.com>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 18, 2015, at 4:34 PM, Brian King <brking@linux.vnet.ibm.com> wrote:
> On 09/16/2015 04:29 PM, Matthew R. Ochs wrote:
>> 
>> +	ssize_t bytes = 0;
>> +	__be64 __iomem *fc_port;
>> +
>> +	if (port >= NUM_FC_PORTS)
>> +		return 0;
>> +
>> +	fc_port = &afu->afu_map->global.fc_port[port][0];
>> +
>> +	for (i = 0; i < CXLFLASH_NUM_VLUNS; i++, buf += 22)
> 
> Rather than this bug prone hard coded 22, how about never incrementing buf and do something
> similar to this:
> 
>> +		bytes += scnprintf(buf, PAGE_SIZE, "%03d: %016llX\n",
>> +				   i, readq_be(&fc_port[i]));
> 
> 		bytes += scnprintf(&buf[bytes], PAGE_SIZE, "%03d: %016llX\n",
> 				   i, readq_be(&fc_port[i]));
> 
>> +	return bytes;
>> +}
>> +

Great suggestion! Will fix in v3.


-matt
