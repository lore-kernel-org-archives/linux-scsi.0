Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EE3C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Nov 2023 18:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344960AbjKISHp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Nov 2023 13:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344973AbjKISHm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2023 13:07:42 -0500
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED063ABC;
        Thu,  9 Nov 2023 10:07:40 -0800 (PST)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6b87c1edfd5so1052390b3a.1;
        Thu, 09 Nov 2023 10:07:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699553260; x=1700158060;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eStIukLDwVRs0NdOG0eWSihEj+JWFkSPCspPqDFsx18=;
        b=DplFm5+5ffiWL62aJVWRp5bLW/c3H4Y/irif+3kpUa3LAPXociw5ci4B38X8Yk+iup
         2y2gu44ChuwCoccQl1FBM9feswWwUgCz/GeqNTRBgzhhJI/rdkIAeJrXHztTRn9pOqP8
         0BmAyN0Vb/IHdzKd4ReitGdN+FoeA0wAS+9SZFkGz/UQSZBzxyNA9cWjh9b4dyrqvc4g
         dLyE5doiL75hg8TegwGJKIZHpF+tlE5u7ugWXmekpYTOpIuPCXzqUdQU2oC25eXUsOq/
         KeeNA8+LyjyUwaFE1PbnGANCAg/JegruF/6Wol4LSCRRFtWo7xYWeFQ4/2pLHJDJjr0o
         k4Eg==
X-Gm-Message-State: AOJu0Yy5RTPxzknk9j4GPvWsZIqL++TSB+i98RAEXYUuxNDiTf8CVfXh
        Vs2rKACglHzZeoOfHBAde70=
X-Google-Smtp-Source: AGHT+IHJzmjo7TzUvLHaJncTi1tfd8YCCm59JcgLS86tixJvspnrYOmUNA8LuwVhBsbF2heWBzl8ZQ==
X-Received: by 2002:a05:6a20:ddaf:b0:17d:d70f:a2c4 with SMTP id kw47-20020a056a20ddaf00b0017dd70fa2c4mr4704622pzb.26.1699553259798;
        Thu, 09 Nov 2023 10:07:39 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:3dcd:f87f:1890:c48e? ([2620:0:1000:8411:3dcd:f87f:1890:c48e])
        by smtp.gmail.com with ESMTPSA id ff24-20020a056a002f5800b0069337938be8sm10932129pfb.110.2023.11.09.10.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Nov 2023 10:07:39 -0800 (PST)
Message-ID: <fb80565a-9b91-4125-ac50-f8469f27c3b8@acm.org>
Date:   Thu, 9 Nov 2023 10:07:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] scsi: ufs: core: Add sysfs node for UFS RTC update
Content-Language: en-US
To:     Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        mani@kernel.org, quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        beanhuo@micron.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikebi@micron.com, lporzio@micron.com
References: <20231109125217.185462-1-beanhuo@iokpp.de>
 <20231109125217.185462-3-beanhuo@iokpp.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231109125217.185462-3-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/23 04:52, Bean Huo wrote:
> This patch introduces a sysfs node named 'rtc_update_ms' within the kernel, enabling users to
> adjust the RTC periodic update frequency to suit the specific requirements of the system and
> UFS. Also, this patch allows the user to disable periodic update RTC  in the UFS idle time.

Why is this behavior enabled by default instead of disabled by default?

Thanks,

Bart.
