From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [RFC] hv_storvsc: error handling.
Date: Mon, 6 Mar 2017 17:48:51 +0000
Message-ID: <DM5PR03MB2490F80E2F703D6FD3F1AC4BA02C0@DM5PR03MB2490.namprd03.prod.outlook.com>
References: <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
        <20170228105741.6253bb8a@xeon-e3>
        <1488325732.11610.9.camel@linux.vnet.ibm.com>
        <20170228172532.280811ed@xeon-e3>
        <1488349258.20321.11.camel@linux.vnet.ibm.com>
        <20170228224845.1da358ee@xeon-e3>       <20170301155057.GA13167@lst.de>
        <20170301075412.2e5f1e98@xeon-e3>       <20170302000135.GA22886@lst.de>
        <20170302005615.GA23687@lst.de> <20170301174058.383da142@xeon-e3>
        <c8ff2b64-2421-ca45-1f89-afec0490c8b3@suse.de>
        <20170302102324.47dbe3ad@xeon-e3>
        <895c4f2e-7faa-41e1-b5de-eedb4ae0f882@email.android.com>
        <20170302110505.6ad2eb61@xeon-e3>
        <1b325703-b823-4304-9d9d-86071811e000@email.android.com>
        <20170303165011.53a38794@xeon-e3>
        <DM5PR03MB24906E9B50B16B8C567EE25BA02A0@DM5PR03MB2490.namprd03.prod.outlook.com>
 <20170306083619.6789f9ba@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0098.outbound.protection.outlook.com ([104.47.40.98]:1482
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753321AbdCFRtD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Mar 2017 12:49:03 -0500
In-Reply-To: <20170306083619.6789f9ba@xeon-e3>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: James Bottomley <James.Bottomley@Hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, "Adrian Suhov (Cloudbase Solutions SRL)" <v-adsuho@microsoft.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>



> -----Original Message-----
> From: Stephen Hemminger [mailto:stephen@networkplumber.org]
> Sent: Monday, March 6, 2017 8:36 AM
> To: KY Srinivasan <kys@microsoft.com>
> Cc: James Bottomley <James.Bottomley@Hansenpartnership.com>; Hannes
> Reinecke <hare@suse.de>; Christoph Hellwig <hch@lst.de>; James
> Bottomley <jejb@linux.vnet.ibm.com>; Jens Axboe <axboe@kernel.dk>;
> Linus Torvalds <torvalds@linux-foundation.org>; Martin K. Petersen
> <martin.petersen@oracle.com>; Dexuan Cui <decui@microsoft.com>; Long
> Li <longli@microsoft.com>; Josh Poulson <jopoulso@microsoft.com>; Adrian
> Suhov (Cloudbase Solutions SRL) <v-adsuho@microsoft.com>; linux-
> scsi@vger.kernel.org; Haiyang Zhang <haiyangz@microsoft.com>
> Subject: Re: [RFC] hv_storvsc: error handling.
>=20
> On Sat, 4 Mar 2017 21:03:41 +0000
> KY Srinivasan <kys@microsoft.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Stephen Hemminger [mailto:stephen@networkplumber.org]
> > > Sent: Friday, March 3, 2017 4:50 PM
> > > To: James Bottomley <James.Bottomley@Hansenpartnership.com>
> > > Cc: Hannes Reinecke <hare@suse.de>; Christoph Hellwig <hch@lst.de>;
> > > James Bottomley <jejb@linux.vnet.ibm.com>; Jens Axboe
> > > <axboe@kernel.dk>; Linus Torvalds <torvalds@linux-foundation.org>;
> > > Martin K. Petersen <martin.petersen@oracle.com>; KY Srinivasan
> > > <kys@microsoft.com>; Dexuan Cui <decui@microsoft.com>; Long Li
> > > <longli@microsoft.com>; Josh Poulson <jopoulso@microsoft.com>;
> Adrian
> > > Suhov (Cloudbase Solutions SRL) <v-adsuho@microsoft.com>; linux-
> > > scsi@vger.kernel.org; Haiyang Zhang <haiyangz@microsoft.com>
> > > Subject: [RFC] hv_storvsc: error handling.
> > >
> > > Needs more testing but this does fix the observed problem.
> > >
> > > From: Stephen Hemminger <sthemmin@microsoft.com>
> > >
> > > Subject: [PATCH] hv_storvsc: fix error handling
> > >
> > > The Hyper-V storvsc SCSI driver was hiding all errors in INQUIRY and
> > > MODE_SENSE commands. This caused the scan process to incorrectly
> think
> > > devices were present and online.  Also invalid LUN errors were not
> > > being handled correctly.
> > >
> > > This fixes problems booting a GEN2 VM on Hyper-V. It effectively
> > > reverts commit 4ed51a21c0f69 ("Staging: hv: storvsc: Fixup
> > > srb and scsi status for INQUIRY and MODE_SENSE")
> > >
> > > Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> > > ---
> > >  drivers/scsi/storvsc_drv.c | 48 ++++--------------------------------=
----------
> > >  1 file changed, 4 insertions(+), 44 deletions(-)
> > >
> > > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > > index 638e5f427c90..8cc241fc54b8 100644
> > > --- a/drivers/scsi/storvsc_drv.c
> > > +++ b/drivers/scsi/storvsc_drv.c
> > > @@ -543,28 +543,6 @@ static void storvsc_host_scan(struct work_struct
> > > *work)
> > >  	kfree(wrk);
> > >  }
> > >
> > > -static void storvsc_remove_lun(struct work_struct *work)
> > > -{
> > > -	struct storvsc_scan_work *wrk;
> > > -	struct scsi_device *sdev;
> > > -
> > > -	wrk =3D container_of(work, struct storvsc_scan_work, work);
> > > -	if (!scsi_host_get(wrk->host))
> > > -		goto done;
> > > -
> > > -	sdev =3D scsi_device_lookup(wrk->host, 0, wrk->tgt_id, wrk->lun);
> > > -
> > > -	if (sdev) {
> > > -		scsi_remove_device(sdev);
> > > -		scsi_device_put(sdev);
> > > -	}
> > > -	scsi_host_put(wrk->host);
> > > -
> > > -done:
> > > -	kfree(wrk);
> > > -}
> > > -
> > > -
> > >  /*
> > >   * We can get incoming messages from the host that are not in respon=
se
> to
> > >   * messages that we have sent out. An example of this would be
> messages
> > > @@ -955,8 +933,7 @@ static void storvsc_handle_error(struct
> > > vmscsi_request *vm_srb,
> > >  		}
> > >  		break;
> > >  	case SRB_STATUS_INVALID_LUN:
> > > -		do_work =3D true;
> > > -		process_err_fn =3D storvsc_remove_lun;
> > > +		set_host_byte(scmnd, DID_NO_CONNECT);
> > >  		break;
> > >  	case SRB_STATUS_ABORTED:
> > >  		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID
> > > &&
> > > @@ -1050,32 +1027,15 @@ static void storvsc_on_io_completion(struct
> > > storvsc_device *stor_device,
> > >
> > >  	stor_pkt =3D &request->vstor_packet;
> > >
> > > -	/*
> > > -	 * The current SCSI handling on the host side does
> > > -	 * not correctly handle:
> > > -	 * INQUIRY command with page code parameter set to 0x80
> > > -	 * MODE_SENSE command with cmd[2] =3D=3D 0x1c
> > > -	 *
> > > -	 * Setup srb and scsi status so this won't be fatal.
> > > -	 * We do this so we can distinguish truly fatal failues
> > > -	 * (srb status =3D=3D 0x4) and off-line the device in that case.
> > > -	 */
> > > -
> > > -	if ((stor_pkt->vm_srb.cdb[0] =3D=3D INQUIRY) ||
> > > -	   (stor_pkt->vm_srb.cdb[0] =3D=3D MODE_SENSE)) {
> > > -		vstor_packet->vm_srb.scsi_status =3D 0;
> > > -		vstor_packet->vm_srb.srb_status =3D SRB_STATUS_SUCCESS;
> > > -	}
> > > -
> > > -
> > >  	/* Copy over the status...etc */
> > >  	stor_pkt->vm_srb.scsi_status =3D vstor_packet->vm_srb.scsi_status;
> > >  	stor_pkt->vm_srb.srb_status =3D vstor_packet->vm_srb.srb_status;
> > >  	stor_pkt->vm_srb.sense_info_length =3D
> > >  	vstor_packet->vm_srb.sense_info_length;
> > >
> > > -	if (vstor_packet->vm_srb.scsi_status !=3D 0 ||
> > > -	    vstor_packet->vm_srb.srb_status !=3D SRB_STATUS_SUCCESS)
> > > +	if (stor_pkt->vm_srb.cdb[0] !=3D INQUIRY &&
> > > +	    (vstor_packet->vm_srb.scsi_status !=3D 0 ||
> > > +	     vstor_packet->vm_srb.srb_status !=3D SRB_STATUS_SUCCESS))
> > >  		storvsc_log(device, STORVSC_LOGGING_WARN,
> > >  			"cmd 0x%x scsi status 0x%x srb status 0x%x\n",
> > >  			stor_pkt->vm_srb.cdb[0],
> > > --
> >
> > This patch gets rid of the ability to "hot remove" LUNs. I don't think =
that can
> be part of any
> > solution. The INQUIRY hack I put in a long time ago was to deal with ho=
st
> bugs on prior versions of
> > Windows server. WS2016 should not be trigerring this code. Stephen, cou=
ld
> you please test this patch -
> > a quick hack:
> >
> > From b97f24f224a71a6e745c42e5640045a553eb407c Mon Sep 17 00:00:00
> 2001
> > From: K. Y. Srinivasan <kys@microsoft.com>
> > Date: Sat, 4 Mar 2017 14:00:46 -0700
> > Subject: [PATCH 1/1] scsi: storvsc: Fix a bug in LUN removal code
> > Reply-To: kys@microsoft.com
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/scsi/storvsc_drv.c |   13 +++++++++++++
> >  1 files changed, 13 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > index 05526b7..27eb682 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -885,6 +885,7 @@ static void storvsc_handle_error(struct
> vmscsi_request *vm_srb,
> >         struct storvsc_scan_work *wrk;
> >         void (*process_err_fn)(struct work_struct *work);
> >         bool do_work =3D false;
> > +       struct scsi_device *sdev;
> >
> >         switch (SRB_STATUS(vm_srb->srb_status)) {
> >         case SRB_STATUS_ERROR:
> > @@ -911,6 +912,18 @@ static void storvsc_handle_error(struct
> vmscsi_request *vm_srb,
> >                 }
> >                 break;
> >         case SRB_STATUS_INVALID_LUN:
> > +               if (!scsi_host_get(host)) {
> > +                       set_host_byte(scmnd, DID_NO_CONNECT);
> > +                       break;
> > +               }
> > +
> > +               sdev =3D scsi_device_lookup(wrk->host, 0, wrk->tgt_id, =
wrk->lun);
> > +
> > +               if (!sdev) {
> > +                       set_host_byte(scmnd, DID_NO_CONNECT);
> > +                       break;
> > +               }
> > +
> >                 do_work =3D true;
> >                 process_err_fn =3D storvsc_remove_lun;
> >                 break;
>=20
> I will try it, but it can't work for two reasons.
> First, the INVALID_LUN error is masked off on INQUIRY in current code.
> Second, the scsi_device is instantiated already as part of scan probe pro=
cess
> before it gets here.

Was the invalid LUN in the LUN0 position. Inquiry of LUN0 support (when LUN=
0 is not populated)
was added only recently to address host side issue.

>=20
> The best solution so far is:
> 	- remove old INQUIRY/SENSE error masking
> 	+ add new workaround for INQUIRY of device id on LUN 0
> 	  which appears to be the reason for old masking
> 	+ return errors on missing LUN
> 	+ provide better transport services for hot remove (rather
>           than detecting by failed I/O).

This the mechanism used by the host for notifying LUN removal - invalid LUN=
 error code.

K. Y
>=20
