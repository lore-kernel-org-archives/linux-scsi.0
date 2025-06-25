Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3D21519B9;
	Wed, 25 Jun 2025 03:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750822642; cv=none; b=eQLycF4vGspDM2nzUMNZgZBn3rYSpFBkk1s137QMRk6gvb0RV8HyONRBUTodT3YWeLD7CB5M4ArdLhS47N1VbXZ8lcuOA6n88ZUQi5s0G3Ev/wqfdptW1KXuRVQOVCpVoqL8V09f7SOCpStT/2wD8eeMA0nh5v3sO1UcHgkpNjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750822642; c=relaxed/simple;
	bh=rqc4hJ278qKiJIpCcI2aKMEri66YeMKurXnPgxpRwag=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=T3EpYiXCjr9pyKHja66NG6Bt1oL5cee1N0oETFAimr2v6Ri69p1zdCQvJuywH9+jiP+5OlSwzCxMmp2blVWF6hWiHKkb5ddAmqgixxIhgCWv/gr+bjaO8Re/w7Dqldj/Pe5WflToXugkb7ez1po54QBo1nB7Pw+2+6SzF3yfLXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4bRnb71qsPz2QVKJ;
	Wed, 25 Jun 2025 11:38:11 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 244731800B2;
	Wed, 25 Jun 2025 11:37:16 +0800 (CST)
Received: from [10.174.185.198] (10.174.185.198) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 25 Jun 2025 11:37:15 +0800
Message-ID: <0088ad17-37cd-4425-bfca-d03595c91cd2@huawei.com>
Date: Wed, 25 Jun 2025 11:37:09 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: <lidiangang@bytedance.com>
CC: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <hare@suse.de>, <linux-kernel@vger.kernel.org>,
	<lixiaokeng@huawei.com>, <hewenliang4@huawei.com>, <yangkunlin7@huawei.com>,
	<changfengnan@bytedance.com>
Reply-To: <20250424092732.GA48639@bytedance.com>
From: JiangJianJun <jiangjianjun3@huawei.com>
Subject: Re: [RFC PATCH v3 04/19] scsi: scsi_error: Add helper
 scsi_eh_sdev_stu to do START_UNIT
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk500001.china.huawei.com (7.202.194.86)

 > From: Wenchao Hao <haowenchao2@huawei.com>
 >
 > Add helper function scsi_eh_sdev_stu() to perform START_UNIT and check
 > if to finish some error commands.
 >
 > > This is preparation for a genernal LUN/target based error handle
 > > strategy and did not change original logic.
 > >
 > > Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
 > > ---
 > >  drivers/scsi/scsi_error.c | 50 +++++++++++++++++++++++----------------
 > >  1 file changed, 29 insertions(+), 21 deletions(-)
 > >
 > > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
 > > index cc3a5adb9daa..3b55642fb585 100644
 > > --- a/drivers/scsi/scsi_error.c
 > > +++ b/drivers/scsi/scsi_error.c
 > > @@ -1567,6 +1567,31 @@ static int scsi_eh_try_stu(struct scsi_cmnd 
*scmd)
 > >  	return 1;
 > >  }
 > >
 > > +static int scsi_eh_sdev_stu(struct scsi_cmnd *scmd,
 > > +			      struct list_head *work_q,
 > > +			      struct list_head *done_q)
 > > +{
 > > +	struct scsi_device *sdev = scmd->device;
 > > +	struct scsi_cmnd *next;
 > > +
 > > +	SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, sdev,
 > > +				"%s: Sending START_UNIT\n", current->comm));
 > > +
 >
 > As in the scsi_eh_stu, SCSI_SENSE_VALID and scsi_check_sense is required
 > before calling scsi_eh_try_stu.

But the SCSI_SENSE_VALID and scsi_check_sense has been called before 
calling scsi_eh_try_stu, see in loop devices in scsi_eh_stu, do you 
means re-call at here?

