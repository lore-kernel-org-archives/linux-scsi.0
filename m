From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH v5] sg: relax 16 byte cdb restriction
Date: Thu, 05 Jun 2014 18:46:38 +0300
Message-ID: <539090DE.7040808@gmail.com>
References: <538E035A.10703@interlog.com> <53908F6A.5090309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54929 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaFEPqm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 11:46:42 -0400
Received: by mail-pd0-f178.google.com with SMTP id v10so1259165pde.9
        for <linux-scsi@vger.kernel.org>; Thu, 05 Jun 2014 08:46:42 -0700 (PDT)
In-Reply-To: <53908F6A.5090309@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>, Christian Franke <Christian.Franke@t-online.de>, James Bottomley <james.bottomley@hansenpartnership.com>

On 06/05/2014 06:40 PM, Boaz Harrosh wrote:
> On 06/03/2014 08:18 PM, Douglas Gilbert wrote:
>> v4 of this patch was sent 20131201.
>>
>> ChangeLog:
>>          - remove the 16 byte CDB (SCSI command) length limit
>>            from the sg driver by handling longer CDBs the same
>>            way as the bsg driver. Remove comment from sg.h
>>            public interface about the cmd_len field being
>>            limited to 16 bytes.
>>          - remove some dead code caused by this change
>>          - cleanup comment block at the top of sg.h, fix urls
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>>
>>
>> sg_cdb_dg5.patch
>>
>>
> <>
>>  
>> +/* SG_MAX_CDB_SIZE should be 260 (spc4r37 section 3.1.30) however the type
>> + * of sg_io_hdr::cmd_len can only represent 255
>> + */
>> +#define SG_MAX_CDB_SIZE 255
>> +
<>

BTW here too. Why new code is using the old interface?
I thought that the all point for having bsg at all is
that new stuff are implemented there in a cleaner interface
for example large CDBs.
Otherwise what was the point for bsg in the first place?
(It was before my time, It would be nice to know?)

What is then left unique at bsg after this patch? only bidi?

Thanks
Boaz

