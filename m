From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/3] cxlflash: Base error recovery support
Date: Thu, 30 Jul 2015 18:04:28 -0500
Message-ID: <55BAAD7C.9020008@linux.vnet.ibm.com>
References: <1437089195-52118-1-git-send-email-mrochs@linux.vnet.ibm.com> <55B13A99.7030603@linux.vnet.ibm.com> <20150729181253.Horde.skEaoxQBlFsVmLXOtcyLAw7@ltc.linux.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:55772 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbbG3XEE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2015 19:04:04 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Thu, 30 Jul 2015 17:04:04 -0600
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id E470D6E804C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2015 18:55:47 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6UN413550790468
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2015 23:04:01 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6UN40Cg032358
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2015 19:04:01 -0400
In-Reply-To: <20150729181253.Horde.skEaoxQBlFsVmLXOtcyLAw7@ltc.linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com, mrochs@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com
Cc: hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com


Wendy:

Thanks for your review. Comment inline below.

- Manoj Kumar

On 7/29/2015 5:12 PM, wenxiong@linux.vnet.ibm.com wrote:
>> +
>> +    cfg->eeh_active = EEH_STATE_NONE;
>> +    wake_up_all(&cfg->eeh_waitq);
>> +}
>> +
>
> Do you need host->lock in these EEH callback functions?

These are synchronous callbacks and only one of them can be active on a 
card at a time. So, I do not believe these need the host->lock.

