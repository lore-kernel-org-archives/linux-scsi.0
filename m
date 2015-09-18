From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 04/30] cxlflash: Fix potential oops following LUN removal
Date: Fri, 18 Sep 2015 18:18:24 -0500
Message-ID: <D9F09DDE-0CAE-4086-960A-761C9CEAC324@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com> <1442438860-49316-1-git-send-email-mrochs@linux.vnet.ibm.com> <55FB683A.5000201@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:33925 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbbIRXSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2015 19:18:30 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 18 Sep 2015 17:18:29 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 53D9D3E40044
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 17:18:26 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8INIQAn6619404
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 16:18:26 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8INIOn9024431
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 17:18:25 -0600
In-Reply-To: <55FB683A.5000201@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 17, 2015, at 8:26 PM, Brian King <brking@linux.vnet.ibm.com> wrote:
> 
> On 09/16/2015 04:27 PM, Matthew R. Ochs wrote:
>> 
>> 	lun_access = kzalloc(sizeof(*lun_access), GFP_KERNEL);
>> 	if (unlikely(!lun_access)) {
>> 		dev_err(dev, "%s: Unable to allocate lun_access!\n", __func__);
>> +		scsi_device_put(sdev);
> 
> Looks like you've got a double scsi_device_put in this path, since there is another put
> in the the err0 path.

Good catch! I'll fix in v3.

