From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] [SCSI] Make scsi_transfer_length take a scsi_data_buffer
 argument
Date: Wed, 06 Aug 2014 16:09:14 +0300
Message-ID: <53E228FA.6060901@dev.mellanox.co.il>
References: <20140713113715.GA26031@infradead.org> <1406318419-7273-1-git-send-email-martin.petersen@oracle.com> <53E21BA7.5000703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40485 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaHFNJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2014 09:09:17 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so8884027wib.10
        for <linux-scsi@vger.kernel.org>; Wed, 06 Aug 2014 06:09:16 -0700 (PDT)
In-Reply-To: <53E21BA7.5000703@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@infradead.org>

On 8/6/2014 3:12 PM, Sagi Grimberg wrote:

<SNIP>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index f2db82beb646..fdea8c1527d4 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -391,7 +391,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct
>> iscsi_task *task)
>>       if (scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
>>           task->protected = true;
>>
>> -    transfer_length = scsi_transfer_length(sc);
>> +    transfer_length = scsi_transfer_length(sc, scsi_out(sc));
>
> If we go down this road we should return to the in_len/out_len
> approach that was used before since taking scsi_out(sc) doesn't make
> sense for READs (although it would work).
>

On second thought, since the transfer length is always the
command scsi data buffer length, why not keep it as is and
if at any point in the future DIF will co-exist with bidi,
we can add scsi_bidi_transfer_length which will calculate
the bidi in length.

In this case, an iSCSI bidi transaction will do:
hdr->data_length = scsi_transfer_legnth(sg);
rlen_ahdr->read_length = scsi_bidi_transfer_length(sc);



Sagi.
