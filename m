From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/4] target: Drop lun_sep_lock for se_lun->lun_se_dev
	RCU usage
Date: Fri, 22 May 2015 13:56:01 +0200
Message-ID: <20150522115601.GB29155@lst.de>
References: <1432278417-29994-1-git-send-email-nab@daterainc.com> <1432278417-29994-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432278417-29994-3-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

> @@ -683,7 +679,7 @@ void core_tpg_remove_lun(
>  		dev->export_count--;
>  		spin_unlock(&dev->se_port_lock);
>  
> -		lun->lun_se_dev = NULL;
> +		rcu_assign_pointer(lun->lun_se_dev, NULL);
>  	}

What guarantees that the se_device stays around for at least a RCU
grace period after this assignment?
