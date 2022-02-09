Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51140C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 23:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiBIXh5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 18:37:57 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiBIXhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 18:37:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3780FE0559A2
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 15:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644449877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kf3bIlJM2TDn95wMjKX0UZ0D8Tc7kogiS7TleanbveI=;
        b=RlBOQkmsPA7V6C+1Od1U08RIMRD0VvTHS1lhPWauflJ68e158lbNJRF1d0K7e/xgGcnM2X
        Wyx+mgtSNIoCiLfwrwNJPBnzk8nU+QhR3TFFE1Qa9DBVd1RWvel5hzJrxY4yNFSdAgtuwg
        pNxTSPMjQNTkxaWKZ618se30/cl91fk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-tlfjDqk6MM2UoH7VnGGyxA-1; Wed, 09 Feb 2022 18:37:56 -0500
X-MC-Unique: tlfjDqk6MM2UoH7VnGGyxA-1
Received: by mail-qv1-f72.google.com with SMTP id jn13-20020ad45ded000000b0042c3394cafaso1687906qvb.22
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 15:37:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kf3bIlJM2TDn95wMjKX0UZ0D8Tc7kogiS7TleanbveI=;
        b=xhilTjGUKaSa4tb25hvoXSnkq8gjHP3HJ6xrIo0ub8NQ4VljewdK2v1XIFTRlr8GGc
         16A7dPn9lJO5rcFCxwlOl4nZd24A20KhNNXJVfHy41fvJuUvhQlrPnPLQxNPVkPCo0lf
         3FZOb1NgQ0/jDvsyexhM7d101GyxN5O2zO6oa9+Ja0kxVueb57NU2BmHeYyuYyRIm0WK
         B1GrP5wRzYjmOT9jQ+raVdCuVZDbiX4BSJ/X93TF0ti0nTMFiLmzW07ZuS77OMvOf8S+
         jGE6GA9q3UdX0o+KBTwoxB3f4crmZzL2Hcq42lTFE0c/wNwXiF8cs3suse/4/HrqsHY8
         qsTg==
X-Gm-Message-State: AOAM531GbAN0eQ17l0bSslx2FQXVSnLAjejlvkLVb8oozlUNTQTaMrWy
        1q27UtYHL/DoaIwbLddEI+dv52bAmk0Ow9NJ7JyEhnJL/QgFImF2HAwpmx8aRJm5k++FD24oST7
        RdjAjHvSDtFOObH2BKg1oPA==
X-Received: by 2002:a05:620a:f0f:: with SMTP id v15mr2538071qkl.86.1644449875754;
        Wed, 09 Feb 2022 15:37:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxYDc2+ZHw0L5UuBzjnj0j1f0peqC4cQnZS284ucSAK30wz0HsSnroM3XBRreNBSILn/FnZfQ==
X-Received: by 2002:a05:620a:f0f:: with SMTP id v15mr2538057qkl.86.1644449875567;
        Wed, 09 Feb 2022 15:37:55 -0800 (PST)
Received: from [192.168.0.14] (97-120-56-15.ptld.qwest.net. [97.120.56.15])
        by smtp.gmail.com with ESMTPSA id s11sm10114460qtk.82.2022.02.09.15.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 15:37:54 -0800 (PST)
Message-ID: <e1b73af8-914c-8289-756a-94c316e5a2f7@redhat.com>
Date:   Wed, 9 Feb 2022 15:37:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 22/44] iscsi: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Karen Xie <kxie@chelsio.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        GR-QLogic-Storage-Upstream@marvell.com
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-23-bvanassche@acm.org>
From:   Chris Leech <cleech@redhat.com>
In-Reply-To: <20220208172514.3481-23-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 9:24 AM, Bart Van Assche wrote:
> Instead of storing the iSCSI task pointer and the session age in the SCSI
> pointer, use command-private variables. This patch prepares for removal of
> the SCSI pointer from struct scsi_cmnd.

> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -603,7 +603,7 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
>  		goto error;
>  	}
>  
> -	if (!sc_cmd->SCp.ptr) {
> +	if (!iscsi_cmd(sc_cmd)->task) {
>  		QEDI_WARN(&qedi->dbg_ctx,
>  			  "SCp.ptr is NULL, returned in another context.\n");
>  		goto error;
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
> index 282ecb4e39bb..8196f89f404e 100644

Minor nit, but this warning should probably be changed as well.

- Chris Leech

