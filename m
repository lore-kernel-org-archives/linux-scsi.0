From: Muthu Kumar <muthu.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Bug 43359] LVM volumes not detected
Date: Tue, 12 Jun 2012 18:22:13 -0700
Message-ID: <CAFR8ueejs0B6GP=uHHZBynK-0mFScQUj_Cp8gSEEeCpyoD0PmQ@mail.gmail.com>
References: <bug-43359-11613@https.bugzilla.kernel.org/>
	<20120610061206.E0E081205DA@bugzilla.kernel.org>
	<CAFR8uefjqTqbg545BExg1F_QR7cwyzOgF1x0WA61iH11bbMo5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFR8uefjqTqbg545BExg1F_QR7cwyzOgF1x0WA61iH11bbMo5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, francois.valenduc-bmtTS95sd5BUM80lpFwj4w@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Thanks to Harald and Bryn, I narrowed it to local changes in my system.

On Mon, Jun 11, 2012 at 9:56 PM, Muthu Kumar <muthu.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> I am using CentOS 6.x and I hit this bug with 3.5-rc2. I tried to loo=
k
> in to the boot process and found that the initramfs generated from
> 3.5.-rc2 is not good for lvm root. It was missing /lib/modules/<uname
> -r>/kernel/drivers/md/*". Also /sbin/ doesn't have lvm_scan and was
> missing a bunch of other files too.
>
> CCing initramfs folks. Any help?
>
>
>
> On Sat, Jun 9, 2012 at 11:12 PM, =A0<bugzilla-daemon-590EEB7GvNiWaY/ihj7yzA@public.gmane.org=
org> wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D43359
>>
>>
>>
>>
>>
>> --- Comment #1 from Fran=E7ois Valenduc <francois.valenduc@tvcablene=
t.be> =A02012-06-10 06:12:06 ---
>> This problem seems impossible to bisect. The first run (794c10fa0fa4=
d) was the
>> result of the bisection limited to drivers and fs directories. A sec=
ond run
>> where I also added the block directory lead to a commit related to w=
atchdog,
>> which is impossible since I don't use watchdog on my computer.
>> A 3rd run on the whole kernel tree leads to this commit:
>>
>> From 4523e1458566a0e8ecfaff90f380dd23acc44d27 Mon Sep 17 00:00:00 20=
01
>> From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> Date: Wed, 30 May 2012 07:51:07 -0700
>> Subject: [PATCH] mm: fix vma_resv_map() NULL pointer
>>
>> hugetlb_reserve_pages() can be used for either normal file-backed
>> hugetlbfs mappings, or MAP_HUGETLB. =A0In the MAP_HUGETLB, semi-anon=
ymous
>> mode, there is not a VMA around. =A0The new call to resv_map_put() a=
ssumed
>> that there was, and resulted in a NULL pointer dereference:
>>
>> This is also strange because I don't use hugetlb. I can revert this =
commit but
>> it doesn't change anything. Does anybody have an idea on what I coul=
d do to
>> further investigate this problem.
>>
>> --
>> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3De=
mail
>> ------- You are receiving this mail because: -------
>> You are the assignee for the bug.--
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
