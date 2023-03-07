Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15378C678D5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 16:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjCGQqO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 11:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjCGQpx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 11:45:53 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFF9869D
        for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2023 08:42:57 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id y2so13802113pjg.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 Mar 2023 08:42:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678207376;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wp3pysIsVjQ4D3eOZdizcghq6e4s7X+y5GfTSubEiVk=;
        b=uChoGKp2r6xBmNpBG26rw2pgsk1WijEYnCgPL7+oEJJqs0zle2P6AOB75mUSLzH4iI
         F/g71laxFbL5XPxkg+yUkFR/5e7xPR/DCrYYqpCWSXHMjXLDXsH2m0BqIsxezvI3Buio
         Qydn5T7Of2FSTUyhEPuZRlM8KOBbOocix4nan6m6GASZRy6VlnvcLtMV2H9IMAgtpMVx
         ajNcBvV+ZL9P5I6zLHdFvyUm+xT+QAgGex+MT0BjltBILBnqREL3/RFZO0Ey5FkL56Jd
         VCmABW//vAhTEUCtHvSvTB5gnwMBFXYT1E77WImFqu2ze673CYznHtbTqriTraOPjAg/
         4+hw==
X-Gm-Message-State: AO0yUKVLdHYB1SIxg28Y8xcyG9vvVLOwAR0KO4L80XdXNbn/FGzH9O8O
        4aIswPDk8xOGdLmtcOXfX7s=
X-Google-Smtp-Source: AK7set9H+AVOM1ik4MNk49G33HFY9venHe2vAdGmlHCNFBytFEscvDU/PQZxbqCNiNWxBHDgAVHAAw==
X-Received: by 2002:a17:90b:4d07:b0:23a:87cf:de93 with SMTP id mw7-20020a17090b4d0700b0023a87cfde93mr13802243pjb.15.1678207376383;
        Tue, 07 Mar 2023 08:42:56 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id fz3-20020a17090b024300b00233567a978csm9420494pjb.42.2023.03.07.08.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 08:42:55 -0800 (PST)
Message-ID: <64e7578f-2711-c715-a3ff-83660fe6819e@acm.org>
Date:   Tue, 7 Mar 2023 08:42:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 0/2] Remove the /proc/scsi/${proc_name} directory earlier
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
References: <20230210205200.36973-1-bvanassche@acm.org>
 <ed6b8027-a9d9-1b45-be8e-df4e8c6c4605@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ed6b8027-a9d9-1b45-be8e-df4e8c6c4605@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/23 07:08, John Garry wrote:
> Is it related to this series, do you think?

Probably. I'm not sure there is an alternative to reverting patch 2/2 
from this series and adding a wait loop inside
scsi_proc_hostdir_add(). Adding a wait loop inside 
scsi_proc_hostdir_add() might be controversial. Anyway, I will look into 
this.

Bart.
