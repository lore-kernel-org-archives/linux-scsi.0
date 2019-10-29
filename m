Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B441BCA9EB9
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 05:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85C9F2086A
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 05:46:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jg9q/Es/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbfJ2FqZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 01:46:25 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42404 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbfJ2FqY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 01:46:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id c16so7006938plz.9
        for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2019 22:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BGNnUOeOALjeswlQdNmg6H9C3q6EXqw3JZNkQRr1llQ=;
        b=jg9q/Es/BqriYOEAkxSEE33zkdwq115DyrEh0wvD3uy32lPbaiuOj2csLoIzevlL/r
         E/12mffycTgJCADXDoCpEOcJQ5N4b5hxQAx7qOgpmzLu61JycIz+8mfdaZo9G+8MQ7Am
         Vuhr0kE/FLTYqA321y7ShfNIzdWWPWTevpyG0WeuvYo0cQqJPSYH7yullEx722ZqFi1R
         8ZtondxROzQdSdqrSN8Bb3UVCnno4n8q9ksYgMMj1Cvij/9GsE35ZlHHxIbbEniuU91a
         wzyjFI3QyxKjyhFgtmoBy0FKTg9NUD7OKS+46Z6OyhcFWXPN9rQyG+ZNpVNJolCoo/jj
         /3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BGNnUOeOALjeswlQdNmg6H9C3q6EXqw3JZNkQRr1llQ=;
        b=lXl9iUBwNkak1CQHGG+CQht0I4DvA/z8vTdyCNJbdM+aSbuoJDtpqPZmgoj8UwMjGt
         vDEnOAnHtbLOT1E7+E9wgOGAEffuBvcBmSXaPCqoIkHilQcRyrHmAiCS0YFd4uJZd5GU
         8XmZ0m/xX4qNTduGTu9DfiuMruGBdw3jO4h10wxJfhofIsDmp5qKMwRF2iiTJGj+qyEr
         EkNisQEp46H3fuj/mOpI/d2ZtLa7sphXSKgjU7HBaB4sRtfnqEu8laks+z1kYfWaFUKC
         ahVtA4dsha8Ax+ydzO/Jpfksd/S2csQyWRNU2R+sWE6pkRZMKlG2hA3Qm+TS+8oRbFBY
         dT1w==
X-Gm-Message-State: APjAAAXiUvn+3W5ZOyYO0XZWs7aEYV6lKJ0RLkEd3lNRGYOijNZrCWSV
        vKKSsrC+gXEikrTXOK0+KG9tCw==
X-Google-Smtp-Source: APXvYqyE5mvnRddgHXGsZTDyiF3MennLWBuBLEfVle86PMhMeHbJJHz1zf8sDXGq6hU0pJqMCcXeZA==
X-Received: by 2002:a17:902:bd91:: with SMTP id q17mr1988190pls.43.1572327984016;
        Mon, 28 Oct 2019 22:46:24 -0700 (PDT)
Received: from tuxbook-pro (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id i16sm12546753pfa.184.2019.10.28.22.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 22:46:23 -0700 (PDT)
Date:   Mon, 28 Oct 2019 22:46:20 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     cang@codeaurora.org
Cc:     Avri Altman <Avri.Altman@wdc.com>,
        "Winkler, Tomas" <tomas.winkler@intel.com>,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Janek Kotas <jank@cadence.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] scsi: ufs: Add command logging infrastructure
Message-ID: <20191029054620.GG1929@tuxbook-pro>
References: <1571808560-3965-1-git-send-email-cang@codeaurora.org>
 <5B8DA87D05A7694D9FA63FD143655C1B9DCF0AFE@hasmsx108.ger.corp.intel.com>
 <MN2PR04MB6991C2AF4DDEDD84C7887258FC6B0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <01eb3c55e35738f2853fbc7175a12eaa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01eb3c55e35738f2853fbc7175a12eaa@codeaurora.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon 28 Oct 19:37 PDT 2019, cang@codeaurora.org wrote:

> On 2019-10-23 18:33, Avri Altman wrote:
> > > 
> > > > Add the necessary infrastructure to keep timestamp history of
> > > > commands, events and other useful info for debugging complex issues.
> > > > This helps in diagnosing events leading upto failure.
> > > 
> > > Why not use tracepoints, for that?
> > Ack on Tomas's comment.
> > Are there any pieces of information that you need not provided by the
> > upiu tracer?
> > 
> > Thanks,
> > Avri
> 
> In extreme cases, when the UFS runs into bad state, system may crash. There
> may not be a chance to collect trace. If trace is not collected and failure
> is hard to be reproduced, some command logs prints would be very helpful to
> help understand what was going on before we run into failure.
> 

This is a common problem shared among many/all subsystems, so it's
better to rely on a generic solution for this; such as using tracepoints
dumped into pstore/ramoops.

Regards,
Bjorn
