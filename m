Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57382C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 17:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244458AbiA0RTr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 12:19:47 -0500
Received: from mail-pj1-f41.google.com ([209.85.216.41]:34725 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242179AbiA0RTq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 12:19:46 -0500
Received: by mail-pj1-f41.google.com with SMTP id l24-20020a17090aec1800b001b55738f633so5512532pjy.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 09:19:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=haguw7H7MAwxfuq316VyqQ9YBJdcgPd0gYRQZ7OQpPk=;
        b=pMeL1KDif0QWe1dwoqcFNjxOgkCJ/hMhuLKP8Xs6M/n4CDyyGKIWPfb4W1AwNKZto/
         tFPZ5j8h4UIQE3cv8v1+lnb3Qw14KrxdKNE0NC+y3NbNTI/MoiDbadbJmAEKT4lrLKlE
         ELoVi0URGONuY1vmj4DVGEuYNz0916th4Iw44kuDIApjWVhBCY5FpczQ2cs7SeuYnehu
         7CeivKWoqsj7Uc608srGAsyDID7T4yx5tOXx4/tIo7Whj/+Mu5ACVYk23GaVqA1KT6nK
         NYvpJvNCkrGto8mB0bDWI/T/2RPfsm6i0/CIz/Vlnsu7p6WHKDNGWlOgy6t2K6DkW6nW
         qmAg==
X-Gm-Message-State: AOAM530h4f87ZpO92pE1iZ/fb4BjOOJPTz7wwLrfMiSoR7qUwxQ/EYB3
        iSxGfImX7wSG6OIouiY+YDs=
X-Google-Smtp-Source: ABdhPJweC8G2tuIKJa7rhucBGG6gwY0rbcI2utGPLxZ7vUrO2JtVDsACCpesGpJnkXJJUsBVRuHIiw==
X-Received: by 2002:a17:903:1207:: with SMTP id l7mr4048575plh.19.1643303985659;
        Thu, 27 Jan 2022 09:19:45 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id i14sm5465523pgh.42.2022.01.27.09.19.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 09:19:45 -0800 (PST)
Message-ID: <531f08fb-b49b-91bf-8e8a-52492e69d6b9@acm.org>
Date:   Thu, 27 Jan 2022 09:19:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH V2] scsi: core: reallocate scsi device's budget map if
 default queue depth is changed
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Martin Wilck <martin.wilck@suse.com>,
        Martin Wilck <mwilck@suse.com>
References: <20220127153733.409132-1-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220127153733.409132-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/22 07:37, Ming Lei wrote:
> Martin reported that sdev->queue_depth can often be changed in
> ->slave_configure(), and now we uses ->cmd_per_lun as initial queue
> depth for setting up sdev->budget_map. And some extreme ->cmd_per_lun
> or ->can_queue won't be used at default actually, if they are used to
> allocate sdev->budget_map, huge memory may be consumed just because
> of bad ->cmd_per_lun.
> 
> Fix the issue by reallocating sdev->budget_map after ->slave_configure()
> returns, at that time, queue_depth should be much more reasonable.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
