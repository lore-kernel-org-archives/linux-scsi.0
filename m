From: "Pravin Bathija" <pbathija@amcc.com>
Subject: RE: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit
	resources.
Date: Thu, 5 Nov 2009 21:49:41 -0800
Message-ID: <9D1E2BDCB5C57B46B56E6D80843439EB09350F76@SDCEXCHANGE01.ad.amcc.com>
References: <1253053555-25097-1-git-send-email-pbathija@amcc.com><20091105134330.GA30489@zod.rchland.ibm.com><1257437226.2753.64.camel@mulgrave.site>
	<1257451218.13611.114.camel@pasglop>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2630111549212023024=="
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, James Bottomley <James.Bottomley@suse.de>
Cc: Eric.Moore@lsi.com, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

--===============2630111549212023024==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CA5EA5.2A4CB319"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CA5EA5.2A4CB319
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

-----Original Message-----
From: Benjamin Herrenschmidt [mailto:benh@kernel.crashing.org]
Sent: Thu 11/5/2009 12:00 PM
To: James Bottomley
Cc: Josh Boyer; Eric.Moore@lsi.com; Pravin Bathija; =
linux-scsi@vger.kernel.org; linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit =
resources.
=20
On Thu, 2009-11-05 at 10:07 -0600, James Bottomley wrote:

> > > 	ioc->memmap =3D mem;
> > >-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem =3D %p, mem_phys =
=3D %lx\n",
> > >-	    ioc->name, mem, mem_phys));
> > >+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem =3D %p, mem_phys =
=3D %llx\n",
> > >+	    ioc->name, mem, (u64)mem_phys));
> > >
> > > 	ioc->mem_phys =3D mem_phys;
> > > 	ioc->chip =3D (SYSIF_REGS __iomem *)mem;
> > >
> > > 	/* Save Port IO values in case we need to do downloadboot */
> > >-	ioc->pio_mem_phys =3D port;
> > >+	port =3D ioremap(port_phys, psize);
> > >+	if (port =3D=3D NULL) {
> > >+		printk(MYIOC_s_ERR_FMT " : ERROR - Unable to map adapter"
> > >+			" port !\n", ioc->name);
> > >+		return -EINVAL;
>=20
> So this looks problematic on a few platforms ... what happens to
> platforms that have no IO space?  They automatically fail here and it
> looks like the adapter never attaches.

> Yup, that part of the patch looks wrong.

> However, a mechanical replacement of unsigned long's with
> resource_size_t to hold physical addresses should be fine despite the
> lack of feedback from LSI.

> Pravin, that ioremap definitely seems like it has nothing to do there,
> port IO is already remapped for you by the core PCI code and should =
work
> "as is". Please respin without that change.

> Cheers,
>Ben.

Thanks for the input. Will make the suggested changes and re-submit the =
patch.

Regards,
Pravin




------_=_NextPart_001_01CA5EA5.2A4CB319
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7653.38">
<TITLE>RE: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit =
resources.</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>-----Original Message-----<BR>
From: Benjamin Herrenschmidt [<A =
HREF=3D"mailto:benh@kernel.crashing.org">mailto:benh@kernel.crashing.org<=
/A>]<BR>
Sent: Thu 11/5/2009 12:00 PM<BR>
To: James Bottomley<BR>
Cc: Josh Boyer; Eric.Moore@lsi.com; Pravin Bathija; =
linux-scsi@vger.kernel.org; linuxppc-dev@ozlabs.org<BR>
Subject: Re: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit =
resources.<BR>
<BR>
On Thu, 2009-11-05 at 10:07 -0600, James Bottomley wrote:<BR>
<BR>
&gt; &gt; &gt; &nbsp; ioc-&gt;memmap =3D mem;<BR>
&gt; &gt; &gt;-&nbsp; dinitprintk(ioc, printk(MYIOC_s_INFO_FMT &quot;mem =
=3D %p, mem_phys =3D %lx\n&quot;,<BR>
&gt; &gt; &gt;-&nbsp; &nbsp;&nbsp;&nbsp; ioc-&gt;name, mem, =
mem_phys));<BR>
&gt; &gt; &gt;+&nbsp; dinitprintk(ioc, printk(MYIOC_s_INFO_FMT &quot;mem =
=3D %p, mem_phys =3D %llx\n&quot;,<BR>
&gt; &gt; &gt;+&nbsp; &nbsp;&nbsp;&nbsp; ioc-&gt;name, mem, =
(u64)mem_phys));<BR>
&gt; &gt; &gt;<BR>
&gt; &gt; &gt; &nbsp; ioc-&gt;mem_phys =3D mem_phys;<BR>
&gt; &gt; &gt; &nbsp; ioc-&gt;chip =3D (SYSIF_REGS __iomem *)mem;<BR>
&gt; &gt; &gt;<BR>
&gt; &gt; &gt; &nbsp; /* Save Port IO values in case we need to do =
downloadboot */<BR>
&gt; &gt; &gt;-&nbsp; ioc-&gt;pio_mem_phys =3D port;<BR>
&gt; &gt; &gt;+&nbsp; port =3D ioremap(port_phys, psize);<BR>
&gt; &gt; &gt;+&nbsp; if (port =3D=3D NULL) {<BR>
&gt; &gt; &gt;+&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
printk(MYIOC_s_ERR_FMT &quot; : ERROR - Unable to map adapter&quot;<BR>
&gt; &gt; &gt;+&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot; port !\n&quot;, =
ioc-&gt;name);<BR>
&gt; &gt; &gt;+&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return =
-EINVAL;<BR>
&gt;<BR>
&gt; So this looks problematic on a few platforms ... what happens =
to<BR>
&gt; platforms that have no IO space?&nbsp; They automatically fail here =
and it<BR>
&gt; looks like the adapter never attaches.<BR>
<BR>
&gt; Yup, that part of the patch looks wrong.<BR>
<BR>
&gt; However, a mechanical replacement of unsigned long's with<BR>
&gt; resource_size_t to hold physical addresses should be fine despite =
the<BR>
&gt; lack of feedback from LSI.<BR>
<BR>
&gt; Pravin, that ioremap definitely seems like it has nothing to do =
there,<BR>
&gt; port IO is already remapped for you by the core PCI code and should =
work<BR>
&gt; &quot;as is&quot;. Please respin without that change.<BR>
<BR>
&gt; Cheers,<BR>
&gt;Ben.<BR>
<BR>
Thanks for the input. Will make the suggested changes and re-submit the =
patch.<BR>
<BR>
Regards,<BR>
Pravin<BR>
<BR>
<BR>
<BR>
</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01CA5EA5.2A4CB319--

--===============2630111549212023024==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@lists.ozlabs.org
https://lists.ozlabs.org/listinfo/linuxppc-dev
--===============2630111549212023024==--
