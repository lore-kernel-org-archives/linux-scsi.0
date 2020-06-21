Return-Path: <SRS0=/9Oe=AC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC637C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 19:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4FE1248FC
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 19:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592767619;
	bh=JupXywNFV0aC73VEIcNLuijWQqpHVpQZpcOLv1kNawg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IgdRCRAL/iQT0r3c9iHk/P5j+SCd9+Ix/OlxJDjycbMD5SusgFIL4Oj6ffju0P5Ut
	 9jnnL16vvMgSa0ZmBXVyCJNDxzeYTxZ0PICQeHSsN0OgzzYHvfMpvB+KG1h4NKGQtW
	 lunhdCHnYrI2TUcBEquKKdWWIfP/3Al0xVgp+7Vw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgFUT07 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Jun 2020 15:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbgFUT07 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 21 Jun 2020 15:26:59 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA06B248F5;
        Sun, 21 Jun 2020 19:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592767618;
        bh=JupXywNFV0aC73VEIcNLuijWQqpHVpQZpcOLv1kNawg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wO/aeFYZ8SoB9ncD7f7ljNIxWAptAr28OxZtq2wP3H6z91HvnfmI6S02EJZLJYVux
         4s3igo97zNsl6YFCnwMFjh+hvvlMYfnWQFf9zF+qMbz6Cygtgngyt+lkQZ8nNARhcS
         I9QIc6w9oQeNXH3WvpTOw0VqjWEp01fO7IYN18BM=
Date:   Sun, 21 Jun 2020 12:26:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     'Avri Altman' <Avri.Altman@wdc.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        'Satya Tangirala' <satyat@google.com>, asutoshd@codeaurora.org,
        linux-scsi@vger.kernel.org,
        'Barani Muthukumaran' <bmuthuku@qti.qualcomm.com>,
        'Kuohong Wang' <kuohong.wang@mediatek.com>,
        'Kim Boojin' <boojin.kim@samsung.com>
Subject: Re: [PATCH v2 0/3] Inline Encryption support for UFS
Message-ID: <20200621192656.GC1140@sol.localdomain>
References: <20200618024736.97207-1-satyat@google.com>
 <yq1a70yh1f3.fsf@ca-mkp.ca.oracle.com>
 <CGME20200621123523epcas5p43bf94789149e6a49a4f9c18b10e1ef37@epcas5p4.samsung.com>
 <SN6PR04MB4640005BEC3EE690CB904298FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
 <000001d647f5$05a494c0$10edbe40$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001d647f5$05a494c0$10edbe40$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jun 21, 2020 at 11:24:30PM +0530, Alim Akhtar wrote:
> Thanks Avri for CCing me.
> 
> > -----Original Message-----
> > From: Avri Altman <Avri.Altman@wdc.com>
> > Sent: 21 June 2020 18:05
> > To: Martin K. Petersen <martin.petersen@oracle.com>; Satya Tangirala
> > <satyat@google.com>; alim.akhtar@samsung.com; asutoshd@codeaurora.org
> > Cc: linux-scsi@vger.kernel.org; Barani Muthukumaran
> > <bmuthuku@qti.qualcomm.com>; Kuohong Wang
> > <kuohong.wang@mediatek.com>; Kim Boojin <boojin.kim@samsung.com>
> > Subject: RE: [PATCH v2 0/3] Inline Encryption support for UFS
> > 
> > +Alim & Asutosh
> > 
> > Hi Satya,
> > 
> > >
> > > Avri,
> > >
> > > > This patch series adds support for inline encryption to UFS using
> > > > the inline encryption support in the block layer. It follows the
> > > > JEDEC UFSHCI v2.1 specification, which defines inline encryption for
> UFS.
> > >
> > > I'd appreciate it if you could review this series.
> > >
> > > Thanks!
> > >
> > > --
> > > Martin K. Petersen      Oracle Linux Engineering
> > A quick question and a comment:
> > 
> > Does the IE infrastructure that you've added to the block layer invented
> for ufs?
> > Do you see other devices using it in the future?
> > 
> > Today, chipset vendors are using a different scheme for their IE.
> > Need their ack before reviewing your patches.
> > 
> Yes, as of today at least in Samsung HCI, we use additional HW blocks to
> handle all the crypto part.
> (Though I need to check the status on the recent SoCs).
> However given the fact that UFSHCI 2.1 spec does includes Crypto support,
> and going by threads that you shared, looks  like other 
> Vendors does uses IE. I am inclined toward getting this reviewed. 

Note that Boojin Kim, who has been Cc'ed on all these patches, has already been
working on replacing Samsung's legacy inline encryption implementation with one
using the new framework.

Unfortunately, Samsung's UFS inline encryption hardware doesn't follow the UFS
specification, so it needs custom driver code and doesn't take much advantage of
ufshcd-crypto (this patchset).  However, it can still use the blk-crypto
framework.  So only the driver needs to differ, not the rest of the storage
stack.  This differs from the "old world" where every vendor had to customize
the entire storage stack to support their inline encryption hardware.

Anyway, ufshcd-crypto (this patchset) is still needed for all vendors who did
mostly/fully follow the UFS specification, e.g. Mediatek
(https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-stanley.chu@mediatek.com)
and Qualcomm
(https://lkml.kernel.org/linux-scsi/20200621173713.132879-1-ebiggers@kernel.org).

More reviews are always appreciated, though note that this patchset has already
been out for review for over a year.  (This is really v15; Satya started the
numbering over after blk-crypto was merged in v5.8-rc1.)  So I'm not sure we
should count on many more formal reviews.  

- Eric
