From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [Patch]: Enable SCSI Wait Scan only if BLK_DEV_INITRD is set.
Date: Tue, 23 Feb 2010 12:52:13 -0800
Message-ID: <4B843FFD.6080005@cisco.com>
References: <4B830AEB.3010905@googlemail.com> <4B83FD7E.1070601@s5r6.in-berlin.de> <4B8424FC.5060203@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:21430 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0BWVBp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 16:01:45 -0500
In-Reply-To: <4B8424FC.5060203@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi <linux-scsi@vger.kernel.org>

Ren=C3=A9 Bolldorf wrote:
> On 02/23/2010 05:08 PM, Stefan Richter wrote:
>> Ren=C3=A9 Bolldorf wrote:
>>
>> (I'm not sure whether the maintainers are going to accept that chang=
e
>> this time around, but anyway:)
>>
>>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>>> index 9191d1e..b785703 100644
>>> --- a/drivers/scsi/Kconfig
>>> +++ b/drivers/scsi/Kconfig
>>> @@ -258,21 +258,22 @@ config SCSI_SCAN_ASYNC
>>>          or async on the kernel's command line.
>>>
>>>    config SCSI_WAIT_SCAN
>>> -    tristate  # No prompt here, this is an invisible symbol.
>>> +    tristate "SCSI Wait Scan"
>>>        default m
>>>        depends on SCSI
>>> +    depends on SCSI_SCAN_ASYNC
>>>        depends on MODULES
>> [...]
>>> +    depends on BLK_DEV_INITRD
>>
>> There needs to be an additional "depends on m" now that you made it
>> visible, so that it cannot be set to y.
>>
>>> +    help
>>> +      scsi_wait_scan is a loadable module which waits until all th=
e=20
>>> async scans are
>>> +      complete.  The idea is to use it in initrd/ initramfs=20
>>> scripts.  You modprobe
>>> +      it after all the modprobes of the root SCSI drivers and it=20
>>> will wait until
>>> +      they have all finished scanning their buses before allowing=20
>>> the boot to
>>> +      proceed.
>> [...]
>>> +      People that use a initramfs should say Y or M.
>>
>> They "...should say M." actually.
>=20
> Ok, updated. thx
> I hope someone pick it up, because it's damn that the module will be=20
> built even with no initramfs support.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 9191d1e..1cb07da 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -258,21 +258,23 @@ config SCSI_SCAN_ASYNC
>        or async on the kernel's command line.
>=20
>  config SCSI_WAIT_SCAN
> -    tristate  # No prompt here, this is an invisible symbol.
> +    tristate "SCSI Wait Scan"
>      default m
> +    depends on m

Seems wrong to me (not a Kconfig expert).  Is there a CONFIG_m symbol?
It already has 'depends on MODULES'.

>      depends on SCSI
> +    depends on SCSI_SCAN_ASYNC
>      depends on MODULES
> -# scsi_wait_scan is a loadable module which waits until all the asyn=
c=20
> scans are
> -# complete.  The idea is to use it in initrd/ initramfs scripts.  Yo=
u=20
> modprobe
> -# it after all the modprobes of the root SCSI drivers and it will wa=
it=20
> until
> -# they have all finished scanning their buses before allowing the bo=
ot to
> -# proceed.  (This method is not applicable if targets boot=20
> independently in
> -# parallel with the initiator, or with transports with=20
> non-deterministic target
> -# discovery schemes, or if a transport driver does not support=20
> scsi_wait_scan.)
> -#
> -# This symbol is not exposed as a prompt because little is to be gai=
ned by
> -# disabling it, whereas people who accidentally switch it off may=20
> wonder why
> -# their mkinitrd gets into trouble.
> +    depends on BLK_DEV_INITRD
> +    help
> +      scsi_wait_scan is a loadable module which waits until all the=20
> async scans are
> +      complete.  The idea is to use it in initrd/ initramfs scripts.=
 =20
> You modprobe
> +      it after all the modprobes of the root SCSI drivers and it wil=
l=20
> wait until
> +      they have all finished scanning their buses before allowing th=
e=20
> boot to
> +      proceed.  (This method is not applicable if targets boot=20
> independently in
> +      parallel with the initiator, or with transports with=20
> non-deterministic target
> +      discovery schemes, or if a transport driver does not support=20
> scsi_wait_scan.)
> +
> +      People that use a initramfs should say M here.
>=20
>  menu "SCSI Transports"
>      depends on SCSI
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
