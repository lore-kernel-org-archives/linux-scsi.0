Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811C7C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 17:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E3D164FC6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 17:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhCJRGf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 12:06:35 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:36410 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbhCJRGb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 12:06:31 -0500
Date:   Wed, 10 Mar 2021 17:06:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connolly.tech;
        s=protonmail; t=1615395989;
        bh=NfjSu8oET9rxciuTn6CT63lHyFIE2Wh5ahAvo9BqhHI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=T5EOg9SKnsicHZt6BpxzYMKo9Le91E5BLIkOLsU6Qmso25xkejzk7bedEG2nz17IK
         LjWsz51ONKZkbQZ7T3DeqjJBEcBk0fcmlH2/p67RismIdKNm/XF/1pnbMIZ0rwAVYq
         jbQzwHIO8vmzm8MO6fsiLqdUsvT7lQvFyPfTAA3k=
To:     Avri Altman <Avri.Altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
From:   Caleb Connolly <caleb@connolly.tech>
Cc:     "ejb@linux.ibm.com" <ejb@linux.ibm.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Reply-To: Caleb Connolly <caleb@connolly.tech>
Subject: Re: [PATCH v3 1/3] scsi: ufshcd: use a function to calculate versions
Message-ID: <f8284c73-34d1-e1a7-6c47-563a0057a9c0@connolly.tech>
In-Reply-To: <DM6PR04MB65757AE022DFB7C1DA9B6D87FC919@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210310153215.371227-1-caleb@connolly.tech> <20210310153215.371227-2-caleb@connolly.tech> <DM6PR04MB65757AE022DFB7C1DA9B6D87FC919@DM6PR04MB6575.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

On 10/03/2021 4:34 pm, Avri Altman wrote:
>> @@ -9298,10 +9291,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
>> *mmio_base, unsigned int irq)
>>          /* Get UFS version supported by the controller */
>>          hba->ufs_version =3D ufshcd_get_ufs_version(hba);
>>
>> -       if ((hba->ufs_version !=3D UFSHCI_VERSION_10) &&
>> -           (hba->ufs_version !=3D UFSHCI_VERSION_11) &&
>> -           (hba->ufs_version !=3D UFSHCI_VERSION_20) &&
>> -           (hba->ufs_version !=3D UFSHCI_VERSION_21))
>> +       if (hba->ufs_version < ufshci_version(1, 0))
>>                  dev_err(hba->dev, "invalid UFS version 0x%x\n",
>>                          hba->ufs_version);
> Here you replaces the specific allowable values, with an expression
> That doesn't really reflects those values.

I took this approach based on feedback from previous patches:

https://lore.kernel.org/linux-scsi/d1b23943b6b3ae6c1f6af041cc592932@codeaur=
ora.org/

https://lkml.org/lkml/2020/4/25/159


Patch 3 of this series removes this check entirely, as it is neither=20
accurate or useful.

The driver does not fail when printing this error, nor is the list of=20
"valid" UFS versions here kept up to date, I struggle to see a situation=20
in which that error message would actually be helpful. Responses to=20
previous patches (above) that added UFS 3.0 to the list have all=20
suggested that removing this check is a more sensible approach.

Regards,

Caleb




