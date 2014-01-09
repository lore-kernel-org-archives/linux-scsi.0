From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] drivers: target: target_core_mod: use div64_u64_rem()
 instead of operator '%' for u64
Date: Thu, 09 Jan 2014 11:17:04 +0100
Message-ID: <52CE7720.6060809@suse.de>
References: <52B4F837.1010403@gmail.com>	 <1387680997.5567.91.camel@haakon3.risingtidesystems.com>	 <52B6AE19.80401@gmail.com>	 <1387781487.5567.147.camel@haakon3.risingtidesystems.com>	 <52B90111.5050203@gmail.com> <52CCFF0C.7070704@suse.de> <1389223117.5567.271.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389223117.5567.271.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, James Hogan <james.hogan@imgtec.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 01/09/2014 12:18 AM, Nicholas A. Bellinger wrote:
> On Wed, 2014-01-08 at 08:32 +0100, Hannes Reinecke wrote:
>> On 12/24/2013 04:35 AM, Chen Gang wrote:
>>> On 12/23/2013 02:51 PM, Nicholas A. Bellinger wrote:
>>>> On Sun, 2013-12-22 at 17:17 +0800, Chen Gang wrote:
>
> <SNIP>
>
>>>>> The related fix patch changed "start_lba =3D lba % ..." to "start=
_lba =3D
>>>>> lba / ...", and also assumed "segment_size * segment_mult" is sti=
ll
>>>>> within u32 (can not cause type over flow).
>>>>>
>>>>> I guess the original author already knew about them, and intended=
 to do
>>>>> like that (if not, please let me know, thanks).
>>>>>
>>>>
>>>> Sorry, your correct that the original code is using modulo divisio=
n to
>>>> calculate start_lba.
>>>>
>>>
>>> Oh, that's all right, (in fact, don't need sorry), I am not quite
>>> familiar with the details, so need related member help check it.  :=
-)
>>>
>>>> Hannes, can you please double check this below..?
>>>>
>>>
>>> Please help check when have time, thanks.
>>>
>> I would even convert segment_size and segment_mult to u64,
>> to ensure no overflows occur:
>>
>> diff --git a/drivers/target/target_core_alua.c
>> b/drivers/target/target_core_alua
>> .c
>> index 9b1856d..54b1e52 100644
>> --- a/drivers/target/target_core_alua.c
>> +++ b/drivers/target/target_core_alua.c
>> @@ -477,8 +477,7 @@ static inline int core_alua_state_lba_dependent(
>>          u8 *alua_ascq)
>>   {
>>          struct se_device *dev =3D cmd->se_dev;
>> -       u32 segment_size, segment_mult, sectors;
>> -       u64 lba;
>> +       u64 segment_size, segment_mult, sectors, lba;
>>
>>          /* Only need to check for cdb actually containing LBAs */
>>          if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB))
>>
>>
>
> Will squash the above into the original patch shortly in for-next..
>
>> Other than that the sector_div() patch is correct.
>>
>
> <nod> Thanks for confirming that sector_div() is correct here vs. the
> original code using modulo that Chen had pointed out.
>
Ah, _that_ was the issue.
I was wondering why you kept on poking me ...

Well.
No, that's actually _not_ correct.
The correct fix would be

diff --git a/drivers/target/target_core_alua.c=20
b/drivers/target/target_core_alua.c
index 54b1e52..12da9b3 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -500,8 +500,7 @@ static inline int core_alua_state_lba_dependent(

                         if (segment_mult) {
                                 u64 tmp =3D lba;
-                               sector_div(tmp, segment_size *=20
segment_mult);
-                               start_lba =3D tmp;
+                               start_lba =3D sector_div(tmp, segment_s=
ize=20
* segment_mult);

                                 last_lba =3D first_lba + segment_size =
- 1;
                                 if (start_lba >=3D first_lba &&
(beware of line breaks ...)
Thing is, we need to calculate the offset into the segment to figure ou=
t=20
which map entry to use.
The actual number of the segment (as had been calculated with the=20
original fix) is immaterial here.

Sorry for this. The email thread just flew past me during Xmas
with me not paying real attention.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
