From: Thomas Steudten <alpha@steudten.com>
Subject: BUG: Kernel Panic: kernel-2.6.1 for alpha in scsi context ll_rw_blk.c
Date: Sat, 10 Jan 2004 17:59:21 +0100
Sender: linux-alpha-owner@vger.kernel.org
Message-ID: <40002F69.9020302@steudten.com>
References: <3FB92938.8040906@steudten.com> <87r806d6n6.fsf@student.uni-tuebingen.de> <3FB93EF6.807@steudten.com> <87islid5tq.fsf@student.uni-tuebingen.de> <20031118021922.A7816@den.park.msu.ru> <3FBA8F20.3050701@steudten.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-alpha-owner@vger.kernel.org>
In-Reply-To: <3FBA8F20.3050701@steudten.com>
To: Thomas Steudten <alpha@steudten.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Falk Hueffner <falk.hueffner@student.uni-tuebingen.de>, Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-alpha@vger.kernel.org, akpm@osdl.org
List-Id: linux-scsi@vger.kernel.org

Hello

I test the new 2.6.1 kernel and run in the same problem as before.
The reason is, that the patch from Ivan isn=B4t there in the kernel
source tree.

Please add the patch to the mainline.

Tom

Thomas Steudten wrote:

> Hi
>=20
> With the patch from Ivan, the prefetch problem is gone.
> Please add this patch to the mainline for 2.6.0 for alpha.
>=20
> Regards
> Tom
>=20
>> We shouldn't prefetch the spinlocks on UP.
>>
>> Ivan.
>>
>> --- 2.6/include/asm-alpha/processor.h    Sat Oct 25 22:44:54 2003
>> +++ linux/include/asm-alpha/processor.h    Tue Nov 18 01:48:39 2003
>> @@ -78,6 +78,11 @@ unsigned long get_wchan(struct task_stru
>>  #define ARCH_HAS_PREFETCHW
>>  #define ARCH_HAS_SPINLOCK_PREFETCH
>> =20
>> +#ifndef CONFIG_SMP
>> +/* Nothing to prefetch. */
>> +#define spin_lock_prefetch(lock)      do { } while (0)
>> +#endif
>> +
>>  #if __GNUC__ > 3 || (__GNUC__ =3D=3D 3 && __GNUC_MINOR__ >=3D 1)
>>  extern inline void prefetch(const void *ptr)   { @@ -89,10 +94,13 @=
@=20
>> extern inline void prefetchw(const void      __builtin_prefetch(ptr,=
=20
>> 1, 3);
>>  }
>> =20
>> +#ifdef CONFIG_SMP
>>  extern inline void spin_lock_prefetch(const void *ptr)   {
>>      __builtin_prefetch(ptr, 1, 3);
>>  }
>> +#endif
>> +
>>  #else
>>  extern inline void prefetch(const void *ptr)   { @@ -104,10 +112,13=
=20
>> @@ extern inline void prefetchw(const void      __asm__ ("ldq $31,%0=
"=20
>> : : "m"(*(char *)ptr));  }
>> =20
>> +#ifdef CONFIG_SMP
>>  extern inline void spin_lock_prefetch(const void *ptr)   {
>>      __asm__ ("ldq $31,%0" : : "m"(*(char *)ptr));  }
>> +#endif
>> +
>>  #endif /* GCC 3.1 */
>> =20
>>  #endif /* __ASM_ALPHA_PROCESSOR_H */
>=20
>=20

--=20
Tom

LINUX user since kernel 0.99.x 1994.
RPM Alpha packages at http://alpha.steudten.com/packages
Want to know what S.u.S.E 1995 cdrom-set contains?


-
To unsubscribe from this list: send the line "unsubscribe linux-alpha" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
