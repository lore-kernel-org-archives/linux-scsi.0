From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH 08/10] aacraid: Disable device ID wildcard
Date: Thu, 3 Dec 2015 21:32:18 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1EF169@BBYEXM01.pmc-sierra.internal>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1448973589-9216-9-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <566065C2.7090603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:38339 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbbLCVcT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 16:32:19 -0500
In-Reply-To: <566065C2.7090603@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Santosh Akula <Santosh.Akula@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Rich Bono <Rich.Bono@pmcs.com>

Hello Tomas,


> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Thursday, December 3, 2015 7:55 AM
> To: Raghava Aditya Renukunta; JBottomley@Parallels.com; linux-
> scsi@vger.kernel.org
> Cc: Mahesh Rajashekhara; Murthy Bhat; Santosh Akula; Gana Sridaran;
> aacraid@pmc-sierra.com; Rich Bono
> Subject: Re: [PATCH 08/10] aacraid: Disable device ID wildcard
> 
> On 1.12.2015 13:39, Raghava Aditya Renukunta wrote:
> > From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
> >
> > Added module parameter that disables device ID wild card binding.
> 
> What is the use case for this?
> 
> It looks like something which could be solved in the modprobe config,
> without a module option.

This will enable us to prevent aacraid from loading for PCI devices that match
device ID wildcards. Enabling us to use say a new driver for future devices.

> Cheers,
> Tomas
> 
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <raghavaaditya.renukunta@pmcs.com>
> > ---
> >  drivers/scsi/aacraid/aachba.c  | 5 +++++
> >  drivers/scsi/aacraid/aacraid.h | 1 +
> >  drivers/scsi/aacraid/linit.c   | 5 +++++
> >  3 files changed, 11 insertions(+)
> >
> > diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> > index 06cbab8..87f4f21 100644
> > --- a/drivers/scsi/aacraid/aachba.c
> > +++ b/drivers/scsi/aacraid/aachba.c
> > @@ -315,6 +315,11 @@ MODULE_PARM_DESC(wwn, "Select a WWN type
> for the arrays:\n"
> >  	"\t1 - Array Meta Data Signature (default)\n"
> >  	"\t2 - Adapter Serial Number");
> >
> > +int aac_disable_device_id_wildcards;
> > +module_param_named(disable_device_id_wildcards,
> > +	aac_disable_device_id_wildcards, int, S_IRUGO | S_IWUSR);
> > +MODULE_PARM_DESC(disable_device_id_wildcards,
> > +	"Disable device ID wildcards");
> >
> >  static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
> >  		struct fib *fibptr) {
> > diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> > index 594de5f..7708a2c 100644
> > --- a/drivers/scsi/aacraid/aacraid.h
> > +++ b/drivers/scsi/aacraid/aacraid.h
> > @@ -2177,3 +2177,4 @@ extern int aac_commit;
> >  extern int update_interval;
> >  extern int check_interval;
> >  extern int aac_check_reset;
> > +extern int aac_disable_device_id_wildcards;
> > diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> > index 3a4dbe7..2094842 100644
> > --- a/drivers/scsi/aacraid/linit.c
> > +++ b/drivers/scsi/aacraid/linit.c
> > @@ -1135,6 +1135,11 @@ static int aac_probe_one(struct pci_dev *pdev,
> const struct pci_device_id *id)
> >  	u64 dmamask;
> >  	extern int aac_sync_mode;
> >
> > +	if (aac_disable_device_id_wildcards &&
> > +		id->subvendor == PCI_ANY_ID &&
> > +		id->subdevice == PCI_ANY_ID)
> > +		return -ENODEV;
> > +
> >  	/*
> >  	 * Only series 7 needs freset.
> >  	 */

Regards,
Raghava Aditya
