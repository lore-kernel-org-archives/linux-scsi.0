From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] drivers: target: target_core_mod: use div64_u64_rem()
 instead of operator '%' for u64
Date: Wed, 08 Jan 2014 08:32:28 +0100
Message-ID: <52CCFF0C.7070704@suse.de>
References: <52B4F837.1010403@gmail.com>  <1387680997.5567.91.camel@haakon3.risingtidesystems.com>  <52B6AE19.80401@gmail.com> <1387781487.5567.147.camel@haakon3.risingtidesystems.com> <52B90111.5050203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbaAHHca (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jan 2014 02:32:30 -0500
In-Reply-To: <52B90111.5050203@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chen Gang <gang.chen.5i5j@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Hogan <james.hogan@imgtec.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>

On 12/24/2013 04:35 AM, Chen Gang wrote:
> On 12/23/2013 02:51 PM, Nicholas A. Bellinger wrote:
>> On Sun, 2013-12-22 at 17:17 +0800, Chen Gang wrote:
>>> On 12/22/2013 10:56 AM, Nicholas A. Bellinger wrote:
>>>> Hi Chen,
>>>>
>>>> On Sat, 2013-12-21 at 10:08 +0800, Chen Gang wrote:
>>>>> In kernel, need use div64_u64_rem() instead of operator '%' for u=
64, or
>>>>> can not pass compiling (with allmodconfig under metag):
>>>>>
>>>>>     MODPOST 2909 modules
>>>>>   ERROR: "__umoddi3" [drivers/target/target_core_mod.ko] undefine=
d!
>>>>>
>>>>> Also need u64 type cast for u32 variable multiply u32 variable, o=
r will
>>>>> cause type overflow issue.
>>>>>
>>>>>
>>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>>>> ---
>>>>>  drivers/target/target_core_alua.c | 3 ++-
>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>
>>>>
>>>> FYI, this unsigned long long division in core_alua_state_lba_depen=
dent()
>>>> was fixed for 32-bit in linux-next >=3D 12192013 code.
>>>>
>>>
>>> OK, thanks.
>>>
>>> The related fix patch changed "start_lba =3D lba % ..." to "start_l=
ba =3D
>>> lba / ...", and also assumed "segment_size * segment_mult" is still
>>> within u32 (can not cause type over flow).
>>>
>>> I guess the original author already knew about them, and intended t=
o do
>>> like that (if not, please let me know, thanks).
>>>
>>
>> Sorry, your correct that the original code is using modulo division =
to
>> calculate start_lba.
>>
>=20
> Oh, that's all right, (in fact, don't need sorry), I am not quite
> familiar with the details, so need related member help check it.  :-)
>=20
>> Hannes, can you please double check this below..?
>>
>=20
> Please help check when have time, thanks.
>=20
I would even convert segment_size and segment_mult to u64,
to ensure no overflows occur:

diff --git a/drivers/target/target_core_alua.c
b/drivers/target/target_core_alua
=2Ec
index 9b1856d..54b1e52 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -477,8 +477,7 @@ static inline int core_alua_state_lba_dependent(
        u8 *alua_ascq)
 {
        struct se_device *dev =3D cmd->se_dev;
-       u32 segment_size, segment_mult, sectors;
-       u64 lba;
+       u64 segment_size, segment_mult, sectors, lba;

        /* Only need to check for cdb actually containing LBAs */
        if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB))


Other than that the sector_div() patch is correct.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
