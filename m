From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] fix kzalloc in scsi device handler
Date: Tue, 16 Nov 2010 12:23:35 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4F51A8010@cosmail01.lsi.com>
References: <AANLkTimsOGcybKBvJCjbtUaUpg5asYMDSky2QhovjcG+@mail.gmail.com>
 <201011161835.49079.eike-kernel@sf-tec.de>
 <E463DF2B2E584B4A82673F53D62C2EF4F51A7FEA@cosmail01.lsi.com>
 <201011162017.44328.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:49762 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757393Ab0KPTXh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2010 14:23:37 -0500
In-Reply-To: <201011162017.44328.eike-kernel@sf-tec.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Hillf Danton <dhillf@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chandra Seetharaman <chandra.seetharaman@us.ibm.com>

> -----Original Message-----
> From: Rolf Eike Beer [mailto:eike-kernel@sf-tec.de]
> Sent: Tuesday, November 16, 2010 1:18 PM
> To: Moger, Babu
> Cc: Hillf Danton; linux-scsi@vger.kernel.org; Chandra Seetharaman
> Subject: Re: [PATCH] fix kzalloc in scsi device handler
> 
> Moger, Babu wrote:
> > > -----Original Message-----
> > > From: Rolf Eike Beer [mailto:eike-kernel@sf-tec.de]
> > > Sent: Tuesday, November 16, 2010 11:36 AM
> > > To: Moger, Babu
> > > Cc: Hillf Danton; linux-scsi@vger.kernel.org; Chandra Seetharaman
> > > Subject: Re: [PATCH] fix kzalloc in scsi device handler
> > >
> > > Moger, Babu wrote:
> > > > Agree.. But this may not fix the problem completely.. Please see
> my
> > > > comments below.. Also copied Chandra if he has any comments..
> > > >
> > > > > -----Original Message-----
> > > > > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > > > > owner@vger.kernel.org] On Behalf Of Hillf Danton
> > > > > Sent: Tuesday, November 16, 2010 7:34 AM
> > > > > To: linux-scsi@vger.kernel.org
> > > > > Subject: [PATCH] fix kzalloc in scsi device handler
> > > > >
> > > > > They look like typo, since there are four instances of kzalloc
> > >
> > > almost
> > >
> > > > > typed by the same finger.
> > > > >
> > > > > The pointer is replaced with a struct, which helps kzalloc
> return
> > > > > correct result.
> > > > >
> > > > > thanks for any comment on the possibility that mem overflow
> could
> > > > > happen.
> > > > >
> > > > > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> > > > > ---
> > > > >
> > > > > --- a/drivers/scsi/device_handler/scsi_dh_alua.c	2010-11-01
> > > > > 19:54:12.000000000 +0800
> > > > > +++ b/drivers/scsi/device_handler/scsi_dh_alua.c	2010-11-16
> > > > > 20:40:36.000000000 +0800
> > > > > @@ -759,7 +759,7 @@ static int alua_bus_attach(struct scsi_d
> > > > >
> > > > >  	unsigned long flags;
> > > > >  	int err = SCSI_DH_OK;
> > > > >
> > > > > -	scsi_dh_data = kzalloc(sizeof(struct scsi_device_handler *)
> > > > > +	scsi_dh_data = kzalloc(sizeof(struct scsi_dh_data)
> > > > >
> > > > >  			       + sizeof(*h) , GFP_KERNEL);
> > > >
> > > > I think this should be like this below.
> > > >
> > > >       scsi_dh_data = kzalloc(sizeof(struct scsi_dh_data)
> > > >
> > > >   			       + sizeof(struct alua_dh_data) ,
> GFP_KERNEL);
> > >
> > > How about kzalloc(sizeof(*scsi_dh_data) + sizeof(*h), GFP_KERNEL)?
> >
> > No.. This would only allocate couple of pointers..  The below should
> be
> > good enough..
> 
> No, it would not.
> 
> >      scsi_dh_data = kzalloc(sizeof(struct scsi_dh_data)
> >    			       + sizeof(struct alua_dh_data) , GFP_KERNEL);
> 
> And that is exactly what I tried to avoid. Look at the * before the
> variable
> name. That would allocate the space for what that pointer is pointing
> to.

Ok.. got it.. Then, Your suggestion should work fine.. Thanks. 
