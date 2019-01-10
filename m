From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 37/41] scsi: st: mark expected switch fall-throughs
Date: Thu, 10 Jan 2019 13:56:30 -0600
Message-ID: <f6feeaf0-1d2d-2e9f-7a25-898a6a95fccc@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <e0f4aa25970996146427e633bbf92be3eeee2e35.1543374820.git.gustavo@embeddedor.com>
 <99e896e6-b54b-540f-9c44-52dede4f2265@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <99e896e6-b54b-540f-9c44-52dede4f2265@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping (second one):

Who can ack/review/take this patch, please?

Thanks
--
Gustavo

On 12/19/18 6:08 PM, Gustavo A. R. Silva wrote:
> Hi,
> 
> Friendly ping:
> 
> Who can ack or review this patch, please?
> 
> Thanks
> -- 
> Gustavo
> 
> On 11/27/18 10:33 PM, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> Addresses-Coverity-ID: 114994 ("Missing break in switch")
>> Addresses-Coverity-ID: 114995 ("Missing break in switch")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/scsi/st.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
>> index 7ff22d3f03e3..7c7a742a5ef7 100644
>> --- a/drivers/scsi/st.c
>> +++ b/drivers/scsi/st.c
>> @@ -337,12 +337,14 @@ static void st_analyze_sense(struct st_request *SRpnt, struct st_cmdstatus *s)
>>           switch (sense[0] & 0x7f) {
>>           case 0x71:
>>               s->deferred = 1;
>> +            /* fall through */
>>           case 0x70:
>>               s->fixed_format = 1;
>>               s->flags = sense[2] & 0xe0;
>>               break;
>>           case 0x73:
>>               s->deferred = 1;
>> +            /* fall through */
>>           case 0x72:
>>               s->fixed_format = 0;
>>               ucp = scsi_sense_desc_find(sense, SCSI_SENSE_BUFFERSIZE, 4);
>> @@ -2721,6 +2723,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
>>       switch (cmd_in) {
>>       case MTFSFM:
>>           chg_eof = 0;    /* Changed from the FSF after this */
>> +        /* fall through */
>>       case MTFSF:
>>           cmd[0] = SPACE;
>>           cmd[1] = 0x01;    /* Space FileMarks */
>> @@ -2735,6 +2738,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
>>           break;
>>       case MTBSFM:
>>           chg_eof = 0;    /* Changed from the FSF after this */
>> +        /* fall through */
>>       case MTBSF:
>>           cmd[0] = SPACE;
>>           cmd[1] = 0x01;    /* Space FileMarks */
>>
