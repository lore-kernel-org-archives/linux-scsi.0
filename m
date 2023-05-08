Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FD8C77B75
	for <linux-scsi@archiver.kernel.org>; Mon,  8 May 2023 16:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjEHQEq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 May 2023 12:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjEHQEp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2023 12:04:45 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871115596
        for <linux-scsi@vger.kernel.org>; Mon,  8 May 2023 09:04:43 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 3f1490d57ef6-b9a6f17f2b6so25738048276.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 May 2023 09:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1683561883; x=1686153883;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wodWe8SDnJ14mNjq+x5RUEaw14/Y1tQx2a3swW+NcF4=;
        b=ZuK8d8TMmvx9wkXXV/lVzryDxYdVZPoc4/Le6ZHyIglhaQOIkiVoB6AJDBvDvXBc+O
         QcnGPcB8420Vnq/1qlJIjHQfjgQIjMtoHz1FXPM7/iEC8ZZ/OEPzfxUAcIc0V2aZA2eC
         Zsqos2Iy807V9dK29GXiWyNRmAwvsRHWyJjg5Kgc3dZ0nAcn7UmuIRw/ekWvfsb/sA7s
         hBbiXvRB+5L++8JAdVI6CLQXiHIbS5L6lj/wd6LzW4yi9Epicq79ZrhFq5Lm5H5MNj4+
         yEDNwbNxNF/2LoDsQBTMAMoo8WA9CwlArhwmY4SMCJGNHEWRgmgdJyUnc8oXxrifo413
         2k4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683561883; x=1686153883;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wodWe8SDnJ14mNjq+x5RUEaw14/Y1tQx2a3swW+NcF4=;
        b=jlGMw/LquV6XdRhWt5lFyJIKTHeExp+k3SO334FBuIoTg+0ALvmaaHY5gC11D4xPv8
         A6Y9s3DVuZkHMlLriLgmBcFR+sCY6nc9eLXJyM3XsX+M5ynFLXz9jWrJtzeGgi7PWdG/
         hdVoSqNUIhwhAhiJZ2I+3wmOGbNCsMr04MopFs94afcpShIwMtK700nZXjiIAUqQNwve
         BE1TAHLCbVNuGkS+PQ+lUTspLyN28sxNXL+WyvleRlEmtLOyj47dflaapsmunKMn/i+8
         stWrX5tirhHs6DREblvuislj3MTa5UW/ASuDldIX9Z4aRT4j5KdFbNgFI71ePCItgXoL
         QA6A==
X-Gm-Message-State: AC+VfDyf4NflR65Z23SJh+lukPkD1e7v55+o+w+WW2/dTT6P5NhXmmjb
        YuWe+fkYA6XmdN4b3fX9HtZG1w==
X-Google-Smtp-Source: ACHHUZ4OUJTS10J3sijo8Z+5zo3cLlIBrTTs5Qkp3Rp8RwzXVqUZLmqlmoY8S31sbPUzIKK5AS9q1w==
X-Received: by 2002:a0d:ccc9:0:b0:559:d19a:37ee with SMTP id o192-20020a0dccc9000000b00559d19a37eemr10590892ywd.15.1683561882657;
        Mon, 08 May 2023 09:04:42 -0700 (PDT)
Received: from smtpclient.apple ([2600:1700:6970:bea0:d134:e0c7:8da4:b0bc])
        by smtp.gmail.com with ESMTPSA id n12-20020a819c4c000000b005460251b0d9sm2565997ywa.82.2023.05.08.09.04.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 May 2023 09:04:41 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH] scsi: sd: Avoid sending an INQUIRY if the page is not
 supported
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <yq1h6sn10by.fsf@ca-mkp.ca.oracle.com>
Date:   Mon, 8 May 2023 09:04:28 -0700
Cc:     linux-scsi@vger.kernel.org,
        Seamus Connor <sconnor@purestorage.com>,
        Krishna Kant <krishna.kant@purestorage.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <81D851CF-423E-480C-80C1-F05CB67E5322@purestorage.com>
References: <20230505204950.21645-1-brian@purestorage.com>
 <yq1h6sn10by.fsf@ca-mkp.ca.oracle.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
X-Mailer: Apple Mail (2.3731.500.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On May 8, 2023, at 5:26 AM, Martin K. Petersen =
<martin.petersen@oracle.com> wrote:
>=20
>=20
> Brian,
>=20
>> When SCSI devices are discovered the function sd_read_cpr gets =
called.
>> This call results in an INQUIRY to page 0xb9. This VPD page is called
>> regardless of whether the target has advertised this page as
>> supported.
>=20
> We used to check the page list first. However, we found several =
devices
> that we did not discover correctly because the pages, while present,
> were not advertised in page 0 and thus ignored. So not checking the
> supported pages first is a feature.

Wouldn=E2=80=99t it be better if those targets fixed that problem? Do =
they report
nothing when VPD page 0 is requested or an incomplete list that =
doesn=E2=80=99t
include this 0xb9?
>=20
> What exactly is the problem you are experiencing wrt. your target
> getting an inquiry for the CPR page?

What happens for us is that our support and customers are used to =
looking
for errors when they see a problem as you would expect. When we are =
logging
VPD page 0xb9 not supported for every device every time a Linux host
reboots it leads to that being incorrectly attributed to whatever actual =
problem
is going on. There is nothing more we can do since we do return the list
of page codes supported and this 0xb9 is not in the list.

Thanks,
Brian
>=20
> --=20
> Martin K. Petersen Oracle Linux Engineering

