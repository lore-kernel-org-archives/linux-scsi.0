From: "Julian Calaby" <julian.calaby@gmail.com>
Subject: Re: [PATCH] SMP request handlers need to update resid
Date: Thu, 20 Dec 2007 14:13:15 +1100
Message-ID: <646765f40712191913m6b98b024jdfeb58191a01f63d@mail.gmail.com>
References: <20071220114436Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:64363 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbXLTDNQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Dec 2007 22:13:16 -0500
Received: by py-out-1112.google.com with SMTP id u77so5528756pyb.16
        for <linux-scsi@vger.kernel.org>; Wed, 19 Dec 2007 19:13:16 -0800 (PST)
In-Reply-To: <20071220114436Z.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@hansenpartnership.com, dougg@torque.net, Eric.Moore@lsi.com, linux-scsi@vger.kernel.org, tomof@acm.org

On Dec 20, 2007 1:44 PM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -1343,6 +1343,8 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>                 smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
>                 memcpy(req->sense, smprep, sizeof(*smprep));
>                 req->sense_len = sizeof(*smprep);
> +               req->data_len = 0;
> +               rsp->data_len -= smprep->ResponseDataLength;

Would

+               rsp->data_len = -smprep->ResponseDataLength;

not work?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
