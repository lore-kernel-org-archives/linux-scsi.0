From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: RE: Announcing ServeRAID driver ( ips ) Version 7.10.18
Date: Wed, 25 Aug 2004 08:03:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A121ABA5B472B74EB59076B8E3C8F01969AD4C@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:55511 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266925AbUHYMDj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 08:03:39 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, coughlan@redhat.com, dledford@redhat.com, bjohnson@redhat.com, bhlim@vmware.com, rofarrell@vmware.com, mantel@suse.de, kerneldriver@suse.de, go@turbolinux.co.jp, rogerv@sco.com, schwab@suse.de, axboe@suse.de, michael@turbolinux.com, vcat@caldera.com, sdenham@redhat.com, "Jeffery, David" <David_Jeffery@adaptec.com>, "Pasteur, Bob" <bob_pasteur@adaptec.com>, "Wendy Hung (E-mail)" <wendyh@us.ibm.com>, "Leah Cunningham (E-mail)" <leahc@us.ibm.com>, "Brad Thomas (E-mail)" <bwthomas@us.ibm.com>, "Felica Turner (E-mail)" <faturner@us.ibm.com>, "Marie Jazynka (E-mail)" <mjazynka@us.ibm.com>, Chris McDermott <lcm@us.ibm.com>, "Williams, Bill" <Bill_Williams@adaptec.com>, torvalds@transmeta.com, marcelo.tosatti@cyclades.com

Arjan,

This patch is for 2.6, but this driver is intended for both 2.6 and 2.4.
Having only one driver greatly simplifies maintenance and reduces
testing efforts.  The 2.4 patch will be sent out later - after I have
resolved any issues.  I just want to get the initial input from the
Linux community reviewers before I sent out the 2.4 patch - that way I
don't have to do it twice if there's any problems. 

The "hosts.h" is necessary.  The RHEL 2.1 kernels, among others, need
this and we have customers using this release. Our customers require us
to be able to update the driver without forcing them to update their
entire production kernel, so we must always maintain backwards
compatibility.

You're right about MODULE_DESCRIPTION. The #ifdef around it can be
removed - but for now, I believe it's harmless.  Feel free to delete
that or I will issue an update patch for it later.

Thanks for your input.

Jack

 

-----Original Message-----
From: Arjan van de Ven [mailto:arjanv@redhat.com] 
Sent: Tuesday, August 24, 2004 5:37 PM
To: Hammer, Jack
Cc: James.Bottomley@SteelEye.com; linux-scsi@vger.kernel.org;
coughlan@redhat.com; dledford@redhat.com; bjohnson@redhat.com;
bhlim@vmware.com; rofarrell@vmware.com; mantel@suse.de;
kerneldriver@suse.de; go@turbolinux.co.jp; rogerv@sco.com;
schwab@suse.de; axboe@suse.de; michael@turbolinux.com; vcat@caldera.com;
sdenham@redhat.com; Jeffery, David; Pasteur, Bob; Wendy Hung (E-mail);
Leah Cunningham (E-mail); Brad Thomas (E-mail); Felica Turner (E-mail);
Marie Jazynka (E-mail); Chris McDermott; Williams, Bill;
torvalds@transmeta.com; marcelo@cyclades.com
Subject: Re: Announcing ServeRAID driver ( ips ) Version 7.10.18

On Tue, 2004-08-24 at 16:22, Hammer, Jack wrote:
> +
> +#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0) #include "hosts.h"
> +#else
>  #include <scsi/scsi_host.h>
> +#endif

I thought you said this was the 2.6 driver...
oh and 2.4 kernels also have <scsi/scsi_host.h> so no need for adding
this ifdef.

>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
>   .use_new_eh_code = 1,
>  #endif
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20)  &&
> LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
> +    .highmem_io          = 1,   
> +#endif

again.... this is the 2.6 driver, right?
> +
> +#ifdef MODULE_DESCRIPTION
> +MODULE_DESCRIPTION("IBM ServeRAID Adapter Driver " IPS_VER_STRING); 
> +#endif

all kernels have MODULE_DESCRIPTION so why the ifdef ?


