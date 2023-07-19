Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE77C001DE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 18:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjGSSJI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 14:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjGSSJH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 14:09:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04E51FC8
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 11:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689790098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Y/GUFxEIaTqE74eL24zjniGM/m0YHfzJ+3Frv5JlMY=;
        b=WjuNxjndvDyb50Zlx3yPyB89R6geTB1PykDMg7K9DNKEeEORWP7rJxDe3H7sEWJKK6KoT0
        /B0+AzvqBBL3bq1DM27rDtAamdRXmjYRDLcdO7CmkzfM11n0Q8ZXPABMlKud4sak8CxE8L
        DFUSkQLHsFBoxRmcjPVnQOwZZ+Pnc+M=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-HYUpaIqROryscYW4dmy5og-1; Wed, 19 Jul 2023 14:08:14 -0400
X-MC-Unique: HYUpaIqROryscYW4dmy5og-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29CB43C108DD;
        Wed, 19 Jul 2023 18:08:14 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (unknown [10.2.16.238])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 960E61121314;
        Wed, 19 Jul 2023 18:08:13 +0000 (UTC)
Date:   Wed, 19 Jul 2023 11:08:11 -0700
From:   Chris Leech <cleech@redhat.com>
To:     hanyu001@208suo.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH] scsi: be2iscsi: wacom: convert sysfs
 sprintf/snprintf family to sysfs_emit
Message-ID: <ZLgmi1I8MVlZnfcm@rhel-developer-toolbox-latest>
References: <tencent_A27502E2D5B495E4E319441AB4B3B5F7E708@qq.com>
 <a70b030b0e0bdf224d35dec9aecc7371@208suo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a70b030b0e0bdf224d35dec9aecc7371@208suo.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 14, 2023 at 04:10:43PM +0800, hanyu001@208suo.com wrote:
> Fix the following coccicheck warning:
> 
> ./drivers/hid/wacom_sys.c:1828:8-16: WARNING: use scnprintf or sprintf.
> 
> ./drivers/scsi/be2iscsi/be_mgmt.c:1251:9-17: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/be2iscsi/be_mgmt.c:1145:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/be2iscsi/be_mgmt.c:1164:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/be2iscsi/be_mgmt.c:1280:8-16: WARNING: use scnprintf or
> sprintf
> 
> Signed-off-by: ztt <1549089851@qq.com>

These should all be converted to sysfs_emit instead of scnprintf.
Thanks,

- Chris Leech

> ---
>  drivers/scsi/be2iscsi/be_mgmt.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c
> b/drivers/scsi/be2iscsi/be_mgmt.c
> index 4e899ec1477d..4916ce9c36a6 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -1142,7 +1142,7 @@ ssize_t
>  beiscsi_drvr_ver_disp(struct device *dev, struct device_attribute *attr,
>                 char *buf)
>  {
> -    return snprintf(buf, PAGE_SIZE, BE_NAME "\n");
> +    return scnprintf(buf, PAGE_SIZE, BE_NAME "\n");
>  }
> 
>  /**
> @@ -1161,7 +1161,7 @@ beiscsi_fw_ver_disp(struct device *dev, struct
> device_attribute *attr,
>      struct Scsi_Host *shost = class_to_shost(dev);
>      struct beiscsi_hba *phba = iscsi_host_priv(shost);
> 
> -    return snprintf(buf, PAGE_SIZE, "%s\n", phba->fw_ver_str);
> +    return scnprintf(buf, PAGE_SIZE, "%s\n", phba->fw_ver_str);
>  }
> 
>  /**
> @@ -1248,7 +1248,7 @@ beiscsi_adap_family_disp(struct device *dev, struct
> device_attribute *attr,
>      case BE_DEVICE_ID1:
>      case OC_DEVICE_ID1:
>      case OC_DEVICE_ID2:
> -        return snprintf(buf, PAGE_SIZE,
> +        return scnprintf(buf, PAGE_SIZE,
>                  "Obsolete/Unsupported BE2 Adapter Family\n");
>      case BE_DEVICE_ID2:
>      case OC_DEVICE_ID3:
> @@ -1277,7 +1277,7 @@ beiscsi_phys_port_disp(struct device *dev, struct
> device_attribute *attr,
>      struct Scsi_Host *shost = class_to_shost(dev);
>      struct beiscsi_hba *phba = iscsi_host_priv(shost);
> 
> -    return snprintf(buf, PAGE_SIZE, "Port Identifier : %u\n",
> +    return scnprintf(buf, PAGE_SIZE, "Port Identifier : %u\n",
>              phba->fw_config.phys_port);
>  }

