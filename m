From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: implement IMMED bit
Date: Wed, 31 Jan 2018 15:26:14 -0500
Message-ID: <a59aa2e7-fa26-6e24-9e79-5a14307fb49a@interlog.com>
References: <20180130055445.20244-1-dgilbert@interlog.com>
 <ed3a63f0-2cbb-8fac-fee7-4f08b1e1e8e2@wdc.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33713 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751296AbeAaU0Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Jan 2018 15:26:25 -0500
In-Reply-To: <ed3a63f0-2cbb-8fac-fee7-4f08b1e1e8e2@wdc.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hare@suse.de

On 2018-01-31 12:06 PM, Bart Van Assche wrote:
> On 01/29/18 21:54, Douglas Gilbert wrote:
>> +static const struct opcode_info_t sync_cache_iarr[] = {
>> +    {0, 0x91, 0, F_LONG_DELAY | F_M_ACCESS, resp_sync_cache, NULL,
>> +        {16,  0x7, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
>                    ^^^
> Can you clarify the choice of "0x7" in the above? After having had a look at 
> SBC-4 I was expecting 0x2 (the mask for the IMMED bit) since all other bits in 
> that command byte are either reserved or obsolete.

As a general rule when you see "obsolete" that means that field was used
in an earlier standard (bit 0 was RELADDR and bit 2 was SYNC_NV). So
application clients complying with earlier versions of SBC might set those
bits. If they are set and the mask is being enforced I choose to not fail
the command as an illegal request. Basically accept and ignore.

>> -    return 0;
>> +    return (cmd[1] & 0x1) ? SDEG_RES_IMMED_MASK : 0; /* check IMMED bit */
> 
> Shouldn't the mask 0x2 be used to check for the IMMED bit?

That comment needs a little more context:

@@ -1597,7 +1614,7 @@ static int resp_start_stop(struct scsi_cmnd * scp,
         }
         stop = !(cmd[4] & 1);
         atomic_xchg(&devip->stopped, stop);
-       return 0;
+       return (cmd[1] & 0x1) ? SDEG_RES_IMMED_MASK : 0; /* check IMMED bit */


For START STOP UNIT the IMMED flag is byte 1, bit 0. So that code
is correct IMO.


And for SYNCHRONIZE CACHE(10 and 16) the IMMED flag is byte 1 bit 1
so the corresponding return statement is:

+       return (cmd[1] & 0x2) ? SDEG_RES_IMMED_MASK : 0; /* check IMMED bit */


Doug Gilbert
