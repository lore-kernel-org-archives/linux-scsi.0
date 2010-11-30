From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 8/9] scsi: megaraid_sas - Driver take some workloads from
 FW
Date: Tue, 30 Nov 2010 16:57:38 +0100
Message-ID: <4CF51EF2.1010606@redhat.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A961E4@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A961F2@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A96213@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A96218@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A9621E@cosmail02.lsi.com>	 <4B6A08C587958942AA3002690DD4F8C30106A96223@cosmail02.lsi.com> <1290189181.23556.77.camel@mulgrave.site> <4B6A08C587958942AA3002690DD4F8C30106B1DEB9@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106B1DEB9@cosmail02.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>, "Prabhakaran, Rajesh" <Rajesh.Prabhakaran@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On 11/24/2010 04:22 PM, Yang, Bo wrote:
> James,
>
> Our megaraid sas driver only implemented the part of the XOR calculat=
ion and copy capability(moving data between 2 buffers) for the RAID5 cm=
ds which FW asks driver to do.  When fw received very heavy I/Os and th=
ere are high pending cmds in FW, fw will ask the help from driver to fi=
nish some cmds and reduce the fw heavy load.  Driver will only do part =
of the RAID5 (not take the jobs) from FW.  Driver is not duplicating Pa=
rity calculation done on dm/md.
>  =20
Do I understand it right - it means that the computation is done someti=
mes in the firmware and
sometimes in the driver depending on the load? I think it is not good h=
aving two complicated
computations on two different places. Wouldn't it better to compute it =
always in the driver?
Could we get a module option for choosing this computation - a)automati=
c, b)only in fw
c)only in driver?

Tomas


> Thanks,
>
> Bo Yang =20
>
>
>
> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]=20
> Sent: Friday, November 19, 2010 12:53 PM
> To: Yang, Bo
> Cc: 'linux-scsi@vger.kernel.org'; 'akpm@osdl.org'; 'linux-kernel@vger=
=2Ekernel.org'; Tomas Henzl
> Subject: Re: [PATCH 8/9] scsi: megaraid_sas - Driver take some worklo=
ads from FW
>
> On Fri, 2010-11-19 at 10:43 -0700, Yang, Bo wrote:
>  =20
>> Driver added the new feature to take some of the workloads from FW t=
o increase
>> performance of the iMR controller.  FW assigns the read cmds back to=
 driver
>> which will increase the performance for megaraid sas iMR controller.
>>    =20
> Just on a process note: you don't have to cc me at every known
> address ... I do read linux-scsi ...
>
> My first take on this patch is that you're basically passing data bac=
k
> to the kernel for RAID-N parity calculations.  This effectively makes
> your RAID one of those pseudo HW ones.  In which case, why not simply
> abandon the HW raid piece and have it all done by DM/MD, which are we=
ll
> optimised for all types of RAID?  The reason for asking is that we're
> trying to reduce the number of in-kernel raid implementations and thi=
s
> is going in the wrong direction.
>
> James
>
>
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD"=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=
=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=
z=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=
=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=
=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D
