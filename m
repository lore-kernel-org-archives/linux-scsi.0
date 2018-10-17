From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] advansys: use correct srb_tag in adv_isr_callback
Date: Tue, 16 Oct 2018 21:34:00 -0400
Message-ID: <yq1murdpd9z.fsf@oracle.com>
References: <20180926114107.13532-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926114107.13532-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Wed, 26 Sep 2018 19:41:07 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: matthew@wil.cx, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi Yue Haibing,

>  	srb_tag = le32_to_cpu(scsiqp->srb_tag);
> -	scp = scsi_host_find_tag(boardp->shost, scsiqp->srb_tag);
> +	scp = scsi_host_find_tag(boardp->shost, srb_tag);

Maybe I'm missing something, but I don't see where in the code
scsiqp->srb_tag is being converted to le32. srb_tag is beyond the memory
accessed by the controller and thus wouldn't need to be little endian.

-- 
Martin K. Petersen	Oracle Linux Engineering
