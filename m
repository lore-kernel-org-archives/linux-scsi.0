Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0477C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 16:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74BA161263
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 16:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhJARBc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:01:32 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:40768 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhJARBc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2021 13:01:32 -0400
Received: by mail-pj1-f52.google.com with SMTP id d4-20020a17090ad98400b0019ece228690so9744884pjv.5;
        Fri, 01 Oct 2021 09:59:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+3oLNMm/Hv0NXPCfbk836CuI5x4bjnJJBJAzNWzu28M=;
        b=bqpPm+A5bv7cQWFKTEF5ivFk5M7QpaiPAw/6vOR5OaeuTYblRAsFIvC38SPkSfE6gH
         dG7mLFcJJYUk3W19Ewcb4Gu9dUtVEQJUMZbUc4p0DQeBkDkGp9FCTCc9pudTxeVIVkCx
         V6kwUncceBZhM80cVttq+RWxLNr8gToLAo03WXuWT0RY1IeQCYyhxHZ5j3Ti+Eo7gUaC
         GCoNp8RH2ORGsVIKOwWo2gct8QhwQTAXPiZHM/FqhhWXYzH0YagUXyD4g5G5q00v55g6
         cJonO95gM8/WCYKwAp9vtcnqvWsiK4IFwmlcd/zP2At7GuHPs8mZHOz6QTD1o6HpaJl0
         EGgw==
X-Gm-Message-State: AOAM532QRk2ZXfJWdHHONshciE+Ub8oKqrKGqQpI0gJEEyB6IAR5oGR6
        sQVMcOYDZznoiTgQn+LpvB0=
X-Google-Smtp-Source: ABdhPJwqEybzzb6OqjE3AGzUorgCKHtawMTjGpECZqCU7baHP9Iou3BHUdBCCIjXnq9G1qaVTa+FFA==
X-Received: by 2002:a17:902:b08f:b0:13e:67df:9fa9 with SMTP id p15-20020a170902b08f00b0013e67df9fa9mr10464205plr.85.1633107587476;
        Fri, 01 Oct 2021 09:59:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:82b7:f0a2:c63d:c44e])
        by smtp.gmail.com with ESMTPSA id 3sm6159348pjk.18.2021.10.01.09.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 09:59:46 -0700 (PDT)
Subject: Re: [PATCH 2/2] scsi: ufs: Stop clearing unit attentions
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Bart Van Assche <bvanassche@google.com>
References: <20210930195237.1521436-1-jaegeuk@kernel.org>
 <20210930195237.1521436-2-jaegeuk@kernel.org>
 <12ba3462-ac6b-ef35-4b5e-e0de6086ab51@intel.com>
 <f2436720-16d5-58da-abcc-20fa1ed01fb9@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5e087a0f-7ae0-41d1-c1f1-e5cc0ad2d38f@acm.org>
Date:   Fri, 1 Oct 2021 09:59:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f2436720-16d5-58da-abcc-20fa1ed01fb9@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/21 11:52 PM, Adrian Hunter wrote:
> Finally, there is another thing to change.  The reason
> ufshcd_suspend_prepare() does a runtime resume of sdev_rpmb is because the
> UAC clear would wait for an async runtime resume, which will never happen
> during system suspend because the PM workqueue gets frozen.  So with the
> removal of UAC clear, ufshcd_suspend_prepare() and ufshcd_resume_complete()
> should be updated also, to leave rpmb alone.

Is the following change what you have in mind?


diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0a28cc4c09d8..0743f54e55f9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9648,10 +9648,6 @@ void ufshcd_resume_complete(struct device *dev)
  		ufshcd_rpm_put(hba);
  		hba->complete_put = false;
  	}
-	if (hba->rpmb_complete_put) {
-		ufshcd_rpmb_rpm_put(hba);
-		hba->rpmb_complete_put = false;
-	}
  }
  EXPORT_SYMBOL_GPL(ufshcd_resume_complete);

@@ -9674,10 +9670,6 @@ int ufshcd_suspend_prepare(struct device *dev)
  		}
  		hba->complete_put = true;
  	}
-	if (hba->sdev_rpmb) {
-		ufshcd_rpmb_rpm_get_sync(hba);
-		hba->rpmb_complete_put = true;
-	}
  	return 0;
  }
  EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 86b615023ecb..5ecfcd8cae0a 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -921,7 +921,6 @@ struct ufs_hba {
  #endif
  	u32 luns_avail;
  	bool complete_put;
-	bool rpmb_complete_put;
  };

  /* Returns true if clocks can be gated. Otherwise false */



Thanks,

Bart.
