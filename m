From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [RFC PATCH 3/5] libsas: dynamic queue depth
Date: Thu, 22 Sep 2011 09:38:54 +0800
Message-ID: <152AA3A5AB22434CBD95AE30281CA2F0@usish.com.cn>
References: <20110920220819.1094.12265.stgit@localhost6.localdomain6> <20110920221038.1094.7832.stgit@localhost6.localdomain6> <FC1F9E38C0703341A1A750524E2525A9018AE1E3@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE1E3@XYUS-EX22.xyus.xyratex.com>
Sender: linux-ide-owner@vger.kernel.org
To: 'Mark Salyzyn' <mark_salyzyn@us.xyratex.com>, 'Dan Williams' <dan.j.williams@intel.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: 'Dave Jiang' <dave.jiang@intel.com>, 'Luben Tuikov' <ltuikov@yahoo.com>, jgarzik@pobox.com, JBottomley@parallels.com, 'Xiangliang Yu' <yuxiangl@marvell.com>, 'Christoph Hellwig' <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Thanks Mark, I 'll post a patch to raise the default host can queue value,
I'm OK with his change!
--Jack
RE: [RFC PATCH 3/5] libsas: dynamic queue depth
> 
> Good Stuff, 'cept I am worried about the host max queue depth of 128 on
> the pm8001 driver resulting in starvation. I defer to Jack Wang's
> judgement on that point (and will explore separately how we can increase
> the host queue depth reliably on the pm8001).
> 
> Consider this an Ack from me that has an interlock on Jack Wang's Ack
> ...
> 
> Sincerely -- Mark Salyzyn
> 
> -----Original Message-----
> From: Dan Williams [mailto:dan.j.williams@intel.com]
> Sent: Tuesday, September 20, 2011 6:11 PM
> To: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org
> Cc: Dave Jiang; Luben Tuikov; jgarzik@pobox.com;
> JBottomley@parallels.com; Jack Wang; Xiangliang Yu; Mark Salyzyn;
> Christoph Hellwig
> Subject: [RFC PATCH 3/5] libsas: dynamic queue depth
> 
> The queue-depth for libsas-attached devices initializes to 32 and can
> only be increased manually via sysfs to a max of 64, while mpt2sas
> attached devices initialize to 254 and dynamically float via the
> midlayer ->change_queue_depth interface.
> 
> No performance regression was observed with this change on the isci
> driver.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mark Salyzyn <msalyzyn@us.xyratex.com>
> Cc: Xiangliang Yu <yuxiangl@marvell.com>
> Cc: Jack Wang <jack_wang@usish.com>
> Cc: Mark Salyzyn <msalyzyn@us.xyratex.com>
> Cc: Luben Tuikov <ltuikov@yahoo.com>
> Tested-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/libsas/sas_scsi_host.c |   39
> ++++++++++++++++-------------------
>  1 files changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c
> b/drivers/scsi/libsas/sas_scsi_host.c
> index 4c6923c..fe08ef0 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -784,8 +784,7 @@ int sas_target_alloc(struct scsi_target *starget)
>  	return 0;
>  }
> 
> -#define SAS_DEF_QD 32
> -#define SAS_MAX_QD 64
> +#define SAS_DEF_QD 256
> 
>  int sas_slave_configure(struct scsi_device *scsi_dev)
>  {
> ______________________________________________________________________
> This email may contain privileged or confidential information, which
should
> only be used for the purpose for which it was sent by Xyratex. No further
rights
> or licenses are granted to use such information. If you are not the
intended
> recipient of this message, please notify the sender by return and delete
it.
> You may not use, copy, disclose or rely on the information contained in
it.
> 
> Internet email is susceptible to data corruption, interception and
> unauthorised amendment for which Xyratex does not accept liability. While
we
> have taken reasonable precautions to ensure that this email is free of
viruses,
> Xyratex does not accept liability for the presence of any computer viruses
in
> this email, nor for any losses caused as a result of viruses.
> 
> Xyratex Technology Limited (03134912), Registered in England & Wales,
> Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
> 
> The Xyratex group of companies also includes, Xyratex Ltd, registered in
> Bermuda, Xyratex International Inc, registered in California, Xyratex
> (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co
Ltd
> registered in The People's Republic of China and Xyratex Japan Limited
> registered in Japan.
> ______________________________________________________________________
> 

