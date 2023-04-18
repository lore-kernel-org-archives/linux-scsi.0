Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D6FC77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 14:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjDROGc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 10:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjDROGb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 10:06:31 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E1283D4
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 07:06:29 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-63b5c48ea09so1820435b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 07:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826789; x=1684418789;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HjrbNtSUKqBsWa4QNihfMJxcXMU+qB3++F4sWPCgfTQ=;
        b=hmh/L7jOtmadqBLpzMJaL7KoGxwXpyeS3RGMbw5wwkkYMRcpBC4x9UiR3EljF1ZAVr
         IMCyiFq/FWM9KPXYFJD2mnhHdJ2VlVwm5IejfL+AyfTl+s1tqkUFFP2spzzsD3bluguR
         9lpvhe+1LxKPLaFw39OQ5RopVEAwO1eEA+k3O7jbUdo0FXKo+m1fGmv8+DIsfwAMu3qk
         sog+FMI6ureJ0y0KHMLKXO1Ot/92zSFp/DVp4rbLu+Hu5YGY+I5SgYEiGIBEjFqIqY/9
         X/l4gQjbG7K1daIKTO2g1VotMq5cfLLZSGj0o77SEdagRfAIeKTqZMXWnz5qx9m/Hw7U
         Xmkw==
X-Gm-Message-State: AAQBX9ct1HOccaWD1jUttJdmj3MNdOeSx7ZQMBvqITCRuqxZn5TXDKSh
        4qj/cDQGdfDLuy4CFscNy5dMWD6XHWU=
X-Google-Smtp-Source: AKy350bPf8lPor58zviwd5kBfkaDOQo678PpjCPpZnF2leC+z+IjY428dVtuMGokuyT1gKnhEw7K3A==
X-Received: by 2002:a17:90b:2382:b0:247:af63:483 with SMTP id mr2-20020a17090b238200b00247af630483mr1996515pjb.46.1681826788795;
        Tue, 18 Apr 2023 07:06:28 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j27-20020a63fc1b000000b0050f9b7e64fasm8898293pgi.77.2023.04.18.07.06.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 07:06:28 -0700 (PDT)
Message-ID: <0a2af553-9b37-d7b4-2fc2-6185c64e8663@acm.org>
Date:   Tue, 18 Apr 2023 07:06:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 2/4] scsi: ufs: Simplify ufshcd_wl_shutdown()
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        Asutosh Das <asutoshd@codeaurora.org>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@google.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
References: <20230417230656.523826-1-bvanassche@acm.org>
 <20230417230656.523826-3-bvanassche@acm.org>
 <74088d26-ac26-15ba-86a0-65d74a426a9c@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <74088d26-ac26-15ba-86a0-65d74a426a9c@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/18/23 06:45, Adrian Hunter wrote:
> On 18/04/23 02:06, Bart Van Assche wrote:
>> Now that sd_shutdown() fails future I/O the code for quiescing LUNs in
>> ufshcd_wl_shutdown() is superfluous. Remove the code for quiescing LUNs.
>> Also remove the ufshcd_rpm_get_sync() call because it is not necessary
>> to resume a UFS device before submitting a START STOP UNIT command.
> 
> What about the host controller hba->dev?

The above question is not clear to me. Please elaborate.

Bart.

