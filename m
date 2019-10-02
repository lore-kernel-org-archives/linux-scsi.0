Return-Path: <SRS0=821a=X3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED128C35280
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 15:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA03121848
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 15:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbfJBPRr convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Oct 2019 11:17:47 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45160 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfJBPRr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Oct 2019 11:17:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id y72so10490521pfb.12
        for <linux-scsi@vger.kernel.org>; Wed, 02 Oct 2019 08:17:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tG3V0c8Sy3a7sYfOzBB9MYrawGbTzSy5flU5Ok3MZSQ=;
        b=b8kd2SSD0SfMOsXlPC+wAlGmZwVbC0oJWe1cBkyrnK4zWilXZxQWr5M1D4e/fKme+i
         UUQxi9tbplCje1+sPuWgeacc3EM8YWTCA3xE3cerqPbP6dKHww3po4ZxWzBtR4NlkXBa
         PGcMDKl3bRDMfTcTAzGLQIHfTkrzvJIi7IodfDWXbcmL51XlUIva3UaDZsE01ysuJ+cV
         HUSXQaxSK6isUBMO3FxeFKgHxIcQvFLoJyzvBM+tlsfvCRHfAzIW+Kepr28dSTLPhZJO
         fo6Gaikf3LQCV5IR04wREX9nx4bbdCIBt5aeumjcdzsVHheQmtEXNqDLOkhHmcbQmZjE
         KqjQ==
X-Gm-Message-State: APjAAAXZX2q3nvZHfaiEw/el1ucwYF/wgkYQ3D9KJMH7LB0KQX3W/8rc
        CF+5moBi2ff+9dFvpnnmir0=
X-Google-Smtp-Source: APXvYqw9sTn097fPWn/BvHE/pe/pbfapnip6MygCp0raj+xsSHzs6XvKoB6e6sY5h7MCyYkMXZXvFQ==
X-Received: by 2002:a63:214e:: with SMTP id s14mr4172555pgm.205.1570029466043;
        Wed, 02 Oct 2019 08:17:46 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:fb9c:664d:d2ad:c9b5? ([2620:15c:2c1:200:fb9c:664d:d2ad:c9b5])
        by smtp.gmail.com with ESMTPSA id q76sm20065615pfc.86.2019.10.02.08.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 08:17:45 -0700 (PDT)
Subject: Re: [PATCH] fixup "qla2xxx: Optimize NPIV tear down process"
To:     Martin Wilck <Martin.Wilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Daniel Wagner <dwagner@suse.de>
References: <20191002143426.20123-1-martin.wilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e89e0963-e6ca-d67d-0402-1a22ed5c5d3e@acm.org>
Date:   Wed, 2 Oct 2019 08:17:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191002143426.20123-1-martin.wilck@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/19 7:35 AM, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hello Martin,
> 
> this patch fixes two issues in patch 02/14 in Himanshu's latest
> qla2xxx series ("qla2xxx: Bug fixes for the driver") from
> Sept. 12th, which you applied onto 5.4/scsi-fixes already.
> See https://marc.info/?l=linux-scsi&m=156951704106671&w=2
> 
> I'm assuming that Himanshu and Quinn are working on another
> series of fixes, in which case that should take precedence
> over this patch. I just wanted to provide this so that the
> already known problems are fixed in your tree.
> 
> Commit message follows:
> 
> Fix two issues with the previously submitted patch
> "qla2xxx: Optimize NPIV tear down process": a missing negation
> in a wait_event_timeout() condition, and a missing loop end
> condition.
> ---
>  drivers/scsi/qla2xxx/qla_mid.c | 2 +-
>  drivers/scsi/qla2xxx/qla_os.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
> index 6afad68e5ba2..b4e042c1bd2a 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -78,7 +78,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
>  	 */
>  	for (i = 0; i < 10 && atomic_read(&vha->vref_count); i++)
>  		wait_event_timeout(vha->vref_waitq,
> -		    atomic_read(&vha->vref_count), HZ);
> +		    !atomic_read(&vha->vref_count), HZ);
>  
>  	spin_lock_irqsave(&ha->vport_slock, flags);
>  	if (atomic_read(&vha->vref_count)) {
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 6e627e521562..ee8167517621 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1119,7 +1119,7 @@ qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
>  
>  	qla2x00_mark_all_devices_lost(vha, 0);
>  
> -	for (i = 0; i < 10; i++)
> +	for (i = 0; !test_fcport_count(vha) && i < 10; i++)
>  		wait_event_timeout(vha->fcport_waitQ, test_fcport_count(vha),
>  		    HZ);

Hi Martin,

Both loops check the loop termination condition twice. Has it been
considered to write these loops such that the loop termination condition
is only tested once, e.g. using the following pattern?

for (i = 0; i < 10; i++)
	if (wait_event_timeout(...) > 0)
		break;

Thanks,

Bart.

