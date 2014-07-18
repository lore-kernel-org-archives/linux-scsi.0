From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Date: Fri, 18 Jul 2014 15:39:25 +0000
Message-ID: <1405697964.605.27.camel@jarvis.lan>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
 <1401901323.17510.23.camel@dabdike>
 <d61f4b87a72544e4b0c1e1872a76f97b@BY2PR03MB299.namprd03.prod.outlook.com>
 <53911A35.7010805@cs.wisc.edu>
 <d9854e6ff97f4b0087dbe835a2a57c8f@BY2PR03MB299.namprd03.prod.outlook.com>
 <5391F801.4010107@cs.wisc.edu>
 <1402077167.2207.89.camel@dabdike.int.hansenpartnership.com>
 <539206FA.1020001@kernel.dk>
 <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
 <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <94D0CD8314A33A4D9D801C0FE68B402958BAC6DC@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958BAC6DC@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Content-ID: <2F1C3D1BA5238844975A36DC2D078972@sw.swsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "Elliott@hp.com" <Elliott@hp.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-07-18 at 00:51 +0000, Elliott, Robert (Server Storage)
wrote:
> In sd_sync_cache:
> 	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
> 
> Regardless of the baseline for the multiplication, a magic 
> number of 2 is too arbitrary.  That might work for an
> individual drive, but could be far too short for a RAID
> controller that runs into worst case error handling for
> the drives to which it is flushing (e.g., if its cache
> is volatile and the drives all have recoverable errors
> during writes).  That time goes up with a bigger cache and 
> with more fragmented write data in the cache requiring
> more individual WRITE commands.

RAID devices with gigabytes of cache are usually battery backed and lie
about their cache type (they usually claim write through).  This
behaviour is exactly what we want because the flush is used to enforce
write barriers for filesystem consistency, so we only want to flush
volatile caches.

The rare case you cite, where the RAID device is volatile and having
difficulty flushing, we do want a failure because otherwise the
filesystem will become unusable and the system will live lock ...
barriers are sent down frequently under normal filesystem operation.

The SCSI standards committees have been struggling with defining and
detecting the difference between volatile and non-volatile cache and the
heuristics we'd have to use to avoid annoying USB devices with detecting
this don't look pretty.  We always zero the SYNC_NV bit anyway, so even
if the devices stopped lying, we'd be safe.

> A better value would be the Recommended Command Timeout field 
> value reported in the REPORT SUPPORTED OPERATION CODES command,
> if reported by the device server.  That is supposed to account
> for the worst case.
> 
> For cases where that is not reported, exposing the multiplier
> in sysfs would let the timeout for simple devices be set to
> smaller values than complex devices.
> 
> Also, in both sd_setup_flush_cmnd and sd_sync_cache:
>       cmd->cmnd[0] = SYNCHRONIZE_CACHE;
>       cmd->cmd_len = 10;
> 
> SYNCHRONIZE CACHE (16) should be favored over SYNCHRONIZE 
> CACHE (10) unless SYNCHRONIZE CACHE (10) is not supported.

For what reason.  We usually go for the safe alternatives, which is 10
byte commands because they have the widest testing and greatest level of
support.  We don't do range flushes currently, so there doesn't seem to
be a practical different.  If we did support range flushes, we'd likely
only use SC(16) on >2TB devices.

James
