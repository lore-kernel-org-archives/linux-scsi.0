From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] - export scsilun_to_int
Date: Wed, 31 Jan 2007 19:51:57 -0600
Message-ID: <1170294717.3402.92.camel@mulgrave.il.steeleye.com>
References: <20070131225433.GA6652@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51486 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161252AbXBABwH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2007 20:52:07 -0500
In-Reply-To: <20070131225433.GA6652@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2007-01-31 at 15:54 -0700, Eric Moore wrote:
> static int
> +mptscsih_cmp_scsilun(struct scsi_lun * lun1, struct scsi_lun * lun2)
> +{
> +       int i;
> +
> +       for (i = 0; i < 8 ; i++)
> +               if (lun1->scsi_lun[i] != lun2->scsi_lun[i])
> +                       return 1;
> +
> +       return 0;
> +}

what's wrong with

memcmp(lun1->scsi_lun, lun2->scsi_lun, 8)

rather than introducing a wrapper?  The compiler can even optimise
memcmp for a fixed size nicely.

James


