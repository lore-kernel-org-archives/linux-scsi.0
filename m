From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 27/32] cxlflash: Fix to prevent stale AFU RRQ
Date: Thu, 01 Oct 2015 09:51:22 +1000
Message-ID: <87pp0zsbyd.fsf@gamma.ozlabs.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443223144-9962-1-git-send-email-mrochs@linux.vnet.ibm.com> <8737xyuhun.fsf@gamma.ozlabs.ibm.com> <FAA7C7C9-EFA4-4135-B39D-E0255980A5E8@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35666 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbbI3Xvc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2015 19:51:32 -0400
Received: by pacfv12 with SMTP id fv12so55739556pac.2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2015 16:51:31 -0700 (PDT)
In-Reply-To: <FAA7C7C9-EFA4-4135-B39D-E0255980A5E8@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>


>>> Following an adapter reset, the AFU RRQ that resides in host memory
>>> holds stale data. This can lead to a condition where the RRQ interrupt
>>> handler tries to process stale entries and/or endlessly loops due to an
>>> out of sync generation bit.
>>> 
>>> To fix, the AFU RRQ in host memory needs to be cleared after each reset.
>> 
>> This looks good. Do you need anything to bail out of cxlflash_rrq_irq if
>> the data goes stale or to all Fs while that function is running?
>
> We're not performing an MMIO here, so I'm not sure how the all Fs check
> would apply. We're also protected fairly well by the generation bit. I suppose
> we could look at adding some type of 'max iterations' count to protect against
> a runaway handler but that would be in a future patch.

Ah, right you are. I had confused all Fs with UEs.

Reviewed-by: Daniel Axtens <dja@axtens.net>

Regards,
Daniel

