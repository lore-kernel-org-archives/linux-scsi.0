From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Wed, 25 Jul 2007 18:21:38 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D708B399D@NAMAIL4.ad.lsil.com>
References: <20070725094740H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:32800 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbXGZAWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2007 20:22:19 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070725094740H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

On  Tuesday, July 24, 2007 6:48 PM, FUJITA Tomonori wrote:
> > I hadn't enabled bsg support in the linux kernel, that was 
> my problem.
> 
> What do you mean? You might hit the bug that you can't build scsi as a
> modular. It was fixed before rc1.
> 

The issue is I'm new to BSG, and I didn't know I needed to enable
CONFIG_BLK_DEV_BSG in the kernel config.   I upgraded today to rc1, and
your correct, I don't have to link the scsi mod into kernel.   Don't
worry about this point, I'm squared away now.

> 
> > > # ./sgv4-tools/smp_rep_manufacturer /sys/class/bsg/expander-0:1
> > > 
> > > 
> > > I think that James tested this with aic94xx, however, I guess that
> > > nobody has tested this with mptsas.
> > > 
> > 
> > I got garbage (I'm using the 2.6.23-git11 patch from last 
> week, before
> > rc1):
> > 
> > # ./smp_rep_manufacturer /sys/class/bsg/expander-2:0
> >   SAS-1.1 format: 1
> >   vendor identification: _BUS_ADD
> >   product identification: RESS=unix:abstra
> >   product revision level: ct=/
> >   component vendor identification: tmp/dbus
> >   component id: 11609
> >   component revision level: 69
> > 
> > With Doug Gilberts tools it works:
> > 
> > # smp_rep_manufacturer --sa=0x500605b0000016b0 /dev/mptctl
> > Report manufacturer response:
> >   SAS-1.1 format: 0
> >   vendor identification: LSILOGIC
> >   product identification: SASx12 A.0
> >   product revision level:
> > 
> > 
> > Also, unloading and reloading the driver resulted in two expander
> > entryies in /sys/class/bsg.    The old entry was not deleted when I
> > unloaded the driver.  When I tryied to run 
> smp_rep_manufacture on the
> > old expander instance, it panicked.

With a sas analyzer, I figured out today why the bsg version of
smp_rep_manufacture is not working.    There is a bug in
mptsas_smp_handler. The calculation of the first scatter gather element
size for the outbound data is incorrect.   Its being set to the resonse
data length, when instead it should be the request data legth.

This is incorrect:

+	flagsLength |= (rsp->data_len - 4);

It should be 

+	flagsLength |= (smpreq->RequestDataLength);


> 
> I forgot to remove bsg entries. James fixed the bug. Please try
> 2.6.23-rc1.

thanks, I noticed its fixed in rc1


> 
> But probably, the tool still don't work against an expander. Does it
> work against the Virtual SMP Port?
> 

I tried out this by passing /sys/class/bsg/sas_host0, and I saw it
return Virtual SMP.  I guess this can be left in.


> Oh, I thought that LSI wants to send the smp_reply back to user space
> since Doug's smp-utils does. But If you don't want, I'll just put the
> response check code that you suggested in the previous mail.
> 

On second thought, It would be nice to have iocstatus, iocloginfo, and
sasstatus available in user space, that way the appliacation will have a
better understanding of what error occurred.   Without that info, how
will you it know if the response data you receive is valid data?   For
instance, before I identified the bug in the sgel size, you were
displaying garbage.   The driver could have prevented that by returning
-ENXIO I guess, instead how about pushing up that info to user space.
what do you think?    maybe there should be some translation to common
error returns code between the varous sas vendors supporting this
portal.

Eric
