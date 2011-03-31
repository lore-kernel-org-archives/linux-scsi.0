From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] scic: remove mmio wrappers
Date: Wed, 30 Mar 2011 18:43:45 -0700
Message-ID: <AANLkTinqdo6q_EUCih74iZzsiccL1V-nk8qatxRVY8ax@mail.gmail.com>
References: <20110328000754.GA28347@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54729 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab1CaBnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2011 21:43:47 -0400
Received: by fxm17 with SMTP id 17so1494595fxm.19
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2011 18:43:45 -0700 (PDT)
In-Reply-To: <20110328000754.GA28347@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Sun, Mar 27, 2011 at 5:07 PM, Christoph Hellwig <hch@infradead.org> =
wrote:
> Remove a couple of layers around read/writel to make the driver reada=
ble.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks!

Smoketests ok, applied, but without the hunk below, which gives away
the fact that this was automated to some extent.

> Index: linux-2.6/drivers/scsi/isci/core/scic_sds_unsolicited_frame_co=
ntrol.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/scsi/isci/core/scic_sds_unsolicited_frame_=
control.c =A02011-03-28 01:40:43.704981485 +0200
> +++ linux-2.6/drivers/scsi/isci/core/scic_sds_unsolicited_frame_contr=
ol.c =A0 =A0 =A0 2011-03-28 01:41:14.336982622 +0200
> @@ -317,8 +317,8 @@ enum sci_status scic_sds_unsolicited_fra
> =A0* This method returns an indication to the caller as to whether th=
e
> =A0* unsolicited frame get pointer should be updated. true This value=
 indicates
> =A0* the unsolicited frame get pointer should be updated (i.e. write
> - * SCU_UFQGP_WRITE). false This value indicates the get pointer shou=
ld not be
> - * updated.
> + * scu_registers->sdma.unsolicited_frame_get_pointer).
> + * false This value indicates the get pointer should not be updated.
> =A0*/

Do you mind sharing the script you used to perform this conversion?  I
have a growing collection of hacked together cleanup tools from this
effort and would like to add this one.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
