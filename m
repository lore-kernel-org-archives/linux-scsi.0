From: Joe Jin <joe.jin@oracle.com>
Subject: =?UTF-8?B?562U5aSNOiBSRTogYmZhIGRyaXZlciBvbiB4ZW4=?=
Date: Fri, 30 Apr 2010 17:40:45 -0700 (PDT)
Message-ID: <be817d0d-1139-4f0f-86e6-0dd709e38f40@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:40193 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab0EAAlE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 20:41:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: huangj@Brocade.COM
Cc: linux-scsi@vger.kernel.org, soeren.binner@oracle.com, haobo.zhou@oracle.com

Jing, thanks for you suggestion.

----- =E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6 -----
=E5=8F=91=E4=BB=B6=E4=BA=BA: huangj@Brocade.COM
=E6=94=B6=E4=BB=B6=E4=BA=BA: joe.jin@oracle.com, linux-scsi@vger.kernel=
=2Eorg
=E6=8A=84=E9=80=81: soeren.binner@oracle.com, haobo.zhou@oracle.com
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2010=E5=B9=B4 5 =E6=9C=88 01=E6=97=
=A5 =E6=98=9F=E6=9C=9F=E5=85=AD  =E4=B8=8A=E5=8D=88 5:13:36 GMT +08:00 =
=E5=8C=97=E4=BA=AC/=E9=87=8D=E5=BA=86/=E9=A6=99=E6=B8=AF/=E4=B9=8C=E9=B2=
=81=E6=9C=A8=E9=BD=90
=E4=B8=BB=E9=A2=98: RE: bfa driver on xen

Hi Joe,

Thanks for reporting the issue. We have noticed this during the netapp/=
oracal ovm test to include bfa driver as part of ovm distro. As a worka=
round, we suggested to set num_sgpg=3D512 and num_ios=3D512.=20

We are working on a fix and it will be available in our 2.3 driver.

Regards,

Jing

>-----Original Message-----
>From: Joe Jin [mailto:joe.jin@oracle.com]
>Sent: Friday, April 30, 2010 2:34 AM
>To: Jing Huang; linux-scsi@vger.kernel.org
>Cc: soeren.binner@oracle.com; haobo.zhou@oracle.com; joe.jin@oracle.co=
m
>Subject: bfa driver on xen
>
>Hi Jing Huang,
>
>I'm Joe Jin from Oracle Linux team, recently we tried brocade device
>on HP DL385 with OracleVM and  found the device could not worked for
>driver could not applied enough memory with below error message:
>
>bfad[0]: memory allocation failed with num_sgpgs: 2048
>bfad[0]: trying to allocate memory with num_sgpgs: 1024
>bfad[0]: memory allocation failed with num_sgpgs: 1024
>bfad[0]: trying to allocate memory with num_sgpgs: 512
>bfad0 bfad_hal_mem_alloc failure
>Not enough memory to attach all Brocade HBA ports, System may need mor=
e
>
>I have did some investigated, here are some information:
>OracleVM xen it 64bit and Dom0 is 32bit, the root cause is when 32bit =
Dom0
>running on 64bit hypervisor(xen), it on compat mode and xen just allow=
ed
>to allocate 1M(order =3D 8) contiguous memory, if not of compat mode,
>Dom0 would successed applied 2M(order=3D9) contiguous memory.
>
>To let it the device works, we have to decrease driver config params
>like num_sgpgs, reqq_size, rspq_size and so on, I'm not sure if
>there are some releations among them, also did not known what values
>is good enough for performance, woule you like give me some advices
>for those? we have to reduce bfa driver DMA memory no more than 1M.
>
>Thanks,
>Joe
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
