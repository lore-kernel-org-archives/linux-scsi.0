From: Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH] [SCSI] FlashPoint: optimize string comparison
Date: Wed, 08 Jul 2015 07:59:23 -0600
Message-ID: <559D2CBB.8090502@gonehiking.org>
References: <1436247543-7326-1-git-send-email-christophe.jaillet@wanadoo.fr>	<CAH6sp9PzQUPo2_VczkEtwzhYW8AcNTqNYWF6kwMvk_N8peGhxg@mail.gmail.com>	<559C06B4.2010808@gonehiking.org>	<559CB8EC.1090008@wanadoo.fr> <CAH6sp9OmMje3EAVisaToorOQb+j3AWm_RE_UTpXN6eYjFny72w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <CAH6sp9OmMje3EAVisaToorOQb+j3AWm_RE_UTpXN6eYjFny72w@mail.gmail.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Frans Klaver <fransklaver@gmail.com>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/08/2015 01:12 AM, Frans Klaver wrote:
> On Wed, Jul 8, 2015 at 7:45 AM, Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
>> Le 07/07/2015 19:04, Khalid Aziz a =C3=A9crit :
>>>
>>> On 07/07/2015 02:45 AM, Frans Klaver wrote:
>>>>
>>>> On Tue, Jul 7, 2015 at 7:39 AM, Christophe JAILLET
>>>> <christophe.jaillet@wanadoo.fr> wrote:
>>>>>
>>>>> Stop comparing the strings as soon as we know that they don't mat=
ch.
>>>>>
>>>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>>>> ---
>>>>>    drivers/scsi/FlashPoint.c | 4 +++-
>>>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.=
c
>>>>> index 5c74e4c..24a4d1a 100644
>>>>> --- a/drivers/scsi/FlashPoint.c
>>>>> +++ b/drivers/scsi/FlashPoint.c
>>>>> @@ -6280,8 +6280,10 @@ static unsigned char FPT_scmachid(unsigned=
 char
>>>>> p_card,
>>>>>                   match =3D 1;
>>>>>
>>>>>                   for (k =3D 0; k < ID_STRING_LENGTH; k++) {
>>>>> -                       if (p_id_string[k] !=3D
>>>>> FPT_scamInfo[i].id_string[k])
>>>>> +                       if (p_id_string[k] !=3D
>>>>> FPT_scamInfo[i].id_string[k]) {
>>>>>                                   match =3D 0;
>>>>> +                               break;
>>>>> +                       }
>>>>>                   }
>>>>>
>>>>>                   if (match) {
>>>>
>>>>
>>>> Why doesn't this use strncmp?
>>>>
>>>> Thanks,
>>>> Frans
>>>>
>>>
>>> I suspect that is how this code came from Mylex many years ago. Usi=
ng
>>> strncmp would indeed be a better way to clean this up. Also, furthe=
r down in
>>> the same routine:
>>>
>>>                  if (FPT_scamInfo[match].state =3D=3D ID_UNUSED) {
>>>                          for (k =3D 0; k < ID_STRING_LENGTH; k++) {
>>>                                  FPT_scamInfo[match].id_string[k] =3D
>>>                                      p_id_string[k];
>>>                          }
>>>
>>>
>>> This should use strncpy instead. There is another similar spot furt=
her
>>> down.
>>>
>>> Christophe, if you can send a new patch with these clean-ups, that =
would
>>> be great.
>>>
>>> Thanks,
>>> Khalid
>>
>>
>> Hi,
>>
>> I'm sorry but I won't propose a new patch for that.
>>
>> I had the same reaction at first (why not use strncmp?) but it seems=
 to be
>> the way this driver is coded. Should we want to introduce strncmp he=
re,
>> then, as you have noticed, strcpy should be used to. memset could be=
 also
>> used in many places. Then looking elsewhere in the code, many things=
 should,
>> IMHO, also be fixed. (use consistently empty lines before/after code=
 ; use
>> consistently { }...)
>>
>> Another concern to me is "the use of carriage return". In the follow=
ing
>> examples, things could be much more readable if not limited to 50 ch=
ars per
>> line, or so.
>
> 80. Parts of the code are indented way too much, resulting in these
> unreadable lines. I have to say that this entire driver looks like
> something that (sh|w)ould be in staging right now.

=46lashPoint.c and BusLogic.c together make up the buslogic driver. I w=
ent=20
through a massive clean up of BusLogic.c (addressing issues like the=20
ones you guys are bringing up) when I took over maintenance of buslogic=
=20
driver and made it 64-bit clean. I am very much in agreement with=20
suggested clean ups, but this code has been in the kernel for a very=20
long time and cleaning it up at this point for the sake of clean up is=20
not a reason enough to destabilize a very stable driver. staging is for=
=20
drivers under development and in experimental state. buslogic driver is=
=20
most definitely not experimental. For now we either leave FlashPoint.c=20
as it is or clean it up as part of a bigger effort to add new=20
functionality or fix a major bug.

Christophe's original patch fixes an inefficiency in the code, so my=20
take on it is to either accept the very specific fix without modifying=20
rest of the code or combine this fix with clean up of at least the=20
entire FPT_scmachid() routine.

Thanks,
Khalid



--
To unsubscribe from this list: send the line "unsubscribe kernel-janito=
rs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
