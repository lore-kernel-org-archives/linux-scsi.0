From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Mon, 25 Aug 2014 10:47:09 +0200
Message-ID: <53FAF80D.2070209@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaHYIrN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 04:47:13 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7P8lCYb025126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2014 04:47:12 -0400
In-Reply-To: <53FAE3CA.6060603@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hi,

On 08/25/2014 09:20 AM, Paolo Bonzini wrote:
> Il 23/08/2014 16:52, Hans de Goede ha scritto:
>> Hi All,
>>
>> Now that the UAS driver is no longer marked as CONFIG_BROKEN,
>> I'm getting quite a few bug reports about issues with UAS drives.
>>
>> One if the issues is that there might be a number of bugs in the
>> abort handling path, as I don't think that was ever tested properly.
>>
>> So I'm wondering is there a way to test the abort path with a real
>> drive? E.G. submit some command which is known to take a significant
>> amount of time, and then abort it right after submitting ?
> 
> You could have some luck with QEMU's UAS emulation.  If you set QEMU's
> I/O throttling options low enough (e.g. 100KB/sec), and then use dd with
> iflag=direct and a largish block size (a few MBs), the guest should
> abort its I/O soon enough.

Thanks for the suggestion, that is an interesting idea. The problem is
though, that qemu's uas implementation is modeled after the kernel
uas driver (including some bugs which I've ended up fixing at both ends),

I want to see how real hardware deals with abort commands (e.g. does it
only acknowledge the abort, or does it also sends a sense code for
the actual command).

Regards,

Hans
