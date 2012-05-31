From: mroos@linux.ee
Subject: Re: [PATCH v2 0/4] fix / cleanup async scsi scanning
Date: Thu, 31 May 2012 12:05:15 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1205311203530.29083@math.ut.ee>
References: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

> Commit a7a20d10 "[SCSI] sd: limit the scope of the async probe domain"
> introduces a boot regression by moving sd probe work off of the global
> async queue.  Using a local async domain hides the probe work from being
> synchronized by wait_for_device_probe()->async_synchronize_full().
> 
> Fix this by teaching async_synchronize_full() to flush all async work
> regardless of domain, and take the opportunity to convert scsi scanning
> to async_schedule().  This enables wait_for_device_probe() to flush scsi
> scanning work.
> 
> Changes since v1: http://marc.info/?l=linux-scsi&m=133793153025832&w=2
> 
> 1/ Tested to fix the boot hang that Meelis reported with v1.  Reworked
>    async_synchronize_full() to walk through all the active domains,
>    otherwise we spin on !list_empty(async_domains) and prevent the async
>    context from running.
> 
> 2/ Added the ability for domains to opt-out of global syncing as
>    requested by Arjan, but also needed for domains that don't want to worry
>    about list corruption when the domain goes out of scope (stack-allocated
>    domains).

Tested successfully on my Netra X1 where the original problem happened, 
on top of 3.4.0-08215-g1e2aec8. Thank you!

-- 
Meelis Roos (mroos@linux.ee)
