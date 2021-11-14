Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7458FC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Nov 2021 00:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4860E61106
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Nov 2021 00:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhKNAaj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Nov 2021 19:30:39 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:34305 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhKNAai (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Nov 2021 19:30:38 -0500
Received: by mail-pf1-f179.google.com with SMTP id r130so11672403pfc.1;
        Sat, 13 Nov 2021 16:27:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+oBTOAeAOBo/l6duXeY1ufFCIwljJ+hfBntn1UB5fUs=;
        b=8MiYvIqHMRCl6O5S/F1TKzue3qieWNmTVc77NmDIcWHGbxdFd1oLILfQZNF9vAo8v4
         g8wpvNRYVKOUfoquybIKLMWw4zz69jag7llenPSzg2HmXm7TN94DIXIYXOwazx6NoVkl
         dzGEDk1Nos00nisj02jHck78Aav7BhR9WEk9tr+pUj4oHEkqZtVo3Uouu9Q9zjm1PjjB
         kctN5e5Ab+TMmD3rUTKdnf8lFR05gIFVVS4rfKYfmzYn7NuwHWUqIwTJJ+jKT3ckYZDj
         I6oNQt2aUxECQwYIivjJEAcv9gJLn6d6f4L289Z7FNG5Ppk9S3TF3CUdE2a5JRzRaLtH
         FU3A==
X-Gm-Message-State: AOAM533uWLO2P0e4odvnnuRMpfairqN2zlQhcl0LX+D81BukPXd5URDA
        xDSSlSUO7LAqa5iTPr9f9bM=
X-Google-Smtp-Source: ABdhPJzEqs+gA4zXLA79ik0+E6F9PReOJA0XW3hPLl0Hmpn8wlmZ5GZ3QYBu3fE9mkRWuvWXtJTukQ==
X-Received: by 2002:a63:3348:: with SMTP id z69mr17542430pgz.177.1636849665301;
        Sat, 13 Nov 2021 16:27:45 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t4sm11199537pfg.155.2021.11.13.16.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Nov 2021 16:27:44 -0800 (PST)
Message-ID: <a18f709c-9674-31a5-68ac-a61ca9d8c94e@acm.org>
Date:   Sat, 13 Nov 2021 16:27:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v1] scsi: ufs: ufshpb: Fix sparse warning in
 ufshpb_set_hpb_read_to_upiu()
Content-Language: en-US
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org,
        daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
References: <20211111222452.384089-1-huobean@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211111222452.384089-1-huobean@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/21 14:24, Bean Huo wrote:
> -		ppn_tmp = swab64(ppn);
> +		ppn_tmp = (__force __be64)swab64((__force u64)ppn);

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
