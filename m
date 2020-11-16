Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40919C55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC9392227F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgKPHjp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 02:39:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:47458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727618AbgKPHjp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 02:39:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2C6CACEB;
        Mon, 16 Nov 2020 07:39:42 +0000 (UTC)
Subject: Re: [PATCH v4 03/19] nvme: Added a newsysfs attribute appid_store
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604895845-2587-4-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <06359c8f-75d2-efe6-ed46-4001a4a0f84f@suse.de>
Date:   Mon, 16 Nov 2020 08:39:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604895845-2587-4-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/20 5:23 AM, Muneendra wrote:
> Added a new sysfs attribute appid_store under
> /sys/class/fc/fc_udev_device/*
> 
> With this new interface the user can set the application identfier
> in  the blkcg associted with cgroup id.
> 
> Once the application identifer has set with this interface it allows
> identification of traffic sources at an individual cgroup based
> Applications (ex:virtual machine (VM))level in both host and
> fabric infrastructure(FC).
> 
> Below is the interface provided to set the app_id
> 
> echo "<cgroupid>:<appid>" >> /sys/class/fc/fc_udev_device/appid_store
> echo "457E:100000109b521d27" >> /sys/class/fc/fc_udev_device/appid_store
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v4:
> No change
> 
> v3:
> Replaced blkcg_set_app_identifier function with blkcg_set_fc_appid
> 
> v2:
> New Patch
> ---
>   drivers/nvme/host/fc.c | 73 +++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 72 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index eae43bb444e0..6d6cc06fd54a 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -9,7 +9,7 @@
>   #include <uapi/scsi/fc/fc_els.h>
>   #include <linux/delay.h>
>   #include <linux/overflow.h>
> -
> +#include <linux/blk-cgroup.h>
>   #include "nvme.h"
>   #include "fabrics.h"
>   #include <linux/nvme-fc-driver.h>
> @@ -3768,10 +3768,81 @@ static ssize_t nvme_fc_nvme_discovery_store(struct device *dev,
>   
>   	return count;
>   }
> +
> +/*parse the Cgroup id from a buf and returns the length of cgrpid*/
> +static int fc_parse_cgrpid(const char *buf, u64 *id)
> +{
> +	char cgrp_id[16+1];
> +	int cgrpid_len, j;
> +
> +	memset(cgrp_id, 0x0, sizeof(cgrp_id));
> +	for (cgrpid_len = 0, j = 0; cgrpid_len < 17; cgrpid_len++) {
> +		if (buf[cgrpid_len] != ':')
> +			cgrp_id[cgrpid_len] = buf[cgrpid_len];
> +		else {
> +			j = 1;
> +			break;
> +		}
> +	}
> +	if (!j)
> +		return -EINVAL;
> +	if (kstrtou64(cgrp_id, 16, id) < 0)
> +		return -EINVAL;
> +	return cgrpid_len;
> +}
> +
> +/*
> + * fc_update_appid :parses and updates the appid in the blkcg associated with
> + * cgroupid.
> + * @buf: buf contains both cgrpid and appid info
> + * @count: size of the buffer
> + */
> +static int fc_update_appid(const char *buf, size_t count)
> +{
> +	u64 cgrp_id;
> +	int appid_len = 0;
> +	int cgrpid_len = 0;
> +	char app_id[APPID_LEN];
> +	int ret = 0;
> +
> +	if (buf[count-1] == '\n')
> +		count--;
> +
> +	if ((count > (16+1+APPID_LEN)) || (!strchr(buf, ':')))
> +		return -EINVAL;
> +
> +	cgrpid_len = fc_parse_cgrpid(buf, &cgrp_id);
> +	if (cgrpid_len < 0)
> +		return -EINVAL;
> +	/*appid len is count - cgrpid_len -1 (: + \n) */
> +	appid_len = count - cgrpid_len - 1;
> +	if (appid_len > APPID_LEN)
> +		return -EINVAL;
> +
> +	memset(app_id, 0x0, sizeof(app_id));
> +	memcpy(app_id, &buf[cgrpid_len+1], appid_len);
> +	ret = blkcg_set_app_identifier(app_id, cgrp_id, sizeof(app_id));
> +	if (ret < 0)
> +		return ret;
> +	return count;
> +}
> +
Right. So you _do_ allow for an arbitrary length for the app_id.
Which means the previous patch had a bug, and you need to allocate 
APPID_LEN + 1 for the 'app_id' entry.

> +static ssize_t fc_appid_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	int ret  = 0;
> +
> +	ret = fc_update_appid(buf, count);
> +	if (ret < 0)
> +		return -EINVAL;
> +	return count;
> +}
>   static DEVICE_ATTR(nvme_discovery, 0200, NULL, nvme_fc_nvme_discovery_store);
> +static DEVICE_ATTR(appid_store, 0200, NULL, fc_appid_store);
>   
>   static struct attribute *nvme_fc_attrs[] = {
>   	&dev_attr_nvme_discovery.attr,
> +	&dev_attr_appid_store.attr,
>   	NULL
>   };
>   
> 

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
