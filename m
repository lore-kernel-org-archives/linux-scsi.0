From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH] megaraid_sas: Fallback to older scanning if not disks are found
Date: Mon, 18 Jan 2016 10:44:31 +0530
Message-ID: <7df34cf7b9d82b4bfcb79c3630fbf373@mail.gmail.com>
References: <1452867193-41266-1-git-send-email-hare@suse.de> <56996BC1.40400@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:33909 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbcARFOe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2016 00:14:34 -0500
Received: by mail-lf0-f44.google.com with SMTP id 17so110171224lfz.1
        for <linux-scsi@vger.kernel.org>; Sun, 17 Jan 2016 21:14:33 -0800 (PST)
In-Reply-To: <56996BC1.40400@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.de>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Lee Duncan [mailto:lduncan@suse.com]
> Sent: Saturday, January 16, 2016 3:29 AM
> To: Hannes Reinecke; Sumit Saxena
> Cc: Kashyap Desai; megaraidlinux.pdl@avagotech.com; Martin K. Petersen;
> James Bottomley; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] megaraid_sas: Fallback to older scanning if not
disks
> are found
>
> On 01/15/2016 06:13 AM, Hannes Reinecke wrote:
> > commit 21c9e160a51383d4cb0b882398534b0c95c0cc3b implemented a
> new
> > driver lookup using the MR_DCMD_LD_LIST_QUERY firmware command.
> > However, this command might not work properly on older firmware,
> > causing the command to return no drives instead of an error.
> > This causes a regression on older firmware as the driver will no
> > longer detect any drives.
> > This patch checks if MR_DCMD_LD_LIST_QUERY return no drives, and falls
> > back to the original method if so.
> >
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index f97ec34..79dff70 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -4107,6 +4107,10 @@ megasas_ld_list_query(struct
> megasas_instance *instance, u8 query_type)
> >  		ret = megasas_issue_polled(instance, cmd);
> >
> >  	tgtid_count = le32_to_cpu(ci->count);
> > +	if (tgtid_count == 0) {
> > +		/* No drives found, try the older LD list DCMD */
> > +		ret = 1;
> > +	}
> >
> >  	if ((ret == 0) && (tgtid_count <= (instance-
> >fw_supported_vd_count))) {
> >  		memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
> >
>
> Reviewed-by: Lee Duncan <lduncan@suse.com>

NACK as fix is already provided in another patch.
Please review patch - http://marc.info/?l=linux-scsi&m=145044529215209&w=2
It has changes to handle this particular issue as well along with many
other areas of MFI DCMD timeout.
