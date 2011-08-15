From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] SCSI: OSD: Kconfig: Select SHA1 and HMAC for OSD Initiator
 library
Date: Mon, 15 Aug 2011 11:44:00 -0700
Message-ID: <4E4968F0.9050108@panasas.com>
References: <20110811142749.GA26109@maxin> <CAMhs6Yy_O33jZ5N7E5UuAtjoRyyEcUG8s4-PQwooX-TJ3Wh=2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:60814 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab1HOSoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2011 14:44:13 -0400
In-Reply-To: <CAMhs6Yy_O33jZ5N7E5UuAtjoRyyEcUG8s4-PQwooX-TJ3Wh=2A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maxin B John <maxin.john@gmail.com>
Cc: rdunlap@xenotime.net, Benny Halevy <bhalevy@panasas.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 08/14/2011 04:18 PM, Maxin B John wrote:
> Ping..
> 
> On Thu, Aug 11, 2011 at 5:27 PM, Maxin B. John <maxin.john@gmail.com> wrote:
>> SCSI_OSD_INITIATOR should select CRYPTO_SHA1 and CRYPTO_HMAC. Express this
>> in Kconfig so that the requirements are met automatically.
>>
>> Signed-off-by: Maxin B. John <maxin.john@gmail.com>

Yes sorry. It was on my todo and I never got to it.

OK So actually current osd_initiator code does not use these libraries.
It should, and I have very old code that started on that (hence the comment),
but it was never submitted to Kernel. The OSD protocol calls for all kind of
security levels that use these, but the current code only supports NO_SEC.

I will keep your patch for when security code goes in. Meanwhile I should
at least remove the stale comment.

Thanks
Boaz

>> ---
>> diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
>> index 861b5ce..1535fe1 100644
>> --- a/drivers/scsi/osd/Kconfig
>> +++ b/drivers/scsi/osd/Kconfig
>> @@ -11,17 +11,16 @@
>>  # it under the terms of the GNU General Public version 2 License as
>>  # published by the Free Software Foundation
>>  #
>> -# FIXME: SCSI_OSD_INITIATOR should select CONFIG (HMAC) SHA1 somehow.
>> -#        How is it done properly?
>>  #
>>
>>  config SCSI_OSD_INITIATOR
>>        tristate "OSD-Initiator library"
>>        depends on SCSI
>> +       select CRYPTO
>> +       select CRYPTO_SHA1
>> +       select CRYPTO_HMAC
>>        help
>>                Enable the OSD-Initiator library (libosd.ko).
>> -               NOTE: You must also select CRYPTO_SHA1 + CRYPTO_HMAC and their
>> -               dependencies
>>
>>  config SCSI_OSD_ULD
>>        tristate "OSD Upper Level driver"
>>

