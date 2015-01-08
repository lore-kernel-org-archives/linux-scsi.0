From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 1/8] megaraid_sas : Endianness related bug fixes and code optimization
Date: Thu, 8 Jan 2015 19:13:18 +0530
Message-ID: <a24e6f2fbad0983e24fc583d013b19a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og114.obsmtp.com ([64.18.2.215]:58061 "EHLO
	exprod7og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbbAHNnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2015 08:43:21 -0500
Received: by mail-qc0-f179.google.com with SMTP id c9so1860455qcz.10
        for <linux-scsi@vger.kernel.org>; Thu, 08 Jan 2015 05:43:21 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, martin.petersen@oracle.com, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@infradead.org]
>Sent: Thursday, January 08, 2015 4:09 PM
>To: Sumit.Saxena@avagotech.com
>Cc: linux-scsi@vger.kernel.org; stable@vger.kernel.org;
>martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com
>Subject: Re: [PATCH 1/8] megaraid_sas : Endianness related bug fixes and
>code optimization
>
>> -#if   defined(__BIG_ENDIAN_BITFIELD)
>> -	u32     MessageAddress1:24; /* bits 31:8*/
>> -	u32     RequestFlags:8;
>> -#else
>>  	u32     RequestFlags:8;
>> -	u32     MessageAddress1:24; /* bits 31:8*/
>> -#endif
>> -	u32     MessageAddress2;      /* bits 61:32 */
>> +	u32     MessageAddress1:24;
>> +	u32     MessageAddress2;
>
>Doesn't this break architectures that set __BIG_ENDIAN_BITFIELD?
Earlier code create the req_desc in machine format and later we convert it
into LE format (as FW wants the data In LE format). Now with this change
we just simplify code, which will first convert req_desc to LE format and
set the MessageAddres1 and RequestFlags  in LE format. Eventually this
will pass same address/flag frame as earlier code does, but giving some
readability.

We have tested this on PPC and this works fine. Actually, this MFA frame
will be fired only at driver load time(for firmware initialization), so if
this setting is not appropriate FW init will fail. We do not refer MFIAIo
anywhere else.

Thanks,
Sumit
