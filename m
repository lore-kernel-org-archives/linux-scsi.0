From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 29/30] cxlflash: Fix to avoid state change collision
Date: Mon, 21 Sep 2015 17:59:45 -0500
Message-ID: <7933AA11-CF46-40DA-A7FA-C309C4CBE3C8@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com> <1442439158-50453-1-git-send-email-mrochs@linux.vnet.ibm.com> <55FFFBB1.9050802@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:40833 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045AbbIUW7t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2015 18:59:49 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 21 Sep 2015 16:59:48 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id E6D6919D8026
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 16:50:39 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8LMwsnv61669422
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 15:58:54 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8LMxjj9011563
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 16:59:46 -0600
In-Reply-To: <55FFFBB1.9050802@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 21, 2015, at 7:44 AM, Tomas Henzl <thenzl@redhat.com> wrote:
> On 16.9.2015 23:32, Matthew R. Ochs wrote:
>> The adapter state machine is susceptible to missing and/or
>> corrupting state updates at runtime. This can lead to a variety
>> of unintended issues and is due to the lack of a serialization
>> mechanism to protect the adapter state.
>> 
>> Use an adapter-wide mutex to serialize state changes.
> 
> I've just briefly looked into your code, but it seems to me that
> an atomic variable would serve your needs also and might be 
> more effective resulting in a faster code execution?

Will keep this in mind. 

> If you keep the mutex way you don't need two mutexes
> in cxlflash_afu_sync - you should remove the mutex &sync_active

Agreed. Will remove as part of this patch in v3.


