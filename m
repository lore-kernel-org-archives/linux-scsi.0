Return-Path: <SRS0=DEWY=5Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A16C2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 11:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BF412145D
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 11:42:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="HTXXTn7q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgDILmy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Apr 2020 07:42:54 -0400
Received: from mout.gmx.net ([212.227.17.21]:38561 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgDILmy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Apr 2020 07:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1586432547;
        bh=zXoV8mONuOHe3NZaogQahCljW9xYioAIbgcWd2tUaVU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=HTXXTn7q4GZuBcnzUvqu6M4v+rQaB/qHDMl2sNF0Ggckk0UAWjzm1PJDCkfm6q/mu
         nJaZDVYYPTNUW9iPVPzfj0Nx4s+1rH9mwtx33OCmJb730CO3HvsnSGcWv+k9pYFdlt
         JfhvCwz9oA3exGDnioQH2U2HIkTMB1Pb2zL51PmA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from medion ([82.19.195.159]) by mail.gmx.com (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N6bfq-1jEVjw420M-018507; Thu, 09
 Apr 2020 13:42:27 +0200
Date:   Thu, 9 Apr 2020 12:42:18 +0100
From:   Alex Dewar <alex.dewar@gmx.co.uk>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Allison Randal <allison@lohutok.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Julia Lawall <julia.lawall@inria.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Richard Fontana <rfontana@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org, aacraid@microsemi.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Remove unnecessary calls to memset after
 dma_alloc_coherent
Message-ID: <20200409114218.5muicchv37ulrjxf@medion>
References: <e2401a31-e9fd-e849-e27c-6e079f5556d2@web.de>
 <20200407160213.qh64de6ebrj7qkmx@lenovo-laptop>
 <807090f6-f2ee-0e5b-6e35-b0c148c7a22f@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <807090f6-f2ee-0e5b-6e35-b0c148c7a22f@web.de>
X-Provags-ID: V03:K1:4zeiGXMkks1kx7Grv2qN9KRNpqbPHQnG9kRTNUVQ/dMG/lGeSUe
 LUIgWwH6+C6/jTv0YehqdzYSutUKOeP2eDeCGEMuYo0nqdObmRrBGjcGJXp/XEHfeymgBue
 ppuQWTFz2bZ2nJKrehU1PPm19gXETpwWPm5CJcQ1t5wABXPFGazd6o1Wwbzikt2WUrtVPYm
 BfZ/LNKHYKhg4FU5I5RoQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:MkITTkrvp20=:Ipi8kwJdrolvAArUjDpLSq
 jlweAMsLyRwR6anr8m9I9AqWrZa6j5dbjytVg5jz2QVhEgVvHJgrfwY1DvIdXN3Pu6FQGJ/Jf
 wLN/ustLTbtYIuDXWKfu6jkhtKpebHfSHPSqvIof7fTIZ/sgemuWrh7RiXfec5m5uVmhG5Xoe
 SFgHZIVoWoiseiQOIEqnhI/NPIMfdg69Umop/GSVmG+BdN3R2zyvooDS+Kl09FHi4sgKTb3nx
 fBgKPRnjZlIFJumeX/K9H4KCrSnX4sTgwfdlqK5z4kFSHd5fS4oqhJYg6wnPiZRjXLG7MfQeL
 eCdJbzZPGD0RxbwsaHl/Qhj0Q7cYuH5EXIGLOtdNa+VYmBrpW6t2wbjsL37PUvbcbs4RUCf30
 KCAOxfRQo5a9AcZTOZbUjEVXCWo5GB0aE1us+/uVRSr4iq4hil2l7hJ8Bak9z3MlC0usKkMZT
 +MxAcAZvS3BRCPOS0IhXi9cM1ftm+oKUXdWyM+vrKEcVmoUYqM6/ZVNSZjrhMl8xJomkGIXtg
 y1TqOiq5B5TrkzUY9HrZYIqEYAPfc8pIgIixRwbu3bTvkcZIHbm7D5SSEcAuKoirsZkW2QQRN
 jTk7W1RVGx77SpfxllTBdVL1uxmpItx29jQqdUNLbGTWdYryvT12Mf62T7uOcWRm85UQEt3U/
 AWuDrMaNczx9Wc3Aau99EwynuV1DENHkosv5xRpeKMTaTWL0KofIexpO/AG3Wsb9/VCXdrdnB
 xgUwtabV5zN61HUk5Pa0KBr9nMuHut4LOWyi5zdoKT0kJIPuwbRIi+VKBZ+FQ1EiKJixkzq2+
 OtoXNUHRYpYcoaAh0IMA7Hg7RqC7QoubA1xrNRXhlTbRefLZ0hYh1CH9D4/jq6lDTugpsc8rR
 qz1RThMxIB0/9gCvloDmY3iYEAZaPeWvSiKCRKPGxdg/TY/k9aXGaAABMRVp5Socvwh+w/ae6
 uAhmGVFagonhI0nVf8eT0pO4ZtZiV+VmbfkaNc3LZRDk7E4EzeQrbiuak9+UCAIHoYSPtt4WY
 rQhQ7Mp4pPDsLH+Da4HE2D6AE5srppAJ4P/vwMXrTajd4HSb/MukTHiquSIWRKfxckTRp/inq
 SxfIqcPAXlUWSvN9pcjZ3AgcuHizAPlnrXTN/9S6nrs0O53+gioTffCZxYlyG6iHvUvAbe5aJ
 ebmXdBMH4a7wCbAkrmVlmXzrPk16efgjbjzGiZg9gOOy7IyRX+NvnwZAO7QlqhbzVLtwNxJhj
 CfLZfQyOrEV5Dxe3h
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 07, 2020 at 06:56:28PM +0200, Markus Elfring wrote:
> >> =E2=80=A6
> >>> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> >>> @@ -4887,15 +4887,13 @@ qla25xx_set_els_cmds_supported(scsi_qla_host=
_t *vha)
> >>>  	    "Entered %s.\n", __func__);
> >>>
> >>>  	els_cmd_map =3D dma_alloc_coherent(&ha->pdev->dev, ELS_CMD_MAP_SIZ=
E,
> >>> -	    &els_cmd_map_dma, GFP_KERNEL);
> >>> +					 &els_cmd_map_dma, GFP_KERNEL);
> >>>  	if (!els_cmd_map) {
> >> =E2=80=A6
> >>
> >> I find it safer to integrate such source code reformattings by
> >> another update step which will be separated from the proposed deletio=
n
> >> of unwanted function calls.
> >
> > Good point. This whitespace was autoformatted by Coccinelle,
> > probably due to my bad SmPL skills.
>
> Some system factors can be involved here.
>
> * The source code formatting can occasionally be improvable
>   in further ways (despite of help by a software like Coccinelle).
>
> * A change mixture can become more challenging.
>
> * Would you like to extend your skills in corresponding areas anyhow?

Sure, I'd love to. Are there any resources you'd recommend? I'm just
starting out with kernel stuff and would be grateful for any pointers
you can offer :-)

Best,
Alex


>
> Regards,
> Markus
