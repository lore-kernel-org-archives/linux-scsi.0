Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C44C001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 14:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjGMOMX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 10:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbjGMOMO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 10:12:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1543271E
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 07:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689257487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4zisuLHJ8gu0UXeSj22EBom1yssk9ZFr5dEm2UPrsAY=;
        b=V37NHeBs53VL4Bs+qvrrxgqnaeAOMqoSSvaeYtdi9MyGXwUIE/LnN2BadC9kba2upCUsA0
        wEEc1dXo2OA9akC7kBddTXhoduPKJAq1WMBa5g/MWNao7tkTVK4PUfRyLLRuC/dY8jy6H0
        qAE0Vo5+sZRzklRJ6dT+CZ2Gd1jUOUo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-FqwqVdPpN-SMhbWRSKFfPw-1; Thu, 13 Jul 2023 10:11:20 -0400
X-MC-Unique: FqwqVdPpN-SMhbWRSKFfPw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA5118C08B2;
        Thu, 13 Jul 2023 14:07:35 +0000 (UTC)
Received: from localhost (unknown [10.39.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46D90F66CB;
        Thu, 13 Jul 2023 14:07:34 +0000 (UTC)
Date:   Thu, 13 Jul 2023 10:07:33 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Vadim Rozenfeld <vrozenfe@redhat.com>
Cc:     Mike Christie <michael.christie@oracle.com>, yvugenfi@redhat.com,
        mdean@redhat.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/2] vhost-scsi: Fix IO hangs when using windows
Message-ID: <20230713140733.GB310002@fedora>
References: <20230709202859.138387-1-michael.christie@oracle.com>
 <20230711183438.GA154686@fedora>
 <6b53b833-3c71-2bd9-8fd8-757ecda75c53@oracle.com>
 <20230712142656.GB215287@fedora>
 <41d2d3aa-b537-686a-f2b4-1e0a861cebc8@oracle.com>
 <CAKiOO4taKxW+QEveJA-3ovM04gkx0dBN0M_gEAAR9nb_bA-2uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ni02hCJuqGspY2Rv"
Content-Disposition: inline
In-Reply-To: <CAKiOO4taKxW+QEveJA-3ovM04gkx0dBN0M_gEAAR9nb_bA-2uA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--Ni02hCJuqGspY2Rv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 13, 2023 at 03:55:45PM +1000, Vadim Rozenfeld wrote:
> Currently we use 4-byte alignmed (FILE_LONG_ALIGNMENT)  in both Windows
> virtio blk and scsi miniport drivers.
> It shouldn't be a problem to change it to 512 by setting AlignmentMask
> field of PORT_CONFIGURATION_INFORMATION structure
> (
> https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/storport/ns-storport-_port_configuration_information
> )
> to FILE_512_BYTE_ALIGNMENT.
> I don't see any problem with changing the alignment parameter in our
> drivers. But it will take us some time to test it properly.

Hi Vadim,
After looking at this again, I confused memory address/size alignment
with request offset/length alignment. The virtio-scsi device does not
have memory alignment constraints, so FILE_LONG_ALIGNMENT is okay and
there's no need to change it.

Thanks,
Stefan

--Ni02hCJuqGspY2Rv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmSwBSUACgkQnKSrs4Gr
c8hDzwf7BD0MqLoDVXPybn61ZH+UR+DjEouwITuk1QJ9k0Soe1PQIVj0EpSfmDa0
PuirvUDI1ASlVs0TnVF3XdUTH0aaVj3XhaKvxyS5dvqnMSa4oKHMQQGu22g4kBmE
ozXT4W4gt5JwNfBUVnSRYILtxSJ6rkCHakEMELueOEiiuYW60PANE+4XlpFBibS0
riMIS6FFvt/9ms8QcCihfPPv8vVmPfwrrO3BSud8gc7q8vl+HOt1BGxC214Bk6Sm
jutOClSQ4BSsdurFkCh/ECDIx1MYsnT5n4Ll/4Bligs6atWzMfu3Vp++4OovBkxr
4rQ//0BbKfl3ENtK+ev5RStnVzb8XA==
=mbCv
-----END PGP SIGNATURE-----

--Ni02hCJuqGspY2Rv--

