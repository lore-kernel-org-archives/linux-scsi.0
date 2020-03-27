Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAD_ENC_HEADER,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2062DC2D0ED
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA7B620578
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="cROZyjoc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgC0RQn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 13:16:43 -0400
Received: from mout.gmx.net ([212.227.17.20]:33723 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727548AbgC0RQm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 13:16:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1585329388;
        bh=F140ojBXoucs6WYh/Mh3CeabfwV2ZTlkn+dqg0CjeTc=;
        h=X-UI-Sender-Class:In-Reply-To:Date:Cc:Subject:From:To;
        b=cROZyjoc7se7OTRWLuN4wADlHdBXg9feY3C8jGMy6tkAjneLvJ+n7/voz7mC4RqPX
         1Y7y/UPahJFgCVUdccjB56oUz9I2aXRd9o9TKd3VOuwVuBORI3J9e0vrvKjsrh9FWa
         bf9bUWn9/smImsQpLz0/yGoRxQ0iex7eBOcUcFrA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([82.19.195.159]) by mail.gmx.com (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MFKKX-1j2iIf1hpx-00FjTl; Fri, 27
 Mar 2020 18:16:28 +0100
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Originaldate: Fri Mar 27, 2020 at 12:58 PM
Originalfrom: "Martin K. Petersen" <martin.petersen@oracle.com>
Original: =?utf-8?q?=0D=0AAlex,=0D=0A=0D=0A>_The_file_aic79xx
 =5Fcore.c_still_contai?= =?utf-8?q?ns_some_FreeBSD-specific
 =0D=0A>_code/macro_guards,=0D=0A=0D=0Aa?= =?utf-8?q?ic7xxx
 =5Fcore.c_needs_the_same_change.=0D=0A=0D=0A--_=0D=0AMart?=
 =?utf-8?q?in_K._Petersen=09Oracle_Linux_Engineering=0D=0A?=
In-Reply-To: <yq1mu81buq1.fsf@oracle.com>
Date:   Fri, 27 Mar 2020 17:16:27 +0000
Cc:     "Hannes Reinecke" <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: aic7xxx: aic97xx: Remove FreeBSD-specific code
From:   "Alex Dewar" <alex.dewar@gmx.co.uk>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Message-Id: <C1LSD6B3VFZC.1DFOPBCI28S9R@lenovo-laptop>
X-Provags-ID: V03:K1:KGsm8ZzzltZqZBeDUKv3O0D2sJ+IUVTp5IngY7BJ8YVgzn9r1/S
 6K21T+ltwNE4O9cAxIn0+9UVo+10dkOO0Nsfo+SOja/lyrZlrZYQaYnfq0nCA1ULA5Avw4E
 meJMEwVuzzwuwuqsXC1nHbVRDAsyz7Ff2dlrxvL6OA7CuiqgEKO6OTq/GrdzTenxkHcSkSQ
 D/uPxCy+q8/lcNHeTxKRQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:GgfZigbU5h8=:YGt7wknhZnplb2Pas79uig
 NNGu33q4O7hWw3tvYJE9vAMEeiM2dLLIyEu9ow6JUjdjmc4qZEqRgS1j34TaXw8YpNCguTxRE
 Bqm+bgKHL6D96PVRO5hNUYIpNWHypDGE9H2x/xMNinsIewZAoF04z08qCOTIHUe8Zu4E08eTA
 9iDYICCa78aCTc0Q52onZ5rf614itEOySAFMKfDNfBiekY239R2HC5P/t8USkq462o6bTQkqW
 gpGPtAW94R0Iwqovo1DTA+xwHL2NTpJoRnB7AFl6ilREVcaT9//1kG9Cy7R/7wVmDm6Pwqgz/
 8gHxrrEPA2j1fF7TOTLStwEL00j/kb920kPbiWWbxa3k6f+/QEvN+0bkMvkUdc1w4xvb39VrX
 bRPFUZWUlQ3RsdIy7q8xqQbB3rHHW19giUE+ImgRIOF8+JaF2c4R15GWOK4S/iBcn4Mne6iC2
 f5mJ7hdjxB4k4dsOUQCjPSZPC4SKOz/aYVUqQDuZASnR1yF2KVXmVtW/zJq8yg5v9O7ETFO2V
 gUIYccnC552juF+ukSRu7woHtsCdXVQZTbGLKZMrHdEnsv/DzdiTjta/fb0WtQ0zBFi6Mpuw+
 q87dSawgYJbmbihb8boRq8xQ+RG8f8zjt8nN6UhKekFez8q7v7z2ovJpdFlwKi5poqGYl2IUw
 GUjDeiUQAoUwu4NFDUsNZ2DcrOrc/fmMlqmAEs74u4/WRbh/fuSCxSaVriGa5gmvHF1s4BLQA
 z9Fq8pdmfVRxBiWASTf9OXt1OYudLzToulBD9cojTkvzsm1kNlXniGSlCrfZNA/GmMiGhIZgN
 S10/Agn7Z4cjLLbQHycvqJN076Fcau1nDoyi5uIkbyibWdXn7STlCqt3gmDoX8qaaYYYfvHLf
 mrgUZP8PkdaQRewbnMGg9NxivZDtZ6pbY4G+BTUyPIik8dLBMyW8T8H/ABxMc6X4tsO0J5MKz
 2cA0s6/E8e0lEQN9zLrHqoLW0MjSWR+8DVGJ4D1kyvHeVg92Vi/efO2YAN4o3SfBq+noAuLPF
 XaEcuVKYRg2RwSpRV7ZW6p5VslxMrv488DNbytmOnM5i6Z6+qLjniyg0LFxpZ7lSBm0jhtGEV
 QdM3fas5MYsqhpI+BmEabqO6V2rJJHIrDfx38IiRH4FEYe4AojoZPF8Ywx0LxxUSL7McFx8xf
 p+tGUsVjSAuNCyPny+/wkhxsmJ3fZO9Sb2Gy1dWGBvqmZD25KJKTs2cQQQGM0f9Abh3hW8Jn6
 JmmaNSAhNOSbWPGbM
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri Mar 27, 2020 at 12:58 PM, Martin K. Petersen wrote:
>
>
> Alex,
>
>
> > The file aic79xx_core.c still contains some FreeBSD-specific
> > code/macro guards,
>
>
> aic7xxx_core.c needs the same change.
>
Thanks for the feedback. I'll stick this in a v2.
