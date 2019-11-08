Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB52FC6196
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 22:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F753214DA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 22:36:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kgPh4G9B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfKHWgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 17:36:53 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36984 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbfKHWgx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 17:36:53 -0500
Received: by mail-wr1-f68.google.com with SMTP id t1so8753753wrv.4
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2019 14:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qc6CfW6p5miBbAUa0RGWy4g9EUQnbZw6jUICSmg+D24=;
        b=kgPh4G9BQIho8sscqW+2FfM2954AFGx6D/tSFxftIZI3/nDQR89NmeotvFbG5GUjgX
         9qSELGByoScz7hm7aSvXM4Wo43NBCRNR4OWkZYwB+MCGzicdvMy2fLe10lVq5cds6AvX
         69iaJkLtqbJxlOvNxSj64Hi5QqpRF1YxAZ5LyH2vS/96QqqHhBdyIwFB4hB+Xfwv0L6O
         OJ98P7ux+9ugNp7A+3BCQJjhV67xPalRHhR2G/r5LnFwirxUXJYQc85rSIRCuV8YQnzQ
         m/B0z5yV84l6YUTRDkXilzKsNBsxONeVnk1DQ22fPDd6R2JXi6Cn04Za6TquCxE1uR9C
         IEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qc6CfW6p5miBbAUa0RGWy4g9EUQnbZw6jUICSmg+D24=;
        b=exGk1z7BDLjK9xZfdSIsgxoKgj5RlGo91eTfBp6Oe3M7wYBlNV91BwCD2Yql8oShoP
         Ct2xNgoh/0DrHu2fLZs41/W4XyRPn6LEZUFf5+o8jec3sU6zgPaJRVCZtj31+oD4J4xz
         x+2P7sJQahm4sW9nLw4E6VYPcqTRhMPG1s9flA1xVk6XY3y4zcg9Ic+Gg84eJoyna0Fi
         C65dEkhlshO3jS8HgXQ3l69oTtrjbW6BjNYP5tMy2XhCIZfjOopD0nGMiPLLsOT4adzx
         Ip7MIS1M1+zUfmJpnp04kO8XZMR7C5JCiNRoAj34co05g4EXODkV9Pj1jPZf+UpuNMlE
         ADQQ==
X-Gm-Message-State: APjAAAXFSs1sXpF415kHBdbyNdFRks4OeUB/3qcuP4bak6tw5gqdxu5v
        BgSPBSHNX4dNtJFBej67rSIA4p+3
X-Google-Smtp-Source: APXvYqwcgfFQoaE3FG7CIvGKI1UxFyBWxRn+OZMLHa3/mdme01Cs4gy1cJh8o5ab+dxOeTv5gGjoDg==
X-Received: by 2002:a5d:4c4e:: with SMTP id n14mr11595184wrt.260.1573252611286;
        Fri, 08 Nov 2019 14:36:51 -0800 (PST)
Received: from [10.230.29.90] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w18sm7809890wrp.31.2019.11.08.14.36.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 14:36:50 -0800 (PST)
Subject: Re: [PATCH 1/3] lpfc: Fix a kernel warning triggered by
 lpfc_get_sgl_per_hdwq()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org
References: <20191107052158.25788-1-bvanassche@acm.org>
 <20191107052158.25788-2-bvanassche@acm.org>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <fbbf0fc4-2d29-8268-90b1-8b7a5b1e6d2f@gmail.com>
Date:   Fri, 8 Nov 2019 14:36:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191107052158.25788-2-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/6/2019 9:21 PM, Bart Van Assche wrote:
> Fix the following kernel bug report:
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: systemd-udevd/954
> 
> Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>


Looks good - thanks Bart

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james

