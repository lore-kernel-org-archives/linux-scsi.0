Return-Path: <SRS0=QSS4=3W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDE3C3524B
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 19:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3E6B206D3
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 19:21:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZ/7jAOP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgBBTVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 14:21:09 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40644 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgBBTVJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 14:21:09 -0500
Received: by mail-pg1-f195.google.com with SMTP id k25so6584326pgt.7;
        Sun, 02 Feb 2020 11:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WhbyccFYxDUetkxi0lachTOu0Psik/R8xkRSrrDTrL0=;
        b=mZ/7jAOP/h6yiWmdHyEHMv0HBowYNttgAeAUTXLAm6ezCPizNZdVjJOyrwdBl8ZxcE
         5CH/0sq9hlUJ+Gkc92w8zYXXP7/bEE5bbvAhFW/lN0wa3lVP40KJkS1AnxD6DnPL8etL
         4WafobsrnwBFIjQbOs1rXo8iDuE3V5/G3wVYgZZaScqNyfAEBf/KVoqj390RMzBbMIj0
         MP/uMRfuxOaWt2ZLgQy+GqzO/zqns9n1EdgCVz2e/kcWp43W5hoDKFYoUvDIVTUZLnQb
         //kcVt5fD6PxZKL/Ga9FN2PzUasEx1hvnnZGwS5c/awOyc1va2DQi5NGmhV2VmsLF6lG
         yScw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=WhbyccFYxDUetkxi0lachTOu0Psik/R8xkRSrrDTrL0=;
        b=jFcbdr4qAXIB16CWtEfGs1qJ6uPiHXbD1QWw+Vl+QGgv1/GlE2a6pggPxFVTepo1JH
         UMmOiMhKfU0iRk4uG97BWoQ29BJ6O/JCqEjqyGCA6jF1ZR9J4UbGZyUEjL7Nfm+sVQmL
         wzD5q3RJsfuBcXJU6b3EUIbHWKaJnnZrwyq3KzGzG/NAoURJWZ3F9djliVzbLcItXrSK
         +3ICa+IBjzTzVCnu10JAFGB2EdfnQvCwHEKe8UCrM1CiqsZc/gf/CjLINmIm+5XcTbz5
         eSwo/mEETXfCtNnLNWZh4NWvWuRDEOPSfBxcpaxdZygp+V5t8VQQlWDyAWJmUtkVVeQd
         9Tow==
X-Gm-Message-State: APjAAAWVqxZ5H4y9Md2bUG9IV32dolwWndz7DUY7AjGXMrx8JAovXVj1
        cd6bBvUNjy4q6m9dbufAbSo=
X-Google-Smtp-Source: APXvYqyYXeyjbiJcsLHIWb5ki4uiBDYotuR0yEOcYTlwSGD4OCJXfT+R+988pdmOjkfqMnSJXII8Tg==
X-Received: by 2002:a63:ba43:: with SMTP id l3mr7078662pgu.120.1580671266991;
        Sun, 02 Feb 2020 11:21:06 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i68sm17605873pfe.173.2020.02.02.11.21.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 02 Feb 2020 11:21:06 -0800 (PST)
Date:   Sun, 2 Feb 2020 11:21:05 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Avi Shchislowski <avi.shchislowski@wdc.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Message-ID: <20200202192105.GA20107@roeck-us.net>
References: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580640419-6703-1-git-send-email-avi.shchislowski@wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Feb 02, 2020 at 12:46:54PM +0200, Avi Shchislowski wrote:
> UFS3.0 allows using the ufs device as a temperature sensor. The
> purpose of this feature is to provide notification to the host of the
> UFS device case temperature. It allows reading of a rough estimate
> (+-10 degrees centigrade) of the current case temperature, And
> setting a lower and upper temperature bounds, in which the device
> will trigger an applicable exception event.
> 
> We added the capability of responding to such notifications, while
> notifying the kernel's thermal core, which further exposes the thermal
> zone attributes to user space. UFS temperature attributes are all
> read-only, so only thermal read ops (.get_xxx) can be implemented.
> 

Can you add an explanation why this can't be added to the just-introduced
'drivetemp' driver in the hwmon subsystem, and why it make sense to
have proprietary attributes for temperature and temperature limits ?

Thanks,
Guenter

> Avi Shchislowski (5):
>   scsi: ufs: Add ufs thermal support
>   scsi: ufs: export ufshcd_enable_ee
>   scsi: ufs: enable thermal exception event
>   scsi: ufs-thermal: implement thermal file ops
>   scsi: ufs: temperature atrributes add to ufs_sysfs

attributes
