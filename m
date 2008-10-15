From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Wed, 15 Oct 2008 16:40:16 -0600
Message-ID: <660360F4F2570145BD872F298951B17A5CA5E5C0@cosmail03.lsi.com>
References: <20081015064303.GA17391@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:44830 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbYJOWka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Oct 2008 18:40:30 -0400
In-Reply-To: <20081015064303.GA17391@akamai.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijit Paithankar <apaithan@akamai.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This is exactly what  I'm doing in my sas2.0 driver.

Eric

On Wednesday, October 15, 2008 12:43 AM, Abhijit Paithankar wrote:
>
> Does this look like it could be useful upstream?
>
> Abhijit
>
> > Signed-off-by: Abhijit Paithankar <apaithan@akamai.com>
> >
> > Index: linux-2.6.27/drivers/message/fusion/mptsas.c
> > ===================================================================
> > --- linux-2.6.27.orig/drivers/message/fusion/mptsas.c
> 2008-10-13 17:31:57.000000000 -0700
> > +++ linux-2.6.27/drivers/message/fusion/mptsas.c
> 2008-10-14 11:36:36.000000000 -0700
> > @@ -839,11 +839,15 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *io
> >  static int
> >  mptsas_slave_configure(struct scsi_device *sdev)
> >  {
> > +     struct sas_rphy *rphy;
> >
> >       if (sdev->channel == MPTSAS_RAID_CHANNEL)
> >               goto out;
> >
> > -     sas_read_port_mode_page(sdev);
> > +     rphy = dev_to_rphy(sdev->sdev_target->dev.parent);
> > +     if (rphy->identify.device_type == SAS_END_DEVICE &&
> > +        (rphy->identify.target_port_protocols & SAS_PROTOCOL_SSP))
> > +             sas_read_port_mode_page(sdev);
> >
> >   out:
> >       return mptscsih_slave_configure(sdev);
>
