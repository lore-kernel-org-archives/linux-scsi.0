Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFF2C6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Sep 2022 12:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiIMM2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Sep 2022 08:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiIMM1c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2022 08:27:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80204DF07
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 05:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663072038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bo8mqt6h/T4mR/FT6YQAZLPOcblBS4kGnup5WJ8vVKY=;
        b=dmRQLWNKjusfwENz/lfiN41wkVpM1jc+B7WKukAYarhhpKgL4Kyz7W+4zgxrIZvPTFDXEr
        z3yiBMoF0lgq7AsGhoLwodXZkeMy3DG8Q2NOKzZ2Cc2YRojauW8thvPfUO7HhHAZHv/spb
        OUJza/AJCDhNoKvZnl+3l6Bvo1lIoRE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-RbqyuytHMnufIm-ZiaJCmQ-1; Tue, 13 Sep 2022 08:27:13 -0400
X-MC-Unique: RbqyuytHMnufIm-ZiaJCmQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D31A3815D28;
        Tue, 13 Sep 2022 12:27:13 +0000 (UTC)
Received: from [10.22.8.246] (unknown [10.22.8.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 302CC49BB61;
        Tue, 13 Sep 2022 12:27:12 +0000 (UTC)
Message-ID: <0a7ee402-3fb2-e765-6395-2c91bb5f82a8@redhat.com>
Date:   Tue, 13 Sep 2022 08:27:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] qedf: Populate sysfs attributes for vport
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, guazhang@redhat.com,
        GR-QLogic-Storage-Upstream@marvell.com
References: <20220912114803.7644-1-njavali@marvell.com>
From:   John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20220912114803.7644-1-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch addresses a day one bug found by a Red Hat QA Test.

This patch has been applied to RHEL test build
and proven to resolve the bug.

Tested-by: Guangwu Zhang <guazhang@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>

On 9/12/22 07:48, Nilesh Javali wrote:
> From: Saurav Kashyap <skashyap@marvell.com>
> 
> Copy speed, supported_speed, frame_size and update port_type for NPIV port.
> 
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qedf/qedf_main.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index 3d6b137314f3..cc6d9decf62c 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -1921,6 +1921,27 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
>   		fc_vport_setlink(vn_port);
>   	}
>   
> +	/* Set symbolic node name */
> +	if (base_qedf->pdev->device == QL45xxx)
> +		snprintf(fc_host_symbolic_name(vn_port->host), 256,
> +			 "Marvell FastLinQ 45xxx FCoE v%s", QEDF_VERSION);
> +
> +	if (base_qedf->pdev->device == QL41xxx)
> +		snprintf(fc_host_symbolic_name(vn_port->host), 256,
> +			 "Marvell FastLinQ 41xxx FCoE v%s", QEDF_VERSION);
> +
> +	/* Set supported speed */
> +	fc_host_supported_speeds(vn_port->host) = n_port->link_supported_speeds;
> +
> +	/* Set speed */
> +	vn_port->link_speed = n_port->link_speed;
> +
> +	/* Set port type */
> +	fc_host_port_type(vn_port->host) = FC_PORTTYPE_NPIV;
> +
> +	/* Set maxframe size */
> +	fc_host_maxframe_size(vn_port->host) = n_port->mfs;
> +
>   	QEDF_INFO(&(base_qedf->dbg_ctx), QEDF_LOG_NPIV, "vn_port=%p.\n",
>   		   vn_port);
>   

