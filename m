Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E854C2BA2B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 19:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C46D2064A
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 19:36:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="MeX7ncz7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387938AbgDMTgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 15:36:11 -0400
Received: from mout.web.de ([212.227.17.12]:45527 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387935AbgDMTgJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Apr 2020 15:36:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586806545;
        bh=sfjeNUJSAHB6UblCAyo4311HvX2lPDH7++QNKLb3Hts=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=MeX7ncz736jnMZZqaoQUrcuQWhh1/+jbeWAAFEQIPCV3L73Jl1rXbdbgV5u7M3tg7
         aR1uu3tmFMs4QbHr6zUiLI0KkDIKHNHvp8JHJrVUDWW9N0a/h48d1GT8wKUEvyWa1S
         25TjX//3w9Mg/Q4S7kGzDuINVJhN/mDClQKl82aQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.133.146.177]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LqlWY-1iksEN2sWA-00ePyz; Mon, 13
 Apr 2020 21:35:45 +0200
To:     Li Bin <huawei.libin@huawei.com>, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Xie XiuQi <xiexiuqi@huawei.com>
Subject: Re: [PATCH] scsi: sg: fix memory leak in sg_build_indirect
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <8b5551e6-46e2-9def-8ab6-ec5ba252c5ea@web.de>
Date:   Mon, 13 Apr 2020 21:35:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:WuWFgBw9do6DDIja6MdXQVYPnzFgETFNsuH6q5LfvWsUV0LCPUI
 HrAFyfn6UL/PtJW/hQXNfq6WZaMqdlpNZzhGzi6YoSAP/lhFcv8DEL/2aLNChvwEdJslT8B
 D6b+B3RWteliVRONyhDVLkjtwAmtGrKNsUyINzDrK+U0FKOns6SG1cgXMdH8YQUIuL7sqkx
 FLjs2PTUbb962NiWyWayg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:rL8dmkqrfIw=:KOeNg6+NnCU+ezQrSNEada
 z31G2wWUI0zM1uqf5oA0B+CwFXAWKwXEcgeJDSo+oSSB5JZzfb4jt8R5/a9BdtldXvZNNbhnl
 a1krATOu7Vo4uIej5lMA5z9j6gOUZstp4/E6KV6HE/z3aPeMgQ6wwIJ51mDI7tGerpUXTjVpp
 3Gx+cM4xt/pc+gGqUZH4pJhzjgEDmzzSNqz+5kd4pD4J+wV5sdFbJJt7luNFeFBs03HBA6os0
 o42r45oCvXomiiBefvBVfC8JUMttvKicrkMjVFBa1wj4ZM6e1l5C5hWuKWiBvsxGAvH7GE+M3
 BHo97eqv7hivTpoR4Xyb0OMgximoX9F2VgGzZ4+xlZsly6qVkSeFXZjdWgL7LcWnEzknkT9Xt
 3z0ZelYKBoEsKHMkxtRB1QXkLHHSQfZdEk4OTBBFCsPxgWdVFM4p0TOR8SOlI/6Wtp86HIeDX
 BWe4SQo0V/nUzRER1Cgy7xpnXzRA2hzTCiBNPGHp2wPwXGSKg+qe4caIzJ3xx4mG5ZiQnvEbV
 6A+21dBBANBcqLyuXKi8rn8+ufm/v69fHR0gjbkDNfaY1tfbaTGWu2H0AZ9k1nLFfEdZ/O3Xd
 XL8NtWJBMf7jMnB/1BU9QHqEPMLPxZfp0G0EppVwV1CYBQPrOY5p45VDCJ1tLVbwFd9cMOhUR
 pN4c/w7AK3Ttzf9psgzEK9g7L/WFz/vSR4+bjf8aLKcqkhV9FI/kqQwZFnuK63EpIbfUsfJ0c
 zvZb/4iv/BO1YYoj+amciaTnTQwz531zmBJK0ohvEWjuFYbVnHORS0mqdPB5SiLwjqdbq+jdV
 PkDHbWyMpYiPVqGB9m5sRahbPC2ILnHs8oJKr3nfvIVuAvE7e+N8cVBOLnocgWJzuoI2k3LJd
 ZT4hclA8xyHOKlt8NL2Vzj+e2UXyHsVRYuXPXfw6vQMCj2GlefX+7syOWQ46Guy+pQr0lWAe0
 wM5m0G1E1UzkT5V2e0pcP0dRZTdpcEtiaj1rZ5xOScfZ3E+qclsIDbeLf89WIl2jyv8I9KHSc
 AeAUudyYq3o4dmr/jqwlOuQ4OArSs1oIVJkdZVYSKvCt0qZKuZ0fhTc1i3Sz27Z5VwuLi4Pp5
 eYwzdH4gB0FD9MQSdw5+kuTjWwXNHWx+GJYEjY4Hu7rZihUCmQ5tzop/QY0QiQ1gqKJAZykO+
 Gizi9BhZxTe+cIwcVZvLFLY3S5LD9LBS5ox8fhg/epRTyEBjRYx/YEeO/G+zoL0ptHGbnwEYH
 pzyQEi1PUxy3uK5r4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Fix a memory leak when there have failed, that we should free the pages
> under the condition rem_sz > 0.

I suggest to improve the change description.

* Please use an imperative wording.

* Will the tag =E2=80=9CFixes=E2=80=9D become relevant?

Regards,
Markus
