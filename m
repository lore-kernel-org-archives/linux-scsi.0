From: Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH] [SCSI] FlashPoint: optimize string comparison
Date: Tue, 07 Jul 2015 11:04:52 -0600
Message-ID: <559C06B4.2010808@gonehiking.org>
References: <1436247543-7326-1-git-send-email-christophe.jaillet@wanadoo.fr> <CAH6sp9PzQUPo2_VczkEtwzhYW8AcNTqNYWF6kwMvk_N8peGhxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH6sp9PzQUPo2_VczkEtwzhYW8AcNTqNYWF6kwMvk_N8peGhxg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Frans Klaver <fransklaver@gmail.com>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/07/2015 02:45 AM, Frans Klaver wrote:
> On Tue, Jul 7, 2015 at 7:39 AM, Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
>> Stop comparing the strings as soon as we know that they don't match.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/scsi/FlashPoint.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
>> index 5c74e4c..24a4d1a 100644
>> --- a/drivers/scsi/FlashPoint.c
>> +++ b/drivers/scsi/FlashPoint.c
>> @@ -6280,8 +6280,10 @@ static unsigned char FPT_scmachid(unsigned char p_card,
>>                  match = 1;
>>
>>                  for (k = 0; k < ID_STRING_LENGTH; k++) {
>> -                       if (p_id_string[k] != FPT_scamInfo[i].id_string[k])
>> +                       if (p_id_string[k] != FPT_scamInfo[i].id_string[k]) {
>>                                  match = 0;
>> +                               break;
>> +                       }
>>                  }
>>
>>                  if (match) {
>
> Why doesn't this use strncmp?
>
> Thanks,
> Frans
>

I suspect that is how this code came from Mylex many years ago. Using 
strncmp would indeed be a better way to clean this up. Also, further 
down in the same routine:

                 if (FPT_scamInfo[match].state == ID_UNUSED) {
                         for (k = 0; k < ID_STRING_LENGTH; k++) {
                                 FPT_scamInfo[match].id_string[k] =
                                     p_id_string[k];
                         }


This should use strncpy instead. There is another similar spot further down.

Christophe, if you can send a new patch with these clean-ups, that would 
be great.

Thanks,
Khalid
