Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386CAC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1115A207D0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:16:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="IIekANrO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgGIRQY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:16:24 -0400
Received: from mout.web.de ([212.227.17.12]:35761 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgGIRQY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jul 2020 13:16:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594314968;
        bh=uoypEdUxFWP131P0/wLe+vSjvXH2N1CecvY+8h97KC4=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=IIekANrO+iKJX6tRWfuoiVVvFYU4G802gQ0LSZ/d7W9zpNykX/PgWf9eKIJBetHZa
         jH/C3Tv97ZXCj6KpYhZCM4vu9dUBqOGQizZ9YP4TKRZbiTp6ElI4w059qC61y2hn2y
         IryiOmMRp9k39UiCbe3lHSCw7+Y7D/Em+vus8HrU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.81.209]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M1oGM-1km6iI2QEE-00thVf; Thu, 09
 Jul 2020 19:16:08 +0200
To:     Xianting Tian <xianting_tian@126.com>, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH] scsi: virtio_scsi: Remove unnecessary condition checks
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <a197f532-7020-0d8e-21bf-42bb66e8daec@web.de>
Date:   Thu, 9 Jul 2020 19:16:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vIQ0hSOkhei+jNfqGgLRjnC6BCzdk9nP63VC530uKBRashIUqa6
 vXkOjUS56yJeVH+RjcjSac6bt1elDS8JA28ilBhw/jXHYGxptpFplg6vqvWhnn4Puc2KP7D
 UwFUbMF/OMW9TfsNLIEspXUQEZcpZjyqxqM1g4hvknICItTGwdAZIHwhh7mopVKTLbR89uC
 Z410jhFpy9H4SjOFNaH5Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/dXLN/51ieE=:zRtwPONgajg7Ph1Nf5O24s
 Ha4/ZU6N+ge4DNr2lLc9icm+Oa4tElr0PWnaAUM41BVuplkYd48oWvS5X0RL7pjt1lseeJeGN
 /Oup0COWHX+s/dkFKp7G3tBSQtPiynYt7yrAXmvFsInXvVF0Ug1Ir/x6x8cQZxorPLkct93f4
 kvGwe9khyc81hgXbfWqYRsOETEktA8BPwp3+Pd/TRdPu4Dgm5VKRYya2MebEHkw4luvrqVFca
 v8bj0hJy12VHm8vW6XA2ONuj5x4LdcHj3qKMEt/qTj5WDKOky7Ssbezus8bxIVLZpDkPjyGdJ
 SllJyZ4TfSwlPT2if2Z+kdn/ZDOdRhR2WWmHy0SBtj0RkF8hNn0SPRzlu5UZOwB96dO+wiwJH
 vsg6hZ3KwFdVMj+LnqhgUPBwDxkeKg9MqhSN+YyrH3q3aI/M4tFrhggeog2diBdCIHCQm/IYn
 1SFJYRTAkYCaktMSh86BYFgYmsM9QNYvjrK4FQPJ/YaVPd2wysm9LsLXlw5pd8GVZOuJNOLsQ
 1YTAErmiH7LbewAYazUdIPdQV5aTdvexrN1Sqh2qnVI0Gft2x6FV8XtLKcw0BGFbars0GxRE/
 KRVthiL+bk+tEPCKAGouTlFadDfyd86c3NV89lh4uJ/70HYrgYRNHROjaR2dgBxjsSwHJSode
 hObuPZ2QQI1tLh4sPgGVX65Rq38XmQ4XVgkWD9vmcgc5DJk9v0IocdZ+usNZhvr2B2mQa3GNc
 Uuz+nJ8SNwBHzLjXkGHdCV2nsHwNQGAW8bIJHbXc1QDKqoKeTacHjrRbqm1xL1yfAsS4IfK/V
 ssiEeOTGousGrGkGmVHc3u3Lpl7gKTbXOnK2Yn6q/gCaZ5LlnE6zhnYIMt456EKnWKZuuh8+7
 hukdQUiS9AxoG4vrKsSAGbeMLV2n1WzzAvP4wtib8Obxt7gyKIsbipr/StCdlVKKyQBZ7ad1j
 F96Mnk/EnXG6eI0hjF4oGbMwZ7MZlMBIavHshK164WLBpyxsssR3XQEc3S4TPqFbnMRLUkXUL
 i1dVfbrmNNNzUq3dEoO7H0BqmDVIYbZgOP/2Pej/6TNeju8oKjOV7gn8g/daaiGd9YioExqkC
 QNBDV/sTxy1oeJGnbRHEBPPIsRnVlY1WHg0PT+sa78VW/+KcgDBWbBysB1xUZiD5j6esglK/X
 n/SRlIr9Ja0UWVvQoXu9OVQ9hBQQhtRd9OiZs86X8I+oW43B1uiSQ21SI5Kz3vdy/2yrWSjFZ
 Av9gKXJpyiKg66NoGHIa2WI4QvB84Mfw/bfBLyQ==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> kmem_cache_destroy and mempool_destroy can correctly handle
> null pointer parameter, so there is no need to check if the
> parameter is null before calling kmem_cache_destroy and
> mempool_destroy.

Can another imperative wording be preferred for the change description?


=E2=80=A6
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -1003,14 +1003,10 @@ static int __init init(void)
>  	return 0;
>
>  error:

Can such a label be questionable?


=E2=80=A6
> +	mempool_destroy(virtscsi_cmd_pool);
> +	virtscsi_cmd_pool =3D NULL;
> +	kmem_cache_destroy(virtscsi_cmd_cache);
> +	virtscsi_cmd_cache =3D NULL;
>  	return ret;
>  }

How do you think about to add a jump target so that the execution
of a few statements can be avoided according to a previous
null pointer check?

Regards,
Markus
