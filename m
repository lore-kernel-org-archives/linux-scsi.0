From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
Subject: Re: [PATCH] scsi: be_iscsi: fix possible memory leak and refactor code
Date: Mon, 18 Nov 2013 14:18:46 -0200
Message-ID: <CAGG-pURDPHOGuSt7a1G=CpdgvyiUvW0ugKq0K_o7-ThCS39F-A@mail.gmail.com>
References: <1384714284-13712-1-git-send-email-geyslan@gmail.com>
	<1384717371.2050.2.camel@dabdike.int.hansenpartnership.com>
	<CAGG-pURSnEeNvmHhQ-GvrnyuMHPrTRMoCKt3P=bB23OD9Vmkpg@mail.gmail.com>
	<1384724339.2050.6.camel@dabdike.int.hansenpartnership.com>
	<CAGG-pUT_h1eNnHDpxRvMPWeN5zi6L2mckHMPsV92Qf3hqtf7EQ@mail.gmail.com>
	<1384786707.2001.6.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:39441 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3KRQSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2013 11:18:47 -0500
In-Reply-To: <1384786707.2001.6.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "open list:SERVER ENGINES 10..." <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

2013/11/18 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Sun, 2013-11-17 at 23:12 -0200, Geyslan Greg=F3rio Bem wrote:
>> 2013/11/17 James Bottomley <James.Bottomley@hansenpartnership.com>:
>> > On Sun, 2013-11-17 at 19:09 -0200, Geyslan Greg=F3rio Bem wrote:
>> >> 2013/11/17 James Bottomley <James.Bottomley@hansenpartnership.com=
>:
>> >> > On Sun, 2013-11-17 at 15:51 -0300, Geyslan G. Bem wrote:
>> >> >> This patch fix memory leakage in cases 'ISCSI_NET_PARAM_VLAN_I=
D' and
>> >> >> 'ISCSI_NET_PARAM_VLAN_PRIORITY' and refactors code 'going out'=
 when
>> >> >> necessary.
>> >> >
>> >> > You pointlessly renamed a variable, which makes the diff hard t=
o read.
>> >> > Please don't do that.
>> >>
>> >> Ok, I can agree. 'len' means length? What is returned in case of =
non
>> >> error?
>> >
>> > it returns the length of buf written to or negative error.
>> >
>> >> > You missed the fact that the passed in pointer is unmodified if
>> >> > mgmt_get_if_info() returns non zero, so the kfree frees junk an=
d would
>> >> > oops.
>> >> >
>> >> > There's no need for a goto; len =3D -EINVAL; does everything th=
at's
>> >> > needed.
>> >>
>> >> Well, that is a coverity catch. CID 1128954. Check it.
>> >
>> > I didn't say coverity was wrong, I said your patch was (well not w=
rong,
>> > just over complex and incomplete).  This is the way to fix both
>> > problems.
>> >
>> > James
>> >
>> > ---
>> >
>> > diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2is=
csi/be_iscsi.c
>> > index ffadbee..9dcbdfa 100644
>> > --- a/drivers/scsi/be2iscsi/be_iscsi.c
>> > +++ b/drivers/scsi/be2iscsi/be_iscsi.c
>> > @@ -541,10 +541,8 @@ static int be2iscsi_get_if_param(struct beisc=
si_hba *phba,
>> >                 ip_type =3D BE2_IPV6;
>>
>> James, this approach will not prevent the leakage.
>
> I don't see why not.  The -EINVAL case goes through the kfree() now t=
oo,
> no?

I'm refering to the removal of kfree in your suggestion.

>
>>  We can initialize the if_info with NULL and always kfree it without
>> to care about junk.
>
> Why?  Error return means no allocation.
Setting if_info to NULL allow to kfree without concerns.

Eg.:

- struct be_cmd_get_if_info_resp *if_info;
+ struct be_cmd_get_if_info_resp *if_info =3D NULL;

=2E..

+       if (len)
+               goto out;

=2E..

-               if (if_info->vlan_priority =3D=3D BEISCSI_VLAN_DISABLE)
-                       return -EINVAL;
+               if (if_info->vlan_priority =3D=3D BEISCSI_VLAN_DISABLE)=
 {
+                       len =3D -EINVAL;
+                       goto out;
+               }

=2E..

        case ISCSI_NET_PARAM_VLAN_PRIORITY:
-               if (if_info->vlan_priority =3D=3D BEISCSI_VLAN_DISABLE)
-                       return -EINVAL;
+               if (if_info->vlan_priority =3D=3D BEISCSI_VLAN_DISABLE)=
 {
+                       len =3D -EINVAL;
+                       goto out;
+               }


+out:
        kfree(if_info);
        return len;


Thus, if if_info remains NULL (was not allocated after
mgmt_get_if_info call) kfree returns without oops. And we can
centralize the freeing in the out regarding chapter 7 of coding style
(http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/CodingStyle#n386).

What do you think?

>
> James
>
>



--=20
Regards,

Geyslan G. Bem
hackingbits.com
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
