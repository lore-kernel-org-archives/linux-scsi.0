From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v2] scsi: NCR5380: Mark expected switch fall-through
Date: Fri, 1 Mar 2019 14:32:30 +1300
Message-ID: <193a8c9d-2af4-150a-c9fc-3113bcc27e4d@gmail.com>
References: <20190228202759.GA5883@embeddedor>
 <alpine.LNX.2.21.1903011143550.8@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1903011143550.8@nippy.intranet>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org

Finn's version looks fine to me.

Cheers,

     Michael

On 1/03/19 2:16 PM, Finn Thain wrote:
> On Thu, 28 Feb 2019, Gustavo A. R. Silva wrote:
>
>> In preparation to enabling -Wimplicit-fallthrough, mark switch
>> cases where we are expecting to fall through.
>>
> This switch case is already marked. So I think the patch description
> should state that this patch is actually a workaround for a gcc deficiency
> which prevents it from locating the marker.
>
>> This patch fixes the following warning:
>>
>> In file included from drivers/scsi/dmx3191d.c:48:
>> drivers/scsi/NCR5380.c: In function ?NCR5380_information_transfer?:
>> drivers/scsi/NCR5380.c:1933:9: warning: this statement may fall through [-Wimplicit-fallthrough=]
>>        if (!hostdata->connected)
>>           ^
>> drivers/scsi/NCR5380.c:1937:5: note: here
>>       default:
>>       ^~~~~~~
>>
>> Warning level 3 was used: -Wimplicit-fallthrough=3
>>
>> Notice that, in this particular case, the code comment is modified
>> in accordance with what GCC is expecting to find.
>>
>> This patch is part of the ongoing efforts to enable
>> -Wimplicit-fallthrough.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>> Changes in v2:
>>   - Update commit log.
>>   - Move code comment after the default label and
>>     retain reason for fall-through in comment as
>>     requested by Michael Schmitz.
>>
>>   drivers/scsi/NCR5380.c | 9 ++++-----
>>   1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
>> index 01c23d27f290..985d1c053578 100644
>> --- a/drivers/scsi/NCR5380.c
>> +++ b/drivers/scsi/NCR5380.c
>> @@ -1933,13 +1933,12 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>>   					if (!hostdata->connected)
>>   						return;
>>   
>> -					/* Fall through to reject message */
>> -
>> +					/* Fall through - to reject message */
> This new hyphen is wrong and harms readability for humans.
>
> I did confirm that gcc can be appeased by the use of a hyphen but not by
> correct grammar such as "Fall through to reject message" or "Fall through.
> Reject message."
>
>> +				default:
>>   					/*
>> -					 * If we get something weird that we aren't expecting,
>> -					 * reject it.
>> +					 * If we get something weird that we
>> +					 * aren't expecting, reject it.
> This reformatting isn't relevant to this patch. The comments can be
> improved however (see below).
>
>>   					 */
>> -				default:
> Moving the 'default' keyword closer to the 'fall through' comment makes
> sense to me -- I could understand if gcc had simple, unambiguous rules for
> annotations.
>
> Do compilers and static analysers agree as to what a correctly annotated
> switch label should look like? If not, we would have to try to mangle code
> and comments in such a way that might satisfy all of the failings in all
> of the tools.
>
>>   					if (tmp == EXTENDED_MESSAGE)
>>   						scmd_printk(KERN_INFO, cmd,
>>   						            "rejecting unknown extended message code %02x, length %d\n",
>>
> Here's an alternative patch, which has the virtue that a simple heuristic
> will work. This patch does not require that other static analysis tools
> will follow gcc's weird rules about hyphens. (I assume they don't but I
> didn't check.)
>
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 7fed9bb72784..fe0535affc14 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -1932,13 +1932,13 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>   					if (!hostdata->connected)
>   						return;
>   
> -					/* Fall through to reject message */
> -
> +					/* Reject message */
> +					/* Fall through */
> +				default:
>   					/*
>   					 * If we get something weird that we aren't expecting,
> -					 * reject it.
> +					 * log it.
>   					 */
> -				default:
>   					if (tmp == EXTENDED_MESSAGE)
>   						scmd_printk(KERN_INFO, cmd,
>   						            "rejecting unknown extended message code %02x, length %d\n",
>
