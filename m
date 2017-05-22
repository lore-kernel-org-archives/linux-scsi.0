From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] csiostor: Avoid content leaks and casts
Date: Mon, 22 May 2017 09:29:41 -0700
Message-ID: <CAGXu5jL6nN79vHLrWeC5YNkhUcuSR9mUNOt19Y2VXuj1qBvhSQ@mail.gmail.com>
References: <20170509223444.GA51314@beast> <20170522150544.GA1677@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:38754 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933696AbdEVQ3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2017 12:29:43 -0400
Received: by mail-it0-f53.google.com with SMTP id r63so647437itc.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2017 09:29:43 -0700 (PDT)
In-Reply-To: <20170522150544.GA1677@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Daniel Micay <danielmicay@gmail.com>

On Mon, May 22, 2017 at 8:05 AM, Varun Prakash <varun@chelsio.com> wrote:
> On Tue, May 09, 2017 at 03:34:44PM -0700, Kees Cook wrote:
>> When copying attributes, the len argument was padded out and the resulting
>> memcpy() would copy beyond the end of the source buffer.  Avoid this,
>> and use size_t for val_len to avoid all the casts. Similarly, avoid source
>> buffer casts and use void *.
>>
>> Additionally enforces val_len can be represented by u16 and that
>> the DMA buffer was not overflowed. Fixes the size of mfa, which is not
>> FC_FDMI_PORT_ATTR_MAXFRAMESIZE_LEN (but it will be padded up to 4). This
>> was noticed by the future CONFIG_FORTIFY_SOURCE checks.
>>
>> Cc: Daniel Micay <danielmicay@gmail.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/scsi/csiostor/csio_lnode.c | 43 +++++++++++++++++++++++---------------
>>  1 file changed, 26 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
>> index c00b2ff72b55..be5ee2d37815 100644
>> --- a/drivers/scsi/csiostor/csio_lnode.c
>> +++ b/drivers/scsi/csiostor/csio_lnode.c
>> @@ -238,14 +238,23 @@ csio_osname(uint8_t *buf, size_t buf_len)
>>  }
>>
>
>
>>
>>       csio_append_attrib(&pld, FC_FDMI_HBA_ATTR_MAXCTPAYLOAD,
>> -                        (uint8_t *)&maxpayload,
>> -                        FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN);
>> +                        &maxpayload, FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN);
>>       len = (uint32_t)(pld - (uint8_t *)cmd);
>>       numattrs++;
>>       attrib_blk->numattrs = htonl(numattrs);
>> @@ -1794,6 +1801,8 @@ csio_ln_mgmt_submit_req(struct csio_ioreq *io_req,
>>       struct csio_mgmtm *mgmtm = csio_hw_to_mgmtm(hw);
>>       int rv;
>>
>> +     BUG_ON(pld_len > pld->len);
>> +
>
> I think WARN_ON() is better than BUG_ON() in this case
>
>         if (WARN_ON(pld_len > pld->len))
>                 return -EINVAL;
>
>>       io_req->io_cbfn = io_cbfn;      /* Upper layer callback handler */
>>       io_req->fw_handle = (uintptr_t) (io_req);
>>       io_req->eq_idx = mgmtm->eq_idx;

I chose BUG_ON here because the damage has already been done. If this
assertion is hit, the heap buffers have already been overrun. This
isn't a state we should only warn about...

-Kees

-- 
Kees Cook
Pixel Security
