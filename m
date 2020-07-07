Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A338CC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 11:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 815FC206F6
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 11:38:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="jxNYUjF2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgGGLix (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 07:38:53 -0400
Received: from mout.web.de ([212.227.17.11]:35625 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbgGGLiw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jul 2020 07:38:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594121907;
        bh=Ie4d2lH0YCvDtJ40tT+Ij77kgtuu0kKomun9k3ORrD0=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=jxNYUjF2anZa81+Kz3So4hpuSFcscNqAxgsNHIUjUWC3Han/FkD+GISMSjlrEbTE/
         mlaFAgcmJ+y9Vy1u7zW/s+1A244/dB9DyE+xh2nGbqFB8vuw3kXRgizjDITJK19skc
         i7dvrozTAJjLhMwpYX+mDhsaZOcik+OGsSlEcVXw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.121.241]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LcgVn-1kaezE28ZT-00k9YM; Tue, 07
 Jul 2020 13:38:27 +0200
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neerav Parikh <Neerav.Parikh@intel.com>,
        Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH] scsi: fcoe: add missed kfree() in an error path
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <977e2781-99ed-54c0-27ad-82d768a1c1e6@web.de>
Date:   Tue, 7 Jul 2020 13:38:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UHqAvi6Jt1lXXUbKU0FLdrLlou9f16SL3QLp4Yh90FLnZg42a4G
 kjx1rVZYaifAYN1Sy7LX+1vHb9HX4zNbxBF58+clurHxRNh4ieozNGU74rsSqee4YDucjpj
 xfBqNNvqUGw0d/QofzU4dJKm3eHezYk44RoNA76/a0gQsqKtfOvDsPe8WhnEH1sx9X6RDo7
 /njjKspgqWfwf+P61A2ag==
X-UI-Out-Filterresults: notjunk:1;V03:K0:cgd5aVH3yjs=:VL8t70FJ3LNkpwTzlf25hj
 6MO2057EOXCwHkMK9GewuU3cH6stLxvvbYA+Zqau4L2VlItK2Vx8G4OzKJmlZEc+ygdAk1Jgv
 DHLLXbaGQOFBS9KRHGI0P0RDx7id6n+TXByFHz87z3doAZ7qlEyYvnw0uu42u9fkse0wNgXQ+
 cyCgXdlc/WCfhVWFuPDB1u0O1ahcIg6IsX7Y6EAXVeAKzVxsPaaQ/idmw0ia3EBDnKD9iwkcB
 wIJdmu8pIqr+Z8VJYXUBmq8eWLca50izoaiPqWueErwPdG0mdujHafBZi5Y4afRjZV7bZl54Q
 9d9ivhQ0tzINV8rGXaZZ33/LjDrM3eTt8ti8i7Yc/Qx3Q4b+GoWWTlw0ppGOi4jtETcYQo3UO
 AsyXVzte9Whf57nZVKkRtr4Gc7xk140dkSyXdDeNl9VuPnmbX0HnwvBVh4z1Jy0UMUNfqAD3r
 /rMH1qWWBI/GW5NTy2OeAchGUk4H+a2z/i/QbvUS3kF37ejKYyQMro1mCMK5bts+ZayNQsZt4
 vaY9y2EslfFH3F8I7u/gAi6GrZAKQ+pukVB7qa+UHdN0wUaKxwO8kQadf0vNbA63AC5ajLJpL
 TUZ9T8jMdt/QGMXXDuh4PUHUASfxP7Nz31cCrnvYTAeWP+9SJ7tjxBhR0dHXetlK9LJcLrPUE
 A29v0FpVe917bluIjwbpihU7MInL1M2fK1n9DVByn/NrcNGMglX0ymuorJILjS9XEuyvhUvtw
 hjiZj0pA0TOqVa75eKR1Zr3yRknJDoqu/vAbFTdmKUmpdQX1efKMW1tx11Dqmhk814KQrhevq
 tGQy7yWttExHPnOzRbVInYmZta6mihDnIvQ+LQu9Q4UdLwmLEhZBSoz9+O42vtusI3xxcUncR
 NRLFkv6LQTLZanepOPJCfgYKgr1QLWipX74+fgdz21K3rDNj/jLLrmhsj3qLq2qRQKL2w1P63
 YCjQA2TB+UJLkNIgpWzNPd+oV0VGrjzUtjn7uTPWdxrb2tOC8G30fRRSrWBmeTf/245BRVb4l
 ollb//P2ipsa7x5hEcnDRFA0pOcDzU5F4r2oZLrZYma4mPXOAl5RDq37XXIUQgGmDEuIr5UXu
 MoF7DBWEyinLi3x2X19f21mptP0zYZQUkW9gxKx4gBSlnfOhWcNGLrM0rJjjhLjOu1eceU8No
 57OcEo8DsGPPBo9nXDvXVulihaPqIYO9meciN5eYT2FQNaqG2jMfWeoFkAW9Ij2hHqNodyj3W
 4jyNGZcMwLN/ownb4g1ikBwktHEydgDm5ct8u1A==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> fcoe_fdmi_info() misses to call kfree() in an error path.
> Add the missed function call to fix it.

I suggest to use an additional jump target for the completion
of the desired exception handling.


=E2=80=A6
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -830,6 +830,7 @@ static void fcoe_fdmi_info(struct fc_lport *lport, s=
truct net_device *netdev)
>  		if (rc) {
>  			printk(KERN_INFO "fcoe: Failed to retrieve FDMI "
>  					"information from netdev.\n");
> +			kfree(fdmi);
>  			return;
>  		}

-			return;
+			goto free_fdmi;


How do you think about to apply any further coding style adjustments?

Regards,
Markus
