Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4FCC43219
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 01:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 270D06322D
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 01:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354346AbhKPBjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 20:39:25 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:33564 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241897AbhKOSbE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 13:31:04 -0500
Received: by mail-pg1-f176.google.com with SMTP id 136so10671594pgc.0
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 10:28:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d7mvUBbug97bc+6fGkESCOm35zr0TE5CbSyDckSF5Yc=;
        b=77hoKzIyo4wk4rbwObT1gfocYAWxOdJ5kI6mKYGLyDMA9j71JzAnZQ8mKsH0Chz4U0
         UhVxtBaZd5SkYOtTriW+8n5Fi+orDVK4Qf+xpD4V4yavyFcYoQ/nRxyW0rnXAy93BkV0
         jfdvB1kWPGHck+05olqMDl/XMga2d3onkJuGbHyhKMUpO2B8WFgwmLNCj4cEy4COcvUe
         Ago806MnFelDoSEWoea7II7emrWqY6W2QP2x5Oq7+LmtXV/gdgvH6yC7oTyq1Q7/vS3p
         GEsPOds6wib7AYYYxFXQ4ec/1DuGNTMmo7+pVszSa+SB+d1lSOoBDuokoneICXxQreS4
         yWvQ==
X-Gm-Message-State: AOAM531feW6XmIBnjSNBMOW4HZCqt3cjqRHbM6HNjQDJsoG3nKHi5WkF
        jja6D2MgVbemrZeXunNdNlg=
X-Google-Smtp-Source: ABdhPJyeGnQ9C2vReNz0NKkLDDWObAHS07j0xGRP1+6am9FAvnlTNKD4Np4ToHoykgldgbrox30C4A==
X-Received: by 2002:a63:f34c:: with SMTP id t12mr648483pgj.70.1637000889133;
        Mon, 15 Nov 2021 10:28:09 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c779:caf7:7b7f:3ecd])
        by smtp.gmail.com with ESMTPSA id k22sm15205098pfi.149.2021.11.15.10.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 10:28:08 -0800 (PST)
Subject: Re: [PATCH 07/11] scsi: ufs: Fix a deadlock in the error handler
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-8-bvanassche@acm.org>
 <YYtp1OSKI3w9dRvh@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c70eadbb-9bdd-f3d5-07e8-da02d2e120c9@acm.org>
Date:   Mon, 15 Nov 2021 10:28:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YYtp1OSKI3w9dRvh@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/21 10:42 PM, Christoph Hellwig wrote:
> as pointed out last time: LLDDS have no business directy allocating
> tags.  Please work with Hannes and John on the proper APIs, as metnioned
> last time as well.

Hi Christoph,

I will do this.

Thanks,

Bart.


