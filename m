Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72309C54FD0
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 14:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A02C2071E
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 14:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="qY42EKlv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgDXOub (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:50:31 -0400
Received: from mout.web.de ([212.227.17.12]:51399 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgDXOub (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 10:50:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1587739819;
        bh=cRrD7bXw1OP6+uzh2zUIpeEXLb+7KKe2QxrgCmY504A=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=qY42EKlvdt1ok5X5AUXEm5EMUVaKnnWtec8TnSccSTOmFYFIBxuPeVx0tmX2PxlX2
         argY7p8JUbBELbzGyrID1QisCeVJgbkt9c+lbAO3cO3juRZil8uPd/Jo9gpXvaVpr0
         0qHR/pkG9Ae9YQYY2bgUaZlftDhlOR7d0jjELQgc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.129.82]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MDgDS-1jQHUj1FKo-00H8NS; Fri, 24
 Apr 2020 16:50:19 +0200
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
Subject: Re: [PATCH] scsi: fnic: Use kmalloc instead of vmalloc for a small
 memory allocation
To:     Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        linux-scsi@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <d9e5c4d7-43fd-13fd-688e-36f9f0d1466d@web.de>
Date:   Fri, 24 Apr 2020 16:50:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Z1WT1zXAgroImd+tDcHTq7Ik4qlowLOI89IgagSpgwITcHesPu1
 /CpaGyzZk5rUVvzUy/xYmWnvRywltWeKPl0ToiiFNONEXEgubX+Yb3/9aovld7jZOwtXYLt
 q4xa2y59nBuWsahmQqLshtO0VQnGcWg8XCcB3mabEO11EDr+FrSUKjiqpb3aMkp/0IaIIa5
 WHYjC+zUNgV5LibGii6Zg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:NT1bDgA2jIM=:MwTubiKfccBoKftYsGhpj5
 dJv97SJOd1vS8aUwyhOOQNASbqStVGgE24UfA6g4/4RxnTXEddLg3IhmCimJCFAikwuT+rgX6
 swQP9oeYbHrCWJ8CehSuobRroCjstRTn8ttJzP1eXeCD+tCnx/w5nfDzFGXNNkx8JaOUQbQm7
 Uc3gKUeQhLdjSA8vw//0jQ7ijTwmrnfD85tPd7NdsJd9xut9BWTRHNJKNDvpanZYoW+OoMq6a
 tV9qZW706VMEqhAkSgoxxvPzJdVTFHtZRxAGAhFxmwjVHA0mjnQMTy97GISCMoJSxPQGAFF2R
 TJTYahe36OpazkCGUkACqN0i0ZHA3acvuWAFMsQJOaDuwMPay5VfWDGRogga4Aiw0GuMk4Cgu
 SvPww3ccLG8AHe04XnBGgCmz1XTChBKFq95PW3T+AujHXzMESTjSUL589/F31iTOaFKHQ6utT
 nIXF4I2GMtZ6rN7Cx0VgoqCBNIhOgEnN7WNFXtlnKVQojP7+J0iVLKYD0nUZXtHoizOXa/yV+
 PeArEbx49yVEvy0r5nIB9oCV3oyYQAuFdF2hJVnlkNkyPlDfM0yw3hba2fAFvxCHX2eYEpmu8
 EEVbTioNnnowx4/bnRTgPo7G+dPR+DSFI+gO/uq1YGcsBWwl8tgIkRGrsqK1KHoXzlbvr53uW
 Hyb6waCrjWm4gWX+kXRsyshDdxzRcPTaqivgYNg9xon+0c6Ao4aIG1lw53ZtCzt2L/PSunhmV
 dtv8VGRSWG6Fedz/irNCPqvGbjprtWO+aYF/C5pt425EE/PeyAeLaHm1DDApRDMmkJntgj79Y
 yl35DOV3X9DkiqoyHZpWT09SpJzErhvXyQS2uEOYQ7vqQHm0q02GZBoOZ1um2wKNci8X2DBHa
 V1YY3Bs2ma1hj4D9AkCm1wEMcpBvWeT51oe37r5zmz1KDod069JA1Kzy4BHQ00uls5MWfWoCS
 dguuzLZVANU5bPyJbgYwpqIxScqiS9ANrsYQ706DklExIGRxU8YXFxOe43sbyreLlm+FIZGxl
 F0tIorgYlXkaRHy6W6mtCsDU6KEc3KmB9EjSg3lNaAanEkaJQ6JUaIGg8Q1ikvlav43tlnJsg
 zNmFQUIfyxw21cWseBn2FDOO5GeDs4RK2jdrYGA5fHaFI4RRzdY8IieT3SOSBVJtOyaYUzCzF
 cjaww/bC5tC7NBv0GKBnOrV1GoGugZa+BXCYyR1pPD1JMPjH+smIDU6xfB89pZ7+nx6CKBxDj
 gAMTxyXlIDiG+wFRU
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 'struct fc_trace_flag_type' is just a few bytes long. There is no need
> to allocate such a structure with vmalloc. Using kmalloc instead.

Can such an adjustment be relevant for the specification of the tag =E2=80=
=9CFixes=E2=80=9D?


> While at it, axe a useless test when freeing the memory.

I find it more appropriate to provide this source code improvement
by a separate update step.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?id=3Db4f633221f0aeac102e463a4be=
46a643b2e3b819#n138

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/sc=
ripts/coccinelle/free/ifnullfree.cocci?id=3Db4f633221f0aeac102e463a4be46a6=
43b2e3b819#n4

Regards,
Markus
