Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D622C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Apr 2022 03:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiDBDce (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 23:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345533AbiDBDc2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 23:32:28 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E9E1DEC32
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 20:30:26 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id f10so4001231plr.6
        for <linux-scsi@vger.kernel.org>; Fri, 01 Apr 2022 20:30:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lg9KaM4lkbZe+eaUOIh3MLXd6IlQpGSFJTkjM4h4xWk=;
        b=I/IbTv39OLNfkqVkhltRQNIneNyhlAPxbWHnFEGviDdjUYyKSuohQ/8ZMy1hW1CNz+
         sxYTV1/3+e9ZIg9PdtEnSBWvRT7LFOgp/xWOmryW4Vz65vP2x/G//CiXK9BbPY/X8H5p
         K5a1r/P8BJpJ9+b1ATu13Ar01HOwmkjsLfPLd27OyeHlvcS+XbdcmVUmHEdM1T+6516C
         gYwQp47urgxwzPYILhDWMgsQ6OLXKYvMAjjWOIFNOpJ8SX31m+HBm82024BTWz2RBoki
         H2LrbYf3+tH/fJa7lsLREc3QAjeBWEek2OuDLtIMDLqGUQ7grXcgUpQ6852SPuWsUSLf
         CKiA==
X-Gm-Message-State: AOAM53300/e7cWlDSar6VuKQFDhZfxNRikz3D7NUvxYZQU4VZ29MqSlj
        94Q57AEHlf8i+sF9P6lI4sOtqgTPTsU=
X-Google-Smtp-Source: ABdhPJzSFQXPfI49a16S4qjG/24mqPjzsnvh8nT7Z8a1AZ7yShzRJVskgImpsHZlyZAIk24YFSU/ug==
X-Received: by 2002:a17:90b:3689:b0:1ca:679f:43ca with SMTP id mj9-20020a17090b368900b001ca679f43camr110732pjb.133.1648870225746;
        Fri, 01 Apr 2022 20:30:25 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id ll19-20020a17090b21d300b001ca2a4777a7sm3750587pjb.19.2022.04.01.20.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 20:30:25 -0700 (PDT)
Message-ID: <44dd7d76-1f9a-3fc2-78e4-f3456600ba85@acm.org>
Date:   Fri, 1 Apr 2022 20:30:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] drivers: scsi: alloc scsi disk ida index before adding
 scsi device
Content-Language: en-US
To:     Jianguo Sun <quic_jianguos@quicinc.com>, linux-scsi@vger.kernel.org
References: <20220401005928.24140-1-quic_jianguos@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220401005928.24140-1-quic_jianguos@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/22 17:59, Jianguo Sun wrote:
> Originally, we alloc ida index in scsi driver(sd_probe) asynchronously,
> which may cause disk name out of order and in turn cause rootfs mount
> issue if we set specific disk mount as the root filesystem by parameters
> "root=/dev/sda6", for example.
> Since the scsi device gets added in sequence, so we change to alloc ida
> index for scsi disk before adding scsi device.

Specifying a /dev/sd* device name as root device is wrong since such a 
name will change if a disk is added to the system or removed from the 
system. Please use one of the /dev/disk/by-*/* names as root device.

Thanks,

Bart.
