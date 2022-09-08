Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EE4C38145
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 19:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiIHTcT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 15:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiIHTcR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 15:32:17 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1967BC0BF8
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 12:32:17 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t3so13827914ply.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 12:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=yvnYGanyaKEUGbRqd/CcPU/eEOKoagHljyZ9DNPCeE8=;
        b=VXBAb7VhCyUpRLftJ6Jl6X8R0msjlER4l8aAczAntshu1v783rq21DjQJKjtN6/Rsf
         Sn7+A+Adqvk6u/PQnGv0KN69UgWHv9ifBCflghVTl2I0vGMevxZyBgncUiY0cLbXKalR
         9wKrjBVpnqG7w7gQoq6qHNYml33QH3YpoylstO/dYZNIYQgFZc2Um1t5sN+rnYjTgqjs
         N3SniGa+Tc9vitPZSZmduDGHK4W+bzyvw0I0GWQlwJTaKD8sYjJ50i+1rUBztDKKRp2y
         bJgtJQimb2exMGHf//QjqawHt+YDtElzWSLfH9g8BX7D5mtitGGxc2aP9Af1kH4KWmR2
         VoPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=yvnYGanyaKEUGbRqd/CcPU/eEOKoagHljyZ9DNPCeE8=;
        b=UDdpJQK/BzIBi9d4qHp5H+tzO8DlWNxw8OHCOSN43PbWmcUIWJWa6LZvDI23InS/Co
         MPKOzCk8OCXYzDDrTtIbG4uMt5thYQAqw672vMhyLyMIbS1SEnwxjKkKRRkU+c+5JirW
         Hk4EOGEALKfTCqG+JDf59WhqJ72t5WtXdZQpQz0bR+2GnjoYoEKbBiSmMuFsAeucIQgR
         FzazMypRBkzpL2gwnfYf23anKRfkpidnb5ZfOFakC2eurZjJIynylYxyqnbud3hFG7Ml
         rFTXPijo6KFGY20TU0oUB9hr7RdNkikC7z9uN58uIUf5EWdy6LWj1xwbypQopYV8Vvjk
         pPZw==
X-Gm-Message-State: ACgBeo0msvu8GOliDiulezLCJ0mQDY2ACUgk4YvwmmxycbGcZIqEC0lm
        S9HHR4J1q1QRDUFUieam2PGUKHDchUoJCMK7OCRt35rmU72O0LVX
X-Google-Smtp-Source: AA6agR5F459xVchDt5t18drrz5D05f1K48B3Beebsu6AtnSV/D8lGwlnM/Em67qj8OOIauN0lob0COmLvCnjmOepslU=
X-Received: by 2002:a17:90a:e60c:b0:202:6ef8:4b52 with SMTP id
 j12-20020a17090ae60c00b002026ef84b52mr3750522pjy.236.1662665536628; Thu, 08
 Sep 2022 12:32:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjXO3=VDjwrtWPCdzQtmWS19UmoUGEXy-zbg5R0fMpJkg@mail.gmail.com>
In-Reply-To: <CAHk-=wjXO3=VDjwrtWPCdzQtmWS19UmoUGEXy-zbg5R0fMpJkg@mail.gmail.com>
From:   hdthky <hdthky0@gmail.com>
Date:   Fri, 9 Sep 2022 03:32:05 +0800
Message-ID: <CALV6CNMg0PGYteL5xP-rYQup1MjxVFPogMUH6ULwwvqeKvUzxA@mail.gmail.com>
Subject: Re: PATCH] scsi: stex: properly zero out the passthrough command structure
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 9, 2022 at 2:16 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Entirely untested, but it would seem to be the cleaner way to go about this. No?

I test the patch using the method described earlier and it turns out that the
bug is fixed.
