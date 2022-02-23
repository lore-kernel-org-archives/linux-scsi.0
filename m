Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59725C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 23:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244000AbiBWXlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 18:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239107AbiBWXls (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 18:41:48 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995B35AED2;
        Wed, 23 Feb 2022 15:41:19 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id m22so474575pja.0;
        Wed, 23 Feb 2022 15:41:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Kb9bID2WTY4EMZehoHcvycZG/UfuyjtbPXehs48y9Gk=;
        b=xVQIy47TxhthChA0dpNzukGt0kOGl9WKILD2DtUJdyD0cV37EraZ75zmAi+Har1Pm0
         h/NQSQs5vzJ2upKlGZTAGiXLocfLvlElli0dlx//9lh/tdPnJEwXf+Go0BwqYHeH1Oyc
         fsAcP/dIb9DnVu26Dgx9cvyIUbZulc2Si9BqzAx6xuc5wp6gNUNQ6hEyYKe2zcOkgixT
         rVspTdMiOWd+sOsJENh2X7Ob4mnXvTNhNFpgrOxZ8RDbsAm6dMibfhZyNSNSiPCIAOwB
         NZDJb1fgYMialc+FrEky3MRWpKOky31bjHrdNOsU9I7WvBmjoeJddn8JCuLgyEke65ut
         LqNw==
X-Gm-Message-State: AOAM533prcuxdGiyL/M80fuyBEH3e3xT6cFVjRc/lAmHw+dWVJT0Gf66
        hATA8gA+1DGg50390r4ga7w=
X-Google-Smtp-Source: ABdhPJzdElw9lVZNq1yKlvCwcQhSIUMJDA+1KEWIvDXeV0RL/mNRiOkjRfzQdpbit/oBKZ9y5EehuA==
X-Received: by 2002:a17:902:e80c:b0:14f:f95c:41ee with SMTP id u12-20020a170902e80c00b0014ff95c41eemr1825219plg.31.1645659678990;
        Wed, 23 Feb 2022 15:41:18 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id fv9sm581914pjb.7.2022.02.23.15.41.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 15:41:18 -0800 (PST)
Message-ID: <4365922e-b687-2438-4eea-b199971acb8b@acm.org>
Date:   Wed, 23 Feb 2022 15:41:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 6/8] scsi: move the resid_len field from struct
 scsi_request to struct scsi_cmnd
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220222140443.589882-1-hch@lst.de>
 <20220222140443.589882-7-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220222140443.589882-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/22 06:04, Christoph Hellwig wrote:
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 47add5b32f460..5ff0a6e8460c3 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -111,7 +111,7 @@ struct scsi_cmnd {
>   				   (ie, between disconnect /
>   				   reconnects.   Probably == sector
>   				   size */
> -
> +	unsigned resid_len;	/* residual count */
>   	unsigned sense_len;
>   	unsigned char *sense_buffer;
>   				/* obtained by REQUEST SENSE when

Same comment here about "unsigned" vs. "unsigned int". Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
