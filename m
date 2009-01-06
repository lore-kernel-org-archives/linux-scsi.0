From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 07/18] osd_ktests: Add basic OSD tests
Date: Tue, 06 Jan 2009 16:56:23 +0200
Message-ID: <49637117.50108@panasas.com>
References: <49636507.8060808@panasas.com>	<1231251436-9777-1-git-send-email-bharrosh@panasas.com> <20090106234303H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:28790 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZAFO4i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 09:56:38 -0500
Received: by ug-out-1314.google.com with SMTP id 39so1541633ugf.37
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2009 06:56:36 -0800 (PST)
In-Reply-To: <20090106234303H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, osd-dev@open-osd.org, akpm@linux-foundation.org

FUJITA Tomonori wrote:
> On Tue,  6 Jan 2009 16:17:16 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> Currently testing what is implemented in the osd_initiator library.
>> That is - format, create/remove partition, create/remove object,
>> read and write to objects.
>>
>> This test passes against the IBM-OSD-SIM OSDv1 target.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> Reviewed-by: Benny Halevy <bhalevy@panasas.com>
>> ---
>>  drivers/scsi/osd/Kbuild       |    2 +-
>>  drivers/scsi/osd/osd_ktests.c |  331 +++++++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/osd/osd_ktests.h |    4 +
>>  drivers/scsi/osd/osd_uld.c    |    2 +-
>>  4 files changed, 337 insertions(+), 2 deletions(-)
>>  create mode 100644 drivers/scsi/osd/osd_ktests.c
>>
>> diff --git a/drivers/scsi/osd/Kbuild b/drivers/scsi/osd/Kbuild
>> index 4730cdc..6fb823f 100644
>> --- a/drivers/scsi/osd/Kbuild
>> +++ b/drivers/scsi/osd/Kbuild
>> @@ -35,5 +35,5 @@ libosd-y := osd_initiator.o
>>  obj-$(CONFIG_SCSI_OSD_INITIATOR) += libosd.o
>>  
>>  # osd.ko - SCSI ULD and char-device
>> -osd-y := osd_uld.o
>> +osd-y := osd_uld.o osd_ktests.o
>>  obj-$(CONFIG_SCSI_OSD_ULD) += osd.o
>> diff --git a/drivers/scsi/osd/osd_ktests.c b/drivers/scsi/osd/osd_ktests.c
>> new file mode 100644
>> index 0000000..fba4934
>> --- /dev/null
>> +++ b/drivers/scsi/osd/osd_ktests.c
>> @@ -0,0 +1,331 @@
>> +/*
>> + * osd_ktests.c - An osd_initiator library in-kernel test suite
>> + *              called by the osd_uld module
> 
> Why do we need in-kernel test suite?

It must be in kernel, because it tests the in-kernel library.
However it could be in it's own Module, which makes it more
complicated, but doable.

Please note that the submitted tests are the bare minimum and
will be enhanced in the future. Perhaps later when the test grow
I will put them in their own module.

The test is most valuable when bringing up a new target/initiator
to check for compatibility. I'll send a patch ASAP that adds an
option to Kconfigure it out of compilation.

Thanks
Boaz
