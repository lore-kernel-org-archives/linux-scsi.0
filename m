From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] scsi_lib: correctly retry failed zero length REQ_TYPE_FS commands
Date: Tue, 17 May 2016 11:35:07 +0200
Message-ID: <CAMGffE=v1SpKKHz4c_DBODOGTg+E+-oDSTHS=2GuQ2eoUgYeNw@mail.gmail.com>
References: <1463166246.2291.84.camel@HansenPartnership.com> <20160517092835.GI17154@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36520 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbcEQJf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2016 05:35:27 -0400
Received: by mail-oi0-f50.google.com with SMTP id x201so15770860oif.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2016 02:35:27 -0700 (PDT)
In-Reply-To: <20160517092835.GI17154@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Parschauer <s.parschauer@gmx.de>, linux-scsi@vger.kernel.org

On Tue, May 17, 2016 at 11:28 AM, Johannes Thumshirn <jthumshirn@suse.d=
e> wrote:
> On Fri, May 13, 2016 at 12:04:06PM -0700, James Bottomley wrote:
>> When SCSI was written, all commands coming from the filesystem
>> (REQ_TYPE_FS commands) had data.  This meant that our signal for
>> needing to complete the command was the number of bytes completed be=
ing
>> equal to the number of bytes in the request.  Unfortunately, with th=
e
>> advent of flush barriers, we can now get zero length REQ_TYPE_FS
>> commands, which confuse this logic because they satisfy the conditio=
n
>> every time.  This means they never get retried even for retryable
>> conditions, like UNIT ATTENTION because we complete them early assum=
ing
>> they're done.  Fix this by special casing the early completion
>> condition to recognise zero length commands with errors and let them
>> drop through to the retry code.
>>
>> Reported-by: Sebastian Parschauer <s.parschauer@gmx.de>
>> Signed-off-by: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
>>
>> ---
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 8106515..f704d02 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -911,9 +911,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, =
unsigned int good_bytes)
>>       }
>>
>>       /*
>> -      * If we finished all bytes in the request we are done now.
>> +      * special case: failed zero length commands always need to
>> +      * drop down into the retry code. Otherwise, if we finished
>> +      * all bytes in the request we are done now.
>>        */
>> -     if (!scsi_end_request(req, error, good_bytes, 0))
>> +     if (!(blk_rq_bytes(req) =3D=3D 0 && error) &&
>> +         !scsi_end_request(req, error, good_bytes, 0))
>>               return;
>
>
> Naive question, why aren't we checking for blk_rq_bytes(req) =3D=3D 0=
 && error in
> scsi_end_request()?
>

Hi Johannes,

Hannes also suggested this way, but that lead to BUG see:
http://www.spinics.net/lists/linux-scsi/msg96908.html


--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
