Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8F3C761AF
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Apr 2023 05:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjDBFBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 01:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDBFBC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 01:01:02 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616D31116E
        for <linux-scsi@vger.kernel.org>; Sat,  1 Apr 2023 22:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680411661; x=1711947661;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l38k6pCrlI2Q4n4ocRQD97hyM5tMTTwSo3YmZmAPE1Y=;
  b=BVBXEBCiABWwd7ZrtKTZDO85dI4l7Ts3+6fOv2qhei+PZOqrRYWwXRgy
   hr8rqs+lw/5zh7LXSEA6nIPgBzUirZtoKlBz7a0dpzoxtnSMe18ZMA4Pu
   LlBLFR7QWbSC1PHROQi+qygOEc1MafNJl9yfmrG+O9l7JCzEgKMTgdZhB
   s1mQOiDq5gOp57tvKVH1TA07/ylDSm/3K8CSemPGtF+A/fIUznXu7xEqf
   rLIxtoEyf0IBtlE2ZvRg3b+jFh0iGzPl2o0tG3ae1yAdHz8V5Z5/5NM7L
   VAJtVfxMrkIV13YLFyQiO8RB0eT6uMiAZ+VZHXtI102xA7jI/hobyZH0I
   w==;
X-IronPort-AV: E=Sophos;i="5.98,312,1673884800"; 
   d="scan'208";a="227063352"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2023 13:01:00 +0800
IronPort-SDR: 80i95oJAzanxA2vp/MifmgN4fS/1pCJ1XBhxj4Z3CHoWQawg1iMRpAuMpMVVQfm4EfvKz7DSob
 89rYtJfPo2mEIPZbvImDp4aTGHRr3CQgfu+nPzLhCLsreySlP0XORH5RISOTgxdBz2yOd40kmN
 xT2ENFXMEbp9Q4qxVgqdv8OA3hWMBvyTgtDtp/Z8j1pGsYZue0mkFuK6HqGd+LW1Cnxsk5t3ac
 8+vk2kNbrmgfkBq51w/oNVx+j0C0f87m0LhWUDRP7rJsHto13AaA7JNt7y9s2pZHO8z3AWNQZR
 pRo=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Apr 2023 21:17:05 -0700
IronPort-SDR: tlRFtWrZZijfW1qZAViy11mSwS7dIRtFZmzg4OtKxDm7S3Hb1Ze5C6O1jeusUNjPyNIVFCO1eT
 ZTwGf3GCc6LksFVMq08RkUD05qb7o1yl21HHMwFw7P8vwFpNtapOm5ippufXSmzpUGQQB/VEDo
 FOPvKqqBLuLV88CG7VUMfdpffZ8jRqcW5DKwAUdUwwQPfu4SyT3+j/nCr0dMV/sGAbwS3R0OzS
 CPkOVoS4ScPoTDZEhcQGfVakfK+hMUx1TrsXmfpDW73Qxq3XUnMhMTM1egqcRNpcTGwnzz87/m
 Wp0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Apr 2023 22:01:01 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pq20r1kwzz1RtW0
        for <linux-scsi@vger.kernel.org>; Sat,  1 Apr 2023 22:01:00 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680411659; x=1683003660; bh=l38k6pCrlI2Q4n4ocRQD97hyM5tMTTwSo3Y
        mZmAPE1Y=; b=lrEgVZXkq2kAQqvqV1UB7EErd69HWnKQt9wDZt2hbiUspqQNmte
        YGX1ENxnvOG70A2l4g6GS5qo9bOK9jAzVRrXqMw8/aSpyskl81ngyZbIa5Zg1aZU
        lo/IkP6SUy+mFDFy4w8X+/JelJxKI7HpsOSMofqXRojZOFeAnsLWYkTGVwocN5bB
        lo4IBcEgdjUqgZC2BXBJ55pSN2qzaexzCflXbR6es1zk7+LYPGrxrBF/JsLl9N+9
        5d/ffz5BWrYQDkmvj+Dp33RR4BEscf+e6oHX4FXrj7dYg4bR6CuXzvLgphSi/skf
        oa4Bg/MfcmVGsKhcnblyT/+df+D+Yj+1/aw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GEEfYorehMas for <linux-scsi@vger.kernel.org>;
        Sat,  1 Apr 2023 22:00:59 -0700 (PDT)
Received: from [10.225.163.1] (unknown [10.225.163.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pq20n51LFz1RtVm;
        Sat,  1 Apr 2023 22:00:57 -0700 (PDT)
Message-ID: <48d385f7-92b5-4e99-7e32-119db6a74f3f@opensource.wdc.com>
Date:   Sun, 2 Apr 2023 14:00:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 3/3] scsi: libsas: Simplify sas_check_parent_topology()
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        john.g.garry@oracle.com
References: <20230401081526.1655279-1-yanaijie@huawei.com>
 <20230401081526.1655279-4-yanaijie@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230401081526.1655279-4-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/23 17:15, Jason Yan wrote:
> Factor out a new helper sas_check_phy_topology() to simplify
> sas_check_parent_topology(). And centralize the calling of
> sas_print_parent_topology_bug().
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  drivers/scsi/libsas/sas_expander.c | 95 +++++++++++++++++-------------
>  1 file changed, 55 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index c0841652f0e0..bffcccdbda6b 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1238,11 +1238,59 @@ static int sas_check_eeds(struct domain_device *child,
>  	return res;
>  }
>  
> -/* Here we spill over 80 columns.  It is intentional.
> - */
> -static int sas_check_parent_topology(struct domain_device *child)
> +
> +static int sas_check_phy_topology(struct domain_device *child, struct ex_phy *parent_phy)

Long line. Break after the first argument.

>  {
>  	struct expander_device *child_ex = &child->ex_dev;
> +	struct ex_phy *child_phy = &child_ex->ex_phy[parent_phy->attached_phy_id];
> +	struct expander_device *parent_ex = &child->parent->ex_dev;
> +	bool print_topology_bug = false;
> +	int res = 0;
> +
> +	switch (child->parent->dev_type) {
> +	case SAS_EDGE_EXPANDER_DEVICE:
> +		if (child->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
> +			if (parent_phy->routing_attr != SUBTRACTIVE_ROUTING ||
> +				child_phy->routing_attr != TABLE_ROUTING) {
> +				res = -ENODEV;
> +				print_topology_bug = true;
> +			}
> +		} else if (parent_phy->routing_attr == SUBTRACTIVE_ROUTING) {
> +			if (child_phy->routing_attr == SUBTRACTIVE_ROUTING) {
> +				res = sas_check_eeds(child, parent_phy, child_phy);
> +			}

The "else if" below should not be on a different line.

> +			else if (child_phy->routing_attr != TABLE_ROUTING) {
> +				res = -ENODEV;
> +				print_topology_bug = true;
> +			}
> +		} else if (parent_phy->routing_attr == TABLE_ROUTING) {
> +			if (child_phy->routing_attr != SUBTRACTIVE_ROUTING &&
> +			    (child_phy->routing_attr != TABLE_ROUTING ||
> +			    !child_ex->t2t_supp || !parent_ex->t2t_supp)) {
> +				res = -ENODEV;
> +				print_topology_bug = true;
> +			}
> +		}
> +		break;
> +	case SAS_FANOUT_EXPANDER_DEVICE:
> +		if (parent_phy->routing_attr != TABLE_ROUTING ||
> +		    child_phy->routing_attr != SUBTRACTIVE_ROUTING) {
> +			res = -ENODEV;
> +			print_topology_bug = true;
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	if (print_topology_bug)
> +		sas_print_parent_topology_bug(child, parent_phy, child_phy);
> +
> +	return res;
> +}
> +
> +static int sas_check_parent_topology(struct domain_device *child)
> +{
>  	struct expander_device *parent_ex;
>  	int i;
>  	int res = 0;
> @@ -1257,7 +1305,7 @@ static int sas_check_parent_topology(struct domain_device *child)
>  
>  	for (i = 0; i < parent_ex->num_phys; i++) {
>  		struct ex_phy *parent_phy = &parent_ex->ex_phy[i];
> -		struct ex_phy *child_phy;
> +		int ret;
>  
>  		if (parent_phy->phy_state == PHY_VACANT ||
>  		    parent_phy->phy_state == PHY_NOT_PRESENT)
> @@ -1266,42 +1314,9 @@ static int sas_check_parent_topology(struct domain_device *child)
>  		if (!sas_phy_match_dev_addr(child, parent_phy))
>  			continue;
>  
> -		child_phy = &child_ex->ex_phy[parent_phy->attached_phy_id];
> -
> -		switch (child->parent->dev_type) {
> -		case SAS_EDGE_EXPANDER_DEVICE:
> -			if (child->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
> -				if (parent_phy->routing_attr != SUBTRACTIVE_ROUTING ||
> -				    child_phy->routing_attr != TABLE_ROUTING) {
> -					sas_print_parent_topology_bug(child, parent_phy, child_phy);
> -					res = -ENODEV;
> -				}
> -			} else if (parent_phy->routing_attr == SUBTRACTIVE_ROUTING) {
> -				if (child_phy->routing_attr == SUBTRACTIVE_ROUTING) {
> -					res = sas_check_eeds(child, parent_phy, child_phy);
> -				} else if (child_phy->routing_attr != TABLE_ROUTING) {
> -					sas_print_parent_topology_bug(child, parent_phy, child_phy);
> -					res = -ENODEV;
> -				}
> -			} else if (parent_phy->routing_attr == TABLE_ROUTING) {
> -				if (child_phy->routing_attr != SUBTRACTIVE_ROUTING &&
> -				    (child_phy->routing_attr != TABLE_ROUTING ||
> -				     !child_ex->t2t_supp || !parent_ex->t2t_supp)) {
> -					sas_print_parent_topology_bug(child, parent_phy, child_phy);
> -					res = -ENODEV;
> -				}
> -			}
> -			break;
> -		case SAS_FANOUT_EXPANDER_DEVICE:
> -			if (parent_phy->routing_attr != TABLE_ROUTING ||
> -			    child_phy->routing_attr != SUBTRACTIVE_ROUTING) {
> -				sas_print_parent_topology_bug(child, parent_phy, child_phy);
> -				res = -ENODEV;
> -			}
> -			break;
> -		default:
> -			break;
> -		}
> +		ret = sas_check_phy_topology(child, parent_phy);
> +		if (ret)
> +			res = ret;
>  	}
>  
>  	return res;

-- 
Damien Le Moal
Western Digital Research

