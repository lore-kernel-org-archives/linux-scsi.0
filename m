Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF39EC5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 07:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2298217F4
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 07:21:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hwsnDf6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbfKFHVy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 02:21:54 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:40962 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfKFHVy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 02:21:54 -0500
Received: by mail-pf1-f174.google.com with SMTP id p26so18158664pfq.8
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 23:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=q9xiyOz8nisyvsxRr+molaDdatyxI6EGvsQaqBiFwK8=;
        b=hwsnDf6w4S8L+w0LGIiLLS0lhRxfyG+FdWTGFmtSFg4KFa3XOHJZvHeZm3NUOQujOL
         I0Jlt9sgTEmt5mUzX5ynkscFvD1Ia9sb6ZxUqr16XxijfoxTO/vBzqZlARUpcD3gxmgf
         aRdNa8mNxSutjaQ9nGRhl4QSkO5gDfzjX3JrugN4vV5VW+n+5qlQYDjbSjiDQN74djqD
         vGZuS6TG8tuPrX2po19E9n8qnFzF/yJ1GbgWd2cI+FUIyOF+dQzp3IaWzSG1BfGKkFI7
         H31mxcw5sAOMTeC9/KgjKBa/+gBtC1tTlrKa8gu/EmIXhg606g3cL3+7FEMDgOkxT0kn
         XOAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=q9xiyOz8nisyvsxRr+molaDdatyxI6EGvsQaqBiFwK8=;
        b=OMfTn9HpgJfP4h5rdHHS6ev7n2bq21Dpb5Y+Dk+t1psxIXGQ0qRlngSLGuPChY3BRv
         yL5NIw1cnTAsWlLsQSPpQ/+puYFtatJ3wramX1JBBsoct9wZ7Ckv0cM1qypLD7qQ4Egp
         gS+Mtx6Twc3Cgqs248ncSnVFCWzezABn70ZmuU7tfjoEljdgwsbHaiiDq8T1yOJZS95J
         +PZJZGhWhBeWQLkv09v1OldbN30Q8Y9kOwAwaLMRFhQ2OMZr+dxeLCspTpQaIoh4xN7Z
         hBsjk5uYOeNW5ekyTqBdvChWrSupCL4ziBSCWPVc3lxDU0pqSMs0lkFEI+lKeHVcLfio
         +qAg==
X-Gm-Message-State: APjAAAXQLH3C4tDVe6Eh7fPScUgUw16y8aayYuoazoxmyBb+fikSG8Ap
        wsFTpxn1MmYdwgrTr7ZNY1vkyMfQ
X-Google-Smtp-Source: APXvYqxayhsIwhAWSLntusWEPh/0tXBOuUJBdJMiHPn860cXfVEhDuYVMS3uC3qChh74DitW2ojlEA==
X-Received: by 2002:a62:ac06:: with SMTP id v6mr1515955pfe.210.1573024913531;
        Tue, 05 Nov 2019 23:21:53 -0800 (PST)
Received: from [192.168.1.101] (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id s18sm5275692pfm.27.2019.11.05.23.21.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 23:21:52 -0800 (PST)
Subject: Re: [PATCH] scsi: scsi-lib.c: increase cmd_size by sizeof(struct
 scatterlist)
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
References: <cover.1572656814.git.fthain@telegraphics.com.au>
 <1572922150-4358-1-git-send-email-schmitzmic@gmail.com>
 <yq1h83h1rr6.fsf@oracle.com>
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        Finn Thain <fthain@telegraphics.com.au>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <fd48a151-ee0f-248c-22a3-abfffc2e1880@gmail.com>
Date:   Wed, 6 Nov 2019 20:21:48 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <yq1h83h1rr6.fsf@oracle.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks Martin,

Am 06.11.2019 um 18:46 schrieb Martin K. Petersen:
>
> Michael,
>
>> In scsi_mq_setup_tags(), cmd_size is calculated based on zero size
>> for the scatter-gather list in case the low level driver uses SG_NONE
>> in its host template.
>
> Applied to 5.4/scsi-fixes. I picked your version since it is small.

I realize it's more of a band-aid and doesn't address the real issue 
perhaps. Maybe it gives someone with a better clue about the block layer 
some idea though (I got out of my depth rather quickly).

> I still intend to queue Finn's SG_NONE cleanups for 5.5. In a way these
> are orthogonal.

Either zero or one work for sg_tablesize in my case, so that's perfectly 
fine by me.

Cheers,

	Michael

>
> Thanks!
>
