Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26E3C11F69
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 16:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9EF861DE6
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 16:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhF2QcE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 12:32:04 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:49000 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232689AbhF2QcC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 12:32:02 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id AE63545EB8;
        Tue, 29 Jun 2021 16:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1624984172; x=
        1626798573; bh=qr5ky+gkEtYKemIN3GVjSxU+hq3oL/XSUADtw6tLNtA=; b=j
        cGbNPC4XT5j13/c34n/kSA+gKkffJHw3VKCc5gR6jMn86XUIEzSxHWZPAwi5dDxR
        6YzxM0UCxqorMyoJnz8WyX1YIGKCgFbA8F0JQ1TWJ/Tahr+3sKpVvGkRDM/MYKZi
        UlUydPyvNDS7aF888ZsmsbVa2ubGXBqWfBK45wLaFk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JaTW_Z1BNMpq; Tue, 29 Jun 2021 19:29:32 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A950045EB9;
        Tue, 29 Jun 2021 19:29:32 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (172.17.100.103) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 29 Jun 2021 19:29:31 +0300
Received: from T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272]) by
 T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272%14]) with mapi id
 15.01.0669.032; Tue, 29 Jun 2021 19:29:31 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>
Subject: RE: [PATCH] scsi: target: fix prot handling in WRITE SAME 32
Thread-Topic: [PATCH] scsi: target: fix prot handling in WRITE SAME 32
Thread-Index: AQHXYpXs/f5zpGiqxE6M7ake5We8B6sqYOsdgADgY8A=
Date:   Tue, 29 Jun 2021 16:29:31 +0000
Message-ID: <f974e27f0393448e814ea0fa1e845d24@yadro.com>
References: <20210616095632.16775-1-d.bogdanov@yadro.com>
 <yq1o8bpl6re.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1o8bpl6re.fsf@ca-mkp.ca.oracle.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.175]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

> > WRITE SAME 32 command handling reads WRPROTECT at the wrong offset in=20
> > 1st octet instead of 10th octet.

> Instead of twiddling all these offsets I think it would be cleaner to tur=
n the sbc_setup_write_same() flags[] into an 'unsigned char protect'. And t=
hen fix up
> sbc_check_prot() to take 'protect' as argument instead of the full CDB an=
d indexing into that.

OK, I will prepare new version of the patch.

> Another option would be passing the index but since cdb[0] is only used f=
or a rare error message I'm not sure it's worth it.

BR,
 Dmitry
