From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: pm8001: locking in mpi_sata_completion() is broken
Date: Thu, 15 Dec 2011 09:26:46 +0800
Message-ID: <05B890C6DE854627B79801C1B3B16BBE@usish.com.cn>
References: <20111214092947.GA1537@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:43057 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab1LOBoX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2011 20:44:23 -0500
In-Reply-To: <20111214092947.GA1537@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Carpenter' <dan.carpenter@oracle.com>
Cc: lindar_liu@usish.com, linux-scsi@vger.kernel.org

RE: pm8001: locking in mpi_sata_completion() is broken
> 
> The locking in mpi_sata_completion() is broken.  I'm not sure what was
> intended at all.  Here is what it does:
> 
>   1876  mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void
*piomb)
>   1877  {
>   1878          struct sas_task *t;
>   1879          struct pm8001_ccb_info *ccb;
>   1880          unsigned long flags = 0;
>                 ^^^^^^^^^^^^^^^^^^^^^^^
> This is bogus.  The flags should be set with irqsave.  This implies a
> knowledge of the internals which should be abstracted away.
> 
[Jack Wang] 
Hi Dan,

Thanks for point out this. Other comments answer below.
> 	[snip]
> 
>   2006          case IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS:
>   2007                  PM8001_IO_DBG(pm8001_ha,
>   2008
> pm8001_printk("IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS\n"));
>   2009                  ts->resp = SAS_TASK_COMPLETE;
>   2010                  ts->stat = SAS_DEV_NO_RESPONSE;
>   2011                  if (!t->uldd_task) {
>   2012                          pm8001_handle_event(pm8001_ha,
>   2013                                  pm8001_dev,
>   2014                                  IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
>   2015                          ts->resp = SAS_TASK_UNDELIVERED;
>   2016                          ts->stat = SAS_QUEUE_FULL;
>   2017                          pm8001_ccb_task_free(pm8001_ha, t, ccb,
> tag);
>   2018                          mb();/*in order to force CPU ordering*/
>   2019                          spin_unlock_irqrestore(&pm8001_ha->lock,
> flags);
> 
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Calling irqrestore before we've done an irqsave.  What are we trying to
> restore?
[Jack Wang] 
We hold spin_lock_irqsave when we process interrupt, so here we need restore
it to do task done clean.
> 
>   2020                          t->task_done(t);
>   2021                          spin_lock_irqsave(&pm8001_ha->lock,
> flags);
>   2022                          return;
>   2023                  }
> 
> 	[snip]
> 
>   2197                  spin_unlock_irqrestore(&t->task_state_lock,
> flags);
>   2198                  pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>   2199                  mb();/*ditto*/
>   2200                  spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> We just called irqrestore so there is no need to restore it twice.
> 
>   2201                  t->task_done(t);
>   2202                  spin_lock_irqsave(&pm8001_ha->lock, flags);
>                                                             ^^^^^
> We're saving the irq status but we're at the end of the function so we
> never use it again.
> 
>   2203          }
>   2204  }
> 
> I've just picked out a couple examples, but basically the whole function
> is like that.
[Jack Wang] 
Others are basically the same, what we want is make the lock balance.

Thanks.
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

