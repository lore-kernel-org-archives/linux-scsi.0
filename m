From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
Subject: Re: [PATCH] scsi: be_iscsi: fix possible memory leak and refactor code
Date: Mon, 18 Nov 2013 17:51:44 -0200
Message-ID: <CAGG-pUT4x0OwwMi0SCryHV5sx4WMhxdVQjTb9=a3Tf+fqczHUQ@mail.gmail.com>
References: <1384714284-13712-1-git-send-email-geyslan@gmail.com>
	<1384717371.2050.2.camel@dabdike.int.hansenpartnership.com>
	<CAGG-pURSnEeNvmHhQ-GvrnyuMHPrTRMoCKt3P=bB23OD9Vmkpg@mail.gmail.com>
	<1384724339.2050.6.camel@dabdike.int.hansenpartnership.com>
	<CAGG-pUT_h1eNnHDpxRvMPWeN5zi6L2mckHMPsV92Qf3hqtf7EQ@mail.gmail.com>
	<1384786707.2001.6.camel@dabdike.int.hansenpartnership.com>
	<CAGG-pURDPHOGuSt7a1G=CpdgvyiUvW0ugKq0K_o7-ThCS39F-A@mail.gmail.com>
	<1384791864.2001.19.camel@dabdike.int.hansenpartnership.com>
	<CAGG-pUSOa-kP7-NfyX6gizSrASc8_hAjN=Knn3cmfO2CK=txZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGG-pUSOa-kP7-NfyX6gizSrASc8_hAjN=Knn3cmfO2CK=txZw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "open list:SERVER ENGINES 10..." <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2013/11/18 Geyslan Greg=F3rio Bem <geyslan@gmail.com>:
> 2013/11/18 James Bottomley <James.Bottomley@hansenpartnership.com>:
>> On Mon, 2013-11-18 at 14:18 -0200, Geyslan Greg=F3rio Bem wrote:
>>> 2013/11/18 James Bottomley <James.Bottomley@hansenpartnership.com>:
>>> > On Sun, 2013-11-17 at 23:12 -0200, Geyslan Greg=F3rio Bem wrote:
>>> >> 2013/11/17 James Bottomley <James.Bottomley@hansenpartnership.co=
m>:
>>> >> > On Sun, 2013-11-17 at 19:09 -0200, Geyslan Greg=F3rio Bem wrot=
e:
>>> >> >> 2013/11/17 James Bottomley <James.Bottomley@hansenpartnership=
=2Ecom>:
>>> >> >> > On Sun, 2013-11-17 at 15:51 -0300, Geyslan G. Bem wrote:
>>> >> >> >> This patch fix memory leakage in cases 'ISCSI_NET_PARAM_VL=
AN_ID' and
>>> >> >> >> 'ISCSI_NET_PARAM_VLAN_PRIORITY' and refactors code 'going =
out' when
>>> >> >> >> necessary.
>>> >> >> >
>>> >> >> > You pointlessly renamed a variable, which makes the diff ha=
rd to read.
>>> >> >> > Please don't do that.
>>> >> >>
>>> >> >> Ok, I can agree. 'len' means length? What is returned in case=
 of non
>>> >> >> error?
>>> >> >
>>> >> > it returns the length of buf written to or negative error.
>>> >> >
>>> >> >> > You missed the fact that the passed in pointer is unmodifie=
d if
>>> >> >> > mgmt_get_if_info() returns non zero, so the kfree frees jun=
k and would
>>> >> >> > oops.
>>> >> >> >
>>> >> >> > There's no need for a goto; len =3D -EINVAL; does everythin=
g that's
>>> >> >> > needed.
>>> >> >>
>>> >> >> Well, that is a coverity catch. CID 1128954. Check it.
>>> >> >
>>> >> > I didn't say coverity was wrong, I said your patch was (well n=
ot wrong,
>>> >> > just over complex and incomplete).  This is the way to fix bot=
h
>>> >> > problems.
>>> >> >
>>> >> > James
>>> >> >
>>> >> > ---
>>> >> >
>>> >> > diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/b=
e2iscsi/be_iscsi.c
>>> >> > index ffadbee..9dcbdfa 100644
>>> >> > --- a/drivers/scsi/be2iscsi/be_iscsi.c
>>> >> > +++ b/drivers/scsi/be2iscsi/be_iscsi.c
>>> >> > @@ -541,10 +541,8 @@ static int be2iscsi_get_if_param(struct b=
eiscsi_hba *phba,
>>> >> >                 ip_type =3D BE2_IPV6;
>>> >>
>>> >> James, this approach will not prevent the leakage.
>>> >
>>> > I don't see why not.  The -EINVAL case goes through the kfree() n=
ow too,
>>> > no?
>>>
>>> I'm refering to the removal of kfree in your suggestion.
>>
>> That's the second bug I pointed out via code inspection.  If the
>> function returns an error (any non zero return) then the pointer isn=
't
>> altered, so we return without the free.  It's a standard error patte=
rn.
>
> Ok. So kfree is useless until the code go to the function bail. Right=
?
>
>>
>>> >
>>> >>  We can initialize the if_info with NULL and always kfree it wit=
hout
>>> >> to care about junk.
>>> >
>>> > Why?  Error return means no allocation.
>>> Setting if_info to NULL allow to kfree without concerns.
>>>
>>> Eg.:
>>>
>>> - struct be_cmd_get_if_info_resp *if_info;
>>> + struct be_cmd_get_if_info_resp *if_info =3D NULL;
>>>
>>> ...
>>>
>>> +       if (len)
>>> +               goto out;
>>>
>>> ...
>>>
>>> -               if (if_info->vlan_priority =3D=3D BEISCSI_VLAN_DISA=
BLE)
>>> -                       return -EINVAL;
>>> +               if (if_info->vlan_priority =3D=3D BEISCSI_VLAN_DISA=
BLE) {
>>> +                       len =3D -EINVAL;
>>> +                       goto out;
>>> +               }
>>
>> What's the point of that?  Just removing the goto out; has the code
>> going to the same place because of the break below.
>>
>> James
>>
>>
>
> I agree whit you that the code goes to same place with or without got=
o
> out. It's just a pattern to simplify future changes in the function.
>
> But I can remove it if you want.
>
>
> --
> Regards,
>
> Geyslan G. Bem
> hackingbits.com

Done:
[PATCH v2] scsi: be_iscsi: fix possible memory leak


--=20
Regards,

Geyslan G. Bem
hackingbits.com
