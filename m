From: Willem Riede <osst@riede.org>
Subject: Re: [patch 1/1] scsi/osst: replace schedule_timeout() with msleep()
Date: Sun, 06 Mar 2005 22:42:55 +0000
Message-ID: <1110148975l.5880l.4l@serve.riede.org>
References: <20050306222742.294F71EC90@trashy.coderock.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:8181 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S261524AbVCFWm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:42:57 -0500
In-Reply-To: <20050306222742.294F71EC90@trashy.coderock.org> (from
	domen@coderock.org on Sun Mar  6 17:27:41 2005)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, nacc@us.ibm.com

On 03/06/2005 05:27:41 PM, domen@coderock.org wrote:
> 
> 
> Use msleep() instead of schedule_timeout() to guarantee the task
> delays as expected. Although TASK_INTERRUPTIBLE is used in the current code,
> there is no code dealing with an early return / signals_pending().

This change is a total don't-care as far as I'm concerned. But if we are going to 
make it, can we please be consistent? Does the "set_current_state(TASK_INTERRUPTIBLE)"
stay or go? The two changes below don't agree in that respect.

---
>  			attempts--;
> -			set_current_state(TASK_INTERRUPTIBLE);
> -			schedule_timeout(HZ / 10);
> +			msleep(100);
>  		}
---
>  #endif
>  		set_current_state(TASK_INTERRUPTIBLE);
> -		schedule_timeout(HZ / 10);
> +		msleep(100);
>  	}
---

Regards, Willem Riede,
osst maintainer.

