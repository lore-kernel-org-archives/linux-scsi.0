Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA573C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 17:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244640AbiA0R2d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 12:28:33 -0500
Received: from mail-pl1-f176.google.com ([209.85.214.176]:43662 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244628AbiA0R2c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 12:28:32 -0500
Received: by mail-pl1-f176.google.com with SMTP id d1so3049538plh.10
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 09:28:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fKn2T3RGBDKrPW1aW1ov5RQwzzFFLefJI1zi9HQ74vU=;
        b=im49XeEajyS2divCwbBpqwyW/z/A7HGFQK9A0zV4CSAyHamfkghl1XChr2E7u07mUo
         5s5Mo2SZFFWVIlRTSjNLYZj0ypoumYAcXPRlFCPR7aprWlAg8tOb8RVDG8EcsVnFNthy
         F+20AK4AcVKdSfSAVxfG5O4nEhLkpJ2qZm2VpEaWRzC8UuKhl2U0JLjauaMEu19whATA
         4S993ZOPRR0zz0yLk/jVNVpyp97VXxaNfx1B5BEHZLmeYUHCnPIPq9UZ8sp6op545AYK
         Y3l3mvH3iam+drqeyG1626BTWbLt9w8vqPe6RBYODGUZeceMVl0+xKnKq1EMhY3Cg0Gx
         Onxw==
X-Gm-Message-State: AOAM532PtmqEu85HG7zuU39VdYK31bWLaJkH3gW+lIClF1OQZkeCxulc
        +DV+OxGnzKWCujRTg9aCLXU=
X-Google-Smtp-Source: ABdhPJz/y7HD+tgv2BlVuFBpEEzYyuuIUaPXea6FIbpmXEFp6zgmvRI432mD/oUTkt6zRdlfpZnVNw==
X-Received: by 2002:a17:902:db01:: with SMTP id m1mr4430797plx.25.1643304512192;
        Thu, 27 Jan 2022 09:28:32 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id a14sm6922652pfv.212.2022.01.27.09.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 09:28:31 -0800 (PST)
Message-ID: <4aa8727e-a183-a1f9-8291-624ecb5e6d25@acm.org>
Date:   Thu, 27 Jan 2022 09:28:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH] scsi: make "access_state" sysfs attribute always
 visible
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org
References: <20220125162441.2226-1-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220125162441.2226-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/22 08:24, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If a SCSI device handler module is loaded after some SCSI devices
> have already been probed (e.g. via request_module() by dm-multipath),
> the "access_state" and "preferred_path" sysfs attributes remain invisible for
> these devices, although the handler is attached and live. The reason is
> that the visibility is only checked when the sysfs attribute group is
> first created. This results in an inconsistent user experience depending
> on the load order of SCSI low-level drivers vs. device handler modules.

Isn't this something that should be fixed in the sysfs code rather than 
in the SCSI core? If this issue affects SCSI I assume that it will also 
affect other sysfs users.

Thanks,

Bart.
