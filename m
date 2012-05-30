From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 0/4] fix / cleanup async scsi scanning
Date: Wed, 30 May 2012 20:22:39 +0200
Message-ID: <20120530182239.GD15635@x1.osrc.amd.com>
References: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mroos@linux.ee, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

On Wed, May 30, 2012 at 11:21:25AM -0700, Dan Williams wrote:
> Commit a7a20d10 "[SCSI] sd: limit the scope of the async probe domain"
> introduces a boot regression by moving sd probe work off of the global
> async queue.  Using a local async domain hides the probe work from being
> synchronized by wait_for_device_probe()->async_synchronize_full().
> 
> Fix this by teaching async_synchronize_full() to flush all async work
> regardless of domain, and take the opportunity to convert scsi scanning
> to async_schedule().  This enables wait_for_device_probe() to flush scsi
> scanning work.

Looks like those fix a similar boot issue I reported earlier:

http://marc.info/?l=linux-kernel&m=133839683405526&w=2

Should I give them a run or are they still in review?

Thanks.

-- 
Regards/Gruss,
Boris.
