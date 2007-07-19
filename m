From: Chris Ruehl <aacraidbug@xit.com.hk>
Subject: Re: aacraid 2.6.21+ partition table disappear
Date: Thu, 19 Jul 2007 13:34:45 +0800
Message-ID: <469EF7F5.7060103@xit.com.hk>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01BF5F29@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from si01.xit.com.hk ([202.67.236.24]:51501 "EHLO si01.xit.com.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbXGSFew (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2007 01:34:52 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by si01.xit.com.hk (Postfix) with ESMTP id 2C0D5C7054
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jul 2007 13:34:50 +0800 (HKT)
Received: from si01.xit.com.hk ([127.0.0.1])
	by localhost (si01.xit.com.hk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SKS5xgp4GKc9 for <linux-scsi@vger.kernel.org>;
	Thu, 19 Jul 2007 13:34:49 +0800 (HKT)
Received: from sx01.office.xit.com.hk (unknown [218.189.225.163])
	by si01.xit.com.hk (Postfix) with ESMTP id 1FF2DC7051
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jul 2007 13:34:49 +0800 (HKT)
Received: from ws-chris.office.xit.com.hk ([10.10.25.152] ident=chris)
	by sx01.office.xit.com.hk with esmtp (Exim 4.63)
	(envelope-from <aacraidbug@xit.com.hk>)
	id 1IBOf2-0006n2-Od
	for linux-scsi@vger.kernel.org; Thu, 19 Jul 2007 13:34:48 +0800
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01BF5F29@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-scsi vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Mark,

the 2.6.22.1 already inherits your patch but still could not boot.
The patch you send remove the 'FSCS_HIDDEN' check.
I found one more check in line 480 of aachba.c (2.6.22.1) my this cause the
problem?

   461
   462 static int _aac_probe_container2(void * context, struct fib * 
fibptr)
   463 {
          ...
   478                 if ((le32_to_cpu(dresp->status) == ST_OK) &&
   479                     (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
   480                     (le32_to_cpu(dresp->mnt[0].state) != 
FSCS_HIDDEN)) {
   481                         fsa_dev_ptr->valid = 1;


I search/read the thread from 2007/04/13 and the difference the
AACRAID in this thread is "rev 02"  ours "rev 01".


thank you
Chris






Salyzyn, Mark wrote:
> The problem description matches this patch (which showed up on
> 2007/04/13).
>
> Sincerely -- Mark Salyzyn
>
>   
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org 
>> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Chris Ruehl
>> Sent: Wednesday, July 18, 2007 5:48 AM
>> To: Linux-scsi vger.kernel.org
>> Subject: aacraid 2.6.21+ partition table disappear 
>>
>>
>> Hi all,
>>
>> I had been last 2 Day in China trying update a Linux (Debian Sarge)
>> running a 2.6.14.3 to 2.6.21.6 or 2.6.22.1
>>
>> The boot stuck in a VFS Kernel Panic no root filesystem found.
>>
>> 1) aacraid compiled into kernel - failed
>> 2) as module + initrd                  - failed
>>
>> the initrd show that the sda with 200GB was found - driver sd
>> but no partition was found.
>>
>> Sorry I could not get a serial cable to cover the boot log - and it's 
>> impossible
>> to get one if you can't speak Mandarin.
>>
>> Do you have any hint what I could do?
>>
>> Thank you
>> Chris
>>
>> Controller is
>> 0000:02:08.0 RAID bus controller: Adaptec AAC-RAID (rev 01)
>>         Subsystem: Adaptec 2120S (Crusader)
>>
>>
>> kerneloutput   """  2.6.14.3  """
>>
>> Loading Adaptec I2O RAID: Version 2.4 Build 5go
>> Detecting Adaptec I2O RAID controllers...
>> Adaptec aacraid driver (1.1-4 Jan 28 2006 18:35:59)
>> AAC0: kernel 4.2-0[8205]
>> AAC0: monitor 4.2-0[8205]
>> AAC0: bios 4.2-0[8205]
>> AAC0: serial c49a76
>> AAC0: Non-DASD support enabled.
>> scsi0 : aacraid
>>   Vendor: ADAPTEC   Model: XITArray1         Rev: V1.0
>>   Type:   Direct-Access                      ANSI SCSI revision: 02
>>   Vendor: SEAGATE   Model: ST373207LC        Rev: D701
>>   Type:   Direct-Access                      ANSI SCSI revision: 03
>>   Vendor: SEAGATE   Model: ST373207LC        Rev: D701
>>   Type:   Direct-Access                      ANSI SCSI revision: 03
>>   Vendor: SEAGATE   Model: ST373207LC        Rev: D701
>>   Type:   Direct-Access                      ANSI SCSI revision: 03
>>   Vendor: SEAGATE   Model: ST373207LC        Rev: D701
>>   Type:   Direct-Access                      ANSI SCSI revision: 03
>>   Vendor: SEAGATE   Model: ST373207LC        Rev: D701
>>   Type:   Direct-Access                      ANSI SCSI revision: 03
>> 3ware 9000 Storage Controller device driver for Linux v2.26.02.004.
>> SCSI device sda: 429920256 512-byte hdwr sectors (220119 MB)
>> sda: Write Protect is off
>> sda: Mode Sense: 03 00 00 00
>> sda: got wrong page
>> sda: assuming drive cache: write through
>> SCSI device sda: 429920256 512-byte hdwr sectors (220119 MB)
>> sda: Write Protect is off
>> sda: Mode Sense: 03 00 00 00
>> sda: got wrong page
>> sda: assuming drive cache: write through
>>  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
>>
>>
>> -- 
>> X-IT Management Ltd.
>> Office A, 14/F, Wing Sing Commercial Bldg.
>> 12 Wing Lok Street, Sheung Wan
>> Hong Kong
>>
>> 3596 7575  PHONE
>> 3585 5118  FAX
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     


-- 
X-IT Management Ltd.
Office A, 14/F, Wing Sing Commercial Bldg.
12 Wing Lok Street, Sheung Wan
Hong Kong

3596 7575  PHONE
3585 5118  FAX

