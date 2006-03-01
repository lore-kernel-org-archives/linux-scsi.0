From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: SATA on mptsas performance
Date: Wed, 1 Mar 2006 09:04:17 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F2FC811@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:59871 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030219AbWCAQE2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 11:04:28 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>, Jeff Garzik <jgarzik@pobox.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Wednesday, March 01, 2006 1:16 AM, Mirko Benz wrote: 
> 
> As promised we have tested 3 Gb (aka SATA II) disks.
> Configuration: LSI SAS3442X controller, Promise SAS JBOD, 12 disks 
> Seagate SATA 80 GB
> 
> Tested with parallel dd invocations with bs=32k.
> The results look better:
> 
> # disks    Read    AVG    Write    AVG
> 1    69    69,0    68    68,0
> 6    420    70,0    324    54,0
> 7    459    65,6    367    52,4
> 8    426    53,3    394    49,3
> 9    399    44,3    389    43,2
> 10    410    41,0    431    43,1
> 11    438    39,8    428    38,9
> 12    468    39,0    481    40,1
> 
> Available bandwidth is 4 * 3 Gb = 1.5 GB (4 lanes / external wide SAS 
> port).
> So there is still some room for improvement. Has anyone else 
> a similar 
> setup and can provide results?
> Maybe with the Adaptec SAS controller?
> 

Sorry, I've not had a chance to replicate this.  Of late, I've been
overloaded.

I asked co-worker regarding this.  They told me they believe SATA
devices
when they open frame, they will complete entire data transaction during 
a single connection.  Meaning they don't do disconnect, and yield to
other 
devices as do SAS devices.  Thus could be the reason when you have 12
SATA devices,
the performance is low.   Jeff Garzik is this true?   However, when I
have a chance, 
I will verify this via bus analyzer, and do some testing.  I beleive I
can obtain
about 10 SATA disk.  

Eric
