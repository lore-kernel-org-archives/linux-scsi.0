Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E9DC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 16:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B76861056
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 16:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbhJMQ6W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:58:22 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:46616 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235869AbhJMQ6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 12:58:21 -0400
Received: by mail-pj1-f52.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so2726656pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 09:56:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XALsxR42xVdst0jbGS32EPi1W0DkCYOWzxie5FkIsBQ=;
        b=53tyxho1rN5p6sHZln1E4mASc+fgOlbLzIqeLL06ancX30NjUnZqfqeqIhCBeiqgPy
         Hn80M50vK9/7HbPUEjJmrIOserTL/w7exVfP9SCOwRrS8aheuWdogR6QhCFVTWMfG0hv
         326goUtGLbDZLxE15XZicEIRoFVpvX4kBTOkF0T1X7EXGPn64VjcwvC7FJvpAl6AQEt4
         nuLbYXJMNnC6//t9Ug8TXNI2/2Vrzl+ZvUqNdbi3lKI2DXqS2b3drW5kUkmY1VQtBl5i
         GA5BUZDJBNWbBBYua38BckUl6/kssLh6OAFG7VX6WMQpGABXbxdijLw6rqQV/IdUK7Wu
         uECw==
X-Gm-Message-State: AOAM533hnIEIdoGz9HtjenHaIzHrKnyNgL2LpsZNyXTRe7yhCSkr3gvZ
        +Lgh3QnGu4jzEhER2293/sg=
X-Google-Smtp-Source: ABdhPJxZzwld84dqU5HonPcA7Sqe5fBSjC3iW2kLl0zy3srj9BcLjr8ioUm/J6OJ5ONtAq6yvtskUw==
X-Received: by 2002:a17:902:bb81:b0:12d:a7ec:3d85 with SMTP id m1-20020a170902bb8100b0012da7ec3d85mr326288pls.17.1634144177622;
        Wed, 13 Oct 2021 09:56:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae3:1dc1:f2a3:9c06])
        by smtp.gmail.com with ESMTPSA id a67sm78790pfa.128.2021.10.13.09.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 09:56:17 -0700 (PDT)
Subject: Re: [PATCH 5/5] scsi: ufs: Add a sysfs attribute for triggering the
 UFS EH
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211012215433.3725777-1-bvanassche@acm.org>
 <20211012215433.3725777-6-bvanassche@acm.org>
 <cd4b5103-e0fd-feed-2663-b505bcf019d8@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <598bbbc4-ab07-0354-045a-14ba5220f814@acm.org>
Date:   Wed, 13 Oct 2021 09:56:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <cd4b5103-e0fd-feed-2663-b505bcf019d8@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/21 1:09 AM, Adrian Hunter wrote:
> On 13/10/2021 00:54, Bart Van Assche wrote:
>> Make it possible to test the impact of the UFS error handler on software
>> that submits SCSI commands to the UFS driver.
> 
> Are you sure this isn't better suited to debugfs?

I will convert this attribute into a debugfs attribute.

>> +	if (ufshcd_eh_in_progress(hba))
>> +		return -EBUSY;
> 
> Does it matter if ufshcd_eh_in_progress()?

The UFS error handler modifies hba->ufshcd_state and assumes that no 
other code modifies hba->ufshcd_state while the error handler is in 
progress. Hence this check.

>> +	} else {
>> +		return -EINVAL;
>> +	}
>> +
>> +	scsi_schedule_eh(hba->host);
> 
> Probably should be:
> 
> 	queue_work(hba->eh_wq, &hba->eh_work);

No. This patch is intended for Martin Petersen's 5.16/scsi-queue branch. 
The patch "Revert "scsi: ufs: Synchronize SCSI and UFS error handling"" 
has been queued on the 5.15/scsi-fixes branch only.

> However, it might be simpler to replace everything with:
> 
> 	spin_lock(hba->host->host_lock);
> 	hba->saved_err |= <something>;
> 	hba->saved_uic_err |= <something else>;
> 	ufshcd_schedule_eh_work(hba);
> 	spin_unlock(hba->host->host_lock);
> 
> Perhaps letting the user specify values to determine <something>
> and <something else>

I will look into this.

Thanks,

Bart.
