Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716ECC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 16:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EFCC2076E
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 16:29:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UC07IQQs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406078AbgFYQ37 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 12:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403828AbgFYQ36 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2020 12:29:58 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D9AC08C5C1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 09:29:58 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id j1so3253880pfe.4
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 09:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ebU4qHg/VNhE7r1qxpVWicIZ1GxxkOMdsMwUJ1vwVqM=;
        b=UC07IQQsfXvIVchBOPlYABhAYrCC+Up2cO2dfIpmOl2CuDgtdiP+LoOA/MzHQuzy9z
         P1zzMbNslkYVUmgVCRs1MVKn5DE2mnA0OSbAkW/2vkW4rPFJJnshJGKxkphNro8OZqf+
         noyFVYTSn/iiJun4sZWDaWQ10gMNaTAVxUh34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ebU4qHg/VNhE7r1qxpVWicIZ1GxxkOMdsMwUJ1vwVqM=;
        b=oflpitXwndArQEniBozVlgqDJispsUom8OKliPCROdJXrzWSFpCQa2fSKQcIWRh1Iv
         lxiKDMv4v80n1AHPKsNVnKVyus7YszdSpflAp0+vpYi3MSzfsBYdcEigi+5NsM1umc9/
         ZfxUjiIqpNgdSwDoMDxrkchQFV4cGjO8Um8gfuBi7uo9wiSa4ECN057HZFI9w632rGhL
         SOqVNX8FViZ0wUgFStqUu8zLbk94Y/GbtxnJds6YIBiBcNKcqKaHty950377wczHxbAF
         TV3AlRyedN092XKzwsRMCirZRFTwwDFU0LtJlsq2xFzfFYDeC+X1kIYgB38Ick59lMw0
         LLsQ==
X-Gm-Message-State: AOAM532fkOLEcAtdKf+Nk8NybQDg0JfvlNAUqjg08qxHc4fN7thqemco
        5f+VtKiKxUZaMiaikqH/G1SQIg==
X-Google-Smtp-Source: ABdhPJyOjhhcC7BjIpmP6YXaZ7WJQTQcg+CzI1hxZvUpbTsgPIlEiY3wKcnXBOuJoSMl+ygUBSbYZQ==
X-Received: by 2002:aa7:9599:: with SMTP id z25mr36604327pfj.176.1593102597921;
        Thu, 25 Jun 2020 09:29:57 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y69sm24765839pfg.207.2020.06.25.09.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 09:29:57 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] qla2xxx SAN Congestion Management (SCM) support
To:     Shyam Sundar <ssundar@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
References: <20200610141509.10616-1-njavali@marvell.com>
 <B39919CA-5C0A-4792-9327-0D50DF8AD2F3@marvell.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <76477ad6-9122-1660-4039-1aee17226065@broadcom.com>
Date:   Thu, 25 Jun 2020 09:29:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <B39919CA-5C0A-4792-9327-0D50DF8AD2F3@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

yep - will do so shortly

On 6/18/2020 3:46 PM, Shyam Sundar wrote:
> Hi James,
>      Could you please review v3 patch-set and let us know if it looks appropriate.
>     
>      We should be sending out the next set of changes (to FC Transport) in the first week of July.
>
> Thanks
> Shyam
>

yep - will do so shortly

-- james


